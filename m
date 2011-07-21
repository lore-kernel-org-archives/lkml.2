Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900Ab1GURBS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 13:01:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52237 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343Ab1GURBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 13:01:17 -0400
Date: Thu, 21 Jul 2011 18:01:12 +0100
From: Mel Gorman <mgorman@suse.de>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        P?draig Brady <P@draigBrady.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Colin King <colin.king@canonical.com>,
        Andrew Lutomirski <luto@mit.edu>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] mm: vmscan: Only read new_classzone_idx from pgdat
 when reclaiming successfully
Message-ID: <20110721170112.GU5349@suse.de>
References: <1308926697-22475-1-git-send-email-mgorman@suse.de>
 <1308926697-22475-5-git-send-email-mgorman@suse.de>
 <20110719160903.GA2978@barrios-desktop>
 <20110720104847.GI5349@suse.de>
 <20110721153007.GC1713@barrios-desktop>
 <20110721160706.GS5349@suse.de>
 <20110721163649.GG1713@barrios-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110721163649.GG1713@barrios-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 22, 2011 at 01:36:49AM +0900, Minchan Kim wrote:
> > > > <SNIP>
> > > > @@ -2740,17 +2742,23 @@ static int kswapd(void *p)
> > > >       tsk->flags |= PF_MEMALLOC | PF_SWAPWRITE | PF_KSWAPD;
> > > >       set_freezable();
> > > >  
> > > > -     order = 0;
> > > > -     classzone_idx = MAX_NR_ZONES - 1;
> > > > +     order = new_order = 0;
> > > > +     classzone_idx = new_classzone_idx = pgdat->nr_zones - 1;
> > > >       for ( ; ; ) {
> > > > -             unsigned long new_order;
> > > > -             int new_classzone_idx;
> > > >               int ret;
> > > >  
> > > > -             new_order = pgdat->kswapd_max_order;
> > > > -             new_classzone_idx = pgdat->classzone_idx;
> > > > -             pgdat->kswapd_max_order = 0;
> > > > -             pgdat->classzone_idx = MAX_NR_ZONES - 1;
> > > > +             /*
> > > > +              * If the last balance_pgdat was unsuccessful it's unlikely a
> > > > +              * new request of a similar or harder type will succeed soon
> > > > +              * so consider going to sleep on the basis we reclaimed at
> > > > +              */
> > > > +             if (classzone_idx >= new_classzone_idx && order == new_order) {
> > > > +                     new_order = pgdat->kswapd_max_order;
> > > > +                     new_classzone_idx = pgdat->classzone_idx;
> > > > +                     pgdat->kswapd_max_order =  0;
> > > > +                     pgdat->classzone_idx = pgdat->nr_zones - 1;
> > > > +             }
> > > > +
> > > 
> > > But in this part.
> > > Why do we need this?
> > 
> > Lets say it's a fork-heavy workload and it is routinely being woken
> > for order-1 allocations and the highest zone is very small. For the
> > most part, it's ok because the allocations are being satisfied from
> > the lower zones which kswapd has no problem balancing.
> > 
> > However, by reading the information even after failing to
> > balance, kswapd continues balancing for order-1 due to reading
> > pgdat->kswapd_max_order, each time failing for the highest zone. It
> > only takes one wakeup request per balance_pgdat() to keep kswapd
> > awake trying to balance the highest zone in a continual loop.
> 
> You made balace_pgdat's classzone_idx as communicated back so classzone_idx returned
> would be not high zone and in [1/4], you changed that sleeping_prematurely consider only
> classzone_idx not nr_zones. So I think it should sleep if low zones is balanced.
> 

If a wakeup for order-1 happened during the last pgdat, the
classzone_idx as communicated back from balance_pgdat() is lost and it
will not sleep in this ordering of events

kswapd 									other processes
====== 									===============
order = balance_pgdat(pgdat, order, &classzone_idx);
									wakeup for order-1
kswapd balances lower zone 
									allocate from lower zone
balance_pgdat fails balance for highest zone, returns
	with lower classzone_idx and possibly lower order
new_order = pgdat->kswapd_max_order      (order == 1)
new_classzone_idx = pgdat->classzone_idx (highest zone)
if (order < new_order || classzone_idx > new_classzone_idx) {
        order = new_order;
        classzone_idx = new_classzone_idx; (failure from balance_pgdat() lost)
}
order = balance_pgdat(pgdat, order, &classzone_idx);

The wakup for order-1 at any point during balance_pgdat() is enough to
keep kswapd awake even though the process that called wakeup_kswapd
would be able to allocate from the lower zones without significant
difficulty.

This is why if balance_pgdat() fails its request, it should go to sleep
if watermarks for the lower zones are met until woken by another
process.

-- 
Mel Gorman
SUSE Labs
