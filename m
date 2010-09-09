Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133Ab0IINzk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 09:55:40 -0400
Received: from gir.skynet.ie ([193.1.99.77]:51713 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276Ab0IINzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 09:55:37 -0400
Date: Thu, 9 Sep 2010 14:55:23 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <cl@linux.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 3/3] mm: page allocator: Drain per-cpu lists after
	direct reclaim allocation fails
Message-ID: <20100909135523.GA340@csn.ul.ie>
References: <1283504926-2120-1-git-send-email-mel@csn.ul.ie> <1283504926-2120-4-git-send-email-mel@csn.ul.ie> <20100908163956.C930.A69D9226@jp.fujitsu.com> <20100909124138.GQ29263@csn.ul.ie> <alpine.DEB.2.00.1009090843480.18975@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1009090843480.18975@router.home>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 09, 2010 at 08:45:16AM -0500, Christoph Lameter wrote:
> On Thu, 9 Sep 2010, Mel Gorman wrote:
> 
> > @@ -1876,10 +1890,13 @@ retry:
> >  					migratetype);
> >
> >  	/*
> > -	 * If an allocation failed after direct reclaim, it could be because
> > -	 * pages are pinned on the per-cpu lists. Drain them and try again
> > +	 * If a high-order allocation failed after direct reclaim, it could
> > +	 * be because pages are pinned on the per-cpu lists. However, only
> > +	 * do it for PAGE_ALLOC_COSTLY_ORDER as the cost of the IPI needed
> > +	 * to drain the pages is itself high. Assume that lower orders
> > +	 * will naturally free without draining.
> >  	 */
> > -	if (!page && !drained) {
> > +	if (!page && !drained && order > PAGE_ALLOC_COSTLY_ORDER) {
> >  		drain_all_pages();
> >  		drained = true;
> >  		goto retry;
> >
> 
> This will have the effect of never sending IPIs for slab allocations since
> they do not do allocations for orders > PAGE_ALLOC_COSTLY_ORDER.
>  

The question is how severe is that? There is somewhat of an expectation
that the lower orders free naturally so it the IPI justified? That said,
our historical behaviour would have looked like

if (!page && !drained && order) {
	drain_all_pages();
	draiained = true;
	goto retry;
}

Play it safe for now and go with that?

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
