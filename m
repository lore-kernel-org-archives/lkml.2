Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686Ab1EDUEp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 16:04:45 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:27422 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755660Ab1EDUEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 16:04:43 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: tzfpPb0VM1nSEgV1_NPsYvh7uHPFPXBZ8oY8xrFaby5W4ET
 romONkyssOfbPSiPqrKeC2Tj8xiEhoUp3g4GtblAt_7OAhKCq_LaQ3eyVbM5
 nnP65gKsfIwiMF4wodOAYXhXGJ5AeWmbQGvKAkI90QJTODOnep0nknHaKosW
 urMMg.MN.yqR3sFwEMIbtXYdw_EutUW_SXaNjEZ3.7r2Luqc7zn1Q0YPKaim
 AVzokWXT.iD2pRL17LoU7bhQRwwiQdxyuwXhcv2PXu_ixhmgUalHTfkpQLk4
 Q0JTcxLazkTl67gWRYT2OGlpKGY8mth3czfplDo2UKG13A7eOzDh_mVhYei0
 dSB0dJOO_xQxwNDvTxPSktyf8
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 4 May 2011 15:04:39 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Pekka Enberg <penberg@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [block IO crash] Re: 2.6.39-rc5-git2 boot crashs
In-Reply-To: <BANLkTi=efcVkGb+DReZ+i1p5j4QXJYjKjQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1105041454190.5495@router.home>
References: <BANLkTi=6_oXX1BM5O3kJ6bVevh9=ydjj3g@mail.gmail.com> <20110504101932.GA3392@elte.hu> <alpine.LFD.2.02.1105041233280.3005@ionos> <BANLkTinxe=gSERoOHOohb1V-CZ0c9BSy2Q@mail.gmail.com> <20110504112746.GE8007@htj.dyndns.org> <alpine.LFD.2.02.1105041417330.3005@ionos>
 <20110504132022.GA17294@htj.dyndns.org> <alpine.LFD.2.02.1105041539050.3005@ionos> <20110504142532.GC17294@htj.dyndns.org> <alpine.LFD.2.02.1105041640020.3005@ionos> <alpine.DEB.2.00.1105040958570.5495@router.home> <BANLkTikiAqcJVoJRJ6oy+LwPJPz+mHNj_w@mail.gmail.com>
 <alpine.DEB.2.00.1105041023070.5495@router.home> <BANLkTik52Fi=vHY-TiK6SAYrWjaSN=PB+g@mail.gmail.com> <BANLkTimdL_tAONUWxZ4sQn1AiPDdbdYqpw@mail.gmail.com> <BANLkTinLn-59oisLrvwyCvyUuNyDKVHP0g@mail.gmail.com> <alpine.DEB.2.00.1105041341550.5495@router.home>
 <BANLkTikEgDGt+KrBsZcinKVom5E63Ma6gg@mail.gmail.com> <alpine.DEB.2.00.1105041421280.5495@router.home> <BANLkTi=efcVkGb+DReZ+i1p5j4QXJYjKjQ@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 May 2011, Linus Torvalds wrote:

> On Wed, May 4, 2011 at 12:30 PM, Christoph Lameter <cl@linux.com> wrote:
> >
> > The naming convention came about from the existing this_cpu_xxx
> > operations
>
> You're missing my point.
>
> An "add" operation makes sense even if it isn't atomic, because
> atomicity isn't a part of the definition of "add".
>
> But cmpxchg DOES NOT MAKE SENSE without atomicity guarantees.

This is not a real cmpxchg after all. Its not atomic in the sense of
other functions. Its only "percpu atomic" if you want it that way. This is
*not* a full cmpxchg_double().

> The whole operation is about atomicity.
>
> Having a version that isn't atomic is STUPID. It's misleading. It's _wrong_.

Its "atomic" in the sense that it is an instruction that is either
executed or not in total and that fact alone allow the avoiding of
synchronization for preemption and interrupts. We just push as much
processing as possible into this single instruction and then we dont have
to worry about preemption or interrupts while this function is
executed by the processor.

> In contrast, having a non-atomic "add" version is understandable.
>
> So when  you say "naming convention", you're missing the much bigger
> naming convention. Namely the "cmpxchg" part!

Well this is not really a true cmpxchg. There is no lock prefix.

The semantics of the this_cpu_xxx functions are not atomic but only per
cpu atomic. That per cpu atomicity can require only the exclusion of
preemption or the exclusion of interrupts.

In extreme cases we dont care about preemption or interrupts interfering
with the operation. We just want to opportunistically take advantage of
sophisticated instructions if they are available (f.e. for accurate vm
counters). Or we may have some other external means of serialization (like
lock or we already disabled preemption). Thats what the __ operations are
for.

Maybe I should have pushed the cmpxchg_double() before the
this_cpu_cmpxchg to avoid these misunderstandings


Here is the patch for the fullly atomic cmpxchg_double() which will be
needed for making the non per cpu specific processing lockless later:


Subject: x86: Add support for cmpxchg_double

A simple implementation that only supports the word size and does not
have a fallback mode (would require a spinlock).

And 32 and 64 bit support for cmpxchg_double. cmpxchg double uses
the cmpxchg8b or cmpxchg16b instruction on x86 processors to compare
and swap 2 machine words. This allows lockless algorithms to move more
context information through critical sections.

Set a flag CONFIG_CMPXCHG_DOUBLE to signal the support of that feature
during kernel builds.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 arch/x86/Kconfig.cpu              |    3 ++
 arch/x86/include/asm/cmpxchg_32.h |   46 ++++++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/cmpxchg_64.h |   45 +++++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/cpufeature.h |    1
 4 files changed, 95 insertions(+)

Index: linux-2.6/arch/x86/include/asm/cmpxchg_64.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/cmpxchg_64.h	2011-04-13 15:19:53.000000000 -0500
+++ linux-2.6/arch/x86/include/asm/cmpxchg_64.h	2011-04-15 13:14:45.000000000 -0500
@@ -151,4 +151,49 @@ extern void __cmpxchg_wrong_size(void);
 	cmpxchg_local((ptr), (o), (n));					\
 })

+#define cmpxchg16b(ptr, o1, o2, n1, n2)				\
+({								\
+	char __ret;						\
+	__typeof__(o2) __junk;					\
+	__typeof__(*(ptr)) __old1 = (o1);			\
+	__typeof__(o2) __old2 = (o2);				\
+	__typeof__(*(ptr)) __new1 = (n1);			\
+	__typeof__(o2) __new2 = (n2);				\
+	asm volatile(LOCK_PREFIX_HERE "lock; cmpxchg16b (%%rsi);setz %1" \
+		       : "=d"(__junk), "=a"(__ret)		\
+		       : "S"(ptr), "b"(__new1),	"c"(__new2),	\
+		         "a"(__old1), "d"(__old2));		\
+	__ret; })
+
+
+#define cmpxchg16b_local(ptr, o1, o2, n1, n2)			\
+({								\
+	char __ret;						\
+	__typeof__(o2) __junk;					\
+	__typeof__(*(ptr)) __old1 = (o1);			\
+	__typeof__(o2) __old2 = (o2);				\
+	__typeof__(*(ptr)) __new1 = (n1);			\
+	__typeof__(o2) __new2 = (n2);				\
+	asm volatile("cmpxchg16b (%%rsi)\n\t\tsetz %1\n\t"	\
+		       : "=d"(__junk)_, "=a"(__ret)		\
+		       : "S"((ptr)), "b"(__new1), "c"(__new2),	\
+ 		         "a"(__old1), "d"(__old2));		\
+	__ret; })
+
+#define cmpxchg_double(ptr, o1, o2, n1, n2)				\
+({									\
+	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
+	VM_BUG_ON((unsigned long)(ptr) % 16);				\
+	cmpxchg16b((ptr), (o1), (o2), (n1), (n2));			\
+})
+
+#define cmpxchg_double_local(ptr, o1, o2, n1, n2)			\
+({									\
+	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
+	VM_BUG_ON((unsigned long)(ptr) % 16);				\
+	cmpxchg16b_local((ptr), (o1), (o2), (n1), (n2));		\
+})
+
+#define system_has_cmpxchg_double() cpu_has_cx16
+
 #endif /* _ASM_X86_CMPXCHG_64_H */
Index: linux-2.6/arch/x86/include/asm/cmpxchg_32.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/cmpxchg_32.h	2011-04-13 15:19:53.000000000 -0500
+++ linux-2.6/arch/x86/include/asm/cmpxchg_32.h	2011-04-15 13:14:45.000000000 -0500
@@ -280,4 +280,50 @@ static inline unsigned long cmpxchg_386(

 #endif

+#define cmpxchg8b(ptr, o1, o2, n1, n2)				\
+({								\
+	char __ret;						\
+	__typeof__(o2) __dummy;					\
+	__typeof__(*(ptr)) __old1 = (o1);			\
+	__typeof__(o2) __old2 = (o2);				\
+	__typeof__(*(ptr)) __new1 = (n1);			\
+	__typeof__(o2) __new2 = (n2);				\
+	asm volatile(LOCK_PREFIX_HERE "lock; cmpxchg8b (%%esi); setz %1"\
+		       : "d="(__dummy), "=a" (__ret) 		\
+		       : "S" ((ptr)), "a" (__old1), "d"(__old2),	\
+		         "b" (__new1), "c" (__new2)		\
+		       : "memory");				\
+	__ret; })
+
+
+#define cmpxchg8b_local(ptr, o1, o2, n1, n2)			\
+({								\
+	char __ret;						\
+	__typeof__(o2) __dummy;					\
+	__typeof__(*(ptr)) __old1 = (o1);			\
+	__typeof__(o2) __old2 = (o2);				\
+	__typeof__(*(ptr)) __new1 = (n1);			\
+	__typeof__(o2) __new2 = (n2);				\
+	asm volatile("cmpxchg8b (%%esi); tsetz %1"		\
+		       : "d="(__dummy), "=a"(__ret)		\
+		       : "S" ((ptr)), "a" (__old), "d"(__old2),	\
+		         "b" (__new1), "c" (__new2),		\
+		       : "memory");				\
+	__ret; })
+
+
+#define cmpxchg_double(ptr, o1, o2, n1, n2)				\
+({									\
+	BUILD_BUG_ON(sizeof(*(ptr)) != 4);				\
+	VM_BUG_ON((unsigned long)(ptr) % 8);				\
+	cmpxchg8b((ptr), (o1), (o2), (n1), (n2));			\
+})
+
+#define cmpxchg_double_local(ptr, o1, o2, n1, n2)			\
+({									\
+       BUILD_BUG_ON(sizeof(*(ptr)) != 4);				\
+       VM_BUG_ON((unsigned long)(ptr) % 8);				\
+       cmpxchg16b_local((ptr), (o1), (o2), (n1), (n2));			\
+})
+
 #endif /* _ASM_X86_CMPXCHG_32_H */
Index: linux-2.6/arch/x86/Kconfig.cpu
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig.cpu	2011-04-13 15:19:53.000000000 -0500
+++ linux-2.6/arch/x86/Kconfig.cpu	2011-04-15 13:14:45.000000000 -0500
@@ -308,6 +308,9 @@ config X86_CMPXCHG
 config CMPXCHG_LOCAL
 	def_bool X86_64 || (X86_32 && !M386)

+config CMPXCHG_DOUBLE
+	def_bool X86_64 || (X86_32 && !M386)
+
 config X86_L1_CACHE_SHIFT
 	int
 	default "7" if MPENTIUM4 || MPSC
Index: linux-2.6/arch/x86/include/asm/cpufeature.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/cpufeature.h	2011-04-15 12:51:51.000000000 -0500
+++ linux-2.6/arch/x86/include/asm/cpufeature.h	2011-04-15 13:14:45.000000000 -0500
@@ -286,6 +286,7 @@ extern const char * const x86_power_flag
 #define cpu_has_hypervisor	boot_cpu_has(X86_FEATURE_HYPERVISOR)
 #define cpu_has_pclmulqdq	boot_cpu_has(X86_FEATURE_PCLMULQDQ)
 #define cpu_has_perfctr_core	boot_cpu_has(X86_FEATURE_PERFCTR_CORE)
+#define cpu_has_cx16		boot_cpu_has(X86_FEATURE_CX16)

 #if defined(CONFIG_X86_INVLPG) || defined(CONFIG_X86_64)
 # define cpu_has_invlpg		1
