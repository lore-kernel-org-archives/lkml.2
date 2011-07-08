Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506Ab1GHHg2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 03:36:28 -0400
Received: from mail.southpole.se ([193.12.106.18]:42134 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab1GHHg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 03:36:26 -0400
Subject: Re: [PATCH v2 07/19] OpenRISC: DMA
From: Jonas Bonn <jonas@southpole.se>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <201107051737.30120.arnd@arndb.de>
References: <1309641352-18714-1-git-send-email-jonas@southpole.se>
	 <1309641352-18714-8-git-send-email-jonas@southpole.se>
	 <201107051737.30120.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Jul 2011 09:36:19 +0200
Message-ID: <1310110579.3073.19.camel@jerome>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Assp-Client-SSL: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2011-07-05 at 17:37 +0200, Arnd Bergmann wrote:
> This will result in having conflicting mappings, one with and another
> without caching, which a lot of CPU architectures don't like. Are you
> sure that you can handle this with or1k?
> 
> 	Arnd

Hi Arnd,
I put a bit more thought into what we actually need for DMA and came up
with the implementation in this patch.  This is a lot simpler than what
we had before, but it seems to fit nicely with the model that we have.

The jist of it is that allocation of coherent memory just needs to
return pages with the cache-inhibit bit set so we now:

i)   call __get_free_pages (via alloc_pages_exact)
ii)  set the CI bit on those pages
iii) flush the pages from cache

This should mean that we don't have any conflicting page table entries
for these pages anymore.

I'd appreciate if you could look over this implementation to make sure
I haven't missed anything fundamental.

Thanks,
Jonas

PS: Having a bit of an issue with git send-email and in a bit of a hurry
so I just pasted the patch into this mail... should be ok since it's
just for review anyway; just hoping the mail client doesn't mess up the
formatting.

-----------------------------------------------------------------

>From b2dc6eb85a19b4601180c9dcec440364daf7d9db Mon Sep 17 00:00:00 2001
From: Jonas Bonn <jonas@southpole.se>
Date: Sat, 4 Jun 2011 21:56:48 +0300
Subject: [PATCH] OpenRISC: DMA

Simple DMA implementation.  Allows for allocation of coherent memory
(simply uncached) for DMA operations.

Signed-off-by: Jonas Bonn <jonas@southpole.se>
---


 arch/openrisc/include/asm/dma-mapping.h |   62 +++++++++++++++
 arch/openrisc/kernel/dma.c              |  131
+++++++++++++++++++++++++++++++
 2 files changed, 193 insertions(+), 0 deletions(-)
 create mode 100644 arch/openrisc/include/asm/dma-mapping.h
 create mode 100644 arch/openrisc/kernel/dma.c

diff --git a/arch/openrisc/include/asm/dma-mapping.h
b/arch/openrisc/include/asm/dma-mapping.h
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
+#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h,
f)
+#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
+
+void *or1k_dma_alloc_coherent(struct device *dev, size_t size,
+			      dma_addr_t *dma_handle, gfp_t flag);
+void or1k_dma_free_coherent(struct device *dev, size_t size, void
*vaddr,
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
index 0000000..54d4773
--- /dev/null
+++ b/arch/openrisc/kernel/dma.c
@@ -0,0 +1,131 @@
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
+ * As alloc_coherent is the only DMA callback being used currently,
that's
+ * the only thing implemented properly.  The rest need looking into...
+ */
+
+#include <linux/device.h>
+#include <linux/dma-mapping.h>
+#include <linux/gfp.h>
+#include <linux/dma-debug.h>
+#include <linux/io.h>
+#include <linux/vmalloc.h>
+#include <linux/sched.h>
+
+#include <asm/cpuinfo.h>
+#include <asm/spr_defs.h>
+#include <asm/tlbflush.h>
+
+static int page_set_nocache(pte_t* pte, unsigned long addr,
+			    unsigned long next, struct mm_walk* walk)
+{
+	unsigned long cl;
+
+	pte_val(*pte) |= _PAGE_CI;
+
+	/*
+	 * Flush the page out of the TLB so that the new page flags get
+	 * picked up next time there's an access
+	 */
+	flush_tlb_page(NULL, addr);
+
+	/* Flush page out of dcache */
+	for (cl = __pa(addr); cl < __pa(next); cl +=
cpuinfo.dcache_block_size)
+		mtspr(SPR_DCBFR, cl);
+
+	return 0;
+}
+
+static int page_clear_nocache(pte_t* pte, unsigned long addr,
+			    unsigned long next, struct mm_walk* walk)
+{
+	pte_val(*pte) &= ~_PAGE_CI;
+
+	/*
+	 * Flush the page out of the TLB so that the new page flags get
+	 * picked up next time there's an access
+	 */
+	flush_tlb_page(NULL, addr);
+
+	return 0;
+}
+
+/*
+ * Alloc "coherent" memory, which for OpenRISC means simply uncached.
+ *
+ * This function effectively just calls __get_free_pages, sets the
+ * cache-inhibit bit on those pages, and makes sure that the pages are
+ * flushed out of the cache before they are used.
+ *
+ */
+void *or1k_dma_alloc_coherent(struct device *dev, size_t size,
+			      dma_addr_t *dma_handle, gfp_t gfp)
+{
+	unsigned long va;
+	void* page;
+	struct mm_walk walk = {
+		.pte_entry = page_set_nocache,
+		.mm = &init_mm
+	};
+
+	page = alloc_pages_exact(size, gfp);
+	if (!page)
+		return NULL;
+
+	/* This gives us the real physical address of the first page. */
+	*dma_handle = __pa(page);
+
+	va = (unsigned long) page;
+
+	/*
+	 * We need to iterate through the pages, clearing the dcache for
+	 * them and setting the cache-inhibit bit.
+	 */
+	if (walk_page_range(va, va+size, &walk)) {
+		free_pages_exact(page, size);
+		return NULL;
+	} 	
+
+	return (void*) va;
+}
+
+void or1k_dma_free_coherent(struct device *dev, size_t size, void
*vaddr,
+			    dma_addr_t dma_handle)
+{
+	unsigned long va = (unsigned long) vaddr;
+	struct mm_walk walk = {
+		.pte_entry = page_clear_nocache,
+		.mm = &init_mm
+	};
+
+	/* walk_page_range shouldn't be able to fail here */
+	WARN_ON(walk_page_range(va, va+size, &walk));
+
+	free_pages_exact(vaddr, size);
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
+fs_initcall(dma_init);
-- 
1.7.1


