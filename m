Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab1IBRek (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 13:34:40 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41213 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810Ab1IBRdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 13:33:06 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <iommu@lists.linux-foundation.org>
Cc: <linux-omap@vger.kernel.org>, Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Joerg Roedel <Joerg.Roedel@amd.com>,
        David Woodhouse <dwmw2@infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH 3/7] iommu/core: use the existing IS_ALIGNED macro
Date: Fri,  2 Sep 2011 20:32:32 +0300
Message-Id: <1314984756-4400-4-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314984756-4400-1-git-send-email-ohad@wizery.com>
References: <1314984756-4400-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace iommu's alignment checks with the existing IS_ALIGNED macro,
to drop a few lines of code and utilize IS_ALIGNED's type safety.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/iommu/iommu.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 6e6b6a1..e61a9ba 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -16,6 +16,7 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
  */
 
+#include <linux/kernel.h>
 #include <linux/bug.h>
 #include <linux/types.h>
 #include <linux/module.h>
@@ -97,13 +98,11 @@ EXPORT_SYMBOL_GPL(iommu_domain_has_cap);
 int iommu_map(struct iommu_domain *domain, unsigned long iova,
 	      phys_addr_t paddr, int gfp_order, int prot)
 {
-	unsigned long invalid_mask;
 	size_t size;
 
 	size         = 0x1000UL << gfp_order;
-	invalid_mask = size - 1;
 
-	BUG_ON((iova | paddr) & invalid_mask);
+	BUG_ON(!IS_ALIGNED(iova | paddr, size));
 
 	return iommu_ops->map(domain, iova, paddr, gfp_order, prot);
 }
@@ -111,13 +110,11 @@ EXPORT_SYMBOL_GPL(iommu_map);
 
 int iommu_unmap(struct iommu_domain *domain, unsigned long iova, int gfp_order)
 {
-	unsigned long invalid_mask;
 	size_t size;
 
 	size         = 0x1000UL << gfp_order;
-	invalid_mask = size - 1;
 
-	BUG_ON(iova & invalid_mask);
+	BUG_ON(!IS_ALIGNED(iova, size));
 
 	return iommu_ops->unmap(domain, iova, gfp_order);
 }
-- 
1.7.4.1

