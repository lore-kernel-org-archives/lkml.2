Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932507Ab2CACp2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 21:45:28 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60633 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758138Ab2CACp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 21:45:27 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of hughd@google.com designates 10.68.130.71 as permitted sender) smtp.mail=hughd@google.com; dkim=pass header.i=hughd@google.com
Date: Wed, 29 Feb 2012 18:44:59 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH v2 next] memcg: fix deadlock by avoiding stat lock when
 anon
In-Reply-To: <alpine.LSU.2.00.1202291648340.11821@eggly.anvils>
Message-ID: <alpine.LSU.2.00.1202291843120.14002@eggly.anvils>
References: <alpine.LSU.2.00.1202282121160.4875@eggly.anvils> <alpine.LSU.2.00.1202282125240.4875@eggly.anvils> <20120229193517.GD1673@cmpxchg.org> <alpine.LSU.2.00.1202291648340.11821@eggly.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix deadlock in "memcg: use new logic for page stat accounting".

page_remove_rmap() first calls mem_cgroup_begin_update_page_stat(),
which may take move_lock_mem_cgroup(), unlocked at the end of
page_remove_rmap() by mem_cgroup_end_update_page_stat().

The PageAnon case never needs to mem_cgroup_dec_page_stat(page,
MEMCG_NR_FILE_MAPPED); but it often needs to mem_cgroup_uncharge_page(),
which does lock_page_cgroup(), while holding that move_lock_mem_cgroup().
Whereas mem_cgroup_move_account() calls move_lock_mem_cgroup() while
holding lock_page_cgroup().

Since mem_cgroup_begin and end are unnecessary here for PageAnon,
simply avoid the deadlock and wasted calls in that case.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
v2: added comment in the code so it's not thought just an optimization.

 mm/rmap.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- 3.3-rc5-next/mm/rmap.c	2012-02-26 23:51:46.506050210 -0800
+++ linux/mm/rmap.c	2012-02-29 17:55:42.868665736 -0800
@@ -1166,10 +1166,18 @@ void page_add_file_rmap(struct page *pag
  */
 void page_remove_rmap(struct page *page)
 {
+	bool anon = PageAnon(page);
 	bool locked;
 	unsigned long flags;
 
-	mem_cgroup_begin_update_page_stat(page, &locked, &flags);
+	/*
+	 * The anon case has no mem_cgroup page_stat to update; but may
+	 * uncharge_page() below, where the lock ordering can deadlock if
+	 * we hold the lock against page_stat move: so avoid it on anon.
+	 */
+	if (!anon)
+		mem_cgroup_begin_update_page_stat(page, &locked, &flags);
+
 	/* page still mapped by someone else? */
 	if (!atomic_add_negative(-1, &page->_mapcount))
 		goto out;
@@ -1181,7 +1189,7 @@ void page_remove_rmap(struct page *page)
 	 * not if it's in swapcache - there might be another pte slot
 	 * containing the swap entry, but page not yet written to swap.
 	 */
-	if ((!PageAnon(page) || PageSwapCache(page)) &&
+	if ((!anon || PageSwapCache(page)) &&
 	    page_test_and_clear_dirty(page_to_pfn(page), 1))
 		set_page_dirty(page);
 	/*
@@ -1190,7 +1198,7 @@ void page_remove_rmap(struct page *page)
 	 */
 	if (unlikely(PageHuge(page)))
 		goto out;
-	if (PageAnon(page)) {
+	if (anon) {
 		mem_cgroup_uncharge_page(page);
 		if (!PageTransHuge(page))
 			__dec_zone_page_state(page, NR_ANON_PAGES);
@@ -1211,7 +1219,8 @@ void page_remove_rmap(struct page *page)
 	 * faster for those pages still in swapcache.
 	 */
 out:
-	mem_cgroup_end_update_page_stat(page, &locked, &flags);
+	if (!anon)
+		mem_cgroup_end_update_page_stat(page, &locked, &flags);
 }
 
 /*
