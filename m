Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711Ab0K3USU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 15:18:20 -0500
Received: from mga02.intel.com ([134.134.136.20]:32359 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905Ab0K3UST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 15:18:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,281,1288594800"; 
   d="scan'208";a="682487475"
Subject: Re: [PATCH 1/2] dmar: fix fault interrupt setup
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "indou.takao@jp.fujitsu.com" <indou.takao@jp.fujitsu.com>
In-Reply-To: <4CF4B628.7060903@jp.fujitsu.com>
References: <4CF4B597.4030708@jp.fujitsu.com>
	 <4CF4B628.7060903@jp.fujitsu.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 30 Nov 2010 12:18:24 -0800
Message-Id: <1291148304.5836.1.camel@sbsiddha-MOBL3>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-30 at 00:30 -0800, Kenji Kaneshige wrote: 
> Fix the problem dmar fault event is not notified in x2apic cluster mode.
> 
> In the current code, dmar fault event is configured before setting up
> the x86_cpu_to_logical_apicid percpu variable in x2apic cluster
> mode. Because of this, invalid apic ID is used for dmar fault
> interrupt and this cuases the problem.
> 
> To fix the problem, do dmar fault event configuration after local apic
> setup (after end_local_APIC_setup()).
> 
> Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> 
> 
> ---
>  arch/x86/kernel/apic/apic.c     |    9 +++++++++
>  arch/x86/kernel/apic/probe_64.c |    7 -------
>  2 files changed, 9 insertions(+), 7 deletions(-)
> 
> Index: linux-next-20101125/arch/x86/kernel/apic/apic.c
> ===================================================================
> --- linux-next-20101125.orig/arch/x86/kernel/apic/apic.c
> +++ linux-next-20101125/arch/x86/kernel/apic/apic.c
> @@ -1745,6 +1745,15 @@ int __init APIC_init_uniprocessor(void)
>  
>  	end_local_APIC_setup();
>  
> +#ifdef CONFIG_INTR_REMAP
> +	/*
> +	 * Now that local APIC setup is completed, configure the fault
> +	 * handling for interrupt remapping.
> +	 */
> +	if (intr_remapping_enabled)
> +		enable_drhd_fault_handling();
> +#endif

BTW, this is wrong. APIC_init_uniprocessor() gets called only for UP
kernel. I will move it to the end_local_APIC_setup()

> +
>  #ifdef CONFIG_X86_IO_APIC
>  	if (smp_found_config && !skip_ioapic_setup && nr_ioapics)
>  		setup_IO_APIC();
> Index: linux-next-20101125/arch/x86/kernel/apic/probe_64.c
> ===================================================================
> --- linux-next-20101125.orig/arch/x86/kernel/apic/probe_64.c
> +++ linux-next-20101125/arch/x86/kernel/apic/probe_64.c
> @@ -79,13 +79,6 @@ void __init default_setup_apic_routing(v
>  		/* need to update phys_pkg_id */
>  		apic->phys_pkg_id = apicid_phys_pkg_id;
>  	}
> -
> -	/*
> -	 * Now that apic routing model is selected, configure the
> -	 * fault handling for intr remapping.
> -	 */
> -	if (intr_remapping_enabled)
> -		enable_drhd_fault_handling();
>  }
>  
>  /* Same for both flat and physical. */
> 
> 

