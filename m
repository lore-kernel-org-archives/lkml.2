Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759345Ab2FUWgD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 18:36:03 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37145 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758392Ab2FUWf6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 18:35:58 -0400
MIME-Version: 1.0
In-Reply-To: <1340316145-4431-4-git-send-email-suresh.b.siddha@intel.com>
References: <1340316145-4431-1-git-send-email-suresh.b.siddha@intel.com>
	<1340316145-4431-4-git-send-email-suresh.b.siddha@intel.com>
Date: Thu, 21 Jun 2012 15:35:40 -0700
X-Google-Sender-Auth: J52KSXgqfR4vSVUCpeAVX3SuG1I
Message-ID: <CAE9FiQXyEKOxmAHcdLM=+ft7CKqdv3Z-gAKf1Uwz53oH-XpyAg@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] x86, x2apic: use multiple cluster members for the
 irq destination only with the explicit affinity
From: Yinghai Lu <yinghai@kernel.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Alexander Gordeev <agordeev@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, x86@kernel.org, gorcunov@openvz.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 3:02 PM, Suresh Siddha
<suresh.b.siddha@intel.com> wrote:
> During boot or driver load etc, interrupt destination is setup using default
> target cpu's. Later the user (irqbalance etc) or the driver (irq_set_affinity/
> irq_set_affinity_hint) can request the interrupt to be migrated to some
> specific set of cpu's.
>
> In the x2apic cluster routing, for the default scenario use single cpu as the
> interrupt destination and when there is an explicit interrupt affinity
> request, route the interrupt to multiple members of a x2apic cluster
> specified in the cpumask of the migration request.
>
> This will minmize the vector pressure when there are lot of interrupt
> sources and relatively few x2apic clusters (for example a single socket
> server). This will allow the performance critical interrupts to be
> routed to multiple cpu's in the x2apic cluster (irqbalance for example
> uses the cache siblings etc while specifying the interrupt destination) and
> allow non-critical interrupts to be serviced by a single logical cpu.
>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> ---
>  arch/x86/kernel/apic/x2apic_cluster.c |   21 +++++++++++++++++++--
>  1 files changed, 19 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
> index bde78d0..c88baa4 100644
> --- a/arch/x86/kernel/apic/x2apic_cluster.c
> +++ b/arch/x86/kernel/apic/x2apic_cluster.c
> @@ -209,13 +209,30 @@ static int x2apic_cluster_probe(void)
>                return 0;
>  }
>
> +static const struct cpumask *x2apic_cluster_target_cpus(void)
> +{
> +       return cpu_all_mask;
> +}
> +
>  /*
>  * Each x2apic cluster is an allocation domain.
>  */
>  static void cluster_vector_allocation_domain(int cpu, struct cpumask *retmask,
>                                             const struct cpumask *mask)
>  {
> -       cpumask_and(retmask, mask, per_cpu(cpus_in_cluster, cpu));
> +       /*
> +        * To minimize vector pressure, default case of boot, device bringup
> +        * etc will use a single cpu for the interrupt destination.
> +        *
> +        * On explicit migration requests coming from irqbalance etc,
> +        * interrupts will be routed to the x2apic cluster (cluster-id
> +        * derived from the first cpu in the mask) members specified
> +        * in the mask.
> +        */
> +       if (mask == x2apic_cluster_target_cpus())
> +               cpumask_copy(retmask, cpumask_of(cpu));
> +       else
> +               cpumask_and(retmask, mask, per_cpu(cpus_in_cluster, cpu));

great, that remove the startup limitation.

Acked-by: Yinghai Lu <yinghai@kernel.org>

>  }
>
>  static struct apic apic_x2apic_cluster = {
> @@ -229,7 +246,7 @@ static struct apic apic_x2apic_cluster = {
>        .irq_delivery_mode              = dest_LowestPrio,
>        .irq_dest_mode                  = 1, /* logical */
>
> -       .target_cpus                    = online_target_cpus,
> +       .target_cpus                    = x2apic_cluster_target_cpus,
>        .disable_esr                    = 0,
>        .dest_logical                   = APIC_DEST_LOGICAL,
>        .check_apicid_used              = NULL,
> --
> 1.7.6.5
>
