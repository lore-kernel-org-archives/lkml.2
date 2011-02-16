Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932840Ab1BPAsC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:48:02 -0500
Received: from kroah.org ([198.145.64.141]:45219 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932803Ab1BPArw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:47:52 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:01 2011
Message-Id: <20110216002101.292409452@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:19:50 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex He <alex.he@amd.com>
Subject: [patch 022/176] USB: EHCI: ASPM quirk of ISOC on AMD Hudson
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex He <alex.he@amd.com>

commit baab93afc2844b68d57b0dcca5e1d34c5d7cf411 upstream.

AMD Hudson also needs the same ASPM quirk as SB800

Signed-off-by: Alex He <alex.he@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/ehci-pci.c |   33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

--- a/drivers/usb/host/ehci-pci.c
+++ b/drivers/usb/host/ehci-pci.c
@@ -41,28 +41,35 @@ static int ehci_pci_reinit(struct ehci_h
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
@@ -128,7 +135,7 @@ static int ehci_pci_setup(struct usb_hcd
 	/* cache this readonly data; minimize chip reads */
 	ehci->hcs_params = ehci_readl(ehci, &ehci->caps->hcs_params);
 
-	if (ehci_quirk_amd_SB800(ehci))
+	if (ehci_quirk_amd_hudson(ehci))
 		ehci->amd_l1_fix = 1;
 
 	retval = ehci_halt(ehci);


