Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709Ab1LWLEW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 06:04:22 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:28599 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218Ab1LWLET convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 06:04:19 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 80.237.6.56
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/LmHRZ1eUwGoukkhaIds/BG/5oZfMALTA=
Message-ID: <1324638242.562.15.camel@rybalov.eng.ttk.net>
Subject: Re: Kswapd in 3.2.0-rc5 is a CPU hog
From: nowhere <nowhere@hakkenden.ath.cx>
To: Dave Chinner <david@fromorbit.com>
Cc: Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Date: Fri, 23 Dec 2011 15:04:02 +0400
In-Reply-To: <20111223102027.GB12731@dastard>
References: <1324437036.4677.5.camel@hakkenden.homenet>
	 <20111221095249.GA28474@tiehlicka.suse.cz> <20111221225512.GG23662@dastard>
	 <1324630880.562.6.camel@rybalov.eng.ttk.net>
	 <20111223102027.GB12731@dastard>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

В Пт., 23/12/2011 в 21:20 +1100, Dave Chinner пишет:
> On Fri, Dec 23, 2011 at 01:01:20PM +0400, nowhere wrote:
> > В Чт., 22/12/2011 в 09:55 +1100, Dave Chinner пишет:
> > > On Wed, Dec 21, 2011 at 10:52:49AM +0100, Michal Hocko wrote:
> > > > [Let's CC linux-mm]
> > > > 
> > > > On Wed 21-12-11 07:10:36, Nikolay S. wrote:
> > > > > Hello,
> > > > > 
> > > > > I'm using 3.2-rc5 on a machine, which atm does almost nothing except
> > > > > file system operations and network i/o (i.e. file server). And there is
> > > > > a problem with kswapd.
> > > > 
> > > > What kind of filesystem do you use?
> > > > 
> > > > > 
> > > > > I'm playing with dd:
> > > > > dd if=/some/big/file of=/dev/null bs=8M
> > > > > 
> > > > > I.e. I'm filling page cache.
> > > > > 
> > > > > So when the machine is just rebooted, kswapd during this operation is
> > > > > almost idle, just 5-8 percent according to top.
> > > > > 
> > > > > After ~5 days of uptime (5 days,  2:10), the same operation demands ~70%
> > > > > for kswapd:
> > > > > 
> > > > >   PID USER      S %CPU %MEM    TIME+  SWAP COMMAND
> > > > >   420 root      R   70  0.0  22:09.60    0 kswapd0
> > > > > 17717 nowhere   D   27  0.2   0:01.81  10m dd
> > > > > 
> > > > > In fact, kswapd cpu usage on this operation steadily increases over
> > > > > time.
> > > > > 
> > > > > Also read performance degrades over time. After reboot:
> > > > > dd if=/some/big/file of=/dev/null bs=8M
> > > > > 1019+1 records in
> > > > > 1019+1 records out
> > > > > 8553494018 bytes (8.6 GB) copied, 16.211 s, 528 MB/s
> > > > > 
> > > > > After ~5 days uptime:
> > > > > dd if=/some/big/file of=/dev/null bs=8M
> > > > > 1019+1 records in
> > > > > 1019+1 records out
> > > > > 8553494018 bytes (8.6 GB) copied, 29.0507 s, 294 MB/s
> > > > > 
> > > > > Whereas raw disk sequential read performance stays the same:
> > > > > dd if=/some/big/file of=/dev/null bs=8M iflag=direct
> > > > > 1019+1 records in
> > > > > 1019+1 records out
> > > > > 8553494018 bytes (8.6 GB) copied, 14.7286 s, 581 MB/s
> > > > > 
> > > > > Also after dropping caches, situation somehow improves, but not to the
> > > > > state of freshly restarted system:
> > > > >   PID USER      S %CPU %MEM    TIME+  SWAP COMMAND
> > > > >   420 root      S   39  0.0  23:31.17    0 kswapd0
> > > > > 19829 nowhere   D   24  0.2   0:02.72 7764 dd
> > > > > 
> > > > > perf shows:
> > > > > 
> > > > >     31.24%  kswapd0  [kernel.kallsyms]  [k] _raw_spin_lock
> > > > >     26.19%  kswapd0  [kernel.kallsyms]  [k] shrink_slab
> > > > >     16.28%  kswapd0  [kernel.kallsyms]  [k] prune_super
> > > > >      6.55%  kswapd0  [kernel.kallsyms]  [k] grab_super_passive
> > > > >      5.35%  kswapd0  [kernel.kallsyms]  [k] down_read_trylock
> > > > >      4.03%  kswapd0  [kernel.kallsyms]  [k] up_read
> > > > >      2.31%  kswapd0  [kernel.kallsyms]  [k] put_super
> > > > >      1.81%  kswapd0  [kernel.kallsyms]  [k] drop_super
> > > > >      0.99%  kswapd0  [kernel.kallsyms]  [k] __put_super
> > > > >      0.25%  kswapd0  [kernel.kallsyms]  [k] __isolate_lru_page
> > > > >      0.23%  kswapd0  [kernel.kallsyms]  [k] free_pcppages_bulk
> > > > >      0.19%  kswapd0  [r8169]            [k] rtl8169_interrupt
> > > > >      0.15%  kswapd0  [kernel.kallsyms]  [k] twa_interrupt
> > > > 
> > > > Quite a lot of time spent shrinking slab (dcache I guess) and a lot of
> > > > spin lock contention.
> > > 
> > > That's just scanning superblocks, not apparently doing anything
> > > useful like shrinking dentries or inodes attached to each sb. i.e.
> > > the shrinkers are being called an awful lot and basically have
> > > nothing to do. I'd be suspecting a problem higher up in the stack to
> > > do with how shrink_slab is operating or being called.
> > > 
> > > I'd suggest gathering event traces for mm_shrink_slab_start/
> > > mm_shrink_slab_end to try to see how the shrinkers are being
> > > driven...
> > > 
> > > Cheers,
> > > 
> > > Dave.
> > 
> > I have recompiled kernel with tracers, and today the problem is visible
> > again. So here is the trace for mm_shrink_slab_start (it is HUGE):
> > 
> >          kswapd0   421 [000] 103976.627873: mm_shrink_slab_start: prune_super+0x0 0xffff88011b00d300: objects to shrink 12 gfp_flags GFP_KERNELGFP_NOTRACK pgs_scanned 32 lru_pgs 942483 cache items 1500 delt
> >          kswapd0   421 [000] 103976.627882: mm_shrink_slab_start: prune_super+0x0 0xffff88011a20ab00: objects to shrink 267 gfp_flags GFP_KERNELGFP_NOTRACK pgs_scanned 32 lru_pgs 942483 cache items 5300 del
> 
> And possibly useless in this form. I need to see the
> mm_shrink_slab_start/mm_shrink_slab_end events interleaved so I can
> see exactly how much work each shrinker call is doing, and the start
> events are truncated so not all the info I need is present.
> 
> Perhaps you should install trace-cmd.
> 
> $ trace-cmd record -e mm_shrink_slab*
> (wait 30s, then ^C)
> $ trace-cmd report > shrink.trace
> 
> And then compress and attach the trace file or put up on the web
> somewhere for me ot download if it's too large for email...
> 
> As it is, there's ~940k pages in the LRU, and shrink_slab is being
> called after 32, 95, 8, 8, 32 and 32 pages on the LRU have been
> scanned. That seems like the shrinkers are being called rather too
> often.
> 
> The end traces indicate the shrinker caches aren't able to free
> anything. So it looks like the vmscan code has got itself in a
> situation where it is not scanning many pages between shrinker
> callouts, and the shrinkers scan but can't make any progress. Looks
> like a vmscan balancing problem right now, not anything to do with
> the shrinker code. A better trace will confirm that.
> 
> FWIW, if you use trace-cmd, it might be worthwhile collecting all the
> vmscan trace events too, as that might help the VM folk understand
> the problem without needing to ask you for more info.

./trace-cmd record -e vmscan/*

Here is the report of trace-cmd while dd'ing
https://80.237.6.56/report-dd.xz


And one more during normal operation
https://80.237.6.56/report-normal.xz

> 
> Cheers,
> 
> Dave.


