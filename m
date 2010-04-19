Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab0DSLnV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 07:43:21 -0400
Received: from gir.skynet.ie ([193.1.99.77]:50540 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066Ab0DSLnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 07:43:20 -0400
Date: Mon, 19 Apr 2010 12:43:00 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Peter Zijlstra <peterz@infradead.org>
Cc: r6144 <rainy6144@gmail.com>, linux-kernel@vger.kernel.org,
       Darren Hart <dvhltc@us.ibm.com>, tglx <tglx@linutronix.de>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: Re: Process-shared futexes on hugepages puts the kernel in an
	infinite loop in 2.6.32.11; is this fixed now?
Message-ID: <20100419114300.GT19264@csn.ul.ie>
References: <1271432722.2564.16.camel@localhost.localdomain> <1271449668.1674.466.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1271449668.1674.466.camel@laptop>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 16, 2010 at 10:27:48PM +0200, Peter Zijlstra wrote:
> On Fri, 2010-04-16 at 23:45 +0800, r6144 wrote:
> > Hello all,
> > 
> > I'm having an annoying kernel bug regarding huge pages in Fedora 12:
> > 
> > https://bugzilla.redhat.com/show_bug.cgi?id=552257
> > 
> > Basically I want to use huge pages in a multithreaded number crunching
> > program, which happens to use process-shared semaphores (because fftw
> > does it).  The futex for the semaphore ends up lying on a huge page, and
> > I then get an endless loop in get_futex_key(), apparently because the
> > anonymous huge page containing the futex does not have a page->mapping.
> > A test case is provided in the above link.
> > 
> > I reported the bug to Fedora bugzilla months ago, but haven't received
> > any feedback yet. 
> 
> No, it works much better if you simply mail LKML and CC people who work
> on the code in question ;-)
> 
> >  The Fedora kernel is based on 2.6.32.11, and a
> > cursory glance at the 2.6.34-rc3 source does not yield any relevant
> > change.
> > 
> > So, could anyone tell me if the current mainline kernel might act better
> > in this respect, before I get around to compiling it?
> 
> Right, so I had a quick chat with Mel, and it appears MAP_PRIVATE
> hugetlb pages don't have their page->mapping set.
> 
> I guess something like the below might work, but I'd really rather not
> add hugetlb knowledge to futex.c. Does anybody else have a better idea?
> Maybe create something similar to an anon_vma for hugetlb pages?
> 

anon_vma for hugetlb pages sounds overkill, what would it gain? In this
context, futex only appears to distinguish between whether the
references are private or shared.

Looking at the hugetlbfs code, I can't see a place where it actually cares
about the mapping as such. It's used to find shared pages in the page cache
(but not in the LRU) that are backed by the hugetlbfs file. For hugetlbfs
though, the mapping is mostly kept in page->private for reservation accounting
purposes.

I can't think of other parts of the VM that touch the mapping if the
page is managed by hugetlbfs so the following patch should also work but
without futex having hugetlbfs-awareness. What do you think? Maybe for
safety, it would be better to make the mapping some obvious poison bytes
or'd with PAGE_MAPPING_ANON so an oops will be more obvious?

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 6034dc9..57a5faa 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -546,6 +546,7 @@ static void free_huge_page(struct page *page)
 
 	mapping = (struct address_space *) page_private(page);
 	set_page_private(page, 0);
+	page->mapping = NULL;
 	BUG_ON(page_count(page));
 	INIT_LIST_HEAD(&page->lru);
 
@@ -2447,8 +2448,10 @@ retry:
 			spin_lock(&inode->i_lock);
 			inode->i_blocks += blocks_per_huge_page(h);
 			spin_unlock(&inode->i_lock);
-		} else
+		} else {
 			lock_page(page);
+			page->mapping = (struct address_space *)PAGE_MAPPING_ANON;
+		}
 	}
 
 	/*
