Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757853Ab2KBTYU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 15:24:20 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:25411 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756980Ab2KBTYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 15:24:08 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/GcamwmmtRwwK8393xXwkS
Subject: [PATCH 3/6] ARM: OMAP2+: Move plat/iovmm.h to
 include/linux/omap-iommu.h
To: linux-kernel@vger.kernel.org
From: Tony Lindgren <tony@atomide.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Omar Ramirez Luna <omar.luna@linaro.org>, linux-omap@vger.kernel.org,
        Ido Yariv <ido@wizery.com>, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org
Date: Fri, 02 Nov 2012 12:24:03 -0700
Message-ID: <20121102192403.4253.24855.stgit@muffinssi.local>
In-Reply-To: <20121102192221.4253.34303.stgit@muffinssi.local>
References: <20121102192221.4253.34303.stgit@muffinssi.local>
User-Agent: StGit/0.16-2-g0d85
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like the iommu framework does not have generic functions
exported for all the needs yet. The hardware specific functions
are defined in files like intel-iommu.h and amd-iommu.h. Follow
the same standard for omap-iommu.h.

This is needed because we are removing plat and mach includes
for ARM common zImage support. Further work should continue
in the iommu framework context as only pure platform data will
be communicated from arch/arm/*omap*/* code to the iommu
framework.

Cc: Joerg Roedel <joro@8bytes.org>
Cc: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Ido Yariv <ido@wizery.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Omar Ramirez Luna <omar.luna@linaro.org>
Cc: linux-media@vger.kernel.org
Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/iommu2.c               |    1 
 arch/arm/plat-omap/include/plat/iommu.h    |   10 +--
 arch/arm/plat-omap/include/plat/iovmm.h    |   89 ----------------------------
 drivers/iommu/omap-iommu-debug.c           |    2 -
 drivers/iommu/omap-iommu.c                 |    1 
 drivers/iommu/omap-iovmm.c                 |   46 ++++++++++++++
 drivers/media/platform/omap3isp/isp.c      |    1 
 drivers/media/platform/omap3isp/isp.h      |    4 -
 drivers/media/platform/omap3isp/ispccdc.c  |    1 
 drivers/media/platform/omap3isp/ispstat.c  |    1 
 drivers/media/platform/omap3isp/ispvideo.c |    2 -
 include/linux/omap-iommu.h                 |   52 ++++++++++++++++
 12 files changed, 107 insertions(+), 103 deletions(-)
 delete mode 100644 arch/arm/plat-omap/include/plat/iovmm.h
 create mode 100644 include/linux/omap-iommu.h

diff --git a/arch/arm/mach-omap2/iommu2.c b/arch/arm/mach-omap2/iommu2.c
index eefc379..e8116cf 100644
--- a/arch/arm/mach-omap2/iommu2.c
+++ b/arch/arm/mach-omap2/iommu2.c
@@ -15,6 +15,7 @@
 #include <linux/device.h>
 #include <linux/jiffies.h>
 #include <linux/module.h>
+#include <linux/omap-iommu.h>
 #include <linux/slab.h>
 #include <linux/stringify.h>
 
diff --git a/arch/arm/plat-omap/include/plat/iommu.h b/arch/arm/plat-omap/include/plat/iommu.h
index 7e8c7b6..a4b71b1 100644
--- a/arch/arm/plat-omap/include/plat/iommu.h
+++ b/arch/arm/plat-omap/include/plat/iommu.h
@@ -216,13 +216,10 @@ static inline struct omap_iommu *dev_to_omap_iommu(struct device *dev)
 #define MMU_RAM_PADDR_SHIFT	12
 #define MMU_RAM_PADDR_MASK \
 	((~0UL >> MMU_RAM_PADDR_SHIFT) << MMU_RAM_PADDR_SHIFT)
-#define MMU_RAM_ENDIAN_SHIFT	9
+
 #define MMU_RAM_ENDIAN_MASK	(1 << MMU_RAM_ENDIAN_SHIFT)
-#define MMU_RAM_ENDIAN_BIG	(1 << MMU_RAM_ENDIAN_SHIFT)
-#define MMU_RAM_ENDIAN_LITTLE	(0 << MMU_RAM_ENDIAN_SHIFT)
-#define MMU_RAM_ELSZ_SHIFT	7
 #define MMU_RAM_ELSZ_MASK	(3 << MMU_RAM_ELSZ_SHIFT)
-#define MMU_RAM_ELSZ_8		(0 << MMU_RAM_ELSZ_SHIFT)
+
 #define MMU_RAM_ELSZ_16		(1 << MMU_RAM_ELSZ_SHIFT)
 #define MMU_RAM_ELSZ_32		(2 << MMU_RAM_ELSZ_SHIFT)
 #define MMU_RAM_ELSZ_NONE	(3 << MMU_RAM_ELSZ_SHIFT)
@@ -269,9 +266,6 @@ extern int omap_iommu_set_isr(const char *name,
 				    void *priv),
 			 void *isr_priv);
 
-extern void omap_iommu_save_ctx(struct device *dev);
-extern void omap_iommu_restore_ctx(struct device *dev);
-
 extern int omap_install_iommu_arch(const struct iommu_functions *ops);
 extern void omap_uninstall_iommu_arch(const struct iommu_functions *ops);
 
diff --git a/arch/arm/plat-omap/include/plat/iovmm.h b/arch/arm/plat-omap/include/plat/iovmm.h
deleted file mode 100644
index 498e57c..0000000
--- a/arch/arm/plat-omap/include/plat/iovmm.h
+++ /dev/null
@@ -1,89 +0,0 @@
-/*
- * omap iommu: simple virtual address space management
- *
- * Copyright (C) 2008-2009 Nokia Corporation
- *
- * Written by Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef __IOMMU_MMAP_H
-#define __IOMMU_MMAP_H
-
-#include <linux/iommu.h>
-
-struct iovm_struct {
-	struct omap_iommu	*iommu;	/* iommu object which this belongs to */
-	u32			da_start; /* area definition */
-	u32			da_end;
-	u32			flags; /* IOVMF_: see below */
-	struct list_head	list; /* linked in ascending order */
-	const struct sg_table	*sgt; /* keep 'page' <-> 'da' mapping */
-	void			*va; /* mpu side mapped address */
-};
-
-/*
- * IOVMF_FLAGS: attribute for iommu virtual memory area(iovma)
- *
- * lower 16 bit is used for h/w and upper 16 bit is for s/w.
- */
-#define IOVMF_SW_SHIFT		16
-
-/*
- * iovma: h/w flags derived from cam and ram attribute
- */
-#define IOVMF_CAM_MASK		(~((1 << 10) - 1))
-#define IOVMF_RAM_MASK		(~IOVMF_CAM_MASK)
-
-#define IOVMF_PGSZ_MASK		(3 << 0)
-#define IOVMF_PGSZ_1M		MMU_CAM_PGSZ_1M
-#define IOVMF_PGSZ_64K		MMU_CAM_PGSZ_64K
-#define IOVMF_PGSZ_4K		MMU_CAM_PGSZ_4K
-#define IOVMF_PGSZ_16M		MMU_CAM_PGSZ_16M
-
-#define IOVMF_ENDIAN_MASK	(1 << 9)
-#define IOVMF_ENDIAN_BIG	MMU_RAM_ENDIAN_BIG
-#define IOVMF_ENDIAN_LITTLE	MMU_RAM_ENDIAN_LITTLE
-
-#define IOVMF_ELSZ_MASK		(3 << 7)
-#define IOVMF_ELSZ_8		MMU_RAM_ELSZ_8
-#define IOVMF_ELSZ_16		MMU_RAM_ELSZ_16
-#define IOVMF_ELSZ_32		MMU_RAM_ELSZ_32
-#define IOVMF_ELSZ_NONE		MMU_RAM_ELSZ_NONE
-
-#define IOVMF_MIXED_MASK	(1 << 6)
-#define IOVMF_MIXED		MMU_RAM_MIXED
-
-/*
- * iovma: s/w flags, used for mapping and umapping internally.
- */
-#define IOVMF_MMIO		(1 << IOVMF_SW_SHIFT)
-#define IOVMF_ALLOC		(2 << IOVMF_SW_SHIFT)
-#define IOVMF_ALLOC_MASK	(3 << IOVMF_SW_SHIFT)
-
-/* "superpages" is supported just with physically linear pages */
-#define IOVMF_DISCONT		(1 << (2 + IOVMF_SW_SHIFT))
-#define IOVMF_LINEAR		(2 << (2 + IOVMF_SW_SHIFT))
-#define IOVMF_LINEAR_MASK	(3 << (2 + IOVMF_SW_SHIFT))
-
-#define IOVMF_DA_FIXED		(1 << (4 + IOVMF_SW_SHIFT))
-
-
-extern struct iovm_struct *omap_find_iovm_area(struct device *dev, u32 da);
-extern u32
-omap_iommu_vmap(struct iommu_domain *domain, struct device *dev, u32 da,
-			const struct sg_table *sgt, u32 flags);
-extern struct sg_table *omap_iommu_vunmap(struct iommu_domain *domain,
-				struct device *dev, u32 da);
-extern u32
-omap_iommu_vmalloc(struct iommu_domain *domain, struct device *dev,
-				u32 da, size_t bytes, u32 flags);
-extern void
-omap_iommu_vfree(struct iommu_domain *domain, struct device *dev,
-				const u32 da);
-extern void *omap_da_to_va(struct device *dev, u32 da);
-
-#endif /* __IOMMU_MMAP_H */
diff --git a/drivers/iommu/omap-iommu-debug.c b/drivers/iommu/omap-iommu-debug.c
index 0cac372..cf4a0b5 100644
--- a/drivers/iommu/omap-iommu-debug.c
+++ b/drivers/iommu/omap-iommu-debug.c
@@ -18,9 +18,9 @@
 #include <linux/uaccess.h>
 #include <linux/platform_device.h>
 #include <linux/debugfs.h>
+#include <linux/omap-iommu.h>
 
 #include <plat/iommu.h>
-#include <plat/iovmm.h>
 
 #include "omap-iopgtable.h"
 
diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
index f2bbfb0..eadcfde 100644
--- a/drivers/iommu/omap-iommu.c
+++ b/drivers/iommu/omap-iommu.c
@@ -19,6 +19,7 @@
 #include <linux/clk.h>
 #include <linux/platform_device.h>
 #include <linux/iommu.h>
+#include <linux/omap-iommu.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
 
diff --git a/drivers/iommu/omap-iovmm.c b/drivers/iommu/omap-iovmm.c
index b332392..9852101 100644
--- a/drivers/iommu/omap-iovmm.c
+++ b/drivers/iommu/omap-iovmm.c
@@ -17,15 +17,59 @@
 #include <linux/device.h>
 #include <linux/scatterlist.h>
 #include <linux/iommu.h>
+#include <linux/omap-iommu.h>
 
 #include <asm/cacheflush.h>
 #include <asm/mach/map.h>
 
 #include <plat/iommu.h>
-#include <plat/iovmm.h>
 
 #include "omap-iopgtable.h"
 
+/*
+ * IOVMF_FLAGS: attribute for iommu virtual memory area(iovma)
+ *
+ * lower 16 bit is used for h/w and upper 16 bit is for s/w.
+ */
+#define IOVMF_SW_SHIFT		16
+
+/*
+ * iovma: h/w flags derived from cam and ram attribute
+ */
+#define IOVMF_CAM_MASK		(~((1 << 10) - 1))
+#define IOVMF_RAM_MASK		(~IOVMF_CAM_MASK)
+
+#define IOVMF_PGSZ_MASK		(3 << 0)
+#define IOVMF_PGSZ_1M		MMU_CAM_PGSZ_1M
+#define IOVMF_PGSZ_64K		MMU_CAM_PGSZ_64K
+#define IOVMF_PGSZ_4K		MMU_CAM_PGSZ_4K
+#define IOVMF_PGSZ_16M		MMU_CAM_PGSZ_16M
+
+#define IOVMF_ENDIAN_MASK	(1 << 9)
+#define IOVMF_ENDIAN_BIG	MMU_RAM_ENDIAN_BIG
+
+#define IOVMF_ELSZ_MASK		(3 << 7)
+#define IOVMF_ELSZ_16		MMU_RAM_ELSZ_16
+#define IOVMF_ELSZ_32		MMU_RAM_ELSZ_32
+#define IOVMF_ELSZ_NONE		MMU_RAM_ELSZ_NONE
+
+#define IOVMF_MIXED_MASK	(1 << 6)
+#define IOVMF_MIXED		MMU_RAM_MIXED
+
+/*
+ * iovma: s/w flags, used for mapping and umapping internally.
+ */
+#define IOVMF_MMIO		(1 << IOVMF_SW_SHIFT)
+#define IOVMF_ALLOC		(2 << IOVMF_SW_SHIFT)
+#define IOVMF_ALLOC_MASK	(3 << IOVMF_SW_SHIFT)
+
+/* "superpages" is supported just with physically linear pages */
+#define IOVMF_DISCONT		(1 << (2 + IOVMF_SW_SHIFT))
+#define IOVMF_LINEAR		(2 << (2 + IOVMF_SW_SHIFT))
+#define IOVMF_LINEAR_MASK	(3 << (2 + IOVMF_SW_SHIFT))
+
+#define IOVMF_DA_FIXED		(1 << (4 + IOVMF_SW_SHIFT))
+
 static struct kmem_cache *iovm_area_cachep;
 
 /* return the offset of the first scatterlist entry in a sg table */
diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 99640d8..7f182f0 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -61,6 +61,7 @@
 #include <linux/i2c.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
+#include <linux/omap-iommu.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/consumer.h>
 #include <linux/slab.h>
diff --git a/drivers/media/platform/omap3isp/isp.h b/drivers/media/platform/omap3isp/isp.h
index 8be7487..8d68669 100644
--- a/drivers/media/platform/omap3isp/isp.h
+++ b/drivers/media/platform/omap3isp/isp.h
@@ -31,11 +31,9 @@
 #include <media/v4l2-device.h>
 #include <linux/device.h>
 #include <linux/io.h>
+#include <linux/iommu.h>
 #include <linux/platform_device.h>
 #include <linux/wait.h>
-#include <linux/iommu.h>
-#include <plat/iommu.h>
-#include <plat/iovmm.h>
 
 #include "ispstat.h"
 #include "ispccdc.h"
diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
index 60181ab..6ae1ffb2 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -30,6 +30,7 @@
 #include <linux/device.h>
 #include <linux/dma-mapping.h>
 #include <linux/mm.h>
+#include <linux/omap-iommu.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <media/v4l2-event.h>
diff --git a/drivers/media/platform/omap3isp/ispstat.c b/drivers/media/platform/omap3isp/ispstat.c
index d7ac76b..35c3823 100644
--- a/drivers/media/platform/omap3isp/ispstat.c
+++ b/drivers/media/platform/omap3isp/ispstat.c
@@ -26,6 +26,7 @@
  */
 
 #include <linux/dma-mapping.h>
+#include <linux/omap-iommu.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
 
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index a0b737fe..a4b8290 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -27,6 +27,7 @@
 #include <linux/clk.h>
 #include <linux/mm.h>
 #include <linux/module.h>
+#include <linux/omap-iommu.h>
 #include <linux/pagemap.h>
 #include <linux/scatterlist.h>
 #include <linux/sched.h>
@@ -35,7 +36,6 @@
 #include <media/v4l2-dev.h>
 #include <media/v4l2-ioctl.h>
 #include <plat/iommu.h>
-#include <plat/iovmm.h>
 #include <plat/omap-pm.h>
 
 #include "ispvideo.h"
diff --git a/include/linux/omap-iommu.h b/include/linux/omap-iommu.h
new file mode 100644
index 0000000..cac78de
--- /dev/null
+++ b/include/linux/omap-iommu.h
@@ -0,0 +1,52 @@
+/*
+ * omap iommu: simple virtual address space management
+ *
+ * Copyright (C) 2008-2009 Nokia Corporation
+ *
+ * Written by Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _INTEL_IOMMU_H_
+#define _INTEL_IOMMU_H_
+
+struct iovm_struct {
+	struct omap_iommu	*iommu;	/* iommu object which this belongs to */
+	u32			da_start; /* area definition */
+	u32			da_end;
+	u32			flags; /* IOVMF_: see below */
+	struct list_head	list; /* linked in ascending order */
+	const struct sg_table	*sgt; /* keep 'page' <-> 'da' mapping */
+	void			*va; /* mpu side mapped address */
+};
+
+#define MMU_RAM_ENDIAN_SHIFT	9
+#define MMU_RAM_ENDIAN_LITTLE	(0 << MMU_RAM_ENDIAN_SHIFT)
+#define MMU_RAM_ELSZ_8		(0 << MMU_RAM_ELSZ_SHIFT)
+#define IOVMF_ENDIAN_LITTLE	MMU_RAM_ENDIAN_LITTLE
+#define MMU_RAM_ELSZ_SHIFT	7
+#define IOVMF_ELSZ_8		MMU_RAM_ELSZ_8
+
+struct iommu_domain;
+
+extern struct iovm_struct *omap_find_iovm_area(struct device *dev, u32 da);
+extern u32
+omap_iommu_vmap(struct iommu_domain *domain, struct device *dev, u32 da,
+			const struct sg_table *sgt, u32 flags);
+extern struct sg_table *omap_iommu_vunmap(struct iommu_domain *domain,
+				struct device *dev, u32 da);
+extern u32
+omap_iommu_vmalloc(struct iommu_domain *domain, struct device *dev,
+				u32 da, size_t bytes, u32 flags);
+extern void
+omap_iommu_vfree(struct iommu_domain *domain, struct device *dev,
+				const u32 da);
+extern void *omap_da_to_va(struct device *dev, u32 da);
+
+extern void omap_iommu_save_ctx(struct device *dev);
+extern void omap_iommu_restore_ctx(struct device *dev);
+
+#endif

