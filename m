Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334Ab3ADWhE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 17:37:04 -0500
Received: from reverse.techspace.com ([216.174.116.17]:34930 "EHLO
	hdasch-dt.enmotus.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754618Ab3ADWhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 17:37:02 -0500
From: Hugh Daschbach <hugh.daschbach@enmotus.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Hugh Daschbach <hugh.daschbach@enmotus.com>
Subject: [PATCH v2 v3.7.0] Add AHCI support for Enmotus Bobcat device.
Date: Fri,  4 Jan 2013 14:39:09 -0800
Message-Id: <1357339149-22284-1-git-send-email-hugh.daschbach@enmotus.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <50E5E153.9040801@mvista.com>
References: <50E5E153.9040801@mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Silicon does not support standard AHCI BAR assignment.  Add
vendor/device exception to force BAR 2.

Signed-off-by: Hugh Daschbach <hugh.daschbach@enmotus.com>
---
v2: Corrected comment in response to Sergei's review.  Thanks, Sergei.

 drivers/ata/ahci.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 7862d17..4979127 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -53,6 +53,7 @@
 
 enum {
 	AHCI_PCI_BAR_STA2X11	= 0,
+	AHCI_PCI_BAR_ENMOTUS	= 2,
 	AHCI_PCI_BAR_STANDARD	= 5,
 };
 
@@ -410,6 +411,9 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(ASMEDIA, 0x0611), board_ahci },	/* ASM1061 */
 	{ PCI_VDEVICE(ASMEDIA, 0x0612), board_ahci },	/* ASM1062 */
 
+	/* Enmotus */
+	{ PCI_DEVICE(0x1c44, 0x8000), board_ahci },
+
 	/* Generic, PCI class code for AHCI */
 	{ PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
 	  PCI_CLASS_STORAGE_SATA_AHCI, 0xffffff, board_ahci },
@@ -1098,9 +1102,11 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		dev_info(&pdev->dev,
 			 "PDC42819 can only drive SATA devices with this driver\n");
 
-	/* The Connext uses non-standard BAR */
+	/* Both Connext and Enmotus devices use non-standard BARs */
 	if (pdev->vendor == PCI_VENDOR_ID_STMICRO && pdev->device == 0xCC06)
 		ahci_pci_bar = AHCI_PCI_BAR_STA2X11;
+	else if (pdev->vendor == 0x1c44 && pdev->device == 0x8000)
+		ahci_pci_bar = AHCI_PCI_BAR_ENMOTUS;
 
 	/* acquire resources */
 	rc = pcim_enable_device(pdev);
-- 
1.7.11.7

