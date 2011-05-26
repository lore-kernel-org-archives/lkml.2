Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758427Ab1EZSSl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:18:41 -0400
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:22804 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758227Ab1EZSPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:15:06 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: jWbrmH0VM1lLYijMZ.adNHMZ1Y4dDY0fsasY6Y3WtcMRy5G
 oXJHBzLtq1sfsIi77Nc9uP7nYiskuETumfQ4FzsHN06WrJLga3eYotN3_Fb.
 1ITiu_bcQCr4til8x4AOBOjTRn_zXLjgJNDQsD0Ol1gnPvgls4vIdXfa3Q1Q
 kIXn2XQcA7tZCeMzbNgJXjw5Es3bY2bqeF6_4mYsQDv6PmivlzkPvg7ZqkPW
 es.qfYaAbt1oTW7LxnmkcnRWSmj.i6BUD7ukDg5_ne73pMZ0mHsA8lMTUUCk
 WzcMQc9mpNaon3Ez6Ps7ycU0vjBRMdyS.TzPdmhzvt2g1OI.Q
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110526181503.710159321@linux.com>
User-Agent: quilt/0.48-1
Date: Thu, 26 May 2011 13:14:46 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>, tj@kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [slubllv6 04/17] x86: Add support for cmpxchg_double
References: <20110526181442.789868308@linux.com>
Content-Disposition: inline; filename=cmpxchg_double_x86
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A simple implementation that only supports the word size and does not
have a fallback mode (would require a spinlock).

And 32 and 64 bit support for cmpxchg_double. cmpxchg double uses
the cmpxchg8b or cmpxchg16b instruction on x86 processors to compare
and swap 2 machine words. This allows lockless algorithms to move more
context information through critical sections.

Set a flag CONFIG_CMPXCHG_DOUBLE to signal the support of that feature
during kernel builds.

Cc: tj@kernel.org
Signed-off-by: Christoph Lameter <cl@linux.com>

---
 arch/x86/Kconfig.cpu              |    3 ++
 arch/x86/include/asm/cmpxchg_32.h |   46 ++++++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/cmpxchg_64.h |   45 +++++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/cpufeature.h |    1 
 4 files changed, 95 insertions(+)

Index: linux-2.6/arch/x86/include/asm/cmpxchg_64.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/cmpxchg_64.h	2011-05-16 11:40:36.421463498 -0500
+++ linux-2.6/arch/x86/include/asm/cmpxchg_64.h	2011-05-16 11:46:34.781463079 -0500
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
--- linux-2.6.orig/arch/x86/include/asm/cmpxchg_32.h	2011-05-16 11:40:36.431463498 -0500
+++ linux-2.6/arch/x86/include/asm/cmpxchg_32.h	2011-05-16 11:46:34.781463079 -0500
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
--- linux-2.6.orig/arch/x86/Kconfig.cpu	2011-05-16 11:40:36.401463498 -0500
+++ linux-2.6/arch/x86/Kconfig.cpu	2011-05-16 11:46:34.781463079 -0500
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
--- linux-2.6.orig/arch/x86/include/asm/cpufeature.h	2011-05-16 11:40:36.411463498 -0500
+++ linux-2.6/arch/x86/include/asm/cpufeature.h	2011-05-16 11:46:34.801463079 -0500
@@ -286,6 +286,7 @@ extern const char * const x86_power_flag
 #define cpu_has_hypervisor	boot_cpu_has(X86_FEATURE_HYPERVISOR)
 #define cpu_has_pclmulqdq	boot_cpu_has(X86_FEATURE_PCLMULQDQ)
 #define cpu_has_perfctr_core	boot_cpu_has(X86_FEATURE_PERFCTR_CORE)
+#define cpu_has_cx16		boot_cpu_has(X86_FEATURE_CX16)
 
 #if defined(CONFIG_X86_INVLPG) || defined(CONFIG_X86_64)
 # define cpu_has_invlpg		1

