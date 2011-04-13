Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757652Ab1DMIGJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 04:06:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:31567 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757300Ab1DMIFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 04:05:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,203,1301900400"; 
   d="scan'208";a="627830151"
Message-Id: <20110413080517.901701497@sli10-conroe.sh.intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 13 Apr 2011 15:57:19 +0800
From: shaohua.li@intel.com
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, cl@linux.com, tj@kernel.org,
        eric.dumazet@gmail.com, Shaohua Li <shaohua.li@intel.com>
Subject: [patch v2 4/4] percpu_counter: use atomic64 for counter
References: <20110413075715.090406229@sli10-conroe.sh.intel.com>
Content-Disposition: inline; filename=percpu-counter-atomic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uses atomic64 for percpu_counter, because it is cheaper than spinlock. This
doesn't slow fast path (percpu_counter_read). atomic64_read equals to fbc->count
for 64-bit system, or equals to spin_lock-read-spin_unlock for 32-bit system.

This can improve some workloads with percpu_counter->lock heavily contented.
For example, vm_committed_as sometimes causes the contention. We should tune
the batch count, but if we can make percpu_counter better, why not? In a 24
CPUs system, 24 processes run stress mmap()/mmunmap(), the atomic method
gives 50x faster.

In percpu_counter_set() and __percpu_counter_sum(), there will be no lock
protecting. This means we might get inprecise count, but we have the same issue
even with lock protecting, because __percpu_counter_add doesn't hold locking
to update cpu local count.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 include/linux/percpu_counter.h |   25 +++----------------------
 lib/percpu_counter.c           |   40 ++++++++++++++++++++--------------------
 2 files changed, 23 insertions(+), 42 deletions(-)

Index: linux/include/linux/percpu_counter.h
===================================================================
--- linux.orig/include/linux/percpu_counter.h	2011-04-13 13:27:22.000000000 +0800
+++ linux/include/linux/percpu_counter.h	2011-04-13 13:47:15.000000000 +0800
@@ -16,8 +16,7 @@
 #ifdef CONFIG_SMP
 
 struct percpu_counter {
-	spinlock_t lock;
-	s64 count;
+	atomic64_t count;
 #ifdef CONFIG_HOTPLUG_CPU
 	struct list_head list;	/* All percpu_counters are on a list */
 #endif
@@ -26,16 +25,7 @@ struct percpu_counter {
 
 extern int percpu_counter_batch;
 
-int __percpu_counter_init(struct percpu_counter *fbc, s64 amount,
-			  struct lock_class_key *key);
-
-#define percpu_counter_init(fbc, value)					\
-	({								\
-		static struct lock_class_key __key;			\
-									\
-		__percpu_counter_init(fbc, value, &__key);		\
-	})
-
+int percpu_counter_init(struct percpu_counter *fbc, s64 amount);
 void percpu_counter_destroy(struct percpu_counter *fbc);
 void percpu_counter_set(struct percpu_counter *fbc, s64 amount);
 void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch);
@@ -60,16 +50,7 @@ static inline s64 percpu_counter_sum(str
 
 static inline s64 percpu_counter_read(struct percpu_counter *fbc)
 {
-#if BITS_PER_LONG == 32
-	s64 count;
-	unsigned long flags;
-	spin_lock_irqsave(&fbc->lock, flags);
-	count = fbc->count;
-	spin_unlock_irqrestore(&fbc->lock, flags);
-	return count;
-#else
-	return fbc->count;
-#endif
+	return atomic64_read(&fbc->count);
 }
 
 /*
Index: linux/lib/percpu_counter.c
===================================================================
--- linux.orig/lib/percpu_counter.c	2011-04-12 16:22:59.000000000 +0800
+++ linux/lib/percpu_counter.c	2011-04-13 13:38:02.000000000 +0800
@@ -59,13 +59,17 @@ void percpu_counter_set(struct percpu_co
 {
 	int cpu;
 
-	spin_lock(&fbc->lock);
+	/*
+	 * Don't really need to disable preempt here, just make sure this is no
+	 * big latency because of preemption
+	 */
+	preempt_disable();
 	for_each_possible_cpu(cpu) {
 		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
 		*pcount = 0;
 	}
-	fbc->count = amount;
-	spin_unlock(&fbc->lock);
+	atomic64_set(&fbc->count, amount);
+	preempt_enable();
 }
 EXPORT_SYMBOL(percpu_counter_set);
 
@@ -76,10 +80,8 @@ void __percpu_counter_add(struct percpu_
 	preempt_disable();
 	count = __this_cpu_read(*fbc->counters) + amount;
 	if (count >= batch || count <= -batch) {
-		spin_lock(&fbc->lock);
-		fbc->count += count;
+		atomic64_add(count, &fbc->count);
 		__this_cpu_write(*fbc->counters, 0);
-		spin_unlock(&fbc->lock);
 	} else {
 		__this_cpu_write(*fbc->counters, count);
 	}
@@ -93,26 +95,27 @@ EXPORT_SYMBOL(__percpu_counter_add);
  */
 s64 __percpu_counter_sum(struct percpu_counter *fbc)
 {
-	s64 ret;
+	s64 ret = 0;
 	int cpu;
 
-	spin_lock(&fbc->lock);
-	ret = fbc->count;
+	/*
+	 * Don't really need to disable preempt here, just make sure this is no
+	 * big latency because of preemption
+	 */
+	preempt_disable();
 	for_each_online_cpu(cpu) {
 		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
 		ret += *pcount;
 	}
-	spin_unlock(&fbc->lock);
+	ret += atomic64_read(&fbc->count);
+	preempt_enable();
 	return ret;
 }
 EXPORT_SYMBOL(__percpu_counter_sum);
 
-int __percpu_counter_init(struct percpu_counter *fbc, s64 amount,
-			  struct lock_class_key *key)
+int percpu_counter_init(struct percpu_counter *fbc, s64 amount)
 {
-	spin_lock_init(&fbc->lock);
-	lockdep_set_class(&fbc->lock, key);
-	fbc->count = amount;
+	atomic64_set(&fbc->count, amount);
 	fbc->counters = alloc_percpu(s32);
 	if (!fbc->counters)
 		return -ENOMEM;
@@ -127,7 +130,7 @@ int __percpu_counter_init(struct percpu_
 #endif
 	return 0;
 }
-EXPORT_SYMBOL(__percpu_counter_init);
+EXPORT_SYMBOL(percpu_counter_init);
 
 void percpu_counter_destroy(struct percpu_counter *fbc)
 {
@@ -171,13 +174,10 @@ static int __cpuinit percpu_counter_hotc
 	mutex_lock(&percpu_counters_lock);
 	list_for_each_entry(fbc, &percpu_counters, list) {
 		s32 *pcount;
-		unsigned long flags;
 
-		spin_lock_irqsave(&fbc->lock, flags);
 		pcount = per_cpu_ptr(fbc->counters, cpu);
-		fbc->count += *pcount;
+		atomic64_add(*pcount, &fbc->count);
 		*pcount = 0;
-		spin_unlock_irqrestore(&fbc->lock, flags);
 	}
 	mutex_unlock(&percpu_counters_lock);
 #endif

