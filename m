Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934318Ab1FWScQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:32:16 -0400
Received: from mail.windriver.com ([147.11.1.11]:62748 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759835Ab1FWRWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:22:03 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Alex He <alex.he@amd.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 015/247] USB: EHCI: ASPM quirk of ISOC on AMD Hudson
Date: Thu, 23 Jun 2011 13:17:38 -0400
Message-Id: <1308849690-14530-16-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex He <alex.he@amd.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit baab93afc2844b68d57b0dcca5e1d34c5d7cf411 upstream.

AMD Hudson also needs the same ASPM quirk as SB800

Signed-off-by: Alex He <alex.he@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/host/ehci-pci.c |   33 ++++++++++++++++++++-------------
 1 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/drivers/usb/host/ehci-pci.c b/drivers/usb/host/ehci-pci.c
index 0bda4c5..de0dbd5 100644
--- a/drivers/usb/host/ehci-pci.c
+++ b/drivers/usb/host/ehci-pci.c
@@ -41,28 +41,35 @@ static int ehci_pci_reinit(struct ehci_hcd *ehci, struct pci_dev *pdev)
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
@@ -128,7 +135,7 @@ static int ehci_pci_setup(struct usb_hcd *hcd)
 	/* cache this readonly data; minimize chip reads */
 	ehci->hcs_params = ehci_readl(ehci, &ehci->caps->hcs_params);
 
-	if (ehci_quirk_amd_SB800(ehci))
+	if (ehci_quirk_amd_hudson(ehci))
 		ehci->amd_l1_fix = 1;
 
 	retval = ehci_halt(ehci);
-- 
1.7.4.4

