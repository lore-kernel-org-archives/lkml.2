Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903Ab2IZDlp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 23:41:45 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:41828 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab2IZDlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 23:41:44 -0400
Message-ID: <5062796F.8050802@linux.vnet.ibm.com>
Date: Wed, 26 Sep 2012 11:41:35 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Michael Wang <wangyun@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@redhat.com,
        svaidy@linux.vnet.ibm.com, wfg@linux.intel.com
Subject: Re: [PATCH] sched: fix should_resched() to avoid do schedule in atomic
References: <1347937984-5817-1-git-send-email-wangyun@linux.vnet.ibm.com>
In-Reply-To: <1347937984-5817-1-git-send-email-wangyun@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12092603-8256-0000-0000-000004532782
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2012 11:13 AM, Michael Wang wrote:
> This patch try to fix the BUG:
> 
> [    0.043953] BUG: scheduling while atomic: swapper/0/1/0x10000002
> [    0.044017] no locks held by swapper/0/1.
> [    0.044692] Pid: 1, comm: swapper/0 Not tainted 3.6.0-rc1-00420-gb7aebb9 #34
> [    0.045861] Call Trace:
> [    0.048071]  [<c106361e>] __schedule_bug+0x5e/0x70
> [    0.048890]  [<c1b28701>] __schedule+0x91/0xb10
> [    0.049660]  [<c14472ea>] ? vsnprintf+0x33a/0x450
> [    0.050444]  [<c1060006>] ? lg_local_lock+0x6/0x70
> [    0.051256]  [<c14fb5b1>] ? wait_for_xmitr+0x31/0x90
> [    0.052019]  [<c144fd55>] ? do_raw_spin_unlock+0xa5/0xf0
> [    0.052903]  [<c1b2a532>] ? _raw_spin_unlock+0x22/0x30
> [    0.053759]  [<c105cdbb>] ? up+0x1b/0x70
> [    0.054421]  [<c1065d6b>] __cond_resched+0x1b/0x30
> [    0.055228]  [<c1b292d5>] _cond_resched+0x45/0x50
> [    0.056020]  [<c1b26c58>] mutex_lock_nested+0x28/0x370
> [    0.056884]  [<c1034222>] ? console_unlock+0x3a2/0x4e0
> [    0.057741]  [<c1ac8559>] __irq_alloc_descs+0x39/0x1c0
> [    0.058589]  [<c10223bc>] io_apic_setup_irq_pin+0x2c/0x310
> [    0.060042]  [<c20638df>] setup_IO_APIC+0x101/0x744
> [    0.060878]  [<c1021d51>] ? clear_IO_APIC+0x31/0x50
> [    0.061695]  [<c20600f4>] native_smp_prepare_cpus+0x538/0x680
> [    0.062644]  [<c2056a91>] ? do_one_initcall+0x12c/0x12c
> [    0.063517]  [<c2056a91>] ? do_one_initcall+0x12c/0x12c
> [    0.064016]  [<c2056adc>] kernel_init+0x4b/0x17f
> [    0.064790]  [<c2056a91>] ? do_one_initcall+0x12c/0x12c
> [    0.065660]  [<c1b2bbd6>] kernel_thread_helper+0x6/0x10
> 
> The process to trigger the BUG is:
> 
> 	native_smp_prepare_cpus()
> 	preempt_disable()		//preempt_count++
> 	__irq_alloc_descs()
> 	mutex_lock()
> 	might_sleep()			//should_resched() return true
> 	__schedule()
> 	preempt_disable()		//preempt_count++
> 	schedule_bug()			//preempt_count > 1, report bug
> 
> So the issue is that should_resched() should not return true while the preempt
> already disabled.

Hi, Peter

Could we use this solution to fix the bug?

Regards,
Michael Wang

> 
> This patch will fix the issue, then might_sleep() won't do schedule in atomic
> any more.
> 
> Reported-by: Fengguang Wu <wfg@linux.intel.com>
> Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
> ---
>  kernel/sched/core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index b38f00e..2b7cd15 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -4171,7 +4171,7 @@ SYSCALL_DEFINE0(sched_yield)
> 
>  static inline int should_resched(void)
>  {
> -	return need_resched() && !(preempt_count() & PREEMPT_ACTIVE);
> +	return need_resched() && !preempt_count();
>  }
> 
>  static void __cond_resched(void)
> 

