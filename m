Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497Ab2IKKEm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 06:04:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56431 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751572Ab2IKKEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 06:04:40 -0400
Date: Tue, 11 Sep 2012 12:04:33 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Glauber Costa <glommer@parallels.com>,
        Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Thomas Graf <tgraf@suug.ch>,
        "Serge E. Hallyn" <serue@us.ibm.com>, Vivek Goyal <vgoyal@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH REPOST RFC cgroup/for-3.7] cgroup: mark subsystems with
 broken hierarchy support and whine if cgroups are nested for them
Message-ID: <20120911100433.GC8058@dhcp22.suse.cz>
References: <20120910223125.GC7677@google.com>
 <20120910223355.GD7677@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120910223355.GD7677@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I like the approach in general but see the comments bellow:

On Mon 10-09-12 15:33:55, Tejun Heo wrote:
[...]
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3855,12 +3855,17 @@ static int mem_cgroup_hierarchy_write(st
>  	 */
>  	if ((!parent_memcg || !parent_memcg->use_hierarchy) &&
>  				(val == 1 || val == 0)) {
> -		if (list_empty(&cont->children))
> +		if (list_empty(&cont->children)) {
>  			memcg->use_hierarchy = val;
> -		else
> +			/* we're fully hierarchical iff root uses hierarchy */
> +			if (mem_cgroup_is_root(memcg))
> +				mem_cgroup_subsys.broken_hierarchy = !val;
> +		} else {
>  			retval = -EBUSY;
> -	} else
> +		}
> +	} else {
>  		retval = -EINVAL;
> +	}
>  
>  out:
>  	cgroup_unlock();
> @@ -4953,6 +4958,7 @@ mem_cgroup_create(struct cgroup *cont)
>  						&per_cpu(memcg_stock, cpu);
>  			INIT_WORK(&stock->work, drain_local_stock);
>  		}
> +		mem_cgroup_subsys.broken_hierarchy = !memcg->use_hierarchy;

Hmmm, this will warn even if we have
root (default use_hierarchy=0)
 \
  A (use_hierarchy=1)
   \
    B <- here

which is unfortunate because it will add a noise to a reasonable
configuration.
I think this is fixable if you move the warning after 
cgroup_subsys_state::create and broken_hierarchy would be set only if
parent is not root and use_hierarchy==0 in mem_cgroup_create. Something
like:

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 795e525..d5c93ab 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4973,6 +4973,13 @@ mem_cgroup_create(struct cgroup *cont)
 	} else {
 		res_counter_init(&memcg->res, NULL);
 		res_counter_init(&memcg->memsw, NULL);
+		/*
+		 * Deeper hierachy with use_hierarchy == false doesn't make
+		 * much sense so let cgroup subsystem know about this unfortunate
+		 * state in our controller.
+		 */
+		if (parent && parent != root_mem_cgroup)
+			mem_cgroup_subsys.broken_hierarchy = true;
 	}
 	memcg->last_scanned_node = MAX_NUMNODES;
 	INIT_LIST_HEAD(&memcg->oom_notify);

What do you think?

>  		hotcpu_notifier(memcg_cpu_hotplug_callback, 0);
>  	} else {
>  		parent = mem_cgroup_from_cont(cont->parent);
> --- a/net/core/netprio_cgroup.c
> +++ b/net/core/netprio_cgroup.c
> @@ -330,7 +330,17 @@ struct cgroup_subsys net_prio_subsys = {
>  	.subsys_id	= net_prio_subsys_id,
>  #endif
>  	.base_cftypes	= ss_files,
> -	.module		= THIS_MODULE
> +	.module		= THIS_MODULE,
> +
> +	/*
> +	 * net_prio has artificial limit on the number of cgroups and
> +	 * disallows nesting making it impossible to co-mount it with other
> +	 * hierarchical subsystems.  Remove the artificially low PRIOIDX_SZ
> +	 * limit and properly nest configuration such that children follow
> +	 * their parents' configurations by default and are allowed to
> +	 * override and remove the following.
> +	 */
> +	.broken_hierarchy = trye,

typo

-- 
Michal Hocko
SUSE Labs
