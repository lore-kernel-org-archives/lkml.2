Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161811Ab2CSFvK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 01:51:10 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:25602 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162085Ab2CSFuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:50:03 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v2 23/26] PCI: Make assign/update resource to support addon_res
Date: Sun, 18 Mar 2012 22:48:46 -0700
Message-Id: <1332136129-14010-24-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332136129-14010-1-git-send-email-yinghai@kernel.org>
References: <1332136129-14010-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090202.4F66C909.0011,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/setup-res.c |   24 ++++++++++++++++++------
 1 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index 161a015..4c6c924 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -33,7 +33,7 @@ void pci_update_resource(struct pci_dev *dev, int resno)
 	u32 new, check, mask;
 	int reg;
 	enum pci_bar_type type;
-	struct resource *res = dev->resource + resno;
+	struct resource *res = pci_dev_resource_n(dev, resno);
 
 	/*
 	 * Ignore resources for unimplemented BARs and unused resource slots
@@ -50,6 +50,21 @@ void pci_update_resource(struct pci_dev *dev, int resno)
 	if (res->flags & IORESOURCE_PCI_FIXED)
 		return;
 
+	if (resno >= PCI_NUM_RESOURCES) {
+		struct pci_dev_addon_resource *addon_res;
+
+		addon_res = to_pci_dev_addon_resource(res);
+		reg = addon_res->reg_addr;
+		if (addon_res->ops) {
+			addon_res->ops->write(dev, res, reg);
+			return;
+		}
+	} else
+		reg = pci_resource_bar(dev, resno, &type);
+
+	if (!reg)
+		return;
+
 	pcibios_resource_to_bus(dev, &region, res);
 
 	new = region.start | (res->flags & PCI_REGION_FLAG_MASK);
@@ -58,9 +73,6 @@ void pci_update_resource(struct pci_dev *dev, int resno)
 	else
 		mask = (u32)PCI_BASE_ADDRESS_MEM_MASK;
 
-	reg = pci_resource_bar(dev, resno, &type);
-	if (!reg)
-		return;
 	if (type != pci_bar_unknown) {
 		if (!(res->flags & IORESOURCE_ROM_ENABLE))
 			return;
@@ -257,7 +269,7 @@ int pci_reassign_resource(struct pci_dev *dev, int resno, resource_size_t addsiz
 	if (!ret) {
 		res->flags &= ~IORESOURCE_STARTALIGN;
 		dev_info(&dev->dev, "BAR %d: reassigned %pR\n", resno, res);
-		if (resno < PCI_BRIDGE_RESOURCES)
+		if (!resno_is_for_bridge(resno))
 			pci_update_resource(dev, resno);
 	}
 	return ret;
@@ -292,7 +304,7 @@ int pci_assign_resource(struct pci_dev *dev, int resno)
 	if (!ret) {
 		res->flags &= ~IORESOURCE_STARTALIGN;
 		dev_info(&dev->dev, "BAR %d: assigned %pR\n", resno, res);
-		if (resno < PCI_BRIDGE_RESOURCES)
+		if (!resno_is_for_bridge(resno))
 			pci_update_resource(dev, resno);
 	}
 	return ret;
-- 
1.7.7

