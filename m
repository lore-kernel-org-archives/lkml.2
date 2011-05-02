Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352Ab1EBXJ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 19:09:27 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:54332 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968Ab1EBXJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 19:09:25 -0400
X-Greylist: delayed 911 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 May 2011 19:09:25 EDT
Message-Id: <201105022254.p42MsPj2030350@farm-0023.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 2 May 2011 13:49:14 -0400
Subject: [PATCH] arch/tile: refactor backtracing code
To: linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 02 May 2011 22:54:25.0456 (UTC) FILETIME=[E26E7B00:01CC091B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change is the result of some work to make the backtrace code more
shareable between kernel, libc, and gdb.

For the kernel, some good effects are to eliminate the hacky
"VirtualAddress" typedef in favor of "unsigned long", to eliminate a
bunch of spurious kernel doc comments, to remove the dead "bt_read_memory"
function, and to use "__tilegx__" in #ifdefs instead of "TILE_CHIP".

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/backtrace.h      |   82 +++++++------------------
 arch/tile/include/asm/opcode-tile_32.h |    7 ++
 arch/tile/include/asm/opcode-tile_64.h |    7 ++
 arch/tile/kernel/backtrace.c           |  103 +++++++++++++------------------
 arch/tile/kernel/stack.c               |   14 ++--
 arch/tile/kernel/tile-desc_32.c        |   11 ++--
 6 files changed, 93 insertions(+), 131 deletions(-)

diff --git a/arch/tile/include/asm/backtrace.h b/arch/tile/include/asm/backtrace.h
index f18887d..bd5399a 100644
--- a/arch/tile/include/asm/backtrace.h
+++ b/arch/tile/include/asm/backtrace.h
@@ -12,80 +12,41 @@
  *   more details.
  */
 
-#ifndef _TILE_BACKTRACE_H
-#define _TILE_BACKTRACE_H
-
-
+#ifndef _ASM_TILE_BACKTRACE_H
+#define _ASM_TILE_BACKTRACE_H
 
 #include <linux/types.h>
 
-#include <arch/chip.h>
-
-#if defined(__tile__)
-typedef unsigned long VirtualAddress;
-#elif CHIP_VA_WIDTH() > 32
-typedef unsigned long long VirtualAddress;
-#else
-typedef unsigned int VirtualAddress;
-#endif
-
-
-/** Reads 'size' bytes from 'address' and writes the data to 'result'.
+/* Reads 'size' bytes from 'address' and writes the data to 'result'.
  * Returns true if successful, else false (e.g. memory not readable).
  */
 typedef bool (*BacktraceMemoryReader)(void *result,
-				      VirtualAddress address,
+				      unsigned long address,
 				      unsigned int size,
 				      void *extra);
 
 typedef struct {
-	/** Current PC. */
-	VirtualAddress pc;
+	/* Current PC. */
+	unsigned long pc;
 
-	/** Current stack pointer value. */
-	VirtualAddress sp;
+	/* Current stack pointer value. */
+	unsigned long sp;
 
-	/** Current frame pointer value (i.e. caller's stack pointer) */
-	VirtualAddress fp;
+	/* Current frame pointer value (i.e. caller's stack pointer) */
+	unsigned long fp;
 
-	/** Internal use only: caller's PC for first frame. */
-	VirtualAddress initial_frame_caller_pc;
+	/* Internal use only: caller's PC for first frame. */
+	unsigned long initial_frame_caller_pc;
 
-	/** Internal use only: callback to read memory. */
+	/* Internal use only: callback to read memory. */
 	BacktraceMemoryReader read_memory_func;
 
-	/** Internal use only: arbitrary argument to read_memory_func. */
+	/* Internal use only: arbitrary argument to read_memory_func. */
 	void *read_memory_func_extra;
 
 } BacktraceIterator;
 
 
-/** Initializes a backtracer to start from the given location.
- *
- * If the frame pointer cannot be determined it is set to -1.
- *
- * @param state The state to be filled in.
- * @param read_memory_func A callback that reads memory. If NULL, a default
- *        value is provided.
- * @param read_memory_func_extra An arbitrary argument to read_memory_func.
- * @param pc The current PC.
- * @param lr The current value of the 'lr' register.
- * @param sp The current value of the 'sp' register.
- * @param r52 The current value of the 'r52' register.
- */
-extern void backtrace_init(BacktraceIterator *state,
-			   BacktraceMemoryReader read_memory_func,
-			   void *read_memory_func_extra,
-			   VirtualAddress pc, VirtualAddress lr,
-			   VirtualAddress sp, VirtualAddress r52);
-
-
-/** Advances the backtracing state to the calling frame, returning
- * true iff successful.
- */
-extern bool backtrace_next(BacktraceIterator *state);
-
-
 typedef enum {
 
 	/* We have no idea what the caller's pc is. */
@@ -138,7 +99,7 @@ enum {
 };
 
 
-/** Internal constants used to define 'info' operands. */
+/* Internal constants used to define 'info' operands. */
 enum {
 	/* 0 and 1 are reserved, as are all negative numbers. */
 
@@ -147,13 +108,10 @@ enum {
 	CALLER_SP_IN_R52_BASE = 4,
 
 	CALLER_SP_OFFSET_BASE = 8,
-
-	/* Marks the entry point of certain functions. */
-	ENTRY_POINT_INFO_OP = 16
 };
 
 
-/** Current backtracer state describing where it thinks the caller is. */
+/* Current backtracer state describing where it thinks the caller is. */
 typedef struct {
 	/*
 	 * Public fields
@@ -192,7 +150,13 @@ typedef struct {
 
 } CallerLocation;
 
+extern void backtrace_init(BacktraceIterator *state,
+                          BacktraceMemoryReader read_memory_func,
+                          void *read_memory_func_extra,
+                          unsigned long pc, unsigned long lr,
+                          unsigned long sp, unsigned long r52);
 
 
+extern bool backtrace_next(BacktraceIterator *state);
 
-#endif /* _TILE_BACKTRACE_H */
+#endif /* _ASM_TILE_BACKTRACE_H */
diff --git a/arch/tile/include/asm/opcode-tile_32.h b/arch/tile/include/asm/opcode-tile_32.h
index eda60ec..03df7b1 100644
--- a/arch/tile/include/asm/opcode-tile_32.h
+++ b/arch/tile/include/asm/opcode-tile_32.h
@@ -1502,5 +1502,12 @@ extern int parse_insn_tile(tile_bundle_bits bits,
                            decoded[TILE_MAX_INSTRUCTIONS_PER_BUNDLE]);
 
 
+/* Given a set of bundle bits and a specific pipe, returns which
+ * instruction the bundle contains in that pipe.
+ */
+extern const struct tile_opcode *
+find_opcode(tile_bundle_bits bits, tile_pipeline pipe);
+
+
 
 #endif /* opcode_tile_h */
diff --git a/arch/tile/include/asm/opcode-tile_64.h b/arch/tile/include/asm/opcode-tile_64.h
index eda60ec..03df7b1 100644
--- a/arch/tile/include/asm/opcode-tile_64.h
+++ b/arch/tile/include/asm/opcode-tile_64.h
@@ -1502,5 +1502,12 @@ extern int parse_insn_tile(tile_bundle_bits bits,
                            decoded[TILE_MAX_INSTRUCTIONS_PER_BUNDLE]);
 
 
+/* Given a set of bundle bits and a specific pipe, returns which
+ * instruction the bundle contains in that pipe.
+ */
+extern const struct tile_opcode *
+find_opcode(tile_bundle_bits bits, tile_pipeline pipe);
+
+
 
 #endif /* opcode_tile_h */
diff --git a/arch/tile/kernel/backtrace.c b/arch/tile/kernel/backtrace.c
index 55a6a74..1dc71ea 100644
--- a/arch/tile/kernel/backtrace.c
+++ b/arch/tile/kernel/backtrace.c
@@ -14,19 +14,11 @@
 
 #include <linux/kernel.h>
 #include <linux/string.h>
-
 #include <asm/backtrace.h>
-
-#include <arch/chip.h>
-
 #include <asm/opcode-tile.h>
+#include <arch/abi.h>
 
-
-#define TREG_SP 54
-#define TREG_LR 55
-
-
-#if TILE_CHIP >= 10
+#ifdef __tilegx__
 #define tile_bundle_bits tilegx_bundle_bits
 #define TILE_MAX_INSTRUCTIONS_PER_BUNDLE TILEGX_MAX_INSTRUCTIONS_PER_BUNDLE
 #define TILE_BUNDLE_ALIGNMENT_IN_BYTES TILEGX_BUNDLE_ALIGNMENT_IN_BYTES
@@ -47,7 +39,7 @@ typedef long long bt_int_reg_t;
 typedef int bt_int_reg_t;
 #endif
 
-/** A decoded bundle used for backtracer analysis. */
+/* A decoded bundle used for backtracer analysis. */
 struct BacktraceBundle {
 	tile_bundle_bits bits;
 	int num_insns;
@@ -56,23 +48,7 @@ struct BacktraceBundle {
 };
 
 
-/* This implementation only makes sense for native tools. */
-/** Default function to read memory. */
-static bool bt_read_memory(void *result, VirtualAddress addr,
-			   unsigned int size, void *extra)
-{
-	/* FIXME: this should do some horrible signal stuff to catch
-	 * SEGV cleanly and fail.
-	 *
-	 * Or else the caller should do the setjmp for efficiency.
-	 */
-
-	memcpy(result, (const void *)addr, size);
-	return true;
-}
-
-
-/** Locates an instruction inside the given bundle that
+/* Locates an instruction inside the given bundle that
  * has the specified mnemonic, and whose first 'num_operands_to_match'
  * operands exactly match those in 'operand_values'.
  */
@@ -107,13 +83,13 @@ static const struct tile_decoded_instruction *find_matching_insn(
 	return NULL;
 }
 
-/** Does this bundle contain an 'iret' instruction? */
+/* Does this bundle contain an 'iret' instruction? */
 static inline bool bt_has_iret(const struct BacktraceBundle *bundle)
 {
 	return find_matching_insn(bundle, TILE_OPC_IRET, NULL, 0) != NULL;
 }
 
-/** Does this bundle contain an 'addi sp, sp, OFFSET' or
+/* Does this bundle contain an 'addi sp, sp, OFFSET' or
  * 'addli sp, sp, OFFSET' instruction, and if so, what is OFFSET?
  */
 static bool bt_has_addi_sp(const struct BacktraceBundle *bundle, int *adjust)
@@ -124,7 +100,7 @@ static bool bt_has_addi_sp(const struct BacktraceBundle *bundle, int *adjust)
 		find_matching_insn(bundle, TILE_OPC_ADDI, vals, 2);
 	if (insn == NULL)
 		insn = find_matching_insn(bundle, TILE_OPC_ADDLI, vals, 2);
-#if TILE_CHIP >= 10
+#ifdef __tilegx__
 	if (insn == NULL)
 		insn = find_matching_insn(bundle, TILEGX_OPC_ADDXLI, vals, 2);
 	if (insn == NULL)
@@ -137,7 +113,7 @@ static bool bt_has_addi_sp(const struct BacktraceBundle *bundle, int *adjust)
 	return true;
 }
 
-/** Does this bundle contain any 'info OP' or 'infol OP'
+/* Does this bundle contain any 'info OP' or 'infol OP'
  * instruction, and if so, what are their OP?  Note that OP is interpreted
  * as an unsigned value by this code since that's what the caller wants.
  * Returns the number of info ops found.
@@ -161,7 +137,7 @@ static int bt_get_info_ops(const struct BacktraceBundle *bundle,
 	return num_ops;
 }
 
-/** Does this bundle contain a jrp instruction, and if so, to which
+/* Does this bundle contain a jrp instruction, and if so, to which
  * register is it jumping?
  */
 static bool bt_has_jrp(const struct BacktraceBundle *bundle, int *target_reg)
@@ -175,7 +151,7 @@ static bool bt_has_jrp(const struct BacktraceBundle *bundle, int *target_reg)
 	return true;
 }
 
-/** Does this bundle modify the specified register in any way? */
+/* Does this bundle modify the specified register in any way? */
 static bool bt_modifies_reg(const struct BacktraceBundle *bundle, int reg)
 {
 	int i, j;
@@ -195,34 +171,34 @@ static bool bt_modifies_reg(const struct BacktraceBundle *bundle, int reg)
 	return false;
 }
 
-/** Does this bundle modify sp? */
+/* Does this bundle modify sp? */
 static inline bool bt_modifies_sp(const struct BacktraceBundle *bundle)
 {
 	return bt_modifies_reg(bundle, TREG_SP);
 }
 
-/** Does this bundle modify lr? */
+/* Does this bundle modify lr? */
 static inline bool bt_modifies_lr(const struct BacktraceBundle *bundle)
 {
 	return bt_modifies_reg(bundle, TREG_LR);
 }
 
-/** Does this bundle contain the instruction 'move fp, sp'? */
+/* Does this bundle contain the instruction 'move fp, sp'? */
 static inline bool bt_has_move_r52_sp(const struct BacktraceBundle *bundle)
 {
 	static const int vals[2] = { 52, TREG_SP };
 	return find_matching_insn(bundle, TILE_OPC_MOVE, vals, 2) != NULL;
 }
 
-/** Does this bundle contain a store of lr to sp? */
+/* Does this bundle contain a store of lr to sp? */
 static inline bool bt_has_sw_sp_lr(const struct BacktraceBundle *bundle)
 {
 	static const int vals[2] = { TREG_SP, TREG_LR };
 	return find_matching_insn(bundle, OPCODE_STORE, vals, 2) != NULL;
 }
 
-#if TILE_CHIP >= 10
-/** Track moveli values placed into registers. */
+#ifdef __tilegx__
+/* Track moveli values placed into registers. */
 static inline void bt_update_moveli(const struct BacktraceBundle *bundle,
 				    int moveli_args[])
 {
@@ -238,7 +214,7 @@ static inline void bt_update_moveli(const struct BacktraceBundle *bundle,
 	}
 }
 
-/** Does this bundle contain an 'add sp, sp, reg' instruction
+/* Does this bundle contain an 'add sp, sp, reg' instruction
  * from a register that we saw a moveli into, and if so, what
  * is the value in the register?
  */
@@ -260,11 +236,11 @@ static bool bt_has_add_sp(const struct BacktraceBundle *bundle, int *adjust,
 }
 #endif
 
-/** Locates the caller's PC and SP for a program starting at the
+/* Locates the caller's PC and SP for a program starting at the
  * given address.
  */
 static void find_caller_pc_and_caller_sp(CallerLocation *location,
-					 const VirtualAddress start_pc,
+					 const unsigned long start_pc,
 					 BacktraceMemoryReader read_memory_func,
 					 void *read_memory_func_extra)
 {
@@ -288,9 +264,9 @@ static void find_caller_pc_and_caller_sp(CallerLocation *location,
 	tile_bundle_bits prefetched_bundles[32];
 	int num_bundles_prefetched = 0;
 	int next_bundle = 0;
-	VirtualAddress pc;
+	unsigned long pc;
 
-#if TILE_CHIP >= 10
+#ifdef __tilegx__
 	/* Naively try to track moveli values to support addx for -m32. */
 	int moveli_args[TILEGX_NUM_REGISTERS] = { 0 };
 #endif
@@ -369,10 +345,6 @@ static void find_caller_pc_and_caller_sp(CallerLocation *location,
 					/* Weird; reserved value, ignore it. */
 					continue;
 				}
-				if (info_operand & ENTRY_POINT_INFO_OP)	{
-					/* This info op is ignored by the backtracer. */
-					continue;
-				}
 
 				/* Skip info ops which are not in the
 				 * "one_ago" mode we want right now.
@@ -453,7 +425,7 @@ static void find_caller_pc_and_caller_sp(CallerLocation *location,
 		if (!sp_determined) {
 			int adjust;
 			if (bt_has_addi_sp(&bundle, &adjust)
-#if TILE_CHIP >= 10
+#ifdef __tilegx__
 			    || bt_has_add_sp(&bundle, &adjust, moveli_args)
 #endif
 				) {
@@ -504,7 +476,7 @@ static void find_caller_pc_and_caller_sp(CallerLocation *location,
 				}
 			}
 
-#if TILE_CHIP >= 10
+#ifdef __tilegx__
 			/* Track moveli arguments for -m32 mode. */
 			bt_update_moveli(&bundle, moveli_args);
 #endif
@@ -546,18 +518,26 @@ static void find_caller_pc_and_caller_sp(CallerLocation *location,
 	}
 }
 
+/* Initializes a backtracer to start from the given location.
+ *
+ * If the frame pointer cannot be determined it is set to -1.
+ *
+ * state: The state to be filled in.
+ * read_memory_func: A callback that reads memory.
+ * read_memory_func_extra: An arbitrary argument to read_memory_func.
+ * pc: The current PC.
+ * lr: The current value of the 'lr' register.
+ * sp: The current value of the 'sp' register.
+ * r52: The current value of the 'r52' register.
+ */
 void backtrace_init(BacktraceIterator *state,
 		    BacktraceMemoryReader read_memory_func,
 		    void *read_memory_func_extra,
-		    VirtualAddress pc, VirtualAddress lr,
-		    VirtualAddress sp, VirtualAddress r52)
+		    unsigned long pc, unsigned long lr,
+		    unsigned long sp, unsigned long r52)
 {
 	CallerLocation location;
-	VirtualAddress fp, initial_frame_caller_pc;
-
-	if (read_memory_func == NULL) {
-		read_memory_func = bt_read_memory;
-	}
+	unsigned long fp, initial_frame_caller_pc;
 
 	/* Find out where we are in the initial frame. */
 	find_caller_pc_and_caller_sp(&location, pc,
@@ -630,12 +610,15 @@ void backtrace_init(BacktraceIterator *state,
 /* Handle the case where the register holds more bits than the VA. */
 static bool valid_addr_reg(bt_int_reg_t reg)
 {
-	return ((VirtualAddress)reg == reg);
+	return ((unsigned long)reg == reg);
 }
 
+/* Advances the backtracing state to the calling frame, returning
+ * true iff successful.
+ */
 bool backtrace_next(BacktraceIterator *state)
 {
-	VirtualAddress next_fp, next_pc;
+	unsigned long next_fp, next_pc;
 	bt_int_reg_t next_frame[2];
 
 	if (state->fp == -1) {
diff --git a/arch/tile/kernel/stack.c b/arch/tile/kernel/stack.c
index dd81713..37ee4d0 100644
--- a/arch/tile/kernel/stack.c
+++ b/arch/tile/kernel/stack.c
@@ -36,7 +36,7 @@
 #define KBT_LOOP	3  /* Backtrace entered a loop */
 
 /* Is address on the specified kernel stack? */
-static int in_kernel_stack(struct KBacktraceIterator *kbt, VirtualAddress sp)
+static int in_kernel_stack(struct KBacktraceIterator *kbt, unsigned long sp)
 {
 	ulong kstack_base = (ulong) kbt->task->stack;
 	if (kstack_base == 0)  /* corrupt task pointer; just follow stack... */
@@ -45,7 +45,7 @@ static int in_kernel_stack(struct KBacktraceIterator *kbt, VirtualAddress sp)
 }
 
 /* Is address valid for reading? */
-static int valid_address(struct KBacktraceIterator *kbt, VirtualAddress address)
+static int valid_address(struct KBacktraceIterator *kbt, unsigned long address)
 {
 	HV_PTE *l1_pgtable = kbt->pgtable;
 	HV_PTE *l2_pgtable;
@@ -97,7 +97,7 @@ static int valid_address(struct KBacktraceIterator *kbt, VirtualAddress address)
 }
 
 /* Callback for backtracer; basically a glorified memcpy */
-static bool read_memory_func(void *result, VirtualAddress address,
+static bool read_memory_func(void *result, unsigned long address,
 			     unsigned int size, void *vkbt)
 {
 	int retval;
@@ -124,7 +124,7 @@ static struct pt_regs *valid_fault_handler(struct KBacktraceIterator* kbt)
 {
 	const char *fault = NULL;  /* happy compiler */
 	char fault_buf[64];
-	VirtualAddress sp = kbt->it.sp;
+	unsigned long sp = kbt->it.sp;
 	struct pt_regs *p;
 
 	if (!in_kernel_stack(kbt, sp))
@@ -163,7 +163,7 @@ static struct pt_regs *valid_fault_handler(struct KBacktraceIterator* kbt)
 }
 
 /* Is the pc pointing to a sigreturn trampoline? */
-static int is_sigreturn(VirtualAddress pc)
+static int is_sigreturn(unsigned long pc)
 {
 	return (pc == VDSO_BASE);
 }
@@ -260,7 +260,7 @@ static void validate_stack(struct pt_regs *regs)
 void KBacktraceIterator_init(struct KBacktraceIterator *kbt,
 			     struct task_struct *t, struct pt_regs *regs)
 {
-	VirtualAddress pc, lr, sp, r52;
+	unsigned long pc, lr, sp, r52;
 	int is_current;
 
 	/*
@@ -331,7 +331,7 @@ EXPORT_SYMBOL(KBacktraceIterator_end);
 
 void KBacktraceIterator_next(struct KBacktraceIterator *kbt)
 {
-	VirtualAddress old_pc = kbt->it.pc, old_sp = kbt->it.sp;
+	unsigned long old_pc = kbt->it.pc, old_sp = kbt->it.sp;
 	kbt->new_context = 0;
 	if (!backtrace_next(&kbt->it) && !KBacktraceIterator_restart(kbt)) {
 		kbt->end = KBT_DONE;
diff --git a/arch/tile/kernel/tile-desc_32.c b/arch/tile/kernel/tile-desc_32.c
index 69af0e1..7e31a12 100644
--- a/arch/tile/kernel/tile-desc_32.c
+++ b/arch/tile/kernel/tile-desc_32.c
@@ -2413,12 +2413,13 @@ const struct tile_operand tile_operands[43] =
 
 
 
-/* Given a set of bundle bits and the lookup FSM for a specific pipe,
- * returns which instruction the bundle contains in that pipe.
+/* Given a set of bundle bits and a specific pipe, returns which
+ * instruction the bundle contains in that pipe.
  */
-static const struct tile_opcode *
-find_opcode(tile_bundle_bits bits, const unsigned short *table)
+const struct tile_opcode *
+find_opcode(tile_bundle_bits bits, tile_pipeline pipe)
 {
+  const unsigned short *table = tile_bundle_decoder_fsms[pipe];
   int index = 0;
 
   while (1)
@@ -2465,7 +2466,7 @@ parse_insn_tile(tile_bundle_bits bits,
     int i;
 
     d = &decoded[num_instructions++];
-    opc = find_opcode (bits, tile_bundle_decoder_fsms[pipe]);
+    opc = find_opcode (bits, (tile_pipeline)pipe);
     d->opcode = opc;
 
     /* Decode each operand, sign extending, etc. as appropriate. */
-- 
1.6.5.2

