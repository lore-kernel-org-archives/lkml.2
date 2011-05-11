Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000Ab1EKPqW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:46:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:29429 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754751Ab1EKPqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:46:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,351,1301900400"; 
   d="scan'208";a="641126614"
Message-Id: <20110511081433.819352330@sli10-conroe.sh.intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 11 May 2011 16:10:15 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tj@kernel.org, eric.dumazet@gmail.com,
        cl@linux.com, npiggin@kernel.dk, Shaohua Li <shaohua.li@intel.com>
Subject: [patch v2 3/5] percpu_counter: use lglock to protect percpu data
References: <20110511081012.903869567@sli10-conroe.sh.intel.com>
Content-Disposition: inline; filename=percpu-counter-percpulock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

uses lglock to protect percpu data. This is a preparation to remove
percpu_counter global lock.
This will slow __percpu_counter_sum, but this one is supposed not to be called
frequently, so doesn't matter.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 include/linux/percpu_counter.h |    9 ++++++---
 lib/percpu_counter.c           |   15 ++++++++++++++-
 2 files changed, 20 insertions(+), 4 deletions(-)

Index: linux/include/linux/percpu_counter.h
===================================================================
--- linux.orig/include/linux/percpu_counter.h	2011-05-10 16:23:01.000000000 +0800
+++ linux/include/linux/percpu_counter.h	2011-05-11 09:28:55.000000000 +0800
@@ -12,6 +12,7 @@
 #include <linux/threads.h>
 #include <linux/percpu.h>
 #include <linux/types.h>
+#include <linux/lglock.h>
 
 #ifdef CONFIG_SMP
 
@@ -22,18 +23,20 @@ struct percpu_counter {
 	struct list_head list;	/* All percpu_counters are on a list */
 #endif
 	s32 __percpu *counters;
+	struct lglock lglock;
 };
 
 extern int percpu_counter_batch;
 
 int __percpu_counter_init(struct percpu_counter *fbc, s64 amount,
-			  struct lock_class_key *key);
+			struct lock_class_key *key, const char *name,
+			struct lock_class_key *key2);
 
 #define percpu_counter_init(fbc, value)					\
 	({								\
-		static struct lock_class_key __key;			\
+		static struct lock_class_key __key, __key2;		\
 									\
-		__percpu_counter_init(fbc, value, &__key);		\
+		__percpu_counter_init(fbc, value, &__key, #fbc, &__key2);\
 	})
 
 void percpu_counter_destroy(struct percpu_counter *fbc);
Index: linux/lib/percpu_counter.c
===================================================================
--- linux.orig/lib/percpu_counter.c	2011-05-10 16:10:54.000000000 +0800
+++ linux/lib/percpu_counter.c	2011-05-11 09:28:55.000000000 +0800
@@ -77,8 +77,10 @@ void __percpu_counter_add(struct percpu_
 	count = __this_cpu_read(*fbc->counters) + amount;
 	if (count >= batch || count <= -batch) {
 		spin_lock(&fbc->lock);
+		lg_local_lock(fbc->lglock);
 		fbc->count += count;
 		__this_cpu_write(*fbc->counters, 0);
+		lg_local_unlock(fbc->lglock);
 		spin_unlock(&fbc->lock);
 	} else {
 		__this_cpu_write(*fbc->counters, count);
@@ -97,18 +99,21 @@ s64 __percpu_counter_sum(struct percpu_c
 	int cpu;
 
 	spin_lock(&fbc->lock);
+	lg_global_lock_online(fbc->lglock);
 	ret = fbc->count;
 	for_each_online_cpu(cpu) {
 		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
 		ret += *pcount;
 	}
+	lg_global_unlock_online(fbc->lglock);
 	spin_unlock(&fbc->lock);
 	return ret;
 }
 EXPORT_SYMBOL(__percpu_counter_sum);
 
 int __percpu_counter_init(struct percpu_counter *fbc, s64 amount,
-			  struct lock_class_key *key)
+		struct lock_class_key *key, const char *name,
+		struct lock_class_key *key2)
 {
 	spin_lock_init(&fbc->lock);
 	lockdep_set_class(&fbc->lock, key);
@@ -116,6 +121,11 @@ int __percpu_counter_init(struct percpu_
 	fbc->counters = alloc_percpu(s32);
 	if (!fbc->counters)
 		return -ENOMEM;
+	if (lglock_alloc(&fbc->lglock)) {
+		free_percpu(fbc->counters);
+		return -ENOMEM;
+	}
+	__lglock_init(&fbc->lglock, name, key2);
 
 	debug_percpu_counter_activate(fbc);
 
@@ -143,6 +153,7 @@ void percpu_counter_destroy(struct percp
 #endif
 	free_percpu(fbc->counters);
 	fbc->counters = NULL;
+	lglock_free(&fbc->lglock);
 }
 EXPORT_SYMBOL(percpu_counter_destroy);
 
@@ -174,9 +185,11 @@ static int __cpuinit percpu_counter_hotc
 		unsigned long flags;
 
 		spin_lock_irqsave(&fbc->lock, flags);
+		lg_local_lock_cpu(fbc->lglock, cpu);
 		pcount = per_cpu_ptr(fbc->counters, cpu);
 		fbc->count += *pcount;
 		*pcount = 0;
+		lg_local_unlock_cpu(fbc->lglock, cpu);
 		spin_unlock_irqrestore(&fbc->lock, flags);
 	}
 	mutex_unlock(&percpu_counters_lock);

