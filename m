Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005Ab1BDVZz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 16:25:55 -0500
Received: from smtp-out.google.com ([74.125.121.67]:57201 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab1BDVZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 16:25:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=NqIiA3Y786Rns5VXYDx12NQ37f8r7lRx2O9KfIUUPxXLiLFOG0sd3qVJpA6LUtAQyQ
         uBfTIFBtgtoVeP10q6oQ==
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>, Venkatesh Pallipadi <venki@google.com>
Subject: [PATCH] sched: Resolve sd_idle and first_idle_cpu Catch-22 - v1
Date: Fri,  4 Feb 2011 13:25:31 -0800
Message-Id: <1296854731-25039-1-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1296852688-1665-1-git-send-email-venki@google.com>
References: <1296852688-1665-1-git-send-email-venki@google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consider a system with { [ (A B) (C D) ] [ (E F) (G H) ] },
() denoting SMT siblings, [] cores on same socket and {} system wide
Further, A, C and D are idle, B is busy and one of EFGH has excess load.

With sd_idle logic, a check in rebalance_domains() converts tick
based load balance requests from CPU A to busy load balance for core
and above domains (lower rate of balance and higher load_idx).

With first_idle_cpu logic, when CPU C or D tries to balance across domains
the logic finds CPU A as first idle CPU in the group and nominates CPU A to
idle balance across sockets.

But, sd_idle above would not allow CPU A to do cross socket idle balance
as CPU A switches its higher level balancing to busy balance.

So, this can result is no cross socket balancing for extended periods.

The fix here adds additional check to detect sd_idle logic in
first_idle_cpu code path. We will now nominate (in order or preference):
* First fully idle CPU
* First semi-idle CPU
* First CPU

Note that this solution works fine for 2 SMT siblings case and won't be
perfect in picking proper semi-idle in case of more than 2 SMT threads.

The problem was found by looking at the code and schedstat output. I don't
yet have any data to show impact of this on any workload.

Changes from v0:
* Removed by test code that I left out in earlier version by mistake.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
---
 kernel/sched_fair.c |   38 ++++++++++++++++++++++++++++++++++++--
 1 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 62723a4..e9dbfa8 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2603,6 +2603,34 @@ fix_small_capacity(struct sched_domain *sd, struct sched_group *group)
 	return 0;
 }
 
+/*
+ * Find if there is any busy CPUs in SD_SHARE_CPUPOWER domain of
+ * requested CPU.
+ * Bypass the check in case of SD_POWERSAVINGS_BALANCE on
+ * parent domain. In that case requested CPU can still be nominated as
+ * balancer for higher domains.
+ */
+static int is_cpupower_sharing_domain_idle(int cpu)
+{
+	struct sched_domain *sd;
+	int i;
+
+	for_each_domain(cpu, sd) {
+		if (!(sd->flags & SD_SHARE_CPUPOWER))
+			break;
+
+		if (test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
+			return 1;
+
+		for_each_cpu(i, sched_domain_span(sd)) {
+			if (!idle_cpu(i))
+				return 0;
+		}
+	}
+
+	return 1;
+}
+
 /**
  * update_sg_lb_stats - Update sched_group's statistics for load balancing.
  * @sd: The sched_domain whose statistics are to be updated.
@@ -2625,6 +2653,7 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 	unsigned long load, max_cpu_load, min_cpu_load, max_nr_running;
 	int i;
 	unsigned int balance_cpu = -1, first_idle_cpu = 0;
+	unsigned int first_semiidle_cpu = 0;
 	unsigned long avg_load_per_task = 0;
 
 	if (local_group)
@@ -2644,8 +2673,13 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 		/* Bias balancing toward cpus of our domain */
 		if (local_group) {
 			if (idle_cpu(i) && !first_idle_cpu) {
-				first_idle_cpu = 1;
-				balance_cpu = i;
+				if (is_cpupower_sharing_domain_idle(i)) {
+					first_idle_cpu = 1;
+					balance_cpu = i;
+				} else if (!first_semiidle_cpu) {
+					first_semiidle_cpu = 1;
+					balance_cpu = i;
+				}
 			}
 
 			load = target_load(i, load_idx);
-- 
1.7.3.1

