Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163231Ab1FAI3L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:29:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44664 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163211Ab1FAI3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:29:00 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:12:26 2011
Message-Id: <20110601081225.794665632@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:12:07 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hemant Pedanekar <hemantp@ti.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [157/165] PCI: Add quirk for setting valid class for TI816X Endpoint
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 1561
Lines: 45

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

---
 drivers/pci/quirks.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2784,6 +2784,16 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_IN
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


