Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050Ab2FSIhm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 04:37:42 -0400
Received: from mx2.parallels.com ([64.131.90.16]:52830 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753624Ab2FSIhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 04:37:38 -0400
Message-ID: <4FE039B9.3080809@parallels.com>
Date: Tue, 19 Jun 2012 12:35:05 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: <linux-mm@kvack.org>, Pekka Enberg <penberg@kernel.org>,
        Cristoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        <cgroups@vger.kernel.org>, <devel@openvz.org>,
        <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Suleiman Souhlal <suleiman@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v4 23/25] memcg: propagate kmem limiting information to
 children
References: <1340015298-14133-1-git-send-email-glommer@parallels.com> <1340015298-14133-24-git-send-email-glommer@parallels.com> <4FDF20ED.4090401@jp.fujitsu.com> <4FDF227B.3080601@parallels.com> <4FDFC4D4.1030303@jp.fujitsu.com>
In-Reply-To: <4FDFC4D4.1030303@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2012 04:16 AM, Kamezawa Hiroyuki wrote:
> (2012/06/18 21:43), Glauber Costa wrote:
>> On 06/18/2012 04:37 PM, Kamezawa Hiroyuki wrote:
>>> (2012/06/18 19:28), Glauber Costa wrote:
>>>> The current memcg slab cache management fails to present satisfatory hierarchical
>>>> behavior in the following scenario:
>>>>
>>>> ->   /cgroups/memory/A/B/C
>>>>
>>>> * kmem limit set at A
>>>> * A and B empty taskwise
>>>> * bash in C does find /
>>>>
>>>> Because kmem_accounted is a boolean that was not set for C, no accounting
>>>> would be done. This is, however, not what we expect.
>>>>
>>>
>>> Hmm....do we need this new routines even while we have mem_cgroup_iter() ?
>>>
>>> Doesn't this work ?
>>>
>>> 	struct mem_cgroup {
>>> 		.....
>>> 		bool kmem_accounted_this;
>>> 		atomic_t kmem_accounted;
>>> 		....
>>> 	}
>>>
>>> at set limit
>>>
>>> 	....set_limit(memcg) {
>>>
>>> 		if (newly accounted) {
>>> 			mem_cgroup_iter() {
>>> 				atomic_inc(&iter->kmem_accounted)
>>> 			}
>>> 		} else {
>>> 			mem_cgroup_iter() {
>>> 				atomic_dec(&iter->kmem_accounted);
>>> 			}
>>> 	}
>>>
>>>
>>> hm ? Then, you can see kmem is accounted or not by atomic_read(&memcg->kmem_accounted);
>>>
>>
>> Accounted by itself / parent is still useful, and I see no reason to use
>> an atomic + bool if we can use a pair of bits.
>>
>> As for the routine, I guess mem_cgroup_iter will work... It does a lot
>> more than I need, but for the sake of using what's already in there, I
>> can switch to it with no problems.
>>
> 
> Hmm. please start from reusing existing routines.
> If it's not enough, some enhancement for generic cgroup  will be welcomed
> rather than completely new one only for memcg.
> 

And now that I am trying to adapt the code to the new function, I
remember clearly why I done this way. Sorry for my failed memory.

That has to do with the order of the walk. I need to enforce hierarchy,
which means whenever a cgroup has !use_hierarchy, I need to cut out that
branch, but continue scanning the tree for other branches.

That is a lot easier to do with depth-search tree walks like the one
proposed in this patch. for_each_mem_cgroup() seems to walk the tree in
css-creation order. Which means we need to keep track of parents that
has hierarchy disabled at all times ( can be many ), and always test for
ancestorship - which is expensive, but I don't particularly care.

But I'll give another shot with this one.
