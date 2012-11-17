Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397Ab2KQDsA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 22:48:00 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:27379 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100Ab2KQDk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 22:40:27 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v8 16/46] x86, mm: relocate initrd under all mem for 64bit
Date: Fri, 16 Nov 2012 19:38:53 -0800
Message-Id: <1353123563-3103-17-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1353123563-3103-1-git-send-email-yinghai@kernel.org>
References: <1353123563-3103-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

instead of under 4g.

For 64bit, we can use any mapped mem instead of low mem.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/setup.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 68dffec..94f922a 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -324,7 +324,7 @@ static void __init relocate_initrd(void)
 	char *p, *q;
 
 	/* We need to move the initrd down into directly mapped mem */
-	ramdisk_here = memblock_find_in_range(0, PFN_PHYS(max_low_pfn_mapped),
+	ramdisk_here = memblock_find_in_range(0, PFN_PHYS(max_pfn_mapped),
 						 area_size, PAGE_SIZE);
 
 	if (!ramdisk_here)
@@ -392,7 +392,7 @@ static void __init reserve_initrd(void)
 
 	initrd_start = 0;
 
-	mapped_size = get_mem_size(max_low_pfn_mapped);
+	mapped_size = get_mem_size(max_pfn_mapped);
 	if (ramdisk_size >= (mapped_size>>1))
 		panic("initrd too large to handle, "
 		       "disabling initrd (%lld needed, %lld available)\n",
@@ -401,8 +401,7 @@ static void __init reserve_initrd(void)
 	printk(KERN_INFO "RAMDISK: [mem %#010llx-%#010llx]\n", ramdisk_image,
 			ramdisk_end - 1);
 
-	if (ramdisk_end <= (max_low_pfn_mapped<<PAGE_SHIFT) &&
-	    pfn_range_is_mapped(PFN_DOWN(ramdisk_image),
+	if (pfn_range_is_mapped(PFN_DOWN(ramdisk_image),
 				PFN_DOWN(ramdisk_end))) {
 		/* All are mapped, easy case */
 		/*
-- 
1.7.7

