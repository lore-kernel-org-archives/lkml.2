Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab0LTHkn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 02:40:43 -0500
Received: from claw.goop.org ([74.207.240.146]:40297 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753747Ab0LTHkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 02:40:42 -0500
Message-ID: <4D0F0870.1090006@goop.org>
Date: Sun, 19 Dec 2010 23:40:32 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Sheng Yang <sheng@linux.intel.com>
CC: linux-kernel@vger.kernel.org, konrad.wilk@oracle.com,
        xen-devel <xen-devel@lists.xensource.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [Xen-devel] Re: [PATCH 2/2 v2] xen: HVM X2APIC support
References: <1291788240-12130-1-git-send-email-sheng@linux.intel.com>	<1291788240-12130-2-git-send-email-sheng@linux.intel.com> <201012171620.22375.sheng@linux.intel.com>
In-Reply-To: <201012171620.22375.sheng@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2010 12:20 AM, Sheng Yang wrote:
> On Wednesday 08 December 2010 14:04:00 Sheng Yang wrote:
>> This patch is similiar to Gleb Natapov's patch for KVM, which enable the
>> hypervisor to emulate x2apic feature for the guest. By this way, the
>> emulation of lapic would be simpler with x2apic interface(MSR), and
>> faster.
>>
>> Signed-off-by: Sheng Yang <sheng@linux.intel.com>
> Jeremy, any comments? 
>
> Keir has already checked the hypervisor part in.

Yes, I suppose its OK.  You can add

Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

I think you should send it upstream via the x86 maintainers in tip.git.

    J

> --
> regards
> Yang, Sheng
>
>> ---
>>  arch/x86/include/asm/hypervisor.h     |    3 ++
>>  arch/x86/include/asm/xen/hypervisor.h |   35
>> +++++++++++++++++++++++++++++++++ arch/x86/xen/enlighten.c              | 
>>  30 ++++++++++----------------- 3 files changed, 49 insertions(+), 19
>> deletions(-)
>>
>> diff --git a/arch/x86/include/asm/hypervisor.h
>> b/arch/x86/include/asm/hypervisor.h index 0c6f7af..7a15153 100644
>> --- a/arch/x86/include/asm/hypervisor.h
>> +++ b/arch/x86/include/asm/hypervisor.h
>> @@ -21,6 +21,7 @@
>>  #define _ASM_X86_HYPERVISOR_H
>>
>>  #include <asm/kvm_para.h>
>> +#include <asm/xen/hypervisor.h>
>>
>>  extern void init_hypervisor(struct cpuinfo_x86 *c);
>>  extern void init_hypervisor_platform(void);
>> @@ -53,6 +54,8 @@ static inline bool hypervisor_x2apic_available(void)
>>  {
>>  	if (kvm_para_available())
>>  		return true;
>> +	if (xen_x2apic_para_available())
>> +		return true;
>>  	return false;
>>  }
>>
>> diff --git a/arch/x86/include/asm/xen/hypervisor.h
>> b/arch/x86/include/asm/xen/hypervisor.h index 396ff4c..66d0fff 100644
>> --- a/arch/x86/include/asm/xen/hypervisor.h
>> +++ b/arch/x86/include/asm/xen/hypervisor.h
>> @@ -37,4 +37,39 @@
>>  extern struct shared_info *HYPERVISOR_shared_info;
>>  extern struct start_info *xen_start_info;
>>
>> +#include <asm/processor.h>
>> +
>> +static inline uint32_t xen_cpuid_base(void)
>> +{
>> +	uint32_t base, eax, ebx, ecx, edx;
>> +	char signature[13];
>> +
>> +	for (base = 0x40000000; base < 0x40010000; base += 0x100) {
>> +		cpuid(base, &eax, &ebx, &ecx, &edx);
>> +		*(uint32_t *)(signature + 0) = ebx;
>> +		*(uint32_t *)(signature + 4) = ecx;
>> +		*(uint32_t *)(signature + 8) = edx;
>> +		signature[12] = 0;
>> +
>> +		if (!strcmp("XenVMMXenVMM", signature) && ((eax - base) >= 2))
>> +			return base;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +#ifdef CONFIG_XEN
>> +extern bool xen_hvm_need_lapic(void);
>> +
>> +static inline bool xen_x2apic_para_available(void)
>> +{
>> +	return xen_hvm_need_lapic();
>> +}
>> +#else
>> +static inline bool xen_x2apic_para_available(void)
>> +{
>> +	return (xen_cpuid_base() != 0);
>> +}
>> +#endif
>> +
>>  #endif /* _ASM_X86_XEN_HYPERVISOR_H */
>> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
>> index 44dcad4..bb8aa31 100644
>> --- a/arch/x86/xen/enlighten.c
>> +++ b/arch/x86/xen/enlighten.c
>> @@ -1256,25 +1256,6 @@ asmlinkage void __init xen_start_kernel(void)
>>  #endif
>>  }
>>
>> -static uint32_t xen_cpuid_base(void)
>> -{
>> -	uint32_t base, eax, ebx, ecx, edx;
>> -	char signature[13];
>> -
>> -	for (base = 0x40000000; base < 0x40010000; base += 0x100) {
>> -		cpuid(base, &eax, &ebx, &ecx, &edx);
>> -		*(uint32_t *)(signature + 0) = ebx;
>> -		*(uint32_t *)(signature + 4) = ecx;
>> -		*(uint32_t *)(signature + 8) = edx;
>> -		signature[12] = 0;
>> -
>> -		if (!strcmp("XenVMMXenVMM", signature) && ((eax - base) >= 2))
>> -			return base;
>> -	}
>> -
>> -	return 0;
>> -}
>> -
>>  static int init_hvm_pv_info(int *major, int *minor)
>>  {
>>  	uint32_t eax, ebx, ecx, edx, pages, msr, base;
>> @@ -1384,6 +1365,17 @@ static bool __init xen_hvm_platform(void)
>>  	return true;
>>  }
>>
>> +bool xen_hvm_need_lapic(void)
>> +{
>> +	if (xen_pv_domain())
>> +		return false;
>> +	if (xen_hvm_domain() && xen_feature(XENFEAT_hvm_pirqs) &&
>> +			xen_have_vector_callback)
>> +		return false;
>> +	return (xen_cpuid_base() != 0);
>> +}
>> +EXPORT_SYMBOL_GPL(xen_hvm_need_lapic);
>> +
>>  const __refconst struct hypervisor_x86 x86_hyper_xen_hvm = {
>>  	.name			= "Xen HVM",
>>  	.detect			= xen_hvm_platform,
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel
>

