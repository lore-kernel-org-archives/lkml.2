Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561Ab1GERXx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 13:23:53 -0400
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:4942
	"EHLO DB3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752246Ab1GERXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 13:23:52 -0400
X-SpamScore: -12
X-BigFish: VPS-12(zz4015L1432N98dKzz1202hzz8275bhz32i668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LNVEX4-02-C6F-02
X-M-MSG: 
Date: Tue, 5 Jul 2011 19:22:15 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH] x86: Make copy_from_user_nmi() a library function
Message-ID: <20110705172215.GE4590@erda.amd.com>
References: <COL116-W380DF5357514E3CC28BB66A38F0@phx.gbl>
 <4DD5046F.3000807@us.ibm.com>
 <4DD53BC8.2010208@hotmail.com>
 <20110607105259.GE20052@erda.amd.com>
 <4DEE2F09.6090803@hotmail.com>
 <20110607171822.GI20052@erda.amd.com>
 <20110607172413.GJ20052@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110607172413.GJ20052@erda.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.06.11 19:24:13, Robert Richter wrote:
> On 07.06.11 19:18:22, Robert Richter wrote:
> > From c73bebe2e281ae089499d7cbc3b44a0869c8daf8 Mon Sep 17 00:00:00 2001
> > From: Robert Richter <robert.richter@amd.com>
> > Date: Fri, 3 Jun 2011 16:37:47 +0200
> > Subject: [PATCH] oprofile, x86: Fix nmi-unsafe callgraph support
> 
> While this patch was a stable fix which introduced duplicate code for
> perf and oprofile I suggest merging the code, see the patch below.
> 
> -Robert
> 
> 
> From 3652d1b07a0cfce5b26ad186594c1bf8f9ca5898 Mon Sep 17 00:00:00 2001
> From: Robert Richter <robert.richter@amd.com>
> Date: Tue, 7 Jun 2011 11:49:55 +0200
> Subject: [PATCH] x86: Make copy_from_user_nmi() a library function
> 
> copy_from_user_nmi() is used in oprofile and perf. Moving it to other
> library functions like copy_from_user(). As this is x86 code for 32
> and 64 bits, create a new file usercopy.c for unified code.
> 
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  arch/x86/include/asm/uaccess.h   |    3 ++
>  arch/x86/kernel/cpu/perf_event.c |   35 ------------------------------
>  arch/x86/lib/Makefile            |    2 +-
>  arch/x86/lib/usercopy.c          |   43 ++++++++++++++++++++++++++++++++++++++
>  arch/x86/oprofile/backtrace.c    |   39 +---------------------------------
>  5 files changed, 48 insertions(+), 74 deletions(-)
>  create mode 100644 arch/x86/lib/usercopy.c

Ingo, Peter,

what about this patch? Any opinion? This one should be against
tip/perf/core now.

Thanks,

-Robert

> 
> diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
> index abd3e0e..c0236e9 100644
> --- a/arch/x86/include/asm/uaccess.h
> +++ b/arch/x86/include/asm/uaccess.h
> @@ -556,6 +556,9 @@ struct __large_struct { unsigned long buf[100]; };
>  
>  #endif /* CONFIG_X86_WP_WORKS_OK */
>  
> +extern unsigned long
> +copy_from_user_nmi(void *to, const void __user *from, unsigned long n);
> +
>  /*
>   * movsl can be slow when source and dest are not both 8-byte aligned
>   */
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index e638689..46bf36d 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -22,7 +22,6 @@
>  #include <linux/sched.h>
>  #include <linux/uaccess.h>
>  #include <linux/slab.h>
> -#include <linux/highmem.h>
>  #include <linux/cpu.h>
>  #include <linux/bitops.h>
>  
> @@ -43,40 +42,6 @@ do {								\
>  } while (0)
>  #endif
>  
> -/*
> - * best effort, GUP based copy_from_user() that assumes IRQ or NMI context
> - */
> -static unsigned long
> -copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
> -{
> -	unsigned long offset, addr = (unsigned long)from;
> -	unsigned long size, len = 0;
> -	struct page *page;
> -	void *map;
> -	int ret;
> -
> -	do {
> -		ret = __get_user_pages_fast(addr, 1, 0, &page);
> -		if (!ret)
> -			break;
> -
> -		offset = addr & (PAGE_SIZE - 1);
> -		size = min(PAGE_SIZE - offset, n - len);
> -
> -		map = kmap_atomic(page);
> -		memcpy(to, map+offset, size);
> -		kunmap_atomic(map);
> -		put_page(page);
> -
> -		len  += size;
> -		to   += size;
> -		addr += size;
> -
> -	} while (len < n);
> -
> -	return len;
> -}
> -
>  struct event_constraint {
>  	union {
>  		unsigned long	idxmsk[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
> diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
> index f2479f1..6ba4773 100644
> --- a/arch/x86/lib/Makefile
> +++ b/arch/x86/lib/Makefile
> @@ -18,7 +18,7 @@ obj-$(CONFIG_SMP) += msr-smp.o cache-smp.o
>  
>  lib-y := delay.o
>  lib-y += thunk_$(BITS).o
> -lib-y += usercopy_$(BITS).o getuser.o putuser.o
> +lib-y += usercopy_$(BITS).o usercopy.o getuser.o putuser.o
>  lib-y += memcpy_$(BITS).o
>  lib-$(CONFIG_INSTRUCTION_DECODER) += insn.o inat.o
>  
> diff --git a/arch/x86/lib/usercopy.c b/arch/x86/lib/usercopy.c
> new file mode 100644
> index 0000000..4ef83d3
> --- /dev/null
> +++ b/arch/x86/lib/usercopy.c
> @@ -0,0 +1,43 @@
> +/*
> + * User address space access functions.
> + *
> + *  For licencing details see kernel-base/COPYING
> + */
> +
> +#include <linux/highmem.h>
> +#include <linux/module.h>
> +
> +/*
> + * best effort, GUP based copy_from_user() that assumes IRQ or NMI context
> + */
> +unsigned long
> +copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
> +{
> +	unsigned long offset, addr = (unsigned long)from;
> +	unsigned long size, len = 0;
> +	struct page *page;
> +	void *map;
> +	int ret;
> +
> +	do {
> +		ret = __get_user_pages_fast(addr, 1, 0, &page);
> +		if (!ret)
> +			break;
> +
> +		offset = addr & (PAGE_SIZE - 1);
> +		size = min(PAGE_SIZE - offset, n - len);
> +
> +		map = kmap_atomic(page);
> +		memcpy(to, map+offset, size);
> +		kunmap_atomic(map);
> +		put_page(page);
> +
> +		len  += size;
> +		to   += size;
> +		addr += size;
> +
> +	} while (len < n);
> +
> +	return len;
> +}
> +EXPORT_SYMBOL(copy_from_user_nmi);
> diff --git a/arch/x86/oprofile/backtrace.c b/arch/x86/oprofile/backtrace.c
> index 88e856e..087233f 100644
> --- a/arch/x86/oprofile/backtrace.c
> +++ b/arch/x86/oprofile/backtrace.c
> @@ -12,10 +12,9 @@
>  #include <linux/sched.h>
>  #include <linux/mm.h>
>  #include <linux/compat.h>
> -#include <linux/highmem.h>
> +#include <linux/uaccess.h>
>  
>  #include <asm/ptrace.h>
> -#include <asm/uaccess.h>
>  #include <asm/stacktrace.h>
>  
>  static void backtrace_warning_symbol(void *data, char *msg,
> @@ -51,42 +50,6 @@ static struct stacktrace_ops backtrace_ops = {
>  	.walk_stack	= print_context_stack,
>  };
>  
> -/* from arch/x86/kernel/cpu/perf_event.c: */
> -
> -/*
> - * best effort, GUP based copy_from_user() that assumes IRQ or NMI context
> - */
> -static unsigned long
> -copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
> -{
> -	unsigned long offset, addr = (unsigned long)from;
> -	unsigned long size, len = 0;
> -	struct page *page;
> -	void *map;
> -	int ret;
> -
> -	do {
> -		ret = __get_user_pages_fast(addr, 1, 0, &page);
> -		if (!ret)
> -			break;
> -
> -		offset = addr & (PAGE_SIZE - 1);
> -		size = min(PAGE_SIZE - offset, n - len);
> -
> -		map = kmap_atomic(page);
> -		memcpy(to, map+offset, size);
> -		kunmap_atomic(map);
> -		put_page(page);
> -
> -		len  += size;
> -		to   += size;
> -		addr += size;
> -
> -	} while (len < n);
> -
> -	return len;
> -}
> -
>  #ifdef CONFIG_COMPAT
>  static struct stack_frame_ia32 *
>  dump_user_backtrace_32(struct stack_frame_ia32 *head)
> -- 
> 1.7.5.rc3
> 
> 
> 
> -- 
> Advanced Micro Devices, Inc.
> Operating System Research Center

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

