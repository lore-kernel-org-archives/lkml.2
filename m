Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451Ab1ANB4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 20:56:20 -0500
Received: from [69.28.251.93] ([69.28.251.93]:44978 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751693Ab1ANB4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 20:56:16 -0500
From: Kevin Cernekee <cernekee@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: <macro@linux-mips.org>, <skuribay@pobox.com>, <raiko@niisi.msk.ru>,
        <linux-mips@linux-mips.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/6] MIPS: Sync after cacheflush on BMIPS processors
Date: Thu, 13 Jan 2011 17:52:12 -0800
Message-Id: <491015d51e5d3d36c517da09e038ecaf@localhost>
User-Agent: vim 7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On BMIPS processors, cache writeback operations may complete before the
data has actually been written out to memory.  Subsequent uncached reads
(or I/O operations) may see stale data unless a sync instruction is
executed after the writeback loop.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 arch/mips/include/asm/hazards.h |   21 +++++++++++++++++++++
 arch/mips/mm/c-r4k.c            |    5 +++++
 2 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/arch/mips/include/asm/hazards.h b/arch/mips/include/asm/hazards.h
index 4e33216..655da05 100644
--- a/arch/mips/include/asm/hazards.h
+++ b/arch/mips/include/asm/hazards.h
@@ -270,4 +270,25 @@ ASMMACRO(disable_fpu_hazard,
 )
 #endif
 
+/*
+ * Some processors will "pipeline" cache writeback operations, and need an
+ * extra sync instruction to ensure that they are actually flushed out to
+ * memory.  Performing an uncached read (or an I/O operation) without the
+ * flush may cause stale data to be fetched.
+ */
+
+#if defined(CONFIG_CPU_BMIPS3300) || defined(CONFIG_CPU_BMIPS4350) || \
+    defined(CONFIG_CPU_BMIPS4380) || defined(CONFIG_CPU_BMIPS5000)
+
+#define cacheflush_hazard()						\
+do {									\
+	__sync();							\
+} while (0)
+
+#else
+
+#define cacheflush_hazard() do { } while (0)
+
+#endif
+
 #endif /* _ASM_HAZARDS_H */
diff --git a/arch/mips/mm/c-r4k.c b/arch/mips/mm/c-r4k.c
index b4923a7..6c113cd 100644
--- a/arch/mips/mm/c-r4k.c
+++ b/arch/mips/mm/c-r4k.c
@@ -33,6 +33,7 @@
 #include <asm/mmu_context.h>
 #include <asm/war.h>
 #include <asm/cacheflush.h> /* for run_uncached() */
+#include <asm/hazards.h>
 
 
 /*
@@ -604,6 +605,7 @@ static void r4k_dma_cache_wback_inv(unsigned long addr, unsigned long size)
 			r4k_blast_scache();
 		else
 			blast_scache_range(addr, addr + size);
+		cacheflush_hazard();
 		return;
 	}
 
@@ -620,6 +622,7 @@ static void r4k_dma_cache_wback_inv(unsigned long addr, unsigned long size)
 	}
 
 	bc_wback_inv(addr, size);
+	cacheflush_hazard();
 }
 
 static void r4k_dma_cache_inv(unsigned long addr, unsigned long size)
@@ -647,6 +650,7 @@ static void r4k_dma_cache_inv(unsigned long addr, unsigned long size)
 				 (addr + size - 1) & almask);
 			blast_inv_scache_range(addr, addr + size);
 		}
+		cacheflush_hazard();
 		return;
 	}
 
@@ -663,6 +667,7 @@ static void r4k_dma_cache_inv(unsigned long addr, unsigned long size)
 	}
 
 	bc_inv(addr, size);
+	cacheflush_hazard();
 }
 #endif /* CONFIG_DMA_NONCOHERENT */
 
-- 
1.7.0.4

