Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816Ab1I3Hek (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 03:34:40 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:44723 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513Ab1I3Hei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 03:34:38 -0400
X-AuditID: cbfee61a-b7cf1ae00000208e-e3-4e85705f6afd
From: Kukjin Kim <kgene.kim@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: "'Russell King'" <rmk+kernel@arm.linux.org.uk>, joerg.roedel@amd.com,
        "'Ohad Ben-Cohen'" <ohad@wizery.com>,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        younglak1004.kim@samsung.com, "'Kukjin Kim'" <kgene.kim@samsung.com>
Subject: [PATCH v2 4/5] iommu/exynos: Add iommu fault handler
Date: Fri, 30 Sep 2011 16:31:43 +0900
Message-id: <016f01cc7f43$00616120$01242360$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Acx/QwAgP1EnMZBURDa/auGimkqe8w==
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KyongHo Cho <pullip.cho@samsung.com>

This adds IOMMU fault handler that is suggested by Ohad Ben-Cohen.

Users of IOMMU API can register its own fault handler with
iommu_set_fault_handler() and the handler is called by IRQ handler
of System MMU.

If no user installs fault handler, IOMMU driver prints debugging
message and generates kernel oops.

Signed-off-by: KyongHo Cho <pullip.cho@samsung.com>
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
---
 drivers/iommu/exynos_iommu.c |   21 +++++++++++++--------
 1 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/iommu/exynos_iommu.c b/drivers/iommu/exynos_iommu.c
index 33fa4a8..d355a2e 100644
--- a/drivers/iommu/exynos_iommu.c
+++ b/drivers/iommu/exynos_iommu.c
@@ -207,28 +207,33 @@ static int default_fault_handler(enum S5P_SYSMMU_INTERRUPT_TYPE itype,
 static irqreturn_t exynos_sysmmu_irq(int irq, void * dev_id)
 {
 	/* SYSMMU is in blocked when interrupt occurred. */
+	unsigned long addr;
 	struct sysmmu_drvdata *data = dev_id;
 	enum S5P_SYSMMU_INTERRUPT_TYPE itype;
-	bool handled = false;
+	int ret = -ENOSYS;
 
 	WARN_ON(!is_sysmmu_active(data));
 
 	itype = (enum S5P_SYSMMU_INTERRUPT_TYPE)
 		__ffs(__raw_readl(data->sfrbase + S5P_INT_STATUS));
 
-	if (WARN_ON((itype < 0) && (itype >= 8))) {
+	if (WARN_ON((itype < 0) && (itype >= 8)))
 		itype = SYSMMU_FAULT_UNKNOWN;
-	} else if (data->fault_handler) {
+
+	addr = __raw_readl(data->sfrbase + fault_reg_offset[itype]);
+
+	if (data->domain)
+		ret = report_iommu_fault(data->domain, data->owner, addr,
+									itype);
+
+	if ((ret == -ENOSYS) && (data->fault_handler)) {
 		unsigned long base;
-		unsigned long addr;
-		addr = __raw_readl(data->sfrbase + fault_reg_offset[itype]);
 		base = __raw_readl(data->sfrbase + S5P_PT_BASE_ADDR);
 
-		if (!data->fault_handler(itype, base, addr))
-			handled = true;
+		ret = data->fault_handler(itype, base, addr);
 	}
 
-	if (handled)
+	if (ret == 0)
 		__raw_writel(1 << itype, data->sfrbase + S5P_INT_CLEAR);
 	else
 		dev_dbg(data->dev, "%s is not handled.\n",
-- 
1.7.1


