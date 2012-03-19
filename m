Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919Ab2CSFyz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 01:54:55 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:31277 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161913Ab2CSFth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:49:37 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v2 06/26] x86, PCI: Use for_each_res with pci_allocate_dev_resources
Date: Sun, 18 Mar 2012 22:48:29 -0700
Message-Id: <1332136129-14010-7-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332136129-14010-1-git-send-email-yinghai@kernel.org>
References: <1332136129-14010-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090209.4F66C8EF.0019,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/pci/i386.c |   55 ++++++++++++++++++--------------------------------
 1 files changed, 20 insertions(+), 35 deletions(-)

diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 570197e..83befee 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -228,49 +228,34 @@ static void pcibios_allocate_bus_resources(struct pci_bus *bus)
 		pcibios_allocate_bus_resources(child);
 }
 
-struct pci_check_idx_range {
-	int start;
-	int end;
-};
-
 static void pcibios_allocate_dev_resources(struct pci_dev *dev, int pass)
 {
-	int idx, disabled, i;
+	int idx, disabled;
 	u16 command;
 	struct resource *r;
 
-	struct pci_check_idx_range idx_range[] = {
-		{ PCI_STD_RESOURCES, PCI_STD_RESOURCE_END },
-#ifdef CONFIG_PCI_IOV
-		{ PCI_IOV_RESOURCES, PCI_IOV_RESOURCE_END },
-#endif
-	};
-
 	pci_read_config_word(dev, PCI_COMMAND, &command);
-	for (i = 0; i < ARRAY_SIZE(idx_range); i++)
-		for (idx = idx_range[i].start; idx <= idx_range[i].end; idx++) {
-			r = &dev->resource[idx];
-			if (r->parent)	/* Already allocated */
-				continue;
-			if (!r->start)	/* Address not assigned at all */
-				continue;
-			if (r->flags & IORESOURCE_IO)
-				disabled = !(command & PCI_COMMAND_IO);
-			else
-				disabled = !(command & PCI_COMMAND_MEMORY);
-			if (pass == disabled) {
-				dev_dbg(&dev->dev,
-					"BAR %d: reserving %pr (d=%d, p=%d)\n",
-					idx, r, disabled, pass);
-				if (pci_claim_resource(dev, idx) < 0) {
-					/* We'll assign a new address later */
-					pcibios_save_fw_addr(dev,
-							idx, r->start);
-					r->end -= r->start;
-					r->start = 0;
-				}
+	for_each_pci_dev_base_norom_resource(dev, r, idx) {
+		if (r->parent)	/* Already allocated */
+			continue;
+		if (!r->start)	/* Address not assigned at all */
+			continue;
+		if (r->flags & IORESOURCE_IO)
+			disabled = !(command & PCI_COMMAND_IO);
+		else
+			disabled = !(command & PCI_COMMAND_MEMORY);
+		if (pass == disabled) {
+			dev_dbg(&dev->dev,
+				"BAR %d: reserving %pr (d=%d, p=%d)\n",
+				idx, r, disabled, pass);
+			if (pci_claim_resource(dev, idx) < 0) {
+				/* We'll assign a new address later */
+				pcibios_save_fw_addr(dev, idx, r->start);
+				r->end -= r->start;
+				r->start = 0;
 			}
 		}
+	}
 	if (!pass) {
 		r = &dev->resource[PCI_ROM_RESOURCE];
 		if (r->flags & IORESOURCE_ROM_ENABLE) {
-- 
1.7.7

