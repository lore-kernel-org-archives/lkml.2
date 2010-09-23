Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684Ab0IWXxK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 19:53:10 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:40067 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab0IWXxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 19:53:08 -0400
Date: Fri, 24 Sep 2010 08:50:45 +0900
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>, Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH 3/4] hugetlb, rmap: fix confusing page locking in
 hugetlb_cow()
Message-ID: <20100923235044.GA13811@spritzera.linux.bs1.fc.nec.co.jp>
References: <1284092586-1179-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1284092586-1179-4-git-send-email-n-horiguchi@ah.jp.nec.com>
 <alpine.LFD.2.00.1009101011140.9670@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1009101011140.9670@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Very sorry for late reply.
(Thank you for letting me know, Andi-san.)

On Fri, Sep 10, 2010 at 10:15:46AM -0700, Linus Torvalds wrote:
> 
> 
> On Fri, 10 Sep 2010, Naoya Horiguchi wrote:
> >  
> > -	if (!pagecache_page) {
> > -		page = pte_page(entry);
> > +	/*
> > +	 * hugetlb_cow() requires page locks of pte_page(entry) and
> > +	 * pagecache_page, so here we need take the former one
> > +	 * when page != pagecache_page or !pagecache_page.
> > +	 */
> > +	page = pte_page(entry);
> > +	if (page != pagecache_page)
> >  		lock_page(page);
> 
> Why isn't this a potential deadlock? You have two pages, and lock them 
> both. Is there some ordering guarantee that says that 'pagecache_page' and 
> 'page' will always be in a certain relationship so that you cannot get 
> A->B and B->A lock ordering?

Locking order is always pagecache -> page, so we are free from deadlock.

> Please document that ordering rule if so.

Yes. I comment it.

Please replace this patch by the following one.

Thanks,
Naoya Horiguchi

---
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Date: Thu, 9 Sep 2010 16:39:33 +0900
Subject: [PATCH 3/4] hugetlb, rmap: fix confusing page locking in hugetlb_cow()

if(!trylock_page) block in avoidcopy path of hugetlb_cow() looks confusing
and is buggy.  Originally this trylock_page() is intended to make sure
that old_page is locked even when old_page != pagecache_page, because then
only pagecache_page is locked.
This patch fixes it by moving page locking into hugetlb_fault().

ChangeLog:
- add comment about deadlock.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Rik van Riel <riel@redhat.com>
---
 mm/hugetlb.c |   22 ++++++++++++----------
 1 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 9519f3f..c032738 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2324,11 +2324,8 @@ retry_avoidcopy:
 	 * and just make the page writable */
 	avoidcopy = (page_mapcount(old_page) == 1);
 	if (avoidcopy) {
-		if (!trylock_page(old_page)) {
-			if (PageAnon(old_page))
-				page_move_anon_rmap(old_page, vma, address);
-		} else
-			unlock_page(old_page);
+		if (PageAnon(old_page))
+			page_move_anon_rmap(old_page, vma, address);
 		set_huge_ptep_writable(vma, address, ptep);
 		return 0;
 	}
@@ -2631,10 +2628,16 @@ int hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 								vma, address);
 	}
 
-	if (!pagecache_page) {
-		page = pte_page(entry);
+	/*
+	 * hugetlb_cow() requires page locks of pte_page(entry) and
+	 * pagecache_page, so here we need take the former one
+	 * when page != pagecache_page or !pagecache_page.
+	 * Note that locking order is always pagecache_page -> page,
+	 * so no worry about deadlock.
+	 */
+	page = pte_page(entry);
+	if (page != pagecache_page)
 		lock_page(page);
-	}
 
 	spin_lock(&mm->page_table_lock);
 	/* Check for a racing update before calling hugetlb_cow */
@@ -2661,9 +2664,8 @@ out_page_table_lock:
 	if (pagecache_page) {
 		unlock_page(pagecache_page);
 		put_page(pagecache_page);
-	} else {
-		unlock_page(page);
 	}
+	unlock_page(page);
 
 out_mutex:
 	mutex_unlock(&hugetlb_instantiation_mutex);
-- 
1.7.2.3
