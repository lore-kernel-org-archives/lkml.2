Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635Ab0K2BED (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 20:04:03 -0500
Received: from mga03.intel.com ([143.182.124.21]:13941 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889Ab0K2BEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 20:04:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,273,1288594800"; 
   d="scan'208";a="354190286"
Subject: Re: Free memory never fully used, swapping
From: Shaohua Li <shaohua.li@intel.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Simon Kirby <sim@hostway.ca>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>
In-Reply-To: <20101126181604.B6E4.A69D9226@jp.fujitsu.com>
References: <20101126110244.B6DC.A69D9226@jp.fujitsu.com>
	 <1290739243.12777.17.camel@sli10-conroe>
	 <20101126181604.B6E4.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Nov 2010 09:03:58 +0800
Message-ID: <1290992638.12777.27.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-26 at 17:18 +0800, KOSAKI Motohiro wrote:
> > On Fri, 2010-11-26 at 10:31 +0800, KOSAKI Motohiro wrote:
> > > > record the order seems not sufficient. in balance_pgdat(), the for look
> > > > exit only when:
> > > > priority <0 or sc.nr_reclaimed >= SWAP_CLUSTER_MAX.
> > > > but we do if (sc.nr_reclaimed < SWAP_CLUSTER_MAX)
> > > >                         order = sc.order = 0;
> > > > this means before we set order to 0, we already reclaimed a lot of
> > > > pages, so I thought we need set order to 0 earlier before there are
> > > > enough free pages. below is a debug patch.
> > > > 
> > > > 
> > > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > > index d31d7ce..ee5d2ed 100644
> > > > --- a/mm/vmscan.c
> > > > +++ b/mm/vmscan.c
> > > > @@ -2117,6 +2117,26 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *mem_cont,
> > > >  }
> > > >  #endif
> > > >  
> > > > +static int all_zone_enough_free_pages(pg_data_t *pgdat)
> > > > +{
> > > > +	int i;
> > > > +
> > > > +	for (i = 0; i < pgdat->nr_zones; i++) {
> > > > +		struct zone *zone = pgdat->node_zones + i;
> > > > +
> > > > +		if (!populated_zone(zone))
> > > > +			continue;
> > > > +
> > > > +		if (zone->all_unreclaimable)
> > > > +			continue;
> > > > +
> > > > +		if (!zone_watermark_ok(zone, 0, high_wmark_pages(zone) * 8,
> > > > +								0, 0))
> > > > +			return 0;
> > > > +	}
> > > > +	return 1;
> > > > +}
> > > > +
> > > >  /* is kswapd sleeping prematurely? */
> > > >  static int sleeping_prematurely(pg_data_t *pgdat, int order, long remaining)
> > > >  {
> > > > @@ -2355,7 +2375,8 @@ out:
> > > >  		 * back to sleep. High-order users can still perform direct
> > > >  		 * reclaim if they wish.
> > > >  		 */
> > > > -		if (sc.nr_reclaimed < SWAP_CLUSTER_MAX)
> > > > +		if (sc.nr_reclaimed < SWAP_CLUSTER_MAX ||
> > > > +		    (order > 0 && all_zone_enough_free_pages(pgdat)))
> > > >  			order = sc.order = 0;
> > > 
> > > Ummm. this doesn't work. this place is processed every 32 pages reclaimed.
> > > (see below code and comment). Theresore your patch break high order reclaim
> > > logic.
> > Yes, this will break high order reclaim, but we need a compromise.
> > wrongly reclaim pages is more worse. could increase the watermark in
> > all_zone_enough_free_pages() better?
> > 
> 
> Hmm..
> I guess I haven't catch your mention. you wrote 
> 
> > > > but we do if (sc.nr_reclaimed < SWAP_CLUSTER_MAX)
> > > >                         order = sc.order = 0;
> > > > this means before we set order to 0, we already reclaimed a lot of
> > > > pages
> 
> and I wrote it's not a lot. So, I don't understand why you are talking
> about watermark increasing now. Personally you seems to talk unrelated
> topic. Can you please elablate your point more
ok let me clarify, in the for-loop of balance_pgdat() we reclaim 32
pages one time. but we have
if (!all_zones_ok) {
...
		if (sc.nr_reclaimed < SWAP_CLUSTER_MAX)
			order = sc.order = 0;

		goto loop_again;
	}
only when sc.nr_reclaimed < SWAP_CLUSTER_MAX or priority < 0, we set
order to 0. before this, we still use high order for zone_watermark_ok()
and it will fail and we keep doing page reclaim. So in the proposed
patch by you or Mel, checking the freed pages or order in kswapd() is
later. so I suggest we check if there is enough free pages in
balance_pgdat() and break high order allocation if yes.

