Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176Ab2L1Ugr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 15:36:47 -0500
Received: from mail-da0-f51.google.com ([209.85.210.51]:51158 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754795Ab2L1Ugm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 15:36:42 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com, axboe@kernel.dk, vgoyal@redhat.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, ctalbott@google.com, rni@google.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 19/24] blkcg: implement blkg_[rw]stat_recursive_sum() and blkg_[rw]stat_merge()
Date: Fri, 28 Dec 2012 12:35:41 -0800
Message-Id: <1356726946-26037-20-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1356726946-26037-1-git-send-email-tj@kernel.org>
References: <1356726946-26037-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement blkg_[rw]stat_recursive_sum() and blkg_[rw]stat_merge().
The former two collect the [rw]stats designated by the target policy
data and offset from the pd's subtree.  The latter two add one
[rw]stat to another.

Note that the recursive sum functions require the queue lock to be
held on entry to make blkg online test reliable.  This is necessary to
properly handle stats of a dying blkg.

These will be used to implement hierarchical stats.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-cgroup.c | 107 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 block/blk-cgroup.h |  35 ++++++++++++++++++
 2 files changed, 142 insertions(+)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 4d625d2..a1a4b97 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -32,6 +32,26 @@ EXPORT_SYMBOL_GPL(blkcg_root);
 
 static struct blkcg_policy *blkcg_policy[BLKCG_MAX_POLS];
 
+static struct blkcg_gq *__blkg_lookup(struct blkcg *blkcg,
+				      struct request_queue *q, bool update_hint);
+
+/**
+ * blkg_for_each_descendant_pre - pre-order walk of a blkg's descendants
+ * @d_blkg: loop cursor pointing to the current descendant
+ * @pos_cgrp: used for iteration
+ * @p_blkg: target blkg to walk descendants of
+ *
+ * Walk @c_blkg through the descendants of @p_blkg.  Must be used with RCU
+ * read locked.  If called under either blkcg or queue lock, the iteration
+ * is guaranteed to include all and only online blkgs.  The caller may
+ * update @pos_cgrp by calling cgroup_rightmost_descendant() to skip
+ * subtree.
+ */
+#define blkg_for_each_descendant_pre(d_blkg, pos_cgrp, p_blkg)		\
+	cgroup_for_each_descendant_pre((pos_cgrp), (p_blkg)->blkcg->css.cgroup) \
+		if (((d_blkg) = __blkg_lookup(cgroup_to_blkcg(pos_cgrp), \
+					      (p_blkg)->q, false)))
+
 static bool blkcg_policy_enabled(struct request_queue *q,
 				 const struct blkcg_policy *pol)
 {
@@ -127,6 +147,17 @@ err_free:
 	return NULL;
 }
 
+/**
+ * __blkg_lookup - internal version of blkg_lookup()
+ * @blkcg: blkcg of interest
+ * @q: request_queue of interest
+ * @update_hint: whether to update lookup hint with the result or not
+ *
+ * This is internal version and shouldn't be used by policy
+ * implementations.  Looks up blkgs for the @blkcg - @q pair regardless of
+ * @q's bypass state.  If @update_hint is %true, the caller should be
+ * holding @q->queue_lock and lookup hint is updated on success.
+ */
 static struct blkcg_gq *__blkg_lookup(struct blkcg *blkcg,
 				      struct request_queue *q, bool update_hint)
 {
@@ -585,6 +616,82 @@ u64 blkg_prfill_rwstat(struct seq_file *sf, struct blkg_policy_data *pd,
 EXPORT_SYMBOL_GPL(blkg_prfill_rwstat);
 
 /**
+ * blkg_stat_recursive_sum - collect hierarchical blkg_stat
+ * @pd: policy private data of interest
+ * @off: offset to the blkg_stat in @pd
+ *
+ * Collect the blkg_stat specified by @off from @pd and all its online
+ * descendants and return the sum.  The caller must be holding the queue
+ * lock for online tests.
+ */
+u64 blkg_stat_recursive_sum(struct blkg_policy_data *pd, int off)
+{
+	struct blkcg_policy *pol = blkcg_policy[pd->plid];
+	struct blkcg_gq *pos_blkg;
+	struct cgroup *pos_cgrp;
+	u64 sum;
+
+	lockdep_assert_held(pd->blkg->q->queue_lock);
+
+	sum = blkg_stat_read((void *)pd + off);
+
+	rcu_read_lock();
+	blkg_for_each_descendant_pre(pos_blkg, pos_cgrp, pd_to_blkg(pd)) {
+		struct blkg_policy_data *pos_pd = blkg_to_pd(pos_blkg, pol);
+		struct blkg_stat *stat = (void *)pos_pd + off;
+
+		if (pos_blkg->online)
+			sum += blkg_stat_read(stat);
+	}
+	rcu_read_unlock();
+
+	return sum;
+}
+EXPORT_SYMBOL_GPL(blkg_stat_recursive_sum);
+
+/**
+ * blkg_rwstat_recursive_sum - collect hierarchical blkg_rwstat
+ * @pd: policy private data of interest
+ * @off: offset to the blkg_stat in @pd
+ *
+ * Collect the blkg_rwstat specified by @off from @pd and all its online
+ * descendants and return the sum.  The caller must be holding the queue
+ * lock for online tests.
+ */
+struct blkg_rwstat blkg_rwstat_recursive_sum(struct blkg_policy_data *pd,
+					     int off)
+{
+	struct blkcg_policy *pol = blkcg_policy[pd->plid];
+	struct blkcg_gq *pos_blkg;
+	struct cgroup *pos_cgrp;
+	struct blkg_rwstat sum;
+	int i;
+
+	lockdep_assert_held(pd->blkg->q->queue_lock);
+
+	sum = blkg_rwstat_read((void *)pd + off);
+
+	rcu_read_lock();
+	blkg_for_each_descendant_pre(pos_blkg, pos_cgrp, pd_to_blkg(pd)) {
+		struct blkg_policy_data *pos_pd = blkg_to_pd(pos_blkg, pol);
+		struct blkg_rwstat *rwstat = (void *)pos_pd + off;
+		struct blkg_rwstat tmp;
+
+		if (!pos_blkg->online)
+			continue;
+
+		tmp = blkg_rwstat_read(rwstat);
+
+		for (i = 0; i < BLKG_RWSTAT_NR; i++)
+			sum.cnt[i] += tmp.cnt[i];
+	}
+	rcu_read_unlock();
+
+	return sum;
+}
+EXPORT_SYMBOL_GPL(blkg_rwstat_recursive_sum);
+
+/**
  * blkg_conf_prep - parse and prepare for per-blkg config update
  * @blkcg: target block cgroup
  * @pol: target policy
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 586c0ac..f2b2929 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -164,6 +164,10 @@ u64 blkg_prfill_stat(struct seq_file *sf, struct blkg_policy_data *pd, int off);
 u64 blkg_prfill_rwstat(struct seq_file *sf, struct blkg_policy_data *pd,
 		       int off);
 
+u64 blkg_stat_recursive_sum(struct blkg_policy_data *pd, int off);
+struct blkg_rwstat blkg_rwstat_recursive_sum(struct blkg_policy_data *pd,
+					     int off);
+
 struct blkg_conf_ctx {
 	struct gendisk			*disk;
 	struct blkcg_gq			*blkg;
@@ -414,6 +418,18 @@ static inline void blkg_stat_reset(struct blkg_stat *stat)
 }
 
 /**
+ * blkg_stat_merge - merge a blkg_stat into another
+ * @to: the destination blkg_stat
+ * @from: the source
+ *
+ * Add @from's count to @to.
+ */
+static inline void blkg_stat_merge(struct blkg_stat *to, struct blkg_stat *from)
+{
+	blkg_stat_add(to, blkg_stat_read(from));
+}
+
+/**
  * blkg_rwstat_add - add a value to a blkg_rwstat
  * @rwstat: target blkg_rwstat
  * @rw: mask of REQ_{WRITE|SYNC}
@@ -484,6 +500,25 @@ static inline void blkg_rwstat_reset(struct blkg_rwstat *rwstat)
 	memset(rwstat->cnt, 0, sizeof(rwstat->cnt));
 }
 
+/**
+ * blkg_rwstat_merge - merge a blkg_rwstat into another
+ * @to: the destination blkg_rwstat
+ * @from: the source
+ *
+ * Add @from's counts to @to.
+ */
+static inline void blkg_rwstat_merge(struct blkg_rwstat *to,
+				     struct blkg_rwstat *from)
+{
+	struct blkg_rwstat v = blkg_rwstat_read(from);
+	int i;
+
+	u64_stats_update_begin(&to->syncp);
+	for (i = 0; i < BLKG_RWSTAT_NR; i++)
+		to->cnt[i] += v.cnt[i];
+	u64_stats_update_end(&to->syncp);
+}
+
 #else	/* CONFIG_BLK_CGROUP */
 
 struct cgroup;
-- 
1.8.0.2

