Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757942Ab1COOQq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 10:16:46 -0400
Received: from verein.lst.de ([213.95.11.211]:37048 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757900Ab1COOQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 10:16:45 -0400
Date: Tue, 15 Mar 2011 15:16:44 +0100
From: Christoph Hellwig <hch@lst.de>
To: qemu-devel@nongnu.org, linux-kernel@vger.kernel.org
Cc: stefanha@gmail.com, kwolf@redhat.com, prerna@linux.vnet.ibm.com,
        aliguori@us.ibm.com, rusty@rustcorp.com.au
Subject: [PATCH, RFC] virtio_blk: add cache control support
Message-ID: <20110315141644.GA30803@lst.de>
References: <20110315141049.GA30627@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110315141049.GA30627@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the new dynamic features config space field to allow
en/disabling the write cache at runtime.  The userspace interface is
a SCSI-compatible sysfs attribute.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/block/virtio_blk.c
===================================================================
--- linux-2.6.orig/drivers/block/virtio_blk.c	2011-03-15 12:16:29.156133695 +0100
+++ linux-2.6/drivers/block/virtio_blk.c	2011-03-15 13:17:30.160634723 +0100
@@ -291,6 +291,73 @@ static ssize_t virtblk_serial_show(struc
 }
 DEVICE_ATTR(serial, S_IRUGO, virtblk_serial_show, NULL);
 
+static bool virtblk_has_wb_cache(struct virtio_blk *vblk)
+{
+	struct virtio_device *vdev = vblk->vdev;
+	u32 features;
+
+	if (!virtio_has_feature(vdev, VIRTIO_BLK_F_FLUSH))
+		return false;
+	if (!virtio_has_feature(vdev, VIRTIO_BLK_F_DYNAMIC))
+		return true;
+
+	vdev->config->get(vdev, offsetof(struct virtio_blk_config, features),
+			  &features, sizeof(features));
+
+	if (features & VIRTIO_BLK_RT_WCE)
+		return true;
+	return false;
+}
+
+static ssize_t virtblk_cache_type_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct gendisk *disk = dev_to_disk(dev);
+
+	if (virtblk_has_wb_cache(disk->private_data))
+		return sprintf(buf, "write back\n");
+	else
+		return sprintf(buf, "write through\n");
+}
+
+static ssize_t virtblk_cache_type_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct gendisk *disk = dev_to_disk(dev);
+	struct virtio_blk *vblk = disk->private_data;
+	struct virtio_device *vdev = vblk->vdev;
+	u32 features, features2 = 0;
+
+	if (!virtio_has_feature(vdev, VIRTIO_BLK_F_FLUSH) ||
+	    !virtio_has_feature(vdev, VIRTIO_BLK_F_DYNAMIC))
+		return -ENXIO;
+
+	if (strncmp(buf, "write through", sizeof("write through") - 1) == 0) {
+		;
+	} else if (strncmp(buf, "write back", sizeof("write back") - 1) == 0) {
+		blk_queue_flush(disk->queue, REQ_FLUSH);
+		features |= VIRTIO_BLK_RT_WCE;
+	} else {
+		return -EINVAL;
+	}
+
+	vdev->config->set(vdev, offsetof(struct virtio_blk_config, features),
+	                  &features, sizeof(features));
+
+	vdev->config->get(vdev, offsetof(struct virtio_blk_config, features),
+			  &features2, sizeof(features2));
+
+	if ((features & VIRTIO_BLK_RT_WCE) !=
+	    (features2 & VIRTIO_BLK_RT_WCE))
+		return -EIO;
+
+	if (!(features2 & VIRTIO_BLK_RT_WCE))
+		blk_queue_flush(disk->queue, 0);
+	return count;
+}
+static DEVICE_ATTR(cache_type, S_IRUGO|S_IWUSR,
+	    virtblk_cache_type_show, virtblk_cache_type_store);
+
 static int __devinit virtblk_probe(struct virtio_device *vdev)
 {
 	struct virtio_blk *vblk;
@@ -377,7 +444,7 @@ static int __devinit virtblk_probe(struc
 	index++;
 
 	/* configure queue flush support */
-	if (virtio_has_feature(vdev, VIRTIO_BLK_F_FLUSH))
+	if (virtblk_has_wb_cache(vblk))
 		blk_queue_flush(q, REQ_FLUSH);
 
 	/* If disk is read-only in the host, the guest should obey */
@@ -456,6 +523,10 @@ static int __devinit virtblk_probe(struc
 	if (err)
 		goto out_del_disk;
 
+	err = device_create_file(disk_to_dev(vblk->disk), &dev_attr_cache_type);
+	if (err)
+		goto out_del_disk;
+
 	return 0;
 
 out_del_disk:
@@ -499,7 +570,7 @@ static const struct virtio_device_id id_
 static unsigned int features[] = {
 	VIRTIO_BLK_F_SEG_MAX, VIRTIO_BLK_F_SIZE_MAX, VIRTIO_BLK_F_GEOMETRY,
 	VIRTIO_BLK_F_RO, VIRTIO_BLK_F_BLK_SIZE, VIRTIO_BLK_F_SCSI,
-	VIRTIO_BLK_F_FLUSH, VIRTIO_BLK_F_TOPOLOGY
+	VIRTIO_BLK_F_FLUSH, VIRTIO_BLK_F_TOPOLOGY, VIRTIO_BLK_F_DYNAMIC
 };
 
 /*
Index: linux-2.6/include/linux/virtio_blk.h
===================================================================
--- linux-2.6.orig/include/linux/virtio_blk.h	2011-03-15 12:14:28.261632780 +0100
+++ linux-2.6/include/linux/virtio_blk.h	2011-03-15 12:25:56.308634399 +0100
@@ -16,6 +16,7 @@
 #define VIRTIO_BLK_F_SCSI	7	/* Supports scsi command passthru */
 #define VIRTIO_BLK_F_FLUSH	9	/* Cache flush command support */
 #define VIRTIO_BLK_F_TOPOLOGY	10	/* Topology information is available */
+#define VIRTIO_BLK_F_DYNAMIC	11	/* Dynamic features field */
 
 #define VIRTIO_BLK_ID_BYTES	20	/* ID string length */
 
@@ -45,6 +46,9 @@ struct virtio_blk_config {
 	__u16 min_io_size;
 	/* optimal sustained I/O size in logical blocks. */
 	__u32 opt_io_size;
+	/* runtime controllable features */
+	__u32 features;
+#define VIRTIO_BLK_RT_WCE		(1 << 0)
 
 } __attribute__((packed));
 
