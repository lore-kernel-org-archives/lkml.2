Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab2BZXdt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 18:33:49 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:21143 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab2BZXdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 18:33:47 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 2/8] x86, PCI: have own version for pcibios_bus_to_resource
Date: Sun, 26 Feb 2012 15:33:16 -0800
Message-Id: <1330299202-3838-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330299202-3838-1-git-send-email-yinghai@kernel.org>
References: <1330299202-3838-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4F4AC158.0039,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86 does not need to offset the address. So we can skip that costing offset
searching.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/pci/i386.c       |   14 ++++++++++++++
 drivers/pci/host-bridge.c |    9 +++++----
 2 files changed, 19 insertions(+), 4 deletions(-)

Index: linux-2.6/arch/x86/pci/i386.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/i386.c
+++ linux-2.6/arch/x86/pci/i386.c
@@ -335,6 +335,20 @@ void __init pcibios_resource_survey(void
  */
 fs_initcall(pcibios_assign_resources);
 
+void pcibios_resource_to_bus(struct pci_dev *dev, struct pci_bus_region *region,
+			     struct resource *res)
+{
+	region->start = res->start;
+	region->end = res->end;
+}
+
+void pcibios_bus_to_resource(struct pci_dev *dev, struct resource *res,
+			     struct pci_bus_region *region)
+{
+	res->start = region->start;
+	res->end = region->end;
+}
+
 static const struct vm_operations_struct pci_mmap_ops = {
 	.access = generic_access_phys,
 };
Index: linux-2.6/drivers/pci/host-bridge.c
===================================================================
--- linux-2.6.orig/drivers/pci/host-bridge.c
+++ linux-2.6/drivers/pci/host-bridge.c
@@ -38,8 +38,9 @@ static bool resource_contains(struct res
 	return res1->start <= res2->start && res1->end >= res2->end;
 }
 
-void pcibios_resource_to_bus(struct pci_dev *dev, struct pci_bus_region *region,
-			     struct resource *res)
+void __weak pcibios_resource_to_bus(struct pci_dev *dev,
+				    struct pci_bus_region *region,
+				    struct resource *res)
 {
 	struct pci_host_bridge *bridge = pci_host_bridge(dev);
 	struct pci_host_bridge_window *window;
@@ -66,8 +67,8 @@ static bool region_contains(struct pci_b
 	return region1->start <= region2->start && region1->end >= region2->end;
 }
 
-void pcibios_bus_to_resource(struct pci_dev *dev, struct resource *res,
-			     struct pci_bus_region *region)
+void __weak pcibios_bus_to_resource(struct pci_dev *dev, struct resource *res,
+				    struct pci_bus_region *region)
 {
 	struct pci_host_bridge *bridge = pci_host_bridge(dev);
 	struct pci_host_bridge_window *window;
