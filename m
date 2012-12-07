Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423185Ab2LGBXB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 20:23:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54898 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755195Ab2LGBXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 20:23:00 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Tony Luck <tony.luck@intel.com>, Andi Kleen <andi.kleen@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 3/3] HWPOISON, hugetlbfs: fix RSS-counter warning
Date: Thu,  6 Dec 2012 20:22:42 -0500
Message-Id: <1354843362-3680-1-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <20121206144008.9b376ec7.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2012 at 02:40:08PM -0800, Andrew Morton wrote:
...
> > On Wed, Dec 05, 2012 at 10:04:50PM +0000, Luck, Tony wrote:
> > > 	if (PageHWPoison(page) && !(flags & TTU_IGNORE_HWPOISON)) {
> > > -		if (PageAnon(page))
> > > +		if (PageHuge(page))
> > > +			;
> > > +		else if (PageAnon(page))
> > >  			dec_mm_counter(mm, MM_ANONPAGES);
> > >  		else
> > >  			dec_mm_counter(mm, MM_FILEPAGES);
> > > 
> > > This style minimizes the "diff" ... but wouldn't it be nicer to say:
> > > 
> > > 		if (!PageHuge(page)) {
> > > 			old code in here
> > > 		}
> > > 
> > 
> > I think this need more lines in diff because old code should be
> > indented without any logical change.
> 
> I do agree with Tony on this.  While it is nice to keep the diff
> looking simple, it is more important that the resulting code be clean
> and idiomatic.

OK, I agree.

> --- a/mm/rmap.c~hwpoison-hugetlbfs-fix-rss-counter-warning-fix
> +++ a/mm/rmap.c
> @@ -1249,14 +1249,14 @@ int try_to_unmap_one(struct page *page, 
>  	update_hiwater_rss(mm);
>  
>  	if (PageHWPoison(page) && !(flags & TTU_IGNORE_HWPOISON)) {
> -		if (PageHuge(page))
> -			;
> -		else if (PageAnon(page))
> -			dec_mm_counter(mm, MM_ANONPAGES);
> -		else
> -			dec_mm_counter(mm, MM_FILEPAGES);
> -		set_pte_at(mm, address, pte,
> -				swp_entry_to_pte(make_hwpoison_entry(page)));
> +		if (!PageHuge(page)) {
> +			if (PageAnon(page))
> +				dec_mm_counter(mm, MM_ANONPAGES);
> +			else
> +				dec_mm_counter(mm, MM_FILEPAGES);
> +			set_pte_at(mm, address, pte,
> +				   swp_entry_to_pte(make_hwpoison_entry(page)));
> +		}

This set_pte_at() should come outside the if-block, or error containment
does not work.

Thanks,
Naoya

>  	} else if (PageAnon(page)) {
>  		swp_entry_t entry = { .val = page_private(page) };
>  
> _
> 
