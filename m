Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053Ab1ETVNh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 17:13:37 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:36666 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756356Ab1ETVN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 17:13:27 -0400
Message-ID: <4DD6D965.4010606@kernel.org>
Date: Fri, 20 May 2011 14:13:09 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/smep] x86, cpu: Enable/disable Supervisor Mode Execution
 Protection
References: <1305157865-31727-1-git-send-email-fenghua.yu@intel.com> <tip-de5397ad5b9ad22e2401c4dacdf1bb3b19c05679@git.kernel.org>
In-Reply-To: <tip-de5397ad5b9ad22e2401c4dacdf1bb3b19c05679@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4DD6D96A.0112,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2011 10:13 PM, tip-bot for Fenghua Yu wrote:
> Commit-ID:  de5397ad5b9ad22e2401c4dacdf1bb3b19c05679
> Gitweb:     http://git.kernel.org/tip/de5397ad5b9ad22e2401c4dacdf1bb3b19c05679
> Author:     Fenghua Yu <fenghua.yu@intel.com>
> AuthorDate: Wed, 11 May 2011 16:51:05 -0700
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Tue, 17 May 2011 21:22:00 -0700
> 
> x86, cpu: Enable/disable Supervisor Mode Execution Protection
> 
> Enable/disable newly documented SMEP (Supervisor Mode Execution Protection) CPU
> feature in kernel. CR4.SMEP (bit 20) is 0 at power-on. If the feature is
> supported by CPU (X86_FEATURE_SMEP), enable SMEP by setting CR4.SMEP. New kernel
> option nosmep disables the feature even if the feature is supported by CPU.
> 
> [ hpa: moved the call to setup_smep() until after the vendor-specific
>   initialization; that ensures that CPUID features are unmasked.  We
>   will still run it before we have userspace (never mind uncontrolled
>   userspace). ]
> 
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> LKML-Reference: <1305157865-31727-1-git-send-email-fenghua.yu@intel.com>
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> ---
>  Documentation/kernel-parameters.txt |    4 ++++
>  arch/x86/kernel/cpu/common.c        |   23 +++++++++++++++++++++++
>  2 files changed, 27 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index cc85a92..56fb8c1 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -1664,6 +1664,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  			noexec=on: enable non-executable mappings (default)
>  			noexec=off: disable non-executable mappings
>  
> +	nosmep		[X86]
> +			Disable SMEP (Supervisor Mode Execution Protection)
> +			even if it is supported by processor.
> +
>  	noexec32	[X86-64]
>  			This affects only 32-bit executables.
>  			noexec32=on: enable non-executable mappings (default)
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index 173f3a3..cbc70a2 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -254,6 +254,25 @@ static inline void squash_the_stupid_serial_number(struct cpuinfo_x86 *c)
>  }
>  #endif
>  
> +static int disable_smep __initdata;
> +static __init int setup_disable_smep(char *arg)
> +{
> +	disable_smep = 1;
> +	return 1;
> +}
> +__setup("nosmep", setup_disable_smep);
> +
> +static __init void setup_smep(struct cpuinfo_x86 *c)
> +{
> +	if (cpu_has(c, X86_FEATURE_SMEP)) {
> +		if (unlikely(disable_smep)) {
> +			setup_clear_cpu_cap(X86_FEATURE_SMEP);
> +			clear_in_cr4(X86_CR4_SMEP);
> +		} else
> +			set_in_cr4(X86_CR4_SMEP);
> +	}
> +}

should be __cpuinit for this function.

otherwise got:

WARNING: arch/x86/built-in.o(.cpuinit.text+0x1b10): Section mismatch in reference from the function identify_cpu() to the function .init.text:setup_smep()
The function __cpuinit identify_cpu() references
a function __init setup_smep().
If setup_smep is only used by identify_cpu then
annotate setup_smep with a matching annotation.


> +
>  /*
>   * Some CPU features depend on higher CPUID levels, which may not always
>   * be available due to CPUID level capping or broken virtualization
> @@ -667,6 +686,8 @@ static void __init early_identify_cpu(struct cpuinfo_x86 *c)
>  	c->cpu_index = 0;
>  #endif
>  	filter_cpuid_features(c, false);
> +
> +	setup_smep(c);
>  }
>  
>  void __init early_cpu_init(void)
> @@ -752,6 +773,8 @@ static void __cpuinit generic_identify(struct cpuinfo_x86 *c)
>  #endif
>  	}
>  
> +	setup_smep(c);
> +
>  	get_model_name(c); /* Default name */
>  
>  	detect_nopl(c);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-tip-commits" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

