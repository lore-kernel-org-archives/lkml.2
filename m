Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758728Ab1E0IcQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 04:32:16 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57393 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab1E0IcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 04:32:14 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 27 May 2011 17:25:22 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Ying Han <yinghan@google.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH v3 3/10] memcg: a test whether zone is reclaimable
 or not
Message-Id: <20110527172522.776a9e26.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <BANLkTi=Ado5+B2t02PLq10xhh4310F-S9Q@mail.gmail.com>
References: <20110526141047.dc828124.kamezawa.hiroyu@jp.fujitsu.com>
	<20110526141909.ec42113e.kamezawa.hiroyu@jp.fujitsu.com>
	<BANLkTi=Ado5+B2t02PLq10xhh4310F-S9Q@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 May 2011 00:21:31 -0700
Ying Han <yinghan@google.com> wrote:

> On Wed, May 25, 2011 at 10:19 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > From: Ying Han <yinghan@google.com>
> >
> > The number of reclaimable pages per zone is an useful information for
> > controling memory reclaim schedule. This patch exports it.
> >
> > Changelog v2->v3:
> >  - added comments.
> >
> > Signed-off-by: Ying Han <yinghan@google.com>
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > ---
> >  include/linux/memcontrol.h |    2 ++
> >  mm/memcontrol.c            |   24 ++++++++++++++++++++++++
> >  2 files changed, 26 insertions(+)
> >
> > Index: memcg_async/mm/memcontrol.c
> > ===================================================================
> > --- memcg_async.orig/mm/memcontrol.c
> > +++ memcg_async/mm/memcontrol.c
> > @@ -1240,6 +1240,30 @@ static unsigned long mem_cgroup_nr_lru_p
> >  }
> >  #endif /* CONFIG_NUMA */
> >
> > +/**
> > + * mem_cgroup_zone_reclaimable_pages
> > + * @memcg: the memcg
> > + * @nid  : node index to be checked.
> > + * @zid  : zone index to be checked.
> > + *
> > + * This function returns the number reclaimable pages on a zone for given memcg.
> > + * Reclaimable page includes file caches and anonymous pages if swap is
> > + * avaliable and never includes unevictable pages.
> > + */
> > +unsigned long mem_cgroup_zone_reclaimable_pages(struct mem_cgroup *memcg,
> > +                                               int nid, int zid)
> > +{
> > +       unsigned long nr;
> > +       struct mem_cgroup_per_zone *mz = mem_cgroup_zoneinfo(memcg, nid, zid);
> > +
> > +       nr = MEM_CGROUP_ZSTAT(mz, NR_ACTIVE_FILE) +
> > +               MEM_CGROUP_ZSTAT(mz, NR_ACTIVE_FILE);
> > +       if (nr_swap_pages > 0)
> > +               nr += MEM_CGROUP_ZSTAT(mz, NR_ACTIVE_ANON) +
> > +                       MEM_CGROUP_ZSTAT(mz, NR_INACTIVE_ANON);
> > +       return nr;
> > +}
> > +
> >  struct zone_reclaim_stat *mem_cgroup_get_reclaim_stat(struct mem_cgroup *memcg,
> >                                                      struct zone *zone)
> >  {
> > Index: memcg_async/include/linux/memcontrol.h
> > ===================================================================
> > --- memcg_async.orig/include/linux/memcontrol.h
> > +++ memcg_async/include/linux/memcontrol.h
> > @@ -109,6 +109,8 @@ extern void mem_cgroup_end_migration(str
> >  */
> >  int mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg);
> >  int mem_cgroup_inactive_file_is_low(struct mem_cgroup *memcg);
> > +unsigned long
> > +mem_cgroup_zone_reclaimable_pages(struct mem_cgroup *memcg, int nid, int zid);
> >  int mem_cgroup_select_victim_node(struct mem_cgroup *memcg);
> >  unsigned long mem_cgroup_zone_nr_lru_pages(struct mem_cgroup *memcg,
> >                                                struct zone *zone,
> >
> >
> 
> Again, please apply the patch:
> 

Nice catch. thank you.

-Kame

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6a52699..0b88d71 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1217,7 +1217,7 @@ unsigned long
> mem_cgroup_zone_reclaimable_pages(struct mem_cgroup *memcg,
>        struct mem_cgroup_per_zone *mz = mem_cgroup_zoneinfo(memcg, nid, zid);
> 
>        nr = MEM_CGROUP_ZSTAT(mz, NR_ACTIVE_FILE) +
> -               MEM_CGROUP_ZSTAT(mz, NR_ACTIVE_FILE);
> +               MEM_CGROUP_ZSTAT(mz, NR_INACTIVE_FILE);
>        if (nr_swap_pages > 0)
>                nr += MEM_CGROUP_ZSTAT(mz, NR_ACTIVE_ANON) +
>                        MEM_CGROUP_ZSTAT(mz, NR_INACTIVE_ANON);
> 
> 
> Also, you need to move this to up since patch 1/10 needs this.
> 
> --Ying
> 

