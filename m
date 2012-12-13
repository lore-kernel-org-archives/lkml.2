Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab2LMC0i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 21:26:38 -0500
Received: from mga11.intel.com ([192.55.52.93]:42227 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932391Ab2LMC0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 21:26:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,270,1355126400"; 
   d="scan'208";a="261435843"
Message-ID: <50C93C40.8020101@intel.com>
Date: Thu, 13 Dec 2012 10:24:00 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-dev@lists.linaro.org, peterz@infradead.org, mingo@kernel.org,
        linux@arm.linux.org.uk, pjt@google.com, santosh.shilimkar@ti.com,
        Morten.Rasmussen@arm.com, chander.kashyap@linaro.org,
        cmetcalf@tilera.com, tony.luck@intel.com, preeti@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de, len.brown@intel.com,
        arjan@linux.intel.com, amit.kucheria@linaro.org,
        viresh.kumar@linaro.org
Subject: Re: [PATCH 2/6] sched: add a new SD SHARE_POWERLINE flag for sched_domain
References: <1355319092-30980-1-git-send-email-vincent.guittot@linaro.org> <1355319092-30980-3-git-send-email-vincent.guittot@linaro.org>
In-Reply-To: <1355319092-30980-3-git-send-email-vincent.guittot@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2012 09:31 PM, Vincent Guittot wrote:
> This new flag SD_SHARE_POWERDOMAIN is used to reflect whether groups of CPU in
> a sched_domain level can or not reach a different power state. If clusters can
> be power gated independently, as an example, the flag should be cleared at CPU
> level. This information is used to decide if it's worth packing some tasks in
> a group of CPUs in order to power gated the other groups instead of spreading
> the tasks. The default behavior of the scheduler is to spread tasks so the
> flag is set into all sched_domains
> 
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> ---
>  arch/ia64/include/asm/topology.h |    1 +
>  arch/tile/include/asm/topology.h |    1 +
>  include/linux/sched.h            |    1 +
>  include/linux/topology.h         |    4 ++++
>  kernel/sched/core.c              |    6 ++++++
>  5 files changed, 13 insertions(+)
> 
> diff --git a/arch/ia64/include/asm/topology.h b/arch/ia64/include/asm/topology.h
> index a2496e4..6d0b617 100644
> --- a/arch/ia64/include/asm/topology.h
> +++ b/arch/ia64/include/asm/topology.h
> @@ -65,6 +65,7 @@ void build_cpu_to_node_map(void);
>  				| SD_BALANCE_EXEC	\
>  				| SD_BALANCE_FORK	\
>  				| SD_WAKE_AFFINE,	\
> +				| arch_sd_local_flags(0)\
>  	.last_balance		= jiffies,		\
>  	.balance_interval	= 1,			\
>  	.nr_balance_failed	= 0,			\
> diff --git a/arch/tile/include/asm/topology.h b/arch/tile/include/asm/topology.h
> index d5e86c9..adc8710 100644
> --- a/arch/tile/include/asm/topology.h
> +++ b/arch/tile/include/asm/topology.h
> @@ -71,6 +71,7 @@ static inline const struct cpumask *cpumask_of_node(int node)
>  				| 0*SD_WAKE_AFFINE			\
>  				| 0*SD_SHARE_CPUPOWER			\
>  				| 0*SD_SHARE_PKG_RESOURCES		\
> +				| arch_sd_local_flags(0)		\
>  				| 0*SD_SERIALIZE			\
>  				,					\
>  	.last_balance		= jiffies,				\
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 046e39a..3287be1 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -844,6 +844,7 @@ enum cpu_idle_type {
>  #define SD_BALANCE_WAKE		0x0010  /* Balance on wakeup */
>  #define SD_WAKE_AFFINE		0x0020	/* Wake task to waking CPU */
>  #define SD_SHARE_CPUPOWER	0x0080	/* Domain members share cpu power */
> +#define SD_SHARE_POWERDOMAIN	0x0100	/* Domain members share power domain */
>  #define SD_SHARE_PKG_RESOURCES	0x0200	/* Domain members share cpu pkg resources */
>  #define SD_SERIALIZE		0x0400	/* Only a single load balancing instance */
>  #define SD_ASYM_PACKING		0x0800  /* Place busy groups earlier in the domain */
> diff --git a/include/linux/topology.h b/include/linux/topology.h
> index d3cf0d6..3eab293 100644
> --- a/include/linux/topology.h
> +++ b/include/linux/topology.h
> @@ -99,6 +99,8 @@ int arch_update_cpu_topology(void);
>  				| 1*SD_WAKE_AFFINE			\
>  				| 1*SD_SHARE_CPUPOWER			\
>  				| 1*SD_SHARE_PKG_RESOURCES		\
> +				| arch_sd_local_flags(SD_SHARE_CPUPOWER|\
> +						SD_SHARE_PKG_RESOURCES) \
>  				| 0*SD_SERIALIZE			\
>  				| 0*SD_PREFER_SIBLING			\
>  				| arch_sd_sibling_asym_packing()	\
> @@ -131,6 +133,7 @@ int arch_update_cpu_topology(void);
>  				| 1*SD_WAKE_AFFINE			\
>  				| 0*SD_SHARE_CPUPOWER			\
>  				| 1*SD_SHARE_PKG_RESOURCES		\
> +				| arch_sd_local_flags(SD_SHARE_PKG_RESOURCES)\
>  				| 0*SD_SERIALIZE			\
>  				,					\
>  	.last_balance		= jiffies,				\
> @@ -161,6 +164,7 @@ int arch_update_cpu_topology(void);
>  				| 1*SD_WAKE_AFFINE			\
>  				| 0*SD_SHARE_CPUPOWER			\
>  				| 0*SD_SHARE_PKG_RESOURCES		\
> +				| arch_sd_local_flags(0)		\

The general style looks like prefering SD_XXX flag directly.

