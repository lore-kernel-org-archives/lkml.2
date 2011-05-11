Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120Ab1EKPrZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:47:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:8648 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754959Ab1EKPqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:46:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,351,1301900400"; 
   d="scan'208";a="641126618"
Message-Id: <20110511081434.156086280@sli10-conroe.sh.intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 11 May 2011 16:10:17 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tj@kernel.org, eric.dumazet@gmail.com,
        cl@linux.com, npiggin@kernel.dk, Shaohua Li <shaohua.li@intel.com>
Subject: [patch v2 5/5] percpu_counter: preemptless __per_cpu_counter_add
References: <20110511081012.903869567@sli10-conroe.sh.intel.com>
Content-Disposition: inline; filename=percpu-counter-add-preemptless.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <cl@linux.com>

Make percpu_counter_add hot path preemptless.

Signed-off-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 lib/percpu_counter.c |   37 +++++++++++++++++++++++++------------
 1 file changed, 25 insertions(+), 12 deletions(-)

Index: linux/lib/percpu_counter.c
===================================================================
--- linux.orig/lib/percpu_counter.c	2011-05-10 16:23:01.000000000 +0800
+++ linux/lib/percpu_counter.c	2011-05-10 16:23:01.000000000 +0800
@@ -67,21 +67,34 @@ void percpu_counter_set(struct percpu_co
 }
 EXPORT_SYMBOL(percpu_counter_set);
 
+static bool __percpu_counter_add_cmpxchg(struct percpu_counter *fbc,
+	s64 count, s64 new)
+{
+#ifdef CONFIG_PREEMPT
+	return this_cpu_cmpxchg(*fbc->counters, count, new) == count;
+#else
+	this_cpu_write(*fbc->counters, new);
+	return true;
+#endif
+}
+
 void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch)
 {
-	s64 count;
+	s64 count, new;
+
+	do {
+		count = this_cpu_read(*fbc->counters);
+		new = count + amount;
 
-	preempt_disable();
-	count = __this_cpu_read(*fbc->counters) + amount;
-	if (count >= batch || count <= -batch) {
-		lg_local_lock(fbc->lglock);
-		atomic64_add(count, &fbc->count);
-		__this_cpu_write(*fbc->counters, 0);
-		lg_local_unlock(fbc->lglock);
-	} else {
-		__this_cpu_write(*fbc->counters, count);
-	}
-	preempt_enable();
+		if (new >= batch || new <= -batch) {
+			lg_local_lock(fbc->lglock);
+			count = __this_cpu_read(*fbc->counters) + amount;
+			atomic64_add(count, &fbc->count);
+			__this_cpu_write(*fbc->counters, 0);
+			lg_local_unlock(fbc->lglock);
+			return;
+		}
+	} while (!__percpu_counter_add_cmpxchg(fbc, count, new));
 }
 EXPORT_SYMBOL(__percpu_counter_add);
 

