Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671Ab0FAK0I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 06:26:08 -0400
Received: from smtp.nokia.com ([192.100.105.134]:59900 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275Ab0FAK0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 06:26:06 -0400
From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: catalin.marinas@arm.com, ext-phil.2.carmody@nokia.com,
       linux-omap@vger.kernel.org, Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Subject: [PATCH v2 3/3] omap iommu: kmemleak: Fix false positive with special scan
Date: Tue,  1 Jun 2010 13:25:11 +0300
Message-Id: <1275387911-13030-4-git-send-email-Hiroshi.DOYU@nokia.com>
X-Mailer: git-send-email 1.7.1.rc1
In-Reply-To: <1273821401-26578-2-git-send-email-Hiroshi.DOYU@nokia.com>
References: <1273821401-26578-2-git-send-email-Hiroshi.DOYU@nokia.com>
X-OriginalArrivalTime: 01 Jun 2010 10:25:29.0598 (UTC) FILETIME=[C23071E0:01CB0174]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>

The fist level iommu page table address is registered with the address
conversion function for kmemleak special scan.

Signed-off-by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
---
 arch/arm/plat-omap/iommu.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/arch/arm/plat-omap/iommu.c b/arch/arm/plat-omap/iommu.c
index a202a2c..5a19e86 100644
--- a/arch/arm/plat-omap/iommu.c
+++ b/arch/arm/plat-omap/iommu.c
@@ -894,6 +894,19 @@ void iommu_put(struct iommu *obj)
 }
 EXPORT_SYMBOL_GPL(iommu_put);
 
+static unsigned long kmemleak_special_conv(void *data, unsigned long orig)
+{
+	u32 *iopgd;
+	struct iommu *obj = (struct iommu *)data;
+
+	iopgd = iopgd_offset(obj, orig);
+
+	if (!iopgd_is_table(*iopgd))
+		return 0;
+
+	return (u32)iopgd_page_vaddr(iopgd);
+}
+
 /*
  *	OMAP Device MMU(IOMMU) detection
  */
@@ -967,6 +980,11 @@ static int __devinit omap_iommu_probe(struct platform_device *pdev)
 
 	BUG_ON(!IS_ALIGNED((unsigned long)obj->iopgd, IOPGD_TABLE_SIZE));
 
+	err = kmemleak_special_scan(p, IOPGD_TABLE_SIZE, kmemleak_special_conv,
+				    obj, THIS_MODULE);
+	if (err)
+		dev_warn(&pdev->dev, "kmemleak: failed to add special scan\n");
+
 	dev_info(&pdev->dev, "%s registered\n", obj->name);
 	return 0;
 
@@ -991,6 +1009,7 @@ static int __devexit omap_iommu_remove(struct platform_device *pdev)
 	platform_set_drvdata(pdev, NULL);
 
 	iopgtable_clear_entry_all(obj);
+	kmemleak_no_special(obj->iopgd);
 	free_pages((unsigned long)obj->iopgd, get_order(IOPGD_TABLE_SIZE));
 
 	irq = platform_get_irq(pdev, 0);
-- 
1.7.1.rc1

