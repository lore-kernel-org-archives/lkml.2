Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101Ab1BAV2Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 16:28:16 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:50424 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950Ab1BAV2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 16:28:15 -0500
Subject: Re: [patch 20/28] posix-timers: Make posix-cpu-timers functions
 static
From: John Stultz <john.stultz@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20110201134419.389755466@linutronix.de>
References: <20110201134320.688829863@linutronix.de>
	 <20110201134419.389755466@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Feb 2011 13:28:10 -0800
Message-ID: <1296595690.3336.66.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-01 at 13:52 +0000, Thomas Gleixner wrote:
> plain text document attachment
> (posix-timer-make-posix-cpu-timer-functions-static.patch)
> All functions are accessed via clock_posix_cpu now. So make them static.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Richard Cochran <richard.cochran@omicron.at>

This patch seems to have more then just making functions static in it.

> @@ -1481,68 +1483,67 @@ static int do_cpu_nanosleep(const clocki
>  	return error;
>  }
> 
> -int posix_cpu_nsleep(const clockid_t which_clock, int flags,
> -		     struct timespec *rqtp, struct timespec __user *rmtp)
> +static long posix_cpu_nsleep_restart(struct restart_block *restart_block)
>  {
> -	struct restart_block *restart_block =
> -		&current_thread_info()->restart_block;
> +	clockid_t which_clock = restart_block->nanosleep.index;
> +	struct timespec t;
>  	struct itimerspec it;
>  	int error;
> 
> -	/*
> -	 * Diagnose required errors first.
> -	 */
> -	if (CPUCLOCK_PERTHREAD(which_clock) &&
> -	    (CPUCLOCK_PID(which_clock) == 0 ||
> -	     CPUCLOCK_PID(which_clock) == current->pid))
> -		return -EINVAL;
> +	t = ns_to_timespec(restart_block->nanosleep.expires);
> 
> -	error = do_cpu_nanosleep(which_clock, flags, rqtp, &it);
> +	error = do_cpu_nanosleep(which_clock, TIMER_ABSTIME, &t, &it);
> 
>  	if (error == -ERESTART_RESTARTBLOCK) {
> -
> -		if (flags & TIMER_ABSTIME)
> -			return -ERESTARTNOHAND;
> +		struct timespec __user *rmtp = restart_block->nanosleep.rmtp;
>  		/*
>  		 * Report back to the user the time still remaining.
>  		 */
>  		if (rmtp && copy_to_user(rmtp, &it.it_value, sizeof *rmtp))
>  			return -EFAULT;
> 
> -		restart_block->fn = posix_cpu_nsleep_restart;
> -		restart_block->nanosleep.index = which_clock;
> -		restart_block->nanosleep.rmtp = rmtp;
> -		restart_block->nanosleep.expires = timespec_to_ns(rqtp);
> +		restart_block->nanosleep.expires = timespec_to_ns(&t);
>  	}
>  	return error;
> +
>  }
> 
> -long posix_cpu_nsleep_restart(struct restart_block *restart_block)
> +static int posix_cpu_nsleep(const clockid_t which_clock, int flags,
> +			    struct timespec *rqtp, struct timespec __user *rmtp)
>  {
> -	clockid_t which_clock = restart_block->nanosleep.index;
> -	struct timespec t;
> +	struct restart_block *restart_block =
> +		&current_thread_info()->restart_block;
>  	struct itimerspec it;
>  	int error;
> 
> -	t = ns_to_timespec(restart_block->nanosleep.expires);
> +	/*
> +	 * Diagnose required errors first.
> +	 */
> +	if (CPUCLOCK_PERTHREAD(which_clock) &&
> +	    (CPUCLOCK_PID(which_clock) == 0 ||
> +	     CPUCLOCK_PID(which_clock) == current->pid))
> +		return -EINVAL;
> 
> -	error = do_cpu_nanosleep(which_clock, TIMER_ABSTIME, &t, &it);
> +	error = do_cpu_nanosleep(which_clock, flags, rqtp, &it);
> 
>  	if (error == -ERESTART_RESTARTBLOCK) {
> -		struct timespec __user *rmtp = restart_block->nanosleep.rmtp;
> +
> +		if (flags & TIMER_ABSTIME)
> +			return -ERESTARTNOHAND;
>  		/*
>  		 * Report back to the user the time still remaining.
>  		 */
>  		if (rmtp && copy_to_user(rmtp, &it.it_value, sizeof *rmtp))
>  			return -EFAULT;
> 
> -		restart_block->nanosleep.expires = timespec_to_ns(&t);
> +		restart_block->fn = posix_cpu_nsleep_restart;
> +		restart_block->nanosleep.index = which_clock;
> +		restart_block->nanosleep.rmtp = rmtp;
> +		restart_block->nanosleep.expires = timespec_to_ns(rqtp);
>  	}
>  	return error;
> -
>  }

Maybe split that out?

thanks
-john


