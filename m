Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965532Ab2EOCST (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:18:19 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53039 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964899Ab2EOCQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:16:33 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 042/179] PCI: Add quirk for setting valid class for TI816X Endpoint
Date: Mon, 14 May 2012 22:12:18 -0400
Message-ID: <1337048075-6132-43-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hemant Pedanekar <hemantp@ti.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/pci/quirks.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 46aca60..6938fdc 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2682,6 +2682,16 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x342e, vtd_mask_spec_errors);
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
1.7.9.6

