Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751210Ab0IGEWq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 00:22:46 -0400
Received: from [69.28.251.93] ([69.28.251.93]:48282 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750827Ab0IGEWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 00:22:34 -0400
From: Kevin Cernekee <cernekee@gmail.com>
Date: Mon, 6 Sep 2010 21:03:46 -0700
Subject: [PATCH 2/5] MIPS: sync after cacheflush
To: Ralf Baechle <ralf@linux-mips.org>
Cc: <linux-mips@linux-mips.org>, <linux-kernel@vger.kernel.org>
Message-Id: <72d10d33beedb9d877a7373dafc04a75@localhost>
User-Agent: vim 7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On processors with deep write buffers, it is likely that many cycles
will pass between a CACHE instruction and the time the data actually
gets written out to DRAM.  Add a SYNC instruction to ensure that the
buffers get emptied before the flush functions return.

Actual problem seen in the wild:

1) dma_alloc_coherent() allocates cached memory

2) memset() is called to clear the new pages

3) dma_cache_wback_inv() is called to flush the zero data out to memory

4) dma_alloc_coherent() returns an uncached (kseg1) pointer to the
freshly allocated pages

5) Caller writes data through the kseg1 pointer

6) Buffered writeback data finally gets flushed out to DRAM

7) Part of caller's data is inexplicably zeroed out

This patch adds SYNC between steps 3 and 4, which fixed the problem.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 arch/mips/mm/c-r4k.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/mips/mm/c-r4k.c b/arch/mips/mm/c-r4k.c
index 6721ee2..05c3de3 100644
--- a/arch/mips/mm/c-r4k.c
+++ b/arch/mips/mm/c-r4k.c
@@ -605,6 +605,7 @@ static void r4k_dma_cache_wback_inv(unsigned long addr, unsigned long size)
 			r4k_blast_scache();
 		else
 			blast_scache_range(addr, addr + size);
+		__sync();
 		return;
 	}
 
@@ -621,6 +622,7 @@ static void r4k_dma_cache_wback_inv(unsigned long addr, unsigned long size)
 	}
 
 	bc_wback_inv(addr, size);
+	__sync();
 }
 
 static void r4k_dma_cache_inv(unsigned long addr, unsigned long size)
@@ -648,6 +650,7 @@ static void r4k_dma_cache_inv(unsigned long addr, unsigned long size)
 				 (addr + size - 1) & almask);
 			blast_inv_scache_range(addr, addr + size);
 		}
+		__sync();
 		return;
 	}
 
@@ -664,6 +667,7 @@ static void r4k_dma_cache_inv(unsigned long addr, unsigned long size)
 	}
 
 	bc_inv(addr, size);
+	__sync();
 }
 #endif /* CONFIG_DMA_NONCOHERENT */
 
-- 
1.7.0.4

