Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332Ab2KLV0u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 16:26:50 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:29682 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071Ab2KLVTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 16:19:32 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 14/46] x86, mm: use pfn_range_is_mapped() with reserve_initrd
Date: Mon, 12 Nov 2012 13:18:10 -0800
Message-Id: <1352755122-25660-15-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1352755122-25660-1-git-send-email-yinghai@kernel.org>
References: <20121112193044.GA11615@phenom.dumpdata.com>
 <1352755122-25660-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are going to map ram only, so under max_low_pfn_mapped,
between 4g and max_pfn_mapped does not mean mapped at all.

Use pfn_range_is_mapped() to find out if range is mapped for initrd.

That could happen bootloader put initrd in range but user could
use memmap to carve some of range out.

Also during copying need to use early_memmap to map original initrd
for accessing.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/setup.c |   52 +++++++++++++++++++++++++---------------------
 1 files changed, 28 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index d85cbd9..bd52f9d 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -317,20 +317,19 @@ static void __init relocate_initrd(void)
 	u64 ramdisk_image = boot_params.hdr.ramdisk_image;
 	u64 ramdisk_size  = boot_params.hdr.ramdisk_size;
 	u64 area_size     = PAGE_ALIGN(ramdisk_size);
-	u64 end_of_lowmem = max_low_pfn_mapped << PAGE_SHIFT;
 	u64 ramdisk_here;
 	unsigned long slop, clen, mapaddr;
 	char *p, *q;
 
-	/* We need to move the initrd down into lowmem */
-	ramdisk_here = memblock_find_in_range(0, end_of_lowmem, area_size,
-					 PAGE_SIZE);
+	/* We need to move the initrd down into directly mapped mem */
+	ramdisk_here = memblock_find_in_range(0, PFN_PHYS(max_low_pfn_mapped),
+						 area_size, PAGE_SIZE);
 
 	if (!ramdisk_here)
 		panic("Cannot find place for new RAMDISK of size %lld\n",
 			 ramdisk_size);
 
-	/* Note: this includes all the lowmem currently occupied by
+	/* Note: this includes all the mem currently occupied by
 	   the initrd, we rely on that fact to keep the data intact. */
 	memblock_reserve(ramdisk_here, area_size);
 	initrd_start = ramdisk_here + PAGE_OFFSET;
@@ -340,17 +339,7 @@ static void __init relocate_initrd(void)
 
 	q = (char *)initrd_start;
 
-	/* Copy any lowmem portion of the initrd */
-	if (ramdisk_image < end_of_lowmem) {
-		clen = end_of_lowmem - ramdisk_image;
-		p = (char *)__va(ramdisk_image);
-		memcpy(q, p, clen);
-		q += clen;
-		ramdisk_image += clen;
-		ramdisk_size  -= clen;
-	}
-
-	/* Copy the highmem portion of the initrd */
+	/* Copy the initrd */
 	while (ramdisk_size) {
 		slop = ramdisk_image & ~PAGE_MASK;
 		clen = ramdisk_size;
@@ -364,7 +353,7 @@ static void __init relocate_initrd(void)
 		ramdisk_image += clen;
 		ramdisk_size  -= clen;
 	}
-	/* high pages is not converted by early_res_to_bootmem */
+
 	ramdisk_image = boot_params.hdr.ramdisk_image;
 	ramdisk_size  = boot_params.hdr.ramdisk_size;
 	printk(KERN_INFO "Move RAMDISK from [mem %#010llx-%#010llx] to"
@@ -373,13 +362,27 @@ static void __init relocate_initrd(void)
 		ramdisk_here, ramdisk_here + ramdisk_size - 1);
 }
 
+static u64 __init get_mem_size(unsigned long limit_pfn)
+{
+	int i;
+	u64 mapped_pages = 0;
+	unsigned long start_pfn, end_pfn;
+
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, NULL) {
+		start_pfn = min_t(unsigned long, start_pfn, limit_pfn);
+		end_pfn = min_t(unsigned long, end_pfn, limit_pfn);
+		mapped_pages += end_pfn - start_pfn;
+	}
+
+	return mapped_pages << PAGE_SHIFT;
+}
 static void __init reserve_initrd(void)
 {
 	/* Assume only end is not page aligned */
 	u64 ramdisk_image = boot_params.hdr.ramdisk_image;
 	u64 ramdisk_size  = boot_params.hdr.ramdisk_size;
 	u64 ramdisk_end   = PAGE_ALIGN(ramdisk_image + ramdisk_size);
-	u64 end_of_lowmem = max_low_pfn_mapped << PAGE_SHIFT;
+	u64 mapped_size;
 
 	if (!boot_params.hdr.type_of_loader ||
 	    !ramdisk_image || !ramdisk_size)
@@ -387,18 +390,19 @@ static void __init reserve_initrd(void)
 
 	initrd_start = 0;
 
-	if (ramdisk_size >= (end_of_lowmem>>1)) {
+	mapped_size = get_mem_size(max_low_pfn_mapped);
+	if (ramdisk_size >= (mapped_size>>1))
 		panic("initrd too large to handle, "
 		       "disabling initrd (%lld needed, %lld available)\n",
-		       ramdisk_size, end_of_lowmem>>1);
-	}
+		       ramdisk_size, mapped_size>>1);
 
 	printk(KERN_INFO "RAMDISK: [mem %#010llx-%#010llx]\n", ramdisk_image,
 			ramdisk_end - 1);
 
-
-	if (ramdisk_end <= end_of_lowmem) {
-		/* All in lowmem, easy case */
+	if (ramdisk_end <= (max_low_pfn_mapped<<PAGE_SHIFT) &&
+	    pfn_range_is_mapped(PFN_DOWN(ramdisk_image),
+				PFN_DOWN(ramdisk_end))) {
+		/* All are mapped, easy case */
 		/*
 		 * don't need to reserve again, already reserved early
 		 * in i386_start_kernel
-- 
1.7.7

