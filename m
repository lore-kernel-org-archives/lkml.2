Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758232Ab2FZGCS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 02:02:18 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46293 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757350Ab2FZGCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 02:02:15 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FE94FDC.7070105@jp.fujitsu.com>
Date: Tue, 26 Jun 2012 14:59:56 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Glauber Costa <glommer@parallels.com>
CC: cgroups@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>,
        devel@openvz.org, Tejun Heo <tj@kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH 10/11] memcg: allow a memcg with kmem charges to be destructed.
References: <1340633728-12785-1-git-send-email-glommer@parallels.com> <1340633728-12785-11-git-send-email-glommer@parallels.com>
In-Reply-To: <1340633728-12785-11-git-send-email-glommer@parallels.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/25 23:15), Glauber Costa wrote:
> Because the ultimate goal of the kmem tracking in memcg is to
> track slab pages as well, we can't guarantee that we'll always
> be able to point a page to a particular process, and migrate
> the charges along with it - since in the common case, a page
> will contain data belonging to multiple processes.
> 
> Because of that, when we destroy a memcg, we only make sure
> the destruction will succeed by discounting the kmem charges
> from the user charges when we try to empty the cgroup.
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> CC: Christoph Lameter <cl@linux.com>
> CC: Pekka Enberg <penberg@cs.helsinki.fi>
> CC: Michal Hocko <mhocko@suse.cz>
> CC: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> CC: Johannes Weiner <hannes@cmpxchg.org>
> CC: Suleiman Souhlal <suleiman@google.com>
> ---
>   mm/memcontrol.c |   10 +++++++++-
>   1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index a6a440b..bb9b6fe 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -598,6 +598,11 @@ static void disarm_kmem_keys(struct mem_cgroup *memcg)
>   {
>   	if (test_bit(KMEM_ACCOUNTED_THIS, &memcg->kmem_accounted))
>   		static_key_slow_dec(&mem_cgroup_kmem_enabled_key);
> +	/*
> +	 * This check can't live in kmem destruction function,
> +	 * since the charges will outlive the cgroup
> +	 */
> +	BUG_ON(res_counter_read_u64(&memcg->kmem, RES_USAGE) != 0);
>   }
>   #else
>   static void disarm_kmem_keys(struct mem_cgroup *memcg)
> @@ -3838,6 +3843,7 @@ static int mem_cgroup_force_empty(struct mem_cgroup *memcg, bool free_all)
>   	int node, zid, shrink;
>   	int nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
>   	struct cgroup *cgrp = memcg->css.cgroup;
> +	u64 usage;
>   
>   	css_get(&memcg->css);
>   
> @@ -3877,8 +3883,10 @@ move_account:
>   		if (ret == -ENOMEM)
>   			goto try_to_free;
>   		cond_resched();
> +		usage = res_counter_read_u64(&memcg->res, RES_USAGE) -
> +			res_counter_read_u64(&memcg->kmem, RES_USAGE);
>   	/* "ret" should also be checked to ensure all lists are empty. */
> -	} while (res_counter_read_u64(&memcg->res, RES_USAGE) > 0 || ret);
> +	} while (usage > 0 || ret);
>   out:
>   	css_put(&memcg->css);
>   	return ret;
> 
Hm....maybe work enough. Could you add more comments on the code ?

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>



