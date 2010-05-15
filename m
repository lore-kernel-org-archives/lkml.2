Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657Ab0EOSKx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 14:10:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:40269 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755123Ab0EOSKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 14:10:23 -0400
From: Tejun Heo <tj@kernel.org>
To: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com,
       linux-scsi@vger.kernel.org, James.Bottomley@suse.de,
       linux-kernel@vger.kernel.org, ben@decadent.org.uk, davem@davemloft.net,
       bzolnier@gmail.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 8/8] libata: implement on-demand HPA unlocking
Date: Sat, 15 May 2010 20:09:34 +0200
Message-Id: <1273946974-29131-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1273946974-29131-1-git-send-email-tj@kernel.org>
References: <1273946974-29131-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 15 May 2010 18:09:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement ata_scsi_unlock_native_capacity() which will be called
through SCSI layer when block layer notices that partitions on a
device extend beyond the end of the device.  It requests EH to unlock
HPA, waits for completion and returns the current device capacity.

This allows libata to unlock HPA on demand instead of having to decide
whether to unlock upfront.  Unlocking on demand is safer than
unlocking by upfront because some BIOSes write private data to the
area beyond HPA limit.  This was suggested by Ben Hutchings.

Signed-off-by: Tejun Heo <tj@kernel.org>
Suggested-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/ata/libata-core.c |    1 +
 drivers/ata/libata-scsi.c |   29 +++++++++++++++++++++++++++++
 include/linux/libata.h    |    2 ++
 3 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 9d6e92d..b0e379d 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6797,6 +6797,7 @@ EXPORT_SYMBOL_GPL(ata_dummy_port_info);
 EXPORT_SYMBOL_GPL(ata_link_next);
 EXPORT_SYMBOL_GPL(ata_dev_next);
 EXPORT_SYMBOL_GPL(ata_std_bios_param);
+EXPORT_SYMBOL_GPL(ata_scsi_unlock_native_capacity);
 EXPORT_SYMBOL_GPL(ata_host_init);
 EXPORT_SYMBOL_GPL(ata_host_alloc);
 EXPORT_SYMBOL_GPL(ata_host_alloc_pinfo);
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 0088cde..fc51531 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -415,6 +415,35 @@ int ata_std_bios_param(struct scsi_device *sdev, struct block_device *bdev,
 }
 
 /**
+ *	ata_scsi_unlock_native_capacity - unlock native capacity
+ *	@sdev: SCSI device to adjust device capacity for
+ *
+ *	This function is called if a partition on @sdev extends beyond
+ *	the end of the device.  It requests EH to unlock HPA.
+ *
+ *	LOCKING:
+ *	Defined by the SCSI layer.  Might sleep.
+ */
+void ata_scsi_unlock_native_capacity(struct scsi_device *sdev)
+{
+	struct ata_port *ap = ata_shost_to_port(sdev->host);
+	struct ata_device *dev;
+	unsigned long flags;
+
+	spin_lock_irqsave(ap->lock, flags);
+
+	dev = ata_scsi_find_dev(ap, sdev);
+	if (dev && dev->n_sectors < dev->n_native_sectors) {
+		dev->flags |= ATA_DFLAG_UNLOCK_HPA;
+		dev->link->eh_info.action |= ATA_EH_RESET;
+		ata_port_schedule_eh(ap);
+	}
+
+	spin_unlock_irqrestore(ap->lock, flags);
+	ata_port_wait_eh(ap);
+}
+
+/**
  *	ata_get_identity - Handler for HDIO_GET_IDENTITY ioctl
  *	@ap: target port
  *	@sdev: SCSI device to get identify data for
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 242eb26..ab7d6de 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1027,6 +1027,7 @@ extern void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd,
 extern int ata_std_bios_param(struct scsi_device *sdev,
 			      struct block_device *bdev,
 			      sector_t capacity, int geom[]);
+extern void ata_scsi_unlock_native_capacity(struct scsi_device *sdev);
 extern int ata_scsi_slave_config(struct scsi_device *sdev);
 extern void ata_scsi_slave_destroy(struct scsi_device *sdev);
 extern int ata_scsi_change_queue_depth(struct scsi_device *sdev,
@@ -1181,6 +1182,7 @@ extern struct device_attribute *ata_common_sdev_attrs[];
 	.slave_configure	= ata_scsi_slave_config,	\
 	.slave_destroy		= ata_scsi_slave_destroy,	\
 	.bios_param		= ata_std_bios_param,		\
+	.unlock_native_capacity	= ata_scsi_unlock_native_capacity, \
 	.sdev_attrs		= ata_common_sdev_attrs
 
 #define ATA_NCQ_SHT(drv_name)					\
-- 
1.6.4.2

