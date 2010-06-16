Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759491Ab0FPTsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 15:48:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759270Ab0FPTsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 15:48:41 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] dm: discard support for the linear target
Date: Wed, 16 Jun 2010 15:48:34 -0400
Message-Id: <1276717714-16750-1-git-send-email-snitzer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow discards to be passed through to a single device linear mapping.
Introduce DM_TARGET_SUPPORTS_DISCARDS target features flag that each
target must set once discard support is added.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-linear.c        |    1 +
 drivers/md/dm-table.c         |   20 +++++++++++++
 drivers/md/dm.c               |   61 +++++++++++++++++++++++++++++++++--------
 drivers/md/dm.h               |    1 +
 include/linux/device-mapper.h |    1 +
 5 files changed, 72 insertions(+), 12 deletions(-)

diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 9200dbf..7071f17 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -152,6 +152,7 @@ static struct target_type linear_target = {
 	.ioctl  = linear_ioctl,
 	.merge  = linear_merge,
 	.iterate_devices = linear_iterate_devices,
+	.features = DM_TARGET_SUPPORTS_DISCARDS,
 };
 
 int __init dm_linear_init(void)
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 9924ea2..7671665 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -54,6 +54,8 @@ struct dm_table {
 	sector_t *highs;
 	struct dm_target *targets;
 
+	unsigned discards_supported:1;
+
 	/*
 	 * Indicates the rw permissions for the new logical
 	 * device.  This should be a combination of FMODE_READ
@@ -203,6 +205,7 @@ int dm_table_create(struct dm_table **result, fmode_t mode,
 
 	INIT_LIST_HEAD(&t->devices);
 	atomic_set(&t->holders, 0);
+	t->discards_supported = 1;
 
 	if (!num_targets)
 		num_targets = KEYS_PER_NODE;
@@ -770,6 +773,9 @@ int dm_table_add_target(struct dm_table *t, const char *type,
 
 	t->highs[t->num_targets++] = tgt->begin + tgt->len - 1;
 
+	if (!(tgt->type->features & DM_TARGET_SUPPORTS_DISCARDS))
+		t->discards_supported = 0;
+
 	return 0;
 
  bad:
@@ -905,6 +911,12 @@ int dm_table_complete(struct dm_table *t)
 	int r = 0;
 	unsigned int leaf_nodes;
 
+	/*
+	 * We only support discards if there is exactly one underlying device.
+	 */
+	if (!list_is_singular(&t->devices))
+		t->discards_supported = 0;
+
 	/* how many indexes will the btree have ? */
 	leaf_nodes = dm_div_up(t->num_targets, KEYS_PER_NODE);
 	t->depth = 1 + int_log(leaf_nodes, CHILDREN_PER_NODE);
@@ -1086,6 +1098,9 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	else
 		queue_flag_set_unlocked(QUEUE_FLAG_CLUSTER, q);
 
+	if (dm_table_supports_discards(t))
+		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, q);
+
 	dm_table_set_integrity(t);
 
 	/*
@@ -1232,6 +1247,11 @@ struct mapped_device *dm_table_get_md(struct dm_table *t)
 	return t->md;
 }
 
+bool dm_table_supports_discards(struct dm_table *t)
+{
+	return t->discards_supported;
+}
+
 EXPORT_SYMBOL(dm_vcalloc);
 EXPORT_SYMBOL(dm_get_device);
 EXPORT_SYMBOL(dm_put_device);
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 0f53d1c..b029a37 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1198,6 +1198,49 @@ static int __clone_and_map_empty_barrier(struct clone_info *ci)
 	return 0;
 }
 
+/*
+ * Perform all io with a single clone.
+ */
+static void __clone_and_map_simple(struct clone_info *ci, struct dm_target *ti)
+{
+	struct bio *clone, *bio = ci->bio;
+	struct dm_target_io *tio;
+
+	tio = alloc_tio(ci, ti);
+	clone = clone_bio(bio, ci->sector, ci->idx,
+			  bio->bi_vcnt - ci->idx, ci->sector_count,
+			  ci->md->bs);
+	__map_bio(ti, clone, tio);
+	ci->sector_count = 0;
+}
+
+static int __clone_and_map_discard(struct clone_info *ci)
+{
+	struct dm_target *ti;
+	sector_t max;
+
+	if (!dm_table_supports_discards(ci->map))
+		return -EOPNOTSUPP;
+
+	ti = dm_table_find_target(ci->map, ci->sector);
+	if (!dm_target_is_valid(ti))
+		return -EIO;
+
+	max = max_io_len(ci->md, ci->sector, ti);
+
+	if (ci->sector_count <= max)
+		__clone_and_map_simple(ci, ti);
+	else {
+		/*
+		 * FIXME: handle discards that span targets; allocating biovec
+		 * with 1 page (logical_block_size) payload for each clone.
+		 */
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static int __clone_and_map(struct clone_info *ci)
 {
 	struct bio *clone, *bio = ci->bio;
@@ -1208,27 +1251,21 @@ static int __clone_and_map(struct clone_info *ci)
 	if (unlikely(bio_empty_barrier(bio)))
 		return __clone_and_map_empty_barrier(ci);
 
+	if (unlikely(bio_rw_flagged(bio, BIO_RW_DISCARD)))
+		return __clone_and_map_discard(ci);
+
 	ti = dm_table_find_target(ci->map, ci->sector);
 	if (!dm_target_is_valid(ti))
 		return -EIO;
 
 	max = max_io_len(ci->md, ci->sector, ti);
 
-	/*
-	 * Allocate a target io object.
-	 */
-	tio = alloc_tio(ci, ti);
-
 	if (ci->sector_count <= max) {
 		/*
 		 * Optimise for the simple case where we can do all of
 		 * the remaining io with a single clone.
 		 */
-		clone = clone_bio(bio, ci->sector, ci->idx,
-				  bio->bi_vcnt - ci->idx, ci->sector_count,
-				  ci->md->bs);
-		__map_bio(ti, clone, tio);
-		ci->sector_count = 0;
+		__clone_and_map_simple(ci, ti);
 
 	} else if (to_sector(bio->bi_io_vec[ci->idx].bv_len) <= max) {
 		/*
@@ -1249,6 +1286,7 @@ static int __clone_and_map(struct clone_info *ci)
 			len += bv_len;
 		}
 
+		tio = alloc_tio(ci, ti);
 		clone = clone_bio(bio, ci->sector, ci->idx, i - ci->idx, len,
 				  ci->md->bs);
 		__map_bio(ti, clone, tio);
@@ -1272,12 +1310,11 @@ static int __clone_and_map(struct clone_info *ci)
 					return -EIO;
 
 				max = max_io_len(ci->md, ci->sector, ti);
-
-				tio = alloc_tio(ci, ti);
 			}
 
 			len = min(remaining, max);
 
+			tio = alloc_tio(ci, ti);
 			clone = split_bvec(bio, ci->sector, ci->idx,
 					   bv->bv_offset + offset, len,
 					   ci->md->bs);
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 664a5ae..032ce2f 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -62,6 +62,7 @@ int dm_table_any_busy_target(struct dm_table *t);
 int dm_table_set_type(struct dm_table *t);
 unsigned dm_table_get_type(struct dm_table *t);
 bool dm_table_request_based(struct dm_table *t);
+bool dm_table_supports_discards(struct dm_table *t);
 int dm_table_alloc_md_mempools(struct dm_table *t);
 void dm_table_free_md_mempools(struct dm_table *t);
 struct dm_md_mempools *dm_table_get_md_mempools(struct dm_table *t);
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 1381cd9..e44cbcb 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -130,6 +130,7 @@ void dm_put_device(struct dm_target *ti, struct dm_dev *d);
 /*
  * Target features
  */
+#define DM_TARGET_SUPPORTS_DISCARDS 0x00000001
 
 struct target_type {
 	uint64_t features;
