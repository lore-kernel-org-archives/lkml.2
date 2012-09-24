Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750872Ab2IXV0r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 17:26:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35278 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab2IXV0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 17:26:46 -0400
Date: Mon, 24 Sep 2012 14:26:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Richard Davies <richard@arachsys.com>, Shaohua Li <shli@kernel.org>,
        Rik van Riel <riel@redhat.com>, Avi Kivity <avi@redhat.com>,
        QEMU-devel <qemu-devel@nongnu.org>, KVM <kvm@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 8/9] mm: compaction: Cache if a pageblock was scanned
 and no pages were isolated
Message-Id: <20120924142644.06c38b80.akpm@linux-foundation.org>
In-Reply-To: <20120924093938.GZ11266@suse.de>
References: <1348224383-1499-1-git-send-email-mgorman@suse.de>
	<1348224383-1499-9-git-send-email-mgorman@suse.de>
	<20120921143656.60a9a6cd.akpm@linux-foundation.org>
	<20120924093938.GZ11266@suse.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Sep 2012 10:39:38 +0100
Mel Gorman <mgorman@suse.de> wrote:

> On Fri, Sep 21, 2012 at 02:36:56PM -0700, Andrew Morton wrote:
> 
> > Also, what has to be done to avoid the polling altogether?  eg/ie, zap
> > a pageblock's PB_migrate_skip synchronously, when something was done to
> > that pageblock which justifies repolling it?
> > 
> 
> The "something" event you are looking for is pages being freed or
> allocated in the page allocator. A movable page being allocated in block
> or a page being freed should clear the PB_migrate_skip bit if it's set.
> Unfortunately this would impact the fast path of the alloc and free paths
> of the page allocator. I felt that that was too high a price to pay.

We already do a similar thing in the page allocator: clearing of
->all_unreclaimable and ->pages_scanned.  But that isn't on the "fast
path" really - it happens once per pcp unload.  Can we do something
like that?  Drop some hint into the zone without having to visit each
page?

> > >
> > > ...
> > >
> > > +static void reset_isolation_suitable(struct zone *zone)
> > > +{
> > > +	unsigned long start_pfn = zone->zone_start_pfn;
> > > +	unsigned long end_pfn = zone->zone_start_pfn + zone->spanned_pages;
> > > +	unsigned long pfn;
> > > +
> > > +	/*
> > > +	 * Do not reset more than once every five seconds. If allocations are
> > > +	 * failing sufficiently quickly to allow this to happen then continually
> > > +	 * scanning for compaction is not going to help. The choice of five
> > > +	 * seconds is arbitrary but will mitigate excessive scanning.
> > > +	 */
> > > +	if (time_before(jiffies, zone->compact_blockskip_expire))
> > > +		return;
> > > +	zone->compact_blockskip_expire = jiffies + (HZ * 5);
> > > +
> > > +	/* Walk the zone and mark every pageblock as suitable for isolation */
> > > +	for (pfn = start_pfn; pfn < end_pfn; pfn += pageblock_nr_pages) {
> > > +		struct page *page;
> > > +		if (!pfn_valid(pfn))
> > > +			continue;
> > > +
> > > +		page = pfn_to_page(pfn);
> > > +		if (zone != page_zone(page))
> > > +			continue;
> > > +
> > > +		clear_pageblock_skip(page);
> > > +	}
> > 
> > What's the worst-case loop count here?
> > 
> 
> zone->spanned_pages >> pageblock_order

What's the worst-case value of (zone->spanned_pages >> pageblock_order) :)
