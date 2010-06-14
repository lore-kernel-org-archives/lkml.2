Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745Ab0FNVoc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 17:44:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:46917 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756676Ab0FNVjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 17:39:19 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Cc: Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Tony Luck <tony.luck@intel.com>, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 25/30] workqueue: increase max_active of keventd and kill current_is_keventd()
Date: Mon, 14 Jun 2010 23:37:42 +0200
Message-Id: <1276551467-21246-26-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1276551467-21246-1-git-send-email-tj@kernel.org>
References: <1276551467-21246-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 14 Jun 2010 21:37:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define WQ_MAX_ACTIVE and create keventd with max_active set to half of
it which means that keventd now can process upto WQ_MAX_ACTIVE / 2 - 1
works concurrently.  Unless some combination can result in dependency
loop longer than max_active, deadlock won't happen and thus it's
unnecessary to check whether current_is_keventd() before trying to
schedule a work.  Kill current_is_keventd().

(Lockdep annotations are broken.  We need lock_map_acquire_read_norecurse())

NOT_SIGNED_OFF_YET: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 arch/ia64/kernel/smpboot.c |    2 +-
 arch/x86/kernel/smpboot.c  |    2 +-
 include/linux/workqueue.h  |    4 ++-
 kernel/workqueue.c         |   63 +++++++++----------------------------------
 4 files changed, 18 insertions(+), 53 deletions(-)

diff --git a/arch/ia64/kernel/smpboot.c b/arch/ia64/kernel/smpboot.c
index 6a1380e..99dcc85 100644
--- a/arch/ia64/kernel/smpboot.c
+++ b/arch/ia64/kernel/smpboot.c
@@ -519,7 +519,7 @@ do_boot_cpu (int sapicid, int cpu)
 	/*
 	 * We can't use kernel_thread since we must avoid to reschedule the child.
 	 */
-	if (!keventd_up() || current_is_keventd())
+	if (!keventd_up())
 		c_idle.work.func(&c_idle.work);
 	else {
 		schedule_work(&c_idle.work);
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index c4f33b2..4d90f37 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -735,7 +735,7 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu)
 		goto do_rest;
 	}
 
-	if (!keventd_up() || current_is_keventd())
+	if (!keventd_up())
 		c_idle.work.func(&c_idle.work);
 	else {
 		schedule_work(&c_idle.work);
diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index b8f4ec4..33e24e7 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -227,6 +227,9 @@ enum {
 	WQ_SINGLE_CPU		= 1 << 1, /* only single cpu at a time */
 	WQ_NON_REENTRANT	= 1 << 2, /* guarantee non-reentrance */
 	WQ_RESCUER		= 1 << 3, /* has an rescue worker */
+
+	WQ_MAX_ACTIVE		= 512,	  /* I like 512, better ideas? */
+	WQ_DFL_ACTIVE		= WQ_MAX_ACTIVE / 2,
 };
 
 extern struct workqueue_struct *
@@ -280,7 +283,6 @@ extern int schedule_delayed_work(struct delayed_work *work, unsigned long delay)
 extern int schedule_delayed_work_on(int cpu, struct delayed_work *work,
 					unsigned long delay);
 extern int schedule_on_each_cpu(work_func_t func);
-extern int current_is_keventd(void);
 extern int keventd_up(void);
 
 extern void init_workqueues(void);
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index dd8c38b..9f22dbd 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2343,7 +2343,6 @@ EXPORT_SYMBOL(schedule_delayed_work_on);
 int schedule_on_each_cpu(work_func_t func)
 {
 	int cpu;
-	int orig = -1;
 	struct work_struct *works;
 
 	works = alloc_percpu(struct work_struct);
@@ -2352,23 +2351,12 @@ int schedule_on_each_cpu(work_func_t func)
 
 	get_online_cpus();
 
-	/*
-	 * When running in keventd don't schedule a work item on
-	 * itself.  Can just call directly because the work queue is
-	 * already bound.  This also is faster.
-	 */
-	if (current_is_keventd())
-		orig = raw_smp_processor_id();
-
 	for_each_online_cpu(cpu) {
 		struct work_struct *work = per_cpu_ptr(works, cpu);
 
 		INIT_WORK(work, func);
-		if (cpu != orig)
-			schedule_work_on(cpu, work);
+		schedule_work_on(cpu, work);
 	}
-	if (orig >= 0)
-		func(per_cpu_ptr(works, orig));
 
 	for_each_online_cpu(cpu)
 		flush_work(per_cpu_ptr(works, cpu));
@@ -2439,41 +2427,6 @@ int keventd_up(void)
 	return keventd_wq != NULL;
 }
 
-int current_is_keventd(void)
-{
-	bool found = false;
-	unsigned int cpu;
-
-	/*
-	 * There no longer is one-to-one relation between worker and
-	 * work queue and a worker task might be unbound from its cpu
-	 * if the cpu was offlined.  Match all busy workers.  This
-	 * function will go away once dynamic pool is implemented.
-	 */
-	for_each_possible_cpu(cpu) {
-		struct global_cwq *gcwq = get_gcwq(cpu);
-		struct worker *worker;
-		struct hlist_node *pos;
-		unsigned long flags;
-		int i;
-
-		spin_lock_irqsave(&gcwq->lock, flags);
-
-		for_each_busy_worker(worker, i, pos, gcwq) {
-			if (worker->task == current) {
-				found = true;
-				break;
-			}
-		}
-
-		spin_unlock_irqrestore(&gcwq->lock, flags);
-		if (found)
-			break;
-	}
-
-	return found;
-}
-
 static struct cpu_workqueue_struct *alloc_cwqs(void)
 {
 	const size_t size = sizeof(struct cpu_workqueue_struct);
@@ -2515,6 +2468,16 @@ static void free_cwqs(struct cpu_workqueue_struct *cwqs)
 #endif
 }
 
+static int wq_clamp_max_active(int max_active, const char *name)
+{
+	if (max_active < 1 || max_active > WQ_MAX_ACTIVE)
+		printk(KERN_WARNING "workqueue: max_active %d requested for %s "
+		       "is out of range, clamping between %d and %d\n",
+		       max_active, name, 1, WQ_MAX_ACTIVE);
+
+	return clamp_val(max_active, 1, WQ_MAX_ACTIVE);
+}
+
 struct workqueue_struct *__create_workqueue_key(const char *name,
 						unsigned int flags,
 						int max_active,
@@ -2524,7 +2487,7 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 	struct workqueue_struct *wq;
 	unsigned int cpu;
 
-	max_active = clamp_val(max_active, 1, INT_MAX);
+	max_active = wq_clamp_max_active(max_active, name);
 
 	wq = kzalloc(sizeof(*wq), GFP_KERNEL);
 	if (!wq)
@@ -3272,6 +3235,6 @@ void __init init_workqueues(void)
 		spin_unlock_irq(&gcwq->lock);
 	}
 
-	keventd_wq = create_workqueue("events");
+	keventd_wq = __create_workqueue("events", 0, WQ_DFL_ACTIVE);
 	BUG_ON(!keventd_wq);
 }
-- 
1.6.4.2

