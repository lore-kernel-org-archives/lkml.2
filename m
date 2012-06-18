Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353Ab2FRORn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 10:17:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50665 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466Ab2FRORl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 10:17:41 -0400
Message-ID: <4FDF3874.2050208@redhat.com>
Date: Mon, 18 Jun 2012 17:17:24 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: x86@kernel.org, kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, gleb@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHv7 3/8] kvm_para: guest side for eoi avoidance
References: <cover.1339681762.git.mst@redhat.com> <4c5bedc5cb55dcea1676b913a0f6da3f04b03145.1339681762.git.mst@redhat.com>
In-Reply-To: <4c5bedc5cb55dcea1676b913a0f6da3f04b03145.1339681762.git.mst@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2012 04:53 PM, Michael S. Tsirkin wrote:
> The idea is simple: there's a bit, per APIC, in guest memory,
> that tells the guest that it does not need EOI.
> Guest tests it using a single est and clear operation - this is
> necessary so that host can detect interrupt nesting - and if set, it can
> skip the EOI MSR.
> 
> I run a simple microbenchmark to show exit reduction
> (note: for testing, need to apply follow-up patch
> 'kvm: host side for eoi optimization' + a qemu patch
>  I posted separately, on host):
> 
> 
> diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
> index a6983b2..47f9eff 100644
> --- a/arch/x86/include/asm/bitops.h
> +++ b/arch/x86/include/asm/bitops.h
> @@ -28,11 +28,13 @@
>  #if __GNUC__ < 4 || (__GNUC__ == 4 && __GNUC_MINOR__ < 1)
>  /* Technically wrong, but this avoids compilation errors on some gcc
>     versions. */
> -#define BITOP_ADDR(x) "=m" (*(volatile long *) (x))
> +#define BITOP_ADDR_CONSTRAINT "=m"
>  #else
> -#define BITOP_ADDR(x) "+m" (*(volatile long *) (x))
> +#define BITOP_ADDR_CONSTRAINT "+m"
>  #endif
>  
> +#define BITOP_ADDR(x) BITOP_ADDR_CONSTRAINT (*(volatile long *) (x))
> +
>  #define ADDR				BITOP_ADDR(addr)

What's this doing here?

>  
> +/* size alignment is implied but just to make it explicit. */
> +static DEFINE_PER_CPU(unsigned long, kvm_apic_eoi) __aligned(2) =
> +	KVM_PV_EOI_DISABLED;

You're actually breaking the alignment.  ulong has 8 byte alignment
sometimes and you can make it cross cache boundary this way.

> +
>  void __cpuinit kvm_guest_cpu_init(void)
>  {
>  	if (!kvm_para_available())
> @@ -300,11 +320,17 @@ void __cpuinit kvm_guest_cpu_init(void)
>  		       smp_processor_id());
>  	}
>  
> +	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI)) {
> +		__get_cpu_var(kvm_apic_eoi) = 0;
> +		wrmsrl(MSR_KVM_PV_EOI_EN, __pa(&__get_cpu_var(kvm_apic_eoi)) |
> +		       KVM_MSR_ENABLED);

Bad formatting.

> +	}
> +
>  	if (has_steal_clock)
>  		kvm_register_steal_time();
>  }
>  


Please check that the kexec path also disables pveoi.

-- 
error compiling committee.c: too many arguments to function


