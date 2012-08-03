Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab2HCTaw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 15:30:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553Ab2HCTav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 15:30:51 -0400
Date: Fri, 3 Aug 2012 21:30:20 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        paulmck <paulmck@linux.vnet.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>
Subject: Re: thp and memory barrier assumptions
Message-ID: <20120803193020.GA1874@redhat.com>
References: <1343334698.32120.11.camel@twins>
 <1343334805.32120.13.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343334805.32120.13.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 10:33:25PM +0200, Peter Zijlstra wrote:
> On Thu, 2012-07-26 at 22:31 +0200, Peter Zijlstra wrote:
> > __do_huge_pmd_anonymous_page() contains:
> > 
> >                 /*
> >                  * The spinlocking to take the lru_lock inside
> >                  * page_add_new_anon_rmap() acts as a full memory
> >                  * barrier to be sure clear_huge_page writes become
> >                  * visible after the set_pmd_at() write.
> >                  */
> >                 page_add_new_anon_rmap(page, vma, haddr);
> > 
> > 
> > page_add_new_anon_rmap() doesn't look to actually do a LOCK+UNLOCK
> > except for unevictable pages.
> > 
> > But even if it did do an unconditional LOCK+UNLOCK that doesn't make a
> > full memory barrier, see Documentation/memory-barriers.txt.
> > 
> > In particular:
> > 
> >         *A = a;
> >         LOCK
> >         UNLOCK
> >         *B = b;
> > 
> > may occur as:
> > 
> >         LOCK, STORE *B, STORE *A, UNLOCK
> > 
> 

I fixed that last year (I think Mel pointed out the bug) but I've been
so busy with other things I forgot to push that theoretical fix from
aa.git to -mm. As soon as autonuma is merged, I'll return to focus on
pushing the other pending patches in my queue that are being starved.

http://git.kernel.org/?p=linux/kernel/git/andrea/aa.git;a=commitdiff;h=d598a3f7ae4ca9d2c2a8653fbe790aab9b1a3141

Can you review it? If ok I'll submit it so it won't starve no
more. Also note the other bugfix that was in fair.c I think is only
needed with AutoNUMA applied this is why I didn't submit it
separately.

This can't affect x86 where even a locked bitop is the equivalent of a
full memory barrier.

> Also, what is that barrier() in handle_mm_fault() doing? And why doesn't
> it have a comment explaining that?

I added the docs below:

=====
>From ad51771a2c3fa697fa0267edda23b48d0b85f023 Mon Sep 17 00:00:00 2001
From: Andrea Arcangeli <aarcange@redhat.com>
Date: Fri, 3 Aug 2012 21:10:44 +0200
Subject: [PATCH] thp: document barrier() in wrprotect THP fault path

Inline doc.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 mm/memory.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 420a449..9ec5bba 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3522,6 +3522,12 @@ retry:
 		pmd_t orig_pmd = *pmd;
 		int ret;
 
+		/*
+		 * flush orig_pmd on the stack to avoid invalidating
+		 * the pmd_trans_huge(orig_pmd) check and to allow
+		 * do_huge_pmd_wp_page to run a reliable
+		 * pmd_same(*pmd, orig_pmd).
+		 */
 		barrier();
 		if (pmd_trans_huge(orig_pmd)) {
 			if (flags & FAULT_FLAG_WRITE &&
