Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750Ab2LAAg4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 19:36:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39278 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403Ab2LAAgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 19:36:54 -0500
Date: Fri, 30 Nov 2012 16:36:43 -0800
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-7ac468b1300f35143a9b5b100e3970ca7ae1d9b8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1354132230-21854-4-git-send-email-hpa@linux.intel.com>
References: <1354132230-21854-4-git-send-email-hpa@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/nuke386] x86, 386 removal: Remove CONFIG_XADD
Git-Commit-ID: 7ac468b1300f35143a9b5b100e3970ca7ae1d9b8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 30 Nov 2012 16:36:48 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7ac468b1300f35143a9b5b100e3970ca7ae1d9b8
Gitweb:     http://git.kernel.org/tip/7ac468b1300f35143a9b5b100e3970ca7ae1d9b8
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Wed, 28 Nov 2012 11:50:25 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 29 Nov 2012 13:23:02 -0800

x86, 386 removal: Remove CONFIG_XADD

All 486+ CPUs support XADD, so remove the fallback 386 support
code.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/r/1354132230-21854-4-git-send-email-hpa@linux.intel.com
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
