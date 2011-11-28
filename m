Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410Ab1K1Tbw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 14:31:52 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35679 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371Ab1K1Tbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 14:31:50 -0500
From: Tejun Heo <tj@kernel.org>
To: benh@kernel.crashing.org, yinghai@kernel.org, hpa@zytor.com,
        tony.luck@intel.com, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        liqin.chen@sunplusct.com, lethal@linux-sh.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        mingo@redhat.com, jonas@southpole.se, lennox.wu@gmail.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/23] memblock: Kill sentinel entries at the end of static region arrays
Date: Mon, 28 Nov 2011 11:31:07 -0800
Message-Id: <1322508685-32532-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1322508685-32532-1-git-send-email-tj@kernel.org>
References: <1322508685-32532-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memblock no longer depends on having one more entry at the end during
addition making the sentinel entries at the end of region arrays not
too useful.  Remove the sentinels.  This eases further updates.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Yinghai Lu <yinghai@kernel.org>
---
 include/linux/poison.h |    6 ------
 mm/memblock.c          |   14 ++------------
 2 files changed, 2 insertions(+), 18 deletions(-)

diff --git a/include/linux/poison.h b/include/linux/poison.h
index 79159de..2110a81 100644
--- a/include/linux/poison.h
+++ b/include/linux/poison.h
@@ -40,12 +40,6 @@
 #define	RED_INACTIVE	0x09F911029D74E35BULL	/* when obj is inactive */
 #define	RED_ACTIVE	0xD84156C5635688C0ULL	/* when obj is active */
 
-#ifdef CONFIG_PHYS_ADDR_T_64BIT
-#define MEMBLOCK_INACTIVE	0x3a84fb0144c9e71bULL
-#else
-#define MEMBLOCK_INACTIVE	0x44c9e71bUL
-#endif
-
 #define SLUB_RED_INACTIVE	0xbb
 #define SLUB_RED_ACTIVE		0xcc
 
diff --git a/mm/memblock.c b/mm/memblock.c
index 4b80f6f..e808df8 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -24,8 +24,8 @@ struct memblock memblock __initdata_memblock;
 
 int memblock_debug __initdata_memblock;
 int memblock_can_resize __initdata_memblock;
-static struct memblock_region memblock_memory_init_regions[INIT_MEMBLOCK_REGIONS + 1] __initdata_memblock;
-static struct memblock_region memblock_reserved_init_regions[INIT_MEMBLOCK_REGIONS + 1] __initdata_memblock;
+static struct memblock_region memblock_memory_init_regions[INIT_MEMBLOCK_REGIONS] __initdata_memblock;
+static struct memblock_region memblock_reserved_init_regions[INIT_MEMBLOCK_REGIONS] __initdata_memblock;
 
 /* inline so we don't get a warning when pr_debug is compiled out */
 static inline const char *memblock_type_name(struct memblock_type *type)
@@ -911,12 +911,6 @@ void __init memblock_analyze(void)
 {
 	int i;
 
-	/* Check marker in the unused last array entry */
-	WARN_ON(memblock_memory_init_regions[INIT_MEMBLOCK_REGIONS].base
-		!= MEMBLOCK_INACTIVE);
-	WARN_ON(memblock_reserved_init_regions[INIT_MEMBLOCK_REGIONS].base
-		!= MEMBLOCK_INACTIVE);
-
 	memblock.memory_size = 0;
 
 	for (i = 0; i < memblock.memory.cnt; i++)
@@ -940,10 +934,6 @@ void __init memblock_init(void)
 	memblock.reserved.regions	= memblock_reserved_init_regions;
 	memblock.reserved.max	= INIT_MEMBLOCK_REGIONS;
 
-	/* Write a marker in the unused last array entry */
-	memblock.memory.regions[INIT_MEMBLOCK_REGIONS].base = MEMBLOCK_INACTIVE;
-	memblock.reserved.regions[INIT_MEMBLOCK_REGIONS].base = MEMBLOCK_INACTIVE;
-
 	/* Create a dummy zero size MEMBLOCK which will get coalesced away later.
 	 * This simplifies the memblock_add() code below...
 	 */
-- 
1.7.3.1

