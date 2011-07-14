Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932499Ab1GNVfw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 17:35:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:59831 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932232Ab1GNVfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 17:35:50 -0400
Date: Thu, 14 Jul 2011 21:35:42 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Message-ID: <tip-8a9ca34c11e1695dab7aff3cfa7780fbfe76b2f8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        benh@kernel.crashing.org, yinghai@kernel.org, tj@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, benh@kernel.crashing.org, tj@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1310462166-31469-10-git-send-email-tj@kernel.org>
References: <1310462166-31469-10-git-send-email-tj@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/memblock] memblock, x86: Replace __get_free_all_memory_range() with for_each_free_mem_range()
Git-Commit-ID: 8a9ca34c11e1695dab7aff3cfa7780fbfe76b2f8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 14 Jul 2011 21:35:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8a9ca34c11e1695dab7aff3cfa7780fbfe76b2f8
Gitweb:     http://git.kernel.org/tip/8a9ca34c11e1695dab7aff3cfa7780fbfe76b2f8
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Tue, 12 Jul 2011 11:16:02 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 14 Jul 2011 11:47:49 -0700

memblock, x86: Replace __get_free_all_memory_range() with for_each_free_mem_range()

__get_free_all_memory_range() walks memblock, calculates free memory
areas and fills in the specified range.  It can be easily replaced
with for_each_free_mem_range().

Convert free_low_memory_core_early() and
add_highpages_with_active_regions() to for_each_free_mem_range().
This leaves __get_free_all_memory_range() without any user.  Kill it
and related functions.

Signed-off-by: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/r/1310462166-31469-10-git-send-email-tj@kernel.org
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/memblock.h |    3 --
 arch/x86/mm/init_32.c           |   28 +++++++-----------
 arch/x86/mm/memblock.c          |   59 ---------------------------------------
 mm/nobootmem.c                  |   28 ++++++++++--------
 4 files changed, 27 insertions(+), 91 deletions(-)

diff --git a/arch/x86/include/asm/memblock.h b/arch/x86/include/asm/memblock.h
index 6c72eca..bc9e44b 100644
--- a/arch/x86/include/asm/memblock.h
+++ b/arch/x86/include/asm/memblock.h
@@ -5,9 +5,6 @@
 
 void memblock_x86_reserve_range(u64 start, u64 end, char *name);
 void memblock_x86_free_range(u64 start, u64 end);
-struct range;
-int __get_free_all_memory_range(struct range **range, int nodeid,
-			 unsigned long start_pfn, unsigned long end_pfn);
 
 u64 memblock_x86_hole_size(u64 start, u64 end);
 u64 memblock_x86_free_memory_in_range(u64 addr, u64 limit);
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 5d173db..0c1da39 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -427,23 +427,17 @@ static void __init add_one_highpage_init(struct page *page)
 void __init add_highpages_with_active_regions(int nid,
 			 unsigned long start_pfn, unsigned long end_pfn)
 {
-	struct range *range;
-	int nr_range;
-	int i;
-
-	nr_range = __get_free_all_memory_range(&range, nid, start_pfn, end_pfn);
-
-	for (i = 0; i < nr_range; i++) {
-		struct page *page;
-		int node_pfn;
-
-		for (node_pfn = range[i].start; node_pfn < range[i].end;
-		     node_pfn++) {
-			if (!pfn_valid(node_pfn))
-				continue;
-			page = pfn_to_page(node_pfn);
-			add_one_highpage_init(page);
-		}
+	phys_addr_t start, end;
+	u64 i;
+
+	for_each_free_mem_range(i, nid, &start, &end, NULL) {
+		unsigned long pfn = clamp_t(unsigned long, PFN_UP(start),
+					    start_pfn, end_pfn);
+		unsigned long e_pfn = clamp_t(unsigned long, PFN_DOWN(end),
+					      start_pfn, end_pfn);
+		for ( ; pfn < e_pfn; pfn++)
+			if (pfn_valid(pfn))
+				add_one_highpage_init(pfn_to_page(pfn));
 	}
 }
 #else
diff --git a/arch/x86/mm/memblock.c b/arch/x86/mm/memblock.c
index 0e8442a..4107c1a 100644
--- a/arch/x86/mm/memblock.c
+++ b/arch/x86/mm/memblock.c
@@ -30,65 +30,6 @@ static __init struct range *find_range_array(int count)
 	return range;
 }
 
-static void __init memblock_x86_subtract_reserved(struct range *range, int az)
-{
-	u64 final_start, final_end;
-	struct memblock_region *r;
-
-	/* Take out region array itself at first*/
-	memblock_free_reserved_regions();
-
-	memblock_dbg("Subtract (%ld early reservations)\n", memblock.reserved.cnt);
-
-	for_each_memblock(reserved, r) {
-		memblock_dbg("  [%010llx-%010llx]\n", (u64)r->base, (u64)r->base + r->size - 1);
-		final_start = PFN_DOWN(r->base);
-		final_end = PFN_UP(r->base + r->size);
-		if (final_start >= final_end)
-			continue;
-		subtract_range(range, az, final_start, final_end);
-	}
-
-	/* Put region array back ? */
-	memblock_reserve_reserved_regions();
-}
-
-static int __init count_early_node_map(int nodeid)
-{
-	int i, cnt = 0;
-
-	for_each_mem_pfn_range(i, nodeid, NULL, NULL, NULL)
-		cnt++;
-	return cnt;
-}
-
-int __init __get_free_all_memory_range(struct range **rangep, int nodeid,
-			 unsigned long start_pfn, unsigned long end_pfn)
-{
-	int count;
-	struct range *range;
-	int nr_range;
-
-	count = (memblock.reserved.cnt + count_early_node_map(nodeid)) * 2;
-
-	range = find_range_array(count);
-	nr_range = 0;
-
-	/*
-	 * Use early_node_map[] and memblock.reserved.region to get range array
-	 * at first
-	 */
-	nr_range = add_from_early_node_map(range, count, nr_range, nodeid);
-	subtract_range(range, count, 0, start_pfn);
-	subtract_range(range, count, end_pfn, -1ULL);
-
-	memblock_x86_subtract_reserved(range, count);
-	nr_range = clean_sort_range(range, count);
-
-	*rangep = range;
-	return nr_range;
-}
-
 static u64 __init __memblock_x86_memory_in_range(u64 addr, u64 limit, bool get_free)
 {
 	int i, count;
diff --git a/mm/nobootmem.c b/mm/nobootmem.c
index 2037a8a..7075bc0 100644
--- a/mm/nobootmem.c
+++ b/mm/nobootmem.c
@@ -108,21 +108,25 @@ static void __init __free_pages_memory(unsigned long start, unsigned long end)
 
 unsigned long __init free_low_memory_core_early(int nodeid)
 {
-	int i;
-	u64 start, end;
 	unsigned long count = 0;
-	struct range *range = NULL;
-	int nr_range;
-
-	nr_range = __get_free_all_memory_range(&range, nodeid, 0, max_low_pfn);
-
-	for (i = 0; i < nr_range; i++) {
-		start = range[i].start;
-		end = range[i].end;
-		count += end - start;
-		__free_pages_memory(start, end);
+	phys_addr_t start, end;
+	u64 i;
+
+	/* free reserved array temporarily so that it's treated as free area */
+	memblock_free_reserved_regions();
+
+	for_each_free_mem_range(i, MAX_NUMNODES, &start, &end, NULL) {
+		unsigned long start_pfn = PFN_UP(start);
+		unsigned long end_pfn = min_t(unsigned long,
+					      PFN_DOWN(end), max_low_pfn);
+		if (start_pfn < end_pfn) {
+			__free_pages_memory(start_pfn, end_pfn);
+			count += end_pfn - start_pfn;
+		}
 	}
 
+	/* put region array back? */
+	memblock_reserve_reserved_regions();
 	return count;
 }
 
