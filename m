Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933256Ab2BAWsu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 17:48:50 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:33790 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933186Ab2BAWoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 17:44:32 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 05/15] PCI, x86: Register busn_res for root buses
Date: Wed,  1 Feb 2012 14:43:52 -0800
Message-Id: <1328136242-17725-6-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1328136242-17725-1-git-send-email-yinghai@kernel.org>
References: <1328136242-17725-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4F29C048.0099,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

update x86_pci_root_bus_resources() to get bus_max for non-acpi case.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/topology.h |    3 ++-
 arch/x86/pci/acpi.c             |    8 +++++---
 arch/x86/pci/bus_numa.c         |    8 +++++++-
 arch/x86/pci/common.c           |   11 +++++++----
 4 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index b9676ae..ad4060e 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -172,7 +172,8 @@ static inline void arch_fix_phys_package_id(int num, u32 slot)
 }
 
 struct pci_bus;
-void x86_pci_root_bus_resources(int bus, struct list_head *resources);
+void x86_pci_root_bus_resources(int bus, int *bus_max,
+				struct list_head *resources);
 
 #ifdef CONFIG_SMP
 #define mc_capable()	((boot_cpu_data.x86_max_cores > 1) && \
diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index daa4249..b25b5b1 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -348,6 +348,7 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_pci_root *root)
 	struct acpi_device *device = root->device;
 	int domain = root->segment;
 	int busnum = root->secondary.start;
+	int busmax = root->secondary.end;
 	LIST_HEAD(resources);
 	struct pci_bus *bus;
 	struct pci_sysdata *sd;
@@ -410,12 +411,13 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_pci_root *root)
 		 * defaults or native bridge info if we're ignoring _CRS.
 		 */
 		if (!pci_use_crs)
-			x86_pci_root_bus_resources(busnum, &resources);
+			x86_pci_root_bus_resources(busnum, &busmax, &resources);
 		bus = pci_create_root_bus(NULL, busnum, &pci_root_ops, sd,
 					  &resources);
-		if (bus)
+		if (bus) {
+			pci_bus_insert_busn_res(bus, busnum, busmax);
 			bus->subordinate = pci_scan_child_bus(bus);
-		else
+		} else
 			pci_free_resource_list(&resources);
 	}
 
diff --git a/arch/x86/pci/bus_numa.c b/arch/x86/pci/bus_numa.c
index fd3f655..5213cd8 100644
--- a/arch/x86/pci/bus_numa.c
+++ b/arch/x86/pci/bus_numa.c
@@ -7,7 +7,8 @@
 int pci_root_num;
 struct pci_root_info pci_root_info[PCI_ROOT_NR];
 
-void x86_pci_root_bus_resources(int bus, struct list_head *resources)
+void x86_pci_root_bus_resources(int bus, int *bus_max,
+				struct list_head *resources)
 {
 	int i;
 	int j;
@@ -28,6 +29,7 @@ void x86_pci_root_bus_resources(int bus, struct list_head *resources)
 	       bus);
 
 	info = &pci_root_info[i];
+	*bus_max = info->bus_max;
 	for (j = 0; j < info->res_num; j++) {
 		struct resource *res;
 		struct resource *root;
@@ -51,6 +53,10 @@ default_resources:
 	printk(KERN_DEBUG "PCI: root bus %02x: using default resources\n", bus);
 	pci_add_resource(resources, &ioport_resource);
 	pci_add_resource(resources, &iomem_resource);
+	if (!bus)
+		*bus_max = 0xff;
+	else if (!*bus_max)
+		*bus_max = bus;
 }
 
 void __devinit update_res(struct pci_root_info *info, resource_size_t start,
diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 323481e..ce0aefc 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -433,6 +433,7 @@ struct pci_bus * __devinit pcibios_scan_root(int busnum)
 	LIST_HEAD(resources);
 	struct pci_bus *bus = NULL;
 	struct pci_sysdata *sd;
+	int bus_max;
 
 	while ((bus = pci_find_next_bus(bus)) != NULL) {
 		if (bus->number == busnum) {
@@ -454,8 +455,9 @@ struct pci_bus * __devinit pcibios_scan_root(int busnum)
 	sd->node = get_mp_bus_to_node(busnum);
 
 	printk(KERN_DEBUG "PCI: Probing PCI hardware (bus %02x)\n", busnum);
-	x86_pci_root_bus_resources(busnum, &resources);
-	bus = pci_scan_root_bus(NULL, busnum, &pci_root_ops, sd, &resources);
+	x86_pci_root_bus_resources(busnum, &bus_max, &resources);
+	bus = pci_scan_root_bus_max(NULL, busnum, bus_max, &pci_root_ops, sd,
+				&resources);
 	if (!bus) {
 		pci_free_resource_list(&resources);
 		kfree(sd);
@@ -643,6 +645,7 @@ struct pci_bus * __devinit pci_scan_bus_on_node(int busno, struct pci_ops *ops,
 	LIST_HEAD(resources);
 	struct pci_bus *bus = NULL;
 	struct pci_sysdata *sd;
+	int bus_max;
 
 	/*
 	 * Allocate per-root-bus (not per bus) arch-specific data.
@@ -655,8 +658,8 @@ struct pci_bus * __devinit pci_scan_bus_on_node(int busno, struct pci_ops *ops,
 		return NULL;
 	}
 	sd->node = node;
-	x86_pci_root_bus_resources(busno, &resources);
-	bus = pci_scan_root_bus(NULL, busno, ops, sd, &resources);
+	x86_pci_root_bus_resources(busno, &bus_max, &resources);
+	bus = pci_scan_root_bus_max(NULL, busno, bus_max, ops, sd, &resources);
 	if (!bus) {
 		pci_free_resource_list(&resources);
 		kfree(sd);
-- 
1.7.7

