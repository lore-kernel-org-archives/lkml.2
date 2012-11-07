Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762Ab2KGHFX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 02:05:23 -0500
Received: from mx2.parallels.com ([64.131.90.16]:49447 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141Ab2KGHFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 02:05:22 -0500
Message-ID: <509A0826.1030708@parallels.com>
Date: Wed, 7 Nov 2012 08:05:10 +0100
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
Subject: Re: [PATCH v6 18/29] Allocate memory for memcg caches whenever a
 new memcg appears
References: <1351771665-11076-1-git-send-email-glommer@parallels.com> <1351771665-11076-19-git-send-email-glommer@parallels.com> <20121105162330.4aa629f8.akpm@linux-foundation.org>
In-Reply-To: <20121105162330.4aa629f8.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [88.2.50.55]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2012 01:23 AM, Andrew Morton wrote:
> On Thu,  1 Nov 2012 16:07:34 +0400
> Glauber Costa <glommer@parallels.com> wrote:
> 
>> Every cache that is considered a root cache (basically the "original" caches,
>> tied to the root memcg/no-memcg) will have an array that should be large enough
>> to store a cache pointer per each memcg in the system.
>>
>> Theoreticaly, this is as high as 1 << sizeof(css_id), which is currently in the
>> 64k pointers range. Most of the time, we won't be using that much.
>>
>> What goes in this patch, is a simple scheme to dynamically allocate such an
>> array, in order to minimize memory usage for memcg caches. Because we would
>> also like to avoid allocations all the time, at least for now, the array will
>> only grow. It will tend to be big enough to hold the maximum number of
>> kmem-limited memcgs ever achieved.
>>
>> We'll allocate it to be a minimum of 64 kmem-limited memcgs. When we have more
>> than that, we'll start doubling the size of this array every time the limit is
>> reached.
>>
>> Because we are only considering kmem limited memcgs, a natural point for this
>> to happen is when we write to the limit. At that point, we already have
>> set_limit_mutex held, so that will become our natural synchronization
>> mechanism.
>>
>> ...
>>
>> +static struct ida kmem_limited_groups;
> 
> Could use DEFINE_IDA() here
> 
>>
>> ...
>>
>>  static int memcg_init_kmem(struct mem_cgroup *memcg, struct cgroup_subsys *ss)
>>  {
>> +	int ret;
>> +
>>  	memcg->kmemcg_id = -1;
>> -	memcg_propagate_kmem(memcg);
>> +	ret = memcg_propagate_kmem(memcg);
>> +	if (ret)
>> +		return ret;
>> +
>> +	if (mem_cgroup_is_root(memcg))
>> +		ida_init(&kmem_limited_groups);
> 
> and zap this?
> 

Ok.

I am starting to go over your replies now, and general question:
Since you have already included this in mm, would you like me to
resubmit the series changing things according to your feedback, or
should I send incremental patches?


