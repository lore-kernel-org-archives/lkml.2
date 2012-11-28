Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932328Ab2K1Tvs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 14:51:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38785 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755589Ab2K1Tu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 14:50:57 -0500
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mario Gzuk <mariogzuk@technikz.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 3/8] x86, 386 removal: Remove CONFIG_XADD
Date: Wed, 28 Nov 2012 11:50:25 -0800
Message-Id: <1354132230-21854-4-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1354132230-21854-1-git-send-email-hpa@linux.intel.com>
References: <1354132230-21854-1-git-send-email-hpa@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

All 486+ CPUs support CMPXCHG, so remove the fallback 386 support
code.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/Kconfig              |  5 -----
 arch/x86/Kconfig.cpu          |  3 ---
 arch/x86/include/asm/atomic.h | 16 ----------------
 arch/x86/include/asm/local.h  | 18 +-----------------
 arch/x86/um/Kconfig           |  2 +-
 5 files changed, 2 insertions(+), 42 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a1a6627..631b298 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -171,13 +171,8 @@ config ARCH_MAY_HAVE_PC_FDC
 	def_bool y
 	depends on ISA_DMA_API
 
-config RWSEM_GENERIC_SPINLOCK
-	def_bool y
-	depends on !X86_XADD
-
 config RWSEM_XCHGADD_ALGORITHM
 	def_bool y
-	depends on X86_XADD
 
 config GENERIC_CALIBRATE_DELAY
 	def_bool y
diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 1290a69..52955ee 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -304,9 +304,6 @@ config X86_L1_CACHE_SHIFT
 	default "4" if MELAN || M486 || MGEODEGX1
 	default "5" if MWINCHIP3D || MWINCHIPC6 || MCRUSOE || MEFFICEON || MCYRIXIII || MK6 || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || M586 || MVIAC3_2 || MGEODE_LX
 
-config X86_XADD
-	def_bool y
-
 config X86_PPRO_FENCE
 	bool "PentiumPro memory ordering errata workaround"
 	depends on M686 || M586MMX || M586TSC || M586 || M486 || MGEODEGX1
diff --git a/arch/x86/include/asm/atomic.h b/arch/x86/include/asm/atomic.h
index b6c3b82..722aa3b 100644
--- a/arch/x86/include/asm/atomic.h
+++ b/arch/x86/include/asm/atomic.h
@@ -172,23 +172,7 @@ static inline int atomic_add_negative(int i, atomic_t *v)
  */
 static inline int atomic_add_return(int i, atomic_t *v)
 {
-#ifdef CONFIG_M386
-	int __i;
-	unsigned long flags;
-	if (unlikely(boot_cpu_data.x86 <= 3))
-		goto no_xadd;
-#endif
-	/* Modern 486+ processor */
 	return i + xadd(&v->counter, i);
-
-#ifdef CONFIG_M386
-no_xadd: /* Legacy 386 processor */
-	raw_local_irq_save(flags);
-	__i = atomic_read(v);
-	atomic_set(v, i + __i);
-	raw_local_irq_restore(flags);
-	return i + __i;
-#endif
 }
 
 /**
diff --git a/arch/x86/include/asm/local.h b/arch/x86/include/asm/local.h
index c8bed0d..2d89e39 100644
--- a/arch/x86/include/asm/local.h
+++ b/arch/x86/include/asm/local.h
@@ -124,27 +124,11 @@ static inline int local_add_negative(long i, local_t *l)
  */
 static inline long local_add_return(long i, local_t *l)
 {
-	long __i;
-#ifdef CONFIG_M386
-	unsigned long flags;
-	if (unlikely(boot_cpu_data.x86 <= 3))
-		goto no_xadd;
-#endif
-	/* Modern 486+ processor */
-	__i = i;
+	long __i = i;
 	asm volatile(_ASM_XADD "%0, %1;"
 		     : "+r" (i), "+m" (l->a.counter)
 		     : : "memory");
 	return i + __i;
-
-#ifdef CONFIG_M386
-no_xadd: /* Legacy 386 processor */
-	local_irq_save(flags);
-	__i = local_read(l);
-	local_set(l, i + __i);
-	local_irq_restore(flags);
-	return i + __i;
-#endif
 }
 
 static inline long local_sub_return(long i, local_t *l)
diff --git a/arch/x86/um/Kconfig b/arch/x86/um/Kconfig
index 0761175..b0c30da 100644
--- a/arch/x86/um/Kconfig
+++ b/arch/x86/um/Kconfig
@@ -31,7 +31,7 @@ config X86_64
 	select MODULES_USE_ELF_RELA
 
 config RWSEM_XCHGADD_ALGORITHM
-	def_bool X86_XADD && 64BIT
+	def_bool 64BIT
 
 config RWSEM_GENERIC_SPINLOCK
 	def_bool !RWSEM_XCHGADD_ALGORITHM
-- 
1.7.11.7

