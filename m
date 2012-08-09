Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769Ab2HIJUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 05:20:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44691 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421Ab2HIJUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 05:20:39 -0400
Date: Thu, 9 Aug 2012 10:20:35 +0100
From: Mel Gorman <mgorman@suse.de>
To: Minchan Kim <minchan@kernel.org>
Cc: Linux-MM <linux-mm@kvack.org>, Rik van Riel <riel@redhat.com>,
        Jim Schutt <jaschut@sandia.gov>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] mm: vmscan: Scale number of pages reclaimed by
 reclaim/compaction based on failures
Message-ID: <20120809092035.GD12690@suse.de>
References: <1344342677-5845-1-git-send-email-mgorman@suse.de>
 <1344342677-5845-3-git-send-email-mgorman@suse.de>
 <20120808014824.GB4247@bbox>
 <20120808075526.GI29814@suse.de>
 <20120808082738.GF4247@bbox>
 <20120808085112.GJ29814@suse.de>
 <20120808235127.GA17835@bbox>
 <20120809074949.GA12690@suse.de>
 <20120809082715.GA19802@bbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20120809082715.GA19802@bbox>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2012 at 05:27:15PM +0900, Minchan Kim wrote:
> > > > +      * pages reclaimed based on the number of consecutive allocation
> > > > +      * failures
> > > > +      */
> > > > +     zone = lruvec_zone(lruvec);
> > > > +     if (zone->compact_order_failed >= sc->order)
> > > 
> > > I can't understand this part.
> > > We don't defer lower order than compact_order_failed by aff62249.
> > > Do you mean lower order compaction context should be a lamb for
> > > deferred higher order allocation request success? I think it's not fair
> > > and even I can't understand rationale why it has to scale the number of pages
> > > reclaimed with the number of recent compaction failture.
> > > Your changelog just says "What we have to do, NOT Why we have to do".
> > > 
> > 
> > I'm a moron, that should be <=, not >=. All my tests were based on order==9
> > and that was the only order using reclaim/compaction so it happened to
> > work as expected. Thanks! I fixed that and added the following
> > clarification to the changelog
> > 
> > The rationale is that reclaiming the normal number of pages still allowed
> > compaction to fail and its success depends on the number of pages. If it's
> > failing, reclaim more pages until it succeeds again.
> > 
> > Does that make more sense?
> 
> If compaction is defered, requestors fails to get high-order page and
> they normally do fallback by order-0 or something.

Yes. At least, one hopes they fell back to order-0.

> In this context, if they don't depends on fallback and retrying higher order
> allocation, your patch makes sense to me because your algorithm is based on
> past allocation request fail rate.
> Do I miss something?

Your question is difficult to parse but I think you are making an implicit
assumption that it's the same caller retrying the high order allocation.
That is not the case, not do I want it to be because that would be similar
to the caller using __GFP_REPEAT. Retrying with more reclaim until the
allocation succeeds would both stall and reclaim excessively.

The intention is that an allocation can fail but each subsequent attempt will
try harder until there is success. Each allocation request does a portion
of the necessary work to spread the cost between multiple requests. Take
THP for example where there is a constant request for THP allocations
for whatever reason (heavy fork workload, large buffer allocation being
populated etc.). Some of those allocations fail but if they do, future
THP requests will reclaim more pages. When compaction resumes again, it
will be more likely to succeed and compact_defer_shift gets reset. In the
specific case of THP there will be allocations that fail but khugepaged
will promote them later if the process is long-lived.

-- 
Mel Gorman
SUSE Labs
