Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100Ab2BGRnz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 12:43:55 -0500
Received: from www.linutronix.de ([62.245.132.108]:55515 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563Ab2BGRnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 12:43:53 -0500
Date: Tue, 7 Feb 2012 18:43:46 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Igor Mammedov <imammedo@redhat.com>
cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, jacob.jun.pan@linux.intel.com,
        alan@linux.intel.com, feng.tang@intel.com, konrad.wilk@oracle.com,
        avi@redhat.com, glommer@redhat.com, johnstul@us.ibm.com,
        riel@redhat.com, tj@kernel.org, kosaki.motohiro@jp.fujitsu.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH] Introduce x86_cpuinit.early_percpu_clock_init hook
In-Reply-To: <1328626364-22591-1-git-send-email-imammedo@redhat.com>
Message-ID: <alpine.LFD.2.02.1202071808340.2794@ionos>
References: <1328626364-22591-1-git-send-email-imammedo@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Feb 2012, Igor Mammedov wrote:

> When kvm guest uses kvmclock, it may hang on vcpu hot-plug.
> This is caused by an overflow in pvclock_get_nsec_offset,
> 
>     u64 delta = tsc - shadow->tsc_timestamp;
> 
> which in turn is caused by an undefined values from percpu
> hv_clock that hasn't been initialized yet.
> Uninitialized clock on being booted cpu is accessed from
>    start_secondary
>     -> smp_callin
>       ->  smp_store_cpu_info
>         -> identify_secondary_cpu
>           -> mtrr_ap_init
>             -> mtrr_restore
>               -> stop_machine_from_inactive_cpu
>                 -> queue_stop_cpus_work
>                   ...
>                     -> sched_clock
>                       -> kvm_clock_read
> which is well before x86_cpuinit.setup_percpu_clockev call in
> start_secondary, where percpu clock is initialized.
> 
> This patch introduces a hook that allows to setup/initialize
> per_cpu clock early and avoid overflow due to reading
>   - undefined values
>   - old values if cpu was offlined and then onlined again
> 
> Another possible early user of this clock source is ftrace that
> accesses it to get timestamps for ring buffer entries. So if
> mtrr_ap_init is moved from identify_secondary_cpu to past
> x86_cpuinit.setup_percpu_clockev in start_secondary, ftrace
> may cause the same overflow/hang on cpu hot-plug anyway.
> 
> More complete description of the problem:
>   https://lkml.org/lkml/2012/2/2/101
> 
> Credits to Marcelo Tosatti <mtosatti@redhat.com> for hook idea.
> 
> Signed-off-by: Igor Mammedov <imammedo@redhat.com>
> ---
>  arch/x86/include/asm/x86_init.h |    2 ++
>  arch/x86/kernel/kvmclock.c      |    4 +---
>  arch/x86/kernel/smpboot.c       |    1 +
>  arch/x86/kernel/x86_init.c      |    1 +
>  4 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
> index 517d476..5d0afac 100644
> --- a/arch/x86/include/asm/x86_init.h
> +++ b/arch/x86/include/asm/x86_init.h
> @@ -145,9 +145,11 @@ struct x86_init_ops {
>  /**
>   * struct x86_cpuinit_ops - platform specific cpu hotplug setups
>   * @setup_percpu_clockev:	set up the per cpu clock event device
> + * @early_percpu_clock_init:	early init of the per cpu clock event device

You initialize the per cpu clock, not the per cpu clock event
device. The latter is still initialized via setup_percpu_clockev().

Otherwise 

Acked-by: Thomas Gleixner <tglx@linutronix.de>

