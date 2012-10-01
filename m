Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216Ab2JAIsn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 04:48:43 -0400
Received: from mx2.parallels.com ([64.131.90.16]:60428 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492Ab2JAIsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 04:48:42 -0400
Message-ID: <50695817.2030201@parallels.com>
Date: Mon, 1 Oct 2012 12:45:11 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, <devel@openvz.org>,
        <linux-mm@kvack.org>, Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 04/13] kmem accounting basic infrastructure
References: <50635B9D.8020205@parallels.com> <20120926195648.GA20342@google.com> <50635F46.7000700@parallels.com> <20120926201629.GB20342@google.com> <50637298.2090904@parallels.com> <20120927120806.GA29104@dhcp22.suse.cz> <20120927143300.GA4251@mtj.dyndns.org> <20120927144307.GH3429@suse.de> <20120927145802.GC4251@mtj.dyndns.org> <50649B4C.8000208@parallels.com> <20120930082358.GG10383@mtj.dyndns.org>
In-Reply-To: <20120930082358.GG10383@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2012 12:23 PM, Tejun Heo wrote:
> Hello, Glauber.
> 
> On Thu, Sep 27, 2012 at 10:30:36PM +0400, Glauber Costa wrote:
>>> But that happens only when pages enter and leave slab and if it still
>>> is significant, we can try to further optimize charging.  Given that
>>> this is only for cases where memcg is already in use and we provide a
>>> switch to disable it globally, I really don't think this warrants
>>> implementing fully hierarchy configuration.
>>
>> Not totally true. We still have to match every allocation to the right
>> cache, and that is actually our heaviest hit, responsible for the 2, 3 %
>> we're seeing when this is enabled. It is the kind of path so hot that
>> people frown upon branches being added, so I don't think we'll ever get
>> this close to being free.
> 
> Sure, depening on workload, any addition to alloc/free could be
> noticeable.  I don't know.  I'll write more about it when replying to
> Michal's message.  BTW, __memcg_kmem_get_cache() does seem a bit
> heavy.  I wonder whether indexing from cache side would make it
> cheaper?  e.g. something like the following.
> 
> 	kmem_cache *__memcg_kmem_get_cache(cachep, gfp)
> 	{
> 		struct kmem_cache *c;
> 
> 		c = cachep->memcg_params->caches[percpu_read(kmemcg_slab_idx)];
> 		if (likely(c))
> 			return c;
> 		/* try to create and then fall back to cachep */
> 	}
> 
> where kmemcg_slab_idx is updated from sched notifier (or maybe add and
> use current->kmemcg_slab_idx?).  You would still need __GFP_* and
> in_interrupt() tests but current->mm and PF_KTHREAD tests can be
> rolled into index selection.
> 

How big would this array be? there can be a lot more kmem_caches than
there are memcgs. That is why it is done from memcg side.

