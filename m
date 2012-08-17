Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156Ab2HQOsy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 10:48:54 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:56946 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758127Ab2HQOso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 10:48:44 -0400
X-AuditID: cbfee61b-b7faf6d00000476a-f2-502e59ca5767
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: "'Minchan Kim'" <minchan@kernel.org>, "'Mel Gorman'" <mgorman@suse.de>
Cc: "'Rik van Riel'" <riel@redhat.com>,
        "'Kamezawa Hiroyuki'" <kamezawa.hiroyu@jp.fujitsu.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <1344934627-8473-1-git-send-email-minchan@kernel.org>
 <1344934627-8473-2-git-send-email-minchan@kernel.org>
 <20120816135817.GS4177@suse.de> <20120817010547.GA3061@bbox>
In-reply-to: <20120817010547.GA3061@bbox>
Subject: RE: [RFC 1/2] cma: remove __reclaim_pages
Date: Fri, 17 Aug 2012 16:48:30 +0200
Organization: SPRC
Message-id: <024801cd7c87$6125f880$2371e980$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac18FHD2r2d3/WCcS12aVYKLNysqywAYoToQ
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsVy+t9jAd1TkXoBBgvWq1lc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mq0+OsRbcla7Y07KFsYFxvWgXIyeHhICJxPoZm5ggbDGJC/fW
	s3UxcnEICSxilJi3sQ/KmcUk8eDaHLAqNgFDia63XUAJDg4RATeJ8y+sQcLMAvsZJbav0IWo
	38EosfBxC1g9p4CmxJGnZ1lAbGEBI4m3O3axgtgsAqoSZz9PAJvDLyAkMXGWAkiYV8BFYvfX
	U0wQtqDEj8n3WCDma0ms33mcCcKWl9i85i0zSKuEgLrEo7+6IGERkOlHH7NClIhI3G14zjqB
	UXgWkkmzkEyahWTSLCQtCxhZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEh/cz6R2Mqxos
	DjEKcDAq8fAeKNMNEGJNLCuuzD3EKMHBrCTCu+IjUIg3JbGyKrUoP76oNCe1+BCjNAeLkjiv
	13+glEB6YklqdmpqQWoRTJaJg1OqgTHg/jt7HpEd+uKeBfOM2m/Iz7KUjGQ1+xK35M271PaA
	df/qXwbPfOgbOP/476O7i+r7r5/nWmZ5me1qTFzG+e70G5rul/bUbP9jM1Xo/KbIbZ5bL7NM
	YF+579qK3bk7T3BddfLZKTbzXurRkIiNLToceW17gv7ZaE76aqD74sY/b0mF02FMRxOUWIoz
	Eg21mIuKEwEiMXRqawIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Minchan,

On Friday, August 17, 2012 3:06 AM Minchan Kim wrote:

> On Thu, Aug 16, 2012 at 02:58:18PM +0100, Mel Gorman wrote:
> > On Tue, Aug 14, 2012 at 05:57:06PM +0900, Minchan Kim wrote:
> > > Now cma reclaims too many pages by __reclaim_pages which says
> > > following as
> > >
> > >         * Reclaim enough pages to make sure that contiguous allocation
> > >         * will not starve the system.
> > >
> > > Starve? What does it starve the system? The function which allocate
> > > free page for migration target would wake up kswapd and do direct reclaim
> > > if needed during migration so system doesn't starve.
> > >
> >
> > I thought this patch was overkill at the time it was introduced but
> > didn't have a concrete reason to reject it when I commented on it
> > https://lkml.org/lkml/2012/1/30/136 . Marek did want this and followed
> > up with "contiguous allocations should have higher priority than others"
> > which I took to mean that he was also ok with excessive reclaim.
> 
> I think OOM kill to background applications is more appropriate than
> big latency of foreground(ex, Camera app) application in your mobile phone.
> In other words, excessive reclaim is *really* bad which elapsed 8sec
> in my test as worst case. :(
> 
> >
> > > Let remove __reclaim_pages and related function and fields.
> > >
> >
> > That should be one patch and I don't object to it being removed as such
> > but it's Marek's call.
> 
> Marek. Any thought?

Well, I've introduced this function as a result of solving Mel's request:

http://www.spinics.net/lists/linux-mm/msg28485.html

Before that I solved it almost the same as in your current patch. I'm aware of 
the fact that __reclaim_pages() approach might be a little overkill, but I didn't
find anything better yet.

> > > I modified split_free_page slightly because I removed __reclaim_pages,
> > > isolate_freepages_range can fail by split_free_page's watermark check.
> > > It's very critical in CMA because it ends up failing alloc_contig_range.
> > >
> >
> > This is a big change and should have been in a patch on its
> > own. split_free_page checks watermarks because if the watermarks are
> > not obeyed a zone can become fully allocated. This can cause a system to
> > livelock under certain circumstances if a page cannot be allocated and a
> > free page is required before other pages can be freed.
> >
> > > I think we don't need the check in case of CMA because CMA allocates
> > > free pages by alloc_pages, not isolate_freepages_block in migrate_pages
> > > so watermark is already checked in alloc_pages.
> >
> > It uses alloc_pages when migrating pages out of the CMA area but note
> > that it uses isolate_freepages_block when allocating the CMA buffer when
> > alloc_contig_range calls isolate_freepages_range
> >
> > isolate_freepages_range(unsigned long start_pfn, unsigned long end_pfn)
> > {
> > 	for (pfn = start_pfn; pfn < end_pfn; pfn += isolated) {
> >                isolated = isolate_freepages_block(pfn, block_end_pfn,
> >                                                    &freelist, true);
> > 	}
> > 	map_pages(&freelist);
> > }
> >
> > so the actual CMA allocation itself is not using alloc_pages. By removing
> > the watermark check you allow the CMA to breach watermarks and puts the
> > system at risk of livelock.
> 
> Fair enough. I will look into that.

We will also looks into this issue. 

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


