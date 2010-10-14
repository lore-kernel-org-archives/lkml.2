Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364Ab0JNCOy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 22:14:54 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36811 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754195Ab0JNCOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 22:14:23 -0400
From: Fernando Guzman Lugo <x0095840@ti.com>
To: <Hiroshi.DOYU@nokia.com>
Cc: <felipe.contreras@nokia.com>, <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>, <andy.shevchenko@gmail.com>,
        <linux-omap@vger.kernel.org>, Fernando Guzman Lugo <x0095840@ti.com>
Subject: [PATCH 4/4] iommu: create new api to set valid da range
Date: Wed, 13 Oct 2010 21:27:37 -0500
Message-Id: <1287023257-30951-5-git-send-email-x0095840@ti.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1287023257-30951-4-git-send-email-x0095840@ti.com>
References: <1287023257-30951-1-git-send-email-x0095840@ti.com>
 <1287023257-30951-2-git-send-email-x0095840@ti.com>
 <1287023257-30951-3-git-send-email-x0095840@ti.com>
 <1287023257-30951-4-git-send-email-x0095840@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some IOMMUs cannot use the whole 0x0 - 0xFFFFFFFF rage.
With this new API the valid range can be set.

Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
---
 arch/arm/plat-omap/include/plat/iommu.h |    3 +++
 arch/arm/plat-omap/iommu.c              |   29 +++++++++++++++++++++++++++++
 arch/arm/plat-omap/iovmm.c              |    8 +++-----
 3 files changed, 35 insertions(+), 5 deletions(-)

diff --git a/arch/arm/plat-omap/include/plat/iommu.h b/arch/arm/plat-omap/include/plat/iommu.h
index 33c7d41..aea01b1 100644
--- a/arch/arm/plat-omap/include/plat/iommu.h
+++ b/arch/arm/plat-omap/include/plat/iommu.h
@@ -46,6 +46,8 @@ struct iommu {
 
 	struct list_head	mmap;
 	struct mutex		mmap_lock; /* protect mmap */
+	u32		da_start;
+	u32		da_end;
 
 	int (*isr)(struct iommu *obj);
 
@@ -152,6 +154,7 @@ extern void flush_iotlb_all(struct iommu *obj);
 extern int iopgtable_store_entry(struct iommu *obj, struct iotlb_entry *e);
 extern size_t iopgtable_clear_entry(struct iommu *obj, u32 iova);
 
+extern int iommu_set_da_range(struct iommu *obj, u32 start, u32 end);
 extern struct iommu *iommu_get(const char *name);
 extern void iommu_put(struct iommu *obj);
 
diff --git a/arch/arm/plat-omap/iommu.c b/arch/arm/plat-omap/iommu.c
index 6cd151b..e70e76b 100644
--- a/arch/arm/plat-omap/iommu.c
+++ b/arch/arm/plat-omap/iommu.c
@@ -25,6 +25,12 @@
 
 #include "iopgtable.h"
 
+/* Reserve the first page for NULL */
+#define IOMMU_DEFAULT_DA_START	PAGE_SIZE
+/* 0xFFFFFFFF not allowed because it is not page aligned */
+#define IOMMU_DEFAULT_DA_END	0xFFFFF000;
+
+
 #define for_each_iotlb_cr(obj, n, __i, cr)				\
 	for (__i = 0;							\
 	     (__i < (n)) && (cr = __iotlb_read_cr((obj), __i), true);	\
@@ -830,6 +836,27 @@ static int device_match_by_alias(struct device *dev, void *data)
 }
 
 /**
+ * iommu_set_da_range - Set a valid device address range
+ * @obj:		target iommu
+ * @start		Start of valid range
+ * @end			End of valid range
+ **/
+int iommu_set_da_range(struct iommu *obj, u32 start, u32 end)
+{
+	if (!obj)
+		return -EFAULT;
+
+	if (end < start || !PAGE_ALIGN(start | end))
+		return -EINVAL;
+
+	obj->da_start = start;
+	obj->da_end = end;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(iommu_set_da_range);
+
+/**
  * iommu_get - Get iommu handler
  * @name:	target iommu name
  **/
@@ -853,6 +880,8 @@ struct iommu *iommu_get(const char *name)
 		if (err)
 			goto err_enable;
 		flush_iotlb_all(obj);
+		obj->da_start = IOMMU_DEFAULT_DA_START;
+		obj->da_end = IOMMU_DEFAULT_DA_END;
 	}
 
 	if (!try_module_get(obj->owner))
diff --git a/arch/arm/plat-omap/iovmm.c b/arch/arm/plat-omap/iovmm.c
index 5489ca9..bb45780 100644
--- a/arch/arm/plat-omap/iovmm.c
+++ b/arch/arm/plat-omap/iovmm.c
@@ -280,10 +280,8 @@ static struct iovm_struct *alloc_iovm_area(struct iommu *obj, u32 da,
 	alignement = PAGE_SIZE;
 
 	if (flags & IOVMF_DA_ANON) {
-		/*
-		 * Reserve the first page for NULL
-		 */
-		start = PAGE_SIZE;
+		start = obj->da_start;
+
 		if (flags & IOVMF_LINEAR)
 			alignement = iopgsz_max(bytes);
 		start = roundup(start, alignement);
@@ -308,7 +306,7 @@ static struct iovm_struct *alloc_iovm_area(struct iommu *obj, u32 da,
 		prev_end = tmp->da_end;
 	}
 
-	if ((start >= prev_end) && (ULONG_MAX - start + 1 >= bytes))
+	if ((start >= prev_end) && (obj->da_end - start >= bytes))
 		goto found;
 
 	dev_dbg(obj->dev, "%s: no space to fit %08x(%x) flags: %08x\n",
-- 
1.6.3.3

