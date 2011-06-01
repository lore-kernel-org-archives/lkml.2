Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759370Ab1FAR3m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 13:29:42 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:35147 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759033Ab1FAR0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 13:26:16 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: v83VR7YVM1n5z4zKeIoVwC5J_1clZhlT.4TvRHl1ghBvlVM
 ziwkdSFGJXdSEJMvIDJpoGHdi43bkkXPO97xY506jAIR_5QAKOytRY_iSeA1
 0Y8ntd1S83BTfmng42ek23KG0q44OvBol2L5rwvVv..GPurMRtyoENV.FQPa
 bfivgui8a.tcN4eg.fuuBrcE4zvSoZpFTAXSplCNdS1e1KZyWctQ7VCmkTu9
 UtUUcevPoga6GAaQRWSch6FbXGOhro8d2pF8BKXKjEgIugWfFeS8mDnfxoRv
 uFNtKF7.B21WgXN4F.mDGh8323WLTIrH6ygRohXl8Jj636E0j7CLbnp1yyOW
 XxiR6H0cHBbG3mrZFjQvlozAA
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110601172614.173427964@linux.com>
User-Agent: quilt/0.48-1
Date: Wed, 01 Jun 2011 12:25:47 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>, tj@kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [slubllv7 04/17] x86: Add support for cmpxchg_double
References: <20110601172543.437240675@linux.com>
Content-Disposition: inline; filename=cmpxchg_double_x86
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A simple implementation that only supports the word size and does not
have a fallback mode (would require a spinlock).

Add 32 and 64 bit support for cmpxchg_double. cmpxchg double uses
the cmpxchg8b or cmpxchg16b instruction on x86 processors to compare
and swap 2 machine words. This allows lockless algorithms to move more
context information through critical sections.

Set a flag CONFIG_CMPXCHG_DOUBLE to signal that support for double word
cmpxchg detection has been build into the kernel. Note that each subsystem
using cmpxchg_double has to implement a fall back mechanism as long as
we offer support for processors that do not implement cmpxchg_double.

Reviewed-by: H. Peter Anvin <hpa@zytor.com>
Cc: tj@kernel.org
Signed-off-by: Christoph Lameter <cl@linux.com>

---
 arch/x86/Kconfig.cpu              |    3 ++
 arch/x86/include/asm/cmpxchg_32.h |   48 ++++++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/cmpxchg_64.h |   45 +++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/cpufeature.h |    2 +
 4 files changed, 98 insertions(+)

Index: linux-2.6/arch/x86/include/asm/cmpxchg_64.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/cmpxchg_64.h	2011-06-01 11:01:05.002406114 -0500
+++ linux-2.6/arch/x86/include/asm/cmpxchg_64.h	2011-06-01 11:01:48.222405834 -0500
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
+	asm volatile(LOCK_PREFIX "cmpxchg16b %2;setz %1"	\
+		       : "=d"(__junk), "=a"(__ret), "+m" (*ptr)	\
+		       : "b"(__new1), "c"(__new2),		\
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
+	asm volatile("cmpxchg16b %2;setz %1"			\
+		       : "=d"(__junk), "=a"(__ret), "+m" (*ptr)	\
+		       : "b"(__new1), "c"(__new2),		\
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
--- linux-2.6.orig/arch/x86/include/asm/cmpxchg_32.h	2011-06-01 11:01:05.022406109 -0500
+++ linux-2.6/arch/x86/include/asm/cmpxchg_32.h	2011-06-01 11:01:48.222405834 -0500
@@ -280,4 +280,52 @@ static inline unsigned long cmpxchg_386(
 
 #endif
 
+#define cmpxchg8b(ptr, o1, o2, n1, n2)				\
+({								\
+	char __ret;						\
+	__typeof__(o2) __dummy;					\
+	__typeof__(*(ptr)) __old1 = (o1);			\
+	__typeof__(o2) __old2 = (o2);				\
+	__typeof__(*(ptr)) __new1 = (n1);			\
+	__typeof__(o2) __new2 = (n2);				\
+	asm volatile(LOCK_PREFIX "cmpxchg8b %2; setz %1"	\
+		       : "=d"(__dummy), "=a" (__ret), "+m" (*ptr)\
+		       : "a" (__old1), "d"(__old2),		\
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
+	asm volatile("cmpxchg8b %2; setz %1"			\
+		       : "=d"(__dummy), "=a"(__ret), "+m" (*ptr)\
+		       : "a" (__old), "d"(__old2),		\
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
+#define system_has_cmpxchg_double() cpu_has_cx8
+
 #endif /* _ASM_X86_CMPXCHG_32_H */
Index: linux-2.6/arch/x86/Kconfig.cpu
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig.cpu	2011-06-01 11:01:05.032406108 -0500
+++ linux-2.6/arch/x86/Kconfig.cpu	2011-06-01 11:02:20.912405628 -0500
@@ -312,6 +312,9 @@ config X86_CMPXCHG
 config CMPXCHG_LOCAL
 	def_bool X86_64 || (X86_32 && !M386)
 
+config CMPXCHG_DOUBLE
+	def_bool y
+
 config X86_L1_CACHE_SHIFT
 	int
 	default "7" if MPENTIUM4 || MPSC
Index: linux-2.6/arch/x86/include/asm/cpufeature.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/cpufeature.h	2011-06-01 11:01:05.012406112 -0500
+++ linux-2.6/arch/x86/include/asm/cpufeature.h	2011-06-01 11:01:48.222405834 -0500
@@ -288,6 +288,8 @@ extern const char * const x86_power_flag
 #define cpu_has_hypervisor	boot_cpu_has(X86_FEATURE_HYPERVISOR)
 #define cpu_has_pclmulqdq	boot_cpu_has(X86_FEATURE_PCLMULQDQ)
 #define cpu_has_perfctr_core	boot_cpu_has(X86_FEATURE_PERFCTR_CORE)
+#define cpu_has_cx8		boot_cpu_has(X86_FEATURE_CX8)
+#define cpu_has_cx16		boot_cpu_has(X86_FEATURE_CX16)
 
 #if defined(CONFIG_X86_INVLPG) || defined(CONFIG_X86_64)
 # define cpu_has_invlpg		1

