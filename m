Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998Ab0HFEhy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 00:37:54 -0400
Received: from smtp-out.google.com ([216.239.44.51]:4548 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab0HFEhv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 00:37:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding:x-system-of-record;
	b=k3eH0lNZnVWcT2VkJDz7svOv9D1Tk90QOeYmFN68vrnlo41s1Nq7VWX91Ms3pFIAy
	zWwJj2HMsrK4SMo0Z3oEg==
MIME-Version: 1.0
In-Reply-To: <20100806131053.411dce6d.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100805184434.3a29c0f9.kamezawa.hiroyu@jp.fujitsu.com> 
	<20100805185713.4d09339e.kamezawa.hiroyu@jp.fujitsu.com> <xr93zkx0z8e5.fsf@ninji.mtv.corp.google.com> 
	<20100806131053.411dce6d.kamezawa.hiroyu@jp.fujitsu.com>
From: Greg Thelen <gthelen@google.com>
Date: Thu, 5 Aug 2010 21:37:29 -0700
Message-ID: <AANLkTikyGEE+z4yMZp8jEqEXd1V1aEeKBhyfU=baeq7=@mail.gmail.com>
Subject: Re: [PATCH 1/4 -mm][memcg] quick ID lookup in memcg
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        vgoyal@redhat.com, m-ikeda@ds.jp.nec.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 5, 2010 at 9:10 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Thu, 05 Aug 2010 21:12:50 -0700
> Greg Thelen <gthelen@google.com> wrote:
>
>> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:
>>
>> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> >
>> > Now, memory cgroup has an ID per cgroup and make use of it at
>> >  - hierarchy walk,
>> >  - swap recording.
>> >
>> > This patch is for making more use of it. The final purpose is
>> > to replace page_cgroup->mem_cgroup's pointer to an unsigned short.
>> >
>> > This patch caches a pointer of memcg in an array. By this, we
>> > don't have to call css_lookup() which requires radix-hash walk.
>> > This saves some amount of memory footprint at lookup memcg via id.
>> >
>> > Changelog: 20100804
>> >  - fixed description in init/Kconfig
>> >
>> > Changelog: 20100730
>> >  - fixed rcu_read_unlock() placement.
>> >
>> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> > ---
>> >  init/Kconfig    |   10 ++++++++++
>> >  mm/memcontrol.c |   48 ++++++++++++++++++++++++++++++++++--------------
>> >  2 files changed, 44 insertions(+), 14 deletions(-)
>> >
>> > Index: mmotm-0727/mm/memcontrol.c
>> > ===================================================================
>> > --- mmotm-0727.orig/mm/memcontrol.c
>> > +++ mmotm-0727/mm/memcontrol.c
>> > @@ -292,6 +292,30 @@ static bool move_file(void)
>> >                                     &mc.to->move_charge_at_immigrate);
>> >  }
>> >
>> > +/* 0 is unused */
>> > +static atomic_t mem_cgroup_num;
>> > +#define NR_MEMCG_GROUPS (CONFIG_MEM_CGROUP_MAX_GROUPS + 1)
>> > +static struct mem_cgroup *mem_cgroups[NR_MEMCG_GROUPS] __read_mostly;
>> > +
>> > +static struct mem_cgroup *id_to_memcg(unsigned short id)
>> > +{
>> > +   /*
>> > +    * This array is set to NULL when mem_cgroup is freed.
>> > +    * IOW, there are no more references && rcu_synchronized().
>> > +    * This lookup-caching is safe.
>> > +    */
>> > +   if (unlikely(!mem_cgroups[id])) {
>> > +           struct cgroup_subsys_state *css;
>> > +
>> > +           rcu_read_lock();
>> > +           css = css_lookup(&mem_cgroup_subsys, id);
>> > +           rcu_read_unlock();
>> > +           if (!css)
>> > +                   return NULL;
>> > +           mem_cgroups[id] = container_of(css, struct mem_cgroup, css);
>> > +   }
>> > +   return mem_cgroups[id];
>> > +}
>>
>> I am worried that id may be larger than CONFIG_MEM_CGROUP_MAX_GROUPS and
>> cause an illegal array index.  I see that
>> mem_cgroup_uncharge_swapcache() uses css_id() to compute 'id'.
>> mem_cgroup_num ensures that there are never more than
>> CONFIG_MEM_CGROUP_MAX_GROUPS memcg active.  But do we have guarantee
>> that the that all of the css_id of each active memcg are less than
>> NR_MEMCG_GROUPS?
>>
> Yes. kernel/cgroup.c's ID assign routine use the smallest number, always.
>
>
>
>> >  /*
>> >   * Maximum loops in mem_cgroup_hierarchical_reclaim(), used for soft
>> >   * limit reclaim to prevent infinite loops, if they ever occur.
>> > @@ -1824,18 +1848,7 @@ static void mem_cgroup_cancel_charge(str
>> >   * it's concern. (dropping refcnt from swap can be called against removed
>> >   * memcg.)
>> >   */
>> > -static struct mem_cgroup *mem_cgroup_lookup(unsigned short id)
>> > -{
>> > -   struct cgroup_subsys_state *css;
>> >
>> > -   /* ID 0 is unused ID */
>> > -   if (!id)
>> > -           return NULL;
>> > -   css = css_lookup(&mem_cgroup_subsys, id);
>> > -   if (!css)
>> > -           return NULL;
>> > -   return container_of(css, struct mem_cgroup, css);
>> > -}
>> >
>> >  struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page)
>> >  {
>> > @@ -1856,7 +1869,7 @@ struct mem_cgroup *try_get_mem_cgroup_fr
>> >             ent.val = page_private(page);
>> >             id = lookup_swap_cgroup(ent);
>> >             rcu_read_lock();
>> > -           mem = mem_cgroup_lookup(id);
>> > +           mem = id_to_memcg(id);
>> >             if (mem && !css_tryget(&mem->css))
>> >                     mem = NULL;
>> >             rcu_read_unlock();
>> > @@ -2208,7 +2221,7 @@ __mem_cgroup_commit_charge_swapin(struct
>> >
>> >             id = swap_cgroup_record(ent, 0);
>> >             rcu_read_lock();
>> > -           memcg = mem_cgroup_lookup(id);
>> > +           memcg = id_to_memcg(id);
>> >             if (memcg) {
>> >                     /*
>> >                      * This recorded memcg can be obsolete one. So, avoid
>> > @@ -2472,7 +2485,7 @@ void mem_cgroup_uncharge_swap(swp_entry_
>> >
>> >     id = swap_cgroup_record(ent, 0);
>> >     rcu_read_lock();
>> > -   memcg = mem_cgroup_lookup(id);
>> > +   memcg = id_to_memcg(id);
>> >     if (memcg) {
>> >             /*
>> >              * We uncharge this because swap is freed.
>> > @@ -3988,6 +4001,9 @@ static struct mem_cgroup *mem_cgroup_all
>> >     struct mem_cgroup *mem;
>> >     int size = sizeof(struct mem_cgroup);
>> >
>> > +   if (atomic_read(&mem_cgroup_num) == NR_MEMCG_GROUPS)
>> > +           return NULL;
>> > +
>>
>> I think that multiple tasks to be simultaneously running
>> mem_cgroup_create().  Therefore more than NR_MEMCG_GROUPS memcg may be
>> created.
>>
>
> No. cgroup_mutex() is held.
>
> Thanks,
> -Kame
>
>

I see that now.  Thank you clarification.  I am doing some testing on
the patches now.
