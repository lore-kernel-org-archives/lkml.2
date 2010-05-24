Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757927Ab0EXQeI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 12:34:08 -0400
Received: from mail-qy0-f183.google.com ([209.85.221.183]:41011 "EHLO
	mail-qy0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982Ab0EXQeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 12:34:05 -0400
From: Will Drewry <wad@chromium.org>
To: dm-devel@redhat.com
Cc: agk@redhat.com, snitzer@redhat.com, linux-kernel@vger.kernel.org,
       Will Drewry <wad@chromium.org>
Subject: [PATCH 2/2] dm: export a table+mapped device to the ioctl interface
Date: Mon, 24 May 2010 11:33:28 -0500
Message-Id: <1274718808-11194-2-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1274294304-30606-1-git-send-email-wad@chromium.org>
References: <1274294304-30606-1-git-send-email-wad@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a mapped device and table is configured without traversing
the dm-ioctl interface (dm-fs-style), then it will not be bound
to a name or uuid.  This means that it will be inaccessible for
userspace management and udev will be unhappy with the lack of
a name or uuid.

The function added in this change performs the required association
to transition to being managed by the ioctl interface.

Signed-off-by: Will Drewry <wad@chromium.org>
---
 drivers/md/dm-ioctl.c         |   38 ++++++++++++++++++++++++++++++++++++++
 include/linux/device-mapper.h |    6 ++++++
 2 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index dfde391..8c73b20 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1604,6 +1604,44 @@ void dm_interface_exit(void)
 }
 
 /**
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
+
+/**
  * dm_copy_name_and_uuid - Copy mapped device name & uuid into supplied buffers
  * @md: Pointer to mapped_device
  * @name: Buffer (size DM_NAME_LEN) for name
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 1381cd9..0792cf3 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -215,6 +215,12 @@ void dm_set_mdptr(struct mapped_device *md, void *ptr);
 void *dm_get_mdptr(struct mapped_device *md);
 
 /*
+ * Export the device via the ioctl interface (uses mdptr).
+ */
+int dm_ioctl_export(struct mapped_device *md, const char *name,
+		    const char *uuid);
+
+/*
  * A device can still be used while suspended, but I/O is deferred.
  */
 int dm_suspend(struct mapped_device *md, unsigned suspend_flags);
-- 
1.7.0.4

