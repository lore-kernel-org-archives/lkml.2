Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758439Ab0JUOIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 10:08:18 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:55035 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583Ab0JUOIR (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 21 Oct 2010 10:08:17 -0400
Date: Thu, 21 Oct 2010 10:06:15 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [GIT PULL] stable/swiotlb-0.9 for v2.6.37
Message-ID: <20101021140615.GA31376@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/konrad/swiotlb-2.6.git stable/swiotlb-0.9

which contains two patches since git commit cb655d0f3d57c23db51b981648e452988c0223f9
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed Oct 6 13:39:52 2010 -0700

    Linux 2.6.36-rc7


There are two patches there for the lib/swiotlb.c library.
First is to cleanup the swiotlb.c library a bit and in the long-term remove the
dependency on the overflow buffer. The other is to page-align the early
buffer allocation so that if we don't use SWIOTLB we can de-allocate
the buffers and save two pages.

Thank you,
Konrad

The shortlog and diffstat:

FUJITA Tomonori (1):
      swiotlb: make io_tlb_overflow static

Yinghai Lu (1):
      swiotlb: Use page alignment for early buffer allocation

 lib/swiotlb.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)


---------------------
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 34e3082..7c06ee5 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -70,7 +70,7 @@ static unsigned long io_tlb_nslabs;
  */
 static unsigned long io_tlb_overflow = 32*1024;
 
-void *io_tlb_overflow_buffer;
+static void *io_tlb_overflow_buffer;
 
 /*
  * This is a free list describing the number of free entries available from
@@ -147,16 +147,16 @@ void __init swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose)
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
@@ -182,7 +182,7 @@ swiotlb_init_with_default_size(size_t default_size, int verbose)
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
 
