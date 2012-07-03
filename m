Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933364Ab2GCGA5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 02:00:57 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37301 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932583Ab2GCGAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 02:00:55 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FF28A85.8020704@jp.fujitsu.com>
Date: Tue, 3 Jul 2012 15:00:37 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-acpi@vger.kernel.org>
CC: <rientjes@google.com>, <liuj97@gmail.com>, <len.brown@intel.com>,
        <benh@kernel.crashing.org>, <paulus@samba.org>, <cl@linux.com>,
        <minchan.kim@gmail.com>, <akpm@linux-foundation.org>,
        <kosaki.motohiro@jp.fujitsu.com>
Subject: [RFC PATCH v2 7/13] memory-hotplug : remove_memory calls __remove_pages
References: <4FF287C3.4030901@jp.fujitsu.com>
In-Reply-To: <4FF287C3.4030901@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch adds __remove_pages() to remove_memory(). Then the range of
phys_start_pfn argument and nr_pages argument in __remove_pagse() may
have different zone. So zone argument is removed from __remove_pages()
and __remove_pages() caluculates zone in each section.

When CONFIG_SPARSEMEM_VMEMMAP is defined, there is no way to remove a memmap.
So __remove_section only calls unregister_memory_section().

CC: David Rientjes <rientjes@google.com>
CC: Jiang Liu <liuj97@gmail.com>
CC: Len Brown <len.brown@intel.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Paul Mackerras <paulus@samba.org>
CC: Christoph Lameter <cl@linux.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

---
 arch/powerpc/platforms/pseries/hotplug-memory.c |    5 +----
 include/linux/memory_hotplug.h                  |    3 +--
 mm/memory_hotplug.c                             |   20 +++++++++++++-------
 3 files changed, 15 insertions(+), 13 deletions(-)

Index: linux-3.5-rc4/mm/memory_hotplug.c
===================================================================
--- linux-3.5-rc4.orig/mm/memory_hotplug.c	2012-07-03 14:22:05.919169458 +0900
+++ linux-3.5-rc4/mm/memory_hotplug.c	2012-07-03 14:22:10.170116406 +0900
@@ -275,11 +275,14 @@ static int __meminit __add_section(int n
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
 static int __remove_section(struct zone *zone, struct mem_section *ms)
 {
-	/*
-	 * XXX: Freeing memmap with vmemmap is not implement yet.
-	 *      This should be removed later.
-	 */
-	return -EBUSY;
+	int ret;
+
+	if (!valid_section(ms))
+		return ret;
+
+	ret = unregister_memory_section(ms);
+
+	return ret;
 }
 #else
 static int __remove_section(struct zone *zone, struct mem_section *ms)
@@ -346,11 +349,11 @@ EXPORT_SYMBOL_GPL(__add_pages);
  * sure that pages are marked reserved and zones are adjust properly by
  * calling offline_pages().
  */
-int __remove_pages(struct zone *zone, unsigned long phys_start_pfn,
-		 unsigned long nr_pages)
+int __remove_pages(unsigned long phys_start_pfn, unsigned long nr_pages)
 {
 	unsigned long i, ret = 0;
 	int sections_to_remove;
+	struct zone *zone;

 	/*
 	 * We can only remove entire sections
@@ -363,6 +366,7 @@ int __remove_pages(struct zone *zone, un
 	sections_to_remove = nr_pages / PAGES_PER_SECTION;
 	for (i = 0; i < sections_to_remove; i++) {
 		unsigned long pfn = phys_start_pfn + i*PAGES_PER_SECTION;
+		zone = page_zone(pfn_to_page(pfn));
 		ret = __remove_section(zone, __pfn_to_section(pfn));
 		if (ret)
 			break;
@@ -664,6 +668,8 @@ int remove_memory(int nid, u64 start, u6
 	lock_memory_hotplug();
 	/* remove memmap entry */
 	firmware_map_remove(start, start + size - 1, "System RAM");
+
+	__remove_pages(start >> PAGE_SHIFT, size >> PAGE_SHIFT);
 	unlock_memory_hotplug();
 	return 0;

Index: linux-3.5-rc4/include/linux/memory_hotplug.h
===================================================================
--- linux-3.5-rc4.orig/include/linux/memory_hotplug.h	2012-07-03 14:21:58.330264047 +0900
+++ linux-3.5-rc4/include/linux/memory_hotplug.h	2012-07-03 14:22:10.170116406 +0900
@@ -89,8 +89,7 @@ extern bool is_pageblock_removable_noloc
 /* reasonably generic interface to expand the physical pages in a zone  */
 extern int __add_pages(int nid, struct zone *zone, unsigned long start_pfn,
 	unsigned long nr_pages);
-extern int __remove_pages(struct zone *zone, unsigned long start_pfn,
-	unsigned long nr_pages);
+extern int __remove_pages(unsigned long start_pfn, unsigned long nr_pages);

 #ifdef CONFIG_NUMA
 extern int memory_add_physaddr_to_nid(u64 start);
Index: linux-3.5-rc4/arch/powerpc/platforms/pseries/hotplug-memory.c
===================================================================
--- linux-3.5-rc4.orig/arch/powerpc/platforms/pseries/hotplug-memory.c	2012-07-03 14:22:05.920169437
+0900
+++ linux-3.5-rc4/arch/powerpc/platforms/pseries/hotplug-memory.c	2012-07-03 14:22:10.172116353 +0900
@@ -76,7 +76,6 @@ unsigned long memory_block_size_bytes(vo
 static int pseries_remove_memblock(unsigned long base, unsigned int memblock_size)
 {
 	unsigned long start, start_pfn;
-	struct zone *zone;
 	int i, ret;
 	int sections_to_remove;

@@ -87,8 +86,6 @@ static int pseries_remove_memblock(unsig
 		return 0;
 	}

-	zone = page_zone(pfn_to_page(start_pfn));
-
 	/*
 	 * Remove section mappings and sysfs entries for the
 	 * section of the memory we are removing.
@@ -101,7 +98,7 @@ static int pseries_remove_memblock(unsig
 	sections_to_remove = (memblock_size >> PAGE_SHIFT) / PAGES_PER_SECTION;
 	for (i = 0; i < sections_to_remove; i++) {
 		unsigned long pfn = start_pfn + i * PAGES_PER_SECTION;
-		ret = __remove_pages(zone, start_pfn,  PAGES_PER_SECTION);
+		ret = __remove_pages(start_pfn,  PAGES_PER_SECTION);
 		if (ret)
 			return ret;
 	}

