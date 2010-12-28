Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab0L1Uj4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 15:39:56 -0500
Received: from smtp-out.google.com ([74.125.121.67]:14639 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599Ab0L1Ujy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 15:39:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=YTUjyaM06p8MWF2GmgdoFKwFn0J+f91KtGcKL+ed733MSS9Uuiaar5BgYTS0fqVQzg
         AKoy2k6+QQHpk98+9xQw==
Date: Tue, 28 Dec 2010 12:39:47 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        eric.dumazet@gmail.com, yinghai@kernel.org, brgerst@gmail.com,
        gorcunov@gmail.com, Pekka Enberg <penberg@kernel.org>,
        shaohui.zheng@intel.com
Subject: Re: [PATCH 14/16] x86: Unify CPU -> NUMA node mapping between 32
 and 64bit
In-Reply-To: <1293536929-31683-15-git-send-email-tj@kernel.org>
Message-ID: <alpine.DEB.2.00.1012281236080.8883@chino.kir.corp.google.com>
References: <1293536929-31683-1-git-send-email-tj@kernel.org> <1293536929-31683-15-git-send-email-tj@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Dec 2010, Tejun Heo wrote:

> diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
> index 989f23b..ce33f69 100644
> --- a/arch/x86/mm/numa_64.c
> +++ b/arch/x86/mm/numa_64.c
> @@ -31,12 +31,6 @@ static unsigned long __initdata nodemap_addr;
>  static unsigned long __initdata nodemap_size;
>  
>  /*
> - * Map cpu index to node index
> - */
> -DEFINE_EARLY_PER_CPU(int, x86_cpu_to_node_map, NUMA_NO_NODE);
> -EXPORT_EARLY_PER_CPU_SYMBOL(x86_cpu_to_node_map);
> -
> -/*
>   * Given a shift value, try to populate memnodemap[]
>   * Returns :
>   * 1 if OK
> @@ -737,34 +731,6 @@ int __cpuinit numa_cpu_node(int cpu)
>  	return NUMA_NO_NODE;
>  }
>  
> -void __cpuinit numa_set_node(int cpu, int node)
> -{
> -	int *cpu_to_node_map = early_per_cpu_ptr(x86_cpu_to_node_map);
> -
> -	/* early setting, no percpu area yet */
> -	if (cpu_to_node_map) {
> -		cpu_to_node_map[cpu] = node;
> -		return;
> -	}
> -
> -#ifdef CONFIG_DEBUG_PER_CPU_MAPS
> -	if (cpu >= nr_cpu_ids || !cpu_possible(cpu)) {
> -		printk(KERN_ERR "numa_set_node: invalid cpu# (%d)\n", cpu);
> -		dump_stack();
> -		return;
> -	}
> -#endif
> -	per_cpu(x86_cpu_to_node_map, cpu) = node;
> -
> -	if (node != NUMA_NO_NODE)
> -		set_cpu_numa_node(cpu, node);
> -}
> -
> -void __cpuinit numa_clear_node(int cpu)
> -{
> -	numa_set_node(cpu, NUMA_NO_NODE);
> -}
> -
>  #ifndef CONFIG_DEBUG_PER_CPU_MAPS
>  
>  void __cpuinit numa_add_cpu(int cpu)

This is also going to conflict with c1c3443c ("x86, numa: Fake 
node-to-cpumask for NUMA emulation") in x86/numa, but it's trival to merge 
because there's no actual implementation change.
