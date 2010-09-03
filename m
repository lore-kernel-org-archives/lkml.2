Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757733Ab0ICKjn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 06:39:43 -0400
Received: from dalsmrelay2.nai.com ([205.227.136.216]:54754 "HELO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757189Ab0ICKjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 06:39:31 -0400
Message-ID: <4C80D022.5000208@snapgear.com>
Date: Fri, 3 Sep 2010 20:38:26 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] Fix M68K irqflags
References: <4C80BFCB.20106@snapgear.com> <4C809B63.2040802@snapgear.com> <4C804F3A.8020001@snapgear.com> <19747.1283422807@redhat.com> <20100902102203.19806.39028.stgit@warthog.procyon.org.uk> <7077.1283496259@redhat.com> <13782.1283501148@redhat.com> <21381.1283508336@redhat.com>
In-Reply-To: <21381.1283508336@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Sep 2010 10:38:38.0333 (UTC) FILETIME=[2B245AD0:01CB4B54]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/10 20:05, David Howells wrote:
> Greg Ungerer<gerg@snapgear.com>  wrote:
>
>> You need to apply this patch to fix this (sent to Linus,
>> but not in head yet)
>>
>> http://marc.info/?l=linux-kernel&m=128347657132425&w=2
>
> In that case, this patch works for me.  I made head.S include
> asm/thread_info.h, and now it finds THREAD_SIZE again.

Yep, that looks good to me.

Regards
Greg



> David
> ---
> From: Greg Ungerer<gerg@snapgear.com>
> Subject: [PATCH] Fix M68K irqflags
>
>
> ---
>
>   arch/m68k/include/asm/entry_no.h        |    2 -
>   arch/m68k/include/asm/irqflags.h        |   76 +++++++++++++++++++++++++++++++
>   arch/m68k/include/asm/system_mm.h       |   25 ----------
>   arch/m68k/include/asm/system_no.h       |   57 -----------------------
>   arch/m68knommu/kernel/asm-offsets.c     |    2 -
>   arch/m68knommu/platform/coldfire/head.S |    1
>   include/asm-generic/hardirq.h           |    1
>   7 files changed, 80 insertions(+), 84 deletions(-)
>   create mode 100644 arch/m68k/include/asm/irqflags.h
>
>
> diff --git a/arch/m68k/include/asm/entry_no.h b/arch/m68k/include/asm/entry_no.h
> index 907ed03..80e4149 100644
> --- a/arch/m68k/include/asm/entry_no.h
> +++ b/arch/m68k/include/asm/entry_no.h
> @@ -28,7 +28,7 @@
>    *			M68K		  COLDFIRE
>    */
>
> -#define ALLOWINT 0xf8ff
> +#define ALLOWINT (~0x700)
>
>   #ifdef __ASSEMBLY__
>
> diff --git a/arch/m68k/include/asm/irqflags.h b/arch/m68k/include/asm/irqflags.h
> new file mode 100644
> index 0000000..6d31c5c
> --- /dev/null
> +++ b/arch/m68k/include/asm/irqflags.h
> @@ -0,0 +1,76 @@
> +#ifndef _M68K_IRQFLAGS_H
> +#define _M68K_IRQFLAGS_H
> +
> +#include<linux/types.h>
> +#include<linux/hardirq.h>
> +#include<linux/preempt.h>
> +#include<asm/thread_info.h>
> +#include<asm/entry.h>
> +
> +static inline unsigned long arch_local_save_flags(void)
> +{
> +	unsigned long flags;
> +	asm volatile ("movew %%sr,%0": "=d" (flags) : : "memory");
> +	return flags;
> +}
> +
> +static inline void arch_local_irq_disable(void)
> +{
> +#ifdef CONFIG_COLDFIRE
> +	asm volatile (
> +		"move	%/sr,%%d0	\n\t"
> +		"ori.l	#0x0700,%%d0	\n\t"
> +		"move	%%d0,%/sr	\n"
> +		: /* no outputs */
> +		:
> +		: "cc", "%d0", "memory");
> +#else
> +	asm volatile ("oriw  #0x0700,%%sr" : : : "memory");
> +#endif
> +}
> +
> +static inline void arch_local_irq_enable(void)
> +{
> +#if defined(CONFIG_COLDFIRE)
> +	asm volatile (
> +		"move	%/sr,%%d0	\n\t"
> +		"andi.l	#0xf8ff,%%d0	\n\t"
> +		"move	%%d0,%/sr	\n"
> +		: /* no outputs */
> +		:
> +		: "cc", "%d0", "memory");
> +#else
> +# if defined(CONFIG_MMU)
> +	if (MACH_IS_Q40 || !hardirq_count())
> +# endif
> +		asm volatile (
> +			"andiw %0,%%sr"
> +			:
> +			: "i" (ALLOWINT)
> +			: "memory")
> +#endif
> +}
> +
> +static inline unsigned long arch_local_irq_save(void)
> +{
> +	unsigned long flags = arch_local_save_flags();
> +	arch_local_irq_disable();
> +	return flags;
> +}
> +
> +static inline void arch_local_irq_restore(unsigned long flags)
> +{
> +	asm volatile ("movew %0,%%sr": : "d" (flags) : "memory");
> +}
> +
> +static inline bool arch_irqs_disabled_flags(unsigned long flags)
> +{
> +	return (flags&  ~ALLOWINT) != 0;
> +}
> +
> +static inline bool arch_irqs_disabled(void)
> +{
> +	return arch_irqs_disabled_flags(arch_local_save_flags());
> +}
> +
> +#endif /* _M68K_IRQFLAGS_H */
> diff --git a/arch/m68k/include/asm/system_mm.h b/arch/m68k/include/asm/system_mm.h
> index dbb6515..12053c4 100644
> --- a/arch/m68k/include/asm/system_mm.h
> +++ b/arch/m68k/include/asm/system_mm.h
> @@ -3,6 +3,7 @@
>
>   #include<linux/linkage.h>
>   #include<linux/kernel.h>
> +#include<linux/irqflags.h>
>   #include<asm/segment.h>
>   #include<asm/entry.h>
>
> @@ -62,30 +63,6 @@ asmlinkage void resume(void);
>   #define smp_wmb()	barrier()
>   #define smp_read_barrier_depends()	((void)0)
>
> -/* interrupt control.. */
> -#if 0
> -#define local_irq_enable() asm volatile ("andiw %0,%%sr": : "i" (ALLOWINT) : "memory")
> -#else
> -#include<linux/hardirq.h>
> -#define local_irq_enable() ({							\
> -	if (MACH_IS_Q40 || !hardirq_count())					\
> -		asm volatile ("andiw %0,%%sr": : "i" (ALLOWINT) : "memory");	\
> -})
> -#endif
> -#define local_irq_disable() asm volatile ("oriw  #0x0700,%%sr": : : "memory")
> -#define local_save_flags(x) asm volatile ("movew %%sr,%0":"=d" (x) : : "memory")
> -#define local_irq_restore(x) asm volatile ("movew %0,%%sr": :"d" (x) : "memory")
> -
> -static inline int irqs_disabled(void)
> -{
> -	unsigned long flags;
> -	local_save_flags(flags);
> -	return flags&  ~ALLOWINT;
> -}
> -
> -/* For spinlocks etc */
> -#define local_irq_save(x)	({ local_save_flags(x); local_irq_disable(); })
> -
>   #define xchg(ptr,x) ((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
>
>   struct __xchg_dummy { unsigned long a[100]; };
> diff --git a/arch/m68k/include/asm/system_no.h b/arch/m68k/include/asm/system_no.h
> index 3c0718d..20126c0 100644
> --- a/arch/m68k/include/asm/system_no.h
> +++ b/arch/m68k/include/asm/system_no.h
> @@ -2,6 +2,7 @@
>   #define _M68KNOMMU_SYSTEM_H
>
>   #include<linux/linkage.h>
> +#include<linux/irqflags.h>
>   #include<asm/segment.h>
>   #include<asm/entry.h>
>
> @@ -46,54 +47,6 @@ asmlinkage void resume(void);
>     (last) = _last;						\
>   }
>
> -#ifdef CONFIG_COLDFIRE
> -#define local_irq_enable() __asm__ __volatile__ (		\
> -	"move %/sr,%%d0\n\t"					\
> -	"andi.l #0xf8ff,%%d0\n\t"				\
> -	"move %%d0,%/sr\n"					\
> -	: /* no outputs */					\
> -	:							\
> -        : "cc", "%d0", "memory")
> -#define local_irq_disable() __asm__ __volatile__ (		\
> -	"move %/sr,%%d0\n\t"					\
> -	"ori.l #0x0700,%%d0\n\t"				\
> -	"move %%d0,%/sr\n"					\
> -	: /* no outputs */					\
> -	:							\
> -	: "cc", "%d0", "memory")
> -/* For spinlocks etc */
> -#define local_irq_save(x) __asm__ __volatile__ (		\
> -	"movew %%sr,%0\n\t"					\
> -	"movew #0x0700,%%d0\n\t"				\
> -	"or.l  %0,%%d0\n\t"					\
> -	"movew %%d0,%/sr"					\
> -	: "=d" (x)						\
> -	:							\
> -	: "cc", "%d0", "memory")
> -#else
> -
> -/* portable version */ /* FIXME - see entry.h*/
> -#define ALLOWINT 0xf8ff
> -
> -#define local_irq_enable() asm volatile ("andiw %0,%%sr": : "i" (ALLOWINT) : "memory")
> -#define local_irq_disable() asm volatile ("oriw  #0x0700,%%sr": : : "memory")
> -#endif
> -
> -#define local_save_flags(x) asm volatile ("movew %%sr,%0":"=d" (x) : : "memory")
> -#define local_irq_restore(x) asm volatile ("movew %0,%%sr": :"d" (x) : "memory")
> -
> -/* For spinlocks etc */
> -#ifndef local_irq_save
> -#define local_irq_save(x) do { local_save_flags(x); local_irq_disable(); } while (0)
> -#endif
> -
> -#define	irqs_disabled()			\
> -({					\
> -	unsigned long flags;		\
> -	local_save_flags(flags);	\
> -	((flags&  0x0700) == 0x0700);	\
> -})
> -
>   #define iret() __asm__ __volatile__ ("rte": : :"memory", "sp", "cc")
>
>   /*
> @@ -206,12 +159,4 @@ static inline unsigned long __xchg(unsigned long x, volatile void * ptr, int siz
>   #define arch_align_stack(x) (x)
>
>
> -static inline int irqs_disabled_flags(unsigned long flags)
> -{
> -	if (flags&  0x0700)
> -		return 0;
> -	else
> -		return 1;
> -}
> -
>   #endif /* _M68KNOMMU_SYSTEM_H */
> diff --git a/arch/m68knommu/kernel/asm-offsets.c b/arch/m68knommu/kernel/asm-offsets.c
> index 9a8876f..2433502 100644
> --- a/arch/m68knommu/kernel/asm-offsets.c
> +++ b/arch/m68knommu/kernel/asm-offsets.c
> @@ -74,8 +74,6 @@ int main(void)
>
>   	DEFINE(PT_PTRACED, PT_PTRACED);
>
> -	DEFINE(THREAD_SIZE, THREAD_SIZE);
> -
>   	/* Offsets in thread_info structure */
>   	DEFINE(TI_TASK, offsetof(struct thread_info, task));
>   	DEFINE(TI_EXECDOMAIN, offsetof(struct thread_info, exec_domain));
> diff --git a/arch/m68knommu/platform/coldfire/head.S b/arch/m68knommu/platform/coldfire/head.S
> index 4b91aa2..0b2d7c7 100644
> --- a/arch/m68knommu/platform/coldfire/head.S
> +++ b/arch/m68knommu/platform/coldfire/head.S
> @@ -15,6 +15,7 @@
>   #include<asm/coldfire.h>
>   #include<asm/mcfcache.h>
>   #include<asm/mcfsim.h>
> +#include<asm/thread_info.h>
>
>   /*****************************************************************************/
>
> diff --git a/include/asm-generic/hardirq.h b/include/asm-generic/hardirq.h
> index 62f5908..c0771aa 100644
> --- a/include/asm-generic/hardirq.h
> +++ b/include/asm-generic/hardirq.h
> @@ -3,7 +3,6 @@
>
>   #include<linux/cache.h>
>   #include<linux/threads.h>
> -#include<linux/irq.h>
>
>   typedef struct {
>   	unsigned int __softirq_pending;
>

