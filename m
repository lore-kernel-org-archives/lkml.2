Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758805Ab2FUIah (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 04:30:37 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4957 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758736Ab2FUIad convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 04:30:33 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 21 Jun 2012 01:30:31 -0700
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
CC: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
Date: Thu, 21 Jun 2012 10:30:23 +0200
Subject: [v2 1/5] iommu: Add DMA window parser, of_get_dma_window()
Thread-Topic: [v2 1/5] iommu: Add DMA window parser, of_get_dma_window()
Thread-Index: Ac1PiB3EgfQvPVkPTdiUpXZQexAISA==
Message-ID: <20120621.113023.1324461719984328307.hdoyu@nvidia.com>
References: <4FE20457.8090307@wwwdotorg.org><20120621.094611.2108645748323641310.hdoyu@nvidia.com><4FE2C5F3.1010007@wwwdotorg.org>
In-Reply-To: <4FE2C5F3.1010007@wwwdotorg.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-nvconfidentiality: public
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi DOYU <hdoyu@nvidia.com>

This code was based on:
    "arch/microblaze/kernel/prom_parse.c"
    "arch/powerpc/kernel/prom_parse.c"

Can replace "of_parse_dma_window()" in the above. This supports
different formats flexibly. "prefix" can be configured if any. "busno"
and "index" are optionally specified. Set NULL and 0 if not used.

Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
---
Update:
Move of_get_dma_window() in drivers/iommu/of_iommu.c

Based on the discussion:
http://marc.info/?l=linux-tegra&m=133732046606458&w=2
---
 drivers/iommu/Kconfig    |    4 ++
 drivers/iommu/Makefile   |    1 +
 drivers/iommu/of_iommu.c |   90 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/of_iommu.h |   21 +++++++++++
 4 files changed, 116 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index 3408937..4826af6 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -13,6 +13,10 @@ menuconfig IOMMU_SUPPORT
 
 if IOMMU_SUPPORT
 
+config OF_IOMMU
+       def_bool y
+       depends on OF
+
 # MSM IOMMU support
 config MSM_IOMMU
 	bool "MSM IOMMU Support"
diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index 76e54ef..14a4d5f 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -1,4 +1,5 @@
 obj-$(CONFIG_IOMMU_API) += iommu.o
+obj-$(CONFIG_OF_IOMMU)	+= of_iommu.o
 obj-$(CONFIG_MSM_IOMMU) += msm_iommu.o msm_iommu_dev.o
 obj-$(CONFIG_AMD_IOMMU) += amd_iommu.o amd_iommu_init.o
 obj-$(CONFIG_AMD_IOMMU_V2) += amd_iommu_v2.o
diff --git a/drivers/iommu/of_iommu.c b/drivers/iommu/of_iommu.c
new file mode 100644
index 0000000..ee249bc
--- /dev/null
+++ b/drivers/iommu/of_iommu.c
@@ -0,0 +1,90 @@
+/*
+ * OF helpers for IOMMU
+ *
+ * Copyright (c) 2012, NVIDIA CORPORATION.  All rights reserved.
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
+#include <linux/export.h>
+#include <linux/limits.h>
+#include <linux/of.h>
+
+/**
+ * of_get_dma_window - Parse *dma-window property and returns 0 if found.
+ *
+ * @dn: device node
+ * @prefix: prefix for property name if any
+ * @index: index to start to parse
+ * @busno: Returns busno if supported. Otherwise pass NULL
+ * @addr: Returns address that DMA starts
+ * @size: Returns the range that DMA can handle
+ *
+ * This supports different formats flexibly. "prefix" can be
+ * configured if any. "busno" and "index" are optionally
+ * specified. Set 0(or NULL) if not used.
+ */
+int of_get_dma_window(struct device_node *dn, const char *prefix, int index,
+		      unsigned long *busno, dma_addr_t *addr, size_t *size)
+{
+	const __be32 *dma_window, *end;
+	int bytes, cur_index = 0;
+	char propname[NAME_MAX], addrname[NAME_MAX], sizename[NAME_MAX];
+
+	if (!dn || !addr || !size)
+		return -EINVAL;
+
+	if (!prefix)
+		prefix = "";
+
+	snprintf(propname, sizeof(propname), "%sdma-window", prefix);
+	snprintf(addrname, sizeof(addrname), "%s#dma-address-cells", prefix);
+	snprintf(sizename, sizeof(sizename), "%s#dma-size-cells", prefix);
+
+	dma_window = of_get_property(dn, propname, &bytes);
+	if (!dma_window)
+		return -ENODEV;
+	end = dma_window + bytes / sizeof(*dma_window);
+
+	while (dma_window < end) {
+		u32 cells;
+		const void *prop;
+
+		/* busno is one cell if supported */
+		if (busno)
+			*busno = be32_to_cpup(dma_window++);
+
+		prop = of_get_property(dn, addrname, NULL);
+		if (!prop)
+			prop = of_get_property(dn, "#address-cells", NULL);
+
+		cells = prop ? be32_to_cpup(prop) : of_n_addr_cells(dn);
+		if (!cells)
+			return -EINVAL;
+		*addr = of_read_number(dma_window, cells);
+		dma_window += cells;
+
+		prop = of_get_property(dn, sizename, NULL);
+		cells = prop ? be32_to_cpup(prop) : of_n_size_cells(dn);
+		if (!cells)
+			return -EINVAL;
+		*size = of_read_number(dma_window, cells);
+		dma_window += cells;
+
+		if (cur_index++ == index)
+			break;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(of_get_dma_window);
diff --git a/include/linux/of_iommu.h b/include/linux/of_iommu.h
new file mode 100644
index 0000000..51a560f
--- /dev/null
+++ b/include/linux/of_iommu.h
@@ -0,0 +1,21 @@
+#ifndef __OF_IOMMU_H
+#define __OF_IOMMU_H
+
+#ifdef CONFIG_OF_IOMMU
+
+extern int of_get_dma_window(struct device_node *dn, const char *prefix,
+			     int index, unsigned long *busno, dma_addr_t *addr,
+			     size_t *size);
+
+#else
+
+static inline int of_get_dma_window(struct device_node *dn, const char *prefix,
+			    int index, unsigned long *busno, dma_addr_t *addr,
+			    size_t *size)
+{
+	return -EINVAL;
+}
+
+#endif	/* CONFIG_OF_IOMMU */
+
+#endif /* __OF_IOMMU_H */
-- 
1.7.5.4
