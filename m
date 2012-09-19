Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177Ab2ISXtU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 19:49:20 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:48840 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036Ab2ISXtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 19:49:18 -0400
X-AuditID: 9c930197-b7b6dae000000e70-1f-505a59fb532c
Date: Thu, 20 Sep 2012 08:51:56 +0900
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
        Christoph Lameter <cl@linux.com>, Johannes Weiner <hannes@cmpxchg.org>,
        David Rientjes <rientjes@google.com>,
        Vasiliy Kulikov <segooon@gmail.com>
Subject: Re: [PATCH] mm: fix NR_ISOLATED_[ANON|FILE] mismatch
Message-ID: <20120919235156.GC13234@bbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2012 at 02:28:10PM -0400, Johannes Weiner wrote:
> On Wed, Sep 19, 2012 at 01:04:56PM -0400, KOSAKI Motohiro wrote:
> > On Wed, Sep 19, 2012 at 3:45 AM, Minchan Kim <minchan@kernel.org> wrote:
> > > When I looked at zone stat mismatch problem, I found
> > > migrate_to_node doesn't decrease NR_ISOLATED_[ANON|FILE]
> > > if check_range fails.
> 
> This is a bit misleading.  It's not that the stats would be
> inaccurate, it's that the pages would be leaked from the LRU, no?
> 
> > > It can make system hang out.
> 
> Did you spot this by code review only or did you actually run into
> this?  Because...
> 
> > > Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > > Cc: Mel Gorman <mgorman@suse.de>
> > > Cc: Christoph Lameter <cl@linux.com>
> > > Signed-off-by: Minchan Kim <minchan@kernel.org>
> > > ---
> > >  mm/mempolicy.c |   16 ++++++++--------
> > >  1 file changed, 8 insertions(+), 8 deletions(-)
> > >
> > > diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> > > index 3d64b36..6bf0860 100644
> > > --- a/mm/mempolicy.c
> > > +++ b/mm/mempolicy.c
> > > @@ -953,16 +953,16 @@ static int migrate_to_node(struct mm_struct *mm, int source, int dest,
> > >
> > >         vma = check_range(mm, mm->mmap->vm_start, mm->task_size, &nmask,
> > >                         flags | MPOL_MF_DISCONTIG_OK, &pagelist);
> > > -       if (IS_ERR(vma))
> > > -               return PTR_ERR(vma);
> > > -
> > > -       if (!list_empty(&pagelist)) {
> > > +       if (IS_ERR(vma)) {
> > > +               err = PTR_ERR(vma);
> > > +               goto out;
> > > +       }
> > > +       if (!list_empty(&pagelist))
> > >                 err = migrate_pages(&pagelist, new_node_page, dest,
> > >                                                         false, MIGRATE_SYNC);
> > > -               if (err)
> > > -                       putback_lru_pages(&pagelist);
> > > -       }
> > > -
> > > +out:
> > > +       if (err)
> > > +               putback_lru_pages(&pagelist);
> > 
> > Good catch!
> > This is a regression since following commit. So, I doubt we need
> > all or nothing semantics. Can we revert it instead? (and probably
> > we need more kind comment for preventing an accident)
> 
> I think it makes sense to revert.  Not because of the semantics, but I
> just don't see how check_range() could even fail for this callsite:
> 
> 1. we pass mm->mmap->vm_start in there, so we should not fail due to
>    find_vma()
> 
> 2. we pass MPOL_MF_DISCONTIG_OK, so the discontig checks do not apply
>    and so can not fail
> 
> 3. we pass MPOL_MF_MOVE | MPOL_MF_MOVE_ALL, the page table loops will
>    continue until addr == end, so we never fail with -EIO
> 
> > commit 0def08e3acc2c9c934e4671487029aed52202d42
> > Author: Vasiliy Kulikov <segooon@gmail.com>
> > Date:   Tue Oct 26 14:21:32 2010 -0700
> > 
> >     mm/mempolicy.c: check return code of check_range
> 
> We don't use this code to "check" the range, we use it to collect
> migrate pages.  There is no failure case.
> 

Here it goes.

>From c2c21b551811e034eb0ede6806e0314b201d7e5b Mon Sep 17 00:00:00 2001
From: Minchan Kim <minchan@kernel.org>
Date: Thu, 20 Sep 2012 08:39:52 +0900
Subject: [PATCH] mm: revert 0def08e3, mm/mempolicy.c: check return code of
 check_range

This patch reverts 0def08e3 because check_range can't fail in
migrate_to_node with considering current usecases.

Quote from Johannes
"
I think it makes sense to revert.  Not because of the semantics, but I
just don't see how check_range() could even fail for this callsite:

1. we pass mm->mmap->vm_start in there, so we should not fail due to
   find_vma()

2. we pass MPOL_MF_DISCONTIG_OK, so the discontig checks do not apply
   and so can not fail

3. we pass MPOL_MF_MOVE | MPOL_MF_MOVE_ALL, the page table loops will
   continue until addr == end, so we never fail with -EIO
"

And I add new VM_BUG_ON for checking migrate_to_node's future usecase
which might pass to MPOL_MF_STRICT.

Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Vasiliy Kulikov <segooon@gmail.com>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 mm/mempolicy.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 3d64b36..9ec87bd 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -946,15 +946,16 @@ static int migrate_to_node(struct mm_struct *mm, int source, int dest,
 	nodemask_t nmask;
 	LIST_HEAD(pagelist);
 	int err = 0;
-	struct vm_area_struct *vma;
 
 	nodes_clear(nmask);
 	node_set(source, nmask);
 
-	vma = check_range(mm, mm->mmap->vm_start, mm->task_size, &nmask,
+	/*
+	 * Collect migrate pages and it shoudn't be failed.
+	 */
+	VM_BUG_ON(flags & MPOL_MF_STRICT);
+	check_range(mm, mm->mmap->vm_start, mm->task_size, &nmask,
 			flags | MPOL_MF_DISCONTIG_OK, &pagelist);
-	if (IS_ERR(vma))
-		return PTR_ERR(vma);
 
 	if (!list_empty(&pagelist)) {
 		err = migrate_pages(&pagelist, new_node_page, dest,
-- 
1.7.9.5

-- 
Kind regards,
Minchan Kim
