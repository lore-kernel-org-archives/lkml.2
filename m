Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097Ab1EKPqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:46:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:63890 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754731Ab1EKPqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:46:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,351,1301900400"; 
   d="scan'208";a="641126616"
Message-Id: <20110511081433.987756741@sli10-conroe.sh.intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 11 May 2011 16:10:16 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tj@kernel.org, eric.dumazet@gmail.com,
        cl@linux.com, npiggin@kernel.dk, Shaohua Li <shaohua.li@intel.com>
Subject: [patch v2 4/5] percpu_counter: use atomic64 for counter in SMP
References: <20110511081012.903869567@sli10-conroe.sh.intel.com>
Content-Disposition: inline; filename=percpu-counter-atomic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The percpu_counter global lock is only used to protect updating fbc->count after
we use lglock to protect percpu data. Uses atomic64 for percpu_counter, because
it is cheaper than spinlock. This doesn't slow fast path (percpu_counter_read).
atomic64_read equals to read fbc->count for 64-bit system, or equals to
spin_lock-read-spin_unlock for 32-bit system.

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
patched: 6727264
The atomic method gives 5x~6x faster.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 include/linux/percpu_counter.h |   14 ++++++--------
 lib/percpu_counter.c           |   27 +++++++++------------------
 2 files changed, 15 insertions(+), 26 deletions(-)

Index: linux/include/linux/percpu_counter.h
===================================================================
--- linux.orig/include/linux/percpu_counter.h	2011-05-10 16:23:01.000000000 +0800
+++ linux/include/linux/percpu_counter.h	2011-05-10 16:23:01.000000000 +0800
@@ -17,8 +17,7 @@
 #ifdef CONFIG_SMP
 
 struct percpu_counter {
-	spinlock_t lock;
-	s64 count;
+	atomic64_t count;
 #ifdef CONFIG_HOTPLUG_CPU
 	struct list_head list;	/* All percpu_counters are on a list */
 #endif
@@ -29,14 +28,13 @@ struct percpu_counter {
 extern int percpu_counter_batch;
 
 int __percpu_counter_init(struct percpu_counter *fbc, s64 amount,
-			struct lock_class_key *key, const char *name,
-			struct lock_class_key *key2);
+			struct lock_class_key *key, const char *name);
 
 #define percpu_counter_init(fbc, value)					\
 	({								\
-		static struct lock_class_key __key, __key2;		\
+		static struct lock_class_key __key;			\
 									\
-		__percpu_counter_init(fbc, value, &__key, #fbc, &__key2);\
+		__percpu_counter_init(fbc, value, &__key, #fbc);	\
 	})
 
 void percpu_counter_destroy(struct percpu_counter *fbc);
@@ -63,7 +61,7 @@ static inline s64 percpu_counter_sum(str
 
 static inline s64 percpu_counter_read(struct percpu_counter *fbc)
 {
-	return fbc->count;
+	return atomic64_read(&fbc->count);
 }
 
 /*
@@ -73,7 +71,7 @@ static inline s64 percpu_counter_read(st
  */
 static inline s64 percpu_counter_read_positive(struct percpu_counter *fbc)
 {
-	s64 ret = fbc->count;
+	s64 ret = percpu_counter_read(fbc);
 
 	barrier();		/* Prevent reloads of fbc->count */
 	if (ret >= 0)
Index: linux/lib/percpu_counter.c
===================================================================
--- linux.orig/lib/percpu_counter.c	2011-05-10 16:23:01.000000000 +0800
+++ linux/lib/percpu_counter.c	2011-05-11 09:24:24.000000000 +0800
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
 
@@ -76,12 +74,10 @@ void __percpu_counter_add(struct percpu_
 	preempt_disable();
 	count = __this_cpu_read(*fbc->counters) + amount;
 	if (count >= batch || count <= -batch) {
-		spin_lock(&fbc->lock);
 		lg_local_lock(fbc->lglock);
-		fbc->count += count;
+		atomic64_add(count, &fbc->count);
 		__this_cpu_write(*fbc->counters, 0);
 		lg_local_unlock(fbc->lglock);
-		spin_unlock(&fbc->lock);
 	} else {
 		__this_cpu_write(*fbc->counters, count);
 	}
@@ -98,26 +94,21 @@ s64 __percpu_counter_sum(struct percpu_c
 	s64 ret;
 	int cpu;
 
-	spin_lock(&fbc->lock);
 	lg_global_lock_online(fbc->lglock);
-	ret = fbc->count;
+	ret = atomic64_read(&fbc->count);
 	for_each_online_cpu(cpu) {
 		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
 		ret += *pcount;
 	}
 	lg_global_unlock_online(fbc->lglock);
-	spin_unlock(&fbc->lock);
 	return ret;
 }
 EXPORT_SYMBOL(__percpu_counter_sum);
 
 int __percpu_counter_init(struct percpu_counter *fbc, s64 amount,
-		struct lock_class_key *key, const char *name,
-		struct lock_class_key *key2)
+		struct lock_class_key *key, const char *name)
 {
-	spin_lock_init(&fbc->lock);
-	lockdep_set_class(&fbc->lock, key);
-	fbc->count = amount;
+	atomic64_set(&fbc->count, amount);
 	fbc->counters = alloc_percpu(s32);
 	if (!fbc->counters)
 		return -ENOMEM;
@@ -125,7 +116,7 @@ int __percpu_counter_init(struct percpu_
 		free_percpu(fbc->counters);
 		return -ENOMEM;
 	}
-	__lglock_init(&fbc->lglock, name, key2);
+	__lglock_init(&fbc->lglock, name, key);
 
 	debug_percpu_counter_activate(fbc);
 
@@ -184,13 +175,13 @@ static int __cpuinit percpu_counter_hotc
 		s32 *pcount;
 		unsigned long flags;
 
-		spin_lock_irqsave(&fbc->lock, flags);
+		local_irq_save(flags);
 		lg_local_lock_cpu(fbc->lglock, cpu);
 		pcount = per_cpu_ptr(fbc->counters, cpu);
-		fbc->count += *pcount;
+		atomic64_add(*pcount, &fbc->count);
 		*pcount = 0;
 		lg_local_unlock_cpu(fbc->lglock, cpu);
-		spin_unlock_irqrestore(&fbc->lock, flags);
+		local_irq_restore(flags);
 	}
 	mutex_unlock(&percpu_counters_lock);
 #endif

