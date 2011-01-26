Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab1AZU42 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 15:56:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58476 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966Ab1AZU41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 15:56:27 -0500
Date: Wed, 26 Jan 2011 21:56:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: hpa@zytor.com, tglx@linutronix.de, Andreas.Herrmann3@amd.com,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 4/4] x86, amd: Support L3 Cache Partitioning on AMD
 family 0x15 CPUs
Message-ID: <20110126205608.GA14361@elte.hu>
References: <20110126105637.GA27809@elte.hu>
 <1296061716-185599-1-git-send-email-hans.rosenfeld@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296061716-185599-1-git-send-email-hans.rosenfeld@amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.8
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.8 required=5.9 tests=BAYES_00,SUBJECT_FUZZY_TION autolearn=no SpamAssassin version=3.2.5
	0.2 SUBJECT_FUZZY_TION     Attempt to obfuscate words in Subject:
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hans Rosenfeld <hans.rosenfeld@amd.com> wrote:

> L3 Cache Partitioning allows selecting which of the 4 L3 subcaches can
> be used for evictions by the L2 cache of each compute unit. By writing a
> 4-bit hexadecimal mask into the the sysfs file /sys/devices/system/cpu/\
> cpuX/cache/index3/subcaches, the user can set the enabled subcaches for
> a CPU. The settings are directly read from and written to the hardware,
> so there is no way to have contradicting settings for two CPUs belonging
> to the same compute unit. Writing will always overwrite any previous
> setting for a compute unit.
> 
> Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
> ---
>  arch/x86/include/asm/amd_nb.h         |    3 +
>  arch/x86/kernel/amd_nb.c              |   57 ++++++++++++++++++++++++
>  arch/x86/kernel/cpu/intel_cacheinfo.c |   77 +++++++++++++++++++++++++++-----
>  3 files changed, 125 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/include/asm/amd_nb.h b/arch/x86/include/asm/amd_nb.h
> index 3e70700..423f11c 100644
> --- a/arch/x86/include/asm/amd_nb.h
> +++ b/arch/x86/include/asm/amd_nb.h
> @@ -18,6 +18,8 @@ extern int amd_cache_northbridges(void);
>  extern void amd_flush_garts(void);
>  extern int amd_numa_init(unsigned long start_pfn, unsigned long end_pfn);
>  extern int amd_scan_nodes(void);
> +extern int amd_get_subcaches(int);
> +extern int amd_set_subcaches(int, int);
>  
>  #ifdef CONFIG_NUMA_EMU
>  extern void amd_fake_nodes(const struct bootnode *nodes, int nr_nodes);
> @@ -38,6 +40,7 @@ extern struct amd_northbridge_info amd_northbridges;
>  
>  #define AMD_NB_GART			0x1
>  #define AMD_NB_L3_INDEX_DISABLE		0x2
> +#define AMD_NB_L3_PARTITIONING		0x4
>  
>  #ifdef CONFIG_AMD_NB
>  
> diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
> index 4ae9a96..63310de 100644
> --- a/arch/x86/kernel/amd_nb.c
> +++ b/arch/x86/kernel/amd_nb.c
> @@ -95,6 +95,10 @@ int amd_cache_northbridges(void)
>  	if (boot_cpu_data.x86 == 0x15)
>  		amd_northbridges.flags |= AMD_NB_L3_INDEX_DISABLE;
>  
> +	/* L3 cache partitioning is supported on family 0x15 */
> +	if (boot_cpu_data.x86 == 0x15)
> +		amd_northbridges.flags |= AMD_NB_L3_PARTITIONING;
> +
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(amd_cache_northbridges);
> @@ -112,6 +116,59 @@ int __init early_is_amd_nb(u32 device)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_SMP
> +int amd_get_subcaches(int cpu)

Well, sprinkling it with CONFIG_SMP is pretty ugly. Also, there's no fundamental 
reason why this shouldnt work with UP. Yes, it makes most sense on SMP but such code 
should be SMP-invariant.

Thanks,

	Ingo
