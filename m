Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300Ab1BDWIH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 17:08:07 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40255 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751835Ab1BDWIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 17:08:05 -0500
Date: Fri, 4 Feb 2011 14:07:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: <hpa@zytor.com>, <tglx@linutronix.de>, <mingo@elte.hu>,
        <andreas.herrmann3@amd.com>, <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>
Subject: Re: [PATCH 1/4] x86, amd: Normalize compute unit IDs on multi-node
 processors
Message-Id: <20110204140744.e2c04ef4.akpm@linux-foundation.org>
In-Reply-To: <1295881543-572552-2-git-send-email-hans.rosenfeld@amd.com>
References: <1295881543-572552-1-git-send-email-hans.rosenfeld@amd.com>
	<1295881543-572552-2-git-send-email-hans.rosenfeld@amd.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Jan 2011 16:05:40 +0100
Hans Rosenfeld <hans.rosenfeld@amd.com> wrote:

> From: Andreas Herrmann <andreas.herrmann3@amd.com>
> 
> On multi-node CPUs we don't need the socket wide compute unit ID but
> the node-wide compute unit ID. Thus we need to normalize the value.
> This is similar to what we do with cpu_core_id.
> 
> A compute unit is then identified by physical_package_id, node_id, and
> compute_unit_id.
> 
> ...
>
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -261,7 +261,7 @@ static int __cpuinit nearby_node(int apicid)
>  #ifdef CONFIG_X86_HT
>  static void __cpuinit amd_get_topology(struct cpuinfo_x86 *c)
>  {
> -	u32 nodes;
> +	u32 nodes, cores_per_cu;
>  	u8 node_id;
>  	int cpu = smp_processor_id();
>  
> @@ -276,6 +276,7 @@ static void __cpuinit amd_get_topology(struct cpuinfo_x86 *c)
>  		/* get compute unit information */
>  		smp_num_siblings = ((ebx >> 8) & 3) + 1;
>  		c->compute_unit_id = ebx & 0xff;
> +		cores_per_cu = ((ebx >> 8) & 3) + 1;
>  	} else if (cpu_has(c, X86_FEATURE_NODEID_MSR)) {
>  		u64 value;
>  
> @@ -288,15 +289,18 @@ static void __cpuinit amd_get_topology(struct cpuinfo_x86 *c)
>  	/* fixup multi-node processor information */
>  	if (nodes > 1) {
>  		u32 cores_per_node;
> +		u32 cus_per_node;
>  
>  		set_cpu_cap(c, X86_FEATURE_AMD_DCM);
>  		cores_per_node = c->x86_max_cores / nodes;
> +		cus_per_node = cores_per_node / cores_per_cu;
>  
>  		/* store NodeID, use llc_shared_map to store sibling info */
>  		per_cpu(cpu_llc_id, cpu) = node_id;
>  
>  		/* core id to be in range from 0 to (cores_per_node - 1) */
> -		c->cpu_core_id = c->cpu_core_id % cores_per_node;
> +		c->cpu_core_id %= cores_per_node;
> +		c->compute_unit_id %= cus_per_node;
>  	}
>  }
>  #endif

arch/x86/kernel/cpu/amd.c: In function 'init_amd':
arch/x86/kernel/cpu/amd.c:268: warning: 'cores_per_cu' may be used uninitialized in this function

The code looks buggy to me.
