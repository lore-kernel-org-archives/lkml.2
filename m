Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab1JQOZt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 10:25:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27320 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250Ab1JQOZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 10:25:47 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Christoph Lameter <cl@linux-foundation.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [RFC 2/3] PM / Hibernate : do not count debug pages as savable
Date: Mon, 17 Oct 2011 16:24:45 +0200
Message-Id: <1318861486-3942-2-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1318861486-3942-1-git-send-email-sgruszka@redhat.com>
References: <1318861486-3942-1-git-send-email-sgruszka@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When debugging memory corruption with CONFIG_DEBUG_PAGEALLOC and
corrupt_dbg > 0, we have lot of free pages that are not marked so.
Snapshot code account them as savable, what cause hibernate memory
preallocation failure.

It is pretty hard to make hibernate allocation succeed with
corrupt_dbg=1. This change at least make it possible when system has
relatively big amount of RAM.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 include/linux/mm.h      |    7 ++++++-
 kernel/power/snapshot.c |    6 ++++++
 mm/page_alloc.c         |    6 ------
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 17e3658..651785b 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1630,13 +1630,18 @@ extern void copy_user_huge_page(struct page *dst, struct page *src,
 #ifdef CONFIG_DEBUG_PAGEALLOC
 extern unsigned int _corrupt_dbg;
 
-
 static inline unsigned int corrupt_dbg(void)
 {
 	return _corrupt_dbg;
 }
+
+static inline bool page_is_corrupt_dbg(struct page *page)
+{
+	return test_bit(PAGE_DEBUG_FLAG_CORRUPT, &page->debug_flags);
+}
 #else
 static inline unsigned int corrupt_dbg(void) { return 0; }
+static inline bool page_is_corrupt_dbg(struct page *page) { return false; }
 #endif /* CONFIG_DEBUG_PAGEALLOC */
 
 #endif /* __KERNEL__ */
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 06efa54..45cf1b1 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -858,6 +858,9 @@ static struct page *saveable_highmem_page(struct zone *zone, unsigned long pfn)
 	    PageReserved(page))
 		return NULL;
 
+	if (page_is_corrupt_dbg(page))
+		return NULL;
+
 	return page;
 }
 
@@ -920,6 +923,9 @@ static struct page *saveable_page(struct zone *zone, unsigned long pfn)
 	    && (!kernel_page_present(page) || pfn_is_nosave(pfn)))
 		return NULL;
 
+	if (page_is_corrupt_dbg(page))
+		return NULL;
+
 	return page;
 }
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 8d18ae4..8a7770a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -425,15 +425,9 @@ static inline void clear_page_corrupt_dbg(struct page *page)
 	__clear_bit(PAGE_DEBUG_FLAG_CORRUPT, &page->debug_flags);
 }
 
-static inline bool page_is_corrupt_dbg(struct page *page)
-{
-	return test_bit(PAGE_DEBUG_FLAG_CORRUPT, &page->debug_flags);
-}
-
 #else
 static inline void set_page_corrupt_dbg(struct page *page) { }
 static inline void clear_page_corrupt_dbg(struct page *page) { }
-static inline bool page_is_corrupt_dbg(struct page *page) { return false; }
 #endif
 
 static inline void set_page_order(struct page *page, int order)
-- 
1.7.1

