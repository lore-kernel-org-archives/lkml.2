Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751587Ab1AEHom (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 02:44:42 -0500
Received: from mga14.intel.com ([143.182.124.37]:55058 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420Ab1AEHol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 02:44:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,277,1291622400"; 
   d="scan'208";a="370261188"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH 2/2 v2] xen: HVM X2APIC support
Date: Wed, 5 Jan 2011 15:47:11 +0800
User-Agent: KMail/1.13.5 (Linux/2.6.35-23-generic; KDE/4.5.1; x86_64; ; )
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
References: <1292912329-12451-1-git-send-email-sheng@linux.intel.com> <1292912329-12451-2-git-send-email-sheng@linux.intel.com>
In-Reply-To: <1292912329-12451-2-git-send-email-sheng@linux.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201101051547.12107.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 December 2010 14:18:49 Sheng Yang wrote:
> This patch is similiar to Gleb Natapov's patch for KVM, which enable the
> hypervisor to emulate x2apic feature for the guest. By this way, the
> emulation of lapic would be simpler with x2apic interface(MSR), and
> faster.
> 
> Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Signed-off-by: Sheng Yang <sheng@linux.intel.com>
> ---

Jeremy & Konrad, 

We also need this one.

Thanks!

--
regards
Yang, Sheng

>  arch/x86/include/asm/hypervisor.h     |    3 ++
>  arch/x86/include/asm/xen/hypervisor.h |   35
> +++++++++++++++++++++++++++++++++ arch/x86/xen/enlighten.c              | 
>  30 ++++++++++----------------- 3 files changed, 49 insertions(+), 19
> deletions(-)
> 
> diff --git a/arch/x86/include/asm/hypervisor.h
> b/arch/x86/include/asm/hypervisor.h index 0c6f7af..7a15153 100644
> --- a/arch/x86/include/asm/hypervisor.h
> +++ b/arch/x86/include/asm/hypervisor.h
> @@ -21,6 +21,7 @@
>  #define _ASM_X86_HYPERVISOR_H
> 
>  #include <asm/kvm_para.h>
> +#include <asm/xen/hypervisor.h>
> 
>  extern void init_hypervisor(struct cpuinfo_x86 *c);
>  extern void init_hypervisor_platform(void);
> @@ -53,6 +54,8 @@ static inline bool hypervisor_x2apic_available(void)
>  {
>  	if (kvm_para_available())
>  		return true;
> +	if (xen_x2apic_para_available())
> +		return true;
>  	return false;
>  }
> 
> diff --git a/arch/x86/include/asm/xen/hypervisor.h
> b/arch/x86/include/asm/xen/hypervisor.h index 396ff4c..66d0fff 100644
> --- a/arch/x86/include/asm/xen/hypervisor.h
> +++ b/arch/x86/include/asm/xen/hypervisor.h
> @@ -37,4 +37,39 @@
>  extern struct shared_info *HYPERVISOR_shared_info;
>  extern struct start_info *xen_start_info;
> 
> +#include <asm/processor.h>
> +
> +static inline uint32_t xen_cpuid_base(void)
> +{
> +	uint32_t base, eax, ebx, ecx, edx;
> +	char signature[13];
> +
> +	for (base = 0x40000000; base < 0x40010000; base += 0x100) {
> +		cpuid(base, &eax, &ebx, &ecx, &edx);
> +		*(uint32_t *)(signature + 0) = ebx;
> +		*(uint32_t *)(signature + 4) = ecx;
> +		*(uint32_t *)(signature + 8) = edx;
> +		signature[12] = 0;
> +
> +		if (!strcmp("XenVMMXenVMM", signature) && ((eax - base) >= 2))
> +			return base;
> +	}
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_XEN
> +extern bool xen_hvm_need_lapic(void);
> +
> +static inline bool xen_x2apic_para_available(void)
> +{
> +	return xen_hvm_need_lapic();
> +}
> +#else
> +static inline bool xen_x2apic_para_available(void)
> +{
> +	return (xen_cpuid_base() != 0);
> +}
> +#endif
> +
>  #endif /* _ASM_X86_XEN_HYPERVISOR_H */
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index 44dcad4..bb8aa31 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -1256,25 +1256,6 @@ asmlinkage void __init xen_start_kernel(void)
>  #endif
>  }
> 
> -static uint32_t xen_cpuid_base(void)
> -{
> -	uint32_t base, eax, ebx, ecx, edx;
> -	char signature[13];
> -
> -	for (base = 0x40000000; base < 0x40010000; base += 0x100) {
> -		cpuid(base, &eax, &ebx, &ecx, &edx);
> -		*(uint32_t *)(signature + 0) = ebx;
> -		*(uint32_t *)(signature + 4) = ecx;
> -		*(uint32_t *)(signature + 8) = edx;
> -		signature[12] = 0;
> -
> -		if (!strcmp("XenVMMXenVMM", signature) && ((eax - base) >= 2))
> -			return base;
> -	}
> -
> -	return 0;
> -}
> -
>  static int init_hvm_pv_info(int *major, int *minor)
>  {
>  	uint32_t eax, ebx, ecx, edx, pages, msr, base;
> @@ -1384,6 +1365,17 @@ static bool __init xen_hvm_platform(void)
>  	return true;
>  }
> 
> +bool xen_hvm_need_lapic(void)
> +{
> +	if (xen_pv_domain())
> +		return false;
> +	if (xen_hvm_domain() && xen_feature(XENFEAT_hvm_pirqs) &&
> +			xen_have_vector_callback)
> +		return false;
> +	return (xen_cpuid_base() != 0);
> +}
> +EXPORT_SYMBOL_GPL(xen_hvm_need_lapic);
> +
>  const __refconst struct hypervisor_x86 x86_hyper_xen_hvm = {
>  	.name			= "Xen HVM",
>  	.detect			= xen_hvm_platform,
