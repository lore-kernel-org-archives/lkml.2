Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202Ab1FSXv6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 19:51:58 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49898 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755092Ab1FSXvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 19:51:55 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 20 Jun 2011 08:44:54 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Ying Han <yinghan@google.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "bsingharora@gmail.com" <bsingharora@gmail.com>,
        Michal Hocko <mhocko@suse.cz>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>
Subject: Re: [PATCH 5/7] Fix not good check of mem_cgroup_local_usage()
Message-Id: <20110620084454.85f048f9.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <BANLkTi=4o-xY46OtsvNCxVKUT-qJBXRMMFZCe-m7eMV-_mesXw@mail.gmail.com>
References: <20110616124730.d6960b8b.kamezawa.hiroyu@jp.fujitsu.com>
	<20110616125443.23584d78.kamezawa.hiroyu@jp.fujitsu.com>
	<BANLkTi=4o-xY46OtsvNCxVKUT-qJBXRMMFZCe-m7eMV-_mesXw@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Jun 2011 15:27:36 -0700
Ying Han <yinghan@google.com> wrote:

> On Wed, Jun 15, 2011 at 8:54 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > From fcfc6ee9847b0b2571cd6e9847572d7c70e1e2b2 Mon Sep 17 00:00:00 2001
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > Date: Thu, 16 Jun 2011 09:23:54 +0900
> > Subject: [PATCH 5/7] Fix not good check of mem_cgroup_local_usage()
> >
> > Now, mem_cgroup_local_usage(memcg) is used as hint for scanning memory
> > cgroup hierarchy. If it returns true, the memcg has some reclaimable memory.
> >
> > But this function doesn't take care of
> >  - unevictable pages
> >  - anon pages on swapless system.
> >
> > This patch fixes the function to use LRU information.
> > For NUMA, for avoid scanning, numa scan bitmap is used. If it's
> > empty, some more precise check will be done.
> >
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > ---
> >  mm/memcontrol.c |   43 +++++++++++++++++++++++++++++++++----------
> >  1 files changed, 33 insertions(+), 10 deletions(-)
> >
> > Index: mmotm-0615/mm/memcontrol.c
> > ===================================================================
> > --- mmotm-0615.orig/mm/memcontrol.c
> > +++ mmotm-0615/mm/memcontrol.c
> > @@ -632,15 +632,6 @@ static long mem_cgroup_read_stat(struct
> >        return val;
> >  }
> >
> > -static long mem_cgroup_local_usage(struct mem_cgroup *mem)
> > -{
> > -       long ret;
> > -
> > -       ret = mem_cgroup_read_stat(mem, MEM_CGROUP_STAT_RSS);
> > -       ret += mem_cgroup_read_stat(mem, MEM_CGROUP_STAT_CACHE);
> > -       return ret;
> > -}
> > -
> >  static void mem_cgroup_swap_statistics(struct mem_cgroup *mem,
> >                                         bool charge)
> >  {
> > @@ -1713,6 +1704,23 @@ static void mem_cgroup_numascan_init(str
> >        mutex_init(&mem->numascan_mutex);
> >  }
> >
> > +static bool mem_cgroup_reclaimable(struct mem_cgroup *mem, bool noswap)
> > +{
> > +       if (!nodes_empty(mem->scan_nodes))
> > +               return true;
> > +       /* slow path */
> > +       if (mem_cgroup_get_local_zonestat(mem, LRU_INACTIVE_FILE))
> > +               return true;
> > +       if (mem_cgroup_get_local_zonestat(mem, LRU_ACTIVE_FILE))
> > +               return true;
> 
> Wondering if we can simplify this like:
> 
> if (mem_cgroup_nr_file_lru_pages(mem))
>    return true;
> 
> 
> > +       if (noswap || !total_swap_pages)
> > +               return false;
> > +       if (mem_cgroup_get_local_zonestat(mem, LRU_INACTIVE_ANON))
> > +               return true;
> > +       if (mem_cgroup_get_local_zonestat(mem, LRU_ACTIVE_ANON))
> > +               return true;
> 
> the same:
> if (mem_cgroup_nr_anon_lru_pages(mem))
>    return true;
> 
> > +       return false;
> > +}
> 
> The two functions above are part of memory.numa_stat patch which is in
> mmotm i believe. Just feel the functionality a bit duplicate except
> the noswap parameter and scan_nodes.
> 

Ah, I didn't noticed such function.


Hm, considering more, I think we don't have to scann all nodes and
make sum of number because what we check is whether pages == 0 or
pages != 0.

I'll make an update.

Thanks,
-Kame




