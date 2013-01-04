Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab3ADAur (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 19:50:47 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:30511 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755144Ab3ADAuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 19:50:39 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v7u1 25/31] memblock: add memblock_mem_size()
Date: Thu,  3 Jan 2013 16:48:45 -0800
Message-Id: <1357260531-11115-26-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use it to get mem size under the limit_pfn.
to replace local version in x86 reserved_initrd.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/setup.c  |   16 +---------------
 include/linux/memblock.h |    1 +
 mm/memblock.c            |   17 +++++++++++++++++
 3 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 15ce495..c58497e 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -363,20 +363,6 @@ static void __init relocate_initrd(void)
 		ramdisk_here, ramdisk_here + ramdisk_size - 1);
 }
 
-static u64 __init get_mem_size(unsigned long limit_pfn)
-{
-	int i;
-	u64 mapped_pages = 0;
-	unsigned long start_pfn, end_pfn;
-
-	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, NULL) {
-		start_pfn = min_t(unsigned long, start_pfn, limit_pfn);
-		end_pfn = min_t(unsigned long, end_pfn, limit_pfn);
-		mapped_pages += end_pfn - start_pfn;
-	}
-
-	return mapped_pages << PAGE_SHIFT;
-}
 static void __init early_reserve_initrd(void)
 {
 	/* Assume only end is not page aligned */
@@ -404,7 +390,7 @@ static void __init reserve_initrd(void)
 
 	initrd_start = 0;
 
-	mapped_size = get_mem_size(max_pfn_mapped);
+	mapped_size = (u64)memblock_mem_size(max_pfn_mapped);
 	if (ramdisk_size >= (mapped_size>>1))
 		panic("initrd too large to handle, "
 		       "disabling initrd (%lld needed, %lld available)\n",
diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index d452ee1..f388203 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -155,6 +155,7 @@ phys_addr_t memblock_alloc_base(phys_addr_t size, phys_addr_t align,
 phys_addr_t __memblock_alloc_base(phys_addr_t size, phys_addr_t align,
 				  phys_addr_t max_addr);
 phys_addr_t memblock_phys_mem_size(void);
+phys_addr_t memblock_mem_size(unsigned long limit_pfn);
 phys_addr_t memblock_start_of_DRAM(void);
 phys_addr_t memblock_end_of_DRAM(void);
 void memblock_enforce_memory_limit(phys_addr_t memory_limit);
diff --git a/mm/memblock.c b/mm/memblock.c
index 6259055..4b3b8d2 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -827,6 +827,23 @@ phys_addr_t __init memblock_phys_mem_size(void)
 	return memblock.memory.total_size;
 }
 
+phys_addr_t __init memblock_mem_size(unsigned long limit_pfn)
+{
+	unsigned long pages = 0;
+	struct memblock_region *r;
+	unsigned long start_pfn, end_pfn;
+
+	for_each_memblock(memory, r) {
+		start_pfn = memblock_region_memory_base_pfn(r);
+		end_pfn = memblock_region_memory_end_pfn(r);
+		start_pfn = min_t(unsigned long, start_pfn, limit_pfn);
+		end_pfn = min_t(unsigned long, end_pfn, limit_pfn);
+		pages += end_pfn - start_pfn;
+	}
+
+	return (phys_addr_t)pages << PAGE_SHIFT;
+}
+
 /* lowest address */
 phys_addr_t __init_memblock memblock_start_of_DRAM(void)
 {
-- 
1.7.10.4

