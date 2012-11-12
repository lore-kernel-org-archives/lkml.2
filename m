Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab2KLLu3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 06:50:29 -0500
Received: from hermes.synopsys.com ([198.182.44.81]:57539 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618Ab2KLLuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 06:50:21 -0500
From: <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tglx@linutronix.de>, <arnd@arndb.de>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [RFC Patch v1 36/55] ARC: ARCompact 2 levels IRQ (high/low priority) Handling
Date: Mon, 12 Nov 2012 17:18:54 +0530
Message-ID: <1352720953-24321-6-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1352720953-24321-1-git-send-email-vgupta@synopsys.com>
References: <1352720953-24321-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vineet Gupta <vgupta@synopsys.com>

There is a bit of hack/kludge right now where we disable preemption if a
L2 (High prio) IRQ is taken while L1 (Low prio) is active.

Need to revisit this

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/Kconfig                |   17 ++++++
 arch/arc/include/asm/entry.h    |   95 +++++++++++++++++++++++++++++++
 arch/arc/include/asm/irqflags.h |    6 ++-
 arch/arc/kernel/entry.S         |  117 +++++++++++++++++++++++++++++++++++++++
 arch/arc/kernel/irq.c           |  104 ++++++++++++++++++++++++++++++++++
 arch/arc/plat-arcfpga/Kconfig   |   13 ++++
 6 files changed, 351 insertions(+), 1 deletions(-)

diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index 4557c8d..e096545 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -210,6 +210,23 @@ config ARC_PAGE_SIZE_4K
 
 endchoice
 
+config ARC_COMPACT_IRQ_LEVELS
+	bool "ARCompact IRQ Priorities: High(2)/Low(1)"
+	default n
+
+if ARC_COMPACT_IRQ_LEVELS
+
+config ARC_IRQ3_LV2
+	bool
+
+config ARC_IRQ5_LV2
+	bool
+
+config ARC_IRQ6_LV2
+	bool
+
+endif
+
 config ARC_FPU_SAVE_RESTORE
 	bool "Enable FPU state persistence across context switch"
 	default n
diff --git a/arch/arc/include/asm/entry.h b/arch/arc/include/asm/entry.h
index 6113e1a..43dbf6f 100644
--- a/arch/arc/include/asm/entry.h
+++ b/arch/arc/include/asm/entry.h
@@ -5,6 +5,12 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  *
+ * Vineetg: March 2009 (Supporting 2 levels of Interrupts)
+ *  Stack switching code can no longer reliably rely on the fact that
+ *  if we are NOT in user mode, stack is switched to kernel mode.
+ *  e.g. L2 IRQ interrupted a L1 ISR which had not yet completed
+ *  it's prologue including stack switching from user mode
+ *
  * Vineetg: Aug 28th 2008: Bug #94984
  *  -Zero Overhead Loop Context shd be cleared when entering IRQ/EXcp/Trap
  *   Normally CPU does this automatically, however when doing FAKE rtie,
@@ -233,6 +239,33 @@
 	 * assume SP is kernel mode SP. _NO_ need to do any stack switching
 	 */
 
+#ifdef CONFIG_ARC_COMPACT_IRQ_LEVELS
+	/* However....
+	 * If Level 2 Interrupts enabled, we may end up with a corner case:
+	 * 1. User Task executing
+	 * 2. L1 IRQ taken, ISR starts (CPU auto-switched to KERNEL mode)
+	 * 3. But before it could switch SP from USER to KERNEL stack
+	 *      a L2 IRQ "Interrupts" L1
+	 * Thay way although L2 IRQ happened in Kernel mode, stack is still
+	 * not switched.
+	 * To handle this, we may need to switch stack even if in kernel mode
+	 * provided SP has values in range of USER mode stack ( < 0x7000_0000 )
+	 */
+	brlo sp, VMALLOC_START, 88f
+
+	/* TODO: vineetg:
+	 * We need to be a bit more cautious here. What if a kernel bug in
+	 * L1 ISR, caused SP to go whaco (some small value which looks like
+	 * USER stk) and then we take L2 ISR.
+	 * Above brlo alone would treat it as a valid L1-L2 sceanrio
+	 * instead of shouting alound
+	 * The only feasible way is to make sure this L2 happened in
+	 * L1 prelogue ONLY i.e. ilink2 is less than a pre-set marker in
+	 * L1 ISR before it switches stack
+	 */
+
+#endif
+
 	/* Save Pre Intr/Exception KERNEL MODE SP on kernel stack
 	 * safe-keeping not really needed, but it keeps the epilogue code
 	 * (SP restore) simpler/uniform.
@@ -463,6 +496,42 @@
 	sub sp, sp, 4
 .endm
 
+.macro SAVE_ALL_INT2
+
+	/* TODO-vineetg: SMP we can't use global nor can we use
+	*   SCRATCH0 as we do for int1 because while int1 is using
+	*   it, int2 can come
+	*/
+	/* retsore original r9 , saved in sys_saved_r9 */
+	ld  r9, [@int2_saved_reg]
+
+	/* now we are ready to save the remaining context :) */
+	st     -2, [sp, 8]    /* orig_r8, -2 for interrupt level 2 */
+	st      0, [sp, 4]    /* orig_r0 , N/A for IRQ */
+	SAVE_CALLER_SAVED
+	st.a    r26, [sp, -4]   /* gp */
+	st.a    fp, [sp, -4]
+	st.a    blink, [sp, -4]
+	st.a    ilink2, [sp, -4]
+	lr	r9, [status32_l2]
+	st.a    r9, [sp, -4]
+	st.a    lp_count, [sp, -4]
+	lr	r9, [lp_end]
+	st.a    r9, [sp, -4]
+	lr	r9, [lp_start]
+	st.a    r9, [sp, -4]
+	lr	r9, [bta_l2]
+	st.a    r9, [sp, -4]
+
+#ifdef PT_REGS_CANARY
+	mov   r9, 0xdeadbee2
+	st    r9, [sp, -4]
+#endif
+
+	/* move up by 1 word to "create" pt_regs->"stack_place_holder" */
+	sub sp, sp, 4
+.endm
+
 /*--------------------------------------------------------------
  * Restore all registers used by interrupt handlers.
  *
@@ -497,6 +566,32 @@
 	/* orig_r0 and orig_r8 skipped automatically */
 .endm
 
+.macro RESTORE_ALL_INT2
+	add sp, sp, 4       /* hop over unused "pt_regs->stack_place_holder" */
+
+	ld.ab   r9, [sp, 4]
+	sr	r9, [bta_l2]
+	ld.ab   r9, [sp, 4]
+	sr	r9, [lp_start]
+	ld.ab   r9, [sp, 4]
+	sr	r9, [lp_end]
+	ld.ab   r9, [sp, 4]
+	mov	lp_count, r9
+	ld.ab   r9, [sp, 4]
+	sr	r9, [status32_l2]
+	ld.ab   r9, [sp, 4]
+	mov	ilink2, r9
+	ld.ab   blink, [sp, 4]
+	ld.ab   fp, [sp, 4]
+	ld.ab   r26, [sp, 4]    /* gp */
+	RESTORE_CALLER_SAVED
+
+	ld  sp, [sp] /* restore original sp */
+	/* orig_r0 and orig_r8 skipped automatically */
+
+.endm
+
+
 /* Get CPU-ID of this core */
 .macro  GET_CPU_ID  reg
 	lr  \reg, [identity]
diff --git a/arch/arc/include/asm/irqflags.h b/arch/arc/include/asm/irqflags.h
index 752e55d..cc8312d 100644
--- a/arch/arc/include/asm/irqflags.h
+++ b/arch/arc/include/asm/irqflags.h
@@ -95,7 +95,11 @@ static inline long arch_local_save_flags(void)
  */
 static inline int arch_irqs_disabled_flags(unsigned long flags)
 {
-	return !(flags & (STATUS_E1_MASK));
+	return !(flags & (STATUS_E1_MASK
+#ifdef CONFIG_ARC_COMPACT_IRQ_LEVELS
+			| STATUS_E2_MASK
+#endif
+		));
 }
 
 static inline int arch_irqs_disabled(void)
diff --git a/arch/arc/kernel/entry.S b/arch/arc/kernel/entry.S
index 93cde5e..13a0052 100644
--- a/arch/arc/kernel/entry.S
+++ b/arch/arc/kernel/entry.S
@@ -36,6 +36,8 @@
  *   exception. Thus FAKE RTIE needed in low level Priv-Violation handler.
  *   Instr Error could also cause similar scenario, so same there as well.
  *
+ * Vineetg: March 2009 (Supporting 2 levels of Interrupts)
+ *
  * Vineetg: Aug 28th 2008: Bug #94984
  *  -Zero Overhead Loop Context shd be cleared when entering IRQ/EXcp/Trap
  *   Normally CPU does this automatically, however when doing FAKE rtie,
@@ -101,13 +103,25 @@ VECTOR   mem_service             ; 0x8, Mem exception   (0x1)
 VECTOR   instr_service           ; 0x10, Instrn Error   (0x2)
 
 ; ******************** Device ISRs **********************
+#ifdef CONFIG_ARC_IRQ3_LV2
+VECTOR   handle_interrupt_level2
+#else
 VECTOR   handle_interrupt_level1
+#endif
 
 VECTOR   handle_interrupt_level1
 
+#ifdef CONFIG_ARC_IRQ5_LV2
+VECTOR   handle_interrupt_level2
+#else
 VECTOR   handle_interrupt_level1
+#endif
 
+#ifdef CONFIG_ARC_IRQ6_LV2
+VECTOR   handle_interrupt_level2
+#else
 VECTOR   handle_interrupt_level1
+#endif
 
 .rept   25
 VECTOR   handle_interrupt_level1 ; Other devices
@@ -144,6 +158,17 @@ VECTOR   reserved                ; Reserved Exceptions
 int1_saved_reg:
 	.zero 4
 
+/* Each Interrupt level needs it's own scratch */
+#ifdef CONFIG_ARC_COMPACT_IRQ_LEVELS
+
+	.section .data		; NOT .global
+	.type   int2_saved_reg, @object
+	.size   int2_saved_reg, 4
+int2_saved_reg:
+	.zero 4
+
+#endif
+
 ; ---------------------------------------------
 	.section .text, "ax",@progbits
 
@@ -157,6 +182,55 @@ reserved:		; processor restart
 
 ;##################### Interrupt Handling ##############################
 
+#ifdef CONFIG_ARC_COMPACT_IRQ_LEVELS
+; ---------------------------------------------
+;  Level 2 ISR: Can interrupt a Level 1 ISR
+; ---------------------------------------------
+ARC_ENTRY handle_interrupt_level2
+
+	; TODO-vineetg for SMP this wont work
+	; free up r9 as scratchpad
+	st  r9, [@int2_saved_reg]
+
+	;Which mode (user/kernel) was the system in when intr occured
+	lr  r9, [status32_l2]
+
+	SWITCH_TO_KERNEL_STK
+	SAVE_ALL_INT2
+
+	;------------------------------------------------------
+	; if L2 IRQ interrupted a L1 ISR, disable preemption
+	;------------------------------------------------------
+
+	ld r9, [sp, PT_status32]        ; get statu32_l2 (saved in pt_regs)
+	bbit0 r9, STATUS_A1_BIT, 1f     ; L1 not active when L2 IRQ, so normal
+
+	; A1 is set in status32_l2
+	; bump thread_info->preempt_count (Disable preemption)
+	GET_CURR_THR_INFO_FROM_SP   r10
+	ld      r9, [r10, THREAD_INFO_PREEMPT_COUNT]
+	add     r9, r9, 1
+	st      r9, [r10, THREAD_INFO_PREEMPT_COUNT]
+
+1:
+	;------------------------------------------------------
+	; setup params for Linux common ISR and invoke it
+	;------------------------------------------------------
+	lr  r0, [icause2]
+	and r0, r0, 0x1f
+
+	bl.d  @arch_do_IRQ
+	mov r1, sp
+
+	mov r8,0x2
+	sr r8, [AUX_IRQ_LV12]       ; clear bit in Sticky Status Reg
+
+	b   ret_from_exception
+
+ARC_EXIT handle_interrupt_level2
+
+#endif
+
 ; ---------------------------------------------
 ;  Level 1 ISR
 ; ---------------------------------------------
@@ -625,6 +699,49 @@ restore_regs :
 
 not_exception:
 
+#ifdef CONFIG_ARC_COMPACT_IRQ_LEVELS
+
+	bbit0  r10, STATUS_A2_BIT, not_level2_interrupt
+
+	;------------------------------------------------------------------
+	; if L2 IRQ interrupted a L1 ISR,  we'd disbaled preemption earlier
+	; so that sched doesnt move to new task, causing L1 to be delayed
+	; undeterministically. Now that we've achieved that, lets reset
+	; things to what they were, before returning from L2 context
+	;----------------------------------------------------------------
+
+	ld r9, [sp, PT_orig_r8]        ; get orig_r8 to make sure it is
+	brne r9, -2, 149f              ; infact a L2 ISR ret path
+
+	ld r9, [sp, PT_status32]        ; get statu32_l2 (saved in pt_regs)
+	bbit0 r9, STATUS_A1_BIT, 149f     ; L1 not active when L2 IRQ, so normal
+
+	; A1 is set in status32_l2
+	; decrement thread_info->preempt_count (re-enable preemption)
+	GET_CURR_THR_INFO_FROM_SP   r10
+	ld      r9, [r10, THREAD_INFO_PREEMPT_COUNT]
+
+	; paranoid check, given A1 was active when A2 happened, preempt count
+	; must not be 0 beccause we would have incremented it.
+	; If this does happen we simply HALT as it means a BUG !!!
+	cmp     r9, 0
+	bnz     2f
+	flag 1
+
+2:
+	sub     r9, r9, 1
+	st      r9, [r10, THREAD_INFO_PREEMPT_COUNT]
+
+149:
+	;return from level 2
+	RESTORE_ALL_INT2
+debug_marker_l2:
+	rtie
+
+not_level2_interrupt:
+
+#endif
+
 	bbit0  r10, STATUS_A1_BIT, not_level1_interrupt
 
 	;return from level 1
diff --git a/arch/arc/kernel/irq.c b/arch/arc/kernel/irq.c
index 03a125c..afde5a7 100644
--- a/arch/arc/kernel/irq.c
+++ b/arch/arc/kernel/irq.c
@@ -21,6 +21,7 @@
  * what it does ?
  * -setup Vector Table Base Reg - in case Linux not linked at 0x8000_0000
  * -Disable all IRQs (on CPU side)
+ * -Optionally, setup the High priority Interrupts as Level 2 IRQs
  */
 void __init arc_init_IRQ(void)
 {
@@ -30,6 +31,24 @@ void __init arc_init_IRQ(void)
 
 	/* Disable all IRQs: enable them as devices request */
 	write_aux_reg(AUX_IENABLE, 0);
+
+       /* setup any high priority Interrupts (Level2 in ARCompact jargon) */
+#ifdef CONFIG_ARC_COMPACT_IRQ_LEVELS
+#ifdef CONFIG_ARC_IRQ3_LV2
+	level_mask |= (1 << 3);
+#endif
+#ifdef CONFIG_ARC_IRQ5_LV2
+	level_mask |= (1 << 5);
+#endif
+#ifdef CONFIG_ARC_IRQ6_LV2
+	level_mask |= (1 << 6);
+#endif
+
+	if (level_mask) {
+		pr_info("Level-2 interrupts bitset %x\n", level_mask);
+		write_aux_reg(AUX_IRQ_LEV, level_mask);
+	}
+#endif
 }
 
 /*
@@ -87,6 +106,90 @@ int __init get_hw_config_num_irq(void)
 	return 0;
 }
 
+/*
+ * arch_local_irq_enable - Enable interrupts.
+ *
+ * 1. Explicitly called to re-enable interrupts
+ * 2. Implicitly called from spin_unlock_irq, write_unlock_irq etc
+ *    which maybe in hard ISR itself
+ *
+ * Semantics of this function change depending on where it is called from:
+ *
+ * -If called from hard-ISR, it must not invert interrupt priorities
+ *  e.g. suppose TIMER is high priority (Level 2) IRQ
+ *    Time hard-ISR, timer_interrupt( ) calls spin_unlock_irq several times.
+ *    Here local_irq_enable( ) shd not re-enable lower priority interrupts
+ * -If called from soft-ISR, it must re-enable all interrupts
+ *    soft ISR are low prioity jobs which can be very slow, thus all IRQs
+ *    must be enabled while they run.
+ *    Now hardware context wise we may still be in L2 ISR (not done rtie)
+ *    still we must re-enable both L1 and L2 IRQs
+ *  Another twist is prev scenario with flow being
+ *     L1 ISR ==> interrupted by L2 ISR  ==> L2 soft ISR
+ *     here we must not re-enable Ll as prev Ll Interrupt's h/w context will get
+ *     over-written (this is deficiency in ARC700 Interrupt mechanism)
+ */
+
+#ifdef CONFIG_ARC_COMPACT_IRQ_LEVELS	/* Complex version for 2 IRQ levels */
+
+void arch_local_irq_enable(void)
+{
+
+	unsigned long flags;
+	flags = arch_local_save_flags();
+
+	/* Allow both L1 and L2 at the onset */
+	flags |= (STATUS_E1_MASK | STATUS_E2_MASK);
+
+	/* Called from hard ISR (between irq_enter and irq_exit) */
+	if (in_irq()) {
+
+		/* If in L2 ISR, don't re-enable any further IRQs as this can
+		 * cause IRQ priorities to get upside down. e.g. it could allow
+		 * L1 be taken while in L2 hard ISR which is wrong not only in
+		 * theory, it can also cause the dreaded L1-L2-L1 scenario
+		 */
+		if (flags & STATUS_A2_MASK)
+			flags &= ~(STATUS_E1_MASK | STATUS_E2_MASK);
+
+		/* Even if in L1 ISR, allowe Higher prio L2 IRQs */
+		else if (flags & STATUS_A1_MASK)
+			flags &= ~(STATUS_E1_MASK);
+	}
+
+	/* called from soft IRQ, ideally we want to re-enable all levels */
+
+	else if (in_softirq()) {
+
+		/* However if this is case of L1 interrupted by L2,
+		 * re-enabling both may cause whaco L1-L2-L1 scenario
+		 * because ARC700 allows level 1 to interrupt an active L2 ISR
+		 * Thus we disable both
+		 * However some code, executing in soft ISR wants some IRQs
+		 * to be enabled so we re-enable L2 only
+		 *
+		 * How do we determine L1 intr by L2
+		 *  -A2 is set (means in L2 ISR)
+		 *  -E1 is set in this ISR's pt_regs->status32 which is
+		 *      saved copy of status32_l2 when l2 ISR happened
+		 */
+		struct pt_regs *pt = get_irq_regs();
+		if ((flags & STATUS_A2_MASK) && pt &&
+		    (pt->status32 & STATUS_A1_MASK)) {
+			/*flags &= ~(STATUS_E1_MASK | STATUS_E2_MASK); */
+			flags &= ~(STATUS_E1_MASK);
+		}
+	}
+
+	arch_local_irq_restore(flags);
+}
+
+#else /* ! CONFIG_ARC_COMPACT_IRQ_LEVELS */
+
+/*
+ * Simpler version for only 1 level of interrupt
+ * Here we only Worry about Level 1 Bits
+ */
 void arch_local_irq_enable(void)
 {
 
@@ -104,4 +207,5 @@ void arch_local_irq_enable(void)
 
 	arch_local_irq_restore(flags);
 }
+#endif
 EXPORT_SYMBOL(arch_local_irq_enable);
diff --git a/arch/arc/plat-arcfpga/Kconfig b/arch/arc/plat-arcfpga/Kconfig
index 3b41a0e..3b399ca 100644
--- a/arch/arc/plat-arcfpga/Kconfig
+++ b/arch/arc/plat-arcfpga/Kconfig
@@ -30,4 +30,17 @@ config ARC_SERIAL_BAUD
 	help
 	  Baud rate for the ARC UART
 
+# Platform specific IRQ wiring - tied to devices - feeds into ARC arch code
+config ARC_TIMER_LV2
+	bool "High Priority Timer0 IRQ"
+	depends on ARC_COMPACT_IRQ_LEVELS
+	select ARC_IRQ3_LV2
+
+# Timer HAS to be high priority, for any other high priority config
+config ARC_SERIAL_LV2
+	bool "High Priority Serial IRQ"
+	depends on ARC_SERIAL && ARC_TIMER_LV2
+	depends on ARC_COMPACT_IRQ_LEVELS
+	select ARC_IRQ5_LV2
+
 endif
-- 
1.7.4.1

