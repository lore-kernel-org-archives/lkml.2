Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758536Ab2BOOk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 09:40:29 -0500
Received: from www.linutronix.de ([62.245.132.108]:53498 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758480Ab2BOOk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 09:40:26 -0500
Date: Wed, 15 Feb 2012 15:40:24 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Matthew Garrett <mjg@redhat.com>
cc: LKML <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] hrtimers: Special-case zero length sleeps
In-Reply-To: <1317308372-6810-1-git-send-email-mjg@redhat.com>
Message-ID: <alpine.LFD.2.02.1202151537500.2794@ionos>
References: <1317308372-6810-1-git-send-email-mjg@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Sep 2011, Matthew Garrett wrote:

> sleep(0) is a common construct used by applications that want to trigger
> the scheduler. sched_yield() might make more sense, but only appeared in
> POSIX.1-2001 and so plenty of example code still uses the sleep(0) form.
> This wouldn't normally be a problem, but it means that event-driven
> applications that are merely trying to avoid starving other processes may
> actually end up sleeping due to having large timer_slack values. Special-
> casing this seems reasonable.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> ---
>  kernel/hrtimer.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> index a9205e3..0bb70a7 100644
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -1566,6 +1566,14 @@ long hrtimer_nanosleep(struct timespec *rqtp, struct timespec __user *rmtp,
>  	if (rt_task(current))
>  		slack = 0;
>  
> +	/*
> +	 * Applications will often sleep(0) to indicate that they wish to
> +	 * be scheduled. Special case that to avoid actually putting them
> +	 * to sleep for the duration of the slack.
> +	 */
> +	if (rqtp->tv_sec == 0 && rqtp->tv_nsec == 0)
> +		slack = 0;

That's pretty pointless. You can simply return 0 here as
do_nanosleep() will not call the scheduler on an already expired
timer, which is always true for a relative timer with delta 0.

Thanks,

	tglx
