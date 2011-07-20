Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933Ab1GTSZd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 14:25:33 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:50822 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167Ab1GTSZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 14:25:32 -0400
Date: Wed, 20 Jul 2011 11:25:12 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, greearb@candelatech.com, edt@aei.ca
Subject: [PATCH rcu/urgent 0/7 v2] Fixes for RCU/scheduler/irq-threads
 trainwreck
Message-ID: <20110720182512.GA22946@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110720001738.GA16369@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110720001738.GA16369@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patch set contains version 2 of fixes for a trainwreck involving
RCU, the scheduler, and threaded interrupts.  This trainwreck involved
RCU failing to properly protect one of its bit fields, use of RCU by
the scheduler from portions of irq_exit() where in_irq() returns false,
uses of the scheduler by RCU colliding with uses of RCU by the scheduler,
threaded interrupts exercising the problematic portions of irq_exit()
more heavily, and so on.  The patches are as follows:

1.	Properly protect current->rcu_read_unlock_special().
	Lack of protection was causing RCU to recurse on itself, which
	in turn resulted in deadlocks involving RCU and the scheduler.
	This affects only RCU_BOOST=y configurations.
2.	Streamline code produced by __rcu_read_unlock().  This one is
	an innocent bystander that is being carried due to conflicts
	with other patches.  (A later version will likely merge it
	with #3 below.)
3.	Make __rcu_read_unlock() delay counting the per-task
	->rcu_read_lock_nesting variable to zero until all cleanup for the
	just-ended RCU read-side critical section has completed.  This
	prevents a number of other cases that could result in deadlock
	due to self recursion.	This affects only TREE_PREEMPT_RCU=y
	configurations.
4.	Make scheduler_ipi() correctly identify itself as being
	in_irq() when it needs to do anything that might involve RCU,
	thus enabling RCU to avoid yet another class of potential
	self-recursions and deadlocks.	This affects PREEMPT_RCU=y
	configurations.
5.	Make irq_exit() inform RCU when it is invoking the scheduler
	in situations where in_irq() would return false, thus
	allowing RCU to correctly avoid self-recursion.  This affects
	TREE_PREEMPT_RCU=y configurations.
6.	Make __lock_task_sighand() execute the entire RCU read-side
	critical section with irqs disabled.  (An experimental patch at
	http://marc.info/?l=linux-kernel&m=131110647222185 might possibly
	make it legal to have an RCU read-side critical section where
	the rcu_read_unlock() is executed with interrupts disabled,
	but where some protion of the RCU read-side critical section
	was preemptible.)  This affects TREE_PREEMPT_RCU=y configurations.

TINY_PREEMPT_RCU will also need a few of these changes, but in the
meantime this patch stack helps organize things better for testing.

Changes from v1 (lkml.kernel.org/r/20110720001738.GA16369@linux.vnet.ibm.com):

o	Fix an embarrassing missing-braces bug in rcu_report_exp_rnp().

o	Fix the WARN_ON_ONCE() in __rcu_read_unlock() to correctly handle
	the new negative values.

o	Make the RCU read-side critical section in __lock_task_sighand()
	cover the full sighand->siglock critical section.

Many thanks to Peter for his review and to Ed and Ben for their testing.

These are also available from the following subject-to-rebase git branch:

git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/urgent

Or will be once kernel.org's mirrors have updated.

							Thanx, Paul

------------------------------------------------------------------------

 b/include/linux/sched.h   |    3 ++
 b/kernel/rcutree_plugin.h |    6 +++--
 b/kernel/sched.c          |   44 ++++++++++++++++++++++++++++++++++-----
 b/kernel/signal.c         |   19 +++++++++++------
 b/kernel/softirq.c        |   12 +++++++++-
 kernel/rcutree_plugin.h   |   51 +++++++++++++++++++++++++++++++++-------------
 6 files changed, 105 insertions(+), 30 deletions(-)
