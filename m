Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab1DOKBt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 06:01:49 -0400
Received: from smtp.nokia.com ([147.243.128.26]:44693 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753549Ab1DOKBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 06:01:48 -0400
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: akpm@linux-foundation.org
Cc: aarcange@redhat.com, cl@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mm: make read-only accessors take const parameters
Date: Fri, 15 Apr 2011 12:56:17 +0300
Message-Id: <1302861377-8048-2-git-send-email-ext-phil.2.carmody@nokia.com>
X-Mailer: git-send-email 1.7.2.rc1.37.gf8c40
In-Reply-To: <1302861377-8048-1-git-send-email-ext-phil.2.carmody@nokia.com>
References: <1302861377-8048-1-git-send-email-ext-phil.2.carmody@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pulling out bits from flags and atomic_read() do not modify
anything, nor do we want to modify anything. We can extend that
insight to clients. This makes static code analysis easier.

I'm not happy with the _ro bloat, but at least it doesn't change
the size of the generated code. An alternative would be a type-
less macro.

Also cleaned up some unnecessary (brackets).

Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
---
 include/linux/mm.h         |   27 +++++++++++++++++----------
 include/linux/page-flags.h |    8 ++++----
 2 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 692dbae..7134563 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -353,9 +353,16 @@ static inline struct page *compound_head(struct page *page)
 	return page;
 }
 
-static inline int page_count(struct page *page)
+static inline const struct page *compound_head_ro(const struct page *page)
 {
-	return atomic_read(&compound_head(page)->_count);
+	if (unlikely(PageTail(page)))
+		return page->first_page;
+	return page;
+}
+
+static inline int page_count(const struct page *page)
+{
+	return atomic_read(&compound_head_ro(page)->_count);
 }
 
 static inline void get_page(struct page *page)
@@ -638,7 +645,7 @@ static inline pte_t maybe_mkwrite(pte_t pte, struct vm_area_struct *vma)
 #define SECTIONS_MASK		((1UL << SECTIONS_WIDTH) - 1)
 #define ZONEID_MASK		((1UL << ZONEID_SHIFT) - 1)
 
-static inline enum zone_type page_zonenum(struct page *page)
+static inline enum zone_type page_zonenum(const struct page *page)
 {
 	return (page->flags >> ZONES_PGSHIFT) & ZONES_MASK;
 }
@@ -651,7 +658,7 @@ static inline enum zone_type page_zonenum(struct page *page)
  * We guarantee only that it will return the same value for two
  * combinable pages in a zone.
  */
-static inline int page_zone_id(struct page *page)
+static inline int page_zone_id(const struct page *page)
 {
 	return (page->flags >> ZONEID_PGSHIFT) & ZONEID_MASK;
 }
@@ -786,7 +793,7 @@ static inline void *page_rmapping(struct page *page)
 	return (void *)((unsigned long)page->mapping & ~PAGE_MAPPING_FLAGS);
 }
 
-static inline int PageAnon(struct page *page)
+static inline int PageAnon(const struct page *page)
 {
 	return ((unsigned long)page->mapping & PAGE_MAPPING_ANON) != 0;
 }
@@ -809,20 +816,20 @@ static inline pgoff_t page_index(struct page *page)
  */
 static inline void reset_page_mapcount(struct page *page)
 {
-	atomic_set(&(page)->_mapcount, -1);
+	atomic_set(&page->_mapcount, -1);
 }
 
-static inline int page_mapcount(struct page *page)
+static inline int page_mapcount(const struct page *page)
 {
-	return atomic_read(&(page)->_mapcount) + 1;
+	return atomic_read(&page->_mapcount) + 1;
 }
 
 /*
  * Return true if this page is mapped into pagetables.
  */
-static inline int page_mapped(struct page *page)
+static inline int page_mapped(const struct page *page)
 {
-	return atomic_read(&(page)->_mapcount) >= 0;
+	return atomic_read(&page->_mapcount) >= 0;
 }
 
 /*
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 811183d..7f8e553 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -135,7 +135,7 @@ enum pageflags {
  * Macros to create function definitions for page flags
  */
 #define TESTPAGEFLAG(uname, lname)					\
-static inline int Page##uname(struct page *page) 			\
+static inline int Page##uname(const struct page *page)			\
 			{ return test_bit(PG_##lname, &page->flags); }
 
 #define SETPAGEFLAG(uname, lname)					\
@@ -173,7 +173,7 @@ static inline int __TestClearPage##uname(struct page *page)		\
 	__SETPAGEFLAG(uname, lname)  __CLEARPAGEFLAG(uname, lname)
 
 #define PAGEFLAG_FALSE(uname) 						\
-static inline int Page##uname(struct page *page) 			\
+static inline int Page##uname(const struct page *page)			\
 			{ return 0; }
 
 #define TESTSCFLAG(uname, lname)					\
@@ -345,7 +345,7 @@ static inline void set_page_writeback(struct page *page)
 __PAGEFLAG(Head, head) CLEARPAGEFLAG(Head, head)
 __PAGEFLAG(Tail, tail)
 
-static inline int PageCompound(struct page *page)
+static inline int PageCompound(const struct page *page)
 {
 	return page->flags & ((1L << PG_head) | (1L << PG_tail));
 
@@ -379,7 +379,7 @@ __PAGEFLAG(Head, compound)
  */
 #define PG_head_tail_mask ((1L << PG_compound) | (1L << PG_reclaim))
 
-static inline int PageTail(struct page *page)
+static inline int PageTail(const struct page *page)
 {
 	return ((page->flags & PG_head_tail_mask) == PG_head_tail_mask);
 }
-- 
1.7.2.rc1.37.gf8c40

