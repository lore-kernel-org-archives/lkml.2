Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab1HNQ3k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:29:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:48881 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753810Ab1HNQ3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:29:35 -0400
Date: Sun, 14 Aug 2011 16:29:07 GMT
From: tip-bot for Paul Turner <pjt@google.com>
Message-ID: <tip-8277434ef1202ce30315f8edb3fc760aa6e74493@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, seto.hidetoshi@jp.fujitsu.com, pjt@google.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        seto.hidetoshi@jp.fujitsu.com, a.p.zijlstra@chello.nl, pjt@google.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110721184757.677889157@google.com>
References: <20110721184757.677889157@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Allow for positional tg_tree walks
Git-Commit-ID: 8277434ef1202ce30315f8edb3fc760aa6e74493
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 14 Aug 2011 16:29:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8277434ef1202ce30315f8edb3fc760aa6e74493
Gitweb:     http://git.kernel.org/tip/8277434ef1202ce30315f8edb3fc760aa6e74493
Author:     Paul Turner <pjt@google.com>
AuthorDate: Thu, 21 Jul 2011 09:43:35 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 14 Aug 2011 12:03:38 +0200

sched: Allow for positional tg_tree walks

Extend walk_tg_tree to accept a positional argument

static int walk_tg_tree_from(struct task_group *from,
			     tg_visitor down, tg_visitor up, void *data)

Existing semantics are preserved, caller must hold rcu_lock() or sufficient
analogue.

Signed-off-by: Paul Turner <pjt@google.com>
Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110721184757.677889157@google.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   50 +++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 37 insertions(+), 13 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 4bbabc2..8ec1e7a 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1591,20 +1591,23 @@ static inline void dec_cpu_load(struct rq *rq, unsigned long load)
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
@@ -1613,19 +1616,29 @@ up:
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
@@ -8870,13 +8883,19 @@ static int tg_rt_schedulable(struct task_group *tg, void *data)
 
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
@@ -9333,6 +9352,7 @@ static int tg_cfs_schedulable_down(struct task_group *tg, void *data)
 
 static int __cfs_schedulable(struct task_group *tg, u64 period, u64 quota)
 {
+	int ret;
 	struct cfs_schedulable_data data = {
 		.tg = tg,
 		.period = period,
@@ -9344,7 +9364,11 @@ static int __cfs_schedulable(struct task_group *tg, u64 period, u64 quota)
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
