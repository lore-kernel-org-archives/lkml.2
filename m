Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab2HCHrE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 03:47:04 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:18201 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753043Ab2HCHpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 03:45:08 -0400
X-IronPort-AV: E=Sophos;i="4.77,705,1336320000"; 
   d="scan'208";a="5544430"
From: wency@cn.fujitsu.com
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-ia64@vger.kernel.org, cmetcalf@tilera.com
Cc: rientjes@google.com, liuj97@gmail.com, len.brown@intel.com,
        benh@kernel.crashing.org, paulus@samba.org, cl@linux.com,
        minchan.kim@gmail.com, akpm@linux-foundation.org,
        kosaki.motohiro@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        Wen Congyang <wency@cn.fujitsu.com>
Subject: [RFC PATCH V6 11/19] memory-hotplug: remove_memory calls __remove_pages
Date: Fri, 3 Aug 2012 15:49:13 +0800
Message-Id: <1343980161-14254-12-git-send-email-wency@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1343980161-14254-1-git-send-email-wency@cn.fujitsu.com>
References: <1343980161-14254-1-git-send-email-wency@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/03 15:45:24,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/03 15:45:26,
	Serialize complete at 2012/08/03 15:45:26
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

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
CC: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
---
 arch/powerpc/platforms/pseries/hotplug-memory.c |    5 +----
 include/linux/memory_hotplug.h                  |    3 +--
 mm/memory_hotplug.c                             |   18 +++++++++++-------
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/hotplug-memory.c b/arch/powerpc/platforms/pseries/hotplug-memory.c
index dc0a035..cc14da4 100644
--- a/arch/powerpc/platforms/pseries/hotplug-memory.c
+++ b/arch/powerpc/platforms/pseries/hotplug-memory.c
@@ -76,7 +76,6 @@ unsigned long memory_block_size_bytes(void)
 static int pseries_remove_memblock(unsigned long base, unsigned int memblock_size)
 {
 	unsigned long start, start_pfn;
-	struct zone *zone;
 	int i, ret;
 	int sections_to_remove;
 
@@ -87,8 +86,6 @@ static int pseries_remove_memblock(unsigned long base, unsigned int memblock_siz
 		return 0;
 	}
 
-	zone = page_zone(pfn_to_page(start_pfn));
-
 	/*
 	 * Remove section mappings and sysfs entries for the
 	 * section of the memory we are removing.
@@ -101,7 +98,7 @@ static int pseries_remove_memblock(unsigned long base, unsigned int memblock_siz
 	sections_to_remove = (memblock_size >> PAGE_SHIFT) / PAGES_PER_SECTION;
 	for (i = 0; i < sections_to_remove; i++) {
 		unsigned long pfn = start_pfn + i * PAGES_PER_SECTION;
-		ret = __remove_pages(zone, start_pfn,  PAGES_PER_SECTION);
+		ret = __remove_pages(start_pfn,  PAGES_PER_SECTION);
 		if (ret)
 			return ret;
 	}
diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index fd84ea9..8bf820d 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -90,8 +90,7 @@ extern bool is_pageblock_removable_nolock(struct page *page);
 /* reasonably generic interface to expand the physical pages in a zone  */
 extern int __add_pages(int nid, struct zone *zone, unsigned long start_pfn,
 	unsigned long nr_pages);
-extern int __remove_pages(struct zone *zone, unsigned long start_pfn,
-	unsigned long nr_pages);
+extern int __remove_pages(unsigned long start_pfn, unsigned long nr_pages);
 
 #ifdef CONFIG_NUMA
 extern int memory_add_physaddr_to_nid(u64 start);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 29aff4d..713f1b9 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -275,11 +275,14 @@ static int __meminit __add_section(int nid, struct zone *zone,
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
 static int __remove_section(struct zone *zone, struct mem_section *ms)
 {
-	/*
-	 * XXX: Freeing memmap with vmemmap is not implement yet.
-	 *      This should be removed later.
-	 */
-	return -EBUSY;
+	int ret = -EINVAL;
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
@@ -363,6 +366,7 @@ int __remove_pages(struct zone *zone, unsigned long phys_start_pfn,
 	sections_to_remove = nr_pages / PAGES_PER_SECTION;
 	for (i = 0; i < sections_to_remove; i++) {
 		unsigned long pfn = phys_start_pfn + i*PAGES_PER_SECTION;
+		zone = page_zone(pfn_to_page(pfn));
 		ret = __remove_section(zone, __pfn_to_section(pfn));
 		if (ret)
 			break;
-- 
1.7.1

