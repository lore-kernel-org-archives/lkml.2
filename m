Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757160Ab0JUCfo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 22:35:44 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59703 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757078Ab0JUCfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 22:35:43 -0400
Message-ID: <4CBFA712.8000007@cn.fujitsu.com>
Date: Thu, 21 Oct 2010 10:36:02 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>
CC: Nauman Rafique <nauman@google.com>, Chad Talbott <ctalbott@google.com>,
        Divyesh Shah <dpshah@google.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: [PATCH 2/4] blkio-cgroup: Add a new interface use_hierarchy
References: <4CBFA64D.6050800@cn.fujitsu.com>
In-Reply-To: <4CBFA64D.6050800@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch just adds a new interface use_hierarchy without enabling any 
functinality. Currently, "use_hierarchy" only occurs in root cgroup. 
Latter patch will make use of this interface to switch between hierarchical
mode and flat mode for cfq group scheduling.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/blk-cgroup.c  |   74 ++++++++++++++++++++++++++++++++++++++++++++++++--
 block/blk-cgroup.h  |    5 +++-
 block/cfq-iosched.c |   26 +++++++++++++++++-
 3 files changed, 100 insertions(+), 5 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 455768a..5ff5b60 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -25,7 +25,10 @@
 static DEFINE_SPINLOCK(blkio_list_lock);
 static LIST_HEAD(blkio_list);
 
-struct blkio_cgroup blkio_root_cgroup = { .weight = 2*BLKIO_WEIGHT_DEFAULT };
+struct blkio_cgroup blkio_root_cgroup = {
+		.weight = 2*BLKIO_WEIGHT_DEFAULT,
+		.use_hierarchy = 1,
+	};
 EXPORT_SYMBOL_GPL(blkio_root_cgroup);
 
 static struct cgroup_subsys_state *blkiocg_create(struct cgroup_subsys *,
@@ -433,6 +436,8 @@ void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
 		struct blkio_group *blkg, void *key, dev_t dev,
 		enum blkio_policy_id plid)
 {
+	struct hlist_node *n;
+
 	unsigned long flags;
 
 	spin_lock_irqsave(&blkcg->lock, flags);
@@ -1385,10 +1390,73 @@ struct cftype blkio_files[] = {
 #endif
 };
 
+static u64 blkiocg_use_hierarchy_read(struct cgroup *cgroup,
+				      struct cftype *cftype)
+{
+	struct blkio_cgroup *blkcg;
+
+	blkcg = cgroup_to_blkio_cgroup(cgroup);
+	return (u64)blkcg->use_hierarchy;
+}
+
+static int
+blkiocg_use_hierarchy_write(struct cgroup *cgroup,
+			    struct cftype *cftype, u64 val)
+{
+	struct blkio_cgroup *blkcg;
+	struct blkio_group *blkg;
+	struct hlist_node *n;
+	struct blkio_policy_type *blkiop;
+
+	blkcg = cgroup_to_blkio_cgroup(cgroup);
+
+	if (val > 1 || !list_empty(&cgroup->children))
+		return -EINVAL;
+
+	if (blkcg->use_hierarchy == val)
+		return 0;
+
+	spin_lock(&blkio_list_lock);
+	blkcg->use_hierarchy = val;
+
+	hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node) {
+		/*
+		 * If this policy does not own the blkg, do not change
+		 * cfq group scheduling mode.
+		 */
+		if (blkiop->plid != blkg->plid)
+			continue;
+
+		list_for_each_entry(blkiop, &blkio_list, list) {
+			if (blkiop->ops.blkio_update_use_hierarchy_fn)
+				blkiop->ops.blkio_update_use_hierarchy_fn(blkg,
+									  val);
+		}
+	}
+	spin_unlock(&blkio_list_lock);
+	return 0;
+}
+
+static struct cftype blkio_use_hierarchy = {
+	.name = "use_hierarchy",
+	.read_u64 = blkiocg_use_hierarchy_read,
+	.write_u64 = blkiocg_use_hierarchy_write,
+};
+
 static int blkiocg_populate(struct cgroup_subsys *subsys, struct cgroup *cgroup)
 {
-	return cgroup_add_files(cgroup, subsys, blkio_files,
-				ARRAY_SIZE(blkio_files));
+	int ret;
+
+	ret = cgroup_add_files(cgroup, subsys, blkio_files,
+			      ARRAY_SIZE(blkio_files));
+	if (ret)
+		return ret;
+
+	/* use_hierarchy is in root cgroup only. */
+	if (!cgroup->parent)
+		ret = cgroup_add_file(cgroup, subsys, &blkio_use_hierarchy);
+
+	return ret;
 }
 
 static void blkiocg_destroy(struct cgroup_subsys *subsys, struct cgroup *cgroup)
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index ea4861b..c8caf4e 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -105,6 +105,7 @@ enum blkcg_file_name_throtl {
 struct blkio_cgroup {
 	struct cgroup_subsys_state css;
 	unsigned int weight;
+	bool use_hierarchy;
 	spinlock_t lock;
 	struct hlist_head blkg_list;
 	struct list_head policy_list; /* list of blkio_policy_node */
@@ -200,7 +201,8 @@ typedef void (blkio_update_group_read_iops_fn) (void *key,
 			struct blkio_group *blkg, unsigned int read_iops);
 typedef void (blkio_update_group_write_iops_fn) (void *key,
 			struct blkio_group *blkg, unsigned int write_iops);
-
+typedef void (blkio_update_use_hierarchy_fn) (struct blkio_group *blkg,
+					      bool val);
 struct blkio_policy_ops {
 	blkio_unlink_group_fn *blkio_unlink_group_fn;
 	blkio_update_group_weight_fn *blkio_update_group_weight_fn;
@@ -208,6 +210,7 @@ struct blkio_policy_ops {
 	blkio_update_group_write_bps_fn *blkio_update_group_write_bps_fn;
 	blkio_update_group_read_iops_fn *blkio_update_group_read_iops_fn;
 	blkio_update_group_write_iops_fn *blkio_update_group_write_iops_fn;
+	blkio_update_use_hierarchy_fn *blkio_update_use_hierarchy_fn;
 };
 
 struct blkio_policy_type {
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 5c3953d..f781e4d 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -200,6 +200,9 @@ struct cfq_group {
 	/* Service tree for cfq_groups and cfqqs set*/
 	struct cfq_rb_root grp_service_tree;
 
+	/* parent cfq_data */
+	struct cfq_data *cfqd;
+
 	/* number of cfqq currently on this group */
 	int nr_cfqq;
 
@@ -234,6 +237,9 @@ struct cfq_data {
 	struct request_queue *queue;
 	struct cfq_group root_group;
 
+	/* cfq group schedule in flat or hierarchy manner. */
+	bool use_hierarchy;
+
 	/*
 	 * The priority currently being served
 	 */
@@ -854,7 +860,7 @@ static unsigned long cfq_slice_offset(struct cfq_data *cfqd,
 	 * just an approximation, should be ok.
 	 */
 	return (cfqq->cfqg->nr_cfqq - 1) * (cfq_prio_slice(cfqd, 1, 0) -
-		       cfq_prio_slice(cfqd, cfq_cfqq_sync(cfqq), cfqq->ioprio));
+		   cfq_prio_slice(cfqd, cfq_cfqq_sync(cfqq), cfqq->ioprio));
 }
 
 static inline s64
@@ -1119,6 +1125,15 @@ static void cfq_destroy_cfqg(struct cfq_data *cfqd, struct cfq_group *cfqg)
 	cfq_put_cfqg(cfqg);
 }
 
+void
+cfq_update_blkio_use_hierarchy(struct blkio_group *blkg, bool val)
+{
+	struct cfq_group *cfqg;
+
+	cfqg = cfqg_of_blkg(blkg);
+	cfqg->cfqd->use_hierarchy = val;
+}
+
 static void init_group_queue_entity(struct blkio_cgroup *blkcg,
 				    struct cfq_group *cfqg)
 {
@@ -1169,6 +1184,9 @@ static void init_cfqg(struct cfq_data *cfqd, struct blkio_cgroup *blkcg,
 	 */
 	atomic_set(&cfqg->ref, 1);
 
+	/* Setup cfq data for cfq group */
+	cfqg->cfqd = cfqd;
+
 	/* Add group onto cgroup list */
 	sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
 	cfq_blkiocg_add_blkio_group(blkcg, &cfqg->blkg, (void *)cfqd,
@@ -4073,6 +4091,7 @@ static void *cfq_init_queue(struct request_queue *q)
 
 	/* Init root group */
 	cfqg = &cfqd->root_group;
+	cfqg->cfqd = cfqd;
 	cfqg->grp_service_tree = CFQ_RB_ROOT;
 	for_each_cfqg_st(cfqg, i, j, st)
 		*st = CFQ_RB_ROOT;
@@ -4142,6 +4161,10 @@ static void *cfq_init_queue(struct request_queue *q)
 	cfqd->cfq_latency = 1;
 	cfqd->cfq_group_isolation = 0;
 	cfqd->hw_tag = -1;
+
+	/* hierarchical scheduling for cfq group by default */
+	cfqd->use_hierarchy = 1;
+
 	/*
 	 * we optimistically start assuming sync ops weren't delayed in last
 	 * second, in order to have larger depth for async operations.
@@ -4304,6 +4327,7 @@ static struct blkio_policy_type blkio_policy_cfq = {
 	.ops = {
 		.blkio_unlink_group_fn =	cfq_unlink_blkio_group,
 		.blkio_update_group_weight_fn =	cfq_update_blkio_group_weight,
+		.blkio_update_use_hierarchy_fn = cfq_update_blkio_use_hierarchy,
 	},
 	.plid = BLKIO_POLICY_PROP,
 };
-- 1.6.5.2 
