Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab1BPRxX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 12:53:23 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:34623 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709Ab1BPRxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 12:53:17 -0500
X-IronPort-AV: E=Sophos;i="4.60,480,1291611600"; 
   d="scan'208";a="136190312"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, Jeremy.Fitzhardinge@citrix.com,
        konrad.wilk@oracle.com, Stefano.Stabellini@eu.citrix.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 3/7] xen-blkfront: handle Xen major numbers other than XENVBD
Date: Wed, 16 Feb 2011 17:53:03 +0000
Message-Id: <1297878787-378-3-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1102161739370.2826@kaball-desktop>
References: <alpine.DEB.2.00.1102161739370.2826@kaball-desktop>
X-OriginalArrivalTime: 16 Feb 2011 17:53:15.0558 (UTC) FILETIME=[62F39C60:01CBCE02]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

This patch makes sure blkfront handles correctly virtual device numbers
corresponding to Xen emulated IDE and SCSI disks: in those cases
blkfront translates the major number to XENVBD and the minor number to a
low xvd minor.

Note: this behaviour is different from what old xenlinux PV guests used
to do: they used to steal an IDE or SCSI major number and use it
instead.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Acked-by: Jeremy Fitzhardinge <jeremy@goop.org>
---
 drivers/block/xen-blkfront.c     |   79 +++++++++++++++++++++++++++++++++++--
 include/xen/interface/io/blkif.h |   21 ++++++++++
 2 files changed, 95 insertions(+), 5 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index d7aa39e..64d9c6d 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -120,6 +120,10 @@ static DEFINE_SPINLOCK(minor_lock);
 #define EXTENDED (1<<EXT_SHIFT)
 #define VDEV_IS_EXTENDED(dev) ((dev)&(EXTENDED))
 #define BLKIF_MINOR_EXT(dev) ((dev)&(~EXTENDED))
+#define EMULATED_HD_DISK_MINOR_OFFSET (0)
+#define EMULATED_HD_DISK_NAME_OFFSET (EMULATED_HD_DISK_MINOR_OFFSET / 256)
+#define EMULATED_SD_DISK_MINOR_OFFSET (EMULATED_HD_DISK_MINOR_OFFSET + (4 * 16))
+#define EMULATED_SD_DISK_NAME_OFFSET (EMULATED_HD_DISK_NAME_OFFSET + 4)
 
 #define DEV_NAME	"xvd"	/* name in /dev */
 
@@ -434,6 +438,65 @@ static void xlvbd_flush(struct blkfront_info *info)
 	       info->feature_flush ? "enabled" : "disabled");
 }
 
+static int xen_translate_vdev(int vdevice, int *minor, unsigned int *offset)
+{
+	int major;
+	major = BLKIF_MAJOR(vdevice);
+	*minor = BLKIF_MINOR(vdevice);
+	switch (major) {
+		case XEN_IDE0_MAJOR:
+			*offset = (*minor / 64) + EMULATED_HD_DISK_NAME_OFFSET;
+			*minor = ((*minor / 64) * PARTS_PER_DISK) +
+				EMULATED_HD_DISK_MINOR_OFFSET;
+			break;
+		case XEN_IDE1_MAJOR:
+			*offset = (*minor / 64) + 2 + EMULATED_HD_DISK_NAME_OFFSET;
+			*minor = (((*minor / 64) + 2) * PARTS_PER_DISK) +
+				EMULATED_HD_DISK_MINOR_OFFSET;
+			break;
+		case XEN_SCSI_DISK0_MAJOR:
+			*offset = (*minor / PARTS_PER_DISK) + EMULATED_SD_DISK_NAME_OFFSET;
+			*minor = *minor + EMULATED_SD_DISK_MINOR_OFFSET;
+			break;
+		case XEN_SCSI_DISK1_MAJOR:
+		case XEN_SCSI_DISK2_MAJOR:
+		case XEN_SCSI_DISK3_MAJOR:
+		case XEN_SCSI_DISK4_MAJOR:
+		case XEN_SCSI_DISK5_MAJOR:
+		case XEN_SCSI_DISK6_MAJOR:
+		case XEN_SCSI_DISK7_MAJOR:
+			*offset = (*minor / PARTS_PER_DISK) + 
+				((major - XEN_SCSI_DISK1_MAJOR + 1) * 16) +
+				EMULATED_SD_DISK_NAME_OFFSET;
+			*minor = *minor +
+				((major - XEN_SCSI_DISK1_MAJOR + 1) * 16 * PARTS_PER_DISK) +
+				EMULATED_SD_DISK_MINOR_OFFSET;
+			break;
+		case XEN_SCSI_DISK8_MAJOR:
+		case XEN_SCSI_DISK9_MAJOR:
+		case XEN_SCSI_DISK10_MAJOR:
+		case XEN_SCSI_DISK11_MAJOR:
+		case XEN_SCSI_DISK12_MAJOR:
+		case XEN_SCSI_DISK13_MAJOR:
+		case XEN_SCSI_DISK14_MAJOR:
+		case XEN_SCSI_DISK15_MAJOR:
+			*offset = (*minor / PARTS_PER_DISK) + 
+				((major - XEN_SCSI_DISK8_MAJOR + 8) * 16) +
+				EMULATED_SD_DISK_NAME_OFFSET;
+			*minor = *minor +
+				((major - XEN_SCSI_DISK8_MAJOR + 8) * 16 * PARTS_PER_DISK) +
+				EMULATED_SD_DISK_MINOR_OFFSET;
+			break;
+		case XENVBD_MAJOR:
+			*offset = *minor / PARTS_PER_DISK;
+			break;
+		default:
+			printk(KERN_WARNING "blkfront: your disk configuration is "
+					"incorrect, please use an xvd device instead\n");
+			return -ENODEV;
+	}
+	return 0;
+}
 
 static int xlvbd_alloc_gendisk(blkif_sector_t capacity,
 			       struct blkfront_info *info,
@@ -441,7 +504,7 @@ static int xlvbd_alloc_gendisk(blkif_sector_t capacity,
 {
 	struct gendisk *gd;
 	int nr_minors = 1;
-	int err = -ENODEV;
+	int err;
 	unsigned int offset;
 	int minor;
 	int nr_parts;
@@ -456,12 +519,20 @@ static int xlvbd_alloc_gendisk(blkif_sector_t capacity,
 	}
 
 	if (!VDEV_IS_EXTENDED(info->vdevice)) {
-		minor = BLKIF_MINOR(info->vdevice);
-		nr_parts = PARTS_PER_DISK;
+		err = xen_translate_vdev(info->vdevice, &minor, &offset);
+		if (err)
+			return err;		
+ 		nr_parts = PARTS_PER_DISK;
 	} else {
 		minor = BLKIF_MINOR_EXT(info->vdevice);
 		nr_parts = PARTS_PER_EXT_DISK;
+		offset = minor / nr_parts;
+		if (xen_hvm_domain() && offset <= EMULATED_HD_DISK_NAME_OFFSET + 4)
+			printk(KERN_WARNING "blkfront: vdevice 0x%x might conflict with "
+					"emulated IDE disks,\n\t choose an xvd device name"
+					"from xvde on\n", info->vdevice);
 	}
+	err = -ENODEV;
 
 	if ((minor % nr_parts) == 0)
 		nr_minors = nr_parts;
@@ -475,8 +546,6 @@ static int xlvbd_alloc_gendisk(blkif_sector_t capacity,
 	if (gd == NULL)
 		goto release;
 
-	offset = minor / nr_parts;
-
 	if (nr_minors > 1) {
 		if (offset < 26)
 			sprintf(gd->disk_name, "%s%c", DEV_NAME, 'a' + offset);
diff --git a/include/xen/interface/io/blkif.h b/include/xen/interface/io/blkif.h
index c2d1fa4..68dd2b4 100644
--- a/include/xen/interface/io/blkif.h
+++ b/include/xen/interface/io/blkif.h
@@ -91,4 +91,25 @@ DEFINE_RING_TYPES(blkif, struct blkif_request, struct blkif_response);
 #define VDISK_REMOVABLE    0x2
 #define VDISK_READONLY     0x4
 
+/* Xen-defined major numbers for virtual disks, they look strangely
+ * familiar */
+#define XEN_IDE0_MAJOR	3
+#define XEN_IDE1_MAJOR	22
+#define XEN_SCSI_DISK0_MAJOR	8
+#define XEN_SCSI_DISK1_MAJOR	65
+#define XEN_SCSI_DISK2_MAJOR	66
+#define XEN_SCSI_DISK3_MAJOR	67
+#define XEN_SCSI_DISK4_MAJOR	68
+#define XEN_SCSI_DISK5_MAJOR	69
+#define XEN_SCSI_DISK6_MAJOR	70
+#define XEN_SCSI_DISK7_MAJOR	71
+#define XEN_SCSI_DISK8_MAJOR	128
+#define XEN_SCSI_DISK9_MAJOR	129
+#define XEN_SCSI_DISK10_MAJOR	130
+#define XEN_SCSI_DISK11_MAJOR	131
+#define XEN_SCSI_DISK12_MAJOR	132
+#define XEN_SCSI_DISK13_MAJOR	133
+#define XEN_SCSI_DISK14_MAJOR	134
+#define XEN_SCSI_DISK15_MAJOR	135
+
 #endif /* __XEN_PUBLIC_IO_BLKIF_H__ */
-- 
1.5.6.5

