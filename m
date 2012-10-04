Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884Ab2JDGte (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 02:49:34 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:61386 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016Ab2JDGtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 02:49:32 -0400
MIME-Version: 1.0
In-Reply-To: <1348252345-5642-7-git-send-email-morten.rasmussen@arm.com>
References: <1348252345-5642-1-git-send-email-morten.rasmussen@arm.com>
	<1348252345-5642-7-git-send-email-morten.rasmussen@arm.com>
Date: Thu, 4 Oct 2012 12:19:32 +0530
Message-ID: <CAKohponvN+-rBxeBW6L1UiwzuDLJ+zymzawyoT3PdxMB31vxRw@mail.gmail.com>
Subject: Re: [RFC PATCH 06/10] ARM: sched: Use device-tree to provide
 fast/slow CPU list for HMP
From: Viresh Kumar <viresh.kumar@linaro.org>
To: morten.rasmussen@arm.com
Cc: paulmck@linux.vnet.ibm.com, pjt@google.com, peterz@infradead.org,
        suresh.b.siddha@intel.com, linaro-sched-sig@lists.linaro.org,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        Arvind.Chauhan@arm.com, Amit Kucheria <amit.kucheria@linaro.org>,
        Robin Randhawa <robin.randhawa@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 September 2012 00:02,  <morten.rasmussen@arm.com> wrote:
> From: Morten Rasmussen <morten.rasmussen@arm.com>
>
> We can't rely on Kconfig options to set the fast and slow CPU lists for
> HMP scheduling if we want a single kernel binary to support multiple
> devices with different CPU topology. E.g. TC2 (ARM's Test-Chip-2
> big.LITTLE system), Fast Models, or even non big.LITTLE devices.
>
> This patch adds the function arch_get_fast_and_slow_cpus() to generate
> the lists at run-time by parsing the CPU nodes in device-tree; it
> assumes slow cores are A7s and everything else is fast. The function
> still supports the old Kconfig options as this is useful for testing the
> HMP scheduler on devices without big.LITTLE.

But this code is handling this case too at the end, with following logic:

> +       cpumask_setall(fast);
> +       cpumask_clear(slow);

Am i missing something?

> This patch is reuse of a patch by Jon Medhurst <tixy@linaro.org> with a
> few bits left out.

Then probably he must be the author of this commit? Also a SOB is required
from him here.

> Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
> ---
>  arch/arm/Kconfig           |    4 ++-
>  arch/arm/kernel/topology.c |   69 ++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 72 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index cb80846..f1271bc 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1588,13 +1588,15 @@ config HMP_FAST_CPU_MASK
>         string "HMP scheduler fast CPU mask"
>         depends on SCHED_HMP
>         help
> -          Specify the cpuids of the fast CPUs in the system as a list string,
> +          Leave empty to use device tree information.
> +         Specify the cpuids of the fast CPUs in the system as a list string,
>           e.g. cpuid 0+1 should be specified as 0-1.
>
>  config HMP_SLOW_CPU_MASK
>         string "HMP scheduler slow CPU mask"
>         depends on SCHED_HMP
>         help
> +         Leave empty to use device tree information.
>           Specify the cpuids of the slow CPUs in the system as a list string,
>           e.g. cpuid 0+1 should be specified as 0-1.
>
> diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
> index 26c12c6..7682e12 100644
> --- a/arch/arm/kernel/topology.c
> +++ b/arch/arm/kernel/topology.c
> @@ -317,6 +317,75 @@ void store_cpu_topology(unsigned int cpuid)
>                 cpu_topology[cpuid].socket_id, mpidr);
>  }
>
> +
> +#ifdef CONFIG_SCHED_HMP
> +
> +static const char * const little_cores[] = {
> +       "arm,cortex-a7",
> +       NULL,
> +};
> +
> +static bool is_little_cpu(struct device_node *cn)
> +{
> +       const char * const *lc;
> +       for (lc = little_cores; *lc; lc++)
> +               if (of_device_is_compatible(cn, *lc))
> +                       return true;
> +       return false;
> +}
> +
> +void __init arch_get_fast_and_slow_cpus(struct cpumask *fast,
> +                                       struct cpumask *slow)
> +{
> +       struct device_node *cn = NULL;
> +       int cpu = 0;
> +
> +       cpumask_clear(fast);
> +       cpumask_clear(slow);
> +
> +       /*
> +        * Use the config options if they are given. This helps testing
> +        * HMP scheduling on systems without a big.LITTLE architecture.
> +        */
> +       if (strlen(CONFIG_HMP_FAST_CPU_MASK) && strlen(CONFIG_HMP_SLOW_CPU_MASK)) {
> +               if (cpulist_parse(CONFIG_HMP_FAST_CPU_MASK, fast))
> +                       WARN(1, "Failed to parse HMP fast cpu mask!\n");
> +               if (cpulist_parse(CONFIG_HMP_SLOW_CPU_MASK, slow))
> +                       WARN(1, "Failed to parse HMP slow cpu mask!\n");
> +               return;
> +       }
> +
> +       /*
> +        * Else, parse device tree for little cores.
> +        */
> +       while ((cn = of_find_node_by_type(cn, "cpu"))) {
> +
> +               if (cpu >= num_possible_cpus())
> +                       break;
> +
> +               if (is_little_cpu(cn))
> +                       cpumask_set_cpu(cpu, slow);
> +               else
> +                       cpumask_set_cpu(cpu, fast);
> +
> +               cpu++;
> +       }
> +
> +       if (!cpumask_empty(fast) && !cpumask_empty(slow))
> +               return;
> +
> +       /*
> +        * We didn't find both big and little cores so let's call all cores
> +        * fast as this will keep the system running, with all cores being
> +        * treated equal.
> +        */
> +       cpumask_setall(fast);
> +       cpumask_clear(slow);
> +}
> +
> +#endif /* CONFIG_SCHED_HMP */

All above calls to of_*() routines have dependency on CONFIG_OF

--
viresh
