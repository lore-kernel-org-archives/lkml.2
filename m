Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860Ab2BATw6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 14:52:58 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:40452 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754754Ab2BATm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 14:42:58 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 21/41] rcu: Inform RCU of irq_exit() activity
Date: Wed,  1 Feb 2012 11:41:39 -0800
Message-Id: <1328125319-5205-21-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020119-7282-0000-0000-0000061F24F5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

This is a port to TINY_RCU of Peter Zijlstra's commit #ec433f0c5

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

This can be triggered 'easily' because invoke_softirq() immediately does
a ttwu() of ksoftirqd/# instead of doing the in-place softirq stuff first,
but even without that the above happens.

Cure this by also excluding softirqs from the rcu_read_unlock_special()
handler and ensuring the force_irqthreads ksoftirqd/# wakeup is done
from full softirq context.

[ Alternatively, delaying the ->rcu_read_lock_nesting decrement
  until after the special handling would make the thing more robust
  in the face of interrupts as well.  And there is a separate patch
  for that. ]

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutiny_plugin.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index 3f6c07e..9d7d985 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -570,7 +570,7 @@ static noinline void rcu_read_unlock_special(struct task_struct *t)
 		rcu_preempt_cpu_qs();
 
 	/* Hardware IRQ handlers cannot block. */
-	if (in_irq()) {
+	if (in_irq() || in_serving_softirq()) {
 		local_irq_restore(flags);
 		return;
 	}
-- 
1.7.8

