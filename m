Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318Ab1EKWZP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 18:25:15 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:60168 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932245Ab1EKWZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 18:25:10 -0400
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: Milton Miller <miltonm@bga.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Will Schmidt <will_schmidt@vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 3/8] pseries/iommu: find windows after kexec during boot
Date: Wed, 11 May 2011 15:24:59 -0700
Message-Id: <1305152704-4864-4-git-send-email-nacc@us.ibm.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1305152704-4864-1-git-send-email-nacc@us.ibm.com>
References: <1305152704-4864-1-git-send-email-nacc@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Milton Miller <miltonm@bga.com>

Move the discovery of windows previously setup from when the pci driver
calls set_dma_mask to an arch_initcall.

When kexecing into a kernel with dynamic dma windows allocated, we need
to find the windows early so that memory hot remove will be able to
delete the tces mapping the to be removed memory and memory hotplug add
will map the new memory into the window.  We should not wait for the
driver to be loaded and the device to be probed.  The iommu init hooks
are before kmalloc is setup, so defer to arch_initcall.

Signed-off-by: Milton Miller <miltonm@bga.com>
Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
---
 arch/powerpc/platforms/pseries/iommu.c |   52 ++++++++++++++-----------------
 1 files changed, 24 insertions(+), 28 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
index a0421ac..a48f126 100644
--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -695,9 +695,9 @@ static void remove_ddw(struct device_node *np)
 			np->full_name, ret, ddr_avail[2], liobn);
 
 delprop:
-	ret = of_remove_property(np, win64);
+	ret = prom_remove_property(np, win64);
 	if (ret)
-		pr_warning("%s: failed to remove direct window property: %d\n"
+		pr_warning("%s: failed to remove direct window property: %d\n",
 			np->full_name, ret);
 }
 
@@ -725,38 +725,38 @@ static u64 dupe_ddw_if_already_created(struct pci_dev *dev, struct device_node *
 	return dma_addr;
 }
 
-static u64 dupe_ddw_if_kexec(struct pci_dev *dev, struct device_node *pdn)
+static int find_existing_ddw_windows(void)
 {
-	struct device_node *dn;
-	struct pci_dn *pcidn;
 	int len;
+	struct device_node *pdn;
 	struct direct_window *window;
 	const struct dynamic_dma_window_prop *direct64;
-	u64 dma_addr = 0;
 
-	dn = pci_device_to_OF_node(dev);
-	pcidn = PCI_DN(dn);
-	direct64 = of_get_property(pdn, DIRECT64_PROPNAME, &len);
-	if (direct64) {
-		if (len < sizeof(struct dynamic_dma_window_prop)) {
+	if (!firmware_has_feature(FW_FEATURE_LPAR))
+		return 0;
+
+	for_each_node_with_property(pdn, DIRECT64_PROPNAME) {
+		direct64 = of_get_property(pdn, DIRECT64_PROPNAME, &len);
+		if (!direct64)
+			continue;
+
+		window = kzalloc(sizeof(*window), GFP_KERNEL);
+		if (!window || len < sizeof(struct dynamic_dma_window_prop)) {
+			kfree(window);
 			remove_ddw(pdn);
-		} else {
-			window = kzalloc(sizeof(*window), GFP_KERNEL);
-			if (!window) {
-				remove_ddw(pdn);
-			} else {
-				window->device = pdn;
-				window->prop = direct64;
-				spin_lock(&direct_window_list_lock);
-				list_add(&window->list, &direct_window_list);
-				spin_unlock(&direct_window_list_lock);
-				dma_addr = direct64->dma_base;
-			}
+			continue;
 		}
+
+		window->device = pdn;
+		window->prop = direct64;
+		spin_lock(&direct_window_list_lock);
+		list_add(&window->list, &direct_window_list);
+		spin_unlock(&direct_window_list_lock);
 	}
 
-	return dma_addr;
+	return 0;
 }
+machine_arch_initcall(pseries, find_existing_ddw_windows);
 
 static int query_ddw(struct pci_dev *dev, const u32 *ddr_avail,
 			struct ddw_query_response *query)
@@ -854,10 +854,6 @@ static u64 enable_ddw(struct pci_dev *dev, struct device_node *pdn)
 	if (dma_addr != 0)
 		goto out_unlock;
 
-	dma_addr = dupe_ddw_if_kexec(dev, pdn);
-	if (dma_addr != 0)
-		goto out_unlock;
-
 	/*
 	 * the ibm,ddw-applicable property holds the tokens for:
 	 * ibm,query-pe-dma-window
-- 
1.7.4.1

