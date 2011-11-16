Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab1KPDOb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 22:14:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27117 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784Ab1KPDOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 22:14:30 -0500
Date: Wed, 16 Nov 2011 05:13:50 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>, Jan Kara <jack@suse.cz>,
        Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm: Do not stall in synchronous compaction for THP
 allocations
Message-ID: <20111116041350.GA3306@redhat.com>
References: <CAEwNFnCRCxrru5rBk7FpypqeL8nD=SY5W3-TaA7Ap5o4CgDSbg@mail.gmail.com>
 <20111110161331.GG3083@suse.de>
 <20111110151211.523fa185.akpm@linux-foundation.org>
 <alpine.DEB.2.00.1111101536330.2194@chino.kir.corp.google.com>
 <20111111101414.GJ3083@suse.de>
 <20111114154408.10de1bc7.akpm@linux-foundation.org>
 <20111115132513.GF27150@suse.de>
 <alpine.DEB.2.00.1111151303230.23579@chino.kir.corp.google.com>
 <20111115234845.GK27150@suse.de>
 <alpine.DEB.2.00.1111151554190.3781@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1111151554190.3781@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 04:07:08PM -0800, David Rientjes wrote:
> On Tue, 15 Nov 2011, Mel Gorman wrote:
> 
> > Adding sync here could obviously be implemented although it may
> > require both always-sync and madvise-sync. Alternatively, something
> > like an options file could be created to create a bitmap similar to
> > what ftrace does. Whatever the mechanism, it exposes the fact that
> > "sync compaction" is used. If that turns out to be not enough, then
> > you may want to add other steps like aggressively reclaiming memory
> > which also potentially may need to be controlled via the sysfs file
> > and this is the slippery slope.
> > 
> 
> So what's being proposed here in this patch is the fifth time this line 
> has been changed and its always been switched between true and !(gfp_mask 
> & __GFP_NO_KSWAPD).  Instead of changing it every few months, I'd suggest 
> that we tie the semantics of the tunable directly to sync_compaction since 
> we're primarily targeting thp hugepages with this change anyway for the 
> "always" case.  Comments?

I don't think it's ok. defrag=madvise means __GFP_WAIT not set for
regular THP alloc (without madvise(MADV_HUGEPAGE)) and __GFP_WAIT set
for madvise(MADV_HUGEPAGE).

If __GFP_WAIT isn't set, compaction-async won't be invoked.

After checking my current thp vmstat I think Andrew was right and we
backed out for a good reason before. I'm getting significantly worse
success rate, not sure why it was a small reduction in success rate
but hey I cannot exclude I may have broke something with some other
patch. I've been running it together with a couple more changes. If
it's this change that reduced the success rate, I'm afraid going
always async is not ok.

So before focusing so much on this sync/async flag, I'd like to
understand better why sync stalls so bad. I mean it's not like the VM
with 4k pages won't be doing some throttling too. I suspect we may be
too heavyweight on migrate looping 10 times. Especially with O_DIRECT
the pages may return pinned immediately after they're unpinned (if the
buffer for the I/O is the same like with dd) so there's no point to
wait on pinned pages 10 times around amounting to wait 10*2 = 20MB =
several seconds with usb stick for each 2M allocation. We can reduce
it to less than one second easily. Maybe somebody has time to test if
the below patch helps or not. I understand in some circumstance it may
not help and it'll lead to the same but I think this is good idea
anyway and maybe it helps. Currently we wait on locked pages, on
writeback pages, we retry on pinned pages again and again on locked
pages etc... That's a bit too much I guess, and we don't have to go
complete async to improve the situation I hope.

Could you try if you see any improvement with the below patch? I'm
running with a dd writing in a loop over 1g sd card and I don't see
stalls and success rate seems better than before but I haven't been
noticing the stalls before so I can't tell. (to test you need to
backout the other patches first, this is for 3.2rc2)

If this isn't enough I'd still prefer to find a way to tackle the
problem on a write-throttling way, or at least I'd need to re-verify
why the success rate was so bad with the patch applied (after 4 days
of uptime of normal load). I tend to check the success rate and with
upstream it's about perfect and a little degradation is ok but I was
getting less than 50%. Note with the usb writing in a loop the success
rate may degrade a bit, page will be locked, we won't wait on page
lock and then on writeback and all that slowdown anymore but it'll
still write throttle a bit and it will stop only working on movable
pages and isolating only clean pages like it would have done with
async forced.

===
>From 3a379b180aa544f876d3c42b47ae20060ae6279b Mon Sep 17 00:00:00 2001
From: Andrea Arcangeli <aarcange@redhat.com>
Date: Wed, 16 Nov 2011 02:52:36 +0100
Subject: [PATCH] compaction: avoid overwork in migrate sync mode

Add a migration sync=2 mode that avoids overwork so more suitable to
be used by compaction to provide lower latency but still write
throttling.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 include/linux/migrate.h |    8 ++--
 mm/compaction.c         |    2 +-
 mm/memory-failure.c     |    2 +-
 mm/memory_hotplug.c     |    2 +-
 mm/mempolicy.c          |    4 +-
 mm/migrate.c            |   77 ++++++++++++++++++++++++++++++-----------------
 6 files changed, 58 insertions(+), 37 deletions(-)

diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index e39aeec..f26fc0e 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -14,10 +14,10 @@ extern int migrate_page(struct address_space *,
 			struct page *, struct page *);
 extern int migrate_pages(struct list_head *l, new_page_t x,
 			unsigned long private, bool offlining,
-			bool sync);
+			int sync);
 extern int migrate_huge_pages(struct list_head *l, new_page_t x,
 			unsigned long private, bool offlining,
-			bool sync);
+			int sync);
 
 extern int fail_migrate_page(struct address_space *,
 			struct page *, struct page *);
@@ -36,10 +36,10 @@ extern int migrate_huge_page_move_mapping(struct address_space *mapping,
 static inline void putback_lru_pages(struct list_head *l) {}
 static inline int migrate_pages(struct list_head *l, new_page_t x,
 		unsigned long private, bool offlining,
-		bool sync) { return -ENOSYS; }
+		int sync) { return -ENOSYS; }
 static inline int migrate_huge_pages(struct list_head *l, new_page_t x,
 		unsigned long private, bool offlining,
-		bool sync) { return -ENOSYS; }
+		int sync) { return -ENOSYS; }
 
 static inline int migrate_prep(void) { return -ENOSYS; }
 static inline int migrate_prep_local(void) { return -ENOSYS; }
diff --git a/mm/compaction.c b/mm/compaction.c
index be0be1d..cbf2784 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -555,7 +555,7 @@ static int compact_zone(struct zone *zone, struct compact_control *cc)
 		nr_migrate = cc->nr_migratepages;
 		err = migrate_pages(&cc->migratepages, compaction_alloc,
 				(unsigned long)cc, false,
-				cc->sync);
+				cc->sync ? 2 : 0);
 		update_nr_listpages(cc);
 		nr_remaining = cc->nr_migratepages;
 
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 06d3479..d8a41d3 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1557,7 +1557,7 @@ int soft_offline_page(struct page *page, int flags)
 					    page_is_file_cache(page));
 		list_add(&page->lru, &pagelist);
 		ret = migrate_pages(&pagelist, new_page, MPOL_MF_MOVE_ALL,
-								0, true);
+				    false, 1);
 		if (ret) {
 			putback_lru_pages(&pagelist);
 			pr_info("soft offline: %#lx: migration failed %d, type %lx\n",
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 2168489..e1d6176 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -809,7 +809,7 @@ do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
 		}
 		/* this function returns # of failed pages */
 		ret = migrate_pages(&source, hotremove_migrate_alloc, 0,
-								true, true);
+				    true, 1);
 		if (ret)
 			putback_lru_pages(&source);
 	}
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index adc3954..0bf88ed 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -933,7 +933,7 @@ static int migrate_to_node(struct mm_struct *mm, int source, int dest,
 
 	if (!list_empty(&pagelist)) {
 		err = migrate_pages(&pagelist, new_node_page, dest,
-								false, true);
+				    false, 1);
 		if (err)
 			putback_lru_pages(&pagelist);
 	}
@@ -1154,7 +1154,7 @@ static long do_mbind(unsigned long start, unsigned long len,
 		if (!list_empty(&pagelist)) {
 			nr_failed = migrate_pages(&pagelist, new_vma_page,
 						(unsigned long)vma,
-						false, true);
+						false, 1);
 			if (nr_failed)
 				putback_lru_pages(&pagelist);
 		}
diff --git a/mm/migrate.c b/mm/migrate.c
index 578e291..175c3bc 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -564,7 +564,7 @@ static int fallback_migrate_page(struct address_space *mapping,
  *  == 0 - success
  */
 static int move_to_new_page(struct page *newpage, struct page *page,
-					int remap_swapcache, bool sync)
+			    int remap_swapcache, bool force)
 {
 	struct address_space *mapping;
 	int rc;
@@ -588,11 +588,11 @@ static int move_to_new_page(struct page *newpage, struct page *page,
 		rc = migrate_page(mapping, newpage, page);
 	else {
 		/*
-		 * Do not writeback pages if !sync and migratepage is
+		 * Do not writeback pages if !force and migratepage is
 		 * not pointing to migrate_page() which is nonblocking
 		 * (swapcache/tmpfs uses migratepage = migrate_page).
 		 */
-		if (PageDirty(page) && !sync &&
+		if (PageDirty(page) && !force &&
 		    mapping->a_ops->migratepage != migrate_page)
 			rc = -EBUSY;
 		else if (mapping->a_ops->migratepage)
@@ -622,7 +622,7 @@ static int move_to_new_page(struct page *newpage, struct page *page,
 }
 
 static int __unmap_and_move(struct page *page, struct page *newpage,
-				int force, bool offlining, bool sync)
+			    bool force, bool offlining)
 {
 	int rc = -EAGAIN;
 	int remap_swapcache = 1;
@@ -631,7 +631,7 @@ static int __unmap_and_move(struct page *page, struct page *newpage,
 	struct anon_vma *anon_vma = NULL;
 
 	if (!trylock_page(page)) {
-		if (!force || !sync)
+		if (!force)
 			goto out;
 
 		/*
@@ -676,14 +676,6 @@ static int __unmap_and_move(struct page *page, struct page *newpage,
 	BUG_ON(charge);
 
 	if (PageWriteback(page)) {
-		/*
-		 * For !sync, there is no point retrying as the retry loop
-		 * is expected to be too short for PageWriteback to be cleared
-		 */
-		if (!sync) {
-			rc = -EBUSY;
-			goto uncharge;
-		}
 		if (!force)
 			goto uncharge;
 		wait_on_page_writeback(page);
@@ -751,7 +743,7 @@ static int __unmap_and_move(struct page *page, struct page *newpage,
 
 skip_unmap:
 	if (!page_mapped(page))
-		rc = move_to_new_page(newpage, page, remap_swapcache, sync);
+		rc = move_to_new_page(newpage, page, remap_swapcache, force);
 
 	if (rc && remap_swapcache)
 		remove_migration_ptes(page, page);
@@ -774,7 +766,7 @@ out:
  * to the newly allocated page in newpage.
  */
 static int unmap_and_move(new_page_t get_new_page, unsigned long private,
-			struct page *page, int force, bool offlining, bool sync)
+			  struct page *page, bool force, bool offlining)
 {
 	int rc = 0;
 	int *result = NULL;
@@ -792,7 +784,7 @@ static int unmap_and_move(new_page_t get_new_page, unsigned long private,
 		if (unlikely(split_huge_page(page)))
 			goto out;
 
-	rc = __unmap_and_move(page, newpage, force, offlining, sync);
+	rc = __unmap_and_move(page, newpage, force, offlining);
 out:
 	if (rc != -EAGAIN) {
 		/*
@@ -840,7 +832,7 @@ out:
  */
 static int unmap_and_move_huge_page(new_page_t get_new_page,
 				unsigned long private, struct page *hpage,
-				int force, bool offlining, bool sync)
+				bool force, bool offlining)
 {
 	int rc = 0;
 	int *result = NULL;
@@ -853,7 +845,7 @@ static int unmap_and_move_huge_page(new_page_t get_new_page,
 	rc = -EAGAIN;
 
 	if (!trylock_page(hpage)) {
-		if (!force || !sync)
+		if (!force)
 			goto out;
 		lock_page(hpage);
 	}
@@ -864,7 +856,7 @@ static int unmap_and_move_huge_page(new_page_t get_new_page,
 	try_to_unmap(hpage, TTU_MIGRATION|TTU_IGNORE_MLOCK|TTU_IGNORE_ACCESS);
 
 	if (!page_mapped(hpage))
-		rc = move_to_new_page(new_hpage, hpage, 1, sync);
+		rc = move_to_new_page(new_hpage, hpage, 1, force);
 
 	if (rc)
 		remove_migration_ptes(hpage, hpage);
@@ -907,7 +899,7 @@ out:
  */
 int migrate_pages(struct list_head *from,
 		new_page_t get_new_page, unsigned long private, bool offlining,
-		bool sync)
+		int sync)
 {
 	int retry = 1;
 	int nr_failed = 0;
@@ -920,15 +912,30 @@ int migrate_pages(struct list_head *from,
 	if (!swapwrite)
 		current->flags |= PF_SWAPWRITE;
 
-	for(pass = 0; pass < 10 && retry; pass++) {
+	for(pass = 0; pass < (sync == 1 ? 10 : 2) && retry; pass++) {
 		retry = 0;
 
 		list_for_each_entry_safe(page, page2, from, lru) {
+			bool force;
+
 			cond_resched();
 
+			switch (sync) {
+			case 0:
+				force = false;
+				break;
+			case 1:
+				force = pass > 2;
+				break;
+			case 2:
+				force = pass > 0;
+				break;
+			default:
+				BUG();
+			}
 			rc = unmap_and_move(get_new_page, private,
-						page, pass > 2, offlining,
-						sync);
+					    page,
+					    force, offlining);
 
 			switch(rc) {
 			case -ENOMEM:
@@ -958,7 +965,7 @@ out:
 
 int migrate_huge_pages(struct list_head *from,
 		new_page_t get_new_page, unsigned long private, bool offlining,
-		bool sync)
+		int sync)
 {
 	int retry = 1;
 	int nr_failed = 0;
@@ -967,15 +974,29 @@ int migrate_huge_pages(struct list_head *from,
 	struct page *page2;
 	int rc;
 
-	for (pass = 0; pass < 10 && retry; pass++) {
+	for (pass = 0; pass < (sync == 1 ? 10 : 2) && retry; pass++) {
 		retry = 0;
 
 		list_for_each_entry_safe(page, page2, from, lru) {
+			bool force;
 			cond_resched();
 
+			switch (sync) {
+			case 0:
+				force = false;
+				break;
+			case 1:
+				force = pass > 2;
+				break;
+			case 2:
+				force = pass > 0;
+				break;
+			default:
+				BUG();
+			}
 			rc = unmap_and_move_huge_page(get_new_page,
-					private, page, pass > 2, offlining,
-					sync);
+					private, page,
+					force, offlining);
 
 			switch(rc) {
 			case -ENOMEM:
@@ -1104,7 +1125,7 @@ set_status:
 	err = 0;
 	if (!list_empty(&pagelist)) {
 		err = migrate_pages(&pagelist, new_page_node,
-				(unsigned long)pm, 0, true);
+				    (unsigned long)pm, false, 1);
 		if (err)
 			putback_lru_pages(&pagelist);
 	}
