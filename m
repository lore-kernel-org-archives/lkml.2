Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab2CPSAS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 14:00:18 -0400
Received: from mga14.intel.com ([143.182.124.37]:23040 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754104Ab2CPSAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 14:00:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="78446180"
Subject: Re: [PATCH] Use x2apic_supported() in the default_apic_id_valid()
 function.
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Steffen Persvold <sp@numascale.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Daniel J Blueman <daniel@numascale-asia.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Date: Fri, 16 Mar 2012 11:01:01 -0700
In-Reply-To: <CAE9FiQXfJthSt=-FiYbc00MzyRcfZ=RacxRQRGk83VpZH70dOQ@mail.gmail.com>
References: <CAE9FiQXC7T7JQRfiry8nHaRYN3ggy9vfzc2jDUzar80hv6pEvw@mail.gmail.com>
	 <1331834583-16070-1-git-send-email-sp@numascale.com>
	 <CAE9FiQUh-kEcLLAZYiy90UJY8-WmXTKhYrjS7HQ40U+Ah2dwNg@mail.gmail.com>
	 <1331846504.16101.12.camel@sbsiddha-desk.sc.intel.com>
	 <CAE9FiQXXy3UDFpm5uCmpnn7Q53FhQN6h-BSAizgk_Sqkg+d4bA@mail.gmail.com>
	 <CAE9FiQUtf9Pix3rmhgk_+oOf19dOvvgQYt+gbHQyag0xkH_bxA@mail.gmail.com>
	 <4F62E417.40905@numascale.com>
	 <CAE9FiQXfJthSt=-FiYbc00MzyRcfZ=RacxRQRGk83VpZH70dOQ@mail.gmail.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1331920862.16101.41.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-16 at 09:57 -0700, Yinghai Lu wrote:
> On Thu, Mar 15, 2012 at 11:56 PM, Steffen Persvold <sp@numascale.com> wrote:
> > Which one of the two patches I sent, do you (Suresh/Yinghai/others) believe
> > is the best/cleanest and works in all cases. I, unfortunately, can't test
> > the Intel case as I don't have any available to test on :/
> >
> > Either patch works fine for NumaChip enabled systems.
> >
> > If desired I will re-post the patch with the approach you find best, but add
> > the apic->apic_id_valid() check in the SRAT code aswell.
> 
> Ok, let use second way that Suresh proposed, please repost that
> without removing checking in srat.
> 
> should like:
> 
> From: Steffen Persvold <sp@numascale.com>
> Subject: [PATCH] Added separate apic_id_valid() functions for selected
> apic drivers
> 
> This allows us to substitute the check in
> arch/x86/kernel/acpi/boot.c::acpi_parse_x2apic and avoid feigning the
> x2apic cpu feature in the NumaChip apic code.
> 
> The following apic drivers have separate apic_id_valid() functions
> which will accept x2apic type IDs :
> 
> x2apic_phys
> x2apic_cluster
> x2apic_uv_x
> apic_numachip
> 
> Signed-off-by: Steffen Persvold <sp@numascale.com>

I have no complaints with this version ;)

Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

> ---
>  arch/x86/include/asm/apic.h           |    2 +-
>  arch/x86/include/asm/x2apic.h         |    5 +++++
>  arch/x86/kernel/acpi/boot.c           |    2 +-
>  arch/x86/kernel/apic/apic_numachip.c  |    3 +--
>  arch/x86/kernel/apic/x2apic_cluster.c |    2 +-
>  arch/x86/kernel/apic/x2apic_phys.c    |    2 +-
>  arch/x86/kernel/apic/x2apic_uv_x.c    |    7 ++++++-
>  arch/x86/mm/srat.c                    |    2 +-
>  8 files changed, 17 insertions(+), 8 deletions(-)
> 
> Index: linux-2.6/arch/x86/include/asm/apic.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/asm/apic.h
> +++ linux-2.6/arch/x86/include/asm/apic.h
> @@ -535,7 +535,7 @@ static inline unsigned int read_apic_id(
> 
>  static inline int default_apic_id_valid(int apicid)
>  {
> -	return x2apic_mode || (apicid < 255);
> +	return (apicid < 255);
>  }
> 
>  extern void default_setup_apic_routing(void);
> Index: linux-2.6/arch/x86/include/asm/x2apic.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/asm/x2apic.h
> +++ linux-2.6/arch/x86/include/asm/x2apic.h
> @@ -18,6 +18,11 @@ static const struct cpumask *x2apic_targ
>  	return cpu_online_mask;
>  }
> 
> +static int x2apic_apic_id_valid(int apicid)
> +{
> +	return 1;
> +}
> +
>  static int x2apic_apic_id_registered(void)
>  {
>  	return 1;
> Index: linux-2.6/arch/x86/kernel/acpi/boot.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/acpi/boot.c
> +++ linux-2.6/arch/x86/kernel/acpi/boot.c
> @@ -227,7 +227,7 @@ acpi_parse_x2apic(struct acpi_subtable_h
>  	 * to not preallocating memory for all NR_CPUS
>  	 * when we use CPU hotplug.
>  	 */
> -	if (!cpu_has_x2apic && (apic_id >= 0xff) && enabled)
> +	if (!apic->apic_id_valid(apic_id) && enabled)
>  		printk(KERN_WARNING PREFIX "x2apic entry ignored\n");
>  	else
>  		acpi_register_lapic(apic_id, enabled);
> Index: linux-2.6/arch/x86/kernel/apic/apic_numachip.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/apic/apic_numachip.c
> +++ linux-2.6/arch/x86/kernel/apic/apic_numachip.c
> @@ -229,11 +229,10 @@ static int __init numachip_system_init(v
>  }
>  early_initcall(numachip_system_init);
> 
> -static int __cpuinit numachip_acpi_madt_oem_check(char *oem_id, char
> *oem_table_id)
> +static int numachip_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
>  {
>  	if (!strncmp(oem_id, "NUMASC", 6)) {
>  		numachip_system = 1;
> -		setup_force_cpu_cap(X86_FEATURE_X2APIC);
>  		return 1;
>  	}
> 
> Index: linux-2.6/arch/x86/kernel/apic/x2apic_cluster.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/apic/x2apic_cluster.c
> +++ linux-2.6/arch/x86/kernel/apic/x2apic_cluster.c
> @@ -218,7 +218,7 @@ static struct apic apic_x2apic_cluster =
>  	.name				= "cluster x2apic",
>  	.probe				= x2apic_cluster_probe,
>  	.acpi_madt_oem_check		= x2apic_acpi_madt_oem_check,
> -	.apic_id_valid			= default_apic_id_valid,
> +	.apic_id_valid			= x2apic_apic_id_valid,
>  	.apic_id_registered		= x2apic_apic_id_registered,
> 
>  	.irq_delivery_mode		= dest_LowestPrio,
> Index: linux-2.6/arch/x86/kernel/apic/x2apic_phys.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/apic/x2apic_phys.c
> +++ linux-2.6/arch/x86/kernel/apic/x2apic_phys.c
> @@ -119,7 +119,7 @@ static struct apic apic_x2apic_phys = {
>  	.name				= "physical x2apic",
>  	.probe				= x2apic_phys_probe,
>  	.acpi_madt_oem_check		= x2apic_acpi_madt_oem_check,
> -	.apic_id_valid			= default_apic_id_valid,
> +	.apic_id_valid			= x2apic_apic_id_valid,
>  	.apic_id_registered		= x2apic_apic_id_registered,
> 
>  	.irq_delivery_mode		= dest_Fixed,
> Index: linux-2.6/arch/x86/kernel/apic/x2apic_uv_x.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/apic/x2apic_uv_x.c
> +++ linux-2.6/arch/x86/kernel/apic/x2apic_uv_x.c
> @@ -266,6 +266,11 @@ static void uv_send_IPI_all(int vector)
>  	uv_send_IPI_mask(cpu_online_mask, vector);
>  }
> 
> +static int uv_apic_id_valid(int apicid)
> +{
> +	return 1;
> +}
> +
>  static int uv_apic_id_registered(void)
>  {
>  	return 1;
> @@ -351,7 +356,7 @@ static struct apic __refdata apic_x2apic
>  	.name				= "UV large system",
>  	.probe				= uv_probe,
>  	.acpi_madt_oem_check		= uv_acpi_madt_oem_check,
> -	.apic_id_valid			= default_apic_id_valid,
> +	.apic_id_valid			= uv_apic_id_valid,
>  	.apic_id_registered		= uv_apic_id_registered,
> 
>  	.irq_delivery_mode		= dest_Fixed,
> Index: linux-2.6/arch/x86/mm/srat.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/mm/srat.c
> +++ linux-2.6/arch/x86/mm/srat.c
> @@ -70,7 +70,7 @@ acpi_numa_x2apic_affinity_init(struct ac
>  		return;
>  	pxm = pa->proximity_domain;
>  	apic_id = pa->apic_id;
> -	if (!cpu_has_x2apic && (apic_id >= 0xff)) {
> +	if (!apic->apic_id_valid(apic_id)) {
>  		printk(KERN_INFO "SRAT: PXM %u -> X2APIC 0x%04x ignored\n",
>  			 pxm, apic_id);
>  		return;


