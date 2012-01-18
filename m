Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360Ab2ARAvh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 19:51:37 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:50012 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948Ab2ARAvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 19:51:36 -0500
Date: Wed, 18 Jan 2012 01:51:32 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Gilad Ben Yossef <gilad@benyossef.com>
Subject: Status of Nohz cpusets (adaptive tickless kernel) for January 2012
Message-ID: <20120118005129.GA1024@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

I haven't yet fully addressed all the reviews I got when I posted the
nohz cpusets patchset last time (https://lkml.org/lkml/2011/8/15/245),
which is why I haven't yet posted the patches for a v2.

Meanwhile I'm still working on it and some progress has been made since
then so I've been thinking it could be nice to report the current status.

One of the steps that have been achieved so far is the detection of illegal uses
of RCU read side critical section while in RCU idle mode (extended quiescent
state). This was a necessary piece for the nohz cpuset because we extend the
RCU idle mode to userspace there. As it happened to become pretty error prone,
this debugging feature became mandatory (and indeed helped me to spot and
fix some bugs in my code).

In the meantime these changes have initiated a split between the nohz and idle
logics, reducing a bit the amount of changes in my tree.

So I have rebased my tree on top of latest rcu/core changes (those that have
been merged for 3.3-rc1) and continue to work on it.

Still several things to do before posting the patches of a v2
but things are moving forward. Also I have started a TODO list
there that I'll feed by the time:

https://tglx.de/~fweisbec/TODO-nohz-cpusets


Result of the work in progress as of today can be found at:

git://github.com/fweisbec/linux-dynticks.git
	nohz/cpuset-v2-pre-20120117


Changes in this tree since v1:

- Rebase against latest rcu/core branch for v3.3-rc1

- Adapt against latest rcu changes: introduce new APIs
  rcu_user_enter(), rcu_user_exit(), rcu_user_enter_irq()
  and rcu_user_exit_irq()

- Handle RCU idle mode with do_notify_resume() path

- Fix deadlock after double rq lock on schedule:
        schedule() -> rq_lock -> next is idle task ->
        tick_nohz_restart_sched_tick() -> wake up softirq ->
        rq lock

- Fix lockup while issuing flush times IPI on exit path:

        CPU 0                           CPU 1

        read_lock(tasklist_lock)
                                        write_lock_irq(tasklist_lock)
        smp_call_function(CPU 1)
        * deadlock *

- Many namespace renames (cpuset_* to tick_nohz_*) and code migration
from sched.c to tick-sched.c

- Seperate code that determine if we can stop the idle tick and don't
use it for adaptive tickless mode.

- Fix adaptive tickless mode set on idle incidentally. TIF_NOHZ was
then missing on the following task that ran tickless, issuing some
illegal uses of RCU.
