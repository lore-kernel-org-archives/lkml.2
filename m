Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561Ab0JPVoP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 17:44:15 -0400
Received: from [69.28.251.93] ([69.28.251.93]:33742 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756394Ab0JPVoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 17:44:12 -0400
From: Kevin Cernekee <cernekee@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: <linux-mips@linux-mips.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH resend 5/9] MIPS: sync after cacheflush
Date: Sat, 16 Oct 2010 14:22:34 -0700
Message-Id: <17d8d27a2356640a4359f1a7dcbb3b42@localhost>
In-Reply-To: <17ebecce124618ddf83ec6fe8e526f93@localhost>
References: <17ebecce124618ddf83ec6fe8e526f93@localhost>
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

