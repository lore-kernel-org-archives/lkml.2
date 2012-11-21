Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823Ab2KUMWA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 07:22:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50126 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958Ab2KUMV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 07:21:59 -0500
Date: Wed, 21 Nov 2012 12:21:52 +0000
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>
Cc: Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Alex Shi <lkml.alex@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 37/46] mm: numa: Add THP migration for the NUMA working
 set scanning fault case.
Message-ID: <20121121122152.GC8218@suse.de>
References: <1353493312-8069-1-git-send-email-mgorman@suse.de>
 <1353493312-8069-38-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1353493312-8069-38-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 10:21:43AM +0000, Mel Gorman wrote:
> Note: This is very heavily based on a patch from Peter Zijlstra with
> 	fixes from Ingo Molnar, Hugh Dickins and Johannes Weiner.  That patch
> 	put a lot of migration logic into mm/huge_memory.c where it does
> 	not belong. This version puts tries to share some of the migration
> 	logic with migrate_misplaced_page.  However, it should be noted
> 	that now migrate.c is doing more with the pagetable manipulation
> 	than is preferred. The end result is barely recognisable so as
> 	before, the signed-offs had to be removed but will be re-added if
> 	the original authors are ok with it.
> 
> Add THP migration for the NUMA working set scanning fault case.
> 
> It uses the page lock to serialize. No migration pte dance is
> necessary because the pte is already unmapped when we decide
> to migrate.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

I think these are the obvious missing bits for memcg.

diff --git a/mm/internal.h b/mm/internal.h
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -212,11 +212,12 @@ static inline void mlock_migrate_page(struct page *newpage, struct page *page)
 {
 	if (TestClearPageMlocked(page)) {
 		unsigned long flags;
+		int nr_pages = hpage_nr_pages(page);
 
 		local_irq_save(flags);
-		__dec_zone_page_state(page, NR_MLOCK);
+		__mod_zone_page_state(page_zone(page), NR_MLOCK, -nr_pages);
 		SetPageMlocked(newpage);
-		__inc_zone_page_state(newpage, NR_MLOCK);
+		__mod_zone_page_state(page_zone(newpage), NR_MLOCK, nr_pages);
 		local_irq_restore(flags);
 	}
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3288,15 +3288,18 @@ void mem_cgroup_prepare_migration(struct page *page, struct page *newpage,
 				  struct mem_cgroup **memcgp)
 {
 	struct mem_cgroup *memcg = NULL;
+	unsigned int nr_pages = 1;
 	struct page_cgroup *pc;
 	enum charge_type ctype;
 
 	*memcgp = NULL;
 
-	VM_BUG_ON(PageTransHuge(page));
 	if (mem_cgroup_disabled())
 		return;
 
+	if (PageTransHuge(page))
+		nr_pages <<= compound_order(page);
+
 	pc = lookup_page_cgroup(page);
 	lock_page_cgroup(pc);
 	if (PageCgroupUsed(pc)) {
@@ -3358,7 +3361,7 @@ void mem_cgroup_prepare_migration(struct page *page, struct page *newpage,
 	 * charged to the res_counter since we plan on replacing the
 	 * old one and only one page is going to be left afterwards.
 	 */
-	__mem_cgroup_commit_charge(memcg, newpage, 1, ctype, false);
+	__mem_cgroup_commit_charge(memcg, newpage, nr_pages, ctype, false);
 }
 
 /* remove redundant charge if migration failed*/
