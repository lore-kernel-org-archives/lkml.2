Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558Ab0JEXQU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 19:16:20 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:31821 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756284Ab0JEXQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 19:16:19 -0400
Message-ID: <4CABB183.1040607@kernel.org>
Date: Tue, 05 Oct 2010 16:15:15 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 4/4] x86, mm, memblock, 32bit: Make add_highpages honor
 early reserved ranges
References: <4CAA4BD5.4020505@kernel.org> <4CAA4DF9.9060205@kernel.org> <4CABAB9A.4060007@zytor.com>
In-Reply-To: <4CABAB9A.4060007@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2010 03:50 PM, H. Peter Anvin wrote:
> On 10/04/2010 02:58 PM, Yinghai Lu wrote:
>>  
>> +int __init get_free_all_memory_range(struct range **rangep, int nodeid)
>> +{
>> +	unsigned long end_pfn = -1ULL;
>> +
> 
> Uh... I really hope I don't have to explain what's wrong with that...

sorry for that.

[PATCH -v2] x86, mm, memblock, 32bit: Make add_highpages honor early reserved ranges

Originally the only early reserved range that is overlapped with high pages :
 "KVA RAM", but We do remove them from active ranges.

It turns out xen could have that kind of overlapping to support memory bollaon.

So We need to make add_highpage_with_active_regions() to subtract memblock
reserved just like low ram.

In this patch, refactering get_freel_all_memory_range() to make it can be used
by add_highpage_with_active_regions().
Also we don't need to remove "KVA RAM" from active ranges.

-v2: use -1UL instead of -1ULL

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/memblock.h |    2 +
 arch/x86/mm/init_32.c           |   59 ++++++++++++----------------------------
 arch/x86/mm/memblock.c          |   19 ++++++++++--
 arch/x86/mm/numa_32.c           |    2 -
 4 files changed, 36 insertions(+), 46 deletions(-)

Index: linux-2.6/arch/x86/include/asm/memblock.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/memblock.h
+++ linux-2.6/arch/x86/include/asm/memblock.h
@@ -9,6 +9,8 @@ void memblock_x86_to_bootmem(u64 start,
 void memblock_x86_reserve_range(u64 start, u64 end, char *name);
 void memblock_x86_free_range(u64 start, u64 end);
 struct range;
+int __get_free_all_memory_range(struct range **range, int nodeid,
+			 unsigned long start_pfn, unsigned long end_pfn);
 int get_free_all_memory_range(struct range **rangep, int nodeid);
 
 void memblock_x86_register_active_regions(int nid, unsigned long start_pfn,
Index: linux-2.6/arch/x86/mm/init_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_32.c
+++ linux-2.6/arch/x86/mm/init_32.c
@@ -423,49 +423,28 @@ static void __init add_one_highpage_init
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
-
-	data = (struct add_highpages_data *)datax;
-
-	final_start_pfn = max(start_pfn, data->start_pfn);
-	final_end_pfn = min(end_pfn, data->end_pfn);
-	if (final_start_pfn >= final_end_pfn)
-		return 0;
-
-	for (node_pfn = final_start_pfn; node_pfn < final_end_pfn;
-	     node_pfn++) {
-		if (!pfn_valid(node_pfn))
-			continue;
-		page = pfn_to_page(node_pfn);
-		add_one_highpage_init(page);
+	struct range *range;
+	int nr_range;
+	int i;
+
+	nr_range = __get_free_all_memory_range(&range, nid, start_pfn, end_pfn);
+
+	for (i = 0; i < nr_range; i++) {
+		struct page *page;
+		int node_pfn;
+
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
Index: linux-2.6/arch/x86/mm/memblock.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/memblock.c
+++ linux-2.6/arch/x86/mm/memblock.c
@@ -139,7 +139,8 @@ static int __init count_early_node_map(i
 	return data.nr;
 }
 
-int __init get_free_all_memory_range(struct range **rangep, int nodeid)
+int __init __get_free_all_memory_range(struct range **rangep, int nodeid,
+			 unsigned long start_pfn, unsigned long end_pfn)
 {
 	int count;
 	struct range *range;
@@ -155,9 +156,9 @@ int __init get_free_all_memory_range(str
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
 
@@ -165,6 +166,16 @@ int __init get_free_all_memory_range(str
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
Index: linux-2.6/arch/x86/mm/numa_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/numa_32.c
+++ linux-2.6/arch/x86/mm/numa_32.c
@@ -326,8 +326,6 @@ static __init unsigned long calculate_nu
 			      "KVA RAM");
 
 		node_remap_start_pfn[nid] = node_kva_final>>PAGE_SHIFT;
-		remove_active_range(nid, node_remap_start_pfn[nid],
-					 node_remap_start_pfn[nid] + size);
 	}
 	printk(KERN_INFO "Reserving total of %lx pages for numa KVA remap\n",
 			reserve_pages);
