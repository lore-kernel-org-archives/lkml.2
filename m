Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825Ab1BXLtd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 06:49:33 -0500
Received: from casper.infradead.org ([85.118.1.10]:46662 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153Ab1BXLtc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 06:49:32 -0500
Subject: Re: [PATCH 2/2] sched: allow users with rtprio rlimit to change
 from SCHED_IDLE policy
From: Peter Zijlstra <peterz@infradead.org>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        richard.purdie@linuxfoundation.org
In-Reply-To: <4D657BEE.4040608@linux.intel.com>
References: <1298408674-3130-1-git-send-email-dvhart@linux.intel.com>
	 <1298408674-3130-3-git-send-email-dvhart@linux.intel.com>
	 <1298458989.2217.361.camel@twins>  <20110223111354.GB7448@elte.hu>
	 <1298459826.2217.363.camel@twins>  <4D652D42.4040801@linux.intel.com>
	 <1298476805.2217.791.camel@twins>  <4D657BEE.4040608@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 24 Feb 2011 12:49:27 +0100
Message-ID: <1298548167.2428.41.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-23 at 13:28 -0800, Darren Hart wrote:
> From: Darren Hart <dvhart@linux.intel.com>
> Date: Thu, 17 Feb 2011 15:37:07 -0800
> Subject: [PATCH] sched: allow users with sufficient RLIMIT_NICE to change from SCHED_IDLE policy
> 
> The current scheduler implementation returns -EPERM when trying to change from
> SCHED_IDLE to SCHED_OTHER or SCHED_BATCH.


>  Since SCHED_IDLE is considered to be
> equivalent to a nice 20, 

Well, its not quite equivalent, its actually 5 times lighter still and
the preemption behaviour is slightly different as you've found ;-)

> changing to another policy should be allowed provided
> the RLIMIT_NICE is accounted for.
> 
> This patch allows the following test-case to pass with RLIMIT_NICE=40, but still
> fail with RLIMIT_NICE=10 when the calling process is run from a typical shell
> (nice 0, or 20 in rlimit terms).

> 
> Signed-off-by: Darren Hart <dvhart@linux.intel.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Richard Purdie <richard.purdie@linuxfoundation.org>
> ---
>  kernel/sched.c |   11 +++++++----
>  1 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 18d38e4..9bf6284 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -4822,12 +4822,15 @@ recheck:
>                             param->sched_priority > rlim_rtprio)
>                                 return -EPERM;
>                 }
> +
>                 /*
> +                * Treat SCHED_IDLE as nice 20. Only allow a switch to
> +                * SCHED_NORMAL if the RLIMIT_NICE would normally permit it.
>                  */
> +               if (p->policy == SCHED_IDLE && policy != SCHED_IDLE) {
> +                       if (!can_nice(p, TASK_NICE(p)))
> +                               return -EPERM;
> +               }
>  
>                 /* can't change other user's priorities */
>                 if (!check_same_owner(p)) 

Looks fine, thanks!
