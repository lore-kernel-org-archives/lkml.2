Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436Ab0DLQBu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 12:01:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:54767 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab0DLQBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 12:01:48 -0400
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the
 anon_vmas of a mergeable VMA
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Borislav Petkov <bp@alien8.de>, Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
In-Reply-To: <4BC33A02.8000307@redhat.com>
References: <20100409191425.GB10780@a1.tnic>
	 <alpine.LFD.2.00.1004091227310.3558@i5.linux-foundation.org>
	 <20100409204328.GG28964@cmpxchg.org>
	 <alpine.LFD.2.00.1004091546350.3558@i5.linux-foundation.org>
	 <alpine.LFD.2.00.1004091638290.3558@i5.linux-foundation.org>
	 <20100410003110.GI28964@cmpxchg.org>
	 <alpine.LFD.2.00.1004091730130.3558@i5.linux-foundation.org>
	 <20100410072714.GA9246@liondog.tnic> <20100410112639.GA24708@a1.tnic>
	 <alpine.LFD.2.00.1004100821340.3558@i5.linux-foundation.org>
	 <20100410163828.GA25579@a1.tnic>
	 <alpine.LFD.2.00.1004100947400.3558@i5.linux-foundation.org>
	 <alpine.LFD.2.00.1004101101180.3558@i5.linux-foundation.org>
	 <1271083207.4807.18.camel@twins>  <4BC33A02.8000307@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Apr 2010 18:01:43 +0200
Message-ID: <1271088103.20295.3383.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-12 at 11:19 -0400, Rik van Riel wrote:
> On 04/12/2010 10:40 AM, Peter Zijlstra wrote:
> 
> > So the reason page->mapping isn't cleared in page_remove_rmap() isn't
> > detailed beyond a (possible) race with page_add_anon_rmap() (which I
> > guess would be reclaim trying to unmap the page and a fault re-instating
> > it).
> >
> > This also complicates the whole page_lock_anon_vma() thing, so it would
> > be nice to be able to remove this race and clear page->mapping in
> > page_remove_rmap().
> 
> For anonymous pages, I don't see where the race comes from.
> 
> Both do_swap_page and the reclaim code hold the page lock
> across the entire operation, so they are already excluding
> each other.
> 
> Hugh, do you remember what the race between page_remove_rmap
> and page_add_anon_rmap is/was all about?
> 
> I don't see a race in the current code...


Something like the below would be nice if possible.


---
 mm/rmap.c |   44 +++++++++++++++++++++++++++++++-------------
 1 files changed, 31 insertions(+), 13 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index eaa7a09..241f75d 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -286,7 +286,22 @@ void __init anon_vma_init(void)
 
 /*
  * Getting a lock on a stable anon_vma from a page off the LRU is
- * tricky: page_lock_anon_vma rely on RCU to guard against the races.
+ * tricky: 
+ *
+ *  page_add_anon_vma()
+ *   atomic_add_negative(page->_mapcount);
+ *   page->mapping = anon_vma;
+ *
+ *
+ *  page_remove_rmap()
+ *   atomic_add_negative();
+ *   page->mapping = anon_vma;
+ *
+ * So we have to first read page->mapping(), and then verify
+ * _mapcount, and make sure we order them correctly.
+ *
+ * We take anon_vma->lock in between so that if we see the anon_vma
+ * with a mapcount we know it won't go away on us.
  */
 struct anon_vma *page_lock_anon_vma(struct page *page)
 {
@@ -294,14 +309,24 @@ struct anon_vma *page_lock_anon_vma(struct page *page)
 	unsigned long anon_mapping;
 
 	rcu_read_lock();
-	anon_mapping = (unsigned long) ACCESS_ONCE(page->mapping);
+	anon_mapping = (unsigned long)rcu_dereference(page->mapping);
 	if ((anon_mapping & PAGE_MAPPING_FLAGS) != PAGE_MAPPING_ANON)
 		goto out;
-	if (!page_mapped(page))
-		goto out;
 
 	anon_vma = (struct anon_vma *) (anon_mapping - PAGE_MAPPING_ANON);
 	spin_lock(&anon_vma->lock);
+
+	/*
+	 * Order the reading of page->mapping and page->_mapcount against the
+	 * mb() implied by the atomic_add_negative() in page_remove_rmap().
+	 */
+	smp_rmb();
+	if (!page_mapped(page)) {
+		spin_unlock(&anon_vma->lock);
+		anon_vma = NULL;
+		goto out;
+	}
+
 	return anon_vma;
 out:
 	rcu_read_unlock();
@@ -864,15 +889,8 @@ void page_remove_rmap(struct page *page)
 		__dec_zone_page_state(page, NR_FILE_MAPPED);
 		mem_cgroup_update_file_mapped(page, -1);
 	}
-	/*
-	 * It would be tidy to reset the PageAnon mapping here,
-	 * but that might overwrite a racing page_add_anon_rmap
-	 * which increments mapcount after us but sets mapping
-	 * before us: so leave the reset to free_hot_cold_page,
-	 * and remember that it's only reliable while mapped.
-	 * Leaving it set also helps swapoff to reinstate ptes
-	 * faster for those pages still in swapcache.
-	 */
+
+	page->mapping = NULL;
 }
 
 /*


