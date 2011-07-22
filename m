Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab1GVAc6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 20:32:58 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:48284 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190Ab1GVAcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 20:32:53 -0400
Date: Fri, 22 Jul 2011 09:27:59 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] memcg: get rid of percpu_charge_mutex lock
Message-Id: <20110722092759.9be9078f.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20110721124223.GE27855@tiehlicka.suse.cz>
References: <cover.1311241300.git.mhocko@suse.cz>
	<2bfb2b7687c1a6b39da2a04689190725075cc4f8.1311241300.git.mhocko@suse.cz>
	<20110721193051.cd3266e5.kamezawa.hiroyu@jp.fujitsu.com>
	<20110721114704.GC27855@tiehlicka.suse.cz>
	<20110721124223.GE27855@tiehlicka.suse.cz>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jul 2011 14:42:23 +0200
Michal Hocko <mhocko@suse.cz> wrote:

> On Thu 21-07-11 13:47:04, Michal Hocko wrote:
> > On Thu 21-07-11 19:30:51, KAMEZAWA Hiroyuki wrote:
> > > On Thu, 21 Jul 2011 09:58:24 +0200
> > > Michal Hocko <mhocko@suse.cz> wrote:
> [...]
> > > > --- a/mm/memcontrol.c
> > > > +++ b/mm/memcontrol.c
> > > > @@ -2166,7 +2165,8 @@ static void drain_all_stock(struct mem_cgroup *root_mem, bool sync)
> > > >  
> > > >  	for_each_online_cpu(cpu) {
> > > >  		struct memcg_stock_pcp *stock = &per_cpu(memcg_stock, cpu);
> > > > -		if (test_bit(FLUSHING_CACHED_CHARGE, &stock->flags))
> > > > +		if (root_mem == stock->cached &&
> > > > +				test_bit(FLUSHING_CACHED_CHARGE, &stock->flags))
> > > >  			flush_work(&stock->work);
> > > 
> > > Doesn't this new check handle hierarchy ?
> > > css_is_ancestor() will be required if you do this check.
> > 
> > Yes you are right. Will fix it. I will add a helper for the check.
> 
> Here is the patch with the helper. The above will then read 
> 	if (mem_cgroup_same_or_subtree(root_mem, stock->cached))
> 
I welcome this new helper function, but it can be used in
memcg_oom_wake_function() and mem_cgroup_under_move() too, can't it ?

Thanks,
Daisuke Nishimura.

> ---
> From b963a9f4dac61044daac49700f84b7819d7c2f53 Mon Sep 17 00:00:00 2001
> From: Michal Hocko <mhocko@suse.cz>
> Date: Thu, 21 Jul 2011 13:54:13 +0200
> Subject: [PATCH] memcg: add mem_cgroup_same_or_subtree helper
> 
> We are checking whether a given two groups are same or at least in the
> same subtree of a hierarchy at several places. Let's make a helper for
> it to make code easier to read.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> ---
>  mm/memcontrol.c |   29 ++++++++++++++++++-----------
>  1 files changed, 18 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 8180cd9..8dbb9d6 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1046,6 +1046,21 @@ void mem_cgroup_move_lists(struct page *page,
>  	mem_cgroup_add_lru_list(page, to);
>  }
>  
> +/*
> + * Checks whether given mem is same or in the root_mem's
> + * hierarchy subtree
> + */
> +static bool mem_cgroup_same_or_subtree(const struct mem_cgroup *root_mem,
> +		struct mem_cgroup *mem)
> +{
> +	if (root_mem != mem) {
> +		return (root_mem->use_hierarchy &&
> +			css_is_ancestor(&mem->css, &root_mem->css));
> +	}
> +
> +	return true;
> +}
> +
>  int task_in_mem_cgroup(struct task_struct *task, const struct mem_cgroup *mem)
>  {
>  	int ret;
> @@ -1065,10 +1080,7 @@ int task_in_mem_cgroup(struct task_struct *task, const struct mem_cgroup *mem)
>  	 * enabled in "curr" and "curr" is a child of "mem" in *cgroup*
>  	 * hierarchy(even if use_hierarchy is disabled in "mem").
>  	 */
> -	if (mem->use_hierarchy)
> -		ret = css_is_ancestor(&curr->css, &mem->css);
> -	else
> -		ret = (curr == mem);
> +	ret = mem_cgroup_same_or_subtree(mem, curr);
>  	css_put(&curr->css);
>  	return ret;
>  }
> @@ -2150,13 +2162,8 @@ static void drain_all_stock(struct mem_cgroup *root_mem, bool sync)
>  		mem = stock->cached;
>  		if (!mem || !stock->nr_pages)
>  			continue;
> -		if (mem != root_mem) {
> -			if (!root_mem->use_hierarchy)
> -				continue;
> -			/* check whether "mem" is under tree of "root_mem" */
> -			if (!css_is_ancestor(&mem->css, &root_mem->css))
> -				continue;
> -		}
> +		if (!mem_cgroup_same_or_subtree(root_mem, mem))
> +			continue;
>  		if (!test_and_set_bit(FLUSHING_CACHED_CHARGE, &stock->flags))
>  			schedule_work_on(cpu, &stock->work);
>  	}
> -- 
> 1.7.5.4
> 
> 
> -- 
> Michal Hocko
> SUSE Labs
> SUSE LINUX s.r.o.
> Lihovarska 1060/12
> 190 00 Praha 9    
> Czech Republic
