Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab1LXGXf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Dec 2011 01:23:35 -0500
Received: from info.dorms.msu.net ([93.180.4.5]:36038 "EHLO dorms.msu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788Ab1LXGXd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Dec 2011 01:23:33 -0500
From: =?utf-8?b?0JDRgNGC0LXQvCDQkNC90LjRgdC40LzQvtCy?= 
	<aanisimov@inbox.ru>
To: Mike Galbraith <efault@gmx.de>
Subject: Re: Commit 1e5a74059f9 broke utime measurement of ptraced() processes
Date: Sat, 24 Dec 2011 10:26:35 +0300
User-Agent: KMail/1.13.5 (Linux/3.2.0-rc6+; KDE/4.5.95; i686; ; )
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, mingo@elte.hu
References: <201112191519.40901.aanisimov@inbox.ru> <1324388358.8497.20.camel@marge.simson.net>
In-Reply-To: <1324388358.8497.20.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201112241026.35726.aanisimov@inbox.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 December 2011 16:39:18, Mike Galbraith wrote:

> Every preempt cuts waker's CPU usage, lessening the odds of it being
> preempted again soon, and effectively hands a few wakeup expense cycles
> to the wakee that preempted it in the bargain.

  This effectively turns utime into a random value. I've tried running a bit 
more tests and here are the results. You can cut-and-paste the attached files 
"with-patch", "without-patch" and "expected" and plot them with gnuplot:

> plot 'without-patch' using 1:2 with linespoints, 'with-patch' using 1:2 with 
linespoints, 'expected' using 1:2 with linespoints;

The X axis is N_ARITH_OPS, the Y axis is the ratio
  R = (time_traced-time_untraced)/time_untraced
in percents.

  With the optimisation in question reverted the overhead per a syscall does 
not depend on what a child process does between syscalls. Denote "c" the 
overhead incurred by all syscalls that the child makes, denote "a" the time 
necessary to run the inner loop with N_ARITH_OPS=1 and let N be the shorthand 
for N_ARITH_OPS. Then time_traced is a*N+c and time_untraced is a*N (the 
program startup/shutdown time is negligible). We have
            c
   R(N) = -----.
           a*N
In the file "expected" I've put values of R when a/c = 0.015. As you can see 
the plot of "expected" ratios approximates the real values in "with-patch" 
with a very good precision starting with N=5.

  The plot of ratios measured when the optimisation in question was turned on 
shows two interesting effects. First, magnitude of its oscillations does not 
seem to decrease. Second, beginning with N=5 the ratio is strictly *negative*, 
so the traced process appears to run faster than the untraced one. Such a 
"speed up" manifests itself especially strongly when I run time-when-traced 
inside a VM. There it is possible to get the traced process run several 
*times* faster than the untraced one.

  I believe that the described behaviour is erroneous and in order to
> lessen the odds of it [waker] being preempted again soon
one should not mess with utime but rather use another technique. It is also 
interesting why the *user time* needs to be affected? It is inside the kernel 
that the tracer process is woken up, so when
> handing a few wakeup expense cycles to the wakee
why not account those cycles as stime?

  Also I'd like to know if there is a way to get reliable utime measurements 
in recent kernels.

Thanks,
Artem.

----- with-patch -----
1 39.3
2 2.0
3 -4.3
4 2.9
5 0.0
6 5.9
7 3.6
8 1.0
9 2.9
10 2.7
11 1.8
12 0.6
13 0.8
14 1.5
15 2.3
----- with-patch -----

----- without-patch -----
1 49.6
2 32.3
3 22.0
4 18.1
5 -2.2
6 -2.5
7 -4.7
8 -10.2
9 -6.3
10 -6.3
11 -7.3
12 -5.9
13 -7.8
14 -3.9
15 -4.5
----- without-patch -----

----- expected -----
1 24.0
2 12.0
3 8.0
4 6.0
5 4.8
6 4.0
7 3.4
8 3.0
9 2.6
10 2.4
11 2.1
12 2.0
13 1.8
14 1.7
15 1.6
----- expected -----

> On Mon, 2011-12-19 at 16:59 +0100, Артем Анисимов wrote:
> > Hi!
> > 
> >   I have tried running a program that measures utime of another process
> >   in two
> > 
> > different setups: the first time when the child process executes with no
> > intervention and the second time when the child is ptrace()d and is
> > stopped at every syscall. It turns out that the overhead imposed by
> > ptrace() is approx. 5% in 2.6.32, but it is 17% in 3.2-rc6. Yet worse is
> > that in 2.6.32 the overhead per system call is roughly constant, but in
> > 3.2-rc6 it varies wildly depending on number of cycles that the child
> > spends in userspace: in some cases increasing "n_cycles_in_userspace /
> > n_syscalls" ratio leads to increase of the overhead.
> > 
> >   I have bisected this bug down to commit 1e5a74059f9 which changed
> >   behaviour
> > 
> > of sched.c::check_preempt_curr(). Before 1e5a74059f9 this function would
> > skip the clock update depending on test_tsk_need_resched(p), but now it
> > checks for test_tsk_need_resched(rq->curr). Reverting this change makes
> > utime measurement behave as in 2.6.32.
> 
> Reverting the change effectively disables the optimization.  What I see
> by creating a scheduler feature switch is that without the optimization,
> there's a ~60%/40% cpu split between time-when-traced/child when traced,
> whereas with the optimization, it shifts to ~55%/45% split.  What you
> see is that utilization shift, caused by the optimization transitioning
> from busted to working.
> 
> Every preempt cuts waker's CPU usage, lessening the odds of it being
> preempted again soon, and effectively hands a few wakeup expense cycles
> to the wakee that preempted it in the bargain.
> 
> No skip optimization
> 
> marge:~/tmp # time sh -c 'for i in $(seq 1 5); do ./time-when-traced;done'
> utime (untraced): 732545 musecs
> utime (traced): 717044 musecs
> diff: -21
> utime (untraced): 697043 musecs
> utime (traced): 702043 musecs
> diff: 7
> utime (untraced): 737545 musecs
> utime (traced): 772547 musecs
> diff: 47
> utime (untraced): 665041 musecs
> utime (traced): 742045 musecs
> diff: 115
> utime (untraced): 654040 musecs
> utime (traced): 695043 musecs
> diff: 62
> 
> real    2m47.552s
> user    1m42.682s
> sys     1m4.684s
> 
> perf report -d [kernel.kallsyms] --sort=symbol |grep clock
>      3.12%  native_sched_clock
>      2.52%  sched_clock_local
>      0.64%  sched_clock_cpu
>      0.57%  update_rq_clock
>      0.16%  jiffies_to_clock_t
>      0.01%  clockevents_program_event
>      0.01%  sched_clock_tick
> 
> With optimization
> 
> marge:~/tmp # time sh -c 'for i in $(seq 1 5); do ./time-when-traced;done'
> utime (untraced): 698043 musecs
> utime (traced): 800049 musecs
> diff: 146
> utime (untraced): 681042 musecs
> utime (traced): 787548 musecs
> diff: 156
> utime (untraced): 699543 musecs
> utime (traced): 865053 musecs
> diff: 236
> utime (untraced): 694543 musecs
> utime (traced): 832551 musecs
> diff: 198
> utime (untraced): 685042 musecs
> utime (traced): 816050 musecs
> diff: 191
> 
> real    2m45.110s
> user    1m43.282s
> sys     1m1.656s
> 
> perf report -d [kernel.kallsyms] --sort=symbol |grep clock
>      2.28%  native_sched_clock
>      1.80%  sched_clock_local
>      0.45%  update_rq_clock
>      0.37%  sched_clock_cpu
>      0.19%  jiffies_to_clock_t
>      0.00%  sched_clock_tick
>      0.00%  clockevents_program_even
