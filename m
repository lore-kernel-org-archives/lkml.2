Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab0KZN4q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 08:56:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39033 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753879Ab0KZN4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 08:56:45 -0500
Date: Fri, 26 Nov 2010 14:49:28 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        "rjw@sisk.plpavel"@ucw.cz
Subject: Re: [PATCH 01/14] signal: fix SIGCONT notification code
Message-ID: <20101126134928.GA28177@redhat.com>
References: <1290768569-16224-1-git-send-email-tj@kernel.org> <1290768569-16224-2-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290768569-16224-2-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26, Tejun Heo wrote:
>
> get_signal_deliver() should test these flags and then notify
> accoringly; however, it incorrectly tested SIGNAL_STOP_CONTINUED
> instead of SIGNAL_CLD_CONTINUED,

OOPS! Yes, typo. Thanks.

This is even documented in prepare_signal(). And it always sets
SIGNAL_STOP_CONTINUED along with SIGNAL_CLD_*, we shouldn't check
this bit, of course.

> Fix it by testing SIGNAL_CLD_CONTINUED.  While at it, uncompress the
> ?: test into if/else clause for better readability.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Roland McGrath <roland@redhat.com>

Reviewed-by: Oleg Nesterov <oleg@redhat.com>

> ---
>  kernel/signal.c |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 4e3cff1..fe004b5 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -1853,8 +1853,13 @@ relock:
>  	 * the CLD_ si_code into SIGNAL_CLD_MASK bits.
>  	 */
>  	if (unlikely(signal->flags & SIGNAL_CLD_MASK)) {
> -		int why = (signal->flags & SIGNAL_STOP_CONTINUED)
> -				? CLD_CONTINUED : CLD_STOPPED;
> +		int why;
> +
> +		if (signal->flags & SIGNAL_CLD_CONTINUED)
> +			why = CLD_CONTINUED;
> +		else
> +			why = CLD_STOPPED;
> +
>  		signal->flags &= ~SIGNAL_CLD_MASK;
>  
>  		why = tracehook_notify_jctl(why, CLD_CONTINUED);
> -- 
> 1.7.1
> 

