Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008Ab2AEGVp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 01:21:45 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35301 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab2AEGVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 01:21:43 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 5 Jan 2012 15:20:28 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hillf Danton <dhillf@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>, linux-mm@kvack.org,
        David Rientjes <rientjes@google.com>, Hugh Dickins <hughd@google.com>,
        Michal Hocko <mhocko@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH] mm: vmscam: check page order in isolating lru pages
Message-Id: <20120105152028.e2689589.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120103160505.6f7a9aab.akpm@linux-foundation.org>
References: <CAJd=RBBJG+hLLc3mR-WzByU1gZEcdFUAoZzyir+1A4a0tVnSmg@mail.gmail.com>
	<4EFCA4F9.7070703@gmail.com>
	<CAJd=RBCuh=zDLZ7J9sV_p_ghoXP-VX6PEAx01t8p_pziTimxnA@mail.gmail.com>
	<20120103160505.6f7a9aab.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jan 2012 16:05:05 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sat, 31 Dec 2011 22:55:22 +0800
> Hillf Danton <dhillf@gmail.com> wrote:
> 
> > From: Hillf Danton <dhillf@gmail.com>
> > Subject: [PATCH] mm: vmscam: check page order in isolating lru pages
> > 
> > Before try to isolate physically contiguous pages, check for page order is
> > added, and if it is not regular page, we should give up the attempt.
> 
> Well..  why?  Neither the changelog nor the code comments explain why
> we skip these pages.  They should!
> 
> > --- a/mm/vmscan.c	Thu Dec 29 20:20:16 2011
> > +++ b/mm/vmscan.c	Sat Dec 31 22:44:16 2011
> > @@ -1162,6 +1162,7 @@ static unsigned long isolate_lru_pages(u
> >  		unsigned long end_pfn;
> >  		unsigned long page_pfn;
> >  		int zone_id;
> > +		unsigned int isolated_pages = 1;
> > 
> >  		page = lru_to_page(src);
> >  		prefetchw_prev_lru_page(page, src, flags);
> > @@ -1172,7 +1173,7 @@ static unsigned long isolate_lru_pages(u
> >  		case 0:
> >  			mem_cgroup_lru_del(page);
> >  			list_move(&page->lru, dst);
> > -			nr_taken += hpage_nr_pages(page);
> > +			isolated_pages = hpage_nr_pages(page);
> >  			break;
> > 
> >  		case -EBUSY:
> > @@ -1184,8 +1185,12 @@ static unsigned long isolate_lru_pages(u
> >  			BUG();
> >  		}
> > 
> > +		nr_taken += isolated_pages;
> >  		if (!order)
> >  			continue;
> > +		/* try pfn-based isolation only for regular page */
> > +		if (isolated_pages != 1)
> > +			continue;
> > 
> >  		/*
> >  		 * Attempt to take all pages in the order aligned region
> > @@ -1227,7 +1232,6 @@ static unsigned long isolate_lru_pages(u
> >  				break;
> > 
> >  			if (__isolate_lru_page(cursor_page, mode, file) == 0) {
> > -				unsigned int isolated_pages;
> > 
> >  				mem_cgroup_lru_del(cursor_page);
> >  				list_move(&cursor_page->lru, dst);
> 
> The code has become rather awkward.
> 
> I don't like the trick of reusing a local (isolated_pages) for other
> purposes later on in the function.  This introduces risk that someone
> will add a usage of the local for its original application after it has
> been reused.  And it's a little bit deceiving for readers - they first
> have to work out "oh, it's being reused for something else".  It would
> be better to use two identifiers.  The compiler is good at reusing
> registers (and sometimes stack slots) if the earlier local has gone
> dead.
> 
> Also, why do we test hpage_nr_pages() here?  Why not directly test
> PageTransHuge()?
> 
> 
> iow, something like this?
> 
> --- a/mm/vmscan.c~mm-vmscam-check-page-order-in-isolating-lru-pages-fix
> +++ a/mm/vmscan.c
> @@ -1173,7 +1173,6 @@ static unsigned long isolate_lru_pages(u
>  		unsigned long end_pfn;
>  		unsigned long page_pfn;
>  		int zone_id;
> -		unsigned int isolated_pages = 1;
>  
>  		page = lru_to_page(src);
>  		prefetchw_prev_lru_page(page, src, flags);
> @@ -1184,7 +1183,7 @@ static unsigned long isolate_lru_pages(u
>  		case 0:
>  			mem_cgroup_lru_del(page);
>  			list_move(&page->lru, dst);
> -			isolated_pages = hpage_nr_pages(page);
> +			nr_taken += hpage_nr_pages(page);
>  			break;
>  
>  		case -EBUSY:
> @@ -1196,11 +1195,11 @@ static unsigned long isolate_lru_pages(u
>  			BUG();
>  		}
>  
> -		nr_taken += isolated_pages;
>  		if (!order)
>  			continue;
> -		/* try pfn-based isolation only for regular page */
> -		if (isolated_pages != 1)
> +
> +		/* Try pfn-based isolation only for regular pages */
> +		if (PageTransHuge(page) != 1)
>  			continue;
>  
>  		/*
> @@ -1243,6 +1242,7 @@ static unsigned long isolate_lru_pages(u
>  				break;
>  
>  			if (__isolate_lru_page(cursor_page, mode, file) == 0) {
> +				unsigned int isolated_pages;
>  
>  				mem_cgroup_del_lru(cursor_page);
>  				list_move(&cursor_page->lru, dst);
> 
> 
> If hpage_nr_pages() is the official way of testing for a thp page
> then I guess this is the wrong thing to do!
> 

I think MAX_ORDER can be greater than THP size. So,


if (hpage_nr_pages(page) >= (1 << order))
	continue;

will be good. we can remove  !order check by this.

Thanks,
-Kame




