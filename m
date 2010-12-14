Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265Ab0LNNGw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 08:06:52 -0500
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:48973 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932101Ab0LNNGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 08:06:50 -0500
From: Fernando Guzman Lugo <fernando.lugo@ti.com>
To: <Hiroshi.DOYU@nokia.com>, <linux@arm.linux.org.uk>, <h-kanigeri2@ti.com>
Cc: <felipe.contreras@nokia.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <tony@atomide.com>, "Guzman Lugo, Fernando" <x0095840@ti.com>
Subject: [PATCHv6 4/4] omap: iommu - create new api to set valid da range
Date: Tue, 14 Dec 2010 07:07:27 -0600
Message-Id: <1292332047-8206-5-git-send-email-fernando.lugo@ti.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1292332047-8206-1-git-send-email-fernando.lugo@ti.com>
References: <1292332047-8206-1-git-send-email-fernando.lugo@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guzman Lugo, Fernando <x0095840@ti.com>

Some IOMMUs cannot use the whole 0x0 - 0xFFFFFFFF rage.
With this new API the valid range can be set.

Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
Acked-by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
---
 arch/arm/plat-omap/include/plat/iommu.h |    3 ++
 arch/arm/plat-omap/iommu.c              |   33 +++++++++++++++++++++++++++++++
 arch/arm/plat-omap/iovmm.c              |   18 ++++++++++------
 3 files changed, 47 insertions(+), 7 deletions(-)

diff --git a/arch/arm/plat-omap/include/plat/iommu.h b/arch/arm/plat-omap/include/plat/iommu.h
index 33c7d41..2ea8ea3 100644
--- a/arch/arm/plat-omap/include/plat/iommu.h
+++ b/arch/arm/plat-omap/include/plat/iommu.h
@@ -103,6 +103,8 @@ struct iommu_platform_data {
 	const char *name;
 	const char *clk_name;
 	const int nr_tlb_entries;
+	u32 da_start;
+	u32 da_end;
 };
 
 #if defined(CONFIG_ARCH_OMAP1)
@@ -152,6 +154,7 @@ extern void flush_iotlb_all(struct iommu *obj);
 extern int iopgtable_store_entry(struct iommu *obj, struct iotlb_entry *e);
 extern size_t iopgtable_clear_entry(struct iommu *obj, u32 iova);
 
+extern int iommu_set_da_range(struct iommu *obj, u32 start, u32 end);
 extern struct iommu *iommu_get(const char *name);
 extern void iommu_put(struct iommu *obj);
 
diff --git a/arch/arm/plat-omap/iommu.c b/arch/arm/plat-omap/iommu.c
index 6cd151b..b3846bd 100644
--- a/arch/arm/plat-omap/iommu.c
+++ b/arch/arm/plat-omap/iommu.c
@@ -25,6 +25,12 @@
 
 #include "iopgtable.h"
 
+/* Reserve the first page for NULL */
+#define IOMMU_DEFAULT_DA_START	PAGE_SIZE
+/* 0xFFFFFFFF not allowed because it is not page aligned */
+#define IOMMU_DEFAULT_DA_END	0xFFFFF000
+
+
 #define for_each_iotlb_cr(obj, n, __i, cr)				\
 	for (__i = 0;							\
 	     (__i < (n)) && (cr = __iotlb_read_cr((obj), __i), true);	\
@@ -830,6 +836,31 @@ static int device_match_by_alias(struct device *dev, void *data)
 }
 
 /**
+ * iommu_set_da_range - Set a valid device address range
+ * @obj:		target iommu
+ * @start		Start of valid range
+ * @end			End of valid range
+ **/
+int iommu_set_da_range(struct iommu *obj, u32 start, u32 end)
+{
+	struct iommu_platform_data *pdata;
+
+	if (!obj)
+		return -EFAULT;
+
+	if (end < start || !PAGE_ALIGN(start | end))
+		return -EINVAL;
+
+	pdata = obj->dev->platform_data;
+
+	pdata->da_start = start;
+	pdata->da_end = end;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(iommu_set_da_range);
+
+/**
  * iommu_get - Get iommu handler
  * @name:	target iommu name
  **/
@@ -853,6 +884,8 @@ struct iommu *iommu_get(const char *name)
 		if (err)
 			goto err_enable;
 		flush_iotlb_all(obj);
+		iommu_set_da_range(obj, IOMMU_DEFAULT_DA_START,
+					IOMMU_DEFAULT_DA_END);
 	}
 
 	if (!try_module_get(obj->owner))
diff --git a/arch/arm/plat-omap/iovmm.c b/arch/arm/plat-omap/iovmm.c
index fa6e643..ee3ca20 100644
--- a/arch/arm/plat-omap/iovmm.c
+++ b/arch/arm/plat-omap/iovmm.c
@@ -272,21 +272,25 @@ static struct iovm_struct *alloc_iovm_area(struct iommu *obj, u32 da,
 {
 	struct iovm_struct *new, *tmp;
 	u32 start, prev_end, alignement;
+	struct iommu_platform_data *pdata;
 
 	if (!obj || !bytes)
 		return ERR_PTR(-EINVAL);
 
+	pdata = obj->dev->platform_data;
+
 	start = da;
 	alignement = PAGE_SIZE;
 
 	if (flags & IOVMF_DA_ANON) {
-		/*
-		 * Reserve the first page for NULL
-		 */
-		start = PAGE_SIZE;
+		start = pdata->da_start;
+
 		if (flags & IOVMF_LINEAR)
 			alignement = iopgsz_max(bytes);
 		start = roundup(start, alignement);
+	} else if (start < pdata->da_start || start > pdata->da_end ||
+					pdata->da_end - start < bytes) {
+		return ERR_PTR(-EINVAL);
 	}
 
 	tmp = NULL;
@@ -299,16 +303,16 @@ static struct iovm_struct *alloc_iovm_area(struct iommu *obj, u32 da,
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
+	if ((start >= prev_end) && (pdata->da_end - start >= bytes))
 		goto found;
 
 	dev_dbg(obj->dev, "%s: no space to fit %08x(%x) flags: %08x\n",
-- 
1.7.3.2

