Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578Ab2DLRPj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 13:15:39 -0400
Received: from mx2.parallels.com ([64.131.90.16]:42853 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752715Ab2DLRPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 13:15:38 -0400
Message-ID: <4F870D4D.6020405@parallels.com>
Date: Thu, 12 Apr 2012 14:13:49 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Johannes Weiner <hannes@cmpxchg.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Walsh <dwalsh@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [RFD] Merge task counter into memcg
References: <20120411185715.GA4317@somewhere.redhat.com> <4F862851.3040208@jp.fujitsu.com> <20120412113217.GB11455@somewhere.redhat.com> <4F86BFC6.2050400@parallels.com> <20120412123256.GI1787@cmpxchg.org> <4F86D4BD.1040305@parallels.com> <20120412153055.GL1787@cmpxchg.org> <20120412163825.GB13069@google.com>
In-Reply-To: <20120412163825.GB13069@google.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [201.82.19.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> The reason why I asked Frederic whether it would make more sense as
> part of memcg wasn't about flexibility but mostly about the type of
> the resource.  I'll continue below.
>
>>> Agree. Even people aiming for unified hierarchies are okay with an
>>> opt-in/out system, I believe. So the controllers need not to be
>>> active at all times. One way of doing this is what I suggested to
>>> Frederic: If you don't limit, don't account.
>>
>> I don't agree, it's a valid usecase to monitor a workload without
>> limiting it in any way.  I do it all the time.
>
> AFAICS, this seems to be the most valid use case for different
> controllers seeing different part of the hierarchy, even if the
> hierarchies aren't completely separate.  Accounting and control being
> in separate controllers is pretty sucky too as it ends up accounting
> things multiple times.  Maybe all controllers should learn how to do
> accounting w/o applying limits?  Not sure yet.

Well...

* I don't know how blkcgrp applies limits
* the cpu cgroup, is limiting by nature, in the sense that it divides 
shares in proportion to the number of cgroups in a hierarchy
* memcg has a RESOURCE_MAX default limit that is bigger than anything 
you can possibly count.

So one of the problems, is that "limiting" may mean different thing to 
each controller.

I am mostly talking about memory cgroup here. And there. "Accounting 
without limiting" can trivially be done by setting limit to 
RESOURCE_MAX-delta. This won't work when we start having machines with 
2^64 physical memory, but I guess we have some time until it happens.

The way I see, it's just a technicality over a way to runtime disable 
the accounting of a resource without filling the hierarchy with flags.


>> To reraise a point from my other email that was ignored: do users
>> actually really care about the number of tasks when they want to
>> prevent forkbombs?  If a task would use neither CPU nor memory, you
>> would not be interested in limiting the number of tasks.
>>
>> Because the number of tasks is not a resource.  CPU and memory are.
>>
>> So again, if we would include the memory impact of tasks properly
>> (structures, kernel stack pages) in the kernel memory counters which
>> we allow to limit, shouldn't this solve our problem?
>
> The task counter is trying to control the *number* of tasks, which is
> purely memory overhead.

No, it is not. As we talk, it is becoming increasingly clear that given 
the use case, the correct term is "translating task *back* into the 
actual amount of memory".

> Translating #tasks into the actual amount of
> memory isn't too trivial tho - the task stack isn't the only
> allocation and the numbers should somehow make sense to the userland
> in consistent way.  Also, I'm not sure whether this particular limit
> should live in its silo or should be summed up together as part of
> kmem (kmem itself is in its own silo after all apart from user memory,
> right?).


It is accounted together, but limited separately. Setting 
memory.kmem.limit > memory.limit is a trivial way to say "Don't limit 
kmem". (and yet account it)

Same thing would go for a stack limit (Well, assuming it won't be merged 
into kmem itself as well)

> So, if those can be settled, I think protecting against fork
> bombs could fit memcg better in the sense that the whole thing makes
> more sense.

I myself will advise against merging anything not byte-based to memcg.
"task counter" is not byte-based.
"fork bomb preventer" might be.
