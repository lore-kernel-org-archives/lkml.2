Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228Ab2HWQh5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 12:37:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3873 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753418Ab2HWQhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 12:37:22 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pci@vger.kernel.org, linux-efi@vger.kernel.org, mfleming@intel.com,
        dwmw2@infradead.org, bhelgaas@google.com,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH V3 3/4] PCI: Add support for non-BAR ROMs
Date: Thu, 23 Aug 2012 12:36:42 -0400
Message-Id: <1345739803-21017-4-git-send-email-mjg@redhat.com>
In-Reply-To: <1345739803-21017-1-git-send-email-mjg@redhat.com>
References: <1345739803-21017-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.206
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Platforms may provide their own mechanisms for obtaining ROMs. Add support
for using data provided by the platform in that case.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/pci/rom.c   | 11 +++++++++--
 include/linux/pci.h |  2 ++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/rom.c b/drivers/pci/rom.c
index 48ebdb2..46026e4 100644
--- a/drivers/pci/rom.c
+++ b/drivers/pci/rom.c
@@ -118,11 +118,17 @@ void __iomem *pci_map_rom(struct pci_dev *pdev, size_t *size)
 	void __iomem *rom;
 
 	/*
+	 * Some devices may provide ROMs via a source other than the BAR
+	 */
+	if (pdev->rom && pdev->romlen) {
+		*size = pdev->romlen;
+		return phys_to_virt((phys_addr_t)pdev->rom);
+	/*
 	 * IORESOURCE_ROM_SHADOW set on x86, x86_64 and IA64 supports legacy
 	 * memory map if the VGA enable bit of the Bridge Control register is
 	 * set for embedded VGA.
 	 */
-	if (res->flags & IORESOURCE_ROM_SHADOW) {
+	} else if (res->flags & IORESOURCE_ROM_SHADOW) {
 		/* primary video rom always starts here */
 		start = (loff_t)0xC0000;
 		*size = 0x20000; /* cover C000:0 through E000:0 */
@@ -219,7 +225,8 @@ void pci_unmap_rom(struct pci_dev *pdev, void __iomem *rom)
 	if (res->flags & (IORESOURCE_ROM_COPY | IORESOURCE_ROM_BIOS_COPY))
 		return;
 
-	iounmap(rom);
+	if (!pdev->rom || !pdev->romlen)
+		iounmap(rom);
 
 	/* Disable again before continuing, leave enabled if pci=rom */
 	if (!(res->flags & (IORESOURCE_ROM_ENABLE | IORESOURCE_ROM_SHADOW)))
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 6a2625c..2668bb9 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -355,6 +355,8 @@ struct pci_dev {
 	};
 	struct pci_ats	*ats;	/* Address Translation Service */
 #endif
+	void *rom; /* Physical pointer to ROM if it's not from the BAR */
+	size_t romlen; /* Length of ROM if it's not from the BAR */
 };
 
 static inline struct pci_dev *pci_physfn(struct pci_dev *dev)
-- 
1.7.11.2

