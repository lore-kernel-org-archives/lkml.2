Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625Ab1JKS0s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 14:26:48 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65369 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755503Ab1JKSZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 14:25:47 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH 3/3] pata_serverworks: add serverworks_fixup()
Date: Tue, 11 Oct 2011 20:13:53 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop-dirty; KDE/4.6.0; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110112013.54217.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_serverworks: add serverworks_fixup()

Factor out common code from serverworks_[re]init_one() to
serverworks_fixup().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
earlier references:
https://lkml.org/lkml/2009/11/25/386

 drivers/ata/pata_serverworks.c |   57 ++++++++++++++++++++---------------------
 1 file changed, 29 insertions(+), 28 deletions(-)

Index: b/drivers/ata/pata_serverworks.c
===================================================================
--- a/drivers/ata/pata_serverworks.c
+++ b/drivers/ata/pata_serverworks.c
@@ -372,6 +372,31 @@ static void serverworks_fixup_ht1000(str
 	pci_write_config_byte(pdev, 0x5A, btr);
 }
 
+static int serverworks_fixup(struct pci_dev *pdev)
+{
+	int rc = 0;
+
+	/* Force master latency timer to 64 PCI clocks */
+	pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 0x40);
+
+	switch (pdev->device) {
+	case PCI_DEVICE_ID_SERVERWORKS_OSB4IDE:
+		rc = serverworks_fixup_osb4(pdev);
+		break;
+	case PCI_DEVICE_ID_SERVERWORKS_CSB5IDE:
+		ata_pci_bmdma_clear_simplex(pdev);
+		/* fall through */
+	case PCI_DEVICE_ID_SERVERWORKS_CSB6IDE:
+	case PCI_DEVICE_ID_SERVERWORKS_CSB6IDE2:
+		rc = serverworks_fixup_csb(pdev);
+		break;
+	case PCI_DEVICE_ID_SERVERWORKS_HT1000IDE:
+		serverworks_fixup_ht1000(pdev);
+		break;
+	}
+
+	return rc;
+}
 
 static int serverworks_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
@@ -409,13 +434,12 @@ static int serverworks_init_one(struct p
 	if (rc)
 		return rc;
 
-	/* Force master latency timer to 64 PCI clocks */
-	pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 0x40);
+	rc = serverworks_fixup(pdev);
 
 	/* OSB4 : South Bridge and IDE */
 	if (pdev->device == PCI_DEVICE_ID_SERVERWORKS_OSB4IDE) {
 		/* Select non UDMA capable OSB4 if we can't do fixups */
-		if ( serverworks_fixup_osb4(pdev) < 0)
+		if (rc < 0)
 			ppi[0] = &info[1];
 	}
 	/* setup CSB5/CSB6 : South Bridge and IDE option RAID */
@@ -425,19 +449,13 @@ static int serverworks_init_one(struct p
 
 		 /* If the returned btr is the newer revision then
 		    select the right info block */
-		 if (serverworks_fixup_csb(pdev) == 3)
+		 if (rc == 3)
 		 	ppi[0] = &info[3];
 
 		/* Is this the 3rd channel CSB6 IDE ? */
 		if (pdev->device == PCI_DEVICE_ID_SERVERWORKS_CSB6IDE2)
 			ppi[1] = &ata_dummy_port_info;
 	}
-	/* setup HT1000E */
-	else if (pdev->device == PCI_DEVICE_ID_SERVERWORKS_HT1000IDE)
-		serverworks_fixup_ht1000(pdev);
-
-	if (pdev->device == PCI_DEVICE_ID_SERVERWORKS_CSB5IDE)
-		ata_pci_bmdma_clear_simplex(pdev);
 
 	return ata_pci_bmdma_init_one(pdev, ppi, &serverworks_sht, NULL, 0);
 }
@@ -452,24 +470,7 @@ static int serverworks_reinit_one(struct
 	if (rc)
 		return rc;
 
-	/* Force master latency timer to 64 PCI clocks */
-	pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 0x40);
-
-	switch (pdev->device) {
-		case PCI_DEVICE_ID_SERVERWORKS_OSB4IDE:
-			serverworks_fixup_osb4(pdev);
-			break;
-		case PCI_DEVICE_ID_SERVERWORKS_CSB5IDE:
-			ata_pci_bmdma_clear_simplex(pdev);
-			/* fall through */
-		case PCI_DEVICE_ID_SERVERWORKS_CSB6IDE:
-		case PCI_DEVICE_ID_SERVERWORKS_CSB6IDE2:
-			serverworks_fixup_csb(pdev);
-			break;
-		case PCI_DEVICE_ID_SERVERWORKS_HT1000IDE:
-			serverworks_fixup_ht1000(pdev);
-			break;
-	}
+	(void)serverworks_fixup(pdev);
 
 	ata_host_resume(host);
 	return 0;
