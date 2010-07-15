Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757766Ab0GOA2u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 20:28:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756894Ab0GOA2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 20:28:49 -0400
Message-ID: <4C3E5637.4010300@redhat.com>
Date: Wed, 14 Jul 2010 14:28:39 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Glauber Costa <glommer@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Avi Kivity <avi@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix ordering constraints on crX read/writes
References: <4C3E363B.7060804@goop.org>
In-Reply-To: <4C3E363B.7060804@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2010 12:12 PM, Jeremy Fitzhardinge wrote:
> Change d3ca901f94b3299 introduces a new mechanism for sequencing
> accesses to the control registers using a variable to act as a
> dependency.  (However, the patch description only says it is unifying
> parts of system.h and makes no mention of this new code.)
>
> This sequencing implementation is flawed in two ways:
>   - Firstly, it gets the input/outputs for __force_order wrong on
>     the asm statements.  __force_order is a proxy for the control
>     registers themselves, so a write_crX should write __force_order,
>     and conversely for read_crX.  The original code got this backwards,
>     making write_crX read from __force_order, which in principle would
>     allow gcc to eliminate a "redundant" write_crX.
>
>   - Secondly, writes to control registers can have drastic
>     side-effects on all memory operations (write to cr3 changes the
>     current pagetable and redefines the meaning of all addresses,
>     for example), so they must clobber "memory" in order to be
>     ordered with respect to memory operations.
>
> We seem to have been saved by the implicit ordering that "asm volatile"
> gives us.
>
> Signed-off-by: Jeremy Fitzhardinge<jeremy.fitzhardinge@citrix.com>
> Cc: Glauber de Oliveira Costa<gcosta@redhat.com>
> Cc: Ingo Molnar<mingo@elte.hu>
> Cc: "H. Peter Anvin"<hpa@zytor.com>
> Cc: Thomas Gleixner<tglx@linutronix.de>
> Cc: Avi Kivity<avi@redhat.com>
> Cc: Zachary Amsden<zamsden@redhat.com>
>
> diff --git a/arch/x86/include/asm/system.h b/arch/x86/include/asm/system.h
> index e7f4d33..b782af2 100644
> --- a/arch/x86/include/asm/system.h
> +++ b/arch/x86/include/asm/system.h
> @@ -212,53 +212,68 @@ static inline void native_clts(void)
>
>   /*
>    * Volatile isn't enough to prevent the compiler from reordering the
> - * read/write functions for the control registers and messing everything up.
> - * A memory clobber would solve the problem, but would prevent reordering of
> - * all loads stores around it, which can hurt performance. Solution is to
> - * use a variable and mimic reads and writes to it to enforce serialization
> + * read/write functions for the control registers and messing
> + * everything up.  A memory clobber would solve the problem, but would
> + * prevent reordering of all loads stores around it, which can hurt
> + * performance (however, control register writes can have drastic
> + * effects on memory accesses - like switching pagetables and thereby
> + * redefining what an address means - so they still need to clobber
> + * memory).
> + *
> + * Solution is to use a variable and mimic reads and writes to it to
> + * enforce serialization.  __force_order acts as a proxy for the
> + * control registers, so a read_crX reads __force_order, and write_crX
> + * writes it (actually both reads and writes it to indicate that
> + * write-over-write can't be "optimised" away).
> + *
> + * This assumes there's no global optimisation between object files,
> + * so using a static per-file "__force_order" is OK.  (In theory we
> + * don't need __force_order to be instantiated at all, since it is
> + * never actually read or written to.  But gcc might decide to
> + * generate a reference to it anyway, so we need to keep it around.)
>    */
>   static unsigned long __force_order;
>
>   static inline unsigned long native_read_cr0(void)
>   {
>   	unsigned long val;
> -	asm volatile("mov %%cr0,%0\n\t" : "=r" (val), "=m" (__force_order));
> +	asm volatile("mov %%cr0,%0\n\t" : "=r" (val) : "m" (__force_order));
>   	return val;
>   }
>
>   static inline void native_write_cr0(unsigned long val)
>   {
> -	asm volatile("mov %0,%%cr0": : "r" (val), "m" (__force_order));
> +	asm volatile("mov %1,%%cr0": "+m" (__force_order) : "r" (val) : "memory");
>   }
>
>   static inline unsigned long native_read_cr2(void)
>   {
>   	unsigned long val;
> -	asm volatile("mov %%cr2,%0\n\t" : "=r" (val), "=m" (__force_order));
> +	asm volatile("mov %%cr2,%0\n\t" : "=r" (val) : "m" (__force_order));
>   	return val;
>   }
>
>   static inline void native_write_cr2(unsigned long val)
>   {
> -	asm volatile("mov %0,%%cr2": : "r" (val), "m" (__force_order));
> +	asm volatile("mov %1,%%cr2": "+m" (__force_order) : "r" (val) : "memory");
>   }
>    

You don't need the memory clobber there.  Technically, this should never 
be used, however.

>
>   static inline unsigned long native_read_cr3(void)
>   {
>   	unsigned long val;
> -	asm volatile("mov %%cr3,%0\n\t" : "=r" (val), "=m" (__force_order));
> +	asm volatile("mov %%cr3,%0\n\t" : "=r" (val) : "m" (__force_order));
>   	return val;
>   }
>
>   static inline void native_write_cr3(unsigned long val)
>   {
> -	asm volatile("mov %0,%%cr3": : "r" (val), "m" (__force_order));
> +	asm volatile("mov %1,%%cr3": "+m" (__force_order) : "r" (val) : "memory");
>   }
>
>   static inline unsigned long native_read_cr4(void)
>   {
>   	unsigned long val;
> -	asm volatile("mov %%cr4,%0\n\t" : "=r" (val), "=m" (__force_order));
> +	asm volatile("mov %%cr4,%0\n\t" : "=r" (val) : "m" (__force_order));
>   	return val;
>   }
>
> @@ -271,7 +286,7 @@ static inline unsigned long native_read_cr4_safe(void)
>   	asm volatile("1: mov %%cr4, %0\n"
>   		     "2:\n"
>   		     _ASM_EXTABLE(1b, 2b)
> -		     : "=r" (val), "=m" (__force_order) : "0" (0));
> +		     : "=r" (val) : "m" (__force_order), "0" (0));
>   #else
>   	val = native_read_cr4();
>   #endif
> @@ -280,7 +295,7 @@ static inline unsigned long native_read_cr4_safe(void)
>
>   static inline void native_write_cr4(unsigned long val)
>   {
> -	asm volatile("mov %0,%%cr4": : "r" (val), "m" (__force_order));
> +	asm volatile("mov %1,%%cr4": "+m" (__force_order) : "r" (val) : "memory");
>   }
>
>   #ifdef CONFIG_X86_64
>
>
>    

Looks good.  I really hope __force_order gets pruned however.  Does it 
actually?
