Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab2HQISs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 04:18:48 -0400
Received: from mail2.unitix.de ([176.9.2.175]:51278 "EHLO mail2.unitix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755209Ab2HQISh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 04:18:37 -0400
X-Greylist: delayed 431 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Aug 2012 04:18:37 EDT
From: Arnd Hannemann <arnd@arndnet.de>
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnd Hannemann <arnd@arndnet.de>
Subject: [PATCH] pata_atiixp: override cable detection on MSI E350DM-E33
Date: Fri, 17 Aug 2012 10:11:15 +0200
Message-Id: <1345191075-30425-1-git-send-email-arnd@arndnet.de>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mainboard MSI E350DM-E33 is advertised with 6 SATA ports.
As it turns out, two of them seem to be driven by on-board
SATA<->PATA converters. If a disk drive is connected to one
of them kernel uses UDMA/33 mode due to cable detection:

[   34.550823] scsi4 : pata_atiixp
[   34.555517] scsi5 : pata_atiixp
[   34.555942] ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xf100 irq 14
[   34.555948] ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xf108 irq 15
...
[   35.040799] ata5.00: ATA-8: WDC WD20EADS-00R6B0, 01.00A01, max UDMA/133
[   35.040806] ata5.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   35.040817] ata5.00: limited to UDMA/33 due to 40-wire cable
[   35.049166] ata5.00: configured for UDMA/33
[   35.049402] scsi 4:0:0:0: Direct-Access     ATA      WDC WD20EADS-00R 01.0 PQ: 0 ANSI: 5

This patch forces "short cable" mode on this board, as it seems clear that
the on-board SATA<->PATA "cable" is short.
With this patch the disk is configured for UDMA/100:

[    5.976756] ata5.00: ATA-8: WDC WD20EADS-00R6B0, 01.00A01, max UDMA/133
[    5.996434] ata5.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    6.024787] ata5.00: configured for UDMA/100

Testing revealed no transfer issues.

Signed-off-by: Arnd Hannemann <arnd@arndnet.de>
---
 drivers/ata/pata_atiixp.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/ata/pata_atiixp.c b/drivers/ata/pata_atiixp.c
index 361c75c..24e5105 100644
--- a/drivers/ata/pata_atiixp.c
+++ b/drivers/ata/pata_atiixp.c
@@ -20,6 +20,7 @@
 #include <linux/delay.h>
 #include <scsi/scsi_host.h>
 #include <linux/libata.h>
+#include <linux/dmi.h>
 
 #define DRV_NAME "pata_atiixp"
 #define DRV_VERSION "0.4.6"
@@ -33,11 +34,26 @@ enum {
 	ATIIXP_IDE_UDMA_MODE 	= 0x56
 };
 
+static const struct dmi_system_id attixp_cable_override_dmi_table[] = {
+	{
+		/* Board has onboard PATA<->SATA converters */
+		.ident = "MSI E350DM-E33",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "MSI"),
+			DMI_MATCH(DMI_BOARD_NAME, "E350DM-E33(MS-7720)"),
+		},
+	},
+	{ }
+};
+
 static int atiixp_cable_detect(struct ata_port *ap)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	u8 udma;
 
+	if (dmi_check_system(attixp_cable_override_dmi_table))
+		return ATA_CBL_PATA40_SHORT;
+
 	/* Hack from drivers/ide/pci. Really we want to know how to do the
 	   raw detection not play follow the bios mode guess */
 	pci_read_config_byte(pdev, ATIIXP_IDE_UDMA_MODE + ap->port_no, &udma);
-- 
1.7.9.5

