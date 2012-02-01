Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282Ab2BAUvR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 15:51:17 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54454 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756964Ab2BAUvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 15:51:11 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 14/16] blkcg: don't allow or retain configuration of missing devices
Date: Wed,  1 Feb 2012 12:50:27 -0800
Message-Id: <1328129429-11823-15-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1328129429-11823-1-git-send-email-tj@kernel.org>
References: <1328129429-11823-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blkcg is very peculiar in that it allows setting and remembering
configurations for non-existent devices by maintaining separate data
structures for configuration.

This behavior is completely out of the usual norms and outright
confusing; furthermore, it uses dev_t number to match the
configuration to devices, which is unpredictable to begin with and
becomes completely unuseable if EXT_DEVT is fully used.

It is wholely unnecessary - we already have fully functional userland
mechanism to program devices being hotplugged which has full access to
device identification, connection topology and filesystem information.

Add a new struct blkio_group_conf which contains all blkcg
configurations to blkio_group and let blkio_group, which can be
created iff the associated device exists and is removed when the
associated device goes away, carry all configurations.

Note that, after this patch, all newly created blkg's will always have
the default configuration (unlimited for throttling and blkcg's weight
for propio).

This patch makes blkio_policy_node meaningless but doesn't remove it.
The next patch will.

-v2: Updated to retry after short sleep if blkg lookup/creation failed
     due to the queue being temporarily bypassed as indicated by
     -EBUSY return.  Pointed out by Vivek.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
---
 block/blk-cgroup.c   |   94 ++++++++++++++++++++++++++++++++++++++-----------
 block/blk-cgroup.h   |    9 +++++
 block/blk-throttle.c |    8 ++--
 block/cfq-iosched.c  |    2 +-
 4 files changed, 87 insertions(+), 26 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index cd41712..bb4db0c 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -855,9 +855,12 @@ static uint64_t blkio_get_stat(struct blkio_group *blkg,
 }
 
 static int blkio_policy_parse_and_set(char *buf,
-	struct blkio_policy_node *newpn, enum blkio_policy_id plid, int fileid)
+				      struct blkio_policy_node *newpn,
+				      enum blkio_policy_id plid, int fileid,
+				      struct blkio_cgroup *blkcg)
 {
 	struct gendisk *disk = NULL;
+	struct blkio_group *blkg = NULL;
 	char *s[4], *p, *major_s = NULL, *minor_s = NULL;
 	unsigned long major, minor;
 	int i = 0, ret = -EINVAL;
@@ -903,11 +906,25 @@ static int blkio_policy_parse_and_set(char *buf,
 		goto out;
 
 	/* For rule removal, do not check for device presence. */
-	if (temp) {
-		disk = get_gendisk(dev, &part);
-		if (!disk || part) {
-			ret = -ENODEV;
-			goto out;
+	disk = get_gendisk(dev, &part);
+
+	if ((!disk || part) && temp) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	rcu_read_lock();
+
+	if (disk && !part) {
+		spin_lock_irq(disk->queue->queue_lock);
+		blkg = blkg_lookup_create(blkcg, disk->queue, plid, false);
+		spin_unlock_irq(disk->queue->queue_lock);
+
+		if (IS_ERR(blkg)) {
+			ret = PTR_ERR(blkg);
+			if (ret == -EBUSY)
+				goto out_unlock;
+			blkg = NULL;
 		}
 	}
 
@@ -917,25 +934,46 @@ static int blkio_policy_parse_and_set(char *buf,
 	case BLKIO_POLICY_PROP:
 		if ((temp < BLKIO_WEIGHT_MIN && temp > 0) ||
 		     temp > BLKIO_WEIGHT_MAX)
-			goto out;
+			goto out_unlock;
 
 		newpn->plid = plid;
 		newpn->fileid = fileid;
 		newpn->val.weight = temp;
+		if (blkg)
+			blkg->conf.weight = temp;
 		break;
 	case BLKIO_POLICY_THROTL:
 		switch(fileid) {
 		case BLKIO_THROTL_read_bps_device:
+			if (blkg)
+				blkg->conf.bps[READ] = temp;
+			newpn->plid = plid;
+			newpn->fileid = fileid;
+			newpn->val.bps = temp;
+			break;
 		case BLKIO_THROTL_write_bps_device:
+			if (blkg)
+				blkg->conf.bps[WRITE] = temp;
 			newpn->plid = plid;
 			newpn->fileid = fileid;
 			newpn->val.bps = temp;
 			break;
 		case BLKIO_THROTL_read_iops_device:
+			if (temp > THROTL_IOPS_MAX)
+				goto out_unlock;
+
+			if (blkg)
+				blkg->conf.iops[READ] = temp;
+			newpn->plid = plid;
+			newpn->fileid = fileid;
+			newpn->val.iops = (unsigned int)temp;
+			break;
 		case BLKIO_THROTL_write_iops_device:
 			if (temp > THROTL_IOPS_MAX)
-				goto out;
+				goto out_unlock;
 
+			if (blkg)
+				blkg->conf.iops[WRITE] = temp;
 			newpn->plid = plid;
 			newpn->fileid = fileid;
 			newpn->val.iops = (unsigned int)temp;
@@ -946,8 +984,21 @@ static int blkio_policy_parse_and_set(char *buf,
 		BUG();
 	}
 	ret = 0;
+out_unlock:
+	rcu_read_unlock();
 out:
 	put_disk(disk);
+
+	/*
+	 * If queue was bypassing, we should retry.  Do so after a short
+	 * msleep().  It isn't strictly necessary but queue can be
+	 * bypassing for some time and it's always nice to avoid busy
+	 * looping.
+	 */
+	if (ret == -EBUSY) {
+		msleep(10);
+		return restart_syscall();
+	}
 	return ret;
 }
 
@@ -1095,26 +1146,29 @@ static void blkio_update_policy_rule(struct blkio_policy_node *oldpn,
 static void blkio_update_blkg_policy(struct blkio_cgroup *blkcg,
 		struct blkio_group *blkg, struct blkio_policy_node *pn)
 {
-	unsigned int weight, iops;
-	u64 bps;
+	struct blkio_group_conf *conf = &blkg->conf;
 
 	switch(pn->plid) {
 	case BLKIO_POLICY_PROP:
-		weight = pn->val.weight ? pn->val.weight :
-				blkcg->weight;
-		blkio_update_group_weight(blkg, weight);
+		blkio_update_group_weight(blkg, conf->weight ?: blkcg->weight);
 		break;
 	case BLKIO_POLICY_THROTL:
 		switch(pn->fileid) {
 		case BLKIO_THROTL_read_bps_device:
+			blkio_update_group_bps(blkg, conf->bps[READ] ?: -1,
+					       pn->fileid);
+			break;
 		case BLKIO_THROTL_write_bps_device:
-			bps = pn->val.bps ? pn->val.bps : (-1);
-			blkio_update_group_bps(blkg, bps, pn->fileid);
+			blkio_update_group_bps(blkg, conf->bps[WRITE] ?: -1,
+					       pn->fileid);
 			break;
 		case BLKIO_THROTL_read_iops_device:
+			blkio_update_group_iops(blkg, conf->iops[READ] ?: -1,
+						pn->fileid);
+			break;
 		case BLKIO_THROTL_write_iops_device:
-			iops = pn->val.iops ? pn->val.iops : (-1);
-			blkio_update_group_iops(blkg, iops, pn->fileid);
+			blkio_update_group_iops(blkg, conf->iops[WRITE] ?: -1,
+						pn->fileid);
 			break;
 		}
 		break;
@@ -1152,7 +1206,7 @@ static int blkiocg_file_write(struct cgroup *cgrp, struct cftype *cft,
 	int ret = 0;
 	char *buf;
 	struct blkio_policy_node *newpn, *pn;
-	struct blkio_cgroup *blkcg;
+	struct blkio_cgroup *blkcg = cgroup_to_blkio_cgroup(cgrp);
 	int keep_newpn = 0;
 	enum blkio_policy_id plid = BLKIOFILE_POLICY(cft->private);
 	int fileid = BLKIOFILE_ATTR(cft->private);
@@ -1167,12 +1221,10 @@ static int blkiocg_file_write(struct cgroup *cgrp, struct cftype *cft,
 		goto free_buf;
 	}
 
-	ret = blkio_policy_parse_and_set(buf, newpn, plid, fileid);
+	ret = blkio_policy_parse_and_set(buf, newpn, plid, fileid, blkcg);
 	if (ret)
 		goto free_newpn;
 
-	blkcg = cgroup_to_blkio_cgroup(cgrp);
-
 	spin_lock_irq(&blkcg->lock);
 
 	pn = blkio_policy_search_node(blkcg, newpn->dev, plid, fileid);
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 2600ae7..81efe71 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -154,6 +154,12 @@ struct blkio_group_stats_cpu {
 	struct u64_stats_sync syncp;
 };
 
+struct blkio_group_conf {
+	unsigned int weight;
+	unsigned int iops[2];
+	u64 bps[2];
+};
+
 struct blkio_group {
 	/* Pointer to the associated request_queue, RCU protected */
 	struct request_queue __rcu *q;
@@ -166,6 +172,9 @@ struct blkio_group {
 	/* policy which owns this blk group */
 	enum blkio_policy_id plid;
 
+	/* Configuration */
+	struct blkio_group_conf conf;
+
 	/* Need to serialize the stats in the case of reset/update */
 	spinlock_t stats_lock;
 	struct blkio_group_stats stats;
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 2ae637b..791b107 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -196,10 +196,10 @@ static struct blkio_group *throtl_alloc_blkio_group(struct request_queue *q,
 	bio_list_init(&tg->bio_lists[1]);
 	tg->limits_changed = false;
 
-	tg->bps[READ] = blkcg_get_read_bps(blkcg, tg->blkg.dev);
-	tg->bps[WRITE] = blkcg_get_write_bps(blkcg, tg->blkg.dev);
-	tg->iops[READ] = blkcg_get_read_iops(blkcg, tg->blkg.dev);
-	tg->iops[WRITE] = blkcg_get_write_iops(blkcg, tg->blkg.dev);
+	tg->bps[READ] = -1;
+	tg->bps[WRITE] = -1;
+	tg->iops[READ] = -1;
+	tg->iops[WRITE] = -1;
 
 	/*
 	 * Take the initial reference that will be released on destroy
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index a7f16dc..3c5b74d 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1083,7 +1083,7 @@ static struct blkio_group *cfq_alloc_blkio_group(struct request_queue *q,
 		return NULL;
 
 	cfq_init_cfqg_base(cfqg);
-	cfqg->weight = blkcg_get_weight(blkcg, cfqg->blkg.dev);
+	cfqg->weight = blkcg->weight;
 
 	/*
 	 * Take the initial reference that will be released on destroy
-- 
1.7.7.3

