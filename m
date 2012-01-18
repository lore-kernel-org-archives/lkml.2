Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab2ARMia (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 07:38:30 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:53678 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939Ab2ARMi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 07:38:29 -0500
Message-ID: <4F16BD39.6070201@linux.vnet.ibm.com>
Date: Wed, 18 Jan 2012 18:08:17 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
        Marcos Souza <marcos.mage@gmail.com>
Subject: Re: [PATCH] Sched fair: check that ilb cpu is online during nohz_balancer_kick()
References: <20120118121049.GA4258@swordfish.minsk.epam.com>
In-Reply-To: <20120118121049.GA4258@swordfish.minsk.epam.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12011802-0260-0000-0000-000000657786
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2012 05:40 PM, Sergey Senozhatsky wrote:

> Sched fair: check that ilb cpu is online during nohz_balancer_kick()
> 
> find_new_ilb() may return offlined cpu if trigger_load_balance() occurs while machine
> suspending or resuming, hitting native_smp_send_reschedule() assertion failure:
> [  108.473465] Disabling non-boot CPUs ...
> [  108.477308] CPU 1 is now offline
> [  108.477497] ------------[ cut here ]------------
> [  108.477523] WARNING: at arch/x86/kernel/smp.c:120 native_smp_send_reschedule+0x25/0x56()
> [  108.477724] Call Trace:
> [  108.477736]  <IRQ>  [<ffffffff81030092>] warn_slowpath_common+0x7e/0x96
> [  108.477772]  [<ffffffff810300bf>] warn_slowpath_null+0x15/0x17
> [  108.477795]  [<ffffffff81018ff7>] native_smp_send_reschedule+0x25/0x56
> [  108.477823]  [<ffffffff81067ffe>] trigger_load_balance+0x6ac/0x72e
> [  108.477847]  [<ffffffff81067bfd>] ? trigger_load_balance+0x2ab/0x72e
> [  108.477874]  [<ffffffff8105f05c>] scheduler_tick+0xe2/0xeb
> [  108.477899]  [<ffffffff8103f6ac>] update_process_times+0x60/0x70
> [  108.477926]  [<ffffffff8107c1e1>] tick_sched_timer+0x6d/0x96
> [  108.477951]  [<ffffffff81053b3b>] __run_hrtimer+0x1c2/0x3a1
> [  108.477974]  [<ffffffff8107c174>] ? tick_nohz_handler+0xdf/0xdf
> [  108.477999]  [<ffffffff81054721>] hrtimer_interrupt+0xe6/0x1b0
> [  108.478023]  [<ffffffff81019bdd>] smp_apic_timer_interrupt+0x80/0x93
> [  108.478051]  [<ffffffff814a2f73>] apic_timer_interrupt+0x73/0x80
> [  108.478072]  <EOI>  [<ffffffff8148f763>] ? slab_cpuup_callback+0xa8/0xdb
> [  108.478108]  [<ffffffff8149f154>] notifier_call_chain+0x86/0xb3
> [  108.478133]  [<ffffffff8147f09f>] ? spp_getpage+0x5f/0x5f
> [  108.478157]  [<ffffffff810556d9>] __raw_notifier_call_chain+0x9/0xb
> [  108.478182]  [<ffffffff81031857>] __cpu_notify+0x1b/0x2d
> [  108.478204]  [<ffffffff81031962>] cpu_notify_nofail+0xe/0x16
> [  108.478227]  [<ffffffff8147f1fd>] _cpu_down+0x130/0x249
> [  108.478249]  [<ffffffff814920ef>] ? printk+0x4c/0x4e
> [  108.478271]  [<ffffffff810319f6>] disable_nonboot_cpus+0x5a/0xfc
> [  108.478297]  [<ffffffff8106f000>] suspend_devices_and_enter+0x19a/0x407
> [  108.478323]  [<ffffffff8106f391>] enter_state+0x124/0x169
> [  108.478346]  [<ffffffff8106e01b>] state_store+0xb7/0x101
> [  108.478373]  [<ffffffff8126c82f>] kobj_attr_store+0x17/0x19
> [  108.478399]  [<ffffffff8117e20c>] sysfs_write_file+0x103/0x13f
> [  108.478425]  [<ffffffff8111f018>] vfs_write+0xad/0x13d
> [  108.478447]  [<ffffffff8111f293>] sys_write+0x45/0x6c
> [  108.478469]  [<ffffffff814a2439>] system_call_fastpath+0x16/0x1b
> [  108.478492] ---[ end trace 991823fa9b0a0b79 ]---
> 
> Check that returned by find_new_ilb() cpu is online.
> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> 
> ---
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 84adb2d..070b8e0 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4826,7 +4826,7 @@ unlock:
>  	rcu_read_unlock();
> 
>  out_done:
> -	if (ilb < nr_cpu_ids && idle_cpu(ilb))
> +	if (likely(cpu_online(ilb)) && ilb < nr_cpu_ids && idle_cpu(ilb))
>  		return ilb;
> 
>  	return nr_cpu_ids;
> 


You can do even better than that by doing:

if (likely(cpu_active(ilb) && ilb < nr_cpu_ids && idle_cpu(ilb))

This would prevent us from sending IPIs to CPUs that are about to go
offline as well (apart from those that are already offline).

However, I would rather prefer an approach where we fix the
nohz.idle_cpus_mask so that it doesn't contain entries corresponding to offline
CPUs. This would not only fix the root-cause of the problem but would also make
find_new_ilb() return useful values more often (that is, values other than
nr_cpu_ids).

Suresh has posted a patch in that direction here:
http://thread.gmane.org/gmane.linux.kernel/1237745/focus=1240001

(But that patch didn't help though...)

It is also to be noted that this warning is a problem introduced in 3.3 merge
window - we didn't hit this in 3.2. So, it would be good to fix the root-cause
provided it is worth the effort (considering both additional code complexity
and the coding effort needed).

Regards,
Srivatsa S. Bhat
IBM Linux Technology Center

