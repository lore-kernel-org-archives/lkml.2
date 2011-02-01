Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016Ab1BAVL3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 16:11:29 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:45086 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752215Ab1BAVL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 16:11:28 -0500
Subject: Re: [patch 08/28] posix-timers: Cleanup restart_block usage
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20110201134418.232288779@linutronix.de>
References: <20110201134320.688829863@linutronix.de>
	 <20110201134418.232288779@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Feb 2011 13:11:14 -0800
Message-ID: <1296594674.3336.51.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-01 at 13:51 +0000, Thomas Gleixner wrote:
> plain text document attachment
> (posix-timers-cleanup-restart-block.patch)
> posix timers still use the legacy arg0-arg3 members of
> restart_block. Use restart_block.nanosleep instead
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Richard Cochran <richard.cochran@omicron.at>
[snip]
>  long posix_cpu_nsleep_restart(struct restart_block *restart_block)
>  {
> -	clockid_t which_clock = restart_block->arg0;
> -	struct timespec __user *rmtp;
> +	clockid_t which_clock = restart_block->nanosleep.index;
>  	struct timespec t;
>  	struct itimerspec it;
>  	int error;
> 
> -	rmtp = (struct timespec __user *) restart_block->arg1;
> -	t.tv_sec = restart_block->arg2;
> -	t.tv_nsec = restart_block->arg3;
> +	t = ns_to_timespec(restart_block->nanosleep.expires);
> 
> -	restart_block->fn = do_no_restart_syscall;
>  	error = do_cpu_nanosleep(which_clock, TIMER_ABSTIME, &t, &it);
> 
>  	if (error == -ERESTART_RESTARTBLOCK) {
> +		struct timespec __user *rmtp = restart_block->nanosleep.rmtp;
>  		/*
> -	 	 * Report back to the user the time still remaining.
> -	 	 */
> -		if (rmtp != NULL && copy_to_user(rmtp, &it.it_value, sizeof *rmtp))
> +		 * Report back to the user the time still remaining.
> +		 */
> +		if (rmtp && copy_to_user(rmtp, &it.it_value, sizeof *rmtp))
>  			return -EFAULT;
> 
> -		restart_block->fn = posix_cpu_nsleep_restart;
> -		restart_block->arg0 = which_clock;
> -		restart_block->arg1 = (unsigned long) rmtp;
> -		restart_block->arg2 = t.tv_sec;
> -		restart_block->arg3 = t.tv_nsec;
> +		restart_block->nanosleep.expires = timespec_to_ns(&t);

The conversion back and forth from nanoseconds to timespec seems a
little extraneous, but short of reworking all of the do_nanosleep calls
to take a ktime I don't see a clean solution (since hrtimer also uses
the restart_block).

Acked-by: John Stultz <johnstul@us.ibm.com>

thanks
-john

