Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397Ab1JMNUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 09:20:55 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35111 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755252Ab1JMNUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 09:20:53 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH 1/3] pata_legacy: unify QDI ->set_piomode methods
Date: Thu, 13 Oct 2011 15:06:56 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop-dirty; KDE/4.6.0; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110131506.56514.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_legacy: unify QDI ->set_piomode methods

Add controller type field to struct legacy_data and then use it
to merge together all ->set_piomode methods for QDI controllers.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
earlier references:
https://lkml.org/lkml/2009/11/25/362

 drivers/ata/pata_legacy.c |   98 ++++++++++------------------------------------
 1 file changed, 23 insertions(+), 75 deletions(-)

Index: b/drivers/ata/pata_legacy.c
===================================================================
--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -76,15 +76,6 @@ static int all;
 module_param(all, int, 0444);
 MODULE_PARM_DESC(all, "Grab all legacy port devices, even if PCI(0=off, 1=on)");
 
-struct legacy_data {
-	unsigned long timing;
-	u8 clock[2];
-	u8 last;
-	int fast;
-	struct platform_device *platform_dev;
-
-};
-
 enum controller {
 	BIOS = 0,
 	SNOOP = 1,
@@ -101,6 +92,14 @@ enum controller {
 	UNKNOWN = -1
 };
 
+struct legacy_data {
+	unsigned long timing;
+	u8 clock[2];
+	u8 last;
+	int fast;
+	enum controller type;
+	struct platform_device *platform_dev;
+};
 
 struct legacy_probe {
 	unsigned char *name;
@@ -622,40 +621,20 @@ static struct ata_port_operations opti82
 	.qc_issue	= opti82c46x_qc_issue,
 };
 
-static void qdi6500_set_piomode(struct ata_port *ap, struct ata_device *adev)
-{
-	struct ata_timing t;
-	struct legacy_data *ld_qdi = ap->host->private_data;
-	int active, recovery;
-	u8 timing;
-
-	/* Get the timing data in cycles */
-	ata_timing_compute(adev, adev->pio_mode, &t, 30303, 1000);
-
-	if (ld_qdi->fast) {
-		active = 8 - clamp_val(t.active, 1, 8);
-		recovery = 18 - clamp_val(t.recover, 3, 18);
-	} else {
-		active = 9 - clamp_val(t.active, 2, 9);
-		recovery = 15 - clamp_val(t.recover, 0, 15);
-	}
-	timing = (recovery << 4) | active | 0x08;
-
-	ld_qdi->clock[adev->devno] = timing;
-
-	outb(timing, ld_qdi->timing);
-}
-
 /**
- *	qdi6580dp_set_piomode		-	PIO setup for dual channel
+ *	qdi65x0_set_piomode		-	PIO setup for QDI65x0
  *	@ap: Port
  *	@adev: Device
  *
+ *	In single channel mode the 6580 has one clock per device and we can
+ *	avoid the requirement to clock switch. We also have to load the timing
+ *	into the right clock according to whether we are master or slave.
+ *
  *	In dual channel mode the 6580 has one clock per channel and we have
  *	to software clockswitch in qc_issue.
  */
 
-static void qdi6580dp_set_piomode(struct ata_port *ap, struct ata_device *adev)
+static void qdi65x0_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
 	struct ata_timing t;
 	struct legacy_data *ld_qdi = ap->host->private_data;
@@ -673,47 +652,15 @@ static void qdi6580dp_set_piomode(struct
 		recovery = 15 - clamp_val(t.recover, 0, 15);
 	}
 	timing = (recovery << 4) | active | 0x08;
-
 	ld_qdi->clock[adev->devno] = timing;
 
-	outb(timing, ld_qdi->timing + 2 * ap->port_no);
-	/* Clear the FIFO */
-	if (adev->class != ATA_DEV_ATA)
-		outb(0x5F, (ld_qdi->timing & 0xFFF0) + 3);
-}
-
-/**
- *	qdi6580_set_piomode		-	PIO setup for single channel
- *	@ap: Port
- *	@adev: Device
- *
- *	In single channel mode the 6580 has one clock per device and we can
- *	avoid the requirement to clock switch. We also have to load the timing
- *	into the right clock according to whether we are master or slave.
- */
-
-static void qdi6580_set_piomode(struct ata_port *ap, struct ata_device *adev)
-{
-	struct ata_timing t;
-	struct legacy_data *ld_qdi = ap->host->private_data;
-	int active, recovery;
-	u8 timing;
-
-	/* Get the timing data in cycles */
-	ata_timing_compute(adev, adev->pio_mode, &t, 30303, 1000);
+	if (ld_qdi->type == QDI6580)
+		outb(timing, ld_qdi->timing + 2 * adev->devno);
+	else
+		outb(timing, ld_qdi->timing + 2 * ap->port_no);
 
-	if (ld_qdi->fast) {
-		active = 8 - clamp_val(t.active, 1, 8);
-		recovery = 18 - clamp_val(t.recover, 3, 18);
-	} else {
-		active = 9 - clamp_val(t.active, 2, 9);
-		recovery = 15 - clamp_val(t.recover, 0, 15);
-	}
-	timing = (recovery << 4) | active | 0x08;
-	ld_qdi->clock[adev->devno] = timing;
-	outb(timing, ld_qdi->timing + 2 * adev->devno);
 	/* Clear the FIFO */
-	if (adev->class != ATA_DEV_ATA)
+	if (ld_qdi->type != QDI6500 && adev->class != ATA_DEV_ATA)
 		outb(0x5F, (ld_qdi->timing & 0xFFF0) + 3);
 }
 
@@ -780,20 +727,20 @@ static int qdi_port(struct platform_devi
 
 static struct ata_port_operations qdi6500_port_ops = {
 	.inherits	= &legacy_base_port_ops,
-	.set_piomode	= qdi6500_set_piomode,
+	.set_piomode	= qdi65x0_set_piomode,
 	.qc_issue	= qdi_qc_issue,
 	.sff_data_xfer	= vlb32_data_xfer,
 };
 
 static struct ata_port_operations qdi6580_port_ops = {
 	.inherits	= &legacy_base_port_ops,
-	.set_piomode	= qdi6580_set_piomode,
+	.set_piomode	= qdi65x0_set_piomode,
 	.sff_data_xfer	= vlb32_data_xfer,
 };
 
 static struct ata_port_operations qdi6580dp_port_ops = {
 	.inherits	= &legacy_base_port_ops,
-	.set_piomode	= qdi6580dp_set_piomode,
+	.set_piomode	= qdi65x0_set_piomode,
 	.qc_issue	= qdi_qc_issue,
 	.sff_data_xfer	= vlb32_data_xfer,
 };
@@ -1013,6 +960,7 @@ static __init int legacy_init_one(struct
 	ctrl_addr = devm_ioport_map(&pdev->dev, io + 0x0206, 1);
 	if (!io_addr || !ctrl_addr)
 		goto fail;
+	ld->type = probe->type;
 	if (controller->setup)
 		if (controller->setup(pdev, probe, ld) < 0)
 			goto fail;
