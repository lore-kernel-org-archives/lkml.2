Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084Ab2IUIp3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 04:45:29 -0400
Received: from mx2.parallels.com ([64.131.90.16]:60888 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756772Ab2IUIp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 04:45:26 -0400
Message-ID: <505C2856.70900@parallels.com>
Date: Fri, 21 Sep 2012 12:41:58 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: JoonSoo Kim <js1304@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, <devel@openvz.org>,
        Tejun Heo <tj@kernel.org>, <linux-mm@kvack.org>,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 06/13] memcg: kmem controller infrastructure
References: <1347977050-29476-1-git-send-email-glommer@parallels.com> <1347977050-29476-7-git-send-email-glommer@parallels.com> <CAAmzW4ONnc7n3kZbYnE6n2Cg0ZyPXW0QU2NMr0uRkyTxnGpNqQ@mail.gmail.com>
In-Reply-To: <CAAmzW4ONnc7n3kZbYnE6n2Cg0ZyPXW0QU2NMr0uRkyTxnGpNqQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2012 08:05 PM, JoonSoo Kim wrote:
> Hi, Glauber.
> 
> 2012/9/18 Glauber Costa <glommer@parallels.com>:
>> +/*
>> + * We need to verify if the allocation against current->mm->owner's memcg is
>> + * possible for the given order. But the page is not allocated yet, so we'll
>> + * need a further commit step to do the final arrangements.
>> + *
>> + * It is possible for the task to switch cgroups in this mean time, so at
>> + * commit time, we can't rely on task conversion any longer.  We'll then use
>> + * the handle argument to return to the caller which cgroup we should commit
>> + * against. We could also return the memcg directly and avoid the pointer
>> + * passing, but a boolean return value gives better semantics considering
>> + * the compiled-out case as well.
>> + *
>> + * Returning true means the allocation is possible.
>> + */
>> +bool
>> +__memcg_kmem_newpage_charge(gfp_t gfp, struct mem_cgroup **_memcg, int order)
>> +{
>> +       struct mem_cgroup *memcg;
>> +       bool ret;
>> +       struct task_struct *p;
>> +
>> +       *_memcg = NULL;
>> +       rcu_read_lock();
>> +       p = rcu_dereference(current->mm->owner);
>> +       memcg = mem_cgroup_from_task(p);
>> +       rcu_read_unlock();
>> +
>> +       if (!memcg_can_account_kmem(memcg))
>> +               return true;
>> +
>> +       mem_cgroup_get(memcg);
>> +
>> +       ret = memcg_charge_kmem(memcg, gfp, PAGE_SIZE << order) == 0;
>> +       if (ret)
>> +               *_memcg = memcg;
>> +       else
>> +               mem_cgroup_put(memcg);
>> +
>> +       return ret;
>> +}
> 
> "*_memcg = memcg" should be executed when "memcg_charge_kmem" is success.
> "memcg_charge_kmem" return 0 if success in charging.
> Therefore, I think this code is wrong.
> If I am right, it is a serious bug that affect behavior of all the patchset.

Which is precisely what it does. ret is a boolean, that will be true
when charge succeeded (== 0 test)

> 
>> +void __memcg_kmem_commit_charge(struct page *page, struct mem_cgroup *memcg,
>> +                             int order)
>> +{
>> +       struct page_cgroup *pc;
>> +
>> +       WARN_ON(mem_cgroup_is_root(memcg));
>> +
>> +       /* The page allocation failed. Revert */
>> +       if (!page) {
>> +               memcg_uncharge_kmem(memcg, PAGE_SIZE << order);
>> +               return;
>> +       }
> 
> In case of "!page ", mem_cgroup_put(memcg) is needed,
> because we already call "mem_cgroup_get(memcg)" in
> __memcg_kmem_newpage_charge().
> I know that mem_cgroup_put()/get() will be removed in later patch, but
> it is important that every patch works fine.

Okay, I'll add the put here. It is indeed missing.


