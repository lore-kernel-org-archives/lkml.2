Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933177Ab2EOQDv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 12:03:51 -0400
Received: from mail1.windriver.com ([147.11.146.13]:62392 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932124Ab2EOQDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 12:03:48 -0400
Date: Tue, 15 May 2012 12:02:50 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Peter Zijlstra <peterz@infradead.org>, Hugh Dickins <hughd@google.com>,
        Willy Tarreau <w@1wt.eu>
CC: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [34-longterm 167/179] futex: Fix regression with read only
 mappings
Message-ID: <20120515160250.GA17760@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
 <1337048075-6132-168-git-send-email-paul.gortmaker@windriver.com>
 <alpine.LSU.2.00.1205142126180.2196@eggly.anvils>
 <1337079117.27694.28.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1337079117.27694.28.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re: [34-longterm 167/179] futex: Fix regression with read only mappings] On 15/05/2012 (Tue 12:51) Peter Zijlstra wrote:

> On Mon, 2012-05-14 at 21:38 -0700, Hugh Dickins wrote:
> > I don't know: I'm not NAKking it, I'm just waving a reddish flag,
> > and hoping that Peter will remember more, and have something more
> > constructive to say, than I can think of at this moment. 
> 
> Ha! you're very optimistic :-)
> 
> going by git log kernel/futex.c on a recent kernel the proposed patch
> should indeed be followed by your patch, but I can't seem to find more
> relevant patches.

Thanks a lot guys.  That is a dependency I'd never have come up with.

Willy -- this is probably of interest to you as well.   Hugh says that
commit e6780f7243 ("futex: Fix uninterruptible loop due to gate_area")
should be used if 9ea71503a8 ("futex: Fix regression with read only
mappings") is used.  The v2.6.32.46 added 9ea71503a8 (as d64ec7bb),
but I don't see a cherry pick of e6780f7243 in any v2.6.32.x yet.

Greg already applied it to 3.0.16 and 3.1.8 and it appeared in v3.2
by default, so no other active stable releases need to worry.

I had to change page_mapping --> page, since the 2.6.34 baseline does
not have a5b338f2b0b1ff73 ("thp: update futex compound knowledge")
[added to v2.6.38] which introduces the shadow variable page_mapping.

Paul.
---

>From f8fe91498b2a35fc6abc02bb213ca297bfcd2b2a Mon Sep 17 00:00:00 2001
From: Hugh Dickins <hughd@google.com>
Date: Sat, 31 Dec 2011 11:44:01 -0800
Subject: [PATCH] futex: Fix uninterruptible loop due to gate_area

commit e6780f7243eddb133cc20ec37fa69317c218b709 upstream.

It was found (by Sasha) that if you use a futex located in the gate
area we get stuck in an uninterruptible infinite loop, much like the
ZERO_PAGE issue.

While looking at this problem, PeterZ realized you'll get into similar
trouble when hitting any install_special_pages() mapping.  And are there
still drivers setting up their own special mmaps without page->mapping,
and without special VM or pte flags to make get_user_pages fail?

In most cases, if page->mapping is NULL, we do not need to retry at all:
Linus points out that even /proc/sys/vm/drop_caches poses no problem,
because it ends up using remove_mapping(), which takes care not to
interfere when the page reference count is raised.

But there is still one case which does need a retry: if memory pressure
called shmem_writepage in between get_user_pages_fast dropping page
table lock and our acquiring page lock, then the page gets switched from
filecache to swapcache (and ->mapping set to NULL) whatever the refcount.
Fault it back in to get the page->mapping needed for key->shared.inode.

Reported-by: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[PG: 2.6.34 variable is page, not page_head, since it doesn't have a5b338f2]
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/kernel/futex.c b/kernel/futex.c
index 98a354d..8b467b4 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -264,17 +264,29 @@ again:
 
 	page = compound_head(page);
 	lock_page(page);
+
+	/*
+	 * If page->mapping is NULL, then it cannot be a PageAnon
+	 * page; but it might be the ZERO_PAGE or in the gate area or
+	 * in a special mapping (all cases which we are happy to fail);
+	 * or it may have been a good file page when get_user_pages_fast
+	 * found it, but truncated or holepunched or subjected to
+	 * invalidate_complete_page2 before we got the page lock (also
+	 * cases which we are happy to fail).  And we hold a reference,
+	 * so refcount care in invalidate_complete_page's remove_mapping
+	 * prevents drop_caches from setting mapping to NULL beneath us.
+	 *
+	 * The case we do have to guard against is when memory pressure made
+	 * shmem_writepage move it from filecache to swapcache beneath us:
+	 * an unlikely race, but we do need to retry for page->mapping.
+	 */
 	if (!page->mapping) {
+		int shmem_swizzled = PageSwapCache(page);
 		unlock_page(page);
 		put_page(page);
-		/*
-		* ZERO_PAGE pages don't have a mapping. Avoid a busy loop
-		* trying to find one. RW mapping would have COW'd (and thus
-		* have a mapping) so this page is RO and won't ever change.
-		*/
-		if ((page == ZERO_PAGE(address)))
-			return -EFAULT;
-		goto again;
+		if (shmem_swizzled)
+			goto again;
+		return -EFAULT;
 	}
 
 	/*
-- 
1.7.9.6

