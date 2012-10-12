Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933029Ab2JLHrb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 03:47:31 -0400
Received: from mx2.parallels.com ([64.131.90.16]:60601 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932482Ab2JLHra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 03:47:30 -0400
Message-ID: <5077CB05.907@parallels.com>
Date: Fri, 12 Oct 2012 11:47:17 +0400
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
Subject: Re: [PATCH v4 09/14] memcg: kmem accounting lifecycle management
References: <1349690780-15988-1-git-send-email-glommer@parallels.com> <1349690780-15988-10-git-send-email-glommer@parallels.com> <20121011131143.GF29295@dhcp22.suse.cz>
In-Reply-To: <20121011131143.GF29295@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2012 05:11 PM, Michal Hocko wrote:
> On Mon 08-10-12 14:06:15, Glauber Costa wrote:
>> Because kmem charges can outlive the cgroup, we need to make sure that
>> we won't free the memcg structure while charges are still in flight.
>> For reviewing simplicity, the charge functions will issue
>> mem_cgroup_get() at every charge, and mem_cgroup_put() at every
>> uncharge.
>>
>> This can get expensive, however, and we can do better. mem_cgroup_get()
>> only really needs to be issued once: when the first limit is set. In the
>> same spirit, we only need to issue mem_cgroup_put() when the last charge
>> is gone.
>>
>> We'll need an extra bit in kmem_accounted for that: KMEM_ACCOUNTED_DEAD.
>> it will be set when the cgroup dies, if there are charges in the group.
>> If there aren't, we can proceed right away.
>>
>> Our uncharge function will have to test that bit every time the charges
>> drop to 0. Because that is not the likely output of
>> res_counter_uncharge, this should not impose a big hit on us: it is
>> certainly much better than a reference count decrease at every
>> operation.
>>
>> [ v3: merged all lifecycle related patches in one ]
>>
>> Signed-off-by: Glauber Costa <glommer@parallels.com>
>> CC: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> CC: Christoph Lameter <cl@linux.com>
>> CC: Pekka Enberg <penberg@cs.helsinki.fi>
>> CC: Michal Hocko <mhocko@suse.cz>
>> CC: Johannes Weiner <hannes@cmpxchg.org>
>> CC: Suleiman Souhlal <suleiman@google.com>
> 
> OK, I like the optimization. I have just one comment to the
> memcg_kmem_dead naming but other than that
> 
> Acked-by: Michal Hocko <mhocko@suse.cz>
> 
> [...]
>> +static bool memcg_kmem_dead(struct mem_cgroup *memcg)
> 
> The name is tricky because it doesn't tell you that it clears the flag
> which made me scratch my head when reading comment in kmem_cgroup_destroy
> 
memcg_kmem_finally_kill_that_bastard() ?

