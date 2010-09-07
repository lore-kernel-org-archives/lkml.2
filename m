Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758379Ab0IGUx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 16:53:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57689 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758318Ab0IGUx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 16:53:28 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk
Cc: nauman@google.com, dpshah@google.com, guijianfeng@cn.fujitsu.com,
        vgoyal@redhat.com
Subject: [PATCH 2/4] blkio: blkio cgroup interface related changes to support new throttling policy
Date: Tue,  7 Sep 2010 16:53:06 -0400
Message-Id: <1283892788-4751-3-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1283892788-4751-1-git-send-email-vgoyal@redhat.com>
References: <1283892788-4751-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o Changes to blkio controller cgroup interface to accomodate more than one
  policy. New policy being introduced is throttling.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c |  697 ++++++++++++++++++++++++++++++++++++++++------------
 block/blk-cgroup.h |   75 ++++++-
 block/cfq.h        |    2 +-
 3 files changed, 618 insertions(+), 156 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index c1a39d9..004aeb3 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -37,6 +37,12 @@ static void blkiocg_attach(struct cgroup_subsys *, struct cgroup *,
 static void blkiocg_destroy(struct cgroup_subsys *, struct cgroup *);
 static int blkiocg_populate(struct cgroup_subsys *, struct cgroup *);
 
+/* for encoding cft->private value on file */
+#define BLKIOFILE_PRIVATE(x, val)	(((x) << 16) | (val))
+/* What policy owns the file, proportional or throttle */
+#define BLKIOFILE_POLICY(val)		(((val) >> 16) & 0xffff)
+#define BLKIOFILE_ATTR(val)		((val) & 0xffff)
+
 struct cgroup_subsys blkio_subsys = {
 	.name = "blkio",
 	.create = blkiocg_create,
@@ -65,14 +71,55 @@ static inline void blkio_policy_delete_node(struct blkio_policy_node *pn)
 	list_del(&pn->node);
 }
 
+static inline bool cftype_blkg_same_policy(struct cftype *cft,
+			struct blkio_group *blkg)
+{
+	enum blkio_policy_id plid = BLKIOFILE_POLICY(cft->private);
+
+	if (blkg->plid == plid)
+		return 1;
+
+	return 0;
+}
+
+/* Determines if policy node matches cgroup file being accessed */
+static inline bool pn_matches_cftype(struct cftype *cft,
+			struct blkio_policy_node *pn)
+{
+	enum blkio_policy_id plid = BLKIOFILE_POLICY(cft->private);
+	int name = BLKIOFILE_ATTR(cft->private);
+
+	if (plid != pn->plid)
+		return 0;
+
+	if (plid == BLKIO_POLICY_PROP) {
+		switch(name) {
+		case BLKIO_PROP_weight_device:
+			return (pn->rulet == BLKIO_RULE_WEIGHT);
+		}
+	}
+
+	if (plid == BLKIO_POLICY_THROTL) {
+		switch(name) {
+		case BLKIO_THROTL_read_bps_device:
+			return (pn->rulet == BLKIO_RULE_READ);
+		case BLKIO_THROTL_write_bps_device:
+			return (pn->rulet == BLKIO_RULE_WRITE);
+		}
+	}
+
+	return 0;
+}
+
 /* Must be called with blkcg->lock held */
 static struct blkio_policy_node *
-blkio_policy_search_node(const struct blkio_cgroup *blkcg, dev_t dev)
+blkio_policy_search_node(const struct blkio_cgroup *blkcg, dev_t dev,
+		enum blkio_policy_id plid, enum blkio_rule_type rulet)
 {
 	struct blkio_policy_node *pn;
 
 	list_for_each_entry(pn, &blkcg->policy_list, node) {
-		if (pn->dev == dev)
+		if (pn->dev == dev && pn->plid == plid && pn->rulet == rulet)
 			return pn;
 	}
 
@@ -86,6 +133,33 @@ struct blkio_cgroup *cgroup_to_blkio_cgroup(struct cgroup *cgroup)
 }
 EXPORT_SYMBOL_GPL(cgroup_to_blkio_cgroup);
 
+static inline void
+blkio_update_group_weight(struct blkio_group *blkg, unsigned int weight)
+{
+	struct blkio_policy_type *blkiop;
+
+	list_for_each_entry(blkiop, &blkio_list, list) {
+		if (blkiop->ops.blkio_update_group_weight_fn)
+			blkiop->ops.blkio_update_group_weight_fn(blkg, weight);
+	}
+}
+
+static inline void blkio_update_group_bps(struct blkio_group *blkg, u64 bps,
+				enum blkio_rule_type rulet)
+{
+	struct blkio_policy_type *blkiop;
+
+	list_for_each_entry(blkiop, &blkio_list, list) {
+		if (rulet == BLKIO_RULE_READ
+		    && blkiop->ops.blkio_update_group_read_bps_fn)
+			blkiop->ops.blkio_update_group_read_bps_fn(blkg, bps);
+
+		if (rulet == BLKIO_RULE_WRITE
+		    && blkiop->ops.blkio_update_group_write_bps_fn)
+			blkiop->ops.blkio_update_group_write_bps_fn(blkg, bps);
+	}
+}
+
 /*
  * Add to the appropriate stat variable depending on the request type.
  * This should be called with the blkg->stats_lock held.
@@ -341,7 +415,8 @@ void blkiocg_update_io_merged_stats(struct blkio_group *blkg, bool direction,
 EXPORT_SYMBOL_GPL(blkiocg_update_io_merged_stats);
 
 void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
-			struct blkio_group *blkg, void *key, dev_t dev)
+		struct blkio_group *blkg, void *key, dev_t dev,
+		enum blkio_policy_id plid)
 {
 	unsigned long flags;
 
@@ -350,6 +425,7 @@ void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
 	rcu_assign_pointer(blkg->key, key);
 	blkg->blkcg_id = css_id(&blkcg->css);
 	hlist_add_head_rcu(&blkg->blkcg_node, &blkcg->blkg_list);
+	blkg->plid = plid;
 	spin_unlock_irqrestore(&blkcg->lock, flags);
 	/* Need to take css reference ? */
 	cgroup_path(blkcg->css.cgroup, blkg->path, sizeof(blkg->path));
@@ -408,51 +484,6 @@ struct blkio_group *blkiocg_lookup_group(struct blkio_cgroup *blkcg, void *key)
 }
 EXPORT_SYMBOL_GPL(blkiocg_lookup_group);
 
-#define SHOW_FUNCTION(__VAR)						\
-static u64 blkiocg_##__VAR##_read(struct cgroup *cgroup,		\
-				       struct cftype *cftype)		\
-{									\
-	struct blkio_cgroup *blkcg;					\
-									\
-	blkcg = cgroup_to_blkio_cgroup(cgroup);				\
-	return (u64)blkcg->__VAR;					\
-}
-
-SHOW_FUNCTION(weight);
-#undef SHOW_FUNCTION
-
-static int
-blkiocg_weight_write(struct cgroup *cgroup, struct cftype *cftype, u64 val)
-{
-	struct blkio_cgroup *blkcg;
-	struct blkio_group *blkg;
-	struct hlist_node *n;
-	struct blkio_policy_type *blkiop;
-	struct blkio_policy_node *pn;
-
-	if (val < BLKIO_WEIGHT_MIN || val > BLKIO_WEIGHT_MAX)
-		return -EINVAL;
-
-	blkcg = cgroup_to_blkio_cgroup(cgroup);
-	spin_lock(&blkio_list_lock);
-	spin_lock_irq(&blkcg->lock);
-	blkcg->weight = (unsigned int)val;
-
-	hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node) {
-		pn = blkio_policy_search_node(blkcg, blkg->dev);
-
-		if (pn)
-			continue;
-
-		list_for_each_entry(blkiop, &blkio_list, list)
-			blkiop->ops.blkio_update_group_weight_fn(blkg,
-					blkcg->weight);
-	}
-	spin_unlock_irq(&blkcg->lock);
-	spin_unlock(&blkio_list_lock);
-	return 0;
-}
-
 static int
 blkiocg_reset_stats(struct cgroup *cgroup, struct cftype *cftype, u64 val)
 {
@@ -593,52 +624,6 @@ static uint64_t blkio_get_stat(struct blkio_group *blkg,
 	return disk_total;
 }
 
-#define SHOW_FUNCTION_PER_GROUP(__VAR, type, show_total)		\
-static int blkiocg_##__VAR##_read(struct cgroup *cgroup,		\
-		struct cftype *cftype, struct cgroup_map_cb *cb)	\
-{									\
-	struct blkio_cgroup *blkcg;					\
-	struct blkio_group *blkg;					\
-	struct hlist_node *n;						\
-	uint64_t cgroup_total = 0;					\
-									\
-	if (!cgroup_lock_live_group(cgroup))				\
-		return -ENODEV;						\
-									\
-	blkcg = cgroup_to_blkio_cgroup(cgroup);				\
-	rcu_read_lock();						\
-	hlist_for_each_entry_rcu(blkg, n, &blkcg->blkg_list, blkcg_node) {\
-		if (blkg->dev) {					\
-			spin_lock_irq(&blkg->stats_lock);		\
-			cgroup_total += blkio_get_stat(blkg, cb,	\
-						blkg->dev, type);	\
-			spin_unlock_irq(&blkg->stats_lock);		\
-		}							\
-	}								\
-	if (show_total)							\
-		cb->fill(cb, "Total", cgroup_total);			\
-	rcu_read_unlock();						\
-	cgroup_unlock();						\
-	return 0;							\
-}
-
-SHOW_FUNCTION_PER_GROUP(time, BLKIO_STAT_TIME, 0);
-SHOW_FUNCTION_PER_GROUP(sectors, BLKIO_STAT_SECTORS, 0);
-SHOW_FUNCTION_PER_GROUP(io_service_bytes, BLKIO_STAT_SERVICE_BYTES, 1);
-SHOW_FUNCTION_PER_GROUP(io_serviced, BLKIO_STAT_SERVICED, 1);
-SHOW_FUNCTION_PER_GROUP(io_service_time, BLKIO_STAT_SERVICE_TIME, 1);
-SHOW_FUNCTION_PER_GROUP(io_wait_time, BLKIO_STAT_WAIT_TIME, 1);
-SHOW_FUNCTION_PER_GROUP(io_merged, BLKIO_STAT_MERGED, 1);
-SHOW_FUNCTION_PER_GROUP(io_queued, BLKIO_STAT_QUEUED, 1);
-#ifdef CONFIG_DEBUG_BLK_CGROUP
-SHOW_FUNCTION_PER_GROUP(dequeue, BLKIO_STAT_DEQUEUE, 0);
-SHOW_FUNCTION_PER_GROUP(avg_queue_size, BLKIO_STAT_AVG_QUEUE_SIZE, 0);
-SHOW_FUNCTION_PER_GROUP(group_wait_time, BLKIO_STAT_GROUP_WAIT_TIME, 0);
-SHOW_FUNCTION_PER_GROUP(idle_time, BLKIO_STAT_IDLE_TIME, 0);
-SHOW_FUNCTION_PER_GROUP(empty_time, BLKIO_STAT_EMPTY_TIME, 0);
-#endif
-#undef SHOW_FUNCTION_PER_GROUP
-
 static int blkio_check_dev_num(dev_t dev)
 {
 	int part = 0;
@@ -652,11 +637,13 @@ static int blkio_check_dev_num(dev_t dev)
 }
 
 static int blkio_policy_parse_and_set(char *buf,
-				      struct blkio_policy_node *newpn)
+	struct blkio_policy_node *newpn, enum blkio_policy_id plid,
+	enum blkio_rule_type rulet)
 {
 	char *s[4], *p, *major_s = NULL, *minor_s = NULL;
 	int ret;
 	unsigned long major, minor, temp;
+	u64 bps;
 	int i = 0;
 	dev_t dev;
 
@@ -705,12 +692,26 @@ static int blkio_policy_parse_and_set(char *buf,
 	if (s[1] == NULL)
 		return -EINVAL;
 
-	ret = strict_strtoul(s[1], 10, &temp);
-	if (ret || (temp < BLKIO_WEIGHT_MIN && temp > 0) ||
-	    temp > BLKIO_WEIGHT_MAX)
-		return -EINVAL;
+	switch (plid) {
+	case BLKIO_POLICY_PROP:
+		ret = strict_strtoul(s[1], 10, &temp);
+		if (ret || (temp < BLKIO_WEIGHT_MIN && temp > 0) ||
+	    	    temp > BLKIO_WEIGHT_MAX)
+			return -EINVAL;
 
-	newpn->weight =  temp;
+		newpn->plid = plid;
+		newpn->rulet = rulet;
+		newpn->val.weight = temp;
+		break;
+	case BLKIO_POLICY_THROTL:
+		ret = strict_strtoull(s[1], 10, &bps);
+		if (ret)
+			return -EINVAL;
+
+		newpn->plid = plid;
+		newpn->rulet = rulet;
+		newpn->val.bps = bps;
+	}
 
 	return 0;
 }
@@ -720,26 +721,121 @@ unsigned int blkcg_get_weight(struct blkio_cgroup *blkcg,
 {
 	struct blkio_policy_node *pn;
 
-	pn = blkio_policy_search_node(blkcg, dev);
+	pn = blkio_policy_search_node(blkcg, dev, BLKIO_POLICY_PROP,
+				BLKIO_RULE_WEIGHT);
 	if (pn)
-		return pn->weight;
+		return pn->val.weight;
 	else
 		return blkcg->weight;
 }
 EXPORT_SYMBOL_GPL(blkcg_get_weight);
 
+uint64_t blkcg_get_read_bps(struct blkio_cgroup *blkcg, dev_t dev)
+{
+	struct blkio_policy_node *pn;
+
+	pn = blkio_policy_search_node(blkcg, dev, BLKIO_POLICY_THROTL,
+				BLKIO_RULE_READ);
+	if (pn)
+		return pn->val.bps;
+	else
+		return -1;
+}
+EXPORT_SYMBOL_GPL(blkcg_get_read_bps);
 
-static int blkiocg_weight_device_write(struct cgroup *cgrp, struct cftype *cft,
-				       const char *buffer)
+uint64_t blkcg_get_write_bps(struct blkio_cgroup *blkcg, dev_t dev)
+{
+	struct blkio_policy_node *pn;
+	pn = blkio_policy_search_node(blkcg, dev, BLKIO_POLICY_THROTL,
+				BLKIO_RULE_WRITE);
+	if (pn)
+		return pn->val.bps;
+	else
+		return -1;
+}
+EXPORT_SYMBOL_GPL(blkcg_get_write_bps);
+
+/* Checks whether user asked for deleting a policy rule */
+static bool blkio_delete_rule_command(struct blkio_policy_node *pn)
+{
+	switch(pn->plid) {
+	case BLKIO_POLICY_PROP:
+		if (pn->val.weight == 0)
+			return 1;
+		break;
+	case BLKIO_POLICY_THROTL:
+		if (pn->val.bps == 0)
+			return 1;
+		break;
+	default:
+		BUG();
+	}
+
+	return 0;
+}
+
+static void blkio_update_policy_rule(struct blkio_policy_node *oldpn,
+					struct blkio_policy_node *newpn)
+{
+	switch(oldpn->plid) {
+	case BLKIO_POLICY_PROP:
+		oldpn->val.weight = newpn->val.weight;
+		break;
+	case BLKIO_POLICY_THROTL:
+		oldpn->val.bps = newpn->val.bps;
+		break;
+	default:
+		BUG();
+	}
+}
+
+/*
+ * A policy node rule has been updated. Propogate this update to all the
+ * block groups which might be affected by this update.
+ */
+static void blkio_update_policy_node_blkg(struct blkio_cgroup *blkcg,
+				struct blkio_policy_node *pn)
+{
+	struct blkio_group *blkg;
+	struct hlist_node *n;
+	enum blkio_rule_type rulet = pn->rulet;
+	unsigned int weight;
+	u64 bps;
+
+	spin_lock(&blkio_list_lock);
+	spin_lock_irq(&blkcg->lock);
+
+	hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node) {
+		if (pn->dev == blkg->dev) {
+			if (pn->plid == BLKIO_POLICY_PROP) {
+				weight = pn->val.weight ? pn->val.weight :
+						blkcg->weight;
+				blkio_update_group_weight(blkg, weight);
+			} else {
+
+				bps = pn->val.bps ? pn->val.bps : (-1);
+				blkio_update_group_bps(blkg, bps, rulet);
+			}
+		}
+	}
+
+	spin_unlock_irq(&blkcg->lock);
+	spin_unlock(&blkio_list_lock);
+
+}
+
+
+static int blkiocg_file_write(struct cgroup *cgrp, struct cftype *cft,
+ 				       const char *buffer)
 {
 	int ret = 0;
 	char *buf;
 	struct blkio_policy_node *newpn, *pn;
 	struct blkio_cgroup *blkcg;
-	struct blkio_group *blkg;
 	int keep_newpn = 0;
-	struct hlist_node *n;
-	struct blkio_policy_type *blkiop;
+	enum blkio_policy_id plid = BLKIOFILE_POLICY(cft->private);
+	int name = BLKIOFILE_ATTR(cft->private);
+	enum blkio_rule_type rulet;
 
 	buf = kstrdup(buffer, GFP_KERNEL);
 	if (!buf)
@@ -751,7 +847,30 @@ static int blkiocg_weight_device_write(struct cgroup *cgrp, struct cftype *cft,
 		goto free_buf;
 	}
 
-	ret = blkio_policy_parse_and_set(buf, newpn);
+	switch (plid) {
+	case BLKIO_POLICY_PROP:
+		if (name == BLKIO_PROP_weight_device) {
+			rulet = BLKIO_RULE_WEIGHT;
+			ret = blkio_policy_parse_and_set(buf, newpn, plid, 0);
+		} else
+			BUG();
+		break;
+	case BLKIO_POLICY_THROTL:
+		if (name == BLKIO_THROTL_read_bps_device) {
+			rulet = BLKIO_RULE_READ;
+			ret = blkio_policy_parse_and_set(buf, newpn, plid,
+					rulet);
+		} else if (name == BLKIO_THROTL_write_bps_device) {
+			rulet = BLKIO_RULE_WRITE;
+			ret = blkio_policy_parse_and_set(buf, newpn, plid,
+					rulet);
+		} else
+			BUG();
+		break;
+	default:
+		BUG();
+	}
+
 	if (ret)
 		goto free_newpn;
 
@@ -759,9 +878,9 @@ static int blkiocg_weight_device_write(struct cgroup *cgrp, struct cftype *cft,
 
 	spin_lock_irq(&blkcg->lock);
 
-	pn = blkio_policy_search_node(blkcg, newpn->dev);
+	pn = blkio_policy_search_node(blkcg, newpn->dev, plid, rulet);
 	if (!pn) {
-		if (newpn->weight != 0) {
+		if (!blkio_delete_rule_command(newpn)) {
 			blkio_policy_insert_node(blkcg, newpn);
 			keep_newpn = 1;
 		}
@@ -769,33 +888,17 @@ static int blkiocg_weight_device_write(struct cgroup *cgrp, struct cftype *cft,
 		goto update_io_group;
 	}
 
-	if (newpn->weight == 0) {
-		/* weight == 0 means deleteing a specific weight */
+	if (blkio_delete_rule_command(newpn)) {
 		blkio_policy_delete_node(pn);
 		spin_unlock_irq(&blkcg->lock);
 		goto update_io_group;
 	}
 	spin_unlock_irq(&blkcg->lock);
 
-	pn->weight = newpn->weight;
+	blkio_update_policy_rule(pn, newpn);
 
 update_io_group:
-	/* update weight for each cfqg */
-	spin_lock(&blkio_list_lock);
-	spin_lock_irq(&blkcg->lock);
-
-	hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node) {
-		if (newpn->dev == blkg->dev) {
-			list_for_each_entry(blkiop, &blkio_list, list)
-				blkiop->ops.blkio_update_group_weight_fn(blkg,
-							 newpn->weight ?
-							 newpn->weight :
-							 blkcg->weight);
-		}
-	}
-
-	spin_unlock_irq(&blkcg->lock);
-	spin_unlock(&blkio_list_lock);
+	blkio_update_policy_node_blkg(blkcg, newpn);
 
 free_newpn:
 	if (!keep_newpn)
@@ -805,21 +908,251 @@ free_buf:
 	return ret;
 }
 
-static int blkiocg_weight_device_read(struct cgroup *cgrp, struct cftype *cft,
-				      struct seq_file *m)
+static void
+blkio_print_policy_node(struct seq_file *m, struct blkio_policy_node *pn)
+{
+	switch(pn->plid) {
+		case BLKIO_POLICY_PROP:
+			if (pn->rulet == BLKIO_RULE_WEIGHT)
+				seq_printf(m, "%u:%u\t%u\n", MAJOR(pn->dev),
+					MINOR(pn->dev), pn->val.weight);
+			break;
+		case BLKIO_POLICY_THROTL:
+			if (pn->rulet == BLKIO_RULE_READ)
+				seq_printf(m, "%u:%u\t%llu\n", MAJOR(pn->dev),
+					MINOR(pn->dev), pn->val.bps);
+			else if (pn->rulet == BLKIO_RULE_WRITE)
+				seq_printf(m, "%u:%u\t%llu\n", MAJOR(pn->dev),
+					MINOR(pn->dev), pn->val.bps);
+			else
+				BUG();
+			break;
+		default:
+			BUG();
+	}
+}
+
+/* cgroup files which read their data from policy nodes end up here */
+static void blkio_read_policy_node_files(struct cftype *cft,
+			struct blkio_cgroup *blkcg, struct seq_file *m)
 {
-	struct blkio_cgroup *blkcg;
 	struct blkio_policy_node *pn;
 
-	blkcg = cgroup_to_blkio_cgroup(cgrp);
 	if (!list_empty(&blkcg->policy_list)) {
 		spin_lock_irq(&blkcg->lock);
 		list_for_each_entry(pn, &blkcg->policy_list, node) {
-			seq_printf(m, "%u:%u\t%u\n", MAJOR(pn->dev),
-				   MINOR(pn->dev), pn->weight);
+			if (!pn_matches_cftype(cft, pn))
+				continue;
+			blkio_print_policy_node(m, pn);
 		}
 		spin_unlock_irq(&blkcg->lock);
 	}
+}
+
+static int blkiocg_file_read(struct cgroup *cgrp, struct cftype *cft,
+				struct seq_file *m)
+{
+	struct blkio_cgroup *blkcg;
+	enum blkio_policy_id plid = BLKIOFILE_POLICY(cft->private);
+	int name = BLKIOFILE_ATTR(cft->private);
+
+	blkcg = cgroup_to_blkio_cgroup(cgrp);
+
+	switch(plid) {
+	case BLKIO_POLICY_PROP:
+		switch(name) {
+		case BLKIO_PROP_weight_device:
+			blkio_read_policy_node_files(cft, blkcg, m);
+			return 0;
+		default:
+			BUG();
+		}
+		break;
+	case BLKIO_POLICY_THROTL:
+		switch(name){
+		case BLKIO_THROTL_read_bps_device:
+		case BLKIO_THROTL_write_bps_device:
+			blkio_read_policy_node_files(cft, blkcg, m);
+			return 0;
+		default:
+			BUG();
+		}
+		break;
+	default:
+		BUG();
+	}
+
+	return 0;
+}
+
+static int blkio_read_blkg_stats(struct blkio_cgroup *blkcg,
+		struct cftype *cft, struct cgroup_map_cb *cb, enum stat_type type,
+		bool show_total)
+{
+	struct blkio_group *blkg;
+	struct hlist_node *n;
+	uint64_t cgroup_total = 0;
+
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(blkg, n, &blkcg->blkg_list, blkcg_node) {
+		if (blkg->dev) {
+			if (!cftype_blkg_same_policy(cft, blkg))
+				continue;
+			spin_lock_irq(&blkg->stats_lock);
+			cgroup_total += blkio_get_stat(blkg, cb, blkg->dev,
+						type);
+			spin_unlock_irq(&blkg->stats_lock);
+		}
+	}
+	if (show_total)
+		cb->fill(cb, "Total", cgroup_total);
+	rcu_read_unlock();
+	return 0;
+}
+
+/* All map kind of cgroup file get serviced by this function */
+static int blkiocg_file_read_map(struct cgroup *cgrp, struct cftype *cft,
+				struct cgroup_map_cb *cb)
+{
+	struct blkio_cgroup *blkcg;
+	enum blkio_policy_id plid = BLKIOFILE_POLICY(cft->private);
+	int name = BLKIOFILE_ATTR(cft->private);
+
+	blkcg = cgroup_to_blkio_cgroup(cgrp);
+
+	switch(plid) {
+	case BLKIO_POLICY_PROP:
+		switch(name) {
+		case BLKIO_PROP_time:
+			return blkio_read_blkg_stats(blkcg, cft, cb,
+						BLKIO_STAT_TIME, 0);
+		case BLKIO_PROP_sectors:
+			return blkio_read_blkg_stats(blkcg, cft, cb,
+						BLKIO_STAT_SECTORS, 0);
+		case BLKIO_PROP_io_service_bytes:
+			return blkio_read_blkg_stats(blkcg, cft, cb,
+						BLKIO_STAT_SERVICE_BYTES, 1);
+		case BLKIO_PROP_io_serviced:
+			return blkio_read_blkg_stats(blkcg, cft, cb,
+						BLKIO_STAT_SERVICED, 1);
+		case BLKIO_PROP_io_service_time:
+			return blkio_read_blkg_stats(blkcg, cft, cb,
+						BLKIO_STAT_SERVICE_TIME, 1);
+		case BLKIO_PROP_io_wait_time:
+			return blkio_read_blkg_stats(blkcg, cft, cb,
+						BLKIO_STAT_WAIT_TIME, 1);
+		case BLKIO_PROP_io_merged:
+			return blkio_read_blkg_stats(blkcg, cft, cb,
+						BLKIO_STAT_MERGED, 1);
+		case BLKIO_PROP_io_queued:
+			return blkio_read_blkg_stats(blkcg, cft, cb,
+						BLKIO_STAT_QUEUED, 1);
+#ifdef CONFIG_DEBUG_BLK_CGROUP
+		case BLKIO_PROP_dequeue:
+			return blkio_read_blkg_stats(blkcg, cft, cb,
+						BLKIO_STAT_DEQUEUE, 0);
+		case BLKIO_PROP_avg_queue_size:
+			return blkio_read_blkg_stats(blkcg, cft, cb,
+						BLKIO_STAT_AVG_QUEUE_SIZE, 0);
+		case BLKIO_PROP_group_wait_time:
+			return blkio_read_blkg_stats(blkcg, cft, cb,
+						BLKIO_STAT_GROUP_WAIT_TIME, 0);
+		case BLKIO_PROP_idle_time:
+			return blkio_read_blkg_stats(blkcg, cft, cb,
+						BLKIO_STAT_IDLE_TIME, 0);
+		case BLKIO_PROP_empty_time:
+			return blkio_read_blkg_stats(blkcg, cft, cb,
+						BLKIO_STAT_EMPTY_TIME, 0);
+#endif
+		default:
+			BUG();
+		}
+		break;
+
+	case BLKIO_POLICY_THROTL:
+		switch(name){
+		case BLKIO_THROTL_io_service_bytes:
+			return blkio_read_blkg_stats(blkcg, cft, cb,
+						BLKIO_STAT_SERVICE_BYTES, 1);
+		case BLKIO_THROTL_io_serviced:
+			return blkio_read_blkg_stats(blkcg, cft, cb,
+						BLKIO_STAT_SERVICED, 1);
+		default:
+			BUG();
+		}
+		break;
+	default:
+		BUG();
+	}
+
+	return 0;
+}
+
+static int blkio_weight_write(struct blkio_cgroup *blkcg, u64 val)
+{
+	struct blkio_group *blkg;
+	struct hlist_node *n;
+	struct blkio_policy_node *pn;
+
+	if (val < BLKIO_WEIGHT_MIN || val > BLKIO_WEIGHT_MAX)
+		return -EINVAL;
+
+	spin_lock(&blkio_list_lock);
+	spin_lock_irq(&blkcg->lock);
+	blkcg->weight = (unsigned int)val;
+
+	hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node) {
+		pn = blkio_policy_search_node(blkcg, blkg->dev,
+					BLKIO_POLICY_PROP, BLKIO_RULE_WEIGHT);
+		if (pn)
+			continue;
+
+		blkio_update_group_weight(blkg, blkcg->weight);
+	}
+	spin_unlock_irq(&blkcg->lock);
+	spin_unlock(&blkio_list_lock);
+	return 0;
+}
+
+static u64 blkiocg_file_read_u64 (struct cgroup *cgrp, struct cftype *cft) {
+	struct blkio_cgroup *blkcg;
+	enum blkio_policy_id plid = BLKIOFILE_POLICY(cft->private);
+	int name = BLKIOFILE_ATTR(cft->private);
+
+	blkcg = cgroup_to_blkio_cgroup(cgrp);
+
+	switch(plid) {
+	case BLKIO_POLICY_PROP:
+		switch(name) {
+		case BLKIO_PROP_weight:
+			return (u64)blkcg->weight;
+		}
+		break;
+	default:
+		BUG();
+	}
+	return 0;
+}
+
+static int
+blkiocg_file_write_u64(struct cgroup *cgrp, struct cftype *cft, u64 val)
+{
+	struct blkio_cgroup *blkcg;
+	enum blkio_policy_id plid = BLKIOFILE_POLICY(cft->private);
+	int name = BLKIOFILE_ATTR(cft->private);
+
+	blkcg = cgroup_to_blkio_cgroup(cgrp);
+
+	switch(plid) {
+	case BLKIO_POLICY_PROP:
+		switch(name) {
+		case BLKIO_PROP_weight:
+			return blkio_weight_write(blkcg, val);
+		}
+		break;
+	default:
+		BUG();
+	}
 
 	return 0;
 }
@@ -827,46 +1160,96 @@ static int blkiocg_weight_device_read(struct cgroup *cgrp, struct cftype *cft,
 struct cftype blkio_files[] = {
 	{
 		.name = "weight_device",
-		.read_seq_string = blkiocg_weight_device_read,
-		.write_string = blkiocg_weight_device_write,
+		.private = BLKIOFILE_PRIVATE(BLKIO_POLICY_PROP,
+				BLKIO_PROP_weight_device),
+		.read_seq_string = blkiocg_file_read,
+		.write_string = blkiocg_file_write,
 		.max_write_len = 256,
 	},
 	{
 		.name = "weight",
-		.read_u64 = blkiocg_weight_read,
-		.write_u64 = blkiocg_weight_write,
+		.private = BLKIOFILE_PRIVATE(BLKIO_POLICY_PROP,
+				BLKIO_PROP_weight),
+		.read_u64 = blkiocg_file_read_u64,
+		.write_u64 = blkiocg_file_write_u64,
+	},
+
+	{
+		.name = "throttle.read_bps_device",
+		.private = BLKIOFILE_PRIVATE(BLKIO_POLICY_THROTL,
+				BLKIO_THROTL_read_bps_device),
+		.read_seq_string = blkiocg_file_read,
+		.write_string = blkiocg_file_write,
+		.max_write_len = 256,
+	},
+
+	{
+		.name = "throttle.write_bps_device",
+		.private = BLKIOFILE_PRIVATE(BLKIO_POLICY_THROTL,
+				BLKIO_THROTL_write_bps_device),
+		.read_seq_string = blkiocg_file_read,
+		.write_string = blkiocg_file_write,
+		.max_write_len = 256,
 	},
 	{
 		.name = "time",
-		.read_map = blkiocg_time_read,
+		.private = BLKIOFILE_PRIVATE(BLKIO_POLICY_PROP,
+				BLKIO_PROP_time),
+		.read_map = blkiocg_file_read_map,
 	},
 	{
 		.name = "sectors",
-		.read_map = blkiocg_sectors_read,
+		.private = BLKIOFILE_PRIVATE(BLKIO_POLICY_PROP,
+				BLKIO_PROP_sectors),
+		.read_map = blkiocg_file_read_map,
 	},
 	{
 		.name = "io_service_bytes",
-		.read_map = blkiocg_io_service_bytes_read,
+		.private = BLKIOFILE_PRIVATE(BLKIO_POLICY_PROP,
+				BLKIO_PROP_io_service_bytes),
+		.read_map = blkiocg_file_read_map,
+	},
+	{
+		.name = "throttle.io_service_bytes",
+		.private = BLKIOFILE_PRIVATE(BLKIO_POLICY_THROTL,
+				BLKIO_THROTL_io_service_bytes),
+		.read_map = blkiocg_file_read_map,
 	},
 	{
 		.name = "io_serviced",
-		.read_map = blkiocg_io_serviced_read,
+		.private = BLKIOFILE_PRIVATE(BLKIO_POLICY_PROP,
+				BLKIO_PROP_io_serviced),
+		.read_map = blkiocg_file_read_map,
+	},
+	{
+		.name = "throttle.io_serviced",
+		.private = BLKIOFILE_PRIVATE(BLKIO_POLICY_THROTL,
+				BLKIO_THROTL_io_serviced),
+		.read_map = blkiocg_file_read_map,
 	},
 	{
 		.name = "io_service_time",
-		.read_map = blkiocg_io_service_time_read,
+		.private = BLKIOFILE_PRIVATE(BLKIO_POLICY_PROP,
+				BLKIO_PROP_io_service_time),
+		.read_map = blkiocg_file_read_map,
 	},
 	{
 		.name = "io_wait_time",
-		.read_map = blkiocg_io_wait_time_read,
+		.private = BLKIOFILE_PRIVATE(BLKIO_POLICY_PROP,
+				BLKIO_PROP_io_wait_time),
+		.read_map = blkiocg_file_read_map,
 	},
 	{
 		.name = "io_merged",
-		.read_map = blkiocg_io_merged_read,
+		.private = BLKIOFILE_PRIVATE(BLKIO_POLICY_PROP,
+				BLKIO_PROP_io_merged),
+		.read_map = blkiocg_file_read_map,
 	},
 	{
 		.name = "io_queued",
-		.read_map = blkiocg_io_queued_read,
+		.private = BLKIOFILE_PRIVATE(BLKIO_POLICY_PROP,
+				BLKIO_PROP_io_queued),
+		.read_map = blkiocg_file_read_map,
 	},
 	{
 		.name = "reset_stats",
@@ -875,23 +1258,33 @@ struct cftype blkio_files[] = {
 #ifdef CONFIG_DEBUG_BLK_CGROUP
 	{
 		.name = "avg_queue_size",
-		.read_map = blkiocg_avg_queue_size_read,
+		.private = BLKIOFILE_PRIVATE(BLKIO_POLICY_PROP,
+				BLKIO_PROP_avg_queue_size),
+		.read_map = blkiocg_file_read_map,
 	},
 	{
 		.name = "group_wait_time",
-		.read_map = blkiocg_group_wait_time_read,
+		.private = BLKIOFILE_PRIVATE(BLKIO_POLICY_PROP,
+				BLKIO_PROP_group_wait_time),
+		.read_map = blkiocg_file_read_map,
 	},
 	{
 		.name = "idle_time",
-		.read_map = blkiocg_idle_time_read,
+		.private = BLKIOFILE_PRIVATE(BLKIO_POLICY_PROP,
+				BLKIO_PROP_idle_time),
+		.read_map = blkiocg_file_read_map,
 	},
 	{
 		.name = "empty_time",
-		.read_map = blkiocg_empty_time_read,
+		.private = BLKIOFILE_PRIVATE(BLKIO_POLICY_PROP,
+				BLKIO_PROP_empty_time),
+		.read_map = blkiocg_file_read_map,
 	},
 	{
 		.name = "dequeue",
-		.read_map = blkiocg_dequeue_read,
+		.private = BLKIOFILE_PRIVATE(BLKIO_POLICY_PROP,
+				BLKIO_PROP_dequeue),
+		.read_map = blkiocg_file_read_map,
 	},
 #endif
 };
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 2b866ec..aa8f0ea 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -15,6 +15,11 @@
 
 #include <linux/cgroup.h>
 
+enum blkio_policy_id {
+	BLKIO_POLICY_PROP = 0,		/* Proportional Bandwidth division */
+	BLKIO_POLICY_THROTL,		/* Throttling */
+};
+
 #if defined(CONFIG_BLK_CGROUP) || defined(CONFIG_BLK_CGROUP_MODULE)
 
 #ifndef CONFIG_BLK_CGROUP
@@ -65,6 +70,39 @@ enum blkg_state_flags {
 	BLKG_empty,
 };
 
+/* cgroup files owned by proportional weight policy */
+enum blkcg_file_name_prop {
+	BLKIO_PROP_weight = 1,
+	BLKIO_PROP_weight_device,
+	BLKIO_PROP_io_service_bytes,
+	BLKIO_PROP_io_serviced,
+	BLKIO_PROP_time,
+	BLKIO_PROP_sectors,
+	BLKIO_PROP_io_service_time,
+	BLKIO_PROP_io_wait_time,
+	BLKIO_PROP_io_merged,
+	BLKIO_PROP_io_queued,
+	BLKIO_PROP_avg_queue_size,
+	BLKIO_PROP_group_wait_time,
+	BLKIO_PROP_idle_time,
+	BLKIO_PROP_empty_time,
+	BLKIO_PROP_dequeue,
+};
+
+/* cgroup files owned by throttle policy */
+enum blkcg_file_name_throtl {
+	BLKIO_THROTL_read_bps_device,
+	BLKIO_THROTL_write_bps_device,
+	BLKIO_THROTL_io_service_bytes,
+	BLKIO_THROTL_io_serviced,
+};
+
+enum blkio_rule_type {
+	BLKIO_RULE_WEIGHT = 0,
+	BLKIO_RULE_READ,
+	BLKIO_RULE_WRITE,
+};
+
 struct blkio_cgroup {
 	struct cgroup_subsys_state css;
 	unsigned int weight;
@@ -113,6 +151,10 @@ struct blkio_group {
 	/* The device MKDEV(major, minor), this group has been created for */
 	dev_t dev;
 
+	/* policy which owns this blk group */
+	enum blkio_policy_id plid;
+
+
 	/* Need to serialize the stats in the case of reset/update */
 	spinlock_t stats_lock;
 	struct blkio_group_stats stats;
@@ -121,19 +163,44 @@ struct blkio_group {
 struct blkio_policy_node {
 	struct list_head node;
 	dev_t dev;
-	unsigned int weight;
+
+	/* This node belongs to max bw policy or porportional weight policy */
+	enum blkio_policy_id plid;
+
+	/* Whether a read or write rule */
+	enum blkio_rule_type rulet;
+
+	union {
+		unsigned int weight;
+		/*
+		 * Rate read/write in terms of byptes per second
+		 * Whether this rate represents read or write is determined
+		 * by rule type "rulet"
+		 */
+		u64 bps;
+	} val;
 };
 
 extern unsigned int blkcg_get_weight(struct blkio_cgroup *blkcg,
 				     dev_t dev);
+extern uint64_t blkcg_get_read_bps(struct blkio_cgroup *blkcg,
+				     dev_t dev);
+extern uint64_t blkcg_get_write_bps(struct blkio_cgroup *blkcg,
+				     dev_t dev);
 
 typedef void (blkio_unlink_group_fn) (void *key, struct blkio_group *blkg);
 typedef void (blkio_update_group_weight_fn) (struct blkio_group *blkg,
 						unsigned int weight);
+typedef void (blkio_update_group_read_bps_fn) (struct blkio_group *blkg,
+						u64 read_bps);
+typedef void (blkio_update_group_write_bps_fn) (struct blkio_group *blkg,
+						u64 write_bps);
 
 struct blkio_policy_ops {
 	blkio_unlink_group_fn *blkio_unlink_group_fn;
 	blkio_update_group_weight_fn *blkio_update_group_weight_fn;
+	blkio_update_group_read_bps_fn *blkio_update_group_read_bps_fn;
+	blkio_update_group_write_bps_fn *blkio_update_group_write_bps_fn;
 };
 
 struct blkio_policy_type {
@@ -212,7 +279,8 @@ static inline void blkiocg_set_start_empty_time(struct blkio_group *blkg) {}
 extern struct blkio_cgroup blkio_root_cgroup;
 extern struct blkio_cgroup *cgroup_to_blkio_cgroup(struct cgroup *cgroup);
 extern void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
-			struct blkio_group *blkg, void *key, dev_t dev);
+	struct blkio_group *blkg, void *key, dev_t dev,
+	enum blkio_policy_id plid);
 extern int blkiocg_del_blkio_group(struct blkio_group *blkg);
 extern struct blkio_group *blkiocg_lookup_group(struct blkio_cgroup *blkcg,
 						void *key);
@@ -234,7 +302,8 @@ static inline struct blkio_cgroup *
 cgroup_to_blkio_cgroup(struct cgroup *cgroup) { return NULL; }
 
 static inline void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
-			struct blkio_group *blkg, void *key, dev_t dev) {}
+		struct blkio_group *blkg, void *key, dev_t dev,
+		enum blkio_policy_id plid) {}
 
 static inline int
 blkiocg_del_blkio_group(struct blkio_group *blkg) { return 0; }
diff --git a/block/cfq.h b/block/cfq.h
index 93448e5..54a6d90 100644
--- a/block/cfq.h
+++ b/block/cfq.h
@@ -69,7 +69,7 @@ static inline void cfq_blkiocg_update_completion_stats(struct blkio_group *blkg,
 
 static inline void cfq_blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
 			struct blkio_group *blkg, void *key, dev_t dev) {
-	blkiocg_add_blkio_group(blkcg, blkg, key, dev);
+	blkiocg_add_blkio_group(blkcg, blkg, key, dev, BLKIO_POLICY_PROP);
 }
 
 static inline int cfq_blkiocg_del_blkio_group(struct blkio_group *blkg)
-- 
1.7.2.2

