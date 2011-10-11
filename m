Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab1JKDTF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 23:19:05 -0400
Received: from smtp-out.google.com ([216.239.44.51]:23189 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152Ab1JKDTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 23:19:00 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=CvwS3NUnR2juD8vd+bdFs6bhoZk8w0eO6tQmwgNhcrjAha6UMnlD2LreUhm3m6BRE
	iFs4LLNWsk7ZXd9XKbzDA==
Subject: [PATCH 06/12] powerpc/pci: split PHB part out of
	pcibios_map_io_space()
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 10 Oct 2011 21:18:57 -0600
Message-ID: <20111011031857.5149.33943.stgit@bhelgaas.mtv.corp.google.com>
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

No functional change.  This is so we can use pcibios_phb_map_io_space()
before we have a struct pci_bus.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 arch/powerpc/kernel/pci_64.c |   40 +++++++++++++++++++++-------------------
 1 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/arch/powerpc/kernel/pci_64.c b/arch/powerpc/kernel/pci_64.c
index ab34046..4401425 100644
--- a/arch/powerpc/kernel/pci_64.c
+++ b/arch/powerpc/kernel/pci_64.c
@@ -130,30 +130,13 @@ EXPORT_SYMBOL_GPL(pcibios_unmap_io_space);
 
 #endif /* CONFIG_HOTPLUG */
 
-int __devinit pcibios_map_io_space(struct pci_bus *bus)
+static int __devinit pcibios_map_phb_io_space(struct pci_controller *hose)
 {
 	struct vm_struct *area;
 	unsigned long phys_page;
 	unsigned long size_page;
 	unsigned long io_virt_offset;
-	struct pci_controller *hose;
-
-	WARN_ON(bus == NULL);
-
-	/* If this not a PHB, nothing to do, page tables still exist and
-	 * thus HPTEs will be faulted in when needed
-	 */
-	if (bus->self) {
-		pr_debug("IO mapping for PCI-PCI bridge %s\n",
-			 pci_name(bus->self));
-		pr_debug("  virt=0x%016llx...0x%016llx\n",
-			 bus->resource[0]->start + _IO_BASE,
-			 bus->resource[0]->end + _IO_BASE);
-		return 0;
-	}
 
-	/* Get the host bridge */
-	hose = pci_bus_to_host(bus);
 	phys_page = _ALIGN_DOWN(hose->io_base_phys, PAGE_SIZE);
 	size_page = _ALIGN_UP(hose->pci_io_size, PAGE_SIZE);
 
@@ -197,11 +180,30 @@ int __devinit pcibios_map_io_space(struct pci_bus *bus)
 
 	return 0;
 }
+
+int __devinit pcibios_map_io_space(struct pci_bus *bus)
+{
+	WARN_ON(bus == NULL);
+
+	/* If this not a PHB, nothing to do, page tables still exist and
+	 * thus HPTEs will be faulted in when needed
+	 */
+	if (bus->self) {
+		pr_debug("IO mapping for PCI-PCI bridge %s\n",
+			 pci_name(bus->self));
+		pr_debug("  virt=0x%016llx...0x%016llx\n",
+			 bus->resource[0]->start + _IO_BASE,
+			 bus->resource[0]->end + _IO_BASE);
+		return 0;
+	}
+
+	return pcibios_phb_map_phb_io_space(pci_bus_to_host(bus));
+}
 EXPORT_SYMBOL_GPL(pcibios_map_io_space);
 
 void __devinit pcibios_setup_phb_io_space(struct pci_controller *hose)
 {
-	pcibios_map_io_space(hose->bus);
+	pcibios_map_phb_io_space(hose);
 }
 
 #define IOBASE_BRIDGE_NUMBER	0

