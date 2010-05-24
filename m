Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083Ab0EXQeK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 12:34:10 -0400
Received: from mail-qy0-f183.google.com ([209.85.221.183]:53001 "EHLO
	mail-qy0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757244Ab0EXQeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 12:34:07 -0400
From: Will Drewry <wad@chromium.org>
To: dm-devel@redhat.com
Cc: agk@redhat.com, snitzer@redhat.com, linux-kernel@vger.kernel.org,
       Will Drewry <wad@chromium.org>
Subject: [PATCH 1/2] dm: ensure dm_table_complete() completes a table for use
Date: Mon, 24 May 2010 11:33:27 -0500
Message-Id: <1274718808-11194-1-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1274294304-30606-1-git-send-email-wad@chromium.org>
References: <1274294304-30606-1-git-send-email-wad@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset breaks up the patch linked below:
  https://patchwork.kernel.org/patch/101026/

This change unifies the various checks and finalization that occurs on a
table prior to use.  By doing so, it allows table construction without
traversing the dm-ioctl interface.

Signed-off-by: Will Drewry <wad@chromium.org>
---
 drivers/md/dm-ioctl.c |   34 ---------------------------------
 drivers/md/dm-table.c |   50 ++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 49 insertions(+), 35 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index d7500e1..dfde391 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1112,28 +1112,9 @@ static int populate_table(struct dm_table *table,
 		next = spec->next;
 	}
 
-	r = dm_table_set_type(table);
-	if (r) {
-		DMWARN("unable to set table type");
-		return r;
-	}
-
 	return dm_table_complete(table);
 }
 
-static int table_prealloc_integrity(struct dm_table *t,
-				    struct mapped_device *md)
-{
-	struct list_head *devices = dm_table_get_devices(t);
-	struct dm_dev_internal *dd;
-
-	list_for_each_entry(dd, devices, list)
-		if (bdev_get_integrity(dd->dm_dev.bdev))
-			return blk_integrity_register(dm_disk(md), NULL);
-
-	return 0;
-}
-
 static int table_load(struct dm_ioctl *param, size_t param_size)
 {
 	int r;
@@ -1155,21 +1136,6 @@ static int table_load(struct dm_ioctl *param, size_t param_size)
 		goto out;
 	}
 
-	r = table_prealloc_integrity(t, md);
-	if (r) {
-		DMERR("%s: could not register integrity profile.",
-		      dm_device_name(md));
-		dm_table_destroy(t);
-		goto out;
-	}
-
-	r = dm_table_alloc_md_mempools(t);
-	if (r) {
-		DMWARN("unable to allocate mempools for this table");
-		dm_table_destroy(t);
-		goto out;
-	}
-
 	down_write(&_hash_lock);
 	hc = dm_get_mdptr(md);
 	if (!hc || hc->md != md) {
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 9924ea2..ef6a3ab 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -900,7 +900,7 @@ static int setup_indexes(struct dm_table *t)
 /*
  * Builds the btree to index the map.
  */
-int dm_table_complete(struct dm_table *t)
+int dm_table_build_index(struct dm_table *t)
 {
 	int r = 0;
 	unsigned int leaf_nodes;
@@ -919,6 +919,54 @@ int dm_table_complete(struct dm_table *t)
 	return r;
 }
 
+/*
+ * Register the mapped device for blk_integrity support if
+ * the underlying devices support it.
+ */
+static int dm_table_prealloc_integrity(struct dm_table *t, struct mapped_device *md)
+{
+	struct list_head *devices = dm_table_get_devices(t);
+	struct dm_dev_internal *dd;
+
+	list_for_each_entry(dd, devices, list)
+		if (bdev_get_integrity(dd->dm_dev.bdev))
+			return blk_integrity_register(dm_disk(md), NULL);
+
+	return 0;
+}
+
+/*
+ * Prepares the table for use by building the indices,
+ * setting the type, and allocating mempools.
+ */
+int dm_table_complete(struct dm_table *t)
+{
+	int r = 0;
+	r = dm_table_set_type(t);
+	if (r) {
+		DMERR("unable to set table type");
+		return r;
+	}
+
+	r = dm_table_build_index(t);
+	if (r) {
+		DMERR("unable to build btrees");
+		return r;
+	}
+
+	r = dm_table_prealloc_integrity(t, t->md);
+	if (r) {
+		DMERR("could not register integrity profile.");
+		return r;
+	}
+
+	r = dm_table_alloc_md_mempools(t);
+	if (r) {
+		DMERR("unable to allocate mempools");
+	}
+	return r;
+}
+
 static DEFINE_MUTEX(_event_lock);
 void dm_table_event_callback(struct dm_table *t,
 			     void (*fn)(void *), void *context)
-- 
1.7.0.4

