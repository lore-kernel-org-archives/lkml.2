Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773Ab2CGLgJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 06:36:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28170 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752408Ab2CGLgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 06:36:08 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] i5400_edac: Avoid calling pci_put_device() twice
Date: Wed,  7 Mar 2012 08:35:56 -0300
Message-Id: <1331120156-27353-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When i5400_edac driver is removed and re-loaded a few times, it causes
an OOPS, as it is currently decrementing some PCI device usage two
times.

When called inside a loop, pci_get_device() will call
pci_put_device(). That mangles the error count. In this specific
case, it seems easier to just duplicate the call.

Also fixes the error logic when pci_get_device fails.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/i5400_edac.c |   54 +++++++++++++++++++++++++++++++-------------
 1 files changed, 38 insertions(+), 16 deletions(-)

diff --git a/drivers/edac/i5400_edac.c b/drivers/edac/i5400_edac.c
index 74d6ec34..b44a5de 100644
--- a/drivers/edac/i5400_edac.c
+++ b/drivers/edac/i5400_edac.c
@@ -735,7 +735,7 @@ static int i5400_get_devices(struct mem_ctl_info *mci, int dev_idx)
 
 	/* Attempt to 'get' the MCH register we want */
 	pdev = NULL;
-	while (!pvt->branchmap_werrors || !pvt->fsb_error_regs) {
+	while (1) {
 		pdev = pci_get_device(PCI_VENDOR_ID_INTEL,
 				      PCI_DEVICE_ID_INTEL_5400_ERR, pdev);
 		if (!pdev) {
@@ -743,23 +743,42 @@ static int i5400_get_devices(struct mem_ctl_info *mci, int dev_idx)
 			i5400_printk(KERN_ERR,
 				"'system address,Process Bus' "
 				"device not found:"
-				"vendor 0x%x device 0x%x ERR funcs "
+				"vendor 0x%x device 0x%x ERR func 1 "
 				"(broken BIOS?)\n",
 				PCI_VENDOR_ID_INTEL,
 				PCI_DEVICE_ID_INTEL_5400_ERR);
-			goto error;
+			return -ENODEV;
 		}
 
-		/* Store device 16 funcs 1 and 2 */
-		switch (PCI_FUNC(pdev->devfn)) {
-		case 1:
-			pvt->branchmap_werrors = pdev;
-			break;
-		case 2:
-			pvt->fsb_error_regs = pdev;
+		/* Store device 16 func 1 */
+		if (PCI_FUNC(pdev->devfn) == 1)
 			break;
+	}
+	pvt->branchmap_werrors = pdev;
+
+	pdev = NULL;
+	while (1) {
+		pdev = pci_get_device(PCI_VENDOR_ID_INTEL,
+				      PCI_DEVICE_ID_INTEL_5400_ERR, pdev);
+		if (!pdev) {
+			/* End of list, leave */
+			i5400_printk(KERN_ERR,
+				"'system address,Process Bus' "
+				"device not found:"
+				"vendor 0x%x device 0x%x ERR func 2 "
+				"(broken BIOS?)\n",
+				PCI_VENDOR_ID_INTEL,
+				PCI_DEVICE_ID_INTEL_5400_ERR);
+
+			pci_dev_put(pvt->branchmap_werrors);
+			return -ENODEV;
 		}
+
+		/* Store device 16 func 2 */
+		if (PCI_FUNC(pdev->devfn) == 2)
+			break;
 	}
+	pvt->fsb_error_regs = pdev;
 
 	debugf1("System Address, processor bus- PCI Bus ID: %s  %x:%x\n",
 		pci_name(pvt->system_address),
@@ -778,7 +797,10 @@ static int i5400_get_devices(struct mem_ctl_info *mci, int dev_idx)
 			"MC: 'BRANCH 0' device not found:"
 			"vendor 0x%x device 0x%x Func 0 (broken BIOS?)\n",
 			PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_5400_FBD0);
-		goto error;
+
+		pci_dev_put(pvt->fsb_error_regs);
+		pci_dev_put(pvt->branchmap_werrors);
+		return -ENODEV;
 	}
 
 	/* If this device claims to have more than 2 channels then
@@ -796,14 +818,14 @@ static int i5400_get_devices(struct mem_ctl_info *mci, int dev_idx)
 			"(broken BIOS?)\n",
 			PCI_VENDOR_ID_INTEL,
 			PCI_DEVICE_ID_INTEL_5400_FBD1);
-		goto error;
+
+		pci_dev_put(pvt->branch_0);
+		pci_dev_put(pvt->fsb_error_regs);
+		pci_dev_put(pvt->branchmap_werrors);
+		return -ENODEV;
 	}
 
 	return 0;
-
-error:
-	i5400_put_devices(mci);
-	return -ENODEV;
 }
 
 /*
-- 
1.7.8

