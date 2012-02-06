Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993Ab2BFWjA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 17:39:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48214 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755015Ab2BFWi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 17:38:58 -0500
Date: Mon, 6 Feb 2012 14:38:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Ying Han <yinghan@google.com>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 1/6] memcg: simplify move_account() check.
Message-Id: <20120206143853.4cd732c4.akpm@linux-foundation.org>
In-Reply-To: <20120206190759.76df4784.kamezawa.hiroyu@jp.fujitsu.com>
References: <20120206190627.7313ff82.kamezawa.hiroyu@jp.fujitsu.com>
	<20120206190759.76df4784.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Feb 2012 19:07:59 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> >From c75cc843ca0cb36de97ab814e59fb4ab7b1ffbd1 Mon Sep 17 00:00:00 2001
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Date: Thu, 2 Feb 2012 10:02:39 +0900
> Subject: [PATCH 1/6] memcg: simplify move_account() check.
> 
> In memcg, for avoiding take-lock-irq-off at accessing page_cgroup,
> a logic, flag + rcu_read_lock(), is used. This works as following
> 
>      CPU-A                     CPU-B
>                              rcu_read_lock()
>     set flag
>                              if(flag is set)
>                                    take heavy lock
>                              do job.
>     synchronize_rcu()        rcu_read_unlock()
> 
> In recent discussion, it's argued that using per-cpu value for this
> flag just complicates the code because 'set flag' is very rare.
> 
> This patch changes 'flag' implementation from percpu to atomic_t.
> This will be much simpler.
> 

To me, "RFC" says "might not be ready for merging yet".  You're up to
v3 - why is it still RFC?  You're still expecting to make significant
changes?

>
>  }
> +/*
> + * memcg->moving_account is used for checking possibility that some thread is
> + * calling move_account(). When a thread on CPU-A starts moving pages under
> + * a memcg, other threads sholud check memcg->moving_account under

"should"

> + * rcu_read_lock(), like this:
> + *
> + *         CPU-A                                    CPU-B
> + *                                              rcu_read_lock()
> + *         memcg->moving_account+1              if (memcg->mocing_account)
> + *                                                   take havier locks.
> + *         syncronize_rcu()                     update something.
> + *                                              rcu_read_unlock()
> + *         start move here.
> + */
>  
>  static void mem_cgroup_start_move(struct mem_cgroup *memcg)
>  {
> -	int cpu;
> -
> -	get_online_cpus();
> -	spin_lock(&memcg->pcp_counter_lock);
> -	for_each_online_cpu(cpu)
> -		per_cpu(memcg->stat->count[MEM_CGROUP_ON_MOVE], cpu) += 1;
> -	memcg->nocpu_base.count[MEM_CGROUP_ON_MOVE] += 1;
> -	spin_unlock(&memcg->pcp_counter_lock);
> -	put_online_cpus();
> -
> +	atomic_inc(&memcg->moving_account);
>  	synchronize_rcu();
>  }
>  
>  static void mem_cgroup_end_move(struct mem_cgroup *memcg)
>  {
> -	int cpu;
> -
> -	if (!memcg)
> -		return;
> -	get_online_cpus();
> -	spin_lock(&memcg->pcp_counter_lock);
> -	for_each_online_cpu(cpu)
> -		per_cpu(memcg->stat->count[MEM_CGROUP_ON_MOVE], cpu) -= 1;
> -	memcg->nocpu_base.count[MEM_CGROUP_ON_MOVE] -= 1;
> -	spin_unlock(&memcg->pcp_counter_lock);
> -	put_online_cpus();
> +	if (memcg)
> +		atomic_dec(&memcg->moving_account);
>  }

It's strange that end_move handles a NULL memcg but start_move does not.

>  /*
>   * 2 routines for checking "mem" is under move_account() or not.
> @@ -1298,7 +1297,7 @@ static void mem_cgroup_end_move(struct mem_cgroup *memcg)
>  static bool mem_cgroup_stealed(struct mem_cgroup *memcg)
>  {
>  	VM_BUG_ON(!rcu_read_lock_held());
> -	return this_cpu_read(memcg->stat->count[MEM_CGROUP_ON_MOVE]) > 0;
> +	return atomic_read(&memcg->moving_account);
>  }

So a bool-returning function can return something > 1?

I don't know what the compiler would make of that.  Presumably "if (b)"
will work OK, but will "if (b1 == b2)"?

