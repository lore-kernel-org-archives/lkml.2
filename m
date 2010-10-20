Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab0JTCfg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 22:35:36 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:49588 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689Ab0JTCff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 22:35:35 -0400
From: Fernando Guzman Lugo <x0095840@ti.com>
To: <Hiroshi.DOYU@nokia.com>
Cc: <felipe.contreras@nokia.com>, <david.cohen@nokia.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Fernando Guzman Lugo <x0095840@ti.com>
Subject: [PATCHv4 4/4] iommu: create new api to set valid da range
Date: Tue, 19 Oct 2010 21:48:52 -0500
Message-Id: <1287542932-14206-5-git-send-email-x0095840@ti.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1287542932-14206-4-git-send-email-x0095840@ti.com>
References: <1287542932-14206-1-git-send-email-x0095840@ti.com>
 <1287542932-14206-2-git-send-email-x0095840@ti.com>
 <1287542932-14206-3-git-send-email-x0095840@ti.com>
 <1287542932-14206-4-git-send-email-x0095840@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some IOMMUs cannot use the whole 0x0 - 0xFFFFFFFF range.
With this new API the valid range can be set.

Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
---
 arch/arm/plat-omap/include/plat/iommu.h |    3 +++
 arch/arm/plat-omap/iommu.c              |   29 +++++++++++++++++++++++++++++
 arch/arm/plat-omap/iovmm.c              |   15 ++++++++-------
 3 files changed, 40 insertions(+), 7 deletions(-)

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
index 5489ca9..cff382f 100644
--- a/arch/arm/plat-omap/iovmm.c
+++ b/arch/arm/plat-omap/iovmm.c
@@ -280,13 +280,14 @@ static struct iovm_struct *alloc_iovm_area(struct iommu *obj, u32 da,
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
+	} else if (start < obj->da_start || start > obj->da_end ||
+					obj->da_end - start < bytes) {
+		return ERR_PTR(-EINVAL);
 	}
 
 	tmp = NULL;
@@ -299,16 +300,16 @@ static struct iovm_struct *alloc_iovm_area(struct iommu *obj, u32 da,
 		if (prev_end > start)
 			break;
 
-		if (start + bytes <= tmp->da_start)
+		if (tmp->da_start > start && (tmp->da_start - start) >= bytes)
 			goto found;
 
-		if (flags & IOVMF_DA_ANON)
+		if (tmp->da_end >= start && flags & IOVMF_DA_ANON)
 			start = roundup(tmp->da_end + 1, alignement);
 
 		prev_end = tmp->da_end;
 	}
 
-	if ((start >= prev_end) && (ULONG_MAX - start + 1 >= bytes))
+	if ((start >= prev_end) && (obj->da_end - start >= bytes))
 		goto found;
 
 	dev_dbg(obj->dev, "%s: no space to fit %08x(%x) flags: %08x\n",
-- 
1.6.3.3

