Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab1IBRdO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 13:33:14 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55839 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884Ab1IBRdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 13:33:10 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <iommu@lists.linux-foundation.org>
Cc: <linux-omap@vger.kernel.org>, Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Joerg Roedel <Joerg.Roedel@amd.com>,
        David Woodhouse <dwmw2@infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH 4/7] iommu/omap: ->unmap() should return order of unmapped page
Date: Fri,  2 Sep 2011 20:32:33 +0300
Message-Id: <1314984756-4400-5-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314984756-4400-1-git-send-email-ohad@wizery.com>
References: <1314984756-4400-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Users of the IOMMU API (kvm specifically) assume that iommu_unmap()
returns the order of the unmapped page.

Fix omap_iommu_unmap() to do so and adopt omap-iovmm accordingly.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/iommu/omap-iommu.c |   13 ++++---------
 drivers/iommu/omap-iovmm.c |    2 +-
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
index 4311bc3..bd5f606 100644
--- a/drivers/iommu/omap-iommu.c
+++ b/drivers/iommu/omap-iommu.c
@@ -1081,18 +1081,13 @@ static int omap_iommu_unmap(struct iommu_domain *domain, unsigned long da,
 	struct omap_iommu_domain *omap_domain = domain->priv;
 	struct omap_iommu *oiommu = omap_domain->iommu_dev;
 	struct device *dev = oiommu->dev;
-	size_t bytes = PAGE_SIZE << order;
-	size_t ret;
+	size_t unmap_size;
 
-	dev_dbg(dev, "unmapping da 0x%lx size 0x%x\n", da, bytes);
+	dev_dbg(dev, "unmapping da 0x%lx order %d\n", da, order);
 
-	ret = iopgtable_clear_entry(oiommu, da);
-	if (ret != bytes) {
-		dev_err(dev, "entry @ 0x%lx was %d; not %d\n", da, ret, bytes);
-		return -EINVAL;
-	}
+	unmap_size = iopgtable_clear_entry(oiommu, da);
 
-	return 0;
+	return unmap_size ? get_order(unmap_size) : -EINVAL;
 }
 
 static int
diff --git a/drivers/iommu/omap-iovmm.c b/drivers/iommu/omap-iovmm.c
index 39bdb92..e8fdb88 100644
--- a/drivers/iommu/omap-iovmm.c
+++ b/drivers/iommu/omap-iovmm.c
@@ -480,7 +480,7 @@ static void unmap_iovm_area(struct iommu_domain *domain, struct omap_iommu *obj,
 		order = get_order(bytes);
 
 		err = iommu_unmap(domain, start, order);
-		if (err)
+		if (err < 0)
 			break;
 
 		dev_dbg(obj->dev, "%s: unmap %08x(%x) %08x\n",
-- 
1.7.4.1

