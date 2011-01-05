Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab1AETrb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 14:47:31 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:21297 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab1AETr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 14:47:29 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6217"; a="69168215"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] arm: mm: Poison freed init memory
Date: Wed,  5 Jan 2011 11:47:25 -0800
Message-Id: <1294256845-29517-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.4.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Poisoning __init marked memory can be useful when tracking down
obscure memory corruption bugs. When a pointer is 0xCCCCCCCC in an
oops it's much more obvious that somebody is using __init marked
memory after kernel initialization. This should help find
incorrect __init markings earlier and mimics what other
architectures are doing already.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

This is a minimal patch to get the idea across. I'm tempted to duplicate
free_area() and rename it to free_init_area() and then have it take virtual
addresses instead of pfns. Then the call sites could be cleaned up to pass
virtual addresses in the case of init memory, and we could remove the NULL
argument for the highpages and DMA users. Thoughts?

 arch/arm/mm/init.c |   20 +++++++++++++-------
 1 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 5164069..b7535ec 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -19,6 +19,7 @@
 #include <linux/gfp.h>
 #include <linux/memblock.h>
 #include <linux/sort.h>
+#include <linux/poison.h>
 
 #include <asm/mach-types.h>
 #include <asm/sections.h>
@@ -358,7 +359,8 @@ void __init bootmem_init(void)
 	max_pfn = max_high - PHYS_PFN_OFFSET;
 }
 
-static inline int free_area(unsigned long pfn, unsigned long end, char *s)
+static inline int free_area(unsigned long pfn, unsigned long end, char *s,
+		bool init_mem)
 {
 	unsigned int pages = 0, size = (end - pfn) << (PAGE_SHIFT - 10);
 
@@ -366,6 +368,9 @@ static inline int free_area(unsigned long pfn, unsigned long end, char *s)
 		struct page *page = pfn_to_page(pfn);
 		ClearPageReserved(page);
 		init_page_count(page);
+		if (init_mem)
+			memset(__va(__pfn_to_phys(pfn)), POISON_FREE_INITMEM,
+					PAGE_SIZE);
 		__free_page(page);
 		pages++;
 	}
@@ -472,7 +477,7 @@ static void __init free_highpages(void)
 				res_end = end;
 			if (res_start != start)
 				totalhigh_pages += free_area(start, res_start,
-							     NULL);
+							     NULL, false);
 			start = res_end;
 			if (start == end)
 				break;
@@ -480,7 +485,7 @@ static void __init free_highpages(void)
 
 		/* And now free anything which remains */
 		if (start < end)
-			totalhigh_pages += free_area(start, end, NULL);
+			totalhigh_pages += free_area(start, end, NULL, false);
 	}
 	totalram_pages += totalhigh_pages;
 #endif
@@ -512,7 +517,8 @@ void __init mem_init(void)
 #ifdef CONFIG_SA1111
 	/* now that our DMA memory is actually so designated, we can free it */
 	totalram_pages += free_area(PHYS_PFN_OFFSET,
-				    __phys_to_pfn(__pa(swapper_pg_dir)), NULL);
+				    __phys_to_pfn(__pa(swapper_pg_dir)), NULL,
+				    false);
 #endif
 
 	free_highpages();
@@ -644,13 +650,13 @@ void free_initmem(void)
 
 	totalram_pages += free_area(__phys_to_pfn(__pa(&__tcm_start)),
 				    __phys_to_pfn(__pa(&__tcm_end)),
-				    "TCM link");
+				    "TCM link", true);
 #endif
 
 	if (!machine_is_integrator() && !machine_is_cintegrator())
 		totalram_pages += free_area(__phys_to_pfn(__pa(__init_begin)),
 					    __phys_to_pfn(__pa(__init_end)),
-					    "init");
+					    "init", true);
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
@@ -662,7 +668,7 @@ void free_initrd_mem(unsigned long start, unsigned long end)
 	if (!keep_initrd)
 		totalram_pages += free_area(__phys_to_pfn(__pa(start)),
 					    __phys_to_pfn(__pa(end)),
-					    "initrd");
+					    "initrd", true);
 }
 
 static int __init keepinitrd_setup(char *__unused)
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

