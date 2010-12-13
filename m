Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146Ab0LMBot (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 20:44:49 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52112 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756540Ab0LMBoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 20:44:46 -0500
Message-ID: <4D057AA3.8050308@cn.fujitsu.com>
Date: Mon, 13 Dec 2010 09:45:07 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>
CC: Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        Chad Talbott <ctalbott@google.com>, Nauman Rafique <nauman@google.com>,
        Divyesh Shah <dpshah@google.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/8] blkio-cgroup: "use_hierarchy" interface without any functionality.
References: <4CDF7BC5.9080803@cn.fujitsu.com> <4CDF9CC6.2040106@cn.fujitsu.com> <20101115165319.GI30792@redhat.com> <4CE2718C.6010406@kernel.dk> <4D01C6AB.9040807@cn.fujitsu.com>
In-Reply-To: <4D01C6AB.9040807@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-13 09:44:43,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-13 09:44:46,
	Serialize complete at 2010-12-13 09:44:46
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds "use_hierarchy" in Root CGroup with out any functionality.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/blk-cgroup.c  |   72 ++++++++++++++++++++++++++++++++++++++++++++++++--
 block/blk-cgroup.h  |    5 +++-
 block/cfq-iosched.c |   24 +++++++++++++++++
 3 files changed, 97 insertions(+), 4 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 455768a..9747ebb 100644
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
@@ -1385,10 +1388,73 @@ struct cftype blkio_files[] = {
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
+		list_for_each_entry(blkiop, &blkio_list, list) {
+			/*
+			 * If this policy does not own the blkg, do not change
+			 * cfq group scheduling mode.
+			 */
+			if (blkiop->plid != blkg->plid)
+				continue;
+
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
index d90627e..08323f5 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -192,6 +192,9 @@ struct cfq_group {
 	/* cfq group sched entity */
 	struct cfq_entity cfqe;
 
+	/* parent cfq_data */
+	struct cfq_data *cfqd;
+
 	/* number of cfqq currently on this group */
 	int nr_cfqq;
 
@@ -235,6 +238,9 @@ struct cfq_data {
 	struct request_queue *queue;
 	struct cfq_group root_group;
 
+	/* cfq group schedule in flat or hierarchy manner. */
+	bool use_hierarchy;
+
 	/*
 	 * The priority currently being served
 	 */
@@ -1091,6 +1097,15 @@ void cfq_update_blkio_group_weight(void *key, struct blkio_group *blkg,
 	cfqg_of_blkg(blkg)->cfqe.weight = weight;
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
 static void init_cfqe(struct blkio_cgroup *blkcg,
 				    struct cfq_group *cfqg)
 {
@@ -1121,6 +1136,9 @@ static void init_cfqg(struct cfq_data *cfqd, struct blkio_cgroup *blkcg,
 	 */
 	atomic_set(&cfqg->ref, 1);
 
+	/* Setup cfq data for cfq group */
+	cfqg->cfqd = cfqd;
+
 	/* Add group onto cgroup list */
 	sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
 	cfq_blkiocg_add_blkio_group(blkcg, &cfqg->blkg, (void *)cfqd,
@@ -4164,6 +4182,7 @@ static void *cfq_init_queue(struct request_queue *q)
 
 	/* Init root group */
 	cfqg = &cfqd->root_group;
+	cfqg->cfqd = cfqd;
 	for_each_cfqg_st(cfqg, i, j, st)
 		*st = CFQ_RB_ROOT;
 	RB_CLEAR_NODE(&cfqg->cfqe.rb_node);
@@ -4224,6 +4243,10 @@ static void *cfq_init_queue(struct request_queue *q)
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
@@ -4386,6 +4409,7 @@ static struct blkio_policy_type blkio_policy_cfq = {
 	.ops = {
 		.blkio_unlink_group_fn =	cfq_unlink_blkio_group,
 		.blkio_update_group_weight_fn =	cfq_update_blkio_group_weight,
+		.blkio_update_use_hierarchy_fn = cfq_update_blkio_use_hierarchy,
 	},
 	.plid = BLKIO_POLICY_PROP,
 };
-- 
1.6.5.2




