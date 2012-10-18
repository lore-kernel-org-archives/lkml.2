Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107Ab2JRV7t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 17:59:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62916 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755625Ab2JRV7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 17:59:47 -0400
Date: Thu, 18 Oct 2012 14:59:44 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Glauber Costa <glommer@parallels.com>
cc: linux-mm@kvack.org, cgroups@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        devel@openvz.org, linux-kernel@vger.kernel.org,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v5 06/14] memcg: kmem controller infrastructure
In-Reply-To: <507FCA90.8060307@parallels.com>
Message-ID: <alpine.DEB.2.00.1210181454100.30894@chino.kir.corp.google.com>
References: <1350382611-20579-1-git-send-email-glommer@parallels.com> <1350382611-20579-7-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1210171515290.20712@chino.kir.corp.google.com> <507FCA90.8060307@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Oct 2012, Glauber Costa wrote:

> >> @@ -2630,6 +2634,171 @@ static void __mem_cgroup_commit_charge(struct mem_cgroup *memcg,
> >>  	memcg_check_events(memcg, page);
> >>  }
> >>  
> >> +#ifdef CONFIG_MEMCG_KMEM
> >> +static inline bool memcg_can_account_kmem(struct mem_cgroup *memcg)
> >> +{
> >> +	return !mem_cgroup_disabled() && !mem_cgroup_is_root(memcg) &&
> >> +		(memcg->kmem_accounted & KMEM_ACCOUNTED_MASK);
> >> +}
> >> +
> >> +static int memcg_charge_kmem(struct mem_cgroup *memcg, gfp_t gfp, u64 size)
> >> +{
> >> +	struct res_counter *fail_res;
> >> +	struct mem_cgroup *_memcg;
> >> +	int ret = 0;
> >> +	bool may_oom;
> >> +
> >> +	ret = res_counter_charge(&memcg->kmem, size, &fail_res);
> >> +	if (ret)
> >> +		return ret;
> >> +
> >> +	/*
> >> +	 * Conditions under which we can wait for the oom_killer.
> >> +	 * We have to be able to wait, but also, if we can't retry,
> >> +	 * we obviously shouldn't go mess with oom.
> >> +	 */
> >> +	may_oom = (gfp & __GFP_WAIT) && !(gfp & __GFP_NORETRY);
> > 
> > What about gfp & __GFP_FS?
> >
> 
> Do you intend to prevent or allow OOM under that flag? I personally
> think that anything that accepts to be OOM-killed should have GFP_WAIT
> set, so that ought to be enough.
> 

The oom killer in the page allocator cannot trigger without __GFP_FS 
because direct reclaim has little chance of being very successful and 
thus we end up needlessly killing processes, and that tends to happen 
quite a bit if we dont check for it.  Seems like this would also happen 
with memcg if mem_cgroup_reclaim() has a large probability of failing?
