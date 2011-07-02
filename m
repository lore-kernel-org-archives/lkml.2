Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779Ab1GBVUN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 17:20:13 -0400
Received: from mail.southpole.se ([193.12.106.18]:45881 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087Ab1GBVQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 17:16:16 -0400
From: Jonas Bonn <jonas@southpole.se>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Jonas Bonn <jonas@southpole.se>
Subject: [PATCH v2 07/19] OpenRISC: DMA
Date: Sat,  2 Jul 2011 23:15:40 +0200
Message-Id: <1309641352-18714-8-git-send-email-jonas@southpole.se>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309641352-18714-1-git-send-email-jonas@southpole.se>
References: <1309641352-18714-1-git-send-email-jonas@southpole.se>
X-Assp-Client-SSL: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Simple DMA implementation.  Allows for allocation of coherent memory
(simply uncached) for DMA operations.

Signed-off-by: Jonas Bonn <jonas@southpole.se>
---
 arch/openrisc/include/asm/dma-mapping.h |   62 ++++++++++++++++++++++
 arch/openrisc/kernel/dma.c              |   86 +++++++++++++++++++++++++++++++
 2 files changed, 148 insertions(+), 0 deletions(-)
 create mode 100644 arch/openrisc/include/asm/dma-mapping.h
 create mode 100644 arch/openrisc/kernel/dma.c

diff --git a/arch/openrisc/include/asm/dma-mapping.h b/arch/openrisc/include/asm/dma-mapping.h
new file mode 100644
index 0000000..3d68ed8
--- /dev/null
+++ b/arch/openrisc/include/asm/dma-mapping.h
@@ -0,0 +1,62 @@
+/*
+ * OpenRISC Linux
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * OpenRISC implementation:
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __ASM_OPENRISC_DMA_MAPPING_H
+#define __ASM_OPENRISC_DMA_MAPPING_H
+
+/*
+ * See Documentation/PCI/PCI-DMA-mapping.txt and
+ * Documentation/DMA-API.txt for documentation.
+ */
+
+#include <linux/dma-debug.h>
+#include <asm-generic/dma-coherent.h>
+
+#define DMA_ERROR_CODE		(~(dma_addr_t)0x0)
+
+int dma_mapping_error(struct device *dev, dma_addr_t dma_addr);
+
+int dma_supported(struct device *dev, u64 mask);
+
+int dma_set_mask(struct device *dev, u64 mask);
+
+#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
+#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
+
+void *or1k_dma_alloc_coherent(struct device *dev, size_t size,
+			      dma_addr_t *dma_handle, gfp_t flag);
+void or1k_dma_free_coherent(struct device *dev, size_t size, void *vaddr,
+			    dma_addr_t dma_handle);
+
+static inline void *dma_alloc_coherent(struct device *dev, size_t size,
+					dma_addr_t *dma_handle, gfp_t flag)
+{
+	void *memory;
+
+	memory = or1k_dma_alloc_coherent(dev, size, dma_handle, flag);
+
+	debug_dma_alloc_coherent(dev, size, *dma_handle, memory);
+	return memory;
+}
+
+static inline void dma_free_coherent(struct device *dev, size_t size,
+				     void *cpu_addr, dma_addr_t dma_handle)
+{
+	debug_dma_free_coherent(dev, size, cpu_addr, dma_handle);
+	or1k_dma_free_coherent(dev, size, cpu_addr, dma_handle);
+}
+
+#endif	/* __ASM_OPENRISC_DMA_MAPPING_H */
diff --git a/arch/openrisc/kernel/dma.c b/arch/openrisc/kernel/dma.c
new file mode 100644
index 0000000..e038732a
--- /dev/null
+++ b/arch/openrisc/kernel/dma.c
@@ -0,0 +1,86 @@
+/*
+ * OpenRISC Linux
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * Modifications for the OpenRISC architecture:
+ * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of the GNU General Public License
+ *      as published by the Free Software Foundation; either version
+ *      2 of the License, or (at your option) any later version.
+ *
+ * DMA mapping callbacks...
+ * As alloc_coherent is the only DMA callback being used currently, that's
+ * the only thing implemented properly.  The rest need looking into...
+ */
+
+#include <linux/device.h>
+#include <linux/dma-mapping.h>
+#include <linux/gfp.h>
+#include <linux/dma-debug.h>
+#include <linux/io.h>
+#include <linux/vmalloc.h>
+
+/*
+ * Alloc "coherent" memory, which for OpenRISC means simply uncached.
+ */
+void *or1k_dma_alloc_coherent(struct device *dev, size_t size,
+			      dma_addr_t *dma_handle, gfp_t flag)
+{
+	int order;
+	unsigned long page, va;
+	pgprot_t prot;
+	struct vm_struct *area;
+
+	/* Only allocate page size areas. */
+	size = PAGE_ALIGN(size);
+	order = get_order(size);
+
+	page = __get_free_pages(flag, order);
+	if (!page)
+		return NULL;
+
+	/* Allocate some common virtual space to map the new pages. */
+	area = get_vm_area(size, VM_ALLOC);
+	if (area == NULL) {
+		free_pages(page, order);
+		return NULL;
+	}
+	va = (unsigned long)area->addr;
+
+	/* This gives us the real physical address of the first page. */
+	*dma_handle = __pa(page);
+
+	prot = PAGE_KERNEL_NOCACHE;
+
+	/* This isn't so much ioremap as just simply 'remap' */
+	if (ioremap_page_range(va, va + size, *dma_handle, prot)) {
+		vfree(area->addr);
+		return NULL;
+	}
+
+	return (void *)va;
+}
+
+void or1k_dma_free_coherent(struct device *dev, size_t size, void *vaddr,
+			    dma_addr_t dma_handle)
+{
+	vfree(vaddr);
+}
+
+/* Number of entries preallocated for DMA-API debugging */
+#define PREALLOC_DMA_DEBUG_ENTRIES (1 << 16)
+
+static int __init dma_init(void)
+{
+	dma_debug_init(PREALLOC_DMA_DEBUG_ENTRIES);
+
+	return 0;
+}
+
+fs_initcall(dma_init);
-- 
1.7.4.1

