Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757088Ab2AEHRc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 02:17:32 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13920 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab2AEHR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 02:17:28 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 04 Jan 2012 23:17:21 -0800
Date: Thu, 5 Jan 2012 09:17:18 +0200
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: Hiroshi Doyu <hdoyu@nvidia.com>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-mm-sig-bounces@lists.linaro.org" 
	<linaro-mm-sig-bounces@lists.linaro.org>
Subject: Re: [PATCH v3 0/2] ARM: IOMMU: tegra: Add iommu_ops for GART/SMMU
 driver
Message-ID: <20120105091718.3fb378b2a1d390f9dd63c396@nvidia.com>
In-Reply-To: <1325747509-29665-1-git-send-email-hdoyu@nvidia.com>
References: <1325747509-29665-1-git-send-email-hdoyu@nvidia.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jan 2012 08:11:47 +0100
Hiroshi Doyu <hdoyu@nvidia.com> wrote:

> This patchset adds support for IOMMU API for Tegra20(GART) and
> Tegra30(SMMU). "struct iommu_ops" are implemented for both H/W IOMMU
> modules.
> 
> Tested with "Ion memory manager" and "DMA mapping API"(*1).

Just for DMA mapping test from MPU side, the following one is used.

>From a7a163c29694c056e020ba9200648120498e1764 Mon Sep 17 00:00:00 2001
From: Hiroshi DOYU <hdoyu@nvidia.com>
Date: Thu, 15 Dec 2011 13:24:24 +0200
Subject: [PATCH 1/1] [NOT-FOR-MERGE] TEST: Simple dma-iommu-mapping API TEST
 module

This is not posted to merge but this is necessary to understand how
SMMU/GART works with DMA(-iommu-mapping-)API.

This is a test to verify DMA API(DMA iommu mapping API), where SoC
specific iommu_ops is used internally.

This does alloc/(un)map/free, but there's no actual access from device
side since it requires device specific communications.

Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
---
 drivers/iommu/dmaapi-test.c |  193 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 193 insertions(+), 0 deletions(-)
 create mode 100644 drivers/iommu/dmaapi-test.c

diff --git a/drivers/iommu/dmaapi-test.c b/drivers/iommu/dmaapi-test.c
new file mode 100644
index 0000000..f386249
--- /dev/null
+++ b/drivers/iommu/dmaapi-test.c
@@ -0,0 +1,193 @@
+/*
+ * DMA IOMMU mapping API test module
+ *
+ * Copyright (c) 2012, NVIDIA CORPORATION.  All rights reserved.
+ *
+ * Author: Krishna Reddy <vdumpa@nvidia.com>,
+ *	Hiroshi DOYU <hdoyu@nvidia.com>
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
+#define DEBUG
+#define pr_fmt(fmt)	KBUILD_MODNAME ":" fmt
+
+#include <linux/module.h>
+#include <linux/dma-mapping.h>
+#include <linux/kthread.h>
+#include <linux/delay.h>
+#include <linux/highmem.h>
+#include <linux/pfn.h>
+#include <linux/dma-mapping.h>
+#include <linux/platform_device.h>
+
+#include <mach/iomap.h>
+#include <mach/smmu.h>
+
+#include <asm/dma-iommu.h>
+
+#include "devices.h"
+
+/* FIXME: 2x and 3x should be supported at once */
+#ifdef CONFIG_ARCH_TEGRA_2x_SOC
+#define IOVA_START	TEGRA_GART_BASE
+#define IOVA_SIZE	TEGRA_GART_SIZE
+static struct platform_device *tegra_iommu_device = &tegra_gart_device;
+#elif CONFIG_ARCH_TEGRA_3x_SOC
+#define IOVA_START	TEGRA_SMMU_BASE
+#define IOVA_SIZE	TEGRA_SMMU_SIZE
+static struct platform_device *tegra_iommu_device = &tegra_smmu_device;
+#else
+#error Unsupported device
+#endif
+
+#define NUM_TEST	3
+#define MAP_SIZE	(4 * PAGE_SIZE)
+
+struct dmaapi_test_case {
+	char *name;
+	void (*fn)(struct device *);
+};
+
+static void dmaapi_test_map_page(struct device *dev)
+{
+	struct page *page;
+	dma_addr_t dma_addr;
+	void *cpu_addr;
+
+	page = alloc_page(GFP_KERNEL);
+	BUG_ON(!page);
+
+	dma_addr = dma_map_page(dev, page, 0, PAGE_SIZE, DMA_TO_DEVICE);
+	BUG_ON(!dma_addr);
+
+	cpu_addr = kmap(page);
+	BUG_ON(!cpu_addr);
+	memset(cpu_addr, 0xa5, PAGE_SIZE);
+	kunmap(cpu_addr);
+
+	pr_debug("pid:%d,%s mapped\t%08x:%08x\n",
+		 current->pid, dev_name(dev), dma_addr, page_to_phys(page));
+
+	dma_unmap_page(dev, dma_addr, PAGE_SIZE, DMA_TO_DEVICE);
+	__free_page(page);
+}
+
+static void dmaapi_test_alloc_coherent(struct device *dev)
+{
+	dma_addr_t da[NUM_TEST];
+	void *va[NUM_TEST];
+	int i;
+
+	for (i = 0; i < NUM_TEST; i++) {
+		void *cpu_addr;
+		dma_addr_t dma_addr;
+
+		cpu_addr = dma_alloc_coherent(dev, MAP_SIZE,
+					      &dma_addr, GFP_KERNEL);
+		BUG_ON(!cpu_addr);
+		memset(cpu_addr, 0xa5, MAP_SIZE);
+
+		pr_debug("pid:%d,%s,[%d] mapped\t%08x:%08x\n",
+			 current->pid, dev_name(dev), i,
+			 dma_addr, virt_to_phys(cpu_addr));
+
+		da[i] = dma_addr;
+		va[i] = cpu_addr;
+	}
+
+	while (--i >= 0) {
+		pr_debug("pid:%d,%s,[%d] unmapping\t%08x:%08x\n",
+			 current->pid, dev_name(dev), i,
+			 da[i], virt_to_phys(va[i]));
+		dma_free_coherent(dev, MAP_SIZE, va[i], da[i]);
+	}
+}
+
+static struct dmaapi_test_case test[] = {
+	{
+		.name = "dmaapi/map page",
+		.fn = dmaapi_test_map_page,
+	},
+	{
+		.name = "dmaapi/alloc coherent",
+		.fn = dmaapi_test_alloc_coherent,
+	},
+};
+
+static u32 dummy_hwgrp_map[] = {
+	HWG_DC | HWG_AFI | HWG_AVPC | HWG_DCB,
+	HWG_EPP | HWG_HC | HWG_G2 | HWG_MPE | HWG_HDA | HWG_ISP,
+	HWG_NV | HWG_PPCS | HWG_SATA | HWG_NV2 | HWG_VI | HWG_VDE,
+};
+
+/* FIXME: Need driver for iommu context? */
+static struct platform_device dmaapi_dummy_device[] = {
+	{ .name = "hwgrp@a", .id = -1, },
+	{ .name = "hwgrp@b", .id = -1, },
+	{ .name = "hwgrp@c", .id = -1, },
+};
+
+static int dmaapi_test_thread(void *data)
+{
+	int i;
+	struct dmaapi_test_case *c = data;
+
+	for (i = 0; true; i++) {
+		struct device *dev;
+		int interval[] = {7, 3, 5,};
+		int n;
+
+		n = i % ARRAY_SIZE(dmaapi_dummy_device);
+		ssleep(interval[n]);
+		dev = &dmaapi_dummy_device[n].dev;
+		c->fn(dev);
+	}
+	return 0;
+}
+
+static int __init dmaapi_test_init(void)
+{
+	int i;
+	struct dma_iommu_mapping *map;
+
+	map = arm_iommu_create_mapping(IOVA_START, IOVA_SIZE, 0);
+	BUG_ON(!map);
+	pr_debug("Allocate IOVA: %08x-%08x\n", map->base, map->base + IOVA_SIZE);
+
+	for (i = 0; i < ARRAY_SIZE(dmaapi_dummy_device); i++) {
+		int err;
+		struct platform_device *pdev = &dmaapi_dummy_device[i];
+
+		pdev->dev.platform_data = (void *)dummy_hwgrp_map[i];
+		pdev->dev.parent = &tegra_iommu_device->dev;
+		err = platform_device_register(pdev);
+		BUG_ON(err);
+
+		err = arm_iommu_attach_device(&pdev->dev, map);
+		BUG_ON(err);
+		pr_debug("IOMMU API: Attached to %s\n", dev_name(&pdev->dev));
+	}
+
+	for (i = 0; i < ARRAY_SIZE(test); i++)
+		kthread_run(dmaapi_test_thread, &test[i], test[i].name);
+
+	return 0;
+}
+module_init(dmaapi_test_init);
+
+MODULE_AUTHOR("Krishna Reddy <vdumpa@nvidia.com>");
+MODULE_AUTHOR("Hiroshi DOYU <hdoyu@nvidia.com>");
+MODULE_DESCRIPTION("DMA IOMMU mapping API test");
+MODULE_LICENSE("GPL v2");
-- 
1.7.5.4

