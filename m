Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209Ab0LHBA5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:00:57 -0500
Received: from kroah.org ([198.145.64.141]:48887 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757066Ab0LHBAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:00:54 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:32 2010
Message-Id: <20101208005732.558871540@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:58:09 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mel Gorman <mel@csn.ul.ie>, Corrado Zoccolo <czoccolo@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>
Subject: [112/289] mm, page-allocator: do not check the state of a non-existant buddy during free
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -530,7 +530,7 @@ static inline void __free_one_page(struc
 	 * so it's less likely to be used soon and more likely to be merged
 	 * as a higher order page
 	 */
-	if ((order < MAX_ORDER-1) && pfn_valid_within(page_to_pfn(buddy))) {
+	if ((order < MAX_ORDER-2) && pfn_valid_within(page_to_pfn(buddy))) {
 		struct page *higher_page, *higher_buddy;
 		combined_idx = __find_combined_index(page_idx, order);
 		higher_page = page + combined_idx - page_idx;


