Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684Ab0KKUoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 15:44:18 -0500
Received: from mga11.intel.com ([192.55.52.93]:9002 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754378Ab0KKUoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 15:44:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,184,1288594800"; 
   d="scan'208";a="625903838"
Subject: Re: [RFC -tip] x86, apic: Merge x2apic code
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20101110192053.GA6978@lenovo>
References: <20101110192053.GA6978@lenovo>
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 11 Nov 2010 12:44:17 -0800
Message-Id: <1289508257.2680.182.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-10 at 11:20 -0800, Cyrill Gorcunov wrote:
> Hi, while being at x2apic_x.c code I noted that files look similar to
> each other so I guessed may be we could merge them. As result --
> this patch.

BTW, as you noticed, x2apic cluster mode allows IPI's to be sent to
multiple cpu's (in the same cluster) at once. I was hoping sometime I
will do this to see if it helps in anything.

So once we do that IPI code will look different.

>  So comments/complains are appreciated and what is more important -- if we need
> this patch at all.

May be we can do the merge for most of them but leave IPI code as it is
(as that is also in the hot path). And may be while we are at this, we
should probably look at the x2apic cluster IPI bits now aswell.

thanks,
suresh

> 
> Thanks,
>   Cyrill
> ---
> x86, apic: Merge x2apic code
> 
> Both x2apic clustered and physical mode apic drivers
> have the number of same procedures. In a sake of shrinking
> code and eliminating duplication -- merge them into one
> x2apic.c.
> 
> The key moments of the patch:
> 
>  - x2apic_dest_mode and x2apic_cpu_to_apicid helpers are introduced,
>    they are simply inline wrappers over x2apic_phys variable
>    (which in turn an eraly_param).
> 
>  - send_IPI functions now obtain destination apicid and
>    desination mode from x2apic_dest_mode and x2apic_cpu_to_apicid
>    helpers.
> 
>    This actually has a side effect -- x2apic_cpu_to_apicid called in
>    for_each_cpu(query_cpu, mask) cycle and do test for x2apic_phys
>    variable at every iteration so I presume we might need to switch
>    to jump-labels (are they ready to use?) though I think this doesn't
>    introduce some sensible overhead even in current form
> 
>  - x2apic_send_IPI_all become a wrapper over x2apic_send_IPI_mask
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> CC: Suresh Siddha <suresh.b.siddha@intel.com>
> CC: Yinghai Lu <yinghai@kernel.org>
> CC: Thomas Gleixner <tglx@linutronix.de>
> ---
>  arch/x86/kernel/apic/Makefile         |    3
>  arch/x86/kernel/apic/x2apic.c         |  312 ++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/apic/x2apic_cluster.c |  244 --------------------------
>  arch/x86/kernel/apic/x2apic_phys.c    |  233 -------------------------
>  4 files changed, 313 insertions(+), 479 deletions(-)
> 
> Index: linux-2.6.git/arch/x86/kernel/apic/Makefile
> =====================================================================
> --- linux-2.6.git.orig/arch/x86/kernel/apic/Makefile
> +++ linux-2.6.git/arch/x86/kernel/apic/Makefile
> @@ -13,8 +13,7 @@ obj-$(CONFIG_SMP)             += ipi.o
> 
>  ifeq ($(CONFIG_X86_64),y)
>  obj-y                          += apic_flat_64.o
> -obj-$(CONFIG_X86_X2APIC)       += x2apic_cluster.o
> -obj-$(CONFIG_X86_X2APIC)       += x2apic_phys.o
> +obj-$(CONFIG_X86_X2APIC)       += x2apic.o
>  obj-$(CONFIG_X86_UV)           += x2apic_uv_x.o
>  endif
> 
> Index: linux-2.6.git/arch/x86/kernel/apic/x2apic.c
> =====================================================================
> --- /dev/null
> +++ linux-2.6.git/arch/x86/kernel/apic/x2apic.c
> @@ -0,0 +1,312 @@
> +/*
> + * APIC driver for "x2apic" cluster and physical mode
> + */
> +
> +#include <linux/threads.h>
> +#include <linux/cpumask.h>
> +#include <linux/string.h>
> +#include <linux/kernel.h>
> +#include <linux/ctype.h>
> +#include <linux/init.h>
> +#include <linux/dmar.h>
> +
> +#include <asm/smp.h>
> +#include <asm/apic.h>
> +#include <asm/ipi.h>
> +
> +static DEFINE_PER_CPU(u32, x86_cpu_to_logical_apicid);
> +
> +int x2apic_phys;
> +static int set_x2apic_phys_mode(char *arg)
> +{
> +       x2apic_phys = 1;
> +       return 0;
> +}
> +early_param("x2apic_phys", set_x2apic_phys_mode);
> +
> +static int x2apic_acpi_madt_oem_check_phys(char *oem_id, char *oem_table_id)
> +{
> +       if (x2apic_phys)
> +               return x2apic_enabled();
> +       else
> +               return 0;
> +}
> +
> +static int x2apic_acpi_madt_oem_check_cluster(char *oem_id, char *oem_table_id)
> +{
> +       return x2apic_enabled();
> +}
> +
> +/*
> + * need to use more than cpu 0, because we need more vectors when
> + * MSI-X are used.
> + */
> +static const struct cpumask *x2apic_target_cpus(void)
> +{
> +       return cpu_online_mask;
> +}
> +
> +/*
> + * for now each logical cpu is in its own vector allocation domain.
> + */
> +static void x2apic_vector_allocation_domain(int cpu, struct cpumask *retmask)
> +{
> +       cpumask_clear(retmask);
> +       cpumask_set_cpu(cpu, retmask);
> +}
> +
> +static void __x2apic_send_IPI_dest(unsigned int apicid, int vector, unsigned int dest)
> +{
> +       unsigned long cfg = __prepare_ICR(0, vector, dest);
> +
> +       /* we're redy to send the IPI */
> +       native_x2apic_icr_write(cfg, apicid);
> +}
> +
> +static inline unsigned int x2apic_dest_mode(void)
> +{
> +       return (x2apic_phys > 0) ? APIC_DEST_PHYSICAL : apic->dest_logical;
> +}
> +
> +static inline unsigned int x2apic_cpu_to_apicid(unsigned long cpu)
> +{
> +       return (x2apic_phys > 0) ?
> +               per_cpu(x86_cpu_to_apicid, cpu) :
> +               per_cpu(x86_cpu_to_logical_apicid, cpu);
> +}
> +
> +/*
> + * for now, we send the IPI's one by one in the cpumask.
> + *
> + * TODO: (IN CLUSTER-MODE) Based on the cpu mask, we can send
> + * the IPI's to the cluster group at once. We have 16 cpu's
> + * in a cluster. This will minimize IPI register writes.
> + */
> +static void x2apic_send_IPI_mask(const struct cpumask *mask, int vector)
> +{
> +       unsigned long query_cpu;
> +       unsigned long flags;
> +       unsigned int apicid, dest;
> +
> +       x2apic_wrmsr_fence();
> +       dest = x2apic_dest_mode();
> +
> +       local_irq_save(flags);
> +       for_each_cpu(query_cpu, mask) {
> +               apicid = x2apic_cpu_to_apicid(query_cpu);
> +               __x2apic_send_IPI_dest(apicid, vector, dest);
> +       }
> +       local_irq_restore(flags);
> +}
> +
> +static void x2apic_send_IPI_mask_allbutself(const struct cpumask *mask, int vector)
> +{
> +       unsigned long this_cpu = smp_processor_id();
> +       unsigned long query_cpu;
> +       unsigned long flags;
> +       unsigned int apicid, dest;
> +
> +       x2apic_wrmsr_fence();
> +       dest = x2apic_dest_mode();
> +
> +       local_irq_save(flags);
> +       for_each_cpu(query_cpu, mask) {
> +               if (query_cpu == this_cpu)
> +                       continue;
> +               apicid = x2apic_cpu_to_apicid(query_cpu);
> +               __x2apic_send_IPI_dest(apicid, vector, dest);
> +       }
> +       local_irq_restore(flags);
> +}
> +
> +static void x2apic_send_IPI_allbutself(int vector)
> +{
> +       x2apic_send_IPI_mask_allbutself(cpu_online_mask, vector);
> +}
> +
> +static void x2apic_send_IPI_all(int vector)
> +{
> +       x2apic_send_IPI_mask(cpu_online_mask, vector);
> +}
> +
> +static int x2apic_apic_id_registered(void)
> +{
> +       return 1;
> +}
> +
> +static unsigned int x2apic_cpu_mask_to_apicid(const struct cpumask *cpumask)
> +{
> +       /*
> +        * We're using fixed IRQ delivery, can only return one
> +        * phys/logical APIC ID. May as well be the first.
> +        */
> +       int cpu = cpumask_first(cpumask);
> +
> +       if ((unsigned)cpu >= nr_cpu_ids)
> +               return BAD_APICID;
> +
> +       return x2apic_cpu_to_apicid(cpu);
> +}
> +
> +static unsigned int
> +x2apic_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
> +                             const struct cpumask *andmask)
> +{
> +       int cpu;
> +
> +       /*
> +        * We're using fixed IRQ delivery, can only return one
> +        * phys/logical APIC ID. May as well be the first.
> +        */
> +       for_each_cpu_and(cpu, cpumask, andmask) {
> +               if (cpumask_test_cpu(cpu, cpu_online_mask))
> +                       break;
> +       }
> +
> +       return x2apic_cpu_to_apicid(cpu);
> +}
> +
> +static unsigned int x2apic_get_apic_id(unsigned long x)
> +{
> +       return x;
> +}
> +
> +static unsigned long x2apic_set_apic_id(unsigned int id)
> +{
> +       return id;
> +}
> +
> +static int x2apic_phys_pkg_id(int initial_apicid, int index_msb)
> +{
> +       return initial_apicid >> index_msb;
> +}
> +
> +static void x2apic_send_IPI_self(int vector)
> +{
> +       apic_write(APIC_SELF_IPI, vector);
> +}
> +
> +static void init_x2apic_ldr(void)
> +{
> +       if (!x2apic_phys) {
> +               /* valid for cluster mode only */
> +               int cpu = smp_processor_id();
> +               per_cpu(x86_cpu_to_logical_apicid, cpu) = apic_read(APIC_LDR);
> +       }
> +}
> +
> +struct apic apic_x2apic_cluster = {
> +       .name                           = "cluster x2apic",
> +       .probe                          = NULL,
> +       .acpi_madt_oem_check            = x2apic_acpi_madt_oem_check_cluster,
> +       .apic_id_registered             = x2apic_apic_id_registered,
> +
> +       .irq_delivery_mode              = dest_LowestPrio,
> +       .irq_dest_mode                  = 1, /* logical */
> +
> +       .target_cpus                    = x2apic_target_cpus,
> +       .disable_esr                    = 0,
> +       .dest_logical                   = APIC_DEST_LOGICAL,
> +       .check_apicid_used              = NULL,
> +       .check_apicid_present           = NULL,
> +
> +       .vector_allocation_domain       = x2apic_vector_allocation_domain,
> +       .init_apic_ldr                  = init_x2apic_ldr,
> +
> +       .ioapic_phys_id_map             = NULL,
> +       .setup_apic_routing             = NULL,
> +       .multi_timer_check              = NULL,
> +       .apicid_to_node                 = NULL,
> +       .cpu_to_logical_apicid          = NULL,
> +       .cpu_present_to_apicid          = default_cpu_present_to_apicid,
> +       .apicid_to_cpu_present          = NULL,
> +       .setup_portio_remap             = NULL,
> +       .check_phys_apicid_present      = default_check_phys_apicid_present,
> +       .enable_apic_mode               = NULL,
> +       .phys_pkg_id                    = x2apic_phys_pkg_id,
> +       .mps_oem_check                  = NULL,
> +
> +       .get_apic_id                    = x2apic_get_apic_id,
> +       .set_apic_id                    = x2apic_set_apic_id,
> +       .apic_id_mask                   = 0xFFFFFFFFu,
> +
> +       .cpu_mask_to_apicid             = x2apic_cpu_mask_to_apicid,
> +       .cpu_mask_to_apicid_and         = x2apic_cpu_mask_to_apicid_and,
> +
> +       .send_IPI_mask                  = x2apic_send_IPI_mask,
> +       .send_IPI_mask_allbutself       = x2apic_send_IPI_mask_allbutself,
> +       .send_IPI_allbutself            = x2apic_send_IPI_allbutself,
> +       .send_IPI_all                   = x2apic_send_IPI_all,
> +       .send_IPI_self                  = x2apic_send_IPI_self,
> +
> +       .trampoline_phys_low            = DEFAULT_TRAMPOLINE_PHYS_LOW,
> +       .trampoline_phys_high           = DEFAULT_TRAMPOLINE_PHYS_HIGH,
> +       .wait_for_init_deassert         = NULL,
> +       .smp_callin_clear_local_apic    = NULL,
> +       .inquire_remote_apic            = NULL,
> +
> +       .read                           = native_apic_msr_read,
> +       .write                          = native_apic_msr_write,
> +       .icr_read                       = native_x2apic_icr_read,
> +       .icr_write                      = native_x2apic_icr_write,
> +       .wait_icr_idle                  = native_x2apic_wait_icr_idle,
> +       .safe_wait_icr_idle             = native_safe_x2apic_wait_icr_idle,
> +};
> +
> +struct apic apic_x2apic_phys = {
> +       .name                           = "physical x2apic",
> +       .probe                          = NULL,
> +       .acpi_madt_oem_check            = x2apic_acpi_madt_oem_check_phys,
> +       .apic_id_registered             = x2apic_apic_id_registered,
> +
> +       .irq_delivery_mode              = dest_Fixed,
> +       .irq_dest_mode                  = 0, /* physical */
> +
> +       .target_cpus                    = x2apic_target_cpus,
> +       .disable_esr                    = 0,
> +       .dest_logical                   = 0,
> +       .check_apicid_used              = NULL,
> +       .check_apicid_present           = NULL,
> +
> +       .vector_allocation_domain       = x2apic_vector_allocation_domain,
> +       .init_apic_ldr                  = init_x2apic_ldr,
> +
> +       .ioapic_phys_id_map             = NULL,
> +       .setup_apic_routing             = NULL,
> +       .multi_timer_check              = NULL,
> +       .apicid_to_node                 = NULL,
> +       .cpu_to_logical_apicid          = NULL,
> +       .cpu_present_to_apicid          = default_cpu_present_to_apicid,
> +       .apicid_to_cpu_present          = NULL,
> +       .setup_portio_remap             = NULL,
> +       .check_phys_apicid_present      = default_check_phys_apicid_present,
> +       .enable_apic_mode               = NULL,
> +       .phys_pkg_id                    = x2apic_phys_pkg_id,
> +       .mps_oem_check                  = NULL,
> +
> +       .get_apic_id                    = x2apic_get_apic_id,
> +       .set_apic_id                    = x2apic_set_apic_id,
> +       .apic_id_mask                   = 0xFFFFFFFFu,
> +
> +       .cpu_mask_to_apicid             = x2apic_cpu_mask_to_apicid,
> +       .cpu_mask_to_apicid_and         = x2apic_cpu_mask_to_apicid_and,
> +
> +       .send_IPI_mask                  = x2apic_send_IPI_mask,
> +       .send_IPI_mask_allbutself       = x2apic_send_IPI_mask_allbutself,
> +       .send_IPI_allbutself            = x2apic_send_IPI_allbutself,
> +       .send_IPI_all                   = x2apic_send_IPI_all,
> +       .send_IPI_self                  = x2apic_send_IPI_self,
> +
> +       .trampoline_phys_low            = DEFAULT_TRAMPOLINE_PHYS_LOW,
> +       .trampoline_phys_high           = DEFAULT_TRAMPOLINE_PHYS_HIGH,
> +       .wait_for_init_deassert         = NULL,
> +       .smp_callin_clear_local_apic    = NULL,
> +       .inquire_remote_apic            = NULL,
> +
> +       .read                           = native_apic_msr_read,
> +       .write                          = native_apic_msr_write,
> +       .icr_read                       = native_x2apic_icr_read,
> +       .icr_write                      = native_x2apic_icr_write,
> +       .wait_icr_idle                  = native_x2apic_wait_icr_idle,
> +       .safe_wait_icr_idle             = native_safe_x2apic_wait_icr_idle,
> +};
> Index: linux-2.6.git/arch/x86/kernel/apic/x2apic_cluster.c
> =====================================================================
> --- linux-2.6.git.orig/arch/x86/kernel/apic/x2apic_cluster.c
> +++ /dev/null
> @@ -1,244 +0,0 @@
> -#include <linux/threads.h>
> -#include <linux/cpumask.h>
> -#include <linux/string.h>
> -#include <linux/kernel.h>
> -#include <linux/ctype.h>
> -#include <linux/init.h>
> -#include <linux/dmar.h>
> -
> -#include <asm/smp.h>
> -#include <asm/apic.h>
> -#include <asm/ipi.h>
> -
> -static DEFINE_PER_CPU(u32, x86_cpu_to_logical_apicid);
> -
> -static int x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
> -{
> -       return x2apic_enabled();
> -}
> -
> -/*
> - * need to use more than cpu 0, because we need more vectors when
> - * MSI-X are used.
> - */
> -static const struct cpumask *x2apic_target_cpus(void)
> -{
> -       return cpu_online_mask;
> -}
> -
> -/*
> - * for now each logical cpu is in its own vector allocation domain.
> - */
> -static void x2apic_vector_allocation_domain(int cpu, struct cpumask *retmask)
> -{
> -       cpumask_clear(retmask);
> -       cpumask_set_cpu(cpu, retmask);
> -}
> -
> -static void
> - __x2apic_send_IPI_dest(unsigned int apicid, int vector, unsigned int dest)
> -{
> -       unsigned long cfg;
> -
> -       cfg = __prepare_ICR(0, vector, dest);
> -
> -       /*
> -        * send the IPI.
> -        */
> -       native_x2apic_icr_write(cfg, apicid);
> -}
> -
> -/*
> - * for now, we send the IPI's one by one in the cpumask.
> - * TBD: Based on the cpu mask, we can send the IPI's to the cluster group
> - * at once. We have 16 cpu's in a cluster. This will minimize IPI register
> - * writes.
> - */
> -static void x2apic_send_IPI_mask(const struct cpumask *mask, int vector)
> -{
> -       unsigned long query_cpu;
> -       unsigned long flags;
> -
> -       x2apic_wrmsr_fence();
> -
> -       local_irq_save(flags);
> -       for_each_cpu(query_cpu, mask) {
> -               __x2apic_send_IPI_dest(
> -                       per_cpu(x86_cpu_to_logical_apicid, query_cpu),
> -                       vector, apic->dest_logical);
> -       }
> -       local_irq_restore(flags);
> -}
> -
> -static void
> - x2apic_send_IPI_mask_allbutself(const struct cpumask *mask, int vector)
> -{
> -       unsigned long this_cpu = smp_processor_id();
> -       unsigned long query_cpu;
> -       unsigned long flags;
> -
> -       x2apic_wrmsr_fence();
> -
> -       local_irq_save(flags);
> -       for_each_cpu(query_cpu, mask) {
> -               if (query_cpu == this_cpu)
> -                       continue;
> -               __x2apic_send_IPI_dest(
> -                               per_cpu(x86_cpu_to_logical_apicid, query_cpu),
> -                               vector, apic->dest_logical);
> -       }
> -       local_irq_restore(flags);
> -}
> -
> -static void x2apic_send_IPI_allbutself(int vector)
> -{
> -       unsigned long this_cpu = smp_processor_id();
> -       unsigned long query_cpu;
> -       unsigned long flags;
> -
> -       x2apic_wrmsr_fence();
> -
> -       local_irq_save(flags);
> -       for_each_online_cpu(query_cpu) {
> -               if (query_cpu == this_cpu)
> -                       continue;
> -               __x2apic_send_IPI_dest(
> -                               per_cpu(x86_cpu_to_logical_apicid, query_cpu),
> -                               vector, apic->dest_logical);
> -       }
> -       local_irq_restore(flags);
> -}
> -
> -static void x2apic_send_IPI_all(int vector)
> -{
> -       x2apic_send_IPI_mask(cpu_online_mask, vector);
> -}
> -
> -static int x2apic_apic_id_registered(void)
> -{
> -       return 1;
> -}
> -
> -static unsigned int x2apic_cpu_mask_to_apicid(const struct cpumask *cpumask)
> -{
> -       /*
> -        * We're using fixed IRQ delivery, can only return one logical APIC ID.
> -        * May as well be the first.
> -        */
> -       int cpu = cpumask_first(cpumask);
> -
> -       if ((unsigned)cpu < nr_cpu_ids)
> -               return per_cpu(x86_cpu_to_logical_apicid, cpu);
> -       else
> -               return BAD_APICID;
> -}
> -
> -static unsigned int
> -x2apic_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
> -                             const struct cpumask *andmask)
> -{
> -       int cpu;
> -
> -       /*
> -        * We're using fixed IRQ delivery, can only return one logical APIC ID.
> -        * May as well be the first.
> -        */
> -       for_each_cpu_and(cpu, cpumask, andmask) {
> -               if (cpumask_test_cpu(cpu, cpu_online_mask))
> -                       break;
> -       }
> -
> -       return per_cpu(x86_cpu_to_logical_apicid, cpu);
> -}
> -
> -static unsigned int x2apic_cluster_phys_get_apic_id(unsigned long x)
> -{
> -       unsigned int id;
> -
> -       id = x;
> -       return id;
> -}
> -
> -static unsigned long set_apic_id(unsigned int id)
> -{
> -       unsigned long x;
> -
> -       x = id;
> -       return x;
> -}
> -
> -static int x2apic_cluster_phys_pkg_id(int initial_apicid, int index_msb)
> -{
> -       return initial_apicid >> index_msb;
> -}
> -
> -static void x2apic_send_IPI_self(int vector)
> -{
> -       apic_write(APIC_SELF_IPI, vector);
> -}
> -
> -static void init_x2apic_ldr(void)
> -{
> -       int cpu = smp_processor_id();
> -
> -       per_cpu(x86_cpu_to_logical_apicid, cpu) = apic_read(APIC_LDR);
> -}
> -
> -struct apic apic_x2apic_cluster = {
> -
> -       .name                           = "cluster x2apic",
> -       .probe                          = NULL,
> -       .acpi_madt_oem_check            = x2apic_acpi_madt_oem_check,
> -       .apic_id_registered             = x2apic_apic_id_registered,
> -
> -       .irq_delivery_mode              = dest_LowestPrio,
> -       .irq_dest_mode                  = 1, /* logical */
> -
> -       .target_cpus                    = x2apic_target_cpus,
> -       .disable_esr                    = 0,
> -       .dest_logical                   = APIC_DEST_LOGICAL,
> -       .check_apicid_used              = NULL,
> -       .check_apicid_present           = NULL,
> -
> -       .vector_allocation_domain       = x2apic_vector_allocation_domain,
> -       .init_apic_ldr                  = init_x2apic_ldr,
> -
> -       .ioapic_phys_id_map             = NULL,
> -       .setup_apic_routing             = NULL,
> -       .multi_timer_check              = NULL,
> -       .apicid_to_node                 = NULL,
> -       .cpu_to_logical_apicid          = NULL,
> -       .cpu_present_to_apicid          = default_cpu_present_to_apicid,
> -       .apicid_to_cpu_present          = NULL,
> -       .setup_portio_remap             = NULL,
> -       .check_phys_apicid_present      = default_check_phys_apicid_present,
> -       .enable_apic_mode               = NULL,
> -       .phys_pkg_id                    = x2apic_cluster_phys_pkg_id,
> -       .mps_oem_check                  = NULL,
> -
> -       .get_apic_id                    = x2apic_cluster_phys_get_apic_id,
> -       .set_apic_id                    = set_apic_id,
> -       .apic_id_mask                   = 0xFFFFFFFFu,
> -
> -       .cpu_mask_to_apicid             = x2apic_cpu_mask_to_apicid,
> -       .cpu_mask_to_apicid_and         = x2apic_cpu_mask_to_apicid_and,
> -
> -       .send_IPI_mask                  = x2apic_send_IPI_mask,
> -       .send_IPI_mask_allbutself       = x2apic_send_IPI_mask_allbutself,
> -       .send_IPI_allbutself            = x2apic_send_IPI_allbutself,
> -       .send_IPI_all                   = x2apic_send_IPI_all,
> -       .send_IPI_self                  = x2apic_send_IPI_self,
> -
> -       .trampoline_phys_low            = DEFAULT_TRAMPOLINE_PHYS_LOW,
> -       .trampoline_phys_high           = DEFAULT_TRAMPOLINE_PHYS_HIGH,
> -       .wait_for_init_deassert         = NULL,
> -       .smp_callin_clear_local_apic    = NULL,
> -       .inquire_remote_apic            = NULL,
> -
> -       .read                           = native_apic_msr_read,
> -       .write                          = native_apic_msr_write,
> -       .icr_read                       = native_x2apic_icr_read,
> -       .icr_write                      = native_x2apic_icr_write,
> -       .wait_icr_idle                  = native_x2apic_wait_icr_idle,
> -       .safe_wait_icr_idle             = native_safe_x2apic_wait_icr_idle,
> -};
> Index: linux-2.6.git/arch/x86/kernel/apic/x2apic_phys.c
> =====================================================================
> --- linux-2.6.git.orig/arch/x86/kernel/apic/x2apic_phys.c
> +++ /dev/null
> @@ -1,233 +0,0 @@
> -#include <linux/threads.h>
> -#include <linux/cpumask.h>
> -#include <linux/string.h>
> -#include <linux/kernel.h>
> -#include <linux/ctype.h>
> -#include <linux/init.h>
> -#include <linux/dmar.h>
> -
> -#include <asm/smp.h>
> -#include <asm/apic.h>
> -#include <asm/ipi.h>
> -
> -int x2apic_phys;
> -
> -static int set_x2apic_phys_mode(char *arg)
> -{
> -       x2apic_phys = 1;
> -       return 0;
> -}
> -early_param("x2apic_phys", set_x2apic_phys_mode);
> -
> -static int x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
> -{
> -       if (x2apic_phys)
> -               return x2apic_enabled();
> -       else
> -               return 0;
> -}
> -
> -/*
> - * need to use more than cpu 0, because we need more vectors when
> - * MSI-X are used.
> - */
> -static const struct cpumask *x2apic_target_cpus(void)
> -{
> -       return cpu_online_mask;
> -}
> -
> -static void x2apic_vector_allocation_domain(int cpu, struct cpumask *retmask)
> -{
> -       cpumask_clear(retmask);
> -       cpumask_set_cpu(cpu, retmask);
> -}
> -
> -static void __x2apic_send_IPI_dest(unsigned int apicid, int vector,
> -                                  unsigned int dest)
> -{
> -       unsigned long cfg;
> -
> -       cfg = __prepare_ICR(0, vector, dest);
> -
> -       /*
> -        * send the IPI.
> -        */
> -       native_x2apic_icr_write(cfg, apicid);
> -}
> -
> -static void x2apic_send_IPI_mask(const struct cpumask *mask, int vector)
> -{
> -       unsigned long query_cpu;
> -       unsigned long flags;
> -
> -       x2apic_wrmsr_fence();
> -
> -       local_irq_save(flags);
> -       for_each_cpu(query_cpu, mask) {
> -               __x2apic_send_IPI_dest(per_cpu(x86_cpu_to_apicid, query_cpu),
> -                                      vector, APIC_DEST_PHYSICAL);
> -       }
> -       local_irq_restore(flags);
> -}
> -
> -static void
> - x2apic_send_IPI_mask_allbutself(const struct cpumask *mask, int vector)
> -{
> -       unsigned long this_cpu = smp_processor_id();
> -       unsigned long query_cpu;
> -       unsigned long flags;
> -
> -       x2apic_wrmsr_fence();
> -
> -       local_irq_save(flags);
> -       for_each_cpu(query_cpu, mask) {
> -               if (query_cpu != this_cpu)
> -                       __x2apic_send_IPI_dest(
> -                               per_cpu(x86_cpu_to_apicid, query_cpu),
> -                               vector, APIC_DEST_PHYSICAL);
> -       }
> -       local_irq_restore(flags);
> -}
> -
> -static void x2apic_send_IPI_allbutself(int vector)
> -{
> -       unsigned long this_cpu = smp_processor_id();
> -       unsigned long query_cpu;
> -       unsigned long flags;
> -
> -       x2apic_wrmsr_fence();
> -
> -       local_irq_save(flags);
> -       for_each_online_cpu(query_cpu) {
> -               if (query_cpu == this_cpu)
> -                       continue;
> -               __x2apic_send_IPI_dest(per_cpu(x86_cpu_to_apicid, query_cpu),
> -                                      vector, APIC_DEST_PHYSICAL);
> -       }
> -       local_irq_restore(flags);
> -}
> -
> -static void x2apic_send_IPI_all(int vector)
> -{
> -       x2apic_send_IPI_mask(cpu_online_mask, vector);
> -}
> -
> -static int x2apic_apic_id_registered(void)
> -{
> -       return 1;
> -}
> -
> -static unsigned int x2apic_cpu_mask_to_apicid(const struct cpumask *cpumask)
> -{
> -       /*
> -        * We're using fixed IRQ delivery, can only return one phys APIC ID.
> -        * May as well be the first.
> -        */
> -       int cpu = cpumask_first(cpumask);
> -
> -       if ((unsigned)cpu < nr_cpu_ids)
> -               return per_cpu(x86_cpu_to_apicid, cpu);
> -       else
> -               return BAD_APICID;
> -}
> -
> -static unsigned int
> -x2apic_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
> -                             const struct cpumask *andmask)
> -{
> -       int cpu;
> -
> -       /*
> -        * We're using fixed IRQ delivery, can only return one phys APIC ID.
> -        * May as well be the first.
> -        */
> -       for_each_cpu_and(cpu, cpumask, andmask) {
> -               if (cpumask_test_cpu(cpu, cpu_online_mask))
> -                       break;
> -       }
> -
> -       return per_cpu(x86_cpu_to_apicid, cpu);
> -}
> -
> -static unsigned int x2apic_phys_get_apic_id(unsigned long x)
> -{
> -       return x;
> -}
> -
> -static unsigned long set_apic_id(unsigned int id)
> -{
> -       return id;
> -}
> -
> -static int x2apic_phys_pkg_id(int initial_apicid, int index_msb)
> -{
> -       return initial_apicid >> index_msb;
> -}
> -
> -static void x2apic_send_IPI_self(int vector)
> -{
> -       apic_write(APIC_SELF_IPI, vector);
> -}
> -
> -static void init_x2apic_ldr(void)
> -{
> -}
> -
> -struct apic apic_x2apic_phys = {
> -
> -       .name                           = "physical x2apic",
> -       .probe                          = NULL,
> -       .acpi_madt_oem_check            = x2apic_acpi_madt_oem_check,
> -       .apic_id_registered             = x2apic_apic_id_registered,
> -
> -       .irq_delivery_mode              = dest_Fixed,
> -       .irq_dest_mode                  = 0, /* physical */
> -
> -       .target_cpus                    = x2apic_target_cpus,
> -       .disable_esr                    = 0,
> -       .dest_logical                   = 0,
> -       .check_apicid_used              = NULL,
> -       .check_apicid_present           = NULL,
> -
> -       .vector_allocation_domain       = x2apic_vector_allocation_domain,
> -       .init_apic_ldr                  = init_x2apic_ldr,
> -
> -       .ioapic_phys_id_map             = NULL,
> -       .setup_apic_routing             = NULL,
> -       .multi_timer_check              = NULL,
> -       .apicid_to_node                 = NULL,
> -       .cpu_to_logical_apicid          = NULL,
> -       .cpu_present_to_apicid          = default_cpu_present_to_apicid,
> -       .apicid_to_cpu_present          = NULL,
> -       .setup_portio_remap             = NULL,
> -       .check_phys_apicid_present      = default_check_phys_apicid_present,
> -       .enable_apic_mode               = NULL,
> -       .phys_pkg_id                    = x2apic_phys_pkg_id,
> -       .mps_oem_check                  = NULL,
> -
> -       .get_apic_id                    = x2apic_phys_get_apic_id,
> -       .set_apic_id                    = set_apic_id,
> -       .apic_id_mask                   = 0xFFFFFFFFu,
> -
> -       .cpu_mask_to_apicid             = x2apic_cpu_mask_to_apicid,
> -       .cpu_mask_to_apicid_and         = x2apic_cpu_mask_to_apicid_and,
> -
> -       .send_IPI_mask                  = x2apic_send_IPI_mask,
> -       .send_IPI_mask_allbutself       = x2apic_send_IPI_mask_allbutself,
> -       .send_IPI_allbutself            = x2apic_send_IPI_allbutself,
> -       .send_IPI_all                   = x2apic_send_IPI_all,
> -       .send_IPI_self                  = x2apic_send_IPI_self,
> -
> -       .trampoline_phys_low            = DEFAULT_TRAMPOLINE_PHYS_LOW,
> -       .trampoline_phys_high           = DEFAULT_TRAMPOLINE_PHYS_HIGH,
> -       .wait_for_init_deassert         = NULL,
> -       .smp_callin_clear_local_apic    = NULL,
> -       .inquire_remote_apic            = NULL,
> -
> -       .read                           = native_apic_msr_read,
> -       .write                          = native_apic_msr_write,
> -       .icr_read                       = native_x2apic_icr_read,
> -       .icr_write                      = native_x2apic_icr_write,
> -       .wait_icr_idle                  = native_x2apic_wait_icr_idle,
> -       .safe_wait_icr_idle             = native_safe_x2apic_wait_icr_idle,
> -};

