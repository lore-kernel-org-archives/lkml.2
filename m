Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757929Ab2JLJrc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 05:47:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37482 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757855Ab2JLJra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 05:47:30 -0400
Date: Fri, 12 Oct 2012 11:47:26 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Suleiman Souhlal <suleiman@google.com>,
        Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, Johannes Weiner <hannes@cmpxchg.org>,
        Greg Thelen <gthelen@google.com>, devel@openvz.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v4 06/14] memcg: kmem controller infrastructure
Message-ID: <20121012094726.GH10110@dhcp22.suse.cz>
References: <1349690780-15988-1-git-send-email-glommer@parallels.com>
 <1349690780-15988-7-git-send-email-glommer@parallels.com>
 <20121011124212.GC29295@dhcp22.suse.cz>
 <5077CAAA.3090709@parallels.com>
 <20121012083944.GD10110@dhcp22.suse.cz>
 <5077D889.2040100@parallels.com>
 <20121012085740.GG10110@dhcp22.suse.cz>
 <5077DF20.7020200@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5077DF20.7020200@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 12-10-12 13:13:04, Glauber Costa wrote:
[...]
> Just so we don't ping-pong in another submission:
> 
> I changed memcontrol.h's memcg_kmem_newpage_charge to include:
> 
>         /* If the test is dying, just let it go. */
>         if (unlikely(test_thread_flag(TIF_MEMDIE)
>                      || fatal_signal_pending(current)))
>                 return true;

OK

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index c32aaaf..72cf189 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> +static int memcg_charge_kmem(struct mem_cgroup *memcg, gfp_t gfp, u64 size)
> +{
> +	struct res_counter *fail_res;
> +	struct mem_cgroup *_memcg;
> +	int ret = 0;
> +	bool may_oom;
> +
> +	ret = res_counter_charge(&memcg->kmem, size, &fail_res);
> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * Conditions under which we can wait for the oom_killer.
> +	 * We have to be able to wait, but also, if we can't retry,
> +	 * we obviously shouldn't go mess with oom.
> +	 */
> +	may_oom = (gfp & __GFP_WAIT) && !(gfp & __GFP_NORETRY);
> +
> +	_memcg = memcg;
> +	ret = __mem_cgroup_try_charge(NULL, gfp, size >> PAGE_SHIFT,
> +				      &_memcg, may_oom);
> +
> +	if (ret == -EINTR)  {
> +		/*
> +		 * __mem_cgroup_try_charge() chosed to bypass to root due to
> +		 * OOM kill or fatal signal.  Since our only options are to
> +		 * either fail the allocation or charge it to this cgroup, do
> +		 * it as a temporary condition. But we can't fail. From a
> +		 * kmem/slab perspective, the cache has already been selected,
> +		 * by mem_cgroup_get_kmem_cache(), so it is too late to change
> +		 * our minds. This condition will only trigger if the task
> +		 * entered memcg_charge_kmem in a sane state, but was
> +		 * OOM-killed.  during __mem_cgroup_try_charge. Tasks that are
> +		 * already dying when the allocation triggers should have been
> +		 * already directed to the root cgroup.
> +		 */
> +		res_counter_charge_nofail(&memcg->res, size, &fail_res);
> +		if (do_swap_account)
> +			res_counter_charge_nofail(&memcg->memsw, size,
> +						  &fail_res);
> +		ret = 0;
> +	} else if (ret)
> +		res_counter_uncharge(&memcg->kmem, size);
> +
> +	return ret;
> +}

OK
-- 
Michal Hocko
SUSE Labs
