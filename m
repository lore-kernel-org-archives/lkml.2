Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152Ab1LTNj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 08:39:29 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:47653 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751514Ab1LTNjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 08:39:23 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/H7PBnh93HdKhW+oW0RWRfyXTEX5LdEaboWB8ybQ
	y6nqVLYGW5VHfi
Subject: Re: Commit 1e5a74059f9 broke utime measurement of ptraced()
 processes
From: Mike Galbraith <efault@gmx.de>
To: =?UTF-8?Q?=D0=90=D1=80=D1=82=D0=B5=D0=BC_?=
	 =?UTF-8?Q?=D0=90=D0=BD=D0=B8=D1=81=D0=B8=D0=BC=D0=BE=D0=B2?= 
	<aanisimov@inbox.ru>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, mingo@elte.hu
In-Reply-To: <201112191519.40901.aanisimov@inbox.ru>
References: <201112191519.40901.aanisimov@inbox.ru>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Dec 2011 14:39:18 +0100
Message-ID: <1324388358.8497.20.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-19 at 16:59 +0100, Артем Анисимов wrote: 
> Hi!
> 
>   I have tried running a program that measures utime of another process in two 
> different setups: the first time when the child process executes with no 
> intervention and the second time when the child is ptrace()d and is stopped at 
> every syscall. It turns out that the overhead imposed by ptrace() is approx. 
> 5% in 2.6.32, but it is 17% in 3.2-rc6. Yet worse is that in 2.6.32 the 
> overhead per system call is roughly constant, but in 3.2-rc6 it varies wildly 
> depending on number of cycles that the child spends in userspace: in some 
> cases increasing "n_cycles_in_userspace / n_syscalls" ratio leads to increase 
> of the overhead.
> 
>   I have bisected this bug down to commit 1e5a74059f9 which changed behaviour 
> of sched.c::check_preempt_curr(). Before 1e5a74059f9 this function would skip 
> the clock update depending on test_tsk_need_resched(p), but now it checks for
> test_tsk_need_resched(rq->curr). Reverting this change makes utime measurement 
> behave as in 2.6.32.

Reverting the change effectively disables the optimization.  What I see
by creating a scheduler feature switch is that without the optimization,
there's a ~60%/40% cpu split between time-when-traced/child when traced,
whereas with the optimization, it shifts to ~55%/45% split.  What you
see is that utilization shift, caused by the optimization transitioning
from busted to working.

Every preempt cuts waker's CPU usage, lessening the odds of it being
preempted again soon, and effectively hands a few wakeup expense cycles
to the wakee that preempted it in the bargain.

No skip optimization

marge:~/tmp # time sh -c 'for i in $(seq 1 5); do ./time-when-traced;done'
utime (untraced): 732545 musecs
utime (traced): 717044 musecs
diff: -21
utime (untraced): 697043 musecs
utime (traced): 702043 musecs
diff: 7
utime (untraced): 737545 musecs
utime (traced): 772547 musecs
diff: 47
utime (untraced): 665041 musecs
utime (traced): 742045 musecs
diff: 115
utime (untraced): 654040 musecs
utime (traced): 695043 musecs
diff: 62

real    2m47.552s
user    1m42.682s
sys     1m4.684s

perf report -d [kernel.kallsyms] --sort=symbol |grep clock
     3.12%  native_sched_clock
     2.52%  sched_clock_local
     0.64%  sched_clock_cpu
     0.57%  update_rq_clock
     0.16%  jiffies_to_clock_t
     0.01%  clockevents_program_event
     0.01%  sched_clock_tick

With optimization

marge:~/tmp # time sh -c 'for i in $(seq 1 5); do ./time-when-traced;done'
utime (untraced): 698043 musecs
utime (traced): 800049 musecs
diff: 146
utime (untraced): 681042 musecs
utime (traced): 787548 musecs
diff: 156
utime (untraced): 699543 musecs
utime (traced): 865053 musecs
diff: 236
utime (untraced): 694543 musecs
utime (traced): 832551 musecs
diff: 198
utime (untraced): 685042 musecs
utime (traced): 816050 musecs
diff: 191

real    2m45.110s
user    1m43.282s
sys     1m1.656s

perf report -d [kernel.kallsyms] --sort=symbol |grep clock
     2.28%  native_sched_clock
     1.80%  sched_clock_local
     0.45%  update_rq_clock
     0.37%  sched_clock_cpu
     0.19%  jiffies_to_clock_t
     0.00%  sched_clock_tick
     0.00%  clockevents_program_even


