Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223Ab1AKV5G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 16:57:06 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36859 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753804Ab1AKV5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 16:57:04 -0500
Date: Tue, 11 Jan 2011 13:55:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, hughd@google.com, mel@csn.ul.ie
Subject: Re: +
 mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-avoid-a-potential-deadlock-due-to-lock_page-during-direct-compaction-fix.patch
 added to -mm tree
Message-Id: <20110111135547.ce6c273c.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1101111341590.7551@chino.kir.corp.google.com>
References: <201101112046.p0BKk2Js005902@imap1.linux-foundation.org>
	<alpine.DEB.2.00.1101111341590.7551@chino.kir.corp.google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Jan 2011 13:43:06 -0800 (PST)
David Rientjes <rientjes@google.com> wrote:

> On Tue, 11 Jan 2011, akpm@linux-foundation.org wrote:
> 
> > diff -puN mm/page_alloc.c~mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-avoid-a-potential-deadlock-due-to-lock_page-during-direct-compaction-fix mm/page_alloc.c
> > --- a/mm/page_alloc.c~mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-avoid-a-potential-deadlock-due-to-lock_page-during-direct-compaction-fix
> > +++ a/mm/page_alloc.c
> > @@ -1815,15 +1815,15 @@ __alloc_pages_direct_compact(gfp_t gfp_m
> >  	int migratetype, unsigned long *did_some_progress)
> >  {
> >  	struct page *page;
> > -	struct task_struct *p = current;
> > +	struct task_struct *tsk = current;
> >  
> >  	if (!order || compaction_deferred(preferred_zone))
> >  		return NULL;
> >  
> > -	p->flags |= PF_MEMALLOC;
> > +	tsk->flags |= PF_MEMALLOC;
> >  	*did_some_progress = try_to_compact_pages(zonelist, order, gfp_mask,
> >  								nodemask);
> > -	p->flags &= ~PF_MEMALLOC;
> > +	tsk->flags &= ~PF_MEMALLOC;
> >  	if (*did_some_progress != COMPACT_SKIPPED) {
> >  
> >  		/* Page migration frees to the PCP lists but we want merging */
> 
> This could be done for all of the page allocator functions in 
> mm/page_alloc.c, I think it would be inconsistent and slightly harder to 
> read if it were done in only one.

Using "p" for any identifier which has less-than-teeny scope is plain
dumb.  It's meaningless and useless.

Anyway...


Subject: mm/page_alloc.c: don't cache `current' in a local
From: Andrew Morton <akpm@linux-foundation.org>

It's old-fashioned and unneeded.

akpm:/usr/src/25> size mm/page_alloc.o
   text    data     bss     dec     hex filename
  39884 1241317   18808 1300009  13d629 mm/page_alloc.o (before)
  39838 1241317   18808 1299963  13d5fb mm/page_alloc.o (after)

Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff -puN mm/page_alloc.c~mm-page_allocc-dont-cache-current-in-a-local mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_allocc-dont-cache-current-in-a-local
+++ a/mm/page_alloc.c
@@ -1809,15 +1809,14 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 	bool sync_migration)
 {
 	struct page *page;
-	struct task_struct *tsk = current;
 
 	if (!order || compaction_deferred(preferred_zone))
 		return NULL;
 
-	tsk->flags |= PF_MEMALLOC;
+	current->flags |= PF_MEMALLOC;
 	*did_some_progress = try_to_compact_pages(zonelist, order, gfp_mask,
 						nodemask, sync_migration);
-	tsk->flags &= ~PF_MEMALLOC;
+	current->flags &= ~PF_MEMALLOC;
 	if (*did_some_progress != COMPACT_SKIPPED) {
 
 		/* Page migration frees to the PCP lists but we want merging */
@@ -1869,23 +1868,22 @@ __alloc_pages_direct_reclaim(gfp_t gfp_m
 {
 	struct page *page = NULL;
 	struct reclaim_state reclaim_state;
-	struct task_struct *p = current;
 	bool drained = false;
 
 	cond_resched();
 
 	/* We now go into synchronous reclaim */
 	cpuset_memory_pressure_bump();
-	p->flags |= PF_MEMALLOC;
+	current->flags |= PF_MEMALLOC;
 	lockdep_set_current_reclaim_state(gfp_mask);
 	reclaim_state.reclaimed_slab = 0;
-	p->reclaim_state = &reclaim_state;
+	current->reclaim_state = &reclaim_state;
 
 	*did_some_progress = try_to_free_pages(zonelist, order, gfp_mask, nodemask);
 
-	p->reclaim_state = NULL;
+	current->reclaim_state = NULL;
 	lockdep_clear_current_reclaim_state();
-	p->flags &= ~PF_MEMALLOC;
+	current->flags &= ~PF_MEMALLOC;
 
 	cond_resched();
 
@@ -1950,7 +1948,6 @@ void wake_all_kswapd(unsigned int order,
 static inline int
 gfp_to_alloc_flags(gfp_t gfp_mask)
 {
-	struct task_struct *p = current;
 	int alloc_flags = ALLOC_WMARK_MIN | ALLOC_CPUSET;
 	const gfp_t wait = gfp_mask & __GFP_WAIT;
 
@@ -1977,12 +1974,12 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
 		 * See also cpuset_zone_allowed() comment in kernel/cpuset.c.
 		 */
 		alloc_flags &= ~ALLOC_CPUSET;
-	} else if (unlikely(rt_task(p)) && !in_interrupt())
+	} else if (unlikely(rt_task(current)) && !in_interrupt())
 		alloc_flags |= ALLOC_HARDER;
 
 	if (likely(!(gfp_mask & __GFP_NOMEMALLOC))) {
 		if (!in_interrupt() &&
-		    ((p->flags & PF_MEMALLOC) ||
+		    ((current->flags & PF_MEMALLOC) ||
 		     unlikely(test_thread_flag(TIF_MEMDIE))))
 			alloc_flags |= ALLOC_NO_WATERMARKS;
 	}
@@ -2001,7 +1998,6 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 	int alloc_flags;
 	unsigned long pages_reclaimed = 0;
 	unsigned long did_some_progress;
-	struct task_struct *p = current;
 	bool sync_migration = false;
 
 	/*
@@ -2060,7 +2056,7 @@ rebalance:
 		goto nopage;
 
 	/* Avoid recursion of direct reclaim */
-	if (p->flags & PF_MEMALLOC)
+	if (current->flags & PF_MEMALLOC)
 		goto nopage;
 
 	/* Avoid allocations with no watermarks from looping endlessly */
@@ -2153,7 +2149,7 @@ nopage:
 	if (!(gfp_mask & __GFP_NOWARN) && printk_ratelimit()) {
 		printk(KERN_WARNING "%s: page allocation failure."
 			" order:%d, mode:0x%x\n",
-			p->comm, order, gfp_mask);
+			current->comm, order, gfp_mask);
 		dump_stack();
 		show_mem();
 	}
_

