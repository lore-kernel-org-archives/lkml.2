Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab1JKDSw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 23:18:52 -0400
Received: from smtp-out.google.com ([216.239.44.51]:23133 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab1JKDSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 23:18:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=p99ST0Bv3WqqUyRPOVAdy9D3KKg8IWgxn3FpV38CpDS1gN9E8zUfV6D+7oMTPtS52
	c2Z6PrDrkrdkD5Hd+CE9A==
Subject: [PATCH 04/12] x86/PCI: supply root bus resources to pci_create_bus()
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 10 Oct 2011 21:18:46 -0600
Message-ID: <20111011031846.5149.27532.stgit@bhelgaas.mtv.corp.google.com>
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

Parse ACPI host bridge _CRS resources first, so we can build a list of
resources available on the root bus and pass it to pci_create_bus().

Note that as before, we parse the ACPI _CRS even if we aren't paying
attention to it so we can print it for debugging purposes.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 arch/x86/pci/acpi.c |   41 ++++++++++++++++++++++++++---------------
 1 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index 9bf7aaa..6269545 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -12,7 +12,7 @@ struct pci_root_info {
 	char *name;
 	unsigned int res_num;
 	struct resource *res;
-	struct pci_bus *bus;
+	struct list_head *resources;
 	int busnum;
 };
 
@@ -250,27 +250,27 @@ static void add_resources(struct pci_root_info *info)
 				 "ignoring host bridge window %pR (conflicts with %s %pR)\n",
 				 res, conflict->name, conflict);
 		else
-			pci_bus_add_resource(info->bus, res, 0);
+			pci_add_resource(info->resources, res);
 	}
 }
 
-static void
-get_current_resources(struct acpi_device *device, int busnum,
-			int domain, struct pci_bus *bus)
+static struct list_head *
+get_current_resources(struct acpi_device *device, int busnum, int domain)
 {
 	struct pci_root_info info;
 	size_t size;
 
-	if (pci_use_crs)
-		pci_bus_remove_resources(bus);
-
 	info.bridge = device;
-	info.bus = bus;
 	info.res_num = 0;
+	info.resources = kmalloc(sizeof(struct list_head), GFP_KERNEL);
+	if (!info.resources)
+		return NULL;
+
+	INIT_LIST_HEAD(info.resources);
 	acpi_walk_resources(device->handle, METHOD_NAME__CRS, count_resource,
 				&info);
 	if (!info.res_num)
-		return;
+		goto res_alloc_fail;
 
 	size = sizeof(*info.res) * info.res_num;
 	info.res = kmalloc(size, GFP_KERNEL);
@@ -286,12 +286,12 @@ get_current_resources(struct acpi_device *device, int busnum,
 				&info);
 
 	add_resources(&info);
-	return;
+	return info.resources;
 
 name_alloc_fail:
 	kfree(info.res);
 res_alloc_fail:
-	return;
+	return info.resources;
 }
 
 struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_pci_root *root)
@@ -299,6 +299,7 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_pci_root *root)
 	struct acpi_device *device = root->device;
 	int domain = root->segment;
 	int busnum = root->secondary.start;
+	struct list_head *resources;
 	struct pci_bus *bus;
 	struct pci_sysdata *sd;
 	int node;
@@ -353,11 +354,21 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_pci_root *root)
 		memcpy(bus->sysdata, sd, sizeof(*sd));
 		kfree(sd);
 	} else {
-		bus = pci_create_bus(NULL, busnum, &pci_root_ops, sd, NULL);
-		if (bus) {
-			get_current_resources(device, busnum, domain, bus);
+		resources = get_current_resources(device, busnum, domain);
+		if (!pci_use_crs) {
+			pci_free_resource_list(resources);
+			resources = NULL;
+		}
+
+		bus = pci_create_bus(NULL, busnum, &pci_root_ops, sd,
+				     resources);
+		if (bus)
 			bus->subordinate = pci_scan_child_bus(bus);
+		else {
+			if (resources)
+				pci_free_resource_list(resources);
 		}
+		kfree(resources);
 	}
 
 	/* After the PCI-E bus has been walked and all devices discovered,

