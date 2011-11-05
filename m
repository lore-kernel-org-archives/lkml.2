Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764Ab1KEK2l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 06:28:41 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:42218 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab1KEK2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 06:28:39 -0400
Message-ID: <4EB50FC8.7000608@linux.vnet.ibm.com>
Date: Sat, 05 Nov 2011 15:58:24 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Fenghua Yu <fenghua.yu@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Len Brown <len.brown@intel.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 2/9] kernel/cpu.c: Add arch dependent cpu map update functions
References: <1320444241-834-1-git-send-email-fenghua.yu@intel.com> <1320444241-834-3-git-send-email-fenghua.yu@intel.com>
In-Reply-To: <1320444241-834-3-git-send-email-fenghua.yu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11110500-5140-0000-0000-00000029FA23
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2011 03:33 AM, Fenghua Yu wrote:
> From: Fenghua Yu <fenghua.yu@intel.com>
> 
> Because resume from hibernate and suspend always starts from CPU0 on x86 BIOS,
> we need to check if CPU0 is online before hibernate or suspend. This causes a
> race condition on cpu_online_map.
> 
> To cope with the race condition, we add arch_cpu_maps_update_begin() and
> arch_cpu_maps_update_done() during cpu_down() and cpu_up(). The functions are
> empty on non x86 platforms and are overriden on x86 platforms with real
> functions to deal with the race condition.
> 

The race between CPU Hotplug and suspend/hibernate has been taken care of by
my patch here (for another usecase): https://lkml.org/lkml/2011/11/2/487
This is not yet in mainline, but in linux-pm/linux-next.
Please see if this solves your case too. And please CC linux-pm mailing list
(linux-pm@vger.kernel.org) on patches related to power management.

> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> ---
>  kernel/cpu.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/cpu.c b/kernel/cpu.c
> index 12b7458..4d80365 100644
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -20,6 +20,14 @@
>  /* Serializes the updates to cpu_online_mask, cpu_present_mask */
>  static DEFINE_MUTEX(cpu_add_remove_lock);
> 
> +void __weak arch_cpu_maps_update_begin(void)
> +{
> +}
> +
> +void __weak arch_cpu_maps_update_done(void)
> +{
> +}
> +
>  /*
>   * The following two API's must be used when attempting
>   * to serialize the updates to cpu_online_mask, cpu_present_mask.
> @@ -274,6 +282,7 @@ int __ref cpu_down(unsigned int cpu)
>  	int err;
> 
>  	cpu_maps_update_begin();
> +	arch_cpu_maps_update_begin();
> 
>  	if (cpu_hotplug_disabled) {
>  		err = -EBUSY;
> @@ -284,6 +293,7 @@ int __ref cpu_down(unsigned int cpu)
> 
>  out:
>  	cpu_maps_update_done();
> +	arch_cpu_maps_update_done();
>  	return err;
>  }

See my comments above about whether this is really necessary.
By the way, the locking/unlocking order here seems rather weird to me.
Why have you not chosen to do something like:

cpu_maps_update_begin()
arch_cpu_maps_update_begin()
...
arch_cpu_maps_update_done()
cpu_maps_update_done()


>  EXPORT_SYMBOL(cpu_down);
> @@ -367,6 +377,7 @@ int __cpuinit cpu_up(unsigned int cpu)
>  #endif
> 
>  	cpu_maps_update_begin();
> +	arch_cpu_maps_update_begin();
> 
>  	if (cpu_hotplug_disabled) {
>  		err = -EBUSY;
> @@ -377,6 +388,7 @@ int __cpuinit cpu_up(unsigned int cpu)
> 
>  out:
>  	cpu_maps_update_done();
> +	arch_cpu_maps_update_done();
>  	return err;

Same here. See my comments above.

Thanks,
Srivatsa S. Bhat

