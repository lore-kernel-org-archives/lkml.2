Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab1BTDfI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 22:35:08 -0500
Received: from smtp-out.google.com ([74.125.121.67]:39112 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab1BTDfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 22:35:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=qHHR052Q7eBTmMi62768m3PFpovH6TROOxGR5p2azGy9DTTenuNIorTFxaBG796WLP
         SJOh3d/FIEDmqTOpHDBA==
Date: Sat, 19 Feb 2011 19:34:57 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        tglx@linutronix.de, Tejun Heo <tj@kernel.org>
cc: yinghai@kernel.org, brgerst@gmail.com, gorcunov@gmail.com,
        shaohui.zheng@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [tip:x86/mm] x86-64, NUMA: Restructure initmem_init()
In-Reply-To: <tip-ffe77a4605fb2588f8666850ad3e3b196241658f@git.kernel.org>
Message-ID: <alpine.DEB.2.00.1102191906180.31263@chino.kir.corp.google.com>
References: <tip-ffe77a4605fb2588f8666850ad3e3b196241658f@git.kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Feb 2011, tip-bot for Tejun Heo wrote:

> diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
> index 656b0cf..c984e34 100644
> --- a/arch/x86/mm/numa_64.c
> +++ b/arch/x86/mm/numa_64.c
> @@ -580,65 +580,73 @@ static int __init numa_emulation(unsigned long start_pfn,
>  }
>  #endif /* CONFIG_NUMA_EMU */
>  
> -void __init initmem_init(void)
> +static int dummy_numa_init(void)
>  {
> -	int acpi = 0, amd = 0;
> -	int i;
> -
> -#ifdef CONFIG_ACPI_NUMA
> -	/*
> -	 * Parse SRAT to discover nodes.
> -	 */
> -	acpi = !x86_acpi_numa_init();
> -#endif
> -
> -#ifdef CONFIG_AMD_NUMA
> -	if (!acpi)
> -		amd = !amd_numa_init();
> -#endif
> -
> -	nodes_clear(node_possible_map);
> -	nodes_clear(node_online_map);
> -
> -#ifdef CONFIG_NUMA_EMU
> -	setup_physnodes(0, max_pfn << PAGE_SHIFT, acpi, amd);
> -	if (cmdline && !numa_emulation(0, max_pfn, acpi, amd))
> -		return;
> -	setup_physnodes(0, max_pfn << PAGE_SHIFT, acpi, amd);
> -	nodes_clear(node_possible_map);
> -	nodes_clear(node_online_map);
> -#endif
> -
> -#ifdef CONFIG_ACPI_NUMA
> -	if (!numa_off && acpi && !acpi_scan_nodes())
> -		return;
> -	nodes_clear(node_possible_map);
> -	nodes_clear(node_online_map);
> -#endif
> +	return 0;
> +}
>  
> -#ifdef CONFIG_AMD_NUMA
> -	if (!numa_off && amd && !amd_scan_nodes())
> -		return;
> -	nodes_clear(node_possible_map);
> -	nodes_clear(node_online_map);
> -#endif
> +static int dummy_scan_nodes(void)
> +{
>  	printk(KERN_INFO "%s\n",
>  	       numa_off ? "NUMA turned off" : "No NUMA configuration found");
> -
>  	printk(KERN_INFO "Faking a node at %016lx-%016lx\n",
>  	       0LU, max_pfn << PAGE_SHIFT);
> +
>  	/* setup dummy node covering all memory */
>  	memnode_shift = 63;
>  	memnodemap = memnode.embedded_map;
>  	memnodemap[0] = 0;
>  	node_set_online(0);
>  	node_set(0, node_possible_map);
> -	for (i = 0; i < MAX_LOCAL_APIC; i++)
> -		set_apicid_to_node(i, NUMA_NO_NODE);
>  	memblock_x86_register_active_regions(0, 0, max_pfn);
>  	init_memory_mapping_high();
>  	setup_node_bootmem(0, 0, max_pfn << PAGE_SHIFT);
>  	numa_init_array();
> +
> +	return 0;
> +}
> +
> +void __init initmem_init(void)
> +{
> +	int (*numa_init[])(void) = { [2] = dummy_numa_init };
> +	int (*scan_nodes[])(void) = { [2] = dummy_scan_nodes };
> +	int i, j;
> +
> +	if (!numa_off) {
> +#ifdef CONFIG_ACPI_NUMA
> +		numa_init[0] = x86_acpi_numa_init;
> +		scan_nodes[0] = acpi_scan_nodes;
> +#endif
> +#ifdef CONFIG_AMD_NUMA
> +		numa_init[1] = amd_numa_init;
> +		scan_nodes[1] = amd_scan_nodes;
> +#endif
> +	}
> +
> +	for (i = 0; i < ARRAY_SIZE(numa_init); i++) {
> +		if (!numa_init[i])
> +			continue;
> +
> +		for (j = 0; j < MAX_LOCAL_APIC; j++)
> +			set_apicid_to_node(j, NUMA_NO_NODE);
> +
> +		nodes_clear(node_possible_map);
> +		nodes_clear(node_online_map);
> +
> +		if (numa_init[i]() < 0)
> +			continue;
> +#ifdef CONFIG_NUMA_EMU
> +		setup_physnodes(0, max_pfn << PAGE_SHIFT, i == 0, i == 1);
> +		if (cmdline && !numa_emulation(0, max_pfn, i == 0, i == 1))
> +			return;
> +		setup_physnodes(0, max_pfn << PAGE_SHIFT, i == 0, i == 1);
> +		nodes_clear(node_possible_map);
> +		nodes_clear(node_online_map);
> +#endif
> +		if (!scan_nodes[i]())
> +			return;
> +	}
> +	BUG();
>  }

This doesn't look very clean, I think it would be much better to extract 
the iteration out to a function of its own which takes an init and scan 
function as arguments and then deal only with numa_off, CONFIG_ACPI_NUMA, 
and CONFIG_AMD_NUMA callers in initmem_init().  If that's done, it's clear 
that the dummy implementation will never fail and so the BUG() in this 
case is never possible (which is intended if all else fails).
