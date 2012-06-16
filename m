Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757145Ab2FPVHs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 17:07:48 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:40172 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756849Ab2FPVHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 17:07:47 -0400
Message-ID: <1339880865.23975.2.camel@joe2Laptop>
Subject: Re: [PATCH] x86: cpu: use printk_once
From: Joe Perches <joe@perches.com>
To: dave@gnu.org
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Date: Sat, 16 Jun 2012 14:07:45 -0700
In-Reply-To: <1339875916.3269.4.camel@offbook>
References: <1339875916.3269.4.camel@offbook>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-06-16 at 21:45 +0200, Davidlohr Bueso wrote:
> Use printk_once() instead of extra variables.

This is _very_ slightly larger.
The only thing I'd change is to use true instead of 1;
Well, I might use pr_info too...

> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
[]
> @@ -457,7 +457,6 @@ void __cpuinit detect_ht(struct cpuinfo_x86 *c)
>  #ifdef CONFIG_X86_HT
>  	u32 eax, ebx, ecx, edx;
>  	int index_msb, core_bits;
> -	static bool printed;
>  
>  	if (!cpu_has(c, X86_FEATURE_HT))
>  		return;
> @@ -493,12 +492,11 @@ void __cpuinit detect_ht(struct cpuinfo_x86 *c)
>  				       ((1 << core_bits) - 1);
>  
>  out:
> -	if (!printed && (c->x86_max_cores * smp_num_siblings) > 1) {
> -		printk(KERN_INFO  "CPU: Physical Processor ID: %d\n",
> -		       c->phys_proc_id);
> -		printk(KERN_INFO  "CPU: Processor Core ID: %d\n",
> -		       c->cpu_core_id);
> -		printed = 1;
> +	if ((c->x86_max_cores * smp_num_siblings) > 1) {
> +		printk_once(KERN_INFO  "CPU: Physical Processor ID: %d\n",
> +			    c->phys_proc_id);
> +		printk_once(KERN_INFO  "CPU: Processor Core ID: %d\n",
> +			    c->cpu_core_id);
>  	}
>  #endif
>  }
> diff --git a/arch/x86/kernel/cpu/topology.c b/arch/x86/kernel/cpu/topology.c
> index 4397e98..2f01ae0 100644
> --- a/arch/x86/kernel/cpu/topology.c
> +++ b/arch/x86/kernel/cpu/topology.c
> @@ -32,7 +32,6 @@ void __cpuinit detect_extended_topology(struct cpuinfo_x86 *c)
>  	unsigned int eax, ebx, ecx, edx, sub_index;
>  	unsigned int ht_mask_width, core_plus_mask_width;
>  	unsigned int core_select_mask, core_level_siblings;
> -	static bool printed;
>  
>  	if (c->cpuid_level < 0xb)
>  		return;
> @@ -86,14 +85,9 @@ void __cpuinit detect_extended_topology(struct cpuinfo_x86 *c)
>  
>  	c->x86_max_cores = (core_level_siblings / smp_num_siblings);
>  
> -	if (!printed) {
> -		printk(KERN_INFO  "CPU: Physical Processor ID: %d\n",
> -		       c->phys_proc_id);
> -		if (c->x86_max_cores > 1)
> -			printk(KERN_INFO  "CPU: Processor Core ID: %d\n",
> -			       c->cpu_core_id);
> -		printed = 1;
> -	}
> +	printk_once(KERN_INFO  "CPU: Physical Processor ID: %d\n", c->phys_proc_id);
> +	if (c->x86_max_cores > 1)
> +		printk_once(KERN_INFO  "CPU: Processor Core ID: %d\n", c->cpu_core_id);
>  	return;
>  #endif
>  }



