Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932738Ab2GYHf0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 03:35:26 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:54715 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753831Ab2GYHfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 03:35:25 -0400
Date: Wed, 25 Jul 2012 09:35:03 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: manual merge of the akpm tree with the tip tree
Message-ID: <20120725073503.GB1112@cmpxchg.org>
References: <20120725140827.4332a5448e4d8d200164ea2e@canb.auug.org.au>
 <20120725071044.GA27535@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120725071044.GA27535@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 09:10:44AM +0200, Ingo Molnar wrote:
> 
> * Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > Hi Andrew,
> > 
> > Today's linux-next merge of the akpm tree got a conflict in 
> > mm/migrate.c between the tip tree and commit "mm: memcg: fix 
> > compaction/migration failing due to memcg limits" from the 
> > akpm tree.
> > 
> > The commit 4783af477d3d ("mm: Migrate misplaced page") was 
> > removed (among several others) from the tip tree since 
> > yesterday (and thus linux-next) so the above akpm tree patch 
> > no longer applies.
> > 
> > I have dropped this patch form the akpm tree (and the following patches
> > as well:
> > mm-memcg-fix-compaction-migration-failing-due-to-memcg-limits-checkpatch-fixes
> > mm: memcg: push down PageSwapCache check into uncharge entry functions
> > mm: memcg: only check for PageSwapCache when uncharging anon
> > mm: memcg: remove unneeded shmem charge type
> > mm: memcg: remove needless !mm fixup to init_mm when charging
> > )
> > 
> > Hopefully this doesn't cause other problems.  I guess that 
> > they will need rebasing depending on what gets merged via the 
> > tip tree.
> 
> Andrew, sorry about this last minute fallout: I felt that 
> sched/numa was still not fully cooked and did not want to hold 
> up the rest of the scheduler tree on that - nor did I want to 
> send an uncooked tree to Linus.
> 
> PeterZ posted another series of sched/numa patches two days ago 
> - once that is ready (probably after the merge window) it will 
> all reappear again, in a slightly different form. I could stick 
> the mm/ bits into a separate tree to make it easier for you.

As this is unlikely to reappear in this merge window, the conflict
resolution is quite simple.  All that's needed is remove the 3 hunks
from my patch that converted a user in Peter's patch to a new API.  I
can resend the series if needed, but it's probably easier to just
remove the hunks against mm/migrate.c::migrate_misplaced_page():

@@ -1519,10 +1512,9 @@ migrate_misplaced_page(struct page *page, struct mm_struct *mm, int node)
 {
 	struct page *oldpage = page, *newpage;
 	struct address_space *mapping = page_mapping(page);
-	struct mem_cgroup *mcg;
+	struct mem_cgroup *memcg;
 	unsigned int gfp;
 	int rc = 0;
-	int charge = -ENOMEM;
 
 	VM_BUG_ON(!PageLocked(page));
 	VM_BUG_ON(page_mapcount(page));
@@ -1556,12 +1548,7 @@ migrate_misplaced_page(struct page *page, struct mm_struct *mm, int node)
 	if (!trylock_page(newpage))
 		BUG();		/* new page should be unlocked!!! */
 
-	// XXX hnaz, is this right?
-	charge = mem_cgroup_prepare_migration(page, newpage, &mcg, gfp);
-	if (charge == -ENOMEM) {
-		rc = charge;
-		goto out;
-	}
+	mem_cgroup_prepare_migration(page, newpage, &memcg);
 
 	newpage->index = page->index;
 	newpage->mapping = page->mapping;
@@ -1581,11 +1568,9 @@ migrate_misplaced_page(struct page *page, struct mm_struct *mm, int node)
 		page = newpage;
 	}
 
+	mem_cgroup_end_migration(memcg, oldpage, newpage, !rc);
 out:
-	if (!charge)
-		mem_cgroup_end_migration(mcg, oldpage, newpage, !rc);
-
-       if (oldpage != page)
+	if (oldpage != page)
                put_page(oldpage);
 
 	if (rc) {
