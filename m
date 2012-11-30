Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030461Ab2K3Ooe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 09:44:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45357 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758383Ab2K3Ood (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 09:44:33 -0500
Date: Fri, 30 Nov 2012 15:44:31 +0100
From: Michal Hocko <mhocko@suse.cz>
To: azurIt <azurit@pobox.sk>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups mailinglist <cgroups@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH for 3.2.34] memcg: do not trigger OOM from
 add_to_page_cache_locked
Message-ID: <20121130144431.GI29317@dhcp22.suse.cz>
References: <20121123100438.GF24698@dhcp22.suse.cz>
 <20121125011047.7477BB5E@pobox.sk>
 <20121125120524.GB10623@dhcp22.suse.cz>
 <20121125135542.GE10623@dhcp22.suse.cz>
 <20121126013855.AF118F5E@pobox.sk>
 <20121126131837.GC17860@dhcp22.suse.cz>
 <20121126132149.GD17860@dhcp22.suse.cz>
 <20121130032918.59B3F780@pobox.sk>
 <20121130124506.GH29317@dhcp22.suse.cz>
 <20121130144427.51A09169@pobox.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121130144427.51A09169@pobox.sk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 30-11-12 14:44:27, azurIt wrote:
> >Anyway your system is under both global and local memory pressure. You
> >didn't see apache going down previously because it was probably the one
> >which was stuck and could be killed.
> >Anyway you need to setup your system more carefully.
> 
> 
> There is, also, an evidence that system has enough of memory! :) Just
> take column 'rss' from process list in OOM message and sum it - you
> will get 2489911. It's probably in KB so it's about 2.4 GB. System has
> 14 GB of RAM so this also match data on my graph - 2.4 is about 17% of
> 14.

Hmm, that corresponds to the ZONE_DMA32 size pretty nicely but that zone
is hardly touched:
Nov 30 02:53:56 server01 kernel: [  818.241291] DMA32 free:2523636kB min:2672kB low:3340kB high:4008kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:2542248kB mlocked:0kB dirty:0kB writeback:0kB mapped:4kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no

DMA32 zone is usually fills up first 4G unless your HW remaps the rest
of the memory above 4G or you have a numa machine and the rest of the
memory is at other node. Could you post your memory map printed during
the boot? (e820: BIOS-provided physical RAM map: and following lines)

There is also ZONE_NORMAL which is also not used much
Nov 30 02:53:56 server01 kernel: [  818.242163] Normal free:6924716kB min:12512kB low:15640kB high:18768kB active_anon:1463128kB inactive_anon:2072kB active_file:1803964kB inactive_file:1072628kB unevictable:3924kB isolated(anon):0kB isolated(file):0kB present:11893760kB mlocked:3924kB dirty:1000kB writeback:776kB mapped:35656kB shmem:3828kB slab_reclaimable:202560kB slab_unreclaimable:50696kB kernel_stack:2944kB pagetables:158616kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no

You have mentioned that you are comounting with cpuset. If this happens
to be a NUMA machine have you made the access to all nodes available?
Also what does /proc/sys/vm/zone_reclaim_mode says?
-- 
Michal Hocko
SUSE Labs
