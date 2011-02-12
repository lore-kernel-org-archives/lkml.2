Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490Ab1BLSla (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 13:41:30 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:52407 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab1BLSlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 13:41:23 -0500
Message-ID: <4D56D3C7.8050803@kernel.org>
Date: Sat, 12 Feb 2011 10:39:03 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, x86@kernel.org, brgerst@gmail.com,
        gorcunov@gmail.com, shaohui.zheng@intel.com, rientjes@google.com,
        mingo@elte.hu, hpa@linux.intel.com
Subject: Re: [PATCH 04/26] x86-64, NUMA: Unify {acpi|amd}_{numa_init|scan_nodes}()
 arguments and return values
References: <1297530663-26234-1-git-send-email-tj@kernel.org> <1297530663-26234-5-git-send-email-tj@kernel.org>
In-Reply-To: <1297530663-26234-5-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4D56D43F.00D9,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2011 09:10 AM, Tejun Heo wrote:
> The functions used during NUMA initialization - *_numa_init() and
> *_scan_nodes() - have different arguments and return values.  Unify
> them such that they all take no argument and return 0 on success and
> -errno on failure.  This is in preparation for further NUMA init
> cleanups.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: Brian Gerst <brgerst@gmail.com>
> Cc: Cyrill Gorcunov <gorcunov@gmail.com>
> Cc: Shaohui Zheng <shaohui.zheng@intel.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: H. Peter Anvin <hpa@linux.intel.com>
> ---
>  arch/x86/include/asm/acpi.h   |    2 +-
>  arch/x86/include/asm/amd_nb.h |    2 +-
>  arch/x86/kernel/setup.c       |    4 ++--
>  arch/x86/mm/amdtopology_64.c  |   18 +++++++++---------
>  arch/x86/mm/numa_64.c         |    2 +-
>  arch/x86/mm/srat_64.c         |    4 ++--
>  drivers/acpi/numa.c           |    9 ++++++---
>  7 files changed, 22 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
> index 211ca3f..4e5dff9 100644
> --- a/arch/x86/include/asm/acpi.h
> +++ b/arch/x86/include/asm/acpi.h
> @@ -187,7 +187,7 @@ struct bootnode;
>  extern int acpi_numa;
>  extern void acpi_get_nodes(struct bootnode *physnodes, unsigned long start,
>  				unsigned long end);
> -extern int acpi_scan_nodes(unsigned long start, unsigned long end);
> +extern int acpi_scan_nodes(void);
>  #define NR_NODE_MEMBLKS (MAX_NUMNODES*2)
>  
>  #ifdef CONFIG_NUMA_EMU
> diff --git a/arch/x86/include/asm/amd_nb.h b/arch/x86/include/asm/amd_nb.h
> index 64dc82e..72abf65 100644
> --- a/arch/x86/include/asm/amd_nb.h
> +++ b/arch/x86/include/asm/amd_nb.h
> @@ -16,7 +16,7 @@ struct bootnode;
>  extern int early_is_amd_nb(u32 value);
>  extern int amd_cache_northbridges(void);
>  extern void amd_flush_garts(void);
> -extern int amd_numa_init(unsigned long start_pfn, unsigned long end_pfn);
> +extern int amd_numa_init(void);
>  extern int amd_scan_nodes(void);
>  
>  #ifdef CONFIG_NUMA_EMU
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index c50ba3d..1870a59 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -988,12 +988,12 @@ void __init setup_arch(char **cmdline_p)
>  	/*
>  	 * Parse SRAT to discover nodes.
>  	 */
> -	acpi = acpi_numa_init();
> +	acpi = !acpi_numa_init();
>  #endif
>  
>  #ifdef CONFIG_AMD_NUMA
>  	if (!acpi)
> -		amd = !amd_numa_init(0, max_pfn);
> +		amd = !amd_numa_init();
>  #endif
>  
>  	initmem_init(acpi, amd);
> diff --git a/arch/x86/mm/amdtopology_64.c b/arch/x86/mm/amdtopology_64.c
> index c7fae38..ee70257 100644
> --- a/arch/x86/mm/amdtopology_64.c
> +++ b/arch/x86/mm/amdtopology_64.c
> @@ -51,7 +51,7 @@ static __init int find_northbridge(void)
>  		return num;
>  	}
>  
> -	return -1;
> +	return -ENOENT;
>  }
>  
>  static __init void early_get_boot_cpu_id(void)
> @@ -69,17 +69,17 @@ static __init void early_get_boot_cpu_id(void)
>  #endif
>  }
>  
> -int __init amd_numa_init(unsigned long start_pfn, unsigned long end_pfn)
> +int __init amd_numa_init(void)
>  {
> -	unsigned long start = PFN_PHYS(start_pfn);
> -	unsigned long end = PFN_PHYS(end_pfn);
> +	unsigned long start = PFN_PHYS(0);
> +	unsigned long end = PFN_PHYS(max_pfn);
>  	unsigned numnodes;
>  	unsigned long prevbase;
>  	int i, nb, found = 0;
>  	u32 nodeid, reg;
>  
>  	if (!early_pci_allowed())
> -		return -1;
> +		return -EINVAL;
>  
>  	nb = find_northbridge();
>  	if (nb < 0)
> @@ -90,7 +90,7 @@ int __init amd_numa_init(unsigned long start_pfn, unsigned long end_pfn)
>  	reg = read_pci_config(0, nb, 0, 0x60);
>  	numnodes = ((reg >> 4) & 0xF) + 1;
>  	if (numnodes <= 1)
> -		return -1;
> +		return -ENOENT;
>  
>  	pr_info("Number of physical nodes %d\n", numnodes);
>  
> @@ -121,7 +121,7 @@ int __init amd_numa_init(unsigned long start_pfn, unsigned long end_pfn)
>  		if ((base >> 8) & 3 || (limit >> 8) & 3) {
>  			pr_err("Node %d using interleaving mode %lx/%lx\n",
>  			       nodeid, (base >> 8) & 3, (limit >> 8) & 3);
> -			return -1;
> +			return -EINVAL;
>  		}
>  		if (node_isset(nodeid, nodes_parsed)) {
>  			pr_info("Node %d already present, skipping\n",
> @@ -160,7 +160,7 @@ int __init amd_numa_init(unsigned long start_pfn, unsigned long end_pfn)
>  		if (prevbase > base) {
>  			pr_err("Node map not sorted %lx,%lx\n",
>  			       prevbase, base);
> -			return -1;
> +			return -EINVAL;
>  		}
>  
>  		pr_info("Node %d MemBase %016lx Limit %016lx\n",
> @@ -177,7 +177,7 @@ int __init amd_numa_init(unsigned long start_pfn, unsigned long end_pfn)
>  	}
>  
>  	if (!found)
> -		return -1;
> +		return -ENOENT;
>  	return 0;
>  }
>  
> diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
> index f534feb..85561d1 100644
> --- a/arch/x86/mm/numa_64.c
> +++ b/arch/x86/mm/numa_64.c
> @@ -595,7 +595,7 @@ void __init initmem_init(int acpi, int amd)
>  #endif
>  
>  #ifdef CONFIG_ACPI_NUMA
> -	if (!numa_off && acpi && !acpi_scan_nodes(0, max_pfn << PAGE_SHIFT))
> +	if (!numa_off && acpi && !acpi_scan_nodes())
>  		return;
>  	nodes_clear(node_possible_map);
>  	nodes_clear(node_online_map);
> diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
> index e3e0dd3..19652dd 100644
> --- a/arch/x86/mm/srat_64.c
> +++ b/arch/x86/mm/srat_64.c
> @@ -359,7 +359,7 @@ void __init acpi_get_nodes(struct bootnode *physnodes, unsigned long start,
>  #endif /* CONFIG_NUMA_EMU */
>  
>  /* Use the information discovered above to actually set up the nodes. */
> -int __init acpi_scan_nodes(unsigned long start, unsigned long end)
> +int __init acpi_scan_nodes(void)
>  {
>  	int i;
>  
> @@ -368,7 +368,7 @@ int __init acpi_scan_nodes(unsigned long start, unsigned long end)
>  
>  	/* First clean up the node list */
>  	for (i = 0; i < MAX_NUMNODES; i++)
> -		cutoff_node(i, start, end);
> +		cutoff_node(i, 0, max_pfn << PAGE_SHIFT);
>  
>  	/*
>  	 * Join together blocks on the same node, holes between
> diff --git a/drivers/acpi/numa.c b/drivers/acpi/numa.c
> index 5eb25eb..3b5c318 100644
> --- a/drivers/acpi/numa.c
> +++ b/drivers/acpi/numa.c
> @@ -274,7 +274,7 @@ acpi_table_parse_srat(enum acpi_srat_type id,
>  
>  int __init acpi_numa_init(void)
>  {
> -	int ret = 0;
> +	int cnt = 0;
>  
>  	/*
>  	 * Should not limit number with cpu num that is from NR_CPUS or nr_cpus=
> @@ -288,7 +288,7 @@ int __init acpi_numa_init(void)
>  				     acpi_parse_x2apic_affinity, 0);
>  		acpi_table_parse_srat(ACPI_SRAT_TYPE_CPU_AFFINITY,
>  				     acpi_parse_processor_affinity, 0);
> -		ret = acpi_table_parse_srat(ACPI_SRAT_TYPE_MEMORY_AFFINITY,
> +		cnt = acpi_table_parse_srat(ACPI_SRAT_TYPE_MEMORY_AFFINITY,
>  					    acpi_parse_memory_affinity,
>  					    NR_NODE_MEMBLKS);
>  	}
> @@ -297,7 +297,10 @@ int __init acpi_numa_init(void)
>  	acpi_table_parse(ACPI_SIG_SLIT, acpi_parse_slit);
>  
>  	acpi_numa_arch_fixup();
> -	return ret;
> +
> +	if (cnt <= 0)
> +		return cnt ?: -ENOENT;
> +	return 0;
>  }
>  
>  int acpi_get_pxm(acpi_handle h)


it will break AMD system that does not have SRAT.

your change will treat NO_SRAT as SRAT is there.

Yinghai
