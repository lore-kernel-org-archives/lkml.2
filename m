Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215Ab2KBHq5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 03:46:57 -0400
Received: from mx2.parallels.com ([64.131.90.16]:45016 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754418Ab2KBHqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 03:46:55 -0400
Message-ID: <50937A62.1060105@parallels.com>
Date: Fri, 2 Nov 2012 11:46:42 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH v6 23/29] memcg: destroy memcg caches
References: <1351771665-11076-1-git-send-email-glommer@parallels.com> <1351771665-11076-24-git-send-email-glommer@parallels.com> <20121101170548.86e0c7e5.akpm@linux-foundation.org>
In-Reply-To: <20121101170548.86e0c7e5.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/2012 04:05 AM, Andrew Morton wrote:
> On Thu,  1 Nov 2012 16:07:39 +0400
> Glauber Costa <glommer@parallels.com> wrote:
> 
>> This patch implements destruction of memcg caches. Right now,
>> only caches where our reference counter is the last remaining are
>> deleted. If there are any other reference counters around, we just
>> leave the caches lying around until they go away.
>>
>> When that happen, a destruction function is called from the cache
>> code. Caches are only destroyed in process context, so we queue them
>> up for later processing in the general case.
>>
>>
>> ...
>>
>> @@ -5950,6 +6012,7 @@ static int mem_cgroup_pre_destroy(struct cgroup *cont)
>>  {
>>  	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
>>  
>> +	mem_cgroup_destroy_all_caches(memcg);
>>  	return mem_cgroup_force_empty(memcg, false);
>>  }
>>  
> 
> Conflicts with linux-next cgroup changes.  Looks pretty simple:
> 
> 
> static int mem_cgroup_pre_destroy(struct cgroup *cont)
> {
> 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
> 	int ret;
> 
> 	css_get(&memcg->css);
> 	ret = mem_cgroup_reparent_charges(memcg);
> 	mem_cgroup_destroy_all_caches(memcg);
> 	css_put(&memcg->css);
> 
> 	return ret;
> }
> 

There is one significant difference between the code I had and the code
after your fix up.

In my patch, caches were destroyed before the call to
mem_cgroup_force_empty. In the final, version, they are destroyed after it.

I am here thinking, but I am not sure if this have any significant
impact... If we run mem_cgroup_destroy_all_caches() before reparenting,
we'll have shrunk a lot of the pending caches, and we will have less
pages to reparent. But we only reparent pages in the lru anyway, and
then expect kmem and remaining umem to match. So *in theory* it should
be fine.

Where can I grab your final tree so I can test it and make sure it is
all good ?


