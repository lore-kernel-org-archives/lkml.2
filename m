Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab0LOGxh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 01:53:37 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:60621 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab0LOGxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 01:53:36 -0500
Date: Wed, 15 Dec 2010 12:15:22 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, npiggin@kernel.dk,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kosaki.motohiro@jp.fujitsu.com, cl@linux.com,
        kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 2/3] Refactor zone_reclaim (v2)
Message-ID: <20101215064522.GA2657@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20101210142745.29934.29186.stgit@localhost6.localdomain6>
 <20101210143018.29934.11893.stgit@localhost6.localdomain6>
 <AANLkTimeecObDMQMbWzNhL1mE+UT9D3o1WWS4bmxtR4U@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimeecObDMQMbWzNhL1mE+UT9D3o1WWS4bmxtR4U@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* MinChan Kim <minchan.kim@gmail.com> [2010-12-14 19:01:26]:

> Hi Balbir,
> 
> On Fri, Dec 10, 2010 at 11:31 PM, Balbir Singh
> <balbir@linux.vnet.ibm.com> wrote:
> > Move reusable functionality outside of zone_reclaim.
> > Make zone_reclaim_unmapped_pages modular
> >
> > Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> > ---
> >  mm/vmscan.c |   35 +++++++++++++++++++++++------------
> >  1 files changed, 23 insertions(+), 12 deletions(-)
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index e841cae..4e2ad05 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -2815,6 +2815,27 @@ static long zone_pagecache_reclaimable(struct zone *zone)
> >  }
> >
> >  /*
> > + * Helper function to reclaim unmapped pages, we might add something
> > + * similar to this for slab cache as well. Currently this function
> > + * is shared with __zone_reclaim()
> > + */
> > +static inline void
> > +zone_reclaim_unmapped_pages(struct zone *zone, struct scan_control *sc,
> > +                               unsigned long nr_pages)
> > +{
> > +       int priority;
> > +       /*
> > +        * Free memory by calling shrink zone with increasing
> > +        * priorities until we have enough memory freed.
> > +        */
> > +       priority = ZONE_RECLAIM_PRIORITY;
> > +       do {
> > +               shrink_zone(priority, zone, sc);
> > +               priority--;
> > +       } while (priority >= 0 && sc->nr_reclaimed < nr_pages);
> > +}
> 
> As I said previous version, zone_reclaim_unmapped_pages doesn't have
> any functions related to reclaim unmapped pages.
> The function name is rather strange.
> It would be better to add scan_control setup in function inner to
> reclaim only unmapped pages.

OK, that is an idea worth looking at, I'll revisit this function.

Thanks for the review!

-- 
	Three Cheers,
	Balbir
