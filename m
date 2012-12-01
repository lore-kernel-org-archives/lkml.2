Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085Ab2LAAgF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 19:36:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39267 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab2LAAgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 19:36:01 -0500
Date: Fri, 30 Nov 2012 16:35:40 -0800
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-d55c5a93db2d5fa95f233ab153f594365d95b777@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1354132230-21854-3-git-send-email-hpa@linux.intel.com>
References: <1354132230-21854-3-git-send-email-hpa@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/nuke386] x86, 386 removal: Remove CONFIG_CMPXCHG
Git-Commit-ID: d55c5a93db2d5fa95f233ab153f594365d95b777
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 30 Nov 2012 16:35:46 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d55c5a93db2d5fa95f233ab153f594365d95b777
Gitweb:     http://git.kernel.org/tip/d55c5a93db2d5fa95f233ab153f594365d95b777
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Wed, 28 Nov 2012 11:50:24 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 29 Nov 2012 13:23:01 -0800

x86, 386 removal: Remove CONFIG_CMPXCHG

All 486+ CPUs support CMPXCHG, so remove the fallback 386 support
code.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/r/1354132230-21854-3-git-send-email-hpa@linux.intel.com
---
 arch/x86/Kconfig.cpu              |  3 ---
 arch/x86/include/asm/cmpxchg_32.h | 55 ---------------------------------------
 arch/x86/include/asm/percpu.h     |  3 ---
 arch/x86/lib/Makefile             |  1 -
 arch/x86/lib/cmpxchg.c            | 54 --------------------------------------
 arch/x86/xen/Kconfig              |  2 +-
 6 files changed, 1 insertion(+), 117 deletions(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 36a07eb..1290a69 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -297,9 +297,6 @@ config X86_INTERNODE_CACHE_SHIFT
 	default "12" if X86_VSMP
 	default X86_L1_CACHE_SHIFT
 
-config X86_CMPXCHG
-	def_bool y
-
 config X86_L1_CACHE_SHIFT
 	int
 	default "7" if MPENTIUM4 || MPSC
diff --git a/arch/x86/include/asm/cmpxchg_32.h b/arch/x86/include/asm/cmpxchg_32.h
index 53f4b21..f8bf2ee 100644
--- a/arch/x86/include/asm/cmpxchg_32.h
+++ b/arch/x86/include/asm/cmpxchg_32.h
@@ -34,9 +34,7 @@ static inline void set_64bit(volatile u64 *ptr, u64 value)
 		     : "memory");
 }
 
-#ifdef CONFIG_X86_CMPXCHG
 #define __HAVE_ARCH_CMPXCHG 1
-#endif
 
 #ifdef CONFIG_X86_CMPXCHG64
 #define cmpxchg64(ptr, o, n)						\
@@ -73,59 +71,6 @@ static inline u64 __cmpxchg64_local(volatile u64 *ptr, u64 old, u64 new)
 	return prev;
 }
 
-#ifndef CONFIG_X86_CMPXCHG
-/*
- * Building a kernel capable running on 80386. It may be necessary to
- * simulate the cmpxchg on the 80386 CPU. For that purpose we define
- * a function for each of the sizes we support.
- */
-
-extern unsigned long cmpxchg_386_u8(volatile void *, u8, u8);
-extern unsigned long cmpxchg_386_u16(volatile void *, u16, u16);
-extern unsigned long cmpxchg_386_u32(volatile void *, u32, u32);
-
-static inline unsigned long cmpxchg_386(volatile void *ptr, unsigned long old,
-					unsigned long new, int size)
-{
-	switch (size) {
-	case 1:
-		return cmpxchg_386_u8(ptr, old, new);
-	case 2:
-		return cmpxchg_386_u16(ptr, old, new);
-	case 4:
-		return cmpxchg_386_u32(ptr, old, new);
-	}
-	return old;
-}
-
-#define cmpxchg(ptr, o, n)						\
-({									\
-	__typeof__(*(ptr)) __ret;					\
-	if (likely(boot_cpu_data.x86 > 3))				\
-		__ret = (__typeof__(*(ptr)))__cmpxchg((ptr),		\
-				(unsigned long)(o), (unsigned long)(n),	\
-				sizeof(*(ptr)));			\
-	else								\
-		__ret = (__typeof__(*(ptr)))cmpxchg_386((ptr),		\
-				(unsigned long)(o), (unsigned long)(n),	\
-				sizeof(*(ptr)));			\
-	__ret;								\
-})
-#define cmpxchg_local(ptr, o, n)					\
-({									\
-	__typeof__(*(ptr)) __ret;					\
-	if (likely(boot_cpu_data.x86 > 3))				\
-		__ret = (__typeof__(*(ptr)))__cmpxchg_local((ptr),	\
-				(unsigned long)(o), (unsigned long)(n),	\
-				sizeof(*(ptr)));			\
-	else								\
-		__ret = (__typeof__(*(ptr)))cmpxchg_386((ptr),		\
-				(unsigned long)(o), (unsigned long)(n),	\
-				sizeof(*(ptr)));			\
-	__ret;								\
-})
-#endif
-
 #ifndef CONFIG_X86_CMPXCHG64
 /*
  * Building a kernel capable running on 80386 and 80486. It may be necessary
diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index 1104afa..0da5200 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -406,7 +406,6 @@ do {									\
 #define this_cpu_xchg_2(pcp, nval)	percpu_xchg_op(pcp, nval)
 #define this_cpu_xchg_4(pcp, nval)	percpu_xchg_op(pcp, nval)
 
-#ifndef CONFIG_M386
 #define __this_cpu_add_return_1(pcp, val) percpu_add_return_op(pcp, val)
 #define __this_cpu_add_return_2(pcp, val) percpu_add_return_op(pcp, val)
 #define __this_cpu_add_return_4(pcp, val) percpu_add_return_op(pcp, val)
@@ -421,8 +420,6 @@ do {									\
 #define this_cpu_cmpxchg_2(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
 #define this_cpu_cmpxchg_4(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
 
-#endif /* !CONFIG_M386 */
-
 #ifdef CONFIG_X86_CMPXCHG64
 #define percpu_cmpxchg8b_double(pcp1, pcp2, o1, o2, n1, n2)		\
 ({									\
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index b00f678..96b2c66 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -32,7 +32,6 @@ ifeq ($(CONFIG_X86_32),y)
         lib-y += checksum_32.o
         lib-y += strstr_32.o
         lib-y += string_32.o
-        lib-y += cmpxchg.o
 ifneq ($(CONFIG_X86_CMPXCHG64),y)
         lib-y += cmpxchg8b_emu.o atomic64_386_32.o
 endif
diff --git a/arch/x86/lib/cmpxchg.c b/arch/x86/lib/cmpxchg.c
deleted file mode 100644
index 5d619f6..0000000
--- a/arch/x86/lib/cmpxchg.c
+++ /dev/null
@@ -1,54 +0,0 @@
-/*
- * cmpxchg*() fallbacks for CPU not supporting these instructions
- */
-
-#include <linux/kernel.h>
-#include <linux/smp.h>
-#include <linux/module.h>
-
-#ifndef CONFIG_X86_CMPXCHG
-unsigned long cmpxchg_386_u8(volatile void *ptr, u8 old, u8 new)
-{
-	u8 prev;
-	unsigned long flags;
-
-	/* Poor man's cmpxchg for 386. Unsuitable for SMP */
-	local_irq_save(flags);
-	prev = *(u8 *)ptr;
-	if (prev == old)
-		*(u8 *)ptr = new;
-	local_irq_restore(flags);
-	return prev;
-}
-EXPORT_SYMBOL(cmpxchg_386_u8);
-
-unsigned long cmpxchg_386_u16(volatile void *ptr, u16 old, u16 new)
-{
-	u16 prev;
-	unsigned long flags;
-
-	/* Poor man's cmpxchg for 386. Unsuitable for SMP */
-	local_irq_save(flags);
-	prev = *(u16 *)ptr;
-	if (prev == old)
-		*(u16 *)ptr = new;
-	local_irq_restore(flags);
-	return prev;
-}
-EXPORT_SYMBOL(cmpxchg_386_u16);
-
-unsigned long cmpxchg_386_u32(volatile void *ptr, u32 old, u32 new)
-{
-	u32 prev;
-	unsigned long flags;
-
-	/* Poor man's cmpxchg for 386. Unsuitable for SMP */
-	local_irq_save(flags);
-	prev = *(u32 *)ptr;
-	if (prev == old)
-		*(u32 *)ptr = new;
-	local_irq_restore(flags);
-	return prev;
-}
-EXPORT_SYMBOL(cmpxchg_386_u32);
-#endif
diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
index fdce49c..9a6775c 100644
--- a/arch/x86/xen/Kconfig
+++ b/arch/x86/xen/Kconfig
@@ -7,7 +7,7 @@ config XEN
 	select PARAVIRT
 	select PARAVIRT_CLOCK
 	depends on X86_64 || (X86_32 && X86_PAE && !X86_VISWS)
-	depends on X86_CMPXCHG && X86_TSC
+	depends on X86_TSC
 	help
 	  This is the Linux Xen port.  Enabling this will allow the
 	  kernel to boot in a paravirtualized environment under the
