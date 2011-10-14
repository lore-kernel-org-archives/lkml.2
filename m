Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500Ab1JNE2q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 00:28:46 -0400
Received: from smtp-out.google.com ([216.239.44.51]:21295 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932433Ab1JNE2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 00:28:38 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=cKL5BmkrgTuotg63A5pV5CeFiRenhi9Qt8tRN64ECrt7VblUT4uxuHspChoJqF1WO
	lJ+fhcuFedKdWTE6qMvQg==
Subject: [PATCH v2 17/29] ia64/PCI: convert to pci_create_root_bus() for
	correct root bus resources
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-arch@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 13 Oct 2011 22:28:33 -0600
Message-ID: <20111014042833.23504.81310.stgit@bhelgaas.mtv.corp.google.com>
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

Convert from pci_create_bus() to pci_create_root_bus().  This way the root
bus resources are correct immediately.  This fixes the problem of "early"
and "header" quirks seeing incorrect root bus resources.

We can't use pci_scan_root_bus() because, like x86, ACPI hotplug currently
requires pci_bus_add_devices() in a separate host bridge .start() method.

CC: Tony Luck <tony.luck@intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 arch/ia64/pci/pci.c |   39 ++++++++++++++-------------------------
 1 files changed, 14 insertions(+), 25 deletions(-)

diff --git a/arch/ia64/pci/pci.c b/arch/ia64/pci/pci.c
index d7e47a9..a7949b5 100644
--- a/arch/ia64/pci/pci.c
+++ b/arch/ia64/pci/pci.c
@@ -133,6 +133,7 @@ alloc_pci_controller (int seg)
 struct pci_root_info {
 	struct acpi_device *bridge;
 	struct pci_controller *controller;
+	struct list_head resources;
 	char *name;
 };
 
@@ -314,24 +315,13 @@ static __devinit acpi_status add_window(struct acpi_resource *res, void *data)
 				 &window->resource);
 	}
 
-	return AE_OK;
-}
+	/* HP's firmware has a hack to work around a Windows bug.
+	 * Ignore these tiny memory ranges */
+	if (!((res->flags & IORESOURCE_MEM) &&
+	      (res->end - res->start < 16)))
+		pci_add_resource(&info->resources, &window->resource);
 
-static void __devinit
-pcibios_setup_root_windows(struct pci_bus *bus, struct pci_controller *ctrl)
-{
-	int i;
-
-	pci_bus_remove_resources(bus);
-	for (i = 0; i < ctrl->windows; i++) {
-		struct resource *res = &ctrl->window[i].resource;
-		/* HP's firmware has a hack to work around a Windows bug.
-		 * Ignore these tiny memory ranges */
-		if ((res->flags & IORESOURCE_MEM) &&
-		    (res->end - res->start < 16))
-			continue;
-		pci_bus_add_resource(bus, res, 0);
-	}
+	return AE_OK;
 }
 
 struct pci_bus * __devinit
@@ -342,6 +332,7 @@ pci_acpi_scan_root(struct acpi_pci_root *root)
 	int bus = root->secondary.start;
 	struct pci_controller *controller;
 	unsigned int windows = 0;
+	struct pci_root_info info;
 	struct pci_bus *pbus;
 	char *name;
 	int pxm;
@@ -358,11 +349,10 @@ pci_acpi_scan_root(struct acpi_pci_root *root)
 		controller->node = pxm_to_node(pxm);
 #endif
 
+	INIT_LIST_HEAD(&info.resources);
 	acpi_walk_resources(device->handle, METHOD_NAME__CRS, count_window,
 			&windows);
 	if (windows) {
-		struct pci_root_info info;
-
 		controller->window =
 			kmalloc_node(sizeof(*controller->window) * windows,
 				     GFP_KERNEL, controller->node);
@@ -386,9 +376,12 @@ pci_acpi_scan_root(struct acpi_pci_root *root)
 	 * should handle the case here, but it appears that IA64 hasn't
 	 * such quirk. So we just ignore the case now.
 	 */
-	pbus = pci_create_bus(NULL, bus, &pci_root_ops, controller, NULL);
-	if (!pbus)
+	pbus = pci_create_root_bus(NULL, bus, &pci_root_ops, controller,
+				   &info.resources);
+	if (!pbus) {
+		pci_free_resource_list(&info.resources);
 		return NULL;
+	}
 
 	pbus->subordinate = pci_scan_child_bus(pbus);
 	return pbus;
@@ -506,14 +499,10 @@ pcibios_fixup_bus (struct pci_bus *b)
 	if (b->self) {
 		pci_read_bridge_bases(b);
 		pcibios_fixup_bridge_resources(b->self);
-	} else {
-		pcibios_setup_root_windows(b, b->sysdata);
 	}
 	list_for_each_entry(dev, &b->devices, bus_list)
 		pcibios_fixup_device_resources(dev);
 	platform_pci_fixup_bus(b);
-
-	return;
 }
 
 void __devinit

