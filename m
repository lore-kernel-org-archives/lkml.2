Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662Ab1D0FiG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 01:38:06 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39374 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217Ab1D0FiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 01:38:03 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 27 Apr 2011 14:31:21 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
        "mgorman@suse.de" <mgorman@suse.de>, Ying Han <yinghan@google.com>
Subject: Re: [PATCH v2] fix get_scan_count for working well with small
 targets
Message-Id: <20110427143121.e2a7e158.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <BANLkTi=zDFrgqn-Mpo2R1M0F_+aMo-byZg@mail.gmail.com>
References: <20110426181724.f8cdad57.kamezawa.hiroyu@jp.fujitsu.com>
	<20110426135934.c1992c3e.akpm@linux-foundation.org>
	<20110427105031.db203b95.kamezawa.hiroyu@jp.fujitsu.com>
	<BANLkTi=zDFrgqn-Mpo2R1M0F_+aMo-byZg@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Apr 2011 14:08:18 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> Hi Kame,
> 
> On Wed, Apr 27, 2011 at 10:50 AM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > On Tue, 26 Apr 2011 13:59:34 -0700
> > Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> >> What about simply removing the nr_saved_scan logic and permitting small
> >> scans?  That simplifies the code and I bet it makes no measurable
> >> performance difference.
> >>
> >
> > ok, v2 here. How this looks ?
> > For memcg, I think I should add select_victim_node() for direct reclaim,
> > then, we'll be tune big memcg using small memory on a zone case.
> >
> > ==
> > At memory reclaim, we determine the number of pages to be scanned
> > per zone as
> >        (anon + file) >> priority.
> > Assume
> >        scan = (anon + file) >> priority.
> >
> > If scan < SWAP_CLUSTER_MAX, the scan will be skipped for this time
> > and priority gets higher. This has some problems.
> >
> >  1. This increases priority as 1 without any scan.
> >     To do scan in this priority, amount of pages should be larger than 512M.
> >     If pages>>priority < SWAP_CLUSTER_MAX, it's recorded and scan will be
> >     batched, later. (But we lose 1 priority.)
> 
> Nice catch!  It looks to be much enhance.
> 
> >     But if the amount of pages is smaller than 16M, no scan at priority==0
> >     forever.
> 


> Before reviewing the code, I have a question about this.
> Now, in case of (priority = 0), we don't do shift operation with priority.>
 So nr_saved_scan would be the number of lru list pages. ie, 16M.
> Why no-scan happens in case of (priority == 0 and 16M lru pages)?
> What am I missing now?
> 
An, sorry. My comment is wrong. no scan at priority == DEF_PRIORITY.
I'll fix description.

But....
Now, in direct reclaim path
==
static void shrink_zones(int priority, struct zonelist *zonelist,
                                        struct scan_control *sc)
{
....
                if (scanning_global_lru(sc)) {
                        if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
                                continue;
                        if (zone->all_unreclaimable && priority != DEF_PRIORITY)
                                continue;       /* Let kswapd poll it */
                }
==

And in kswapd path
==
                /*
                 * Scan in the highmem->dma direction for the highest
                 * zone which needs scanning
                 */
                for (i = pgdat->nr_zones - 1; i >= 0; i--) {
                        struct zone *zone = pgdat->node_zones + i;

                        if (!populated_zone(zone))
                                continue;

                        if (zone->all_unreclaimable && priority != DEF_PRIORITY)
                                continue;
....
               for (i = 0; i <= end_zone; i++) {
                        if (zone->all_unreclaimable && priority != DEF_PRIORITY)
                                continue;

==

So, all_unreclaimable zones are only scanned when priority==DEF_PRIORITY.
But, in DEF_PRIORITY, scan count is always zero because of priority shift.
So, yes, no scan even if priority==0 even after setting all_unreclaimable == true.

Thanks,
-Kame

