Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab0EFGYh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 02:24:37 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:42736 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab0EFGYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 02:24:35 -0400
From: Darren Hart <dvhltc@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Darren Hart <dvhltc@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "Peter W. Morreale" <pmorreale@novell.com>,
       Rik van Riel <riel@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Chris Mason <chris.mason@oracle.com>,
       John Cooper <john.cooper@third-harmonic.com>,
       Chris Wright <chrisw@sous-sol.org>, Ulrich Drepper <drepper@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Avi Kivity <avi@redhat.com>
Subject: [PATCH V6 0/4][RFC] futex: FUTEX_LOCK with optional adaptive spinning
Date: Wed,  5 May 2010 23:24:16 -0700
Message-Id: <1273127060-30375-1-git-send-email-dvhltc@us.ibm.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


RFC - NOT FOR INCLUSION

The following patch series implements a new experimental kernel side futex mutex
via new FUTEX_LOCK and FUTEX_LOCK_ADAPTIVE futex op codes. The adaptive spin
allows for multiple spinners until the lock is released or the owner is
descheduled. The patch currently allows the user to specify if they want
spinning or not, but the final version will only provide the adaptive variant as
blocking locks are already very efficiently implemented with the existing
operations.

This version greatly outperforms the last, and actually outperforms adaptive
pthread mutexes for long lock hold times.  The primary difference from the
previous implementation was userspace optimization, although many kernel-side
improvements were made as well.

I'm using the futex_lock branch of my futextest test suite to gather results.
The testcases (futex_lock.c, futex_wait_2.c, pthread_mutex_2.c, and
futex_wait_tid.c) are under performance/ and can be checked out here:

git://git.kernel.org/pub/scm/linux/kernel/git/dvhart/futextest.git

At Avi's suggestion, I prepared plots of multiple thread counts, they are
available at the URL below. These plots are all from runs with a period of
1,000 or 10,000 instructions, with one plot per each of several duty-cycles.
For V6 I have added two new comparison tests, "thread_wait_tid" which uses
FUTEX_WAIT/WAKE to implement a mutex just as "futex_wait" does, but it uses
the TID|FUTEX_WAITERS futex value policy to illustrate the overhead over a
simple 0,1,2 policy. Second, "pthread_mutex_pi" uses a PTHREAD_PRIO_INHERIT
mutex which also uses the TID|FUTEX_WAITERS policy and has a higher overhead
set of futex op codes (FUTEX_LOCK_PI and FUTEX_UNLOCK_PI).

http://www.kernel.org/pub/linux/kernel/people/dvhart/adaptive_futex/v6/v6c-p1000-logs/plots/
http://www.kernel.org/pub/linux/kernel/people/dvhart/adaptive_futex/v6/v6c-p10000-logs/plots/

As illustrated in the above plots:
o FUTEX_LOCK_ADAPTIVE performs significantly better than FUTEX_LOCK for the
  shorter period over all duty-cycles and comparable for the longer period on
  all but the 32% duty-cycle, where it again out-performed the non-adaptive
  version.
o PI pthread mutex underperformed every other implementaion by one or two orders
  of magnitude. This is surely due to the significant overhead of the PI futex
  operations.
o The futex_wait_tid test illustrates the additional overhead imposed by the
  TID|FUTEX_WAITERS policy which requires the use of | and & operators as well
  as more conditionals and even cmpxchg loops. This overhead becomes very
  apparent in higher thread counts. The new FUTEX_LOCK operations outperform
  the futex_wait_tid in most scenarios.
o The only consistent win for FUTEX_LOCK_ADAPTIVE is at the 32% duty cycle,
  where it outperforms every other implementation.
o The adaptive futex_wait test served as a reference to verify my general
  approach was not grossly inferior to the hand-written asm employed by
  pthreads. Notice that futex_wait*-adaptive is mostly on par with
  pthread_mutex*-adaptive.

Given the necessity of the TID|FUTEX_WAITERS policy with a kernel-side adaptive
spin implementation, I feel this implementation is pretty well optimized.

Next steps:

o Improve workload definition. The current workload is a cpu-hog. It runs a
  fixed set of instructions in a loop, with some percentage of those being
  contained within the lock/unlock block. Adding sleeps to reduce CPU overhead
  just added so much scheduling overhead that the numbers dropped absurdly for
  both normal and adaptive. I'd appreciate any assistance in preparing a
  test-case for a real-world usage scenario. I will work with some of IBM's
  product teams to do so, and would welcome any input from others with an
  interest in kernel assisted userspace spinlocks.

o Attempt the kernel assisted userspace spinning version proposed by Avi, Alan,
  and Ulrich for comparison. This involves providing information about the
  running state of each thread to userspace. Where exactly this memory should
  be allocated is still unclear. For a proof of concept I will like create a
  simple array indexed by bid and a vdso style API to access this information.

Finally, the V6 diffstat:
 include/linux/futex.h |    6 +
 include/linux/sched.h |    1 +
 kernel/futex.c        |  572 ++++++++++++++++++++++++++++++++++++-------------
 kernel/sched.c        |   66 ++++++
 4 files changed, 494 insertions(+), 151 deletions(-)

Thanks,

Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
