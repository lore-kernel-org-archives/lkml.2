Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751081Ab0LUKhk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 05:37:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707Ab0LUKhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 05:37:39 -0500
Date: Tue, 21 Dec 2010 11:30:08 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Roland McGrath <roland@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH][RFC] Always unlock 'tasklist_lock' in
	kernel/exit.c::do_wait()
Message-ID: <20101221103008.GA30286@redhat.com>
References: <alpine.LNX.2.00.1012202324540.23785@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1012202324540.23785@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20, Jesper Juhl wrote:
>
> Hi,
>
> The Coverity checker spotted this. I think it has a point, but I'm not
> intimate with this code so there could be somethingI'm missing.
>
> It seems that kernel/exit.c::do_wait() does not always release
> 'tasklist_lock'. There are multiple ways the code could be changed to make
> sure it's always released, I just picked the most straight forward one.
>
> Does this look right to everyone else or is it just me?
> I've only compile tested the patch so far.
>
>
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  exit.c |    8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/exit.c b/kernel/exit.c
> index 676149a..456b13d 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -1647,12 +1647,16 @@ repeat:
>  	tsk = current;
>  	do {
>  		retval = do_wait_thread(wo, tsk);
> -		if (retval)
> +		if (retval) {
> +			read_unlock(&tasklist_lock);

No, this is not right.

If wait_consider_task() returns nonzero (pid or errcode), tasklist_lock
should be already released.

That is why, for example, wait_task_stopped() does BUG_ON(!retval) after
it drops tasklist.

Oleg.

