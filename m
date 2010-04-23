Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab0DWTeN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 15:34:13 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:39190 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754064Ab0DWTeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 15:34:10 -0400
Date: Fri, 23 Apr 2010 12:34:06 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [BUGFIX][PATCH] memcg rcu lock fix v3
Message-ID: <20100423193406.GD2589@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4BD10D59.9090504@cn.fujitsu.com>
 <20100423121424.ae47efcb.kamezawa.hiroyu@jp.fujitsu.com>
 <4BD118E2.7080307@cn.fujitsu.com>
 <4BD11A24.2070500@cn.fujitsu.com>
 <20100423125814.01e95bce.kamezawa.hiroyu@jp.fujitsu.com>
 <20100423130349.f320d0be.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100423130349.f320d0be.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 01:03:49PM +0900, KAMEZAWA Hiroyuki wrote:
> On Fri, 23 Apr 2010 12:58:14 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > On Fri, 23 Apr 2010 11:55:16 +0800
> > Li Zefan <lizf@cn.fujitsu.com> wrote:
> > 
> > > Li Zefan wrote:
> > > > KAMEZAWA Hiroyuki wrote:
> > > >> On Fri, 23 Apr 2010 11:00:41 +0800
> > > >> Li Zefan <lizf@cn.fujitsu.com> wrote:
> > > >>
> > > >>> with CONFIG_PROVE_RCU=y, I saw this warning, it's because
> > > >>> css_id() is not under rcu_read_lock().
> > > >>>
> > > >> Ok. Thank you for reporting.
> > > >> This is ok ? 
> > > > 
> > > > Yes, and I did some more simple tests on memcg, no more warning
> > > > showed up.
> > > > 
> > > 
> > > oops, after trigging oom, I saw 2 more warnings:
> > > 
> > 
> > Thank you for good testing.
> v3 here...sorry too rapid posting...
> 
> ==
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

I have queued this, thank you all!

However, memcg_oom_wake_function() does not yet exist in the tree
I am using, and is_target_pte_for_mc() has changed.  I omitted the
hunk for memcg_oom_wake_function() and edited the hunk for
is_target_pte_for_mc().

I have queued this for others' testing, but if you would rather carry
this patch up the memcg path, please let me know and I will drop it.

							Thanx, Paul

> css_id() should be called under rcu_read_lock().
> Following is a report from Li Zefan.
> ==
> ===================================================
> [ INFO: suspicious rcu_dereference_check() usage. ]
> ---------------------------------------------------
> kernel/cgroup.c:4438 invoked rcu_dereference_check() without protection!
> 
> other info that might help us debug this:
> 
> 
> rcu_scheduler_active = 1, debug_locks = 1
> 1 lock held by kswapd0/31:
>  #0:  (swap_lock){+.+.-.}, at: [<c05058bb>] swap_info_get+0x4b/0xd0
> 
> stack backtrace:
> Pid: 31, comm: kswapd0 Not tainted 2.6.34-rc5-tip+ #13
> Call Trace:
>  [<c083c5d6>] ? printk+0x1d/0x1f
>  [<c0480744>] lockdep_rcu_dereference+0x94/0xb0
>  [<c049d6ed>] css_id+0x5d/0x60
>  [<c05165a5>] mem_cgroup_uncharge_swapcache+0x45/0xa0
>  [<c0505e4f>] swapcache_free+0x3f/0x60
>  [<c04e79e2>] __remove_mapping+0xb2/0xf0
>  [<c04e7cbb>] shrink_page_list+0x26b/0x490
>  [<c047f85d>] ? put_lock_stats+0xd/0x30
>  [<c083fd67>] ? _raw_spin_unlock_irq+0x27/0x50
>  [<c0482566>] ? trace_hardirqs_on_caller+0xb6/0x220
>  [<c04e8158>] shrink_inactive_list+0x278/0x620
>  [<c04729e1>] ? sched_clock_cpu+0x121/0x180
>  [<c047e9b8>] ? trace_hardirqs_off_caller+0x18/0x130
>  [<c047eadb>] ? trace_hardirqs_off+0xb/0x10
>  [<c0843438>] ? sub_preempt_count+0x8/0x90
>  [<c047f85d>] ? put_lock_stats+0xd/0x30
>  [<c04e8704>] shrink_zone+0x204/0x3c0
>  [<c083fcac>] ? _raw_spin_unlock+0x2c/0x50
>  [<c04e951e>] kswapd+0x61e/0x7c0
>  [<c04e6ed0>] ? isolate_pages_global+0x0/0x1f0
>  [<c046bae0>] ? autoremove_wake_function+0x0/0x50
>  [<c04e8f00>] ? kswapd+0x0/0x7c0
>  [<c046b5e4>] kthread+0x74/0x80
>  [<c046b570>] ? kthread+0x0/0x80
>  [<c04035ba>] kernel_thread_helper+0x6/0x10
> 
> And css_is_ancestor() should be called under rcu_read_lock().
> 
> 
> Reported-by: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  mm/memcontrol.c |   18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6.34-rc5-mm1/mm/memcontrol.c
> ===================================================================
> --- linux-2.6.34-rc5-mm1.orig/mm/memcontrol.c
> +++ linux-2.6.34-rc5-mm1/mm/memcontrol.c
> @@ -838,10 +838,12 @@ int task_in_mem_cgroup(struct task_struc
>  	 * enabled in "curr" and "curr" is a child of "mem" in *cgroup*
>  	 * hierarchy(even if use_hierarchy is disabled in "mem").
>  	 */
> +	rcu_read_lock();
>  	if (mem->use_hierarchy)
>  		ret = css_is_ancestor(&curr->css, &mem->css);
>  	else
>  		ret = (curr == mem);
> +	rcu_read_unlock();
>  	css_put(&curr->css);
>  	return ret;
>  }
> @@ -1360,9 +1362,13 @@ static int memcg_oom_wake_function(wait_
>  	 * Both of oom_wait_info->mem and wake_mem are stable under us.
>  	 * Then we can use css_is_ancestor without taking care of RCU.
>  	 */
> +	rcu_read_lock();
>  	if (!css_is_ancestor(&oom_wait_info->mem->css, &wake_mem->css) &&
> -	    !css_is_ancestor(&wake_mem->css, &oom_wait_info->mem->css))
> +	    !css_is_ancestor(&wake_mem->css, &oom_wait_info->mem->css)) {
> +		rcu_read_unlock();
>  		return 0;
> +	}
> +	rcu_read_unlock();
> 
>  wakeup:
>  	return autoremove_wake_function(wait, mode, sync, arg);
> @@ -2401,7 +2407,9 @@ mem_cgroup_uncharge_swapcache(struct pag
> 
>  	/* record memcg information */
>  	if (do_swap_account && swapout && memcg) {
> +		rcu_read_lock();
>  		swap_cgroup_record(ent, css_id(&memcg->css));
> +		rcu_read_unlock();
>  		mem_cgroup_get(memcg);
>  	}
>  	if (swapout && memcg)
> @@ -2458,8 +2466,10 @@ static int mem_cgroup_move_swap_account(
>  {
>  	unsigned short old_id, new_id;
> 
> +	rcu_read_lock();
>  	old_id = css_id(&from->css);
>  	new_id = css_id(&to->css);
> +	rcu_read_unlock();
> 
>  	if (swap_cgroup_cmpxchg(entry, old_id, new_id) == old_id) {
>  		mem_cgroup_swap_statistics(from, false);
> @@ -4303,7 +4313,11 @@ static int is_target_pte_for_mc(struct v
>  	}
>  	/* Threre is a swap entry and a page doesn't exist or isn't charged */
>  	if (ent.val && !ret) {
> -		if (css_id(&mc.from->css) == lookup_swap_cgroup(ent)) {
> +		unsigned short id;
> +		rcu_read_lock();
> +		id = css_id(&mc.from->css);
> +		rcu_read_unlock();
> +		if (id == lookup_swap_cgroup(ent)) {
>  			ret = MC_TARGET_SWAP;
>  			if (target)
>  				target->ent = ent;
> 
> 
