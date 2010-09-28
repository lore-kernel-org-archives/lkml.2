Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895Ab0I1TQi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 15:16:38 -0400
Received: from havoc.gtf.org ([69.61.125.42]:46143 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752510Ab0I1TQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 15:16:37 -0400
Date: Tue, 28 Sep 2010 15:16:36 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patch] libata fix
Message-ID: <20100928191636.GA11706@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ahci.c          |    4 ++++
 drivers/ata/ahci.h          |   12 +++++++++++-
 drivers/ata/ahci_platform.c |    6 +++++-
 drivers/ata/libahci.c       |   16 ++++------------
 4 files changed, 24 insertions(+), 14 deletions(-)

Tejun Heo (1):
      ahci: fix module refcount breakage introduced by libahci split

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index ff1c945..99d0e5a 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -90,6 +90,10 @@ static int ahci_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg);
 static int ahci_pci_device_resume(struct pci_dev *pdev);
 #endif
 
+static struct scsi_host_template ahci_sht = {
+	AHCI_SHT("ahci"),
+};
+
 static struct ata_port_operations ahci_vt8251_ops = {
 	.inherits		= &ahci_ops,
 	.hardreset		= ahci_vt8251_hardreset,
diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index 474427b..e5fdeeb 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -298,7 +298,17 @@ struct ahci_host_priv {
 
 extern int ahci_ignore_sss;
 
-extern struct scsi_host_template ahci_sht;
+extern struct device_attribute *ahci_shost_attrs[];
+extern struct device_attribute *ahci_sdev_attrs[];
+
+#define AHCI_SHT(drv_name)						\
+	ATA_NCQ_SHT(drv_name),						\
+	.can_queue		= AHCI_MAX_CMDS - 1,			\
+	.sg_tablesize		= AHCI_MAX_SG,				\
+	.dma_boundary		= AHCI_DMA_BOUNDARY,			\
+	.shost_attrs		= ahci_shost_attrs,			\
+	.sdev_attrs		= ahci_sdev_attrs
+
 extern struct ata_port_operations ahci_ops;
 
 void ahci_save_initial_config(struct device *dev,
diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
index 4e97f33..84b6432 100644
--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -23,6 +23,10 @@
 #include <linux/ahci_platform.h>
 #include "ahci.h"
 
+static struct scsi_host_template ahci_platform_sht = {
+	AHCI_SHT("ahci_platform"),
+};
+
 static int __init ahci_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -145,7 +149,7 @@ static int __init ahci_probe(struct platform_device *pdev)
 	ahci_print_info(host, "platform");
 
 	rc = ata_host_activate(host, irq, ahci_interrupt, IRQF_SHARED,
-			       &ahci_sht);
+			       &ahci_platform_sht);
 	if (rc)
 		goto err0;
 
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 68dc678..8eea309 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -121,7 +121,7 @@ static DEVICE_ATTR(ahci_port_cmd, S_IRUGO, ahci_show_port_cmd, NULL);
 static DEVICE_ATTR(em_buffer, S_IWUSR | S_IRUGO,
 		   ahci_read_em_buffer, ahci_store_em_buffer);
 
-static struct device_attribute *ahci_shost_attrs[] = {
+struct device_attribute *ahci_shost_attrs[] = {
 	&dev_attr_link_power_management_policy,
 	&dev_attr_em_message_type,
 	&dev_attr_em_message,
@@ -132,22 +132,14 @@ static struct device_attribute *ahci_shost_attrs[] = {
 	&dev_attr_em_buffer,
 	NULL
 };
+EXPORT_SYMBOL_GPL(ahci_shost_attrs);
 
-static struct device_attribute *ahci_sdev_attrs[] = {
+struct device_attribute *ahci_sdev_attrs[] = {
 	&dev_attr_sw_activity,
 	&dev_attr_unload_heads,
 	NULL
 };
-
-struct scsi_host_template ahci_sht = {
-	ATA_NCQ_SHT("ahci"),
-	.can_queue		= AHCI_MAX_CMDS - 1,
-	.sg_tablesize		= AHCI_MAX_SG,
-	.dma_boundary		= AHCI_DMA_BOUNDARY,
-	.shost_attrs		= ahci_shost_attrs,
-	.sdev_attrs		= ahci_sdev_attrs,
-};
-EXPORT_SYMBOL_GPL(ahci_sht);
+EXPORT_SYMBOL_GPL(ahci_sdev_attrs);
 
 struct ata_port_operations ahci_ops = {
 	.inherits		= &sata_pmp_port_ops,
