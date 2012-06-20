Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608Ab2FTF4b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 01:56:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61853 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320Ab2FTF4a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 01:56:30 -0400
MIME-Version: 1.0
In-Reply-To: <1340149411-2972-2-git-send-email-suresh.b.siddha@intel.com>
References: <1340067097.3696.6.camel@sbsiddha-desk.sc.intel.com>
	<1340149411-2972-1-git-send-email-suresh.b.siddha@intel.com>
	<1340149411-2972-2-git-send-email-suresh.b.siddha@intel.com>
Date: Tue, 19 Jun 2012 22:56:29 -0700
X-Google-Sender-Auth: OV6vP-frM-6DeiLyDWCm_kAUShA
Message-ID: <CAE9FiQWsx9smPtca-w83g91q8eb5BBJ+wNenjxKNAFFgYO=Abw@mail.gmail.com>
Subject: Re: [PATCH 2/2] x86, x2apic: limit the vector reservation to the user
 specified mask
From: Yinghai Lu <yinghai@kernel.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Alexander Gordeev <agordeev@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, x86@kernel.org, gorcunov@openvz.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 4:43 PM, Suresh Siddha
<suresh.b.siddha@intel.com> wrote:
> For the x2apic cluster mode, vector for an interrupt is currently reserved on
> all the cpu's that are part of the x2apic cluster. But the interrupts will
> be routed only to the cluster (derived from the first cpu in the mask) members
> specified in the mask. So there is no need to reserve the vector in the unused
> cluster members.
>
> Modify __assign_irq_vector() to reserve the vectors based on the user
> specified irq destination mask and the corresponding vector domain specified
> by the apic driver.
>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> ---
>  arch/x86/include/asm/apic.h           |   14 +++++++++---
>  arch/x86/kernel/apic/apic_noop.c      |    5 +++-
>  arch/x86/kernel/apic/io_apic.c        |   36 ++++++++++++++++++++++-----------
>  arch/x86/kernel/apic/x2apic_cluster.c |    8 ++++--
>  4 files changed, 43 insertions(+), 20 deletions(-)
>
> diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
> index b37fa12..7746acb 100644
> --- a/arch/x86/include/asm/apic.h
> +++ b/arch/x86/include/asm/apic.h
> @@ -306,7 +306,9 @@ struct apic {
>        unsigned long (*check_apicid_used)(physid_mask_t *map, int apicid);
>        unsigned long (*check_apicid_present)(int apicid);
>
> -       void (*vector_allocation_domain)(int cpu, struct cpumask *retmask);
> +       void (*vector_allocation_domain)(const struct cpumask *mask,
> +                                        struct cpumask *retmask,
> +                                        const struct cpumask *prevmask);
>        void (*init_apic_ldr)(void);
>
>        void (*ioapic_phys_id_map)(physid_mask_t *phys_map, physid_mask_t *retmap);
> @@ -615,7 +617,9 @@ default_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
>                               unsigned int *apicid);
>
>  static inline void
> -flat_vector_allocation_domain(int cpu, struct cpumask *retmask)
> +flat_vector_allocation_domain(const struct cpumask *mask,
> +                             struct cpumask *retmask,
> +                             const struct cpumask *prevmask)
>  {
>        /* Careful. Some cpus do not strictly honor the set of cpus
>         * specified in the interrupt destination when using lowest
> @@ -630,9 +634,11 @@ flat_vector_allocation_domain(int cpu, struct cpumask *retmask)
>  }
>
>  static inline void
> -default_vector_allocation_domain(int cpu, struct cpumask *retmask)
> +default_vector_allocation_domain(const struct cpumask *mask,
> +                                struct cpumask *retmask,
> +                                const struct cpumask *prevmask)
>  {
> -       cpumask_copy(retmask, cpumask_of(cpu));
> +       cpumask_copy(retmask, cpumask_of(cpumask_first(retmask)));
>  }
>
>  static inline unsigned long default_check_apicid_used(physid_mask_t *map, int apicid)
> diff --git a/arch/x86/kernel/apic/apic_noop.c b/arch/x86/kernel/apic/apic_noop.c
> index 08c337b..847ece1 100644
> --- a/arch/x86/kernel/apic/apic_noop.c
> +++ b/arch/x86/kernel/apic/apic_noop.c
> @@ -100,8 +100,11 @@ static unsigned long noop_check_apicid_present(int bit)
>        return physid_isset(bit, phys_cpu_present_map);
>  }
>
> -static void noop_vector_allocation_domain(int cpu, struct cpumask *retmask)
> +static void noop_vector_allocation_domain(const struct cpumask *mask,
> +                                         struct cpumask *retmask,
> +                                         const struct cpumask *prevmask)
>  {
> +       int cpu = cpumask_first(retmask);
>        if (cpu != 0)
>                pr_warning("APIC: Vector allocated for non-BSP cpu\n");
>        cpumask_copy(retmask, cpumask_of(cpu));
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index 7a945f8..0a55eb8 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -1097,6 +1097,22 @@ void unlock_vector_lock(void)
>        raw_spin_unlock(&vector_lock);
>  }
>
> +/*
> + * New cpu mask using the vector is a subset of the current in use mask.
> + * So cleanup the vector allocation for the members that are not used anymore.
> + */
> +static inline int
> +cleanup_unused_subset(struct cpumask *mask, struct irq_cfg *cfg)
> +{
> +       if (!cpumask_equal(mask, cfg->domain)) {
> +               cpumask_andnot(cfg->old_domain, cfg->domain, mask);
> +               cfg->move_in_progress = 1;
> +               cpumask_and(cfg->domain, cfg->domain, mask);
> +       }
> +       free_cpumask_var(mask);
> +       return 0;
> +}
> +
>  static int
>  __assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
>  {
> @@ -1126,10 +1142,9 @@ __assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
>        old_vector = cfg->vector;
>        if (old_vector) {
>                cpumask_and(tmp_mask, mask, cpu_online_mask);
> -               if (cpumask_subset(tmp_mask, cfg->domain)) {
> -                       free_cpumask_var(tmp_mask);
> -                       return 0;
> -               }
> +               apic->vector_allocation_domain(mask, tmp_mask, cfg->domain);
> +               if (cpumask_subset(tmp_mask, cfg->domain))
> +                       return cleanup_unused_subset(tmp_mask, cfg);
>        }

This whole check could be removed.

>
>        /* Only try and allocate irqs on cpus that are present */
> @@ -1137,15 +1152,12 @@ __assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
>        cpumask_clear(cfg->old_domain);
>        cpu = cpumask_first_and(mask, cpu_online_mask);
>        while (cpu < nr_cpu_ids) {
> -               int new_cpu;
> -               int vector, offset;
> +               int new_cpu, vector, offset;
>
> -               apic->vector_allocation_domain(cpu, tmp_mask);
> -
> -               if (cpumask_subset(tmp_mask, cfg->domain)) {
> -                       free_cpumask_var(tmp_mask);
> -                       return 0;
> -               }
> +               cpumask_copy(tmp_mask, cpumask_of(cpu));
> +               apic->vector_allocation_domain(mask, tmp_mask, cfg->domain);
> +               if (cpumask_subset(tmp_mask, cfg->domain))
> +                       return cleanup_unused_subset(tmp_mask, cfg);
>
>                vector = current_vector;
>                offset = current_offset;
> diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
> index b5d889b..4d49512 100644
> --- a/arch/x86/kernel/apic/x2apic_cluster.c
> +++ b/arch/x86/kernel/apic/x2apic_cluster.c
> @@ -212,10 +212,12 @@ static int x2apic_cluster_probe(void)
>  /*
>  * Each x2apic cluster is an allocation domain.
>  */
> -static void cluster_vector_allocation_domain(int cpu, struct cpumask *retmask)
> +static void cluster_vector_allocation_domain(const struct cpumask *mask,
> +                                            struct cpumask *retmask,
> +                                            const struct cpumask *prevmask)
>  {
> -       cpumask_clear(retmask);
> -       cpumask_copy(retmask, per_cpu(cpus_in_cluster, cpu));
> +       int cpu = cpumask_first(retmask);
> +       cpumask_and(retmask, mask, per_cpu(cpus_in_cluster, cpu));

prevmask is not used. could be removed.

Other than those two,

Acked-by: Yinghai Lu <yinghai@kernel.org>
