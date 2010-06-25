Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233Ab0FYVK5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 17:10:57 -0400
Received: from king.tilera.com ([72.1.168.226]:44209 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438Ab0FYVKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 17:10:54 -0400
Message-Id: <201006252110.o5PLAovH010769@farm-0002.internal.tilera.com>
To: linux-kernel@vger.kernel.org
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 25 Jun 2010 16:41:11 -0400
Subject: [PATCH] arch/tile: Enable more sophisticated IRQ model for 32-bit chips.
X-OriginalArrivalTime: 25 Jun 2010 21:10:53.0142 (UTC) FILETIME=[E5225760:01CB14AA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This model is based on the on-chip interrupt model used by the
TILE-Gx next-generation hardware, and interacts much more cleanly
with the Linux generic IRQ layer.

The change includes modifications to the Tilera hypervisor, which
are reflected in the hypervisor headers in arch/tile/include/arch/.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/arch/chip_tile64.h  |    3 +
 arch/tile/include/arch/chip_tilepro.h |    3 +
 arch/tile/include/asm/irq.h           |   62 +++++++-
 arch/tile/include/asm/smp.h           |   27 +++-
 arch/tile/include/hv/hypervisor.h     |  117 ++++++++-------
 arch/tile/include/hv/pagesize.h       |   32 ++++
 arch/tile/kernel/hvglue.lds           |   14 +-
 arch/tile/kernel/irq.c                |  259 +++++++++++++++++++++++----------
 arch/tile/kernel/smp.c                |   72 ++++++++-
 9 files changed, 435 insertions(+), 154 deletions(-)
 create mode 100644 arch/tile/include/hv/pagesize.h

diff --git a/arch/tile/include/arch/chip_tile64.h b/arch/tile/include/arch/chip_tile64.h
index 18b5bc8..1246573 100644
--- a/arch/tile/include/arch/chip_tile64.h
+++ b/arch/tile/include/arch/chip_tile64.h
@@ -248,5 +248,8 @@
 /** Does the chip support rev1 DMA packets? */
 #define CHIP_HAS_REV1_DMA_PACKETS() 0
 
+/** Does the chip have an IPI shim? */
+#define CHIP_HAS_IPI() 0
+
 #endif /* !__OPEN_SOURCE__ */
 #endif /* __ARCH_CHIP_H__ */
diff --git a/arch/tile/include/arch/chip_tilepro.h b/arch/tile/include/arch/chip_tilepro.h
index 9852af1..e864c47 100644
--- a/arch/tile/include/arch/chip_tilepro.h
+++ b/arch/tile/include/arch/chip_tilepro.h
@@ -248,5 +248,8 @@
 /** Does the chip support rev1 DMA packets? */
 #define CHIP_HAS_REV1_DMA_PACKETS() 1
 
+/** Does the chip have an IPI shim? */
+#define CHIP_HAS_IPI() 0
+
 #endif /* !__OPEN_SOURCE__ */
 #endif /* __ARCH_CHIP_H__ */
diff --git a/arch/tile/include/asm/irq.h b/arch/tile/include/asm/irq.h
index 9be1f84..572fd3e 100644
--- a/arch/tile/include/asm/irq.h
+++ b/arch/tile/include/asm/irq.h
@@ -23,15 +23,65 @@
 /* IRQ numbers used for linux IPIs. */
 #define IRQ_RESCHEDULE 1
 
-/* The HV interrupt state object. */
-DECLARE_PER_CPU(HV_IntrState, dev_intr_state);
-
 void ack_bad_irq(unsigned int irq);
 
 /*
- * Paravirtualized drivers should call this when their init calls
- * discover a valid HV IRQ.
+ * Different ways of handling interrupts.  Tile interrupts are always
+ * per-cpu; there is no global interrupt controller to implement
+ * enable/disable.  Most onboard devices can send their interrupts to
+ * many tiles at the same time, and Tile-specific drivers know how to
+ * deal with this.
+ *
+ * However, generic devices (usually PCIE based, sometimes GPIO)
+ * expect that interrupts will fire on a single core at a time and
+ * that the irq can be enabled or disabled from any core at any time.
+ * We implement this by directing such interrupts to a single core.
+ *
+ * One added wrinkle is that PCI interrupts can be either
+ * hardware-cleared (legacy interrupts) or software cleared (MSI).
+ * Other generic device systems (GPIO) are always software-cleared.
+ *
+ * The enums below are used by drivers for onboard devices, including
+ * the internals of PCI root complex and GPIO.  They allow the driver
+ * to tell the generic irq code what kind of interrupt is mapped to a
+ * particular IRQ number.
+ */
+enum {
+	/* per-cpu interrupt; use enable/disable_percpu_irq() to mask */
+	TILE_IRQ_PERCPU,
+	/* global interrupt, hardware responsible for clearing. */
+	TILE_IRQ_HW_CLEAR,
+	/* global interrupt, software responsible for clearing. */
+	TILE_IRQ_SW_CLEAR,
+};
+
+
+/*
+ * Paravirtualized drivers should call this when they dynamically
+ * allocate a new IRQ or discover an IRQ that was pre-allocated by the
+ * hypervisor for use with their particular device.  This gives the
+ * IRQ subsystem an opportunity to do interrupt-type-specific
+ * initialization.
+ *
+ * ISSUE: We should modify this API so that registering anything
+ * except percpu interrupts also requires providing callback methods
+ * for enabling and disabling the interrupt.  This would allow the
+ * generic IRQ code to proxy enable/disable_irq() calls back into the
+ * PCI subsystem, which in turn could enable or disable the interrupt
+ * at the PCI shim.
  */
-void tile_irq_activate(unsigned int irq);
+void tile_irq_activate(unsigned int irq, int tile_irq_type);
+
+/*
+ * For onboard, non-PCI (e.g. TILE_IRQ_PERCPU) devices, drivers know
+ * how to use enable/disable_percpu_irq() to manage interrupts on each
+ * core.  We can't use the generic enable/disable_irq() because they
+ * use a single reference count per irq, rather than per cpu per irq.
+ */
+void enable_percpu_irq(unsigned int irq);
+void disable_percpu_irq(unsigned int irq);
+
+
+void setup_irq_regs(void);
 
 #endif /* _ASM_TILE_IRQ_H */
diff --git a/arch/tile/include/asm/smp.h b/arch/tile/include/asm/smp.h
index da24858..532124a 100644
--- a/arch/tile/include/asm/smp.h
+++ b/arch/tile/include/asm/smp.h
@@ -20,6 +20,7 @@
 #include <asm/processor.h>
 #include <linux/cpumask.h>
 #include <linux/irqreturn.h>
+#include <hv/hypervisor.h>
 
 /* Set up this tile to support receiving hypervisor messages */
 void init_messaging(void);
@@ -39,9 +40,6 @@ void send_IPI_single(int dest, int tag);
 /* Process an IPI message */
 void evaluate_message(int tag);
 
-/* Process an IRQ_RESCHEDULE IPI. */
-irqreturn_t handle_reschedule_ipi(int irq, void *token);
-
 /* Boot a secondary cpu */
 void online_secondary(void);
 
@@ -56,6 +54,20 @@ extern HV_Topology smp_topology;
 #define smp_height		(smp_topology.height)
 #define smp_width		(smp_topology.width)
 
+/* Convenience functions for converting cpu <-> coords. */
+static inline int cpu_x(int cpu)
+{
+	return cpu % smp_width;
+}
+static inline int cpu_y(int cpu)
+{
+	return cpu / smp_width;
+}
+static inline int xy_to_cpu(int x, int y)
+{
+	return y * smp_width + x;
+}
+
 /* Hypervisor message tags sent via the tile send_IPI*() routines. */
 #define MSG_TAG_START_CPU		1
 #define MSG_TAG_STOP_CPU		2
@@ -85,6 +97,9 @@ void print_disabled_cpus(void);
 #define smp_master_cpu		0
 #define smp_height		1
 #define smp_width		1
+#define cpu_x(cpu)		0
+#define cpu_y(cpu)		0
+#define xy_to_cpu(x, y)		0
 
 #endif /* !CONFIG_SMP */
 
@@ -123,4 +138,10 @@ static inline int __cpulist_parse_crop(const char *buf, struct cpumask *dstp,
 	return bitmap_parselist_crop(buf, cpumask_bits(dstp), nbits);
 }
 
+/* Initialize the IPI subsystem. */
+void ipi_init(void);
+
+/* Function for start-cpu message to cause us to jump to. */
+extern unsigned long start_cpu_function_addr;
+
 #endif /* _ASM_TILE_SMP_H */
diff --git a/arch/tile/include/hv/hypervisor.h b/arch/tile/include/hv/hypervisor.h
index 84b3155..a90d298 100644
--- a/arch/tile/include/hv/hypervisor.h
+++ b/arch/tile/include/hv/hypervisor.h
@@ -20,12 +20,9 @@
 #ifndef _TILE_HV_H
 #define _TILE_HV_H
 
-#ifdef __tile__
 #include <arch/chip.h>
-#else
-/* HACK: Allow use by "tools/cpack/". */
-#include "install/include/arch/chip.h"
-#endif
+
+#include <hv/pagesize.h>
 
 /* Linux builds want unsigned long constants, but assembler wants numbers */
 #ifdef __ASSEMBLER__
@@ -39,7 +36,6 @@
 #define __HV_SIZE_ONE 1UL
 #endif
 
-
 /** The log2 of the span of a level-1 page table, in bytes.
  */
 #define HV_LOG2_L1_SPAN 32
@@ -48,21 +44,11 @@
  */
 #define HV_L1_SPAN (__HV_SIZE_ONE << HV_LOG2_L1_SPAN)
 
-/** The log2 of the size of small pages, in bytes. This value should
- * be verified at runtime by calling hv_sysconf(HV_SYSCONF_PAGE_SIZE_SMALL).
- */
-#define HV_LOG2_PAGE_SIZE_SMALL 16
-
 /** The size of small pages, in bytes. This value should be verified
  * at runtime by calling hv_sysconf(HV_SYSCONF_PAGE_SIZE_SMALL).
  */
 #define HV_PAGE_SIZE_SMALL (__HV_SIZE_ONE << HV_LOG2_PAGE_SIZE_SMALL)
 
-/** The log2 of the size of large pages, in bytes. This value should be
- * verified at runtime by calling hv_sysconf(HV_SYSCONF_PAGE_SIZE_LARGE).
- */
-#define HV_LOG2_PAGE_SIZE_LARGE 24
-
 /** The size of large pages, in bytes. This value should be verified
  * at runtime by calling hv_sysconf(HV_SYSCONF_PAGE_SIZE_LARGE).
  */
@@ -93,7 +79,7 @@
 #define HV_DISPATCH_ENTRY_SIZE 32
 
 /** Version of the hypervisor interface defined by this file */
-#define _HV_VERSION 10
+#define _HV_VERSION 11
 
 /* Index into hypervisor interface dispatch code blocks.
  *
@@ -253,8 +239,10 @@
 /** hv_set_command_line */
 #define HV_DISPATCH_SET_COMMAND_LINE              47
 
-/** hv_dev_register_intr_state */
-#define HV_DISPATCH_DEV_REGISTER_INTR_STATE       48
+#if !CHIP_HAS_IPI()
+
+/** hv_clear_intr */
+#define HV_DISPATCH_CLEAR_INTR                    48
 
 /** hv_enable_intr */
 #define HV_DISPATCH_ENABLE_INTR                   49
@@ -262,20 +250,30 @@
 /** hv_disable_intr */
 #define HV_DISPATCH_DISABLE_INTR                  50
 
+/** hv_raise_intr */
+#define HV_DISPATCH_RAISE_INTR                    51
+
 /** hv_trigger_ipi */
-#define HV_DISPATCH_TRIGGER_IPI                   51
+#define HV_DISPATCH_TRIGGER_IPI                   52
+
+#endif /* !CHIP_HAS_IPI() */
 
 /** hv_store_mapping */
-#define HV_DISPATCH_STORE_MAPPING                 52
+#define HV_DISPATCH_STORE_MAPPING                 53
 
 /** hv_inquire_realpa */
-#define HV_DISPATCH_INQUIRE_REALPA                53
+#define HV_DISPATCH_INQUIRE_REALPA                54
 
 /** hv_flush_all */
-#define HV_DISPATCH_FLUSH_ALL                     54
+#define HV_DISPATCH_FLUSH_ALL                     55
+
+#if CHIP_HAS_IPI()
+/** hv_get_ipi_pte */
+#define HV_DISPATCH_GET_IPI_PTE                   56
+#endif
 
 /** One more than the largest dispatch value */
-#define _HV_DISPATCH_END                          55
+#define _HV_DISPATCH_END                          57
 
 
 #ifndef __ASSEMBLER__
@@ -484,21 +482,6 @@ typedef enum {
  */
 int hv_confstr(HV_ConfstrQuery query, HV_VirtAddr buf, int len);
 
-/** State object used to enable and disable one-shot and level-sensitive
- *  interrupts. */
-typedef struct
-{
-#if CHIP_VA_WIDTH() > 32
-  __hv64 opaque[2]; /**< No user-serviceable parts inside */
-#else
-  __hv32 opaque[2]; /**< No user-serviceable parts inside */
-#endif
-}
-HV_IntrState;
-
-/** A set of interrupts. */
-typedef __hv32 HV_IntrMask;
-
 /** Tile coordinate */
 typedef struct
 {
@@ -509,34 +492,51 @@ typedef struct
   int y;
 } HV_Coord;
 
+
+#if CHIP_HAS_IPI()
+
+/** Get the PTE for sending an IPI to a particular tile.
+ *
+ * @param tile Tile which will receive the IPI.
+ * @param pl Indicates which IPI registers: 0 = IPI_0, 1 = IPI_1.
+ * @param pte Filled with resulting PTE.
+ * @result Zero if no error, non-zero for invalid parameters.
+ */
+int hv_get_ipi_pte(HV_Coord tile, int pl, HV_PTE* pte);
+
+#else /* !CHIP_HAS_IPI() */
+
+/** A set of interrupts. */
+typedef __hv32 HV_IntrMask;
+
 /** The low interrupt numbers are reserved for use by the client in
  *  delivering IPIs.  Any interrupt numbers higher than this value are
  *  reserved for use by HV device drivers. */
 #define HV_MAX_IPI_INTERRUPT 7
 
-/** Register an interrupt state object.  This object is used to enable and
- *  disable one-shot and level-sensitive interrupts.  Once the state is
- *  registered, the client must not read or write the state object; doing
- *  so will cause undefined results.
+/** Enable a set of device interrupts.
  *
- * @param intr_state Pointer to interrupt state object.
- * @return HV_OK on success, or a hypervisor error code.
+ * @param enab_mask Bitmap of interrupts to enable.
  */
-HV_Errno hv_dev_register_intr_state(HV_IntrState* intr_state);
+void hv_enable_intr(HV_IntrMask enab_mask);
 
-/** Enable a set of one-shot and level-sensitive interrupts.
+/** Disable a set of device interrupts.
  *
- * @param intr_state Pointer to interrupt state object.
- * @param enab_mask Bitmap of interrupts to enable.
+ * @param disab_mask Bitmap of interrupts to disable.
  */
-void hv_enable_intr(HV_IntrState* intr_state, HV_IntrMask enab_mask);
+void hv_disable_intr(HV_IntrMask disab_mask);
 
-/** Disable a set of one-shot and level-sensitive interrupts.
+/** Clear a set of device interrupts.
  *
- * @param intr_state Pointer to interrupt state object.
- * @param disab_mask Bitmap of interrupts to disable.
+ * @param clear_mask Bitmap of interrupts to clear.
  */
-void hv_disable_intr(HV_IntrState* intr_state, HV_IntrMask disab_mask);
+void hv_clear_intr(HV_IntrMask clear_mask);
+
+/** Assert a set of device interrupts.
+ *
+ * @param assert_mask Bitmap of interrupts to clear.
+ */
+void hv_assert_intr(HV_IntrMask assert_mask);
 
 /** Trigger a one-shot interrupt on some tile
  *
@@ -547,6 +547,8 @@ void hv_disable_intr(HV_IntrState* intr_state, HV_IntrMask disab_mask);
  */
 HV_Errno hv_trigger_ipi(HV_Coord tile, int interrupt);
 
+#endif // !CHIP_HAS_IPI()
+
 /** Store memory mapping in debug memory so that external debugger can read it.
  * A maximum of 16 entries can be stored.
  *
@@ -1010,6 +1012,13 @@ int hv_console_write(HV_VirtAddr bytes, int len);
  *  it will return to the code which was interrupted by the INTCTRL_1
  *  interrupt.
  *
+ *  Under some circumstances, the firing of INTCTRL_1 can race with
+ *  the lowering of a device interrupt.  In such a case, the
+ *  hv_downcall_dispatch service may issue an iret instruction instead
+ *  of entering one of the client's actual downcall-handling interrupt
+ *  vectors.  This will return execution to the location that was
+ *  interrupted by INTCTRL_1.
+ *
  *  Any saving of registers should be done by the actual handling
  *  vectors; no registers should be changed by the INTCTRL_1 handler.
  *  In particular, the client should not use a jal instruction to invoke
diff --git a/arch/tile/include/hv/pagesize.h b/arch/tile/include/hv/pagesize.h
new file mode 100644
index 0000000..58bed11
--- /dev/null
+++ b/arch/tile/include/hv/pagesize.h
@@ -0,0 +1,32 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+/**
+ * @file pagesize.h
+ */
+
+#ifndef _HV_PAGESIZE_H
+#define _HV_PAGESIZE_H
+
+/** The log2 of the size of small pages, in bytes. This value should
+ * be verified at runtime by calling hv_sysconf(HV_SYSCONF_PAGE_SIZE_SMALL).
+ */
+#define HV_LOG2_PAGE_SIZE_SMALL 16
+
+/** The log2 of the size of large pages, in bytes. This value should be
+ * verified at runtime by calling hv_sysconf(HV_SYSCONF_PAGE_SIZE_LARGE).
+ */
+#define HV_LOG2_PAGE_SIZE_LARGE 24
+
+#endif /* _HV_PAGESIZE_H */
diff --git a/arch/tile/kernel/hvglue.lds b/arch/tile/kernel/hvglue.lds
index 698489b..2b7cd0a 100644
--- a/arch/tile/kernel/hvglue.lds
+++ b/arch/tile/kernel/hvglue.lds
@@ -46,11 +46,13 @@ hv_inquire_tiles = TEXT_OFFSET + 0x10580;
 hv_confstr = TEXT_OFFSET + 0x105a0;
 hv_reexec = TEXT_OFFSET + 0x105c0;
 hv_set_command_line = TEXT_OFFSET + 0x105e0;
-hv_dev_register_intr_state = TEXT_OFFSET + 0x10600;
+hv_clear_intr = TEXT_OFFSET + 0x10600;
 hv_enable_intr = TEXT_OFFSET + 0x10620;
 hv_disable_intr = TEXT_OFFSET + 0x10640;
-hv_trigger_ipi = TEXT_OFFSET + 0x10660;
-hv_store_mapping = TEXT_OFFSET + 0x10680;
-hv_inquire_realpa = TEXT_OFFSET + 0x106a0;
-hv_flush_all = TEXT_OFFSET + 0x106c0;
-hv_glue_internals = TEXT_OFFSET + 0x106e0;
+hv_raise_intr = TEXT_OFFSET + 0x10660;
+hv_trigger_ipi = TEXT_OFFSET + 0x10680;
+hv_store_mapping = TEXT_OFFSET + 0x106a0;
+hv_inquire_realpa = TEXT_OFFSET + 0x106c0;
+hv_flush_all = TEXT_OFFSET + 0x106e0;
+hv_get_ipi_pte = TEXT_OFFSET + 0x10700;
+hv_glue_internals = TEXT_OFFSET + 0x10720;
diff --git a/arch/tile/kernel/irq.c b/arch/tile/kernel/irq.c
index 24cc6b2..596c600 100644
--- a/arch/tile/kernel/irq.c
+++ b/arch/tile/kernel/irq.c
@@ -19,6 +19,11 @@
 #include <linux/kernel_stat.h>
 #include <linux/uaccess.h>
 #include <hv/drv_pcie_rc_intf.h>
+#include <arch/spr_def.h>
+#include <asm/traps.h>
+
+/* Bit-flag stored in irq_desc->chip_data to indicate HW-cleared irqs. */
+#define IS_HW_CLEARED 1
 
 /*
  * The set of interrupts we enable for raw_local_irq_enable().
@@ -31,30 +36,74 @@ DEFINE_PER_CPU(unsigned long long, interrupts_enabled_mask) =
   INITIAL_INTERRUPTS_ENABLED;
 EXPORT_PER_CPU_SYMBOL(interrupts_enabled_mask);
 
-/* Define per-tile device interrupt state */
-DEFINE_PER_CPU(HV_IntrState, dev_intr_state);
-
+/* Define per-tile device interrupt statistics state. */
 DEFINE_PER_CPU(irq_cpustat_t, irq_stat) ____cacheline_internodealigned_in_smp;
 EXPORT_PER_CPU_SYMBOL(irq_stat);
 
+/*
+ * Define per-tile irq disable mask; the hardware/HV only has a single
+ * mask that we use to implement both masking and disabling.
+ */
+static DEFINE_PER_CPU(unsigned long, irq_disable_mask)
+	____cacheline_internodealigned_in_smp;
+
+/*
+ * Per-tile IRQ nesting depth.  Used to make sure we enable newly
+ * enabled IRQs before exiting the outermost interrupt.
+ */
+static DEFINE_PER_CPU(int, irq_depth);
+
+/* State for allocating IRQs on Gx. */
+#if CHIP_HAS_IPI()
+static unsigned long available_irqs = ~(1UL << IRQ_RESCHEDULE);
+static DEFINE_SPINLOCK(available_irqs_lock);
+#endif
 
+#if CHIP_HAS_IPI()
+/* Use SPRs to manipulate device interrupts. */
+#define mask_irqs(irq_mask) __insn_mtspr(SPR_IPI_MASK_SET_1, irq_mask)
+#define unmask_irqs(irq_mask) __insn_mtspr(SPR_IPI_MASK_RESET_1, irq_mask)
+#define clear_irqs(irq_mask) __insn_mtspr(SPR_IPI_EVENT_RESET_1, irq_mask)
+#else
+/* Use HV to manipulate device interrupts. */
+#define mask_irqs(irq_mask) hv_disable_intr(irq_mask)
+#define unmask_irqs(irq_mask) hv_enable_intr(irq_mask)
+#define clear_irqs(irq_mask) hv_clear_intr(irq_mask)
+#endif
 
 /*
- * Interrupt dispatcher, invoked upon a hypervisor device interrupt downcall
+ * The interrupt handling path, implemented in terms of HV interrupt
+ * emulation on TILE64 and TILEPro, and IPI hardware on TILE-Gx.
  */
 void tile_dev_intr(struct pt_regs *regs, int intnum)
 {
-	int irq;
+	int depth = __get_cpu_var(irq_depth)++;
+	unsigned long original_irqs;
+	unsigned long remaining_irqs;
+	struct pt_regs *old_regs;
 
+#if CHIP_HAS_IPI()
 	/*
-	 * Get the device interrupt pending mask from where the hypervisor
-	 * has tucked it away for us.
+	 * Pending interrupts are listed in an SPR.  We might be
+	 * nested, so be sure to only handle irqs that weren't already
+	 * masked by a previous interrupt.  Then, mask out the ones
+	 * we're going to handle.
 	 */
-	unsigned long pending_dev_intr_mask = __insn_mfspr(SPR_SYSTEM_SAVE_1_3);
-
+	unsigned long masked = __insn_mfspr(SPR_IPI_MASK_1);
+	original_irqs = __insn_mfspr(SPR_IPI_EVENT_1) & ~masked;
+	__insn_mtspr(SPR_IPI_MASK_SET_1, original_irqs);
+#else
+	/*
+	 * Hypervisor performs the equivalent of the Gx code above and
+	 * then puts the pending interrupt mask into a system save reg
+	 * for us to find.
+	 */
+	original_irqs = __insn_mfspr(SPR_SYSTEM_SAVE_1_3);
+#endif
+	remaining_irqs = original_irqs;
 
 	/* Track time spent here in an interrupt context. */
-	struct pt_regs *old_regs = set_irq_regs(regs);
+	old_regs = set_irq_regs(regs);
 	irq_enter();
 
 #ifdef CONFIG_DEBUG_STACKOVERFLOW
@@ -62,26 +111,35 @@ void tile_dev_intr(struct pt_regs *regs, int intnum)
 	{
 		long sp = stack_pointer - (long) current_thread_info();
 		if (unlikely(sp < (sizeof(struct thread_info) + STACK_WARN))) {
-			printk(KERN_EMERG "tile_dev_intr: "
+			pr_emerg("tile_dev_intr: "
 			       "stack overflow: %ld\n",
 			       sp - sizeof(struct thread_info));
 			dump_stack();
 		}
 	}
 #endif
+	while (remaining_irqs) {
+		unsigned long irq = __ffs(remaining_irqs);
+		remaining_irqs &= ~(1UL << irq);
 
-	for (irq = 0; pending_dev_intr_mask; ++irq) {
-		if (pending_dev_intr_mask & 0x1) {
-			generic_handle_irq(irq);
+		/* Count device irqs; Linux IPIs are counted elsewhere. */
+		if (irq != IRQ_RESCHEDULE)
+			__get_cpu_var(irq_stat).irq_dev_intr_count++;
 
-			/* Count device irqs; IPIs are counted elsewhere. */
-			if (irq > HV_MAX_IPI_INTERRUPT)
-				__get_cpu_var(irq_stat).irq_dev_intr_count++;
-		}
-		pending_dev_intr_mask >>= 1;
+		generic_handle_irq(irq);
 	}
 
 	/*
+	 * If we weren't nested, turn on all enabled interrupts,
+	 * including any that were reenabled during interrupt
+	 * handling.
+	 */
+	if (depth == 0)
+		unmask_irqs(~__get_cpu_var(irq_disable_mask));
+
+	__get_cpu_var(irq_depth)--;
+
+	/*
 	 * Track time spent against the current process again and
 	 * process any softirqs if they are waiting.
 	 */
@@ -90,97 +148,114 @@ void tile_dev_intr(struct pt_regs *regs, int intnum)
 }
 
 
+/*
+ * Remove an irq from the disabled mask.  If we're in an interrupt
+ * context, defer enabling the HW interrupt until we leave.
+ */
+void enable_percpu_irq(unsigned int irq)
+{
+	get_cpu_var(irq_disable_mask) &= ~(1UL << irq);
+	if (__get_cpu_var(irq_depth) == 0)
+		unmask_irqs(1UL << irq);
+	put_cpu_var(irq_disable_mask);
+}
+EXPORT_SYMBOL(enable_percpu_irq);
+
+/*
+ * Add an irq to the disabled mask.  We disable the HW interrupt
+ * immediately so that there's no possibility of it firing.  If we're
+ * in an interrupt context, the return path is careful to avoid
+ * unmasking a newly disabled interrupt.
+ */
+void disable_percpu_irq(unsigned int irq)
+{
+	get_cpu_var(irq_disable_mask) |= (1UL << irq);
+	mask_irqs(1UL << irq);
+	put_cpu_var(irq_disable_mask);
+}
+EXPORT_SYMBOL(disable_percpu_irq);
+
 /* Mask an interrupt. */
-static void hv_dev_irq_mask(unsigned int irq)
+static void tile_irq_chip_mask(unsigned int irq)
 {
-	HV_IntrState *p_intr_state = &__get_cpu_var(dev_intr_state);
-	hv_disable_intr(p_intr_state, 1 << irq);
+	mask_irqs(1UL << irq);
 }
 
 /* Unmask an interrupt. */
-static void hv_dev_irq_unmask(unsigned int irq)
+static void tile_irq_chip_unmask(unsigned int irq)
 {
-	/* Re-enable the hypervisor to generate interrupts. */
-	HV_IntrState *p_intr_state = &__get_cpu_var(dev_intr_state);
-	hv_enable_intr(p_intr_state, 1 << irq);
+	unmask_irqs(1UL << irq);
 }
 
 /*
- * The HV doesn't latch incoming interrupts while an interrupt is
- * disabled, so we need to reenable interrupts before running the
- * handler.
- *
- * ISSUE: Enabling the interrupt this early avoids any race conditions
- * but introduces the possibility of nested interrupt stack overflow.
- * An imminent change to the HV IRQ model will fix this.
+ * Clear an interrupt before processing it so that any new assertions
+ * will trigger another irq.
  */
-static void hv_dev_irq_ack(unsigned int irq)
+static void tile_irq_chip_ack(unsigned int irq)
 {
-	hv_dev_irq_unmask(irq);
+	if ((unsigned long)get_irq_chip_data(irq) != IS_HW_CLEARED)
+		clear_irqs(1UL << irq);
 }
 
 /*
- * Since ack() reenables interrupts, there's nothing to do at eoi().
+ * For per-cpu interrupts, we need to avoid unmasking any interrupts
+ * that we disabled via disable_percpu_irq().
  */
-static void hv_dev_irq_eoi(unsigned int irq)
+static void tile_irq_chip_eoi(unsigned int irq)
 {
+	if (!(__get_cpu_var(irq_disable_mask) & (1UL << irq)))
+		unmask_irqs(1UL << irq);
 }
 
-static struct irq_chip hv_dev_irq_chip = {
-	.typename = "hv_dev_irq_chip",
-	.ack = hv_dev_irq_ack,
-	.mask = hv_dev_irq_mask,
-	.unmask = hv_dev_irq_unmask,
-	.eoi = hv_dev_irq_eoi,
-};
-
-static struct irqaction resched_action = {
-	.handler = handle_reschedule_ipi,
-	.name = "resched",
-	.dev_id = handle_reschedule_ipi /* unique token */,
+static struct irq_chip tile_irq_chip = {
+	.typename = "tile_irq_chip",
+	.ack = tile_irq_chip_ack,
+	.eoi = tile_irq_chip_eoi,
+	.mask = tile_irq_chip_mask,
+	.unmask = tile_irq_chip_unmask,
 };
 
 void __init init_IRQ(void)
 {
-	/* Bind IPI irqs. Does this belong somewhere else in init? */
-	tile_irq_activate(IRQ_RESCHEDULE);
-	BUG_ON(setup_irq(IRQ_RESCHEDULE, &resched_action));
+	ipi_init();
 }
 
-void __cpuinit init_per_tile_IRQs(void)
+void __cpuinit setup_irq_regs(void)
 {
-	int rc;
-
-	/* Set the pointer to the per-tile device interrupt state. */
-	HV_IntrState *sv_ptr = &__get_cpu_var(dev_intr_state);
-	rc = hv_dev_register_intr_state(sv_ptr);
-	if (rc != HV_OK)
-		panic("hv_dev_register_intr_state: error %d", rc);
-
+	/* Enable interrupt delivery. */
+	unmask_irqs(~0UL);
+#if CHIP_HAS_IPI()
+	raw_local_irq_unmask(INT_IPI_1);
+#endif
 }
 
-void tile_irq_activate(unsigned int irq)
+void tile_irq_activate(unsigned int irq, int tile_irq_type)
 {
 	/*
-	 * Paravirtualized drivers can call up to the HV to find out
-	 * which irq they're associated with.  The HV interface
-	 * doesn't provide a generic call for discovering all valid
-	 * IRQs, so drivers must call this method to initialize newly
-	 * discovered IRQs.
-	 *
-	 * We could also just initialize all 32 IRQs at startup, but
-	 * doing so would lead to a kernel fault if an unexpected
-	 * interrupt fires and jumps to a NULL action.  By defering
-	 * the set_irq_chip_and_handler() call, unexpected IRQs are
-	 * handled properly by handle_bad_irq().
+	 * We use handle_level_irq() by default because the pending
+	 * interrupt vector (whether modeled by the HV on TILE64 and
+	 * TILEPro or implemented in hardware on TILE-Gx) has
+	 * level-style semantics for each bit.  An interrupt fires
+	 * whenever a bit is high, not just at edges.
+	 */
+	irq_flow_handler_t handle = handle_level_irq;
+	if (tile_irq_type == TILE_IRQ_PERCPU)
+		handle = handle_percpu_irq;
+	set_irq_chip_and_handler(irq, &tile_irq_chip, handle);
+
+	/*
+	 * Flag interrupts that are hardware-cleared so that ack()
+	 * won't clear them.
 	 */
-	hv_dev_irq_mask(irq);
-	set_irq_chip_and_handler(irq, &hv_dev_irq_chip, handle_percpu_irq);
+	if (tile_irq_type == TILE_IRQ_HW_CLEAR)
+		set_irq_chip_data(irq, (void *)IS_HW_CLEARED);
 }
+EXPORT_SYMBOL(tile_irq_activate);
+
 
 void ack_bad_irq(unsigned int irq)
 {
-	printk(KERN_ERR "unexpected IRQ trap at vector %02x\n", irq);
+	pr_err("unexpected IRQ trap at vector %02x\n", irq);
 }
 
 /*
@@ -225,3 +300,35 @@ skip:
 	}
 	return 0;
 }
+
+#if CHIP_HAS_IPI()
+int create_irq(void)
+{
+	unsigned long flags;
+	int result;
+
+	spin_lock_irqsave(&available_irqs_lock, flags);
+	if (available_irqs == 0)
+		result = -ENOMEM;
+	else {
+		result = __ffs(available_irqs);
+		available_irqs &= ~(1UL << result);
+		dynamic_irq_init(result);
+	}
+	spin_unlock_irqrestore(&available_irqs_lock, flags);
+
+	return result;
+}
+EXPORT_SYMBOL(create_irq);
+
+void destroy_irq(unsigned int irq)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&available_irqs_lock, flags);
+	available_irqs |= (1UL << irq);
+	dynamic_irq_cleanup(irq);
+	spin_unlock_irqrestore(&available_irqs_lock, flags);
+}
+EXPORT_SYMBOL(destroy_irq);
+#endif
diff --git a/arch/tile/kernel/smp.c b/arch/tile/kernel/smp.c
index 782c1bf..1cb5ec7 100644
--- a/arch/tile/kernel/smp.c
+++ b/arch/tile/kernel/smp.c
@@ -15,10 +15,18 @@
  */
 
 #include <linux/smp.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
 #include <linux/irq.h>
+#include <linux/module.h>
 #include <asm/cacheflush.h>
 
 HV_Topology smp_topology __write_once;
+EXPORT_SYMBOL(smp_topology);
+
+#if CHIP_HAS_IPI()
+static unsigned long __iomem *ipi_mappings[NR_CPUS];
+#endif
 
 
 /*
@@ -100,7 +108,6 @@ void on_each_cpu_mask(const struct cpumask *mask, void (*func)(void *),
 /* Handler to start the current cpu. */
 static void smp_start_cpu_interrupt(void)
 {
-	extern unsigned long start_cpu_function_addr;
 	get_irq_regs()->pc = start_cpu_function_addr;
 }
 
@@ -174,12 +181,8 @@ void flush_icache_range(unsigned long start, unsigned long end)
 }
 
 
-/*
- * The smp_send_reschedule() path does not use the hv_message_intr()
- * path but instead the faster tile_dev_intr() path for interrupts.
- */
-
-irqreturn_t handle_reschedule_ipi(int irq, void *token)
+/* Called when smp_send_reschedule() triggers IRQ_RESCHEDULE. */
+static irqreturn_t handle_reschedule_ipi(int irq, void *token)
 {
 	/*
 	 * Nothing to do here; when we return from interrupt, the
@@ -191,12 +194,63 @@ irqreturn_t handle_reschedule_ipi(int irq, void *token)
 	return IRQ_HANDLED;
 }
 
+static struct irqaction resched_action = {
+	.handler = handle_reschedule_ipi,
+	.name = "resched",
+	.dev_id = handle_reschedule_ipi /* unique token */,
+};
+
+void __init ipi_init(void)
+{
+#if CHIP_HAS_IPI()
+	int cpu;
+	/* Map IPI trigger MMIO addresses. */
+	for_each_possible_cpu(cpu) {
+		HV_Coord tile;
+		HV_PTE pte;
+		unsigned long offset;
+
+		tile.x = cpu_x(cpu);
+		tile.y = cpu_y(cpu);
+		if (hv_get_ipi_pte(tile, 1, &pte) != 0)
+			panic("Failed to initialize IPI for cpu %d\n", cpu);
+
+		offset = hv_pte_get_pfn(pte) << PAGE_SHIFT;
+		ipi_mappings[cpu] = ioremap_prot(offset, PAGE_SIZE, pte);
+	}
+#endif
+
+	/* Bind handle_reschedule_ipi() to IRQ_RESCHEDULE. */
+	tile_irq_activate(IRQ_RESCHEDULE, TILE_IRQ_PERCPU);
+	BUG_ON(setup_irq(IRQ_RESCHEDULE, &resched_action));
+}
+
+#if CHIP_HAS_IPI()
+
+void smp_send_reschedule(int cpu)
+{
+	WARN_ON(cpu_is_offline(cpu));
+
+	/*
+	 * We just want to do an MMIO store.  The traditional writeq()
+	 * functions aren't really correct here, since they're always
+	 * directed at the PCI shim.  For now, just do a raw store,
+	 * casting away the __iomem attribute.
+	 */
+	((unsigned long __force *)ipi_mappings[cpu])[IRQ_RESCHEDULE] = 0;
+}
+
+#else
+
 void smp_send_reschedule(int cpu)
 {
 	HV_Coord coord;
 
 	WARN_ON(cpu_is_offline(cpu));
-	coord.y = cpu / smp_width;
-	coord.x = cpu % smp_width;
+
+	coord.y = cpu_y(cpu);
+	coord.x = cpu_x(cpu);
 	hv_trigger_ipi(coord, IRQ_RESCHEDULE);
 }
+
+#endif /* CHIP_HAS_IPI() */
-- 
1.6.5.2

