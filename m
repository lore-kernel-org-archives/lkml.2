Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373Ab0IHOxI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 10:53:08 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:47544 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655Ab0IHOxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 10:53:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JwRBZXzSL/LFTs+zM0Khx2G1ZcwVWubpek7VK30bNMjgdSsKq9qqvfJZigdT2kY0UJ
         Ob+xNBaG2rBCOb2PSLdzi7gdiYVoRGRVPSzy8toMko/gYwgLTkKEG+XIcNke08cqo+nF
         RtvvkuuZpFSicaGGwMQf/TxPrN2IXeTJRZEQg=
Date: Wed, 8 Sep 2010 23:52:45 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        Linux Kernel List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 03/10] writeback: Do not congestion sleep if there are
 no congested BDIs or significant writeback
Message-ID: <20100908145245.GG4620@barrios-desktop>
References: <1283770053-18833-1-git-send-email-mel@csn.ul.ie>
 <1283770053-18833-4-git-send-email-mel@csn.ul.ie>
 <20100907152533.GB4620@barrios-desktop>
 <20100908110403.GB29263@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100908110403.GB29263@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 08, 2010 at 12:04:03PM +0100, Mel Gorman wrote:
> On Wed, Sep 08, 2010 at 12:25:33AM +0900, Minchan Kim wrote:
> > > + * @zone: A zone to consider the number of being being written back from
> > > + * @sync: SYNC or ASYNC IO
> > > + * @timeout: timeout in jiffies
> > > + *
> > > + * Waits for up to @timeout jiffies for a backing_dev (any backing_dev) to exit
> > > + * write congestion.  If no backing_devs are congested then the number of
> > > + * writeback pages in the zone are checked and compared to the inactive
> > > + * list. If there is no sigificant writeback or congestion, there is no point
> >                                                 and 
> > 
> 
> Why and? "or" makes sense because we avoid sleeping on either condition.

if (nr_bdi_congested[sync]) == 0) {
        if (writeback < inactive / 2) {
                cond_resched();
                ..
                goto out
        }
}

for avoiding sleeping, above two condition should meet. 
So I thought "and" is make sense. 
Am I missing something?

> 
> > > + * in sleeping but cond_resched() is called in case the current process has
> > > + * consumed its CPU quota.
> > > + */
> > > +long wait_iff_congested(struct zone *zone, int sync, long timeout)
> > > +{
> > > +	long ret;
> > > +	unsigned long start = jiffies;
> > > +	DEFINE_WAIT(wait);
> > > +	wait_queue_head_t *wqh = &congestion_wqh[sync];
> > > +
> > > +	/*
> > > +	 * If there is no congestion, check the amount of writeback. If there
> > > +	 * is no significant writeback and no congestion, just cond_resched
> > > +	 */
> > > +	if (atomic_read(&nr_bdi_congested[sync]) == 0) {
> > > +		unsigned long inactive, writeback;
> > > +
> > > +		inactive = zone_page_state(zone, NR_INACTIVE_FILE) +
> > > +				zone_page_state(zone, NR_INACTIVE_ANON);
> > > +		writeback = zone_page_state(zone, NR_WRITEBACK);
> > > +
> > > +		/*
> > > +		 * If less than half the inactive list is being written back,
> > > +		 * reclaim might as well continue
> > > +		 */
> > > +		if (writeback < inactive / 2) {
> > 
> > I am not sure this is best.
> > 
> 
> I'm not saying it is. The objective is to identify a situation where
> sleeping until the next write or congestion clears is pointless. We have
> already identified that we are not congested so the question is "are we
> writing a lot at the moment?". The assumption is that if there is a lot
> of writing going on, we might as well sleep until one completes rather
> than reclaiming more.
> 
> This is the first effort at identifying pointless sleeps. Better ones
> might be identified in the future but that shouldn't stop us making a
> semi-sensible decision now.

nr_bdi_congested is no problem since we have used it for a long time.
But you added new rule about writeback. 

Why I pointed out is that you added new rule and I hope let others know
this change since they have a good idea or any opinions. 
I think it's a one of roles as reviewer.

> 
> > 1. Without considering various speed class storage, could we fix it as half of inactive?
> 
> We don't really have a good means of identifying speed classes of
> storage. Worse, we are considering on a zone-basis here, not a BDI
> basis. The pages being written back in the zone could be backed by
> anything so we cannot make decisions based on BDI speed.

True. So it's why I have below question.
As you said, we don't have enough information in vmscan.
So I am not sure how effective such semi-sensible decision is. 

I think best is to throttle in page-writeback well. 
But I am not a expert about that and don't have any idea. Sorry.
So I can't insist on my nitpick. If others don't have any objection,
I don't mind this, either. 

Wu, Do you have any opinion?

> 
> > 2. Isn't there any writeback throttling on above layer? Do we care of it in here?
> > 
> 
> There are but congestion_wait() and now wait_iff_congested() are part of
> that. We can see from the figures in the leader that congestion_wait()
> is sleeping more than is necessary or smart.
> 
> > Just out of curiosity. 
> > 
> 
> -- 
> Mel Gorman
> Part-time Phd Student                          Linux Technology Center
> University of Limerick                         IBM Dublin Software Lab

-- 
Kind regards,
Minchan Kim
