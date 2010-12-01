Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab0LAKuq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 05:50:46 -0500
Received: from gir.skynet.ie ([193.1.99.77]:49797 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361Ab0LAKup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 05:50:45 -0500
Date: Wed, 1 Dec 2010 10:50:29 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] mm: vmscan: Convert lumpy_mode into a bitmask
Message-ID: <20101201105029.GL13268@csn.ul.ie>
References: <1290440635-30071-1-git-send-email-mel@csn.ul.ie> <1290440635-30071-3-git-send-email-mel@csn.ul.ie> <20101201102732.GK15564@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20101201102732.GK15564@cmpxchg.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 01, 2010 at 11:27:32AM +0100, Johannes Weiner wrote:
> On Mon, Nov 22, 2010 at 03:43:50PM +0000, Mel Gorman wrote:
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -51,11 +51,20 @@
> >  #define CREATE_TRACE_POINTS
> >  #include <trace/events/vmscan.h>
> >  
> > -enum lumpy_mode {
> > -	LUMPY_MODE_NONE,
> > -	LUMPY_MODE_ASYNC,
> > -	LUMPY_MODE_SYNC,
> > -};
> > +/*
> > + * lumpy_mode determines how the inactive list is shrunk
> > + * LUMPY_MODE_SINGLE: Reclaim only order-0 pages
> > + * LUMPY_MODE_ASYNC:  Do not block
> > + * LUMPY_MODE_SYNC:   Allow blocking e.g. call wait_on_page_writeback
> > + * LUMPY_MODE_CONTIGRECLAIM: For high-order allocations, take a reference
> > + *			page from the LRU and reclaim all pages within a
> > + *			naturally aligned range
> 
> I find those names terribly undescriptive.  It also strikes me as an
> odd set of flags.  Can't this be represented with less?
> 
> 	LUMPY_MODE_ENABLED
> 	LUMPY_MODE_SYNC
> 
> or, after the rename,
> 
> 	RECLAIM_MODE_HIGHER	= 1
> 	RECLAIM_MODE_SYNC	= 2
> 	RECLAIM_MODE_LUMPY	= 4
> 

My problem with that is you have to infer what the behaviour is from what the
flags "are not" as opposed to what they are. For example, !LUMPY_MODE_SYNC
implies LUMPY_MODE_ASYNC instead of specifying LUMPY_MODE_ASYNC. It also
looks very odd when trying to distinguish between order-0 standard reclaim,
lumpy reclaim and reclaim/compaction.

> where compaction mode is default if RECLAIM_MODE_HIGHER, and
> RECLAIM_MODE_LUMPY will go away eventually.
> 
> Also, if you have a flag name for 'reclaim with extra efforts for
> higher order pages' that is better than RECLAIM_MODE_HIGHER... ;)
> 
> > +typedef unsigned __bitwise__ lumpy_mode;
> 
> lumpy_mode_t / reclaim_mode_t?
> 

It can't hurt!

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
