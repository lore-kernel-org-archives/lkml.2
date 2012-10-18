Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236Ab2JRJmZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 05:42:25 -0400
Received: from mx2.parallels.com ([64.131.90.16]:38350 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755024Ab2JRJmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 05:42:23 -0400
Message-ID: <507FCEF3.2050801@parallels.com>
Date: Thu, 18 Oct 2012 13:42:11 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: <linux-mm@kvack.org>, <cgroups@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        <devel@openvz.org>, <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH v5 09/14] memcg: kmem accounting lifecycle management
References: <1350382611-20579-1-git-send-email-glommer@parallels.com> <1350382611-20579-10-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1210171624540.20813@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1210171624540.20813@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2012 03:28 AM, David Rientjes wrote:
> On Tue, 16 Oct 2012, Glauber Costa wrote:
> 
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 1182188..e24b388 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -344,6 +344,7 @@ struct mem_cgroup {
>>  /* internal only representation about the status of kmem accounting. */
>>  enum {
>>  	KMEM_ACCOUNTED_ACTIVE = 0, /* accounted by this cgroup itself */
>> +	KMEM_ACCOUNTED_DEAD, /* dead memcg, pending kmem charges */
> 
> "dead memcg with pending kmem charges" seems better.
> 
ok.

>>  };
>>  
>>  #define KMEM_ACCOUNTED_MASK (1 << KMEM_ACCOUNTED_ACTIVE)
>> @@ -353,6 +354,22 @@ static void memcg_kmem_set_active(struct mem_cgroup *memcg)
>>  {
>>  	set_bit(KMEM_ACCOUNTED_ACTIVE, &memcg->kmem_accounted);
>>  }
>> +
>> +static bool memcg_kmem_is_active(struct mem_cgroup *memcg)
>> +{
>> +	return test_bit(KMEM_ACCOUNTED_ACTIVE, &memcg->kmem_accounted);
>> +}
> 
> I think all of these should be inline.
> 
They end up being, to be best of my knowledge the compiler can and will
inline such simple functions regardless of their marking, unless you
explicitly mark them noinline.


>> +
>> +static void memcg_kmem_mark_dead(struct mem_cgroup *memcg)
>> +{
>> +	if (test_bit(KMEM_ACCOUNTED_ACTIVE, &memcg->kmem_accounted))
>> +		set_bit(KMEM_ACCOUNTED_DEAD, &memcg->kmem_accounted);
>> +}
> 
> The set_bit() doesn't happen atomically with the test_bit(), what 
> synchronization is required for this?
> 

I believe the explanation Michal gave in answer to this is comprehensive.
