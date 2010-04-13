Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017Ab0DMKg5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 06:36:57 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37431 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331Ab0DMKgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 06:36:55 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the anon_vmas of a mergeable VMA
Cc: kosaki.motohiro@jp.fujitsu.com, Rik van Riel <riel@redhat.com>,
       Borislav Petkov <bp@alien8.de>, Johannes Weiner <hannes@cmpxchg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
In-Reply-To: <alpine.LFD.2.00.1004120844370.26679@i5.linux-foundation.org>
References: <4BC24309.7060004@redhat.com> <alpine.LFD.2.00.1004120844370.26679@i5.linux-foundation.org>
Message-Id: <20100413192259.D113.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 13 Apr 2010 19:36:51 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

> On Sun, 11 Apr 2010, Rik van Riel wrote:
> >
> > Another thing I just thought of.
> > 
> > The anon_vma struct will not be reused for something completely
> > different due to the SLAB_DESTROY_BY_RCU flag that the anon_vma_cachep
> > is created with.
> 
> Rik, we _know_ it got re-used by something totally different. That's 
> clearly the problem. The page->mapping pointer does _not_ point to an 
> anon_vma any more. That's the problem here.
> 
> What we need to figure out is how we have a page on the LRU list that is 
> still marked as 'mapped' that has that stale mapping pointer.
> 
> I can easily see how the stale mapping pointer happens for a non-mapped 
> page. That part is trivial. Here's a simple case:
> 
>  - vmscan does that whole "isolate LRU pages", and one of them is a (at 
>    that time mapped) anonymous page. It's now not on any LRU lists at all.
> 
>  - vmscan ends up waiting for pageout and/or writeback while holding that 
>    list of pages.
> 
>  - in the meantime, the process that had the page exists or unmaps, 
>    unmapping the page and freeing the vma and the anon_vma.
> 
>  - vmscan eventually gets to the page, and does that page_referenced() 
>    dance. page->mapping points to something that is long long gone (as in 
>    "IO access lifetimes", so we're talking something that has been freed 
>    literally milliseconds ago, rather than any RCU delays)
> 
> So I can see the stale page->mapping pointer happening. That part is even 
> trivial. What I don't see is how the page would be still marked 'mapped'. 
> Everything that actually free's the vma/anon_vmas should also have 
> unmapped the page before that - even if it didn't _free_ the page.

Sorry, Now I'm lost what discuss in this crazy long thread.
IIUC, If the page->mapping was freed millisecns ago, following (1)
check returen false and we never touch page->mapping literally.

Am I missing something?


===================================================================
struct anon_vma *page_lock_anon_vma(struct page *page)
{
        struct anon_vma *anon_vma;
        unsigned long anon_mapping;

        rcu_read_lock();
        anon_mapping = (unsigned long) ACCESS_ONCE(page->mapping);
        if ((anon_mapping & PAGE_MAPPING_FLAGS) != PAGE_MAPPING_ANON)
                goto out;
        if (!page_mapped(page))       /* (1) here */ 
                goto out;

        anon_vma = (struct anon_vma *) (anon_mapping - PAGE_MAPPING_ANON);
        spin_lock(&anon_vma->lock);
        return anon_vma;
out:
        rcu_read_unlock();
        return NULL;
}
=================================================


And, I think your following patch seems incorrect.
The added page_mapped() is called after spinlock(anon_vma->lock),
it mean check-after-dereference. such check doesn't prevent invalid
pointer dereference, I think.

perhaps, I'm missing anything. I have to reread this thread at all from
first.

---
diff --git a/mm/rmap.c b/mm/rmap.c
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -302,7 +302,11 @@ struct anon_vma *page_lock_anon_vma(struct page *page)
 
 	anon_vma = (struct anon_vma *) (anon_mapping - PAGE_MAPPING_ANON);
 	spin_lock(&anon_vma->lock);
-	return anon_vma;
+
+	if (page_mapped(page))
+		return anon_vma;
+
+	spin_unlock(&anon_vma->lock);
 out:
 	rcu_read_unlock();
 	return NULL;







