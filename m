Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab2AZJCA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 04:02:00 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:59815 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242Ab2AZJBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 04:01:12 -0500
Date: Thu, 26 Jan 2012 10:00:57 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 15/15] ARM: Samsung: use CMA for 2 memory banks for s5p-mfc
 device
In-reply-to: <1327568457-27734-1-git-send-email-m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org
Cc: Michal Nazarewicz <mina86@mina86.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daniel Walker <dwalker@codeaurora.org>, Mel Gorman <mel@csn.ul.ie>,
        Arnd Bergmann <arnd@arndb.de>, Jesse Barker <jesse.barker@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Shariq Hasnain <shariq.hasnain@linaro.org>,
        Chunsang Jeong <chunsang.jeong@linaro.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Message-id: <1327568457-27734-16-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.7.3
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1327568457-27734-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace custom memory bank initialization using memblock_reserve and
dma_declare_coherent with a single call to CMA's dma_declare_contiguous.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/plat-s5p/dev-mfc.c |   51 ++++++-------------------------------------
 1 files changed, 7 insertions(+), 44 deletions(-)

diff --git a/arch/arm/plat-s5p/dev-mfc.c b/arch/arm/plat-s5p/dev-mfc.c
index a30d36b..fcb8400 100644
--- a/arch/arm/plat-s5p/dev-mfc.c
+++ b/arch/arm/plat-s5p/dev-mfc.c
@@ -14,6 +14,7 @@
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
+#include <linux/dma-contiguous.h>
 #include <linux/memblock.h>
 #include <linux/ioport.h>
 
@@ -22,52 +23,14 @@
 #include <plat/irqs.h>
 #include <plat/mfc.h>
 
-struct s5p_mfc_reserved_mem {
-	phys_addr_t	base;
-	unsigned long	size;
-	struct device	*dev;
-};
-
-static struct s5p_mfc_reserved_mem s5p_mfc_mem[2] __initdata;
-
 void __init s5p_mfc_reserve_mem(phys_addr_t rbase, unsigned int rsize,
 				phys_addr_t lbase, unsigned int lsize)
 {
-	int i;
-
-	s5p_mfc_mem[0].dev = &s5p_device_mfc_r.dev;
-	s5p_mfc_mem[0].base = rbase;
-	s5p_mfc_mem[0].size = rsize;
-
-	s5p_mfc_mem[1].dev = &s5p_device_mfc_l.dev;
-	s5p_mfc_mem[1].base = lbase;
-	s5p_mfc_mem[1].size = lsize;
-
-	for (i = 0; i < ARRAY_SIZE(s5p_mfc_mem); i++) {
-		struct s5p_mfc_reserved_mem *area = &s5p_mfc_mem[i];
-		if (memblock_remove(area->base, area->size)) {
-			printk(KERN_ERR "Failed to reserve memory for MFC device (%ld bytes at 0x%08lx)\n",
-			       area->size, (unsigned long) area->base);
-			area->base = 0;
-		}
-	}
-}
-
-static int __init s5p_mfc_memory_init(void)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(s5p_mfc_mem); i++) {
-		struct s5p_mfc_reserved_mem *area = &s5p_mfc_mem[i];
-		if (!area->base)
-			continue;
+	if (dma_declare_contiguous(&s5p_device_mfc_r.dev, rsize, rbase, 0))
+		printk(KERN_ERR "Failed to reserve memory for MFC device (%u bytes at 0x%08lx)\n",
+		       rsize, (unsigned long) rbase);
 
-		if (dma_declare_coherent_memory(area->dev, area->base,
-				area->base, area->size,
-				DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE) == 0)
-			printk(KERN_ERR "Failed to declare coherent memory for MFC device (%ld bytes at 0x%08lx)\n",
-			       area->size, (unsigned long) area->base);
-	}
-	return 0;
+	if (dma_declare_contiguous(&s5p_device_mfc_l.dev, lsize, lbase, 0))
+		printk(KERN_ERR "Failed to reserve memory for MFC device (%u bytes at 0x%08lx)\n",
+		       rsize, (unsigned long) rbase);
 }
-device_initcall(s5p_mfc_memory_init);
-- 
1.7.1.569.g6f426

