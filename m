Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738Ab0KLKAg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 05:00:36 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:18241 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246Ab0KLKAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 05:00:35 -0500
Message-ID: <4CDD0FD0.1020807@kernel.org>
Date: Fri, 12 Nov 2010 01:58:40 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101026 SUSE/3.0.10 Thunderbird/3.0.10
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH UPDATED 4/9] x86: Initialize 32bit logical apicid mapping
 early during boot
References: <1289473363-29440-1-git-send-email-tj@kernel.org> <1289473363-29440-5-git-send-email-tj@kernel.org> <4CDD0B1F.4060701@kernel.org>
In-Reply-To: <4CDD0B1F.4060701@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2010 01:38 AM, Tejun Heo wrote:
> On x86_32, non-standard logical apicid mapping can be used by
> different NUMA setups and the mapping is queried while bringing up
> each CPU using apic->cpu_to_logical_apicid() to build
> cpu_2_logical_apicid[] array.  The logical apicid is then used to
> deliver IPIs and determine NUMA configuration.
> 
> Unfortunately, initializing at SMP bring up is too late for percpu
> setup making static percpu variables setup w/o considering NUMA.  This
> also is different from how x86_64 is configured making the code
> difficult to follow and maintain.
> 
> This patch updates logical apicid mapping handling such that,
> 
> * early_percpu variable x86_cpu_to_logical_apicid replaces
>   cpu_2_logical_apicid[].
> 
> * apic->cpu_to_logical_apicid() is called once during get_smp_config()
>   and the output is recorded in x86_cpu_to_logical_apicid.
> 
> * apic->cpu_to_logical_apicid() is allowed to return BAD_APICID if it
>   can't determine the value that early during boot.  In this case, the
>   mapping will be initialized during SMP bring up by reading APIC LDR
>   as before.
> 
> - Brian Gerst spotted that setup_per_cpu_areas() was not copying the
>   early x86_cpu_to_logical_apicid to the permanent percpu area and
>   es7000_32 is using per_cpu() instead of early_per_cpu(), which in
>   itself is not incorrect as they're never used before setup_per_cpu()
>   but still confusing.  Both updated.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Brian Gerst <brgerst@gmail.com>
> ---
> Updated as per Brian's comment.  The rest of the patchset apply okay
> on top of this change.  The git tree is updated accordingly.
> 
> Thanks.
> 
>  arch/x86/include/asm/apic.h      |   18 +++++++++++++-----
>  arch/x86/include/asm/smp.h       |    3 +++
>  arch/x86/kernel/apic/apic.c      |   36 ++++++++++++++++++++++++++++--------
>  arch/x86/kernel/apic/bigsmp_32.c |   26 ++++++++++++++------------
>  arch/x86/kernel/apic/es7000_32.c |   27 ++++++++++-----------------
>  arch/x86/kernel/apic/ipi.c       |    8 ++++----
>  arch/x86/kernel/apic/numaq_32.c  |   15 +++++++--------
>  arch/x86/kernel/apic/summit_32.c |   36 ++++++++++++++++--------------------
>  arch/x86/kernel/setup_percpu.c   |    7 +++++++
>  arch/x86/kernel/smpboot.c        |   10 +++-------
>  10 files changed, 105 insertions(+), 81 deletions(-)
> 
> Index: work/arch/x86/kernel/apic/apic.c
> ===================================================================
> --- work.orig/arch/x86/kernel/apic/apic.c
> +++ work/arch/x86/kernel/apic/apic.c
> @@ -1202,6 +1207,7 @@ static void __cpuinit lapic_setup_esr(vo
>   */
>  void __cpuinit setup_local_APIC(void)
>  {
> +	int cpu = smp_processor_id();
>  	unsigned int value, queued;
>  	int i, j, acked = 0;
>  	unsigned long long tsc = 0, ntsc;
> @@ -1343,21 +1362,19 @@ void __cpuinit setup_local_APIC(void)
>  	 * TODO: set up through-local-APIC from through-I/O-APIC? --macro
>  	 */
>  	value = apic_read(APIC_LVT0) & APIC_LVT_MASKED;
> -	if (!smp_processor_id() && (pic_mode || !value)) {
> +	if (!cpu && (pic_mode || !value)) {
>  		value = APIC_DM_EXTINT;
> -		apic_printk(APIC_VERBOSE, "enabled ExtINT on CPU#%d\n",
> -				smp_processor_id());
> +		apic_printk(APIC_VERBOSE, "enabled ExtINT on CPU#%d\n", cpu);
>  	} else {
>  		value = APIC_DM_EXTINT | APIC_LVT_MASKED;
> -		apic_printk(APIC_VERBOSE, "masked ExtINT on CPU#%d\n",
> -				smp_processor_id());
> +		apic_printk(APIC_VERBOSE, "masked ExtINT on CPU#%d\n", cpu);
>  	}
>  	apic_write(APIC_LVT0, value);
> 
>  	/*
>  	 * only the BP should see the LINT1 NMI signal, obviously.
>  	 */
> -	if (!smp_processor_id())
> +	if (!cpu)
>  		value = APIC_DM_NMI;
>  	else
>  		value = APIC_DM_NMI | APIC_LVT_MASKED;
> @@ -1369,7 +1386,7 @@ void __cpuinit setup_local_APIC(void)
> 
>  #ifdef CONFIG_X86_MCE_INTEL
>  	/* Recheck CMCI information after local APIC is up on CPU #0 */
> -	if (smp_processor_id() == 0)
> +	if (cpu == 0)
>  		cmci_recheck();
>  #endif
>  }

those replacing smp_processor_id() with cpu should be in another patch.

Thanks

	Yinghai
