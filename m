Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584Ab0IFIMd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 04:12:33 -0400
Received: from smtp-out.google.com ([216.239.44.51]:52305 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450Ab0IFIM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 04:12:28 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=JcsMP/bQAvRw6PMQuQlAkZ52e1QeDSR0+zD49IT5XW/FrifNXaAEIY7AI74oshA+a
	weWdaP0MeKGgquTh1+c1g==
Date: Mon, 6 Sep 2010 01:12:38 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Ondrej Zary <linux@rainbow-software.org>,
        Andrea Gelmini <andrea.gelmini@gmail.com>,
        Balbir Singh <balbir@in.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Nigel Cunningham <nigel@tuxonice.net>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] swap: prevent reuse during hibernation
In-Reply-To: <alpine.LSU.2.00.1009060104410.13600@sister.anvils>
Message-ID: <alpine.LSU.2.00.1009060111220.13600@sister.anvils>
References: <alpine.LSU.2.00.1009060104410.13600@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: stable@kernel.org
---

 mm/swapfile.c |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

--- swap1/mm/swapfile.c	2010-09-05 22:37:07.000000000 -0700
+++ swap2/mm/swapfile.c	2010-09-05 22:45:54.000000000 -0700
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
