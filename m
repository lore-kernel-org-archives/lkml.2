Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711Ab1IFTWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 15:22:19 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:55623 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556Ab1IFTWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 15:22:05 -0400
From: Dan McGee <dpmcgee@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH 2/2] pata_sis: add mode_filter method for certain sis5513 chipsets
Date: Tue,  6 Sep 2011 14:21:59 -0500
Message-Id: <1315336919-2737-2-git-send-email-dpmcgee@gmail.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1315336919-2737-1-git-send-email-dpmcgee@gmail.com>
References: <1315336919-2737-1-git-send-email-dpmcgee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This mirrors a very old commit (3160d5416f39da9d9) to the old sis5513
IDE driver that prevents certain setups from working. UDMA6, aka
ATA/133, is not supported on some chipsets and we need to ensure this
mode is not chosen even if a connected drive supports it. Port this old
patch forward to the new PATA driver to ensure UDMA5 is the highest mode
used if that is what is supported.

Kernel bugzilla #41582.

Reviewed-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Dan McGee <dpmcgee@gmail.com>
---
 drivers/ata/pata_sis.c |   27 ++++++++++++++++++++++++++-
 1 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/pata_sis.c b/drivers/ata/pata_sis.c
index 9374400..54c41c7 100644
--- a/drivers/ata/pata_sis.c
+++ b/drivers/ata/pata_sis.c
@@ -509,6 +509,27 @@ static void sis_133_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 	pci_write_config_dword(pdev, port, t1);
 }
 
+/**
+ *	sis_133_mode_filter - mode selection filter
+ *	@adev: ATA device
+ *
+ *	Block UDMA6 on devices that do not support it.
+ */
+
+static unsigned long sis_133_mode_filter(struct ata_device *adev, unsigned long mask)
+{
+	struct ata_port *ap = adev->link->ap;
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	int port = sis_port_base(adev);
+	u32 t1;
+
+	pci_read_config_dword(pdev, port, &t1);
+	/* if ATA133 is disabled, mask it out */
+	if (!(t1 & 0x08))
+		mask &= ~(0xE0 << ATA_SHIFT_UDMA);
+	return mask;
+}
+
 static struct scsi_host_template sis_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
@@ -530,6 +551,7 @@ static struct ata_port_operations sis_133_ops = {
 	.set_piomode		= sis_133_set_piomode,
 	.set_dmamode		= sis_133_set_dmamode,
 	.cable_detect		= sis_133_cable_detect,
+	.mode_filter		= sis_133_mode_filter,
 };
 
 static struct ata_port_operations sis_133_early_ops = {
@@ -779,10 +801,13 @@ static int sis_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 
 		switch(trueid) {
 		case 0x5518:	/* SIS 962/963 */
+			printk(KERN_INFO DRV_NAME " %s: SiS 962/963 MuTIOL IDE UDMA133 controller\n",
+				pci_name(pdev));
 			chipset = &sis133;
 			if ((idemisc & 0x40000000) == 0) {
 				pci_write_config_dword(pdev, 0x54, idemisc | 0x40000000);
-				printk(KERN_INFO "SIS5513: Switching to 5513 register mapping\n");
+				printk(KERN_INFO DRV_NAME " %s: Switching to 5513 register mapping\n",
+					pci_name(pdev));
 			}
 			break;
 		case 0x0180:	/* SIS 965/965L */
-- 
1.7.6.1

