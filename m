Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab1L0E6U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 23:58:20 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60604 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab1L0E6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 23:58:14 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 27 Dec 2011 13:56:58 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, nowhere <nowhere@hakkenden.ath.cx>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: Kswapd in 3.2.0-rc5 is a CPU hog
Message-Id: <20111227135658.08c8016a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20111227035730.GA22840@barrios-laptop.redhat.com>
References: <1324437036.4677.5.camel@hakkenden.homenet>
	<20111221095249.GA28474@tiehlicka.suse.cz>
	<20111221225512.GG23662@dastard>
	<1324630880.562.6.camel@rybalov.eng.ttk.net>
	<20111223102027.GB12731@dastard>
	<1324638242.562.15.camel@rybalov.eng.ttk.net>
	<20111223204503.GC12731@dastard>
	<20111227111543.5e486eb7.kamezawa.hiroyu@jp.fujitsu.com>
	<20111227035730.GA22840@barrios-laptop.redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Dec 2011 12:57:31 +0900
Minchan Kim <minchan@kernel.org> wrote:

> On Tue, Dec 27, 2011 at 11:15:43AM +0900, KAMEZAWA Hiroyuki wrote:
> > On Sat, 24 Dec 2011 07:45:03 +1100
> > Dave Chinner <david@fromorbit.com> wrote:
> > 
> > > On Fri, Dec 23, 2011 at 03:04:02PM +0400, nowhere wrote:
> > > > В Пт., 23/12/2011 в 21:20 +1100, Dave Chinner пишет:
> > > > > On Fri, Dec 23, 2011 at 01:01:20PM +0400, nowhere wrote:
> > > > > > В Чт., 22/12/2011 в 09:55 +1100, Dave Chinner пишет:
> > > > > > > On Wed, Dec 21, 2011 at 10:52:49AM +0100, Michal Hocko wrote:
> > 
> > > > Here is the report of trace-cmd while dd'ing
> > > > https://80.237.6.56/report-dd.xz
> > > 
> > > Ok, it's not a shrink_slab() problem - it's just being called ~100uS
> > > by kswapd. The pattern is:
> > > 
> > > 	- reclaim 94 (batches of 32,32,30) pages from iinactive list
> > > 	  of zone 1, node 0, prio 12
> > > 	- call shrink_slab
> > > 		- scan all caches
> > > 		- all shrinkers return 0 saying nothing to shrink
> > > 	- 40us gap
> > > 	- reclaim 10-30 pages from inactive list of zone 2, node 0, prio 12
> > > 	- call shrink_slab
> > > 		- scan all caches
> > > 		- all shrinkers return 0 saying nothing to shrink
> > > 	- 40us gap
> > > 	- isolate 9 pages from LRU zone ?, node ?, none isolated, none freed
> > > 	- isolate 22 pages from LRU zone ?, node ?, none isolated, none freed
> > > 	- call shrink_slab
> > > 		- scan all caches
> > > 		- all shrinkers return 0 saying nothing to shrink
> > > 	40us gap
> > > 
> > > And it just repeats over and over again. After a while, nid=0,zone=1
> > > drops out of the traces, so reclaim only comes in batches of 10-30
> > > pages from zone 2 between each shrink_slab() call.
> > > 
> > > The trace starts at 111209.881s, with 944776 pages on the LRUs. It
> > > finishes at 111216.1 with kswapd going to sleep on node 0 with
> > > 930067 pages on the LRU. So 7 seconds to free 15,000 pages (call it
> > > 2,000 pages/s) which is awfully slow....
> > > 
> > > vmscan gurus - time for you to step in now...
> > >
> >  
> > Can you show /proc/zoneinfo ? I want to know each zone's size.
> > 
> > Below is my memo.
> > 
> > In trace log, priority = 11 or 12. Then, I think kswapd can reclaim memory
> > to satisfy "sc.nr_reclaimed >= SWAP_CLUSTER_MAX" condition and loops again.
> > 
> > Seeing balance_pgdat() and trace log, I guess it does
> > 
> > 	wake up
> > 
> > 	shrink_zone(zone=0(DMA?))     => nothing to reclaim.
> > 		shrink_slab()
> > 	shrink_zone(zone=1(DMA32?))   => reclaim 32,32,31 pages 
> > 		shrink_slab()
> > 	shrink_zone(zone=2(NORMAL?))  => reclaim 13 pages. 
> > 		srhink_slab()
> > 
> > 	sleep or retry.
> > 
> > Why shrink_slab() need to be called frequently like this ?
> 
> I guess it's caused by small NORMAL zone.

You're right. I confirmed his zoneinfo.

> The scenario I think is as follows,
> 
> 1. dd comsumes memory in NORMAL zone
> 2. dd enter direct reclaim and wakeup kswapd
> 3. kswapd reclaims some memory in NORMAL zone until it reclaims high wamrk
> 4. schedule
> 5. dd consumes memory again in NORMAL zone
> 6. kswapd fail to reclaim memory by high watermark due to 5.
> 7. loop again, goto 3.
> 
> The point is speed between reclaim VS memory consumption.
> So kswapd cannot reach a point which enough pages are in NORMAL zone.
> 
> > 
> > BTW. I'm sorry if I miss something ...Why only kswapd reclaims memory
> > while 'dd' operation ? (no direct relcaim by dd.)
> > Is this log record cpu hog after 'dd' ?
> 
> If above scenario is right, dd couldn't enter direct reclaim to reclaim memory.
> 

I think you're right. IIUC, kswapd's behavior is what we usually see.

Hmm, if I understand correctly,

 - dd's speed down is caused by kswapd's cpu consumption.
 - kswapd's cpu consumption is enlarged by shrink_slab() (by perf)
 - kswapd can't stop because NORMAL zone is small.
 - memory reclaim speed is enough because dd can't get enough cpu.

I wonder reducing to call shrink_slab() may be a help but I'm not sure
where lock conention comes from...

Regards,
-Kame






