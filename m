Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916Ab2DXSWv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 14:22:51 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:35148 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755956Ab2DXSWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 14:22:49 -0400
Date: Tue, 24 Apr 2012 20:22:33 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] memcg: fix Bad page state after replace_page_cache
Message-ID: <20120424182233.GA22625@cmpxchg.org>
References: <alpine.LSU.2.00.1204182325350.3700@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1204182325350.3700@eggly.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 11:34:46PM -0700, Hugh Dickins wrote:
> My 9ce70c0240d0 "memcg: fix deadlock by inverting lrucare nesting" put a
> nasty little bug into v3.3's version of mem_cgroup_replace_page_cache(),
> sometimes used for FUSE.  Replacing __mem_cgroup_commit_charge_lrucare()
> by __mem_cgroup_commit_charge(), I used the "pc" pointer set up earlier:
> but it's for oldpage, and needs now to be for newpage.  Once oldpage was
> freed, its PageCgroupUsed bit (cleared above but set again here) caused
> "Bad page state" messages - and perhaps worse, being missed from newpage.
> (I didn't find this by using FUSE, but in reusing the function for tmpfs.)
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Cc: stable@vger.kernel.org [v3.3 only]

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

This is the second bug of this nature and none of the callsites are
actually using the pc themselves, so we should probably move the pc
lookup into __mem_cgroup_commit_charge() itself.

---
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [patch] mm: memcg: move pc lookup point to commit_charge()

None of the callsites actually need the page_cgroup descriptor
themselves, so just pass the page and do the look up in there.

We already had two bugs (6568d4a 'mm: memcg: update the correct soft
limit tree during migration' and 'memcg: fix Bad page state after
replace_page_cache') where the passed page and pc were not referring
to the same page frame.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c |   17 +++++------------
 1 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 884e936..1a28dd8 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2461,10 +2461,10 @@ struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page)
 static void __mem_cgroup_commit_charge(struct mem_cgroup *memcg,
 				       struct page *page,
 				       unsigned int nr_pages,
-				       struct page_cgroup *pc,
 				       enum charge_type ctype,
 				       bool lrucare)
 {
+	struct page_cgroup *pc = lookup_page_cgroup(page);
 	struct zone *uninitialized_var(zone);
 	bool was_on_lru = false;
 	bool anon;
@@ -2701,7 +2701,6 @@ static int mem_cgroup_charge_common(struct page *page, struct mm_struct *mm,
 {
 	struct mem_cgroup *memcg = NULL;
 	unsigned int nr_pages = 1;
-	struct page_cgroup *pc;
 	bool oom = true;
 	int ret;
 
@@ -2715,11 +2714,10 @@ static int mem_cgroup_charge_common(struct page *page, struct mm_struct *mm,
 		oom = false;
 	}
 
-	pc = lookup_page_cgroup(page);
 	ret = __mem_cgroup_try_charge(mm, gfp_mask, nr_pages, &memcg, oom);
 	if (ret == -ENOMEM)
 		return ret;
-	__mem_cgroup_commit_charge(memcg, page, nr_pages, pc, ctype, false);
+	__mem_cgroup_commit_charge(memcg, page, nr_pages, ctype, false);
 	return 0;
 }
 
@@ -2816,16 +2814,13 @@ static void
 __mem_cgroup_commit_charge_swapin(struct page *page, struct mem_cgroup *memcg,
 					enum charge_type ctype)
 {
-	struct page_cgroup *pc;
-
 	if (mem_cgroup_disabled())
 		return;
 	if (!memcg)
 		return;
 	cgroup_exclude_rmdir(&memcg->css);
 
-	pc = lookup_page_cgroup(page);
-	__mem_cgroup_commit_charge(memcg, page, 1, pc, ctype, true);
+	__mem_cgroup_commit_charge(memcg, page, 1, ctype, true);
 	/*
 	 * Now swap is on-memory. This means this page may be
 	 * counted both as mem and swap....double count.
@@ -3254,14 +3249,13 @@ int mem_cgroup_prepare_migration(struct page *page,
 	 * page. In the case new page is migrated but not remapped, new page's
 	 * mapcount will be finally 0 and we call uncharge in end_migration().
 	 */
-	pc = lookup_page_cgroup(newpage);
 	if (PageAnon(page))
 		ctype = MEM_CGROUP_CHARGE_TYPE_MAPPED;
 	else if (page_is_file_cache(page))
 		ctype = MEM_CGROUP_CHARGE_TYPE_CACHE;
 	else
 		ctype = MEM_CGROUP_CHARGE_TYPE_SHMEM;
-	__mem_cgroup_commit_charge(memcg, newpage, 1, pc, ctype, false);
+	__mem_cgroup_commit_charge(memcg, newpage, 1, ctype, false);
 	return ret;
 }
 
@@ -3348,8 +3342,7 @@ void mem_cgroup_replace_page_cache(struct page *oldpage,
 	 * the newpage may be on LRU(or pagevec for LRU) already. We lock
 	 * LRU while we overwrite pc->mem_cgroup.
 	 */
-	pc = lookup_page_cgroup(newpage);
-	__mem_cgroup_commit_charge(memcg, newpage, 1, pc, type, true);
+	__mem_cgroup_commit_charge(memcg, newpage, 1, type, true);
 }
 
 #ifdef CONFIG_DEBUG_VM
-- 
1.7.7.6

