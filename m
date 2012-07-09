Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab2GISU2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 14:20:28 -0400
Received: from mail-yx0-f202.google.com ([209.85.213.202]:49653 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab2GISUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 14:20:25 -0400
Subject: [PATCH 2/2] PCI: disable MEM decoding while updating 64-bit MEM BARs
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Robert Hancock <hancockrwd@gmail.com>
Date: Mon, 09 Jul 2012 12:20:23 -0600
Message-ID: <20120709182023.18165.95880.stgit@bhelgaas.mtv.corp.google.com>
In-Reply-To: <20120709181745.18165.93914.stgit@bhelgaas.mtv.corp.google.com>
References: <20120709181745.18165.93914.stgit@bhelgaas.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we update 64-bit BARs, we have to perform two config writes.  Between
the writes, the half-written BAR value could match a MEM access intended
for another device.  This could result in corruption of this device (for
writes) or an unexpected response machine check (for reads).

To prevent this, disable MEM decoding while updating such BARs.  This uses
the same safety test as 253d2e5498, which disables both MEM and IO while
sizing BARs, namely, we don't disable decoding for host bridge devices.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/setup-res.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index eea85da..1a0e60e 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -30,6 +30,8 @@
 void pci_update_resource(struct pci_dev *dev, int resno)
 {
 	struct pci_bus_region region;
+	bool disable;
+	u16 cmd;
 	u32 new, check, mask;
 	int reg;
 	enum pci_bar_type type;
@@ -67,6 +69,18 @@ void pci_update_resource(struct pci_dev *dev, int resno)
 		new |= PCI_ROM_ADDRESS_ENABLE;
 	}
 
+	/*
+	 * We can't update a 64-bit BAR atomically, so when possible,
+	 * disable decoding so that a half-updated BAR won't conflict
+	 * with another device.
+	 */
+	disable = (res->flags & IORESOURCE_MEM_64) && !dev->mmio_always_on;
+	if (disable) {
+		pci_read_config_word(dev, PCI_COMMAND, &cmd);
+		pci_write_config_word(dev, PCI_COMMAND,
+				      cmd & ~PCI_COMMAND_MEMORY);
+	}
+
 	pci_write_config_dword(dev, reg, new);
 	pci_read_config_dword(dev, reg, &check);
 
@@ -84,6 +98,10 @@ void pci_update_resource(struct pci_dev *dev, int resno)
 			       "(high %#08x != %#08x)\n", resno, new, check);
 		}
 	}
+
+	if (disable)
+		pci_write_config_word(dev, PCI_COMMAND, cmd);
+
 	res->flags &= ~IORESOURCE_UNSET;
 	dev_dbg(&dev->dev, "BAR %d: set to %pR (PCI address [%#llx-%#llx])\n",
 		resno, res, (unsigned long long)region.start,

