Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891Ab2ALIVN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 03:21:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45265 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752850Ab2ALIVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 03:21:10 -0500
Date: Thu, 12 Jan 2012 09:21:05 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] mm: Fix NULL ptr dereference in __count_immobile_pages
Message-ID: <20120112082105.GA1042@tiehlicka.suse.cz>
References: <1326213022-11761-1-git-send-email-mhocko@suse.cz>
 <20120111143439.538bf274.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120111143439.538bf274.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 11-01-12 14:34:39, Andrew Morton wrote:
> On Tue, 10 Jan 2012 17:30:22 +0100
> Michal Hocko <mhocko@suse.cz> wrote:
> 
> > This patch fixes the following NULL ptr dereference caused by
> > cat /sys/devices/system/memory/memory0/removable:
> 
> Which is world-readable, I assume?

Right. But considering that we haven't seen any report like that it
seems that the HW is rather rare

> 
> > ...
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -5608,6 +5608,17 @@ __count_immobile_pages(struct zone *zone, struct page *page, int count)
> >  bool is_pageblock_removable_nolock(struct page *page)
> >  {
> >  	struct zone *zone = page_zone(page);
> > +	unsigned long pfn = page_to_pfn(page);
> > +
> > +	/*
> > +	 * We have to be careful here because we are iterating over memory
> > +	 * sections which are not zone aware so we might end up outside of
> > +	 * the zone but still within the section.
> > +	 */
> > +	if (!zone || zone->zone_start_pfn > pfn ||
> > +			zone->zone_start_pfn + zone->spanned_pages <= pfn)
> > +		return false;
> > +
> >  	return __count_immobile_pages(zone, page, 0);
> >  }
> 
> So I propose that we backport it into -stable?

Agreed.

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
