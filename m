Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945943Ab2LGCKg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 21:10:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60428 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423613Ab2LGCKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 21:10:35 -0500
Date: Thu, 6 Dec 2012 18:10:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Tony Luck <tony.luck@intel.com>, Andi Kleen <andi.kleen@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 3/3] HWPOISON, hugetlbfs: fix RSS-counter warning
Message-Id: <20121206181024.f8a77240.akpm@linux-foundation.org>
In-Reply-To: <1354843362-3680-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <20121206144008.9b376ec7.akpm@linux-foundation.org>
	<1354843362-3680-1-git-send-email-n-horiguchi@ah.jp.nec.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  6 Dec 2012 20:22:42 -0500 Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:

> > --- a/mm/rmap.c~hwpoison-hugetlbfs-fix-rss-counter-warning-fix
> > +++ a/mm/rmap.c
> > @@ -1249,14 +1249,14 @@ int try_to_unmap_one(struct page *page, 
> >  	update_hiwater_rss(mm);
> >  
> >  	if (PageHWPoison(page) && !(flags & TTU_IGNORE_HWPOISON)) {
> > -		if (PageHuge(page))
> > -			;
> > -		else if (PageAnon(page))
> > -			dec_mm_counter(mm, MM_ANONPAGES);
> > -		else
> > -			dec_mm_counter(mm, MM_FILEPAGES);
> > -		set_pte_at(mm, address, pte,
> > -				swp_entry_to_pte(make_hwpoison_entry(page)));
> > +		if (!PageHuge(page)) {
> > +			if (PageAnon(page))
> > +				dec_mm_counter(mm, MM_ANONPAGES);
> > +			else
> > +				dec_mm_counter(mm, MM_FILEPAGES);
> > +			set_pte_at(mm, address, pte,
> > +				   swp_entry_to_pte(make_hwpoison_entry(page)));
> > +		}
> 
> This set_pte_at() should come outside the if-block, or error containment
> does not work.

Doh.  C is really hard!

--- a/mm/rmap.c~hwpoison-hugetlbfs-fix-rss-counter-warning-fix-fix
+++ a/mm/rmap.c
@@ -1254,9 +1254,9 @@ int try_to_unmap_one(struct page *page, 
 				dec_mm_counter(mm, MM_ANONPAGES);
 			else
 				dec_mm_counter(mm, MM_FILEPAGES);
-			set_pte_at(mm, address, pte,
-				   swp_entry_to_pte(make_hwpoison_entry(page)));
 		}
+		set_pte_at(mm, address, pte,
+			   swp_entry_to_pte(make_hwpoison_entry(page)));
 	} else if (PageAnon(page)) {
 		swp_entry_t entry = { .val = page_private(page) };
 
_

