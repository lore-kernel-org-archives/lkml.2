Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902Ab1DEHDM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 03:03:12 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48271 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077Ab1DEHDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 03:03:09 -0400
From: Hemant Pedanekar <hemantp@ti.com>
To: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Hemant Pedanekar <hemantp@ti.com>
Subject: [PATCH] pci: Add quirk for setting valid class for TI816X Endpoint
Date: Tue,  5 Apr 2011 12:32:50 +0530
Message-Id: <1301986970-16482-1-git-send-email-hemantp@ti.com>
X-Mailer: git-send-email 1.7.3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TI816X (common name for DM816x/C6A816x/AM389x family) devices configured to boot
as PCIe Endpoint have class code = 0. This makes kernel PCI bus code to skip
allocating BARs to these devices resulting into following type of error when
trying to enable them:

"Device 0000:01:00.0 not available because of resource collisions"

The device cannot be operated because of the above issue.

This patch adds a ID specific (TI VENDOR ID and 816X DEVICE ID based) 'early'
fixup quirk to replace class code with PCI_CLASS_MULTIMEDIA_VIDEO as class.

Signed-off-by: Hemant Pedanekar <hemantp@ti.com>
---
 drivers/pci/quirks.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index bd80f63..a1e4f61 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2784,6 +2784,16 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x342e, vtd_mask_spec_errors);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x3c28, vtd_mask_spec_errors);
 #endif
 
+static void __devinit fixup_ti816x_class(struct pci_dev* dev)
+{
+	/* TI 816x devices do not have class code set when in PCIe boot mode */
+	if (dev->class == PCI_CLASS_NOT_DEFINED) {
+		dev_info(&dev->dev, "Setting PCI class for 816x PCIe device\n");
+		dev->class = PCI_CLASS_MULTIMEDIA_VIDEO;
+	}
+}
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_TI, 0xb800, fixup_ti816x_class);
+
 static void pci_do_fixups(struct pci_dev *dev, struct pci_fixup *f,
 			  struct pci_fixup *end)
 {
-- 
1.7.3.5

