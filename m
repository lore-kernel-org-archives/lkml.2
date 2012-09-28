Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714Ab2I1HwT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 03:52:19 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63340 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756004Ab2I1HwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 03:52:17 -0400
X-IronPort-AV: E=Sophos;i="4.80,501,1344182400"; 
   d="scan'208";a="5933266"
Message-ID: <506557B6.1050107@cn.fujitsu.com>
Date: Fri, 28 Sep 2012 15:54:30 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tang Chen <tangchen@cn.fujitsu.com>
CC: tony.luck@intel.com, bp@amd64.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, Miao Xie <miaox@cn.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] Do not change worker's running cpu in cmci_rediscover().
References: <1348737586-7018-1-git-send-email-tangchen@cn.fujitsu.com>
In-Reply-To: <1348737586-7018-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/28 15:52:23,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/28 15:52:24,
	Serialize complete at 2012/09/28 15:52:24
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add CC: Tejun Heo, Peter Zijlstra.

Hi, Tejun

This is a bug whose root cause is the same as
https://bugzilla.kernel.org/show_bug.cgi?id=47301.

Acked-by: Lai Jiangshan <laijs@cn.fujitsu.com>

thanks,
Lai


On 09/27/2012 05:19 PM, Tang Chen wrote:
> 1. cmci_rediscover() is only called by the CPU_POST_DEAD event handler, which
> means the corresponding cpu has already dead. As a result, it won't be accessed
> in the for_each_online_cpu loop.
> So, we could change the if(cpu == dying) statement into a BUG_ON().
> 
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
> 
> The following is call trace.
> 
> [ 6155.451107] ------------[ cut here ]------------
> [ 6155.452019] kernel BUG at kernel/sched/core.c:1654!
> ......
> [ 6155.452019] RIP: 0010:[<ffffffff810add15>]  [<ffffffff810add15>] try_to_wake_up_local+0x115/0x130
> ......
> [ 6155.452019] Call Trace:
> [ 6155.452019]  [<ffffffff8166fc14>] __schedule+0x764/0x880
> [ 6155.452019]  [<ffffffff81670059>] schedule+0x29/0x70
> [ 6155.452019]  [<ffffffff8166de65>] schedule_timeout+0x235/0x2d0
> [ 6155.452019]  [<ffffffff810db57d>] ? mark_held_locks+0x8d/0x140
> [ 6155.452019]  [<ffffffff810dd463>] ? __lock_release+0x133/0x1a0
> [ 6155.452019]  [<ffffffff81671c50>] ? _raw_spin_unlock_irq+0x30/0x50
> [ 6155.452019]  [<ffffffff810db8f5>] ? trace_hardirqs_on_caller+0x105/0x190
> [ 6155.452019]  [<ffffffff8166fefb>] wait_for_common+0x12b/0x180
> [ 6155.452019]  [<ffffffff810b0b30>] ? try_to_wake_up+0x2f0/0x2f0
> [ 6155.452019]  [<ffffffff8167002d>] wait_for_completion+0x1d/0x20
> [ 6155.452019]  [<ffffffff8110008a>] stop_one_cpu+0x8a/0xc0
> [ 6155.452019]  [<ffffffff810abd40>] ? __migrate_task+0x1a0/0x1a0
> [ 6155.452019]  [<ffffffff810a6ab8>] ? complete+0x28/0x60
> [ 6155.452019]  [<ffffffff810b0fd8>] set_cpus_allowed_ptr+0x128/0x130
> [ 6155.452019]  [<ffffffff81036785>] cmci_rediscover+0xf5/0x140
> [ 6155.452019]  [<ffffffff816643c0>] mce_cpu_callback+0x18d/0x19d
> [ 6155.452019]  [<ffffffff81676187>] notifier_call_chain+0x67/0x150
> [ 6155.452019]  [<ffffffff810a03de>] __raw_notifier_call_chain+0xe/0x10
> [ 6155.452019]  [<ffffffff81070470>] __cpu_notify+0x20/0x40
> [ 6155.452019]  [<ffffffff810704a5>] cpu_notify_nofail+0x15/0x30
> [ 6155.452019]  [<ffffffff81655182>] _cpu_down+0x262/0x2e0
> [ 6155.452019]  [<ffffffff81655236>] cpu_down+0x36/0x50
> [ 6155.452019]  [<ffffffff813d3eaa>] acpi_processor_remove+0x50/0x11e
> [ 6155.452019]  [<ffffffff813a6978>] acpi_device_remove+0x90/0xb2
> [ 6155.452019]  [<ffffffff8143cbec>] __device_release_driver+0x7c/0xf0
> [ 6155.452019]  [<ffffffff8143cd6f>] device_release_driver+0x2f/0x50
> [ 6155.452019]  [<ffffffff813a7870>] acpi_bus_remove+0x32/0x6d
> [ 6155.452019]  [<ffffffff813a7932>] acpi_bus_trim+0x87/0xee
> [ 6155.452019]  [<ffffffff813a7a21>] acpi_bus_hot_remove_device+0x88/0x16b
> [ 6155.452019]  [<ffffffff813a33ee>] acpi_os_execute_deferred+0x27/0x34
> [ 6155.452019]  [<ffffffff81090589>] process_one_work+0x219/0x680
> [ 6155.452019]  [<ffffffff81090528>] ? process_one_work+0x1b8/0x680
> [ 6155.452019]  [<ffffffff813a33c7>] ? acpi_os_wait_events_complete+0x23/0x23
> [ 6155.452019]  [<ffffffff810923be>] worker_thread+0x12e/0x320
> [ 6155.452019]  [<ffffffff81092290>] ? manage_workers+0x110/0x110
> [ 6155.452019]  [<ffffffff81098396>] kthread+0xc6/0xd0
> [ 6155.452019]  [<ffffffff8167c4c4>] kernel_thread_helper+0x4/0x10
> [ 6155.452019]  [<ffffffff81671f30>] ? retint_restore_args+0x13/0x13
> [ 6155.452019]  [<ffffffff810982d0>] ? __init_kthread_worker+0x70/0x70
> [ 6155.452019]  [<ffffffff8167c4c0>] ? gs_change+0x13/0x13
> 
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  arch/x86/kernel/cpu/mcheck/mce_intel.c |   34 +++++++++++++++++--------------
>  1 files changed, 19 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
> index 38e49bc..f7d9795 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
> @@ -163,34 +163,38 @@ void cmci_clear(void)
>  	raw_spin_unlock_irqrestore(&cmci_discover_lock, flags);
>  }
>  
> +static long cmci_rediscover_work_func(void *arg)
> +{
> +	int banks;
> +
> +	/* Recheck banks in case CPUs don't all have the same */
> +	if (cmci_supported(&banks))
> +		cmci_discover(banks, 0);
> +
> +	return 0;
> +}
> +
>  /*
>   * After a CPU went down cycle through all the others and rediscover
>   * Must run in process context.
>   */
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
>  }
>  
>  /*

