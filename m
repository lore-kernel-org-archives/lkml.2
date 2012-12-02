Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324Ab2LBN54 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 08:57:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441Ab2LBN5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 08:57:55 -0500
Date: Sun, 2 Dec 2012 15:57:52 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Raphael S Carvalho <raphael.scarv@gmail.com>
Cc: avi@redhat.com, mtosatti@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] arch/x86/kvm/cpuid.c: cpuid_maxphyaddr "bad"
 handling.
Message-ID: <20121202135752.GB8731@redhat.com>
References: <CACz=WefC5ZKOf9rh-puHNgTsVDpS+_XWLcgRfvyv5wt3R0KT5g@mail.gmail.com>
 <CACz=WecbxF3ccS5brqqh1HfCJQeLViRfpp1UHtw9yZY8Fm1BKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACz=WecbxF3ccS5brqqh1HfCJQeLViRfpp1UHtw9yZY8Fm1BKA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2012 at 03:20:27PM -0200, Raphael S Carvalho wrote:
> Well, the below function reports the physical-address width supported
> by the processor.
> It does its work very well, though I found a detail which it doesn't
> handle at all.
> 
> PS: The following function is not a patch.
> int cpuid_maxphyaddr(struct kvm_vcpu *vcpu)
> {
>         struct kvm_cpuid_entry2 *best;
> 
>         best = kvm_find_cpuid_entry(vcpu, 0x80000000, 0);
>         if (!best || best->eax < 0x80000008)
>                 goto not_found;
>         best = kvm_find_cpuid_entry(vcpu, 0x80000008, 0);
>         if (best)
>                 return best->eax & 0xff;
> not_found:
>         return 36;
> }
> 
> As I'm seeing, its(above function) first step is to check whether the
> CPU provides the CPUID function 80000008H,
> if so, it gets the physical-address width from the available CPUID
> function, otherwise it implicitly returns 36.
> 
> Intel manual says the following:
> "For processors that do not support CPUID function 80000008H, the
> width is generally 36 if CPUID.01H:EDX.PAE [bit 6] = 1
> and 32 otherwise."
> According to the above-mentioned statement, we would have to return 32
> whether PAE is not supported by the CPU.
> So I was wondering if such a function would work efficiently on
> processors that do not support PAE extension.
> I also would like to share that MAXPHYADDR can be at most 52. However,
> not sure if such an implementation is even needed.
> 
> NOTE:
> arch/x86/include/asm/cpufeature.h provides the below macro.
> #define cpu_has_pae             boot_cpu_has(X86_FEATURE_PAE)
> Does the above macro return 1 whether CPU does support the PAE feature?
> If so, we would have to make a single change in the code:
> 
> Signed-off-by: Raphael S.Carvalho <raphael.scarv@gmail.com>
> 
> --- a/arch/x86/kvm/cpuid.c	2012-11-19 23:44:29.000000000 -0200
> +++ b/arch/x86/kvm/cpuid.c	2012-11-30 15:05:51.000000000 -0200
> @@ -617,7 +617,10 @@
>  	if (best)
>  		return best->eax & 0xff;
>  not_found:
> -	return 36;
> +	/* Check whether CPU supports PAE, if so the MAXPHYADDR
> +	 * is 36, otherwise 32.
> +	 */
> +	return (cpu_has_pae) ? 36 : 32;
>  }
> 
> Follows a different patch otherwise:
> arch/x86/include/asm/processor.h does provide a generic cpuid function
> called native_cpuid, however, I added another procedure for
> simplicity/efficiency purposes.
> 
> Signed-off-by: Raphael S.Carvalho <raphael.scarv@gmail.com>
> 
> --- a/arch/x86/kvm/cpuid.c	2012-11-19 23:44:29.000000000 -0200
> +++ b/arch/x86/kvm/cpuid.c	2012-11-30 14:28:22.000000000 -0200
> @@ -606,6 +606,30 @@
> 
> +#ifndef PAE_BIT
> +#define PAE_BIT (1ULL << 6)
> +#endif
> +static inline unsigned cpuid_cpu_pae_support(void)
> +{
> +	unsigned int __edx;
> +	const unsigned int cpu_id_param = 0x01;
> +
> +	/* According to Intel Manual we can check
> +	 * whether the processor does provide PAE by
> +	 * using the CPUID instruction.
> +	 * Syntax: CPUID.01H:EDX.PAE [bit 6] = 1
> +	 */
> +	__edx = 0;
> +	asm volatile(
> +		"cpuid"
> +		: "=d"(__edx)
> +		: "a"(cpu_id_param)
> +		: "ecx","ebx"
> +		);
> +
You need to check cpuid as seen by a guest not a host. Something
like this:

struct kvm_cpuid_entry2 *feat = kvm_find_cpuid_entry(vcpu, 1, 0)
if (feat && (feat->edx & PAE_BIT))
    return 36;
else
    return 32;

But currently KVM code assumes that PAE is always present. kvm_set_cr4()
allows PAE to be set without doing the check above.

> +	return (__edx & PAE_BIT);
> +}
> +
>  int cpuid_maxphyaddr(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_cpuid_entry2 *best;
> @@ -617,7 +641,10 @@
>  	if (best)
>  		return best->eax & 0xff;
>  not_found:
> -	return 36;
> +	/* Check whether CPU supports PAE, if so the MAXPHYADDR
> +	 * is 36, otherwise 32.
> +	 */
> +	return (cpuid_cpu_pae_support()) ? 36 : 32;
>  }
> 
> Regards,
> Raphael S.Carvalho <raphael.scarv@gmail.com>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--
			Gleb.
