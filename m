Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398Ab0EMP57 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 11:57:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:33061 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932285Ab0EMP50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 11:57:26 -0400
From: Tejun Heo <tj@kernel.org>
To: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com,
       linux-scsi@vger.kernel.org, James.Bottomley@suse.de,
       linux-kernel@vger.kernel.org
Cc: ben@decadent.org.uk, Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/4] libata: implement on-demand HPA unlocking
Date: Thu, 13 May 2010 17:56:46 +0200
Message-Id: <1273766206-17402-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1273766206-17402-1-git-send-email-tj@kernel.org>
References: <1273766206-17402-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 13 May 2010 15:56:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement ata_scsi_set_capacity() which will be called through SCSI
layer when block layer notices that partitions on a device extend
beyond the end of the device.  ata_scsi_set_capacity() requests EH to
unlock HPA, waits for completion and returns the current device
capacity.

This allows libata to unlock HPA on demand instead of having to decide
whether to unlock upfront.  Unlocking on demand is safer than
unlocking by upfront because some BIOSes write private data to the
area beyond HPA limit.  This was suggested by Ben Hutchings.

Signed-off-by: Tejun Heo <tj@kernel.org>
Suggested-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/ata/libata-core.c |    1 +
 drivers/ata/libata-scsi.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/libata.h    |    3 +++
 3 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 9d6e92d..56badb4 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6797,6 +6797,7 @@ EXPORT_SYMBOL_GPL(ata_dummy_port_info);
 EXPORT_SYMBOL_GPL(ata_link_next);
 EXPORT_SYMBOL_GPL(ata_dev_next);
 EXPORT_SYMBOL_GPL(ata_std_bios_param);
+EXPORT_SYMBOL_GPL(ata_scsi_set_capacity);
 EXPORT_SYMBOL_GPL(ata_host_init);
 EXPORT_SYMBOL_GPL(ata_host_alloc);
 EXPORT_SYMBOL_GPL(ata_host_alloc_pinfo);
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 0088cde..2523943 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -415,6 +415,48 @@ int ata_std_bios_param(struct scsi_device *sdev, struct block_device *bdev,
 }
 
 /**
+ *	ata_scsi_set_capacity - adjust device capacity
+ *	@sdev: SCSI device to adjust device capacity for
+ *	@new_capacity: new target capacity
+ *
+ *	This function is called if a partition on @sdev extends beyond
+ *	the end of the device.  It requests EH to unlock HPA and
+ *	returns the possibly adjusted capacity.
+ *
+ *	LOCKING:
+ *	Defined by the SCSI layer.  Might sleep.
+ *
+ *	RETURNS:
+ *	New capacity if adjusted successfully.  0 if device is not
+ *	found.
+ */
+sector_t ata_scsi_set_capacity(struct scsi_device *sdev, sector_t new_capacity)
+{
+	struct ata_port *ap = ata_shost_to_port(sdev->host);
+	sector_t capacity = 0;
+	struct ata_device *dev;
+	unsigned long flags;
+
+	spin_lock_irqsave(ap->lock, flags);
+
+	dev = ata_scsi_find_dev(ap, sdev);
+	if (dev && dev->n_sectors < new_capacity &&
+	    dev->n_sectors < dev->n_native_sectors) {
+		struct ata_eh_info *ehi = &dev->link->eh_info;
+
+		dev->flags |= ATA_DFLAG_UNLOCK_HPA;
+		ehi->action |= ATA_EH_RESET;
+		ata_port_schedule_eh(ap);
+		spin_unlock_irqrestore(ap->lock, flags);
+		ata_port_wait_eh(ap);
+		capacity = dev->n_sectors;
+	} else
+		spin_unlock_irqrestore(ap->lock, flags);
+
+	return capacity;
+}
+
+/**
  *	ata_get_identity - Handler for HDIO_GET_IDENTITY ioctl
  *	@ap: target port
  *	@sdev: SCSI device to get identify data for
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 242eb26..1082956 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1027,6 +1027,8 @@ extern void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd,
 extern int ata_std_bios_param(struct scsi_device *sdev,
 			      struct block_device *bdev,
 			      sector_t capacity, int geom[]);
+extern sector_t ata_scsi_set_capacity(struct scsi_device *sdev,
+				      sector_t new_capacity);
 extern int ata_scsi_slave_config(struct scsi_device *sdev);
 extern void ata_scsi_slave_destroy(struct scsi_device *sdev);
 extern int ata_scsi_change_queue_depth(struct scsi_device *sdev,
@@ -1181,6 +1183,7 @@ extern struct device_attribute *ata_common_sdev_attrs[];
 	.slave_configure	= ata_scsi_slave_config,	\
 	.slave_destroy		= ata_scsi_slave_destroy,	\
 	.bios_param		= ata_std_bios_param,		\
+	.set_capacity		= ata_scsi_set_capacity,	\
 	.sdev_attrs		= ata_common_sdev_attrs
 
 #define ATA_NCQ_SHT(drv_name)					\
-- 
1.6.4.2

