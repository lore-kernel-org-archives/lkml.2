Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab1LUJwy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 04:52:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57901 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596Ab1LUJwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 04:52:51 -0500
Date: Wed, 21 Dec 2011 10:52:49 +0100
From: Michal Hocko <mhocko@suse.cz>
To: "Nikolay S." <nowhere@hakkenden.ath.cx>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: Kswapd in 3.2.0-rc5 is a CPU hog
Message-ID: <20111221095249.GA28474@tiehlicka.suse.cz>
References: <1324437036.4677.5.camel@hakkenden.homenet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324437036.4677.5.camel@hakkenden.homenet>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Let's CC linux-mm]

On Wed 21-12-11 07:10:36, Nikolay S. wrote:
> Hello,
> 
> I'm using 3.2-rc5 on a machine, which atm does almost nothing except
> file system operations and network i/o (i.e. file server). And there is
> a problem with kswapd.

What kind of filesystem do you use?

> 
> I'm playing with dd:
> dd if=/some/big/file of=/dev/null bs=8M
> 
> I.e. I'm filling page cache.
> 
> So when the machine is just rebooted, kswapd during this operation is
> almost idle, just 5-8 percent according to top.
> 
> After ~5 days of uptime (5 days,  2:10), the same operation demands ~70%
> for kswapd:
> 
>   PID USER      S %CPU %MEM    TIME+  SWAP COMMAND
>   420 root      R   70  0.0  22:09.60    0 kswapd0
> 17717 nowhere   D   27  0.2   0:01.81  10m dd
> 
> In fact, kswapd cpu usage on this operation steadily increases over
> time.
> 
> Also read performance degrades over time. After reboot:
> dd if=/some/big/file of=/dev/null bs=8M
> 1019+1 records in
> 1019+1 records out
> 8553494018 bytes (8.6 GB) copied, 16.211 s, 528 MB/s
> 
> After ~5 days uptime:
> dd if=/some/big/file of=/dev/null bs=8M
> 1019+1 records in
> 1019+1 records out
> 8553494018 bytes (8.6 GB) copied, 29.0507 s, 294 MB/s
> 
> Whereas raw disk sequential read performance stays the same:
> dd if=/some/big/file of=/dev/null bs=8M iflag=direct
> 1019+1 records in
> 1019+1 records out
> 8553494018 bytes (8.6 GB) copied, 14.7286 s, 581 MB/s
> 
> Also after dropping caches, situation somehow improves, but not to the
> state of freshly restarted system:
>   PID USER      S %CPU %MEM    TIME+  SWAP COMMAND
>   420 root      S   39  0.0  23:31.17    0 kswapd0
> 19829 nowhere   D   24  0.2   0:02.72 7764 dd
> 
> perf shows:
> 
>     31.24%  kswapd0  [kernel.kallsyms]  [k] _raw_spin_lock
>     26.19%  kswapd0  [kernel.kallsyms]  [k] shrink_slab
>     16.28%  kswapd0  [kernel.kallsyms]  [k] prune_super
>      6.55%  kswapd0  [kernel.kallsyms]  [k] grab_super_passive
>      5.35%  kswapd0  [kernel.kallsyms]  [k] down_read_trylock
>      4.03%  kswapd0  [kernel.kallsyms]  [k] up_read
>      2.31%  kswapd0  [kernel.kallsyms]  [k] put_super
>      1.81%  kswapd0  [kernel.kallsyms]  [k] drop_super
>      0.99%  kswapd0  [kernel.kallsyms]  [k] __put_super
>      0.25%  kswapd0  [kernel.kallsyms]  [k] __isolate_lru_page
>      0.23%  kswapd0  [kernel.kallsyms]  [k] free_pcppages_bulk
>      0.19%  kswapd0  [r8169]            [k] rtl8169_interrupt
>      0.15%  kswapd0  [kernel.kallsyms]  [k] twa_interrupt

Quite a lot of time spent shrinking slab (dcache I guess) and a lot of
spin lock contention.
Could you also take few snapshots of /proc/420/stack to see what kswapd
is doing.

> 
> P.S.: The message above was written couple of days ago. Now I'm at 10
> days uptime, and this is the result as of today
>   PID USER      S %CPU %MEM    TIME+  SWAP COMMAND
>   420 root      R   93  0.0 110:48.48    0 kswapd0
> 30085 nowhere   D   42  0.2   0:04.36  10m dd
> 
> PPS: Please CC me.

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
