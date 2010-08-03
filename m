Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab0HCGeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 02:34:21 -0400
Received: from ozlabs.org ([203.10.76.45]:40430 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755327Ab0HCGeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 02:34:19 -0400
Date: Tue, 3 Aug 2010 16:29:15 +1000
From: Anton Blanchard <anton@samba.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] iommu: inline iommu_num_pages
Message-ID: <20100803062914.GC31448@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A profile of a network benchmark showed iommu_num_pages rather high up:

     0.52%  iommu_num_pages

Looking at the profile, an integer divide is taking almost all of the time:

      %         
         :      c000000000376ea4 <.iommu_num_pages>:
    1.93 :      c000000000376ea4:       fb e1 ff f8     std     r31,-8(r1)
    0.00 :      c000000000376ea8:       f8 21 ff c1     stdu    r1,-64(r1)
    0.00 :      c000000000376eac:       7c 3f 0b 78     mr      r31,r1
    3.86 :      c000000000376eb0:       38 84 ff ff     addi    r4,r4,-1
    0.00 :      c000000000376eb4:       38 05 ff ff     addi    r0,r5,-1
    0.00 :      c000000000376eb8:       7c 84 2a 14     add     r4,r4,r5
   46.95 :      c000000000376ebc:       7c 00 18 38     and     r0,r0,r3
   45.66 :      c000000000376ec0:       7c 84 02 14     add     r4,r4,r0
    0.00 :      c000000000376ec4:       7c 64 2b 92     divdu   r3,r4,r5
    0.00 :      c000000000376ec8:       38 3f 00 40     addi    r1,r31,64
    0.00 :      c000000000376ecc:       eb e1 ff f8     ld      r31,-8(r1)
    1.61 :      c000000000376ed0:       4e 80 00 20     blr

Since every caller of iommu_num_pages passes in a constant power of two
we can inline this such that the divide is replaced by a shift. The
entire function is only a few instructions once optimised, so it is
a good candidate for inlining overall.

Signed-off-by: Anton Blanchard <anton@samba.org>
--

Index: powerpc.git/include/linux/iommu-helper.h
===================================================================
--- powerpc.git.orig/include/linux/iommu-helper.h	2010-07-30 11:51:49.900741505 +1000
+++ powerpc.git/include/linux/iommu-helper.h	2010-07-30 11:53:49.310741623 +1000
@@ -1,6 +1,8 @@
 #ifndef _LINUX_IOMMU_HELPER_H
 #define _LINUX_IOMMU_HELPER_H
 
+#include <linux/kernel.h>
+
 static inline unsigned long iommu_device_max_index(unsigned long size,
 						   unsigned long offset,
 						   u64 dma_mask)
@@ -20,7 +22,13 @@ extern unsigned long iommu_area_alloc(un
 				      unsigned long boundary_size,
 				      unsigned long align_mask);
 
-extern unsigned long iommu_num_pages(unsigned long addr, unsigned long len,
-				     unsigned long io_page_size);
+static inline unsigned long iommu_num_pages(unsigned long addr,
+					    unsigned long len,
+					    unsigned long io_page_size)
+{
+	unsigned long size = (addr & (io_page_size - 1)) + len;
+
+	return DIV_ROUND_UP(size, io_page_size);
+}
 
 #endif
Index: powerpc.git/lib/iommu-helper.c
===================================================================
--- powerpc.git.orig/lib/iommu-helper.c	2010-07-30 11:45:10.860741495 +1000
+++ powerpc.git/lib/iommu-helper.c	2010-07-30 11:52:20.732001414 +1000
@@ -38,12 +38,3 @@ again:
 	return -1;
 }
 EXPORT_SYMBOL(iommu_area_alloc);
-
-unsigned long iommu_num_pages(unsigned long addr, unsigned long len,
-			      unsigned long io_page_size)
-{
-	unsigned long size = (addr & (io_page_size - 1)) + len;
-
-	return DIV_ROUND_UP(size, io_page_size);
-}
-EXPORT_SYMBOL(iommu_num_pages);
