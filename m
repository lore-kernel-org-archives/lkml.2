Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588Ab1BXXPe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 18:15:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39512 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756351Ab1BXXPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 18:15:33 -0500
Date: Fri, 25 Feb 2011 00:14:49 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 8/8] Add VM counters for transparent hugepages
Message-ID: <20110224231449.GE23252@random.random>
References: <1298425922-23630-1-git-send-email-andi@firstfloor.org>
 <1298425922-23630-9-git-send-email-andi@firstfloor.org>
 <1298587384.9138.23.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298587384.9138.23.camel@nimitz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 02:43:04PM -0800, Dave Hansen wrote:
> On Tue, 2011-02-22 at 17:52 -0800, Andi Kleen wrote:
> > @@ -2286,6 +2290,9 @@ void __split_huge_page_pmd(struct mm_struct *mm, pmd_t *pmd)
> >  		spin_unlock(&mm->page_table_lock);
> >  		return;
> >  	}
> > +
> > +	count_vm_event(THP_SPLIT);
> > +
> >  	page = pmd_page(*pmd);
> >  	VM_BUG_ON(!page_count(page));
> >  	get_page(page);
> 
> Hey Andi,
> 
> Your split counter tracks the split_huge_page_pmd() calls, but misses
> plain split_huge_page() calls.  Did you do this on purpose?  Could we
> move the counter in to the low-level split function like below?

Agreed, I already noticed and posted this same change in Message-ID:
20110224041851.GF31195

> diff -puN mm/huge_memory.c~move-THP_SPLIT mm/huge_memory.c
> --- linux-2.6.git/mm/huge_memory.c~move-THP_SPLIT	2011-02-24 14:37:32.825288409 -0800
> +++ linux-2.6.git-dave/mm/huge_memory.c	2011-02-24 14:39:01.767939971 -0800
> @@ -1342,6 +1342,8 @@ static void __split_huge_page(struct pag
>  	BUG_ON(!PageHead(page));
>  	BUG_ON(PageTail(page));
>  
> +	count_vm_event(THP_SPLIT);
> +
>  	mapcount = 0;
>  	list_for_each_entry(avc, &anon_vma->head, same_anon_vma) {
>  		struct vm_area_struct *vma = avc->vma;

I've a micropreference in having it in split_huge_page succeeding path
after __split_huge_page returns, as the __ function is where the
brainer code is and statcode to me is annoying to read mixed in the
more complex code. Not that it makes any practical difference though.
