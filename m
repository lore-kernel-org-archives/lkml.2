Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714Ab1GTASy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 20:18:54 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:59428 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279Ab1GTASg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 20:18:36 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, greearb@candelatech.com, edt@aei.ca,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/urgent 6/7] softirq,rcu: Inform RCU of irq_exit() activity
Date: Tue, 19 Jul 2011 17:18:22 -0700
Message-Id: <1311121103-16978-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110720001738.GA16369@linux.vnet.ibm.com>
References: <20110720001738.GA16369@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

The rcu_read_unlock_special() function relies on in_irq() to exclude
scheduler activity from interrupt level.  This fails because exit_irq()
can invoke the scheduler after clearing the preempt_count() bits that
in_irq() uses to determine that it is at interrupt level.  This situation
can result in failures as follows:

 $task			IRQ		SoftIRQ

 rcu_read_lock()

 /* do stuff */

 <preempt> |= UNLOCK_BLOCKED

 rcu_read_unlock()
   --t->rcu_read_lock_nesting

			irq_enter();
			/* do stuff, don't use RCU */
			irq_exit();
			  sub_preempt_count(IRQ_EXIT_OFFSET);
			  invoke_softirq()

					ttwu();
					  spin_lock_irq(&pi->lock)
					  rcu_read_lock();
					  /* do stuff */
					  rcu_read_unlock();
					    rcu_read_unlock_special()
					      rcu_report_exp_rnp()
					        ttwu()
					          spin_lock_irq(&pi->lock) /* deadlock */

   rcu_read_unlock_special(t);

Ed can simply trigger this 'easy' because invoke_softirq() immediately
does a ttwu() of ksoftirqd/# instead of doing the in-place softirq stuff
first, but even without that the above happens.

Cure this by also excluding softirqs from the
rcu_read_unlock_special() handler and ensuring the force_irqthreads
ksoftirqd/# wakeup is done from full softirq context.

[ Alternatively, delaying the ->rcu_read_lock_nesting decrement
  until after the special handling would make the thing more robust
  in the face of interrupts as well.  And there is a separate patch
  for that. ]

Cc: Thomas Gleixner <tglx@linutronix.de>
Reported-and-tested-by: Ed Tomlinson <edt@aei.ca>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_plugin.h |    2 +-
 kernel/softirq.c        |   12 ++++++++++--
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index ad4539a..6c96c67 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -318,7 +318,7 @@ static noinline void rcu_read_unlock_special(struct task_struct *t)
 	}
 
 	/* Hardware IRQ handlers cannot block. */
-	if (in_irq()) {
+	if (in_irq() || in_serving_softirq()) {
 		local_irq_restore(flags);
 		return;
 	}
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 40cf63d..fca82c3 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -315,16 +315,24 @@ static inline void invoke_softirq(void)
 {
 	if (!force_irqthreads)
 		__do_softirq();
-	else
+	else {
+		__local_bh_disable((unsigned long)__builtin_return_address(0),
+				SOFTIRQ_OFFSET);
 		wakeup_softirqd();
+		__local_bh_enable(SOFTIRQ_OFFSET);
+	}
 }
 #else
 static inline void invoke_softirq(void)
 {
 	if (!force_irqthreads)
 		do_softirq();
-	else
+	else {
+		__local_bh_disable((unsigned long)__builtin_return_address(0),
+				SOFTIRQ_OFFSET);
 		wakeup_softirqd();
+		__local_bh_enable(SOFTIRQ_OFFSET);
+	}
 }
 #endif
 
-- 
1.7.3.2

