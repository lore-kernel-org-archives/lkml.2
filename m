Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088Ab2F0F4B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 01:56:01 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53753 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab2F0Fz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 01:55:59 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FEAA05C.6090204@jp.fujitsu.com>
Date: Wed, 27 Jun 2012 14:55:40 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-acpi@vger.kernel.org>
CC: <len.brown@intel.com>, <benh@kernel.crashing.org>, <paulus@samba.org>,
        <cl@linux.com>, <minchan.kim@gmail.com>, <akpm@linux-foundation.org>,
        <kosaki.motohiro@jp.fujitsu.com>, <wency@cn.fujitsu.com>
Subject: [RFC PATCH 9/12] memory-hotplug : implement register_page_bootmem_info_section
 of sparse-vmemmap
References: <4FEA9C88.1070800@jp.fujitsu.com>
In-Reply-To: <4FEA9C88.1070800@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For removing memmap region of sparse-vmemmap which is allocated bootmem,
memmap region of sparse-vmemmap needs to be registered by get_page_bootmem().
So the patch searches pages of virtual mapping and registers the pages by
get_page_bootmem().

CC: Len Brown <len.brown@intel.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Paul Mackerras <paulus@samba.org>
CC: Christoph Lameter <cl@linux.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

---
 arch/x86/mm/init_64.c          |   53 +++++++++++++++++++++++++++++++++++++++++
 include/linux/memory_hotplug.h |    2 +
 include/linux/mm.h             |    3 +-
 mm/memory_hotplug.c            |   23 +++++++++++++++--
 4 files changed, 77 insertions(+), 4 deletions(-)

Index: linux-3.5-rc4/mm/memory_hotplug.c
===================================================================
--- linux-3.5-rc4.orig/mm/memory_hotplug.c	2012-06-26 14:05:16.604459506 +0900
+++ linux-3.5-rc4/mm/memory_hotplug.c	2012-06-26 14:27:19.850916817 +0900
@@ -91,8 +91,8 @@ static void release_memory_resource(stru
 }

 #ifdef CONFIG_MEMORY_HOTPLUG_SPARSE
-static void get_page_bootmem(unsigned long info,  struct page *page,
-			     unsigned long type)
+void get_page_bootmem(unsigned long info,  struct page *page,
+		      unsigned long type)
 {
 	unsigned long page_type;

@@ -164,8 +164,25 @@ static void register_page_bootmem_info_s

 }
 #else
-static inline void register_page_bootmem_info_section(unsigned long start_pfn)
+static void register_page_bootmem_info_section(unsigned long start_pfn)
 {
+	unsigned long mapsize, section_nr;
+	struct mem_section *ms;
+	struct page *page, *memmap;
+
+	if (!pfn_valid(start_pfn))
+		return;
+
+	section_nr = pfn_to_section_nr(start_pfn);
+	ms = __nr_to_section(section_nr);
+
+	memmap = sparse_decode_mem_map(ms->section_mem_map, section_nr);
+
+	page = virt_to_page(memmap);
+	mapsize = sizeof(struct page) * PAGES_PER_SECTION;
+	mapsize = PAGE_ALIGN(mapsize) >> PAGE_SHIFT;
+
+	register_page_bootmem_memmap(section_nr, memmap, PAGES_PER_SECTION);
 }
 #endif

Index: linux-3.5-rc4/include/linux/mm.h
===================================================================
--- linux-3.5-rc4.orig/include/linux/mm.h	2012-06-25 04:53:04.000000000 +0900
+++ linux-3.5-rc4/include/linux/mm.h	2012-06-26 14:26:17.481696320 +0900
@@ -1586,7 +1586,8 @@ int vmemmap_populate_basepages(struct pa
 						unsigned long pages, int node);
 int vmemmap_populate(struct page *start_page, unsigned long pages, int node);
 void vmemmap_populate_print_last(void);
-
+void register_page_bootmem_memmap(unsigned long section_nr, struct page *map,
+				  unsigned long size);

 enum mf_flags {
 	MF_COUNT_INCREASED = 1 << 0,
Index: linux-3.5-rc4/arch/x86/mm/init_64.c
===================================================================
--- linux-3.5-rc4.orig/arch/x86/mm/init_64.c	2012-06-25 04:53:04.000000000 +0900
+++ linux-3.5-rc4/arch/x86/mm/init_64.c	2012-06-26 14:26:17.481696320 +0900
@@ -978,6 +978,59 @@ vmemmap_populate(struct page *start_page
 	return 0;
 }

+void __meminit
+register_page_bootmem_memmap(unsigned long section_nr, struct page *start_page,
+			     unsigned long size)
+{
+	unsigned long addr = (unsigned long)start_page;
+	unsigned long end = (unsigned long)(start_page + size);
+	unsigned long next;
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+
+	for (; addr < end; addr = next) {
+		pte_t *pte = NULL;
+
+		pgd = pgd_offset_k(addr);
+		if (pgd_none(*pgd)) {
+			next = (addr + PAGE_SIZE) & PAGE_MASK;
+			continue;
+		}
+		get_page_bootmem(section_nr, pgd_page(*pgd), MIX_SECTION_INFO);
+
+		pud = pud_offset(pgd, addr);
+		if (pud_none(*pud)) {
+			next = (addr + PAGE_SIZE) & PAGE_MASK;
+			continue;
+		}
+		get_page_bootmem(section_nr, pud_page(*pud), MIX_SECTION_INFO);
+
+		if (!cpu_has_pse) {
+			next = (addr + PAGE_SIZE) & PAGE_MASK;
+			pmd = pmd_offset(pud, addr);
+			if (pmd_none(*pmd))
+				continue;
+			get_page_bootmem(section_nr, pmd_page(*pmd),
+					 MIX_SECTION_INFO);
+
+			pte = pte_offset_kernel(pmd, addr);
+			if (pte_none(*pte))
+				continue;
+			get_page_bootmem(section_nr, pte_page(*pte),
+					 SECTION_INFO);
+		} else {
+			next = pmd_addr_end(addr, end);
+
+			pmd = pmd_offset(pud, addr);
+			if (pmd_none(*pmd))
+				continue;
+			get_page_bootmem(section_nr, pmd_page(*pmd),
+					 SECTION_INFO);
+		}
+	}
+}
+
 void __meminit vmemmap_populate_print_last(void)
 {
 	if (p_start) {
Index: linux-3.5-rc4/include/linux/memory_hotplug.h
===================================================================
--- linux-3.5-rc4.orig/include/linux/memory_hotplug.h	2012-06-26 14:05:16.603459518 +0900
+++ linux-3.5-rc4/include/linux/memory_hotplug.h	2012-06-26 14:11:14.175989381 +0900
@@ -162,6 +162,8 @@ static inline void arch_refresh_nodedata

 extern void register_page_bootmem_info_node(struct pglist_data *pgdat);
 extern void put_page_bootmem(struct page *page);
+extern void get_page_bootmem(unsigned long ingo, struct page *page,
+			     unsigned long type);

 /*
  * Lock for memory hotplug guarantees 1) all callbacks for memory hotplug

