Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab1D1Ctx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 22:49:53 -0400
Received: from smtp-out.google.com ([74.125.121.67]:12497 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab1D1Ctv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 22:49:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=alAltlVUB1C76TyR5hhYLabp/Uum5YbCe9i66qBBjKOgEMsC2UXNl7faRzwkfFtqHY
         1XBEtdS5EjOzEt4Vm18w==
MIME-Version: 1.0
In-Reply-To: <20110428085751.fd478fe8.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110427165120.a60c6609.kamezawa.hiroyu@jp.fujitsu.com>
	<BANLkTinx+4zXaO3rhHRUzr3m-K-2_NMTQw@mail.gmail.com>
	<20110428085751.fd478fe8.kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 27 Apr 2011 19:49:44 -0700
Message-ID: <BANLkTi=eJYQoahG_+rHDqWBUxh9ipWgX-Q@mail.gmail.com>
Subject: Re: [PATCHv2] memcg: reclaim memory from node in round-robin
From: Ying Han <yinghan@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 4:57 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Wed, 27 Apr 2011 10:33:43 -0700
> Ying Han <yinghan@google.com> wrote:
>
>> On Wed, Apr 27, 2011 at 12:51 AM, KAMEZAWA Hiroyuki
>> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> > I changed the logic a little and add a filter for skipping nodes.
>> > With large NUMA, tasks may under cpuset or mempolicy and the usage of memory
>> > can be unbalanced. So, I think a filter is required.
>>
>> Thank you.
>>
>> >
>> > ==
>> > Now, memory cgroup's direct reclaim frees memory from the current node.
>> > But this has some troubles. In usual, when a set of threads works in
>> > cooperative way, they are tend to on the same node. So, if they hit
>> > limits under memcg, it will reclaim memory from themselves, it may be
>> > active working set.
>> >
>> > For example, assume 2 node system which has Node 0 and Node 1
>> > and a memcg which has 1G limit. After some work, file cacne remains and
>> > and usages are
>> >   Node 0:  1M
>> >   Node 1:  998M.
>> >
>> > and run an application on Node 0, it will eats its foot before freeing
>> > unnecessary file caches.
>> >
>> > This patch adds round-robin for NUMA and adds equal pressure to each
>> > node. When using cpuset's spread memory feature, this will work very well.
>> >
>> >
>> > From: Ying Han <yinghan@google.com>
>> > Signed-off-by: Ying Han <yinghan@google.com>
>> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> >
>> > Changelog v1->v2:
>> >  - fixed comments.
>> >  - added a logic to avoid scanning unused node.
>> >
>> > ---
>> >  include/linux/memcontrol.h |    1
>> >  mm/memcontrol.c            |   98 ++++++++++++++++++++++++++++++++++++++++++---
>> >  mm/vmscan.c                |    9 +++-
>> >  3 files changed, 101 insertions(+), 7 deletions(-)
>> >
>> > Index: memcg/include/linux/memcontrol.h
>> > ===================================================================
>> > --- memcg.orig/include/linux/memcontrol.h
>> > +++ memcg/include/linux/memcontrol.h
>> > @@ -108,6 +108,7 @@ extern void mem_cgroup_end_migration(str
>> >  */
>> >  int mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg);
>> >  int mem_cgroup_inactive_file_is_low(struct mem_cgroup *memcg);
>> > +int mem_cgroup_select_victim_node(struct mem_cgroup *memcg);
>> >  unsigned long mem_cgroup_zone_nr_pages(struct mem_cgroup *memcg,
>> >                                       struct zone *zone,
>> >                                       enum lru_list lru);
>> > Index: memcg/mm/memcontrol.c
>> > ===================================================================
>> > --- memcg.orig/mm/memcontrol.c
>> > +++ memcg/mm/memcontrol.c
>> > @@ -237,6 +237,11 @@ struct mem_cgroup {
>> >         * reclaimed from.
>> >         */
>> >        int last_scanned_child;
>> > +       int last_scanned_node;
>> > +#if MAX_NUMNODES > 1
>> > +       nodemask_t      scan_nodes;
>> > +       unsigned long   next_scan_node_update;
>> > +#endif
>> >        /*
>> >         * Should the accounting and control be hierarchical, per subtree?
>> >         */
>> > @@ -650,18 +655,27 @@ static void mem_cgroup_soft_scan(struct
>> >        this_cpu_add(mem->stat->events[MEM_CGROUP_EVENTS_SOFT_SCAN], val);
>> >  }
>> >
>> > +static unsigned long
>> > +mem_cgroup_get_zonestat_node(struct mem_cgroup *mem, int nid, enum lru_list idx)
>> > +{
>> > +       struct mem_cgroup_per_zone *mz;
>> > +       u64 total;
>> > +       int zid;
>> > +
>> > +       for (zid = 0; zid < MAX_NR_ZONES; zid++) {
>> > +               mz = mem_cgroup_zoneinfo(mem, nid, zid);
>> > +               total += MEM_CGROUP_ZSTAT(mz, idx);
>> > +       }
>> > +       return total;
>> > +}
>> >  static unsigned long mem_cgroup_get_local_zonestat(struct mem_cgroup *mem,
>> >                                        enum lru_list idx)
>> >  {
>> > -       int nid, zid;
>> > -       struct mem_cgroup_per_zone *mz;
>> > +       int nid;
>> >        u64 total = 0;
>> >
>> >        for_each_online_node(nid)
>> > -               for (zid = 0; zid < MAX_NR_ZONES; zid++) {
>> > -                       mz = mem_cgroup_zoneinfo(mem, nid, zid);
>> > -                       total += MEM_CGROUP_ZSTAT(mz, idx);
>> > -               }
>> > +               total += mem_cgroup_get_zonestat_node(mem, nid, idx);
>> >        return total;
>> >  }
>> >
>> > @@ -1471,6 +1485,77 @@ mem_cgroup_select_victim(struct mem_cgro
>> >        return ret;
>> >  }
>> >
>> > +#if MAX_NUMNODES > 1
>> > +
>> > +/*
>> > + * Update nodemask always is not very good. Even if we have empty
>> > + * list, or wrong list here, we can start from some node and traverse all nodes
>> > + * based on zonelist. So, update the list loosely once in 10 secs.
>> > + *
>> > + */
>> > +static void mem_cgroup_may_update_nodemask(struct mem_cgroup *mem)
>> > +{
>> > +       int nid;
>> > +
>> > +       if (time_after(mem->next_scan_node_update, jiffies))
>> > +               return;
>> > +
>> > +       mem->next_scan_node_update = jiffies + 10*HZ;
>> > +       /* make a nodemask where this memcg uses memory from */
>> > +       mem->scan_nodes = node_states[N_HIGH_MEMORY];
>> > +
>> > +       for_each_node_mask(nid, node_states[N_HIGH_MEMORY]) {
>> > +
>> > +               if (mem_cgroup_get_zonestat_node(mem, nid, LRU_INACTIVE_FILE) ||
>> > +                   mem_cgroup_get_zonestat_node(mem, nid, LRU_ACTIVE_FILE))
>> > +                       continue;
>> > +
>> > +               if (total_swap_pages &&
>> > +                   (mem_cgroup_get_zonestat_node(mem, nid, LRU_INACTIVE_ANON) ||
>> > +                    mem_cgroup_get_zonestat_node(mem, nid, LRU_ACTIVE_ANON)))
>> > +                       continue;
>> > +               node_clear(nid, mem->scan_nodes);
>> > +       }
>> > +
>> > +}
>> > +
>> > +/*
>> > + * Selecting a node where we start reclaim from. Because what we need is just
>> > + * reducing usage counter, start from anywhere is O,K. Considering
>> > + * memory reclaim from current node, there are pros. and cons.
>> > + *
>> > + * Freeing memory from current node means freeing memory from a node which
>> > + * we'll use or we've used. So, it may make LRU bad. And if several threads
>> > + * hit limits, it will see a contention on a node. But freeing from remote
>> > + * node means more costs for memory reclaim because of memory latency.
>> > + *
>> > + * Now, we use round-robin. Better algorithm is welcomed.
>> > + */
>> > +int mem_cgroup_select_victim_node(struct mem_cgroup *mem)
>> > +{
>> > +       int node;
>> > +
>> > +       mem_cgroup_may_update_nodemask(mem);
>> > +       node = mem->last_scanned_node;
>> > +
>> > +       node = next_node(node, mem->scan_nodes);
>> > +       if (node == MAX_NUMNODES) {
>> > +               node = first_node(mem->scan_nodes);
>> > +               if (unlikely(node == MAX_NUMNODES))
>> > +                       node = numa_node_id();
>> not sure about this logic, is that possible we reclaim from a node
>> with all "unreclaimable" pages (based on the
>> mem_cgroup_may_update_nodemask check).
>> If i missed anything here, it would be helpful to add comment.
>>
>
> What I'm afraid here is when a user uses very small memcg,
> all pages on the LRU may be isolated or all usages are in per-cpu cache
> of memcg or because of task-migration between memcg, it hits limit before
> having any pages on LRU.....I think there is possible corner cases which
> can cause hang.
>
> ok, will add comment.

Ok, thanks. Otherwise it looks good.

Acked-by: Ying Han <yinghan@google.com>

--Ying

--Ying
>
> Thanks,
> -Kame
>
>
>
>
>
>
>
