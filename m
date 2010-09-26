Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab0IZI7s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 04:59:48 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59317 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab0IZI7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 04:59:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=f0PB27yK84zW3vD/FpOALngKTviuQ+l+VMQ1qesoU83PyzxqY9lmKwokTN5KitmP+l
         GJYp9o4I3Q5Lpj4MV9rPo0o0/SZR0yUfeG1PJKVElVd4/GNMZruDRFtOVfQYR4UOGSLO
         m2zw/nTjzYFSsI3VKF13dPLb/svzjvCXvuW10=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] edac: i7300_edac: call pci_disable_device
Date: Sun, 26 Sep 2010 12:59:41 +0400
Message-Id: <1285491581-32622-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neither i7300_init_one() nor i7300_remove_one() calls pci_disable_device()
after enabling it.
---
 Compile tested.

 drivers/edac/i7300_edac.c |   35 +++++++++++++++++++++--------------
 1 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/drivers/edac/i7300_edac.c b/drivers/edac/i7300_edac.c
index 38920c0..749fa75 100644
--- a/drivers/edac/i7300_edac.c
+++ b/drivers/edac/i7300_edac.c
@@ -1046,7 +1046,7 @@ static int __devinit i7300_init_one(struct pci_dev *pdev,
 
 	/* wake up device */
 	rc = pci_enable_device(pdev);
-	if (rc == -EIO)
+	if (rc)
 		return rc;
 
 	debugf0("MC: " __FILE__ ": %s(), pdev bus %u dev=0x%x fn=0x%x\n",
@@ -1055,8 +1055,9 @@ static int __devinit i7300_init_one(struct pci_dev *pdev,
 		PCI_SLOT(pdev->devfn), PCI_FUNC(pdev->devfn));
 
 	/* We only are looking for func 0 of the set */
+	rc = -ENODEV;
 	if (PCI_FUNC(pdev->devfn) != 0)
-		return -ENODEV;
+		goto fail_disable;
 
 	/* As we don't have a motherboard identification routine to determine
 	 * actual number of slots/dimms per channel, we thus utilize the
@@ -1073,10 +1074,10 @@ static int __devinit i7300_init_one(struct pci_dev *pdev,
 		__func__, num_channels, num_dimms_per_channel, num_csrows);
 
 	/* allocate a new MC control structure */
+	rc = -ENOMEM;
 	mci = edac_mc_alloc(sizeof(*pvt), num_csrows, num_channels, 0);
-
 	if (mci == NULL)
-		return -ENOMEM;
+		goto fail_disable;
 
 	debugf0("MC: " __FILE__ ": %s(): mci = %p\n", __func__, mci);
 
@@ -1085,15 +1086,15 @@ static int __devinit i7300_init_one(struct pci_dev *pdev,
 	pvt = mci->pvt_info;
 	pvt->pci_dev_16_0_fsb_ctlr = pdev;	/* Record this device in our private */
 
+	rc = -ENOMEM;
 	pvt->tmp_prt_buffer = kmalloc(PAGE_SIZE, GFP_KERNEL);
-	if (!pvt->tmp_prt_buffer) {
-		edac_mc_free(mci);
-		return -ENOMEM;
-	}
+	if (!pvt->tmp_prt_buffer)
+		goto fail_free;
 
 	/* 'get' the pci devices we want to reserve for our use */
+	rc = -ENODEV;
 	if (i7300_get_devices(mci))
-		goto fail0;
+		goto fail_buffer_free;
 
 	mci->mc_idx = 0;
 	mci->mtype_cap = MEM_FLAG_FB_DDR2;
@@ -1121,13 +1122,14 @@ static int __devinit i7300_init_one(struct pci_dev *pdev,
 	}
 
 	/* add this new MC control structure to EDAC's list of MCs */
+	rc = -ENODEV;
 	if (edac_mc_add_mc(mci)) {
 		debugf0("MC: " __FILE__
 			": %s(): failed edac_mc_add_mc()\n", __func__);
 		/* FIXME: perhaps some code should go here that disables error
 		 * reporting if we just enabled it
 		 */
-		goto fail1;
+		goto fail_put;
 	}
 
 	i7300_clear_error(mci);
@@ -1146,14 +1148,18 @@ static int __devinit i7300_init_one(struct pci_dev *pdev,
 	return 0;
 
 	/* Error exit unwinding stack */
-fail1:
-
+fail_put:
 	i7300_put_devices(mci);
 
-fail0:
+fail_buffer_free:
 	kfree(pvt->tmp_prt_buffer);
+
+fail_free:
 	edac_mc_free(mci);
-	return -ENODEV;
+
+fail_disable:
+	pci_disable_device(pdev);
+	return rc;
 }
 
 /**
@@ -1181,6 +1187,7 @@ static void __devexit i7300_remove_one(struct pci_dev *pdev)
 
 	kfree(tmp);
 	edac_mc_free(mci);
+	pci_disable_device(pdev);
 }
 
 /*
-- 
1.7.0.4

