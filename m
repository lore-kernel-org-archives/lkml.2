Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933266Ab2JDAiZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 20:38:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:19009 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933167Ab2JDAiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 20:38:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,530,1344236400"; 
   d="scan'208";a="230270042"
From: Alexander Duyck <alexander.h.duyck@intel.com>
Subject: [RFC PATCH 0/7] Improve swiotlb performance by using physical
	addresses
To: konrad.wilk@oracle.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, rob@landley.net, akpm@linux-foundation.org,
        joerg.roedel@amd.com, bhelgaas@google.com, shuahkhan@gmail.com
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, x86@kernel.org
Date: Wed, 03 Oct 2012 17:38:41 -0700
Message-ID: <20121004002113.5016.66913.stgit@gitlad.jf.intel.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While working on 10Gb/s routing performance I found a significant amount of
time was being spent in the swiotlb DMA handler.  Further digging found that a
significant amount of this was due to the fact that virtual to physical
address translation and calling the function that did it.  It accounted for
nearly 60% of the total overhead.

This patch set works to resolve that by changing the io_tlb_start address and
io_tlb_overflow_buffer address from virtual addresses to physical addresses.
By doing this, devices that are not making use of bounce buffers can
significantly reduce their overhead.  In addition I followed through with the
cleanup to the point that the only functions that really require the virtual
address for the dma buffer are the init, free, and bounce functions.

When running a routing throughput test using small packets I saw roughly a 5%
increase in packets rates after applying these patches.  This appears to match
up with the CPU overhead reduction I was tracking via perf.

Before:
Results 10.29Mps
# Overhead Symbol
# ........ ...........................................................................................................
#
     1.97%  [k] __phys_addr                                                                                   
            |              
            |--24.97%-- swiotlb_sync_single
            |          
            |--16.55%-- is_swiotlb_buffer
            |          
            |--11.25%-- unmap_single
            |          
             --2.71%-- swiotlb_dma_mapping_error
     1.66%  [k] swiotlb_sync_single                                                                                 
     1.45%  [k] is_swiotlb_buffer                                     
     0.53%  [k] unmap_single                                                                                     
     0.52%  [k] swiotlb_map_page                                      
     0.47%  [k] swiotlb_sync_single_for_device                                                                 
     0.43%  [k] swiotlb_sync_single_for_cpu                           
     0.42%  [k] swiotlb_dma_mapping_error                                                               
     0.34%  [k] swiotlb_unmap_page                

After:
Results 10.99Mps
# Overhead Symbol
# ........ ...........................................................................................................
#
     0.50%  [k] swiotlb_map_page                                                                                        
     0.50%  [k] swiotlb_sync_single                                                                                     
     0.36%  [k] swiotlb_sync_single_for_cpu                                                                             
     0.35%  [k] swiotlb_sync_single_for_device                                                                          
     0.25%  [k] swiotlb_unmap_page                                                                                      
     0.17%  [k] swiotlb_dma_mapping_error  

---

Alexander Duyck (7):
      swiotlb:  Do not export swiotlb_bounce since there are no external consumers
      swiotlb: Use physical addresses instead of virtual in swiotlb_tbl_sync_single
      swiotlb: Use physical addresses for swiotlb_tbl_unmap_single
      swiotlb: Return physical addresses when calling swiotlb_tbl_map_single
      swiotlb: Make io_tlb_overflow_buffer a physical address
      swiotlb: Make io_tlb_start a physical address instead of a virtual address
      swiotlb: Instead of tracking the end of the swiotlb region just calculate it


 drivers/xen/swiotlb-xen.c |   25 ++---
 include/linux/swiotlb.h   |   20 ++--
 lib/swiotlb.c             |  247 +++++++++++++++++++++++----------------------
 3 files changed, 150 insertions(+), 142 deletions(-)

-- 

