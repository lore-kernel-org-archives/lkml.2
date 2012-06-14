Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab2FNUFK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 16:05:10 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:47165 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489Ab2FNUFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 16:05:08 -0400
Date: Thu, 14 Jun 2012 13:01:29 -0700
From: Silas Boyd-Wickizer <sbw@mit.edu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [RFC patch 1/5] kthread: Implement park/unpark facility
Message-ID: <20120614200125.GA26852@mit.edu>
References: <20120613102823.373180763@linutronix.de>
 <20120613105815.132283147@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120613105815.132283147@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've taken a stab at converting stop_machine to use kthread_park and
kthread_unpark.  I don't think stop_machine can use
smpboot_park_threads (in their current implementation) because, among
other reasons, _cpu_down calls __stop_machine after parking the
stopper threads via smpboot_park_threads.

Silas

Signed-off-by: Silas Boyd-Wickizer <sbw@mit.edu>
---
 kernel/stop_machine.c |   41 ++++++++++++++++++-----------------------
 1 file changed, 18 insertions(+), 23 deletions(-)

diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 2f194e9..631f133 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -244,7 +244,7 @@ int try_stop_cpus(const struct cpumask *cpumask, cpu_stop_fn_t fn, void *arg)
 	return ret;
 }
 
-static int cpu_stopper_thread(void *data)
+static __noreturn int cpu_stopper_thread(void *data)
 {
 	struct cpu_stopper *stopper = data;
 	struct cpu_stop_work *work;
@@ -253,10 +253,8 @@ static int cpu_stopper_thread(void *data)
 repeat:
 	set_current_state(TASK_INTERRUPTIBLE);	/* mb paired w/ kthread_stop */
 
-	if (kthread_should_stop()) {
-		__set_current_state(TASK_RUNNING);
-		return 0;
-	}
+	if (kthread_should_park())
+		kthread_parkme();
 
 	work = NULL;
 	spin_lock_irq(&stopper->lock);
@@ -308,23 +306,23 @@ static int __cpuinit cpu_stop_cpu_callback(struct notifier_block *nfb,
 
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_UP_PREPARE:
-		BUG_ON(stopper->thread || stopper->enabled ||
-		       !list_empty(&stopper->works));
-		p = kthread_create_on_node(cpu_stopper_thread,
-					   stopper,
-					   cpu_to_node(cpu),
-					   "migration/%d", cpu);
-		if (IS_ERR(p))
-			return notifier_from_errno(PTR_ERR(p));
-		get_task_struct(p);
-		kthread_bind(p, cpu);
-		sched_set_stop_task(cpu, p);
-		stopper->thread = p;
+		if (!stopper->thread) {
+			BUG_ON(stopper->enabled ||
+			       !list_empty(&stopper->works));
+			p = kthread_create_on_cpu(cpu_stopper_thread,
+						  stopper,
+						  cpu,
+						  "migration/%d");
+			if (IS_ERR(p))
+				return notifier_from_errno(PTR_ERR(p));
+			get_task_struct(p);
+			stopper->thread = p;
+		}
+		sched_set_stop_task(cpu, stopper->thread);
 		break;
 
 	case CPU_ONLINE:
-		/* strictly unnecessary, as first user will wake it */
-		wake_up_process(stopper->thread);
+		kthread_unpark(stopper->thread);
 		/* mark enabled */
 		spin_lock_irq(&stopper->lock);
 		stopper->enabled = true;
@@ -339,16 +337,13 @@ static int __cpuinit cpu_stop_cpu_callback(struct notifier_block *nfb,
 
 		sched_set_stop_task(cpu, NULL);
 		/* kill the stopper */
-		kthread_stop(stopper->thread);
+		kthread_park(stopper->thread);
 		/* drain remaining works */
 		spin_lock_irq(&stopper->lock);
 		list_for_each_entry(work, &stopper->works, list)
 			cpu_stop_signal_done(work->done, false);
 		stopper->enabled = false;
 		spin_unlock_irq(&stopper->lock);
-		/* release the stopper */
-		put_task_struct(stopper->thread);
-		stopper->thread = NULL;
 		break;
 	}
 #endif
