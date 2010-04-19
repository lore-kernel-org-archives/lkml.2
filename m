Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634Ab0DSLwk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 07:52:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:49491 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab0DSLwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 07:52:39 -0400
Subject: Re: Process-shared futexes on hugepages puts the kernel in an
 infinite loop in 2.6.32.11; is this fixed now?
From: Peter Zijlstra <peterz@infradead.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: r6144 <rainy6144@gmail.com>, linux-kernel@vger.kernel.org,
       Darren Hart <dvhltc@us.ibm.com>, tglx <tglx@linutronix.de>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
In-Reply-To: <20100419114300.GT19264@csn.ul.ie>
References: <1271432722.2564.16.camel@localhost.localdomain>
	 <1271449668.1674.466.camel@laptop>  <20100419114300.GT19264@csn.ul.ie>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Apr 2010 13:52:36 +0200
Message-ID: <1271677956.1674.922.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-19 at 12:43 +0100, Mel Gorman wrote:

> > Right, so I had a quick chat with Mel, and it appears MAP_PRIVATE
> > hugetlb pages don't have their page->mapping set.
> > 
> > I guess something like the below might work, but I'd really rather not
> > add hugetlb knowledge to futex.c. Does anybody else have a better idea?
> > Maybe create something similar to an anon_vma for hugetlb pages?
> > 
> 
> anon_vma for hugetlb pages sounds overkill, what would it gain? In this
> context, futex only appears to distinguish between whether the
> references are private or shared.
> 
> Looking at the hugetlbfs code, I can't see a place where it actually cares
> about the mapping as such. It's used to find shared pages in the page cache
> (but not in the LRU) that are backed by the hugetlbfs file. For hugetlbfs
> though, the mapping is mostly kept in page->private for reservation accounting
> purposes.
> 
> I can't think of other parts of the VM that touch the mapping if the
> page is managed by hugetlbfs so the following patch should also work but
> without futex having hugetlbfs-awareness. What do you think? Maybe for
> safety, it would be better to make the mapping some obvious poison bytes
> or'd with PAGE_MAPPING_ANON so an oops will be more obvious?

Yes, this seems perfectly adequate to me, that poison idea might be
worthwhile too :-)

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 6034dc9..57a5faa 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -546,6 +546,7 @@ static void free_huge_page(struct page *page)
>  
>  	mapping = (struct address_space *) page_private(page);
>  	set_page_private(page, 0);
> +	page->mapping = NULL;
>  	BUG_ON(page_count(page));
>  	INIT_LIST_HEAD(&page->lru);
>  
> @@ -2447,8 +2448,10 @@ retry:
>  			spin_lock(&inode->i_lock);
>  			inode->i_blocks += blocks_per_huge_page(h);
>  			spin_unlock(&inode->i_lock);
> -		} else
> +		} else {
>  			lock_page(page);
> +			page->mapping = (struct address_space *)PAGE_MAPPING_ANON;
> +		}
>  	}
>  
>  	/*



