Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996Ab2AWXLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 18:11:22 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38617 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754918Ab2AWXK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 18:10:29 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tejun@google.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 15/16] blkcg: kill blkio_policy_node
Date: Mon, 23 Jan 2012 15:09:52 -0800
Message-Id: <1327360193-24679-16-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1327360193-24679-1-git-send-email-tj@kernel.org>
References: <1327360193-24679-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tejun@google.com>

Now that blkcg configuration lives in blkg's, blkio_policy_node is no
longer necessary.  Kill it.

blkio_policy_parse_and_set() now fails if invoked for missing device
and functions to print out configurations are updated to print from
blkg's.

cftype_blkg_same_policy() is dropped along with other policy functions
for consistency.  Its one line is open coded in the only user -
blkio_read_blkg_stats().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c |  430 +++++++---------------------------------------------
 block/blk-cgroup.h |   32 ----
 2 files changed, 58 insertions(+), 404 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index c1793e2..efb159c 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -59,54 +59,6 @@ struct cgroup_subsys blkio_subsys = {
 };
 EXPORT_SYMBOL_GPL(blkio_subsys);
 
-static inline void blkio_policy_insert_node(struct blkio_cgroup *blkcg,
-					    struct blkio_policy_node *pn)
-{
-	list_add(&pn->node, &blkcg->policy_list);
-}
-
-static inline bool cftype_blkg_same_policy(struct cftype *cft,
-			struct blkio_group *blkg)
-{
-	enum blkio_policy_id plid = BLKIOFILE_POLICY(cft->private);
-
-	if (blkg->plid == plid)
-		return 1;
-
-	return 0;
-}
-
-/* Determines if policy node matches cgroup file being accessed */
-static inline bool pn_matches_cftype(struct cftype *cft,
-			struct blkio_policy_node *pn)
-{
-	enum blkio_policy_id plid = BLKIOFILE_POLICY(cft->private);
-	int fileid = BLKIOFILE_ATTR(cft->private);
-
-	return (plid == pn->plid && fileid == pn->fileid);
-}
-
-/* Must be called with blkcg->lock held */
-static inline void blkio_policy_delete_node(struct blkio_policy_node *pn)
-{
-	list_del(&pn->node);
-}
-
-/* Must be called with blkcg->lock held */
-static struct blkio_policy_node *
-blkio_policy_search_node(const struct blkio_cgroup *blkcg, dev_t dev,
-		enum blkio_policy_id plid, int fileid)
-{
-	struct blkio_policy_node *pn;
-
-	list_for_each_entry(pn, &blkcg->policy_list, node) {
-		if (pn->dev == dev && pn->plid == plid && pn->fileid == fileid)
-			return pn;
-	}
-
-	return NULL;
-}
-
 struct blkio_cgroup *cgroup_to_blkio_cgroup(struct cgroup *cgroup)
 {
 	return container_of(cgroup_subsys_state(cgroup, blkio_subsys_id),
@@ -819,10 +771,8 @@ static uint64_t blkio_get_stat(struct blkio_group *blkg,
 	return disk_total;
 }
 
-static int blkio_policy_parse_and_set(char *buf,
-				      struct blkio_policy_node *newpn,
-				      enum blkio_policy_id plid, int fileid,
-				      struct blkio_cgroup *blkcg)
+static int blkio_policy_parse_and_set(char *buf, enum blkio_policy_id plid,
+				      int fileid, struct blkio_cgroup *blkcg)
 {
 	struct gendisk *disk = NULL;
 	struct blkio_group *blkg = NULL;
@@ -870,23 +820,18 @@ static int blkio_policy_parse_and_set(char *buf,
 	if (strict_strtoull(s[1], 10, &temp))
 		goto out;
 
-	/* For rule removal, do not check for device presence. */
 	disk = get_gendisk(dev, &part);
-
-	if ((!disk || part) && temp) {
-		ret = -ENODEV;
+	if (!disk || part)
 		goto out;
-	}
 
 	rcu_read_lock();
 
-	if (disk && !part) {
-		spin_lock_irq(disk->queue->queue_lock);
-		blkg = blkg_lookup_create(blkcg, disk->queue, plid);
-		spin_unlock_irq(disk->queue->queue_lock);
-	}
+	spin_lock_irq(disk->queue->queue_lock);
+	blkg = blkg_lookup_create(blkcg, disk->queue, plid);
+	spin_unlock_irq(disk->queue->queue_lock);
 
-	newpn->dev = dev;
+	if (!blkg)
+		goto out_unlock;
 
 	switch (plid) {
 	case BLKIO_POLICY_PROP:
@@ -894,47 +839,30 @@ static int blkio_policy_parse_and_set(char *buf,
 		     temp > BLKIO_WEIGHT_MAX)
 			goto out_unlock;
 
-		newpn->plid = plid;
-		newpn->fileid = fileid;
-		newpn->val.weight = temp;
-		if (blkg)
-			blkg->conf.weight = temp;
+		blkg->conf.weight = temp;
+		blkio_update_group_weight(blkg, temp ?: blkcg->weight);
 		break;
 	case BLKIO_POLICY_THROTL:
 		switch(fileid) {
 		case BLKIO_THROTL_read_bps_device:
-			if (blkg)
-				blkg->conf.bps[READ] = temp;
-			newpn->plid = plid;
-			newpn->fileid = fileid;
-			newpn->val.bps = temp;
+			blkg->conf.bps[READ] = temp;
+			blkio_update_group_bps(blkg, temp ?: -1, fileid);
 			break;
 		case BLKIO_THROTL_write_bps_device:
-			if (blkg)
-				blkg->conf.bps[WRITE] = temp;
-			newpn->plid = plid;
-			newpn->fileid = fileid;
-			newpn->val.bps = temp;
+			blkg->conf.bps[WRITE] = temp;
+			blkio_update_group_bps(blkg, temp ?: -1, fileid);
 			break;
 		case BLKIO_THROTL_read_iops_device:
 			if (temp > THROTL_IOPS_MAX)
 				goto out_unlock;
-
-			if (blkg)
-				blkg->conf.iops[READ] = temp;
-			newpn->plid = plid;
-			newpn->fileid = fileid;
-			newpn->val.iops = (unsigned int)temp;
+			blkg->conf.iops[READ] = temp;
+			blkio_update_group_iops(blkg, temp ?: -1, fileid);
 			break;
 		case BLKIO_THROTL_write_iops_device:
 			if (temp > THROTL_IOPS_MAX)
 				goto out_unlock;
-
-			if (blkg)
-				blkg->conf.iops[WRITE] = temp;
-			newpn->plid = plid;
-			newpn->fileid = fileid;
-			newpn->val.iops = (unsigned int)temp;
+			blkg->conf.iops[WRITE] = temp;
+			blkio_update_group_iops(blkg, temp ?: -1, fileid);
 			break;
 		}
 		break;
@@ -949,212 +877,12 @@ out:
 	return ret;
 }
 
-unsigned int blkcg_get_weight(struct blkio_cgroup *blkcg,
-			      dev_t dev)
-{
-	struct blkio_policy_node *pn;
-	unsigned long flags;
-	unsigned int weight;
-
-	spin_lock_irqsave(&blkcg->lock, flags);
-
-	pn = blkio_policy_search_node(blkcg, dev, BLKIO_POLICY_PROP,
-				BLKIO_PROP_weight_device);
-	if (pn)
-		weight = pn->val.weight;
-	else
-		weight = blkcg->weight;
-
-	spin_unlock_irqrestore(&blkcg->lock, flags);
-
-	return weight;
-}
-EXPORT_SYMBOL_GPL(blkcg_get_weight);
-
-uint64_t blkcg_get_read_bps(struct blkio_cgroup *blkcg, dev_t dev)
-{
-	struct blkio_policy_node *pn;
-	unsigned long flags;
-	uint64_t bps = -1;
-
-	spin_lock_irqsave(&blkcg->lock, flags);
-	pn = blkio_policy_search_node(blkcg, dev, BLKIO_POLICY_THROTL,
-				BLKIO_THROTL_read_bps_device);
-	if (pn)
-		bps = pn->val.bps;
-	spin_unlock_irqrestore(&blkcg->lock, flags);
-
-	return bps;
-}
-
-uint64_t blkcg_get_write_bps(struct blkio_cgroup *blkcg, dev_t dev)
-{
-	struct blkio_policy_node *pn;
-	unsigned long flags;
-	uint64_t bps = -1;
-
-	spin_lock_irqsave(&blkcg->lock, flags);
-	pn = blkio_policy_search_node(blkcg, dev, BLKIO_POLICY_THROTL,
-				BLKIO_THROTL_write_bps_device);
-	if (pn)
-		bps = pn->val.bps;
-	spin_unlock_irqrestore(&blkcg->lock, flags);
-
-	return bps;
-}
-
-unsigned int blkcg_get_read_iops(struct blkio_cgroup *blkcg, dev_t dev)
-{
-	struct blkio_policy_node *pn;
-	unsigned long flags;
-	unsigned int iops = -1;
-
-	spin_lock_irqsave(&blkcg->lock, flags);
-	pn = blkio_policy_search_node(blkcg, dev, BLKIO_POLICY_THROTL,
-				BLKIO_THROTL_read_iops_device);
-	if (pn)
-		iops = pn->val.iops;
-	spin_unlock_irqrestore(&blkcg->lock, flags);
-
-	return iops;
-}
-
-unsigned int blkcg_get_write_iops(struct blkio_cgroup *blkcg, dev_t dev)
-{
-	struct blkio_policy_node *pn;
-	unsigned long flags;
-	unsigned int iops = -1;
-
-	spin_lock_irqsave(&blkcg->lock, flags);
-	pn = blkio_policy_search_node(blkcg, dev, BLKIO_POLICY_THROTL,
-				BLKIO_THROTL_write_iops_device);
-	if (pn)
-		iops = pn->val.iops;
-	spin_unlock_irqrestore(&blkcg->lock, flags);
-
-	return iops;
-}
-
-/* Checks whether user asked for deleting a policy rule */
-static bool blkio_delete_rule_command(struct blkio_policy_node *pn)
-{
-	switch(pn->plid) {
-	case BLKIO_POLICY_PROP:
-		if (pn->val.weight == 0)
-			return 1;
-		break;
-	case BLKIO_POLICY_THROTL:
-		switch(pn->fileid) {
-		case BLKIO_THROTL_read_bps_device:
-		case BLKIO_THROTL_write_bps_device:
-			if (pn->val.bps == 0)
-				return 1;
-			break;
-		case BLKIO_THROTL_read_iops_device:
-		case BLKIO_THROTL_write_iops_device:
-			if (pn->val.iops == 0)
-				return 1;
-		}
-		break;
-	default:
-		BUG();
-	}
-
-	return 0;
-}
-
-static void blkio_update_policy_rule(struct blkio_policy_node *oldpn,
-					struct blkio_policy_node *newpn)
-{
-	switch(oldpn->plid) {
-	case BLKIO_POLICY_PROP:
-		oldpn->val.weight = newpn->val.weight;
-		break;
-	case BLKIO_POLICY_THROTL:
-		switch(newpn->fileid) {
-		case BLKIO_THROTL_read_bps_device:
-		case BLKIO_THROTL_write_bps_device:
-			oldpn->val.bps = newpn->val.bps;
-			break;
-		case BLKIO_THROTL_read_iops_device:
-		case BLKIO_THROTL_write_iops_device:
-			oldpn->val.iops = newpn->val.iops;
-		}
-		break;
-	default:
-		BUG();
-	}
-}
-
-/*
- * Some rules/values in blkg have changed. Propagate those to respective
- * policies.
- */
-static void blkio_update_blkg_policy(struct blkio_cgroup *blkcg,
-		struct blkio_group *blkg, struct blkio_policy_node *pn)
-{
-	struct blkio_group_conf *conf = &blkg->conf;
-
-	switch(pn->plid) {
-	case BLKIO_POLICY_PROP:
-		blkio_update_group_weight(blkg, conf->weight ?: blkcg->weight);
-		break;
-	case BLKIO_POLICY_THROTL:
-		switch(pn->fileid) {
-		case BLKIO_THROTL_read_bps_device:
-			blkio_update_group_bps(blkg, conf->bps[READ] ?: -1,
-					       pn->fileid);
-			break;
-		case BLKIO_THROTL_write_bps_device:
-			blkio_update_group_bps(blkg, conf->bps[WRITE] ?: -1,
-					       pn->fileid);
-			break;
-		case BLKIO_THROTL_read_iops_device:
-			blkio_update_group_iops(blkg, conf->iops[READ] ?: -1,
-						pn->fileid);
-			break;
-		case BLKIO_THROTL_write_iops_device:
-			blkio_update_group_iops(blkg, conf->iops[WRITE] ?: -1,
-						pn->fileid);
-			break;
-		}
-		break;
-	default:
-		BUG();
-	}
-}
-
-/*
- * A policy node rule has been updated. Propagate this update to all the
- * block groups which might be affected by this update.
- */
-static void blkio_update_policy_node_blkg(struct blkio_cgroup *blkcg,
-				struct blkio_policy_node *pn)
-{
-	struct blkio_group *blkg;
-	struct hlist_node *n;
-
-	spin_lock(&blkio_list_lock);
-	spin_lock_irq(&blkcg->lock);
-
-	hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node) {
-		if (pn->dev != blkg->dev || pn->plid != blkg->plid)
-			continue;
-		blkio_update_blkg_policy(blkcg, blkg, pn);
-	}
-
-	spin_unlock_irq(&blkcg->lock);
-	spin_unlock(&blkio_list_lock);
-}
-
 static int blkiocg_file_write(struct cgroup *cgrp, struct cftype *cft,
  				       const char *buffer)
 {
 	int ret = 0;
 	char *buf;
-	struct blkio_policy_node *newpn, *pn;
 	struct blkio_cgroup *blkcg = cgroup_to_blkio_cgroup(cgrp);
-	int keep_newpn = 0;
 	enum blkio_policy_id plid = BLKIOFILE_POLICY(cft->private);
 	int fileid = BLKIOFILE_ATTR(cft->private);
 
@@ -1162,69 +890,42 @@ static int blkiocg_file_write(struct cgroup *cgrp, struct cftype *cft,
 	if (!buf)
 		return -ENOMEM;
 
-	newpn = kzalloc(sizeof(*newpn), GFP_KERNEL);
-	if (!newpn) {
-		ret = -ENOMEM;
-		goto free_buf;
-	}
-
-	ret = blkio_policy_parse_and_set(buf, newpn, plid, fileid, blkcg);
-	if (ret)
-		goto free_newpn;
-
-	spin_lock_irq(&blkcg->lock);
-
-	pn = blkio_policy_search_node(blkcg, newpn->dev, plid, fileid);
-	if (!pn) {
-		if (!blkio_delete_rule_command(newpn)) {
-			blkio_policy_insert_node(blkcg, newpn);
-			keep_newpn = 1;
-		}
-		spin_unlock_irq(&blkcg->lock);
-		goto update_io_group;
-	}
-
-	if (blkio_delete_rule_command(newpn)) {
-		blkio_policy_delete_node(pn);
-		kfree(pn);
-		spin_unlock_irq(&blkcg->lock);
-		goto update_io_group;
-	}
-	spin_unlock_irq(&blkcg->lock);
-
-	blkio_update_policy_rule(pn, newpn);
-
-update_io_group:
-	blkio_update_policy_node_blkg(blkcg, newpn);
-
-free_newpn:
-	if (!keep_newpn)
-		kfree(newpn);
-free_buf:
+	ret = blkio_policy_parse_and_set(buf, plid, fileid, blkcg);
 	kfree(buf);
 	return ret;
 }
 
-static void
-blkio_print_policy_node(struct seq_file *m, struct blkio_policy_node *pn)
+static void blkio_print_group_conf(struct cftype *cft, struct blkio_group *blkg,
+				   struct seq_file *m)
 {
-	switch(pn->plid) {
+	int fileid = BLKIOFILE_ATTR(cft->private);
+	int rw = WRITE;
+
+	switch (blkg->plid) {
 		case BLKIO_POLICY_PROP:
-			if (pn->fileid == BLKIO_PROP_weight_device)
-				seq_printf(m, "%u:%u\t%u\n", MAJOR(pn->dev),
-					MINOR(pn->dev), pn->val.weight);
+			if (blkg->conf.weight)
+				seq_printf(m, "%u:%u\t%u\n", MAJOR(blkg->dev),
+					MINOR(blkg->dev), blkg->conf.weight);
 			break;
 		case BLKIO_POLICY_THROTL:
-			switch(pn->fileid) {
+			switch (fileid) {
 			case BLKIO_THROTL_read_bps_device:
+				rw = READ;
 			case BLKIO_THROTL_write_bps_device:
-				seq_printf(m, "%u:%u\t%llu\n", MAJOR(pn->dev),
-					MINOR(pn->dev), pn->val.bps);
+				if (blkg->conf.bps[rw])
+					seq_printf(m, "%u:%u\t%llu\n",
+						   MAJOR(blkg->dev),
+						   MINOR(blkg->dev),
+						   blkg->conf.bps[rw]);
 				break;
 			case BLKIO_THROTL_read_iops_device:
+				rw = READ;
 			case BLKIO_THROTL_write_iops_device:
-				seq_printf(m, "%u:%u\t%u\n", MAJOR(pn->dev),
-					MINOR(pn->dev), pn->val.iops);
+				if (blkg->conf.iops[rw])
+					seq_printf(m, "%u:%u\t%u\n",
+						   MAJOR(blkg->dev),
+						   MINOR(blkg->dev),
+						   blkg->conf.iops[rw]);
 				break;
 			}
 			break;
@@ -1234,20 +935,17 @@ blkio_print_policy_node(struct seq_file *m, struct blkio_policy_node *pn)
 }
 
 /* cgroup files which read their data from policy nodes end up here */
-static void blkio_read_policy_node_files(struct cftype *cft,
-			struct blkio_cgroup *blkcg, struct seq_file *m)
+static void blkio_read_conf(struct cftype *cft, struct blkio_cgroup *blkcg,
+			    struct seq_file *m)
 {
-	struct blkio_policy_node *pn;
+	struct blkio_group *blkg;
+	struct hlist_node *n;
 
-	if (!list_empty(&blkcg->policy_list)) {
-		spin_lock_irq(&blkcg->lock);
-		list_for_each_entry(pn, &blkcg->policy_list, node) {
-			if (!pn_matches_cftype(cft, pn))
-				continue;
-			blkio_print_policy_node(m, pn);
-		}
-		spin_unlock_irq(&blkcg->lock);
-	}
+	spin_lock_irq(&blkcg->lock);
+	hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node)
+		if (BLKIOFILE_POLICY(cft->private) == blkg->plid)
+			blkio_print_group_conf(cft, blkg, m);
+	spin_unlock_irq(&blkcg->lock);
 }
 
 static int blkiocg_file_read(struct cgroup *cgrp, struct cftype *cft,
@@ -1263,7 +961,7 @@ static int blkiocg_file_read(struct cgroup *cgrp, struct cftype *cft,
 	case BLKIO_POLICY_PROP:
 		switch(name) {
 		case BLKIO_PROP_weight_device:
-			blkio_read_policy_node_files(cft, blkcg, m);
+			blkio_read_conf(cft, blkcg, m);
 			return 0;
 		default:
 			BUG();
@@ -1275,7 +973,7 @@ static int blkiocg_file_read(struct cgroup *cgrp, struct cftype *cft,
 		case BLKIO_THROTL_write_bps_device:
 		case BLKIO_THROTL_read_iops_device:
 		case BLKIO_THROTL_write_iops_device:
-			blkio_read_policy_node_files(cft, blkcg, m);
+			blkio_read_conf(cft, blkcg, m);
 			return 0;
 		default:
 			BUG();
@@ -1299,7 +997,7 @@ static int blkio_read_blkg_stats(struct blkio_cgroup *blkcg,
 	rcu_read_lock();
 	hlist_for_each_entry_rcu(blkg, n, &blkcg->blkg_list, blkcg_node) {
 		if (blkg->dev) {
-			if (!cftype_blkg_same_policy(cft, blkg))
+			if (BLKIOFILE_POLICY(cft->private) != blkg->plid)
 				continue;
 			if (pcpu)
 				cgroup_total += blkio_get_stat_cpu(blkg, cb,
@@ -1398,11 +1096,10 @@ static int blkiocg_file_read_map(struct cgroup *cgrp, struct cftype *cft,
 	return 0;
 }
 
-static int blkio_weight_write(struct blkio_cgroup *blkcg, u64 val)
+static int blkio_weight_write(struct blkio_cgroup *blkcg, int plid, u64 val)
 {
 	struct blkio_group *blkg;
 	struct hlist_node *n;
-	struct blkio_policy_node *pn;
 
 	if (val < BLKIO_WEIGHT_MIN || val > BLKIO_WEIGHT_MAX)
 		return -EINVAL;
@@ -1411,14 +1108,10 @@ static int blkio_weight_write(struct blkio_cgroup *blkcg, u64 val)
 	spin_lock_irq(&blkcg->lock);
 	blkcg->weight = (unsigned int)val;
 
-	hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node) {
-		pn = blkio_policy_search_node(blkcg, blkg->dev,
-				BLKIO_POLICY_PROP, BLKIO_PROP_weight_device);
-		if (pn)
-			continue;
+	hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node)
+		if (blkg->plid == plid && !blkg->conf.weight)
+			blkio_update_group_weight(blkg, blkcg->weight);
 
-		blkio_update_group_weight(blkg, blkcg->weight);
-	}
 	spin_unlock_irq(&blkcg->lock);
 	spin_unlock(&blkio_list_lock);
 	return 0;
@@ -1457,7 +1150,7 @@ blkiocg_file_write_u64(struct cgroup *cgrp, struct cftype *cft, u64 val)
 	case BLKIO_POLICY_PROP:
 		switch(name) {
 		case BLKIO_PROP_weight:
-			return blkio_weight_write(blkcg, val);
+			return blkio_weight_write(blkcg, plid, val);
 		}
 		break;
 	default:
@@ -1638,7 +1331,6 @@ static void blkiocg_destroy(struct cgroup_subsys *subsys, struct cgroup *cgroup)
 	struct blkio_group *blkg;
 	struct request_queue *q;
 	struct blkio_policy_type *blkiop;
-	struct blkio_policy_node *pn, *pntmp;
 
 	rcu_read_lock();
 	do {
@@ -1670,11 +1362,6 @@ static void blkiocg_destroy(struct cgroup_subsys *subsys, struct cgroup *cgroup)
 		spin_unlock(&blkio_list_lock);
 	} while (1);
 
-	list_for_each_entry_safe(pn, pntmp, &blkcg->policy_list, node) {
-		blkio_policy_delete_node(pn);
-		kfree(pn);
-	}
-
 	free_css_id(&blkio_subsys, &blkcg->css);
 	rcu_read_unlock();
 	if (blkcg != &blkio_root_cgroup)
@@ -1701,7 +1388,6 @@ done:
 	spin_lock_init(&blkcg->lock);
 	INIT_HLIST_HEAD(&blkcg->blkg_list);
 
-	INIT_LIST_HEAD(&blkcg->policy_list);
 	return &blkcg->css;
 }
 
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 3bbbe80..4a2442d 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -112,7 +112,6 @@ struct blkio_cgroup {
 	unsigned int weight;
 	spinlock_t lock;
 	struct hlist_head blkg_list;
-	struct list_head policy_list; /* list of blkio_policy_node */
 };
 
 struct blkio_group_stats {
@@ -182,37 +181,6 @@ struct blkio_group {
 	struct blkio_group_stats_cpu __percpu *stats_cpu;
 };
 
-struct blkio_policy_node {
-	struct list_head node;
-	dev_t dev;
-	/* This node belongs to max bw policy or porportional weight policy */
-	enum blkio_policy_id plid;
-	/* cgroup file to which this rule belongs to */
-	int fileid;
-
-	union {
-		unsigned int weight;
-		/*
-		 * Rate read/write in terms of bytes per second
-		 * Whether this rate represents read or write is determined
-		 * by file type "fileid".
-		 */
-		u64 bps;
-		unsigned int iops;
-	} val;
-};
-
-extern unsigned int blkcg_get_weight(struct blkio_cgroup *blkcg,
-				     dev_t dev);
-extern uint64_t blkcg_get_read_bps(struct blkio_cgroup *blkcg,
-				     dev_t dev);
-extern uint64_t blkcg_get_write_bps(struct blkio_cgroup *blkcg,
-				     dev_t dev);
-extern unsigned int blkcg_get_read_iops(struct blkio_cgroup *blkcg,
-				     dev_t dev);
-extern unsigned int blkcg_get_write_iops(struct blkio_cgroup *blkcg,
-				     dev_t dev);
-
 typedef struct blkio_group *(blkio_alloc_group_fn)(struct request_queue *q,
 						   struct blkio_cgroup *blkcg);
 typedef void (blkio_link_group_fn)(struct request_queue *q,
-- 
1.7.7.3

