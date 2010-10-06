Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758605Ab0JFG2e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 02:28:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:34845 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758200Ab0JFG2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 02:28:32 -0400
Date: Wed, 6 Oct 2010 06:28:15 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de
In-Reply-To: <4CABB183.1040607@kernel.org>
References: <4CABB183.1040607@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/memblock] x86-32, memblock: Make add_highpages honor early reserved ranges
Message-ID: <tip-1d931264af0f10649b35afa8fbd2e169da51ac08@git.kernel.org>
Git-Commit-ID: 1d931264af0f10649b35afa8fbd2e169da51ac08
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 06 Oct 2010 06:28:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1d931264af0f10649b35afa8fbd2e169da51ac08
Gitweb:     http://git.kernel.org/tip/1d931264af0f10649b35afa8fbd2e169da51ac08
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Tue, 5 Oct 2010 16:15:15 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 5 Oct 2010 21:44:35 -0700

x86-32, memblock: Make add_highpages honor early reserved ranges

Originally the only early reserved range that is overlapped with high
pages is "KVA RAM", but we already do remove that from the active ranges.

However, It turns out Xen could have that kind of overlapping to support memory
ballooning.x

So we need to make add_highpage_with_active_regions() to subtract
memblock reserved just like low ram; this is the proper design anyway.

In this patch, refactering get_freel_all_memory_range() to make it can
be used by add_highpage_with_active_regions().  Also we don't need to
remove "KVA RAM" from active ranges.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <4CABB183.1040607@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/memblock.h |    2 +
 arch/x86/mm/init_32.c           |   53 +++++++++++---------------------------
 arch/x86/mm/memblock.c          |   19 +++++++++++---
 arch/x86/mm/numa_32.c           |    2 -
 4 files changed, 33 insertions(+), 43 deletions(-)

diff --git a/arch/x86/include/asm/memblock.h b/arch/x86/include/asm/memblock.h
index 2c304bb..19ae14b 100644
--- a/arch/x86/include/asm/memblock.h
+++ b/arch/x86/include/asm/memblock.h
@@ -9,6 +9,8 @@ void memblock_x86_to_bootmem(u64 start, u64 end);
 void memblock_x86_reserve_range(u64 start, u64 end, char *name);
 void memblock_x86_free_range(u64 start, u64 end);
 struct range;
+int __get_free_all_memory_range(struct range **range, int nodeid,
+			 unsigned long start_pfn, unsigned long end_pfn);
 int get_free_all_memory_range(struct range **rangep, int nodeid);
 
 void memblock_x86_register_active_regions(int nid, unsigned long start_pfn,
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index c2385d7..8546709 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -423,49 +423,28 @@ static void __init add_one_highpage_init(struct page *page)
 	totalhigh_pages++;
 }
 
-struct add_highpages_data {
-	unsigned long start_pfn;
-	unsigned long end_pfn;
-};
-
-static int __init add_highpages_work_fn(unsigned long start_pfn,
-					 unsigned long end_pfn, void *datax)
+void __init add_highpages_with_active_regions(int nid,
+			 unsigned long start_pfn, unsigned long end_pfn)
 {
-	int node_pfn;
-	struct page *page;
-	unsigned long final_start_pfn, final_end_pfn;
-	struct add_highpages_data *data;
+	struct range *range;
+	int nr_range;
+	int i;
 
-	data = (struct add_highpages_data *)datax;
+	nr_range = __get_free_all_memory_range(&range, nid, start_pfn, end_pfn);
 
-	final_start_pfn = max(start_pfn, data->start_pfn);
-	final_end_pfn = min(end_pfn, data->end_pfn);
-	if (final_start_pfn >= final_end_pfn)
-		return 0;
+	for (i = 0; i < nr_range; i++) {
+		struct page *page;
+		int node_pfn;
 
-	for (node_pfn = final_start_pfn; node_pfn < final_end_pfn;
-	     node_pfn++) {
-		if (!pfn_valid(node_pfn))
-			continue;
-		page = pfn_to_page(node_pfn);
-		add_one_highpage_init(page);
+		for (node_pfn = range[i].start; node_pfn < range[i].end;
+		     node_pfn++) {
+			if (!pfn_valid(node_pfn))
+				continue;
+			page = pfn_to_page(node_pfn);
+			add_one_highpage_init(page);
+		}
 	}
-
-	return 0;
-
 }
-
-void __init add_highpages_with_active_regions(int nid, unsigned long start_pfn,
-					      unsigned long end_pfn)
-{
-	struct add_highpages_data data;
-
-	data.start_pfn = start_pfn;
-	data.end_pfn = end_pfn;
-
-	work_with_active_regions(nid, add_highpages_work_fn, &data);
-}
-
 #else
 static inline void permanent_kmaps_init(pgd_t *pgd_base)
 {
diff --git a/arch/x86/mm/memblock.c b/arch/x86/mm/memblock.c
index 50ecbc5..fd7a040 100644
--- a/arch/x86/mm/memblock.c
+++ b/arch/x86/mm/memblock.c
@@ -156,7 +156,8 @@ static int __init count_early_node_map(int nodeid)
 	return data.nr;
 }
 
-int __init get_free_all_memory_range(struct range **rangep, int nodeid)
+int __init __get_free_all_memory_range(struct range **rangep, int nodeid,
+			 unsigned long start_pfn, unsigned long end_pfn)
 {
 	int count;
 	struct range *range;
@@ -172,9 +173,9 @@ int __init get_free_all_memory_range(struct range **rangep, int nodeid)
 	 * at first
 	 */
 	nr_range = add_from_early_node_map(range, count, nr_range, nodeid);
-#ifdef CONFIG_X86_32
-	subtract_range(range, count, max_low_pfn, -1ULL);
-#endif
+	subtract_range(range, count, 0, start_pfn);
+	subtract_range(range, count, end_pfn, -1ULL);
+
 	memblock_x86_subtract_reserved(range, count);
 	nr_range = clean_sort_range(range, count);
 
@@ -182,6 +183,16 @@ int __init get_free_all_memory_range(struct range **rangep, int nodeid)
 	return nr_range;
 }
 
+int __init get_free_all_memory_range(struct range **rangep, int nodeid)
+{
+	unsigned long end_pfn = -1UL;
+
+#ifdef CONFIG_X86_32
+	end_pfn = max_low_pfn;
+#endif
+	return __get_free_all_memory_range(rangep, nodeid, 0, end_pfn);
+}
+
 static u64 __init __memblock_x86_memory_in_range(u64 addr, u64 limit, bool get_free)
 {
 	int i, count;
diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
index 70ddeb7..84a3e4c 100644
--- a/arch/x86/mm/numa_32.c
+++ b/arch/x86/mm/numa_32.c
@@ -326,8 +326,6 @@ static __init unsigned long calculate_numa_remap_pages(void)
 			      "KVA RAM");
 
 		node_remap_start_pfn[nid] = node_kva_final>>PAGE_SHIFT;
-		remove_active_range(nid, node_remap_start_pfn[nid],
-					 node_remap_start_pfn[nid] + size);
 	}
 	printk(KERN_INFO "Reserving total of %lx pages for numa KVA remap\n",
 			reserve_pages);
