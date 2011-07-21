Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073Ab1GUXEW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 19:04:22 -0400
Received: from smtp-out.google.com ([216.239.44.51]:55913 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108Ab1GUXBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 19:01:02 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:content-disposition;
	b=Q8o8FuRJACWZL0cEay3x8xbfPnVgKlxbutYXSVZHcKBqw6/SpC7fPAosp5DyW6Urx
	diS3MRGFcplY6PCmy7DoA==
Message-Id: <20110721184757.677889157@google.com>
User-Agent: quilt/0.48-1
Date: Thu, 21 Jul 2011 09:43:35 -0700
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Jason Baron <jbaron@redhat.com>
Subject: [patch 10/18] sched: allow for positional tg_tree walks
References: <20110721164325.231521704@google.com>
Content-Disposition: inline; filename=sched-bwc-refactor-walk_tg_tree.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extend walk_tg_tree to accept a positional argument

static int walk_tg_tree_from(struct task_group *from,
			     tg_visitor down, tg_visitor up, void *data)

Existing semantics are preserved, caller must hold rcu_lock() or sufficient
analogue.

Signed-off-by: Paul Turner <pjt@google.com>
Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

---
 kernel/sched.c |   52 +++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 39 insertions(+), 13 deletions(-)

Index: tip/kernel/sched.c
===================================================================
--- tip.orig/kernel/sched.c
+++ tip/kernel/sched.c
@@ -1583,20 +1583,23 @@ static inline void dec_cpu_load(struct r
 typedef int (*tg_visitor)(struct task_group *, void *);
 
 /*
- * Iterate the full tree, calling @down when first entering a node and @up when
- * leaving it for the final time.
+ * Iterate task_group tree rooted at *from, calling @down when first entering a
+ * node and @up when leaving it for the final time.
+ *
+ * Caller must hold rcu_lock or sufficient equivalent.
  */
-static int walk_tg_tree(tg_visitor down, tg_visitor up, void *data)
+static int walk_tg_tree_from(struct task_group *from,
+			     tg_visitor down, tg_visitor up, void *data)
 {
 	struct task_group *parent, *child;
 	int ret;
 
-	rcu_read_lock();
-	parent = &root_task_group;
+	parent = from;
+
 down:
 	ret = (*down)(parent, data);
 	if (ret)
-		goto out_unlock;
+		goto out;
 	list_for_each_entry_rcu(child, &parent->children, siblings) {
 		parent = child;
 		goto down;
@@ -1605,19 +1608,29 @@ up:
 		continue;
 	}
 	ret = (*up)(parent, data);
-	if (ret)
-		goto out_unlock;
+	if (ret || parent == from)
+		goto out;
 
 	child = parent;
 	parent = parent->parent;
 	if (parent)
 		goto up;
-out_unlock:
-	rcu_read_unlock();
-
+out:
 	return ret;
 }
 
+/*
+ * Iterate the full tree, calling @down when first entering a node and @up when
+ * leaving it for the final time.
+ *
+ * Caller must hold rcu_lock or sufficient equivalent.
+ */
+
+static inline int walk_tg_tree(tg_visitor down, tg_visitor up, void *data)
+{
+	return walk_tg_tree_from(&root_task_group, down, up, data);
+}
+
 static int tg_nop(struct task_group *tg, void *data)
 {
 	return 0;
@@ -1711,7 +1724,9 @@ static int tg_load_down(struct task_grou
 
 static void update_h_load(long cpu)
 {
+	rcu_read_lock();
 	walk_tg_tree(tg_load_down, tg_nop, (void *)cpu);
+	rcu_read_unlock();
 }
 
 #endif
@@ -8684,13 +8699,19 @@ static int tg_rt_schedulable(struct task
 
 static int __rt_schedulable(struct task_group *tg, u64 period, u64 runtime)
 {
+	int ret;
+
 	struct rt_schedulable_data data = {
 		.tg = tg,
 		.rt_period = period,
 		.rt_runtime = runtime,
 	};
 
-	return walk_tg_tree(tg_rt_schedulable, tg_nop, &data);
+	rcu_read_lock();
+	ret = walk_tg_tree(tg_rt_schedulable, tg_nop, &data);
+	rcu_read_unlock();
+
+	return ret;
 }
 
 static int tg_set_rt_bandwidth(struct task_group *tg,
@@ -9147,6 +9168,7 @@ static int tg_cfs_schedulable_down(struc
 
 static int __cfs_schedulable(struct task_group *tg, u64 period, u64 quota)
 {
+	int ret;
 	struct cfs_schedulable_data data = {
 		.tg = tg,
 		.period = period,
@@ -9158,7 +9180,11 @@ static int __cfs_schedulable(struct task
 		do_div(data.quota, NSEC_PER_USEC);
 	}
 
-	return walk_tg_tree(tg_cfs_schedulable_down, tg_nop, &data);
+	rcu_read_lock();
+	ret = walk_tg_tree(tg_cfs_schedulable_down, tg_nop, &data);
+	rcu_read_unlock();
+
+	return ret;
 }
 #endif /* CONFIG_CFS_BANDWIDTH */
 #endif /* CONFIG_FAIR_GROUP_SCHED */


