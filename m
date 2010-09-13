Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab0IMR11 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 13:27:27 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:50448 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809Ab0IMR10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 13:27:26 -0400
Date: Mon, 13 Sep 2010 22:56:19 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        gthelen@google.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH] memcg: avoid lock in updating file_mapped (Was fix race
 in file_mapped accouting flag management
Message-ID: <20100913172619.GN17950@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20100913160822.0c2cd732.kamezawa.hiroyu@jp.fujitsu.com>
 <20100913161309.9d733e6b.kamezawa.hiroyu@jp.fujitsu.com>
 <20100913170151.aef94e26.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100913170151.aef94e26.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-09-13 17:01:51]:

> 
> Very sorry, subject was wrong..(reposting).
> 
> ==
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> At accounting file events per memory cgroup, we need to find memory cgroup
> via page_cgroup->mem_cgroup. Now, we use lock_page_cgroup() for guarantee
> pc->mem_cgroup is not overwritten while we make use of it.
> 
> But, considering the context which page-cgroup for files are accessed,
> we can use alternative light-weight mutual execusion in the most case.
> 
> At handling file-caches, the only race we have to take care of is "moving"
> account, IOW, overwriting page_cgroup->mem_cgroup. 
> (See comment in the patch)
> 
> Unlike charge/uncharge, "move" happens not so frequently. It happens only when
> rmdir() and task-moving (with a special settings.)
> This patch adds a race-checker for file-cache-status accounting v.s. account
> moving. The new per-cpu-per-memcg counter MEM_CGROUP_ON_MOVE is added.
> The routine for account move 
>   1. Increment it before start moving
>   2. Call synchronize_rcu()
>   3. Decrement it after the end of moving.
> By this, file-status-counting routine can check it needs to call
> lock_page_cgroup(). In most case, I doesn't need to call it.
> 
> Following is a perf data of a process which mmap()/munmap 32MB of file cache
> in a minute.
> 
> Before patch:
>     28.25%     mmap  mmap               [.] main
>     22.64%     mmap  [kernel.kallsyms]  [k] page_fault
>      9.96%     mmap  [kernel.kallsyms]  [k] mem_cgroup_update_file_mapped
>      3.67%     mmap  [kernel.kallsyms]  [k] filemap_fault
>      3.50%     mmap  [kernel.kallsyms]  [k] unmap_vmas
>      2.99%     mmap  [kernel.kallsyms]  [k] __do_fault
>      2.76%     mmap  [kernel.kallsyms]  [k] find_get_page
> 
> After patch:
>     30.00%     mmap  mmap               [.] main
>     23.78%     mmap  [kernel.kallsyms]  [k] page_fault
>      5.52%     mmap  [kernel.kallsyms]  [k] mem_cgroup_update_file_mapped
>      3.81%     mmap  [kernel.kallsyms]  [k] unmap_vmas
>      3.26%     mmap  [kernel.kallsyms]  [k] find_get_page
>      3.18%     mmap  [kernel.kallsyms]  [k] __do_fault
>      3.03%     mmap  [kernel.kallsyms]  [k] filemap_fault
>      2.40%     mmap  [kernel.kallsyms]  [k] handle_mm_fault
>      2.40%     mmap  [kernel.kallsyms]  [k] do_page_fault
> 
> This patch reduces memcg's cost to some extent.
> (mem_cgroup_update_file_mapped is called by both of map/unmap)
> 
> Note: It seems some more improvements are required..but no idea.
>       maybe removing set/unset flag is required.
> 
> Changelog: 20100913
>  - decoupled with ID patches.
>  - updated comments.
> 
> Changelog: 20100901
>  - changes id_to_memcg(pc, true) to be id_to_memcg(pc, false)
>    in update_file_mapped()
>  - updated comments on lock rule of update_file_mapped()
> Changelog: 20100825
>  - added a comment about mc.lock
>  - fixed bad lock.
> Changelog: 20100804
>  - added a comment for possible optimization hint.
> Changelog: 20100730
>  - some cleanup.
> Changelog: 20100729
>  - replaced __this_cpu_xxx() with this_cpu_xxx
>    (because we don't call spinlock)
>  - added VM_BUG_ON().
> 
> Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  mm/memcontrol.c |   99 ++++++++++++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 85 insertions(+), 14 deletions(-)
> 
> Index: lockless-update/mm/memcontrol.c
> ===================================================================
> --- lockless-update.orig/mm/memcontrol.c
> +++ lockless-update/mm/memcontrol.c
> @@ -90,6 +90,7 @@ enum mem_cgroup_stat_index {
>  	MEM_CGROUP_STAT_PGPGOUT_COUNT,	/* # of pages paged out */
>  	MEM_CGROUP_STAT_SWAPOUT, /* # of pages, swapped out */
>  	MEM_CGROUP_EVENTS,	/* incremented at every  pagein/pageout */
> +	MEM_CGROUP_ON_MOVE,	/* someone is moving account between groups */
> 
>  	MEM_CGROUP_STAT_NSTATS,
>  };
> @@ -1051,7 +1052,46 @@ static unsigned int get_swappiness(struc
>  	return swappiness;
>  }
> 
> -/* A routine for testing mem is not under move_account */
> +static void mem_cgroup_start_move(struct mem_cgroup *mem)
> +{
> +	int cpu;
> +	/* Because this is for moving account, reuse mc.lock */
> +	spin_lock(&mc.lock);
> +	for_each_possible_cpu(cpu)

for_each_possible_cpu() might be too much, no?

I recommend we use a get_online_cpus()/put_online_cpus() pair
around the call and optimize.

> +		per_cpu(mem->stat->count[MEM_CGROUP_ON_MOVE], cpu) += 1;
> +	spin_unlock(&mc.lock);
> +
> +	synchronize_rcu();
> +}
> +
> +static void mem_cgroup_end_move(struct mem_cgroup *mem)
> +{
> +	int cpu;
> +
> +	if (!mem)
> +		return;
> +	spin_lock(&mc.lock);
> +	for_each_possible_cpu(cpu)
> +		per_cpu(mem->stat->count[MEM_CGROUP_ON_MOVE], cpu) -= 1;

Same as above


-- 
	Three Cheers,
	Balbir
