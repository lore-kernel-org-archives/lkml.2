Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab2JJLEp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 07:04:45 -0400
Received: from service87.mimecast.com ([91.220.42.44]:52651 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428Ab2JJLEo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 07:04:44 -0400
Date: Wed, 10 Oct 2012 12:04:40 +0100
From: Morten Rasmussen <Morten.Rasmussen@arm.com>
To: tixy@linaro.org
Cc: "linaro-sched-sig@lists.linaro.org" 
	<linaro-sched-sig@lists.linaro.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pjt@google.com" <pjt@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "suresh.b.siddha@intel.com" <suresh.b.siddha@intel.com>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 06/10] ARM: sched: Use device-tree to provide
 fast/slow CPU list for HMP
Message-ID: <20121010110440.GE3729@e103034-lin>
References: <1348252345-5642-1-git-send-email-morten.rasmussen@arm.com>
 <1348252345-5642-7-git-send-email-morten.rasmussen@arm.com>
MIME-Version: 1.0
In-Reply-To: <1348252345-5642-7-git-send-email-morten.rasmussen@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 10 Oct 2012 11:04:39.0931 (UTC) FILETIME=[0B2D4CB0:01CDA6D7]
X-MC-Unique: 112101012044115901
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tixy,

Could you have a look at my code stealing patch below? Since it is
basically a trimmed version of one of your patches I would prefer to
put you as author and have your SOB on it. What is your opinion?

Thanks,
Morten

On Fri, Sep 21, 2012 at 07:32:21PM +0100, Morten Rasmussen wrote:
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
> 
> This patch is reuse of a patch by Jon Medhurst <tixy@linaro.org> with a
> few bits left out.
> 
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
>  	string "HMP scheduler fast CPU mask"
>  	depends on SCHED_HMP
>  	help
> -          Specify the cpuids of the fast CPUs in the system as a list string,
> +          Leave empty to use device tree information.
> +	  Specify the cpuids of the fast CPUs in the system as a list string,
>  	  e.g. cpuid 0+1 should be specified as 0-1.
>  
>  config HMP_SLOW_CPU_MASK
>  	string "HMP scheduler slow CPU mask"
>  	depends on SCHED_HMP
>  	help
> +	  Leave empty to use device tree information.
>  	  Specify the cpuids of the slow CPUs in the system as a list string,
>  	  e.g. cpuid 0+1 should be specified as 0-1.
>  
> diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
> index 26c12c6..7682e12 100644
> --- a/arch/arm/kernel/topology.c
> +++ b/arch/arm/kernel/topology.c
> @@ -317,6 +317,75 @@ void store_cpu_topology(unsigned int cpuid)
>  		cpu_topology[cpuid].socket_id, mpidr);
>  }
>  
> +
> +#ifdef CONFIG_SCHED_HMP
> +
> +static const char * const little_cores[] = {
> +	"arm,cortex-a7",
> +	NULL,
> +};
> +
> +static bool is_little_cpu(struct device_node *cn)
> +{
> +	const char * const *lc;
> +	for (lc = little_cores; *lc; lc++)
> +		if (of_device_is_compatible(cn, *lc))
> +			return true;
> +	return false;
> +}
> +
> +void __init arch_get_fast_and_slow_cpus(struct cpumask *fast,
> +					struct cpumask *slow)
> +{
> +	struct device_node *cn = NULL;
> +	int cpu = 0;
> +
> +	cpumask_clear(fast);
> +	cpumask_clear(slow);
> +
> +	/*
> +	 * Use the config options if they are given. This helps testing
> +	 * HMP scheduling on systems without a big.LITTLE architecture.
> +	 */
> +	if (strlen(CONFIG_HMP_FAST_CPU_MASK) && strlen(CONFIG_HMP_SLOW_CPU_MASK)) {
> +		if (cpulist_parse(CONFIG_HMP_FAST_CPU_MASK, fast))
> +			WARN(1, "Failed to parse HMP fast cpu mask!\n");
> +		if (cpulist_parse(CONFIG_HMP_SLOW_CPU_MASK, slow))
> +			WARN(1, "Failed to parse HMP slow cpu mask!\n");
> +		return;
> +	}
> +
> +	/*
> +	 * Else, parse device tree for little cores.
> +	 */
> +	while ((cn = of_find_node_by_type(cn, "cpu"))) {
> +
> +		if (cpu >= num_possible_cpus())
> +			break;
> +
> +		if (is_little_cpu(cn))
> +			cpumask_set_cpu(cpu, slow);
> +		else
> +			cpumask_set_cpu(cpu, fast);
> +
> +		cpu++;
> +	}
> +
> +	if (!cpumask_empty(fast) && !cpumask_empty(slow))
> +		return;
> +
> +	/*
> +	 * We didn't find both big and little cores so let's call all cores
> +	 * fast as this will keep the system running, with all cores being
> +	 * treated equal.
> +	 */
> +	cpumask_setall(fast);
> +	cpumask_clear(slow);
> +}
> +
> +#endif /* CONFIG_SCHED_HMP */
> +
> +
>  /*
>   * init_cpu_topology is called at boot when only one cpu is running
>   * which prevent simultaneous write access to cpu_topology array
> -- 
> 1.7.9.5
> 

