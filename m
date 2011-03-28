Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056Ab1C1GUe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 02:20:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49145 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259Ab1C1GUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 02:20:33 -0400
Date: Mon, 28 Mar 2011 08:19:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <cl@linux.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org,
        tj@kernel.org, npiggin@kernel.dk, rientjes@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] slub: Disable the lockless allocator
Message-ID: <20110328061929.GA24328@elte.hu>
References: <20110326112725.GA28612@elte.hu>
 <20110326114736.GA8251@elte.hu>
 <1301161507.2979.105.camel@edumazet-laptop>
 <alpine.DEB.2.00.1103261406420.24195@router.home>
 <alpine.DEB.2.00.1103261428200.25375@router.home>
 <alpine.DEB.2.00.1103261440160.25375@router.home>
 <AANLkTinTzKQkRcE2JvP_BpR0YMj82gppAmNo7RqgftCG@mail.gmail.com>
 <alpine.DEB.2.00.1103262028170.1004@router.home>
 <alpine.DEB.2.00.1103262054410.1373@router.home>
 <4D9026C8.6060905@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D9026C8.6060905@cs.helsinki.fi>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> On 3/27/11 4:57 AM, Christoph Lameter wrote:
> >But then the same fix must also be used in the asm code or the fallback
> >(turns out that the fallback is always used in kmem_cache_init since
> >the instruction patching comes later).
> >
> >Patch boots fine both in UP and SMP mode
> >
> >
> >
> >
> >Subject: percpu: Omit segment prefix in the UP case for cmpxchg_double
> >
> >Omit the segment prefix in the UP case. GS is not used then
> >and we will generate segfaults if cmpxchg16b is used otherwise.
> >
> >Signed-off-by: Linus Torvalds<torvalds@linux-foundation.org>
> >Signed-off-by: Christoph Lameter<cl@linux.com>
> >
> >  arch/x86/include/asm/percpu.h |   10 ++++++----
> >  1 files changed, 6 insertions(+), 4 deletions(-)
> >
> >Index: linux-2.6/arch/x86/include/asm/percpu.h
> >===================================================================
> >--- linux-2.6.orig/arch/x86/include/asm/percpu.h	2011-03-26 20:43:03.994089001 -0500
> >+++ linux-2.6/arch/x86/include/asm/percpu.h	2011-03-26 20:43:22.414089004 -0500
> >@@ -45,7 +45,7 @@
> >  #include<linux/stringify.h>
> >
> >  #ifdef CONFIG_SMP
> >-#define __percpu_arg(x)		"%%"__stringify(__percpu_seg)":%P" #x
> >+#define __percpu_prefix		"%%"__stringify(__percpu_seg)":"
> >  #define __my_cpu_offset		percpu_read(this_cpu_off)
> >
> >  /*
> >@@ -62,9 +62,11 @@
> >  	(typeof(*(ptr)) __kernel __force *)tcp_ptr__;	\
> >  })
> >  #else
> >-#define __percpu_arg(x)		"%P" #x
> >+#define __percpu_prefix		""
> >  #endif
> >
> >+#define __percpu_arg(x)		__percpu_prefix "%P" #x
> >+
> >  /*
> >   * Initialized pointers to per-cpu variables needed for the boot
> >   * processor need to use these macros to get the proper address
> >@@ -516,11 +518,11 @@
> >  	typeof(o2) __n2 = n2;						\
> >  	typeof(o2) __dummy;						\
> >  	alternative_io("call this_cpu_cmpxchg16b_emu\n\t" P6_NOP4,	\
> >-		       "cmpxchg16b %%gs:(%%rsi)\n\tsetz %0\n\t",	\
> >+		       "cmpxchg16b " __percpu_prefix "(%%rsi)\n\tsetz %0\n\t",	\
> >  		       X86_FEATURE_CX16,				\
> >  		       ASM_OUTPUT2("=a"(__ret), "=d"(__dummy)),		\
> >  		       "S" (&pcp1), "b"(__n1), "c"(__n2),		\
> >-		       "a"(__o1), "d"(__o2));				\
> >+		       "a"(__o1), "d"(__o2) : "memory");		\
> >  	__ret;								\
> >  })
> >
> >Index: linux-2.6/arch/x86/lib/cmpxchg16b_emu.S
> >===================================================================
> >--- linux-2.6.orig/arch/x86/lib/cmpxchg16b_emu.S	2011-03-26 20:43:57.384089004 -0500
> >+++ linux-2.6/arch/x86/lib/cmpxchg16b_emu.S	2011-03-26 20:48:42.684088999 -0500
> >@@ -10,6 +10,12 @@
> >  #include<asm/frame.h>
> >  #include<asm/dwarf2.h>
> >
> >+#ifdef CONFIG_SMP
> >+#define SEG_PREFIX %gs:
> >+#else
> >+#define SEG_PREFIX
> >+#endif
> >+
> >  .text
> >
> >  /*
> >@@ -37,13 +43,13 @@
> >  	pushf
> >  	cli
> >
> >-	cmpq %gs:(%rsi), %rax
> >+	cmpq SEG_PREFIX(%rsi), %rax
> >  	jne not_same
> >-	cmpq %gs:8(%rsi), %rdx
> >+	cmpq SEG_PREFIX 8(%rsi), %rdx
> >  	jne not_same
> >
> >-	movq %rbx, %gs:(%rsi)
> >-	movq %rcx, %gs:8(%rsi)
> >+	movq %rbx, SEG_PREFIX(%rsi)
> >+	movq %rcx, SEG_PREFIX 8(%rsi)
> >
> >  	popf
> >  	mov $1, %al
> 
> Tejun, does this look good to you as well? I think it should go
> through the percpu tree. It's needed to fix a boot crash with
> lockless SLUB fastpaths enabled.

AFAICS Linus applied it already:

d7c3f8cee81f: percpu: Omit segment prefix in the UP case for cmpxchg_double

Thanks,

	Ingo
