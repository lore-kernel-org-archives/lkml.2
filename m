Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761625Ab0HMNKO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 09:10:14 -0400
Received: from king.tilera.com ([72.1.168.226]:13968 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761593Ab0HMNJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 09:09:51 -0400
Message-Id: <201008131309.o7DD9lro005841@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 13 Aug 2010 08:40:57 -0400
Subject: [PATCH] arch/tile: support backtracing on TILE-Gx
To: linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 13 Aug 2010 13:09:47.0735 (UTC) FILETIME=[CE408670:01CB3AE8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This functionality was stubbed out until recently.  Now we support our
normal backtracing API on TILE-Gx as well as on TILE64/TILEPro.
This change includes a tweak to the instruction encoding caused by
adding addxli for compat mode.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/backtrace.h |    4 +-
 arch/tile/kernel/backtrace.c      |  137 ++++++++++++++++++++++++++----------
 arch/tile/kernel/stack.c          |    8 --
 arch/tile/kernel/traps.c          |    4 +-
 4 files changed, 105 insertions(+), 48 deletions(-)

diff --git a/arch/tile/include/asm/backtrace.h b/arch/tile/include/asm/backtrace.h
index 6970bfc..758ca46 100644
--- a/arch/tile/include/asm/backtrace.h
+++ b/arch/tile/include/asm/backtrace.h
@@ -21,7 +21,9 @@
 
 #include <arch/chip.h>
 
-#if CHIP_VA_WIDTH() > 32
+#if defined(__tile__)
+typedef unsigned long VirtualAddress;
+#elif CHIP_VA_WIDTH() > 32
 typedef unsigned long long VirtualAddress;
 #else
 typedef unsigned int VirtualAddress;
diff --git a/arch/tile/kernel/backtrace.c b/arch/tile/kernel/backtrace.c
index 77265f3..d3c41c1 100644
--- a/arch/tile/kernel/backtrace.c
+++ b/arch/tile/kernel/backtrace.c
@@ -19,9 +19,6 @@
 
 #include <arch/chip.h>
 
-#if TILE_CHIP < 10
-
-
 #include <asm/opcode-tile.h>
 
 
@@ -29,6 +26,27 @@
 #define TREG_LR 55
 
 
+#if TILE_CHIP >= 10
+#define tile_bundle_bits tilegx_bundle_bits
+#define TILE_MAX_INSTRUCTIONS_PER_BUNDLE TILEGX_MAX_INSTRUCTIONS_PER_BUNDLE
+#define TILE_BUNDLE_ALIGNMENT_IN_BYTES TILEGX_BUNDLE_ALIGNMENT_IN_BYTES
+#define tile_decoded_instruction tilegx_decoded_instruction
+#define tile_mnemonic tilegx_mnemonic
+#define parse_insn_tile parse_insn_tilegx
+#define TILE_OPC_IRET TILEGX_OPC_IRET
+#define TILE_OPC_ADDI TILEGX_OPC_ADDI
+#define TILE_OPC_ADDLI TILEGX_OPC_ADDLI
+#define TILE_OPC_INFO TILEGX_OPC_INFO
+#define TILE_OPC_INFOL TILEGX_OPC_INFOL
+#define TILE_OPC_JRP TILEGX_OPC_JRP
+#define TILE_OPC_MOVE TILEGX_OPC_MOVE
+#define OPCODE_STORE TILEGX_OPC_ST
+typedef long long bt_int_reg_t;
+#else
+#define OPCODE_STORE TILE_OPC_SW
+typedef int bt_int_reg_t;
+#endif
+
 /** A decoded bundle used for backtracer analysis. */
 struct BacktraceBundle {
 	tile_bundle_bits bits;
@@ -41,7 +59,7 @@ struct BacktraceBundle {
 /* This implementation only makes sense for native tools. */
 /** Default function to read memory. */
 static bool bt_read_memory(void *result, VirtualAddress addr,
-			   size_t size, void *extra)
+			   unsigned int size, void *extra)
 {
 	/* FIXME: this should do some horrible signal stuff to catch
 	 * SEGV cleanly and fail.
@@ -106,6 +124,12 @@ static bool bt_has_addi_sp(const struct BacktraceBundle *bundle, int *adjust)
 		find_matching_insn(bundle, TILE_OPC_ADDI, vals, 2);
 	if (insn == NULL)
 		insn = find_matching_insn(bundle, TILE_OPC_ADDLI, vals, 2);
+#if TILE_CHIP >= 10
+	if (insn == NULL)
+		insn = find_matching_insn(bundle, TILEGX_OPC_ADDXLI, vals, 2);
+	if (insn == NULL)
+		insn = find_matching_insn(bundle, TILEGX_OPC_ADDXI, vals, 2);
+#endif
 	if (insn == NULL)
 		return false;
 
@@ -190,13 +214,52 @@ static inline bool bt_has_move_r52_sp(const struct BacktraceBundle *bundle)
 	return find_matching_insn(bundle, TILE_OPC_MOVE, vals, 2) != NULL;
 }
 
-/** Does this bundle contain the instruction 'sw sp, lr'? */
+/** Does this bundle contain a store of lr to sp? */
 static inline bool bt_has_sw_sp_lr(const struct BacktraceBundle *bundle)
 {
 	static const int vals[2] = { TREG_SP, TREG_LR };
-	return find_matching_insn(bundle, TILE_OPC_SW, vals, 2) != NULL;
+	return find_matching_insn(bundle, OPCODE_STORE, vals, 2) != NULL;
+}
+
+#if TILE_CHIP >= 10
+/** Track moveli values placed into registers. */
+static inline void bt_update_moveli(const struct BacktraceBundle *bundle,
+				    int moveli_args[])
+{
+	int i;
+	for (i = 0; i < bundle->num_insns; i++) {
+		const struct tile_decoded_instruction *insn =
+			&bundle->insns[i];
+
+		if (insn->opcode->mnemonic == TILEGX_OPC_MOVELI) {
+			int reg = insn->operand_values[0];
+			moveli_args[reg] = insn->operand_values[1];
+		}
+	}
 }
 
+/** Does this bundle contain an 'add sp, sp, reg' instruction
+ * from a register that we saw a moveli into, and if so, what
+ * is the value in the register?
+ */
+static bool bt_has_add_sp(const struct BacktraceBundle *bundle, int *adjust,
+			  int moveli_args[])
+{
+	static const int vals[2] = { TREG_SP, TREG_SP };
+
+	const struct tile_decoded_instruction *insn =
+		find_matching_insn(bundle, TILEGX_OPC_ADDX, vals, 2);
+	if (insn) {
+		int reg = insn->operand_values[2];
+		if (moveli_args[reg]) {
+			*adjust = moveli_args[reg];
+			return true;
+		}
+	}
+	return false;
+}
+#endif
+
 /** Locates the caller's PC and SP for a program starting at the
  * given address.
  */
@@ -227,6 +290,11 @@ static void find_caller_pc_and_caller_sp(CallerLocation *location,
 	int next_bundle = 0;
 	VirtualAddress pc;
 
+#if TILE_CHIP >= 10
+	/* Naively try to track moveli values to support addx for -m32. */
+	int moveli_args[TILEGX_NUM_REGISTERS] = { 0 };
+#endif
+
 	/* Default to assuming that the caller's sp is the current sp.
 	 * This is necessary to handle the case where we start backtracing
 	 * right at the end of the epilog.
@@ -380,7 +448,11 @@ static void find_caller_pc_and_caller_sp(CallerLocation *location,
 
 		if (!sp_determined) {
 			int adjust;
-			if (bt_has_addi_sp(&bundle, &adjust)) {
+			if (bt_has_addi_sp(&bundle, &adjust)
+#if TILE_CHIP >= 10
+			    || bt_has_add_sp(&bundle, &adjust, moveli_args)
+#endif
+				) {
 				location->sp_location = SP_LOC_OFFSET;
 
 				if (adjust <= 0) {
@@ -427,6 +499,11 @@ static void find_caller_pc_and_caller_sp(CallerLocation *location,
 					sp_determined = true;
 				}
 			}
+
+#if TILE_CHIP >= 10
+			/* Track moveli arguments for -m32 mode. */
+			bt_update_moveli(&bundle, moveli_args);
+#endif
 		}
 
 		if (bt_has_iret(&bundle)) {
@@ -502,11 +579,10 @@ void backtrace_init(BacktraceIterator *state,
 		break;
 	}
 
-	/* The frame pointer should theoretically be aligned mod 8. If
-	 * it's not even aligned mod 4 then something terrible happened
-	 * and we should mark it as invalid.
+	/* If the frame pointer is not aligned to the basic word size
+	 * something terrible happened and we should mark it as invalid.
 	 */
-	if (fp % 4 != 0)
+	if (fp % sizeof(bt_int_reg_t) != 0)
 		fp = -1;
 
 	/* -1 means "don't know initial_frame_caller_pc". */
@@ -547,9 +623,16 @@ void backtrace_init(BacktraceIterator *state,
 	state->read_memory_func_extra = read_memory_func_extra;
 }
 
+/* Handle the case where the register holds more bits than the VA. */
+static bool valid_addr_reg(bt_int_reg_t reg)
+{
+	return ((VirtualAddress)reg == reg);
+}
+
 bool backtrace_next(BacktraceIterator *state)
 {
-	VirtualAddress next_fp, next_pc, next_frame[2];
+	VirtualAddress next_fp, next_pc;
+	bt_int_reg_t next_frame[2];
 
 	if (state->fp == -1) {
 		/* No parent frame. */
@@ -563,11 +646,9 @@ bool backtrace_next(BacktraceIterator *state)
 	}
 
 	next_fp = next_frame[1];
-	if (next_fp % 4 != 0) {
-		/* Caller's frame pointer is suspect, so give up.
-		 * Technically it should be aligned mod 8, but we will
-		 * be forgiving here.
-		 */
+	if (!valid_addr_reg(next_frame[1]) ||
+	    next_fp % sizeof(bt_int_reg_t) != 0) {
+		/* Caller's frame pointer is suspect, so give up. */
 		return false;
 	}
 
@@ -585,7 +666,7 @@ bool backtrace_next(BacktraceIterator *state)
 	} else {
 		/* Get the caller PC from the frame linkage area. */
 		next_pc = next_frame[0];
-		if (next_pc == 0 ||
+		if (!valid_addr_reg(next_frame[0]) || next_pc == 0 ||
 		    next_pc % TILE_BUNDLE_ALIGNMENT_IN_BYTES != 0) {
 			/* The PC is suspect, so give up. */
 			return false;
@@ -599,23 +680,3 @@ bool backtrace_next(BacktraceIterator *state)
 
 	return true;
 }
-
-#else /* TILE_CHIP < 10 */
-
-void backtrace_init(BacktraceIterator *state,
-		    BacktraceMemoryReader read_memory_func,
-		    void *read_memory_func_extra,
-		    VirtualAddress pc, VirtualAddress lr,
-		    VirtualAddress sp, VirtualAddress r52)
-{
-	state->pc = pc;
-	state->sp = sp;
-	state->fp = -1;
-	state->initial_frame_caller_pc = -1;
-	state->read_memory_func = read_memory_func;
-	state->read_memory_func_extra = read_memory_func_extra;
-}
-
-bool backtrace_next(BacktraceIterator *state) { return false; }
-
-#endif /* TILE_CHIP < 10 */
diff --git a/arch/tile/kernel/stack.c b/arch/tile/kernel/stack.c
index b6268d3..38a68b0 100644
--- a/arch/tile/kernel/stack.c
+++ b/arch/tile/kernel/stack.c
@@ -108,7 +108,6 @@ static bool read_memory_func(void *result, VirtualAddress address,
 /* Return a pt_regs pointer for a valid fault handler frame */
 static struct pt_regs *valid_fault_handler(struct KBacktraceIterator* kbt)
 {
-#ifndef __tilegx__
 	const char *fault = NULL;  /* happy compiler */
 	char fault_buf[64];
 	VirtualAddress sp = kbt->it.sp;
@@ -146,7 +145,6 @@ static struct pt_regs *valid_fault_handler(struct KBacktraceIterator* kbt)
 	}
 	if (!kbt->profile || (INT_MASK(p->faultnum) & QUEUED_INTERRUPTS) == 0)
 		return p;
-#endif
 	return NULL;
 }
 
@@ -351,12 +349,6 @@ void tile_show_stack(struct KBacktraceIterator *kbt, int headers)
 		       kbt->task->pid, kbt->task->tgid, kbt->task->comm,
 		       smp_processor_id(), get_cycles());
 	}
-#ifdef __tilegx__
-	if (kbt->is_current) {
-		__insn_mtspr(SPR_SIM_CONTROL,
-			     SIM_DUMP_SPR_ARG(SIM_DUMP_BACKTRACE));
-	}
-#endif
 	kbt->verbose = 1;
 	i = 0;
 	for (; !KBacktraceIterator_end(kbt); KBacktraceIterator_next(kbt)) {
diff --git a/arch/tile/kernel/traps.c b/arch/tile/kernel/traps.c
index 3870abb..0f362dc 100644
--- a/arch/tile/kernel/traps.c
+++ b/arch/tile/kernel/traps.c
@@ -128,7 +128,9 @@ static int special_ill(bundle_bits bundle, int *sigp, int *codep)
 #ifdef __tilegx__
 	if ((bundle & TILEGX_BUNDLE_MODE_MASK) != 0)
 		return 0;
-	if (get_Opcode_X1(bundle) != UNARY_OPCODE_X1)
+	if (get_Opcode_X1(bundle) != RRR_0_OPCODE_X1)
+		return 0;
+	if (get_RRROpcodeExtension_X1(bundle) != UNARY_RRR_0_OPCODE_X1)
 		return 0;
 	if (get_UnaryOpcodeExtension_X1(bundle) != ILL_UNARY_OPCODE_X1)
 		return 0;
-- 
1.6.5.2

