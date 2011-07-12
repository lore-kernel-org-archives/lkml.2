Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739Ab1GLJRx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 05:17:53 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61601 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab1GLJQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 05:16:22 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de,
        benh@kernel.crashing.org, yinghai@kernel.org, davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, x86@kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/13] memblock, x86: Make free_all_memory_core_early() explicitly free lowmem only
Date: Tue, 12 Jul 2011 11:16:01 +0200
Message-Id: <1310462166-31469-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1310462166-31469-1-git-send-email-tj@kernel.org>
References: <1310462166-31469-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nomemblock is currently used only by x86 and on x86_32
free_all_memory_core_early() silently freed only the low mem because
get_free_all_memory_range() in arch/x86/mm/memblock.c implicitly
limited range to max_low_pfn.

Rename free_all_memory_core_early() to free_low_memory_core_early()
and make it call __get_free_all_memory_range() and limit the range to
max_low_pfn explicitly.  This makes things clearer and also is
consistent with the bootmem behavior.

This leaves get_free_all_memory_range() without any user.  Kill it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/include/asm/memblock.h |    1 -
 arch/x86/mm/memblock.c          |   10 ----------
 arch/x86/mm/numa_64.c           |    2 +-
 include/linux/bootmem.h         |    2 +-
 mm/nobootmem.c                  |    8 ++++----
 5 files changed, 6 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/memblock.h b/arch/x86/include/asm/memblock.h
index d2a5a59..6c72eca 100644
--- a/arch/x86/include/asm/memblock.h
+++ b/arch/x86/include/asm/memblock.h
@@ -8,7 +8,6 @@ void memblock_x86_free_range(u64 start, u64 end);
 struct range;
 int __get_free_all_memory_range(struct range **range, int nodeid,
 			 unsigned long start_pfn, unsigned long end_pfn);
-int get_free_all_memory_range(struct range **rangep, int nodeid);
 
 u64 memblock_x86_hole_size(u64 start, u64 end);
 u64 memblock_x86_free_memory_in_range(u64 addr, u64 limit);
diff --git a/arch/x86/mm/memblock.c b/arch/x86/mm/memblock.c
index 648d47d..0e8442a 100644
--- a/arch/x86/mm/memblock.c
+++ b/arch/x86/mm/memblock.c
@@ -89,16 +89,6 @@ int __init __get_free_all_memory_range(struct range **rangep, int nodeid,
 	return nr_range;
 }
 
-int __init get_free_all_memory_range(struct range **rangep, int nodeid)
-{
-	unsigned long end_pfn = -1UL;
-
-#ifdef CONFIG_X86_32
-	end_pfn = max_low_pfn;
-#endif
-	return __get_free_all_memory_range(rangep, nodeid, 0, end_pfn);
-}
-
 static u64 __init __memblock_x86_memory_in_range(u64 addr, u64 limit, bool get_free)
 {
 	int i, count;
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index dd27f40..92e2711 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -19,7 +19,7 @@ unsigned long __init numa_free_all_bootmem(void)
 	for_each_online_node(i)
 		pages += free_all_bootmem_node(NODE_DATA(i));
 
-	pages += free_all_memory_core_early(MAX_NUMNODES);
+	pages += free_low_memory_core_early(MAX_NUMNODES);
 
 	return pages;
 }
diff --git a/include/linux/bootmem.h b/include/linux/bootmem.h
index ab344a5..66d3e95 100644
--- a/include/linux/bootmem.h
+++ b/include/linux/bootmem.h
@@ -44,7 +44,7 @@ extern unsigned long init_bootmem_node(pg_data_t *pgdat,
 				       unsigned long endpfn);
 extern unsigned long init_bootmem(unsigned long addr, unsigned long memend);
 
-unsigned long free_all_memory_core_early(int nodeid);
+extern unsigned long free_low_memory_core_early(int nodeid);
 extern unsigned long free_all_bootmem_node(pg_data_t *pgdat);
 extern unsigned long free_all_bootmem(void);
 
diff --git a/mm/nobootmem.c b/mm/nobootmem.c
index c781626..2037a8a 100644
--- a/mm/nobootmem.c
+++ b/mm/nobootmem.c
@@ -106,7 +106,7 @@ static void __init __free_pages_memory(unsigned long start, unsigned long end)
 		__free_pages_bootmem(pfn_to_page(i), 0);
 }
 
-unsigned long __init free_all_memory_core_early(int nodeid)
+unsigned long __init free_low_memory_core_early(int nodeid)
 {
 	int i;
 	u64 start, end;
@@ -114,7 +114,7 @@ unsigned long __init free_all_memory_core_early(int nodeid)
 	struct range *range = NULL;
 	int nr_range;
 
-	nr_range = get_free_all_memory_range(&range, nodeid);
+	nr_range = __get_free_all_memory_range(&range, nodeid, 0, max_low_pfn);
 
 	for (i = 0; i < nr_range; i++) {
 		start = range[i].start;
@@ -136,7 +136,7 @@ unsigned long __init free_all_bootmem_node(pg_data_t *pgdat)
 {
 	register_page_bootmem_info_node(pgdat);
 
-	/* free_all_memory_core_early(MAX_NUMNODES) will be called later */
+	/* free_low_memory_core_early(MAX_NUMNODES) will be called later */
 	return 0;
 }
 
@@ -154,7 +154,7 @@ unsigned long __init free_all_bootmem(void)
 	 * Use MAX_NUMNODES will make sure all ranges in early_node_map[]
 	 *  will be used instead of only Node0 related
 	 */
-	return free_all_memory_core_early(MAX_NUMNODES);
+	return free_low_memory_core_early(MAX_NUMNODES);
 }
 
 /**
-- 
1.7.6

