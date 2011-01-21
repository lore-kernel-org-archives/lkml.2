Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab1AUVc6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 16:32:58 -0500
Received: from www.tglx.de ([62.245.132.106]:34147 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354Ab1AUVc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 16:32:57 -0500
Date: Fri, 21 Jan 2011 22:32:48 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Vernon Mauery <vernux@us.ibm.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Wait to remove active timer when rescheduling hrtimer
In-Reply-To: <1295632350-10215-1-git-send-email-vernux@us.ibm.com>
Message-ID: <alpine.LFD.2.00.1101212232210.2971@localhost6.localdomain6>
References: <1295632350-10215-1-git-send-email-vernux@us.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 21 Jan 2011, Vernon Mauery wrote:

> In the current hrtimer implementation, when explicitly
> removing a timer, the hrtimer_cancel function waits
> until the timer is not currently running before actually
> calling remove_hrtimer.  But in the __hrtimer_start_range_ns
> function (called by hrtimer_start, among others), it
> calls remove_hrtimer without checking to see if the
> timer is currently running.  This doesn't seem to cause
> much trouble in the vanilla kernel, but in the -RT
> kernel, this causes a silent hang when exercising the
> sch_htb module on a 10GbE interface.
> 
> Signed-off-by: Vernon Mauery <vernux@us.ibm.com>
> ---
>  kernel/hrtimer.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> index 0c8d7c0..c7e8ba0 100644
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -935,6 +935,11 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
>  	base = lock_hrtimer_base(timer, &flags);
>  
>  	/* Remove an active timer from the queue: */
> +	while (hrtimer_callback_running(timer)) {
> +		unlock_hrtimer_base(timer, &flags);
> +		hrtimer_wait_for_timer(timer);
> +		base = lock_hrtimer_base(timer, &flags);
> +	}
>  	ret = remove_hrtimer(timer, base);
>  
>  	/* Switch the timer base, if necessary: */

Hmm, why does it hang ?

Thanks,

	tglx
