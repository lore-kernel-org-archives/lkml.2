Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668Ab0HMVMe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 17:12:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:43095 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751649Ab0HMVMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 17:12:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,365,1278313200"; 
   d="scan'208";a="545005898"
Subject: Re: [PATCH/RFC 1/5] [PATCH] sched: merge cpu_to_core_group
 functions
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
        Ingo Molnar <mingo@elte.hu>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
In-Reply-To: <20100812172621.703227914@de.ibm.com>
References: <20100812172544.655648128@de.ibm.com>
	 <20100812172621.703227914@de.ibm.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Fri, 13 Aug 2010 14:11:54 -0700
Message-Id: <1281733914.2704.28.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-12 at 10:25 -0700, Heiko Carstens wrote:
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> Merge and simplify the two cpu_to_core_group variants so that the
> resulting function follows the same pattern like cpu_to_phys_group.
> 
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
> 
>  kernel/sched.c |   18 +++++-------------
>  1 file changed, 5 insertions(+), 13 deletions(-)
> 
> diff -urpN linux-2.6/kernel/sched.c linux-2.6-patched/kernel/sched.c
> --- linux-2.6/kernel/sched.c	2010-08-11 13:47:16.000000000 +0200
> +++ linux-2.6-patched/kernel/sched.c	2010-08-11 13:47:22.000000000 +0200
> @@ -6546,31 +6546,23 @@ cpu_to_cpu_group(int cpu, const struct c
>  #ifdef CONFIG_SCHED_MC
>  static DEFINE_PER_CPU(struct static_sched_domain, core_domains);
>  static DEFINE_PER_CPU(struct static_sched_group, sched_group_core);
> -#endif /* CONFIG_SCHED_MC */
>  
> -#if defined(CONFIG_SCHED_MC) && defined(CONFIG_SCHED_SMT)
>  static int
>  cpu_to_core_group(int cpu, const struct cpumask *cpu_map,
>  		  struct sched_group **sg, struct cpumask *mask)
>  {
>  	int group;
> -
> +#ifdef CONFIG_SCHED_SMT
>  	cpumask_and(mask, topology_thread_cpumask(cpu), cpu_map);
>  	group = cpumask_first(mask);
> +#else
> +	group = cpu;
> +#endif
>  	if (sg)
>  		*sg = &per_cpu(sched_group_core, group).sg;
>  	return group;
>  }
> -#elif defined(CONFIG_SCHED_MC)
> -static int
> -cpu_to_core_group(int cpu, const struct cpumask *cpu_map,
> -		  struct sched_group **sg, struct cpumask *unused)
> -{
> -	if (sg)
> -		*sg = &per_cpu(sched_group_core, cpu).sg;
> -	return cpu;
> -}
> -#endif
> +#endif /* CONFIG_SCHED_MC */
>  
>  static DEFINE_PER_CPU(struct static_sched_domain, phys_domains);
>  static DEFINE_PER_CPU(struct static_sched_group, sched_group_phys);

Reason why this code was structured like this was because of the
feedback from Andrew Morton. http://lkml.org/lkml/2006/1/27/308

May be we can further clean all this code up as part of your new
proposal. I can help in some of this. Thanks.

