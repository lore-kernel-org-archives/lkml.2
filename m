Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab0L1QqO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 11:46:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752378Ab0L1QqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 11:46:10 -0500
Date: Tue, 28 Dec 2010 17:38:29 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Dario Faggioli <raistlin@linux.it>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>, torbenh <torbenh@gmx.de>,
        john.stultz@linaro.org, roland@redhat.com, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH resend] Reading POSIX CPU timer from outside the
	process.
Message-ID: <20101228163829.GA26533@redhat.com>
References: <1293121303.3390.185.camel@Palantir> <1293533742.2899.1028.camel@Palantir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293533742.2899.1028.camel@Palantir>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch doesn't look right,

On 12/28, Dario Faggioli wrote:
>
> Trying to call clock_getcpuclockid (and then clock_gettime) on a thread
> from outside the process that spawned it results in this:
>   ### Testing tid 24207: CPU-time clock for PID 24207 is 1.132371729 seconds
>   ### Testing tid 24209: clock_getcpuclockid: Success
>
> OTOH, if full-fledged processes are involved, the behaviour is this:
>   ### Testing tid 24218: CPU-time clock for PID 24218 is 0.001059305 seconds
>   ### Testing tid 24220: CPU-time clock for PID 24220 is 1.044057391 seconds
>
> Test programs available here: http://gitorious.org/clockid
>
> All that because clock_getcpuclockid forbids accessing thread
> specific CPU-time clocks from outside the thread group,

First of all, linux has no clock_getcpuclockid() system call, so
the changelog looks confusing.

glibc implements clock_getcpuclockid() via clock_getres(), that
is why the change in check_clock() can help.

> Therefore, this commit makes clock_getcpuclockid behave as follows:
>  - if it's called on a tid which is also a PID (i.e., the thread is
>    a thread group leader), it returns the CLOCK_PROCESS_CPUTIME_ID of
>    the process;
>  - if it's called on a tid of a non-group leader, it returns the
>    CLOCK_THREAD_CPUTIME_ID of such specific thread.

And both changes look wrong to me.

> --- a/kernel/posix-cpu-timers.c
> +++ b/kernel/posix-cpu-timers.c
> @@ -39,10 +39,9 @@ static int check_clock(const clockid_t which_clock)
>
>  	rcu_read_lock();
>  	p = find_task_by_vpid(pid);
> -	if (!p || !(CPUCLOCK_PERTHREAD(which_clock) ?
> -		   same_thread_group(p, current) : has_group_leader_pid(p))) {
> +	if (!p || (CPUCLOCK_PERTHREAD(which_clock) &&
> +		   same_thread_group(p, current) && !has_group_leader_pid(p)))
>  		error = -EINVAL;
> -	}
>  	rcu_read_unlock();

How so? For example, with this change
clock_getres(MAKE_THREAD_CPUCLOCK(pid_of_sub_thread)) won't work, no?

> @@ -349,11 +348,9 @@ int posix_cpu_clock_get(const clockid_t which_clock, struct timespec *tp)
>  		rcu_read_lock();
>  		p = find_task_by_vpid(pid);
>  		if (p) {
> -			if (CPUCLOCK_PERTHREAD(which_clock)) {
> -				if (same_thread_group(p, current)) {
> -					error = cpu_clock_sample(which_clock,
> -								 p, &rtn);
> -				}
> +			if (CPUCLOCK_PERTHREAD(which_clock) ||
> +			    !thread_group_leader(p)) {
> +				error = cpu_clock_sample(which_clock, p, &rtn);

IOW, we ignore CPUCLOCK_PERTHREAD() if !thread_group_leader(),
this can't be right.

I think, if we want to remove this limitation, we need something
like the patch below. If it doesn't help, we should fix glibc.

Oleg.

--- x/kernel/posix-cpu-timers.c
+++ x/kernel/posix-cpu-timers.c
@@ -39,10 +39,8 @@ static int check_clock(const clockid_t w
 
 	rcu_read_lock();
 	p = find_task_by_vpid(pid);
-	if (!p || !(CPUCLOCK_PERTHREAD(which_clock) ?
-		   same_thread_group(p, current) : has_group_leader_pid(p))) {
+	if (!p || !(CPUCLOCK_PERTHREAD(which_clock) || has_group_leader_pid(p)))
 		error = -EINVAL;
-	}
 	rcu_read_unlock();
 
 	return error;
@@ -350,10 +348,7 @@ int posix_cpu_clock_get(const clockid_t 
 		p = find_task_by_vpid(pid);
 		if (p) {
 			if (CPUCLOCK_PERTHREAD(which_clock)) {
-				if (same_thread_group(p, current)) {
-					error = cpu_clock_sample(which_clock,
-								 p, &rtn);
-				}
+				error = cpu_clock_sample(which_clock, p, &rtn);
 			} else {
 				read_lock(&tasklist_lock);
 				if (thread_group_leader(p) && p->sighand) {

