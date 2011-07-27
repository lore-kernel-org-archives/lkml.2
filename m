Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967Ab1G0WGt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 18:06:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:46879 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755491Ab1G0Vsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:48:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,278,1309762800"; 
   d="scan'208";a="30900532"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: hemantp@ti.com, jbarnes@virtuousgeek.org, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [32/99] PCI: Add quirk for setting valid class for TI816X Endpoint
Message-Id: <20110727214830.DD75A2403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:48:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Hemant Pedanekar <hemantp@ti.com>

commit 63c4408074cbcc070ac17fc10e524800eb9bd0b0 upstream.

TI816X (common name for DM816x/C6A816x/AM389x family) devices configured
to boot as PCIe Endpoint have class code = 0. This makes kernel PCI bus
code to skip allocating BARs to these devices resulting into following
type of error when trying to enable them:

"Device 0000:01:00.0 not available because of resource collisions"

The device cannot be operated because of the above issue.

This patch adds a ID specific (TI VENDOR ID and 816X DEVICE ID based)
'early' fixup quirk to replace class code with
PCI_CLASS_MULTIMEDIA_VIDEO as class.

Signed-off-by: Hemant Pedanekar <hemantp@ti.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/pci/quirks.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: linux-2.6.35.y/drivers/pci/quirks.c
===================================================================
--- linux-2.6.35.y.orig/drivers/pci/quirks.c
+++ linux-2.6.35.y/drivers/pci/quirks.c
@@ -2727,6 +2727,16 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_IN
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
