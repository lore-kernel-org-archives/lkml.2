Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888Ab2GWG7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 02:59:50 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:42593 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154Ab2GWG7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 02:59:49 -0400
Subject: [RFC PATCH 1/1] sched: Add a new API to find the prefer idlest cpu
From: Shirley Ma <mashirle@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        vivek@us.ibm.com, sri@us.ibm.com
In-Reply-To: <1343026634.13461.15.camel@oc3660625478.ibm.com>
References: <1343026634.13461.15.camel@oc3660625478.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 22 Jul 2012 23:59:43 -0700
Message-ID: <1343026783.13461.17.camel@oc3660625478.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-24.el6) 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12072306-6078-0000-0000-00000D753FF1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 64d9df5..46cc4a7 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2806,4 +2806,6 @@ static inline unsigned long rlimit_max(unsigned int limit)
 
 #endif /* __KERNEL__ */
 
+extern int find_idlest_prefer_cpu(struct cpumask *prefer,
+				 struct cpumask *allowed, int prev_cpu);
 #endif
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c099cc6..7240868 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -26,6 +26,7 @@
 #include <linux/slab.h>
 #include <linux/profile.h>
 #include <linux/interrupt.h>
+#include <linux/export.h>
 
 #include <trace/events/sched.h>
 
@@ -2809,6 +2810,35 @@ unlock:
 
 	return new_cpu;
 }
+
+/*
+ * This API is used to find the most idle cpu from both preferred and
+ * allowed cpuset (such as cgroup controls cpuset). It helps per-cpu thread
+ * model to pick up the allowed local cpu to be scheduled.
+ * If these two cpusets have intersects, the cpu is chose from the intersects,
+ * if there is no intersects, then the cpu is chose from the allowed cpuset.
+ * prev_cpu helps to better local cache when prev_cpu is not busy.
+ */
+int find_idlest_prefer_cpu(struct cpumask *prefer, struct cpumask *allowed,
+			  int prev_cpu)
+{
+	unsigned long load, min_load = ULONG_MAX;
+	int check, i, idlest = -1;
+
+	check = cpumask_intersects(prefer, allowed);
+	/* Traverse only the allowed CPUs */
+	if (check == 0)
+		prefer = allowed;
+	for_each_cpu_and(i, prefer, allowed) {
+		load = weighted_cpuload(i);
+		if (load < min_load || (load == min_load && i == prev_cpu)) {
+			min_load = load;
+			idlest = i;
+		}
+	}
+	return idlest;
+}
+EXPORT_SYMBOL(find_idlest_prefer_cpu);
 #endif /* CONFIG_SMP */
 
 static unsigned long

Shirley

