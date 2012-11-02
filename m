Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593Ab2KBTYR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 15:24:17 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:25434 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756983Ab2KBTYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 15:24:10 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/OVSGpnEXSqRn1jpzCGyEQ
Subject: [PATCH 4/6] ARM: OMAP2+: Move iommu2 to drivers/iommu/omap-iommu2.c
To: linux-kernel@vger.kernel.org
From: Tony Lindgren <tony@atomide.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, Joerg Roedel <joro@8bytes.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Omar Ramirez Luna <omar.luna@linaro.org>, linux-omap@vger.kernel.org,
        Ido Yariv <ido@wizery.com>, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org
Date: Fri, 02 Nov 2012 12:24:06 -0700
Message-ID: <20121102192406.4253.61774.stgit@muffinssi.local>
In-Reply-To: <20121102192221.4253.34303.stgit@muffinssi.local>
References: <20121102192221.4253.34303.stgit@muffinssi.local>
User-Agent: StGit/0.16-2-g0d85
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This file should not be in arch/arm. Move it to drivers/iommu
to allow making most of the header local to drivers/iommu.

This is needed as we are removing plat and mach includes
from drivers for ARM common zImage support.

Cc: Joerg Roedel <joro@8bytes.org>
Cc: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Ido Yariv <ido@wizery.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Omar Ramirez Luna <omar.luna@linaro.org>
Cc: linux-media@vger.kernel.org
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/Makefile            |    2 
 arch/arm/plat-omap/include/plat/iommu.h |  272 ++-----------------------------
 drivers/iommu/Makefile                  |    1 
 drivers/iommu/omap-iommu-debug.c        |    1 
 drivers/iommu/omap-iommu.c              |   19 ++
 drivers/iommu/omap-iommu.h              |  255 +++++++++++++++++++++++++++++
 drivers/iommu/omap-iommu2.c             |    2 
 drivers/iommu/omap-iopgtable.h          |   22 ---
 drivers/iommu/omap-iovmm.c              |    1 
 9 files changed, 293 insertions(+), 282 deletions(-)
 create mode 100644 drivers/iommu/omap-iommu.h
 rename arch/arm/mach-omap2/iommu2.c => drivers/iommu/omap-iommu2.c (99%)

diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index fe40d9e..d6721a7 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -184,8 +184,6 @@ obj-$(CONFIG_HW_PERF_EVENTS)		+= pmu.o
 obj-$(CONFIG_OMAP_MBOX_FWK)		+= mailbox_mach.o
 mailbox_mach-objs			:= mailbox.o
 
-obj-$(CONFIG_OMAP_IOMMU)		+= iommu2.o
-
 iommu-$(CONFIG_OMAP_IOMMU)		:= omap-iommu.o
 obj-y					+= $(iommu-m) $(iommu-y)
 
diff --git a/arch/arm/plat-omap/include/plat/iommu.h b/arch/arm/plat-omap/include/plat/iommu.h
index a4b71b1..c677b9f 100644
--- a/arch/arm/plat-omap/include/plat/iommu.h
+++ b/arch/arm/plat-omap/include/plat/iommu.h
@@ -10,103 +10,21 @@
  * published by the Free Software Foundation.
  */
 
-#ifndef __MACH_IOMMU_H
-#define __MACH_IOMMU_H
-
-#include <linux/io.h>
-
-#if defined(CONFIG_ARCH_OMAP1)
-#error "iommu for this processor not implemented yet"
-#endif
-
-struct iotlb_entry {
-	u32 da;
-	u32 pa;
-	u32 pgsz, prsvd, valid;
-	union {
-		u16 ap;
-		struct {
-			u32 endian, elsz, mixed;
-		};
-	};
-};
-
-struct omap_iommu {
-	const char	*name;
-	struct module	*owner;
-	struct clk	*clk;
-	void __iomem	*regbase;
-	struct device	*dev;
-	void		*isr_priv;
-	struct iommu_domain *domain;
-
-	unsigned int	refcount;
-	spinlock_t	iommu_lock;	/* global for this whole object */
-
-	/*
-	 * We don't change iopgd for a situation like pgd for a task,
-	 * but share it globally for each iommu.
-	 */
-	u32		*iopgd;
-	spinlock_t	page_table_lock; /* protect iopgd */
-
-	int		nr_tlb_entries;
-
-	struct list_head	mmap;
-	struct mutex		mmap_lock; /* protect mmap */
-
-	void *ctx; /* iommu context: registres saved area */
-	u32 da_start;
-	u32 da_end;
-};
-
-struct cr_regs {
-	union {
-		struct {
-			u16 cam_l;
-			u16 cam_h;
-		};
-		u32 cam;
-	};
-	union {
-		struct {
-			u16 ram_l;
-			u16 ram_h;
-		};
-		u32 ram;
-	};
-};
-
-struct iotlb_lock {
-	short base;
-	short vict;
-};
-
-/* architecture specific functions */
-struct iommu_functions {
-	unsigned long	version;
-
-	int (*enable)(struct omap_iommu *obj);
-	void (*disable)(struct omap_iommu *obj);
-	void (*set_twl)(struct omap_iommu *obj, bool on);
-	u32 (*fault_isr)(struct omap_iommu *obj, u32 *ra);
-
-	void (*tlb_read_cr)(struct omap_iommu *obj, struct cr_regs *cr);
-	void (*tlb_load_cr)(struct omap_iommu *obj, struct cr_regs *cr);
-
-	struct cr_regs *(*alloc_cr)(struct omap_iommu *obj,
-							struct iotlb_entry *e);
-	int (*cr_valid)(struct cr_regs *cr);
-	u32 (*cr_to_virt)(struct cr_regs *cr);
-	void (*cr_to_e)(struct cr_regs *cr, struct iotlb_entry *e);
-	ssize_t (*dump_cr)(struct omap_iommu *obj, struct cr_regs *cr,
-							char *buf);
-
-	u32 (*get_pte_attr)(struct iotlb_entry *e);
+#define MMU_REG_SIZE		256
 
-	void (*save_ctx)(struct omap_iommu *obj);
-	void (*restore_ctx)(struct omap_iommu *obj);
-	ssize_t (*dump_ctx)(struct omap_iommu *obj, char *buf, ssize_t len);
+/**
+ * struct iommu_arch_data - omap iommu private data
+ * @name: name of the iommu device
+ * @iommu_dev: handle of the iommu device
+ *
+ * This is an omap iommu private data object, which binds an iommu user
+ * to its iommu device. This object should be placed at the iommu user's
+ * dev_archdata so generic IOMMU API can be used without having to
+ * utilize omap-specific plumbing anymore.
+ */
+struct omap_iommu_arch_data {
+	const char *name;
+	struct omap_iommu *iommu_dev;
 };
 
 /**
@@ -129,165 +47,3 @@ struct iommu_platform_data {
 	u32 da_start;
 	u32 da_end;
 };
-
-/**
- * struct iommu_arch_data - omap iommu private data
- * @name: name of the iommu device
- * @iommu_dev: handle of the iommu device
- *
- * This is an omap iommu private data object, which binds an iommu user
- * to its iommu device. This object should be placed at the iommu user's
- * dev_archdata so generic IOMMU API can be used without having to
- * utilize omap-specific plumbing anymore.
- */
-struct omap_iommu_arch_data {
-	const char *name;
-	struct omap_iommu *iommu_dev;
-};
-
-#ifdef CONFIG_IOMMU_API
-/**
- * dev_to_omap_iommu() - retrieves an omap iommu object from a user device
- * @dev: iommu client device
- */
-static inline struct omap_iommu *dev_to_omap_iommu(struct device *dev)
-{
-	struct omap_iommu_arch_data *arch_data = dev->archdata.iommu;
-
-	return arch_data->iommu_dev;
-}
-#endif
-
-/* IOMMU errors */
-#define OMAP_IOMMU_ERR_TLB_MISS		(1 << 0)
-#define OMAP_IOMMU_ERR_TRANS_FAULT	(1 << 1)
-#define OMAP_IOMMU_ERR_EMU_MISS		(1 << 2)
-#define OMAP_IOMMU_ERR_TBLWALK_FAULT	(1 << 3)
-#define OMAP_IOMMU_ERR_MULTIHIT_FAULT	(1 << 4)
-
-/*
- * MMU Register offsets
- */
-#define MMU_REVISION		0x00
-#define MMU_SYSCONFIG		0x10
-#define MMU_SYSSTATUS		0x14
-#define MMU_IRQSTATUS		0x18
-#define MMU_IRQENABLE		0x1c
-#define MMU_WALKING_ST		0x40
-#define MMU_CNTL		0x44
-#define MMU_FAULT_AD		0x48
-#define MMU_TTB			0x4c
-#define MMU_LOCK		0x50
-#define MMU_LD_TLB		0x54
-#define MMU_CAM			0x58
-#define MMU_RAM			0x5c
-#define MMU_GFLUSH		0x60
-#define MMU_FLUSH_ENTRY		0x64
-#define MMU_READ_CAM		0x68
-#define MMU_READ_RAM		0x6c
-#define MMU_EMU_FAULT_AD	0x70
-
-#define MMU_REG_SIZE		256
-
-/*
- * MMU Register bit definitions
- */
-#define MMU_LOCK_BASE_SHIFT	10
-#define MMU_LOCK_BASE_MASK	(0x1f << MMU_LOCK_BASE_SHIFT)
-#define MMU_LOCK_BASE(x)	\
-	((x & MMU_LOCK_BASE_MASK) >> MMU_LOCK_BASE_SHIFT)
-
-#define MMU_LOCK_VICT_SHIFT	4
-#define MMU_LOCK_VICT_MASK	(0x1f << MMU_LOCK_VICT_SHIFT)
-#define MMU_LOCK_VICT(x)	\
-	((x & MMU_LOCK_VICT_MASK) >> MMU_LOCK_VICT_SHIFT)
-
-#define MMU_CAM_VATAG_SHIFT	12
-#define MMU_CAM_VATAG_MASK \
-	((~0UL >> MMU_CAM_VATAG_SHIFT) << MMU_CAM_VATAG_SHIFT)
-#define MMU_CAM_P		(1 << 3)
-#define MMU_CAM_V		(1 << 2)
-#define MMU_CAM_PGSZ_MASK	3
-#define MMU_CAM_PGSZ_1M		(0 << 0)
-#define MMU_CAM_PGSZ_64K	(1 << 0)
-#define MMU_CAM_PGSZ_4K		(2 << 0)
-#define MMU_CAM_PGSZ_16M	(3 << 0)
-
-#define MMU_RAM_PADDR_SHIFT	12
-#define MMU_RAM_PADDR_MASK \
-	((~0UL >> MMU_RAM_PADDR_SHIFT) << MMU_RAM_PADDR_SHIFT)
-
-#define MMU_RAM_ENDIAN_MASK	(1 << MMU_RAM_ENDIAN_SHIFT)
-#define MMU_RAM_ELSZ_MASK	(3 << MMU_RAM_ELSZ_SHIFT)
-
-#define MMU_RAM_ELSZ_16		(1 << MMU_RAM_ELSZ_SHIFT)
-#define MMU_RAM_ELSZ_32		(2 << MMU_RAM_ELSZ_SHIFT)
-#define MMU_RAM_ELSZ_NONE	(3 << MMU_RAM_ELSZ_SHIFT)
-#define MMU_RAM_MIXED_SHIFT	6
-#define MMU_RAM_MIXED_MASK	(1 << MMU_RAM_MIXED_SHIFT)
-#define MMU_RAM_MIXED		MMU_RAM_MIXED_MASK
-
-/*
- * utilities for super page(16MB, 1MB, 64KB and 4KB)
- */
-
-#define iopgsz_max(bytes)			\
-	(((bytes) >= SZ_16M) ? SZ_16M :		\
-	 ((bytes) >= SZ_1M)  ? SZ_1M  :		\
-	 ((bytes) >= SZ_64K) ? SZ_64K :		\
-	 ((bytes) >= SZ_4K)  ? SZ_4K  :	0)
-
-#define bytes_to_iopgsz(bytes)				\
-	(((bytes) == SZ_16M) ? MMU_CAM_PGSZ_16M :	\
-	 ((bytes) == SZ_1M)  ? MMU_CAM_PGSZ_1M  :	\
-	 ((bytes) == SZ_64K) ? MMU_CAM_PGSZ_64K :	\
-	 ((bytes) == SZ_4K)  ? MMU_CAM_PGSZ_4K  : -1)
-
-#define iopgsz_to_bytes(iopgsz)				\
-	(((iopgsz) == MMU_CAM_PGSZ_16M)	? SZ_16M :	\
-	 ((iopgsz) == MMU_CAM_PGSZ_1M)	? SZ_1M  :	\
-	 ((iopgsz) == MMU_CAM_PGSZ_64K)	? SZ_64K :	\
-	 ((iopgsz) == MMU_CAM_PGSZ_4K)	? SZ_4K  : 0)
-
-#define iopgsz_ok(bytes) (bytes_to_iopgsz(bytes) >= 0)
-
-/*
- * global functions
- */
-extern u32 omap_iommu_arch_version(void);
-
-extern void omap_iotlb_cr_to_e(struct cr_regs *cr, struct iotlb_entry *e);
-
-extern int
-omap_iopgtable_store_entry(struct omap_iommu *obj, struct iotlb_entry *e);
-
-extern int omap_iommu_set_isr(const char *name,
-		 int (*isr)(struct omap_iommu *obj, u32 da, u32 iommu_errs,
-				    void *priv),
-			 void *isr_priv);
-
-extern int omap_install_iommu_arch(const struct iommu_functions *ops);
-extern void omap_uninstall_iommu_arch(const struct iommu_functions *ops);
-
-extern int omap_foreach_iommu_device(void *data,
-				int (*fn)(struct device *, void *));
-
-extern ssize_t
-omap_iommu_dump_ctx(struct omap_iommu *obj, char *buf, ssize_t len);
-extern size_t
-omap_dump_tlb_entries(struct omap_iommu *obj, char *buf, ssize_t len);
-
-/*
- * register accessors
- */
-static inline u32 iommu_read_reg(struct omap_iommu *obj, size_t offs)
-{
-	return __raw_readl(obj->regbase + offs);
-}
-
-static inline void iommu_write_reg(struct omap_iommu *obj, u32 val, size_t offs)
-{
-	__raw_writel(val, obj->regbase + offs);
-}
-
-#endif /* __MACH_IOMMU_H */
diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index 14a4d5f..f66b816 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_DMAR_TABLE) += dmar.o
 obj-$(CONFIG_INTEL_IOMMU) += iova.o intel-iommu.o
 obj-$(CONFIG_IRQ_REMAP) += intel_irq_remapping.o irq_remapping.o
 obj-$(CONFIG_OMAP_IOMMU) += omap-iommu.o
+obj-$(CONFIG_OMAP_IOMMU) += omap-iommu2.o
 obj-$(CONFIG_OMAP_IOVMM) += omap-iovmm.o
 obj-$(CONFIG_OMAP_IOMMU_DEBUG) += omap-iommu-debug.o
 obj-$(CONFIG_TEGRA_IOMMU_GART) += tegra-gart.o
diff --git a/drivers/iommu/omap-iommu-debug.c b/drivers/iommu/omap-iommu-debug.c
index cf4a0b5..d0427bd 100644
--- a/drivers/iommu/omap-iommu-debug.c
+++ b/drivers/iommu/omap-iommu-debug.c
@@ -23,6 +23,7 @@
 #include <plat/iommu.h>
 
 #include "omap-iopgtable.h"
+#include "omap-iommu.h"
 
 #define MAXCOLUMN 100 /* for short messages */
 
diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
index eadcfde..4db86e1 100644
--- a/drivers/iommu/omap-iommu.c
+++ b/drivers/iommu/omap-iommu.c
@@ -22,12 +22,14 @@
 #include <linux/omap-iommu.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
+#include <linux/io.h>
 
 #include <asm/cacheflush.h>
 
 #include <plat/iommu.h>
 
 #include "omap-iopgtable.h"
+#include "omap-iommu.h"
 
 #define for_each_iotlb_cr(obj, n, __i, cr)				\
 	for (__i = 0;							\
@@ -1016,6 +1018,23 @@ static void iopte_cachep_ctor(void *iopte)
 	clean_dcache_area(iopte, IOPTE_TABLE_SIZE);
 }
 
+static u32 iotlb_init_entry(struct iotlb_entry *e, u32 da, u32 pa,
+				   u32 flags)
+{
+	memset(e, 0, sizeof(*e));
+
+	e->da		= da;
+	e->pa		= pa;
+	e->valid	= 1;
+	/* FIXME: add OMAP1 support */
+	e->pgsz		= flags & MMU_CAM_PGSZ_MASK;
+	e->endian	= flags & MMU_RAM_ENDIAN_MASK;
+	e->elsz		= flags & MMU_RAM_ELSZ_MASK;
+	e->mixed	= flags & MMU_RAM_MIXED_MASK;
+
+	return iopgsz_to_bytes(e->pgsz);
+}
+
 static int omap_iommu_map(struct iommu_domain *domain, unsigned long da,
 			 phys_addr_t pa, size_t bytes, int prot)
 {
diff --git a/drivers/iommu/omap-iommu.h b/drivers/iommu/omap-iommu.h
new file mode 100644
index 0000000..8c3378d
--- /dev/null
+++ b/drivers/iommu/omap-iommu.h
@@ -0,0 +1,255 @@
+/*
+ * omap iommu: main structures
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
+#if defined(CONFIG_ARCH_OMAP1)
+#error "iommu for this processor not implemented yet"
+#endif
+
+struct iotlb_entry {
+	u32 da;
+	u32 pa;
+	u32 pgsz, prsvd, valid;
+	union {
+		u16 ap;
+		struct {
+			u32 endian, elsz, mixed;
+		};
+	};
+};
+
+struct omap_iommu {
+	const char	*name;
+	struct module	*owner;
+	struct clk	*clk;
+	void __iomem	*regbase;
+	struct device	*dev;
+	void		*isr_priv;
+	struct iommu_domain *domain;
+
+	unsigned int	refcount;
+	spinlock_t	iommu_lock;	/* global for this whole object */
+
+	/*
+	 * We don't change iopgd for a situation like pgd for a task,
+	 * but share it globally for each iommu.
+	 */
+	u32		*iopgd;
+	spinlock_t	page_table_lock; /* protect iopgd */
+
+	int		nr_tlb_entries;
+
+	struct list_head	mmap;
+	struct mutex		mmap_lock; /* protect mmap */
+
+	void *ctx; /* iommu context: registres saved area */
+	u32 da_start;
+	u32 da_end;
+};
+
+struct cr_regs {
+	union {
+		struct {
+			u16 cam_l;
+			u16 cam_h;
+		};
+		u32 cam;
+	};
+	union {
+		struct {
+			u16 ram_l;
+			u16 ram_h;
+		};
+		u32 ram;
+	};
+};
+
+struct iotlb_lock {
+	short base;
+	short vict;
+};
+
+/* architecture specific functions */
+struct iommu_functions {
+	unsigned long	version;
+
+	int (*enable)(struct omap_iommu *obj);
+	void (*disable)(struct omap_iommu *obj);
+	void (*set_twl)(struct omap_iommu *obj, bool on);
+	u32 (*fault_isr)(struct omap_iommu *obj, u32 *ra);
+
+	void (*tlb_read_cr)(struct omap_iommu *obj, struct cr_regs *cr);
+	void (*tlb_load_cr)(struct omap_iommu *obj, struct cr_regs *cr);
+
+	struct cr_regs *(*alloc_cr)(struct omap_iommu *obj,
+							struct iotlb_entry *e);
+	int (*cr_valid)(struct cr_regs *cr);
+	u32 (*cr_to_virt)(struct cr_regs *cr);
+	void (*cr_to_e)(struct cr_regs *cr, struct iotlb_entry *e);
+	ssize_t (*dump_cr)(struct omap_iommu *obj, struct cr_regs *cr,
+							char *buf);
+
+	u32 (*get_pte_attr)(struct iotlb_entry *e);
+
+	void (*save_ctx)(struct omap_iommu *obj);
+	void (*restore_ctx)(struct omap_iommu *obj);
+	ssize_t (*dump_ctx)(struct omap_iommu *obj, char *buf, ssize_t len);
+};
+
+#ifdef CONFIG_IOMMU_API
+/**
+ * dev_to_omap_iommu() - retrieves an omap iommu object from a user device
+ * @dev: iommu client device
+ */
+static inline struct omap_iommu *dev_to_omap_iommu(struct device *dev)
+{
+	struct omap_iommu_arch_data *arch_data = dev->archdata.iommu;
+
+	return arch_data->iommu_dev;
+}
+#endif
+
+/* IOMMU errors */
+#define OMAP_IOMMU_ERR_TLB_MISS		(1 << 0)
+#define OMAP_IOMMU_ERR_TRANS_FAULT	(1 << 1)
+#define OMAP_IOMMU_ERR_EMU_MISS		(1 << 2)
+#define OMAP_IOMMU_ERR_TBLWALK_FAULT	(1 << 3)
+#define OMAP_IOMMU_ERR_MULTIHIT_FAULT	(1 << 4)
+
+/*
+ * MMU Register offsets
+ */
+#define MMU_REVISION		0x00
+#define MMU_SYSCONFIG		0x10
+#define MMU_SYSSTATUS		0x14
+#define MMU_IRQSTATUS		0x18
+#define MMU_IRQENABLE		0x1c
+#define MMU_WALKING_ST		0x40
+#define MMU_CNTL		0x44
+#define MMU_FAULT_AD		0x48
+#define MMU_TTB			0x4c
+#define MMU_LOCK		0x50
+#define MMU_LD_TLB		0x54
+#define MMU_CAM			0x58
+#define MMU_RAM			0x5c
+#define MMU_GFLUSH		0x60
+#define MMU_FLUSH_ENTRY		0x64
+#define MMU_READ_CAM		0x68
+#define MMU_READ_RAM		0x6c
+#define MMU_EMU_FAULT_AD	0x70
+
+#define MMU_REG_SIZE		256
+
+/*
+ * MMU Register bit definitions
+ */
+#define MMU_LOCK_BASE_SHIFT	10
+#define MMU_LOCK_BASE_MASK	(0x1f << MMU_LOCK_BASE_SHIFT)
+#define MMU_LOCK_BASE(x)	\
+	((x & MMU_LOCK_BASE_MASK) >> MMU_LOCK_BASE_SHIFT)
+
+#define MMU_LOCK_VICT_SHIFT	4
+#define MMU_LOCK_VICT_MASK	(0x1f << MMU_LOCK_VICT_SHIFT)
+#define MMU_LOCK_VICT(x)	\
+	((x & MMU_LOCK_VICT_MASK) >> MMU_LOCK_VICT_SHIFT)
+
+#define MMU_CAM_VATAG_SHIFT	12
+#define MMU_CAM_VATAG_MASK \
+	((~0UL >> MMU_CAM_VATAG_SHIFT) << MMU_CAM_VATAG_SHIFT)
+#define MMU_CAM_P		(1 << 3)
+#define MMU_CAM_V		(1 << 2)
+#define MMU_CAM_PGSZ_MASK	3
+#define MMU_CAM_PGSZ_1M		(0 << 0)
+#define MMU_CAM_PGSZ_64K	(1 << 0)
+#define MMU_CAM_PGSZ_4K		(2 << 0)
+#define MMU_CAM_PGSZ_16M	(3 << 0)
+
+#define MMU_RAM_PADDR_SHIFT	12
+#define MMU_RAM_PADDR_MASK \
+	((~0UL >> MMU_RAM_PADDR_SHIFT) << MMU_RAM_PADDR_SHIFT)
+
+#define MMU_RAM_ENDIAN_MASK	(1 << MMU_RAM_ENDIAN_SHIFT)
+#define MMU_RAM_ENDIAN_BIG	(1 << MMU_RAM_ENDIAN_SHIFT)
+
+#define MMU_RAM_ELSZ_MASK	(3 << MMU_RAM_ELSZ_SHIFT)
+#define MMU_RAM_ELSZ_8		(0 << MMU_RAM_ELSZ_SHIFT)
+#define MMU_RAM_ELSZ_16		(1 << MMU_RAM_ELSZ_SHIFT)
+#define MMU_RAM_ELSZ_32		(2 << MMU_RAM_ELSZ_SHIFT)
+#define MMU_RAM_ELSZ_NONE	(3 << MMU_RAM_ELSZ_SHIFT)
+#define MMU_RAM_MIXED_SHIFT	6
+#define MMU_RAM_MIXED_MASK	(1 << MMU_RAM_MIXED_SHIFT)
+#define MMU_RAM_MIXED		MMU_RAM_MIXED_MASK
+
+/*
+ * utilities for super page(16MB, 1MB, 64KB and 4KB)
+ */
+
+#define iopgsz_max(bytes)			\
+	(((bytes) >= SZ_16M) ? SZ_16M :		\
+	 ((bytes) >= SZ_1M)  ? SZ_1M  :		\
+	 ((bytes) >= SZ_64K) ? SZ_64K :		\
+	 ((bytes) >= SZ_4K)  ? SZ_4K  :	0)
+
+#define bytes_to_iopgsz(bytes)				\
+	(((bytes) == SZ_16M) ? MMU_CAM_PGSZ_16M :	\
+	 ((bytes) == SZ_1M)  ? MMU_CAM_PGSZ_1M  :	\
+	 ((bytes) == SZ_64K) ? MMU_CAM_PGSZ_64K :	\
+	 ((bytes) == SZ_4K)  ? MMU_CAM_PGSZ_4K  : -1)
+
+#define iopgsz_to_bytes(iopgsz)				\
+	(((iopgsz) == MMU_CAM_PGSZ_16M)	? SZ_16M :	\
+	 ((iopgsz) == MMU_CAM_PGSZ_1M)	? SZ_1M  :	\
+	 ((iopgsz) == MMU_CAM_PGSZ_64K)	? SZ_64K :	\
+	 ((iopgsz) == MMU_CAM_PGSZ_4K)	? SZ_4K  : 0)
+
+#define iopgsz_ok(bytes) (bytes_to_iopgsz(bytes) >= 0)
+
+/*
+ * global functions
+ */
+extern u32 omap_iommu_arch_version(void);
+
+extern void omap_iotlb_cr_to_e(struct cr_regs *cr, struct iotlb_entry *e);
+
+extern int
+omap_iopgtable_store_entry(struct omap_iommu *obj, struct iotlb_entry *e);
+
+extern int omap_iommu_set_isr(const char *name,
+		 int (*isr)(struct omap_iommu *obj, u32 da, u32 iommu_errs,
+				    void *priv),
+			 void *isr_priv);
+
+extern void omap_iommu_save_ctx(struct device *dev);
+extern void omap_iommu_restore_ctx(struct device *dev);
+
+extern int omap_install_iommu_arch(const struct iommu_functions *ops);
+extern void omap_uninstall_iommu_arch(const struct iommu_functions *ops);
+
+extern int omap_foreach_iommu_device(void *data,
+				int (*fn)(struct device *, void *));
+
+extern ssize_t
+omap_iommu_dump_ctx(struct omap_iommu *obj, char *buf, ssize_t len);
+extern size_t
+omap_dump_tlb_entries(struct omap_iommu *obj, char *buf, ssize_t len);
+
+/*
+ * register accessors
+ */
+static inline u32 iommu_read_reg(struct omap_iommu *obj, size_t offs)
+{
+	return __raw_readl(obj->regbase + offs);
+}
+
+static inline void iommu_write_reg(struct omap_iommu *obj, u32 val, size_t offs)
+{
+	__raw_writel(val, obj->regbase + offs);
+}
diff --git a/arch/arm/mach-omap2/iommu2.c b/drivers/iommu/omap-iommu2.c
similarity index 99%
rename from arch/arm/mach-omap2/iommu2.c
rename to drivers/iommu/omap-iommu2.c
index e8116cf..f97c386 100644
--- a/arch/arm/mach-omap2/iommu2.c
+++ b/drivers/iommu/omap-iommu2.c
@@ -13,6 +13,7 @@
 
 #include <linux/err.h>
 #include <linux/device.h>
+#include <linux/io.h>
 #include <linux/jiffies.h>
 #include <linux/module.h>
 #include <linux/omap-iommu.h>
@@ -20,6 +21,7 @@
 #include <linux/stringify.h>
 
 #include <plat/iommu.h>
+#include "omap-iommu.h"
 
 /*
  * omap2 architecture specific register bit definitions
diff --git a/drivers/iommu/omap-iopgtable.h b/drivers/iommu/omap-iopgtable.h
index 66a8139..cd4ae9e 100644
--- a/drivers/iommu/omap-iopgtable.h
+++ b/drivers/iommu/omap-iopgtable.h
@@ -10,9 +10,6 @@
  * published by the Free Software Foundation.
  */
 
-#ifndef __PLAT_OMAP_IOMMU_H
-#define __PLAT_OMAP_IOMMU_H
-
 /*
  * "L2 table" address mask and size definitions.
  */
@@ -97,24 +94,5 @@ static inline phys_addr_t omap_iommu_translate(u32 d, u32 va, u32 mask)
 #define iopte_index(da)		(((da) >> IOPTE_SHIFT) & (PTRS_PER_IOPTE - 1))
 #define iopte_offset(iopgd, da)	(iopgd_page_vaddr(iopgd) + iopte_index(da))
 
-static inline u32 iotlb_init_entry(struct iotlb_entry *e, u32 da, u32 pa,
-				   u32 flags)
-{
-	memset(e, 0, sizeof(*e));
-
-	e->da		= da;
-	e->pa		= pa;
-	e->valid	= 1;
-	/* FIXME: add OMAP1 support */
-	e->pgsz		= flags & MMU_CAM_PGSZ_MASK;
-	e->endian	= flags & MMU_RAM_ENDIAN_MASK;
-	e->elsz		= flags & MMU_RAM_ELSZ_MASK;
-	e->mixed	= flags & MMU_RAM_MIXED_MASK;
-
-	return iopgsz_to_bytes(e->pgsz);
-}
-
 #define to_iommu(dev)							\
 	(struct omap_iommu *)platform_get_drvdata(to_platform_device(dev))
-
-#endif /* __PLAT_OMAP_IOMMU_H */
diff --git a/drivers/iommu/omap-iovmm.c b/drivers/iommu/omap-iovmm.c
index 9852101..3e3b242 100644
--- a/drivers/iommu/omap-iovmm.c
+++ b/drivers/iommu/omap-iovmm.c
@@ -25,6 +25,7 @@
 #include <plat/iommu.h>
 
 #include "omap-iopgtable.h"
+#include "omap-iommu.h"
 
 /*
  * IOVMF_FLAGS: attribute for iommu virtual memory area(iovma)

