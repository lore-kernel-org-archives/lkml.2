Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab2JPItD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 04:49:03 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60606 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244Ab2JPItA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 04:49:00 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <507D1F5D.8080709@jp.fujitsu.com>
Date: Tue, 16 Oct 2012 17:48:29 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Glauber Costa <glommer@parallels.com>
CC: Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Suleiman Souhlal <suleiman@google.com>,
        Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>, Greg Thelen <gthelen@google.com>,
        devel@openvz.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v4 10/14] memcg: use static branches when code not in
 use
References: <1349690780-15988-1-git-send-email-glommer@parallels.com> <1349690780-15988-11-git-send-email-glommer@parallels.com> <20121011134028.GH29295@dhcp22.suse.cz> <5077CB29.2000505@parallels.com>
In-Reply-To: <5077CB29.2000505@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/10/12 16:47), Glauber Costa wrote:
> On 10/11/2012 05:40 PM, Michal Hocko wrote:
>> On Mon 08-10-12 14:06:16, Glauber Costa wrote:
>>> We can use static branches to patch the code in or out when not used.
>>>
>>> Because the _ACTIVE bit on kmem_accounted is only set after the
>>> increment is done, we guarantee that the root memcg will always be
>>> selected for kmem charges until all call sites are patched (see
>>> memcg_kmem_enabled).  This guarantees that no mischarges are applied.
>>>
>>> static branch decrement happens when the last reference count from the
>>> kmem accounting in memcg dies. This will only happen when the charges
>>> drop down to 0.
>>>
>>> When that happen, we need to disable the static branch only on those
>>> memcgs that enabled it. To achieve this, we would be forced to
>>> complicate the code by keeping track of which memcgs were the ones
>>> that actually enabled limits, and which ones got it from its parents.
>>>
>>> It is a lot simpler just to do static_key_slow_inc() on every child
>>> that is accounted.
>>>
>>> [ v4: adapted this patch to the changes in kmem_accounted ]
>>>
>>> Signed-off-by: Glauber Costa <glommer@parallels.com>
>>> CC: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>>> CC: Christoph Lameter <cl@linux.com>
>>> CC: Pekka Enberg <penberg@cs.helsinki.fi>
>>> CC: Michal Hocko <mhocko@suse.cz>
>>> CC: Johannes Weiner <hannes@cmpxchg.org>
>>> CC: Suleiman Souhlal <suleiman@google.com>
>>
>> Looks reasonable to me
>> Acked-by: Michal Hocko <mhocko@suse.cz>
>>
>> Just a little nit.
>>
>> [...]
>>
>>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>>> index 634c7b5..724a08b 100644
>>> --- a/mm/memcontrol.c
>>> +++ b/mm/memcontrol.c
>>> @@ -344,11 +344,15 @@ struct mem_cgroup {
>>>   /* internal only representation about the status of kmem accounting. */
>>>   enum {
>>>   	KMEM_ACCOUNTED_ACTIVE = 0, /* accounted by this cgroup itself */
>>> +	KMEM_ACCOUNTED_ACTIVATED, /* static key enabled. */
>>>   	KMEM_ACCOUNTED_DEAD, /* dead memcg, pending kmem charges */
>>>   };
>>>
>>> -/* first bit */
>>> -#define KMEM_ACCOUNTED_MASK 0x1
>>> +/*
>>> + * first two bits. We account when limit is on, but only after
>>> + * call sites are patched
>>> + */
>>> +#define KMEM_ACCOUNTED_MASK 0x3
>>
>> The names are long but why not use KMEM_ACCOUNTED_ACTIVE*
>> #define KMEM_ACCOUNTED_MASK 1<<KMEM_ACCOUNTED_ACTIVE | 1<<KMEM_ACCOUNTED_ACTIVATED
>>
> Because the names are long! =)
>

please use "long" macros ;) it's not bad.

Anyway,

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>







