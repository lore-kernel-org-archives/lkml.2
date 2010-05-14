Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759707Ab0ENTvA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 15:51:00 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:18055 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757234Ab0ENTuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 15:50:51 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Becky Bruce <beckyb@kernel.crashing.org>
Subject: [PATCH 29/37] swiotlb: Use page alignment for early buffer allocation
Date: Fri, 14 May 2010 12:45:55 -0700
Message-Id: <1273866363-14249-30-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1273866363-14249-1-git-send-email-yinghai@kernel.org>
References: <1273866363-14249-1-git-send-email-yinghai@kernel.org>
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090208.4BEDA94C.0099,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

for 2.6.34

We could call free_bootmem_late() if swiotlb is not used, and
it will shrink to page alignement.

So alloc them with page alignment at first, to avoid lose two pages

before patch:
[    0.000000]     lmb_reserve_area: [00d3600000, 00d7600000]   swiotlb buffer
[    0.000000]     lmb_reserve_area: [00d7e7ef40, 00d7e9ef40]     swiotlb list
[    0.000000]     lmb_reserve_area: [00d7e3ef40, 00d7e7ef40]  swiotlb orig_ad
[    0.000000]     lmb_reserve_area: [000008a000, 0000092000]  swiotlb overflo

after patch will get
[    0.000000]     lmb_reserve_area: [00d3600000, 00d7600000]   swiotlb buffer
[    0.000000]     lmb_reserve_area: [00d7e7e000, 00d7e9e000]     swiotlb list
[    0.000000]     lmb_reserve_area: [00d7e3e000, 00d7e7e000]  swiotlb orig_ad
[    0.000000]     lmb_reserve_area: [000008a000, 0000092000]  swiotlb overflo

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Becky Bruce <beckyb@kernel.crashing.org>
---
 lib/swiotlb.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 5fddf72..1bd4258 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -159,7 +159,7 @@ swiotlb_init_with_default_size(size_t default_size, int verbose)
 	/*
 	 * Get IO TLB memory from the low pages
 	 */
-	io_tlb_start = alloc_bootmem_low_pages(bytes);
+	io_tlb_start = alloc_bootmem_low_pages(PAGE_ALIGN(bytes));
 	if (!io_tlb_start)
 		panic("Cannot allocate SWIOTLB buffer");
 	io_tlb_end = io_tlb_start + bytes;
@@ -169,16 +169,16 @@ swiotlb_init_with_default_size(size_t default_size, int verbose)
 	 * to find contiguous free memory regions of size up to IO_TLB_SEGSIZE
 	 * between io_tlb_start and io_tlb_end.
 	 */
-	io_tlb_list = alloc_bootmem(io_tlb_nslabs * sizeof(int));
+	io_tlb_list = alloc_bootmem_pages(PAGE_ALIGN(io_tlb_nslabs * sizeof(int)));
 	for (i = 0; i < io_tlb_nslabs; i++)
  		io_tlb_list[i] = IO_TLB_SEGSIZE - OFFSET(i, IO_TLB_SEGSIZE);
 	io_tlb_index = 0;
-	io_tlb_orig_addr = alloc_bootmem(io_tlb_nslabs * sizeof(phys_addr_t));
+	io_tlb_orig_addr = alloc_bootmem_pages(PAGE_ALIGN(io_tlb_nslabs * sizeof(phys_addr_t)));
 
 	/*
 	 * Get the overflow emergency buffer
 	 */
-	io_tlb_overflow_buffer = alloc_bootmem_low(io_tlb_overflow);
+	io_tlb_overflow_buffer = alloc_bootmem_low_pages(PAGE_ALIGN(io_tlb_overflow));
 	if (!io_tlb_overflow_buffer)
 		panic("Cannot allocate SWIOTLB overflow buffer!\n");
 	if (verbose)
@@ -304,13 +304,13 @@ void __init swiotlb_free(void)
 			   get_order(io_tlb_nslabs << IO_TLB_SHIFT));
 	} else {
 		free_bootmem_late(__pa(io_tlb_overflow_buffer),
-				  io_tlb_overflow);
+				  PAGE_ALIGN(io_tlb_overflow));
 		free_bootmem_late(__pa(io_tlb_orig_addr),
-				  io_tlb_nslabs * sizeof(phys_addr_t));
+				  PAGE_ALIGN(io_tlb_nslabs * sizeof(phys_addr_t)));
 		free_bootmem_late(__pa(io_tlb_list),
-				  io_tlb_nslabs * sizeof(int));
+				  PAGE_ALIGN(io_tlb_nslabs * sizeof(int)));
 		free_bootmem_late(__pa(io_tlb_start),
-				  io_tlb_nslabs << IO_TLB_SHIFT);
+				  PAGE_ALIGN(io_tlb_nslabs << IO_TLB_SHIFT));
 	}
 }
 
-- 
1.6.4.2

