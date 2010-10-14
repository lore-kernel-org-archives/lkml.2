Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144Ab0JNVQZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 17:16:25 -0400
Received: from king.tilera.com ([72.1.168.226]:52863 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932107Ab0JNVQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 17:16:21 -0400
Message-Id: <57a94bf9a901cd4dbe08b51ce6ed0eb497d411f5.1287090287.git.cmetcalf@tilera.com>
In-Reply-To: <cover.1287090280.git.cmetcalf@tilera.com>
References: <cover.1287090280.git.cmetcalf@tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 14 Oct 2010 16:23:03 -0400
Subject: [PATCH 09/14] arch/tile: parameterize system PLs to support KVM port
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
X-OriginalArrivalTime: 14 Oct 2010 21:16:19.0184 (UTC) FILETIME=[0B52A700:01CB6BE5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While not a port to KVM (yet), this change modifies the kernel
to be able to build either at PL1 or at PL2 with a suitable
config switch.  Pushing up this change avoids handling branch
merge issues going forward with the KVM work.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/Kconfig                   |   12 +++++
 arch/tile/Makefile                  |    2 +
 arch/tile/include/arch/spr_def.h    |   85 +++++++++++++++++++++++++++++++++++
 arch/tile/include/arch/spr_def_32.h |   39 ++++++++++++++++
 arch/tile/include/asm/irqflags.h    |   64 +++++++++++++-------------
 arch/tile/include/asm/page.h        |   27 +++++++-----
 arch/tile/include/asm/processor.h   |   11 +++--
 arch/tile/include/asm/ptrace.h      |    4 +-
 arch/tile/include/asm/system.h      |    2 +-
 arch/tile/include/hv/hypervisor.h   |   28 ++++++------
 arch/tile/kernel/entry.S            |   12 +++--
 arch/tile/kernel/head_32.S          |    5 +-
 arch/tile/kernel/intvec_32.S        |   67 +++++++++++++++-------------
 arch/tile/kernel/irq.c              |   16 +++---
 arch/tile/kernel/messaging.c        |    2 +-
 arch/tile/kernel/process.c          |   12 +++++-
 arch/tile/kernel/regs_32.S          |    2 +-
 arch/tile/kernel/setup.c            |   28 +++++++-----
 arch/tile/kernel/smp.c              |    2 +-
 arch/tile/kernel/traps.c            |    2 +-
 arch/tile/kvm/Kconfig               |   38 +++++++++++++++
 arch/tile/mm/fault.c                |    6 +-
 arch/tile/mm/init.c                 |    2 +-
 23 files changed, 337 insertions(+), 131 deletions(-)
 create mode 100644 arch/tile/kvm/Kconfig

diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index 2361e3e..89cfee0 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -96,6 +96,7 @@ config HVC_TILE
 
 config TILE
 	def_bool y
+	select HAVE_KVM if !TILEGX
 	select GENERIC_FIND_FIRST_BIT
 	select GENERIC_FIND_NEXT_BIT
 	select USE_GENERIC_SMP_HELPERS
@@ -314,6 +315,15 @@ config HARDWALL
 	bool "Hardwall support to allow access to user dynamic network"
 	default y
 
+config KERNEL_PL
+	int "Processor protection level for kernel"
+	range 1 2
+	default "1"
+	---help---
+	  This setting determines the processor protection level the
+	  kernel will be built to run at.  Generally you should use
+	  the default value here.
+
 endmenu  # Tilera-specific configuration
 
 menu "Bus options"
@@ -354,3 +364,5 @@ source "security/Kconfig"
 source "crypto/Kconfig"
 
 source "lib/Kconfig"
+
+source "arch/tile/kvm/Kconfig"
diff --git a/arch/tile/Makefile b/arch/tile/Makefile
index a700f7f..17acce7 100644
--- a/arch/tile/Makefile
+++ b/arch/tile/Makefile
@@ -53,6 +53,8 @@ libs-y		+= $(LIBGCC_PATH)
 # See arch/tile/Kbuild for content of core part of the kernel
 core-y		+= arch/tile/
 
+core-$(CONFIG_KVM) += arch/tile/kvm/
+
 ifdef TILERA_ROOT
 INSTALL_PATH ?= $(TILERA_ROOT)/tile/boot
 endif
diff --git a/arch/tile/include/arch/spr_def.h b/arch/tile/include/arch/spr_def.h
index c8fdbd9..442fcba 100644
--- a/arch/tile/include/arch/spr_def.h
+++ b/arch/tile/include/arch/spr_def.h
@@ -12,8 +12,93 @@
  *   more details.
  */
 
+/*
+ * In addition to including the proper base SPR definition file, depending
+ * on machine architecture, this file defines several macros which allow
+ * kernel code to use protection-level dependent SPRs without worrying
+ * about which PL it's running at.  In these macros, the PL that the SPR
+ * or interrupt number applies to is replaced by K.
+ */
+
+#if CONFIG_KERNEL_PL != 1 && CONFIG_KERNEL_PL != 2
+#error CONFIG_KERNEL_PL must be 1 or 2
+#endif
+
+/* Concatenate 4 strings. */
+#define __concat4(a, b, c, d) a ## b ## c ## d
+#define _concat4(a, b, c, d)  __concat4(a, b, c, d)
+
 #ifdef __tilegx__
 #include <arch/spr_def_64.h>
+
+/* TILE-Gx dependent, protection-level dependent SPRs. */
+
+#define SPR_INTERRUPT_MASK_K \
+	_concat4(SPR_INTERRUPT_MASK_, CONFIG_KERNEL_PL,,)
+#define SPR_INTERRUPT_MASK_SET_K \
+	_concat4(SPR_INTERRUPT_MASK_SET_, CONFIG_KERNEL_PL,,)
+#define SPR_INTERRUPT_MASK_RESET_K \
+	_concat4(SPR_INTERRUPT_MASK_RESET_, CONFIG_KERNEL_PL,,)
+#define SPR_INTERRUPT_VECTOR_BASE_K \
+	_concat4(SPR_INTERRUPT_VECTOR_BASE_, CONFIG_KERNEL_PL,,)
+
+#define SPR_IPI_MASK_K \
+	_concat4(SPR_IPI_MASK_, CONFIG_KERNEL_PL,,)
+#define SPR_IPI_MASK_RESET_K \
+	_concat4(SPR_IPI_MASK_RESET_, CONFIG_KERNEL_PL,,)
+#define SPR_IPI_MASK_SET_K \
+	_concat4(SPR_IPI_MASK_SET_, CONFIG_KERNEL_PL,,)
+#define SPR_IPI_EVENT_K \
+	_concat4(SPR_IPI_EVENT_, CONFIG_KERNEL_PL,,)
+#define SPR_IPI_EVENT_RESET_K \
+	_concat4(SPR_IPI_EVENT_RESET_, CONFIG_KERNEL_PL,,)
+#define SPR_IPI_MASK_SET_K \
+	_concat4(SPR_IPI_MASK_SET_, CONFIG_KERNEL_PL,,)
+#define INT_IPI_K \
+	_concat4(INT_IPI_, CONFIG_KERNEL_PL,,)
+
+#define SPR_SINGLE_STEP_CONTROL_K \
+	_concat4(SPR_SINGLE_STEP_CONTROL_, CONFIG_KERNEL_PL,,)
+#define SPR_SINGLE_STEP_EN_K_K \
+	_concat4(SPR_SINGLE_STEP_EN_, CONFIG_KERNEL_PL, _, CONFIG_KERNEL_PL)
+#define INT_SINGLE_STEP_K \
+	_concat4(INT_SINGLE_STEP_, CONFIG_KERNEL_PL,,)
+
 #else
 #include <arch/spr_def_32.h>
+
+/* TILEPro dependent, protection-level dependent SPRs. */
+
+#define SPR_INTERRUPT_MASK_K_0 \
+	_concat4(SPR_INTERRUPT_MASK_, CONFIG_KERNEL_PL, _0,)
+#define SPR_INTERRUPT_MASK_K_1 \
+	_concat4(SPR_INTERRUPT_MASK_, CONFIG_KERNEL_PL, _1,)
+#define SPR_INTERRUPT_MASK_SET_K_0 \
+	_concat4(SPR_INTERRUPT_MASK_SET_, CONFIG_KERNEL_PL, _0,)
+#define SPR_INTERRUPT_MASK_SET_K_1 \
+	_concat4(SPR_INTERRUPT_MASK_SET_, CONFIG_KERNEL_PL, _1,)
+#define SPR_INTERRUPT_MASK_RESET_K_0 \
+	_concat4(SPR_INTERRUPT_MASK_RESET_, CONFIG_KERNEL_PL, _0,)
+#define SPR_INTERRUPT_MASK_RESET_K_1 \
+	_concat4(SPR_INTERRUPT_MASK_RESET_, CONFIG_KERNEL_PL, _1,)
+
 #endif
+
+/* Generic protection-level dependent SPRs. */
+
+#define SPR_SYSTEM_SAVE_K_0 \
+	_concat4(SPR_SYSTEM_SAVE_, CONFIG_KERNEL_PL, _0,)
+#define SPR_SYSTEM_SAVE_K_1 \
+	_concat4(SPR_SYSTEM_SAVE_, CONFIG_KERNEL_PL, _1,)
+#define SPR_SYSTEM_SAVE_K_2 \
+	_concat4(SPR_SYSTEM_SAVE_, CONFIG_KERNEL_PL, _2,)
+#define SPR_SYSTEM_SAVE_K_3 \
+	_concat4(SPR_SYSTEM_SAVE_, CONFIG_KERNEL_PL, _3,)
+#define SPR_EX_CONTEXT_K_0 \
+	_concat4(SPR_EX_CONTEXT_, CONFIG_KERNEL_PL, _0,)
+#define SPR_EX_CONTEXT_K_1 \
+	_concat4(SPR_EX_CONTEXT_, CONFIG_KERNEL_PL, _1,)
+#define SPR_INTCTRL_K_STATUS \
+	_concat4(SPR_INTCTRL_, CONFIG_KERNEL_PL, _STATUS,)
+#define INT_INTCTRL_K \
+	_concat4(INT_INTCTRL_, CONFIG_KERNEL_PL,,)
diff --git a/arch/tile/include/arch/spr_def_32.h b/arch/tile/include/arch/spr_def_32.h
index b4fc068..bbc1f4c 100644
--- a/arch/tile/include/arch/spr_def_32.h
+++ b/arch/tile/include/arch/spr_def_32.h
@@ -56,58 +56,93 @@
 #define SPR_EX_CONTEXT_1_1__ICS_SHIFT 2
 #define SPR_EX_CONTEXT_1_1__ICS_RMASK 0x1
 #define SPR_EX_CONTEXT_1_1__ICS_MASK  0x4
+#define SPR_EX_CONTEXT_2_0 0x4605
+#define SPR_EX_CONTEXT_2_1 0x4606
+#define SPR_EX_CONTEXT_2_1__PL_SHIFT 0
+#define SPR_EX_CONTEXT_2_1__PL_RMASK 0x3
+#define SPR_EX_CONTEXT_2_1__PL_MASK  0x3
+#define SPR_EX_CONTEXT_2_1__ICS_SHIFT 2
+#define SPR_EX_CONTEXT_2_1__ICS_RMASK 0x1
+#define SPR_EX_CONTEXT_2_1__ICS_MASK  0x4
 #define SPR_FAIL 0x4e09
 #define SPR_INTCTRL_0_STATUS 0x4a07
 #define SPR_INTCTRL_1_STATUS 0x4807
+#define SPR_INTCTRL_2_STATUS 0x4607
 #define SPR_INTERRUPT_CRITICAL_SECTION 0x4e0a
 #define SPR_INTERRUPT_MASK_0_0 0x4a08
 #define SPR_INTERRUPT_MASK_0_1 0x4a09
 #define SPR_INTERRUPT_MASK_1_0 0x4809
 #define SPR_INTERRUPT_MASK_1_1 0x480a
+#define SPR_INTERRUPT_MASK_2_0 0x4608
+#define SPR_INTERRUPT_MASK_2_1 0x4609
 #define SPR_INTERRUPT_MASK_RESET_0_0 0x4a0a
 #define SPR_INTERRUPT_MASK_RESET_0_1 0x4a0b
 #define SPR_INTERRUPT_MASK_RESET_1_0 0x480b
 #define SPR_INTERRUPT_MASK_RESET_1_1 0x480c
+#define SPR_INTERRUPT_MASK_RESET_2_0 0x460a
+#define SPR_INTERRUPT_MASK_RESET_2_1 0x460b
 #define SPR_INTERRUPT_MASK_SET_0_0 0x4a0c
 #define SPR_INTERRUPT_MASK_SET_0_1 0x4a0d
 #define SPR_INTERRUPT_MASK_SET_1_0 0x480d
 #define SPR_INTERRUPT_MASK_SET_1_1 0x480e
+#define SPR_INTERRUPT_MASK_SET_2_0 0x460c
+#define SPR_INTERRUPT_MASK_SET_2_1 0x460d
 #define SPR_MPL_DMA_CPL_SET_0 0x5800
 #define SPR_MPL_DMA_CPL_SET_1 0x5801
+#define SPR_MPL_DMA_CPL_SET_2 0x5802
 #define SPR_MPL_DMA_NOTIFY_SET_0 0x3800
 #define SPR_MPL_DMA_NOTIFY_SET_1 0x3801
+#define SPR_MPL_DMA_NOTIFY_SET_2 0x3802
 #define SPR_MPL_INTCTRL_0_SET_0 0x4a00
 #define SPR_MPL_INTCTRL_0_SET_1 0x4a01
+#define SPR_MPL_INTCTRL_0_SET_2 0x4a02
 #define SPR_MPL_INTCTRL_1_SET_0 0x4800
 #define SPR_MPL_INTCTRL_1_SET_1 0x4801
+#define SPR_MPL_INTCTRL_1_SET_2 0x4802
+#define SPR_MPL_INTCTRL_2_SET_0 0x4600
+#define SPR_MPL_INTCTRL_2_SET_1 0x4601
+#define SPR_MPL_INTCTRL_2_SET_2 0x4602
 #define SPR_MPL_SN_ACCESS_SET_0 0x0800
 #define SPR_MPL_SN_ACCESS_SET_1 0x0801
+#define SPR_MPL_SN_ACCESS_SET_2 0x0802
 #define SPR_MPL_SN_CPL_SET_0 0x5a00
 #define SPR_MPL_SN_CPL_SET_1 0x5a01
+#define SPR_MPL_SN_CPL_SET_2 0x5a02
 #define SPR_MPL_SN_FIREWALL_SET_0 0x2c00
 #define SPR_MPL_SN_FIREWALL_SET_1 0x2c01
+#define SPR_MPL_SN_FIREWALL_SET_2 0x2c02
 #define SPR_MPL_SN_NOTIFY_SET_0 0x2a00
 #define SPR_MPL_SN_NOTIFY_SET_1 0x2a01
+#define SPR_MPL_SN_NOTIFY_SET_2 0x2a02
 #define SPR_MPL_UDN_ACCESS_SET_0 0x0c00
 #define SPR_MPL_UDN_ACCESS_SET_1 0x0c01
+#define SPR_MPL_UDN_ACCESS_SET_2 0x0c02
 #define SPR_MPL_UDN_AVAIL_SET_0 0x4000
 #define SPR_MPL_UDN_AVAIL_SET_1 0x4001
+#define SPR_MPL_UDN_AVAIL_SET_2 0x4002
 #define SPR_MPL_UDN_CA_SET_0 0x3c00
 #define SPR_MPL_UDN_CA_SET_1 0x3c01
+#define SPR_MPL_UDN_CA_SET_2 0x3c02
 #define SPR_MPL_UDN_COMPLETE_SET_0 0x1400
 #define SPR_MPL_UDN_COMPLETE_SET_1 0x1401
+#define SPR_MPL_UDN_COMPLETE_SET_2 0x1402
 #define SPR_MPL_UDN_FIREWALL_SET_0 0x3000
 #define SPR_MPL_UDN_FIREWALL_SET_1 0x3001
+#define SPR_MPL_UDN_FIREWALL_SET_2 0x3002
 #define SPR_MPL_UDN_REFILL_SET_0 0x1000
 #define SPR_MPL_UDN_REFILL_SET_1 0x1001
+#define SPR_MPL_UDN_REFILL_SET_2 0x1002
 #define SPR_MPL_UDN_TIMER_SET_0 0x3600
 #define SPR_MPL_UDN_TIMER_SET_1 0x3601
+#define SPR_MPL_UDN_TIMER_SET_2 0x3602
 #define SPR_MPL_WORLD_ACCESS_SET_0 0x4e00
 #define SPR_MPL_WORLD_ACCESS_SET_1 0x4e01
+#define SPR_MPL_WORLD_ACCESS_SET_2 0x4e02
 #define SPR_PASS 0x4e0b
 #define SPR_PERF_COUNT_0 0x4205
 #define SPR_PERF_COUNT_1 0x4206
 #define SPR_PERF_COUNT_CTL 0x4207
+#define SPR_PERF_COUNT_DN_CTL 0x4210
 #define SPR_PERF_COUNT_STS 0x4208
 #define SPR_PROC_STATUS 0x4f00
 #define SPR_SIM_CONTROL 0x4e0c
@@ -124,6 +159,10 @@
 #define SPR_SYSTEM_SAVE_1_1 0x4901
 #define SPR_SYSTEM_SAVE_1_2 0x4902
 #define SPR_SYSTEM_SAVE_1_3 0x4903
+#define SPR_SYSTEM_SAVE_2_0 0x4700
+#define SPR_SYSTEM_SAVE_2_1 0x4701
+#define SPR_SYSTEM_SAVE_2_2 0x4702
+#define SPR_SYSTEM_SAVE_2_3 0x4703
 #define SPR_TILE_COORD 0x4c17
 #define SPR_TILE_RTF_HWM 0x4e10
 #define SPR_TILE_TIMER_CONTROL 0x3205
diff --git a/arch/tile/include/asm/irqflags.h b/arch/tile/include/asm/irqflags.h
index 45cf67c..6ebdd7d 100644
--- a/arch/tile/include/asm/irqflags.h
+++ b/arch/tile/include/asm/irqflags.h
@@ -47,53 +47,53 @@
 	int __n = (n); \
 	int __mask = 1 << (__n & 0x1f); \
 	if (__n < 32) \
-		__insn_mtspr(SPR_INTERRUPT_MASK_SET_1_0, __mask); \
+		__insn_mtspr(SPR_INTERRUPT_MASK_SET_K_0, __mask); \
 	else \
-		__insn_mtspr(SPR_INTERRUPT_MASK_SET_1_1, __mask); \
+		__insn_mtspr(SPR_INTERRUPT_MASK_SET_K_1, __mask); \
 } while (0)
 #define interrupt_mask_reset(n) do { \
 	int __n = (n); \
 	int __mask = 1 << (__n & 0x1f); \
 	if (__n < 32) \
-		__insn_mtspr(SPR_INTERRUPT_MASK_RESET_1_0, __mask); \
+		__insn_mtspr(SPR_INTERRUPT_MASK_RESET_K_0, __mask); \
 	else \
-		__insn_mtspr(SPR_INTERRUPT_MASK_RESET_1_1, __mask); \
+		__insn_mtspr(SPR_INTERRUPT_MASK_RESET_K_1, __mask); \
 } while (0)
 #define interrupt_mask_check(n) ({ \
 	int __n = (n); \
 	(((__n < 32) ? \
-	 __insn_mfspr(SPR_INTERRUPT_MASK_1_0) : \
-	 __insn_mfspr(SPR_INTERRUPT_MASK_1_1)) \
+	 __insn_mfspr(SPR_INTERRUPT_MASK_K_0) : \
+	 __insn_mfspr(SPR_INTERRUPT_MASK_K_1)) \
 	  >> (__n & 0x1f)) & 1; \
 })
 #define interrupt_mask_set_mask(mask) do { \
 	unsigned long long __m = (mask); \
-	__insn_mtspr(SPR_INTERRUPT_MASK_SET_1_0, (unsigned long)(__m)); \
-	__insn_mtspr(SPR_INTERRUPT_MASK_SET_1_1, (unsigned long)(__m>>32)); \
+	__insn_mtspr(SPR_INTERRUPT_MASK_SET_K_0, (unsigned long)(__m)); \
+	__insn_mtspr(SPR_INTERRUPT_MASK_SET_K_1, (unsigned long)(__m>>32)); \
 } while (0)
 #define interrupt_mask_reset_mask(mask) do { \
 	unsigned long long __m = (mask); \
-	__insn_mtspr(SPR_INTERRUPT_MASK_RESET_1_0, (unsigned long)(__m)); \
-	__insn_mtspr(SPR_INTERRUPT_MASK_RESET_1_1, (unsigned long)(__m>>32)); \
+	__insn_mtspr(SPR_INTERRUPT_MASK_RESET_K_0, (unsigned long)(__m)); \
+	__insn_mtspr(SPR_INTERRUPT_MASK_RESET_K_1, (unsigned long)(__m>>32)); \
 } while (0)
 #else
 #define interrupt_mask_set(n) \
-	__insn_mtspr(SPR_INTERRUPT_MASK_SET_1, (1UL << (n)))
+	__insn_mtspr(SPR_INTERRUPT_MASK_SET_K, (1UL << (n)))
 #define interrupt_mask_reset(n) \
-	__insn_mtspr(SPR_INTERRUPT_MASK_RESET_1, (1UL << (n)))
+	__insn_mtspr(SPR_INTERRUPT_MASK_RESET_K, (1UL << (n)))
 #define interrupt_mask_check(n) \
-	((__insn_mfspr(SPR_INTERRUPT_MASK_1) >> (n)) & 1)
+	((__insn_mfspr(SPR_INTERRUPT_MASK_K) >> (n)) & 1)
 #define interrupt_mask_set_mask(mask) \
-	__insn_mtspr(SPR_INTERRUPT_MASK_SET_1, (mask))
+	__insn_mtspr(SPR_INTERRUPT_MASK_SET_K, (mask))
 #define interrupt_mask_reset_mask(mask) \
-	__insn_mtspr(SPR_INTERRUPT_MASK_RESET_1, (mask))
+	__insn_mtspr(SPR_INTERRUPT_MASK_RESET_K, (mask))
 #endif
 
 /*
  * The set of interrupts we want active if irqs are enabled.
  * Note that in particular, the tile timer interrupt comes and goes
  * from this set, since we have no other way to turn off the timer.
- * Likewise, INTCTRL_1 is removed and re-added during device
+ * Likewise, INTCTRL_K is removed and re-added during device
  * interrupts, as is the the hardwall UDN_FIREWALL interrupt.
  * We use a low bit (MEM_ERROR) as our sentinel value and make sure it
  * is always claimed as an "active interrupt" so we can query that bit
@@ -168,14 +168,14 @@ DECLARE_PER_CPU(unsigned long long, interrupts_enabled_mask);
 
 /* Return 0 or 1 to indicate whether interrupts are currently disabled. */
 #define IRQS_DISABLED(tmp)					\
-	mfspr   tmp, INTERRUPT_MASK_1;				\
+	mfspr   tmp, SPR_INTERRUPT_MASK_K;			\
 	andi    tmp, tmp, 1
 
 /* Load up a pointer to &interrupts_enabled_mask. */
 #define GET_INTERRUPTS_ENABLED_MASK_PTR(reg)			\
-	moveli reg, hw2_last(interrupts_enabled_mask); \
-	shl16insli reg, reg, hw1(interrupts_enabled_mask); \
-	shl16insli reg, reg, hw0(interrupts_enabled_mask); \
+	moveli reg, hw2_last(interrupts_enabled_mask);		\
+	shl16insli reg, reg, hw1(interrupts_enabled_mask);	\
+	shl16insli reg, reg, hw0(interrupts_enabled_mask);	\
 	add     reg, reg, tp
 
 /* Disable interrupts. */
@@ -183,18 +183,18 @@ DECLARE_PER_CPU(unsigned long long, interrupts_enabled_mask);
 	moveli  tmp0, hw2_last(LINUX_MASKABLE_INTERRUPTS);	\
 	shl16insli tmp0, tmp0, hw1(LINUX_MASKABLE_INTERRUPTS);	\
 	shl16insli tmp0, tmp0, hw0(LINUX_MASKABLE_INTERRUPTS);	\
-	mtspr   INTERRUPT_MASK_SET_1, tmp0
+	mtspr   SPR_INTERRUPT_MASK_SET_K, tmp0
 
 /* Disable ALL synchronous interrupts (used by NMI entry). */
 #define IRQ_DISABLE_ALL(tmp)					\
 	movei   tmp, -1;					\
-	mtspr   INTERRUPT_MASK_SET_1, tmp
+	mtspr   SPR_INTERRUPT_MASK_SET_K, tmp
 
 /* Enable interrupts. */
 #define IRQ_ENABLE(tmp0, tmp1)					\
 	GET_INTERRUPTS_ENABLED_MASK_PTR(tmp0);			\
 	ld      tmp0, tmp0;					\
-	mtspr   INTERRUPT_MASK_RESET_1, tmp0
+	mtspr   SPR_INTERRUPT_MASK_RESET_K, tmp0
 
 #else /* !__tilegx__ */
 
@@ -208,14 +208,14 @@ DECLARE_PER_CPU(unsigned long long, interrupts_enabled_mask);
  * (making the original code's write of the "high" mask word idempotent).
  */
 #define IRQS_DISABLED(tmp)					\
-	mfspr   tmp, INTERRUPT_MASK_1_0;			\
+	mfspr   tmp, SPR_INTERRUPT_MASK_K_0;			\
 	shri    tmp, tmp, INT_MEM_ERROR;			\
 	andi    tmp, tmp, 1
 
 /* Load up a pointer to &interrupts_enabled_mask. */
 #define GET_INTERRUPTS_ENABLED_MASK_PTR(reg)			\
-	moveli  reg, lo16(interrupts_enabled_mask);	\
-	auli    reg, reg, ha16(interrupts_enabled_mask);\
+	moveli  reg, lo16(interrupts_enabled_mask);		\
+	auli    reg, reg, ha16(interrupts_enabled_mask);	\
 	add     reg, reg, tp
 
 /* Disable interrupts. */
@@ -225,16 +225,16 @@ DECLARE_PER_CPU(unsigned long long, interrupts_enabled_mask);
 	 moveli tmp1, lo16(LINUX_MASKABLE_INTERRUPTS)		\
 	};							\
 	{							\
-	 mtspr  INTERRUPT_MASK_SET_1_0, tmp0;			\
+	 mtspr  SPR_INTERRUPT_MASK_SET_K_0, tmp0;		\
 	 auli   tmp1, tmp1, ha16(LINUX_MASKABLE_INTERRUPTS)	\
 	};							\
-	mtspr   INTERRUPT_MASK_SET_1_1, tmp1
+	mtspr   SPR_INTERRUPT_MASK_SET_K_1, tmp1
 
 /* Disable ALL synchronous interrupts (used by NMI entry). */
 #define IRQ_DISABLE_ALL(tmp)					\
 	movei   tmp, -1;					\
-	mtspr   INTERRUPT_MASK_SET_1_0, tmp;			\
-	mtspr   INTERRUPT_MASK_SET_1_1, tmp
+	mtspr   SPR_INTERRUPT_MASK_SET_K_0, tmp;		\
+	mtspr   SPR_INTERRUPT_MASK_SET_K_1, tmp
 
 /* Enable interrupts. */
 #define IRQ_ENABLE(tmp0, tmp1)					\
@@ -244,8 +244,8 @@ DECLARE_PER_CPU(unsigned long long, interrupts_enabled_mask);
 	 addi   tmp1, tmp0, 4					\
 	};							\
 	lw      tmp1, tmp1;					\
-	mtspr   INTERRUPT_MASK_RESET_1_0, tmp0;			\
-	mtspr   INTERRUPT_MASK_RESET_1_1, tmp1
+	mtspr   SPR_INTERRUPT_MASK_RESET_K_0, tmp0;		\
+	mtspr   SPR_INTERRUPT_MASK_RESET_K_1, tmp1
 #endif
 
 /*
diff --git a/arch/tile/include/asm/page.h b/arch/tile/include/asm/page.h
index 7d90641..7979a45 100644
--- a/arch/tile/include/asm/page.h
+++ b/arch/tile/include/asm/page.h
@@ -199,17 +199,17 @@ static inline __attribute_const__ int get_order(unsigned long size)
  * If you want more physical memory than this then see the CONFIG_HIGHMEM
  * option in the kernel configuration.
  *
- * The top two 16MB chunks in the table below (VIRT and HV) are
- * unavailable to Linux.  Since the kernel interrupt vectors must live
- * at 0xfd000000, we map all of the bottom of RAM at this address with
- * a huge page table entry to minimize its ITLB footprint (as well as
- * at PAGE_OFFSET).  The last architected requirement is that user
- * interrupt vectors live at 0xfc000000, so we make that range of
- * memory available to user processes.  The remaining regions are sized
- * as shown; after the first four addresses, we show "typical" values,
- * since the actual addresses depend on kernel #defines.
+ * The top 16MB chunk in the table below is unavailable to Linux.  Since
+ * the kernel interrupt vectors must live at ether 0xfe000000 or 0xfd000000
+ * (depending on whether the kernel is at PL2 or Pl1), we map all of the
+ * bottom of RAM at this address with a huge page table entry to minimize
+ * its ITLB footprint (as well as at PAGE_OFFSET).  The last architected
+ * requirement is that user interrupt vectors live at 0xfc000000, so we
+ * make that range of memory available to user processes.  The remaining
+ * regions are sized as shown; the first four addresses use the PL 1
+ * values, and after that, we show "typical" values, since the actual
+ * addresses depend on kernel #defines.
  *
- * MEM_VIRT_INTRPT                 0xff000000
  * MEM_HV_INTRPT                   0xfe000000
  * MEM_SV_INTRPT (kernel code)     0xfd000000
  * MEM_USER_INTRPT (user vector)   0xfc000000
@@ -221,9 +221,14 @@ static inline __attribute_const__ int get_order(unsigned long size)
  */
 
 #define MEM_USER_INTRPT		_AC(0xfc000000, UL)
+#if CONFIG_KERNEL_PL == 1
 #define MEM_SV_INTRPT		_AC(0xfd000000, UL)
 #define MEM_HV_INTRPT		_AC(0xfe000000, UL)
-#define MEM_VIRT_INTRPT		_AC(0xff000000, UL)
+#else
+#define MEM_GUEST_INTRPT	_AC(0xfd000000, UL)
+#define MEM_SV_INTRPT		_AC(0xfe000000, UL)
+#define MEM_HV_INTRPT		_AC(0xff000000, UL)
+#endif
 
 #define INTRPT_SIZE		0x4000
 
diff --git a/arch/tile/include/asm/processor.h b/arch/tile/include/asm/processor.h
index ccd5f84..1747ff3 100644
--- a/arch/tile/include/asm/processor.h
+++ b/arch/tile/include/asm/processor.h
@@ -328,18 +328,21 @@ extern int kdata_huge;
  * Note that assembly code assumes that USER_PL is zero.
  */
 #define USER_PL 0
-#define KERNEL_PL 1
+#if CONFIG_KERNEL_PL == 2
+#define GUEST_PL 1
+#endif
+#define KERNEL_PL CONFIG_KERNEL_PL
 
-/* SYSTEM_SAVE_1_0 holds the current cpu number ORed with ksp0. */
+/* SYSTEM_SAVE_K_0 holds the current cpu number ORed with ksp0. */
 #define CPU_LOG_MASK_VALUE 12
 #define CPU_MASK_VALUE ((1 << CPU_LOG_MASK_VALUE) - 1)
 #if CONFIG_NR_CPUS > CPU_MASK_VALUE
 # error Too many cpus!
 #endif
 #define raw_smp_processor_id() \
-	((int)__insn_mfspr(SPR_SYSTEM_SAVE_1_0) & CPU_MASK_VALUE)
+	((int)__insn_mfspr(SPR_SYSTEM_SAVE_K_0) & CPU_MASK_VALUE)
 #define get_current_ksp0() \
-	(__insn_mfspr(SPR_SYSTEM_SAVE_1_0) & ~CPU_MASK_VALUE)
+	(__insn_mfspr(SPR_SYSTEM_SAVE_K_0) & ~CPU_MASK_VALUE)
 #define next_current_ksp0(task) ({ \
 	unsigned long __ksp0 = task_ksp0(task); \
 	int __cpu = raw_smp_processor_id(); \
diff --git a/arch/tile/include/asm/ptrace.h b/arch/tile/include/asm/ptrace.h
index 4a02bb0..ac6d343 100644
--- a/arch/tile/include/asm/ptrace.h
+++ b/arch/tile/include/asm/ptrace.h
@@ -62,8 +62,8 @@ struct pt_regs {
 	pt_reg_t lr;		/* aliases regs[TREG_LR] */
 
 	/* Saved special registers. */
-	pt_reg_t pc;		/* stored in EX_CONTEXT_1_0 */
-	pt_reg_t ex1;		/* stored in EX_CONTEXT_1_1 (PL and ICS bit) */
+	pt_reg_t pc;		/* stored in EX_CONTEXT_K_0 */
+	pt_reg_t ex1;		/* stored in EX_CONTEXT_K_1 (PL and ICS bit) */
 	pt_reg_t faultnum;	/* fault number (INT_SWINT_1 for syscall) */
 	pt_reg_t orig_r0;	/* r0 at syscall entry, else zero */
 	pt_reg_t flags;		/* flags (see below) */
diff --git a/arch/tile/include/asm/system.h b/arch/tile/include/asm/system.h
index fb7ff95..5388850 100644
--- a/arch/tile/include/asm/system.h
+++ b/arch/tile/include/asm/system.h
@@ -164,7 +164,7 @@ extern struct task_struct *_switch_to(struct task_struct *prev,
 /* Helper function for _switch_to(). */
 extern struct task_struct *__switch_to(struct task_struct *prev,
 				       struct task_struct *next,
-				       unsigned long new_system_save_1_0);
+				       unsigned long new_system_save_k_0);
 
 /* Address that switched-away from tasks are at. */
 extern unsigned long get_switch_to_pc(void);
diff --git a/arch/tile/include/hv/hypervisor.h b/arch/tile/include/hv/hypervisor.h
index 9bd303a..f672544 100644
--- a/arch/tile/include/hv/hypervisor.h
+++ b/arch/tile/include/hv/hypervisor.h
@@ -1003,37 +1003,37 @@ int hv_console_write(HV_VirtAddr bytes, int len);
  *  when these occur in a client's interrupt critical section, they must
  *  be delivered through the downcall mechanism.
  *
- *  A downcall is initially delivered to the client as an INTCTRL_1
- *  interrupt.  Upon entry to the INTCTRL_1 vector, the client must
- *  immediately invoke the hv_downcall_dispatch service.  This service
- *  will not return; instead it will cause one of the client's actual
- *  downcall-handling interrupt vectors to be entered.  The EX_CONTEXT
- *  registers in the client will be set so that when the client irets,
- *  it will return to the code which was interrupted by the INTCTRL_1
- *  interrupt.
- *
- *  Under some circumstances, the firing of INTCTRL_1 can race with
+ *  A downcall is initially delivered to the client as an INTCTRL_CL
+ *  interrupt, where CL is the client's PL.  Upon entry to the INTCTRL_CL
+ *  vector, the client must immediately invoke the hv_downcall_dispatch
+ *  service.  This service will not return; instead it will cause one of
+ *  the client's actual downcall-handling interrupt vectors to be entered.
+ *  The EX_CONTEXT registers in the client will be set so that when the
+ *  client irets, it will return to the code which was interrupted by the
+ *  INTCTRL_CL interrupt.
+ *
+ *  Under some circumstances, the firing of INTCTRL_CL can race with
  *  the lowering of a device interrupt.  In such a case, the
  *  hv_downcall_dispatch service may issue an iret instruction instead
  *  of entering one of the client's actual downcall-handling interrupt
  *  vectors.  This will return execution to the location that was
- *  interrupted by INTCTRL_1.
+ *  interrupted by INTCTRL_CL.
  *
  *  Any saving of registers should be done by the actual handling
- *  vectors; no registers should be changed by the INTCTRL_1 handler.
+ *  vectors; no registers should be changed by the INTCTRL_CL handler.
  *  In particular, the client should not use a jal instruction to invoke
  *  the hv_downcall_dispatch service, as that would overwrite the client's
  *  lr register.  Note that the hv_downcall_dispatch service may overwrite
  *  one or more of the client's system save registers.
  *
- *  The client must not modify the INTCTRL_1_STATUS SPR.  The hypervisor
+ *  The client must not modify the INTCTRL_CL_STATUS SPR.  The hypervisor
  *  will set this register to cause a downcall to happen, and will clear
  *  it when no further downcalls are pending.
  *
- *  When a downcall vector is entered, the INTCTRL_1 interrupt will be
+ *  When a downcall vector is entered, the INTCTRL_CL interrupt will be
  *  masked.  When the client is done processing a downcall, and is ready
  *  to accept another, it must unmask this interrupt; if more downcalls
- *  are pending, this will cause the INTCTRL_1 vector to be reentered.
+ *  are pending, this will cause the INTCTRL_CL vector to be reentered.
  *  Currently the following interrupt vectors can be entered through a
  *  downcall:
  *
diff --git a/arch/tile/kernel/entry.S b/arch/tile/kernel/entry.S
index 80d13f0..fd8dc42 100644
--- a/arch/tile/kernel/entry.S
+++ b/arch/tile/kernel/entry.S
@@ -15,7 +15,9 @@
 #include <linux/linkage.h>
 #include <linux/unistd.h>
 #include <asm/irqflags.h>
+#include <asm/processor.h>
 #include <arch/abi.h>
+#include <arch/spr_def.h>
 
 #ifdef __tilegx__
 #define bnzt bnezt
@@ -80,7 +82,7 @@ STD_ENTRY(KBacktraceIterator_init_current)
 STD_ENTRY(cpu_idle_on_new_stack)
 	{
 	 move sp, r1
-	 mtspr SYSTEM_SAVE_1_0, r2
+	 mtspr SPR_SYSTEM_SAVE_K_0, r2
 	}
 	jal free_thread_info
 	j cpu_idle
@@ -102,15 +104,15 @@ STD_ENTRY(smp_nap)
 STD_ENTRY(_cpu_idle)
 	{
 	 lnk r0
-	 movei r1, 1
+	 movei r1, KERNEL_PL
 	}
 	{
 	 addli r0, r0, _cpu_idle_nap - .
 	 mtspr INTERRUPT_CRITICAL_SECTION, r1
 	}
-	IRQ_ENABLE(r2, r3)         /* unmask, but still with ICS set */
-	mtspr EX_CONTEXT_1_1, r1   /* PL1, ICS clear */
-	mtspr EX_CONTEXT_1_0, r0
+	IRQ_ENABLE(r2, r3)             /* unmask, but still with ICS set */
+	mtspr SPR_EX_CONTEXT_K_1, r1   /* Kernel PL, ICS clear */
+	mtspr SPR_EX_CONTEXT_K_0, r0
 	iret
 	.global _cpu_idle_nap
 _cpu_idle_nap:
diff --git a/arch/tile/kernel/head_32.S b/arch/tile/kernel/head_32.S
index 2b4f6c0..90e7c44 100644
--- a/arch/tile/kernel/head_32.S
+++ b/arch/tile/kernel/head_32.S
@@ -23,6 +23,7 @@
 #include <asm/asm-offsets.h>
 #include <hv/hypervisor.h>
 #include <arch/chip.h>
+#include <arch/spr_def.h>
 
 /*
  * This module contains the entry code for kernel images. It performs the
@@ -76,7 +77,7 @@ ENTRY(_start)
 	}
 1:
 
-	/* Get our processor number and save it away in SAVE_1_0. */
+	/* Get our processor number and save it away in SAVE_K_0. */
 	jal hv_inquire_topology
 	mulll_uu r4, r1, r2        /* r1 == y, r2 == width */
 	add r4, r4, r0             /* r0 == x, so r4 == cpu == y*width + x */
@@ -124,7 +125,7 @@ ENTRY(_start)
 	lw r0, r0
 	lw sp, r1
 	or r4, sp, r4
-	mtspr SYSTEM_SAVE_1_0, r4  /* save ksp0 + cpu */
+	mtspr SPR_SYSTEM_SAVE_K_0, r4  /* save ksp0 + cpu */
 	addi sp, sp, -STACK_TOP_DELTA
 	{
 	  move lr, zero   /* stop backtraces in the called function */
diff --git a/arch/tile/kernel/intvec_32.S b/arch/tile/kernel/intvec_32.S
index f87c5c0..206dc7e 100644
--- a/arch/tile/kernel/intvec_32.S
+++ b/arch/tile/kernel/intvec_32.S
@@ -32,8 +32,8 @@
 # error "No support for kernel preemption currently"
 #endif
 
-#if INT_INTCTRL_1 < 32 || INT_INTCTRL_1 >= 48
-# error INT_INTCTRL_1 coded to set high interrupt mask
+#if INT_INTCTRL_K < 32 || INT_INTCTRL_K >= 48
+# error INT_INTCTRL_K coded to set high interrupt mask
 #endif
 
 #define PTREGS_PTR(reg, ptreg) addli reg, sp, C_ABI_SAVE_AREA_SIZE + (ptreg)
@@ -132,8 +132,8 @@ intvec_\vecname:
 
 	/* Temporarily save a register so we have somewhere to work. */
 
-	mtspr   SYSTEM_SAVE_1_1, r0
-	mfspr   r0, EX_CONTEXT_1_1
+	mtspr   SPR_SYSTEM_SAVE_K_1, r0
+	mfspr   r0, SPR_EX_CONTEXT_K_1
 
 	/* The cmpxchg code clears sp to force us to reset it here on fault. */
 	{
@@ -167,18 +167,18 @@ intvec_\vecname:
 	 * The page_fault handler may be downcalled directly by the
 	 * hypervisor even when Linux is running and has ICS set.
 	 *
-	 * In this case the contents of EX_CONTEXT_1_1 reflect the
+	 * In this case the contents of EX_CONTEXT_K_1 reflect the
 	 * previous fault and can't be relied on to choose whether or
 	 * not to reinitialize the stack pointer.  So we add a test
-	 * to see whether SYSTEM_SAVE_1_2 has the high bit set,
+	 * to see whether SYSTEM_SAVE_K_2 has the high bit set,
 	 * and if so we don't reinitialize sp, since we must be coming
 	 * from Linux.  (In fact the precise case is !(val & ~1),
 	 * but any Linux PC has to have the high bit set.)
 	 *
-	 * Note that the hypervisor *always* sets SYSTEM_SAVE_1_2 for
+	 * Note that the hypervisor *always* sets SYSTEM_SAVE_K_2 for
 	 * any path that turns into a downcall to one of our TLB handlers.
 	 */
-	mfspr   r0, SYSTEM_SAVE_1_2
+	mfspr   r0, SPR_SYSTEM_SAVE_K_2
 	{
 	 blz    r0, 0f    /* high bit in S_S_1_2 is for a PC to use */
 	 move   r0, sp
@@ -187,12 +187,12 @@ intvec_\vecname:
 
 2:
 	/*
-	 * SYSTEM_SAVE_1_0 holds the cpu number in the low bits, and
+	 * SYSTEM_SAVE_K_0 holds the cpu number in the low bits, and
 	 * the current stack top in the higher bits.  So we recover
 	 * our stack top by just masking off the low bits, then
 	 * point sp at the top aligned address on the actual stack page.
 	 */
-	mfspr   r0, SYSTEM_SAVE_1_0
+	mfspr   r0, SPR_SYSTEM_SAVE_K_0
 	mm      r0, r0, zero, LOG2_THREAD_SIZE, 31
 
 0:
@@ -254,7 +254,7 @@ intvec_\vecname:
 	 sw     sp, r3
 	 addli  sp, sp, PTREGS_OFFSET_PC - PTREGS_OFFSET_REG(3)
 	}
-	mfspr   r0, EX_CONTEXT_1_0
+	mfspr   r0, SPR_EX_CONTEXT_K_0
 	.ifc \processing,handle_syscall
 	/*
 	 * Bump the saved PC by one bundle so that when we return, we won't
@@ -267,7 +267,7 @@ intvec_\vecname:
 	 sw     sp, r0
 	 addli  sp, sp, PTREGS_OFFSET_EX1 - PTREGS_OFFSET_PC
 	}
-	mfspr   r0, EX_CONTEXT_1_1
+	mfspr   r0, SPR_EX_CONTEXT_K_1
 	{
 	 sw     sp, r0
 	 addi   sp, sp, PTREGS_OFFSET_FAULTNUM - PTREGS_OFFSET_EX1
@@ -289,7 +289,7 @@ intvec_\vecname:
 	 .endif
 	 addli  sp, sp, PTREGS_OFFSET_REG(0) - PTREGS_OFFSET_FAULTNUM
 	}
-	mfspr   r0, SYSTEM_SAVE_1_1    /* Original r0 */
+	mfspr   r0, SPR_SYSTEM_SAVE_K_1    /* Original r0 */
 	{
 	 sw     sp, r0
 	 addi   sp, sp, -PTREGS_OFFSET_REG(0) - 4
@@ -309,12 +309,12 @@ intvec_\vecname:
 	 * See discussion below at "finish_interrupt_save".
 	 */
 	.ifc \c_routine, do_page_fault
-	mfspr   r2, SYSTEM_SAVE_1_3   /* address of page fault */
-	mfspr   r3, SYSTEM_SAVE_1_2   /* info about page fault */
+	mfspr   r2, SPR_SYSTEM_SAVE_K_3   /* address of page fault */
+	mfspr   r3, SPR_SYSTEM_SAVE_K_2   /* info about page fault */
 	.else
 	.ifc \vecnum, INT_DOUBLE_FAULT
 	{
-	 mfspr  r2, SYSTEM_SAVE_1_2   /* double fault info from HV */
+	 mfspr  r2, SPR_SYSTEM_SAVE_K_2   /* double fault info from HV */
 	 movei  r3, 0
 	}
 	.else
@@ -467,7 +467,7 @@ intvec_\vecname:
 	/* Load tp with our per-cpu offset. */
 #ifdef CONFIG_SMP
 	{
-	 mfspr  r20, SYSTEM_SAVE_1_0
+	 mfspr  r20, SPR_SYSTEM_SAVE_K_0
 	 moveli r21, lo16(__per_cpu_offset)
 	}
 	{
@@ -487,7 +487,7 @@ intvec_\vecname:
 	 * We load flags in r32 here so we can jump to .Lrestore_regs
 	 * directly after do_page_fault_ics() if necessary.
 	 */
-	mfspr   r32, EX_CONTEXT_1_1
+	mfspr   r32, SPR_EX_CONTEXT_K_1
 	{
 	 andi   r32, r32, SPR_EX_CONTEXT_1_1__PL_MASK  /* mask off ICS */
 	 PTREGS_PTR(r21, PTREGS_OFFSET_FLAGS)
@@ -957,11 +957,11 @@ STD_ENTRY(interrupt_return)
 	pop_reg_zero r21, r3, sp, PTREGS_OFFSET_EX1 - PTREGS_OFFSET_PC
 	pop_reg_zero lr, r4, sp, PTREGS_OFFSET_REG(52) - PTREGS_OFFSET_EX1
 	{
-	 mtspr  EX_CONTEXT_1_0, r21
+	 mtspr  SPR_EX_CONTEXT_K_0, r21
 	 move   r5, zero
 	}
 	{
-	 mtspr  EX_CONTEXT_1_1, lr
+	 mtspr  SPR_EX_CONTEXT_K_1, lr
 	 andi   lr, lr, SPR_EX_CONTEXT_1_1__PL_MASK  /* mask off ICS */
 	}
 
@@ -1199,7 +1199,7 @@ STD_ENTRY(interrupt_return)
 	STD_ENDPROC(interrupt_return)
 
 	/*
-	 * This interrupt variant clears the INT_INTCTRL_1 interrupt mask bit
+	 * This interrupt variant clears the INT_INTCTRL_K interrupt mask bit
 	 * before returning, so we can properly get more downcalls.
 	 */
 	.pushsection .text.handle_interrupt_downcall,"ax"
@@ -1208,11 +1208,11 @@ handle_interrupt_downcall:
 	check_single_stepping normal, .Ldispatch_downcall
 .Ldispatch_downcall:
 
-	/* Clear INTCTRL_1 from the set of interrupts we ever enable. */
+	/* Clear INTCTRL_K from the set of interrupts we ever enable. */
 	GET_INTERRUPTS_ENABLED_MASK_PTR(r30)
 	{
 	 addi   r30, r30, 4
-	 movei  r31, INT_MASK(INT_INTCTRL_1)
+	 movei  r31, INT_MASK(INT_INTCTRL_K)
 	}
 	{
 	 lw     r20, r30
@@ -1227,7 +1227,7 @@ handle_interrupt_downcall:
 	}
 	FEEDBACK_REENTER(handle_interrupt_downcall)
 
-	/* Allow INTCTRL_1 to be enabled next time we enable interrupts. */
+	/* Allow INTCTRL_K to be enabled next time we enable interrupts. */
 	lw      r20, r30
 	or      r20, r20, r31
 	sw      r30, r20
@@ -1509,7 +1509,7 @@ handle_ill:
 /* Various stub interrupt handlers and syscall handlers */
 
 STD_ENTRY_LOCAL(_kernel_double_fault)
-	mfspr   r1, EX_CONTEXT_1_0
+	mfspr   r1, SPR_EX_CONTEXT_K_0
 	move    r2, lr
 	move    r3, sp
 	move    r4, r52
@@ -1518,7 +1518,7 @@ STD_ENTRY_LOCAL(_kernel_double_fault)
 	STD_ENDPROC(_kernel_double_fault)
 
 STD_ENTRY_LOCAL(bad_intr)
-	mfspr   r2, EX_CONTEXT_1_0
+	mfspr   r2, SPR_EX_CONTEXT_K_0
 	panic   "Unhandled interrupt %#x: PC %#lx"
 	STD_ENDPROC(bad_intr)
 
@@ -1560,7 +1560,7 @@ STD_ENTRY(_sys_clone)
  * a page fault which would assume the stack was valid, it does
  * save/restore the stack pointer and zero it out to make sure it gets reset.
  * Since we always keep interrupts disabled, the hypervisor won't
- * clobber our EX_CONTEXT_1_x registers, so we don't save/restore them
+ * clobber our EX_CONTEXT_K_x registers, so we don't save/restore them
  * (other than to advance the PC on return).
  *
  * We have to manually validate the user vs kernel address range
@@ -1766,7 +1766,7 @@ ENTRY(sys_cmpxchg)
 	/* Do slow mtspr here so the following "mf" waits less. */
 	{
 	 move   sp, r27
-	 mtspr  EX_CONTEXT_1_0, r28
+	 mtspr  SPR_EX_CONTEXT_K_0, r28
 	}
 	mf
 
@@ -1785,7 +1785,7 @@ ENTRY(sys_cmpxchg)
 	}
 	{
 	 move   sp, r27
-	 mtspr  EX_CONTEXT_1_0, r28
+	 mtspr  SPR_EX_CONTEXT_K_0, r28
 	}
 	iret
 
@@ -1813,7 +1813,7 @@ ENTRY(sys_cmpxchg)
 #endif
 
 	/* Issue the slow SPR here while the tns result is in flight. */
-	mfspr   r28, EX_CONTEXT_1_0
+	mfspr   r28, SPR_EX_CONTEXT_K_0
 
 	{
 	 addi   r28, r28, 8    /* return to the instruction after the swint1 */
@@ -1901,7 +1901,7 @@ ENTRY(sys_cmpxchg)
 .Lcmpxchg64_mismatch:
 	{
 	 move   sp, r27
-	 mtspr  EX_CONTEXT_1_0, r28
+	 mtspr  SPR_EX_CONTEXT_K_0, r28
 	}
 	mf
 	{
@@ -1982,8 +1982,13 @@ int_unalign:
 	int_hand     INT_PERF_COUNT, PERF_COUNT, \
 		     op_handle_perf_interrupt, handle_nmi
 	int_hand     INT_INTCTRL_3, INTCTRL_3, bad_intr
+#if CONFIG_KERNEL_PL == 2
+	dc_dispatch  INT_INTCTRL_2, INTCTRL_2
+	int_hand     INT_INTCTRL_1, INTCTRL_1, bad_intr
+#else
 	int_hand     INT_INTCTRL_2, INTCTRL_2, bad_intr
 	dc_dispatch  INT_INTCTRL_1, INTCTRL_1
+#endif
 	int_hand     INT_INTCTRL_0, INTCTRL_0, bad_intr
 	int_hand     INT_MESSAGE_RCV_DWNCL, MESSAGE_RCV_DWNCL, \
 		     hv_message_intr, handle_interrupt_downcall
diff --git a/arch/tile/kernel/irq.c b/arch/tile/kernel/irq.c
index 596c600..394d554 100644
--- a/arch/tile/kernel/irq.c
+++ b/arch/tile/kernel/irq.c
@@ -61,9 +61,9 @@ static DEFINE_SPINLOCK(available_irqs_lock);
 
 #if CHIP_HAS_IPI()
 /* Use SPRs to manipulate device interrupts. */
-#define mask_irqs(irq_mask) __insn_mtspr(SPR_IPI_MASK_SET_1, irq_mask)
-#define unmask_irqs(irq_mask) __insn_mtspr(SPR_IPI_MASK_RESET_1, irq_mask)
-#define clear_irqs(irq_mask) __insn_mtspr(SPR_IPI_EVENT_RESET_1, irq_mask)
+#define mask_irqs(irq_mask) __insn_mtspr(SPR_IPI_MASK_SET_K, irq_mask)
+#define unmask_irqs(irq_mask) __insn_mtspr(SPR_IPI_MASK_RESET_K, irq_mask)
+#define clear_irqs(irq_mask) __insn_mtspr(SPR_IPI_EVENT_RESET_K, irq_mask)
 #else
 /* Use HV to manipulate device interrupts. */
 #define mask_irqs(irq_mask) hv_disable_intr(irq_mask)
@@ -89,16 +89,16 @@ void tile_dev_intr(struct pt_regs *regs, int intnum)
 	 * masked by a previous interrupt.  Then, mask out the ones
 	 * we're going to handle.
 	 */
-	unsigned long masked = __insn_mfspr(SPR_IPI_MASK_1);
-	original_irqs = __insn_mfspr(SPR_IPI_EVENT_1) & ~masked;
-	__insn_mtspr(SPR_IPI_MASK_SET_1, original_irqs);
+	unsigned long masked = __insn_mfspr(SPR_IPI_MASK_K);
+	original_irqs = __insn_mfspr(SPR_IPI_EVENT_K) & ~masked;
+	__insn_mtspr(SPR_IPI_MASK_SET_K, original_irqs);
 #else
 	/*
 	 * Hypervisor performs the equivalent of the Gx code above and
 	 * then puts the pending interrupt mask into a system save reg
 	 * for us to find.
 	 */
-	original_irqs = __insn_mfspr(SPR_SYSTEM_SAVE_1_3);
+	original_irqs = __insn_mfspr(SPR_SYSTEM_SAVE_K_3);
 #endif
 	remaining_irqs = original_irqs;
 
@@ -225,7 +225,7 @@ void __cpuinit setup_irq_regs(void)
 	/* Enable interrupt delivery. */
 	unmask_irqs(~0UL);
 #if CHIP_HAS_IPI()
-	raw_local_irq_unmask(INT_IPI_1);
+	raw_local_irq_unmask(INT_IPI_K);
 #endif
 }
 
diff --git a/arch/tile/kernel/messaging.c b/arch/tile/kernel/messaging.c
index 6d23ed2..997e393 100644
--- a/arch/tile/kernel/messaging.c
+++ b/arch/tile/kernel/messaging.c
@@ -34,7 +34,7 @@ void __cpuinit init_messaging(void)
 		panic("hv_register_message_state: error %d", rc);
 
 	/* Make sure downcall interrupts will be enabled. */
-	raw_local_irq_unmask(INT_INTCTRL_1);
+	raw_local_irq_unmask(INT_INTCTRL_K);
 }
 
 void hv_message_intr(struct pt_regs *regs, int intnum)
diff --git a/arch/tile/kernel/process.c b/arch/tile/kernel/process.c
index 221f12b..8430f45 100644
--- a/arch/tile/kernel/process.c
+++ b/arch/tile/kernel/process.c
@@ -305,15 +305,25 @@ int dump_task_regs(struct task_struct *tsk, elf_gregset_t *regs)
 /* Allow user processes to access the DMA SPRs */
 void grant_dma_mpls(void)
 {
+#if CONFIG_KERNEL_PL == 2
+	__insn_mtspr(SPR_MPL_DMA_CPL_SET_1, 1);
+	__insn_mtspr(SPR_MPL_DMA_NOTIFY_SET_1, 1);
+#else
 	__insn_mtspr(SPR_MPL_DMA_CPL_SET_0, 1);
 	__insn_mtspr(SPR_MPL_DMA_NOTIFY_SET_0, 1);
+#endif
 }
 
 /* Forbid user processes from accessing the DMA SPRs */
 void restrict_dma_mpls(void)
 {
+#if CONFIG_KERNEL_PL == 2
+	__insn_mtspr(SPR_MPL_DMA_CPL_SET_2, 1);
+	__insn_mtspr(SPR_MPL_DMA_NOTIFY_SET_2, 1);
+#else
 	__insn_mtspr(SPR_MPL_DMA_CPL_SET_1, 1);
 	__insn_mtspr(SPR_MPL_DMA_NOTIFY_SET_1, 1);
+#endif
 }
 
 /* Pause the DMA engine, then save off its state registers. */
@@ -524,7 +534,7 @@ struct task_struct *__sched _switch_to(struct task_struct *prev,
 	 * Switch kernel SP, PC, and callee-saved registers.
 	 * In the context of the new task, return the old task pointer
 	 * (i.e. the task that actually called __switch_to).
-	 * Pass the value to use for SYSTEM_SAVE_1_0 when we reset our sp.
+	 * Pass the value to use for SYSTEM_SAVE_K_0 when we reset our sp.
 	 */
 	return __switch_to(prev, next, next_current_ksp0(next));
 }
diff --git a/arch/tile/kernel/regs_32.S b/arch/tile/kernel/regs_32.S
index e88d6e1..caa1310 100644
--- a/arch/tile/kernel/regs_32.S
+++ b/arch/tile/kernel/regs_32.S
@@ -85,7 +85,7 @@ STD_ENTRY_SECTION(__switch_to, .sched.text)
 	{
 	  /* Update sp and ksp0 simultaneously to avoid backtracer warnings. */
 	  move sp, r13
-	  mtspr SYSTEM_SAVE_1_0, r2
+	  mtspr SPR_SYSTEM_SAVE_K_0, r2
 	}
 	FOR_EACH_CALLEE_SAVED_REG(LOAD_REG)
 .L__switch_to_pc:
diff --git a/arch/tile/kernel/setup.c b/arch/tile/kernel/setup.c
index c1a697e..6444a2b 100644
--- a/arch/tile/kernel/setup.c
+++ b/arch/tile/kernel/setup.c
@@ -187,11 +187,11 @@ early_param("vmalloc", parse_vmalloc);
 
 #ifdef CONFIG_HIGHMEM
 /*
- * Determine for each controller where its lowmem is mapped and how
- * much of it is mapped there.  On controller zero, the first few
- * megabytes are mapped at 0xfd000000 as code, so in principle we
- * could start our data mappings higher up, but for now we don't
- * bother, to avoid additional confusion.
+ * Determine for each controller where its lowmem is mapped and how much of
+ * it is mapped there.  On controller zero, the first few megabytes are
+ * already mapped in as code at MEM_SV_INTRPT, so in principle we could
+ * start our data mappings higher up, but for now we don't bother, to avoid
+ * additional confusion.
  *
  * One question is whether, on systems with more than 768 Mb and
  * controllers of different sizes, to map in a proportionate amount of
@@ -876,6 +876,9 @@ void __cpuinit setup_cpu(int boot)
 #if CHIP_HAS_SN_PROC()
 	raw_local_irq_unmask(INT_SNITLB_MISS);
 #endif
+#ifdef __tilegx__
+	raw_local_irq_unmask(INT_SINGLE_STEP_K);
+#endif
 
 	/*
 	 * Allow user access to many generic SPRs, like the cycle
@@ -893,11 +896,12 @@ void __cpuinit setup_cpu(int boot)
 #endif
 
 	/*
-	 * Set the MPL for interrupt control 0 to user level.
-	 * This includes access to the SYSTEM_SAVE and EX_CONTEXT SPRs,
-	 * as well as the PL 0 interrupt mask.
+	 * Set the MPL for interrupt control 0 & 1 to the corresponding
+	 * values.  This includes access to the SYSTEM_SAVE and EX_CONTEXT
+	 * SPRs, as well as the interrupt mask.
 	 */
 	__insn_mtspr(SPR_MPL_INTCTRL_0_SET_0, 1);
+	__insn_mtspr(SPR_MPL_INTCTRL_1_SET_1, 1);
 
 	/* Initialize IRQ support for this cpu. */
 	setup_irq_regs();
@@ -1033,7 +1037,7 @@ static void __init validate_va(void)
 	 * In addition, make sure we CAN'T use the end of memory, since
 	 * we use the last chunk of each pgd for the pgd_list.
 	 */
-	int i, fc_fd_ok = 0;
+	int i, user_kernel_ok = 0;
 	unsigned long max_va = 0;
 	unsigned long list_va =
 		((PGD_LIST_OFFSET / sizeof(pgd_t)) << PGDIR_SHIFT);
@@ -1044,13 +1048,13 @@ static void __init validate_va(void)
 			break;
 		if (range.start <= MEM_USER_INTRPT &&
 		    range.start + range.size >= MEM_HV_INTRPT)
-			fc_fd_ok = 1;
+			user_kernel_ok = 1;
 		if (range.start == 0)
 			max_va = range.size;
 		BUG_ON(range.start + range.size > list_va);
 	}
-	if (!fc_fd_ok)
-		early_panic("Hypervisor not configured for VAs 0xfc/0xfd\n");
+	if (!user_kernel_ok)
+		early_panic("Hypervisor not configured for user/kernel VAs\n");
 	if (max_va == 0)
 		early_panic("Hypervisor not configured for low VAs\n");
 	if (max_va < KERNEL_HIGH_VADDR)
diff --git a/arch/tile/kernel/smp.c b/arch/tile/kernel/smp.c
index 1cb5ec7..75255d9 100644
--- a/arch/tile/kernel/smp.c
+++ b/arch/tile/kernel/smp.c
@@ -212,7 +212,7 @@ void __init ipi_init(void)
 
 		tile.x = cpu_x(cpu);
 		tile.y = cpu_y(cpu);
-		if (hv_get_ipi_pte(tile, 1, &pte) != 0)
+		if (hv_get_ipi_pte(tile, KERNEL_PL, &pte) != 0)
 			panic("Failed to initialize IPI for cpu %d\n", cpu);
 
 		offset = hv_pte_get_pfn(pte) << PAGE_SHIFT;
diff --git a/arch/tile/kernel/traps.c b/arch/tile/kernel/traps.c
index 0f362dc..7826a8b 100644
--- a/arch/tile/kernel/traps.c
+++ b/arch/tile/kernel/traps.c
@@ -278,7 +278,7 @@ void __kprobes do_trap(struct pt_regs *regs, int fault_num,
 	case INT_DOUBLE_FAULT:
 		/*
 		 * For double fault, "reason" is actually passed as
-		 * SYSTEM_SAVE_1_2, the hypervisor's double-fault info, so
+		 * SYSTEM_SAVE_K_2, the hypervisor's double-fault info, so
 		 * we can provide the original fault number rather than
 		 * the uninteresting "INT_DOUBLE_FAULT" so the user can
 		 * learn what actually struck while PL0 ICS was set.
diff --git a/arch/tile/kvm/Kconfig b/arch/tile/kvm/Kconfig
new file mode 100644
index 0000000..b88f9c0
--- /dev/null
+++ b/arch/tile/kvm/Kconfig
@@ -0,0 +1,38 @@
+#
+# KVM configuration
+#
+
+source "virt/kvm/Kconfig"
+
+menuconfig VIRTUALIZATION
+	bool "Virtualization"
+	---help---
+	  Say Y here to get to see options for using your Linux host to run
+	  other operating systems inside virtual machines (guests).
+	  This option alone does not add any kernel code.
+
+	  If you say N, all options in this submenu will be skipped and
+	  disabled.
+
+if VIRTUALIZATION
+
+config KVM
+	tristate "Kernel-based Virtual Machine (KVM) support"
+	depends on HAVE_KVM && MODULES && EXPERIMENTAL
+	select PREEMPT_NOTIFIERS
+	select ANON_INODES
+	---help---
+	  Support hosting paravirtualized guest machines.
+
+	  This module provides access to the hardware capabilities through
+	  a character device node named /dev/kvm.
+
+	  To compile this as a module, choose M here: the module
+	  will be called kvm.
+
+	  If unsure, say N.
+
+source drivers/vhost/Kconfig
+source drivers/virtio/Kconfig
+
+endif # VIRTUALIZATION
diff --git a/arch/tile/mm/fault.c b/arch/tile/mm/fault.c
index 94f579d..f295b4a 100644
--- a/arch/tile/mm/fault.c
+++ b/arch/tile/mm/fault.c
@@ -563,10 +563,10 @@ do_sigbus:
 /*
  * When we take an ITLB or DTLB fault or access violation in the
  * supervisor while the critical section bit is set, the hypervisor is
- * reluctant to write new values into the EX_CONTEXT_1_x registers,
+ * reluctant to write new values into the EX_CONTEXT_K_x registers,
  * since that might indicate we have not yet squirreled the SPR
  * contents away and can thus safely take a recursive interrupt.
- * Accordingly, the hypervisor passes us the PC via SYSTEM_SAVE_1_2.
+ * Accordingly, the hypervisor passes us the PC via SYSTEM_SAVE_K_2.
  *
  * Note that this routine is called before homecache_tlb_defer_enter(),
  * which means that we can properly unlock any atomics that might
@@ -610,7 +610,7 @@ struct intvec_state do_page_fault_ics(struct pt_regs *regs, int fault_num,
 	 * fault.  We didn't set up a kernel stack on initial entry to
 	 * sys_cmpxchg, but instead had one set up by the fault, which
 	 * (because sys_cmpxchg never releases ICS) came to us via the
-	 * SYSTEM_SAVE_1_2 mechanism, and thus EX_CONTEXT_1_[01] are
+	 * SYSTEM_SAVE_K_2 mechanism, and thus EX_CONTEXT_K_[01] are
 	 * still referencing the original user code.  We release the
 	 * atomic lock and rewrite pt_regs so that it appears that we
 	 * came from user-space directly, and after we finish the
diff --git a/arch/tile/mm/init.c b/arch/tile/mm/init.c
index d89c9ea..78e1982 100644
--- a/arch/tile/mm/init.c
+++ b/arch/tile/mm/init.c
@@ -1060,7 +1060,7 @@ void free_initmem(void)
 
 	/*
 	 * Free the pages mapped from 0xc0000000 that correspond to code
-	 * pages from 0xfd000000 that we won't use again after init.
+	 * pages from MEM_SV_INTRPT that we won't use again after init.
 	 */
 	free_init_pages("unused kernel text",
 			(unsigned long)_sinittext - text_delta,
-- 
1.6.5.2

