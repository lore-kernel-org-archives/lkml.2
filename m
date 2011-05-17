Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab1EQIom (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 04:44:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:65454 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752303Ab1EQIoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 04:44:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,224,1304319600"; 
   d="scan'208";a="2672228"
Message-Id: <20110517084419.775071525@sli10-conroe.sh.intel.com>
User-Agent: quilt/0.48-1
Date: Tue, 17 May 2011 16:41:20 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tj@kernel.org, eric.dumazet@gmail.com,
        cl@linux.com, Shaohua Li <shaohua.li@intel.com>
Subject: [patch v3 3/3] percpu_counter: use percpu data to track add start
References: <20110517084117.572970726@sli10-conroe.sh.intel.com>
Content-Disposition: inline; filename=percpu-counter-percpustart.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add_start causes a lot of cache bouncing because it's updated by all
cpus. We can actually make it a percpu variable. This will completely
reduce the cache bouncing.
With the patch and last patch, I get about 7x faster running the
workload that last patch described. Only with last patch, the workload
is only about 4x faster.
This doesn't slow down _sum because we removed lock for _sum. I did
a stress test. 23 CPU run _add, one cpu runs _sum. In _add fast path
(don't hold) lock, _sum runs a little slow (about 20% slower). In
_add slow path (hold lock), _sum runs much faster (about 9x faster);

V2: uses one percpu data as Eric suggested.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 include/linux/percpu_counter.h |   11 ++++++--
 lib/percpu_counter.c           |   51 ++++++++++++++++++++---------------------
 2 files changed, 33 insertions(+), 29 deletions(-)

Index: linux/include/linux/percpu_counter.h
===================================================================
--- linux.orig/include/linux/percpu_counter.h	2011-05-16 10:46:14.000000000 +0800
+++ linux/include/linux/percpu_counter.h	2011-05-17 14:06:23.000000000 +0800
@@ -15,13 +15,18 @@
 
 #ifdef CONFIG_SMP
 
+struct percpu_counter_data {
+	s32 counter;
+	char add_start;
+};
+
 struct percpu_counter {
-	atomic_t sum_start, add_start;
+	atomic_t sum_start;
 	atomic64_t count;
 #ifdef CONFIG_HOTPLUG_CPU
 	struct list_head list;	/* All percpu_counters are on a list */
 #endif
-	s32 __percpu *counters;
+	struct percpu_counter_data __percpu *cpu_data;
 };
 
 extern int percpu_counter_batch;
@@ -71,7 +76,7 @@ static inline s64 percpu_counter_read_po
 
 static inline int percpu_counter_initialized(struct percpu_counter *fbc)
 {
-	return (fbc->counters != NULL);
+	return (fbc->cpu_data != NULL);
 }
 
 #else
Index: linux/lib/percpu_counter.c
===================================================================
--- linux.orig/lib/percpu_counter.c	2011-05-16 10:46:14.000000000 +0800
+++ linux/lib/percpu_counter.c	2011-05-17 14:11:04.000000000 +0800
@@ -59,10 +59,8 @@ void percpu_counter_set(struct percpu_co
 {
 	int cpu;
 
-	for_each_possible_cpu(cpu) {
-		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
-		*pcount = 0;
-	}
+	for_each_possible_cpu(cpu)
+		per_cpu_ptr(fbc->cpu_data, cpu)->counter = 0;
 	atomic64_set(&fbc->count, amount);
 }
 EXPORT_SYMBOL(percpu_counter_set);
@@ -72,23 +70,25 @@ void __percpu_counter_add(struct percpu_
 	s64 count;
 
 	preempt_disable();
-	count = __this_cpu_read(*fbc->counters) + amount;
+	count = __this_cpu_ptr(fbc->cpu_data)->counter + amount;
 	if (count >= batch || count <= -batch) {
 		while (1) {
-			atomic_inc_return(&fbc->add_start);
+			__this_cpu_ptr(fbc->cpu_data)->add_start = 1;
+			/* Guarantee add_starts is seen by _sum */
+			smp_wmb();
 			if (atomic_read(&fbc->sum_start) == 0)
 				break;
-			atomic_dec(&fbc->add_start);
+			__this_cpu_ptr(fbc->cpu_data)->add_start = 0;
 			while (atomic_read(&fbc->sum_start) != 0)
 				cpu_relax();
 		}
 
 		atomic64_add(count, &fbc->count);
-		__this_cpu_write(*fbc->counters, 0);
+		__this_cpu_ptr(fbc->cpu_data)->counter = 0;
 
-		atomic_dec(&fbc->add_start);
+		__this_cpu_ptr(fbc->cpu_data)->add_start = 0;
 	} else {
-		__this_cpu_write(*fbc->counters, count);
+		__this_cpu_ptr(fbc->cpu_data)->counter = count;
 	}
 	preempt_enable();
 }
@@ -104,15 +104,15 @@ s64 __percpu_counter_sum(struct percpu_c
 	int cpu;
 
 	atomic_inc_return(&fbc->sum_start);
-	while (atomic_read(&fbc->add_start) != 0)
-		cpu_relax();
-
-	ret = atomic64_read(&fbc->count);
 	for_each_online_cpu(cpu) {
-		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
-		ret += *pcount;
+		while (per_cpu_ptr(fbc->cpu_data, cpu)->add_start != 0)
+			cpu_relax();
 	}
 
+	ret = atomic64_read(&fbc->count);
+	for_each_online_cpu(cpu)
+		ret += __this_cpu_ptr(fbc->cpu_data)->counter;
+
 	atomic_dec(&fbc->sum_start);
 	return ret;
 }
@@ -122,9 +122,8 @@ int percpu_counter_init(struct percpu_co
 {
 	atomic64_set(&fbc->count, amount);
 	atomic_set(&fbc->sum_start, 0);
-	atomic_set(&fbc->add_start, 0);
-	fbc->counters = alloc_percpu(s32);
-	if (!fbc->counters)
+	fbc->cpu_data = alloc_percpu(struct percpu_counter_data);
+	if (!fbc->cpu_data)
 		return -ENOMEM;
 
 	debug_percpu_counter_activate(fbc);
@@ -141,7 +140,7 @@ EXPORT_SYMBOL(percpu_counter_init);
 
 void percpu_counter_destroy(struct percpu_counter *fbc)
 {
-	if (!fbc->counters)
+	if (!fbc->cpu_data)
 		return;
 
 	debug_percpu_counter_deactivate(fbc);
@@ -151,8 +150,8 @@ void percpu_counter_destroy(struct percp
 	list_del(&fbc->list);
 	mutex_unlock(&percpu_counters_lock);
 #endif
-	free_percpu(fbc->counters);
-	fbc->counters = NULL;
+	free_percpu(fbc->cpu_data);
+	fbc->cpu_data = NULL;
 }
 EXPORT_SYMBOL(percpu_counter_destroy);
 
@@ -180,11 +179,11 @@ static int __cpuinit percpu_counter_hotc
 	cpu = (unsigned long)hcpu;
 	mutex_lock(&percpu_counters_lock);
 	list_for_each_entry(fbc, &percpu_counters, list) {
-		s32 *pcount;
+		struct percpu_counter_data *data =
+			per_cpu_ptr(fbc->cpu_data, cpu);
 
-		pcount = per_cpu_ptr(fbc->counters, cpu);
-		atomic64_add(*pcount, &fbc->count);
-		*pcount = 0;
+		atomic64_add(data->counter, &fbc->count);
+		data->counter = 0;
 	}
 	mutex_unlock(&percpu_counters_lock);
 #endif

