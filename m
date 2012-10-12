Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933218Ab2JLHsI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 03:48:08 -0400
Received: from mx2.parallels.com ([64.131.90.16]:60676 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932482Ab2JLHsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 03:48:05 -0400
Message-ID: <5077CB29.2000505@parallels.com>
Date: Fri, 12 Oct 2012 11:47:53 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Suleiman Souhlal <suleiman@google.com>,
        Tejun Heo <tj@kernel.org>, <cgroups@vger.kernel.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Greg Thelen <gthelen@google.com>, <devel@openvz.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v4 10/14] memcg: use static branches when code not in
 use
References: <1349690780-15988-1-git-send-email-glommer@parallels.com> <1349690780-15988-11-git-send-email-glommer@parallels.com> <20121011134028.GH29295@dhcp22.suse.cz>
In-Reply-To: <20121011134028.GH29295@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2012 05:40 PM, Michal Hocko wrote:
> On Mon 08-10-12 14:06:16, Glauber Costa wrote:
>> We can use static branches to patch the code in or out when not used.
>>
>> Because the _ACTIVE bit on kmem_accounted is only set after the
>> increment is done, we guarantee that the root memcg will always be
>> selected for kmem charges until all call sites are patched (see
>> memcg_kmem_enabled).  This guarantees that no mischarges are applied.
>>
>> static branch decrement happens when the last reference count from the
>> kmem accounting in memcg dies. This will only happen when the charges
>> drop down to 0.
>>
>> When that happen, we need to disable the static branch only on those
>> memcgs that enabled it. To achieve this, we would be forced to
>> complicate the code by keeping track of which memcgs were the ones
>> that actually enabled limits, and which ones got it from its parents.
>>
>> It is a lot simpler just to do static_key_slow_inc() on every child
>> that is accounted.
>>
>> [ v4: adapted this patch to the changes in kmem_accounted ]
>>
>> Signed-off-by: Glauber Costa <glommer@parallels.com>
>> CC: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> CC: Christoph Lameter <cl@linux.com>
>> CC: Pekka Enberg <penberg@cs.helsinki.fi>
>> CC: Michal Hocko <mhocko@suse.cz>
>> CC: Johannes Weiner <hannes@cmpxchg.org>
>> CC: Suleiman Souhlal <suleiman@google.com>
> 
> Looks reasonable to me
> Acked-by: Michal Hocko <mhocko@suse.cz>
> 
> Just a little nit.
> 
> [...]
> 
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 634c7b5..724a08b 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -344,11 +344,15 @@ struct mem_cgroup {
>>  /* internal only representation about the status of kmem accounting. */
>>  enum {
>>  	KMEM_ACCOUNTED_ACTIVE = 0, /* accounted by this cgroup itself */
>> +	KMEM_ACCOUNTED_ACTIVATED, /* static key enabled. */
>>  	KMEM_ACCOUNTED_DEAD, /* dead memcg, pending kmem charges */
>>  };
>>  
>> -/* first bit */
>> -#define KMEM_ACCOUNTED_MASK 0x1
>> +/*
>> + * first two bits. We account when limit is on, but only after
>> + * call sites are patched
>> + */
>> +#define KMEM_ACCOUNTED_MASK 0x3
> 
> The names are long but why not use KMEM_ACCOUNTED_ACTIVE*
> #define KMEM_ACCOUNTED_MASK 1<<KMEM_ACCOUNTED_ACTIVE | 1<<KMEM_ACCOUNTED_ACTIVATED
> 
Because the names are long! =)

