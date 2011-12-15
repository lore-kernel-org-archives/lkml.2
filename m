Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758880Ab1LONMJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 08:12:09 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18276 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab1LONMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 08:12:07 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 15 Dec 2011 05:12:02 -0800
From: Hiroshi DOYU <hdoyu@nvidia.com>
To: Hiroshi DOYU <hdoyu@nvidia.com>
Cc: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>,
        Joerg Roedel <joerg.roedel@amd.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        Tony Lindgren <tony@atomide.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] [RFC] ARM: IOMMU: Tegra30: iommu_ops for SMMU driver
Date: Thu, 15 Dec 2011 15:11:30 +0200
Message-Id: <1323954690-7000-3-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323954690-7000-1-git-send-email-hdoyu@nvidia.com>
References: <1323954690-7000-1-git-send-email-hdoyu@nvidia.com>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tegra 30 IOMMU H/W, SMMU (System Memory Management Unit). This patch
implements struct iommu_ops for SMMU for the upper IOMMU API.

This H/W module supports multiple virtual address spaces(domain x4),
and manages 2 level H/W translation pagetable.

Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
---
 arch/arm/mach-tegra/include/mach/smmu.h |   63 ++
 drivers/iommu/Kconfig                   |   11 +
 drivers/iommu/Makefile                  |    1 +
 drivers/iommu/tegra-smmu.c              | 1027 +++++++++++++++++++++++++++++++
 4 files changed, 1102 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-tegra/include/mach/smmu.h
 create mode 100644 drivers/iommu/tegra-smmu.c

diff --git a/arch/arm/mach-tegra/include/mach/smmu.h b/arch/arm/mach-tegra/include/mach/smmu.h
new file mode 100644
index 0000000..3eff2e1
--- /dev/null
+++ b/arch/arm/mach-tegra/include/mach/smmu.h
@@ -0,0 +1,63 @@
+/*
+ * IOMMU API for SMMU in Tegra30
+ *
+ * Copyright (c) 2010-2011, NVIDIA CORPORATION.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#ifndef	MACH_SMMU_H
+#define	MACH_SMMU_H
+
+enum smmu_hwgrp {
+	HWGRP_AFI,
+	HWGRP_AVPC,
+	HWGRP_DC,
+	HWGRP_DCB,
+	HWGRP_EPP,
+	HWGRP_G2,
+	HWGRP_HC,
+	HWGRP_HDA,
+	HWGRP_ISP,
+	HWGRP_MPE,
+	HWGRP_NV,
+	HWGRP_NV2,
+	HWGRP_PPCS,
+	HWGRP_SATA,
+	HWGRP_VDE,
+	HWGRP_VI,
+
+	HWGRP_COUNT,
+
+	HWGRP_END = ~0,
+};
+
+#define HWG_AFI		(1 << HWGRP_AFI)
+#define HWG_AVPC	(1 << HWGRP_AVPC)
+#define HWG_DC		(1 << HWGRP_DC)
+#define HWG_DCB		(1 << HWGRP_DCB)
+#define HWG_EPP		(1 << HWGRP_EPP)
+#define HWG_G2		(1 << HWGRP_G2)
+#define HWG_HC		(1 << HWGRP_HC)
+#define HWG_HDA		(1 << HWGRP_HDA)
+#define HWG_ISP		(1 << HWGRP_ISP)
+#define HWG_MPE		(1 << HWGRP_MPE)
+#define HWG_NV		(1 << HWGRP_NV)
+#define HWG_NV2		(1 << HWGRP_NV2)
+#define HWG_PPCS	(1 << HWGRP_PPCS)
+#define HWG_SATA	(1 << HWGRP_SATA)
+#define HWG_VDE		(1 << HWGRP_VDE)
+#define HWG_VI		(1 << HWGRP_VI)
+
+#endif	/* MACH_SMMU_H */
diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index 348ff75..1df5c82 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -142,4 +142,15 @@ config TEGRA_IOMMU_GART
 	  space through the GART (Graphics Address Relocation Table)
 	  hardware included on Tegra SoCs.
 
+config TEGRA_IOMMU_SMMU
+	bool "Tegra SMMU IOMMU Support"
+	depends on ARCH_TEGRA_3x_SOC
+	default y
+	select IOMMU_API
+	help
+	  Enables support for remapping discontiguous physical memory
+	  shared with the operating system into contiguous I/O virtual
+	  space through the SMMU (System Memory Management Unit)
+	  hardware included on Tegra SoCs.
+
 endif # IOMMU_SUPPORT
diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index fc5f42a..37648c5 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -8,3 +8,4 @@ obj-$(CONFIG_OMAP_IOMMU) += omap-iommu.o
 obj-$(CONFIG_OMAP_IOVMM) += omap-iovmm.o
 obj-$(CONFIG_OMAP_IOMMU_DEBUG) += omap-iommu-debug.o
 obj-$(CONFIG_TEGRA_IOMMU_GART) += tegra-gart.o
+obj-$(CONFIG_TEGRA_IOMMU_SMMU) += tegra-smmu.o
diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
new file mode 100644
index 0000000..454e2b0
--- /dev/null
+++ b/drivers/iommu/tegra-smmu.c
@@ -0,0 +1,1027 @@
+/*
+ * IOMMU API for SMMU in Tegra30
+ *
+ * Copyright (c) 2010-2011, NVIDIA CORPORATION.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#define pr_fmt(fmt)	"%s(): " fmt, __func__
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/spinlock.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include <linux/mm.h>
+#include <linux/pagemap.h>
+#include <linux/device.h>
+#include <linux/sched.h>
+#include <linux/iommu.h>
+#include <linux/io.h>
+
+#include <asm/page.h>
+#include <asm/cacheflush.h>
+
+#include <mach/iomap.h>
+#include <mach/smmu.h>
+
+#define SMMU_CONFIG				0x10
+#define SMMU_CONFIG_DISABLE			0
+#define SMMU_CONFIG_ENABLE			1
+
+#define SMMU_TLB_CONFIG				0x14
+#define SMMU_TLB_CONFIG_STATS__MASK		(1 << 31)
+#define SMMU_TLB_CONFIG_STATS__ENABLE		(1 << 31)
+#define SMMU_TLB_CONFIG_HIT_UNDER_MISS__ENABLE	(1 << 29)
+#define SMMU_TLB_CONFIG_ACTIVE_LINES__VALUE	0x10
+#define SMMU_TLB_CONFIG_RESET_VAL		0x20000010
+
+#define SMMU_PTC_CONFIG				0x18
+#define SMMU_PTC_CONFIG_STATS__MASK		(1 << 31)
+#define SMMU_PTC_CONFIG_STATS__ENABLE		(1 << 31)
+#define SMMU_PTC_CONFIG_CACHE__ENABLE		(1 << 29)
+#define SMMU_PTC_CONFIG_INDEX_MAP__PATTERN	0x3f
+#define SMMU_PTC_CONFIG_RESET_VAL		0x2000003f
+
+#define SMMU_PTB_ASID				0x1c
+#define SMMU_PTB_ASID_CURRENT_SHIFT		0
+
+#define SMMU_PTB_DATA				0x20
+#define SMMU_PTB_DATA_RESET_VAL			0
+#define SMMU_PTB_DATA_ASID_NONSECURE_SHIFT	29
+#define SMMU_PTB_DATA_ASID_WRITABLE_SHIFT	30
+#define SMMU_PTB_DATA_ASID_READABLE_SHIFT	31
+
+#define SMMU_TLB_FLUSH				0x30
+#define SMMU_TLB_FLUSH_VA_MATCH_ALL		0
+#define SMMU_TLB_FLUSH_VA_MATCH_SECTION		2
+#define SMMU_TLB_FLUSH_VA_MATCH_GROUP		3
+#define SMMU_TLB_FLUSH_ASID_SHIFT		29
+#define SMMU_TLB_FLUSH_ASID_MATCH_DISABLE	0
+#define SMMU_TLB_FLUSH_ASID_MATCH_ENABLE	1
+#define SMMU_TLB_FLUSH_ASID_MATCH_SHIFT		31
+
+#define SMMU_PTC_FLUSH				0x34
+#define SMMU_PTC_FLUSH_TYPE_ALL			0
+#define SMMU_PTC_FLUSH_TYPE_ADR			1
+#define SMMU_PTC_FLUSH_ADR_SHIFT		4
+
+#define SMMU_ASID_SECURITY			0x38
+
+#define SMMU_STATS_TLB_HIT_COUNT		0x1f0
+#define SMMU_STATS_TLB_MISS_COUNT		0x1f4
+#define SMMU_STATS_PTC_HIT_COUNT		0x1f8
+#define SMMU_STATS_PTC_MISS_COUNT		0x1fc
+
+#define SMMU_TRANSLATION_ENABLE_0		0x228
+#define SMMU_TRANSLATION_ENABLE_1		0x22c
+#define SMMU_TRANSLATION_ENABLE_2		0x230
+
+#define SMMU_AFI_ASID	0x238   /* PCIE */
+#define SMMU_AVPC_ASID	0x23c   /* AVP */
+#define SMMU_DC_ASID	0x240   /* Display controller */
+#define SMMU_DCB_ASID	0x244   /* Display controller B */
+#define SMMU_EPP_ASID	0x248   /* Encoder pre-processor */
+#define SMMU_G2_ASID	0x24c   /* 2D engine */
+#define SMMU_HC_ASID	0x250   /* Host1x */
+#define SMMU_HDA_ASID	0x254   /* High-def audio */
+#define SMMU_ISP_ASID	0x258   /* Image signal processor */
+#define SMMU_MPE_ASID	0x264   /* MPEG encoder */
+#define SMMU_NV_ASID	0x268   /* (3D) */
+#define SMMU_NV2_ASID	0x26c   /* (3D) */
+#define SMMU_PPCS_ASID	0x270   /* AHB */
+#define SMMU_SATA_ASID	0x278   /* SATA */
+#define SMMU_VDE_ASID	0x27c   /* Video decoder */
+#define SMMU_VI_ASID	0x280   /* Video input */
+
+#define SMMU_PDE_NEXT_SHIFT		28
+
+/* AHB Arbiter Registers */
+#define AHB_XBAR_CTRL				0xe0
+#define AHB_XBAR_CTRL_SMMU_INIT_DONE_DONE	1
+#define AHB_XBAR_CTRL_SMMU_INIT_DONE_SHIFT	17
+
+#define SMMU_NUM_ASIDS				4
+#define SMMU_TLB_FLUSH_VA_SECTION__MASK		0xffc00000
+#define SMMU_TLB_FLUSH_VA_SECTION__SHIFT	12 /* right shift */
+#define SMMU_TLB_FLUSH_VA_GROUP__MASK		0xffffc000
+#define SMMU_TLB_FLUSH_VA_GROUP__SHIFT		12 /* right shift */
+#define SMMU_TLB_FLUSH_VA(iova, which)	\
+	((((iova) & SMMU_TLB_FLUSH_VA_##which##__MASK) >> \
+		SMMU_TLB_FLUSH_VA_##which##__SHIFT) |	\
+	SMMU_TLB_FLUSH_VA_MATCH_##which)
+#define SMMU_PTB_ASID_CUR(n)	\
+		((n) << SMMU_PTB_ASID_CURRENT_SHIFT)
+#define SMMU_TLB_FLUSH_ASID_MATCH_disable		\
+		(SMMU_TLB_FLUSH_ASID_MATCH_DISABLE <<	\
+			SMMU_TLB_FLUSH_ASID_MATCH_SHIFT)
+#define SMMU_TLB_FLUSH_ASID_MATCH__ENABLE		\
+		(SMMU_TLB_FLUSH_ASID_MATCH_ENABLE <<	\
+			SMMU_TLB_FLUSH_ASID_MATCH_SHIFT)
+
+#define SMMU_PAGE_SHIFT 12
+#define SMMU_PAGE_SIZE	(1 << SMMU_PAGE_SHIFT)
+
+#define SMMU_PDIR_COUNT	1024
+#define SMMU_PDIR_SIZE	(sizeof(unsigned long) * SMMU_PDIR_COUNT)
+#define SMMU_PTBL_COUNT	1024
+#define SMMU_PTBL_SIZE	(sizeof(unsigned long) * SMMU_PTBL_COUNT)
+#define SMMU_PDIR_SHIFT	12
+#define SMMU_PDE_SHIFT	12
+#define SMMU_PTE_SHIFT	12
+#define SMMU_PFN_MASK	0x000fffff
+
+#define SMMU_ADDR_TO_PFN(addr)	((addr) >> 12)
+#define SMMU_ADDR_TO_PDN(addr)	((addr) >> 22)
+#define SMMU_PDN_TO_ADDR(addr)	((pdn) << 22)
+
+#define _READABLE	(1 << SMMU_PTB_DATA_ASID_READABLE_SHIFT)
+#define _WRITABLE	(1 << SMMU_PTB_DATA_ASID_WRITABLE_SHIFT)
+#define _NONSECURE	(1 << SMMU_PTB_DATA_ASID_NONSECURE_SHIFT)
+#define _PDE_NEXT	(1 << SMMU_PDE_NEXT_SHIFT)
+#define _MASK_ATTR	(_READABLE | _WRITABLE | _NONSECURE)
+
+#define _PDIR_ATTR	(_READABLE | _WRITABLE | _NONSECURE)
+
+#define _PDE_ATTR	(_READABLE | _WRITABLE | _NONSECURE)
+#define _PDE_ATTR_N	(_PDE_ATTR | _PDE_NEXT)
+#define _PDE_VACANT(pdn)	(((pdn) << 10) | _PDE_ATTR)
+
+#define _PTE_ATTR	(_READABLE | _WRITABLE | _NONSECURE)
+#define _PTE_VACANT(addr)	(((addr) >> SMMU_PAGE_SHIFT) | _PTE_ATTR)
+
+#define SMMU_MK_PDIR(page, attr)	\
+		((page_to_phys(page) >> SMMU_PDIR_SHIFT) | (attr))
+#define SMMU_MK_PDE(page, attr)		\
+		(unsigned long)((page_to_phys(page) >> SMMU_PDE_SHIFT) | (attr))
+#define SMMU_EX_PTBL_PAGE(pde)		\
+		pfn_to_page((unsigned long)(pde) & SMMU_PFN_MASK)
+#define SMMU_PFN_TO_PTE(pfn, attr)	(unsigned long)((pfn) | (attr))
+
+#define SMMU_ASID_ENABLE(asid)	((asid) | (1 << 31))
+#define SMMU_ASID_DISABLE	0
+#define SMMU_ASID_ASID(n)	((n) & ~SMMU_ASID_ENABLE(0))
+
+#define smmu_client_enable_hwgrp(c, m)	smmu_client_set_hwgrp(c, m, 1)
+#define smmu_client_disable_hwgrp(c)	smmu_client_set_hwgrp(c, 0, 0)
+#define __smmu_client_enable_hwgrp(c, m) __smmu_client_set_hwgrp(c, m, 1)
+#define __smmu_client_disable_hwgrp(c)	__smmu_client_set_hwgrp(c, 0, 0)
+
+#define HWGRP_INIT(client) [HWGRP_##client] = SMMU_##client##_ASID
+
+static const u32 smmu_hwgrp_asid_reg[] = {
+	HWGRP_INIT(AFI),
+	HWGRP_INIT(AVPC),
+	HWGRP_INIT(DC),
+	HWGRP_INIT(DCB),
+	HWGRP_INIT(EPP),
+	HWGRP_INIT(G2),
+	HWGRP_INIT(HC),
+	HWGRP_INIT(HDA),
+	HWGRP_INIT(ISP),
+	HWGRP_INIT(MPE),
+	HWGRP_INIT(NV),
+	HWGRP_INIT(NV2),
+	HWGRP_INIT(PPCS),
+	HWGRP_INIT(SATA),
+	HWGRP_INIT(VDE),
+	HWGRP_INIT(VI),
+};
+#define HWGRP_ASID_REG(x) (smmu_hwgrp_asid_reg[x])
+
+/*
+ * Per client for address space
+ */
+struct smmu_client {
+	struct device		*dev;
+	struct list_head	list;
+	struct smmu_as		*as;
+	u32			hwgrp;
+};
+
+/*
+ * Per address space
+ */
+struct smmu_as {
+	struct smmu_device	*smmu;	/* back pointer to container */
+	unsigned int		asid;
+	struct mutex		lock;	/* for pagetable */
+	struct page		*pdir_page;
+	unsigned long		pdir_attr;
+	unsigned long		pde_attr;
+	unsigned long		pte_attr;
+	unsigned int		*pte_count;
+
+	struct list_head	client;
+	spinlock_t		client_lock; /* for client list */
+};
+
+/*
+ * Per SMMU device - IOMMU device
+ */
+struct smmu_device {
+	void __iomem	*regs, *regs_ahbarb;
+	unsigned long	iovmm_base;	/* remappable base address */
+	unsigned long	page_count;	/* total remappable size */
+	spinlock_t	lock;
+	char		*name;
+	struct device	*dev;
+	int		num_ases;
+	struct smmu_as	*as;		/* Run-time allocated array */
+	struct page *avp_vector_page;	/* dummy page shared by all AS's */
+
+	/*
+	 * Register image savers for suspend/resume
+	 */
+	unsigned long translation_enable_0;
+	unsigned long translation_enable_1;
+	unsigned long translation_enable_2;
+	unsigned long asid_security;
+};
+
+static struct smmu_device *smmu_handle; /* unique for a system */
+
+/*
+ *	SMMU/AHB register accessors
+ */
+static inline u32 smmu_read(struct smmu_device *smmu, size_t offs)
+{
+	return readl(smmu->regs + offs);
+}
+static inline void smmu_write(struct smmu_device *smmu, u32 val, size_t offs)
+{
+	writel(val, smmu->regs + offs);
+}
+
+static inline u32 ahb_read(struct smmu_device *smmu, size_t offs)
+{
+	return readl(smmu->regs_ahbarb + offs);
+}
+static inline void ahb_write(struct smmu_device *smmu, u32 val, size_t offs)
+{
+	writel(val, smmu->regs_ahbarb + offs);
+}
+
+#define VA_PAGE_TO_PA(va, page)	\
+	(page_to_phys(page) + ((unsigned long)(va) & ~PAGE_MASK))
+
+#define FLUSH_CPU_DCACHE(va, page, size)	\
+	do {	\
+		unsigned long _pa_ = VA_PAGE_TO_PA(va, page);		\
+		__cpuc_flush_dcache_area((void *)(va), (size_t)(size));	\
+		outer_flush_range(_pa_, _pa_+(size_t)(size));		\
+	} while (0)
+
+/*
+ * Any interaction between any block on PPSB and a block on APB or AHB
+ * must have these read-back barriers to ensure the APB/AHB bus
+ * transaction is complete before initiating activity on the PPSB
+ * block.
+ */
+#define FLUSH_SMMU_REGS(smmu)	smmu_read(smmu, SMMU_CONFIG)
+
+#define smmu_client_hwgrp(c) (u32)((c)->dev->platform_data)
+
+static int __smmu_client_set_hwgrp(struct smmu_client *c,
+				   unsigned long map, int on)
+{
+	int i;
+	struct smmu_as *as = c->as;
+	u32 val, offs, mask = SMMU_ASID_ENABLE(as->asid);
+	struct smmu_device *smmu = as->smmu;
+
+	WARN_ON(!on && map);
+	if (on && !map)
+		return -EINVAL;
+	if (!on)
+		map = smmu_client_hwgrp(c);
+
+	for_each_set_bit(i, &map, BITS_PER_LONG) {
+		offs = HWGRP_ASID_REG(i);
+		val = smmu_read(smmu, offs);
+		if (on) {
+			if (WARN_ON(val & mask))
+				goto err_hw_busy;
+			val |= mask;
+		} else {
+			WARN_ON((val & mask) == mask);
+			val &= ~mask;
+		}
+		smmu_write(smmu, val, offs);
+	}
+	FLUSH_SMMU_REGS(smmu);
+	c->hwgrp = map;
+	return 0;
+err_hw_busy:
+	for_each_set_bit(i, &map, BITS_PER_LONG) {
+		offs = HWGRP_ASID_REG(i);
+		val = smmu_read(smmu, offs);
+		val &= ~mask;
+		smmu_write(smmu, val, offs);
+	}
+	return -EBUSY;
+}
+
+static int smmu_client_set_hwgrp(struct smmu_client *c, u32 map, int on)
+{
+	u32 val;
+	struct smmu_as *as = c->as;
+	struct smmu_device *smmu = as->smmu;
+
+	spin_lock(&smmu->lock);
+	val = __smmu_client_set_hwgrp(c, map, on);
+	spin_unlock(&smmu->lock);
+	return val;
+}
+
+/*
+ * Flush all TLB entries and all PTC entries
+ * Caller must lock smmu
+ */
+static void smmu_flush_regs(struct smmu_device *smmu, int enable)
+{
+	u32 val;
+
+	smmu_write(smmu, SMMU_PTC_FLUSH_TYPE_ALL, SMMU_PTC_FLUSH);
+	FLUSH_SMMU_REGS(smmu);
+	val = SMMU_TLB_FLUSH_VA_MATCH_ALL |
+		SMMU_TLB_FLUSH_ASID_MATCH_disable;
+	smmu_write(smmu, val, SMMU_TLB_FLUSH);
+
+	if (enable)
+		smmu_write(smmu, SMMU_CONFIG_ENABLE, SMMU_CONFIG);
+	FLUSH_SMMU_REGS(smmu);
+}
+
+static void smmu_setup_regs(struct smmu_device *smmu)
+{
+	int i;
+	u32 val;
+
+	for (i = 0; i < smmu->num_ases; i++) {
+		struct smmu_as *as = &smmu->as[i];
+		struct smmu_client *c;
+
+		smmu_write(smmu, SMMU_PTB_ASID_CUR(as->asid), SMMU_PTB_ASID);
+		val = as->pdir_page ?
+			SMMU_MK_PDIR(as->pdir_page, as->pdir_attr) :
+			SMMU_PTB_DATA_RESET_VAL;
+		smmu_write(smmu, val, SMMU_PTB_DATA);
+
+		list_for_each_entry(c, &as->client, list)
+			__smmu_client_set_hwgrp(c, c->hwgrp, 1);
+	}
+
+	smmu_write(smmu, smmu->translation_enable_0, SMMU_TRANSLATION_ENABLE_0);
+	smmu_write(smmu, smmu->translation_enable_1, SMMU_TRANSLATION_ENABLE_1);
+	smmu_write(smmu, smmu->translation_enable_2, SMMU_TRANSLATION_ENABLE_2);
+	smmu_write(smmu, smmu->asid_security, SMMU_ASID_SECURITY);
+	smmu_write(smmu, SMMU_TLB_CONFIG_RESET_VAL, SMMU_TLB_CONFIG);
+	smmu_write(smmu, SMMU_PTC_CONFIG_RESET_VAL, SMMU_PTC_CONFIG);
+
+	smmu_flush_regs(smmu, 1);
+
+	val = ahb_read(smmu, AHB_XBAR_CTRL);
+	val |= AHB_XBAR_CTRL_SMMU_INIT_DONE_DONE <<
+		AHB_XBAR_CTRL_SMMU_INIT_DONE_SHIFT;
+	ahb_write(smmu, val, AHB_XBAR_CTRL);
+}
+
+static void flush_ptc_and_tlb(struct smmu_device *smmu,
+		      struct smmu_as *as, dma_addr_t iova,
+		      unsigned long *pte, struct page *page, int is_pde)
+{
+	u32 val;
+	unsigned long tlb_flush_va = is_pde
+		?  SMMU_TLB_FLUSH_VA(iova, SECTION)
+		:  SMMU_TLB_FLUSH_VA(iova, GROUP);
+
+	val = SMMU_PTC_FLUSH_TYPE_ADR | VA_PAGE_TO_PA(pte, page);
+	smmu_write(smmu, val, SMMU_PTC_FLUSH);
+	FLUSH_SMMU_REGS(smmu);
+	val = tlb_flush_va |
+		SMMU_TLB_FLUSH_ASID_MATCH__ENABLE |
+		(as->asid << SMMU_TLB_FLUSH_ASID_SHIFT);
+	smmu_write(smmu, val, SMMU_TLB_FLUSH);
+	FLUSH_SMMU_REGS(smmu);
+}
+
+static void free_ptbl(struct smmu_as *as, dma_addr_t iova)
+{
+	unsigned long pdn = SMMU_ADDR_TO_PDN(iova);
+	unsigned long *pdir = (unsigned long *)kmap(as->pdir_page);
+
+	if (pdir[pdn] != _PDE_VACANT(pdn)) {
+		pr_debug("pdn: %lx\n", pdn);
+
+		ClearPageReserved(SMMU_EX_PTBL_PAGE(pdir[pdn]));
+		__free_page(SMMU_EX_PTBL_PAGE(pdir[pdn]));
+		pdir[pdn] = _PDE_VACANT(pdn);
+		FLUSH_CPU_DCACHE(&pdir[pdn], as->pdir_page, sizeof pdir[pdn]);
+		flush_ptc_and_tlb(as->smmu, as, iova, &pdir[pdn],
+				  as->pdir_page, 1);
+	}
+	kunmap(as->pdir_page);
+}
+
+static void free_pdir(struct smmu_as *as)
+{
+	unsigned addr;
+	int count;
+
+	if (!as->pdir_page)
+		return;
+
+	addr = as->smmu->iovmm_base;
+	count = as->smmu->page_count;
+	while (count-- > 0) {
+		free_ptbl(as, addr);
+		addr += SMMU_PAGE_SIZE * SMMU_PTBL_COUNT;
+	}
+	ClearPageReserved(as->pdir_page);
+	__free_page(as->pdir_page);
+	as->pdir_page = NULL;
+	kfree(as->pte_count);
+	as->pte_count = NULL;
+}
+
+/*
+ * Maps PTBL for given iova and returns the PTE address
+ * Caller must unmap the mapped PTBL returned in *ptbl_page_p
+ */
+static unsigned long *locate_pte(struct smmu_as *as,
+				 dma_addr_t iova, bool allocate,
+				 struct page **ptbl_page_p,
+				 unsigned int **count)
+{
+	unsigned long ptn = SMMU_ADDR_TO_PFN(iova);
+	unsigned long pdn = SMMU_ADDR_TO_PDN(iova);
+	unsigned long *pdir = kmap(as->pdir_page);
+	unsigned long *ptbl;
+
+	if (pdir[pdn] != _PDE_VACANT(pdn)) {
+		/* Mapped entry table already exists */
+		*ptbl_page_p = SMMU_EX_PTBL_PAGE(pdir[pdn]);
+		ptbl = kmap(*ptbl_page_p);
+	} else if (!allocate) {
+		kunmap(as->pdir_page);
+		return NULL;
+	} else {
+		int pn;
+		unsigned long addr = SMMU_PDN_TO_ADDR(pdn);
+
+		/* Vacant - allocate a new page table */
+		pr_debug("New PTBL pdn: %lx\n", pdn);
+
+		*ptbl_page_p = alloc_page(GFP_KERNEL | __GFP_DMA);
+		if (!*ptbl_page_p) {
+			kunmap(as->pdir_page);
+			pr_err("failed to allocate smmu_device page table\n");
+			return NULL;
+		}
+		SetPageReserved(*ptbl_page_p);
+		ptbl = (unsigned long *)kmap(*ptbl_page_p);
+		for (pn = 0; pn < SMMU_PTBL_COUNT;
+		     pn++, addr += SMMU_PAGE_SIZE) {
+			ptbl[pn] = _PTE_VACANT(addr);
+		}
+		FLUSH_CPU_DCACHE(ptbl, *ptbl_page_p, SMMU_PTBL_SIZE);
+		pdir[pdn] = SMMU_MK_PDE(*ptbl_page_p,
+					as->pde_attr | _PDE_NEXT);
+		FLUSH_CPU_DCACHE(&pdir[pdn], as->pdir_page, sizeof pdir[pdn]);
+		flush_ptc_and_tlb(as->smmu, as, iova, &pdir[pdn],
+				  as->pdir_page, 1);
+	}
+	*count = &as->pte_count[pdn];
+
+	kunmap(as->pdir_page);
+	return &ptbl[ptn % SMMU_PTBL_COUNT];
+}
+
+#ifdef CONFIG_SMMU_SIG_DEBUG
+static void put_signature(struct smmu_as *as,
+			  dma_addr_t iova, unsigned long pfn)
+{
+	struct page *page;
+	unsigned long *vaddr;
+
+	page = pfn_to_page(pfn);
+	vaddr = kmap(page);
+	if (!vaddr)
+		return;
+
+	vaddr[0] = iova;
+	vaddr[1] = pfn << PAGE_SHIFT;
+	FLUSH_CPU_DCACHE(vaddr, page, sizeof(vaddr[0]) * 2);
+	kunmap(page);
+}
+#else
+static inline void put_signature(struct smmu_as *as,
+				 unsigned long addr, unsigned long pfn)
+{
+}
+#endif
+
+/*
+ * Caller must lock/unlock as
+ */
+static int alloc_pdir(struct smmu_as *as)
+{
+	unsigned long *pdir;
+	int pdn;
+	u32 val;
+	struct smmu_device *smmu = as->smmu;
+
+	if (as->pdir_page)
+		return 0;
+
+	as->pte_count = kzalloc(sizeof(as->pte_count[0]) * SMMU_PDIR_COUNT,
+				GFP_KERNEL);
+	if (!as->pte_count) {
+		pr_err("failed to allocate smmu_device PTE cunters\n");
+		return -ENOMEM;
+	}
+	as->pdir_page = alloc_page(GFP_KERNEL | __GFP_DMA);
+	if (!as->pdir_page) {
+		pr_err("failed to allocate smmu_device page directory\n");
+		kfree(as->pte_count);
+		as->pte_count = NULL;
+		return -ENOMEM;
+	}
+	SetPageReserved(as->pdir_page);
+	pdir = kmap(as->pdir_page);
+
+	for (pdn = 0; pdn < SMMU_PDIR_COUNT; pdn++)
+		pdir[pdn] = _PDE_VACANT(pdn);
+	FLUSH_CPU_DCACHE(pdir, as->pdir_page, SMMU_PDIR_SIZE);
+	val = SMMU_PTC_FLUSH_TYPE_ADR | VA_PAGE_TO_PA(pdir, as->pdir_page);
+	smmu_write(smmu, val, SMMU_PTC_FLUSH);
+	FLUSH_SMMU_REGS(as->smmu);
+	val = SMMU_TLB_FLUSH_VA_MATCH_ALL |
+		SMMU_TLB_FLUSH_ASID_MATCH__ENABLE |
+		(as->asid << SMMU_TLB_FLUSH_ASID_SHIFT);
+	smmu_write(smmu, val, SMMU_TLB_FLUSH);
+	FLUSH_SMMU_REGS(as->smmu);
+	kunmap(as->pdir_page);
+
+	return 0;
+}
+
+static void __smmu_iommu_unmap(struct smmu_as *as, dma_addr_t iova)
+{
+	unsigned long *pte;
+	struct page *page;
+	unsigned int *count;
+
+	pte = locate_pte(as, iova, false, &page, &count);
+	if (WARN_ON(!pte))
+		return;
+
+	if (WARN_ON(*pte == _PTE_VACANT(iova)))
+		return;
+
+	*pte = _PTE_VACANT(iova);
+	FLUSH_CPU_DCACHE(pte, page, sizeof(*pte));
+	flush_ptc_and_tlb(as->smmu, as, iova, pte, page, 0);
+	kunmap(page);
+	if (!--(*count)) {
+		free_ptbl(as, iova);
+		smmu_flush_regs(as->smmu, 0);
+	}
+}
+
+static void __smmu_iommu_map_pfn(struct smmu_as *as, dma_addr_t iova,
+				 unsigned long pfn)
+{
+	struct smmu_device *smmu = as->smmu;
+	unsigned long *pte;
+	unsigned int *count;
+	struct page *page;
+
+	pte = locate_pte(as, iova, true, &page, &count);
+	if (WARN_ON(!pte))
+		return;
+
+	if (*pte == _PTE_VACANT(iova))
+		(*count)++;
+	*pte = SMMU_PFN_TO_PTE(pfn, as->pte_attr);
+	if (unlikely((*pte == _PTE_VACANT(iova))))
+		(*count)--;
+	FLUSH_CPU_DCACHE(pte, page, sizeof(*pte));
+	flush_ptc_and_tlb(smmu, as, iova, pte, page, 0);
+	kunmap(page);
+	put_signature(as, iova, pfn);
+}
+
+static int smmu_iommu_map(struct iommu_domain *domain, unsigned long iova,
+			  phys_addr_t pa, int order, int prot)
+{
+	unsigned long count = (PAGE_SIZE << order) >> SMMU_PAGE_SHIFT;
+	struct smmu_as *as = domain->priv;
+	unsigned long pfn = __phys_to_pfn(pa);
+	int i;
+
+	pr_debug("[%d] %08lx:%08x(%ld)\n", as->asid, iova, pa, count);
+
+	if (!IS_ALIGNED(iova, PAGE_SIZE))
+		return -EINVAL;
+
+	mutex_lock(&as->lock);
+	for (i = 0; i < count; i++, pfn++) {
+
+		if (!pfn_valid(pfn))
+			goto fail;
+
+		__smmu_iommu_map_pfn(as, iova, pfn);
+		iova += SMMU_PAGE_SIZE;
+	}
+	mutex_unlock(&as->lock);
+	return 0;
+fail:
+	while (--i) {
+		iova -= SMMU_PAGE_SIZE;
+		__smmu_iommu_unmap(as, iova);
+	}
+	mutex_unlock(&as->lock);
+	return -ENOMEM;
+}
+
+static int smmu_iommu_unmap(struct iommu_domain *domain, unsigned long iova,
+			    int gfp_order)
+{
+	struct smmu_as *as = domain->priv;
+	unsigned long count = (PAGE_SIZE << gfp_order) >> SMMU_PAGE_SHIFT;
+	int i;
+
+	pr_debug("[%d] %08lx(%ld)\n", as->asid, iova, count);
+
+	mutex_lock(&as->lock);
+	for (i = 0; i < count; i++) {
+		__smmu_iommu_unmap(as, iova);
+		iova += SMMU_PAGE_SIZE;
+	}
+	mutex_unlock(&as->lock);
+	return 0;
+}
+
+static phys_addr_t smmu_iommu_iova_to_phys(struct iommu_domain *domain,
+					   unsigned long iova)
+{
+	struct smmu_as *as = domain->priv;
+	unsigned long *pte;
+	unsigned int *count;
+	struct page *page;
+	unsigned long pfn;
+
+	if (!IS_ALIGNED(iova, PAGE_SIZE))
+		return -EINVAL;
+
+	mutex_lock(&as->lock);
+
+	pte = locate_pte(as, iova, true, &page, &count);
+	pfn = *pte & SMMU_PFN_MASK;
+	WARN_ON(!pfn_valid(pfn));
+	pr_debug("iova:%08lx pfn:%08lx asid:%d\n", iova, pfn, as->asid);
+
+	mutex_unlock(&as->lock);
+	return PFN_PHYS(pfn);
+}
+
+static int smmu_iommu_domain_has_cap(struct iommu_domain *domain,
+				     unsigned long cap)
+{
+	return 0;
+}
+
+static int smmu_iommu_domain_init(struct iommu_domain *domain)
+{
+	int i;
+	struct smmu_as *as;
+	struct smmu_device *smmu = smmu_handle;
+
+	/* Look for a free AS with lock held */
+	for  (i = 0; i < smmu->num_ases; i++) {
+		struct smmu_as *tmp = &smmu->as[i];
+
+		mutex_lock(&tmp->lock);
+		if (!tmp->pdir_page) {
+			as = tmp;
+			goto found;
+		}
+		mutex_unlock(&tmp->lock);
+	}
+	pr_err("no free AS\n");
+	return -ENODEV;
+
+found:
+	if (alloc_pdir(as) < 0)
+		goto err_alloc_pdir;
+
+	spin_lock(&smmu->lock);
+
+	/* Update PDIR register */
+	smmu_write(smmu, SMMU_PTB_ASID_CUR(as->asid), SMMU_PTB_ASID);
+	smmu_write(smmu,
+		   SMMU_MK_PDIR(as->pdir_page, as->pdir_attr), SMMU_PTB_DATA);
+	FLUSH_SMMU_REGS(smmu);
+
+	spin_unlock(&smmu->lock);
+
+	mutex_unlock(&as->lock);
+	domain->priv = as;
+	pr_debug("smmu_as@%p\n", as);
+	return 0;
+err_alloc_pdir:
+	mutex_unlock(&as->lock);
+	return -ENODEV;
+}
+
+static void smmu_iommu_domain_destroy(struct iommu_domain *domain)
+{
+	struct smmu_as *as = domain->priv;
+	struct smmu_device *smmu = as->smmu;
+
+	mutex_lock(&as->lock);
+
+	if (as->pdir_page) {
+		spin_lock(&smmu->lock);
+		smmu_write(smmu, SMMU_PTB_ASID_CUR(as->asid), SMMU_PTB_ASID);
+		smmu_write(smmu, SMMU_PTB_DATA_RESET_VAL, SMMU_PTB_DATA);
+		FLUSH_SMMU_REGS(smmu);
+		spin_unlock(&smmu->lock);
+
+		free_pdir(as);
+	}
+
+	if (!list_empty(&as->client)) {
+		struct smmu_client *c;
+
+		list_for_each_entry(c, &as->client, list)
+			pr_err("%s is still attached\n", dev_name(c->dev));
+	}
+
+	mutex_unlock(&as->lock);
+
+	domain->priv = NULL;
+	pr_debug("smmu_as@%p\n", as);
+}
+
+static int smmu_iommu_attach_dev(struct iommu_domain *domain,
+				 struct device *dev)
+{
+	struct smmu_as *as = domain->priv;
+	struct smmu_client *client, *c;
+	u32 map;
+	int err;
+
+	client = kmalloc(sizeof(*c), GFP_KERNEL);
+	if (!client)
+		return -ENOMEM;
+	client->dev = dev;
+	client->as = as;
+	map = (unsigned long)dev->platform_data;
+	if (!map)
+		return -EINVAL;
+
+	err = smmu_client_enable_hwgrp(client, map);
+	if (err)
+		goto err_hwgrp;
+
+	spin_lock(&as->client_lock);
+	list_for_each_entry(c, &as->client, list) {
+		if (c->dev == dev) {
+			pr_err("%s is already attached\n", dev_name(dev));
+			err = -EINVAL;
+			goto err_client;
+		}
+	}
+	list_add(&client->list, &as->client);
+	spin_unlock(&as->client_lock);
+
+	/*
+	 * Reserve "page zero" for AVP vectors using a common dummy
+	 * page.
+	 */
+	if (map & HWG_AVPC) {
+		struct page *page;
+
+		page = as->smmu->avp_vector_page;
+		__smmu_iommu_map_pfn(as, 0, page_to_pfn(page));
+
+		pr_info("Reserve \"page zero\" for AVP vectors using a common dummy\n");
+	}
+
+	pr_debug("Attached %s\n", dev_name(dev));
+	return 0;
+err_client:
+	smmu_client_disable_hwgrp(client);
+	spin_unlock(&as->client_lock);
+err_hwgrp:
+	kfree(client);
+	return err;
+}
+
+static void smmu_iommu_detach_dev(struct iommu_domain *domain,
+				  struct device *dev)
+{
+	struct smmu_as *as = domain->priv;
+	struct smmu_client *c;
+
+	spin_lock(&as->client_lock);
+
+	list_for_each_entry(c, &as->client, list) {
+		if (c->dev == dev) {
+			smmu_client_disable_hwgrp(c);
+			list_del(&c->list);
+			c->as = NULL;
+			pr_debug("Detached %s\n", dev_name(dev));
+			goto out;
+		}
+	}
+	pr_err("Couldn't find %s\n", dev_name(dev));
+out:
+	spin_unlock(&as->client_lock);
+}
+
+static struct iommu_ops smmu_iommu_ops = {
+	.domain_init	= smmu_iommu_domain_init,
+	.domain_destroy	= smmu_iommu_domain_destroy,
+	.attach_dev	= smmu_iommu_attach_dev,
+	.detach_dev	= smmu_iommu_detach_dev,
+	.map		= smmu_iommu_map,
+	.unmap		= smmu_iommu_unmap,
+	.iova_to_phys	= smmu_iommu_iova_to_phys,
+	.domain_has_cap	= smmu_iommu_domain_has_cap,
+};
+
+static int smmu_iommu_suspend(struct device *dev)
+{
+	struct smmu_device *smmu = dev_get_drvdata(dev);
+
+	smmu->translation_enable_0 = smmu_read(smmu, SMMU_TRANSLATION_ENABLE_0);
+	smmu->translation_enable_1 = smmu_read(smmu, SMMU_TRANSLATION_ENABLE_1);
+	smmu->translation_enable_2 = smmu_read(smmu, SMMU_TRANSLATION_ENABLE_2);
+	smmu->asid_security = smmu_read(smmu, SMMU_ASID_SECURITY);
+	return 0;
+}
+
+static int smmu_iommu_resume(struct device *dev)
+{
+	struct smmu_device *smmu = dev_get_drvdata(dev);
+
+	spin_lock(&smmu->lock);
+	smmu_setup_regs(smmu);
+	spin_unlock(&smmu->lock);
+	return 0;
+}
+
+static int smmu_iommu_probe(struct platform_device *pdev)
+{
+	struct smmu_device *smmu;
+	struct resource *regs, *regs2, *window;
+	int i, err = 0;
+
+	BUILD_BUG_ON(PAGE_SHIFT != SMMU_PAGE_SHIFT);
+
+	regs = platform_get_resource_byname(pdev, IORESOURCE_MEM, "mc");
+	regs2 = platform_get_resource_byname(pdev, IORESOURCE_MEM, "ahbarb");
+	window = platform_get_resource_byname(pdev, IORESOURCE_MEM, "iovm");
+	if (!regs || !regs2 || !window) {
+		pr_err("No SMMU resources\n");
+		return -ENODEV;
+	}
+
+	smmu = kzalloc(sizeof(*smmu), GFP_KERNEL);
+	if (!smmu) {
+		pr_err("failed to allocate smmu_device\n");
+		return -ENOMEM;
+	}
+
+	smmu->num_ases = SMMU_NUM_ASIDS;
+	smmu->iovmm_base = (dma_addr_t)window->start;
+	smmu->page_count = resource_size(window) >> SMMU_PAGE_SHIFT;
+	smmu->regs = ioremap(regs->start, resource_size(regs));
+	smmu->regs_ahbarb = ioremap(regs2->start, resource_size(regs2));
+	if (!smmu->regs || !smmu->regs_ahbarb) {
+		pr_err("failed to remap SMMU registers\n");
+		err = -ENXIO;
+		goto fail;
+	}
+
+	smmu->translation_enable_0 = ~0;
+	smmu->translation_enable_1 = ~0;
+	smmu->translation_enable_2 = ~0;
+	smmu->asid_security = 0;
+
+	smmu->as = kzalloc(sizeof(smmu->as[0]) * smmu->num_ases, GFP_KERNEL);
+	if (!smmu->as) {
+		pr_err("failed to allocate smmu_as\n");
+		err = -ENOMEM;
+		goto fail;
+	}
+
+	for (i = 0; i < smmu->num_ases; i++) {
+		struct smmu_as *as = &smmu->as[i];
+
+		as->smmu = smmu;
+		as->asid = i;
+		as->pdir_attr = _PDIR_ATTR;
+		as->pde_attr = _PDE_ATTR;
+		as->pte_attr = _PTE_ATTR;
+
+		mutex_init(&as->lock);
+		INIT_LIST_HEAD(&as->client);
+	}
+	spin_lock_init(&smmu->lock);
+	smmu_setup_regs(smmu);
+	platform_set_drvdata(pdev, smmu);
+	smmu_handle = smmu;
+
+	smmu->avp_vector_page = alloc_page(GFP_KERNEL);
+	if (!smmu->avp_vector_page)
+		goto fail;
+	return 0;
+fail:
+	if (smmu->avp_vector_page)
+		__free_page(smmu->avp_vector_page);
+	if (smmu->regs)
+		iounmap(smmu->regs);
+	if (smmu->regs_ahbarb)
+		iounmap(smmu->regs_ahbarb);
+	if (smmu && smmu->as) {
+		for (i = 0; i < smmu->num_ases; i++) {
+			if (smmu->as[i].pdir_page) {
+				ClearPageReserved(smmu->as[i].pdir_page);
+				__free_page(smmu->as[i].pdir_page);
+			}
+		}
+		kfree(smmu->as);
+	}
+	kfree(smmu);
+	return err;
+}
+
+static int smmu_iommu_remove(struct platform_device *pdev)
+{
+	struct smmu_device *smmu = platform_get_drvdata(pdev);
+
+	smmu_write(smmu, SMMU_CONFIG_DISABLE, SMMU_CONFIG);
+	platform_set_drvdata(pdev, NULL);
+	if (smmu->as) {
+		int i;
+
+		for (i = 0; i < smmu->num_ases; i++)
+			free_pdir(&smmu->as[i]);
+		kfree(smmu->as);
+	}
+	if (smmu->avp_vector_page)
+		__free_page(smmu->avp_vector_page);
+	if (smmu->regs)
+		iounmap(smmu->regs);
+	if (smmu->regs_ahbarb)
+		iounmap(smmu->regs_ahbarb);
+	kfree(smmu);
+	smmu_handle = NULL;
+	return 0;
+}
+
+const struct dev_pm_ops smmu_iommu_pm_ops = {
+	.suspend	= smmu_iommu_suspend,
+	.resume		= smmu_iommu_resume,
+};
+
+static struct platform_driver smmu_iommu_driver = {
+	.probe		= smmu_iommu_probe,
+	.remove		= smmu_iommu_remove,
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= "smmu-iommu",
+		.pm	= &smmu_iommu_pm_ops,
+	},
+};
+
+static int __devinit smmu_iommu_init(void)
+{
+	bus_set_iommu(&platform_bus_type, &smmu_iommu_ops);
+	return platform_driver_register(&smmu_iommu_driver);
+}
+
+static void __exit smmu_iommu_exit(void)
+{
+	platform_driver_unregister(&smmu_iommu_driver);
+}
+
+subsys_initcall(smmu_iommu_init);
+module_exit(smmu_iommu_exit);
-- 
1.7.5.4

