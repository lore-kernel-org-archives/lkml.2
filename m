Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932797Ab1I1WpR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:45:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54394 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932779Ab1I1WpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:45:12 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:40 2011
Message-Id: <20110928220140.814383711@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:01:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dave Hansen <dave@linux.vnet.ibm.com>, Hugh Dickins <hughd@google.com>,
        David Rientjes <rientjes@google.com>
Subject: [147/244] make /proc/$pid/numa_maps gather_stats() take variable page size
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dave Hansen <dave@linux.vnet.ibm.com>

commit eb4866d0066ffd5446751c102d64feb3318d8bd1 upstream.

We need to teach the numa_maps code about transparent huge pages.  The
first step is to teach gather_stats() that the pte it is dealing with
might represent more than one page.

Note that will we use this in a moment for transparent huge pages since
they have use a single pmd_t which _acts_ as a "surrogate" for a bunch
of smaller pte_t's.

I'm a _bit_ unhappy that this interface counts in hugetlbfs page sizes
for hugetlbfs pages and PAGE_SIZE for normal pages.  That means that to
figure out how many _bytes_ "dirty=1" means, you must first know the
hugetlbfs page size.  That's easier said than done especially if you
don't have visibility in to the mount.

But, that's probably a discussion for another day especially since it
would change behavior to fix it.  But, just in case anyone wonders why
this patch only passes a '1' in the hugetlb case...

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/proc/task_mmu.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -877,30 +877,31 @@ struct numa_maps_private {
 	struct numa_maps md;
 };
 
-static void gather_stats(struct page *page, struct numa_maps *md, int pte_dirty)
+static void gather_stats(struct page *page, struct numa_maps *md, int pte_dirty,
+			unsigned long nr_pages)
 {
 	int count = page_mapcount(page);
 
-	md->pages++;
+	md->pages += nr_pages;
 	if (pte_dirty || PageDirty(page))
-		md->dirty++;
+		md->dirty += nr_pages;
 
 	if (PageSwapCache(page))
-		md->swapcache++;
+		md->swapcache += nr_pages;
 
 	if (PageActive(page) || PageUnevictable(page))
-		md->active++;
+		md->active += nr_pages;
 
 	if (PageWriteback(page))
-		md->writeback++;
+		md->writeback += nr_pages;
 
 	if (PageAnon(page))
-		md->anon++;
+		md->anon += nr_pages;
 
 	if (count > md->mapcount_max)
 		md->mapcount_max = count;
 
-	md->node[page_to_nid(page)]++;
+	md->node[page_to_nid(page)] += nr_pages;
 }
 
 static int gather_pte_stats(pmd_t *pmd, unsigned long addr,
@@ -931,7 +932,7 @@ static int gather_pte_stats(pmd_t *pmd,
 		if (!node_isset(nid, node_states[N_HIGH_MEMORY]))
 			continue;
 
-		gather_stats(page, md, pte_dirty(*pte));
+		gather_stats(page, md, pte_dirty(*pte), 1);
 
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 	pte_unmap_unlock(orig_pte, ptl);
@@ -952,7 +953,7 @@ static int gather_hugetbl_stats(pte_t *p
 		return 0;
 
 	md = walk->private;
-	gather_stats(page, md, pte_dirty(*pte));
+	gather_stats(page, md, pte_dirty(*pte), 1);
 	return 0;
 }
 


