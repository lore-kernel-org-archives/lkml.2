Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315Ab1HRAbo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 20:31:44 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42758 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500Ab1HRAbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 20:31:43 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 18 Aug 2011 09:24:21 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <jweiner@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        Balbir Singh <bsingharora@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] memcg: pin execution to current cpu while draining
 stock
Message-Id: <20110818092421.856b74fe.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110817194927.GA10982@redhat.com>
References: <cover.1311338634.git.mhocko@suse.cz>
	<2f17df54db6661c39a05669d08a9e6257435b898.1311338634.git.mhocko@suse.cz>
	<20110725101657.21f85bf0.kamezawa.hiroyu@jp.fujitsu.com>
	<20110817194927.GA10982@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Aug 2011 21:49:27 +0200
Johannes Weiner <jweiner@redhat.com> wrote:

> Commit d1a05b6 'memcg: do not try to drain per-cpu caches without
> pages' added a drain_local_stock() call to a preemptible section.
> 
> The draining task looks up the cpu-local stock twice to set the
> draining-flag, then to drain the stock and clear the flag again.  If
> the task is migrated to a different CPU in between, noone will clear
> the flag on the first stock and it will be forever undrainable.  Its
> charge can not be recovered and the cgroup can not be deleted anymore.
> 
> Properly pin the task to the executing CPU while draining stocks.
> 
> Signed-off-by: Johannes Weiner <jweiner@redhat.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com
> Cc: Michal Hocko <mhocko@suse.cz>

Thanks. I think Shaoha Li reported this.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com
==

http://www.spinics.net/lists/linux-mm/msg22635.html

I get below warning:
BUG: using smp_processor_id() in preemptible [00000000] code: bash/739
caller is drain_local_stock+0x1a/0x55
Pid: 739, comm: bash Tainted: G        W   3.0.0+ #255
Call Trace:
 [<ffffffff813435c6>] debug_smp_processor_id+0xc2/0xdc
 [<ffffffff8114ae9b>] drain_local_stock+0x1a/0x55
 [<ffffffff8114b076>] drain_all_stock+0x98/0x13a
 [<ffffffff8114f04c>] mem_cgroup_force_empty+0xa3/0x27a
 [<ffffffff8114ff1d>] ? sys_close+0x38/0x138
 [<ffffffff811a7631>] ? environ_read+0x1d/0x159
 [<ffffffff8114f253>] mem_cgroup_force_empty_write+0x17/0x19
 [<ffffffff810c72fb>] cgroup_file_write+0xa8/0xba
 [<ffffffff811522ce>] vfs_write+0xb3/0x138
 [<ffffffff81152416>] sys_write+0x4a/0x71
 [<ffffffff8114ffd5>] ? sys_close+0xf0/0x138
 [<ffffffff8176deab>] system_call_fastpath+0x16/0x1b

drain_local_stock() should be run with preempt disabled.
==

Andrew, could you pull this one , too ?
http://www.spinics.net/lists/linux-mm/msg22636.html

Thanks,
-Kame

> ---
>  mm/memcontrol.c |    9 ++-------
>  1 files changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 697a1d5..e9b1206 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2085,13 +2085,7 @@ static void drain_all_stock(struct mem_cgroup *root_mem, bool sync)
>  
>  	/* Notify other cpus that system-wide "drain" is running */
>  	get_online_cpus();
> -	/*
> -	 * Get a hint for avoiding draining charges on the current cpu,
> -	 * which must be exhausted by our charging.  It is not required that
> -	 * this be a precise check, so we use raw_smp_processor_id() instead of
> -	 * getcpu()/putcpu().
> -	 */
> -	curcpu = raw_smp_processor_id();
> +	curcpu = get_cpu();
>  	for_each_online_cpu(cpu) {
>  		struct memcg_stock_pcp *stock = &per_cpu(memcg_stock, cpu);
>  		struct mem_cgroup *mem;
> @@ -2108,6 +2102,7 @@ static void drain_all_stock(struct mem_cgroup *root_mem, bool sync)
>  				schedule_work_on(cpu, &stock->work);
>  		}
>  	}
> +	put_cpu();
>  
>  	if (!sync)
>  		goto out;
> -- 
> 1.7.6
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

