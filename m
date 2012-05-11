Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab2EKFIG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 01:08:06 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5463 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692Ab2EKFIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 01:08:04 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 10 May 2012 22:08:00 -0700
From: Hiroshi DOYU <hdoyu@nvidia.com>
To: <hdoyu@nvidia.com>
CC: <linux-tegra@vger.kernel.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] dt: Add general DMA window parser
Date: Fri, 11 May 2012 08:07:53 +0300
Message-ID: <1336712873-32244-1-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code was based on:
	"arch/microblaze/kernel/prom_parse.c"
	"arch/powerpc/kernel/prom_parse.c"

"ibm," prefix could be supported with some modification.

Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>
---
 drivers/of/Kconfig         |    4 ++
 drivers/of/Makefile        |    1 +
 drivers/of/of_dma.c        |   70 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/of_address.h |   13 ++++++++
 4 files changed, 88 insertions(+), 0 deletions(-)

diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
index dfba3e6..3b0298b 100644
--- a/drivers/of/Kconfig
+++ b/drivers/of/Kconfig
@@ -83,4 +83,8 @@ config OF_MTD
 	depends on MTD
 	def_bool y
 
+config OF_DMA
+	depends on HAS_DMA
+	def_bool y
+
 endmenu # OF
diff --git a/drivers/of/Makefile b/drivers/of/Makefile
index e027f44..711ff5b 100644
--- a/drivers/of/Makefile
+++ b/drivers/of/Makefile
@@ -11,3 +11,4 @@ obj-$(CONFIG_OF_MDIO)	+= of_mdio.o
 obj-$(CONFIG_OF_PCI)	+= of_pci.o
 obj-$(CONFIG_OF_PCI_IRQ)  += of_pci_irq.o
 obj-$(CONFIG_OF_MTD)	+= of_mtd.o
+obj-$(CONFIG_OF_DMA)	+= of_dma.o
diff --git a/drivers/of/of_dma.c b/drivers/of/of_dma.c
new file mode 100644
index 0000000..a89fe61
--- /dev/null
+++ b/drivers/of/of_dma.c
@@ -0,0 +1,70 @@
+/*
+ * Copyright (c) 2012, NVIDIA CORPORATION.  All rights reserved.
+ *
+ * Based on:
+ *	"arch/microblaze/kernel/prom_parse.c"
+ *	"arch/powerpc/kernel/prom_parse.c"
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#include <linux/export.h>
+#include <linux/of_address.h>
+
+int of_get_dma_window(struct device_node *dn,
+			const char *propname, int index,
+			unsigned long *busno,
+			dma_addr_t *addr, size_t *size)
+{
+	const __be32 *dma_window, *end;
+	int bytes, cur_index = 0;
+
+	if (!dn || !addr || !size)
+		return -EINVAL;
+
+	if (!propname)
+		propname = "dma-window";
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
+		/* busno is always one cell */
+		if (busno)
+			*busno = be32_to_cpup(dma_window++);
+
+		prop = of_get_property(dn, "#dma-address-cells", NULL);
+		if (!prop)
+			prop = of_get_property(dn, "#address-cells", NULL);
+
+		cells = prop ? be32_to_cpup(prop) : of_n_addr_cells(dn);
+		if (!cells)
+			return -EINVAL;
+		*addr = of_read_number(dma_window, cells);
+		dma_window += cells;
+
+		prop = of_get_property(dn, "#dma-size-cells", NULL);
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
+EXPORT_SYMBOL(of_get_dma_window);
diff --git a/include/linux/of_address.h b/include/linux/of_address.h
index 01b925a..9d9da9d 100644
--- a/include/linux/of_address.h
+++ b/include/linux/of_address.h
@@ -21,6 +21,11 @@ extern void __iomem *of_iomap(struct device_node *device, int index);
 extern const u32 *of_get_address(struct device_node *dev, int index,
 			   u64 *size, unsigned int *flags);
 
+extern int of_get_dma_window(struct device_node *dev,
+			       const char *propname, int index,
+			       unsigned long *busno,
+			       dma_addr_t *phys, size_t *size);
+
 #ifndef pci_address_to_pio
 static inline unsigned long pci_address_to_pio(phys_addr_t addr) { return -1; }
 #define pci_address_to_pio pci_address_to_pio
@@ -48,6 +53,14 @@ static inline const u32 *of_get_address(struct device_node *dev, int index,
 {
 	return NULL;
 }
+
+extern int of_get_dma_window(struct device_node *dev,
+			       const char *propname, int index,
+			       unsigned long *busno,
+			       dma_addr_t *phys, size_t *size)
+{
+	return 0;
+}
 #endif /* CONFIG_OF_ADDRESS */
 
 
-- 
1.7.5.4

