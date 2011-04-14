Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758389Ab1DNCIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 22:08:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:47076 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756853Ab1DNCHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 22:07:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,208,1301900400"; 
   d="scan'208";a="628286218"
Message-Id: <20110414020747.411215973@sli10-conroe.sh.intel.com>
User-Agent: quilt/0.48-1
Date: Thu, 14 Apr 2011 10:04:50 +0800
From: shaohua.li@intel.com
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tj@kernel.org, cl@linux.com,
        eric.dumazet@gmail.com, Shaohua Li <shaohua.li@intel.com>
Subject: [patch v3 3/3] percpu_counter: use atomic64 for counter in SMP
References: <20110414020447.979946152@sli10-conroe.sh.intel.com>
Content-Disposition: inline; filename=percpu-counter-atomic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uses atomic64 for percpu_counter, because it is cheaper than spinlock. This
doesn't slow fast path (percpu_counter_read). atomic64_read equals to fbc->count
for 64-bit system, or equals to spin_lock-read-spin_unlock for 32-bit system

Note, originally the percpu_counter_read for 32-bit system doesn't hold
spin_lock, but that is buggy and might cause very wrong value accessed.
This patch fixes the issue.

This can also improve some workloads with percpu_counter->lock heavily
contented. For example, vm_committed_as sometimes causes the contention.
We should tune the batch count, but if we can make percpu_counter better,
why not? In a 24 CPUs system and 24 processes, each runs:
while (1) {
	mmap(128M);
	munmap(128M);
}
we then measure how many loops each process can take:
orig: 1226976
patched: 8210626
The atomic method gives 7x faster.

In percpu_counter_set() and __percpu_counter_sum(), there will be no lock
protecting. This means we might get inprecise count, but we have the same issue
even with lock protecting, because __percpu_counter_add doesn't hold locking
to update cpu local count.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 include/linux/percpu_counter.h |   18 +++--------------
 lib/percpu_counter.c           |   42 +++++++++++++++++++++--------------------
 2 files changed, 26 insertions(+), 34 deletions(-)

Index: linux/include/linux/percpu_counter.h
===================================================================
--- linux.orig/include/linux/percpu_counter.h	2011-04-14 09:50:36.000000000 +0800
+++ linux/include/linux/percpu_counter.h	2011-04-14 09:53:56.000000000 +0800
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
@@ -60,7 +50,7 @@ static inline s64 percpu_counter_sum(str
 
 static inline s64 percpu_counter_read(struct percpu_counter *fbc)
 {
-	return fbc->count;
+	return atomic64_read(&fbc->count);
 }
 
 /*
@@ -70,7 +60,7 @@ static inline s64 percpu_counter_read(st
  */
 static inline s64 percpu_counter_read_positive(struct percpu_counter *fbc)
 {
-	s64 ret = fbc->count;
+	s64 ret = percpu_counter_read(fbc);
 
 	barrier();		/* Prevent reloads of fbc->count */
 	if (ret >= 0)
Index: linux/lib/percpu_counter.c
===================================================================
--- linux.orig/lib/percpu_counter.c	2011-04-14 09:53:04.000000000 +0800
+++ linux/lib/percpu_counter.c	2011-04-14 10:01:29.000000000 +0800
@@ -59,13 +59,17 @@ void percpu_counter_set(struct percpu_co
 {
 	int cpu;
 
-	spin_lock(&fbc->lock);
+	/*
+	 * Don't really need to disable preempt here, just make sure there is
+	 * no big latency because of preemption
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
 
@@ -79,11 +83,11 @@ void __percpu_counter_add(struct percpu_
 		new = count + amount;
 		/* In case of overflow fold it into the global counter instead */
 		if (new >= batch || new <= -batch) {
-			spin_lock(&fbc->lock);
+			preempt_disable();
 			count = __this_cpu_read(*fbc->counters);
-			fbc->count += count + amount;
+			atomic64_add(count + amount, &fbc->count);
 			__this_cpu_write(*fbc->counters, 0);
-			spin_unlock(&fbc->lock);
+			preempt_enable();
 			return;
 		}
 
@@ -97,26 +101,27 @@ EXPORT_SYMBOL(__percpu_counter_add);
  */
 s64 __percpu_counter_sum(struct percpu_counter *fbc)
 {
-	s64 ret;
+	s64 ret = 0;
 	int cpu;
 
-	spin_lock(&fbc->lock);
-	ret = fbc->count;
+	/*
+	 * Don't really need to disable preempt here, just make sure there is
+	 * no big latency because of preemption
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
@@ -131,7 +136,7 @@ int __percpu_counter_init(struct percpu_
 #endif
 	return 0;
 }
-EXPORT_SYMBOL(__percpu_counter_init);
+EXPORT_SYMBOL(percpu_counter_init);
 
 void percpu_counter_destroy(struct percpu_counter *fbc)
 {
@@ -175,13 +180,10 @@ static int __cpuinit percpu_counter_hotc
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

