Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741Ab2JPXIa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 19:08:30 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:49462 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243Ab2JPXI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 19:08:29 -0400
Date: Tue, 16 Oct 2012 16:08:24 -0700
From: Tejun Heo <tj@kernel.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: tony.luck@intel.com, bp@amd64.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, Miao Xie <miaox@cn.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH] Do not change worker's running cpu in
 cmci_rediscover().
Message-ID: <20121016230824.GG16166@google.com>
References: <1348737586-7018-1-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348737586-7018-1-git-send-email-tangchen@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Sorry about the delay.  Was traveling.

On Thu, Sep 27, 2012 at 05:19:46PM +0800, Tang Chen wrote:
> 1. cmci_rediscover() is only called by the CPU_POST_DEAD event handler, which
> means the corresponding cpu has already dead. As a result, it won't be accessed
> in the for_each_online_cpu loop.
> So, we could change the if(cpu == dying) statement into a BUG_ON().

Let's please move this to a separate patch and use WARN_ON_ONCE()
instead.

> 2. cmci_rediscover() used set_cpus_allowed_ptr() to change the current process's
> running cpu, and migrate itself to the dest cpu. But worker processes are not
> allowed to be migrated. If current is a worker, the worker will be migrated to
> another cpu, but the corresponding  worker_pool is still on the original cpu.
> 
> In this case, the following BUG_ON in try_to_wake_up_local() will be triggered:
> BUG_ON(rq != this_rq());
> 
> This will cause the kernel panic.
> 
> This patch removes the set_cpus_allowed_ptr() call, and put the cmci rediscover
> jobs onto all the other cpus using system_wq. This could bring some delay for
> the jobs.
...
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>

After separating out the fix part into a separate patch, please add
Cc: stable@vger.kernel.org.

>  void cmci_rediscover(int dying)
>  {
> -	int banks;
> -	int cpu;
> -	cpumask_var_t old;
> +	int cpu, banks;
>  
>  	if (!cmci_supported(&banks))
>  		return;
> -	if (!alloc_cpumask_var(&old, GFP_KERNEL))
> -		return;
> -	cpumask_copy(old, &current->cpus_allowed);
>  
>  	for_each_online_cpu(cpu) {
> -		if (cpu == dying)
> -			continue;
> -		if (set_cpus_allowed_ptr(current, cpumask_of(cpu)))
> +		BUG_ON(cpu == dying);
> +
> +		if (cpu == smp_processor_id()) {
> +			cmci_rediscover_work_func(NULL);
>  			continue;
> -		/* Recheck banks in case CPUs don't all have the same */
> -		if (cmci_supported(&banks))
> -			cmci_discover(banks, 0);
> -	}
> +		}
>  
> -	set_cpus_allowed_ptr(current, old);
> -	free_cpumask_var(old);
> +		work_on_cpu(cpu, cmci_rediscover_work_func, NULL);
> +	}

The change looks correct to me but fails to apply to the current
mainline.

Thanks!

-- 
tejun
