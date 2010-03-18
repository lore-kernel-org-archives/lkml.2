Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab0CRPXU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 11:23:20 -0400
Received: from mail-px0-f198.google.com ([209.85.216.198]:63569 "EHLO
	mail-px0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631Ab0CRPXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 11:23:05 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [V2 PATCH 10/10] arch/sparc: Remove obsolete dev_archdata.prom_node
	and of_devce.node
To: davem@davemloft.net, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, michal.simek@petalogix.com,
       linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
       microblaze-uclinux@itee.uq.edu.au
Date: Thu, 18 Mar 2010 09:23:01 -0600
Message-ID: <20100318152301.21082.93473.stgit@angua>
In-Reply-To: <20100318144836.21082.93040.stgit@angua>
References: <20100318144836.21082.93040.stgit@angua>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both dev_archdata.prom_node and of_device.node are duplications of the
device.of_node value.  This patch removes them.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

 arch/sparc/include/asm/device.h    |   15 ---------------
 arch/sparc/include/asm/of_device.h |    1 -
 arch/sparc/kernel/of_device_32.c   |    2 --
 arch/sparc/kernel/of_device_64.c   |    2 --
 arch/sparc/kernel/pci.c            |    3 +--
 5 files changed, 1 insertions(+), 22 deletions(-)

diff --git a/arch/sparc/include/asm/device.h b/arch/sparc/include/asm/device.h
index f3b85b6..d4c4521 100644
--- a/arch/sparc/include/asm/device.h
+++ b/arch/sparc/include/asm/device.h
@@ -13,25 +13,10 @@ struct dev_archdata {
 	void			*iommu;
 	void			*stc;
 	void			*host_controller;
-
-	struct device_node	*prom_node;
 	struct of_device	*op;
-
 	int			numa_node;
 };
 
-static inline void dev_archdata_set_node(struct dev_archdata *ad,
-					 struct device_node *np)
-{
-	ad->prom_node = np;
-}
-
-static inline struct device_node *
-dev_archdata_get_node(const struct dev_archdata *ad)
-{
-	return ad->prom_node;
-}
-
 struct pdev_archdata {
 };
 
diff --git a/arch/sparc/include/asm/of_device.h b/arch/sparc/include/asm/of_device.h
index a5d9811..f320246 100644
--- a/arch/sparc/include/asm/of_device.h
+++ b/arch/sparc/include/asm/of_device.h
@@ -14,7 +14,6 @@
  */
 struct of_device
 {
-	struct device_node		*node;
 	struct device			dev;
 	struct resource			resource[PROMREG_MAX];
 	unsigned int			irqs[PROMINTR_MAX];
diff --git a/arch/sparc/kernel/of_device_32.c b/arch/sparc/kernel/of_device_32.c
index 7073117..47e63f1 100644
--- a/arch/sparc/kernel/of_device_32.c
+++ b/arch/sparc/kernel/of_device_32.c
@@ -345,11 +345,9 @@ static struct of_device * __init scan_one_device(struct device_node *dp,
 		return NULL;
 
 	sd = &op->dev.archdata;
-	sd->prom_node = dp;
 	sd->op = op;
 
 	op->dev.of_node = dp;
-	op->node = dp;
 
 	op->clock_freq = of_getintprop_default(dp, "clock-frequency",
 					       (25*1000*1000));
diff --git a/arch/sparc/kernel/of_device_64.c b/arch/sparc/kernel/of_device_64.c
index c8e352e..1dae807 100644
--- a/arch/sparc/kernel/of_device_64.c
+++ b/arch/sparc/kernel/of_device_64.c
@@ -640,11 +640,9 @@ static struct of_device * __init scan_one_device(struct device_node *dp,
 		return NULL;
 
 	sd = &op->dev.archdata;
-	sd->prom_node = dp;
 	sd->op = op;
 
 	op->dev.of_node = dp;
-	op->node = dp;
 
 	op->clock_freq = of_getintprop_default(dp, "clock-frequency",
 					       (25*1000*1000));
diff --git a/arch/sparc/kernel/pci.c b/arch/sparc/kernel/pci.c
index c7a214e..8a8363a 100644
--- a/arch/sparc/kernel/pci.c
+++ b/arch/sparc/kernel/pci.c
@@ -261,8 +261,6 @@ static struct pci_dev *of_create_pci_dev(struct pci_pbm_info *pbm,
 	sd->iommu = pbm->iommu;
 	sd->stc = &pbm->stc;
 	sd->host_controller = pbm;
-	sd->prom_node = node;
-	dev->dev.of_node = node;
 	sd->op = op = of_find_device_by_node(node);
 	sd->numa_node = pbm->numa_node;
 
@@ -286,6 +284,7 @@ static struct pci_dev *of_create_pci_dev(struct pci_pbm_info *pbm,
 	dev->sysdata = node;
 	dev->dev.parent = bus->bridge;
 	dev->dev.bus = &pci_bus_type;
+	dev->dev.of_node = node;
 	dev->devfn = devfn;
 	dev->multifunction = 0;		/* maybe a lie? */
 	set_pcie_port_type(dev);

