Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933632Ab1C3WMz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:12:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:15534 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933086Ab1C3VF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:05:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="727132724"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: alex.he@amd.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [21/275] USB: EHCI: ASPM quirk of ISOC on AMD Hudson
Message-Id: <20110330210415.C67303E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:04:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Alex He <alex.he@amd.com>

commit baab93afc2844b68d57b0dcca5e1d34c5d7cf411 upstream.

AMD Hudson also needs the same ASPM quirk as SB800

Signed-off-by: Alex He <alex.he@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/host/ehci-pci.c |   33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

Index: linux-2.6.35.y/drivers/usb/host/ehci-pci.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/host/ehci-pci.c	2011-03-29 23:02:58.277344248 -0700
+++ linux-2.6.35.y/drivers/usb/host/ehci-pci.c	2011-03-29 23:02:58.654334603 -0700
@@ -41,28 +41,35 @@
 	return 0;
 }
 
-static int ehci_quirk_amd_SB800(struct ehci_hcd *ehci)
+static int ehci_quirk_amd_hudson(struct ehci_hcd *ehci)
 {
 	struct pci_dev *amd_smbus_dev;
 	u8 rev = 0;
 
 	amd_smbus_dev = pci_get_device(PCI_VENDOR_ID_ATI, 0x4385, NULL);
-	if (!amd_smbus_dev)
-		return 0;
-
-	pci_read_config_byte(amd_smbus_dev, PCI_REVISION_ID, &rev);
-	if (rev < 0x40) {
-		pci_dev_put(amd_smbus_dev);
-		amd_smbus_dev = NULL;
-		return 0;
+	if (amd_smbus_dev) {
+		pci_read_config_byte(amd_smbus_dev, PCI_REVISION_ID, &rev);
+		if (rev < 0x40) {
+			pci_dev_put(amd_smbus_dev);
+			amd_smbus_dev = NULL;
+			return 0;
+		}
+	} else {
+		amd_smbus_dev = pci_get_device(PCI_VENDOR_ID_AMD, 0x780b, NULL);
+		if (!amd_smbus_dev)
+			return 0;
+		pci_read_config_byte(amd_smbus_dev, PCI_REVISION_ID, &rev);
+		if (rev < 0x11 || rev > 0x18) {
+			pci_dev_put(amd_smbus_dev);
+			amd_smbus_dev = NULL;
+			return 0;
+		}
 	}
 
 	if (!amd_nb_dev)
 		amd_nb_dev = pci_get_device(PCI_VENDOR_ID_AMD, 0x1510, NULL);
-	if (!amd_nb_dev)
-		ehci_err(ehci, "QUIRK: unable to get AMD NB device\n");
 
-	ehci_info(ehci, "QUIRK: Enable AMD SB800 L1 fix\n");
+	ehci_info(ehci, "QUIRK: Enable exception for AMD Hudson ASPM\n");
 
 	pci_dev_put(amd_smbus_dev);
 	amd_smbus_dev = NULL;
@@ -128,7 +135,7 @@
 	/* cache this readonly data; minimize chip reads */
 	ehci->hcs_params = ehci_readl(ehci, &ehci->caps->hcs_params);
 
-	if (ehci_quirk_amd_SB800(ehci))
+	if (ehci_quirk_amd_hudson(ehci))
 		ehci->amd_l1_fix = 1;
 
 	retval = ehci_halt(ehci);
