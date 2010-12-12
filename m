Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401Ab0LMASA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:18:00 -0500
Received: from one.firstfloor.org ([213.235.205.2]:35908 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713Ab0LLXqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:46:12 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: mel@csn.ul.ie, ak@linux.intel.com, czoccolo@gmail.com,
        kosaki.motohiro@jp.fujitsu.com, cl@linux-foundation.org,
        riel@redhat.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [72/223] mm, page-allocator: do not check the state of a non-existant buddy during free
Message-Id: <20101212234610.C9E3DB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:46:10 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Mel Gorman <mel@csn.ul.ie>

commit b7f50cfa3630b6e079929ffccfd442d65064ee1f upstream.

There is a bug in commit 6dda9d55 ("page allocator: reduce fragmentation
in buddy allocator by adding buddies that are merging to the tail of the
free lists") that means a buddy at order MAX_ORDER is checked for merging.
 A page of this order never exists so at times, an effectively random
piece of memory is being checked.

Alan Curry has reported that this is causing memory corruption in
userspace data on a PPC32 platform (http://lkml.org/lkml/2010/10/9/32).
It is not clear why this is happening.  It could be a cache coherency
problem where pages mapped in both user and kernel space are getting
Signed-off-by: Andi Kleen <ak@linux.intel.com>

different cache lines due to the bad read from kernel space
(http://lkml.org/lkml/2010/10/13/179).  It could also be that there are
some special registers being io-remapped at the end of the memmap array
and that a read has special meaning on them.  Compiler bugs have been
ruled out because the assembly before and after the patch looks relatively
harmless.

This patch fixes the problem by ensuring we are not reading a possibly
invalid location of memory.  It's not clear why the read causes corruption
but one way or the other it is a buggy read.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Corrado Zoccolo <czoccolo@gmail.com>
Reported-by: Alan Curry <pacman@kosh.dhis.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/mm/page_alloc.c
===================================================================
--- linux.orig/mm/page_alloc.c
+++ linux/mm/page_alloc.c
@@ -530,7 +530,7 @@ static inline void __free_one_page(struc
 	 * so it's less likely to be used soon and more likely to be merged
 	 * as a higher order page
 	 */
-	if ((order < MAX_ORDER-1) && pfn_valid_within(page_to_pfn(buddy))) {
+	if ((order < MAX_ORDER-2) && pfn_valid_within(page_to_pfn(buddy))) {
 		struct page *higher_page, *higher_buddy;
 		combined_idx = __find_combined_index(page_idx, order);
 		higher_page = page + combined_idx - page_idx;
