Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932294Ab1JNE1i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 00:27:38 -0400
Received: from smtp-out.google.com ([74.125.121.67]:49803 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238Ab1JNE1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 00:27:34 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=s/hr6WblWx4FAD3TlIZcBdn9pN6epKc2FGGqubu0GCw1OXpRn4hXQWft1BB0XLQnj
	JcBOCMdtt8N4AQoqHA0WA==
Subject: [PATCH v2 04/29] MIPS: PCI: convert to pci_scan_root_bus() for
	correct root bus resources
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-arch@vger.kernel.org, Deng-Cheng Zhu <dczhu@mips.com>,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>
Date: Thu, 13 Oct 2011 22:27:27 -0600
Message-ID: <20111014042727.23504.20722.stgit@bhelgaas.mtv.corp.google.com>
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

Based on original patch by Deng-Cheng Zhu.

Reference: https://lkml.org/lkml/2011/8/26/89
CC: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Deng-Cheng Zhu <dczhu@mips.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 arch/mips/pci/pci.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/mips/pci/pci.c b/arch/mips/pci/pci.c
index 33bba7b..8ce4979 100644
--- a/arch/mips/pci/pci.c
+++ b/arch/mips/pci/pci.c
@@ -80,6 +80,7 @@ static void __devinit pcibios_scanbus(struct pci_controller *hose)
 {
 	static int next_busno;
 	static int need_domain_info;
+	struct list_head resources;
 	struct pci_bus *bus;
 
 	if (!hose->iommu)
@@ -88,7 +89,14 @@ static void __devinit pcibios_scanbus(struct pci_controller *hose)
 	if (hose->get_busno && pci_probe_only)
 		next_busno = (*hose->get_busno)();
 
-	bus = pci_scan_bus(next_busno, hose->pci_ops, hose);
+	INIT_LIST_HEAD(&resources);
+	pci_add_resource(&resources, hose->mem_resource);
+	pci_add_resource(&resources, hose->io_resource);
+	bus = pci_scan_root_bus(NULL, next_busno, hose->pci_ops, hose,
+				&resources);
+	if (!bus)
+		pci_free_resource_list(&resources);
+
 	hose->bus = bus;
 
 	need_domain_info = need_domain_info || hose->index;
@@ -265,15 +273,11 @@ void __devinit pcibios_fixup_bus(struct pci_bus *bus)
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

