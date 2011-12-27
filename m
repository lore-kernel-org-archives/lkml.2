Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751256Ab1L0GHQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 01:07:16 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:45235 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847Ab1L0GHN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 01:07:13 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 80.237.6.56
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/eQhyc/MQxeucFKTK9bZMLBMFOQNr4lYQ=
Message-ID: <1324966011.8894.1.camel@rybalov.eng.ttk.net>
Subject: Re: Kswapd in 3.2.0-rc5 is a CPU hog
From: nowhere <nowhere@hakkenden.ath.cx>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Dave Chinner <david@fromorbit.com>, Michal Hocko <mhocko@suse.cz>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Date: Tue, 27 Dec 2011 10:06:51 +0400
In-Reply-To: <20111227134405.9902dcbb.kamezawa.hiroyu@jp.fujitsu.com>
References: <1324437036.4677.5.camel@hakkenden.homenet>
	 <20111221095249.GA28474@tiehlicka.suse.cz> <20111221225512.GG23662@dastard>
	 <1324630880.562.6.camel@rybalov.eng.ttk.net>
	 <20111223102027.GB12731@dastard>
	 <1324638242.562.15.camel@rybalov.eng.ttk.net>
	 <20111223204503.GC12731@dastard>
	 <20111227111543.5e486eb7.kamezawa.hiroyu@jp.fujitsu.com>
	 <1324954208.4634.2.camel@hakkenden.homenet>
	 <20111227134405.9902dcbb.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

В Вт., 27/12/2011 в 13:44 +0900, KAMEZAWA Hiroyuki пишет:
> On Tue, 27 Dec 2011 06:50:08 +0400
> "Nikolay S." <nowhere@hakkenden.ath.cx> wrote:
> 
> > В Вт., 27/12/2011 в 11:15 +0900, KAMEZAWA Hiroyuki пишет:
> > > On Sat, 24 Dec 2011 07:45:03 +1100
> > > Dave Chinner <david@fromorbit.com> wrote:
> > > 
> > > > On Fri, Dec 23, 2011 at 03:04:02PM +0400, nowhere wrote:
> > > > > В Пт., 23/12/2011 в 21:20 +1100, Dave Chinner пишет:
> > > > > > On Fri, Dec 23, 2011 at 01:01:20PM +0400, nowhere wrote:
> > > > > > > В Чт., 22/12/2011 в 09:55 +1100, Dave Chinner пишет:
> > > > > > > > On Wed, Dec 21, 2011 at 10:52:49AM +0100, Michal Hocko wrote:
> > > 
> > > > > Here is the report of trace-cmd while dd'ing
> > > > > https://80.237.6.56/report-dd.xz
> > > > 
> > > > Ok, it's not a shrink_slab() problem - it's just being called ~100uS
> > > > by kswapd. The pattern is:
> > > > 
> > > > 	- reclaim 94 (batches of 32,32,30) pages from iinactive list
> > > > 	  of zone 1, node 0, prio 12
> > > > 	- call shrink_slab
> > > > 		- scan all caches
> > > > 		- all shrinkers return 0 saying nothing to shrink
> > > > 	- 40us gap
> > > > 	- reclaim 10-30 pages from inactive list of zone 2, node 0, prio 12
> > > > 	- call shrink_slab
> > > > 		- scan all caches
> > > > 		- all shrinkers return 0 saying nothing to shrink
> > > > 	- 40us gap
> > > > 	- isolate 9 pages from LRU zone ?, node ?, none isolated, none freed
> > > > 	- isolate 22 pages from LRU zone ?, node ?, none isolated, none freed
> > > > 	- call shrink_slab
> > > > 		- scan all caches
> > > > 		- all shrinkers return 0 saying nothing to shrink
> > > > 	40us gap
> > > > 
> > > > And it just repeats over and over again. After a while, nid=0,zone=1
> > > > drops out of the traces, so reclaim only comes in batches of 10-30
> > > > pages from zone 2 between each shrink_slab() call.
> > > > 
> > > > The trace starts at 111209.881s, with 944776 pages on the LRUs. It
> > > > finishes at 111216.1 with kswapd going to sleep on node 0 with
> > > > 930067 pages on the LRU. So 7 seconds to free 15,000 pages (call it
> > > > 2,000 pages/s) which is awfully slow....
> > > > 
> > > > vmscan gurus - time for you to step in now...
> > > >
> > >  
> > > Can you show /proc/zoneinfo ? I want to know each zone's size.
> > 
> 
> Thanks, 
> Qeustion:
>  1. does this system has no swap ?

It has. 4G

>  2. What version of kernel which you didn't see the kswapd issue ?

Hmm... 3.1 and below, I presume

>  3. Is this real host ? or virtualized ?

100% real

> 
> > $ cat /proc/zoneinfo 
> ...
> Node 0, zone    DMA32
>   pages free     19620
>         min      14715
>         low      18393
>         high     22072
>         scanned  0
>         spanned  1044480
>         present  896960
>     nr_free_pages 19620
>     nr_inactive_anon 43203
>     nr_active_anon 206577
>     nr_inactive_file 412249
>     nr_active_file 126151
> 
> Then, DMA32(zone=1) files are enough large (> 32 << 12)
> Hmm. assuming all frees are used for file(of dd)
> 
> 
> (412249 + 126151 + 19620) >> 12 = 136
> 
> So, 32, 32, 30 scan seems to work as desgined.
> 
> > Node 0, zone   Normal
> >   pages free     2854
> >         min      2116
> >         low      2645
> >         high     3174
> >         scanned  0
> >         spanned  131072
> >         present  129024
> >     nr_free_pages 2854
> >     nr_inactive_anon 20682
> >     nr_active_anon 10262
> >     nr_inactive_file 47083
> >     nr_active_file 11292
> 
> Hmm, NORMAL is much smaller than DMA32. (only 500MB.)
> 
> Then, at priority=12,
> 
>   13 << 12 = 53248
> 
> 13 pages per a scan seems to work as designed.
> To me,  it seems kswapd does usual work...reclaim small memory until free
> gets enough. And it seems 'dd' allocates its memory from ZONE_DMA32 because
> of gfp_t fallbacks.
> 
> 
> Memo.
> 
> 1. why shrink_slab() should be called per zone, which is not zone aware.
>    Isn't it enough to call it per priority ?
> 
> 2. what spinlock contention that perf showed ?
>    And if shrink_slab() doesn't consume cpu as trace shows, why perf 
>    says shrink_slab() is heavy..
> 
> 3. because 8/9 of memory is in DMA32, calling shrink_slab() frequently
>    at scanning NORMAL seems to be time wasting.
>  
> 
> Thanks,
> -Kame
> 
> 
> 
> 
> 


