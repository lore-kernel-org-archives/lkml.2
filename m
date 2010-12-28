Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab0L1Unc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 15:43:32 -0500
Received: from smtp-out.google.com ([74.125.121.67]:16543 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483Ab0L1Unb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 15:43:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=AcWqf4pefC2lpwcM0BNUcS3DQ5+Dj2kTh6PHYsEuVVNyhczOMgdwFrxgpQD/WOCh6r
         AXyXpzJKTyChT1nQ3C2g==
Date: Tue, 28 Dec 2010 12:43:24 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        eric.dumazet@gmail.com, yinghai@kernel.org, brgerst@gmail.com,
        gorcunov@gmail.com, Pekka Enberg <penberg@kernel.org>,
        shaohui.zheng@intel.com
Subject: Re: [PATCH 15/16] x86: Unify node_to_cpumask_map handling between
 32 and 64bit
In-Reply-To: <1293536929-31683-16-git-send-email-tj@kernel.org>
Message-ID: <alpine.DEB.2.00.1012281240000.8883@chino.kir.corp.google.com>
References: <1293536929-31683-1-git-send-email-tj@kernel.org> <1293536929-31683-16-git-send-email-tj@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Dec 2010, Tejun Heo wrote:

> diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
> index ce33f69..6013aca 100644
> --- a/arch/x86/mm/numa_64.c
> +++ b/arch/x86/mm/numa_64.c
> @@ -730,58 +730,3 @@ int __cpuinit numa_cpu_node(int cpu)
>  		return __apicid_to_node[apicid];
>  	return NUMA_NO_NODE;
>  }
> -
> -#ifndef CONFIG_DEBUG_PER_CPU_MAPS
> -
> -void __cpuinit numa_add_cpu(int cpu)
> -{
> -	cpumask_set_cpu(cpu, node_to_cpumask_map[early_cpu_to_node(cpu)]);
> -}
> -
> -void __cpuinit numa_remove_cpu(int cpu)
> -{
> -	cpumask_clear_cpu(cpu, node_to_cpumask_map[early_cpu_to_node(cpu)]);
> -}
> -
> -#else /* CONFIG_DEBUG_PER_CPU_MAPS */
> -
> -/*
> - * --------- debug versions of the numa functions ---------
> - */
> -static void __cpuinit numa_set_cpumask(int cpu, int enable)
> -{
> -	int node = early_cpu_to_node(cpu);
> -	struct cpumask *mask;
> -	char buf[64];
> -
> -	mask = node_to_cpumask_map[node];
> -	if (mask == NULL) {
> -		printk(KERN_ERR "node_to_cpumask_map[%i] NULL\n", node);
> -		dump_stack();
> -		return;
> -	}
> -
> -	if (enable)
> -		cpumask_set_cpu(cpu, mask);
> -	else
> -		cpumask_clear_cpu(cpu, mask);
> -
> -	cpulist_scnprintf(buf, sizeof(buf), mask);
> -	printk(KERN_DEBUG "%s cpu %d node %d: mask now %s\n",
> -		enable ? "numa_add_cpu" : "numa_remove_cpu", cpu, node, buf);
> -}
> -
> -void __cpuinit numa_add_cpu(int cpu)
> -{
> -	numa_set_cpumask(cpu, 1);
> -}
> -
> -void __cpuinit numa_remove_cpu(int cpu)
> -{
> -	numa_set_cpumask(cpu, 0);
> -}
> -/*
> - * --------- end of debug versions of the numa functions ---------
> - */
> -
> -#endif /* CONFIG_DEBUG_PER_CPU_MAPS */

This has been almost entirely rewritten in x86/numa by c1c3443c ("x86, 
numa: Fake node-to-cpumask for NUMA emulation") and the pending fix 
http://marc.info/?l=linux-kernel&m=129340072128297 ("x86, numa: Fix 
CONFIG_DEBUG_PER_CPU_MAPS without NUMA").  Since this is only moving those 
functions to numa.c, it should be trivial to fix once based on x86/numa.
