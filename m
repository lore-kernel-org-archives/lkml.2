Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933125Ab2GCNUY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 09:20:24 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:51068 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932412Ab2GCNTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 09:19:54 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: rusty@rustcorp.com.au, kvm@vger.kernel.org
Subject: [PATCH] virtio-blk: allow toggling host cache between writeback and writethrough
Date: Tue,  3 Jul 2012 15:19:37 +0200
Message-Id: <1341321577-24435-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.10.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the new VIRTIO_BLK_F_CONFIG_WCE feature,
which exposes the cache mode in the configuration space and lets the
driver modify it.  The cache mode is exposed via sysfs.

Even if the host does not support the new feature, the cache mode is
visible (thanks to the existing VIRTIO_BLK_F_WCE), but not modifiable.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/block/virtio_blk.c |   90 ++++++++++++++++++++++++++++++++++++++++++-
 include/linux/virtio_blk.h |    5 ++-
 2 files changed, 91 insertions(+), 4 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 693187d..5602505 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -397,6 +397,83 @@ static int virtblk_name_format(char *prefix, int index, char *buf, int buflen)
 	return 0;
 }
 
+static int virtblk_get_cache_mode(struct virtio_device *vdev)
+{
+	u8 writeback;
+	int err;
+
+	err = virtio_config_val(vdev, VIRTIO_BLK_F_CONFIG_WCE,
+				offsetof(struct virtio_blk_config, wce),
+				&writeback);
+	if (err)
+		writeback = virtio_has_feature(vdev, VIRTIO_BLK_F_WCE);
+
+	return writeback;
+}
+
+static void virtblk_update_cache_mode(struct virtio_device *vdev)
+{
+	u8 writeback = virtblk_get_cache_mode(vdev);
+	struct virtio_blk *vblk = vdev->priv;
+
+	if (writeback)
+		blk_queue_flush(vblk->disk->queue, REQ_FLUSH);
+	else
+		blk_queue_flush(vblk->disk->queue, 0);
+
+       revalidate_disk(vblk->disk);
+}
+
+static const char *virtblk_cache_types[] = {
+	"write through", "write back"
+};
+
+static ssize_t
+virtblk_cache_type_store(struct device *dev, struct device_attribute *attr,
+			 const char *buf, size_t count)
+{
+	struct gendisk *disk = dev_to_disk(dev);
+	struct virtio_blk *vblk = disk->private_data;
+	struct virtio_device *vdev = vblk->vdev;
+	int i;
+	u8 writeback;
+
+	BUG_ON(!virtio_has_feature(vblk->vdev, VIRTIO_BLK_F_CONFIG_WCE));
+	for (i = ARRAY_SIZE(virtblk_cache_types); --i >= 0; )
+		if (sysfs_streq(buf, virtblk_cache_types[i]))
+			break;
+
+	if (i < 0)
+		return -EINVAL;
+
+	writeback = i;
+	vdev->config->set(vdev,
+			  offsetof(struct virtio_blk_config, wce),
+			  &writeback, sizeof(writeback));
+
+	virtblk_update_cache_mode(vdev);
+	return count;
+}
+
+static ssize_t
+virtblk_cache_type_show(struct device *dev, struct device_attribute *attr,
+			 char *buf)
+{
+	struct gendisk *disk = dev_to_disk(dev);
+	struct virtio_blk *vblk = disk->private_data;
+	u8 writeback = virtblk_get_cache_mode(vblk->vdev);
+
+	BUG_ON(writeback >= ARRAY_SIZE(virtblk_cache_types));
+	return snprintf(buf, 40, "%s\n", virtblk_cache_types[writeback]);
+}
+
+static const struct device_attribute dev_attr_cache_type_ro =
+	__ATTR(cache_type, S_IRUGO,
+	       virtblk_cache_type_show, NULL);
+static const struct device_attribute dev_attr_cache_type_rw =
+	__ATTR(cache_type, S_IRUGO|S_IWUSR,
+	       virtblk_cache_type_show, virtblk_cache_type_store);
+
 static int __devinit virtblk_probe(struct virtio_device *vdev)
 {
 	struct virtio_blk *vblk;
@@ -474,8 +549,7 @@ static int __devinit virtblk_probe(struct virtio_device *vdev)
 	vblk->index = index;
 
 	/* configure queue flush support */
-	if (virtio_has_feature(vdev, VIRTIO_BLK_F_FLUSH))
-		blk_queue_flush(q, REQ_FLUSH);
+	virtblk_update_cache_mode(vdev);
 
 	/* If disk is read-only in the host, the guest should obey */
 	if (virtio_has_feature(vdev, VIRTIO_BLK_F_RO))
@@ -553,6 +627,14 @@ static int __devinit virtblk_probe(struct virtio_device *vdev)
 	if (err)
 		goto out_del_disk;
 
+	if (virtio_has_feature(vdev, VIRTIO_BLK_F_CONFIG_WCE))
+		err = device_create_file(disk_to_dev(vblk->disk),
+					 &dev_attr_cache_type_rw);
+	else
+		err = device_create_file(disk_to_dev(vblk->disk),
+					 &dev_attr_cache_type_ro);
+	if (err)
+		goto out_del_disk;
 	return 0;
 
 out_del_disk:
@@ -655,7 +737,7 @@ static const struct virtio_device_id id_table[] = {
 static unsigned int features[] = {
 	VIRTIO_BLK_F_SEG_MAX, VIRTIO_BLK_F_SIZE_MAX, VIRTIO_BLK_F_GEOMETRY,
 	VIRTIO_BLK_F_RO, VIRTIO_BLK_F_BLK_SIZE, VIRTIO_BLK_F_SCSI,
-	VIRTIO_BLK_F_FLUSH, VIRTIO_BLK_F_TOPOLOGY
+	VIRTIO_BLK_F_WCE, VIRTIO_BLK_F_TOPOLOGY, VIRTIO_BLK_F_CONFIG_WCE
 };
 
 /*
diff --git a/include/linux/virtio_blk.h b/include/linux/virtio_blk.h
index e0edb40..18a1027 100644
--- a/include/linux/virtio_blk.h
+++ b/include/linux/virtio_blk.h
@@ -37,8 +37,9 @@
 #define VIRTIO_BLK_F_RO		5	/* Disk is read-only */
 #define VIRTIO_BLK_F_BLK_SIZE	6	/* Block size of disk is available*/
 #define VIRTIO_BLK_F_SCSI	7	/* Supports scsi command passthru */
-#define VIRTIO_BLK_F_FLUSH	9	/* Cache flush command support */
+#define VIRTIO_BLK_F_WCE	9	/* Writeback mode enabled after reset */
 #define VIRTIO_BLK_F_TOPOLOGY	10	/* Topology information is available */
+#define VIRTIO_BLK_F_CONFIG_WCE	11	/* Writeback mode available in config */
 
 #define VIRTIO_BLK_ID_BYTES	20	/* ID string length */
 
@@ -69,6 +70,8 @@ struct virtio_blk_config {
 	/* optimal sustained I/O size in logical blocks. */
 	__u32 opt_io_size;
 
+        /* writeback mode (if VIRTIO_BLK_F_CONFIG_WCE) */
+        __u8 wce;
 } __attribute__((packed));
 
 /*
-- 
1.7.1

