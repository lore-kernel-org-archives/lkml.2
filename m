Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932320Ab2DYB6P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 21:58:15 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36128 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757928Ab2DYB6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 21:58:12 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4F9759C0.1070805@jp.fujitsu.com>
Date: Wed, 25 Apr 2012 10:56:16 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: David Rientjes <rientjes@google.com>,
        Glauber Costa <glommer@parallels.com>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, devel@openvz.org,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 17/23] kmem controller charge/uncharge infrastructure
References: <1334959051-18203-1-git-send-email-glommer@parallels.com> <1335138820-26590-6-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1204231522320.13535@chino.kir.corp.google.com> <20120424142232.GC8626@somewhere>
In-Reply-To: <20120424142232.GC8626@somewhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/04/24 23:22), Frederic Weisbecker wrote:

> On Mon, Apr 23, 2012 at 03:25:59PM -0700, David Rientjes wrote:
>> On Sun, 22 Apr 2012, Glauber Costa wrote:
>>
>>> +/*
>>> + * Return the kmem_cache we're supposed to use for a slab allocation.
>>> + * If we are in interrupt context or otherwise have an allocation that
>>> + * can't fail, we return the original cache.
>>> + * Otherwise, we will try to use the current memcg's version of the cache.
>>> + *
>>> + * If the cache does not exist yet, if we are the first user of it,
>>> + * we either create it immediately, if possible, or create it asynchronously
>>> + * in a workqueue.
>>> + * In the latter case, we will let the current allocation go through with
>>> + * the original cache.
>>> + *
>>> + * This function returns with rcu_read_lock() held.
>>> + */
>>> +struct kmem_cache *__mem_cgroup_get_kmem_cache(struct kmem_cache *cachep,
>>> +					     gfp_t gfp)
>>> +{
>>> +	struct mem_cgroup *memcg;
>>> +	int idx;
>>> +
>>> +	gfp |=  cachep->allocflags;
>>> +
>>> +	if ((current->mm == NULL))
>>> +		return cachep;
>>> +
>>> +	if (cachep->memcg_params.memcg)
>>> +		return cachep;
>>> +
>>> +	idx = cachep->memcg_params.id;
>>> +	VM_BUG_ON(idx == -1);
>>> +
>>> +	memcg = mem_cgroup_from_task(current);
>>> +	if (!mem_cgroup_kmem_enabled(memcg))
>>> +		return cachep;
>>> +
>>> +	if (rcu_access_pointer(memcg->slabs[idx]) == NULL) {
>>> +		memcg_create_cache_enqueue(memcg, cachep);
>>> +		return cachep;
>>> +	}
>>> +
>>> +	return rcu_dereference(memcg->slabs[idx]);
>>> +}
>>> +EXPORT_SYMBOL(__mem_cgroup_get_kmem_cache);
>>> +
>>> +void mem_cgroup_remove_child_kmem_cache(struct kmem_cache *cachep, int id)
>>> +{
>>> +	rcu_assign_pointer(cachep->memcg_params.memcg->slabs[id], NULL);
>>> +}
>>> +
>>> +bool __mem_cgroup_charge_kmem(gfp_t gfp, size_t size)
>>> +{
>>> +	struct mem_cgroup *memcg;
>>> +	bool ret = true;
>>> +
>>> +	rcu_read_lock();
>>> +	memcg = mem_cgroup_from_task(current);
>>
>> This seems horribly inconsistent with memcg charging of user memory since 
>> it charges to p->mm->owner and you're charging to p.  So a thread attached 
>> to a memcg can charge user memory to one memcg while charging slab to 
>> another memcg?
> 
> Charging to the thread rather than the process seem to me the right behaviour:
> you can have two threads of a same process attached to different cgroups.
> 
> Perhaps it is the user memory memcg that needs to be fixed?
> 

There is a problem of OOM-Kill.
To free memory by killing process, 'mm' should be released by kill.
So, oom-killer just finds a leader of process.

Assume A process X consists of thread A, B and A is thread-group-leader.

Put thread A into cgroup/Gold
    thread B into cgroup/Silver.

If we do accounting based on threads, we can't do anything at OOM in cgroup/Silver.
An idea 'Killing thread-A to kill thread-B'..... breaks isolation.
 
As far as resources used by process, I think accounting should be done per process.
It's not tied to thread.

About kmem, if we count task_struct, page tables, etc...which can be freed by
OOM-Killer i.e. it's allocated for 'process', should be aware of OOM problem.
Using mm->owner makes sense to me until someone finds a great idea to handle
OOM situation rather than task killing.

Thanks,
-Kame

