Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004Ab2AWXLC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 18:11:02 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:54228 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754932Ab2AWXKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 18:10:31 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tejun@google.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 16/16] blkcg: kill the mind-bending blkg->dev
Date: Mon, 23 Jan 2012 15:09:53 -0800
Message-Id: <1327360193-24679-17-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1327360193-24679-1-git-send-email-tj@kernel.org>
References: <1327360193-24679-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tejun@google.com>

blkg->dev is dev_t recording the device number of the block device for
the associated request_queue.  It is used to identify the associated
block device when printing out configuration or stats.

This is redundant to begin with.  A blkg is an association between a
cgroup and a request_queue and it of course is possible to reach
request_queue from blkg and synchronization conventions are in place
for safe q dereferencing, so this shouldn't be necessary from the
beginning.  Furthermore, it's initialized by sscanf()ing the device
name of backing_dev_info.  The mind boggles.

Anyways, if blkg is visible under rcu lock, we *know* that the
associated request_queue hasn't gone away yet and its bdi is
registered and alive - blkg can't be created for request_queue which
hasn't been fully initialized and it can't go away before blkg is
removed.

Let stat and conf read functions get device name from
blkg->q->backing_dev_info.dev and pass it down to printing functions
and remove blkg->dev.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c   |   86 ++++++++++++++++++++++++++------------------------
 block/blk-cgroup.h   |    2 -
 block/blk-throttle.c |   51 +----------------------------
 block/cfq-iosched.c  |   21 ------------
 4 files changed, 47 insertions(+), 113 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index efb159c..65a6f4e 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -627,10 +627,10 @@ blkiocg_reset_stats(struct cgroup *cgroup, struct cftype *cftype, u64 val)
 	return 0;
 }
 
-static void blkio_get_key_name(enum stat_sub_type type, dev_t dev, char *str,
-				int chars_left, bool diskname_only)
+static void blkio_get_key_name(enum stat_sub_type type, const char *dname,
+			       char *str, int chars_left, bool diskname_only)
 {
-	snprintf(str, chars_left, "%d:%d", MAJOR(dev), MINOR(dev));
+	snprintf(str, chars_left, "%s", dname);
 	chars_left -= strlen(str);
 	if (chars_left <= 0) {
 		printk(KERN_WARNING
@@ -661,9 +661,9 @@ static void blkio_get_key_name(enum stat_sub_type type, dev_t dev, char *str,
 }
 
 static uint64_t blkio_fill_stat(char *str, int chars_left, uint64_t val,
-				struct cgroup_map_cb *cb, dev_t dev)
+				struct cgroup_map_cb *cb, const char *dname)
 {
-	blkio_get_key_name(0, dev, str, chars_left, true);
+	blkio_get_key_name(0, dname, str, chars_left, true);
 	cb->fill(cb, str, val);
 	return val;
 }
@@ -695,7 +695,8 @@ static uint64_t blkio_read_stat_cpu(struct blkio_group *blkg,
 }
 
 static uint64_t blkio_get_stat_cpu(struct blkio_group *blkg,
-		struct cgroup_map_cb *cb, dev_t dev, enum stat_type_cpu type)
+				   struct cgroup_map_cb *cb, const char *dname,
+				   enum stat_type_cpu type)
 {
 	uint64_t disk_total, val;
 	char key_str[MAX_KEY_LEN];
@@ -703,12 +704,14 @@ static uint64_t blkio_get_stat_cpu(struct blkio_group *blkg,
 
 	if (type == BLKIO_STAT_CPU_SECTORS) {
 		val = blkio_read_stat_cpu(blkg, type, 0);
-		return blkio_fill_stat(key_str, MAX_KEY_LEN - 1, val, cb, dev);
+		return blkio_fill_stat(key_str, MAX_KEY_LEN - 1, val, cb,
+				       dname);
 	}
 
 	for (sub_type = BLKIO_STAT_READ; sub_type < BLKIO_STAT_TOTAL;
 			sub_type++) {
-		blkio_get_key_name(sub_type, dev, key_str, MAX_KEY_LEN, false);
+		blkio_get_key_name(sub_type, dname, key_str, MAX_KEY_LEN,
+				   false);
 		val = blkio_read_stat_cpu(blkg, type, sub_type);
 		cb->fill(cb, key_str, val);
 	}
@@ -716,14 +719,16 @@ static uint64_t blkio_get_stat_cpu(struct blkio_group *blkg,
 	disk_total = blkio_read_stat_cpu(blkg, type, BLKIO_STAT_READ) +
 			blkio_read_stat_cpu(blkg, type, BLKIO_STAT_WRITE);
 
-	blkio_get_key_name(BLKIO_STAT_TOTAL, dev, key_str, MAX_KEY_LEN, false);
+	blkio_get_key_name(BLKIO_STAT_TOTAL, dname, key_str, MAX_KEY_LEN,
+			   false);
 	cb->fill(cb, key_str, disk_total);
 	return disk_total;
 }
 
 /* This should be called with blkg->stats_lock held */
 static uint64_t blkio_get_stat(struct blkio_group *blkg,
-		struct cgroup_map_cb *cb, dev_t dev, enum stat_type type)
+			       struct cgroup_map_cb *cb, const char *dname,
+			       enum stat_type type)
 {
 	uint64_t disk_total;
 	char key_str[MAX_KEY_LEN];
@@ -731,11 +736,11 @@ static uint64_t blkio_get_stat(struct blkio_group *blkg,
 
 	if (type == BLKIO_STAT_TIME)
 		return blkio_fill_stat(key_str, MAX_KEY_LEN - 1,
-					blkg->stats.time, cb, dev);
+					blkg->stats.time, cb, dname);
 #ifdef CONFIG_DEBUG_BLK_CGROUP
 	if (type == BLKIO_STAT_UNACCOUNTED_TIME)
 		return blkio_fill_stat(key_str, MAX_KEY_LEN - 1,
-					blkg->stats.unaccounted_time, cb, dev);
+				       blkg->stats.unaccounted_time, cb, dname);
 	if (type == BLKIO_STAT_AVG_QUEUE_SIZE) {
 		uint64_t sum = blkg->stats.avg_queue_size_sum;
 		uint64_t samples = blkg->stats.avg_queue_size_samples;
@@ -743,30 +748,33 @@ static uint64_t blkio_get_stat(struct blkio_group *blkg,
 			do_div(sum, samples);
 		else
 			sum = 0;
-		return blkio_fill_stat(key_str, MAX_KEY_LEN - 1, sum, cb, dev);
+		return blkio_fill_stat(key_str, MAX_KEY_LEN - 1,
+				       sum, cb, dname);
 	}
 	if (type == BLKIO_STAT_GROUP_WAIT_TIME)
 		return blkio_fill_stat(key_str, MAX_KEY_LEN - 1,
-					blkg->stats.group_wait_time, cb, dev);
+				       blkg->stats.group_wait_time, cb, dname);
 	if (type == BLKIO_STAT_IDLE_TIME)
 		return blkio_fill_stat(key_str, MAX_KEY_LEN - 1,
-					blkg->stats.idle_time, cb, dev);
+				       blkg->stats.idle_time, cb, dname);
 	if (type == BLKIO_STAT_EMPTY_TIME)
 		return blkio_fill_stat(key_str, MAX_KEY_LEN - 1,
-					blkg->stats.empty_time, cb, dev);
+				       blkg->stats.empty_time, cb, dname);
 	if (type == BLKIO_STAT_DEQUEUE)
 		return blkio_fill_stat(key_str, MAX_KEY_LEN - 1,
-					blkg->stats.dequeue, cb, dev);
+				       blkg->stats.dequeue, cb, dname);
 #endif
 
 	for (sub_type = BLKIO_STAT_READ; sub_type < BLKIO_STAT_TOTAL;
 			sub_type++) {
-		blkio_get_key_name(sub_type, dev, key_str, MAX_KEY_LEN, false);
+		blkio_get_key_name(sub_type, dname, key_str, MAX_KEY_LEN,
+				   false);
 		cb->fill(cb, key_str, blkg->stats.stat_arr[type][sub_type]);
 	}
 	disk_total = blkg->stats.stat_arr[type][BLKIO_STAT_READ] +
 			blkg->stats.stat_arr[type][BLKIO_STAT_WRITE];
-	blkio_get_key_name(BLKIO_STAT_TOTAL, dev, key_str, MAX_KEY_LEN, false);
+	blkio_get_key_name(BLKIO_STAT_TOTAL, dname, key_str, MAX_KEY_LEN,
+			   false);
 	cb->fill(cb, key_str, disk_total);
 	return disk_total;
 }
@@ -898,14 +906,15 @@ static int blkiocg_file_write(struct cgroup *cgrp, struct cftype *cft,
 static void blkio_print_group_conf(struct cftype *cft, struct blkio_group *blkg,
 				   struct seq_file *m)
 {
+	const char *dname = dev_name(blkg->q->backing_dev_info.dev);
 	int fileid = BLKIOFILE_ATTR(cft->private);
 	int rw = WRITE;
 
 	switch (blkg->plid) {
 		case BLKIO_POLICY_PROP:
 			if (blkg->conf.weight)
-				seq_printf(m, "%u:%u\t%u\n", MAJOR(blkg->dev),
-					MINOR(blkg->dev), blkg->conf.weight);
+				seq_printf(m, "%s\t%u\n",
+					   dname, blkg->conf.weight);
 			break;
 		case BLKIO_POLICY_THROTL:
 			switch (fileid) {
@@ -913,19 +922,15 @@ static void blkio_print_group_conf(struct cftype *cft, struct blkio_group *blkg,
 				rw = READ;
 			case BLKIO_THROTL_write_bps_device:
 				if (blkg->conf.bps[rw])
-					seq_printf(m, "%u:%u\t%llu\n",
-						   MAJOR(blkg->dev),
-						   MINOR(blkg->dev),
-						   blkg->conf.bps[rw]);
+					seq_printf(m, "%s\t%llu\n",
+						   dname, blkg->conf.bps[rw]);
 				break;
 			case BLKIO_THROTL_read_iops_device:
 				rw = READ;
 			case BLKIO_THROTL_write_iops_device:
 				if (blkg->conf.iops[rw])
-					seq_printf(m, "%u:%u\t%u\n",
-						   MAJOR(blkg->dev),
-						   MINOR(blkg->dev),
-						   blkg->conf.iops[rw]);
+					seq_printf(m, "%s\t%u\n",
+						   dname, blkg->conf.iops[rw]);
 				break;
 			}
 			break;
@@ -996,18 +1001,17 @@ static int blkio_read_blkg_stats(struct blkio_cgroup *blkcg,
 
 	rcu_read_lock();
 	hlist_for_each_entry_rcu(blkg, n, &blkcg->blkg_list, blkcg_node) {
-		if (blkg->dev) {
-			if (BLKIOFILE_POLICY(cft->private) != blkg->plid)
-				continue;
-			if (pcpu)
-				cgroup_total += blkio_get_stat_cpu(blkg, cb,
-						blkg->dev, type);
-			else {
-				spin_lock_irq(&blkg->stats_lock);
-				cgroup_total += blkio_get_stat(blkg, cb,
-						blkg->dev, type);
-				spin_unlock_irq(&blkg->stats_lock);
-			}
+		const char *dname = dev_name(blkg->q->backing_dev_info.dev);
+
+		if (BLKIOFILE_POLICY(cft->private) != blkg->plid)
+			continue;
+		if (pcpu)
+			cgroup_total += blkio_get_stat_cpu(blkg, cb, dname,
+							   type);
+		else {
+			spin_lock_irq(&blkg->stats_lock);
+			cgroup_total += blkio_get_stat(blkg, cb, dname, type);
+			spin_unlock_irq(&blkg->stats_lock);
 		}
 	}
 	if (show_total)
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 4a2442d..f8bd36a 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -166,8 +166,6 @@ struct blkio_group {
 	unsigned short blkcg_id;
 	/* Store cgroup path */
 	char path[128];
-	/* The device MKDEV(major, minor), this group has been created for */
-	dev_t dev;
 	/* policy which owns this blk group */
 	enum blkio_policy_id plid;
 
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index f02eaf67..587aa84 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -212,50 +212,12 @@ static struct blkio_group *throtl_alloc_blkio_group(struct request_queue *q,
 	return &tg->blkg;
 }
 
-static void
-__throtl_tg_fill_dev_details(struct throtl_data *td, struct throtl_grp *tg)
-{
-	struct backing_dev_info *bdi = &td->queue->backing_dev_info;
-	unsigned int major, minor;
-
-	if (!tg || tg->blkg.dev)
-		return;
-
-	/*
-	 * Fill in device details for a group which might not have been
-	 * filled at group creation time as queue was being instantiated
-	 * and driver had not attached a device yet
-	 */
-	if (bdi->dev && dev_name(bdi->dev)) {
-		sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
-		tg->blkg.dev = MKDEV(major, minor);
-	}
-}
-
-/*
- * Should be called with without queue lock held. Here queue lock will be
- * taken rarely. It will be taken only once during life time of a group
- * if need be
- */
-static void
-throtl_tg_fill_dev_details(struct throtl_data *td, struct throtl_grp *tg)
-{
-	if (!tg || tg->blkg.dev)
-		return;
-
-	spin_lock_irq(td->queue->queue_lock);
-	__throtl_tg_fill_dev_details(td, tg);
-	spin_unlock_irq(td->queue->queue_lock);
-}
-
 static void throtl_link_blkio_group(struct request_queue *q,
 				    struct blkio_group *blkg)
 {
 	struct throtl_data *td = q->td;
 	struct throtl_grp *tg = tg_of_blkg(blkg);
 
-	__throtl_tg_fill_dev_details(td, tg);
-
 	hlist_add_head(&tg->tg_node, &td->tg_list);
 	td->nr_undestroyed_grps++;
 }
@@ -263,20 +225,14 @@ static void throtl_link_blkio_group(struct request_queue *q,
 static struct
 throtl_grp *throtl_lookup_tg(struct throtl_data *td, struct blkio_cgroup *blkcg)
 {
-	struct throtl_grp *tg = NULL;
-
 	/*
 	 * This is the common case when there are no blkio cgroups.
  	 * Avoid lookup in this case
  	 */
 	if (blkcg == &blkio_root_cgroup)
-		tg = td->root_tg;
-	else
-		tg = tg_of_blkg(blkg_lookup(blkcg, td->queue,
-					    BLKIO_POLICY_THROTL));
+		return td->root_tg;
 
-	__throtl_tg_fill_dev_details(td, tg);
-	return tg;
+	return tg_of_blkg(blkg_lookup(blkcg, td->queue, BLKIO_POLICY_THROTL));
 }
 
 static struct throtl_grp *throtl_lookup_create_tg(struct throtl_data *td,
@@ -294,7 +250,6 @@ static struct throtl_grp *throtl_lookup_create_tg(struct throtl_data *td,
 	else if (!blk_queue_dead(q))
 		tg = td->root_tg;
 
-	__throtl_tg_fill_dev_details(td, tg);
 	return tg;
 }
 
@@ -1081,8 +1036,6 @@ bool blk_throtl_bio(struct request_queue *q, struct bio *bio)
 	blkcg = task_blkio_cgroup(current);
 	tg = throtl_lookup_tg(td, blkcg);
 	if (tg) {
-		throtl_tg_fill_dev_details(td, tg);
-
 		if (tg_no_rule_group(tg, rw)) {
 			blkiocg_update_dispatch_stats(&tg->blkg, bio->bi_size,
 					rw, rw_is_sync(bio->bi_rw));
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 0ee04b5..12632b8 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1052,20 +1052,7 @@ static void cfq_link_blkio_group(struct request_queue *q,
 				 struct blkio_group *blkg)
 {
 	struct cfq_data *cfqd = q->elevator->elevator_data;
-	struct backing_dev_info *bdi = &q->backing_dev_info;
 	struct cfq_group *cfqg = cfqg_of_blkg(blkg);
-	unsigned int major, minor;
-
-	/*
-	 * Add group onto cgroup list. It might happen that bdi->dev is
-	 * not initialized yet. Initialize this new group without major
-	 * and minor info and this info will be filled in once a new thread
-	 * comes for IO.
-	 */
-	if (bdi->dev) {
-		sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
-		blkg->dev = MKDEV(major, minor);
-	}
 
 	cfqd->nr_blkcg_linked_grps++;
 
@@ -2808,7 +2795,6 @@ static struct cfq_queue *
 cfq_find_alloc_queue(struct cfq_data *cfqd, bool is_sync,
 		     struct io_context *ioc, gfp_t gfp_mask)
 {
-	struct backing_dev_info *bdi = &cfqd->queue->backing_dev_info;
 	struct blkio_cgroup *blkcg;
 	struct cfq_queue *cfqq, *new_cfqq = NULL;
 	struct cfq_io_cq *cic;
@@ -2825,13 +2811,6 @@ retry:
 	else
 		cfqg = cfq_lookup_create_cfqg(cfqd, blkcg);
 
-	if (cfqg && !cfqg->blkg.dev && bdi->dev && dev_name(bdi->dev)) {
-		unsigned int major, minor;
-
-		sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
-		cfqg->blkg.dev = MKDEV(major, minor);
-	}
-
 	cic = cfq_cic_lookup(cfqd, ioc);
 	/* cic always exists here */
 	cfqq = cic_to_cfqq(cic, is_sync);
-- 
1.7.7.3

