Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab1JKDSq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 23:18:46 -0400
Received: from smtp-out.google.com ([216.239.44.51]:23124 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab1JKDSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 23:18:44 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=cmbDCF7n6g5lgKP7tLYe8MIr0HGAyvDJ/zgUTWqFywY2a6GVTAzrvTc+LePD7N69u
	yChNmahV6anJnnik+iwsw==
Subject: [PATCH 03/12] MIPS: PCI: supply root bus resources to pci_create_bus()
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Deng-Cheng Zhu <dczhu@mips.com>, linux-kernel@vger.kernel.org
Date: Mon, 10 Oct 2011 21:18:41 -0600
Message-ID: <20111011031840.5149.12861.stgit@bhelgaas.mtv.corp.google.com>
In-Reply-To: <20111011030726.5149.23793.stgit@bhelgaas.mtv.corp.google.com>
References: <20111011030726.5149.23793.stgit@bhelgaas.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new interface of pci_create_bus() so that system controller's
resources are added to the root bus upon bus creation, thereby avoiding
conflicts with PCI quirks before pcibios_fixup_bus() gets the chance to
fixup the root bus resources in pci_scan_child_bus().

Based on original patch by Deng-Cheng Zhu.

Reference: https://lkml.org/lkml/2011/8/26/89
CC: Deng-Cheng Zhu <dczhu@mips.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 arch/mips/pci/pci.c |   21 ++++++++++++++-------
 1 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/arch/mips/pci/pci.c b/arch/mips/pci/pci.c
index 33bba7b..4c7866d 100644
--- a/arch/mips/pci/pci.c
+++ b/arch/mips/pci/pci.c
@@ -80,6 +80,7 @@ static void __devinit pcibios_scanbus(struct pci_controller *hose)
 {
 	static int next_busno;
 	static int need_domain_info;
+	struct list_head resources;
 	struct pci_bus *bus;
 
 	if (!hose->iommu)
@@ -88,7 +89,17 @@ static void __devinit pcibios_scanbus(struct pci_controller *hose)
 	if (hose->get_busno && pci_probe_only)
 		next_busno = (*hose->get_busno)();
 
-	bus = pci_scan_bus(next_busno, hose->pci_ops, hose);
+	INIT_LIST_HEAD(&resources);
+	pci_add_resource(&resources, ctrl->mem_resource);
+	pci_add_resource(&resources, ctrl->io_resource);
+	bus = pci_create_bus(NULL, next_busno, hose->pci_ops, hose, &resources);
+	if (bus) {
+		bus->subordinate = pci_scan_child_bus(bus);
+		pci_bus_add_devices(bus);
+	} else {
+		pci_free_resource_list(&resources);
+	}
+
 	hose->bus = bus;
 
 	need_domain_info = need_domain_info || hose->index;
@@ -265,15 +276,11 @@ void __devinit pcibios_fixup_bus(struct pci_bus *bus)
 {
 	/* Propagate hose info into the subordinate devices.  */
 
-	struct pci_controller *hose = bus->sysdata;
 	struct list_head *ln;
 	struct pci_dev *dev = bus->self;
 
-	if (!dev) {
-		bus->resource[0] = hose->io_resource;
-		bus->resource[1] = hose->mem_resource;
-	} else if (pci_probe_only &&
-		   (dev->class >> 8) == PCI_CLASS_BRIDGE_PCI) {
+	if (pci_probe_only && dev &&
+	    (dev->class >> 8) == PCI_CLASS_BRIDGE_PCI) {
 		pci_read_bridge_bases(bus);
 		pcibios_fixup_device_resources(dev, bus);
 	}

