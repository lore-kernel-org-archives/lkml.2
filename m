Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932467Ab1JNE2c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 00:28:32 -0400
Received: from smtp-out.google.com ([74.125.121.67]:50136 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932453Ab1JNE23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 00:28:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=p73Gdq6JgizxG5QEYFEHuEi0UGddUxEFXQgRQF3uyVBBHI1i/sSZLey0c/qn9EDKO
	yJ/bLIFzAPULP5OMtIvtA==
Subject: [PATCH v2 15/29] sparc32,
	leon/PCI: convert to pci_scan_root_bus() for correct root bus
	resources
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Date: Thu, 13 Oct 2011 22:28:23 -0600
Message-ID: <20111014042823.23504.88314.stgit@bhelgaas.mtv.corp.google.com>
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

Convert from pci_scan_bus_parented() to pci_scan_root_bus() and remove root
bus resource fixups.  This fixes the problem of "early" and "header" quirks
seeing incorrect root bus resources.

pci_scan_root_bus() also includes the pci_bus_add_devices() so we don't
need to do that separately.

CC: David S. Miller <davem@davemloft.net>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 arch/sparc/kernel/leon_pci.c |   26 +++++++++-----------------
 1 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/arch/sparc/kernel/leon_pci.c b/arch/sparc/kernel/leon_pci.c
index a8a9a27..b7f2e9a 100644
--- a/arch/sparc/kernel/leon_pci.c
+++ b/arch/sparc/kernel/leon_pci.c
@@ -18,22 +18,23 @@
  */
 void leon_pci_init(struct platform_device *ofdev, struct leon_pci_info *info)
 {
+	struct list_head resources;
 	struct pci_bus *root_bus;
 
-	root_bus = pci_scan_bus_parented(&ofdev->dev, 0, info->ops, info);
-	if (root_bus) {
-		root_bus->resource[0] = &info->io_space;
-		root_bus->resource[1] = &info->mem_space;
-		root_bus->resource[2] = NULL;
-
-		/* Init all PCI devices into PCI tree */
-		pci_bus_add_devices(root_bus);
+	INIT_LIST_HEAD(&resources);
+	pci_add_resource(&resources, &info->io_space);
+	pci_add_resource(&resources, &info->mem_space);
 
+	root_bus = pci_scan_root_bus(&ofdev->dev, 0, info->ops, info,
+				     &resources);
+	if (root_bus) {
 		/* Setup IRQs of all devices using custom routines */
 		pci_fixup_irqs(pci_common_swizzle, info->map_irq);
 
 		/* Assign devices with resources */
 		pci_assign_unassigned_resources();
+	} else {
+		pci_free_resource_list(&resources);
 	}
 }
 
@@ -82,15 +83,6 @@ void __devinit pcibios_fixup_bus(struct pci_bus *pbus)
 	int i, has_io, has_mem;
 	u16 cmd;
 
-	/* Generic PCI bus probing sets these to point at
-	 * &io{port,mem}_resouce which is wrong for us.
-	 */
-	if (pbus->self == NULL) {
-		pbus->resource[0] = &info->io_space;
-		pbus->resource[1] = &info->mem_space;
-		pbus->resource[2] = NULL;
-	}
-
 	list_for_each_entry(dev, &pbus->devices, bus_list) {
 		/*
 		 * We can not rely on that the bootloader has enabled I/O

