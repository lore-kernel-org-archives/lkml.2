Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757897Ab2BDBzy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 20:55:54 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:35375 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756368Ab2BDBpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 20:45:50 -0500
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
Subject: [PATCH tip/core/rcu 21/47] rcu: Inform RCU of irq_exit() activity
Date: Fri,  3 Feb 2012 17:44:56 -0800
Message-Id: <1328319922-30828-21-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1328319922-30828-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120204014452.GA29811@linux.vnet.ibm.com>
 <1328319922-30828-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020401-3270-0000-0000-000003B921FE
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

It is also necessary to delay the ->rcu_read_lock_nesting decrement until
after rcu_read_unlock_special().  This delay is handled by the commit
"Protect __rcu_read_unlock() against scheduler-using irq handlers".

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutiny_plugin.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index 95df60e..387c275 100644
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

