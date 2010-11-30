Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632Ab0K3LTf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 06:19:35 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59282 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755273Ab0K3LTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 06:19:34 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: Free memory never fully used, swapping
Cc: kosaki.motohiro@jp.fujitsu.com, Simon Kirby <sim@hostway.ca>,
        Shaohua Li <shaohua.li@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>
In-Reply-To: <20101130104136.GK13268@csn.ul.ie>
References: <20101130152002.8307.A69D9226@jp.fujitsu.com> <20101130104136.GK13268@csn.ul.ie>
Message-Id: <20101130201821.8319.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 30 Nov 2010 20:19:28 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> > > > >  out:
> > > > > -	if (!all_zones_ok) {
> > > > > +	if (!(all_zones_ok || (order && any_zone_ok))) {
> > > > 
> > > > This doesn't work ;)
> > > > kswapd have to clear ZONE_CONGESTED flag before enter sleeping.
> > > > otherwise nobody can clear it.
> > > > 
> > > 
> > > Does it not do it earlier in balance_pgdat() here
> > > 
> > >                                 /*
> > >                                  * If a zone reaches its high watermark,
> > >                                  * consider it to be no longer congested. It's
> > >                                  * possible there are dirty pages backed by
> > >                                  * congested BDIs but as pressure is
> > >                                  * relieved, spectulatively avoid congestion waits
> > >                                  */
> > >                                 zone_clear_flag(zone, ZONE_CONGESTED);
> > >                                 if (i <= pgdat->high_zoneidx)
> > >                                         any_zone_ok = 1;
> > 
> > zone_clear_flag(zone, ZONE_CONGESTED) only clear one zone status. other
> > zone remain old status.
> > 
> 
> Ah now I get you. kswapd does not necessarily balance all zones so it needs
> to unconditionally clear them all before it goes to sleep in case. At
> some time in the future, the tagging of ZONE_CONGESTED needs more
> thinking about.
>

This is a option.


> > > > Say, we have to fill below condition.
> > > >  - All zone are successing zone_watermark_ok(order-0)
> > > 
> > > We should loop around at least once with order == 0 where all_zones_ok
> > > is checked.
> > 
> > But no gurantee. IOW kswapd early stopping increase GFP_ATOMIC allocation
> > failure risk, I think.
> > 
> 
> Force all zones to be balanced for order-0?

Yes.

I think following change does.

	if (i <= pgdat->high_zoneidx)
- 		 any_zone_ok = 1;
+		order = sc.order = 0;


This is more conservative.



