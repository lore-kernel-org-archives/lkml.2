Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803Ab0EOBmV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 21:42:21 -0400
Received: from mail-gx0-f217.google.com ([209.85.217.217]:42401 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754626Ab0EOBmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 21:42:14 -0400
From: Will Drewry <wad@chromium.org>
To: dm-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: agk@redhat.com, snitzer@redhat.com, Will Drewry <wad@chromium.org>
Subject: [RFC PATCH v2 1/2] dm: allow a dm-fs-style device to be shared via dm-ioctl
Date: Fri, 14 May 2010 20:41:40 -0500
Message-Id: <1273887701-2152-1-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <20100514035347.GA20636@redhat.com>
References: <20100514035347.GA20636@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change adds one function which is used for binding
a given mapped device to a name+uuid in the dm-ioctl hash table.
In addition, it ensures that public functions are available that
allow mapped devices and tables to be created and associated
with the shared code paths with dm-ioctl:
- suspend flags are available
- dm_table_complete() now prepares a table for use completely

Signed-off-by: Will Drewry <wad@chromium.org>
---
 drivers/md/dm-ioctl.c         |   72 +++++++++++++++++++++-------------------
 drivers/md/dm-table.c         |   50 ++++++++++++++++++++++++++++-
 drivers/md/dm.h               |    6 ---
 include/linux/device-mapper.h |   12 +++++++
 4 files changed, 99 insertions(+), 41 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index d7500e1..006be9d 100644
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
@@ -1637,6 +1603,44 @@ void dm_interface_exit(void)
 	dm_hash_exit();
 }
 
+
+/**
+ * dm_ioctl_export - Permanently export a mapped device via the ioctl interface
+ * @md: Pointer to mapped_device
+ * @name: Buffer (size DM_NAME_LEN) for name
+ * @uuid: Buffer (size DM_UUID_LEN) for uuid or NULL if not desired
+ */
+int dm_ioctl_export(struct mapped_device *md, const char *name, const char *uuid)
+{
+	int r = 0;
+	struct hash_cell *hc;
+
+	if (!md) {
+		r = -ENXIO;
+		goto out;
+	}
+
+	/* The name and uuid can only be set once. */
+	mutex_lock(&dm_hash_cells_mutex);
+	hc = dm_get_mdptr(md);
+	mutex_unlock(&dm_hash_cells_mutex);
+	if (hc) {
+		DMERR("%s: already exported", dm_device_name(md));
+		r = -ENXIO;
+		goto out;
+	}
+
+	r = dm_hash_insert(name, uuid, md);
+	if (r) {
+		DMERR("%s: could not bind to '%s'", dm_device_name(md), name);
+		goto out;
+	}
+
+	/* Let udev know we've changed. */
+	dm_kobject_uevent(md, KOBJ_CHANGE, dm_get_event_nr(md));
+out:
+	return r;
+}
 /**
  * dm_copy_name_and_uuid - Copy mapped device name & uuid into supplied buffers
  * @md: Pointer to mapped_device
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
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index bad1724..782d867 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -17,12 +17,6 @@
 #include <linux/hdreg.h>
 
 /*
- * Suspend feature flags
- */
-#define DM_SUSPEND_LOCKFS_FLAG		(1 << 0)
-#define DM_SUSPEND_NOFLUSH_FLAG		(1 << 1)
-
-/*
  * Type of table and mapped_device's mempool
  */
 #define DM_TYPE_NONE		0
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 1381cd9..6c1c230 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -215,6 +215,18 @@ void dm_set_mdptr(struct mapped_device *md, void *ptr);
 void *dm_get_mdptr(struct mapped_device *md);
 
 /*
+ * Export the device via the ioctl interface (uses mdptr).
+ */
+int dm_ioctl_export(struct mapped_device *md, const char *name,
+		    const char *uuid);
+
+/*
+ * Suspend feature flags
+ */
+#define DM_SUSPEND_LOCKFS_FLAG		(1 << 0)
+#define DM_SUSPEND_NOFLUSH_FLAG		(1 << 1)
+
+/*
  * A device can still be used while suspended, but I/O is deferred.
  */
 int dm_suspend(struct mapped_device *md, unsigned suspend_flags);
-- 
1.7.0.4

