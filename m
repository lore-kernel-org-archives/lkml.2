Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab2CHC55 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 21:57:57 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38249 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab2CHC54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 21:57:56 -0500
Date: Thu, 8 Mar 2012 03:57:40 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Tommaso Cucinotta <cucinotta@sssup.it>, Avi Kivity <avi@redhat.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Geoff Levand <geoff@infradead.org>, Christoph Lameter <cl@linux.com>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: [ANNOUNCE] Nohz cpusets (adaptive tickless kernel) v2-pre-20120308
Message-ID: <20120308025738.GA7976@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

Reminder of what it's all about: https://lkml.org/lkml/2011/8/15/245

The whole patchset has moved forward enough that it's now time
to release a new iteration of it. I plan to post all the patches
soon to LKML but before that I would like to rebase against 3.3[-rc >= 6]
and clean up a few little things, especially revisit some changelogs.

So before that to happen, I still wanted to do a release in order
to keep everyone in touch with latest changes.

Latest changes can be found at:

git://github.com/fweisbec/linux-dynticks.git
	nohz/cpuset-v2-pre-20120308

There is still a lot to do, but I'm glad we made some progresses with
more idle/adaptive tickless code unification, namespace cleanups,
RCU fixes, and various bugfixes here and there, etc...

Changes since v1 (https://lkml.org/lkml/2011/8/15/245):

- Rebase against latest Paul McKenney's rcu/core branch for v3.3-rc1

- Adapt against latest rcu changes: introduce new APIs
  rcu_user_enter(), rcu_user_exit(), rcu_user_enter_irq()
  and rcu_user_exit_irq()

- Handle RCU idle mode with do_notify_resume() path

- Fix deadlock after double rq lock on schedule:
	schedule() -> rq_lock -> next is idle task ->
	tick_nohz_restart_sched_tick() -> wake up softirq ->
	rq lock

- Fix lockup while issuing flush times IPI on exit path:

	CPU 0				CPU 1

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
illegal uses of RCU

- Restart the tick anytime more than one task is on the runqueue. We were previously
only covering wake ups, now we also handle migration and any other source of task enqueuing

- Handle use of RCU in schedule() when called right before resuming userspace
(new schedule_user() API)

- Take the decision to stop the tick from irq exit instead of the middle of the timer
interrupt. This gives more opportunity to stop it and is one step more to unify idle
and adaptive tickless.

- Unify tickless idle and tickless user/system CPU time accounting infrastructures.

- If the tick is stopped adaptively and we are going to schedule the idle
task, don't restart the tick.

- Remove task_nohz_mode per cpu var and use ts->tick_stopped instead. This
leads to more unification between idle tickless and adaptive tickless.

Have fun!
