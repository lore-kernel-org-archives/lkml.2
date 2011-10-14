Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932660Ab1JNEay (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 00:30:54 -0400
Received: from smtp-out.google.com ([74.125.121.67]:50492 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932460Ab1JNE3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 00:29:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=odaLRetLaZfgLXUtJFRtJ+8i65UYUb1NmcvAJWiTjEm0iQbuUBM/xdEIqsESUG8Ki
	X9IXL3tXhf3+sOuE01/0w==
Subject: [PATCH v2 24/29] alpha/PCI: convert to pci_scan_root_bus() for
	correct root bus resources
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 13 Oct 2011 22:29:09 -0600
Message-ID: <20111014042909.23504.29138.stgit@bhelgaas.mtv.corp.google.com>
In-Reply-To: <20111014042142.23504.70417.stgit@bhelgaas.mtv.corp.google.com>
References: <20111014042142.23504.70417.stgit@bhelgaas.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert from pci_scan_bus() to pci_scan_root_bus() and remove root bus
resource fixups.  This fixes the problem of "early" and "header" quirks
seeing incorrect root bus resources.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 arch/alpha/kernel/pci.c |   37 ++++++++++++++++++++-----------------
 1 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/arch/alpha/kernel/pci.c b/arch/alpha/kernel/pci.c
index c9ab94e..e9e78a2 100644
--- a/arch/alpha/kernel/pci.c
+++ b/arch/alpha/kernel/pci.c
@@ -286,22 +286,7 @@ pcibios_fixup_bus(struct pci_bus *bus)
 	struct pci_controller *hose = bus->sysdata;
 	struct pci_dev *dev = bus->self;
 
-	if (!dev) {
-		/* Root bus. */
-		u32 pci_mem_end;
-		u32 sg_base = hose->sg_pci ? hose->sg_pci->dma_base : ~0;
-		unsigned long end;
-
-		bus->resource[0] = hose->io_space;
-		bus->resource[1] = hose->mem_space;
-
-		/* Adjust hose mem_space limit to prevent PCI allocations
-		   in the iommu windows. */
-		pci_mem_end = min((u32)__direct_map_base, sg_base) - 1;
-		end = hose->mem_space->start + pci_mem_end;
-		if (hose->mem_space->end > end)
-			hose->mem_space->end = end;
- 	} else if (pci_probe_only &&
+	if (pci_probe_only && dev &&
  		   (dev->class >> 8) == PCI_CLASS_BRIDGE_PCI) {
  		pci_read_bridge_bases(bus);
  		pcibios_fixup_device_resources(dev, bus);
@@ -414,13 +399,31 @@ void __init
 common_init_pci(void)
 {
 	struct pci_controller *hose;
+	struct list_head resources;
 	struct pci_bus *bus;
 	int next_busno;
 	int need_domain_info = 0;
+	u32 pci_mem_end;
+	u32 sg_base;
+	unsigned long end;
 
 	/* Scan all of the recorded PCI controllers.  */
 	for (next_busno = 0, hose = hose_head; hose; hose = hose->next) {
-		bus = pci_scan_bus(next_busno, alpha_mv.pci_ops, hose);
+		sg_base = hose->sg_pci ? hose->sg_pci->dma_base : ~0;
+
+		/* Adjust hose mem_space limit to prevent PCI allocations
+		   in the iommu windows. */
+		pci_mem_end = min((u32)__direct_map_base, sg_base) - 1;
+		end = hose->mem_space->start + pci_mem_end;
+		if (hose->mem_space->end > end)
+			hose->mem_space->end = end;
+
+		INIT_LIST_HEAD(&resources);
+		pci_add_resource(&resources, &hose->io_space);
+		pci_add_resource(&resources, &hose->mem_space);
+
+		bus = pci_scan_root_bus(NULL, next_busno, alpha_mv.pci_ops,
+					hose, &resources);
 		hose->bus = bus;
 		hose->need_domain_info = need_domain_info;
 		next_busno = bus->subordinate + 1;

