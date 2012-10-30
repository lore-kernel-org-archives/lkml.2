Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932950Ab2J3LcN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 07:32:13 -0400
Received: from mx2.parallels.com ([64.131.90.16]:53336 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555Ab2J3LcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 07:32:10 -0400
Message-ID: <508FBA99.3010009@parallels.com>
Date: Tue, 30 Oct 2012 15:31:37 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: JoonSoo Kim <js1304@gmail.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <cgroups@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, Christoph Lameter <cl@linux.com>,
        "David Rientjes" <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, <devel@openvz.org>,
        Suleiman Souhlal <suleiman@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v5 13/18] memcg/sl[au]b Track all the memcg children of
 a kmem_cache.
References: <1350656442-1523-1-git-send-email-glommer@parallels.com> <1350656442-1523-14-git-send-email-glommer@parallels.com> <CAAmzW4MGdj-jL_FJ2Nkoa4Hx8KUDCeVK6HFidYQLauu_0vHhCg@mail.gmail.com>
In-Reply-To: <CAAmzW4MGdj-jL_FJ2Nkoa4Hx8KUDCeVK6HFidYQLauu_0vHhCg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2012 07:26 PM, JoonSoo Kim wrote:
> 2012/10/19 Glauber Costa <glommer@parallels.com>:
>> +void kmem_cache_destroy_memcg_children(struct kmem_cache *s)
>> +{
>> +       struct kmem_cache *c;
>> +       int i;
>> +
>> +       if (!s->memcg_params)
>> +               return;
>> +       if (!s->memcg_params->is_root_cache)
>> +               return;
>> +
>> +       /*
>> +        * If the cache is being destroyed, we trust that there is no one else
>> +        * requesting objects from it. Even if there are, the sanity checks in
>> +        * kmem_cache_destroy should caught this ill-case.
>> +        *
>> +        * Still, we don't want anyone else freeing memcg_caches under our
>> +        * noses, which can happen if a new memcg comes to life. As usual,
>> +        * we'll take the set_limit_mutex to protect ourselves against this.
>> +        */
>> +       mutex_lock(&set_limit_mutex);
>> +       for (i = 0; i < memcg_limited_groups_array_size; i++) {
>> +               c = s->memcg_params->memcg_caches[i];
>> +               if (c)
>> +                       kmem_cache_destroy(c);
>> +       }
>> +       mutex_unlock(&set_limit_mutex);
>> +}
> 
> It may cause NULL deref.
> Look at the following scenario.
> 
> 1. some memcg slab caches has remained object.
> 2. start to destroy memcg.
> 3. schedule_delayed_work(kmem_cache_destroy_work_func, @delay 60hz)
> 4. all remained object is freed.
> 5. start to destroy root cache.
> 6. kmem_cache_destroy makes 's->memcg_params->memcg_caches[i]" NULL!!
> 7. Start delayed work function.
> 8. cachep in kmem_cache_destroy_work_func() may be NULL
> 
> Thanks.
> 
Thanks for spotting. This is the same problem we have in
memcg_cache_destroy(),
which I solved by not respawning the worker.

In here, I believe it should be possible to just cancel all remaining
pending work, since we are now in the process of deleting the caches
ourselves.



