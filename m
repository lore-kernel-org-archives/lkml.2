Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932420Ab1CYXwo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 19:52:44 -0400
Received: from kroah.org ([198.145.64.141]:41582 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932285Ab1CYXwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:52:35 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 16:45:10 2011
Message-Id: <20110325234510.330229533@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 16:44:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: [24/63] mm: PageBuddy and mapcount robustness
In-Reply-To: <20110325234526.GA18017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andrea Arcangeli <aarcange@redhat.com>

commit ef2b4b95a63a1d23958dcb99eb2c6898eddc87d0 upstream.

Change the _mapcount value indicating PageBuddy from -2 to -128 for
more robusteness against page_mapcount() undeflows.

Use reset_page_mapcount instead of __ClearPageBuddy in bad_page to
ignore the previous retval of PageBuddy().

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reported-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/mm.h |   11 +++++++++--
 mm/page_alloc.c    |    4 ++--
 2 files changed, 11 insertions(+), 4 deletions(-)

--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -402,16 +402,23 @@ static inline void init_page_count(struc
 /*
  * PageBuddy() indicate that the page is free and in the buddy system
  * (see mm/page_alloc.c).
+ *
+ * PAGE_BUDDY_MAPCOUNT_VALUE must be <= -2 but better not too close to
+ * -2 so that an underflow of the page_mapcount() won't be mistaken
+ * for a genuine PAGE_BUDDY_MAPCOUNT_VALUE. -128 can be created very
+ * efficiently by most CPU architectures.
  */
+#define PAGE_BUDDY_MAPCOUNT_VALUE (-128)
+
 static inline int PageBuddy(struct page *page)
 {
-	return atomic_read(&page->_mapcount) == -2;
+	return atomic_read(&page->_mapcount) == PAGE_BUDDY_MAPCOUNT_VALUE;
 }
 
 static inline void __SetPageBuddy(struct page *page)
 {
 	VM_BUG_ON(atomic_read(&page->_mapcount) != -1);
-	atomic_set(&page->_mapcount, -2);
+	atomic_set(&page->_mapcount, PAGE_BUDDY_MAPCOUNT_VALUE);
 }
 
 static inline void __ClearPageBuddy(struct page *page)
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -286,7 +286,7 @@ static void bad_page(struct page *page)
 
 	/* Don't complain about poisoned pages */
 	if (PageHWPoison(page)) {
-		__ClearPageBuddy(page);
+		reset_page_mapcount(page); /* remove PageBuddy */
 		return;
 	}
 
@@ -317,7 +317,7 @@ static void bad_page(struct page *page)
 	dump_stack();
 out:
 	/* Leave bad fields for debug, except PageBuddy could make trouble */
-	__ClearPageBuddy(page);
+	reset_page_mapcount(page); /* remove PageBuddy */
 	add_taint(TAINT_BAD_PAGE);
 }
 


