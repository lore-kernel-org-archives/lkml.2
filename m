Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276Ab2AKAd1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 19:33:27 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:65344 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756667Ab2AKAdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 19:33:25 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAHvWDE95LbVq/2dsb2JhbABDrFiBBoFyAQEFOhwjEAgDGC4UJQMhE75yE4sdYwSVC5JP
Date: Wed, 11 Jan 2012 11:33:22 +1100
From: Dave Chinner <david@fromorbit.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan@kernel.org>, nowhere <nowhere@hakkenden.ath.cx>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: Kswapd in 3.2.0-rc5 is a CPU hog
Message-ID: <20120111003322.GE24410@dastard>
References: <1324437036.4677.5.camel@hakkenden.homenet>
 <20111221095249.GA28474@tiehlicka.suse.cz>
 <20111221225512.GG23662@dastard>
 <1324630880.562.6.camel@rybalov.eng.ttk.net>
 <20111223102027.GB12731@dastard>
 <1324638242.562.15.camel@rybalov.eng.ttk.net>
 <20111223204503.GC12731@dastard>
 <20111227111543.5e486eb7.kamezawa.hiroyu@jp.fujitsu.com>
 <20111227035730.GA22840@barrios-laptop.redhat.com>
 <20111227135658.08c8016a.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111227135658.08c8016a.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 27, 2011 at 01:56:58PM +0900, KAMEZAWA Hiroyuki wrote:
> On Tue, 27 Dec 2011 12:57:31 +0900
> Minchan Kim <minchan@kernel.org> wrote:
> > The scenario I think is as follows,
> > 
> > 1. dd comsumes memory in NORMAL zone
> > 2. dd enter direct reclaim and wakeup kswapd
> > 3. kswapd reclaims some memory in NORMAL zone until it reclaims high wamrk
> > 4. schedule
> > 5. dd consumes memory again in NORMAL zone
> > 6. kswapd fail to reclaim memory by high watermark due to 5.
> > 7. loop again, goto 3.
> > 
> > The point is speed between reclaim VS memory consumption.
> > So kswapd cannot reach a point which enough pages are in NORMAL zone.
> > 
> > > 
> > > BTW. I'm sorry if I miss something ...Why only kswapd reclaims memory
> > > while 'dd' operation ? (no direct relcaim by dd.)
> > > Is this log record cpu hog after 'dd' ?
> > 
> > If above scenario is right, dd couldn't enter direct reclaim to reclaim memory.
> > 
> 
> I think you're right. IIUC, kswapd's behavior is what we usually see.
> 
> Hmm, if I understand correctly,
> 
>  - dd's speed down is caused by kswapd's cpu consumption.
>  - kswapd's cpu consumption is enlarged by shrink_slab() (by perf)
>  - kswapd can't stop because NORMAL zone is small.
>  - memory reclaim speed is enough because dd can't get enough cpu.
> 
> I wonder reducing to call shrink_slab() may be a help but I'm not sure
> where lock conention comes from...

There is no lock contention. It's simply the overhead of grabbing a
passive reference to every superblock in the machine 3 times every
100uS.

FWIW, I don't think kswapd should be polling the shrinkers this
often when there are no/very few pages available to be freed from
the slab caches. There are many more shrinkers now than there were
in the past, so the overhead of polling all shrinkers very quickly
is significant.

FWIW, when we move to locality aware shrinkers, the polling overhead
is going to be even higher, so either the VM needs to call
shrink_slab less aggressively, or shrink_slab() needs to have some
method of reducing shrinker polling frequency.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
