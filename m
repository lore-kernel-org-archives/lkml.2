Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837Ab1IPRxu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 13:53:50 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40260 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755571Ab1IPRxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 13:53:48 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <iommu@lists.linux-foundation.org>
Cc: <linux-omap@vger.kernel.org>, Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Joerg Roedel <Joerg.Roedel@amd.com>,
        David Woodhouse <dwmw2@infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, Ohad Ben-Cohen <ohad@wizery.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [PATCH v3 6/6] iommu/core: remove the temporary register_iommu_pgsize API
Date: Fri, 16 Sep 2011 20:51:46 +0300
Message-Id: <1316195506-9777-7-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316195506-9777-1-git-send-email-ohad@wizery.com>
References: <1316195506-9777-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that all IOMMU drivers are converted to the new
register_iommu_pgsize() API, the old code can be removed, and
we can s/register_iommu_pgsize/register_iommu/.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Joerg Roedel <Joerg.Roedel@amd.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: David Brown <davidb@codeaurora.org>
Cc: Stepan Moskovchenko <stepanm@codeaurora.org>
---
 drivers/iommu/amd_iommu.c   |    3 +--
 drivers/iommu/intel-iommu.c |    3 +--
 drivers/iommu/iommu.c       |   34 +---------------------------------
 drivers/iommu/msm_iommu.c   |    2 +-
 drivers/iommu/omap-iommu.c  |    2 +-
 include/linux/iommu.h       |    5 ++---
 6 files changed, 7 insertions(+), 42 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 80191d2..cf29645 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -2511,8 +2511,7 @@ static unsigned long amd_iommu_pgsizes = ~0xFFFUL;
 
 void __init amd_iommu_init_api(void)
 {
-	register_iommu_pgsize(&amd_iommu_ops, &amd_iommu_pgsizes,
-						BITS_PER_LONG);
+	register_iommu(&amd_iommu_ops, &amd_iommu_pgsizes, BITS_PER_LONG);
 }
 
 int __init amd_iommu_init_dma_ops(void)
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 46c21a2..c013b85 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -3504,8 +3504,7 @@ int __init intel_iommu_init(void)
 
 	init_iommu_pm_ops();
 
-	register_iommu_pgsize(&intel_iommu_ops, &intel_iommu_pgsizes,
-							BITS_PER_LONG);
+	register_iommu(&intel_iommu_ops, &intel_iommu_pgsizes, BITS_PER_LONG);
 
 	bus_register_notifier(&pci_bus_type, &device_nb);
 
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 7c01c8c..8bbd1aa 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -46,13 +46,8 @@ static unsigned int iommu_min_page_idx;
  * @ops: iommu handlers
  * @pgsize_bitmap: bitmap of page sizes supported by the hardware
  * @nr_page_bits: size of @pgsize_bitmap (in bits)
- *
- * Note: this is a temporary function, which will be removed once
- * all IOMMU drivers are converted. The only reason it exists is to
- * allow splitting the pgsizes changes to several patches in order to ease
- * the review.
  */
-void register_iommu_pgsize(struct iommu_ops *ops, unsigned long *pgsize_bitmap,
+void register_iommu(struct iommu_ops *ops, unsigned long *pgsize_bitmap,
 					unsigned int nr_page_bits)
 {
 	if (iommu_ops || iommu_pgsize_bitmap || !nr_page_bits)
@@ -67,33 +62,6 @@ void register_iommu_pgsize(struct iommu_ops *ops, unsigned long *pgsize_bitmap,
 	iommu_min_pagesz = 1 << iommu_min_page_idx;
 }
 
-/*
- * default pagesize bitmap, will be removed once all IOMMU drivers
- * are converted
- */
-static unsigned long default_iommu_pgsizes = ~0xFFFUL;
-
-void register_iommu(struct iommu_ops *ops)
-{
-	if (iommu_ops)
-		BUG();
-
-	iommu_ops = ops;
-
-	/*
-	 * set default pgsize values, which retain the existing
-	 * IOMMU API behavior: drivers will be called to map
-	 * regions that are sized/aligned to order of 4KiB pages
-	 */
-	iommu_pgsize_bitmap = &default_iommu_pgsizes;
-	iommu_nr_page_bits = BITS_PER_LONG;
-
-	/* find the minimum page size and its index only once */
-	iommu_min_page_idx = find_first_bit(iommu_pgsize_bitmap,
-						iommu_nr_page_bits);
-	iommu_min_pagesz = 1 << iommu_min_page_idx;
-}
-
 bool iommu_found(void)
 {
 	return iommu_ops != NULL;
diff --git a/drivers/iommu/msm_iommu.c b/drivers/iommu/msm_iommu.c
index a4ed116..e59ced9 100644
--- a/drivers/iommu/msm_iommu.c
+++ b/drivers/iommu/msm_iommu.c
@@ -733,7 +733,7 @@ static int __init msm_iommu_init(void)
 	setup_iommu_tex_classes();
 
 	/* we're only using the first 25 bits of the pgsizes bitmap */
-	register_iommu_pgsize(&msm_iommu_ops, &msm_iommu_pgsizes, 25);
+	register_iommu(&msm_iommu_ops, &msm_iommu_pgsizes, 25);
 
 	return 0;
 }
diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
index 403dd6a..3d8ad87 100644
--- a/drivers/iommu/omap-iommu.c
+++ b/drivers/iommu/omap-iommu.c
@@ -1229,7 +1229,7 @@ static int __init omap_iommu_init(void)
 	iopte_cachep = p;
 
 	/* we're only using the first 25 bits of the pgsizes bitmap */
-	register_iommu_pgsize(&omap_iommu_ops, &omap_iommu_pgsizes, 25);
+	register_iommu(&omap_iommu_ops, &omap_iommu_pgsizes, 25);
 
 	return platform_driver_register(&omap_iommu_driver);
 }
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 1806956..297893f 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -60,9 +60,8 @@ struct iommu_ops {
 
 #ifdef CONFIG_IOMMU_API
 
-extern void register_iommu(struct iommu_ops *ops);
-extern void register_iommu_pgsize(struct iommu_ops *ops,
-		unsigned long *pgsize_bitmap, unsigned int nr_page_bits);
+extern void register_iommu(struct iommu_ops *ops, unsigned long *pgsize_bitmap,
+					unsigned int nr_page_bits);
 extern bool iommu_found(void);
 extern struct iommu_domain *iommu_domain_alloc(void);
 extern void iommu_domain_free(struct iommu_domain *domain);
-- 
1.7.4.1

