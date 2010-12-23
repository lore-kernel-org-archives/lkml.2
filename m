Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377Ab0LWQwP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 11:52:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10206 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752830Ab0LWQwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 11:52:14 -0500
Date: Thu, 23 Dec 2010 17:44:53 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Dario Faggioli <raistlin@linux.it>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>, torbenh <torbenh@gmx.de>,
        john.stultz@linaro.org, roland@redhat.com, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [PATCH] Read THREAD_CPUTIME clock from other  processes.
Message-ID: <20101223164453.GA13111@redhat.com>
References: <1293121303.3390.185.camel@Palantir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293121303.3390.185.camel@Palantir>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23, Dario Faggioli wrote:
>
> Trying to read CLOCK_THREAD_CPUTIME_ID of a thread from outside
> the process that spawned it with this code:
>
>         if (clock_getcpuclockid(tid, &clockid) != 0) {
>                 perror("clock_getcpuclockid");
>                 exit(EXIT_FAILURE);
>         }
>
> results in this:
>   ### Testing tid 24207: CPU-time clock for PID 24207 is 1.132371729 seconds
>   ### Testing tid 24209: clock_getcpuclockid: Success
>
> OTH, if full-fledged processes are involved, the behaviour is this:
>   ### Testing tid 24218: CPU-time clock for PID 24218 is 0.001059305 seconds
>   ### Testing tid 24220: CPU-time clock for PID 24220 is 1.044057391 seconds
>
> Test programs available here: http://gitorious.org/clockid.
>
> This is because clock_getcpuclockid forbids accessing thread
> specific CPU-time clocks from outside the thread group. This is
> not requested (e.g., by POSIX) to be like this, or at least no
> indication that such operation should fail can be found in
> `man clock_getcpuclockid' and alike.
>
> However, having such capability could be useful, if you want
> to monitor the execution of a bunch of thread from some kind of
> "manager" which might not be part of the same process. A typical
> example that could benefit from this could be the JACK graph-manager.
>
> Therefore, this patch removes such limitation and enables the
> following behaviour, for the threaded and process-based case,
> respectively:

Can't comment, I never understood this.


A couple of nits on the patch itself,

> --- a/kernel/posix-cpu-timers.c
> +++ b/kernel/posix-cpu-timers.c
> @@ -39,10 +39,8 @@ static int check_clock(const clockid_t which_clock)
>
>  	rcu_read_lock();
>  	p = find_task_by_vpid(pid);
> -	if (!p || !(CPUCLOCK_PERTHREAD(which_clock) ?
> -		   same_thread_group(p, current) : has_group_leader_pid(p))) {
> +	if (!p)
>  		error = -EINVAL;
> -	}

This changes the behaviour of sys_clock_settime(). Probably doesn't
matter since it does nothing, but perhaps !CPUCLOCK_PERTHREAD &&
!group_leader should result in -EINAVL as before.

> @@ -349,18 +347,21 @@ int posix_cpu_clock_get(const clockid_t which_clock, struct timespec *tp)
>  		rcu_read_lock();
>  		p = find_task_by_vpid(pid);
>  		if (p) {
> -			if (CPUCLOCK_PERTHREAD(which_clock)) {
> -				if (same_thread_group(p, current)) {
> -					error = cpu_clock_sample(which_clock,
> -								 p, &rtn);
> -				}
> +
> +			if (CPUCLOCK_PERTHREAD(which_clock) &&
> +			    same_thread_group(p, current)) {
> +				error = cpu_clock_sample(which_clock,
> +							 p, &rtn);
>  			} else {
>  				read_lock(&tasklist_lock);
> -				if (thread_group_leader(p) && p->sighand) {
> +				if (!CPUCLOCK_PERTHREAD(which_clock) &&
> +				    thread_group_leader(p) && p->sighand)
>  					error =
>  					    cpu_clock_sample_group(which_clock,
> -							           p, &rtn);
> -				}
> +								   p, &rtn);
> +				else
> +					error = cpu_clock_sample(which_clock,
> +								 p, &rtn);
>  				read_unlock(&tasklist_lock);

Can't understand... why did you duplicate cpu_clock_sample() ?

IOW, it seems to me you could simply kill the
"if (same_thread_group(p, current)) {" line with the same efect, no?

Oleg.

