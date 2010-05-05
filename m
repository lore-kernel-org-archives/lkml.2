Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934869Ab0EEQ0Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 12:26:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58170 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934053Ab0EEQ0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 12:26:24 -0400
Date: Wed, 5 May 2010 18:26:19 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Borislav Petkov <borislav.petkov@amd.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Renninger <trenn@suse.de>, Jiri Benc <jbenc@suse.cz>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       "Ostrovsky, Boris" <Boris.Ostrovsky@amd.com>
Subject: Re: [113/197] x86, cacheinfo: Calculate L3 indices
In-Reply-To: <20100422190917.467545308@kvm.kroah.org>
Message-ID: <alpine.LNX.2.00.1005051736080.9849@pobox.suse.cz>
References: <20100422190917.467545308@kvm.kroah.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ added some more CCs ]

On Thu, 22 Apr 2010, Greg KH wrote:

> 2.6.32-stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> 
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> commit 048a8774ca43488d78605031f11cc206d7a2682a upstream.
> 
> We need to know the valid L3 indices interval when disabling them over
> /sysfs. Do that when the core is brought online and add boundary checks
> to the sysfs .store attribute.
> 
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> LKML-Reference: <1264172467-25155-6-git-send-email-bp@amd64.org>
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  arch/x86/kernel/cpu/intel_cacheinfo.c |   35 ++++++++++++++++++++++++++++++----
>  1 file changed, 31 insertions(+), 4 deletions(-)
> 
> --- a/arch/x86/kernel/cpu/intel_cacheinfo.c
> +++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
> @@ -151,7 +151,8 @@ struct _cpuid4_info {
>  	union _cpuid4_leaf_ebx ebx;
>  	union _cpuid4_leaf_ecx ecx;
>  	unsigned long size;
> -	unsigned long can_disable;
> +	bool can_disable;
> +	unsigned int l3_indices;
>  	DECLARE_BITMAP(shared_cpu_map, NR_CPUS);
>  };
>  
> @@ -161,7 +162,8 @@ struct _cpuid4_info_regs {
>  	union _cpuid4_leaf_ebx ebx;
>  	union _cpuid4_leaf_ecx ecx;
>  	unsigned long size;
> -	unsigned long can_disable;
> +	bool can_disable;
> +	unsigned int l3_indices;
>  };
>  
>  unsigned short			num_cache_leaves;
> @@ -291,6 +293,29 @@ amd_cpuid4(int leaf, union _cpuid4_leaf_
>  		(ebx->split.ways_of_associativity + 1) - 1;
>  }
>  
> +static unsigned int __cpuinit amd_calc_l3_indices(void)
> +{
> +	/*
> +	 * We're called over smp_call_function_single() and therefore
> +	 * are on the correct cpu.
> +	 */
> +	int cpu = smp_processor_id();
> +	int node = cpu_to_node(cpu);
> +	struct pci_dev *dev = node_to_k8_nb_misc(node);
> +	unsigned int sc0, sc1, sc2, sc3;
> +	u32 val;
> +
> +	pci_read_config_dword(dev, 0x1C4, &val);

This is broken -- the code doesn't handle the case of node_to_k8_nb_misc() 
returning NULL, causing NULL pointer dereference in 
pci_read_config_dword() in such case.

[ ... snip ... ]
> @@ -780,7 +806,8 @@ static ssize_t store_cache_disable(struc
>  		return -EINVAL;
>  
>  	/* do not allow writes outside of allowed bits */
> -	if (val & ~(SUBCACHE_MASK | SUBCACHE_INDEX))
> +	if ((val & ~(SUBCACHE_MASK | SUBCACHE_INDEX)) ||
> +	    ((val & SUBCACHE_INDEX) > this_leaf->l3_indices))
>  		return -EINVAL;
>  
>  	val |= BIT(30);
> 

Please consider applying the patch below, both for 2.6.34 and all the 
-stable kernels this patch has hit.



From: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] x86, cacheinfo: fix oops in amd_calc_l3_indices()

Commit 048a8774ca4348 ("x86, cacheinfo: Calculate L3 indices") introduced
amd_calc_l3_indices(), but this function doesn't properly handle case
when node_to_k8_nb_misc() returns NULL, causing immediate oops due to
NULL pointer dereference in pci_read_config_dword().

Make amd_calc_l3_indices() return -1 in such cases. This is correct
lower bound, as it will make store_cache_disable() return EINVAL in
all such cases.

Cc: stable@kernel.org
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index b3eeb66..b9f8dca 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -314,6 +314,9 @@ static unsigned int __cpuinit amd_calc_l3_indices(void)
 	unsigned int sc0, sc1, sc2, sc3;
 	u32 val = 0;
 
+	if (!dev)
+		return -1;
+
 	pci_read_config_dword(dev, 0x1C4, &val);
 
 	/* calculate subcache sizes */
-- 
1.6.4.2
