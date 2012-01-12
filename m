Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238Ab2ALCSS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 21:18:18 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55989 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab2ALCSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 21:18:16 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 12 Jan 2012 11:17:02 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH] mm: Fix NULL ptr dereference in __count_immobile_pages
Message-Id: <20120112111702.3b7f2fa2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120111084802.GA16466@tiehlicka.suse.cz>
References: <1326213022-11761-1-git-send-email-mhocko@suse.cz>
	<alpine.DEB.2.00.1201101326080.10821@chino.kir.corp.google.com>
	<20120111084802.GA16466@tiehlicka.suse.cz>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jan 2012 09:48:02 +0100
Michal Hocko <mhocko@suse.cz> wrote:

> On Tue 10-01-12 13:31:08, David Rientjes wrote:
> > On Tue, 10 Jan 2012, Michal Hocko wrote:
> [...]
> > >  mm/page_alloc.c |   11 +++++++++++
> > >  1 files changed, 11 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > > index 2b8ba3a..485be89 100644
> > > --- a/mm/page_alloc.c
> > > +++ b/mm/page_alloc.c
> > > @@ -5608,6 +5608,17 @@ __count_immobile_pages(struct zone *zone, struct page *page, int count)
> > >  bool is_pageblock_removable_nolock(struct page *page)
> > >  {
> > >  	struct zone *zone = page_zone(page);
> > > +	unsigned long pfn = page_to_pfn(page);
> > > +

Hmm, I don't like to use page_zone() when we know the page may not be initialized.
Shouldn't we add

	if (!node_online(page_to_nid(page))
		return false;
?

But...hmm. I think we should return 'true' here for removing a section with a hole
finally....(Now, false will be safe.)



> > > +	/*
> > > +	 * We have to be careful here because we are iterating over memory
> > > +	 * sections which are not zone aware so we might end up outside of
> > > +	 * the zone but still within the section.
> > > +	 */
> > > +	if (!zone || zone->zone_start_pfn > pfn ||
> > > +			zone->zone_start_pfn + zone->spanned_pages <= pfn)
> > > +		return false;
> > > +
> > >  	return __count_immobile_pages(zone, page, 0);
> > >  }
> > >  
> > 
> > This seems partially bogus, why would
> > 
> > 	page_zone(page)->zone_start_pfn > page_to_pfn(page) ||
> > 	page_zone(page)->zone_start_pfn + page_zone(page)->spanned_pages <= page_to_pfn(page)
> > 
> > ever be true?  That would certainly mean that the struct zone is corrupted 
> > and seems to be unnecessary to fix the problem you're addressing.
> 
> Not really. Consider the case when the node 0 is present. Uninitialized
> page would lead to node=0, zone=0 and then we have to check for the zone
> boundaries.
> 



> > I think this should be handled in is_mem_section_removable() on the pfn 
> > rather than using the struct page in is_pageblock_removable_nolock() and 
> > converting back and forth.  We should make sure that any page passed to 
> > is_pageblock_removable_nolock() is valid.
> 
> Yes, I do not like pfn->page->pfn dance as well and in fact I do not
> have a strong opinion which one is better. I just put it at the place
> where we care about zone to be more obvious. If others think that I
> should move the check one level higher I'll do that. I just think this
> is more obvious.
> 
Hmm, mem_section and pageblock is a different chunk...
And, IIUC, in some IBM machines, section may includes several zones.
Please taking care of that if you move this to is_mem_section_removable()...

Thanks,
-Kame








