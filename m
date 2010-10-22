Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759219Ab0JVS4A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:56:00 -0400
Received: from kroah.org ([198.145.64.141]:33943 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759209Ab0JVSz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:55:57 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:28 2010
Message-Id: <20101022185228.490059298@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:50:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>, Jeff Garzik <jgarzik@redhat.com>
Subject: [013/103] ahci: fix module refcount breakage introduced by libahci split
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <htejun@gmail.com>

commit fad16e7a7f67eef8d33f8ad58850db89382b09ce upstream.

libata depends on scsi_host_template for module reference counting and
sht's should be owned by each low level driver.  During libahci split,
the sht was left with libahci.ko leaving the actual low level drivers
not reference counted.  This made ahci and ahci_platform always
unloadable even while they're being actively used.

Fix it by defining AHCI_SHT() macro in ahci.h and defining a sht for
each low level ahci driver.

stable: only applicable to 2.6.35.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Pedro Francisco <pedrogfrancisco@gmail.com>
Tested-by: Michael Tokarev <mjt@tls.msk.ru>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/ahci.c          |    4 ++++
 drivers/ata/ahci.h          |   12 +++++++++++-
 drivers/ata/ahci_platform.c |    6 +++++-
 drivers/ata/libahci.c       |   16 ++++------------
 4 files changed, 24 insertions(+), 14 deletions(-)

--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -89,6 +89,10 @@ static int ahci_pci_device_suspend(struc
 static int ahci_pci_device_resume(struct pci_dev *pdev);
 #endif
 
+static struct scsi_host_template ahci_sht = {
+	AHCI_SHT("ahci"),
+};
+
 static struct ata_port_operations ahci_vt8251_ops = {
 	.inherits		= &ahci_ops,
 	.hardreset		= ahci_vt8251_hardreset,
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -297,7 +297,17 @@ struct ahci_host_priv {
 
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
@@ -140,7 +144,7 @@ static int __init ahci_probe(struct plat
 	ahci_print_info(host, "platform");
 
 	rc = ata_host_activate(host, irq, ahci_interrupt, IRQF_SHARED,
-			       &ahci_sht);
+			       &ahci_platform_sht);
 	if (rc)
 		goto err0;
 
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -121,7 +121,7 @@ static DEVICE_ATTR(ahci_port_cmd, S_IRUG
 static DEVICE_ATTR(em_buffer, S_IWUSR | S_IRUGO,
 		   ahci_read_em_buffer, ahci_store_em_buffer);
 
-static struct device_attribute *ahci_shost_attrs[] = {
+struct device_attribute *ahci_shost_attrs[] = {
 	&dev_attr_link_power_management_policy,
 	&dev_attr_em_message_type,
 	&dev_attr_em_message,
@@ -132,22 +132,14 @@ static struct device_attribute *ahci_sho
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


