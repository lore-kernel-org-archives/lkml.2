Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab1EQIoX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 04:44:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:65454 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848Ab1EQIoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 04:44:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,224,1304319600"; 
   d="scan'208";a="3222834"
Message-Id: <20110517084419.602635499@sli10-conroe.sh.intel.com>
User-Agent: quilt/0.48-1
Date: Tue, 17 May 2011 16:41:19 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tj@kernel.org, eric.dumazet@gmail.com,
        cl@linux.com, Shaohua Li <shaohua.li@intel.com>
Subject: [patch v3 2/3] percpu_counter: use atomic64 for counter in SMP
References: <20110517084117.572970726@sli10-conroe.sh.intel.com>
Content-Disposition: inline; filename=percpu-counter-atomic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uses atomic64 for percpu_counter, because it is cheaper than spinlock.
This doesn't slow fast path (percpu_counter_read). atomic64_read
equals to read fbc->count for 64-bit system, or equals to
spin_lock-read-spin_unlock for 32-bit system. Note, originally
the percpu_counter_read for 32-bit system doesn't hold spin_lock,
but that is buggy and might cause very wrong value accessed. This
patch fixes the issue.

We use sum_start and add_start to make sure _sum doesn't see deviation
when _add slow path is running. When _sum is running, _add will wait
_sum finish. This is scaring that _add is slow down, but actually not,
because _sum is called very rare. We could make _sum waits _add finish,
but since _add is called frequently, this will make _sum run very slow.

This can also improve some workloads with percpu_counter->lock heavily
contented. For example, vm_committed_as sometimes causes the contention.
We should tune the batch count, but if we can make percpu_counter better,
why not? In a 24 CPUs system and 24 processes, each runs:
while (1) {
	mmap(128M);
	munmap(128M);
}
we then measure how many loops each process can take:
The atomic method gives 4x faster.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 include/linux/percpu_counter.h |   19 ++++-------------
 lib/percpu_counter.c           |   45 +++++++++++++++++++++++------------------
 2 files changed, 31 insertions(+), 33 deletions(-)

Index: linux/include/linux/percpu_counter.h
===================================================================
--- linux.orig/include/linux/percpu_counter.h	2011-05-13 11:13:25.000000000 +0800
+++ linux/include/linux/percpu_counter.h	2011-05-16 10:46:14.000000000 +0800
@@ -16,8 +16,8 @@
 #ifdef CONFIG_SMP
 
 struct percpu_counter {
-	spinlock_t lock;
-	s64 count;
+	atomic_t sum_start, add_start;
+	atomic64_t count;
 #ifdef CONFIG_HOTPLUG_CPU
 	struct list_head list;	/* All percpu_counters are on a list */
 #endif
@@ -26,16 +26,7 @@ struct percpu_counter {
 
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
@@ -60,7 +51,7 @@ static inline s64 percpu_counter_sum(str
 
 static inline s64 percpu_counter_read(struct percpu_counter *fbc)
 {
-	return fbc->count;
+	return atomic64_read(&fbc->count);
 }
 
 /*
@@ -70,7 +61,7 @@ static inline s64 percpu_counter_read(st
  */
 static inline s64 percpu_counter_read_positive(struct percpu_counter *fbc)
 {
-	s64 ret = fbc->count;
+	s64 ret = percpu_counter_read(fbc);
 
 	barrier();		/* Prevent reloads of fbc->count */
 	if (ret >= 0)
Index: linux/lib/percpu_counter.c
===================================================================
--- linux.orig/lib/percpu_counter.c	2011-05-13 10:29:04.000000000 +0800
+++ linux/lib/percpu_counter.c	2011-05-16 10:46:14.000000000 +0800
@@ -59,13 +59,11 @@ void percpu_counter_set(struct percpu_co
 {
 	int cpu;
 
-	spin_lock(&fbc->lock);
 	for_each_possible_cpu(cpu) {
 		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
 		*pcount = 0;
 	}
-	fbc->count = amount;
-	spin_unlock(&fbc->lock);
+	atomic64_set(&fbc->count, amount);
 }
 EXPORT_SYMBOL(percpu_counter_set);
 
@@ -76,10 +74,19 @@ void __percpu_counter_add(struct percpu_
 	preempt_disable();
 	count = __this_cpu_read(*fbc->counters) + amount;
 	if (count >= batch || count <= -batch) {
-		spin_lock(&fbc->lock);
-		fbc->count += count;
+		while (1) {
+			atomic_inc_return(&fbc->add_start);
+			if (atomic_read(&fbc->sum_start) == 0)
+				break;
+			atomic_dec(&fbc->add_start);
+			while (atomic_read(&fbc->sum_start) != 0)
+				cpu_relax();
+		}
+
+		atomic64_add(count, &fbc->count);
 		__this_cpu_write(*fbc->counters, 0);
-		spin_unlock(&fbc->lock);
+
+		atomic_dec(&fbc->add_start);
 	} else {
 		__this_cpu_write(*fbc->counters, count);
 	}
@@ -96,23 +103,26 @@ s64 __percpu_counter_sum(struct percpu_c
 	s64 ret;
 	int cpu;
 
-	spin_lock(&fbc->lock);
-	ret = fbc->count;
+	atomic_inc_return(&fbc->sum_start);
+	while (atomic_read(&fbc->add_start) != 0)
+		cpu_relax();
+
+	ret = atomic64_read(&fbc->count);
 	for_each_online_cpu(cpu) {
 		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
 		ret += *pcount;
 	}
-	spin_unlock(&fbc->lock);
+
+	atomic_dec(&fbc->sum_start);
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
+	atomic_set(&fbc->sum_start, 0);
+	atomic_set(&fbc->add_start, 0);
 	fbc->counters = alloc_percpu(s32);
 	if (!fbc->counters)
 		return -ENOMEM;
@@ -127,7 +137,7 @@ int __percpu_counter_init(struct percpu_
 #endif
 	return 0;
 }
-EXPORT_SYMBOL(__percpu_counter_init);
+EXPORT_SYMBOL(percpu_counter_init);
 
 void percpu_counter_destroy(struct percpu_counter *fbc)
 {
@@ -171,13 +181,10 @@ static int __cpuinit percpu_counter_hotc
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

