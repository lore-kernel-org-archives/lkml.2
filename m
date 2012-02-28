Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab2B1CIQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 21:08:16 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:19999 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab2B1CEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 21:04:49 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 02/11] x86, PCI: have own version for pcibios_bus_to_resource
Date: Mon, 27 Feb 2012 18:03:42 -0800
Message-Id: <1330394631-28978-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330394631-28978-1-git-send-email-yinghai@kernel.org>
References: <1330394631-28978-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090203.4F4C363D.0121,ss=1,re=0.000,fgs=0
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

diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 33e6a0b..eeed28e 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -335,6 +335,20 @@ void __init pcibios_resource_survey(void)
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
diff --git a/drivers/pci/host-bridge.c b/drivers/pci/host-bridge.c
index 5ca4220..dfaff3f 100644
--- a/drivers/pci/host-bridge.c
+++ b/drivers/pci/host-bridge.c
@@ -38,8 +38,9 @@ static bool resource_contains(struct resource *res1, struct resource *res2)
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
@@ -66,8 +67,8 @@ static bool region_contains(struct pci_bus_region *region1,
 	return region1->start <= region2->start && region1->end >= region2->end;
 }
 
-void pcibios_bus_to_resource(struct pci_dev *dev, struct resource *res,
-			     struct pci_bus_region *region)
+void __weak pcibios_bus_to_resource(struct pci_dev *dev, struct resource *res,
+				    struct pci_bus_region *region)
 {
 	struct pci_host_bridge *bridge = pci_host_bridge(dev);
 	struct pci_host_bridge_window *window;
-- 
1.7.7

