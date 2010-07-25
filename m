Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481Ab0GYODN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 10:03:13 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35425 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab0GYODM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 10:03:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=S+zUaavD95997C+b/n2WXsz5KS2Tb8HuvZ8iuxTridHvWD5PTFSFpKtEi9oBP5ZC1o
         rqmbxu4h/TqvC2slptvDqzjspak7JV/mHpfP3mJkFXa/St7N1bZ8T4JddIYmmaYrp1f2
         P3TZ8FsSIfj0hURnkR/IHu8IY1THUXIBPTshc=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Johannes Weiner <hannes@cmpxchg.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH] Tight check of pfn_valid on sparsemem - v3
Date: Sun, 25 Jul 2010 23:02:41 +0900
Message-Id: <1280066561-8543-1-git-send-email-minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog since v2
 o Change some function names
 o Remove mark_memmap_hole in memmap bring up
 o Change CONFIG_SPARSEMEM with CONFIG_ARCH_HAS_HOLES_MEMORYMODEL 
 
I have a plan following as after this patch is acked.

TODO:
1) expand pfn_valid to FALTMEM in ARM
I think we can enhance pfn_valid of FLATMEM in ARM.
Now it is doing binary search and it's expesive.
First of all, After we merge this patch, I expand it to FALTMEM of ARM.

2) remove memmap_valid_within
We can remove memmap_valid_within by strict pfn_valid's tight check.

3) Optimize hole check in sparsemem
In case of spasemem, we can optimize pfn_valid through defining new flag
like SECTION_HAS_HOLE of hole mem_section. 

== CUT HERE ==

Kukjin reported oops happen while he change min_free_kbytes
http://www.spinics.net/lists/arm-kernel/msg92894.html
It happen by memory map on sparsemem.

The system has a memory map following as.
     section 0             section 1              section 2
0x20000000-0x25000000, 0x40000000-0x50000000, 0x50000000-0x58000000
SECTION_SIZE_BITS 28(256M)

It means section 0 is an incompletely filled section.
Nontheless, current pfn_valid of sparsemem checks pfn loosely.
It checks only mem_section's validation but ARM can free mem_map on hole
to save memory space. So in above case, pfn on 0x25000000 can pass pfn_valid's
validation check. It's not what we want.

We can match section size to smallest valid size.(ex, above case, 16M)
But Russell doesn't like it due to mem_section's memory overhead with different
configuration(ex, 512K section).

I tried to add valid pfn range in mem_section but everyone doesn't like it
due to size overhead. This patch is suggested by KAMEZAWA-san.
I just fixed compile error and change some naming.

This patch registers address of mem_section to memmap itself's page struct's
pg->private field. This means the page is used for memmap of the section.
Otherwise, the page is used for other purpose and memmap has a hole.

This patch is based on mmotm-2010-07-19

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reported-by: Kukjin Kim <kgene.kim@samsung.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Russell King <linux@arm.linux.org.uk>
---
 arch/arm/mm/init.c                  |    4 +++-
 include/linux/mmzone.h              |   22 +++++++++++++++++++++-
 mm/mmzone.c                         |   34 ++++++++++++++++++++++++++++++++++
 5 files changed, 58 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index f6a9994..25e2670 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -482,8 +482,10 @@ free_memmap(int node, unsigned long start_pfn, unsigned long end_pfn)
 	 * If there are free pages between these,
 	 * free the section of the memmap array.
 	 */
-	if (pg < pgend)
+	if (pg < pgend) {
+ 		mark_invalid_memmap(pg >> PAGE_SHIFT, pgend >> PAGE_SHIFT);
 		free_bootmem_node(NODE_DATA(node), pg, pgend - pg);
+	}
 }
 
 /*
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index b4d109e..a3195bd 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -15,6 +15,7 @@
 #include <linux/seqlock.h>
 #include <linux/nodemask.h>
 #include <linux/pageblock-flags.h>
+#include <linux/mm_types.h>
 #include <generated/bounds.h>
 #include <asm/atomic.h>
 #include <asm/page.h>
@@ -1049,11 +1050,30 @@ static inline struct mem_section *__pfn_to_section(unsigned long pfn)
 	return __nr_to_section(pfn_to_section_nr(pfn));
 }
 
+void mark_invalid_memmap(unsigned long start, unsigned long end);
+
+#ifdef CONFIG_ARCH_HAS_HOLES_MEMORYMODEL
+#define MEMMAP_HOLE	(0x1UL)
+static inline int memmap_valid(unsigned long pfn)
+{
+	struct page *page = pfn_to_page(pfn);
+	struct page *__pg = virt_to_page(page);
+	return !(__pg->private & MEMMAP_HOLE);
+}
+#else
+static inline int memmap_valid(unsigned long pfn)
+{
+	return 1;
+}
+#endif
+
 static inline int pfn_valid(unsigned long pfn)
 {
+	struct mem_section *ms;
 	if (pfn_to_section_nr(pfn) >= NR_MEM_SECTIONS)
 		return 0;
-	return valid_section(__nr_to_section(pfn_to_section_nr(pfn)));
+	ms = __nr_to_section(pfn_to_section_nr(pfn));
+	return valid_section(ms) && memmap_valid(pfn);
 }
 
 static inline int pfn_present(unsigned long pfn)
diff --git a/mm/mmzone.c b/mm/mmzone.c
index f5b7d17..7c84e5e 100644
--- a/mm/mmzone.c
+++ b/mm/mmzone.c
@@ -86,4 +86,38 @@ int memmap_valid_within(unsigned long pfn,
 
 	return 1;
 }
+
+/*
+ * Fill pg->private on hole memmap with MEMMAP_HOLE.
+ * pfn_valid() will check this later. (see include/linux/mmzone.h)
+ * Evenry arch should call
+ * 	mark_invalid_memmap(start, end) # for all holes in mem_map.
+ * please see usage in ARM.
+ */
+void mark_invalid_memmap(unsigned long start, unsigned long end)
+{
+	struct mem_section *ms;
+	unsigned long pos, next;
+	struct page *pg;
+	void *memmap, *mapend;
+
+	for (pos = start; pos < end; pos = next) {
+		next = (pos + PAGES_PER_SECTION) & PAGE_SECTION_MASK;
+		ms = __pfn_to_section(pos);
+		if (!valid_section(ms))
+			continue;
+
+		for (memmap = (void*)pfn_to_page(pos),
+			/* The last page in section */
+			mapend = pfn_to_page(next-1);
+			memmap < mapend; memmap += PAGE_SIZE) {
+			pg = virt_to_page(memmap);
+			pg->private = MEMMAP_HOLE;
+		}
+	}
+}
+#else
+void mark_invalid_memmap(unsigned long start, unsigned long end)
+{
+}
 #endif /* CONFIG_ARCH_HAS_HOLES_MEMORYMODEL */
-- 
1.7.0.5

