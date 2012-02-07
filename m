Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522Ab2BGS44 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 13:56:56 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:35380 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756381Ab2BGS4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 13:56:54 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 2/4] cpuset: Split up update_cpumask() so that its
 functionality can be reused
To: paul@paulmenage.org, a.p.zijlstra@chello.nl, mingo@elte.hu, rjw@sisk.pl,
        tj@kernel.org
Cc: frank.rowand@am.sony.com, pjt@google.com, tglx@linutronix.de,
        lizf@cn.fujitsu.com, prashanth@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com,
        srivatsa.bhat@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Date: Wed, 08 Feb 2012 00:26:42 +0530
Message-ID: <20120207185620.7482.29594.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20120207185411.7482.43576.stgit@srivatsabhat.in.ibm.com>
References: <20120207185411.7482.43576.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12020718-9574-0000-0000-00000147BDD3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

update_cpumask() expects the new cpuset in the form of characters (owing to
the fact that it expects cpuset updates from userspace). This might not be
appropriate if an in-kernel user wants to call it.

So, split up the function so that its functionality can be reused. That is,
introduce do_update_cpumask() and offload the core work to it.

Reported-by: Prashanth K. Nageshappa <prashanth@linux.vnet.ibm.com>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: stable@vger.kernel.org
---

 kernel/cpuset.c |   61 ++++++++++++++++++++++++++++++++++++++-----------------
 1 files changed, 42 insertions(+), 19 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 5e2323b..2be71da 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -864,13 +864,14 @@ static void update_tasks_cpumask(struct cpuset *cs, struct ptr_heap *heap)
 	cgroup_scan_tasks(&scan);
 }
 
+
 /**
- * update_cpumask - update the cpus_allowed mask of a cpuset and all tasks in it
+ * do_update_cpumask - update the cpus_allowed mask of a cpuset and all tasks
+ * in it
  * @cs: the cpuset to consider
- * @buf: buffer of cpu numbers written to this cpuset
+ * @trialcs: the updated cpuset value requested
  */
-static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
-			  const char *buf)
+static int do_update_cpumask(struct cpuset *cs, struct cpuset *trialcs)
 {
 	struct ptr_heap heap;
 	int retval;
@@ -880,22 +881,9 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 	if (cs == &top_cpuset)
 		return -EACCES;
 
-	/*
-	 * An empty cpus_allowed is ok only if the cpuset has no tasks.
-	 * Since cpulist_parse() fails on an empty mask, we special case
-	 * that parsing.  The validate_change() call ensures that cpusets
-	 * with tasks have cpus.
-	 */
-	if (!*buf) {
-		cpumask_clear(trialcs->cpus_allowed);
-	} else {
-		retval = cpulist_parse(buf, trialcs->cpus_allowed);
-		if (retval < 0)
-			return retval;
-
-		if (!cpumask_subset(trialcs->cpus_allowed, cpu_active_mask))
+	if (!cpumask_subset(trialcs->cpus_allowed, cpu_active_mask))
 			return -EINVAL;
-	}
+
 	retval = validate_change(cs, trialcs);
 	if (retval < 0)
 		return retval;
@@ -925,9 +913,44 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 
 	if (is_load_balanced)
 		async_rebuild_sched_domains();
+
 	return 0;
 }
 
+/**
+ * update_cpumask - update the cpus_allowed mask of a cpuset and all tasks in it
+ * @cs: the cpuset to consider
+ * @buf: buffer of cpu numbers written to this cpuset
+ */
+static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
+			  const char *buf)
+{
+	int retval;
+
+	/* top_cpuset.cpus_allowed tracks cpu_online_map; it's read-only */
+	if (cs == &top_cpuset)
+		return -EACCES;
+
+	/*
+	 * An empty cpus_allowed is ok only if the cpuset has no tasks.
+	 * Since cpulist_parse() fails on an empty mask, we special case
+	 * that parsing.  The validate_change() call ensures that cpusets
+	 * with tasks have cpus.
+	 */
+	if (!*buf) {
+		cpumask_clear(trialcs->cpus_allowed);
+	} else {
+		retval = cpulist_parse(buf, trialcs->cpus_allowed);
+		if (retval < 0)
+			return retval;
+
+		if (!cpumask_subset(trialcs->cpus_allowed, cpu_active_mask))
+			return -EINVAL;
+	}
+
+	return do_update_cpumask(cs, trialcs);
+}
+
 /*
  * cpuset_migrate_mm
  *

