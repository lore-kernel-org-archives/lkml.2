Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083Ab2K1BPx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 20:15:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50404 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213Ab2K1BPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 20:15:52 -0500
Date: Tue, 27 Nov 2012 17:15:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rafael Aquini <aquini@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] mm: fix balloon_page_movable() page->flags check
Message-Id: <20121127171544.8bbb702a.akpm@linux-foundation.org>
In-Reply-To: <20121128003409.GB7401@t510.redhat.com>
References: <20121127145708.c7173d0d.akpm@linux-foundation.org>
	<1ccb1c95a52185bcc6009761cb2829197e2737ea.1354058194.git.aquini@redhat.com>
	<20121127155201.ddfea7e1.akpm@linux-foundation.org>
	<20121128003409.GB7401@t510.redhat.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Nov 2012 22:34:10 -0200 Rafael Aquini <aquini@redhat.com> wrote:

> Do you want me to resubmit this patch with the changes you suggested?

oh, I think I can reach that far.  How's this look?

From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-introduce-a-common-interface-for-balloon-pages-mobility-mm-fix-balloon_page_movable-page-flags-check-fix

use PAGE_FLAGS_CHECK_AT_PREP, s/__balloon_page_flags/page_flags_cleared/, small cleanups

Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/balloon_compaction.h |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff -puN include/linux/balloon_compaction.h~mm-introduce-a-common-interface-for-balloon-pages-mobility-mm-fix-balloon_page_movable-page-flags-check-fix include/linux/balloon_compaction.h
--- a/include/linux/balloon_compaction.h~mm-introduce-a-common-interface-for-balloon-pages-mobility-mm-fix-balloon_page_movable-page-flags-check-fix
+++ a/include/linux/balloon_compaction.h
@@ -41,6 +41,7 @@
 #ifndef _LINUX_BALLOON_COMPACTION_H
 #define _LINUX_BALLOON_COMPACTION_H
 #include <linux/pagemap.h>
+#include <linux/page-flags.h>
 #include <linux/migrate.h>
 #include <linux/gfp.h>
 #include <linux/err.h>
@@ -109,18 +110,16 @@ static inline void balloon_mapping_free(
 /*
  * __balloon_page_flags - helper to perform balloon @page ->flags tests.
  *
- * As balloon pages are got from Buddy, and we do not play with page->flags
+ * As balloon pages are obtained from buddy and we do not play with page->flags
  * at driver level (exception made when we get the page lock for compaction),
- * therefore we can safely identify a ballooned page by checking if the
- * NR_PAGEFLAGS rightmost bits from the page->flags are all cleared.
- * This approach also helps on skipping ballooned pages that are locked for
- * compaction or release, thus mitigating their racy check at
- * balloon_page_movable()
+ * we can safely identify a ballooned page by checking if the
+ * PAGE_FLAGS_CHECK_AT_PREP page->flags are all cleared.  This approach also
+ * helps us skip ballooned pages that are locked for compaction or release, thus
+ * mitigating their racy check at balloon_page_movable()
  */
-#define BALLOON_PAGE_FLAGS_MASK       ((1UL << NR_PAGEFLAGS) - 1)
-static inline bool __balloon_page_flags(struct page *page)
+static inline bool page_flags_cleared(struct page *page)
 {
-	return page->flags & BALLOON_PAGE_FLAGS_MASK ? false : true;
+	return !(page->flags & PAGE_FLAGS_CHECK_AT_PREP);
 }
 
 /*
@@ -149,10 +148,10 @@ static inline bool __is_movable_balloon_
 static inline bool balloon_page_movable(struct page *page)
 {
 	/*
-	 * Before dereferencing and testing mapping->flags, lets make sure
+	 * Before dereferencing and testing mapping->flags, let's make sure
 	 * this is not a page that uses ->mapping in a different way
 	 */
-	if (__balloon_page_flags(page) && !page_mapped(page) &&
+	if (page_flags_cleared(page) && !page_mapped(page) &&
 	    page_count(page) == 1)
 		return __is_movable_balloon_page(page);
 
_

