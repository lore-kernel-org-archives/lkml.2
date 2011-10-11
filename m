Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129Ab1JKDSo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 23:18:44 -0400
Received: from smtp-out.google.com ([74.125.121.67]:44481 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab1JKDSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 23:18:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=WfSSVD1gSf0GoA73iCReoOKbctgNg2V2R0v91Bp7XJcPyLmNt4xd8ZFYz5nYOjixz
	FaUtxcaczC0xkS6yyFcbA==
Subject: [PATCH 02/12] PCI: pass available resources into pci_create_bus()
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Deng-Cheng Zhu <dczhu@mips.com>, linux-kernel@vger.kernel.org
Date: Mon, 10 Oct 2011 21:18:35 -0600
Message-ID: <20111011031835.5149.98333.stgit@bhelgaas.mtv.corp.google.com>
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

The default resources given to a bus by pci_create_bus()
are ioport_resource and iomem_resource, i.e., the entire address
space.  Architectures are expected to correct these later, typically
in pcibios_fixup_bus(), but code such as PCI quirks that run in the
interim see incorrect resource information.

This patch adds a "resources" argument to pci_create_bus() so
architecture code can supply the correct resources at the beginning.

Based on original patch by Deng-Cheng Zhu.

Reference: http://www.spinics.net/lists/mips/msg41654.html
Reference: https://lkml.org/lkml/2011/8/26/88
CC: Deng-Cheng Zhu <dczhu@mips.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 arch/microblaze/pci/pci-common.c |    3 ++-
 arch/powerpc/kernel/pci-common.c |    3 ++-
 arch/sparc/kernel/pci.c          |    3 ++-
 arch/x86/pci/acpi.c              |    2 +-
 drivers/pci/probe.c              |   17 +++++++++++++----
 include/linux/pci.h              |    3 ++-
 6 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/arch/microblaze/pci/pci-common.c b/arch/microblaze/pci/pci-common.c
index 4cfae20..9c35aa6 100644
--- a/arch/microblaze/pci/pci-common.c
+++ b/arch/microblaze/pci/pci-common.c
@@ -1581,7 +1581,8 @@ static void __devinit pcibios_scan_phb(struct pci_controller *hose)
 		 node ? node->full_name : "<NO NAME>");
 
 	/* Create an empty bus for the toplevel */
-	bus = pci_create_bus(hose->parent, hose->first_busno, hose->ops, hose);
+	bus = pci_create_bus(hose->parent, hose->first_busno,
+			     hose->ops, hose, NULL);
 	if (bus == NULL) {
 		printk(KERN_ERR "Failed to create bus for PCI domain %04x\n",
 		       hose->global_number);
diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
index 32656f1..2ede26a 100644
--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -1703,7 +1703,8 @@ void __devinit pcibios_scan_phb(struct pci_controller *hose)
 		 node ? node->full_name : "<NO NAME>");
 
 	/* Create an empty bus for the toplevel */
-	bus = pci_create_bus(hose->parent, hose->first_busno, hose->ops, hose);
+	bus = pci_create_bus(hose->parent, hose->first_busno,
+			     hose->ops, hose, NULL);
 	if (bus == NULL) {
 		pr_err("Failed to create bus for PCI domain %04x\n",
 			hose->global_number);
diff --git a/arch/sparc/kernel/pci.c b/arch/sparc/kernel/pci.c
index 1e94f94..77c38bb 100644
--- a/arch/sparc/kernel/pci.c
+++ b/arch/sparc/kernel/pci.c
@@ -689,7 +689,8 @@ struct pci_bus * __devinit pci_scan_one_pbm(struct pci_pbm_info *pbm,
 
 	printk("PCI: Scanning PBM %s\n", node->full_name);
 
-	bus = pci_create_bus(parent, pbm->pci_first_busno, pbm->pci_ops, pbm);
+	bus = pci_create_bus(parent, pbm->pci_first_busno,
+			     pbm->pci_ops, pbm, NULL);
 	if (!bus) {
 		printk(KERN_ERR "Failed to create bus for %s\n",
 		       node->full_name);
diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index 039d913..9bf7aaa 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -353,7 +353,7 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_pci_root *root)
 		memcpy(bus->sysdata, sd, sizeof(*sd));
 		kfree(sd);
 	} else {
-		bus = pci_create_bus(NULL, busnum, &pci_root_ops, sd);
+		bus = pci_create_bus(NULL, busnum, &pci_root_ops, sd, NULL);
 		if (bus) {
 			get_current_resources(device, busnum, domain, bus);
 			bus->subordinate = pci_scan_child_bus(bus);
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 6ab6bd3..6a8e1c6 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1529,11 +1529,13 @@ unsigned int __devinit pci_scan_child_bus(struct pci_bus *bus)
 }
 
 struct pci_bus * pci_create_bus(struct device *parent,
-		int bus, struct pci_ops *ops, void *sysdata)
+		int bus, struct pci_ops *ops, void *sysdata,
+		struct list_head *resources)
 {
 	int error;
 	struct pci_bus *b, *b2;
 	struct device *dev;
+	struct pci_bus_resource *bus_res, *n;
 
 	b = pci_alloc_bus();
 	if (!b)
@@ -1583,8 +1585,15 @@ struct pci_bus * pci_create_bus(struct device *parent,
 	pci_create_legacy_files(b);
 
 	b->number = b->secondary = bus;
-	b->resource[0] = &ioport_resource;
-	b->resource[1] = &iomem_resource;
+
+	/* Add initial resources to the bus */
+	if (resources) {
+		list_for_each_entry_safe(bus_res, n, resources, list)
+			list_move_tail(&bus_res->list, &b->resources);
+	} else {
+		b->resource[0] = &ioport_resource;
+		b->resource[1] = &iomem_resource;
+	}
 
 	return b;
 
@@ -1605,7 +1614,7 @@ struct pci_bus * __devinit pci_scan_bus_parented(struct device *parent,
 {
 	struct pci_bus *b;
 
-	b = pci_create_bus(parent, bus, ops, sysdata);
+	b = pci_create_bus(parent, bus, ops, sysdata, NULL);
 	if (b)
 		b->subordinate = pci_scan_child_bus(b);
 	return b;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 6841e7f..f5e1b4a 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -667,7 +667,8 @@ static inline struct pci_bus * __devinit pci_scan_bus(int bus, struct pci_ops *o
 	return root_bus;
 }
 struct pci_bus *pci_create_bus(struct device *parent, int bus,
-			       struct pci_ops *ops, void *sysdata);
+			       struct pci_ops *ops, void *sysdata,
+			       struct list_head *resources);
 struct pci_bus *pci_add_new_bus(struct pci_bus *parent, struct pci_dev *dev,
 				int busnr);
 void pcie_update_link_speed(struct pci_bus *bus, u16 link_status);

