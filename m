Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904Ab0IRT3Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:29:25 -0400
Received: from kroah.org ([198.145.64.141]:43487 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756812Ab0IRTPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:15:23 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:02 2010
Message-Id: <20100918191302.666328887@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:12:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Ondrej Zary <linux@rainbow-software.org>,
        Andrea Gelmini <andrea.gelmini@gmail.com>,
        Balbir Singh <balbir@in.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Nigel Cunningham <nigel@tuxonice.net>
Subject: [062/129] swap: prevent reuse during hibernation
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hugh Dickins <hughd@google.com>

commit b73d7fcecd93dc15eaa3c45c8c587b613f6673c4 upstream.

Move the hibernation check from scan_swap_map() into try_to_free_swap():
to catch not only the common case when hibernation's allocation itself
triggers swap reuse, but also the less likely case when concurrent page
reclaim (shrink_page_list) might happen to try_to_free_swap from a page.

Hibernation already clears __GFP_IO from the gfp_allowed_mask, to stop
reclaim from going to swap: check that to prevent swap reuse too.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ondrej Zary <linux@rainbow-software.org>
Cc: Andrea Gelmini <andrea.gelmini@gmail.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Nigel Cunningham <nigel@tuxonice.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/swapfile.c |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -318,10 +318,8 @@ checks:
 	if (offset > si->highest_bit)
 		scan_base = offset = si->lowest_bit;
 
-	/* reuse swap entry of cache-only swap if not hibernation. */
-	if (vm_swap_full()
-		&& usage == SWAP_HAS_CACHE
-		&& si->swap_map[offset] == SWAP_HAS_CACHE) {
+	/* reuse swap entry of cache-only swap if not busy. */
+	if (vm_swap_full() && si->swap_map[offset] == SWAP_HAS_CACHE) {
 		int swap_was_freed;
 		spin_unlock(&swap_lock);
 		swap_was_freed = __try_to_reclaim_swap(si, offset);
@@ -688,6 +686,24 @@ int try_to_free_swap(struct page *page)
 	if (page_swapcount(page))
 		return 0;
 
+	/*
+	 * Once hibernation has begun to create its image of memory,
+	 * there's a danger that one of the calls to try_to_free_swap()
+	 * - most probably a call from __try_to_reclaim_swap() while
+	 * hibernation is allocating its own swap pages for the image,
+	 * but conceivably even a call from memory reclaim - will free
+	 * the swap from a page which has already been recorded in the
+	 * image as a clean swapcache page, and then reuse its swap for
+	 * another page of the image.  On waking from hibernation, the
+	 * original page might be freed under memory pressure, then
+	 * later read back in from swap, now with the wrong data.
+	 *
+	 * Hibernation clears bits from gfp_allowed_mask to prevent
+	 * memory reclaim from writing to disk, so check that here.
+	 */
+	if (!(gfp_allowed_mask & __GFP_IO))
+		return 0;
+
 	delete_from_swap_cache(page);
 	SetPageDirty(page);
 	return 1;


