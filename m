Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423284Ab2JaQ22 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 12:28:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58839 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423013Ab2JaQ20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 12:28:26 -0400
Date: Wed, 31 Oct 2012 17:28:25 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, bsingharora@gmail.com,
        kamezawa.hiroyu@jp.fujitsu.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 8/8] cgroup: make ->pre_destroy() return void
Message-ID: <20121031162825.GG22809@dhcp22.suse.cz>
References: <1351657365-25055-1-git-send-email-tj@kernel.org>
 <1351657365-25055-9-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351657365-25055-9-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 30-10-12 21:22:45, Tejun Heo wrote:
> All ->pre_destory() implementations return 0 now, which is the only
> allowed return value.  Make it return void.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: Balbir Singh <bsingharora@gmail.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Vivek Goyal <vgoyal@redhat.com>

Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  block/blk-cgroup.c     | 3 +--
>  include/linux/cgroup.h | 2 +-
>  kernel/cgroup.c        | 2 +-
>  mm/hugetlb_cgroup.c    | 4 +---
>  mm/memcontrol.c        | 3 +--
>  5 files changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index f3b44a6..a7816f3 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -600,7 +600,7 @@ struct cftype blkcg_files[] = {
>   *
>   * This is the blkcg counterpart of ioc_release_fn().
>   */
> -static int blkcg_pre_destroy(struct cgroup *cgroup)
> +static void blkcg_pre_destroy(struct cgroup *cgroup)
>  {
>  	struct blkcg *blkcg = cgroup_to_blkcg(cgroup);
>  
> @@ -622,7 +622,6 @@ static int blkcg_pre_destroy(struct cgroup *cgroup)
>  	}
>  
>  	spin_unlock_irq(&blkcg->lock);
> -	return 0;
>  }
>  
>  static void blkcg_destroy(struct cgroup *cgroup)
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index 47868a8..adb2adc 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -436,7 +436,7 @@ int cgroup_taskset_size(struct cgroup_taskset *tset);
>  
>  struct cgroup_subsys {
>  	struct cgroup_subsys_state *(*create)(struct cgroup *cgrp);
> -	int (*pre_destroy)(struct cgroup *cgrp);
> +	void (*pre_destroy)(struct cgroup *cgrp);
>  	void (*destroy)(struct cgroup *cgrp);
>  	int (*can_attach)(struct cgroup *cgrp, struct cgroup_taskset *tset);
>  	void (*cancel_attach)(struct cgroup *cgrp, struct cgroup_taskset *tset);
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index c5f6fb2..83cd7d0 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -4054,7 +4054,7 @@ static int cgroup_rmdir(struct inode *unused_dir, struct dentry *dentry)
>  	mutex_unlock(&cgroup_mutex);
>  	for_each_subsys(cgrp->root, ss)
>  		if (ss->pre_destroy)
> -			WARN_ON_ONCE(ss->pre_destroy(cgrp));
> +			ss->pre_destroy(cgrp);
>  	mutex_lock(&cgroup_mutex);
>  
>  	/*
> diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
> index dc595c6..0d3a1a3 100644
> --- a/mm/hugetlb_cgroup.c
> +++ b/mm/hugetlb_cgroup.c
> @@ -155,7 +155,7 @@ out:
>   * Force the hugetlb cgroup to empty the hugetlb resources by moving them to
>   * the parent cgroup.
>   */
> -static int hugetlb_cgroup_pre_destroy(struct cgroup *cgroup)
> +static void hugetlb_cgroup_pre_destroy(struct cgroup *cgroup)
>  {
>  	struct hstate *h;
>  	struct page *page;
> @@ -172,8 +172,6 @@ static int hugetlb_cgroup_pre_destroy(struct cgroup *cgroup)
>  		}
>  		cond_resched();
>  	} while (hugetlb_cgroup_have_usage(cgroup));
> -
> -	return 0;
>  }
>  
>  int hugetlb_cgroup_charge_cgroup(int idx, unsigned long nr_pages,
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 47c4680..af05a60 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5002,12 +5002,11 @@ free_out:
>  	return ERR_PTR(error);
>  }
>  
> -static int mem_cgroup_pre_destroy(struct cgroup *cont)
> +static void mem_cgroup_pre_destroy(struct cgroup *cont)
>  {
>  	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
>  
>  	mem_cgroup_reparent_charges(memcg);
> -	return 0;
>  }
>  
>  static void mem_cgroup_destroy(struct cgroup *cont)
> -- 
> 1.7.11.7
> 

-- 
Michal Hocko
SUSE Labs
