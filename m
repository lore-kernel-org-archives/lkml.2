Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848Ab0JKRlN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 13:41:13 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:24339 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755657Ab0JKRlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 13:41:11 -0400
Message-ID: <4CB34C09.2060100@kernel.org>
Date: Mon, 11 Oct 2010 10:40:25 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ingo Molnar <mingo@elte.hu>,
        =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>,
        linux-kernel@vger.kernel.org, Becky Bruce <beckyb@kernel.crashing.org>
Subject: [PATCH] swiotlb: Use page alignment for early buffer allocation
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We could call free_bootmem_late() if swiotlb is not used, and
it will shrink to page alignment.

So alloc them with page alignment at first, to avoid lose two pages

before patch:
[    0.000000]     memblock_x86_reserve_range: [00d3600000, 00d7600000]   swiotlb buffer
[    0.000000]     memblock_x86_reserve_range: [00d7e7ef40, 00d7e9ef40]     swiotlb list
[    0.000000]     memblock_x86_reserve_range: [00d7e3ef40, 00d7e7ef40]  swiotlb orig_ad
[    0.000000]     memblock_x86_reserve_range: [000008a000, 0000092000]  swiotlb overflo

after patch will get
[    0.000000]     memblock_x86_reserve_range: [00d3600000, 00d7600000]   swiotlb buffer
[    0.000000]     memblock_x86_reserve_range: [00d7e7e000, 00d7e9e000]     swiotlb list
[    0.000000]     memblock_x86_reserve_range: [00d7e3e000, 00d7e7e000]  swiotlb orig_ad
[    0.000000]     memblock_x86_reserve_range: [000008a000, 0000092000]  swiotlb overflo

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Becky Bruce <beckyb@kernel.crashing.org>

---
 lib/swiotlb.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

Index: linux-2.6/lib/swiotlb.c
===================================================================
--- linux-2.6.orig/lib/swiotlb.c
+++ linux-2.6/lib/swiotlb.c
@@ -147,16 +147,16 @@ void __init swiotlb_init_with_tbl(char *
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
@@ -182,7 +182,7 @@ swiotlb_init_with_default_size(size_t de
 	/*
 	 * Get IO TLB memory from the low pages
 	 */
-	io_tlb_start = alloc_bootmem_low_pages(bytes);
+	io_tlb_start = alloc_bootmem_low_pages(PAGE_ALIGN(bytes));
 	if (!io_tlb_start)
 		panic("Cannot allocate SWIOTLB buffer");
 
@@ -308,13 +308,13 @@ void __init swiotlb_free(void)
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
 
