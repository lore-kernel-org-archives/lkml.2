Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab1HQQkm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 12:40:42 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:54673 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903Ab1HQQkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 12:40:40 -0400
X-IronPort-AV: E=Sophos;i="4.68,240,1312171200"; 
   d="scan'208";a="159143965"
From: Ian Campbell <ian.campbell@citrix.com>
To: linux-kernel@vger.kernel.org
CC: Ian Campbell <ian.campbell@citrix.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Michel Lespinasse <walken@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] mm: fix __page_to_pfn for a const struct page argument
Date: Wed, 17 Aug 2011 17:40:33 +0100
Message-ID: <1313599233-16595-1-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows the cast in lowmem_page_address (introduced as a warning fixup to
33dd4e0ec911 "mm: make some struct page's const") to be removed.

Propagate const'ness to page_to_section() as well since it is required by
__page_to_pfn.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 include/asm-generic/memory_model.h |    4 ++--
 include/linux/mm.h                 |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/asm-generic/memory_model.h b/include/asm-generic/memory_model.h
index fb2d63f..aea9e45 100644
--- a/include/asm-generic/memory_model.h
+++ b/include/asm-generic/memory_model.h
@@ -39,7 +39,7 @@
 })
 
 #define __page_to_pfn(pg)						\
-({	struct page *__pg = (pg);					\
+({	const struct page *__pg = (pg);					\
 	struct pglist_data *__pgdat = NODE_DATA(page_to_nid(__pg));	\
 	(unsigned long)(__pg - __pgdat->node_mem_map) +			\
 	 __pgdat->node_start_pfn;					\
@@ -57,7 +57,7 @@
  * section[i].section_mem_map == mem_map's address - start_pfn;
  */
 #define __page_to_pfn(pg)					\
-({	struct page *__pg = (pg);				\
+({	const struct page *__pg = (pg);				\
 	int __sec = page_to_section(__pg);			\
 	(unsigned long)(__pg - __section_mem_map_addr(__nr_to_section(__sec)));	\
 })
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 12793b6..9e5d965 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -689,7 +689,7 @@ static inline void set_page_section(struct page *page, unsigned long section)
 	page->flags |= (section & SECTIONS_MASK) << SECTIONS_PGSHIFT;
 }
 
-static inline unsigned long page_to_section(struct page *page)
+static inline unsigned long page_to_section(const struct page *page)
 {
 	return (page->flags >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
 }
@@ -724,7 +724,7 @@ static inline void set_page_links(struct page *page, enum zone_type zone,
 
 static __always_inline void *lowmem_page_address(const struct page *page)
 {
-	return __va(PFN_PHYS(page_to_pfn((struct page *)page)));
+	return __va(PFN_PHYS(page_to_pfn(page)));
 }
 
 #if defined(CONFIG_HIGHMEM) && !defined(WANT_PAGE_VIRTUAL)
-- 
1.7.2.5

