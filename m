Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732Ab2IBVwa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 17:52:30 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:23372 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755359Ab2IBVvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 17:51:07 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, x86 <x86@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH part2 2/6] x86, PCI: Separate pcibios_allocate_dev_resources()
Date: Sun,  2 Sep 2012 14:50:49 -0700
Message-Id: <1346622653-30741-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1346622653-30741-1-git-send-email-yinghai@kernel.org>
References: <1346622653-30741-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thus pcibios_allocate_resources() could more simple and clean

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/pci/i386.c |   42 +++++++++++++++++++++++-------------------
 1 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 9800362..5817cf2 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -232,9 +232,8 @@ struct pci_check_idx_range {
 	int end;
 };
 
-static void __init pcibios_allocate_resources(int pass)
+static void __init pcibios_allocate_dev_resources(struct pci_dev *dev, int pass)
 {
-	struct pci_dev *dev = NULL;
 	int idx, disabled, i;
 	u16 command;
 	struct resource *r;
@@ -246,14 +245,13 @@ static void __init pcibios_allocate_resources(int pass)
 #endif
 	};
 
-	for_each_pci_dev(dev) {
-		pci_read_config_word(dev, PCI_COMMAND, &command);
-		for (i = 0; i < ARRAY_SIZE(idx_range); i++)
+	pci_read_config_word(dev, PCI_COMMAND, &command);
+	for (i = 0; i < ARRAY_SIZE(idx_range); i++)
 		for (idx = idx_range[i].start; idx <= idx_range[i].end; idx++) {
 			r = &dev->resource[idx];
-			if (r->parent)		/* Already allocated */
+			if (r->parent)	/* Already allocated */
 				continue;
-			if (!r->start)		/* Address not assigned at all */
+			if (!r->start)	/* Address not assigned at all */
 				continue;
 			if (r->flags & IORESOURCE_IO)
 				disabled = !(command & PCI_COMMAND_IO);
@@ -272,23 +270,29 @@ static void __init pcibios_allocate_resources(int pass)
 				}
 			}
 		}
-		if (!pass) {
-			r = &dev->resource[PCI_ROM_RESOURCE];
-			if (r->flags & IORESOURCE_ROM_ENABLE) {
-				/* Turn the ROM off, leave the resource region,
-				 * but keep it unregistered. */
-				u32 reg;
-				dev_dbg(&dev->dev, "disabling ROM %pR\n", r);
-				r->flags &= ~IORESOURCE_ROM_ENABLE;
-				pci_read_config_dword(dev,
-						dev->rom_base_reg, &reg);
-				pci_write_config_dword(dev, dev->rom_base_reg,
+	if (!pass) {
+		r = &dev->resource[PCI_ROM_RESOURCE];
+		if (r->flags & IORESOURCE_ROM_ENABLE) {
+			/* Turn the ROM off, leave the resource region,
+			 * but keep it unregistered. */
+			u32 reg;
+			dev_dbg(&dev->dev, "disabling ROM %pR\n", r);
+			r->flags &= ~IORESOURCE_ROM_ENABLE;
+			pci_read_config_dword(dev, dev->rom_base_reg, &reg);
+			pci_write_config_dword(dev, dev->rom_base_reg,
 						reg & ~PCI_ROM_ADDRESS_ENABLE);
-			}
 		}
 	}
 }
 
+static void __init pcibios_allocate_resources(int pass)
+{
+	struct pci_dev *dev = NULL;
+
+	for_each_pci_dev(dev)
+		pcibios_allocate_dev_resources(dev, pass);
+}
+
 static int __init pcibios_assign_resources(void)
 {
 	struct pci_dev *dev = NULL;
-- 
1.7.7

