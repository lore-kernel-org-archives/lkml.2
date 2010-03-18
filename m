Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926Ab0CRJH5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 05:07:57 -0400
Received: from mail-yx0-f191.google.com ([209.85.210.191]:60035 "EHLO
	mail-yx0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab0CRJHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 05:07:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=mDAo4VcaAMRXBCeaUuHONgXcw9BEgaCh8iQlzy9JSDgKtNf+qDscVsO7MYuIfgWfHN
         HT4JE93ikKnGOxRWvrzDEhADYO9NqkqGxT7FTzQLQk2pA2saFTYlDGIkEHvT5F7Fs0W8
         J6EouXDSHgdi+UcaXyx1xMB1lWVVVIR2Ui4m4=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 06/12] kernel/: convert cpu notifier to return encapsulate errno value
Date: Thu, 18 Mar 2010 18:05:18 +0900
Message-Id: <1268903124-10237-6-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1268903124-10237-1-git-send-email-akinobu.mita@gmail.com>
References: <1268903124-10237-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By the previous modification, the cpu notifier can return encapsulate
errno value. This converts the cpu notifiers for kernel/*.c

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 kernel/padata.c     |    4 ++--
 kernel/profile.c    |    4 ++--
 kernel/relay.c      |    2 +-
 kernel/sched.c      |    2 +-
 kernel/smp.c        |    2 +-
 kernel/softirq.c    |    2 +-
 kernel/softlockup.c |    2 +-
 kernel/timer.c      |    7 +++++--
 kernel/workqueue.c  |    9 +++++----
 9 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 93caf65..c610d12 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -587,7 +587,7 @@ static int __cpuinit padata_cpu_callback(struct notifier_block *nfb,
 		err = __padata_add_cpu(pinst, cpu);
 		mutex_unlock(&pinst->lock);
 		if (err)
-			return NOTIFY_BAD;
+			return notifier_from_errno(err);
 		break;
 
 	case CPU_DOWN_PREPARE:
@@ -598,7 +598,7 @@ static int __cpuinit padata_cpu_callback(struct notifier_block *nfb,
 		err = __padata_remove_cpu(pinst, cpu);
 		mutex_unlock(&pinst->lock);
 		if (err)
-			return NOTIFY_BAD;
+			return notifier_from_errno(err);
 		break;
 
 	case CPU_UP_CANCELED:
diff --git a/kernel/profile.c b/kernel/profile.c
index a55d3a3..cbf2677 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -370,7 +370,7 @@ static int __cpuinit profile_cpu_callback(struct notifier_block *info,
 					GFP_KERNEL | __GFP_ZERO,
 					0);
 			if (!page)
-				return NOTIFY_BAD;
+				return notifier_from_errno(-ENOMEM);
 			per_cpu(cpu_profile_hits, cpu)[1] = page_address(page);
 		}
 		if (!per_cpu(cpu_profile_hits, cpu)[0]) {
@@ -386,7 +386,7 @@ out_free:
 		page = virt_to_page(per_cpu(cpu_profile_hits, cpu)[1]);
 		per_cpu(cpu_profile_hits, cpu)[1] = NULL;
 		__free_page(page);
-		return NOTIFY_BAD;
+		return notifier_from_errno(-ENOMEM);
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
 		if (prof_cpu_mask != NULL)
diff --git a/kernel/relay.c b/kernel/relay.c
index 3d97f28..29714bf 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -539,7 +539,7 @@ static int __cpuinit relay_hotcpu_callback(struct notifier_block *nb,
 					"relay_hotcpu_callback: cpu %d buffer "
 					"creation failed\n", hotcpu);
 				mutex_unlock(&relay_channels_mutex);
-				return NOTIFY_BAD;
+				return notifier_from_errno(-ENOMEM);
 			}
 		}
 		mutex_unlock(&relay_channels_mutex);
diff --git a/kernel/sched.c b/kernel/sched.c
index c61e58a..873b9d1 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5887,7 +5887,7 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 	case CPU_UP_PREPARE_FROZEN:
 		p = kthread_create(migration_thread, hcpu, "migration/%d", cpu);
 		if (IS_ERR(p))
-			return NOTIFY_BAD;
+			return notifier_from_errno(PTR_ERR(p));
 		kthread_bind(p, cpu);
 		/* Must be high prio: stop_machine expects to yield to it. */
 		rq = task_rq_lock(p, &flags);
diff --git a/kernel/smp.c b/kernel/smp.c
index 9867b6b..cb2a6c6 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -51,7 +51,7 @@ hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
 	case CPU_UP_PREPARE_FROZEN:
 		if (!zalloc_cpumask_var_node(&cfd->cpumask, GFP_KERNEL,
 				cpu_to_node(cpu)))
-			return NOTIFY_BAD;
+			return notifier_from_errno(-ENOMEM);
 		break;
 
 #ifdef CONFIG_HOTPLUG_CPU
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 7c1a67e..2ca2323 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -808,7 +808,7 @@ static int __cpuinit cpu_callback(struct notifier_block *nfb,
 		p = kthread_create(run_ksoftirqd, hcpu, "ksoftirqd/%d", hotcpu);
 		if (IS_ERR(p)) {
 			printk("ksoftirqd for %i failed\n", hotcpu);
-			return NOTIFY_BAD;
+			return notifier_from_errno(PTR_ERR(p));
 		}
 		kthread_bind(p, hotcpu);
   		per_cpu(ksoftirqd, hotcpu) = p;
diff --git a/kernel/softlockup.c b/kernel/softlockup.c
index 0d4c789..46af4c5 100644
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -228,7 +228,7 @@ cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		p = kthread_create(watchdog, hcpu, "watchdog/%d", hotcpu);
 		if (IS_ERR(p)) {
 			printk(KERN_ERR "watchdog for %i failed\n", hotcpu);
-			return NOTIFY_BAD;
+			return notifier_from_errno(PTR_ERR(p));
 		}
 		per_cpu(softlockup_touch_ts, hotcpu) = 0;
 		per_cpu(softlockup_watchdog, hotcpu) = p;
diff --git a/kernel/timer.c b/kernel/timer.c
index c61a794..bc7e930 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1618,11 +1618,14 @@ static int __cpuinit timer_cpu_notify(struct notifier_block *self,
 				unsigned long action, void *hcpu)
 {
 	long cpu = (long)hcpu;
+	int err;
+
 	switch(action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
-		if (init_timers_cpu(cpu) < 0)
-			return NOTIFY_BAD;
+		err = init_timers_cpu(cpu);
+		if (err < 0)
+			return notifier_from_errno(err);
 		break;
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_DEAD:
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index dee4865..5aa45a0 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1076,7 +1076,7 @@ static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
 	unsigned int cpu = (unsigned long)hcpu;
 	struct cpu_workqueue_struct *cwq;
 	struct workqueue_struct *wq;
-	int ret = NOTIFY_OK;
+	int err = 0;
 
 	action &= ~CPU_TASKS_FROZEN;
 
@@ -1090,12 +1090,13 @@ undo:
 
 		switch (action) {
 		case CPU_UP_PREPARE:
-			if (!create_workqueue_thread(cwq, cpu))
+			err = create_workqueue_thread(cwq, cpu);
+			if (!err)
 				break;
 			printk(KERN_ERR "workqueue [%s] for %i failed\n",
 				wq->name, cpu);
 			action = CPU_UP_CANCELED;
-			ret = NOTIFY_BAD;
+			err = -ENOMEM;
 			goto undo;
 
 		case CPU_ONLINE:
@@ -1116,7 +1117,7 @@ undo:
 		cpumask_clear_cpu(cpu, cpu_populated_map);
 	}
 
-	return ret;
+	return notifier_from_errno(err);
 }
 
 #ifdef CONFIG_SMP
-- 
1.6.0.6

