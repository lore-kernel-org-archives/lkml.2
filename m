Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602Ab1IGQXy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:23:54 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55418 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756509Ab1IGQXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:23:40 -0400
From: Dan McGee <dpmcgee@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
        Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH 3/5] pata_sis: enable MWDMA for UDMA 133 chipset
Date: Wed,  7 Sep 2011 11:23:20 -0500
Message-Id: <1315412602-6560-4-git-send-email-dpmcgee@gmail.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1315412602-6560-1-git-send-email-dpmcgee@gmail.com>
References: <1315412602-6560-1-git-send-email-dpmcgee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This ports the timing values over from the old IDE driver into the new
PATA-based one. The comment was lying when it stated the old driver was
not MWDMA capable.

Boot tested on actual hardware using 'libata.force=mwdma2'.

Signed-off-by: Dan McGee <dpmcgee@gmail.com>
---
 drivers/ata/pata_sis.c |   25 +++++++++++++++++--------
 1 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/ata/pata_sis.c b/drivers/ata/pata_sis.c
index fb4e90f..a42668b 100644
--- a/drivers/ata/pata_sis.c
+++ b/drivers/ata/pata_sis.c
@@ -485,21 +485,30 @@ static void sis_133_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 	int port;
 	u32 t1;
 
-	/* bits 4- cycle time 8 - cvs time */
-	static const u32 timing_u100[] = { 0x6B0, 0x470, 0x350, 0x140, 0x120, 0x110, 0x000 };
-	static const u32 timing_u133[] = { 0x9F0, 0x6A0, 0x470, 0x250, 0x230, 0x220, 0x210 };
-
 	port = sis_port_base(adev);
 	pci_read_config_dword(pdev, port, &t1);
 
 	if (adev->dma_mode < XFER_UDMA_0) {
+		/* Recovery << 24 | Act << 16 | Ini << 12, like PIO modes */
+		static const u32 timing_u100[] = { 0x19154000, 0x06072000, 0x04062000 };
+		static const u32 timing_u133[] = { 0x221C6000, 0x0C0A3000, 0x05093000 };
+		int speed = adev->dma_mode - XFER_MW_DMA_0;
+
+		t1 &= 0xC0C00FFF;
+		/* disable UDMA */
 		t1 &= ~0x00000004;
-		/* FIXME: need data sheet to add MWDMA here. Also lacking on
-		   ide/pci driver */
+		if (t1 & 0x08)
+			t1 |= timing_u133[speed];
+		else
+			t1 |= timing_u100[speed];
 	} else {
+		/* bits 4- cycle time 8 - cvs time */
+		static const u32 timing_u100[] = { 0x6B0, 0x470, 0x350, 0x140, 0x120, 0x110, 0x000 };
+		static const u32 timing_u133[] = { 0x9F0, 0x6A0, 0x470, 0x250, 0x230, 0x220, 0x210 };
 		int speed = adev->dma_mode - XFER_UDMA_0;
-		/* if & 8 no UDMA133 - need info for ... */
+
 		t1 &= ~0x00000FF0;
+		/* enable UDMA */
 		t1 |= 0x00000004;
 		if (t1 & 0x08)
 			t1 |= timing_u133[speed];
@@ -620,7 +629,7 @@ static const struct ata_port_info sis_info100_early = {
 static const struct ata_port_info sis_info133 = {
 	.flags		= ATA_FLAG_SLAVE_POSS,
 	.pio_mask	= ATA_PIO4,
-	/* No MWDMA */
+	.mwdma_mask	= ATA_MWDMA2,
 	.udma_mask	= ATA_UDMA6,
 	.port_ops	= &sis_133_ops,
 };
-- 
1.7.6.1

