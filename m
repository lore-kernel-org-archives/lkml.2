Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab0LAL4u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 06:56:50 -0500
Received: from gir.skynet.ie ([193.1.99.77]:52771 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417Ab0LAL4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 06:56:49 -0500
Date: Wed, 1 Dec 2010 11:56:33 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] mm: vmscan: Convert lumpy_mode into a bitmask
Message-ID: <20101201115633.GO13268@csn.ul.ie>
References: <1290440635-30071-1-git-send-email-mel@csn.ul.ie> <1290440635-30071-3-git-send-email-mel@csn.ul.ie> <20101201102732.GK15564@cmpxchg.org> <20101201105029.GL13268@csn.ul.ie> <20101201112116.GR15564@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20101201112116.GR15564@cmpxchg.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 01, 2010 at 12:21:16PM +0100, Johannes Weiner wrote:
> On Wed, Dec 01, 2010 at 10:50:29AM +0000, Mel Gorman wrote:
> > On Wed, Dec 01, 2010 at 11:27:32AM +0100, Johannes Weiner wrote:
> > > On Mon, Nov 22, 2010 at 03:43:50PM +0000, Mel Gorman wrote:
> > > > --- a/mm/vmscan.c
> > > > +++ b/mm/vmscan.c
> > > > @@ -51,11 +51,20 @@
> > > >  #define CREATE_TRACE_POINTS
> > > >  #include <trace/events/vmscan.h>
> > > >  
> > > > -enum lumpy_mode {
> > > > -	LUMPY_MODE_NONE,
> > > > -	LUMPY_MODE_ASYNC,
> > > > -	LUMPY_MODE_SYNC,
> > > > -};
> > > > +/*
> > > > + * lumpy_mode determines how the inactive list is shrunk
> > > > + * LUMPY_MODE_SINGLE: Reclaim only order-0 pages
> > > > + * LUMPY_MODE_ASYNC:  Do not block
> > > > + * LUMPY_MODE_SYNC:   Allow blocking e.g. call wait_on_page_writeback
> > > > + * LUMPY_MODE_CONTIGRECLAIM: For high-order allocations, take a reference
> > > > + *			page from the LRU and reclaim all pages within a
> > > > + *			naturally aligned range
> > > 
> > > I find those names terribly undescriptive.  It also strikes me as an
> > > odd set of flags.  Can't this be represented with less?
> > > 
> > > 	LUMPY_MODE_ENABLED
> > > 	LUMPY_MODE_SYNC
> > > 
> > > or, after the rename,
> > > 
> > > 	RECLAIM_MODE_HIGHER	= 1
> > > 	RECLAIM_MODE_SYNC	= 2
> > > 	RECLAIM_MODE_LUMPY	= 4
> > > 
> > 
> > My problem with that is you have to infer what the behaviour is from what the
> > flags "are not" as opposed to what they are. For example, !LUMPY_MODE_SYNC
> > implies LUMPY_MODE_ASYNC instead of specifying LUMPY_MODE_ASYNC.
> 
> Sounds like a boolean value to me.  And it shows: you never actually
> check for RECLAIM_MODE_ASYNC in the code, you just always set it to
> the opposite of RECLAIM_MODE_SYNC - the flag which is actually read.
> 

If you insist, the ASYNC flag can be dropped. I found it easier to flag
what behaviour was expected than infer it. In retrospect, I should have
passed the flag into set_reclaim_mode() instead of a boolean and it
would have been obvious from the caller site as well.

> > It also looks very odd when trying to distinguish between order-0
> > standard reclaim, lumpy reclaim and reclaim/compaction.
> 
> That is true, because this is still an actual tristate.  It's probably
> better to defer until lumpy reclaim is gone and there is only one flag
> for higher-order reclaim left.
> 

Sure.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
