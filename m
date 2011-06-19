Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990Ab1FSXsf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 19:48:35 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35891 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805Ab1FSXse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 19:48:34 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 20 Jun 2011 08:41:23 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Ying Han <yinghan@google.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "bsingharora@gmail.com" <bsingharora@gmail.com>,
        Michal Hocko <mhocko@suse.cz>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Andrew Bresticker <abrestic@google.com>
Subject: Re: [PATCH 3/7] memcg: add memory.scan_stat
Message-Id: <20110620084123.c63d3e12.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <BANLkTimYEr9k3Sk5JoaRrrQH4mGoTmL1Wf5gadYVGDuNpxofHw@mail.gmail.com>
References: <20110616124730.d6960b8b.kamezawa.hiroyu@jp.fujitsu.com>
	<20110616125314.4f78b1e0.kamezawa.hiroyu@jp.fujitsu.com>
	<BANLkTimYEr9k3Sk5JoaRrrQH4mGoTmL1Wf5gadYVGDuNpxofHw@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Jun 2011 15:04:18 -0700
Ying Han <yinghan@google.com> wrote:

> On Wed, Jun 15, 2011 at 8:53 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > From e08990dd9ada13cf236bec1ef44b207436434b8e Mon Sep 17 00:00:00 2001
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > Date: Wed, 15 Jun 2011 14:11:01 +0900
> > Subject: [PATCH 3/7] memcg: add memory.scan_stat
> >
> > commit log of commit 0ae5e89 " memcg: count the soft_limit reclaim in..."
> > says it adds scanning stats to memory.stat file. But it doesn't because
> > we considered we needed to make a concensus for such new APIs.
> >
> > This patch is a trial to add memory.scan_stat. This shows
> >  - the number of scanned pages
> >  - the number of recleimed pages
> >  - the number of elaplsed time (including sleep/pause time)
> >  for both of direct/soft reclaim and shrinking caused by changing limit
> >  or force_empty.
> >
> > The biggest difference with oringinal Ying's one is that this file
> > can be reset by some write, as
> >
> >  # echo 0 ...../memory.scan_stat
> >
> > [kamezawa@bluextal ~]$ cat /cgroup/memory/A/memory.scan_stat
> > scanned_pages_by_limit 358470
> > freed_pages_by_limit 180795
> > elapsed_ns_by_limit 21629927
> > scanned_pages_by_system 0
> > freed_pages_by_system 0
> > elapsed_ns_by_system 0
> > scanned_pages_by_shrink 76646
> > freed_pages_by_shrink 38355
> > elappsed_ns_by_shrink 31990670
> > total_scanned_pages_by_limit 358470
> > total_freed_pages_by_limit 180795
> > total_elapsed_ns_by_hierarchical 216299275
> > total_scanned_pages_by_system 0
> > total_freed_pages_by_system 0
> > total_elapsed_ns_by_system 0
> > total_scanned_pages_by_shrink 76646
> > total_freed_pages_by_shrink 38355
> > total_elapsed_ns_by_shrink 31990670
> >
> > total_xxxx is for hierarchy management.
> >
> > This will be useful for further memcg developments and need to be
> > developped before we do some complicated rework on LRU/softlimit
> > management.
> 
> Agreed. Actually we are also looking into adding a per-memcg API for
> adding visibility of
> page reclaim path. It would be helpful for us to settle w/ the API first.
> 
> I am not a fan of names, but how about
> "/dev/cgroup/memory/memory.reclaim_stat" ?
> 

Hm, ok, I have no favorite. 


> >
> > Now, scan/free/elapsed_by_system is incomplete but future works of
> > Johannes at el. will fill remaining information and then, we can
> > look into problems of isolation between memcgs.
> >
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > ---
> >  Documentation/cgroups/memory.txt |   33 +++++++++
> >  include/linux/memcontrol.h       |   16 ++++
> >  include/linux/swap.h             |    6 -
> >  mm/memcontrol.c                  |  135 +++++++++++++++++++++++++++++++++++++--
> >  mm/vmscan.c                      |   27 ++++++-
> >  5 files changed, 199 insertions(+), 18 deletions(-)
> >
> > Index: mmotm-0615/Documentation/cgroups/memory.txt
> > ===================================================================
> > --- mmotm-0615.orig/Documentation/cgroups/memory.txt
> > +++ mmotm-0615/Documentation/cgroups/memory.txt
> > @@ -380,7 +380,7 @@ will be charged as a new owner of it.
> >
> >  5.2 stat file
> >
> > -memory.stat file includes following statistics
> > +5.2.1 memory.stat file includes following statistics
> >
> >  # per-memory cgroup local status
> >  cache          - # of bytes of page cache memory.
> > @@ -438,6 +438,37 @@ Note:
> >         file_mapped is accounted only when the memory cgroup is owner of page
> >         cache.)
> >
> > +5.2.2 memory.scan_stat
> > +
> > +memory.scan_stat includes statistics information for memory scanning and
> > +freeing, reclaiming. The statistics shows memory scanning information since
> > +memory cgroup creation and can be reset to 0 by writing 0 as
> > +
> > + #echo 0 > ../memory.scan_stat
> > +
> > +This file contains following statistics.
> > +
> > +scanned_pages_by_limit - # of scanned pages at hitting limit.
> > +freed_pages_by_limit   - # of freed pages at hitting limit.
> 
> How those stats different from Johannes's patch? I feel we should keep
> them into this API instead of memory.stat
> "pgscan_direct_limit"
> "pgreclaim_direct_limit"
> 

It's unclear the unit of number from that name.
And, I can't find what it means "direct_limit". Only "limit" is meaningful.



> > +elapsed_ns_by_limit    - nano sec of elappsed time at LRU scan at
> > +                                  hitting limit.(this includes sleep time.)
> 
> 
> > +
> > +scanned_pages_by_system        - # of scanned pages by the kernel.
> > +                         (Now, this value means global memory reclaim
> > +                           caused by system memory shortage with a hint
> > +                          of softlimit. "No soft limit" case will be
> > +                          supported in future.)
> > +freed_pages_by_system  - # of freed pages by the kernel.
> 
> The same for the following which I assume the same meaning with:
> "pgscan_direct_hierarchy"
> "pgreclaim_direct_hierarchy"
> 

Doesn't make sense. What hierarchy means, here?

Above 2 is for showing "amount of scanned/reclaimed memory by system's memory
pressure". 
(But now, it just shows "softlimit" information until Johannes' work comes.)

For hierarchy information, I have "total_xxxx_by_xxxx" parameter. 

> > +elapsed_ns_by_system   - nano sec of elappsed time by kernel.
> > +
> > +scanned_pages_by_shrink        - # of scanned pages by shrinking.
> > +                                 (i.e. changes of limit, force_empty, etc.)
> > +freed_pages_by_shrink  - # of freed pages by shirkining.
> 
> So those stats are not included in the ones above?
> 

Yes.

Thanks,
-Kame



