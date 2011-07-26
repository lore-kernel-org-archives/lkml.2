Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab1GZPhF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 11:37:05 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:58903 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623Ab1GZPgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 11:36:00 -0400
From: Tejun Heo <tj@kernel.org>
To: benh@kernel.crashing.org, yinghai@kernel.org, hpa@zytor.com,
        tony.luck@intel.com, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        liqin.chen@sunplusct.com, lethal@linux-sh.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: mingo@redhat.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/23] powerpc: Cleanup memblock usage
Date: Tue, 26 Jul 2011 17:35:22 +0200
Message-Id: <1311694534-5161-12-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311694534-5161-1-git-send-email-tj@kernel.org>
References: <1311694534-5161-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* early_init_devtree(): Total memory size is aligned to PAGE_SIZE;
  however, alignment isn't enforced if memory_limit is explicitly
  specified.  Simplify the logic and always apply PAGE_SIZE alignment.

* MMU_init(): memblock regions is truncated by directly modifying
  memblock.memory.cnt.  This is incomplete (reserved array is not
  truncated) and unnecessarily low level hindering further memblock
  improvments.  Use memblock_enforce_memory_limit() instead.

* wii_memory_fixups(): Unnecessarily low level direct manipulation of
  memblock regions.  The same result can be achieved using properly
  abstracted operations.  Reimplement using memblock API.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Yinghai Lu <yinghai@kernel.org>
---
 arch/powerpc/kernel/prom.c               |   17 ++++++-----------
 arch/powerpc/mm/init_32.c                |    2 +-
 arch/powerpc/platforms/embedded6xx/wii.c |   22 +++++++++-------------
 3 files changed, 16 insertions(+), 25 deletions(-)

diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index 83633b9..16a632f 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -736,17 +736,12 @@ void __init early_init_devtree(void *params)
 	early_reserve_mem();
 	phyp_dump_reserve_mem();
 
-	limit = memory_limit;
-	if (! limit) {
-		phys_addr_t memsize;
-
-		/* Ensure that total memory size is page-aligned, because
-		 * otherwise mark_bootmem() gets upset. */
-		memblock_analyze();
-		memsize = memblock_phys_mem_size();
-		if ((memsize & PAGE_MASK) != memsize)
-			limit = memsize & PAGE_MASK;
-	}
+	/*
+	 * Ensure that total memory size is page-aligned, because otherwise
+	 * mark_bootmem() gets upset.
+	 */
+	memblock_analyze();
+	limit = ALIGN(memory_limit ?: memblock_phys_mem_size(), PAGE_SIZE);
 	memblock_enforce_memory_limit(limit);
 
 	memblock_analyze();
diff --git a/arch/powerpc/mm/init_32.c b/arch/powerpc/mm/init_32.c
index 5de0f25..d6c2607 100644
--- a/arch/powerpc/mm/init_32.c
+++ b/arch/powerpc/mm/init_32.c
@@ -125,7 +125,7 @@ void __init MMU_init(void)
 
 	if (memblock.memory.cnt > 1) {
 #ifndef CONFIG_WII
-		memblock.memory.cnt = 1;
+		memblock_enforce_memory_limit(memblock.memory.regions[0].size);
 		memblock_analyze();
 		printk(KERN_WARNING "Only using first contiguous memory region");
 #else
diff --git a/arch/powerpc/platforms/embedded6xx/wii.c b/arch/powerpc/platforms/embedded6xx/wii.c
index 1b5dc1a..1cbe9d3 100644
--- a/arch/powerpc/platforms/embedded6xx/wii.c
+++ b/arch/powerpc/platforms/embedded6xx/wii.c
@@ -79,23 +79,19 @@ void __init wii_memory_fixups(void)
 	BUG_ON(memblock.memory.cnt != 2);
 	BUG_ON(!page_aligned(p[0].base) || !page_aligned(p[1].base));
 
-	p[0].size = _ALIGN_DOWN(p[0].size, PAGE_SIZE);
-	p[1].size = _ALIGN_DOWN(p[1].size, PAGE_SIZE);
+	/* trim unaligned tail */
+	memblock_remove(ALIGN(p[1].base + p[1].size, PAGE_SIZE),
+			(phys_addr_t)ULLONG_MAX);
 
-	wii_hole_start = p[0].base + p[0].size;
+	/* determine hole, add & reserve them */
+	wii_hole_start = ALIGN(p[0].base + p[0].size, PAGE_SIZE);
 	wii_hole_size = p[1].base - wii_hole_start;
-
-	pr_info("MEM1: <%08llx %08llx>\n", p[0].base, p[0].size);
-	pr_info("HOLE: <%08lx %08lx>\n", wii_hole_start, wii_hole_size);
-	pr_info("MEM2: <%08llx %08llx>\n", p[1].base, p[1].size);
-
-	p[0].size += wii_hole_size + p[1].size;
-
-	memblock.memory.cnt = 1;
+	memblock_add(wii_hole_start, wii_hole_size);
+	memblock_reserve(wii_hole_start, wii_hole_size);
 	memblock_analyze();
 
-	/* reserve the hole */
-	memblock_reserve(wii_hole_start, wii_hole_size);
+	BUG_ON(memblock.memory.cnt != 1);
+	__memblock_dump_all();
 
 	/* allow ioremapping the address space in the hole */
 	__allow_ioremap_reserved = 1;
-- 
1.7.6

