Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833Ab0E2DeY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 23:34:24 -0400
Received: from king.tilera.com ([72.1.168.226]:16063 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755774Ab0E2DeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 23:34:14 -0400
Message-Id: <201005290334.o4T3Y6dP029952@farm-0002.internal.tilera.com>
In-Reply-To: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com>
References: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 28 May 2010 23:10:39 -0400
Subject: [PATCH 4/8] arch/tile: core kernel/ code.
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, torvalds@linux-foundation.org
X-OriginalArrivalTime: 29 May 2010 03:34:07.0124 (UTC) FILETIME=[CB0C8D40:01CAFEDF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This omits just the tile-desc_32.c file, which is large enough to
merit being in a separate commit.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/Makefile          |   16 +
 arch/tile/kernel/asm-offsets.c     |   76 ++
 arch/tile/kernel/backtrace.c       |  634 ++++++++++++
 arch/tile/kernel/compat.c          |  183 ++++
 arch/tile/kernel/compat_signal.c   |  433 ++++++++
 arch/tile/kernel/early_printk.c    |  109 ++
 arch/tile/kernel/entry.S           |  141 +++
 arch/tile/kernel/head_32.S         |  180 ++++
 arch/tile/kernel/hvglue.lds        |   56 +
 arch/tile/kernel/init_task.c       |   59 ++
 arch/tile/kernel/intvec_32.S       | 2006 ++++++++++++++++++++++++++++++++++++
 arch/tile/kernel/irq.c             |  227 ++++
 arch/tile/kernel/machine_kexec.c   |  291 ++++++
 arch/tile/kernel/messaging.c       |  115 ++
 arch/tile/kernel/module.c          |  257 +++++
 arch/tile/kernel/pci-dma.c         |  231 +++++
 arch/tile/kernel/proc.c            |   91 ++
 arch/tile/kernel/process.c         |  647 ++++++++++++
 arch/tile/kernel/ptrace.c          |  203 ++++
 arch/tile/kernel/reboot.c          |   52 +
 arch/tile/kernel/regs_32.S         |  145 +++
 arch/tile/kernel/relocate_kernel.S |  280 +++++
 arch/tile/kernel/setup.c           | 1497 +++++++++++++++++++++++++++
 arch/tile/kernel/signal.c          |  359 +++++++
 arch/tile/kernel/single_step.c     |  656 ++++++++++++
 arch/tile/kernel/smp.c             |  202 ++++
 arch/tile/kernel/smpboot.c         |  293 ++++++
 arch/tile/kernel/stack.c           |  485 +++++++++
 arch/tile/kernel/sys.c             |  122 +++
 arch/tile/kernel/time.c            |  220 ++++
 arch/tile/kernel/tlb.c             |   97 ++
 arch/tile/kernel/traps.c           |  237 +++++
 arch/tile/kernel/vmlinux.lds.S     |   98 ++
 33 files changed, 10698 insertions(+), 0 deletions(-)
 create mode 100644 arch/tile/kernel/Makefile
 create mode 100644 arch/tile/kernel/asm-offsets.c
 create mode 100644 arch/tile/kernel/backtrace.c
 create mode 100644 arch/tile/kernel/compat.c
 create mode 100644 arch/tile/kernel/compat_signal.c
 create mode 100644 arch/tile/kernel/early_printk.c
 create mode 100644 arch/tile/kernel/entry.S
 create mode 100644 arch/tile/kernel/head_32.S
 create mode 100644 arch/tile/kernel/hvglue.lds
 create mode 100644 arch/tile/kernel/init_task.c
 create mode 100644 arch/tile/kernel/intvec_32.S
 create mode 100644 arch/tile/kernel/irq.c
 create mode 100644 arch/tile/kernel/machine_kexec.c
 create mode 100644 arch/tile/kernel/messaging.c
 create mode 100644 arch/tile/kernel/module.c
 create mode 100644 arch/tile/kernel/pci-dma.c
 create mode 100644 arch/tile/kernel/proc.c
 create mode 100644 arch/tile/kernel/process.c
 create mode 100644 arch/tile/kernel/ptrace.c
 create mode 100644 arch/tile/kernel/reboot.c
 create mode 100644 arch/tile/kernel/regs_32.S
 create mode 100644 arch/tile/kernel/relocate_kernel.S
 create mode 100644 arch/tile/kernel/setup.c
 create mode 100644 arch/tile/kernel/signal.c
 create mode 100644 arch/tile/kernel/single_step.c
 create mode 100644 arch/tile/kernel/smp.c
 create mode 100644 arch/tile/kernel/smpboot.c
 create mode 100644 arch/tile/kernel/stack.c
 create mode 100644 arch/tile/kernel/sys.c
 create mode 100644 arch/tile/kernel/time.c
 create mode 100644 arch/tile/kernel/tlb.c
 create mode 100644 arch/tile/kernel/traps.c
 create mode 100644 arch/tile/kernel/vmlinux.lds.S

diff --git a/arch/tile/kernel/Makefile b/arch/tile/kernel/Makefile
new file mode 100644
index 0000000..756e6ec
--- /dev/null
+++ b/arch/tile/kernel/Makefile
@@ -0,0 +1,16 @@
+#
+# Makefile for the Linux/TILE kernel.
+#
+
+extra-y := vmlinux.lds head_$(BITS).o
+obj-y := backtrace.o entry.o init_task.o irq.o messaging.o \
+	pci-dma.o proc.o process.o ptrace.o reboot.o \
+	setup.o signal.o single_step.o stack.o sys.o time.o traps.o \
+	intvec_$(BITS).o regs_$(BITS).o tile-desc_$(BITS).o
+
+obj-$(CONFIG_TILEGX)		+= futex_64.o
+obj-$(CONFIG_COMPAT)		+= compat.o compat_signal.o
+obj-$(CONFIG_SMP)		+= smpboot.o smp.o tlb.o
+obj-$(CONFIG_MODULES)		+= module.o
+obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
+obj-$(CONFIG_KEXEC)		+= machine_kexec.o relocate_kernel.o
diff --git a/arch/tile/kernel/asm-offsets.c b/arch/tile/kernel/asm-offsets.c
new file mode 100644
index 0000000..01ddf19
--- /dev/null
+++ b/arch/tile/kernel/asm-offsets.c
@@ -0,0 +1,76 @@
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
+ *
+ * Generates definitions from c-type structures used by assembly sources.
+ */
+
+#include <linux/kbuild.h>
+#include <linux/thread_info.h>
+#include <linux/sched.h>
+#include <linux/hardirq.h>
+#include <linux/ptrace.h>
+#include <hv/hypervisor.h>
+
+/* Check for compatible compiler early in the build. */
+#ifdef CONFIG_TILEGX
+# ifndef __tilegx__
+#  error Can only build TILE-Gx configurations with tilegx compiler
+# endif
+# ifndef __LP64__
+#  error Must not specify -m32 when building the TILE-Gx kernel
+# endif
+#else
+# ifdef __tilegx__
+#  error Can not build TILEPro/TILE64 configurations with tilegx compiler
+# endif
+#endif
+
+void foo(void)
+{
+	DEFINE(SINGLESTEP_STATE_BUFFER_OFFSET, \
+	       offsetof(struct single_step_state, buffer));
+	DEFINE(SINGLESTEP_STATE_FLAGS_OFFSET, \
+	       offsetof(struct single_step_state, flags));
+	DEFINE(SINGLESTEP_STATE_ORIG_PC_OFFSET, \
+	       offsetof(struct single_step_state, orig_pc));
+	DEFINE(SINGLESTEP_STATE_NEXT_PC_OFFSET, \
+	       offsetof(struct single_step_state, next_pc));
+	DEFINE(SINGLESTEP_STATE_BRANCH_NEXT_PC_OFFSET, \
+	       offsetof(struct single_step_state, branch_next_pc));
+	DEFINE(SINGLESTEP_STATE_UPDATE_VALUE_OFFSET, \
+	       offsetof(struct single_step_state, update_value));
+
+	DEFINE(THREAD_INFO_TASK_OFFSET, \
+	       offsetof(struct thread_info, task));
+	DEFINE(THREAD_INFO_FLAGS_OFFSET, \
+	       offsetof(struct thread_info, flags));
+	DEFINE(THREAD_INFO_STATUS_OFFSET, \
+	       offsetof(struct thread_info, status));
+	DEFINE(THREAD_INFO_HOMECACHE_CPU_OFFSET, \
+	       offsetof(struct thread_info, homecache_cpu));
+	DEFINE(THREAD_INFO_STEP_STATE_OFFSET, \
+	       offsetof(struct thread_info, step_state));
+
+	DEFINE(TASK_STRUCT_THREAD_KSP_OFFSET,
+	       offsetof(struct task_struct, thread.ksp));
+	DEFINE(TASK_STRUCT_THREAD_PC_OFFSET,
+	       offsetof(struct task_struct, thread.pc));
+
+	DEFINE(HV_TOPOLOGY_WIDTH_OFFSET, \
+	       offsetof(HV_Topology, width));
+	DEFINE(HV_TOPOLOGY_HEIGHT_OFFSET, \
+	       offsetof(HV_Topology, height));
+
+	DEFINE(IRQ_CPUSTAT_SYSCALL_COUNT_OFFSET, \
+	       offsetof(irq_cpustat_t, irq_syscall_count));
+}
diff --git a/arch/tile/kernel/backtrace.c b/arch/tile/kernel/backtrace.c
new file mode 100644
index 0000000..1b0a410
--- /dev/null
+++ b/arch/tile/kernel/backtrace.c
@@ -0,0 +1,634 @@
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
+#include <linux/kernel.h>
+#include <linux/string.h>
+
+#include <asm/backtrace.h>
+
+#include <arch/chip.h>
+
+#if TILE_CHIP < 10
+
+
+#include <asm/opcode-tile.h>
+
+
+#define TREG_SP 54
+#define TREG_LR 55
+
+
+/** A decoded bundle used for backtracer analysis. */
+typedef struct {
+	tile_bundle_bits bits;
+	int num_insns;
+	struct tile_decoded_instruction
+	insns[TILE_MAX_INSTRUCTIONS_PER_BUNDLE];
+} BacktraceBundle;
+
+
+/* This implementation only makes sense for native tools. */
+/** Default function to read memory. */
+static bool
+bt_read_memory(void *result, VirtualAddress addr, size_t size, void *extra)
+{
+	/* FIXME: this should do some horrible signal stuff to catch
+	 * SEGV cleanly and fail.
+	 *
+	 * Or else the caller should do the setjmp for efficiency.
+	 */
+
+	memcpy(result, (const void *)addr, size);
+	return true;
+}
+
+
+/** Locates an instruction inside the given bundle that
+ * has the specified mnemonic, and whose first 'num_operands_to_match'
+ * operands exactly match those in 'operand_values'.
+ */
+static const struct tile_decoded_instruction*
+find_matching_insn(const BacktraceBundle *bundle,
+		   tile_mnemonic mnemonic,
+		   const int *operand_values,
+		   int num_operands_to_match)
+{
+	int i, j;
+	bool match;
+
+	for (i = 0; i < bundle->num_insns; i++) {
+		const struct tile_decoded_instruction *insn =
+			&bundle->insns[i];
+
+		if (insn->opcode->mnemonic != mnemonic)
+			continue;
+
+		match = true;
+		for (j = 0; j < num_operands_to_match; j++) {
+			if (operand_values[j] != insn->operand_values[j]) {
+				match = false;
+				break;
+			}
+		}
+
+		if (match)
+			return insn;
+	}
+
+	return NULL;
+}
+
+/** Does this bundle contain an 'iret' instruction? */
+static inline bool
+bt_has_iret(const BacktraceBundle *bundle)
+{
+	return find_matching_insn(bundle, TILE_OPC_IRET, NULL, 0) != NULL;
+}
+
+/** Does this bundle contain an 'addi sp, sp, OFFSET' or
+ * 'addli sp, sp, OFFSET' instruction, and if so, what is OFFSET?
+ */
+static bool
+bt_has_addi_sp(const BacktraceBundle *bundle, int *adjust)
+{
+	static const int vals[2] = { TREG_SP, TREG_SP };
+
+	const struct tile_decoded_instruction *insn =
+		find_matching_insn(bundle, TILE_OPC_ADDI, vals, 2);
+	if (insn == NULL)
+		insn = find_matching_insn(bundle, TILE_OPC_ADDLI, vals, 2);
+	if (insn == NULL)
+		return false;
+
+	*adjust = insn->operand_values[2];
+	return true;
+}
+
+/** Does this bundle contain any 'info OP' or 'infol OP'
+ * instruction, and if so, what are their OP?  Note that OP is interpreted
+ * as an unsigned value by this code since that's what the caller wants.
+ * Returns the number of info ops found.
+ */
+static int
+bt_get_info_ops(const BacktraceBundle *bundle,
+		int operands[MAX_INFO_OPS_PER_BUNDLE])
+{
+	int num_ops = 0;
+	int i;
+
+	for (i = 0; i < bundle->num_insns; i++) {
+		const struct tile_decoded_instruction *insn =
+			&bundle->insns[i];
+
+		if (insn->opcode->mnemonic == TILE_OPC_INFO ||
+		    insn->opcode->mnemonic == TILE_OPC_INFOL) {
+			operands[num_ops++] = insn->operand_values[0];
+		}
+	}
+
+	return num_ops;
+}
+
+/** Does this bundle contain a jrp instruction, and if so, to which
+ * register is it jumping?
+ */
+static bool
+bt_has_jrp(const BacktraceBundle *bundle, int *target_reg)
+{
+	const struct tile_decoded_instruction *insn =
+		find_matching_insn(bundle, TILE_OPC_JRP, NULL, 0);
+	if (insn == NULL)
+		return false;
+
+	*target_reg = insn->operand_values[0];
+	return true;
+}
+
+/** Does this bundle modify the specified register in any way? */
+static bool
+bt_modifies_reg(const BacktraceBundle *bundle, int reg)
+{
+	int i, j;
+	for (i = 0; i < bundle->num_insns; i++) {
+		const struct tile_decoded_instruction *insn =
+			&bundle->insns[i];
+
+		if (insn->opcode->implicitly_written_register == reg)
+			return true;
+
+		for (j = 0; j < insn->opcode->num_operands; j++)
+			if (insn->operands[j]->is_dest_reg &&
+			    insn->operand_values[j] == reg)
+				return true;
+	}
+
+	return false;
+}
+
+/** Does this bundle modify sp? */
+static inline bool
+bt_modifies_sp(const BacktraceBundle *bundle)
+{
+	return bt_modifies_reg(bundle, TREG_SP);
+}
+
+/** Does this bundle modify lr? */
+static inline bool
+bt_modifies_lr(const BacktraceBundle *bundle)
+{
+	return bt_modifies_reg(bundle, TREG_LR);
+}
+
+/** Does this bundle contain the instruction 'move fp, sp'? */
+static inline bool
+bt_has_move_r52_sp(const BacktraceBundle *bundle)
+{
+	static const int vals[2] = { 52, TREG_SP };
+	return find_matching_insn(bundle, TILE_OPC_MOVE, vals, 2) != NULL;
+}
+
+/** Does this bundle contain the instruction 'sw sp, lr'? */
+static inline bool
+bt_has_sw_sp_lr(const BacktraceBundle *bundle)
+{
+	static const int vals[2] = { TREG_SP, TREG_LR };
+	return find_matching_insn(bundle, TILE_OPC_SW, vals, 2) != NULL;
+}
+
+/** Locates the caller's PC and SP for a program starting at the
+ * given address.
+ */
+static void
+find_caller_pc_and_caller_sp(CallerLocation *location,
+			     const VirtualAddress start_pc,
+			     BacktraceMemoryReader read_memory_func,
+			     void *read_memory_func_extra)
+{
+	/* Have we explicitly decided what the sp is,
+	 * rather than just the default?
+	 */
+	bool sp_determined = false;
+
+	/* Has any bundle seen so far modified lr? */
+	bool lr_modified = false;
+
+	/* Have we seen a move from sp to fp? */
+	bool sp_moved_to_r52 = false;
+
+	/* Have we seen a terminating bundle? */
+	bool seen_terminating_bundle = false;
+
+	/* Cut down on round-trip reading overhead by reading several
+	 * bundles at a time.
+	 */
+	tile_bundle_bits prefetched_bundles[32];
+	int num_bundles_prefetched = 0;
+	int next_bundle = 0;
+	VirtualAddress pc;
+
+	/* Default to assuming that the caller's sp is the current sp.
+	 * This is necessary to handle the case where we start backtracing
+	 * right at the end of the epilog.
+	 */
+	location->sp_location = SP_LOC_OFFSET;
+	location->sp_offset = 0;
+
+	/* Default to having no idea where the caller PC is. */
+	location->pc_location = PC_LOC_UNKNOWN;
+
+	/* Don't even try if the PC is not aligned. */
+	if (start_pc % TILE_BUNDLE_ALIGNMENT_IN_BYTES != 0)
+		return;
+
+	for (pc = start_pc;; pc += sizeof(tile_bundle_bits)) {
+
+		BacktraceBundle bundle;
+		int num_info_ops, info_operands[MAX_INFO_OPS_PER_BUNDLE];
+		int one_ago, jrp_reg;
+		bool has_jrp;
+
+		if (next_bundle >= num_bundles_prefetched) {
+			/* Prefetch some bytes, but don't cross a page
+			 * boundary since that might cause a read failure we
+			 * don't care about if we only need the first few
+			 * bytes. Note: we don't care what the actual page
+			 * size is; using the minimum possible page size will
+			 * prevent any problems.
+			 */
+			unsigned int bytes_to_prefetch = 4096 - (pc & 4095);
+			if (bytes_to_prefetch > sizeof prefetched_bundles)
+				bytes_to_prefetch = sizeof prefetched_bundles;
+
+			if (!read_memory_func(prefetched_bundles, pc,
+					      bytes_to_prefetch,
+					      read_memory_func_extra)) {
+				if (pc == start_pc) {
+					/* The program probably called a bad
+					 * address, such as a NULL pointer.
+					 * So treat this as if we are at the
+					 * start of the function prolog so the
+					 * backtrace will show how we got here.
+					 */
+					location->pc_location = PC_LOC_IN_LR;
+					return;
+				}
+
+				/* Unreadable address. Give up. */
+				break;
+			}
+
+			next_bundle = 0;
+			num_bundles_prefetched =
+				bytes_to_prefetch / sizeof(tile_bundle_bits);
+		}
+
+		/* Decode the next bundle. */
+		bundle.bits = prefetched_bundles[next_bundle++];
+		bundle.num_insns =
+			parse_insn_tile(bundle.bits, pc, bundle.insns);
+		num_info_ops = bt_get_info_ops(&bundle, info_operands);
+
+		/* First look at any one_ago info ops if they are interesting,
+		 * since they should shadow any non-one-ago info ops.
+		 */
+		for (one_ago = (pc != start_pc) ? 1 : 0;
+		     one_ago >= 0; one_ago--) {
+			int i;
+			for (i = 0; i < num_info_ops; i++) {
+				int info_operand = info_operands[i];
+				if (info_operand < CALLER_UNKNOWN_BASE)	{
+					/* Weird; reserved value, ignore it. */
+					continue;
+				}
+
+				/* Skip info ops which are not in the
+				 * "one_ago" mode we want right now.
+				 */
+				if (((info_operand & ONE_BUNDLE_AGO_FLAG) != 0)
+				    != (one_ago != 0))
+					continue;
+
+				/* Clear the flag to make later checking
+				 * easier. */
+				info_operand &= ~ONE_BUNDLE_AGO_FLAG;
+
+				/* Default to looking at PC_IN_LR_FLAG. */
+				if (info_operand & PC_IN_LR_FLAG)
+					location->pc_location =
+						PC_LOC_IN_LR;
+				else
+					location->pc_location =
+						PC_LOC_ON_STACK;
+
+				switch (info_operand) {
+				case CALLER_UNKNOWN_BASE:
+					location->pc_location = PC_LOC_UNKNOWN;
+					location->sp_location = SP_LOC_UNKNOWN;
+					return;
+
+				case CALLER_SP_IN_R52_BASE:
+				case CALLER_SP_IN_R52_BASE | PC_IN_LR_FLAG:
+					location->sp_location = SP_LOC_IN_R52;
+					return;
+
+				default:
+				{
+					const unsigned int val = info_operand
+						- CALLER_SP_OFFSET_BASE;
+					const unsigned int sp_offset =
+						(val >> NUM_INFO_OP_FLAGS) * 8;
+					if (sp_offset < 32768) {
+						/* This is a properly encoded
+						 * SP offset. */
+						location->sp_location =
+							SP_LOC_OFFSET;
+						location->sp_offset =
+							sp_offset;
+						return;
+					} else {
+						/* This looked like an SP
+						 * offset, but it's outside
+						 * the legal range, so this
+						 * must be an unrecognized
+						 * info operand.  Ignore it.
+						 */
+					}
+				}
+				break;
+				}
+			}
+		}
+
+		if (seen_terminating_bundle) {
+			/* We saw a terminating bundle during the previous
+			 * iteration, so we were only looking for an info op.
+			 */
+			break;
+		}
+
+		if (bundle.bits == 0) {
+			/* Wacky terminating bundle. Stop looping, and hope
+			 * we've already seen enough to find the caller.
+			 */
+			break;
+		}
+
+		/*
+		 * Try to determine caller's SP.
+		 */
+
+		if (!sp_determined) {
+			int adjust;
+			if (bt_has_addi_sp(&bundle, &adjust)) {
+				location->sp_location = SP_LOC_OFFSET;
+
+				if (adjust <= 0) {
+					/* We are in prolog about to adjust
+					 * SP. */
+					location->sp_offset = 0;
+				} else {
+					/* We are in epilog restoring SP. */
+					location->sp_offset = adjust;
+				}
+
+				sp_determined = true;
+			} else {
+				if (bt_has_move_r52_sp(&bundle)) {
+					/* Maybe in prolog, creating an
+					 * alloca-style frame.  But maybe in
+					 * the middle of a fixed-size frame
+					 * clobbering r52 with SP.
+					 */
+					sp_moved_to_r52 = true;
+				}
+
+				if (bt_modifies_sp(&bundle)) {
+					if (sp_moved_to_r52) {
+						/* We saw SP get saved into
+						 * r52 earlier (or now), which
+						 * must have been in the
+						 * prolog, so we now know that
+						 * SP is still holding the
+						 * caller's sp value.
+						 */
+						location->sp_location =
+							SP_LOC_OFFSET;
+						location->sp_offset = 0;
+					} else {
+						/* Someone must have saved
+						 * aside the caller's SP value
+						 * into r52, so r52 holds the
+						 * current value.
+						 */
+						location->sp_location =
+							SP_LOC_IN_R52;
+					}
+					sp_determined = true;
+				}
+			}
+		}
+
+		if (bt_has_iret(&bundle)) {
+			/* This is a terminating bundle. */
+			seen_terminating_bundle = true;
+			continue;
+		}
+
+		/*
+		 * Try to determine caller's PC.
+		 */
+
+		jrp_reg = -1;
+		has_jrp = bt_has_jrp(&bundle, &jrp_reg);
+		if (has_jrp)
+			seen_terminating_bundle = true;
+
+		if (location->pc_location == PC_LOC_UNKNOWN) {
+			if (has_jrp) {
+				if (jrp_reg == TREG_LR && !lr_modified) {
+					/* Looks like a leaf function, or else
+					 * lr is already restored. */
+					location->pc_location =
+						PC_LOC_IN_LR;
+				} else {
+					location->pc_location =
+						PC_LOC_ON_STACK;
+				}
+			} else if (bt_has_sw_sp_lr(&bundle)) {
+				/* In prolog, spilling initial lr to stack. */
+				location->pc_location = PC_LOC_IN_LR;
+			} else if (bt_modifies_lr(&bundle)) {
+				lr_modified = true;
+			}
+		}
+	}
+}
+
+void
+backtrace_init(BacktraceIterator *state,
+	       BacktraceMemoryReader read_memory_func,
+	       void *read_memory_func_extra,
+	       VirtualAddress pc, VirtualAddress lr,
+	       VirtualAddress sp, VirtualAddress r52)
+{
+	CallerLocation location;
+	VirtualAddress fp, initial_frame_caller_pc;
+
+	if (read_memory_func == NULL) {
+		read_memory_func = bt_read_memory;
+	}
+
+	/* Find out where we are in the initial frame. */
+	find_caller_pc_and_caller_sp(&location, pc,
+				     read_memory_func, read_memory_func_extra);
+
+	switch (location.sp_location) {
+	case SP_LOC_UNKNOWN:
+		/* Give up. */
+		fp = -1;
+		break;
+
+	case SP_LOC_IN_R52:
+		fp = r52;
+		break;
+
+	case SP_LOC_OFFSET:
+		fp = sp + location.sp_offset;
+		break;
+
+	default:
+		/* Give up. */
+		fp = -1;
+		break;
+	}
+
+	/* The frame pointer should theoretically be aligned mod 8. If
+	 * it's not even aligned mod 4 then something terrible happened
+	 * and we should mark it as invalid.
+	 */
+	if (fp % 4 != 0)
+		fp = -1;
+
+	/* -1 means "don't know initial_frame_caller_pc". */
+	initial_frame_caller_pc = -1;
+
+	switch (location.pc_location) {
+	case PC_LOC_UNKNOWN:
+		/* Give up. */
+		fp = -1;
+		break;
+
+	case PC_LOC_IN_LR:
+		if (lr == 0 || lr % TILE_BUNDLE_ALIGNMENT_IN_BYTES != 0) {
+			/* Give up. */
+			fp = -1;
+		} else {
+			initial_frame_caller_pc = lr;
+		}
+		break;
+
+	case PC_LOC_ON_STACK:
+		/* Leave initial_frame_caller_pc as -1,
+		 * meaning check the stack.
+		 */
+		break;
+
+	default:
+		/* Give up. */
+		fp = -1;
+		break;
+	}
+
+	state->pc = pc;
+	state->sp = sp;
+	state->fp = fp;
+	state->initial_frame_caller_pc = initial_frame_caller_pc;
+	state->read_memory_func = read_memory_func;
+	state->read_memory_func_extra = read_memory_func_extra;
+}
+
+bool
+backtrace_next(BacktraceIterator *state)
+{
+	VirtualAddress next_fp, next_pc, next_frame[2];
+
+	if (state->fp == -1) {
+		/* No parent frame. */
+		return false;
+	}
+
+	/* Try to read the frame linkage data chaining to the next function. */
+	if (!state->read_memory_func(&next_frame, state->fp, sizeof next_frame,
+				     state->read_memory_func_extra)) {
+		return false;
+	}
+
+	next_fp = next_frame[1];
+	if (next_fp % 4 != 0) {
+		/* Caller's frame pointer is suspect, so give up.
+		 * Technically it should be aligned mod 8, but we will
+		 * be forgiving here.
+		 */
+		return false;
+	}
+
+	if (state->initial_frame_caller_pc != -1) {
+		/* We must be in the initial stack frame and already know the
+		 * caller PC.
+		 */
+		next_pc = state->initial_frame_caller_pc;
+
+		/* Force reading stack next time, in case we were in the
+		 * initial frame.  We don't do this above just to paranoidly
+		 * avoid changing the struct at all when we return false.
+		 */
+		state->initial_frame_caller_pc = -1;
+	} else {
+		/* Get the caller PC from the frame linkage area. */
+		next_pc = next_frame[0];
+		if (next_pc == 0 ||
+		    next_pc % TILE_BUNDLE_ALIGNMENT_IN_BYTES != 0) {
+			/* The PC is suspect, so give up. */
+			return false;
+		}
+	}
+
+	/* Update state to become the caller's stack frame. */
+	state->pc = next_pc;
+	state->sp = state->fp;
+	state->fp = next_fp;
+
+	return true;
+}
+
+#else /* TILE_CHIP < 10 */
+
+void
+backtrace_init(BacktraceIterator *state,
+	       BacktraceMemoryReader read_memory_func,
+	       void *read_memory_func_extra,
+	       VirtualAddress pc, VirtualAddress lr,
+	       VirtualAddress sp, VirtualAddress r52)
+{
+	state->pc = pc;
+	state->sp = sp;
+	state->fp = -1;
+	state->initial_frame_caller_pc = -1;
+	state->read_memory_func = read_memory_func;
+	state->read_memory_func_extra = read_memory_func_extra;
+}
+
+bool backtrace_next(BacktraceIterator *state) { return false; }
+
+#endif /* TILE_CHIP < 10 */
diff --git a/arch/tile/kernel/compat.c b/arch/tile/kernel/compat.c
new file mode 100644
index 0000000..a374c99
--- /dev/null
+++ b/arch/tile/kernel/compat.c
@@ -0,0 +1,183 @@
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
+/* Adjust unistd.h to provide 32-bit numbers and functions. */
+#define __SYSCALL_COMPAT
+
+#include <linux/compat.h>
+#include <linux/msg.h>
+#include <linux/syscalls.h>
+#include <linux/kdev_t.h>
+#include <linux/fs.h>
+#include <linux/fcntl.h>
+#include <linux/smp_lock.h>
+#include <linux/uaccess.h>
+#include <linux/signal.h>
+#include <asm/syscalls.h>
+
+/*
+ * Syscalls that take 64-bit numbers traditionally take them in 32-bit
+ * "high" and "low" value parts on 32-bit architectures.
+ * In principle, one could imagine passing some register arguments as
+ * fully 64-bit on TILE-Gx in 32-bit mode, but it seems easier to
+ * adapt the usual convention.
+ */
+
+long compat_sys_truncate64(char __user *filename, u32 dummy, u32 low, u32 high)
+{
+	return sys_truncate(filename, ((loff_t)high << 32) | low);
+}
+
+long compat_sys_ftruncate64(unsigned int fd, u32 dummy, u32 low, u32 high)
+{
+	return sys_ftruncate(fd, ((loff_t)high << 32) | low);
+}
+
+long compat_sys_pread64(unsigned int fd, char __user *ubuf, size_t count,
+			u32 dummy, u32 low, u32 high)
+{
+	return sys_pread64(fd, ubuf, count, ((loff_t)high << 32) | low);
+}
+
+long compat_sys_pwrite64(unsigned int fd, char __user *ubuf, size_t count,
+			 u32 dummy, u32 low, u32 high)
+{
+	return sys_pwrite64(fd, ubuf, count, ((loff_t)high << 32) | low);
+}
+
+long compat_sys_lookup_dcookie(u32 low, u32 high, char __user *buf, size_t len)
+{
+	return sys_lookup_dcookie(((loff_t)high << 32) | low, buf, len);
+}
+
+long compat_sys_sync_file_range2(int fd, unsigned int flags,
+				 u32 offset_lo, u32 offset_hi,
+				 u32 nbytes_lo, u32 nbytes_hi)
+{
+	return sys_sync_file_range(fd, ((loff_t)offset_hi << 32) | offset_lo,
+				   ((loff_t)nbytes_hi << 32) | nbytes_lo,
+				   flags);
+}
+
+long compat_sys_fallocate(int fd, int mode,
+			  u32 offset_lo, u32 offset_hi,
+			  u32 len_lo, u32 len_hi)
+{
+	return sys_fallocate(fd, mode, ((loff_t)offset_hi << 32) | offset_lo,
+			     ((loff_t)len_hi << 32) | len_lo);
+}
+
+
+
+long compat_sys_sched_rr_get_interval(compat_pid_t pid,
+				      struct compat_timespec __user *interval)
+{
+	struct timespec t;
+	int ret;
+	mm_segment_t old_fs = get_fs();
+
+	set_fs(KERNEL_DS);
+	ret = sys_sched_rr_get_interval(pid, (struct timespec __user *)&t);
+	set_fs(old_fs);
+	if (put_compat_timespec(&t, interval))
+		return -EFAULT;
+	return ret;
+}
+
+ssize_t compat_sys_sendfile(int out_fd, int in_fd, compat_off_t __user *offset,
+			    size_t count)
+{
+	mm_segment_t old_fs = get_fs();
+	int ret;
+	off_t of;
+
+	if (offset && get_user(of, offset))
+		return -EFAULT;
+
+	set_fs(KERNEL_DS);
+	ret = sys_sendfile(out_fd, in_fd, offset ? (off_t __user *)&of : NULL,
+			   count);
+	set_fs(old_fs);
+
+	if (offset && put_user(of, offset))
+		return -EFAULT;
+	return ret;
+}
+
+
+/*
+ * The usual compat_sys_msgsnd() and _msgrcv() seem to be assuming
+ * some different calling convention than our normal 32-bit tile code.
+ */
+
+/* Already defined in ipc/compat.c, but we need it here. */
+struct compat_msgbuf {
+	compat_long_t mtype;
+	char mtext[1];
+};
+
+long tile_compat_sys_msgsnd(int msqid,
+			    struct compat_msgbuf __user *msgp,
+			    size_t msgsz, int msgflg)
+{
+	compat_long_t mtype;
+
+	if (get_user(mtype, &msgp->mtype))
+		return -EFAULT;
+	return do_msgsnd(msqid, mtype, msgp->mtext, msgsz, msgflg);
+}
+
+long tile_compat_sys_msgrcv(int msqid,
+			    struct compat_msgbuf __user *msgp,
+			    size_t msgsz, long msgtyp, int msgflg)
+{
+	long err, mtype;
+
+	err =  do_msgrcv(msqid, &mtype, msgp->mtext, msgsz, msgtyp, msgflg);
+	if (err < 0)
+		goto out;
+
+	if (put_user(mtype, &msgp->mtype))
+		err = -EFAULT;
+ out:
+	return err;
+}
+
+/* Provide the compat syscall number to call mapping. */
+#undef __SYSCALL
+#define __SYSCALL(nr, call) [nr] = (compat_##call),
+
+/* The generic versions of these don't work for Tile. */
+#define compat_sys_msgrcv tile_compat_sys_msgrcv
+#define compat_sys_msgsnd tile_compat_sys_msgsnd
+
+/* See comments in sys.c */
+#define compat_sys_fadvise64 sys32_fadvise64
+#define compat_sys_fadvise64_64 sys32_fadvise64_64
+#define compat_sys_readahead sys32_readahead
+#define compat_sys_sync_file_range compat_sys_sync_file_range2
+
+/* The native 64-bit "struct stat" matches the 32-bit "struct stat64". */
+#define compat_sys_stat64 sys_newstat
+#define compat_sys_lstat64 sys_newlstat
+#define compat_sys_fstat64 sys_newfstat
+#define compat_sys_fstatat64 sys_newfstatat
+
+/* Pass full 64-bit values through ptrace. */
+#define compat_sys_ptrace tile_compat_sys_ptrace
+
+void *compat_sys_call_table[__NR_syscalls] = {
+	[0 ... __NR_syscalls-1] = sys_ni_syscall,
+#include <asm/unistd.h>
+};
diff --git a/arch/tile/kernel/compat_signal.c b/arch/tile/kernel/compat_signal.c
new file mode 100644
index 0000000..9fa4ba8
--- /dev/null
+++ b/arch/tile/kernel/compat_signal.c
@@ -0,0 +1,433 @@
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
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/smp.h>
+#include <linux/smp_lock.h>
+#include <linux/kernel.h>
+#include <linux/signal.h>
+#include <linux/errno.h>
+#include <linux/wait.h>
+#include <linux/unistd.h>
+#include <linux/stddef.h>
+#include <linux/personality.h>
+#include <linux/suspend.h>
+#include <linux/ptrace.h>
+#include <linux/elf.h>
+#include <linux/compat.h>
+#include <linux/syscalls.h>
+#include <linux/uaccess.h>
+#include <asm/processor.h>
+#include <asm/ucontext.h>
+#include <asm/sigframe.h>
+#include <arch/interrupts.h>
+
+struct compat_sigaction {
+	compat_uptr_t sa_handler;
+	compat_ulong_t sa_flags;
+	compat_uptr_t sa_restorer;
+	sigset_t sa_mask;		/* mask last for extensibility */
+};
+
+struct compat_sigaltstack {
+	compat_uptr_t ss_sp;
+	int ss_flags;
+	compat_size_t ss_size;
+};
+
+struct compat_ucontext {
+	compat_ulong_t	  uc_flags;
+	compat_uptr_t     uc_link;
+	struct compat_sigaltstack	  uc_stack;
+	struct sigcontext uc_mcontext;
+	sigset_t	  uc_sigmask;	/* mask last for extensibility */
+};
+
+struct compat_siginfo {
+	int si_signo;
+	int si_errno;
+	int si_code;
+
+	union {
+		int _pad[SI_PAD_SIZE];
+
+		/* kill() */
+		struct {
+			unsigned int _pid;	/* sender's pid */
+			unsigned int _uid;	/* sender's uid */
+		} _kill;
+
+		/* POSIX.1b timers */
+		struct {
+			compat_timer_t _tid;	/* timer id */
+			int _overrun;		/* overrun count */
+			compat_sigval_t _sigval;	/* same as below */
+			int _sys_private;	/* not to be passed to user */
+			int _overrun_incr;	/* amount to add to overrun */
+		} _timer;
+
+		/* POSIX.1b signals */
+		struct {
+			unsigned int _pid;	/* sender's pid */
+			unsigned int _uid;	/* sender's uid */
+			compat_sigval_t _sigval;
+		} _rt;
+
+		/* SIGCHLD */
+		struct {
+			unsigned int _pid;	/* which child */
+			unsigned int _uid;	/* sender's uid */
+			int _status;		/* exit code */
+			compat_clock_t _utime;
+			compat_clock_t _stime;
+		} _sigchld;
+
+		/* SIGILL, SIGFPE, SIGSEGV, SIGBUS */
+		struct {
+			unsigned int _addr;	/* faulting insn/memory ref. */
+#ifdef __ARCH_SI_TRAPNO
+			int _trapno;	/* TRAP # which caused the signal */
+#endif
+		} _sigfault;
+
+		/* SIGPOLL */
+		struct {
+			int _band;	/* POLL_IN, POLL_OUT, POLL_MSG */
+			int _fd;
+		} _sigpoll;
+	} _sifields;
+};
+
+struct compat_rt_sigframe {
+	unsigned char save_area[C_ABI_SAVE_AREA_SIZE]; /* caller save area */
+	struct compat_siginfo info;
+	struct compat_ucontext uc;
+};
+
+#define _BLOCKABLE (~(sigmask(SIGKILL) | sigmask(SIGSTOP)))
+
+long compat_sys_rt_sigaction(int sig, struct compat_sigaction __user *act,
+			     struct compat_sigaction __user *oact,
+			     size_t sigsetsize)
+{
+	struct k_sigaction new_sa, old_sa;
+	int ret = -EINVAL;
+
+	/* XXX: Don't preclude handling different sized sigset_t's.  */
+	if (sigsetsize != sizeof(sigset_t))
+		goto out;
+
+	if (act) {
+		compat_uptr_t handler, restorer;
+
+		if (!access_ok(VERIFY_READ, act, sizeof(*act)) ||
+		    __get_user(handler, &act->sa_handler) ||
+		    __get_user(new_sa.sa.sa_flags, &act->sa_flags) ||
+		    __get_user(restorer, &act->sa_restorer) ||
+		    __copy_from_user(&new_sa.sa.sa_mask, &act->sa_mask,
+				     sizeof(sigset_t)))
+			return -EFAULT;
+		new_sa.sa.sa_handler = compat_ptr(handler);
+		new_sa.sa.sa_restorer = compat_ptr(restorer);
+	}
+
+	ret = do_sigaction(sig, act ? &new_sa : NULL, oact ? &old_sa : NULL);
+
+	if (!ret && oact) {
+		if (!access_ok(VERIFY_WRITE, oact, sizeof(*oact)) ||
+		    __put_user(ptr_to_compat(old_sa.sa.sa_handler),
+			       &oact->sa_handler) ||
+		    __put_user(ptr_to_compat(old_sa.sa.sa_restorer),
+			       &oact->sa_restorer) ||
+		    __put_user(old_sa.sa.sa_flags, &oact->sa_flags) ||
+		    __copy_to_user(&oact->sa_mask, &old_sa.sa.sa_mask,
+				   sizeof(sigset_t)))
+			return -EFAULT;
+	}
+out:
+	return ret;
+}
+
+long compat_sys_rt_sigqueueinfo(int pid, int sig,
+				struct compat_siginfo __user *uinfo)
+{
+	siginfo_t info;
+	int ret;
+	mm_segment_t old_fs = get_fs();
+
+	if (copy_siginfo_from_user32(&info, uinfo))
+		return -EFAULT;
+	set_fs(KERNEL_DS);
+	ret = sys_rt_sigqueueinfo(pid, sig, (siginfo_t __user *)&info);
+	set_fs(old_fs);
+	return ret;
+}
+
+int copy_siginfo_to_user32(struct compat_siginfo __user *to, siginfo_t *from)
+{
+	int err;
+
+	if (!access_ok(VERIFY_WRITE, to, sizeof(struct compat_siginfo)))
+		return -EFAULT;
+
+	/* If you change siginfo_t structure, please make sure that
+	   this code is fixed accordingly.
+	   It should never copy any pad contained in the structure
+	   to avoid security leaks, but must copy the generic
+	   3 ints plus the relevant union member.  */
+	err = __put_user(from->si_signo, &to->si_signo);
+	err |= __put_user(from->si_errno, &to->si_errno);
+	err |= __put_user((short)from->si_code, &to->si_code);
+
+	if (from->si_code < 0) {
+		err |= __put_user(from->si_pid, &to->si_pid);
+		err |= __put_user(from->si_uid, &to->si_uid);
+		err |= __put_user(ptr_to_compat(from->si_ptr), &to->si_ptr);
+	} else {
+		/*
+		 * First 32bits of unions are always present:
+		 * si_pid === si_band === si_tid === si_addr(LS half)
+		 */
+		err |= __put_user(from->_sifields._pad[0],
+				  &to->_sifields._pad[0]);
+		switch (from->si_code >> 16) {
+		case __SI_FAULT >> 16:
+			break;
+		case __SI_CHLD >> 16:
+			err |= __put_user(from->si_utime, &to->si_utime);
+			err |= __put_user(from->si_stime, &to->si_stime);
+			err |= __put_user(from->si_status, &to->si_status);
+			/* FALL THROUGH */
+		default:
+		case __SI_KILL >> 16:
+			err |= __put_user(from->si_uid, &to->si_uid);
+			break;
+		case __SI_POLL >> 16:
+			err |= __put_user(from->si_fd, &to->si_fd);
+			break;
+		case __SI_TIMER >> 16:
+			err |= __put_user(from->si_overrun, &to->si_overrun);
+			err |= __put_user(ptr_to_compat(from->si_ptr),
+					  &to->si_ptr);
+			break;
+			 /* This is not generated by the kernel as of now.  */
+		case __SI_RT >> 16:
+		case __SI_MESGQ >> 16:
+			err |= __put_user(from->si_uid, &to->si_uid);
+			err |= __put_user(from->si_int, &to->si_int);
+			break;
+		}
+	}
+	return err;
+}
+
+int copy_siginfo_from_user32(siginfo_t *to, struct compat_siginfo __user *from)
+{
+	int err;
+	u32 ptr32;
+
+	if (!access_ok(VERIFY_READ, from, sizeof(struct compat_siginfo)))
+		return -EFAULT;
+
+	err = __get_user(to->si_signo, &from->si_signo);
+	err |= __get_user(to->si_errno, &from->si_errno);
+	err |= __get_user(to->si_code, &from->si_code);
+
+	err |= __get_user(to->si_pid, &from->si_pid);
+	err |= __get_user(to->si_uid, &from->si_uid);
+	err |= __get_user(ptr32, &from->si_ptr);
+	to->si_ptr = compat_ptr(ptr32);
+
+	return err;
+}
+
+long _compat_sys_sigaltstack(const struct compat_sigaltstack __user *uss_ptr,
+			     struct compat_sigaltstack __user *uoss_ptr,
+			     struct pt_regs *regs)
+{
+	stack_t uss, uoss;
+	int ret;
+	mm_segment_t seg;
+
+	if (uss_ptr) {
+		u32 ptr;
+
+		memset(&uss, 0, sizeof(stack_t));
+		if (!access_ok(VERIFY_READ, uss_ptr, sizeof(*uss_ptr)) ||
+			    __get_user(ptr, &uss_ptr->ss_sp) ||
+			    __get_user(uss.ss_flags, &uss_ptr->ss_flags) ||
+			    __get_user(uss.ss_size, &uss_ptr->ss_size))
+			return -EFAULT;
+		uss.ss_sp = compat_ptr(ptr);
+	}
+	seg = get_fs();
+	set_fs(KERNEL_DS);
+	ret = do_sigaltstack(uss_ptr ? &uss : NULL, &uoss,
+			     (unsigned long)compat_ptr(regs->sp));
+	set_fs(seg);
+	if (ret >= 0 && uoss_ptr)  {
+		if (!access_ok(VERIFY_WRITE, uoss_ptr, sizeof(*uoss_ptr)) ||
+		    __put_user(ptr_to_compat(uoss.ss_sp), &uoss_ptr->ss_sp) ||
+		    __put_user(uoss.ss_flags, &uoss_ptr->ss_flags) ||
+		    __put_user(uoss.ss_size, &uoss_ptr->ss_size))
+			ret = -EFAULT;
+	}
+	return ret;
+}
+
+long _compat_sys_rt_sigreturn(struct pt_regs *regs)
+{
+	struct compat_rt_sigframe __user *frame =
+		(struct compat_rt_sigframe __user *) compat_ptr(regs->sp);
+	sigset_t set;
+	long r0;
+
+	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
+		goto badframe;
+	if (__copy_from_user(&set, &frame->uc.uc_sigmask, sizeof(set)))
+		goto badframe;
+
+	sigdelsetmask(&set, ~_BLOCKABLE);
+	spin_lock_irq(&current->sighand->siglock);
+	current->blocked = set;
+	recalc_sigpending();
+	spin_unlock_irq(&current->sighand->siglock);
+
+	if (restore_sigcontext(regs, &frame->uc.uc_mcontext, &r0))
+		goto badframe;
+
+	if (_compat_sys_sigaltstack(&frame->uc.uc_stack, NULL, regs) != 0)
+		goto badframe;
+
+	return r0;
+
+badframe:
+	force_sig(SIGSEGV, current);
+	return 0;
+}
+
+/*
+ * Determine which stack to use..
+ */
+static inline void __user *compat_get_sigframe(struct k_sigaction *ka,
+					       struct pt_regs *regs,
+					       size_t frame_size)
+{
+	unsigned long sp;
+
+	/* Default to using normal stack */
+	sp = (unsigned long)compat_ptr(regs->sp);
+
+	/*
+	 * If we are on the alternate signal stack and would overflow
+	 * it, don't.  Return an always-bogus address instead so we
+	 * will die with SIGSEGV.
+	 */
+	if (on_sig_stack(sp) && !likely(on_sig_stack(sp - frame_size)))
+		return (void __user *) -1L;
+
+	/* This is the X/Open sanctioned signal stack switching.  */
+	if (ka->sa.sa_flags & SA_ONSTACK) {
+		if (sas_ss_flags(sp) == 0)
+			sp = current->sas_ss_sp + current->sas_ss_size;
+	}
+
+	sp -= frame_size;
+	/*
+	 * Align the stack pointer according to the TILE ABI,
+	 * i.e. so that on function entry (sp & 15) == 0.
+	 */
+	sp &= -16UL;
+	return (void __user *) sp;
+}
+
+int compat_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
+			  sigset_t *set, struct pt_regs *regs)
+{
+	unsigned long restorer;
+	struct compat_rt_sigframe __user *frame;
+	int err = 0;
+	int usig;
+
+	frame = compat_get_sigframe(ka, regs, sizeof(*frame));
+
+	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
+		goto give_sigsegv;
+
+	usig = current_thread_info()->exec_domain
+		&& current_thread_info()->exec_domain->signal_invmap
+		&& sig < 32
+		? current_thread_info()->exec_domain->signal_invmap[sig]
+		: sig;
+
+	/* Always write at least the signal number for the stack backtracer. */
+	if (ka->sa.sa_flags & SA_SIGINFO) {
+		/* At sigreturn time, restore the callee-save registers too. */
+		err |= copy_siginfo_to_user32(&frame->info, info);
+		regs->flags |= PT_FLAGS_RESTORE_REGS;
+	} else {
+		err |= __put_user(info->si_signo, &frame->info.si_signo);
+	}
+
+	/* Create the ucontext.  */
+	err |= __clear_user(&frame->save_area, sizeof(frame->save_area));
+	err |= __put_user(0, &frame->uc.uc_flags);
+	err |= __put_user(0, &frame->uc.uc_link);
+	err |= __put_user(ptr_to_compat((void *)(current->sas_ss_sp)),
+			  &frame->uc.uc_stack.ss_sp);
+	err |= __put_user(sas_ss_flags(regs->sp),
+			  &frame->uc.uc_stack.ss_flags);
+	err |= __put_user(current->sas_ss_size, &frame->uc.uc_stack.ss_size);
+	err |= setup_sigcontext(&frame->uc.uc_mcontext, regs);
+	err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
+	if (err)
+		goto give_sigsegv;
+
+	restorer = VDSO_BASE;
+	if (ka->sa.sa_flags & SA_RESTORER)
+		restorer = ptr_to_compat_reg(ka->sa.sa_restorer);
+
+	/*
+	 * Set up registers for signal handler.
+	 * Registers that we don't modify keep the value they had from
+	 * user-space at the time we took the signal.
+	 */
+	regs->pc = ptr_to_compat_reg(ka->sa.sa_handler);
+	regs->ex1 = PL_ICS_EX1(USER_PL, 1); /* set crit sec in handler */
+	regs->sp = ptr_to_compat_reg(frame);
+	regs->lr = restorer;
+	regs->regs[0] = (unsigned long) usig;
+
+	if (ka->sa.sa_flags & SA_SIGINFO) {
+		/* Need extra arguments, so mark to restore caller-saves. */
+		regs->regs[1] = ptr_to_compat_reg(&frame->info);
+		regs->regs[2] = ptr_to_compat_reg(&frame->uc);
+		regs->flags |= PT_FLAGS_CALLER_SAVES;
+	}
+
+	/*
+	 * Notify any tracer that was single-stepping it.
+	 * The tracer may want to single-step inside the
+	 * handler too.
+	 */
+	if (test_thread_flag(TIF_SINGLESTEP))
+		ptrace_notify(SIGTRAP);
+
+	return 0;
+
+give_sigsegv:
+	force_sigsegv(sig, current);
+	return -EFAULT;
+}
diff --git a/arch/tile/kernel/early_printk.c b/arch/tile/kernel/early_printk.c
new file mode 100644
index 0000000..e44d441
--- /dev/null
+++ b/arch/tile/kernel/early_printk.c
@@ -0,0 +1,109 @@
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
+#include <linux/console.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/string.h>
+#include <asm/setup.h>
+#include <hv/hypervisor.h>
+
+static void early_hv_write(struct console *con, const char *s, unsigned n)
+{
+	hv_console_write((HV_VirtAddr) s, n);
+}
+
+static struct console early_hv_console = {
+	.name =		"earlyhv",
+	.write =	early_hv_write,
+	.flags =	CON_PRINTBUFFER,
+	.index =	-1,
+};
+
+/* Direct interface for emergencies */
+struct console *early_console = &early_hv_console;
+static int early_console_initialized;
+static int early_console_complete;
+
+static void early_vprintk(const char *fmt, va_list ap)
+{
+	char buf[512];
+	int n = vscnprintf(buf, sizeof(buf), fmt, ap);
+	early_console->write(early_console, buf, n);
+}
+
+void early_printk(const char *fmt, ...)
+{
+	va_list ap;
+	va_start(ap, fmt);
+	early_vprintk(fmt, ap);
+	va_end(ap);
+}
+
+void early_panic(const char *fmt, ...)
+{
+	va_list ap;
+	raw_local_irq_disable_all();
+	va_start(ap, fmt);
+	early_printk("Kernel panic - not syncing: ");
+	early_vprintk(fmt, ap);
+	early_console->write(early_console, "\n", 1);
+	va_end(ap);
+	dump_stack();
+	hv_halt();
+}
+
+static int __initdata keep_early;
+
+static int __init setup_early_printk(char *str)
+{
+	if (early_console_initialized)
+		return 1;
+
+	if (str != NULL && strncmp(str, "keep", 4) == 0)
+		keep_early = 1;
+
+	early_console = &early_hv_console;
+	early_console_initialized = 1;
+	register_console(early_console);
+
+	return 0;
+}
+
+void __init disable_early_printk(void)
+{
+	early_console_complete = 1;
+	if (!early_console_initialized || !early_console)
+		return;
+	if (!keep_early) {
+		early_printk("disabling early console\n");
+		unregister_console(early_console);
+		early_console_initialized = 0;
+	} else {
+		early_printk("keeping early console\n");
+	}
+}
+
+void warn_early_printk(void)
+{
+	if (early_console_complete || early_console_initialized)
+		return;
+	early_printk("\
+Machine shutting down before console output is fully initialized.\n\
+You may wish to reboot and add the option 'earlyprintk' to your\n\
+boot command line to see any diagnostic early console output.\n\
+");
+}
+
+early_param("earlyprintk", setup_early_printk);
diff --git a/arch/tile/kernel/entry.S b/arch/tile/kernel/entry.S
new file mode 100644
index 0000000..136261f
--- /dev/null
+++ b/arch/tile/kernel/entry.S
@@ -0,0 +1,141 @@
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
+#include <linux/linkage.h>
+#include <arch/abi.h>
+#include <asm/unistd.h>
+#include <asm/irqflags.h>
+
+#ifdef __tilegx__
+#define bnzt bnezt
+#endif
+
+STD_ENTRY(current_text_addr)
+	{ move r0, lr; jrp lr }
+	STD_ENDPROC(current_text_addr)
+
+STD_ENTRY(_sim_syscall)
+	/*
+	 * Wait for r0-r9 to be ready (and lr on the off chance we
+	 * want the syscall to locate its caller), then make a magic
+	 * simulator syscall.
+	 *
+	 * We carefully stall until the registers are readable in case they
+	 * are the target of a slow load, etc. so that tile-sim will
+	 * definitely be able to read all of them inside the magic syscall.
+	 *
+	 * Technically this is wrong for r3-r9 and lr, since an interrupt
+	 * could come in and restore the registers with a slow load right
+	 * before executing the mtspr. We may need to modify tile-sim to
+	 * explicitly stall for this case, but we do not yet have
+	 * a way to implement such a stall.
+	 */
+	{ and zero, lr, r9 ; and zero, r8, r7 }
+	{ and zero, r6, r5 ; and zero, r4, r3 }
+	{ and zero, r2, r1 ; mtspr SIM_CONTROL, r0 }
+	{ jrp lr }
+	STD_ENDPROC(_sim_syscall)
+
+/*
+ * Implement execve().  The i386 code has a note that forking from kernel
+ * space results in no copy on write until the execve, so we should be
+ * careful not to write to the stack here.
+ */
+STD_ENTRY(kernel_execve)
+	moveli TREG_SYSCALL_NR_NAME, __NR_execve
+	swint1
+	jrp lr
+	STD_ENDPROC(kernel_execve)
+
+/* Delay a fixed number of cycles. */
+STD_ENTRY(__delay)
+	{ addi r0, r0, -1; bnzt r0, . }
+	jrp lr
+	STD_ENDPROC(__delay)
+
+/*
+ * We don't run this function directly, but instead copy it to a page
+ * we map into every user process.  See vdso_setup().
+ *
+ * Note that libc has a copy of this function that it uses to compare
+ * against the PC when a stack backtrace ends, so if this code is
+ * changed, the libc implementation(s) should also be updated.
+ */
+	.pushsection .data
+ENTRY(__rt_sigreturn)
+	moveli TREG_SYSCALL_NR_NAME,__NR_rt_sigreturn
+	swint1
+	ENDPROC(__rt_sigreturn)
+	ENTRY(__rt_sigreturn_end)
+	.popsection
+
+STD_ENTRY(dump_stack)
+	{ move r2, lr; lnk r1 }
+	{ move r4, r52; addli r1, r1, dump_stack - . }
+	{ move r3, sp; j _dump_stack }
+	jrp lr   /* keep backtracer happy */
+	STD_ENDPROC(dump_stack)
+
+STD_ENTRY(KBacktraceIterator_init_current)
+	{ move r2, lr; lnk r1 }
+	{ move r4, r52; addli r1, r1, KBacktraceIterator_init_current - . }
+	{ move r3, sp; j _KBacktraceIterator_init_current }
+	jrp lr   /* keep backtracer happy */
+	STD_ENDPROC(KBacktraceIterator_init_current)
+
+/*
+ * Reset our stack to r1/r2 (sp and ksp0+cpu respectively), then
+ * free the old stack (passed in r0) and re-invoke cpu_idle().
+ * We update sp and ksp0 simultaneously to avoid backtracer warnings.
+ */
+STD_ENTRY(cpu_idle_on_new_stack)
+	{
+	 move sp, r1
+	 mtspr SYSTEM_SAVE_1_0, r2
+	}
+	jal free_thread_info
+	j cpu_idle
+	STD_ENDPROC(cpu_idle_on_new_stack)
+
+/* Loop forever on a nap during SMP boot. */
+STD_ENTRY(smp_nap)
+	nap
+	j smp_nap /* we are not architecturally guaranteed not to exit nap */
+	jrp lr    /* clue in the backtracer */
+	STD_ENDPROC(smp_nap)
+
+/*
+ * Enable interrupts racelessly and then nap until interrupted.
+ * This function's _cpu_idle_nap address is special; see intvec.S.
+ * When interrupted at _cpu_idle_nap, we bump the PC forward 8, and
+ * as a result return to the function that called _cpu_idle().
+ */
+STD_ENTRY(_cpu_idle)
+	{
+	 lnk r0
+	 movei r1, 1
+	}
+	{
+	 addli r0, r0, _cpu_idle_nap - .
+	 mtspr INTERRUPT_CRITICAL_SECTION, r1
+	}
+	IRQ_ENABLE(r2, r3)         /* unmask, but still with ICS set */
+	mtspr EX_CONTEXT_1_1, r1   /* PL1, ICS clear */
+	mtspr EX_CONTEXT_1_0, r0
+	iret
+	.global _cpu_idle_nap
+_cpu_idle_nap:
+	nap
+	jrp lr
+	STD_ENDPROC(_cpu_idle)
diff --git a/arch/tile/kernel/head_32.S b/arch/tile/kernel/head_32.S
new file mode 100644
index 0000000..2b4f6c0
--- /dev/null
+++ b/arch/tile/kernel/head_32.S
@@ -0,0 +1,180 @@
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
+ *
+ * TILE startup code.
+ */
+
+#include <linux/linkage.h>
+#include <linux/init.h>
+#include <asm/page.h>
+#include <asm/pgtable.h>
+#include <asm/thread_info.h>
+#include <asm/processor.h>
+#include <asm/asm-offsets.h>
+#include <hv/hypervisor.h>
+#include <arch/chip.h>
+
+/*
+ * This module contains the entry code for kernel images. It performs the
+ * minimal setup needed to call the generic C routines.
+ */
+
+	__HEAD
+ENTRY(_start)
+	/* Notify the hypervisor of what version of the API we want */
+	{
+	  movei r1, TILE_CHIP
+	  movei r2, TILE_CHIP_REV
+	}
+	{
+	  moveli r0, _HV_VERSION
+	  jal hv_init
+	}
+	/* Get a reasonable default ASID in r0 */
+	{
+	  move r0, zero
+	  jal hv_inquire_asid
+	}
+	/* Install the default page table */
+	{
+	  moveli r6, lo16(swapper_pgprot - PAGE_OFFSET)
+	  move r4, r0     /* use starting ASID of range for this page table */
+	}
+	{
+	  moveli r0, lo16(swapper_pg_dir - PAGE_OFFSET)
+	  auli r6, r6, ha16(swapper_pgprot - PAGE_OFFSET)
+	}
+	{
+	  lw r2, r6
+	  addi r6, r6, 4
+	}
+	{
+	  lw r3, r6
+	  auli r0, r0, ha16(swapper_pg_dir - PAGE_OFFSET)
+	}
+	{
+	  inv r6
+	  move r1, zero   /* high 32 bits of CPA is zero */
+	}
+	{
+	  moveli lr, lo16(1f)
+	  move r5, zero
+	}
+	{
+	  auli lr, lr, ha16(1f)
+	  j hv_install_context
+	}
+1:
+
+	/* Get our processor number and save it away in SAVE_1_0. */
+	jal hv_inquire_topology
+	mulll_uu r4, r1, r2        /* r1 == y, r2 == width */
+	add r4, r4, r0             /* r0 == x, so r4 == cpu == y*width + x */
+
+#ifdef CONFIG_SMP
+	/*
+	 * Load up our per-cpu offset.  When the first (master) tile
+	 * boots, this value is still zero, so we will load boot_pc
+	 * with start_kernel, and boot_sp with init_stack + THREAD_SIZE.
+	 * The master tile initializes the per-cpu offset array, so that
+	 * when subsequent (secondary) tiles boot, they will instead load
+	 * from their per-cpu versions of boot_sp and boot_pc.
+	 */
+	moveli r5, lo16(__per_cpu_offset)
+	auli r5, r5, ha16(__per_cpu_offset)
+	s2a r5, r4, r5
+	lw r5, r5
+	bnz r5, 1f
+
+	/*
+	 * Save the width and height to the smp_topology variable
+	 * for later use.
+	 */
+	moveli r0, lo16(smp_topology + HV_TOPOLOGY_WIDTH_OFFSET)
+	auli r0, r0, ha16(smp_topology + HV_TOPOLOGY_WIDTH_OFFSET)
+	{
+	  sw r0, r2
+	  addi r0, r0, (HV_TOPOLOGY_HEIGHT_OFFSET - HV_TOPOLOGY_WIDTH_OFFSET)
+	}
+	sw r0, r3
+1:
+#else
+	move r5, zero
+#endif
+
+	/* Load and go with the correct pc and sp. */
+	{
+	  addli r1, r5, lo16(boot_sp)
+	  addli r0, r5, lo16(boot_pc)
+	}
+	{
+	  auli r1, r1, ha16(boot_sp)
+	  auli r0, r0, ha16(boot_pc)
+	}
+	lw r0, r0
+	lw sp, r1
+	or r4, sp, r4
+	mtspr SYSTEM_SAVE_1_0, r4  /* save ksp0 + cpu */
+	addi sp, sp, -STACK_TOP_DELTA
+	{
+	  move lr, zero   /* stop backtraces in the called function */
+	  jr r0
+	}
+	ENDPROC(_start)
+
+.section ".bss.page_aligned","w"
+	.align PAGE_SIZE
+ENTRY(empty_zero_page)
+	.fill PAGE_SIZE,1,0
+	END(empty_zero_page)
+
+	.macro PTE va, cpa, bits1, no_org=0
+	.ifeq \no_org
+	.org swapper_pg_dir + HV_L1_INDEX(\va) * HV_PTE_SIZE
+	.endif
+	.word HV_PTE_PAGE | HV_PTE_DIRTY | HV_PTE_PRESENT | HV_PTE_ACCESSED | \
+	      (HV_PTE_MODE_CACHE_NO_L3 << HV_PTE_INDEX_MODE)
+	.word (\bits1) | (HV_CPA_TO_PFN(\cpa) << HV_PTE_INDEX_PFN)
+	.endm
+
+.section ".data.page_aligned","wa"
+	.align PAGE_SIZE
+ENTRY(swapper_pg_dir)
+	/*
+	 * All data pages from PAGE_OFFSET to MEM_USER_INTRPT are mapped as
+	 * VA = PA + PAGE_OFFSET.  We remap things with more precise access
+	 * permissions and more respect for size of RAM later.
+	 */
+	.set addr, 0
+	.rept (MEM_USER_INTRPT - PAGE_OFFSET) >> PGDIR_SHIFT
+	PTE addr + PAGE_OFFSET, addr, HV_PTE_READABLE | HV_PTE_WRITABLE
+	.set addr, addr + PGDIR_SIZE
+	.endr
+
+	/* The true text VAs are mapped as VA = PA + MEM_SV_INTRPT */
+	PTE MEM_SV_INTRPT, 0, HV_PTE_READABLE | HV_PTE_EXECUTABLE
+	.org swapper_pg_dir + HV_L1_SIZE
+	END(swapper_pg_dir)
+
+	/*
+	 * Isolate swapper_pgprot to its own cache line, since each cpu
+	 * starting up will read it using VA-is-PA and local homing.
+	 * This would otherwise likely conflict with other data on the cache
+	 * line, once we have set its permanent home in the page tables.
+	 */
+	__INITDATA
+	.align CHIP_L2_LINE_SIZE()
+ENTRY(swapper_pgprot)
+	PTE	0, 0, HV_PTE_READABLE | HV_PTE_WRITABLE, 1
+	.align CHIP_L2_LINE_SIZE()
+	END(swapper_pgprot)
diff --git a/arch/tile/kernel/hvglue.lds b/arch/tile/kernel/hvglue.lds
new file mode 100644
index 0000000..698489b
--- /dev/null
+++ b/arch/tile/kernel/hvglue.lds
@@ -0,0 +1,56 @@
+/* Hypervisor call vector addresses; see <hv/hypervisor.h> */
+hv_init = TEXT_OFFSET + 0x10020;
+hv_install_context = TEXT_OFFSET + 0x10040;
+hv_sysconf = TEXT_OFFSET + 0x10060;
+hv_get_rtc = TEXT_OFFSET + 0x10080;
+hv_set_rtc = TEXT_OFFSET + 0x100a0;
+hv_flush_asid = TEXT_OFFSET + 0x100c0;
+hv_flush_page = TEXT_OFFSET + 0x100e0;
+hv_flush_pages = TEXT_OFFSET + 0x10100;
+hv_restart = TEXT_OFFSET + 0x10120;
+hv_halt = TEXT_OFFSET + 0x10140;
+hv_power_off = TEXT_OFFSET + 0x10160;
+hv_inquire_physical = TEXT_OFFSET + 0x10180;
+hv_inquire_memory_controller = TEXT_OFFSET + 0x101a0;
+hv_inquire_virtual = TEXT_OFFSET + 0x101c0;
+hv_inquire_asid = TEXT_OFFSET + 0x101e0;
+hv_nanosleep = TEXT_OFFSET + 0x10200;
+hv_console_read_if_ready = TEXT_OFFSET + 0x10220;
+hv_console_write = TEXT_OFFSET + 0x10240;
+hv_downcall_dispatch = TEXT_OFFSET + 0x10260;
+hv_inquire_topology = TEXT_OFFSET + 0x10280;
+hv_fs_findfile = TEXT_OFFSET + 0x102a0;
+hv_fs_fstat = TEXT_OFFSET + 0x102c0;
+hv_fs_pread = TEXT_OFFSET + 0x102e0;
+hv_physaddr_read64 = TEXT_OFFSET + 0x10300;
+hv_physaddr_write64 = TEXT_OFFSET + 0x10320;
+hv_get_command_line = TEXT_OFFSET + 0x10340;
+hv_set_caching = TEXT_OFFSET + 0x10360;
+hv_bzero_page = TEXT_OFFSET + 0x10380;
+hv_register_message_state = TEXT_OFFSET + 0x103a0;
+hv_send_message = TEXT_OFFSET + 0x103c0;
+hv_receive_message = TEXT_OFFSET + 0x103e0;
+hv_inquire_context = TEXT_OFFSET + 0x10400;
+hv_start_all_tiles = TEXT_OFFSET + 0x10420;
+hv_dev_open = TEXT_OFFSET + 0x10440;
+hv_dev_close = TEXT_OFFSET + 0x10460;
+hv_dev_pread = TEXT_OFFSET + 0x10480;
+hv_dev_pwrite = TEXT_OFFSET + 0x104a0;
+hv_dev_poll = TEXT_OFFSET + 0x104c0;
+hv_dev_poll_cancel = TEXT_OFFSET + 0x104e0;
+hv_dev_preada = TEXT_OFFSET + 0x10500;
+hv_dev_pwritea = TEXT_OFFSET + 0x10520;
+hv_flush_remote = TEXT_OFFSET + 0x10540;
+hv_console_putc = TEXT_OFFSET + 0x10560;
+hv_inquire_tiles = TEXT_OFFSET + 0x10580;
+hv_confstr = TEXT_OFFSET + 0x105a0;
+hv_reexec = TEXT_OFFSET + 0x105c0;
+hv_set_command_line = TEXT_OFFSET + 0x105e0;
+hv_dev_register_intr_state = TEXT_OFFSET + 0x10600;
+hv_enable_intr = TEXT_OFFSET + 0x10620;
+hv_disable_intr = TEXT_OFFSET + 0x10640;
+hv_trigger_ipi = TEXT_OFFSET + 0x10660;
+hv_store_mapping = TEXT_OFFSET + 0x10680;
+hv_inquire_realpa = TEXT_OFFSET + 0x106a0;
+hv_flush_all = TEXT_OFFSET + 0x106c0;
+hv_glue_internals = TEXT_OFFSET + 0x106e0;
diff --git a/arch/tile/kernel/init_task.c b/arch/tile/kernel/init_task.c
new file mode 100644
index 0000000..928b318
--- /dev/null
+++ b/arch/tile/kernel/init_task.c
@@ -0,0 +1,59 @@
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
+#include <linux/mm.h>
+#include <linux/fs.h>
+#include <linux/init_task.h>
+#include <linux/mqueue.h>
+#include <linux/module.h>
+#include <linux/start_kernel.h>
+#include <linux/uaccess.h>
+
+static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
+static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
+
+/*
+ * Initial thread structure.
+ *
+ * We need to make sure that this is THREAD_SIZE aligned due to the
+ * way process stacks are handled. This is done by having a special
+ * "init_task" linker map entry..
+ */
+union thread_union init_thread_union __init_task_data = {
+	INIT_THREAD_INFO(init_task)
+};
+
+/*
+ * Initial task structure.
+ *
+ * All other task structs will be allocated on slabs in fork.c
+ */
+struct task_struct init_task = INIT_TASK(init_task);
+EXPORT_SYMBOL(init_task);
+
+/*
+ * per-CPU stack and boot info.
+ */
+DEFINE_PER_CPU(unsigned long, boot_sp) =
+	(unsigned long)init_stack + THREAD_SIZE;
+
+#ifdef CONFIG_SMP
+DEFINE_PER_CPU(unsigned long, boot_pc) = (unsigned long)start_kernel;
+#else
+/*
+ * The variable must be __initdata since it references __init code.
+ * With CONFIG_SMP it is per-cpu data, which is exempt from validation.
+ */
+unsigned long __initdata boot_pc = (unsigned long)start_kernel;
+#endif
diff --git a/arch/tile/kernel/intvec_32.S b/arch/tile/kernel/intvec_32.S
new file mode 100644
index 0000000..207271f
--- /dev/null
+++ b/arch/tile/kernel/intvec_32.S
@@ -0,0 +1,2006 @@
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
+ *
+ * Linux interrupt vectors.
+ */
+
+#include <linux/linkage.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <asm/ptrace.h>
+#include <asm/thread_info.h>
+#include <asm/unistd.h>
+#include <asm/irqflags.h>
+#include <asm/atomic.h>
+#include <asm/asm-offsets.h>
+#include <hv/hypervisor.h>
+#include <arch/abi.h>
+#include <arch/interrupts.h>
+#include <arch/spr_def.h>
+
+#ifdef CONFIG_PREEMPT
+# error "No support for kernel preemption currently"
+#endif
+
+#if INT_INTCTRL_1 < 32 || INT_INTCTL_1 >= 48
+# error INT_INTCTRL_1 coded to set high interrupt mask
+#endif
+
+#define PTREGS_PTR(reg, ptreg) addli reg, sp, C_ABI_SAVE_AREA_SIZE + (ptreg)
+
+#define PTREGS_OFFSET_SYSCALL PTREGS_OFFSET_REG(TREG_SYSCALL_NR)
+
+#if !CHIP_HAS_WH64()
+	/* By making this an empty macro, we can use wh64 in the code. */
+	.macro  wh64 reg
+	.endm
+#endif
+
+	.macro  push_reg reg, ptr=sp, delta=-4
+	{
+	 sw     \ptr, \reg
+	 addli  \ptr, \ptr, \delta
+	}
+	.endm
+
+	.macro  pop_reg reg, ptr=sp, delta=4
+	{
+	 lw     \reg, \ptr
+	 addli  \ptr, \ptr, \delta
+	}
+	.endm
+
+	.macro  pop_reg_zero reg, zreg, ptr=sp, delta=4
+	{
+	 move   \zreg, zero
+	 lw     \reg, \ptr
+	 addi   \ptr, \ptr, \delta
+	}
+	.endm
+
+	.macro  push_extra_callee_saves reg
+	PTREGS_PTR(\reg, PTREGS_OFFSET_REG(51))
+	push_reg r51, \reg
+	push_reg r50, \reg
+	push_reg r49, \reg
+	push_reg r48, \reg
+	push_reg r47, \reg
+	push_reg r46, \reg
+	push_reg r45, \reg
+	push_reg r44, \reg
+	push_reg r43, \reg
+	push_reg r42, \reg
+	push_reg r41, \reg
+	push_reg r40, \reg
+	push_reg r39, \reg
+	push_reg r38, \reg
+	push_reg r37, \reg
+	push_reg r36, \reg
+	push_reg r35, \reg
+	push_reg r34, \reg, PTREGS_OFFSET_BASE - PTREGS_OFFSET_REG(34)
+	.endm
+
+	.macro  panic str
+	.pushsection .rodata, "a"
+1:
+	.asciz  "\str"
+	.popsection
+	{
+	 moveli r0, lo16(1b)
+	}
+	{
+	 auli   r0, r0, ha16(1b)
+	 jal    panic
+	}
+	.endm
+
+#ifdef __COLLECT_LINKER_FEEDBACK__
+	.pushsection .text.intvec_feedback,"ax"
+intvec_feedback:
+	.popsection
+#endif
+
+	/*
+	 * Default interrupt handler.
+	 *
+	 * vecnum is where we'll put this code.
+	 * c_routine is the C routine we'll call.
+	 *
+	 * The C routine is passed two arguments:
+	 * - A pointer to the pt_regs state.
+	 * - The interrupt vector number.
+	 *
+	 * The "processing" argument specifies the code for processing
+	 * the interrupt. Defaults to "handle_interrupt".
+	 */
+	.macro  int_hand vecnum, vecname, c_routine, processing=handle_interrupt
+	.org    (\vecnum << 8)
+intvec_\vecname:
+	.ifc    \vecnum, INT_SWINT_1
+	blz     TREG_SYSCALL_NR_NAME, sys_cmpxchg
+	.endif
+
+	/* Temporarily save a register so we have somewhere to work. */
+
+	mtspr   SYSTEM_SAVE_1_1, r0
+	mfspr   r0, EX_CONTEXT_1_1
+
+	/* The cmpxchg code clears sp to force us to reset it here on fault. */
+	{
+	 bz     sp, 2f
+	 andi   r0, r0, SPR_EX_CONTEXT_1_1__PL_MASK  /* mask off ICS */
+	}
+
+	.ifc    \vecnum, INT_DOUBLE_FAULT
+	/*
+	 * For double-faults from user-space, fall through to the normal
+	 * register save and stack setup path.  Otherwise, it's the
+	 * hypervisor giving us one last chance to dump diagnostics, and we
+	 * branch to the kernel_double_fault routine to do so.
+	 */
+	bz      r0, 1f
+	j       _kernel_double_fault
+1:
+	.else
+	/*
+	 * If we're coming from user-space, then set sp to the top of
+	 * the kernel stack.  Otherwise, assume sp is already valid.
+	 */
+	{
+	 bnz    r0, 0f
+	 move   r0, sp
+	}
+	.endif
+
+	.ifc    \c_routine, do_page_fault
+	/*
+	 * The page_fault handler may be downcalled directly by the
+	 * hypervisor even when Linux is running and has ICS set.
+	 *
+	 * In this case the contents of EX_CONTEXT_1_1 reflect the
+	 * previous fault and can't be relied on to choose whether or
+	 * not to reinitialize the stack pointer.  So we add a test
+	 * to see whether SYSTEM_SAVE_1_2 has the high bit set,
+	 * and if so we don't reinitialize sp, since we must be coming
+	 * from Linux.  (In fact the precise case is !(val & ~1),
+	 * but any Linux PC has to have the high bit set.)
+	 *
+	 * Note that the hypervisor *always* sets SYSTEM_SAVE_1_2 for
+	 * any path that turns into a downcall to one of our TLB handlers.
+	 */
+	mfspr   r0, SYSTEM_SAVE_1_2
+	{
+	 blz    r0, 0f    /* high bit in S_S_1_2 is for a PC to use */
+	 move   r0, sp
+	}
+	.endif
+
+2:
+	/*
+	 * SYSTEM_SAVE_1_0 holds the cpu number in the low bits, and
+	 * the current stack top in the higher bits.  So we recover
+	 * our stack top by just masking off the low bits, then
+	 * point sp at the top aligned address on the actual stack page.
+	 */
+	mfspr   r0, SYSTEM_SAVE_1_0
+	mm      r0, r0, zero, LOG2_THREAD_SIZE, 31
+
+0:
+	/*
+	 * Align the stack mod 64 so we can properly predict what
+	 * cache lines we need to write-hint to reduce memory fetch
+	 * latency as we enter the kernel.  The layout of memory is
+	 * as follows, with cache line 0 at the lowest VA, and cache
+	 * line 4 just below the r0 value this "andi" computes.
+	 * Note that we never write to cache line 4, and we skip
+	 * cache line 1 for syscalls.
+	 *
+	 *    cache line 4: ptregs padding (two words)
+	 *    cache line 3: r46...lr, pc, ex1, faultnum, orig_r0, flags, pad
+	 *    cache line 2: r30...r45
+	 *    cache line 1: r14...r29
+	 *    cache line 0: 2 x frame, r0..r13
+	 */
+	andi    r0, r0, -64
+
+	/*
+	 * Push the first four registers on the stack, so that we can set
+	 * them to vector-unique values before we jump to the common code.
+	 *
+	 * Registers are pushed on the stack as a struct pt_regs,
+	 * with the sp initially just above the struct, and when we're
+	 * done, sp points to the base of the struct, minus
+	 * C_ABI_SAVE_AREA_SIZE, so we can directly jal to C code.
+	 *
+	 * This routine saves just the first four registers, plus the
+	 * stack context so we can do proper backtracing right away,
+	 * and defers to handle_interrupt to save the rest.
+	 * The backtracer needs pc, ex1, lr, sp, r52, and faultnum.
+	 */
+	addli   r0, r0, PTREGS_OFFSET_LR - (PTREGS_SIZE + KSTK_PTREGS_GAP)
+	wh64    r0    /* cache line 3 */
+	{
+	 sw     r0, lr
+	 addli  r0, r0, PTREGS_OFFSET_SP - PTREGS_OFFSET_LR
+	}
+	{
+	 sw     r0, sp
+	 addli  sp, r0, PTREGS_OFFSET_REG(52) - PTREGS_OFFSET_SP
+	}
+	{
+	 sw     sp, r52
+	 addli  sp, sp, PTREGS_OFFSET_REG(1) - PTREGS_OFFSET_REG(52)
+	}
+	wh64    sp    /* cache line 0 */
+	{
+	 sw     sp, r1
+	 addli  sp, sp, PTREGS_OFFSET_REG(2) - PTREGS_OFFSET_REG(1)
+	}
+	{
+	 sw     sp, r2
+	 addli  sp, sp, PTREGS_OFFSET_REG(3) - PTREGS_OFFSET_REG(2)
+	}
+	{
+	 sw     sp, r3
+	 addli  sp, sp, PTREGS_OFFSET_PC - PTREGS_OFFSET_REG(3)
+	}
+	mfspr   r0, EX_CONTEXT_1_0
+	.ifc \processing,handle_syscall
+	/*
+	 * Bump the saved PC by one bundle so that when we return, we won't
+	 * execute the same swint instruction again.  We need to do this while
+	 * we're in the critical section.
+	 */
+	addi    r0, r0, 8
+	.endif
+	{
+	 sw     sp, r0
+	 addli  sp, sp, PTREGS_OFFSET_EX1 - PTREGS_OFFSET_PC
+	}
+	mfspr   r0, EX_CONTEXT_1_1
+	{
+	 sw     sp, r0
+	 addi   sp, sp, PTREGS_OFFSET_FAULTNUM - PTREGS_OFFSET_EX1
+	/*
+	 * Use r0 for syscalls so it's a temporary; use r1 for interrupts
+	 * so that it gets passed through unchanged to the handler routine.
+	 * Note that the .if conditional confusingly spans bundles.
+	 */
+	 .ifc \processing,handle_syscall
+	 movei  r0, \vecnum
+	}
+	{
+	 sw     sp, r0
+	 .else
+	 movei  r1, \vecnum
+	}
+	{
+	 sw     sp, r1
+	 .endif
+	 addli  sp, sp, PTREGS_OFFSET_REG(0) - PTREGS_OFFSET_FAULTNUM
+	}
+	mfspr   r0, SYSTEM_SAVE_1_1    /* Original r0 */
+	{
+	 sw     sp, r0
+	 addi   sp, sp, -PTREGS_OFFSET_REG(0) - 4
+	}
+	{
+	 sw     sp, zero        /* write zero into "Next SP" frame pointer */
+	 addi   sp, sp, -4      /* leave SP pointing at bottom of frame */
+	}
+	.ifc \processing,handle_syscall
+	j       handle_syscall
+	.else
+	/*
+	 * Capture per-interrupt SPR context to registers.
+	 * We overload the meaning of r3 on this path such that if its bit 31
+	 * is set, we have to mask all interrupts including NMIs before
+	 * clearing the interrupt critical section bit.
+	 * See discussion below at "finish_interrupt_save".
+	 */
+	.ifc \c_routine, do_page_fault
+	mfspr   r2, SYSTEM_SAVE_1_3   /* address of page fault */
+	mfspr   r3, SYSTEM_SAVE_1_2   /* info about page fault */
+	.else
+	.ifc \vecnum, INT_DOUBLE_FAULT
+	{
+	 mfspr  r2, SYSTEM_SAVE_1_2   /* double fault info from HV */
+	 movei  r3, 0
+	}
+	.else
+	.ifc \c_routine, do_trap
+	{
+	 mfspr  r2, GPV_REASON
+	 movei  r3, 0
+	}
+	.else
+	.ifc \c_routine, op_handle_perf_interrupt
+	{
+	 mfspr  r2, PERF_COUNT_STS
+	 movei  r3, -1   /* not used, but set for consistency */
+	}
+	.else
+#if CHIP_HAS_AUX_PERF_COUNTERS()
+	.ifc \c_routine, op_handle_aux_perf_interrupt
+	{
+	 mfspr  r2, AUX_PERF_COUNT_STS
+	 movei  r3, -1   /* not used, but set for consistency */
+	}
+	.else
+#endif
+	movei   r3, 0
+#if CHIP_HAS_AUX_PERF_COUNTERS()
+	.endif
+#endif
+	.endif
+	.endif
+	.endif
+	.endif
+	/* Put function pointer in r0 */
+	moveli  r0, lo16(\c_routine)
+	{
+	 auli   r0, r0, ha16(\c_routine)
+	 j       \processing
+	}
+	.endif
+	ENDPROC(intvec_\vecname)
+
+#ifdef __COLLECT_LINKER_FEEDBACK__
+	.pushsection .text.intvec_feedback,"ax"
+	.org    (\vecnum << 5)
+	FEEDBACK_ENTER_EXPLICIT(intvec_\vecname, .intrpt1, 1 << 8)
+	jrp     lr
+	.popsection
+#endif
+
+	.endm
+
+
+	/*
+	 * Save the rest of the registers that we didn't save in the actual
+	 * vector itself.  We can't use r0-r10 inclusive here.
+	 */
+	.macro  finish_interrupt_save, function
+
+	/* If it's a syscall, save a proper orig_r0, otherwise just zero. */
+	PTREGS_PTR(r52, PTREGS_OFFSET_ORIG_R0)
+	{
+	 .ifc \function,handle_syscall
+	 sw     r52, r0
+	 .else
+	 sw     r52, zero
+	 .endif
+	 PTREGS_PTR(r52, PTREGS_OFFSET_TP)
+	}
+
+	/*
+	 * For ordinary syscalls, we save neither caller- nor callee-
+	 * save registers, since the syscall invoker doesn't expect the
+	 * caller-saves to be saved, and the called kernel functions will
+	 * take care of saving the callee-saves for us.
+	 *
+	 * For interrupts we save just the caller-save registers.  Saving
+	 * them is required (since the "caller" can't save them).  Again,
+	 * the called kernel functions will restore the callee-save
+	 * registers for us appropriately.
+	 *
+	 * On return, we normally restore nothing special for syscalls,
+	 * and just the caller-save registers for interrupts.
+	 *
+	 * However, there are some important caveats to all this:
+	 *
+	 * - We always save a few callee-save registers to give us
+	 *   some scratchpad registers to carry across function calls.
+	 *
+	 * - fork/vfork/etc require us to save all the callee-save
+	 *   registers, which we do in PTREGS_SYSCALL_ALL_REGS, below.
+	 *
+	 * - We always save r0..r5 and r10 for syscalls, since we need
+	 *   to reload them a bit later for the actual kernel call, and
+	 *   since we might need them for -ERESTARTNOINTR, etc.
+	 *
+	 * - Before invoking a signal handler, we save the unsaved
+	 *   callee-save registers so they are visible to the
+	 *   signal handler or any ptracer.
+	 *
+	 * - If the unsaved callee-save registers are modified, we set
+	 *   a bit in pt_regs so we know to reload them from pt_regs
+	 *   and not just rely on the kernel function unwinding.
+	 *   (Done for ptrace register writes and SA_SIGINFO handler.)
+	 */
+	{
+	 sw     r52, tp
+	 PTREGS_PTR(r52, PTREGS_OFFSET_REG(33))
+	}
+	wh64    r52    /* cache line 2 */
+	push_reg r33, r52
+	push_reg r32, r52
+	push_reg r31, r52
+	.ifc \function,handle_syscall
+	push_reg r30, r52, PTREGS_OFFSET_SYSCALL - PTREGS_OFFSET_REG(30)
+	push_reg TREG_SYSCALL_NR_NAME, r52, \
+	  PTREGS_OFFSET_REG(5) - PTREGS_OFFSET_SYSCALL
+	.else
+
+	push_reg r30, r52, PTREGS_OFFSET_REG(29) - PTREGS_OFFSET_REG(30)
+	wh64    r52    /* cache line 1 */
+	push_reg r29, r52
+	push_reg r28, r52
+	push_reg r27, r52
+	push_reg r26, r52
+	push_reg r25, r52
+	push_reg r24, r52
+	push_reg r23, r52
+	push_reg r22, r52
+	push_reg r21, r52
+	push_reg r20, r52
+	push_reg r19, r52
+	push_reg r18, r52
+	push_reg r17, r52
+	push_reg r16, r52
+	push_reg r15, r52
+	push_reg r14, r52
+	push_reg r13, r52
+	push_reg r12, r52
+	push_reg r11, r52
+	push_reg r10, r52
+	push_reg r9, r52
+	push_reg r8, r52
+	push_reg r7, r52
+	push_reg r6, r52
+
+	.endif
+
+	push_reg r5, r52
+	sw      r52, r4
+
+	/* Load tp with our per-cpu offset. */
+#ifdef CONFIG_SMP
+	{
+	 mfspr  r20, SYSTEM_SAVE_1_0
+	 moveli r21, lo16(__per_cpu_offset)
+	}
+	{
+	 auli   r21, r21, ha16(__per_cpu_offset)
+	 mm     r20, r20, zero, 0, LOG2_THREAD_SIZE-1
+	}
+	s2a     r20, r20, r21
+	lw      tp, r20
+#else
+	move    tp, zero
+#endif
+
+	/*
+	 * If we will be returning to the kernel, we will need to
+	 * reset the interrupt masks to the state they had before.
+	 * Set DISABLE_IRQ in flags iff we came from PL1 with irqs disabled.
+	 * We load flags in r32 here so we can jump to .Lrestore_regs
+	 * directly after do_page_fault_ics() if necessary.
+	 */
+	mfspr   r32, EX_CONTEXT_1_1
+	{
+	 andi   r32, r32, SPR_EX_CONTEXT_1_1__PL_MASK  /* mask off ICS */
+	 PTREGS_PTR(r21, PTREGS_OFFSET_FLAGS)
+	}
+	bzt     r32, 1f       /* zero if from user space */
+	IRQS_DISABLED(r32)    /* zero if irqs enabled */
+#if PT_FLAGS_DISABLE_IRQ != 1
+# error Value of IRQS_DISABLED used to set PT_FLAGS_DISABLE_IRQ; fix
+#endif
+1:
+	.ifnc \function,handle_syscall
+	/* Record the fact that we saved the caller-save registers above. */
+	ori     r32, r32, PT_FLAGS_CALLER_SAVES
+	.endif
+	sw      r21, r32
+
+#ifdef __COLLECT_LINKER_FEEDBACK__
+	/*
+	 * Notify the feedback routines that we were in the
+	 * appropriate fixed interrupt vector area.  Note that we
+	 * still have ICS set at this point, so we can't invoke any
+	 * atomic operations or we will panic.  The feedback
+	 * routines internally preserve r0..r10 and r30 up.
+	 */
+	.ifnc \function,handle_syscall
+	shli    r20, r1, 5
+	.else
+	moveli  r20, INT_SWINT_1 << 5
+	.endif
+	addli   r20, r20, lo16(intvec_feedback)
+	auli    r20, r20, ha16(intvec_feedback)
+	jalr    r20
+
+	/* And now notify the feedback routines that we are here. */
+	FEEDBACK_ENTER(\function)
+#endif
+
+	/*
+	 * we've captured enough state to the stack (including in
+	 * particular our EX_CONTEXT state) that we can now release
+	 * the interrupt critical section and replace it with our
+	 * standard "interrupts disabled" mask value.  This allows
+	 * synchronous interrupts (and profile interrupts) to punch
+	 * through from this point onwards.
+	 *
+	 * If bit 31 of r3 is set during a non-NMI interrupt, we know we
+	 * are on the path where the hypervisor has punched through our
+	 * ICS with a page fault, so we call out to do_page_fault_ics()
+	 * to figure out what to do with it.  If the fault was in
+	 * an atomic op, we unlock the atomic lock, adjust the
+	 * saved register state a little, and return "zero" in r4,
+	 * falling through into the normal page-fault interrupt code.
+	 * If the fault was in a kernel-space atomic operation, then
+	 * do_page_fault_ics() resolves it itself, returns "one" in r4,
+	 * and as a result goes directly to restoring registers and iret,
+	 * without trying to adjust the interrupt masks at all.
+	 * The do_page_fault_ics() API involves passing and returning
+	 * a five-word struct (in registers) to avoid writing the
+	 * save and restore code here.
+	 */
+	.ifc \function,handle_nmi
+	IRQ_DISABLE_ALL(r20)
+	.else
+	.ifnc \function,handle_syscall
+	bgezt   r3, 1f
+	{
+	 PTREGS_PTR(r0, PTREGS_OFFSET_BASE)
+	 jal    do_page_fault_ics
+	}
+	FEEDBACK_REENTER(\function)
+	bzt     r4, 1f
+	j       .Lrestore_regs
+1:
+	.endif
+	IRQ_DISABLE(r20, r21)
+	.endif
+	mtspr   INTERRUPT_CRITICAL_SECTION, zero
+
+#if CHIP_HAS_WH64()
+	/*
+	 * Prepare the first 256 stack bytes to be rapidly accessible
+	 * without having to fetch the background data.  We don't really
+	 * know how far to write-hint, but kernel stacks generally
+	 * aren't that big, and write-hinting here does take some time.
+	 */
+	addi    r52, sp, -64
+	{
+	 wh64   r52
+	 addi   r52, r52, -64
+	}
+	{
+	 wh64   r52
+	 addi   r52, r52, -64
+	}
+	{
+	 wh64   r52
+	 addi   r52, r52, -64
+	}
+	wh64    r52
+#endif
+
+#ifdef CONFIG_TRACE_IRQFLAGS
+	.ifnc \function,handle_nmi
+	/*
+	 * We finally have enough state set up to notify the irq
+	 * tracing code that irqs were disabled on entry to the handler.
+	 * The TRACE_IRQS_OFF call clobbers registers r0-r29.
+	 * For syscalls, we already have the register state saved away
+	 * on the stack, so we don't bother to do any register saves here,
+	 * and later we pop the registers back off the kernel stack.
+	 * For interrupt handlers, save r0-r3 in callee-saved registers.
+	 */
+	.ifnc \function,handle_syscall
+	{ move r30, r0; move r31, r1 }
+	{ move r32, r2; move r33, r3 }
+	.endif
+	TRACE_IRQS_OFF
+	.ifnc \function,handle_syscall
+	{ move r0, r30; move r1, r31 }
+	{ move r2, r32; move r3, r33 }
+	.endif
+	.endif
+#endif
+
+	.endm
+
+	.macro  check_single_stepping, kind, not_single_stepping
+	/*
+	 * Check for single stepping in user-level priv
+	 *   kind can be "normal", "ill", or "syscall"
+	 * At end, if fall-thru
+	 *   r29: thread_info->step_state
+	 *   r28: &pt_regs->pc
+	 *   r27: pt_regs->pc
+	 *   r26: thread_info->step_state->buffer
+	 */
+
+	/* Check for single stepping */
+	GET_THREAD_INFO(r29)
+	{
+	 /* Get pointer to field holding step state */
+	 addi   r29, r29, THREAD_INFO_STEP_STATE_OFFSET
+
+	 /* Get pointer to EX1 in register state */
+	 PTREGS_PTR(r27, PTREGS_OFFSET_EX1)
+	}
+	{
+	 /* Get pointer to field holding PC */
+	 PTREGS_PTR(r28, PTREGS_OFFSET_PC)
+
+	 /* Load the pointer to the step state */
+	 lw     r29, r29
+	}
+	/* Load EX1 */
+	lw      r27, r27
+	{
+	 /* Points to flags */
+	 addi   r23, r29, SINGLESTEP_STATE_FLAGS_OFFSET
+
+	 /* No single stepping if there is no step state structure */
+	 bzt    r29, \not_single_stepping
+	}
+	{
+	 /* mask off ICS and any other high bits */
+	 andi   r27, r27, SPR_EX_CONTEXT_1_1__PL_MASK
+
+	 /* Load pointer to single step instruction buffer */
+	 lw     r26, r29
+	}
+	/* Check priv state */
+	bnz     r27, \not_single_stepping
+
+	/* Get flags */
+	lw      r22, r23
+	{
+	 /* Branch if single-step mode not enabled */
+	 bbnst  r22, \not_single_stepping
+
+	 /* Clear enabled flag */
+	 andi   r22, r22, ~SINGLESTEP_STATE_MASK_IS_ENABLED
+	}
+	.ifc \kind,normal
+	{
+	 /* Load PC */
+	 lw     r27, r28
+
+	 /* Point to the entry containing the original PC */
+	 addi   r24, r29, SINGLESTEP_STATE_ORIG_PC_OFFSET
+	}
+	{
+	 /* Disable single stepping flag */
+	 sw     r23, r22
+	}
+	{
+	 /* Get the original pc */
+	 lw     r24, r24
+
+	 /* See if the PC is at the start of the single step buffer */
+	 seq    r25, r26, r27
+	}
+	/*
+	 * NOTE: it is really expected that the PC be in the single step buffer
+	 *       at this point
+	 */
+	bzt     r25, \not_single_stepping
+
+	/* Restore the original PC */
+	sw      r28, r24
+	.else
+	.ifc \kind,syscall
+	{
+	 /* Load PC */
+	 lw     r27, r28
+
+	 /* Point to the entry containing the next PC */
+	 addi   r24, r29, SINGLESTEP_STATE_NEXT_PC_OFFSET
+	}
+	{
+	 /* Increment the stopped PC by the bundle size */
+	 addi   r26, r26, 8
+
+	 /* Disable single stepping flag */
+	 sw     r23, r22
+	}
+	{
+	 /* Get the next pc */
+	 lw     r24, r24
+
+	 /*
+	  * See if the PC is one bundle past the start of the
+	  * single step buffer
+	  */
+	 seq    r25, r26, r27
+	}
+	{
+	 /*
+	  * NOTE: it is really expected that the PC be in the
+	  * single step buffer at this point
+	  */
+	 bzt    r25, \not_single_stepping
+	}
+	/* Set to the next PC */
+	sw      r28, r24
+	.else
+	{
+	 /* Point to 3rd bundle in buffer */
+	 addi   r25, r26, 16
+
+	 /* Load PC */
+	 lw      r27, r28
+	}
+	{
+	 /* Disable single stepping flag */
+	 sw      r23, r22
+
+	 /* See if the PC is in the single step buffer */
+	 slte_u  r24, r26, r27
+	}
+	{
+	 slte_u r25, r27, r25
+
+	 /*
+	  * NOTE: it is really expected that the PC be in the
+	  * single step buffer at this point
+	  */
+	 bzt    r24, \not_single_stepping
+	}
+	bzt     r25, \not_single_stepping
+	.endif
+	.endif
+	.endm
+
+	/*
+	 * Redispatch a downcall.
+	 */
+	.macro  dc_dispatch vecnum, vecname
+	.org    (\vecnum << 8)
+intvec_\vecname:
+	j       hv_downcall_dispatch
+	ENDPROC(intvec_\vecname)
+	.endm
+
+	/*
+	 * Common code for most interrupts.  The C function we're eventually
+	 * going to is in r0, and the faultnum is in r1; the original
+	 * values for those registers are on the stack.
+	 */
+	.pushsection .text.handle_interrupt,"ax"
+handle_interrupt:
+	finish_interrupt_save handle_interrupt
+
+	/*
+	 * Check for if we are single stepping in user level. If so, then
+	 * we need to restore the PC.
+	 */
+
+	check_single_stepping normal, .Ldispatch_interrupt
+.Ldispatch_interrupt:
+
+	/* Jump to the C routine; it should enable irqs as soon as possible. */
+	{
+	 jalr   r0
+	 PTREGS_PTR(r0, PTREGS_OFFSET_BASE)
+	}
+	FEEDBACK_REENTER(handle_interrupt)
+	{
+	 movei  r30, 0   /* not an NMI */
+	 j      interrupt_return
+	}
+	STD_ENDPROC(handle_interrupt)
+
+/*
+ * This routine takes a boolean in r30 indicating if this is an NMI.
+ * If so, we also expect a boolean in r31 indicating whether to
+ * re-enable the oprofile interrupts.
+ */
+STD_ENTRY(interrupt_return)
+	/* If we're resuming to kernel space, don't check thread flags. */
+	{
+	 bnz    r30, .Lrestore_all  /* NMIs don't special-case user-space */
+	 PTREGS_PTR(r29, PTREGS_OFFSET_EX1)
+	}
+	lw      r29, r29
+	andi    r29, r29, SPR_EX_CONTEXT_1_1__PL_MASK  /* mask off ICS */
+	{
+	 bzt    r29, .Lresume_userspace
+	 PTREGS_PTR(r29, PTREGS_OFFSET_PC)
+	}
+
+	/* If we're resuming to _cpu_idle_nap, bump PC forward by 8. */
+	{
+	 lw     r28, r29
+	 moveli r27, lo16(_cpu_idle_nap)
+	}
+	{
+	 auli   r27, r27, ha16(_cpu_idle_nap)
+	}
+	{
+	 seq    r27, r27, r28
+	}
+	{
+	 bbns   r27, .Lrestore_all
+	 addi   r28, r28, 8
+	}
+	sw      r29, r28
+	j       .Lrestore_all
+
+.Lresume_userspace:
+	FEEDBACK_REENTER(interrupt_return)
+
+	/*
+	 * Disable interrupts so as to make sure we don't
+	 * miss an interrupt that sets any of the thread flags (like
+	 * need_resched or sigpending) between sampling and the iret.
+	 * Routines like schedule() or do_signal() may re-enable
+	 * interrupts before returning.
+	 */
+	IRQ_DISABLE(r20, r21)
+	TRACE_IRQS_OFF  /* Note: clobbers registers r0-r29 */
+
+	/* Get base of stack in r32; note r30/31 are used as arguments here. */
+	GET_THREAD_INFO(r32)
+
+
+	/* Check to see if there is any work to do before returning to user. */
+	{
+	 addi   r29, r32, THREAD_INFO_FLAGS_OFFSET
+	 moveli r28, lo16(_TIF_ALLWORK_MASK)
+	}
+	{
+	 lw     r29, r29
+	 auli   r28, r28, ha16(_TIF_ALLWORK_MASK)
+	}
+	and     r28, r29, r28
+	bnz     r28, .Lwork_pending
+
+	/*
+	 * In the NMI case we
+	 * omit the call to single_process_check_nohz, which normally checks
+	 * to see if we should start or stop the scheduler tick, because
+	 * we can't call arbitrary Linux code from an NMI context.
+	 * We always call the homecache TLB deferral code to re-trigger
+	 * the deferral mechanism.
+	 *
+	 * The other chunk of responsibility this code has is to reset the
+	 * interrupt masks appropriately to reset irqs and NMIs.  We have
+	 * to call TRACE_IRQS_OFF and TRACE_IRQS_ON to support all the
+	 * lockdep-type stuff, but we can't set ICS until afterwards, since
+	 * ICS can only be used in very tight chunks of code to avoid
+	 * tripping over various assertions that it is off.
+	 *
+	 * (There is what looks like a window of vulnerability here since
+	 * we might take a profile interrupt between the two SPR writes
+	 * that set the mask, but since we write the low SPR word first,
+	 * and our interrupt entry code checks the low SPR word, any
+	 * profile interrupt will actually disable interrupts in both SPRs
+	 * before returning, which is OK.)
+	 */
+.Lrestore_all:
+	PTREGS_PTR(r0, PTREGS_OFFSET_EX1)
+	{
+	 lw     r0, r0
+	 PTREGS_PTR(r32, PTREGS_OFFSET_FLAGS)
+	}
+	{
+	 andi   r0, r0, SPR_EX_CONTEXT_1_1__PL_MASK
+	 lw     r32, r32
+	}
+	bnz    r0, 1f
+	j       2f
+#if PT_FLAGS_DISABLE_IRQ != 1
+# error Assuming PT_FLAGS_DISABLE_IRQ == 1 so we can use bbnst below
+#endif
+1:	bbnst   r32, 2f
+	IRQ_DISABLE(r20,r21)
+	TRACE_IRQS_OFF
+	movei   r0, 1
+	mtspr   INTERRUPT_CRITICAL_SECTION, r0
+	bzt     r30, .Lrestore_regs
+	j       3f
+2:	TRACE_IRQS_ON
+	movei   r0, 1
+	mtspr   INTERRUPT_CRITICAL_SECTION, r0
+	IRQ_ENABLE(r20, r21)
+	bzt     r30, .Lrestore_regs
+3:
+
+
+	/*
+	 * We now commit to returning from this interrupt, since we will be
+	 * doing things like setting EX_CONTEXT SPRs and unwinding the stack
+	 * frame.  No calls should be made to any other code after this point.
+	 * This code should only be entered with ICS set.
+	 * r32 must still be set to ptregs.flags.
+	 * We launch loads to each cache line separately first, so we can
+	 * get some parallelism out of the memory subsystem.
+	 * We start zeroing caller-saved registers throughout, since
+	 * that will save some cycles if this turns out to be a syscall.
+	 */
+.Lrestore_regs:
+	FEEDBACK_REENTER(interrupt_return)   /* called from elsewhere */
+
+	/*
+	 * Rotate so we have one high bit and one low bit to test.
+	 * - low bit says whether to restore all the callee-saved registers,
+	 *   or just r30-r33, and r52 up.
+	 * - high bit (i.e. sign bit) says whether to restore all the
+	 *   caller-saved registers, or just r0.
+	 */
+#if PT_FLAGS_CALLER_SAVES != 2 || PT_FLAGS_RESTORE_REGS != 4
+# error Rotate trick does not work :-)
+#endif
+	{
+	 rli    r20, r32, 30
+	 PTREGS_PTR(sp, PTREGS_OFFSET_REG(0))
+	}
+
+	/*
+	 * Load cache lines 0, 2, and 3 in that order, then use
+	 * the last loaded value, which makes it likely that the other
+	 * cache lines have also loaded, at which point we should be
+	 * able to safely read all the remaining words on those cache
+	 * lines without waiting for the memory subsystem.
+	 */
+	pop_reg_zero r0, r1, sp, PTREGS_OFFSET_REG(30) - PTREGS_OFFSET_REG(0)
+	pop_reg_zero r30, r2, sp, PTREGS_OFFSET_PC - PTREGS_OFFSET_REG(30)
+	pop_reg_zero r21, r3, sp, PTREGS_OFFSET_EX1 - PTREGS_OFFSET_PC
+	pop_reg_zero lr, r4, sp, PTREGS_OFFSET_REG(52) - PTREGS_OFFSET_EX1
+	{
+	 mtspr  EX_CONTEXT_1_0, r21
+	 move   r5, zero
+	}
+	{
+	 mtspr  EX_CONTEXT_1_1, lr
+	 andi   lr, lr, SPR_EX_CONTEXT_1_1__PL_MASK  /* mask off ICS */
+	}
+
+	/* Restore callee-saveds that we actually use. */
+	pop_reg_zero r52, r6, sp, PTREGS_OFFSET_REG(31) - PTREGS_OFFSET_REG(52)
+	pop_reg_zero r31, r7
+	pop_reg_zero r32, r8
+	pop_reg_zero r33, r9, sp, PTREGS_OFFSET_REG(29) - PTREGS_OFFSET_REG(33)
+
+	/*
+	 * If we modified other callee-saveds, restore them now.
+	 * This is rare, but could be via ptrace or signal handler.
+	 */
+	{
+	 move   r10, zero
+	 bbs    r20, .Lrestore_callees
+	}
+.Lcontinue_restore_regs:
+
+	/* Check if we're returning from a syscall. */
+	{
+	 move   r11, zero
+	 blzt   r20, 1f  /* no, so go restore callee-save registers */
+	}
+
+	/*
+	 * Check if we're returning to userspace.
+	 * Note that if we're not, we don't worry about zeroing everything.
+	 */
+	{
+	 addli  sp, sp, PTREGS_OFFSET_LR - PTREGS_OFFSET_REG(29)
+	 bnz    lr, .Lkernel_return
+	}
+
+	/*
+	 * On return from syscall, we've restored r0 from pt_regs, but we
+	 * clear the remainder of the caller-saved registers.  We could
+	 * restore the syscall arguments, but there's not much point,
+	 * and it ensures user programs aren't trying to use the
+	 * caller-saves if we clear them, as well as avoiding leaking
+	 * kernel pointers into userspace.
+	 */
+	pop_reg_zero lr, r12, sp, PTREGS_OFFSET_TP - PTREGS_OFFSET_LR
+	pop_reg_zero tp, r13, sp, PTREGS_OFFSET_SP - PTREGS_OFFSET_TP
+	{
+	 lw     sp, sp
+	 move   r14, zero
+	 move   r15, zero
+	}
+	{ move r16, zero; move r17, zero }
+	{ move r18, zero; move r19, zero }
+	{ move r20, zero; move r21, zero }
+	{ move r22, zero; move r23, zero }
+	{ move r24, zero; move r25, zero }
+	{ move r26, zero; move r27, zero }
+	{ move r28, zero; move r29, zero }
+	iret
+
+	/*
+	 * Not a syscall, so restore caller-saved registers.
+	 * First kick off a load for cache line 1, which we're touching
+	 * for the first time here.
+	 */
+	.align 64
+1:	pop_reg r29, sp, PTREGS_OFFSET_REG(1) - PTREGS_OFFSET_REG(29)
+	pop_reg r1
+	pop_reg r2
+	pop_reg r3
+	pop_reg r4
+	pop_reg r5
+	pop_reg r6
+	pop_reg r7
+	pop_reg r8
+	pop_reg r9
+	pop_reg r10
+	pop_reg r11
+	pop_reg r12
+	pop_reg r13
+	pop_reg r14
+	pop_reg r15
+	pop_reg r16
+	pop_reg r17
+	pop_reg r18
+	pop_reg r19
+	pop_reg r20
+	pop_reg r21
+	pop_reg r22
+	pop_reg r23
+	pop_reg r24
+	pop_reg r25
+	pop_reg r26
+	pop_reg r27
+	pop_reg r28, sp, PTREGS_OFFSET_LR - PTREGS_OFFSET_REG(28)
+	/* r29 already restored above */
+	bnz     lr, .Lkernel_return
+	pop_reg lr, sp, PTREGS_OFFSET_TP - PTREGS_OFFSET_LR
+	pop_reg tp, sp, PTREGS_OFFSET_SP - PTREGS_OFFSET_TP
+	lw      sp, sp
+	iret
+
+	/*
+	 * We can't restore tp when in kernel mode, since a thread might
+	 * have migrated from another cpu and brought a stale tp value.
+	 */
+.Lkernel_return:
+	pop_reg lr, sp, PTREGS_OFFSET_SP - PTREGS_OFFSET_LR
+	lw      sp, sp
+	iret
+
+	/* Restore callee-saved registers from r34 to r51. */
+.Lrestore_callees:
+	addli  sp, sp, PTREGS_OFFSET_REG(34) - PTREGS_OFFSET_REG(29)
+	pop_reg r34
+	pop_reg r35
+	pop_reg r36
+	pop_reg r37
+	pop_reg r38
+	pop_reg r39
+	pop_reg r40
+	pop_reg r41
+	pop_reg r42
+	pop_reg r43
+	pop_reg r44
+	pop_reg r45
+	pop_reg r46
+	pop_reg r47
+	pop_reg r48
+	pop_reg r49
+	pop_reg r50
+	pop_reg r51, sp, PTREGS_OFFSET_REG(29) - PTREGS_OFFSET_REG(51)
+	j .Lcontinue_restore_regs
+
+.Lwork_pending:
+	/* Mask the reschedule flag */
+	andi    r28, r29, _TIF_NEED_RESCHED
+
+	{
+	 /*
+	  * If the NEED_RESCHED flag is called, we call schedule(), which
+	  * may drop this context right here and go do something else.
+	  * On return, jump back to .Lresume_userspace and recheck.
+	  */
+	 bz     r28, .Lasync_tlb
+
+	 /* Mask the async-tlb flag */
+	 andi   r28, r29, _TIF_ASYNC_TLB
+	}
+
+	jal     schedule
+	FEEDBACK_REENTER(interrupt_return)
+
+	/* Reload the flags and check again */
+	j       .Lresume_userspace
+
+.Lasync_tlb:
+	{
+	 bz     r28, .Lneed_sigpending
+
+	 /* Mask the sigpending flag */
+	 andi   r28, r29, _TIF_SIGPENDING
+	}
+
+	PTREGS_PTR(r0, PTREGS_OFFSET_BASE)
+	jal     do_async_page_fault
+	FEEDBACK_REENTER(interrupt_return)
+
+	/*
+	 * Go restart the "resume userspace" process.  We may have
+	 * fired a signal, and we need to disable interrupts again.
+	 */
+	j       .Lresume_userspace
+
+.Lneed_sigpending:
+	/*
+	 * At this point we are either doing signal handling or single-step,
+	 * so either way make sure we have all the registers saved.
+	 */
+	push_extra_callee_saves r0
+
+	{
+	 /* If no signal pending, skip to singlestep check */
+	 bz     r28, .Lneed_singlestep
+
+	 /* Mask the singlestep flag */
+	 andi   r28, r29, _TIF_SINGLESTEP
+	}
+
+	jal     do_signal
+	FEEDBACK_REENTER(interrupt_return)
+
+	/* Reload the flags and check again */
+	j       .Lresume_userspace
+
+.Lneed_singlestep:
+	{
+	 /* Get a pointer to the EX1 field */
+	 PTREGS_PTR(r29, PTREGS_OFFSET_EX1)
+
+	 /* If we get here, our bit must be set. */
+	 bz     r28, .Lwork_confusion
+	}
+	/* If we are in priv mode, don't single step */
+	lw      r28, r29
+	andi    r28, r28, SPR_EX_CONTEXT_1_1__PL_MASK  /* mask off ICS */
+	bnz     r28, .Lrestore_all
+
+	/* Allow interrupts within the single step code */
+	TRACE_IRQS_ON  /* Note: clobbers registers r0-r29 */
+	IRQ_ENABLE(r20, r21)
+
+	/* try to single-step the current instruction */
+	PTREGS_PTR(r0, PTREGS_OFFSET_BASE)
+	jal     single_step_once
+	FEEDBACK_REENTER(interrupt_return)
+
+	/* Re-disable interrupts.  TRACE_IRQS_OFF in .Lrestore_all. */
+	IRQ_DISABLE(r20,r21)
+
+	j       .Lrestore_all
+
+.Lwork_confusion:
+	move    r0, r28
+	panic   "thread_info allwork flags unhandled on userspace resume: %#x"
+
+	STD_ENDPROC(interrupt_return)
+
+	/*
+	 * This interrupt variant clears the INT_INTCTRL_1 interrupt mask bit
+	 * before returning, so we can properly get more downcalls.
+	 */
+	.pushsection .text.handle_interrupt_downcall,"ax"
+handle_interrupt_downcall:
+	finish_interrupt_save handle_interrupt_downcall
+	check_single_stepping normal, .Ldispatch_downcall
+.Ldispatch_downcall:
+
+	/* Clear INTCTRL_1 from the set of interrupts we ever enable. */
+	GET_INTERRUPTS_ENABLED_MASK_PTR(r30)
+	{
+	 addi   r30, r30, 4
+	 movei  r31, INT_MASK(INT_INTCTRL_1)
+	}
+	{
+	 lw     r20, r30
+	 nor    r21, r31, zero
+	}
+	and     r20, r20, r21
+	sw      r30, r20
+
+	{
+	 jalr   r0
+	 PTREGS_PTR(r0, PTREGS_OFFSET_BASE)
+	}
+	FEEDBACK_REENTER(handle_interrupt_downcall)
+
+	/* Allow INTCTRL_1 to be enabled next time we enable interrupts. */
+	lw      r20, r30
+	or      r20, r20, r31
+	sw      r30, r20
+
+	{
+	 movei  r30, 0   /* not an NMI */
+	 j      interrupt_return
+	}
+	STD_ENDPROC(handle_interrupt_downcall)
+
+	/*
+	 * Some interrupts don't check for single stepping
+	 */
+	.pushsection .text.handle_interrupt_no_single_step,"ax"
+handle_interrupt_no_single_step:
+	finish_interrupt_save handle_interrupt_no_single_step
+	{
+	 jalr   r0
+	 PTREGS_PTR(r0, PTREGS_OFFSET_BASE)
+	}
+	FEEDBACK_REENTER(handle_interrupt_no_single_step)
+	{
+	 movei  r30, 0   /* not an NMI */
+	 j      interrupt_return
+	}
+	STD_ENDPROC(handle_interrupt_no_single_step)
+
+	/*
+	 * "NMI" interrupts mask ALL interrupts before calling the
+	 * handler, and don't check thread flags, etc., on the way
+	 * back out.  In general, the only things we do here for NMIs
+	 * are the register save/restore, fixing the PC if we were
+	 * doing single step, and the dataplane kernel-TLB management.
+	 * We don't (for example) deal with start/stop of the sched tick.
+	 */
+	.pushsection .text.handle_nmi,"ax"
+handle_nmi:
+	finish_interrupt_save handle_nmi
+	check_single_stepping normal, .Ldispatch_nmi
+.Ldispatch_nmi:
+	{
+	 jalr   r0
+	 PTREGS_PTR(r0, PTREGS_OFFSET_BASE)
+	}
+	FEEDBACK_REENTER(handle_nmi)
+	j       interrupt_return
+	STD_ENDPROC(handle_nmi)
+
+	/*
+	 * Parallel code for syscalls to handle_interrupt.
+	 */
+	.pushsection .text.handle_syscall,"ax"
+handle_syscall:
+	finish_interrupt_save handle_syscall
+
+	/*
+	 * Check for if we are single stepping in user level. If so, then
+	 * we need to restore the PC.
+	 */
+	check_single_stepping syscall, .Ldispatch_syscall
+.Ldispatch_syscall:
+
+	/* Enable irqs. */
+	TRACE_IRQS_ON
+	IRQ_ENABLE(r20, r21)
+
+	/* Bump the counter for syscalls made on this tile. */
+	moveli  r20, lo16(irq_stat + IRQ_CPUSTAT_SYSCALL_COUNT_OFFSET)
+	auli    r20, r20, ha16(irq_stat + IRQ_CPUSTAT_SYSCALL_COUNT_OFFSET)
+	add     r20, r20, tp
+	lw      r21, r20
+	addi    r21, r21, 1
+	sw      r20, r21
+
+	/* Trace syscalls, if requested. */
+	GET_THREAD_INFO(r31)
+	addi	r31, r31, THREAD_INFO_FLAGS_OFFSET
+	lw	r30, r31
+	andi    r30, r30, _TIF_SYSCALL_TRACE
+	bzt	r30, .Lrestore_syscall_regs
+	jal	do_syscall_trace
+	FEEDBACK_REENTER(handle_syscall)
+
+	/*
+	 * We always reload our registers from the stack at this
+	 * point.  They might be valid, if we didn't build with
+	 * TRACE_IRQFLAGS, and this isn't a dataplane tile, and we're not
+	 * doing syscall tracing, but there are enough cases now that it
+	 * seems simplest just to do the reload unconditionally.
+	 */
+.Lrestore_syscall_regs:
+	PTREGS_PTR(r11, PTREGS_OFFSET_REG(0))
+	pop_reg r0, r11
+	pop_reg r1, r11
+	pop_reg r2, r11
+	pop_reg r3, r11
+	pop_reg r4, r11
+	pop_reg r5, r11, PTREGS_OFFSET_SYSCALL - PTREGS_OFFSET_REG(5)
+	pop_reg TREG_SYSCALL_NR_NAME, r11
+
+	/* Ensure that the syscall number is within the legal range. */
+	moveli  r21, __NR_syscalls
+	{
+	 slt_u  r21, TREG_SYSCALL_NR_NAME, r21
+	 moveli r20, lo16(sys_call_table)
+	}
+	{
+	 bbns   r21, .Linvalid_syscall
+	 auli   r20, r20, ha16(sys_call_table)
+	}
+	s2a     r20, TREG_SYSCALL_NR_NAME, r20
+	lw      r20, r20
+
+	/* Jump to syscall handler. */
+	jalr    r20; .Lhandle_syscall_link:
+	FEEDBACK_REENTER(handle_syscall)
+
+	/*
+	 * Write our r0 onto the stack so it gets restored instead
+	 * of whatever the user had there before.
+	 */
+	PTREGS_PTR(r29, PTREGS_OFFSET_REG(0))
+	sw      r29, r0
+
+	/* Do syscall trace again, if requested. */
+	lw	r30, r31
+	andi    r30, r30, _TIF_SYSCALL_TRACE
+	bzt     r30, 1f
+	jal	do_syscall_trace
+	FEEDBACK_REENTER(handle_syscall)
+1:	j       .Lresume_userspace   /* jump into middle of interrupt_return */
+
+.Linvalid_syscall:
+	/* Report an invalid syscall back to the user program */
+	{
+	 PTREGS_PTR(r29, PTREGS_OFFSET_REG(0))
+	 movei  r28, -ENOSYS
+	}
+	sw      r29, r28
+	j       .Lresume_userspace   /* jump into middle of interrupt_return */
+	STD_ENDPROC(handle_syscall)
+
+	/* Return the address for oprofile to suppress in backtraces. */
+STD_ENTRY_SECTION(handle_syscall_link_address, .text.handle_syscall)
+	lnk     r0
+	{
+	 addli  r0, r0, .Lhandle_syscall_link - .
+	 jrp    lr
+	}
+	STD_ENDPROC(handle_syscall_link_address)
+
+STD_ENTRY(ret_from_fork)
+	jal     sim_notify_fork
+	jal     schedule_tail
+	FEEDBACK_REENTER(ret_from_fork)
+	j       .Lresume_userspace   /* jump into middle of interrupt_return */
+	STD_ENDPROC(ret_from_fork)
+
+	/*
+	 * Code for ill interrupt.
+	 */
+	.pushsection .text.handle_ill,"ax"
+handle_ill:
+	finish_interrupt_save handle_ill
+
+	/*
+	 * Check for if we are single stepping in user level. If so, then
+	 * we need to restore the PC.
+	 */
+	check_single_stepping ill, .Ldispatch_normal_ill
+
+	{
+	 /* See if the PC is the 1st bundle in the buffer */
+	 seq    r25, r27, r26
+
+	 /* Point to the 2nd bundle in the buffer */
+	 addi   r26, r26, 8
+	}
+	{
+	 /* Point to the original pc */
+	 addi   r24, r29, SINGLESTEP_STATE_ORIG_PC_OFFSET
+
+	 /* Branch if the PC is the 1st bundle in the buffer */
+	 bnz    r25, 3f
+	}
+	{
+	 /* See if the PC is the 2nd bundle of the buffer */
+	 seq    r25, r27, r26
+
+	 /* Set PC to next instruction */
+	 addi   r24, r29, SINGLESTEP_STATE_NEXT_PC_OFFSET
+	}
+	{
+	 /* Point to flags */
+	 addi   r25, r29, SINGLESTEP_STATE_FLAGS_OFFSET
+
+	 /* Branch if PC is in the second bundle */
+	 bz     r25, 2f
+	}
+	/* Load flags */
+	lw      r25, r25
+	{
+	 /*
+	  * Get the offset for the register to restore
+	  * Note: the lower bound is 2, so we have implicit scaling by 4.
+	  *  No multiplication of the register number by the size of a register
+	  *  is needed.
+	  */
+	 mm     r27, r25, zero, SINGLESTEP_STATE_TARGET_LB, \
+		SINGLESTEP_STATE_TARGET_UB
+
+	 /* Mask Rewrite_LR */
+	 andi   r25, r25, SINGLESTEP_STATE_MASK_UPDATE
+	}
+	{
+	 addi   r29, r29, SINGLESTEP_STATE_UPDATE_VALUE_OFFSET
+
+	 /* Don't rewrite temp register */
+	 bz     r25, 3f
+	}
+	{
+	 /* Get the temp value */
+	 lw     r29, r29
+
+	 /* Point to where the register is stored */
+	 add    r27, r27, sp
+	}
+
+	/* Add in the C ABI save area size to the register offset */
+	addi    r27, r27, C_ABI_SAVE_AREA_SIZE
+
+	/* Restore the user's register with the temp value */
+	sw      r27, r29
+	j       3f
+
+2:
+	/* Must be in the third bundle */
+	addi    r24, r29, SINGLESTEP_STATE_BRANCH_NEXT_PC_OFFSET
+
+3:
+	/* set PC and continue */
+	lw      r26, r24
+	sw      r28, r26
+
+	/* Clear TIF_SINGLESTEP */
+	GET_THREAD_INFO(r0)
+
+	addi    r1, r0, THREAD_INFO_FLAGS_OFFSET
+	{
+	 lw     r2, r1
+	 addi   r0, r0, THREAD_INFO_TASK_OFFSET  /* currently a no-op */
+	}
+	andi    r2, r2, ~_TIF_SINGLESTEP
+	sw      r1, r2
+
+	/* Issue a sigtrap */
+	{
+	 lw     r0, r0          /* indirect thru thread_info to get task_info*/
+	 addi   r1, sp, C_ABI_SAVE_AREA_SIZE  /* put ptregs pointer into r1 */
+	 move   r2, zero        /* load error code into r2 */
+	}
+
+	jal     send_sigtrap    /* issue a SIGTRAP */
+	FEEDBACK_REENTER(handle_ill)
+	j       .Lresume_userspace   /* jump into middle of interrupt_return */
+
+.Ldispatch_normal_ill:
+	{
+	 jalr   r0
+	 PTREGS_PTR(r0, PTREGS_OFFSET_BASE)
+	}
+	FEEDBACK_REENTER(handle_ill)
+	{
+	 movei  r30, 0   /* not an NMI */
+	 j      interrupt_return
+	}
+	STD_ENDPROC(handle_ill)
+
+	.pushsection .rodata, "a"
+	.align  8
+bpt_code:
+	bpt
+	ENDPROC(bpt_code)
+	.popsection
+
+/* Various stub interrupt handlers and syscall handlers */
+
+STD_ENTRY_LOCAL(_kernel_double_fault)
+	mfspr   r1, EX_CONTEXT_1_0
+	move    r2, lr
+	move    r3, sp
+	move    r4, r52
+	addi    sp, sp, -C_ABI_SAVE_AREA_SIZE
+	j       kernel_double_fault
+	STD_ENDPROC(_kernel_double_fault)
+
+STD_ENTRY_LOCAL(bad_intr)
+	mfspr   r2, EX_CONTEXT_1_0
+	panic   "Unhandled interrupt %#x: PC %#lx"
+	STD_ENDPROC(bad_intr)
+
+/* Put address of pt_regs in reg and jump. */
+#define PTREGS_SYSCALL(x, reg)                          \
+	STD_ENTRY(x);                                   \
+	{                                               \
+	 PTREGS_PTR(reg, PTREGS_OFFSET_BASE);           \
+	 j      _##x                                    \
+	};                                              \
+	STD_ENDPROC(x)
+
+PTREGS_SYSCALL(sys_execve, r3)
+PTREGS_SYSCALL(sys_sigaltstack, r2)
+PTREGS_SYSCALL(sys_rt_sigreturn, r0)
+
+/* Save additional callee-saves to pt_regs, put address in reg and jump. */
+#define PTREGS_SYSCALL_ALL_REGS(x, reg)                 \
+	STD_ENTRY(x);                                   \
+	push_extra_callee_saves reg;                    \
+	j       _##x;                                   \
+	STD_ENDPROC(x)
+
+PTREGS_SYSCALL_ALL_REGS(sys_fork, r0)
+PTREGS_SYSCALL_ALL_REGS(sys_vfork, r0)
+PTREGS_SYSCALL_ALL_REGS(sys_clone, r4)
+PTREGS_SYSCALL_ALL_REGS(sys_cmpxchg_badaddr, r1)
+
+/*
+ * This entrypoint is taken for the cmpxchg and atomic_update fast
+ * swints.  We may wish to generalize it to other fast swints at some
+ * point, but for now there are just two very similar ones, which
+ * makes it faster.
+ *
+ * The fast swint code is designed to have a small footprint.  It does
+ * not save or restore any GPRs, counting on the caller-save registers
+ * to be available to it on entry.  It does not modify any callee-save
+ * registers (including "lr").  It does not check what PL it is being
+ * called at, so you'd better not call it other than at PL0.
+ *
+ * It does not use the stack, but since it might be re-interrupted by
+ * a page fault which would assume the stack was valid, it does
+ * save/restore the stack pointer and zero it out to make sure it gets reset.
+ * Since we always keep interrupts disabled, the hypervisor won't
+ * clobber our EX_CONTEXT_1_x registers, so we don't save/restore them
+ * (other than to advance the PC on return).
+ *
+ * We have to manually validate the user vs kernel address range
+ * (since at PL1 we can read/write both), and for performance reasons
+ * we don't allow cmpxchg on the fc000000 memory region, since we only
+ * validate that the user address is below PAGE_OFFSET.
+ *
+ * We place it in the __HEAD section to ensure it is relatively
+ * near to the intvec_SWINT_1 code (reachable by a conditional branch).
+ *
+ * Must match register usage in do_page_fault().
+ */
+	__HEAD
+	.align 64
+	/* Align much later jump on the start of a cache line. */
+#if !ATOMIC_LOCKS_FOUND_VIA_TABLE()
+	nop; nop
+#endif
+ENTRY(sys_cmpxchg)
+
+	/*
+	 * Save "sp" and set it zero for any possible page fault.
+	 *
+	 * HACK: We want to both zero sp and check r0's alignment,
+	 * so we do both at once. If "sp" becomes nonzero we
+	 * know r0 is unaligned and branch to the error handler that
+	 * restores sp, so this is OK.
+	 *
+	 * ICS is disabled right now so having a garbage but nonzero
+	 * sp is OK, since we won't execute any faulting instructions
+	 * when it is nonzero.
+	 */
+	{
+	 move   r27, sp
+	 andi	sp, r0, 3
+	}
+
+	/*
+	 * Get the lock address in ATOMIC_LOCK_REG, and also validate that the
+	 * address is less than PAGE_OFFSET, since that won't trap at PL1.
+	 * We only use bits less than PAGE_SHIFT to avoid having to worry
+	 * about aliasing among multiple mappings of the same physical page,
+	 * and we ignore the low 3 bits so we have one lock that covers
+	 * both a cmpxchg64() and a cmpxchg() on either its low or high word.
+	 * NOTE: this code must match __atomic_hashed_lock() in lib/atomic.c.
+	 */
+
+#if ATOMIC_LOCKS_FOUND_VIA_TABLE()
+	{
+	 /* Check for unaligned input. */
+	 bnz    sp, .Lcmpxchg_badaddr
+	 mm     r25, r0, zero, 3, PAGE_SHIFT-1
+	}
+	{
+	 crc32_32 r25, zero, r25
+	 moveli r21, lo16(atomic_lock_ptr)
+	}
+	{
+	 auli   r21, r21, ha16(atomic_lock_ptr)
+	 auli   r23, zero, hi16(PAGE_OFFSET)  /* hugepage-aligned */
+	}
+	{
+	 shri	r20, r25, 32 - ATOMIC_HASH_L1_SHIFT
+	 slt_u  r23, r0, r23
+
+	 /*
+	  * Ensure that the TLB is loaded before we take out the lock.
+	  * On TILEPro, this will start fetching the value all the way
+	  * into our L1 as well (and if it gets modified before we
+	  * grab the lock, it will be invalidated from our cache
+	  * before we reload it).  On tile64, we'll start fetching it
+	  * into our L1 if we're the home, and if we're not, we'll
+	  * still at least start fetching it into the home's L2.
+	  */
+	 lw	r26, r0
+	}
+	{
+	 s2a    r21, r20, r21
+	 bbns   r23, .Lcmpxchg_badaddr
+	}
+	{
+	 lw     r21, r21
+	 seqi	r23, TREG_SYSCALL_NR_NAME, __NR_FAST_cmpxchg64
+	 andi	r25, r25, ATOMIC_HASH_L2_SIZE - 1
+	}
+	{
+	 /* Branch away at this point if we're doing a 64-bit cmpxchg. */
+	 bbs    r23, .Lcmpxchg64
+	 andi   r23, r0, 7       /* Precompute alignment for cmpxchg64. */
+	}
+
+	{
+	 /*
+	  * We very carefully align the code that actually runs with
+	  * the lock held (nine bundles) so that we know it is all in
+	  * the icache when we start.  This instruction (the jump) is
+	  * at the start of the first cache line, address zero mod 64;
+	  * we jump to somewhere in the second cache line to issue the
+	  * tns, then jump back to finish up.
+	  */
+	 s2a	ATOMIC_LOCK_REG_NAME, r25, r21
+	 j      .Lcmpxchg32_tns
+	}
+
+#else /* ATOMIC_LOCKS_FOUND_VIA_TABLE() */
+	{
+	 /* Check for unaligned input. */
+	 bnz    sp, .Lcmpxchg_badaddr
+	 auli   r23, zero, hi16(PAGE_OFFSET)  /* hugepage-aligned */
+	}
+	{
+	 /*
+	  * Slide bits into position for 'mm'. We want to ignore
+	  * the low 3 bits of r0, and consider only the next
+	  * ATOMIC_HASH_SHIFT bits.
+	  * Because of C pointer arithmetic, we want to compute this:
+	  *
+	  * ((char*)atomic_locks +
+	  *  (((r0 >> 3) & (1 << (ATOMIC_HASH_SIZE - 1))) << 2))
+	  *
+	  * Instead of two shifts we just ">> 1", and use 'mm'
+	  * to ignore the low and high bits we don't want.
+	  */
+	 shri	r25, r0, 1
+
+	 slt_u  r23, r0, r23
+
+	 /*
+	  * Ensure that the TLB is loaded before we take out the lock.
+	  * On tilepro, this will start fetching the value all the way
+	  * into our L1 as well (and if it gets modified before we
+	  * grab the lock, it will be invalidated from our cache
+	  * before we reload it).  On tile64, we'll start fetching it
+	  * into our L1 if we're the home, and if we're not, we'll
+	  * still at least start fetching it into the home's L2.
+	  */
+	 lw	r26, r0
+	}
+	{
+	 /* atomic_locks is page aligned so this suffices to get its addr. */
+	 auli	r21, zero, hi16(atomic_locks)
+
+	 bbns   r23, .Lcmpxchg_badaddr
+	}
+	{
+	 /*
+	  * Insert the hash bits into the page-aligned pointer.
+	  * ATOMIC_HASH_SHIFT is so big that we don't actually hash
+	  * the unmasked address bits, as that may cause unnecessary
+	  * collisions.
+	  */
+	 mm	ATOMIC_LOCK_REG_NAME, r25, r21, 2, (ATOMIC_HASH_SHIFT + 2) - 1
+
+	 seqi	r23, TREG_SYSCALL_NR_NAME, __NR_FAST_cmpxchg64
+	}
+	{
+	 /* Branch away at this point if we're doing a 64-bit cmpxchg. */
+	 bbs    r23, .Lcmpxchg64
+	 andi   r23, r0, 7       /* Precompute alignment for cmpxchg64. */
+	}
+	{
+	 /*
+	  * We very carefully align the code that actually runs with
+	  * the lock held (nine bundles) so that we know it is all in
+	  * the icache when we start.  This instruction (the jump) is
+	  * at the start of the first cache line, address zero mod 64;
+	  * we jump to somewhere in the second cache line to issue the
+	  * tns, then jump back to finish up.
+	  */
+	 j      .Lcmpxchg32_tns
+	}
+
+#endif /* ATOMIC_LOCKS_FOUND_VIA_TABLE() */
+
+	ENTRY(__sys_cmpxchg_grab_lock)
+
+	/*
+	 * Perform the actual cmpxchg or atomic_update.
+	 * Note that __futex_mark_unlocked() in uClibc relies on
+	 * atomic_update() to always perform an "mf", so don't make
+	 * it optional or conditional without modifying that code.
+	 */
+.Ldo_cmpxchg32:
+	{
+	 lw     r21, r0
+	 seqi	r23, TREG_SYSCALL_NR_NAME, __NR_FAST_atomic_update
+	 move	r24, r2
+	}
+	{
+	 seq    r22, r21, r1     /* See if cmpxchg matches. */
+	 and	r25, r21, r1     /* If atomic_update, compute (*mem & mask) */
+	}
+	{
+	 or	r22, r22, r23    /* Skip compare branch for atomic_update. */
+	 add	r25, r25, r2     /* Compute (*mem & mask) + addend. */
+	}
+	{
+	 mvnz	r24, r23, r25    /* Use atomic_update value if appropriate. */
+	 bbns   r22, .Lcmpxchg32_mismatch
+	}
+	sw      r0, r24
+
+	/* Do slow mtspr here so the following "mf" waits less. */
+	{
+	 move   sp, r27
+	 mtspr  EX_CONTEXT_1_0, r28
+	}
+	mf
+
+	/* The following instruction is the start of the second cache line. */
+	{
+	 move   r0, r21
+	 sw     ATOMIC_LOCK_REG_NAME, zero
+	}
+	iret
+
+	/* Duplicated code here in the case where we don't overlap "mf" */
+.Lcmpxchg32_mismatch:
+	{
+	 move   r0, r21
+	 sw     ATOMIC_LOCK_REG_NAME, zero
+	}
+	{
+	 move   sp, r27
+	 mtspr  EX_CONTEXT_1_0, r28
+	}
+	iret
+
+	/*
+	 * The locking code is the same for 32-bit cmpxchg/atomic_update,
+	 * and for 64-bit cmpxchg.  We provide it as a macro and put
+	 * it into both versions.  We can't share the code literally
+	 * since it depends on having the right branch-back address.
+	 * Note that the first few instructions should share the cache
+	 * line with the second half of the actual locked code.
+	 */
+	.macro  cmpxchg_lock, bitwidth
+
+	/* Lock; if we succeed, jump back up to the read-modify-write. */
+#ifdef CONFIG_SMP
+	tns     r21, ATOMIC_LOCK_REG_NAME
+#else
+	/*
+	 * Non-SMP preserves all the lock infrastructure, to keep the
+	 * code simpler for the interesting (SMP) case.  However, we do
+	 * one small optimization here and in atomic_asm.S, which is
+	 * to fake out acquiring the actual lock in the atomic_lock table.
+	 */
+	movei	r21, 0
+#endif
+
+	/* Issue the slow SPR here while the tns result is in flight. */
+	mfspr   r28, EX_CONTEXT_1_0
+
+	{
+	 addi   r28, r28, 8    /* return to the instruction after the swint1 */
+	 bzt    r21, .Ldo_cmpxchg\bitwidth
+	}
+	/*
+	 * The preceding instruction is the last thing that must be
+	 * on the second cache line.
+	 */
+
+#ifdef CONFIG_SMP
+	/*
+	 * We failed to acquire the tns lock on our first try.  Now use
+	 * bounded exponential backoff to retry, like __atomic_spinlock().
+	 */
+	{
+	 moveli r23, 2048       /* maximum backoff time in cycles */
+	 moveli r25, 32         /* starting backoff time in cycles */
+	}
+1:	mfspr   r26, CYCLE_LOW  /* get start point for this backoff */
+2:	mfspr   r22, CYCLE_LOW  /* test to see if we've backed off enough */
+	sub     r22, r22, r26
+	slt     r22, r22, r25
+	bbst    r22, 2b
+	{
+	 shli   r25, r25, 1     /* double the backoff; retry the tns */
+	 tns    r21, ATOMIC_LOCK_REG_NAME
+	}
+	slt     r26, r23, r25   /* is the proposed backoff too big? */
+	{
+	 mvnz   r25, r26, r23
+	 bzt    r21, .Ldo_cmpxchg\bitwidth
+	}
+	j       1b
+#endif /* CONFIG_SMP */
+	.endm
+
+.Lcmpxchg32_tns:
+	cmpxchg_lock 32
+
+	/*
+	 * This code is invoked from sys_cmpxchg after most of the
+	 * preconditions have been checked.  We still need to check
+	 * that r0 is 8-byte aligned, since if it's not we won't
+	 * actually be atomic.  However, ATOMIC_LOCK_REG has the atomic
+	 * lock pointer and r27/r28 have the saved SP/PC.
+	 * r23 is holding "r0 & 7" so we can test for alignment.
+	 * The compare value is in r2/r3; the new value is in r4/r5.
+	 * On return, we must put the old value in r0/r1.
+	 */
+	.align 64
+.Lcmpxchg64:
+	{
+#if ATOMIC_LOCKS_FOUND_VIA_TABLE()
+	 s2a	ATOMIC_LOCK_REG_NAME, r25, r21
+#endif
+	 bzt     r23, .Lcmpxchg64_tns
+	}
+	j       .Lcmpxchg_badaddr
+
+.Ldo_cmpxchg64:
+	{
+	 lw     r21, r0
+	 addi   r25, r0, 4
+	}
+	{
+	 lw     r1, r25
+	}
+	seq     r26, r21, r2
+	{
+	 bz     r26, .Lcmpxchg64_mismatch
+	 seq    r26, r1, r3
+	}
+	{
+	 bz     r26, .Lcmpxchg64_mismatch
+	}
+	sw      r0, r4
+	sw      r25, r5
+
+	/*
+	 * The 32-bit path provides optimized "match" and "mismatch"
+	 * iret paths, but we don't have enough bundles in this cache line
+	 * to do that, so we just make even the "mismatch" path do an "mf".
+	 */
+.Lcmpxchg64_mismatch:
+	{
+	 move   sp, r27
+	 mtspr  EX_CONTEXT_1_0, r28
+	}
+	mf
+	{
+	 move   r0, r21
+	 sw     ATOMIC_LOCK_REG_NAME, zero
+	}
+	iret
+
+.Lcmpxchg64_tns:
+	cmpxchg_lock 64
+
+
+	/*
+	 * Reset sp and revector to sys_cmpxchg_badaddr(), which will
+	 * just raise the appropriate signal and exit.  Doing it this
+	 * way means we don't have to duplicate the code in intvec.S's
+	 * int_hand macro that locates the top of the stack.
+	 */
+.Lcmpxchg_badaddr:
+	{
+	 moveli TREG_SYSCALL_NR_NAME, __NR_cmpxchg_badaddr
+	 move   sp, r27
+	}
+	j       intvec_SWINT_1
+	ENDPROC(sys_cmpxchg)
+	ENTRY(__sys_cmpxchg_end)
+
+
+/* The single-step support may need to read all the registers. */
+int_unalign:
+	push_extra_callee_saves r0
+	j       do_trap
+
+/* Include .intrpt1 array of interrupt vectors */
+	.section ".intrpt1", "ax"
+
+#define op_handle_perf_interrupt bad_intr
+#define op_handle_aux_perf_interrupt bad_intr
+
+#define do_hardwall_trap bad_intr
+
+	int_hand     INT_ITLB_MISS, ITLB_MISS, \
+		     do_page_fault, handle_interrupt_no_single_step
+	int_hand     INT_MEM_ERROR, MEM_ERROR, bad_intr
+	int_hand     INT_ILL, ILL, do_trap, handle_ill
+	int_hand     INT_GPV, GPV, do_trap
+	int_hand     INT_SN_ACCESS, SN_ACCESS, do_trap
+	int_hand     INT_IDN_ACCESS, IDN_ACCESS, do_trap
+	int_hand     INT_UDN_ACCESS, UDN_ACCESS, do_trap
+	int_hand     INT_IDN_REFILL, IDN_REFILL, bad_intr
+	int_hand     INT_UDN_REFILL, UDN_REFILL, bad_intr
+	int_hand     INT_IDN_COMPLETE, IDN_COMPLETE, bad_intr
+	int_hand     INT_UDN_COMPLETE, UDN_COMPLETE, bad_intr
+	int_hand     INT_SWINT_3, SWINT_3, do_trap
+	int_hand     INT_SWINT_2, SWINT_2, do_trap
+	int_hand     INT_SWINT_1, SWINT_1, SYSCALL, handle_syscall
+	int_hand     INT_SWINT_0, SWINT_0, do_trap
+	int_hand     INT_UNALIGN_DATA, UNALIGN_DATA, int_unalign
+	int_hand     INT_DTLB_MISS, DTLB_MISS, do_page_fault
+	int_hand     INT_DTLB_ACCESS, DTLB_ACCESS, do_page_fault
+	int_hand     INT_DMATLB_MISS, DMATLB_MISS, do_page_fault
+	int_hand     INT_DMATLB_ACCESS, DMATLB_ACCESS, do_page_fault
+	int_hand     INT_SNITLB_MISS, SNITLB_MISS, do_page_fault
+	int_hand     INT_SN_NOTIFY, SN_NOTIFY, bad_intr
+	int_hand     INT_SN_FIREWALL, SN_FIREWALL, do_hardwall_trap
+	int_hand     INT_IDN_FIREWALL, IDN_FIREWALL, bad_intr
+	int_hand     INT_UDN_FIREWALL, UDN_FIREWALL, do_hardwall_trap
+	int_hand     INT_TILE_TIMER, TILE_TIMER, do_timer_interrupt
+	int_hand     INT_IDN_TIMER, IDN_TIMER, bad_intr
+	int_hand     INT_UDN_TIMER, UDN_TIMER, bad_intr
+	int_hand     INT_DMA_NOTIFY, DMA_NOTIFY, bad_intr
+	int_hand     INT_IDN_CA, IDN_CA, bad_intr
+	int_hand     INT_UDN_CA, UDN_CA, bad_intr
+	int_hand     INT_IDN_AVAIL, IDN_AVAIL, bad_intr
+	int_hand     INT_UDN_AVAIL, UDN_AVAIL, bad_intr
+	int_hand     INT_PERF_COUNT, PERF_COUNT, \
+		     op_handle_perf_interrupt, handle_nmi
+	int_hand     INT_INTCTRL_3, INTCTRL_3, bad_intr
+	int_hand     INT_INTCTRL_2, INTCTRL_2, bad_intr
+	dc_dispatch  INT_INTCTRL_1, INTCTRL_1
+	int_hand     INT_INTCTRL_0, INTCTRL_0, bad_intr
+	int_hand     INT_MESSAGE_RCV_DWNCL, MESSAGE_RCV_DWNCL, \
+		     hv_message_intr, handle_interrupt_downcall
+	int_hand     INT_DEV_INTR_DWNCL, DEV_INTR_DWNCL, \
+		     tile_dev_intr, handle_interrupt_downcall
+	int_hand     INT_I_ASID, I_ASID, bad_intr
+	int_hand     INT_D_ASID, D_ASID, bad_intr
+	int_hand     INT_DMATLB_MISS_DWNCL, DMATLB_MISS_DWNCL, \
+		     do_page_fault, handle_interrupt_downcall
+	int_hand     INT_SNITLB_MISS_DWNCL, SNITLB_MISS_DWNCL, \
+		     do_page_fault, handle_interrupt_downcall
+	int_hand     INT_DMATLB_ACCESS_DWNCL, DMATLB_ACCESS_DWNCL, \
+		     do_page_fault, handle_interrupt_downcall
+	int_hand     INT_SN_CPL, SN_CPL, bad_intr
+	int_hand     INT_DOUBLE_FAULT, DOUBLE_FAULT, do_trap
+#if CHIP_HAS_AUX_PERF_COUNTERS()
+	int_hand     INT_AUX_PERF_COUNT, AUX_PERF_COUNT, \
+		     op_handle_aux_perf_interrupt, handle_nmi
+#endif
+
+	/* Synthetic interrupt delivered only by the simulator */
+	int_hand     INT_BREAKPOINT, BREAKPOINT, do_breakpoint
diff --git a/arch/tile/kernel/irq.c b/arch/tile/kernel/irq.c
new file mode 100644
index 0000000..24cc6b2
--- /dev/null
+++ b/arch/tile/kernel/irq.c
@@ -0,0 +1,227 @@
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
+#include <linux/module.h>
+#include <linux/seq_file.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/kernel_stat.h>
+#include <linux/uaccess.h>
+#include <hv/drv_pcie_rc_intf.h>
+
+/*
+ * The set of interrupts we enable for raw_local_irq_enable().
+ * This is initialized to have just a single interrupt that the kernel
+ * doesn't actually use as a sentinel.  During kernel init,
+ * interrupts are added as the kernel gets prepared to support them.
+ * NOTE: we could probably initialize them all statically up front.
+ */
+DEFINE_PER_CPU(unsigned long long, interrupts_enabled_mask) =
+  INITIAL_INTERRUPTS_ENABLED;
+EXPORT_PER_CPU_SYMBOL(interrupts_enabled_mask);
+
+/* Define per-tile device interrupt state */
+DEFINE_PER_CPU(HV_IntrState, dev_intr_state);
+
+DEFINE_PER_CPU(irq_cpustat_t, irq_stat) ____cacheline_internodealigned_in_smp;
+EXPORT_PER_CPU_SYMBOL(irq_stat);
+
+
+
+/*
+ * Interrupt dispatcher, invoked upon a hypervisor device interrupt downcall
+ */
+void tile_dev_intr(struct pt_regs *regs, int intnum)
+{
+	int irq;
+
+	/*
+	 * Get the device interrupt pending mask from where the hypervisor
+	 * has tucked it away for us.
+	 */
+	unsigned long pending_dev_intr_mask = __insn_mfspr(SPR_SYSTEM_SAVE_1_3);
+
+
+	/* Track time spent here in an interrupt context. */
+	struct pt_regs *old_regs = set_irq_regs(regs);
+	irq_enter();
+
+#ifdef CONFIG_DEBUG_STACKOVERFLOW
+	/* Debugging check for stack overflow: less than 1/8th stack free? */
+	{
+		long sp = stack_pointer - (long) current_thread_info();
+		if (unlikely(sp < (sizeof(struct thread_info) + STACK_WARN))) {
+			printk(KERN_EMERG "tile_dev_intr: "
+			       "stack overflow: %ld\n",
+			       sp - sizeof(struct thread_info));
+			dump_stack();
+		}
+	}
+#endif
+
+	for (irq = 0; pending_dev_intr_mask; ++irq) {
+		if (pending_dev_intr_mask & 0x1) {
+			generic_handle_irq(irq);
+
+			/* Count device irqs; IPIs are counted elsewhere. */
+			if (irq > HV_MAX_IPI_INTERRUPT)
+				__get_cpu_var(irq_stat).irq_dev_intr_count++;
+		}
+		pending_dev_intr_mask >>= 1;
+	}
+
+	/*
+	 * Track time spent against the current process again and
+	 * process any softirqs if they are waiting.
+	 */
+	irq_exit();
+	set_irq_regs(old_regs);
+}
+
+
+/* Mask an interrupt. */
+static void hv_dev_irq_mask(unsigned int irq)
+{
+	HV_IntrState *p_intr_state = &__get_cpu_var(dev_intr_state);
+	hv_disable_intr(p_intr_state, 1 << irq);
+}
+
+/* Unmask an interrupt. */
+static void hv_dev_irq_unmask(unsigned int irq)
+{
+	/* Re-enable the hypervisor to generate interrupts. */
+	HV_IntrState *p_intr_state = &__get_cpu_var(dev_intr_state);
+	hv_enable_intr(p_intr_state, 1 << irq);
+}
+
+/*
+ * The HV doesn't latch incoming interrupts while an interrupt is
+ * disabled, so we need to reenable interrupts before running the
+ * handler.
+ *
+ * ISSUE: Enabling the interrupt this early avoids any race conditions
+ * but introduces the possibility of nested interrupt stack overflow.
+ * An imminent change to the HV IRQ model will fix this.
+ */
+static void hv_dev_irq_ack(unsigned int irq)
+{
+	hv_dev_irq_unmask(irq);
+}
+
+/*
+ * Since ack() reenables interrupts, there's nothing to do at eoi().
+ */
+static void hv_dev_irq_eoi(unsigned int irq)
+{
+}
+
+static struct irq_chip hv_dev_irq_chip = {
+	.typename = "hv_dev_irq_chip",
+	.ack = hv_dev_irq_ack,
+	.mask = hv_dev_irq_mask,
+	.unmask = hv_dev_irq_unmask,
+	.eoi = hv_dev_irq_eoi,
+};
+
+static struct irqaction resched_action = {
+	.handler = handle_reschedule_ipi,
+	.name = "resched",
+	.dev_id = handle_reschedule_ipi /* unique token */,
+};
+
+void __init init_IRQ(void)
+{
+	/* Bind IPI irqs. Does this belong somewhere else in init? */
+	tile_irq_activate(IRQ_RESCHEDULE);
+	BUG_ON(setup_irq(IRQ_RESCHEDULE, &resched_action));
+}
+
+void __cpuinit init_per_tile_IRQs(void)
+{
+	int rc;
+
+	/* Set the pointer to the per-tile device interrupt state. */
+	HV_IntrState *sv_ptr = &__get_cpu_var(dev_intr_state);
+	rc = hv_dev_register_intr_state(sv_ptr);
+	if (rc != HV_OK)
+		panic("hv_dev_register_intr_state: error %d", rc);
+
+}
+
+void tile_irq_activate(unsigned int irq)
+{
+	/*
+	 * Paravirtualized drivers can call up to the HV to find out
+	 * which irq they're associated with.  The HV interface
+	 * doesn't provide a generic call for discovering all valid
+	 * IRQs, so drivers must call this method to initialize newly
+	 * discovered IRQs.
+	 *
+	 * We could also just initialize all 32 IRQs at startup, but
+	 * doing so would lead to a kernel fault if an unexpected
+	 * interrupt fires and jumps to a NULL action.  By defering
+	 * the set_irq_chip_and_handler() call, unexpected IRQs are
+	 * handled properly by handle_bad_irq().
+	 */
+	hv_dev_irq_mask(irq);
+	set_irq_chip_and_handler(irq, &hv_dev_irq_chip, handle_percpu_irq);
+}
+
+void ack_bad_irq(unsigned int irq)
+{
+	printk(KERN_ERR "unexpected IRQ trap at vector %02x\n", irq);
+}
+
+/*
+ * Generic, controller-independent functions:
+ */
+
+int show_interrupts(struct seq_file *p, void *v)
+{
+	int i = *(loff_t *) v, j;
+	struct irqaction *action;
+	unsigned long flags;
+
+	if (i == 0) {
+		seq_printf(p, "           ");
+		for (j = 0; j < NR_CPUS; j++)
+			if (cpu_online(j))
+				seq_printf(p, "CPU%-8d", j);
+		seq_putc(p, '\n');
+	}
+
+	if (i < NR_IRQS) {
+		raw_spin_lock_irqsave(&irq_desc[i].lock, flags);
+		action = irq_desc[i].action;
+		if (!action)
+			goto skip;
+		seq_printf(p, "%3d: ", i);
+#ifndef CONFIG_SMP
+		seq_printf(p, "%10u ", kstat_irqs(i));
+#else
+		for_each_online_cpu(j)
+			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
+#endif
+		seq_printf(p, " %14s", irq_desc[i].chip->typename);
+		seq_printf(p, "  %s", action->name);
+
+		for (action = action->next; action; action = action->next)
+			seq_printf(p, ", %s", action->name);
+
+		seq_putc(p, '\n');
+skip:
+		raw_spin_unlock_irqrestore(&irq_desc[i].lock, flags);
+	}
+	return 0;
+}
diff --git a/arch/tile/kernel/machine_kexec.c b/arch/tile/kernel/machine_kexec.c
new file mode 100644
index 0000000..ed3e1cb
--- /dev/null
+++ b/arch/tile/kernel/machine_kexec.c
@@ -0,0 +1,291 @@
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
+ *
+ * based on machine_kexec.c from other architectures in linux-2.6.18
+ */
+
+#include <linux/mm.h>
+#include <linux/kexec.h>
+#include <linux/delay.h>
+#include <linux/reboot.h>
+#include <linux/errno.h>
+#include <linux/vmalloc.h>
+#include <linux/cpumask.h>
+#include <linux/kernel.h>
+#include <linux/elf.h>
+#include <linux/highmem.h>
+#include <linux/mmu_context.h>
+#include <linux/io.h>
+#include <linux/timex.h>
+#include <asm/pgtable.h>
+#include <asm/pgalloc.h>
+#include <asm/cacheflush.h>
+#include <asm/checksum.h>
+#include <hv/hypervisor.h>
+
+
+/*
+ * This stuff is not in elf.h and is not in any other kernel include.
+ * This stuff is needed below in the little boot notes parser to
+ * extract the command line so we can pass it to the hypervisor.
+ */
+struct Elf32_Bhdr {
+	Elf32_Word b_signature;
+	Elf32_Word b_size;
+	Elf32_Half b_checksum;
+	Elf32_Half b_records;
+};
+#define ELF_BOOT_MAGIC		0x0E1FB007
+#define EBN_COMMAND_LINE	0x00000004
+#define roundupsz(X) (((X) + 3) & ~3)
+
+/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
+
+
+void machine_shutdown(void)
+{
+	/*
+	 * Normally we would stop all the other processors here, but
+	 * the check in machine_kexec_prepare below ensures we'll only
+	 * get this far if we've been booted with "nosmp" on the
+	 * command line or without CONFIG_SMP so there's nothing to do
+	 * here (for now).
+	 */
+}
+
+void machine_crash_shutdown(struct pt_regs *regs)
+{
+	/*
+	 * Cannot happen.  This type of kexec is disabled on this
+	 * architecture (and enforced in machine_kexec_prepare below).
+	 */
+}
+
+
+int machine_kexec_prepare(struct kimage *image)
+{
+	if (num_online_cpus() > 1) {
+		printk(KERN_WARNING "%s: detected attempt to kexec "
+		       "with num_online_cpus() > 1\n",
+		       __func__);
+		return -ENOSYS;
+	}
+	if (image->type != KEXEC_TYPE_DEFAULT) {
+		printk(KERN_WARNING "%s: detected attempt to kexec "
+		       "with unsupported type: %d\n",
+		       __func__,
+		       image->type);
+		return -ENOSYS;
+	}
+	return 0;
+}
+
+void machine_kexec_cleanup(struct kimage *image)
+{
+	/*
+	 * We did nothing in machine_kexec_prepare,
+	 * so we have nothing to do here.
+	 */
+}
+
+/*
+ * If we can find elf boot notes on this page, return the command
+ * line.  Otherwise, silently return null.  Somewhat kludgy, but no
+ * good way to do this without significantly rearchitecting the
+ * architecture-independent kexec code.
+ */
+
+static unsigned char *kexec_bn2cl(void *pg)
+{
+	struct Elf32_Bhdr *bhdrp;
+	Elf32_Nhdr *nhdrp;
+	unsigned char *desc;
+	unsigned char *command_line;
+	__sum16 csum;
+
+	bhdrp = (struct Elf32_Bhdr *) pg;
+
+	/*
+	 * This routine is invoked for every source page, so make
+	 * sure to quietly ignore every impossible page.
+	 */
+	if (bhdrp->b_signature != ELF_BOOT_MAGIC ||
+	    bhdrp->b_size > PAGE_SIZE)
+		return 0;
+
+	/*
+	 * If we get a checksum mismatch, it's possible that this is
+	 * just a false positive, but relatively unlikely.  We dump
+	 * out the contents of the section so we can diagnose better.
+	 */
+	csum = ip_compute_csum(pg, bhdrp->b_size);
+	if (csum != 0) {
+		int i;
+		unsigned char *p = pg;
+		int nbytes = min((Elf32_Word)1000, bhdrp->b_size);
+		printk(KERN_INFO "%s: bad checksum %#x\n", __func__, csum);
+		printk(KERN_INFO "bytes (%d):", bhdrp->b_size);
+		for (i = 0; i < nbytes; ++i)
+			printk(" %02x", p[i]);
+		if (bhdrp->b_size != nbytes)
+			printk(" ...");
+		printk("\n");
+		return 0;
+	}
+
+	nhdrp = (Elf32_Nhdr *) (bhdrp + 1);
+
+	while (nhdrp->n_type != EBN_COMMAND_LINE) {
+
+		desc = (unsigned char *) (nhdrp + 1);
+		desc += roundupsz(nhdrp->n_descsz);
+
+		nhdrp = (Elf32_Nhdr *) desc;
+
+		/* still in bounds? */
+		if ((unsigned char *) (nhdrp + 1) >
+		    ((unsigned char *) pg) + bhdrp->b_size) {
+
+			printk(KERN_INFO "%s: out of bounds\n", __func__);
+			return 0;
+		}
+	}
+
+	command_line = (unsigned char *) (nhdrp + 1);
+	desc = command_line;
+
+	while (*desc != '\0') {
+		desc++;
+		if (((unsigned long)desc & PAGE_MASK) != (unsigned long)pg) {
+			printk(KERN_INFO "%s: ran off end of page\n",
+			       __func__);
+			return 0;
+		}
+	}
+
+	return command_line;
+}
+
+static void kexec_find_and_set_command_line(struct kimage *image)
+{
+	kimage_entry_t *ptr, entry;
+
+	unsigned char *command_line = 0;
+	unsigned char *r;
+	HV_Errno hverr;
+
+	for (ptr = &image->head;
+	     (entry = *ptr) && !(entry & IND_DONE);
+	     ptr = (entry & IND_INDIRECTION) ?
+		     phys_to_virt((entry & PAGE_MASK)) : ptr + 1) {
+
+		if ((entry & IND_SOURCE)) {
+			void *va =
+				kmap_atomic_pfn(entry >> PAGE_SHIFT, KM_USER0);
+			r = kexec_bn2cl(va);
+			if (r) {
+				command_line = r;
+				break;
+			}
+			kunmap_atomic(va, KM_USER0);
+		}
+	}
+
+	if (command_line != 0) {
+		printk(KERN_INFO "setting new command line to \"%s\"\n",
+		       command_line);
+
+		hverr = hv_set_command_line(
+			(HV_VirtAddr) command_line, strlen(command_line));
+		kunmap_atomic(command_line, KM_USER0);
+	} else {
+		printk(KERN_INFO "%s: no command line found; making empty\n",
+		       __func__);
+		hverr = hv_set_command_line((HV_VirtAddr) command_line, 0);
+	}
+	if (hverr) {
+		printk(KERN_WARNING
+		      "%s: call to hv_set_command_line returned error: %d\n",
+		      __func__, hverr);
+
+	}
+}
+
+/*
+ * The kexec code range-checks all its PAs, so to avoid having it run
+ * amok and allocate memory and then sequester it from every other
+ * controller, we force it to come from controller zero.  We also
+ * disable the oom-killer since if we do end up running out of memory,
+ * that almost certainly won't help.
+ */
+struct page *kimage_alloc_pages_arch(gfp_t gfp_mask, unsigned int order)
+{
+	gfp_mask |= __GFP_THISNODE | __GFP_NORETRY;
+	return alloc_pages_node(0, gfp_mask, order);
+}
+
+static void setup_quasi_va_is_pa(void)
+{
+	HV_PTE *pgtable;
+	HV_PTE pte;
+	int i;
+
+	/*
+	 * Flush our TLB to prevent conflicts between the previous contents
+	 * and the new stuff we're about to add.
+	 */
+	local_flush_tlb_all();
+
+	/* setup VA is PA, at least up to PAGE_OFFSET */
+
+	pgtable = (HV_PTE *)current->mm->pgd;
+	pte = hv_pte(_PAGE_KERNEL | _PAGE_HUGE_PAGE);
+	pte = hv_pte_set_mode(pte, HV_PTE_MODE_CACHE_NO_L3);
+
+	for (i = 0; i < pgd_index(PAGE_OFFSET); i++)
+		pgtable[i] = pfn_pte(i << (HPAGE_SHIFT - PAGE_SHIFT), pte);
+}
+
+
+NORET_TYPE void machine_kexec(struct kimage *image)
+{
+	void *reboot_code_buffer;
+	NORET_TYPE void (*rnk)(unsigned long, void *, unsigned long)
+		ATTRIB_NORET;
+
+	/* Mask all interrupts before starting to reboot. */
+	interrupt_mask_set_mask(~0ULL);
+
+	kexec_find_and_set_command_line(image);
+
+	/*
+	 * Adjust the home caching of the control page to be cached on
+	 * this cpu, and copy the assembly helper into the control
+	 * code page, which we map in the vmalloc area.
+	 */
+	homecache_change_page_home(image->control_code_page, 0,
+				   smp_processor_id());
+	reboot_code_buffer = vmap(&image->control_code_page, 1, 0,
+				  __pgprot(_PAGE_KERNEL | _PAGE_EXECUTABLE));
+	memcpy(reboot_code_buffer, relocate_new_kernel,
+	       relocate_new_kernel_size);
+	__flush_icache_range(
+		(unsigned long) reboot_code_buffer,
+		(unsigned long) reboot_code_buffer + relocate_new_kernel_size);
+
+	setup_quasi_va_is_pa();
+
+	/* now call it */
+	rnk = reboot_code_buffer;
+	(*rnk)(image->head, reboot_code_buffer, image->start);
+}
diff --git a/arch/tile/kernel/messaging.c b/arch/tile/kernel/messaging.c
new file mode 100644
index 0000000..f991f52
--- /dev/null
+++ b/arch/tile/kernel/messaging.c
@@ -0,0 +1,115 @@
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
+#include <linux/percpu.h>
+#include <linux/smp.h>
+#include <linux/hardirq.h>
+#include <linux/ptrace.h>
+#include <asm/hv_driver.h>
+#include <asm/irq_regs.h>
+#include <hv/hypervisor.h>
+#include <arch/interrupts.h>
+
+/* All messages are stored here */
+static DEFINE_PER_CPU(HV_MsgState, msg_state);
+
+void __cpuinit init_messaging()
+{
+	/* Allocate storage for messages in kernel space */
+	HV_MsgState *state = &__get_cpu_var(msg_state);
+	int rc = hv_register_message_state(state);
+	if (rc != HV_OK)
+		panic("hv_register_message_state: error %d", rc);
+
+	/* Make sure downcall interrupts will be enabled. */
+	raw_local_irq_unmask(INT_INTCTRL_1);
+}
+
+void hv_message_intr(struct pt_regs *regs, int intnum)
+{
+	/*
+	 * We enter with interrupts disabled and leave them disabled,
+	 * to match expectations of called functions (e.g.
+	 * do_ccupdate_local() in mm/slab.c).  This is also consistent
+	 * with normal call entry for device interrupts.
+	 */
+
+	int message[HV_MAX_MESSAGE_SIZE/sizeof(int)];
+	HV_RcvMsgInfo rmi;
+	int nmsgs = 0;
+
+	/* Track time spent here in an interrupt context */
+	struct pt_regs *old_regs = set_irq_regs(regs);
+	irq_enter();
+
+#ifdef CONFIG_DEBUG_STACKOVERFLOW
+	/* Debugging check for stack overflow: less than 1/8th stack free? */
+	{
+		long sp = stack_pointer - (long) current_thread_info();
+		if (unlikely(sp < (sizeof(struct thread_info) + STACK_WARN))) {
+			printk(KERN_EMERG "hv_message_intr: "
+			       "stack overflow: %ld\n",
+			       sp - sizeof(struct thread_info));
+			dump_stack();
+		}
+	}
+#endif
+
+	while (1) {
+		rmi = hv_receive_message(__get_cpu_var(msg_state),
+					 (HV_VirtAddr) message,
+					 sizeof(message));
+		if (rmi.msglen == 0)
+			break;
+
+		if (rmi.msglen < 0)
+			panic("hv_receive_message failed: %d", rmi.msglen);
+
+		++nmsgs;
+
+		if (rmi.source == HV_MSG_TILE) {
+			int tag;
+
+			/* we just send tags for now */
+			BUG_ON(rmi.msglen != sizeof(int));
+
+			tag = message[0];
+#ifdef CONFIG_SMP
+			evaluate_message(message[0]);
+#else
+			panic("Received IPI message %d in UP mode", tag);
+#endif
+		} else if (rmi.source == HV_MSG_INTR) {
+			HV_IntrMsg *him = (HV_IntrMsg *)message;
+			struct hv_driver_cb *cb =
+				(struct hv_driver_cb *)him->intarg;
+			cb->callback(cb, him->intdata);
+			__get_cpu_var(irq_stat).irq_hv_msg_count++;
+		}
+	}
+
+	/*
+	 * We shouldn't have gotten a message downcall with no
+	 * messages available.
+	 */
+	if (nmsgs == 0)
+		panic("Message downcall invoked with no messages!");
+
+	/*
+	 * Track time spent against the current process again and
+	 * process any softirqs if they are waiting.
+	 */
+	irq_exit();
+	set_irq_regs(old_regs);
+}
diff --git a/arch/tile/kernel/module.c b/arch/tile/kernel/module.c
new file mode 100644
index 0000000..ed3e911
--- /dev/null
+++ b/arch/tile/kernel/module.c
@@ -0,0 +1,257 @@
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
+ *
+ * Based on i386 version, copyright (C) 2001 Rusty Russell.
+ */
+
+#include <linux/moduleloader.h>
+#include <linux/elf.h>
+#include <linux/vmalloc.h>
+#include <linux/fs.h>
+#include <linux/string.h>
+#include <linux/kernel.h>
+#include <asm/opcode-tile.h>
+#include <asm/pgtable.h>
+
+#ifdef __tilegx__
+# define Elf_Rela Elf64_Rela
+# define ELF_R_SYM ELF64_R_SYM
+# define ELF_R_TYPE ELF64_R_TYPE
+#else
+# define Elf_Rela Elf32_Rela
+# define ELF_R_SYM ELF32_R_SYM
+# define ELF_R_TYPE ELF32_R_TYPE
+#endif
+
+#ifdef MODULE_DEBUG
+#define DEBUGP printk
+#else
+#define DEBUGP(fmt...)
+#endif
+
+/*
+ * Allocate some address space in the range MEM_MODULE_START to
+ * MEM_MODULE_END and populate it with memory.
+ */
+void *module_alloc(unsigned long size)
+{
+	struct page **pages;
+	pgprot_t prot_rwx = __pgprot(_PAGE_KERNEL | _PAGE_KERNEL_EXEC);
+	struct vm_struct *area;
+	int i = 0;
+	int npages;
+
+	if (size == 0)
+		return NULL;
+	npages = (size + PAGE_SIZE - 1) / PAGE_SIZE;
+	pages = kmalloc(npages * sizeof(struct page *), GFP_KERNEL);
+	if (pages == NULL)
+		return NULL;
+	for (; i < npages; ++i) {
+		pages[i] = alloc_page(GFP_KERNEL | __GFP_HIGHMEM);
+		if (!pages[i])
+			goto error;
+	}
+
+	area = __get_vm_area(size, VM_ALLOC, MEM_MODULE_START, MEM_MODULE_END);
+	if (!area)
+		goto error;
+
+	if (map_vm_area(area, prot_rwx, &pages)) {
+		vunmap(area->addr);
+		goto error;
+	}
+
+	return area->addr;
+
+error:
+	while (--i >= 0)
+		__free_page(pages[i]);
+	kfree(pages);
+	return NULL;
+}
+
+
+/* Free memory returned from module_alloc */
+void module_free(struct module *mod, void *module_region)
+{
+	vfree(module_region);
+	/*
+	 * FIXME: If module_region == mod->init_region, trim exception
+	 * table entries.
+	 */
+}
+
+/* We don't need anything special. */
+int module_frob_arch_sections(Elf_Ehdr *hdr,
+			      Elf_Shdr *sechdrs,
+			      char *secstrings,
+			      struct module *mod)
+{
+	return 0;
+}
+
+int apply_relocate(Elf_Shdr *sechdrs,
+		   const char *strtab,
+		   unsigned int symindex,
+		   unsigned int relsec,
+		   struct module *me)
+{
+	printk(KERN_ERR "module %s: .rel relocation unsupported\n", me->name);
+	return -ENOEXEC;
+}
+
+#ifdef __tilegx__
+/*
+ * Validate that the high 16 bits of "value" is just the sign-extension of
+ * the low 48 bits.
+ */
+static int validate_hw2_last(long value, struct module *me)
+{
+	if (((value << 16) >> 16) != value) {
+		printk("module %s: Out of range HW2_LAST value %#lx\n",
+		       me->name, value);
+		return 0;
+	}
+	return 1;
+}
+
+/*
+ * Validate that "value" isn't too big to hold in a JumpOff relocation.
+ */
+static int validate_jumpoff(long value)
+{
+	/* Determine size of jump offset. */
+	int shift = __builtin_clzl(get_JumpOff_X1(create_JumpOff_X1(-1)));
+
+	/* Check to see if it fits into the relocation slot. */
+	long f = get_JumpOff_X1(create_JumpOff_X1(value));
+	f = (f << shift) >> shift;
+
+	return f == value;
+}
+#endif
+
+int apply_relocate_add(Elf_Shdr *sechdrs,
+		       const char *strtab,
+		       unsigned int symindex,
+		       unsigned int relsec,
+		       struct module *me)
+{
+	unsigned int i;
+	Elf_Rela *rel = (void *)sechdrs[relsec].sh_addr;
+	Elf_Sym *sym;
+	u64 *location;
+	unsigned long value;
+
+	DEBUGP("Applying relocate section %u to %u\n", relsec,
+	       sechdrs[relsec].sh_info);
+	for (i = 0; i < sechdrs[relsec].sh_size / sizeof(*rel); i++) {
+		/* This is where to make the change */
+		location = (void *)sechdrs[sechdrs[relsec].sh_info].sh_addr
+			+ rel[i].r_offset;
+		/*
+		 * This is the symbol it is referring to.
+		 * Note that all undefined symbols have been resolved.
+		 */
+		sym = (Elf_Sym *)sechdrs[symindex].sh_addr
+			+ ELF_R_SYM(rel[i].r_info);
+		value = sym->st_value + rel[i].r_addend;
+
+		switch (ELF_R_TYPE(rel[i].r_info)) {
+
+#define MUNGE(func) (*location = ((*location & ~func(-1)) | func(value)))
+
+#ifndef __tilegx__
+		case R_TILE_32:
+			*(uint32_t *)location = value;
+			break;
+		case R_TILE_IMM16_X0_HA:
+			value = (value + 0x8000) >> 16;
+			/*FALLTHROUGH*/
+		case R_TILE_IMM16_X0_LO:
+			MUNGE(create_Imm16_X0);
+			break;
+		case R_TILE_IMM16_X1_HA:
+			value = (value + 0x8000) >> 16;
+			/*FALLTHROUGH*/
+		case R_TILE_IMM16_X1_LO:
+			MUNGE(create_Imm16_X1);
+			break;
+		case R_TILE_JOFFLONG_X1:
+			value -= (unsigned long) location;  /* pc-relative */
+			value = (long) value >> 3;     /* count by instrs */
+			MUNGE(create_JOffLong_X1);
+			break;
+#else
+		case R_TILEGX_64:
+			*location = value;
+			break;
+		case R_TILEGX_IMM16_X0_HW2_LAST:
+			if (!validate_hw2_last(value, me))
+				return -ENOEXEC;
+			value >>= 16;
+			/*FALLTHROUGH*/
+		case R_TILEGX_IMM16_X0_HW1:
+			value >>= 16;
+			/*FALLTHROUGH*/
+		case R_TILEGX_IMM16_X0_HW0:
+			MUNGE(create_Imm16_X0);
+			break;
+		case R_TILEGX_IMM16_X1_HW2_LAST:
+			if (!validate_hw2_last(value, me))
+				return -ENOEXEC;
+			value >>= 16;
+			/*FALLTHROUGH*/
+		case R_TILEGX_IMM16_X1_HW1:
+			value >>= 16;
+			/*FALLTHROUGH*/
+		case R_TILEGX_IMM16_X1_HW0:
+			MUNGE(create_Imm16_X1);
+			break;
+		case R_TILEGX_JUMPOFF_X1:
+			value -= (unsigned long) location;  /* pc-relative */
+			value = (long) value >> 3;     /* count by instrs */
+			if (!validate_jumpoff(value)) {
+				printk("module %s: Out of range jump to"
+				       " %#llx at %#llx (%p)\n", me->name,
+				       sym->st_value + rel[i].r_addend,
+				       rel[i].r_offset, location);
+				return -ENOEXEC;
+			}
+			MUNGE(create_JumpOff_X1);
+			break;
+#endif
+
+#undef MUNGE
+
+		default:
+			printk(KERN_ERR "module %s: Unknown relocation: %d\n",
+			       me->name, (int) ELF_R_TYPE(rel[i].r_info));
+			return -ENOEXEC;
+		}
+	}
+	return 0;
+}
+
+int module_finalize(const Elf_Ehdr *hdr,
+		    const Elf_Shdr *sechdrs,
+		    struct module *me)
+{
+	/* FIXME: perhaps remove the "writable" bit from the TLB? */
+	return 0;
+}
+
+void module_arch_cleanup(struct module *mod)
+{
+}
diff --git a/arch/tile/kernel/pci-dma.c b/arch/tile/kernel/pci-dma.c
new file mode 100644
index 0000000..b1ddc80
--- /dev/null
+++ b/arch/tile/kernel/pci-dma.c
@@ -0,0 +1,231 @@
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
+#include <linux/mm.h>
+#include <linux/dma-mapping.h>
+#include <linux/vmalloc.h>
+#include <asm/tlbflush.h>
+#include <asm/homecache.h>
+
+/* Generic DMA mapping functions: */
+
+/*
+ * Allocate what Linux calls "coherent" memory, which for us just
+ * means uncached.
+ */
+void *dma_alloc_coherent(struct device *dev,
+			 size_t size,
+			 dma_addr_t *dma_handle,
+			 gfp_t gfp)
+{
+	int order;
+	struct page *pg;
+
+	gfp |= GFP_KERNEL | __GFP_ZERO;
+
+	order = get_order(size);
+	/* alloc on node 0 so the paddr fits in a u32 */
+	pg = homecache_alloc_pages_node(0, gfp, order, PAGE_HOME_UNCACHED);
+	if (pg == NULL)
+		return NULL;
+
+	*dma_handle = page_to_pa(pg);
+	return (void *) page_address(pg);
+}
+EXPORT_SYMBOL(dma_alloc_coherent);
+
+/*
+ * Free memory that was allocated with dma_alloc_coherent.
+ */
+void dma_free_coherent(struct device *dev, size_t size,
+		  void *vaddr, dma_addr_t dma_handle)
+{
+	homecache_free_pages((unsigned long)vaddr, get_order(size));
+}
+EXPORT_SYMBOL(dma_free_coherent);
+
+/*
+ * The map routines "map" the specified address range for DMA
+ * accesses.  The memory belongs to the device after this call is
+ * issued, until it is unmapped with dma_unmap_single.
+ *
+ * We don't need to do any mapping, we just flush the address range
+ * out of the cache and return a DMA address.
+ *
+ * The unmap routines do whatever is necessary before the processor
+ * accesses the memory again, and must be called before the driver
+ * touches the memory.  We can get away with a cache invalidate if we
+ * can count on nothing having been touched.
+ */
+
+
+/*
+ * dma_map_single can be passed any memory address, and there appear
+ * to be no alignment constraints.
+ *
+ * There is a chance that the start of the buffer will share a cache
+ * line with some other data that has been touched in the meantime.
+ */
+dma_addr_t dma_map_single(struct device *dev, void *ptr, size_t size,
+	       enum dma_data_direction direction)
+{
+	struct page *page;
+	dma_addr_t dma_addr;
+	int thispage;
+
+	BUG_ON(!valid_dma_direction(direction));
+	WARN_ON(size == 0);
+
+	dma_addr = __pa(ptr);
+
+	/* We might have been handed a buffer that wraps a page boundary */
+	while ((int)size > 0) {
+		/* The amount to flush that's on this page */
+		thispage = PAGE_SIZE - ((unsigned long)ptr & (PAGE_SIZE - 1));
+		thispage = min((int)thispage, (int)size);
+		/* Is this valid for any page we could be handed? */
+		page = pfn_to_page(kaddr_to_pfn(ptr));
+		homecache_flush_cache(page, 0);
+		ptr += thispage;
+		size -= thispage;
+	}
+
+	return dma_addr;
+}
+EXPORT_SYMBOL(dma_map_single);
+
+void dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
+		 enum dma_data_direction direction)
+{
+	BUG_ON(!valid_dma_direction(direction));
+}
+EXPORT_SYMBOL(dma_unmap_single);
+
+int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
+	   enum dma_data_direction direction)
+{
+	int i;
+
+	BUG_ON(!valid_dma_direction(direction));
+
+	WARN_ON(nents == 0 || sg[0].length == 0);
+
+	for (i = 0; i < nents; i++) {
+		struct page *page;
+		sg[i].dma_address = sg_phys(sg + i);
+		page = pfn_to_page(sg[i].dma_address >> PAGE_SHIFT);
+		homecache_flush_cache(page, 0);
+	}
+
+	return nents;
+}
+EXPORT_SYMBOL(dma_map_sg);
+
+void dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nhwentries,
+	     enum dma_data_direction direction)
+{
+	BUG_ON(!valid_dma_direction(direction));
+}
+EXPORT_SYMBOL(dma_unmap_sg);
+
+dma_addr_t dma_map_page(struct device *dev, struct page *page,
+			unsigned long offset, size_t size,
+			enum dma_data_direction direction)
+{
+	BUG_ON(!valid_dma_direction(direction));
+
+	homecache_flush_cache(page, 0);
+
+	return page_to_pa(page) + offset;
+}
+EXPORT_SYMBOL(dma_map_page);
+
+void dma_unmap_page(struct device *dev, dma_addr_t dma_address, size_t size,
+	       enum dma_data_direction direction)
+{
+	BUG_ON(!valid_dma_direction(direction));
+}
+EXPORT_SYMBOL(dma_unmap_page);
+
+void dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle,
+			     size_t size, enum dma_data_direction direction)
+{
+	BUG_ON(!valid_dma_direction(direction));
+}
+EXPORT_SYMBOL(dma_sync_single_for_cpu);
+
+void dma_sync_single_for_device(struct device *dev, dma_addr_t dma_handle,
+				size_t size, enum dma_data_direction direction)
+{
+	unsigned long start = PFN_DOWN(dma_handle);
+	unsigned long end = PFN_DOWN(dma_handle + size - 1);
+	unsigned long i;
+
+	BUG_ON(!valid_dma_direction(direction));
+	for (i = start; i <= end; ++i)
+		homecache_flush_cache(pfn_to_page(i), 0);
+}
+EXPORT_SYMBOL(dma_sync_single_for_device);
+
+void dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg, int nelems,
+		    enum dma_data_direction direction)
+{
+	BUG_ON(!valid_dma_direction(direction));
+	WARN_ON(nelems == 0 || sg[0].length == 0);
+}
+EXPORT_SYMBOL(dma_sync_sg_for_cpu);
+
+/*
+ * Flush and invalidate cache for scatterlist.
+ */
+void dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
+			    int nelems, enum dma_data_direction direction)
+{
+	int i;
+
+	BUG_ON(!valid_dma_direction(direction));
+	WARN_ON(nelems == 0 || sg[0].length == 0);
+
+	for (i = 0; i < nelems; i++)
+		dma_sync_single_for_device(dev, sg[i].dma_address,
+					   sg[i].dma_length, direction);
+}
+EXPORT_SYMBOL(dma_sync_sg_for_device);
+
+void dma_sync_single_range_for_cpu(struct device *dev, dma_addr_t dma_handle,
+				   unsigned long offset, size_t size,
+				   enum dma_data_direction direction)
+{
+	dma_sync_single_for_cpu(dev, dma_handle + offset, size, direction);
+}
+EXPORT_SYMBOL(dma_sync_single_range_for_cpu);
+
+void dma_sync_single_range_for_device(struct device *dev,
+				      dma_addr_t dma_handle,
+				      unsigned long offset, size_t size,
+				      enum dma_data_direction direction)
+{
+	dma_sync_single_for_device(dev, dma_handle + offset, size, direction);
+}
+EXPORT_SYMBOL(dma_sync_single_range_for_device);
+
+/*
+ * dma_alloc_noncoherent() returns non-cacheable memory, so there's no
+ * need to do any flushing here.
+ */
+void dma_cache_sync(void *vaddr, size_t size,
+		    enum dma_data_direction direction)
+{
+}
+EXPORT_SYMBOL(dma_cache_sync);
diff --git a/arch/tile/kernel/proc.c b/arch/tile/kernel/proc.c
new file mode 100644
index 0000000..92ef925
--- /dev/null
+++ b/arch/tile/kernel/proc.c
@@ -0,0 +1,91 @@
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
+#include <linux/smp.h>
+#include <linux/seq_file.h>
+#include <linux/threads.h>
+#include <linux/cpumask.h>
+#include <linux/timex.h>
+#include <linux/delay.h>
+#include <linux/fs.h>
+#include <linux/proc_fs.h>
+#include <linux/sysctl.h>
+#include <linux/hardirq.h>
+#include <linux/mman.h>
+#include <linux/smp.h>
+#include <asm/pgtable.h>
+#include <asm/processor.h>
+#include <asm/sections.h>
+#include <asm/homecache.h>
+#include <arch/chip.h>
+
+
+/*
+ * Support /proc/cpuinfo
+ */
+
+#define cpu_to_ptr(n) ((void *)((long)(n)+1))
+#define ptr_to_cpu(p) ((long)(p) - 1)
+
+static int show_cpuinfo(struct seq_file *m, void *v)
+{
+	int n = ptr_to_cpu(v);
+
+	if (n == 0) {
+		char buf[NR_CPUS*5];
+		cpulist_scnprintf(buf, sizeof(buf), cpu_online_mask);
+		seq_printf(m, "cpu count\t: %d\n", num_online_cpus());
+		seq_printf(m, "cpu list\t: %s\n", buf);
+		seq_printf(m, "model name\t: %s\n", chip_model);
+		seq_printf(m, "flags\t\t:\n");  /* nothing for now */
+		seq_printf(m, "cpu MHz\t\t: %llu.%06llu\n",
+			   get_clock_rate() / 1000000,
+			   (get_clock_rate() % 1000000));
+		seq_printf(m, "bogomips\t: %lu.%02lu\n\n",
+			   loops_per_jiffy/(500000/HZ),
+			   (loops_per_jiffy/(5000/HZ)) % 100);
+	}
+
+#ifdef CONFIG_SMP
+	if (!cpu_online(n))
+		return 0;
+#endif
+
+	seq_printf(m, "processor\t: %d\n", n);
+
+	/* Print only num_online_cpus() blank lines total. */
+	if (cpumask_next(n, cpu_online_mask) < nr_cpu_ids)
+		seq_printf(m, "\n");
+
+	return 0;
+}
+
+static void *c_start(struct seq_file *m, loff_t *pos)
+{
+	return *pos < nr_cpu_ids ? cpu_to_ptr(*pos) : NULL;
+}
+static void *c_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	++*pos;
+	return c_start(m, pos);
+}
+static void c_stop(struct seq_file *m, void *v)
+{
+}
+const struct seq_operations cpuinfo_op = {
+	.start	= c_start,
+	.next	= c_next,
+	.stop	= c_stop,
+	.show	= show_cpuinfo,
+};
diff --git a/arch/tile/kernel/process.c b/arch/tile/kernel/process.c
new file mode 100644
index 0000000..824f230
--- /dev/null
+++ b/arch/tile/kernel/process.c
@@ -0,0 +1,647 @@
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
+#include <linux/sched.h>
+#include <linux/preempt.h>
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/kprobes.h>
+#include <linux/elfcore.h>
+#include <linux/tick.h>
+#include <linux/init.h>
+#include <linux/mm.h>
+#include <linux/compat.h>
+#include <linux/hardirq.h>
+#include <linux/syscalls.h>
+#include <asm/system.h>
+#include <asm/stack.h>
+#include <asm/homecache.h>
+#include <arch/chip.h>
+#include <arch/abi.h>
+
+
+/*
+ * Use the (x86) "idle=poll" option to prefer low latency when leaving the
+ * idle loop over low power while in the idle loop, e.g. if we have
+ * one thread per core and we want to get threads out of futex waits fast.
+ */
+static int no_idle_nap;
+static int __init idle_setup(char *str)
+{
+	if (!str)
+		return -EINVAL;
+
+	if (!strcmp(str, "poll")) {
+		printk("using polling idle threads.\n");
+		no_idle_nap = 1;
+	} else if (!strcmp(str, "halt"))
+		no_idle_nap = 0;
+	else
+		return -1;
+
+	return 0;
+}
+early_param("idle", idle_setup);
+
+/*
+ * The idle thread. There's no useful work to be
+ * done, so just try to conserve power and have a
+ * low exit latency (ie sit in a loop waiting for
+ * somebody to say that they'd like to reschedule)
+ */
+void cpu_idle(void)
+{
+	extern void _cpu_idle(void);
+	int cpu = smp_processor_id();
+
+
+	current_thread_info()->status |= TS_POLLING;
+
+	if (no_idle_nap) {
+		while (1) {
+			while (!need_resched())
+				cpu_relax();
+			schedule();
+		}
+	}
+
+	/* endless idle loop with no priority at all */
+	while (1) {
+		tick_nohz_stop_sched_tick(1);
+		while (!need_resched()) {
+			if (cpu_is_offline(cpu))
+				BUG();  /* no HOTPLUG_CPU */
+
+			local_irq_disable();
+			__get_cpu_var(irq_stat).idle_timestamp = jiffies;
+			current_thread_info()->status &= ~TS_POLLING;
+			/*
+			 * TS_POLLING-cleared state must be visible before we
+			 * test NEED_RESCHED:
+			 */
+			smp_mb();
+
+			if (!need_resched())
+				_cpu_idle();
+			else
+				local_irq_enable();
+			current_thread_info()->status |= TS_POLLING;
+		}
+		tick_nohz_restart_sched_tick();
+		preempt_enable_no_resched();
+		schedule();
+		preempt_disable();
+	}
+}
+
+struct thread_info *alloc_thread_info(struct task_struct *task)
+{
+	struct page *page;
+	int flags = GFP_KERNEL;
+
+#ifdef CONFIG_DEBUG_STACK_USAGE
+	flags |= __GFP_ZERO;
+#endif
+
+	page = alloc_pages(flags, THREAD_SIZE_ORDER);
+	if (!page)
+		return 0;
+
+	return (struct thread_info *)page_address(page);
+}
+
+/*
+ * Free a thread_info node, and all of its derivative
+ * data structures.
+ */
+void free_thread_info(struct thread_info *info)
+{
+	struct single_step_state *step_state = info->step_state;
+
+
+	if (step_state) {
+
+		/*
+		 * FIXME: we don't munmap step_state->buffer
+		 * because the mm_struct for this process (info->task->mm)
+		 * has already been zeroed in exit_mm().  Keeping a
+		 * reference to it here seems like a bad move, so this
+		 * means we can't munmap() the buffer, and therefore if we
+		 * ptrace multiple threads in a process, we will slowly
+		 * leak user memory.  (Note that as soon as the last
+		 * thread in a process dies, we will reclaim all user
+		 * memory including single-step buffers in the usual way.)
+		 * We should either assign a kernel VA to this buffer
+		 * somehow, or we should associate the buffer(s) with the
+		 * mm itself so we can clean them up that way.
+		 */
+		kfree(step_state);
+	}
+
+	free_page((unsigned long)info);
+}
+
+static void save_arch_state(struct thread_struct *t);
+
+extern void ret_from_fork(void);
+
+int copy_thread(unsigned long clone_flags, unsigned long sp,
+		unsigned long stack_size,
+		struct task_struct *p, struct pt_regs *regs)
+{
+	struct pt_regs *childregs;
+	unsigned long ksp;
+
+	/*
+	 * When creating a new kernel thread we pass sp as zero.
+	 * Assign it to a reasonable value now that we have the stack.
+	 */
+	if (sp == 0 && regs->ex1 == PL_ICS_EX1(KERNEL_PL, 0))
+		sp = KSTK_TOP(p);
+
+	/*
+	 * Do not clone step state from the parent; each thread
+	 * must make its own lazily.
+	 */
+	task_thread_info(p)->step_state = NULL;
+
+	/*
+	 * Start new thread in ret_from_fork so it schedules properly
+	 * and then return from interrupt like the parent.
+	 */
+	p->thread.pc = (unsigned long) ret_from_fork;
+
+	/* Save user stack top pointer so we can ID the stack vm area later. */
+	p->thread.usp0 = sp;
+
+	/* Record the pid of the process that created this one. */
+	p->thread.creator_pid = current->pid;
+
+	/*
+	 * Copy the registers onto the kernel stack so the
+	 * return-from-interrupt code will reload it into registers.
+	 */
+	childregs = task_pt_regs(p);
+	*childregs = *regs;
+	childregs->regs[0] = 0;         /* return value is zero */
+	childregs->sp = sp;  /* override with new user stack pointer */
+
+	/*
+	 * Copy the callee-saved registers from the passed pt_regs struct
+	 * into the context-switch callee-saved registers area.
+	 * We have to restore the callee-saved registers since we may
+	 * be cloning a userspace task with userspace register state,
+	 * and we won't be unwinding the same kernel frames to restore them.
+	 * Zero out the C ABI save area to mark the top of the stack.
+	 */
+	ksp = (unsigned long) childregs;
+	ksp -= C_ABI_SAVE_AREA_SIZE;   /* interrupt-entry save area */
+	((long *)ksp)[0] = ((long *)ksp)[1] = 0;
+	ksp -= CALLEE_SAVED_REGS_COUNT * sizeof(unsigned long);
+	memcpy((void *)ksp, &regs->regs[CALLEE_SAVED_FIRST_REG],
+	       CALLEE_SAVED_REGS_COUNT * sizeof(unsigned long));
+	ksp -= C_ABI_SAVE_AREA_SIZE;   /* __switch_to() save area */
+	((long *)ksp)[0] = ((long *)ksp)[1] = 0;
+	p->thread.ksp = ksp;
+
+#if CHIP_HAS_TILE_DMA()
+	/*
+	 * No DMA in the new thread.  We model this on the fact that
+	 * fork() clears the pending signals, alarms, and aio for the child.
+	 */
+	memset(&p->thread.tile_dma_state, 0, sizeof(struct tile_dma_state));
+	memset(&p->thread.dma_async_tlb, 0, sizeof(struct async_tlb));
+#endif
+
+#if CHIP_HAS_SN_PROC()
+	/* Likewise, the new thread is not running static processor code. */
+	p->thread.sn_proc_running = 0;
+	memset(&p->thread.sn_async_tlb, 0, sizeof(struct async_tlb));
+#endif
+
+#if CHIP_HAS_PROC_STATUS_SPR()
+	/* New thread has its miscellaneous processor state bits clear. */
+	p->thread.proc_status = 0;
+#endif
+
+
+
+	/*
+	 * Start the new thread with the current architecture state
+	 * (user interrupt masks, etc.).
+	 */
+	save_arch_state(&p->thread);
+
+	return 0;
+}
+
+/*
+ * Return "current" if it looks plausible, or else a pointer to a dummy.
+ * This can be helpful if we are just trying to emit a clean panic.
+ */
+struct task_struct *validate_current(void)
+{
+	static struct task_struct corrupt = { .comm = "<corrupt>" };
+	struct task_struct *tsk = current;
+	if (unlikely((unsigned long)tsk < PAGE_OFFSET ||
+		     (void *)tsk > high_memory ||
+		     ((unsigned long)tsk & (__alignof__(*tsk) - 1)) != 0)) {
+		printk("Corrupt 'current' %p (sp %#lx)\n", tsk, stack_pointer);
+		tsk = &corrupt;
+	}
+	return tsk;
+}
+
+/* Take and return the pointer to the previous task, for schedule_tail(). */
+struct task_struct *sim_notify_fork(struct task_struct *prev)
+{
+	struct task_struct *tsk = current;
+	__insn_mtspr(SPR_SIM_CONTROL, SIM_CONTROL_OS_FORK_PARENT |
+		     (tsk->thread.creator_pid << _SIM_CONTROL_OPERATOR_BITS));
+	__insn_mtspr(SPR_SIM_CONTROL, SIM_CONTROL_OS_FORK |
+		     (tsk->pid << _SIM_CONTROL_OPERATOR_BITS));
+	return prev;
+}
+
+int dump_task_regs(struct task_struct *tsk, elf_gregset_t *regs)
+{
+	struct pt_regs *ptregs = task_pt_regs(tsk);
+	elf_core_copy_regs(regs, ptregs);
+	return 1;
+}
+
+#if CHIP_HAS_TILE_DMA()
+
+/* Allow user processes to access the DMA SPRs */
+void grant_dma_mpls(void)
+{
+	__insn_mtspr(SPR_MPL_DMA_CPL_SET_0, 1);
+	__insn_mtspr(SPR_MPL_DMA_NOTIFY_SET_0, 1);
+}
+
+/* Forbid user processes from accessing the DMA SPRs */
+void restrict_dma_mpls(void)
+{
+	__insn_mtspr(SPR_MPL_DMA_CPL_SET_1, 1);
+	__insn_mtspr(SPR_MPL_DMA_NOTIFY_SET_1, 1);
+}
+
+/* Pause the DMA engine, then save off its state registers. */
+static void save_tile_dma_state(struct tile_dma_state *dma)
+{
+	unsigned long state = __insn_mfspr(SPR_DMA_USER_STATUS);
+	unsigned long post_suspend_state;
+
+	/* If we're running, suspend the engine. */
+	if ((state & DMA_STATUS_MASK) == SPR_DMA_STATUS__RUNNING_MASK)
+		__insn_mtspr(SPR_DMA_CTR, SPR_DMA_CTR__SUSPEND_MASK);
+
+	/*
+	 * Wait for the engine to idle, then save regs.  Note that we
+	 * want to record the "running" bit from before suspension,
+	 * and the "done" bit from after, so that we can properly
+	 * distinguish a case where the user suspended the engine from
+	 * the case where the kernel suspended as part of the context
+	 * swap.
+	 */
+	do {
+		post_suspend_state = __insn_mfspr(SPR_DMA_USER_STATUS);
+	} while (post_suspend_state & SPR_DMA_STATUS__BUSY_MASK);
+
+	dma->src = __insn_mfspr(SPR_DMA_SRC_ADDR);
+	dma->src_chunk = __insn_mfspr(SPR_DMA_SRC_CHUNK_ADDR);
+	dma->dest = __insn_mfspr(SPR_DMA_DST_ADDR);
+	dma->dest_chunk = __insn_mfspr(SPR_DMA_DST_CHUNK_ADDR);
+	dma->strides = __insn_mfspr(SPR_DMA_STRIDE);
+	dma->chunk_size = __insn_mfspr(SPR_DMA_CHUNK_SIZE);
+	dma->byte = __insn_mfspr(SPR_DMA_BYTE);
+	dma->status = (state & SPR_DMA_STATUS__RUNNING_MASK) |
+		(post_suspend_state & SPR_DMA_STATUS__DONE_MASK);
+}
+
+/* Restart a DMA that was running before we were context-switched out. */
+static void restore_tile_dma_state(struct thread_struct *t)
+{
+	const struct tile_dma_state *dma = &t->tile_dma_state;
+
+	/*
+	 * The only way to restore the done bit is to run a zero
+	 * length transaction.
+	 */
+	if ((dma->status & SPR_DMA_STATUS__DONE_MASK) &&
+	    !(__insn_mfspr(SPR_DMA_USER_STATUS) & SPR_DMA_STATUS__DONE_MASK)) {
+		__insn_mtspr(SPR_DMA_BYTE, 0);
+		__insn_mtspr(SPR_DMA_CTR, SPR_DMA_CTR__REQUEST_MASK);
+		while (__insn_mfspr(SPR_DMA_USER_STATUS) &
+		       SPR_DMA_STATUS__BUSY_MASK)
+			;
+	}
+
+	__insn_mtspr(SPR_DMA_SRC_ADDR, dma->src);
+	__insn_mtspr(SPR_DMA_SRC_CHUNK_ADDR, dma->src_chunk);
+	__insn_mtspr(SPR_DMA_DST_ADDR, dma->dest);
+	__insn_mtspr(SPR_DMA_DST_CHUNK_ADDR, dma->dest_chunk);
+	__insn_mtspr(SPR_DMA_STRIDE, dma->strides);
+	__insn_mtspr(SPR_DMA_CHUNK_SIZE, dma->chunk_size);
+	__insn_mtspr(SPR_DMA_BYTE, dma->byte);
+
+	/*
+	 * Restart the engine if we were running and not done.
+	 * Clear a pending async DMA fault that we were waiting on return
+	 * to user space to execute, since we expect the DMA engine
+	 * to regenerate those faults for us now.  Note that we don't
+	 * try to clear the TIF_ASYNC_TLB flag, since it's relatively
+	 * harmless if set, and it covers both DMA and the SN processor.
+	 */
+	if ((dma->status & DMA_STATUS_MASK) == SPR_DMA_STATUS__RUNNING_MASK) {
+		t->dma_async_tlb.fault_num = 0;
+		__insn_mtspr(SPR_DMA_CTR, SPR_DMA_CTR__REQUEST_MASK);
+	}
+}
+
+#endif
+
+static void save_arch_state(struct thread_struct *t)
+{
+#if CHIP_HAS_SPLIT_INTR_MASK()
+	t->interrupt_mask = __insn_mfspr(SPR_INTERRUPT_MASK_0_0) |
+		((u64)__insn_mfspr(SPR_INTERRUPT_MASK_0_1) << 32);
+#else
+	t->interrupt_mask = __insn_mfspr(SPR_INTERRUPT_MASK_0);
+#endif
+	t->ex_context[0] = __insn_mfspr(SPR_EX_CONTEXT_0_0);
+	t->ex_context[1] = __insn_mfspr(SPR_EX_CONTEXT_0_1);
+	t->system_save[0] = __insn_mfspr(SPR_SYSTEM_SAVE_0_0);
+	t->system_save[1] = __insn_mfspr(SPR_SYSTEM_SAVE_0_1);
+	t->system_save[2] = __insn_mfspr(SPR_SYSTEM_SAVE_0_2);
+	t->system_save[3] = __insn_mfspr(SPR_SYSTEM_SAVE_0_3);
+	t->intctrl_0 = __insn_mfspr(SPR_INTCTRL_0_STATUS);
+#if CHIP_HAS_PROC_STATUS_SPR()
+	t->proc_status = __insn_mfspr(SPR_PROC_STATUS);
+#endif
+}
+
+static void restore_arch_state(const struct thread_struct *t)
+{
+#if CHIP_HAS_SPLIT_INTR_MASK()
+	__insn_mtspr(SPR_INTERRUPT_MASK_0_0, (u32) t->interrupt_mask);
+	__insn_mtspr(SPR_INTERRUPT_MASK_0_1, t->interrupt_mask >> 32);
+#else
+	__insn_mtspr(SPR_INTERRUPT_MASK_0, t->interrupt_mask);
+#endif
+	__insn_mtspr(SPR_EX_CONTEXT_0_0, t->ex_context[0]);
+	__insn_mtspr(SPR_EX_CONTEXT_0_1, t->ex_context[1]);
+	__insn_mtspr(SPR_SYSTEM_SAVE_0_0, t->system_save[0]);
+	__insn_mtspr(SPR_SYSTEM_SAVE_0_1, t->system_save[1]);
+	__insn_mtspr(SPR_SYSTEM_SAVE_0_2, t->system_save[2]);
+	__insn_mtspr(SPR_SYSTEM_SAVE_0_3, t->system_save[3]);
+	__insn_mtspr(SPR_INTCTRL_0_STATUS, t->intctrl_0);
+#if CHIP_HAS_PROC_STATUS_SPR()
+	__insn_mtspr(SPR_PROC_STATUS, t->proc_status);
+#endif
+#if CHIP_HAS_TILE_RTF_HWM()
+	/*
+	 * Clear this whenever we switch back to a process in case
+	 * the previous process was monkeying with it.  Even if enabled
+	 * in CBOX_MSR1 via TILE_RTF_HWM_MIN, it's still just a
+	 * performance hint, so isn't worth a full save/restore.
+	 */
+	__insn_mtspr(SPR_TILE_RTF_HWM, 0);
+#endif
+}
+
+
+void _prepare_arch_switch(struct task_struct *next)
+{
+#if CHIP_HAS_SN_PROC()
+	int snctl;
+#endif
+#if CHIP_HAS_TILE_DMA()
+	struct tile_dma_state *dma = &current->thread.tile_dma_state;
+	if (dma->enabled)
+		save_tile_dma_state(dma);
+#endif
+#if CHIP_HAS_SN_PROC()
+	/*
+	 * Suspend the static network processor if it was running.
+	 * We do not suspend the fabric itself, just like we don't
+	 * try to suspend the UDN.
+	 */
+	snctl = __insn_mfspr(SPR_SNCTL);
+	current->thread.sn_proc_running =
+		(snctl & SPR_SNCTL__FRZPROC_MASK) == 0;
+	if (current->thread.sn_proc_running)
+		__insn_mtspr(SPR_SNCTL, snctl | SPR_SNCTL__FRZPROC_MASK);
+#endif
+}
+
+
+extern struct task_struct *__switch_to(struct task_struct *prev,
+				       struct task_struct *next,
+				       unsigned long new_system_save_1_0);
+
+struct task_struct *__sched _switch_to(struct task_struct *prev,
+				       struct task_struct *next)
+{
+	/* DMA state is already saved; save off other arch state. */
+	save_arch_state(&prev->thread);
+
+#if CHIP_HAS_TILE_DMA()
+	/*
+	 * Restore DMA in new task if desired.
+	 * Note that it is only safe to restart here since interrupts
+	 * are disabled, so we can't take any DMATLB miss or access
+	 * interrupts before we have finished switching stacks.
+	 */
+	if (next->thread.tile_dma_state.enabled) {
+		restore_tile_dma_state(&next->thread);
+		grant_dma_mpls();
+	} else {
+		restrict_dma_mpls();
+	}
+#endif
+
+	/* Restore other arch state. */
+	restore_arch_state(&next->thread);
+
+#if CHIP_HAS_SN_PROC()
+	/*
+	 * Restart static network processor in the new process
+	 * if it was running before.
+	 */
+	if (next->thread.sn_proc_running) {
+		int snctl = __insn_mfspr(SPR_SNCTL);
+		__insn_mtspr(SPR_SNCTL, snctl & ~SPR_SNCTL__FRZPROC_MASK);
+	}
+#endif
+
+
+	/*
+	 * Switch kernel SP, PC, and callee-saved registers.
+	 * In the context of the new task, return the old task pointer
+	 * (i.e. the task that actually called __switch_to).
+	 * Pass the value to use for SYSTEM_SAVE_1_0 when we reset our sp.
+	 */
+	return __switch_to(prev, next, next_current_ksp0(next));
+}
+
+int _sys_fork(struct pt_regs *regs)
+{
+	return do_fork(SIGCHLD, regs->sp, regs, 0, NULL, NULL);
+}
+
+int _sys_clone(unsigned long clone_flags, unsigned long newsp,
+	       int __user *parent_tidptr, int __user *child_tidptr,
+	       struct pt_regs *regs)
+{
+	if (!newsp)
+		newsp = regs->sp;
+	return do_fork(clone_flags, newsp, regs, 0,
+		       parent_tidptr, child_tidptr);
+}
+
+int _sys_vfork(struct pt_regs *regs)
+{
+	return do_fork(CLONE_VFORK | CLONE_VM | SIGCHLD, regs->sp,
+		       regs, 0, NULL, NULL);
+}
+
+/*
+ * sys_execve() executes a new program.
+ */
+int _sys_execve(char __user *path, char __user *__user *argv,
+		char __user *__user *envp, struct pt_regs *regs)
+{
+	int error;
+	char *filename;
+
+	filename = getname(path);
+	error = PTR_ERR(filename);
+	if (IS_ERR(filename))
+		goto out;
+	error = do_execve(filename, argv, envp, regs);
+	putname(filename);
+out:
+	return error;
+}
+
+#ifdef CONFIG_COMPAT
+int _compat_sys_execve(char __user *path, compat_uptr_t __user *argv,
+		       compat_uptr_t __user *envp, struct pt_regs *regs)
+{
+	int error;
+	char *filename;
+
+	filename = getname(path);
+	error = PTR_ERR(filename);
+	if (IS_ERR(filename))
+		goto out;
+	error = compat_do_execve(filename, argv, envp, regs);
+	putname(filename);
+out:
+	return error;
+}
+#endif
+
+unsigned long get_wchan(struct task_struct *p)
+{
+	struct KBacktraceIterator kbt;
+
+	if (!p || p == current || p->state == TASK_RUNNING)
+		return 0;
+
+	for (KBacktraceIterator_init(&kbt, p, NULL);
+	     !KBacktraceIterator_end(&kbt);
+	     KBacktraceIterator_next(&kbt)) {
+		if (!in_sched_functions(kbt.it.pc))
+			return kbt.it.pc;
+	}
+
+	return 0;
+}
+
+/*
+ * We pass in lr as zero (cleared in kernel_thread) and the caller
+ * part of the backtrace ABI on the stack also zeroed (in copy_thread)
+ * so that backtraces will stop with this function.
+ * Note that we don't use r0, since copy_thread() clears it.
+ */
+static void start_kernel_thread(int dummy, int (*fn)(int), int arg)
+{
+	do_exit(fn(arg));
+}
+
+/*
+ * Create a kernel thread
+ */
+int kernel_thread(int (*fn)(void *), void * arg, unsigned long flags)
+{
+	struct pt_regs regs;
+
+	memset(&regs, 0, sizeof(regs));
+	regs.ex1 = PL_ICS_EX1(KERNEL_PL, 0);  /* run at kernel PL, no ICS */
+	regs.pc = (long) start_kernel_thread;
+	regs.flags = PT_FLAGS_CALLER_SAVES;   /* need to restore r1 and r2 */
+	regs.regs[1] = (long) fn;             /* function pointer */
+	regs.regs[2] = (long) arg;            /* parameter register */
+
+	/* Ok, create the new process.. */
+	return do_fork(flags | CLONE_VM | CLONE_UNTRACED, 0, &regs,
+		       0, NULL, NULL);
+}
+EXPORT_SYMBOL(kernel_thread);
+
+/* Flush thread state. */
+void flush_thread(void)
+{
+	/* Nothing */
+}
+
+/*
+ * Free current thread data structures etc..
+ */
+void exit_thread(void)
+{
+	/* Nothing */
+}
+
+#ifdef __tilegx__
+# define LINECOUNT 3
+# define EXTRA_NL "\n"
+#else
+# define LINECOUNT 4
+# define EXTRA_NL ""
+#endif
+
+void show_regs(struct pt_regs *regs)
+{
+	struct task_struct *tsk = validate_current();
+	int i, linebreak;
+	printk("\n");
+	printk(" Pid: %d, comm: %20s, CPU: %d\n",
+	       tsk->pid, tsk->comm, smp_processor_id());
+	for (i = linebreak = 0; i < 53; ++i) {
+		printk(" r%-2d: "REGFMT, i, regs->regs[i]);
+		if (++linebreak == LINECOUNT) {
+			linebreak = 0;
+			printk("\n");
+		}
+	}
+	printk(" tp : "REGFMT EXTRA_NL " sp : "REGFMT" lr : "REGFMT"\n",
+	       regs->tp, regs->sp, regs->lr);
+	printk(" pc : "REGFMT" ex1: %ld     faultnum: %ld\n",
+	       regs->pc, regs->ex1, regs->faultnum);
+
+	dump_stack_regs(regs);
+}
diff --git a/arch/tile/kernel/ptrace.c b/arch/tile/kernel/ptrace.c
new file mode 100644
index 0000000..4680549
--- /dev/null
+++ b/arch/tile/kernel/ptrace.c
@@ -0,0 +1,203 @@
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
+ *
+ * Copied from i386: Ross Biro 1/23/92
+ */
+
+#include <linux/kernel.h>
+#include <linux/ptrace.h>
+#include <linux/kprobes.h>
+#include <linux/compat.h>
+#include <linux/uaccess.h>
+
+void user_enable_single_step(struct task_struct *child)
+{
+	set_tsk_thread_flag(child, TIF_SINGLESTEP);
+}
+
+void user_disable_single_step(struct task_struct *child)
+{
+	clear_tsk_thread_flag(child, TIF_SINGLESTEP);
+}
+
+/*
+ * This routine will put a word on the process's privileged stack.
+ */
+static void putreg(struct task_struct *task,
+		   unsigned long addr, unsigned long value)
+{
+	unsigned int regno = addr / sizeof(unsigned long);
+	struct pt_regs *childregs = task_pt_regs(task);
+	childregs->regs[regno] = value;
+	childregs->flags |= PT_FLAGS_RESTORE_REGS;
+}
+
+static unsigned long getreg(struct task_struct *task, unsigned long addr)
+{
+	unsigned int regno = addr / sizeof(unsigned long);
+	struct pt_regs *childregs = task_pt_regs(task);
+	return childregs->regs[regno];
+}
+
+/*
+ * Called by kernel/ptrace.c when detaching..
+ */
+void ptrace_disable(struct task_struct *child)
+{
+	clear_tsk_thread_flag(child, TIF_SINGLESTEP);
+
+	/*
+	 * These two are currently unused, but will be set by arch_ptrace()
+	 * and used in the syscall assembly when we do support them.
+	 */
+	clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
+}
+
+long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+{
+	unsigned long __user *datap;
+	unsigned long tmp;
+	int i;
+	long ret = -EIO;
+
+#ifdef CONFIG_COMPAT
+	if (task_thread_info(current)->status & TS_COMPAT)
+		data = (u32)data;
+	if (task_thread_info(child)->status & TS_COMPAT)
+		addr = (u32)addr;
+#endif
+	datap = (unsigned long __user *)data;
+
+	switch (request) {
+
+	case PTRACE_PEEKUSR:  /* Read register from pt_regs. */
+		if (addr & (sizeof(data)-1))
+			break;
+		if (addr < 0 || addr >= PTREGS_SIZE)
+			break;
+		tmp = getreg(child, addr);   /* Read register */
+		ret = put_user(tmp, datap);
+		break;
+
+	case PTRACE_POKEUSR:  /* Write register in pt_regs. */
+		if (addr & (sizeof(data)-1))
+			break;
+		if (addr < 0 || addr >= PTREGS_SIZE)
+			break;
+		putreg(child, addr, data);   /* Write register */
+		break;
+
+	case PTRACE_GETREGS:  /* Get all registers from the child. */
+		if (!access_ok(VERIFY_WRITE, datap, PTREGS_SIZE))
+			break;
+		for (i = 0; i < PTREGS_SIZE; i += sizeof(long)) {
+			ret = __put_user(getreg(child, i), datap);
+			if (ret != 0)
+				break;
+			datap++;
+		}
+		break;
+
+	case PTRACE_SETREGS:  /* Set all registers in the child. */
+		if (!access_ok(VERIFY_READ, datap, PTREGS_SIZE))
+			break;
+		for (i = 0; i < PTREGS_SIZE; i += sizeof(long)) {
+			ret = __get_user(tmp, datap);
+			if (ret != 0)
+				break;
+			putreg(child, i, tmp);
+			datap++;
+		}
+		break;
+
+	case PTRACE_GETFPREGS:  /* Get the child FPU state. */
+	case PTRACE_SETFPREGS:  /* Set the child FPU state. */
+		break;
+
+	case PTRACE_SETOPTIONS:
+		/* Support TILE-specific ptrace options. */
+		child->ptrace &= ~PT_TRACE_MASK_TILE;
+		tmp = data & PTRACE_O_MASK_TILE;
+		data &= ~PTRACE_O_MASK_TILE;
+		ret = ptrace_request(child, request, addr, data);
+		if (tmp & PTRACE_O_TRACEMIGRATE)
+			child->ptrace |= PT_TRACE_MIGRATE;
+		break;
+
+	default:
+#ifdef CONFIG_COMPAT
+		if (task_thread_info(current)->status & TS_COMPAT) {
+			ret = compat_ptrace_request(child, request,
+						    addr, data);
+			break;
+		}
+#endif
+		ret = ptrace_request(child, request, addr, data);
+		break;
+	}
+
+	return ret;
+}
+
+#ifdef CONFIG_COMPAT
+/* Not used; we handle compat issues in arch_ptrace() directly. */
+long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
+			       compat_ulong_t addr, compat_ulong_t data)
+{
+	BUG();
+}
+#endif
+
+void do_syscall_trace(void)
+{
+	if (!test_thread_flag(TIF_SYSCALL_TRACE))
+		return;
+
+	if (!(current->ptrace & PT_PTRACED))
+		return;
+
+	/*
+	 * The 0x80 provides a way for the tracing parent to distinguish
+	 * between a syscall stop and SIGTRAP delivery
+	 */
+	ptrace_notify(SIGTRAP|((current->ptrace & PT_TRACESYSGOOD) ? 0x80 : 0));
+
+	/*
+	 * this isn't the same as continuing with a signal, but it will do
+	 * for normal use.  strace only continues with a signal if the
+	 * stopping signal is not SIGTRAP.  -brl
+	 */
+	if (current->exit_code) {
+		send_sig(current->exit_code, current, 1);
+		current->exit_code = 0;
+	}
+}
+
+void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs, int error_code)
+{
+	struct siginfo info;
+
+	memset(&info, 0, sizeof(info));
+	info.si_signo = SIGTRAP;
+	info.si_code  = TRAP_BRKPT;
+	info.si_addr  = (void __user *) regs->pc;
+
+	/* Send us the fakey SIGTRAP */
+	force_sig_info(SIGTRAP, &info, tsk);
+}
+
+/* Handle synthetic interrupt delivered only by the simulator. */
+void __kprobes do_breakpoint(struct pt_regs* regs, int fault_num)
+{
+	send_sigtrap(current, regs, fault_num);
+}
diff --git a/arch/tile/kernel/reboot.c b/arch/tile/kernel/reboot.c
new file mode 100644
index 0000000..a452392
--- /dev/null
+++ b/arch/tile/kernel/reboot.c
@@ -0,0 +1,52 @@
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
+#include <linux/stddef.h>
+#include <linux/reboot.h>
+#include <linux/smp.h>
+#include <asm/page.h>
+#include <asm/setup.h>
+#include <hv/hypervisor.h>
+
+#ifndef CONFIG_SMP
+#define smp_send_stop()
+#endif
+
+void machine_halt(void)
+{
+	warn_early_printk();
+	raw_local_irq_disable_all();
+	smp_send_stop();
+	hv_halt();
+}
+
+void machine_power_off(void)
+{
+	warn_early_printk();
+	raw_local_irq_disable_all();
+	smp_send_stop();
+	hv_power_off();
+}
+
+void machine_restart(char *cmd)
+{
+	raw_local_irq_disable_all();
+	smp_send_stop();
+	hv_restart((HV_VirtAddr) "vmlinux", (HV_VirtAddr) cmd);
+}
+
+/*
+ * Power off function, if any
+ */
+void (*pm_power_off)(void) = machine_power_off;
diff --git a/arch/tile/kernel/regs_32.S b/arch/tile/kernel/regs_32.S
new file mode 100644
index 0000000..e88d6e1
--- /dev/null
+++ b/arch/tile/kernel/regs_32.S
@@ -0,0 +1,145 @@
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
+#include <linux/linkage.h>
+#include <asm/system.h>
+#include <asm/ptrace.h>
+#include <asm/asm-offsets.h>
+#include <arch/spr_def.h>
+#include <asm/processor.h>
+
+/*
+ * See <asm/system.h>; called with prev and next task_struct pointers.
+ * "prev" is returned in r0 for _switch_to and also for ret_from_fork.
+ *
+ * We want to save pc/sp in "prev", and get the new pc/sp from "next".
+ * We also need to save all the callee-saved registers on the stack.
+ *
+ * Intel enables/disables access to the hardware cycle counter in
+ * seccomp (secure computing) environments if necessary, based on
+ * has_secure_computing().  We might want to do this at some point,
+ * though it would require virtualizing the other SPRs under WORLD_ACCESS.
+ *
+ * Since we're saving to the stack, we omit sp from this list.
+ * And for parallels with other architectures, we save lr separately,
+ * in the thread_struct itself (as the "pc" field).
+ *
+ * This code also needs to be aligned with process.c copy_thread()
+ */
+
+#if CALLEE_SAVED_REGS_COUNT != 24
+# error Mismatch between <asm/system.h> and kernel/entry.S
+#endif
+#define FRAME_SIZE ((2 + CALLEE_SAVED_REGS_COUNT) * 4)
+
+#define SAVE_REG(r) { sw r12, r; addi r12, r12, 4 }
+#define LOAD_REG(r) { lw r, r12; addi r12, r12, 4 }
+#define FOR_EACH_CALLEE_SAVED_REG(f)					\
+							f(r30); f(r31); \
+	f(r32); f(r33); f(r34); f(r35);	f(r36); f(r37); f(r38); f(r39); \
+	f(r40); f(r41); f(r42); f(r43); f(r44); f(r45); f(r46); f(r47); \
+	f(r48); f(r49); f(r50); f(r51); f(r52);
+
+STD_ENTRY_SECTION(__switch_to, .sched.text)
+	{
+	  move r10, sp
+	  sw sp, lr
+	  addi sp, sp, -FRAME_SIZE
+	}
+	{
+	  addi r11, sp, 4
+	  addi r12, sp, 8
+	}
+	{
+	  sw r11, r10
+	  addli r4, r1, TASK_STRUCT_THREAD_KSP_OFFSET
+	}
+	{
+	  lw r13, r4   /* Load new sp to a temp register early. */
+	  addli r3, r0, TASK_STRUCT_THREAD_KSP_OFFSET
+	}
+	FOR_EACH_CALLEE_SAVED_REG(SAVE_REG)
+	{
+	  sw r3, sp
+	  addli r3, r0, TASK_STRUCT_THREAD_PC_OFFSET
+	}
+	{
+	  sw r3, lr
+	  addli r4, r1, TASK_STRUCT_THREAD_PC_OFFSET
+	}
+	{
+	  lw lr, r4
+	  addi r12, r13, 8
+	}
+	{
+	  /* Update sp and ksp0 simultaneously to avoid backtracer warnings. */
+	  move sp, r13
+	  mtspr SYSTEM_SAVE_1_0, r2
+	}
+	FOR_EACH_CALLEE_SAVED_REG(LOAD_REG)
+.L__switch_to_pc:
+	{
+	  addi sp, sp, FRAME_SIZE
+	  jrp lr   /* r0 is still valid here, so return it */
+	}
+	STD_ENDPROC(__switch_to)
+
+/* Return a suitable address for the backtracer for suspended threads */
+STD_ENTRY_SECTION(get_switch_to_pc, .sched.text)
+	lnk r0
+	{
+	  addli r0, r0, .L__switch_to_pc - .
+	  jrp lr
+	}
+	STD_ENDPROC(get_switch_to_pc)
+
+STD_ENTRY(get_pt_regs)
+	.irp reg, r0, r1, r2, r3, r4, r5, r6, r7, \
+		 r8, r9, r10, r11, r12, r13, r14, r15, \
+		 r16, r17, r18, r19, r20, r21, r22, r23, \
+		 r24, r25, r26, r27, r28, r29, r30, r31, \
+		 r32, r33, r34, r35, r36, r37, r38, r39, \
+		 r40, r41, r42, r43, r44, r45, r46, r47, \
+		 r48, r49, r50, r51, r52, tp, sp
+	{
+	 sw r0, \reg
+	 addi r0, r0, 4
+	}
+	.endr
+	{
+	 sw r0, lr
+	 addi r0, r0, PTREGS_OFFSET_PC - PTREGS_OFFSET_LR
+	}
+	lnk r1
+	{
+	 sw r0, r1
+	 addi r0, r0, PTREGS_OFFSET_EX1 - PTREGS_OFFSET_PC
+	}
+	mfspr r1, INTERRUPT_CRITICAL_SECTION
+	shli r1, r1, SPR_EX_CONTEXT_1_1__ICS_SHIFT
+	ori r1, r1, KERNEL_PL
+	{
+	 sw r0, r1
+	 addi r0, r0, PTREGS_OFFSET_FAULTNUM - PTREGS_OFFSET_EX1
+	}
+	{
+	 sw r0, zero       /* clear faultnum */
+	 addi r0, r0, PTREGS_OFFSET_ORIG_R0 - PTREGS_OFFSET_FAULTNUM
+	}
+	{
+	 sw r0, zero       /* clear orig_r0 */
+	 addli r0, r0, -PTREGS_OFFSET_ORIG_R0    /* restore r0 to base */
+	}
+	jrp lr
+	STD_ENDPROC(get_pt_regs)
diff --git a/arch/tile/kernel/relocate_kernel.S b/arch/tile/kernel/relocate_kernel.S
new file mode 100644
index 0000000..010b418
--- /dev/null
+++ b/arch/tile/kernel/relocate_kernel.S
@@ -0,0 +1,280 @@
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
+ *
+ * copy new kernel into place and then call hv_reexec
+ *
+ */
+
+#include <linux/linkage.h>
+#include <arch/chip.h>
+#include <asm/page.h>
+#include <hv/hypervisor.h>
+
+#define ___hvb	MEM_SV_INTRPT + HV_GLUE_START_CPA
+
+#define ___hv_dispatch(f) (___hvb + (HV_DISPATCH_ENTRY_SIZE * f))
+
+#define ___hv_console_putc ___hv_dispatch(HV_DISPATCH_CONSOLE_PUTC)
+#define ___hv_halt         ___hv_dispatch(HV_DISPATCH_HALT)
+#define ___hv_reexec       ___hv_dispatch(HV_DISPATCH_REEXEC)
+#define ___hv_flush_remote ___hv_dispatch(HV_DISPATCH_FLUSH_REMOTE)
+
+#undef RELOCATE_NEW_KERNEL_VERBOSE
+
+STD_ENTRY(relocate_new_kernel)
+
+	move	r30, r0		/* page list */
+	move	r31, r1		/* address of page we are on */
+	move	r32, r2		/* start address of new kernel */
+
+	shri	r1, r1, PAGE_SHIFT
+	addi	r1, r1, 1
+	shli	sp, r1, PAGE_SHIFT
+	addi	sp, sp, -8
+	/* we now have a stack (whether we need one or not) */
+
+	moveli	r40, lo16(___hv_console_putc)
+	auli	r40, r40, ha16(___hv_console_putc)
+
+#ifdef RELOCATE_NEW_KERNEL_VERBOSE
+	moveli	r0, 'r'
+	jalr	r40
+
+	moveli	r0, '_'
+	jalr	r40
+
+	moveli	r0, 'n'
+	jalr	r40
+
+	moveli	r0, '_'
+	jalr	r40
+
+	moveli	r0, 'k'
+	jalr	r40
+
+	moveli	r0, '\n'
+	jalr	r40
+#endif
+
+	/*
+	 * Throughout this code r30 is pointer to the element of page
+	 * list we are working on.
+	 *
+	 * Normally we get to the next element of the page list by
+	 * incrementing r30 by four.  The exception is if the element
+	 * on the page list is an IND_INDIRECTION in which case we use
+	 * the element with the low bits masked off as the new value
+	 * of r30.
+	 *
+	 * To get this started, we need the value passed to us (which
+	 * will always be an IND_INDIRECTION) in memory somewhere with
+	 * r30 pointing at it.  To do that, we push the value passed
+	 * to us on the stack and make r30 point to it.
+	 */
+
+	sw	sp, r30
+	move	r30, sp
+	addi	sp, sp, -8
+
+#if CHIP_HAS_CBOX_HOME_MAP()
+	/*
+	 * On TILEPro, we need to flush all tiles' caches, since we may
+	 * have been doing hash-for-home caching there.  Note that we
+	 * must do this _after_ we're completely done modifying any memory
+	 * other than our output buffer (which we know is locally cached).
+	 * We want the caches to be fully clean when we do the reexec,
+	 * because the hypervisor is going to do this flush again at that
+	 * point, and we don't want that second flush to overwrite any memory.
+	 */
+	{
+	 move	r0, zero	 /* cache_pa */
+	 move	r1, zero
+	}
+	{
+	 auli	r2, zero, ha16(HV_FLUSH_EVICT_L2) /* cache_control */
+	 movei	r3, -1		 /* cache_cpumask; -1 means all client tiles */
+	}
+	{
+	 move	r4, zero	 /* tlb_va */
+	 move	r5, zero	 /* tlb_length */
+	}
+	{
+	 move	r6, zero	 /* tlb_pgsize */
+	 move	r7, zero	 /* tlb_cpumask */
+	}
+	{
+	 move	r8, zero	 /* asids */
+	 moveli	r20, lo16(___hv_flush_remote)
+	}
+	{
+	 move	r9, zero	 /* asidcount */
+	 auli	r20, r20, ha16(___hv_flush_remote)
+	}
+
+	jalr	r20
+#endif
+
+	/* r33 is destination pointer, default to zero */
+
+	moveli	r33, 0
+
+.Lloop:	lw	r10, r30
+
+	andi	r9, r10, 0xf	/* low 4 bits tell us what type it is */
+	xor	r10, r10, r9	/* r10 is now value with low 4 bits stripped */
+
+	seqi	r0, r9, 0x1	/* IND_DESTINATION */
+	bzt	r0, .Ltry2
+
+	move	r33, r10
+
+#ifdef RELOCATE_NEW_KERNEL_VERBOSE
+	moveli	r0, 'd'
+	jalr	r40
+#endif
+
+	addi	r30, r30, 4
+	j	.Lloop
+
+.Ltry2:
+	seqi	r0, r9, 0x2	/* IND_INDIRECTION */
+	bzt	r0, .Ltry4
+
+	move	r30, r10
+
+#ifdef RELOCATE_NEW_KERNEL_VERBOSE
+	moveli	r0, 'i'
+	jalr	r40
+#endif
+
+	j	.Lloop
+
+.Ltry4:
+	seqi	r0, r9, 0x4	/* IND_DONE */
+	bzt	r0, .Ltry8
+
+	mf
+
+#ifdef RELOCATE_NEW_KERNEL_VERBOSE
+	moveli	r0, 'D'
+	jalr	r40
+	moveli	r0, '\n'
+	jalr	r40
+#endif
+
+	move	r0, r32
+	moveli	r1, 0		/* arg to hv_reexec is 64 bits */
+
+	moveli	r41, lo16(___hv_reexec)
+	auli	r41, r41, ha16(___hv_reexec)
+
+	jalr	r41
+
+	/* we should not get here */
+
+	moveli	r0, '?'
+	jalr	r40
+	moveli	r0, '\n'
+	jalr	r40
+
+	j	.Lhalt
+
+.Ltry8:	seqi	r0, r9, 0x8	/* IND_SOURCE */
+	bz	r0, .Lerr	/* unknown type */
+
+	/* copy page at r10 to page at r33 */
+
+	move	r11, r33
+
+	moveli	r0, lo16(PAGE_SIZE)
+	auli	r0, r0, ha16(PAGE_SIZE)
+	add	r33, r33, r0
+
+	/* copy word at r10 to word at r11 until r11 equals r33 */
+
+	/* We know page size must be multiple of 16, so we can unroll
+	 * 16 times safely without any edge case checking.
+	 *
+	 * Issue a flush of the destination every 16 words to avoid
+	 * incoherence when starting the new kernel.  (Now this is
+	 * just good paranoia because the hv_reexec call will also
+	 * take care of this.)
+	 */
+
+1:
+	{ lw	r0, r10; addi	r10, r10, 4 }
+	{ sw	r11, r0; addi	r11, r11, 4 }
+	{ lw	r0, r10; addi	r10, r10, 4 }
+	{ sw	r11, r0; addi	r11, r11, 4 }
+	{ lw	r0, r10; addi	r10, r10, 4 }
+	{ sw	r11, r0; addi	r11, r11, 4 }
+	{ lw	r0, r10; addi	r10, r10, 4 }
+	{ sw	r11, r0; addi	r11, r11, 4 }
+	{ lw	r0, r10; addi	r10, r10, 4 }
+	{ sw	r11, r0; addi	r11, r11, 4 }
+	{ lw	r0, r10; addi	r10, r10, 4 }
+	{ sw	r11, r0; addi	r11, r11, 4 }
+	{ lw	r0, r10; addi	r10, r10, 4 }
+	{ sw	r11, r0; addi	r11, r11, 4 }
+	{ lw	r0, r10; addi	r10, r10, 4 }
+	{ sw	r11, r0; addi	r11, r11, 4 }
+	{ lw	r0, r10; addi	r10, r10, 4 }
+	{ sw	r11, r0; addi	r11, r11, 4 }
+	{ lw	r0, r10; addi	r10, r10, 4 }
+	{ sw	r11, r0; addi	r11, r11, 4 }
+	{ lw	r0, r10; addi	r10, r10, 4 }
+	{ sw	r11, r0; addi	r11, r11, 4 }
+	{ lw	r0, r10; addi	r10, r10, 4 }
+	{ sw	r11, r0; addi	r11, r11, 4 }
+	{ lw	r0, r10; addi	r10, r10, 4 }
+	{ sw	r11, r0; addi	r11, r11, 4 }
+	{ lw	r0, r10; addi	r10, r10, 4 }
+	{ sw	r11, r0; addi	r11, r11, 4 }
+	{ lw	r0, r10; addi	r10, r10, 4 }
+	{ sw	r11, r0; addi	r11, r11, 4 }
+	{ lw	r0, r10; addi	r10, r10, 4 }
+	{ sw	r11, r0 }
+	{ flush r11    ; addi	r11, r11, 4 }
+
+	seq	r0, r33, r11
+	bzt	r0, 1b
+
+#ifdef RELOCATE_NEW_KERNEL_VERBOSE
+	moveli	r0, 's'
+	jalr	r40
+#endif
+
+	addi	r30, r30, 4
+	j	.Lloop
+
+
+.Lerr:	moveli	r0, 'e'
+	jalr	r40
+	moveli	r0, 'r'
+	jalr	r40
+	moveli	r0, 'r'
+	jalr	r40
+	moveli	r0, '\n'
+	jalr	r40
+.Lhalt:
+	moveli	r41, lo16(___hv_halt)
+	auli	r41, r41, ha16(___hv_halt)
+
+	jalr	r41
+	STD_ENDPROC(relocate_new_kernel)
+
+	.section .rodata,"a"
+
+	.globl relocate_new_kernel_size
+relocate_new_kernel_size:
+	.long .Lend_relocate_new_kernel - relocate_new_kernel
diff --git a/arch/tile/kernel/setup.c b/arch/tile/kernel/setup.c
new file mode 100644
index 0000000..333262d
--- /dev/null
+++ b/arch/tile/kernel/setup.c
@@ -0,0 +1,1497 @@
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
+#include <linux/sched.h>
+#include <linux/kernel.h>
+#include <linux/mmzone.h>
+#include <linux/bootmem.h>
+#include <linux/module.h>
+#include <linux/node.h>
+#include <linux/cpu.h>
+#include <linux/ioport.h>
+#include <linux/kexec.h>
+#include <linux/pci.h>
+#include <linux/initrd.h>
+#include <linux/io.h>
+#include <linux/highmem.h>
+#include <linux/smp.h>
+#include <linux/timex.h>
+#include <asm/setup.h>
+#include <asm/sections.h>
+#include <asm/sections.h>
+#include <asm/cacheflush.h>
+#include <asm/cacheflush.h>
+#include <asm/pgalloc.h>
+#include <asm/mmu_context.h>
+#include <hv/hypervisor.h>
+#include <arch/interrupts.h>
+
+/* <linux/smp.h> doesn't provide this definition. */
+#ifndef CONFIG_SMP
+#define setup_max_cpus 1
+#endif
+
+static inline int ABS(int x) { return x >= 0 ? x : -x; }
+
+/* Chip information */
+char chip_model[64] __write_once;
+
+struct pglist_data node_data[MAX_NUMNODES] __read_mostly;
+EXPORT_SYMBOL(node_data);
+
+/* We only create bootmem data on node 0. */
+static bootmem_data_t __initdata node0_bdata;
+
+/* Information on the NUMA nodes that we compute early */
+unsigned long __cpuinitdata node_start_pfn[MAX_NUMNODES];
+unsigned long __cpuinitdata node_end_pfn[MAX_NUMNODES];
+unsigned long __initdata node_memmap_pfn[MAX_NUMNODES];
+unsigned long __initdata node_percpu_pfn[MAX_NUMNODES];
+unsigned long __initdata node_free_pfn[MAX_NUMNODES];
+
+#ifdef CONFIG_HIGHMEM
+/* Page frame index of end of lowmem on each controller. */
+unsigned long __cpuinitdata node_lowmem_end_pfn[MAX_NUMNODES];
+
+/* Number of pages that can be mapped into lowmem. */
+static unsigned long __initdata mappable_physpages;
+#endif
+
+/* Data on which physical memory controller corresponds to which NUMA node */
+int node_controller[MAX_NUMNODES] = { [0 ... MAX_NUMNODES-1] = -1 };
+
+#ifdef CONFIG_HIGHMEM
+/* Map information from VAs to PAs */
+unsigned long pbase_map[1 << (32 - HPAGE_SHIFT)]
+  __write_once __attribute__((aligned(L2_CACHE_BYTES)));
+EXPORT_SYMBOL(pbase_map);
+
+/* Map information from PAs to VAs */
+void *vbase_map[NR_PA_HIGHBIT_VALUES]
+  __write_once __attribute__((aligned(L2_CACHE_BYTES)));
+EXPORT_SYMBOL(vbase_map);
+#endif
+
+/* Node number as a function of the high PA bits */
+int highbits_to_node[NR_PA_HIGHBIT_VALUES] __write_once;
+EXPORT_SYMBOL(highbits_to_node);
+
+static unsigned int __initdata maxmem_pfn = -1U;
+static unsigned int __initdata maxnodemem_pfn[MAX_NUMNODES] = {
+	[0 ... MAX_NUMNODES-1] = -1U
+};
+static nodemask_t __initdata isolnodes;
+
+#ifdef CONFIG_PCI
+enum { DEFAULT_PCI_RESERVE_MB = 64 };
+static unsigned int __initdata pci_reserve_mb = DEFAULT_PCI_RESERVE_MB;
+unsigned long __initdata pci_reserve_start_pfn = -1U;
+unsigned long __initdata pci_reserve_end_pfn = -1U;
+#endif
+
+static int __init setup_maxmem(char *str)
+{
+	long maxmem_mb;
+	if (str == NULL || strict_strtol(str, 0, &maxmem_mb) != 0 ||
+	    maxmem_mb == 0)
+		return -EINVAL;
+
+	maxmem_pfn = (maxmem_mb >> (HPAGE_SHIFT - 20)) <<
+		(HPAGE_SHIFT - PAGE_SHIFT);
+	printk("Forcing RAM used to no more than %dMB\n",
+	       maxmem_pfn >> (20 - PAGE_SHIFT));
+	return 0;
+}
+early_param("maxmem", setup_maxmem);
+
+static int __init setup_maxnodemem(char *str)
+{
+	char *endp;
+	long maxnodemem_mb, node;
+
+	node = str ? simple_strtoul(str, &endp, 0) : INT_MAX;
+	if (node >= MAX_NUMNODES || *endp != ':' ||
+	    strict_strtol(endp+1, 0, &maxnodemem_mb) != 0)
+		return -EINVAL;
+
+	maxnodemem_pfn[node] = (maxnodemem_mb >> (HPAGE_SHIFT - 20)) <<
+		(HPAGE_SHIFT - PAGE_SHIFT);
+	printk("Forcing RAM used on node %ld to no more than %dMB\n",
+	       node, maxnodemem_pfn[node] >> (20 - PAGE_SHIFT));
+	return 0;
+}
+early_param("maxnodemem", setup_maxnodemem);
+
+static int __init setup_isolnodes(char *str)
+{
+	char buf[MAX_NUMNODES * 5];
+	if (str == NULL || nodelist_parse(str, isolnodes) != 0)
+		return -EINVAL;
+
+	nodelist_scnprintf(buf, sizeof(buf), isolnodes);
+	printk("Set isolnodes value to '%s'\n", buf);
+	return 0;
+}
+early_param("isolnodes", setup_isolnodes);
+
+#ifdef CONFIG_PCI
+static int __init setup_pci_reserve(char* str)
+{
+	unsigned long mb;
+
+	if (str == NULL || strict_strtoul(str, 0, &mb) != 0 ||
+	    mb > 3 * 1024)
+		return -EINVAL;
+
+	pci_reserve_mb = mb;
+	printk("Reserving %dMB for PCIE root complex mappings\n",
+	       pci_reserve_mb);
+	return 0;
+}
+early_param("pci_reserve", setup_pci_reserve);
+#endif
+
+#ifndef __tilegx__
+/*
+ * vmalloc=size forces the vmalloc area to be exactly 'size' bytes.
+ * This can be used to increase (or decrease) the vmalloc area.
+ */
+static int __init parse_vmalloc(char *arg)
+{
+	if (!arg)
+		return -EINVAL;
+
+	VMALLOC_RESERVE = (memparse(arg, &arg) + PGDIR_SIZE - 1) & PGDIR_MASK;
+
+	/* See validate_va() for more on this test. */
+	if ((long)_VMALLOC_START >= 0)
+		early_panic("\"vmalloc=%#lx\" value too large: maximum %#lx\n",
+			    VMALLOC_RESERVE, _VMALLOC_END - 0x80000000UL);
+
+	return 0;
+}
+early_param("vmalloc", parse_vmalloc);
+#endif
+
+#ifdef CONFIG_HIGHMEM
+/*
+ * Determine for each controller where its lowmem is mapped and how
+ * much of it is mapped there.  On controller zero, the first few
+ * megabytes are mapped at 0xfd000000 as code, so in principle we
+ * could start our data mappings higher up, but for now we don't
+ * bother, to avoid additional confusion.
+ *
+ * One question is whether, on systems with more than 768 Mb and
+ * controllers of different sizes, to map in a proportionate amount of
+ * each one, or to try to map the same amount from each controller.
+ * (E.g. if we have three controllers with 256MB, 1GB, and 256MB
+ * respectively, do we map 256MB from each, or do we map 128 MB, 512
+ * MB, and 128 MB respectively?)  For now we use a proportionate
+ * solution like the latter.
+ *
+ * The VA/PA mapping demands that we align our decisions at 16 MB
+ * boundaries so that we can rapidly convert VA to PA.
+ */
+static void *__init setup_pa_va_mapping(void)
+{
+	unsigned long curr_pages = 0;
+	unsigned long vaddr = PAGE_OFFSET;
+	nodemask_t highonlynodes = isolnodes;
+	int i, j;
+
+	memset(pbase_map, -1, sizeof(pbase_map));
+	memset(vbase_map, -1, sizeof(vbase_map));
+
+	/* Node zero cannot be isolated for LOWMEM purposes. */
+	node_clear(0, highonlynodes);
+
+	/* Count up the number of pages on non-highonlynodes controllers. */
+	mappable_physpages = 0;
+	for_each_online_node(i) {
+		if (!node_isset(i, highonlynodes))
+			mappable_physpages +=
+				node_end_pfn[i] - node_start_pfn[i];
+	}
+
+	for_each_online_node(i) {
+		unsigned long start = node_start_pfn[i];
+		unsigned long end = node_end_pfn[i];
+		unsigned long size = end - start;
+		unsigned long vaddr_end;
+
+		if (node_isset(i, highonlynodes)) {
+			/* Mark this controller as having no lowmem. */
+			node_lowmem_end_pfn[i] = start;
+			continue;
+		}
+
+		curr_pages += size;
+		if (mappable_physpages > MAXMEM_PFN) {
+			vaddr_end = PAGE_OFFSET +
+				(((u64)curr_pages * MAXMEM_PFN /
+				  mappable_physpages)
+				 << PAGE_SHIFT);
+		} else {
+			vaddr_end = PAGE_OFFSET + (curr_pages << PAGE_SHIFT);
+		}
+		for (j = 0; vaddr < vaddr_end; vaddr += HPAGE_SIZE, ++j) {
+			unsigned long this_pfn =
+				start + (j << HUGETLB_PAGE_ORDER);
+			pbase_map[vaddr >> HPAGE_SHIFT] = this_pfn;
+			if (vbase_map[__pfn_to_highbits(this_pfn)] ==
+			    (void *)-1)
+				vbase_map[__pfn_to_highbits(this_pfn)] =
+					(void *)(vaddr & HPAGE_MASK);
+		}
+		node_lowmem_end_pfn[i] = start + (j << HUGETLB_PAGE_ORDER);
+		BUG_ON(node_lowmem_end_pfn[i] > end);
+	}
+
+	/* Return highest address of any mapped memory. */
+	return (void *)vaddr;
+}
+#endif /* CONFIG_HIGHMEM */
+
+/*
+ * Register our most important memory mappings with the debug stub.
+ *
+ * This is up to 4 mappings for lowmem, one mapping per memory
+ * controller, plus one for our text segment.
+ */
+void __cpuinit store_permanent_mappings(void)
+{
+	int i;
+
+	for_each_online_node(i) {
+		HV_PhysAddr pa = ((HV_PhysAddr)node_start_pfn[i]) << PAGE_SHIFT;
+#ifdef CONFIG_HIGHMEM
+		HV_PhysAddr high_mapped_pa = node_lowmem_end_pfn[i];
+#else
+		HV_PhysAddr high_mapped_pa = node_end_pfn[i];
+#endif
+
+		unsigned long pages = high_mapped_pa - node_start_pfn[i];
+		HV_VirtAddr addr = (HV_VirtAddr) __va(pa);
+		hv_store_mapping(addr, pages << PAGE_SHIFT, pa);
+	}
+
+	hv_store_mapping((HV_VirtAddr)_stext,
+			 (uint32_t)(_einittext - _stext), 0);
+}
+
+/*
+ * Use hv_inquire_physical() to populate node_{start,end}_pfn[]
+ * and node_online_map, doing suitable sanity-checking.
+ * Also set min_low_pfn, max_low_pfn, and max_pfn.
+ */
+static void __init setup_memory(void)
+{
+	int i, j;
+	int highbits_seen[NR_PA_HIGHBIT_VALUES] = { 0 };
+#ifdef CONFIG_HIGHMEM
+	long highmem_pages;
+#endif
+#ifndef __tilegx__
+	int cap;
+#endif
+#if defined(CONFIG_HIGHMEM) || defined(__tilegx__)
+	long lowmem_pages;
+#endif
+
+	/* We are using a char to hold the cpu_2_node[] mapping */
+	BUG_ON(MAX_NUMNODES > 127);
+
+	/* Discover the ranges of memory available to us */
+	for (i = 0; ; ++i) {
+		unsigned long start, size, end, highbits;
+		HV_PhysAddrRange range = hv_inquire_physical(i);
+		if (range.size == 0)
+			break;
+#ifdef CONFIG_FLATMEM
+		if (i > 0) {
+			printk("Can't use discontiguous PAs: %#llx..%#llx\n",
+			       range.size, range.start + range.size);
+			continue;
+		}
+#endif
+#ifndef __tilegx__
+		if ((unsigned long)range.start) {
+			printk("Range not at 4GB multiple: %#llx..%#llx\n",
+			       range.start, range.start + range.size);
+			continue;
+		}
+#endif
+		if ((range.start & (HPAGE_SIZE-1)) != 0 ||
+		    (range.size & (HPAGE_SIZE-1)) != 0) {
+			unsigned long long start_pa = range.start;
+			unsigned long long size = range.size;
+			range.start = (start_pa + HPAGE_SIZE - 1) & HPAGE_MASK;
+			range.size -= (range.start - start_pa);
+			range.size &= HPAGE_MASK;
+			printk("Range not hugepage-aligned: %#llx..%#llx:"
+			       " now %#llx-%#llx\n",
+			       start_pa, start_pa + size,
+			       range.start, range.start + range.size);
+		}
+		highbits = __pa_to_highbits(range.start);
+		if (highbits >= NR_PA_HIGHBIT_VALUES) {
+			printk("PA high bits too high: %#llx..%#llx\n",
+			       range.start, range.start + range.size);
+			continue;
+		}
+		if (highbits_seen[highbits]) {
+			printk("Range overlaps in high bits: %#llx..%#llx\n",
+			       range.start, range.start + range.size);
+			continue;
+		}
+		highbits_seen[highbits] = 1;
+		if (PFN_DOWN(range.size) > maxnodemem_pfn[i]) {
+			int size = maxnodemem_pfn[i];
+			if (size > 0) {
+				printk("Maxnodemem reduced node %d to"
+				       " %d pages\n", i, size);
+				range.size = (HV_PhysAddr)size << PAGE_SHIFT;
+			} else {
+				printk("Maxnodemem disabled node %d\n", i);
+				continue;
+			}
+		}
+		if (num_physpages + PFN_DOWN(range.size) > maxmem_pfn) {
+			int size = maxmem_pfn - num_physpages;
+			if (size > 0) {
+				printk("Maxmem reduced node %d to %d pages\n",
+				       i, size);
+				range.size = (HV_PhysAddr)size << PAGE_SHIFT;
+			} else {
+				printk("Maxmem disabled node %d\n", i);
+				continue;
+			}
+		}
+		if (i >= MAX_NUMNODES) {
+			printk("Too many PA nodes (#%d): %#llx...%#llx\n",
+			       i, range.size, range.size + range.start);
+			continue;
+		}
+
+		start = range.start >> PAGE_SHIFT;
+		size = range.size >> PAGE_SHIFT;
+		end = start + size;
+
+#ifndef __tilegx__
+		if (((HV_PhysAddr)end << PAGE_SHIFT) !=
+		    (range.start + range.size)) {
+			printk("PAs too high to represent: %#llx..%#llx\n",
+			       range.start, range.start + range.size);
+			continue;
+		}
+#endif
+#ifdef CONFIG_PCI
+		/*
+		 * Blocks that overlap the pci reserved region must
+		 * have enough space to hold the maximum percpu data
+		 * region at the top of the range.  If there isn't
+		 * enough space above the reserved region, just
+		 * truncate the node.
+		 */
+		if (start <= pci_reserve_start_pfn &&
+		    end > pci_reserve_start_pfn) {
+			unsigned int per_cpu_size =
+				__per_cpu_end - __per_cpu_start;
+			unsigned int percpu_pages =
+				NR_CPUS * (PFN_UP(per_cpu_size) >> PAGE_SHIFT);
+			if (end < pci_reserve_end_pfn + percpu_pages) {
+				end = pci_reserve_start_pfn;
+				printk("PCI mapping region reduced node %d to"
+				       " %ld pages\n", i, end - start);
+			}
+		}
+#endif
+
+		for (j = __pfn_to_highbits(start);
+		     j <= __pfn_to_highbits(end - 1); j++)
+			highbits_to_node[j] = i;
+
+		node_start_pfn[i] = start;
+		node_end_pfn[i] = end;
+		node_controller[i] = range.controller;
+		num_physpages += size;
+		max_pfn = end;
+
+		/* Mark node as online */
+		node_set(i, node_online_map);
+		node_set(i, node_possible_map);
+	}
+
+#ifndef __tilegx__
+	/*
+	 * For 4KB pages, mem_map "struct page" data is 1% of the size
+	 * of the physical memory, so can be quite big (640 MB for
+	 * four 16G zones).  These structures must be mapped in
+	 * lowmem, and since we currently cap out at about 768 MB,
+	 * it's impractical to try to use this much address space.
+	 * For now, arbitrarily cap the amount of physical memory
+	 * we're willing to use at 8 million pages (32GB of 4KB pages).
+	 */
+	cap = 8 * 1024 * 1024;  /* 8 million pages */
+	if (num_physpages > cap) {
+		int num_nodes = num_online_nodes();
+		int cap_each = cap / num_nodes;
+		unsigned long dropped_pages = 0;
+		for (i = 0; i < num_nodes; ++i) {
+			int size = node_end_pfn[i] - node_start_pfn[i];
+			if (size > cap_each) {
+				dropped_pages += (size - cap_each);
+				node_end_pfn[i] = node_start_pfn[i] + cap_each;
+			}
+		}
+		num_physpages -= dropped_pages;
+		printk(KERN_WARNING "Only using %ldMB memory;"
+		       " ignoring %ldMB.\n",
+		       num_physpages >> (20 - PAGE_SHIFT),
+		       dropped_pages >> (20 - PAGE_SHIFT));
+		printk(KERN_WARNING "Consider using a larger page size.\n");
+	}
+#endif
+
+	/* Heap starts just above the last loaded address. */
+	min_low_pfn = PFN_UP((unsigned long)_end - PAGE_OFFSET);
+
+#ifdef CONFIG_HIGHMEM
+	/* Find where we map lowmem from each controller. */
+	high_memory = setup_pa_va_mapping();
+
+	/* Set max_low_pfn based on what node 0 can directly address. */
+	max_low_pfn = node_lowmem_end_pfn[0];
+
+	lowmem_pages = (mappable_physpages > MAXMEM_PFN) ?
+		MAXMEM_PFN : mappable_physpages;
+	highmem_pages = (long) (num_physpages - lowmem_pages);
+
+	printk(KERN_NOTICE "%ldMB HIGHMEM available.\n",
+	       pages_to_mb(highmem_pages > 0 ? highmem_pages : 0));
+	printk(KERN_NOTICE "%ldMB LOWMEM available.\n",
+			pages_to_mb(lowmem_pages));
+#else
+	/* Set max_low_pfn based on what node 0 can directly address. */
+	max_low_pfn = node_end_pfn[0];
+
+#ifndef __tilegx__
+	if (node_end_pfn[0] > MAXMEM_PFN) {
+		printk(KERN_WARNING "Only using %ldMB LOWMEM.\n",
+		       MAXMEM>>20);
+		printk(KERN_WARNING "Use a HIGHMEM enabled kernel.\n");
+		max_low_pfn = MAXMEM_PFN;
+		max_pfn = MAXMEM_PFN;
+		num_physpages = MAXMEM_PFN;
+		node_end_pfn[0] = MAXMEM_PFN;
+	} else {
+		printk(KERN_NOTICE "%ldMB memory available.\n",
+		       pages_to_mb(node_end_pfn[0]));
+	}
+	for (i = 1; i < MAX_NUMNODES; ++i) {
+		node_start_pfn[i] = 0;
+		node_end_pfn[i] = 0;
+	}
+	high_memory = __va(node_end_pfn[0]);
+#else
+	lowmem_pages = 0;
+	for (i = 0; i < MAX_NUMNODES; ++i) {
+		int pages = node_end_pfn[i] - node_start_pfn[i];
+		lowmem_pages += pages;
+		if (pages)
+			high_memory = pfn_to_kaddr(node_end_pfn[i]);
+	}
+	printk(KERN_NOTICE "%ldMB memory available.\n",
+	       pages_to_mb(lowmem_pages));
+#endif
+#endif
+}
+
+static void __init setup_bootmem_allocator(void)
+{
+	unsigned long bootmap_size, first_alloc_pfn, last_alloc_pfn;
+
+	/* Provide a node 0 bdata. */
+	NODE_DATA(0)->bdata = &node0_bdata;
+
+#ifdef CONFIG_PCI
+	/* Don't let boot memory alias the PCI region. */
+	last_alloc_pfn = min(max_low_pfn, pci_reserve_start_pfn);
+#else
+	last_alloc_pfn = max_low_pfn;
+#endif
+
+	/*
+	 * Initialize the boot-time allocator (with low memory only):
+	 * The first argument says where to put the bitmap, and the
+	 * second says where the end of allocatable memory is.
+	 */
+	bootmap_size = init_bootmem(min_low_pfn, last_alloc_pfn);
+
+	/*
+	 * Let the bootmem allocator use all the space we've given it
+	 * except for its own bitmap.
+	 */
+	first_alloc_pfn = min_low_pfn + PFN_UP(bootmap_size);
+	if (first_alloc_pfn >= last_alloc_pfn)
+		early_panic("Not enough memory on controller 0 for bootmem\n");
+
+	free_bootmem(PFN_PHYS(first_alloc_pfn),
+		     PFN_PHYS(last_alloc_pfn - first_alloc_pfn));
+
+#ifdef CONFIG_KEXEC
+	if (crashk_res.start != crashk_res.end)
+		reserve_bootmem(crashk_res.start,
+			crashk_res.end - crashk_res.start + 1, 0);
+#endif
+
+}
+
+void *__init alloc_remap(int nid, unsigned long size)
+{
+	int pages = node_end_pfn[nid] - node_start_pfn[nid];
+	void *map = pfn_to_kaddr(node_memmap_pfn[nid]);
+	BUG_ON(size != pages * sizeof(struct page));
+	memset(map, 0, size);
+	return map;
+}
+
+static int __init percpu_size(void)
+{
+	int size = ALIGN(__per_cpu_end - __per_cpu_start, PAGE_SIZE);
+#ifdef CONFIG_MODULES
+	if (size < PERCPU_ENOUGH_ROOM)
+		size = PERCPU_ENOUGH_ROOM;
+#endif
+	/* In several places we assume the per-cpu data fits on a huge page. */
+	BUG_ON(kdata_huge && size > HPAGE_SIZE);
+	return size;
+}
+
+static inline unsigned long alloc_bootmem_pfn(int size, unsigned long goal)
+{
+	void *kva = __alloc_bootmem(size, PAGE_SIZE, goal);
+	unsigned long pfn = kaddr_to_pfn(kva);
+	BUG_ON(goal && PFN_PHYS(pfn) != goal);
+	return pfn;
+}
+
+static void __init zone_sizes_init(void)
+{
+	unsigned long zones_size[MAX_NR_ZONES] = { 0 };
+	unsigned long node_percpu[MAX_NUMNODES] = { 0 };
+	int size = percpu_size();
+	int num_cpus = smp_height * smp_width;
+	int i;
+
+	for (i = 0; i < num_cpus; ++i)
+		node_percpu[cpu_to_node(i)] += size;
+
+	for_each_online_node(i) {
+		unsigned long start = node_start_pfn[i];
+		unsigned long end = node_end_pfn[i];
+#ifdef CONFIG_HIGHMEM
+		unsigned long lowmem_end = node_lowmem_end_pfn[i];
+#else
+		unsigned long lowmem_end = end;
+#endif
+		int memmap_size = (end - start) * sizeof(struct page);
+		node_free_pfn[i] = start;
+
+		/*
+		 * Set aside pages for per-cpu data and the mem_map array.
+		 *
+		 * Since the per-cpu data requires special homecaching,
+		 * if we are in kdata_huge mode, we put it at the end of
+		 * the lowmem region.  If we're not in kdata_huge mode,
+		 * we take the per-cpu pages from the bottom of the
+		 * controller, since that avoids fragmenting a huge page
+		 * that users might want.  We always take the memmap
+		 * from the bottom of the controller, since with
+		 * kdata_huge that lets it be under a huge TLB entry.
+		 *
+		 * If the user has requested isolnodes for a controller,
+		 * though, there'll be no lowmem, so we just alloc_bootmem
+		 * the memmap.  There will be no percpu memory either.
+		 */
+		if (__pfn_to_highbits(start) == 0) {
+			/* In low PAs, allocate via bootmem. */
+			unsigned long goal = 0;
+			node_memmap_pfn[i] =
+				alloc_bootmem_pfn(memmap_size, goal);
+			if (kdata_huge)
+				goal = PFN_PHYS(lowmem_end) - node_percpu[i];
+			if (node_percpu[i])
+				node_percpu_pfn[i] =
+				    alloc_bootmem_pfn(node_percpu[i], goal);
+		} else if (cpu_isset(i, isolnodes)) {
+			node_memmap_pfn[i] = alloc_bootmem_pfn(memmap_size, 0);
+			BUG_ON(node_percpu[i] != 0);
+		} else {
+			/* In high PAs, just reserve some pages. */
+			node_memmap_pfn[i] = node_free_pfn[i];
+			node_free_pfn[i] += PFN_UP(memmap_size);
+			if (!kdata_huge) {
+				node_percpu_pfn[i] = node_free_pfn[i];
+				node_free_pfn[i] += PFN_UP(node_percpu[i]);
+			} else {
+				node_percpu_pfn[i] =
+					lowmem_end - PFN_UP(node_percpu[i]);
+			}
+		}
+
+#ifdef CONFIG_HIGHMEM
+		if (start > lowmem_end) {
+			zones_size[ZONE_DMA] = 0;
+			zones_size[ZONE_HIGHMEM] = end - start;
+		} else {
+			zones_size[ZONE_DMA] = lowmem_end - start;
+			zones_size[ZONE_HIGHMEM] = end - lowmem_end;
+		}
+#else
+		zones_size[ZONE_DMA] = end - start;
+#endif
+
+		/*
+		 * Everyone shares node 0's bootmem allocator, but
+		 * we use alloc_remap(), above, to put the actual
+		 * struct page array on the individual controllers,
+		 * which is most of the data that we actually care about.
+		 * We can't place bootmem allocators on the other
+		 * controllers since the bootmem allocator can only
+		 * operate on 32-bit physical addresses.
+		 */
+		NODE_DATA(i)->bdata = NODE_DATA(0)->bdata;
+
+		free_area_init_node(i, zones_size, start, NULL);
+		printk(KERN_DEBUG "  DMA zone: %ld per-cpu pages\n",
+		       PFN_UP(node_percpu[i]));
+
+		/* Track the type of memory on each node */
+		if (zones_size[ZONE_DMA])
+			node_set_state(i, N_NORMAL_MEMORY);
+#ifdef CONFIG_HIGHMEM
+		if (end != start)
+			node_set_state(i, N_HIGH_MEMORY);
+#endif
+
+		node_set_online(i);
+	}
+}
+
+#ifdef CONFIG_NUMA
+
+/* which logical CPUs are on which nodes */
+struct cpumask node_2_cpu_mask[MAX_NUMNODES] __write_once;
+EXPORT_SYMBOL(node_2_cpu_mask);
+
+/* which node each logical CPU is on */
+char cpu_2_node[NR_CPUS] __write_once __attribute__((aligned(L2_CACHE_BYTES)));
+EXPORT_SYMBOL(cpu_2_node);
+
+/* Return cpu_to_node() except for cpus not yet assigned, which return -1 */
+static int __init cpu_to_bound_node(int cpu, struct cpumask* unbound_cpus)
+{
+	if (!cpu_possible(cpu) || cpumask_test_cpu(cpu, unbound_cpus))
+		return -1;
+	else
+		return cpu_to_node(cpu);
+}
+
+/* Return number of immediately-adjacent tiles sharing the same NUMA node. */
+static int __init node_neighbors(int node, int cpu,
+				 struct cpumask *unbound_cpus)
+{
+	int neighbors = 0;
+	int w = smp_width;
+	int h = smp_height;
+	int x = cpu % w;
+	int y = cpu / w;
+	if (x > 0 && cpu_to_bound_node(cpu-1, unbound_cpus) == node)
+		++neighbors;
+	if (x < w-1 && cpu_to_bound_node(cpu+1, unbound_cpus) == node)
+		++neighbors;
+	if (y > 0 && cpu_to_bound_node(cpu-w, unbound_cpus) == node)
+		++neighbors;
+	if (y < h-1 && cpu_to_bound_node(cpu+w, unbound_cpus) == node)
+		++neighbors;
+	return neighbors;
+}
+
+static void __init setup_numa_mapping(void)
+{
+	int distance[MAX_NUMNODES][NR_CPUS];
+	HV_Coord coord;
+	int cpu, node, cpus, i, x, y;
+	int num_nodes = num_online_nodes();
+	struct cpumask unbound_cpus;
+	nodemask_t default_nodes;
+
+	cpumask_clear(&unbound_cpus);
+
+	/* Get set of nodes we will use for defaults */
+	nodes_andnot(default_nodes, node_online_map, isolnodes);
+	if (nodes_empty(default_nodes)) {
+		BUG_ON(!node_isset(0, node_online_map));
+		printk("Forcing NUMA node zero available as a default node\n");
+		node_set(0, default_nodes);
+	}
+
+	/* Populate the distance[] array */
+	memset(distance, -1, sizeof(distance));
+	cpu = 0;
+	for (coord.y = 0; coord.y < smp_height; ++coord.y) {
+		for (coord.x = 0; coord.x < smp_width;
+		     ++coord.x, ++cpu) {
+			BUG_ON(cpu >= nr_cpu_ids);
+			if (!cpu_possible(cpu)) {
+				cpu_2_node[cpu] = -1;
+				continue;
+			}
+			for_each_node_mask(node, default_nodes) {
+				HV_MemoryControllerInfo info =
+					hv_inquire_memory_controller(
+						coord, node_controller[node]);
+				distance[node][cpu] =
+					ABS(info.coord.x) + ABS(info.coord.y);
+			}
+			cpumask_set_cpu(cpu, &unbound_cpus);
+		}
+	}
+	cpus = cpu;
+
+	/*
+	 * Round-robin through the NUMA nodes until all the cpus are
+	 * assigned.  We could be more clever here (e.g. create four
+	 * sorted linked lists on the same set of cpu nodes, and pull
+	 * off them in round-robin sequence, removing from all four
+	 * lists each time) but given the relatively small numbers
+	 * involved, O(n^2) seem OK for a one-time cost.
+	 */
+	node = first_node(default_nodes);
+	while (!cpumask_empty(&unbound_cpus)) {
+		int best_cpu = -1;
+		int best_distance = INT_MAX;
+		for (cpu = 0; cpu < cpus; ++cpu) {
+			if (cpumask_test_cpu(cpu, &unbound_cpus)) {
+				/*
+				 * Compute metric, which is how much
+				 * closer the cpu is to this memory
+				 * controller than the others, shifted
+				 * up, and then the number of
+				 * neighbors already in the node as an
+				 * epsilon adjustment to try to keep
+				 * the nodes compact.
+				 */
+				int d = distance[node][cpu] * num_nodes;
+				for_each_node_mask(i, default_nodes) {
+					if (i != node)
+						d -= distance[i][cpu];
+				}
+				d *= 8;  /* allow space for epsilon */
+				d -= node_neighbors(node, cpu, &unbound_cpus);
+				if (d < best_distance) {
+					best_cpu = cpu;
+					best_distance = d;
+				}
+			}
+		}
+		BUG_ON(best_cpu < 0);
+		cpumask_set_cpu(best_cpu, &node_2_cpu_mask[node]);
+		cpu_2_node[best_cpu] = node;
+		cpumask_clear_cpu(best_cpu, &unbound_cpus);
+		node = next_node(node, default_nodes);
+		if (node == MAX_NUMNODES)
+			node = first_node(default_nodes);
+	}
+
+	/* Print out node assignments and set defaults for disabled cpus */
+	cpu = 0;
+	for (y = 0; y < smp_height; ++y) {
+		printk(KERN_DEBUG "NUMA cpu-to-node row %d:", y);
+		for (x = 0; x < smp_width; ++x, ++cpu) {
+			if (cpu_to_node(cpu) < 0) {
+				printk(" -");
+				cpu_2_node[cpu] = first_node(default_nodes);
+			} else {
+				printk(" %d", cpu_to_node(cpu));
+			}
+		}
+		printk("\n");
+	}
+}
+
+static struct cpu cpu_devices[NR_CPUS];
+
+static int __init topology_init(void)
+{
+	int i;
+
+	for_each_online_node(i)
+		register_one_node(i);
+
+	for_each_present_cpu(i)
+		register_cpu(&cpu_devices[i], i);
+
+	return 0;
+}
+
+subsys_initcall(topology_init);
+
+#else /* !CONFIG_NUMA */
+
+#define setup_numa_mapping() do { } while (0)
+
+#endif /* CONFIG_NUMA */
+
+/**
+ * setup_mpls() - Allow the user-space code to access various SPRs.
+ *
+ * Also called from online_secondary().
+ */
+void __cpuinit setup_mpls(void)
+{
+	/* Allow asynchronous TLB interrupts. */
+#if CHIP_HAS_TILE_DMA()
+	raw_local_irq_unmask(INT_DMATLB_MISS);
+	raw_local_irq_unmask(INT_DMATLB_ACCESS);
+#endif
+#if CHIP_HAS_SN_PROC()
+	raw_local_irq_unmask(INT_SNITLB_MISS);
+#endif
+
+	/*
+	 * Allow user access to many generic SPRs, like the cycle
+	 * counter, PASS/FAIL/DONE, INTERRUPT_CRITICAL_SECTION, etc.
+	 */
+	__insn_mtspr(SPR_MPL_WORLD_ACCESS_SET_0, 1);
+
+#if CHIP_HAS_SN()
+	/* Static network is not restricted. */
+	__insn_mtspr(SPR_MPL_SN_ACCESS_SET_0, 1);
+#endif
+#if CHIP_HAS_SN_PROC()
+	__insn_mtspr(SPR_MPL_SN_NOTIFY_SET_0, 1);
+	__insn_mtspr(SPR_MPL_SN_CPL_SET_0, 1);
+#endif
+
+	/*
+	 * Set the MPL for interrupt control 0 to user level.
+	 * This includes access to the SYSTEM_SAVE and EX_CONTEXT SPRs,
+	 * as well as the PL 0 interrupt mask.
+	 */
+	__insn_mtspr(SPR_MPL_INTCTRL_0_SET_0, 1);
+}
+
+static int __initdata set_initramfs_file;
+static char __initdata initramfs_file[128] = "initramfs.cpio.gz";
+
+static int __init setup_initramfs_file(char *str)
+{
+	if (str == NULL)
+		return -EINVAL;
+	strncpy(initramfs_file, str, sizeof(initramfs_file) - 1);
+	set_initramfs_file = 1;
+
+	return 0;
+}
+early_param("initramfs_file", setup_initramfs_file);
+
+/*
+ * We look for an additional "initramfs.cpio.gz" file in the hvfs.
+ * If there is one, we allocate some memory for it and it will be
+ * unpacked to the initramfs after any built-in initramfs_data.
+ */
+static void __init load_hv_initrd(void)
+{
+	HV_FS_StatInfo stat;
+	int fd, rc;
+	void *initrd;
+
+	fd = hv_fs_findfile((HV_VirtAddr) initramfs_file);
+	if (fd == HV_ENOENT) {
+		if (set_initramfs_file)
+			printk("No such hvfs initramfs file '%s'\n",
+			       initramfs_file);
+		return;
+	}
+	BUG_ON(fd < 0);
+	stat = hv_fs_fstat(fd);
+	BUG_ON(stat.size < 0);
+	if (stat.flags & HV_FS_ISDIR) {
+		printk("Ignoring hvfs file '%s': it's a directory.\n",
+		       initramfs_file);
+		return;
+	}
+	initrd = alloc_bootmem_pages(stat.size);
+	rc = hv_fs_pread(fd, (HV_VirtAddr) initrd, stat.size, 0);
+	if (rc != stat.size) {
+		printk("Error reading %d bytes from hvfs file '%s': %d\n",
+		       stat.size, initramfs_file, rc);
+		free_bootmem((unsigned long) initrd, stat.size);
+		return;
+	}
+	initrd_start = (unsigned long) initrd;
+	initrd_end = initrd_start + stat.size;
+}
+
+void __init free_initrd_mem(unsigned long begin, unsigned long end)
+{
+	free_bootmem(begin, end - begin);
+}
+
+static void __init validate_hv(void)
+{
+	/*
+	 * It may already be too late, but let's check our built-in
+	 * configuration against what the hypervisor is providing.
+	 */
+	unsigned long glue_size = hv_sysconf(HV_SYSCONF_GLUE_SIZE);
+	int hv_page_size = hv_sysconf(HV_SYSCONF_PAGE_SIZE_SMALL);
+	int hv_hpage_size = hv_sysconf(HV_SYSCONF_PAGE_SIZE_LARGE);
+	HV_ASIDRange asid_range;
+
+#ifndef CONFIG_SMP
+	HV_Topology topology = hv_inquire_topology();
+	BUG_ON(topology.coord.x != 0 || topology.coord.y != 0);
+	if (topology.width != 1 || topology.height != 1) {
+		printk("Warning: booting UP kernel on %dx%d grid;"
+		       " will ignore all but first tile.\n",
+		       topology.width, topology.height);
+	}
+#endif
+
+	if (PAGE_OFFSET + HV_GLUE_START_CPA + glue_size > (unsigned long)_text)
+		early_panic("Hypervisor glue size %ld is too big!\n",
+			    glue_size);
+	if (hv_page_size != PAGE_SIZE)
+		early_panic("Hypervisor page size %#x != our %#lx\n",
+			    hv_page_size, PAGE_SIZE);
+	if (hv_hpage_size != HPAGE_SIZE)
+		early_panic("Hypervisor huge page size %#x != our %#lx\n",
+			    hv_hpage_size, HPAGE_SIZE);
+
+#ifdef CONFIG_SMP
+	/*
+	 * Some hypervisor APIs take a pointer to a bitmap array
+	 * whose size is at least the number of cpus on the chip.
+	 * We use a struct cpumask for this, so it must be big enough.
+	 */
+	if ((smp_height * smp_width) > nr_cpu_ids)
+		early_panic("Hypervisor %d x %d grid too big for Linux"
+			    " NR_CPUS %d\n", smp_height, smp_width,
+			    nr_cpu_ids);
+#endif
+
+	/*
+	 * Check that we're using allowed ASIDs, and initialize the
+	 * various asid variables to their appropriate initial states.
+	 */
+	asid_range = hv_inquire_asid(0);
+	__get_cpu_var(current_asid) = min_asid = asid_range.start;
+	max_asid = asid_range.start + asid_range.size - 1;
+
+	if (hv_confstr(HV_CONFSTR_CHIP_MODEL, (HV_VirtAddr)chip_model,
+		       sizeof(chip_model)) < 0) {
+		printk("Warning: HV_CONFSTR_CHIP_MODEL not available\n");
+		strlcpy(chip_model, "unknown", sizeof(chip_model));
+	}
+}
+
+static void __init validate_va(void)
+{
+#ifndef __tilegx__   /* FIXME: GX: probably some validation relevant here */
+	/*
+	 * Similarly, make sure we're only using allowed VAs.
+	 * We assume we can contiguously use MEM_USER_INTRPT .. MEM_HV_INTRPT,
+	 * and 0 .. KERNEL_HIGH_VADDR.
+	 * In addition, make sure we CAN'T use the end of memory, since
+	 * we use the last chunk of each pgd for the pgd_list.
+	 */
+	int i, fc_fd_ok = 0;
+	unsigned long max_va = 0;
+	unsigned long list_va =
+		((PGD_LIST_OFFSET / sizeof(pgd_t)) << PGDIR_SHIFT);
+
+	for (i = 0; ; ++i) {
+		HV_VirtAddrRange range = hv_inquire_virtual(i);
+		if (range.size == 0)
+			break;
+		if (range.start <= MEM_USER_INTRPT &&
+		    range.start + range.size >= MEM_HV_INTRPT)
+			fc_fd_ok = 1;
+		if (range.start == 0)
+			max_va = range.size;
+		BUG_ON(range.start + range.size > list_va);
+	}
+	if (!fc_fd_ok)
+		early_panic("Hypervisor not configured for VAs 0xfc/0xfd\n");
+	if (max_va == 0)
+		early_panic("Hypervisor not configured for low VAs\n");
+	if (max_va < KERNEL_HIGH_VADDR)
+		early_panic("Hypervisor max VA %#lx smaller than %#lx\n",
+			    max_va, KERNEL_HIGH_VADDR);
+
+	/* Kernel PCs must have their high bit set; see intvec.S. */
+	if ((long)VMALLOC_START >= 0)
+		early_panic(
+			"Linux VMALLOC region below the 2GB line (%#lx)!\n"
+			"Reconfigure the kernel with fewer NR_HUGE_VMAPS\n"
+			"or smaller VMALLOC_RESERVE.\n",
+			VMALLOC_START);
+#endif
+}
+
+/*
+ * cpu_lotar_map lists all the cpus that are valid for the supervisor
+ * to cache data on at a page level, i.e. what cpus can be placed in
+ * the LOTAR field of a PTE.  It is equivalent to the set of possible
+ * cpus plus any other cpus that are willing to share their cache.
+ * It is set by hv_inquire_tiles(HV_INQ_TILES_LOTAR).
+ */
+struct cpumask __write_once cpu_lotar_map;
+EXPORT_SYMBOL(cpu_lotar_map);
+
+#if CHIP_HAS_CBOX_HOME_MAP()
+/*
+ * hash_for_home_map lists all the tiles that hash-for-home data
+ * will be cached on.  Note that this may includes tiles that are not
+ * valid for this supervisor to use otherwise (e.g. if a hypervisor
+ * device is being shared between multiple supervisors).
+ * It is set by hv_inquire_tiles(HV_INQ_TILES_HFH_CACHE).
+ */
+struct cpumask hash_for_home_map;
+EXPORT_SYMBOL(hash_for_home_map);
+#endif
+
+/*
+ * cpu_cacheable_map lists all the cpus whose caches the hypervisor can
+ * flush on our behalf.  It is set to cpu_possible_map OR'ed with
+ * hash_for_home_map, and it is what should be passed to
+ * hv_flush_remote() to flush all caches.  Note that if there are
+ * dedicated hypervisor driver tiles that have authorized use of their
+ * cache, those tiles will only appear in cpu_lotar_map, NOT in
+ * cpu_cacheable_map, as they are a special case.
+ */
+struct cpumask __write_once cpu_cacheable_map;
+EXPORT_SYMBOL(cpu_cacheable_map);
+
+static __initdata struct cpumask disabled_map;
+
+static int __init disabled_cpus(char *str)
+{
+	int boot_cpu = smp_processor_id();
+
+	if (str == NULL || cpulist_parse_crop(str, &disabled_map) != 0)
+		return -EINVAL;
+	if (cpumask_test_cpu(boot_cpu, &disabled_map)) {
+		printk("disabled_cpus: can't disable boot cpu %d\n", boot_cpu);
+		cpumask_clear_cpu(boot_cpu, &disabled_map);
+	}
+	return 0;
+}
+
+early_param("disabled_cpus", disabled_cpus);
+
+void __init print_disabled_cpus()
+{
+	if (!cpumask_empty(&disabled_map)) {
+		char buf[100];
+		cpulist_scnprintf(buf, sizeof(buf), &disabled_map);
+		printk(KERN_INFO "CPUs not available for Linux: %s\n", buf);
+	}
+}
+
+static void __init setup_cpu_maps(void)
+{
+	struct cpumask hv_disabled_map, cpu_possible_init;
+	int boot_cpu = smp_processor_id();
+	int cpus, i, rc;
+
+	/* Learn which cpus are allowed by the hypervisor. */
+	rc = hv_inquire_tiles(HV_INQ_TILES_AVAIL,
+			      (HV_VirtAddr) cpumask_bits(&cpu_possible_init),
+			      sizeof(cpu_cacheable_map));
+	if (rc < 0)
+		early_panic("hv_inquire_tiles(AVAIL) failed: rc %d\n", rc);
+	if (!cpumask_test_cpu(boot_cpu, &cpu_possible_init))
+		early_panic("Boot CPU %d disabled by hypervisor!\n", boot_cpu);
+
+	/* Compute the cpus disabled by the hvconfig file. */
+	cpumask_complement(&hv_disabled_map, &cpu_possible_init);
+
+	/* Include them with the cpus disabled by "disabled_cpus". */
+	cpumask_or(&disabled_map, &disabled_map, &hv_disabled_map);
+
+	/*
+	 * Disable every cpu after "setup_max_cpus".  But don't mark
+	 * as disabled the cpus that are outside of our initial rectangle,
+	 * since that turns out to be confusing.
+	 */
+	cpus = 1;                          /* this cpu */
+	cpumask_set_cpu(boot_cpu, &disabled_map);   /* ignore this cpu */
+	for (i = 0; cpus < setup_max_cpus; ++i)
+		if (!cpumask_test_cpu(i, &disabled_map))
+			++cpus;
+	for (; i < smp_height * smp_width; ++i)
+		cpumask_set_cpu(i, &disabled_map);
+	cpumask_clear_cpu(boot_cpu, &disabled_map); /* reset this cpu */
+	for (i = smp_height * smp_width; i < NR_CPUS; ++i)
+		cpumask_clear_cpu(i, &disabled_map);
+
+	/*
+	 * Setup cpu_possible map as every cpu allocated to us, minus
+	 * the results of any "disabled_cpus" settings.
+	 */
+	cpumask_andnot(&cpu_possible_init, &cpu_possible_init, &disabled_map);
+	init_cpu_possible(&cpu_possible_init);
+
+	/* Learn which cpus are valid for LOTAR caching. */
+	rc = hv_inquire_tiles(HV_INQ_TILES_LOTAR,
+			      (HV_VirtAddr) cpumask_bits(&cpu_lotar_map),
+			      sizeof(cpu_lotar_map));
+	if (rc < 0) {
+		printk("warning: no HV_INQ_TILES_LOTAR; using AVAIL\n");
+		cpu_lotar_map = cpu_possible_map;
+	}
+
+#if CHIP_HAS_CBOX_HOME_MAP()
+	/* Retrieve set of CPUs used for hash-for-home caching */
+	rc = hv_inquire_tiles(HV_INQ_TILES_HFH_CACHE,
+			      (HV_VirtAddr) hash_for_home_map.bits,
+			      sizeof(hash_for_home_map));
+	if (rc < 0)
+		early_panic("hv_inquire_tiles(HFH_CACHE) failed: rc %d\n", rc);
+	cpumask_or(&cpu_cacheable_map, &cpu_possible_map, &hash_for_home_map);
+#else
+	cpu_cacheable_map = cpu_possible_map;
+#endif
+}
+
+
+static int __init dataplane(char *str)
+{
+	printk("WARNING: dataplane support disabled in this kernel\n");
+	return 0;
+}
+
+early_param("dataplane", dataplane);
+
+#ifdef CONFIG_CMDLINE_BOOL
+static char __initdata builtin_cmdline[COMMAND_LINE_SIZE] = CONFIG_CMDLINE;
+#endif
+
+void __init setup_arch(char **cmdline_p)
+{
+	int len;
+
+#if defined(CONFIG_CMDLINE_BOOL) && defined(CONFIG_CMDLINE_OVERRIDE)
+	len = hv_get_command_line((HV_VirtAddr) boot_command_line,
+				  COMMAND_LINE_SIZE);
+	if (boot_command_line[0])
+		printk("WARNING: ignoring dynamic command line \"%s\"\n",
+		       boot_command_line);
+	strlcpy(boot_command_line, builtin_cmdline, COMMAND_LINE_SIZE);
+#else
+	char *hv_cmdline;
+#if defined(CONFIG_CMDLINE_BOOL)
+	if (builtin_cmdline[0]) {
+		int builtin_len = strlcpy(boot_command_line, builtin_cmdline,
+					  COMMAND_LINE_SIZE);
+		if (builtin_len < COMMAND_LINE_SIZE-1)
+			boot_command_line[builtin_len++] = ' ';
+		hv_cmdline = &boot_command_line[builtin_len];
+		len = COMMAND_LINE_SIZE - builtin_len;
+	} else
+#endif
+	{
+		hv_cmdline = boot_command_line;
+		len = COMMAND_LINE_SIZE;
+	}
+	len = hv_get_command_line((HV_VirtAddr) hv_cmdline, len);
+	if (len < 0 || len > COMMAND_LINE_SIZE)
+		early_panic("hv_get_command_line failed: %d\n", len);
+#endif
+
+	*cmdline_p = boot_command_line;
+
+	/* Set disabled_map and setup_max_cpus very early */
+	parse_early_param();
+
+	/* Make sure the kernel is compatible with the hypervisor. */
+	validate_hv();
+	validate_va();
+
+	setup_cpu_maps();
+
+
+#ifdef CONFIG_PCI
+	/*
+	 * Initialize the PCI structures.  This is done before memory
+	 * setup so that we know whether or not a pci_reserve region
+	 * is necessary.
+	 */
+	if (tile_pci_init() == 0)
+		pci_reserve_mb = 0;
+
+	/* PCI systems reserve a region just below 4GB for mapping iomem. */
+	pci_reserve_end_pfn  = (1 << (32 - PAGE_SHIFT));
+	pci_reserve_start_pfn = pci_reserve_end_pfn -
+		(pci_reserve_mb << (20 - PAGE_SHIFT));
+#endif
+
+	init_mm.start_code = (unsigned long) _text;
+	init_mm.end_code = (unsigned long) _etext;
+	init_mm.end_data = (unsigned long) _edata;
+	init_mm.brk = (unsigned long) _end;
+
+	setup_memory();
+	store_permanent_mappings();
+	setup_bootmem_allocator();
+
+	/*
+	 * NOTE: before this point _nobody_ is allowed to allocate
+	 * any memory using the bootmem allocator.
+	 */
+
+	paging_init();
+	setup_numa_mapping();
+	zone_sizes_init();
+	set_page_homes();
+	setup_mpls();
+	setup_clock();
+	load_hv_initrd();
+}
+
+
+/*
+ * Set up per-cpu memory.
+ */
+
+unsigned long __per_cpu_offset[NR_CPUS] __write_once;
+EXPORT_SYMBOL(__per_cpu_offset);
+
+static size_t __initdata pfn_offset[MAX_NUMNODES] = { 0 };
+static unsigned long __initdata percpu_pfn[NR_CPUS] = { 0 };
+
+/*
+ * As the percpu code allocates pages, we return the pages from the
+ * end of the node for the specified cpu.
+ */
+static void *__init pcpu_fc_alloc(unsigned int cpu, size_t size, size_t align)
+{
+	int nid = cpu_to_node(cpu);
+	unsigned long pfn = node_percpu_pfn[nid] + pfn_offset[nid];
+
+	BUG_ON(size % PAGE_SIZE != 0);
+	pfn_offset[nid] += size / PAGE_SIZE;
+	if (percpu_pfn[cpu] == 0)
+		percpu_pfn[cpu] = pfn;
+	return pfn_to_kaddr(pfn);
+}
+
+/*
+ * Pages reserved for percpu memory are not freeable, and in any case we are
+ * on a short path to panic() in setup_per_cpu_area() at this point anyway.
+ */
+static void __init pcpu_fc_free(void *ptr, size_t size)
+{
+}
+
+/*
+ * Set up vmalloc page tables using bootmem for the percpu code.
+ */
+static void __init pcpu_fc_populate_pte(unsigned long addr)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+
+	BUG_ON(pgd_addr_invalid(addr));
+
+	pgd = swapper_pg_dir + pgd_index(addr);
+	pud = pud_offset(pgd, addr);
+	BUG_ON(!pud_present(*pud));
+	pmd = pmd_offset(pud, addr);
+	if (pmd_present(*pmd)) {
+		BUG_ON(pmd_huge_page(*pmd));
+	} else {
+		pte = __alloc_bootmem(L2_KERNEL_PGTABLE_SIZE,
+				      HV_PAGE_TABLE_ALIGN, 0);
+		pmd_populate_kernel(&init_mm, pmd, pte);
+	}
+}
+
+void __init setup_per_cpu_areas(void)
+{
+	struct page *pg;
+	unsigned long delta, pfn, lowmem_va;
+	unsigned long size = percpu_size();
+	char *ptr;
+	int rc, cpu, i;
+
+	rc = pcpu_page_first_chunk(PERCPU_MODULE_RESERVE, pcpu_fc_alloc,
+				   pcpu_fc_free, pcpu_fc_populate_pte);
+	if (rc < 0)
+		panic("Cannot initialize percpu area (err=%d)", rc);
+
+	delta = (unsigned long)pcpu_base_addr - (unsigned long)__per_cpu_start;
+	for_each_possible_cpu(cpu) {
+		__per_cpu_offset[cpu] = delta + pcpu_unit_offsets[cpu];
+
+		/* finv the copy out of cache so we can change homecache */
+		ptr = pcpu_base_addr + pcpu_unit_offsets[cpu];
+		__finv_buffer(ptr, size);
+		pfn = percpu_pfn[cpu];
+
+		/* Rewrite the page tables to cache on that cpu */
+		pg = pfn_to_page(pfn);
+		for (i = 0; i < size; i += PAGE_SIZE, ++pfn, ++pg) {
+
+			/* Update the vmalloc mapping and page home. */
+			pte_t *ptep =
+				virt_to_pte(NULL, (unsigned long)ptr + i);
+			pte_t pte = *ptep;
+			BUG_ON(pfn != pte_pfn(pte));
+			pte = hv_pte_set_mode(pte, HV_PTE_MODE_CACHE_TILE_L3);
+			pte = set_remote_cache_cpu(pte, cpu);
+			set_pte(ptep, pte);
+
+			/* Update the lowmem mapping for consistency. */
+			lowmem_va = (unsigned long)pfn_to_kaddr(pfn);
+			ptep = virt_to_pte(NULL, lowmem_va);
+			if (pte_huge(*ptep)) {
+				printk(KERN_DEBUG "early shatter of huge page"
+				       " at %#lx\n", lowmem_va);
+				shatter_pmd((pmd_t *)ptep);
+				ptep = virt_to_pte(NULL, lowmem_va);
+				BUG_ON(pte_huge(*ptep));
+			}
+			BUG_ON(pfn != pte_pfn(*ptep));
+			set_pte(ptep, pte);
+		}
+	}
+
+	/* Set our thread pointer appropriately. */
+	set_my_cpu_offset(__per_cpu_offset[smp_processor_id()]);
+
+	/* Make sure the finv's have completed. */
+	mb_incoherent();
+
+	/* Flush the TLB so we reference it properly from here on out. */
+	local_flush_tlb_all();
+}
+
+static struct resource data_resource = {
+	.name	= "Kernel data",
+	.start	= 0,
+	.end	= 0,
+	.flags	= IORESOURCE_BUSY | IORESOURCE_MEM
+};
+
+static struct resource code_resource = {
+	.name	= "Kernel code",
+	.start	= 0,
+	.end	= 0,
+	.flags	= IORESOURCE_BUSY | IORESOURCE_MEM
+};
+
+/*
+ * We reserve all resources above 4GB so that PCI won't try to put
+ * mappings above 4GB; the standard allows that for some devices but
+ * the probing code trunates values to 32 bits.
+ */
+#ifdef CONFIG_PCI
+static struct resource* __init
+insert_non_bus_resource(void)
+{
+	struct resource *res =
+		kzalloc(sizeof(struct resource), GFP_ATOMIC);
+	res->name = "Non-Bus Physical Address Space";
+	res->start = (1ULL << 32);
+	res->end = -1LL;
+	res->flags = IORESOURCE_BUSY | IORESOURCE_MEM;
+	if (insert_resource(&iomem_resource, res)) {
+		kfree(res);
+		return NULL;
+	}
+	return res;
+}
+#endif
+
+static struct resource* __init
+insert_ram_resource(u64 start_pfn, u64 end_pfn)
+{
+	struct resource *res =
+		kzalloc(sizeof(struct resource), GFP_ATOMIC);
+	res->name = "System RAM";
+	res->start = start_pfn << PAGE_SHIFT;
+	res->end = (end_pfn << PAGE_SHIFT) - 1;
+	res->flags = IORESOURCE_BUSY | IORESOURCE_MEM;
+	if (insert_resource(&iomem_resource, res)) {
+		kfree(res);
+		return NULL;
+	}
+	return res;
+}
+
+/*
+ * Request address space for all standard resources
+ *
+ * If the system includes PCI root complex drivers, we need to create
+ * a window just below 4GB where PCI BARs can be mapped.
+ */
+static int __init request_standard_resources(void)
+{
+	int i;
+	enum { CODE_DELTA = MEM_SV_INTRPT - PAGE_OFFSET };
+
+	iomem_resource.end = -1LL;
+#ifdef CONFIG_PCI
+	insert_non_bus_resource();
+#endif
+
+	for_each_online_node(i) {
+		u64 start_pfn = node_start_pfn[i];
+		u64 end_pfn = node_end_pfn[i];
+
+#ifdef CONFIG_PCI
+		if (start_pfn <= pci_reserve_start_pfn &&
+		    end_pfn > pci_reserve_start_pfn) {
+			if (end_pfn > pci_reserve_end_pfn)
+				insert_ram_resource(pci_reserve_end_pfn,
+						     end_pfn);
+			end_pfn = pci_reserve_start_pfn;
+		}
+#endif
+		insert_ram_resource(start_pfn, end_pfn);
+	}
+
+	code_resource.start = __pa(_text - CODE_DELTA);
+	code_resource.end = __pa(_etext - CODE_DELTA)-1;
+	data_resource.start = __pa(_sdata);
+	data_resource.end = __pa(_end)-1;
+
+	insert_resource(&iomem_resource, &code_resource);
+	insert_resource(&iomem_resource, &data_resource);
+
+#ifdef CONFIG_KEXEC
+	insert_resource(&iomem_resource, &crashk_res);
+#endif
+
+	return 0;
+}
+
+subsys_initcall(request_standard_resources);
diff --git a/arch/tile/kernel/signal.c b/arch/tile/kernel/signal.c
new file mode 100644
index 0000000..7ea85eb
--- /dev/null
+++ b/arch/tile/kernel/signal.c
@@ -0,0 +1,359 @@
+/*
+ * Copyright (C) 1991, 1992  Linus Torvalds
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
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/smp.h>
+#include <linux/smp_lock.h>
+#include <linux/kernel.h>
+#include <linux/signal.h>
+#include <linux/errno.h>
+#include <linux/wait.h>
+#include <linux/unistd.h>
+#include <linux/stddef.h>
+#include <linux/personality.h>
+#include <linux/suspend.h>
+#include <linux/ptrace.h>
+#include <linux/elf.h>
+#include <linux/compat.h>
+#include <linux/syscalls.h>
+#include <linux/uaccess.h>
+#include <asm/processor.h>
+#include <asm/ucontext.h>
+#include <asm/sigframe.h>
+#include <arch/interrupts.h>
+
+#define DEBUG_SIG 0
+
+#define _BLOCKABLE (~(sigmask(SIGKILL) | sigmask(SIGSTOP)))
+
+
+/* Caller before callee in this file; other callee is in assembler */
+void do_signal(struct pt_regs *regs);
+
+int _sys_sigaltstack(const stack_t __user *uss,
+		     stack_t __user *uoss, struct pt_regs *regs)
+{
+	return do_sigaltstack(uss, uoss, regs->sp);
+}
+
+
+/*
+ * Do a signal return; undo the signal stack.
+ */
+
+int restore_sigcontext(struct pt_regs *regs,
+		       struct sigcontext __user *sc, long *pr0)
+{
+	int err = 0;
+	int i;
+
+	/* Always make any pending restarted system calls return -EINTR */
+	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+
+	for (i = 0; i < sizeof(struct pt_regs)/sizeof(long); ++i)
+		err |= __get_user(((long *)regs)[i],
+				  &((long *)(&sc->regs))[i]);
+
+	regs->faultnum = INT_SWINT_1_SIGRETURN;
+
+	err |= __get_user(*pr0, &sc->regs.regs[0]);
+	return err;
+}
+
+int _sys_rt_sigreturn(struct pt_regs *regs)
+{
+	struct rt_sigframe __user *frame =
+		(struct rt_sigframe __user *)(regs->sp);
+	sigset_t set;
+	long r0;
+
+	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
+		goto badframe;
+	if (__copy_from_user(&set, &frame->uc.uc_sigmask, sizeof(set)))
+		goto badframe;
+
+	sigdelsetmask(&set, ~_BLOCKABLE);
+	spin_lock_irq(&current->sighand->siglock);
+	current->blocked = set;
+	recalc_sigpending();
+	spin_unlock_irq(&current->sighand->siglock);
+
+	if (restore_sigcontext(regs, &frame->uc.uc_mcontext, &r0))
+		goto badframe;
+
+	if (do_sigaltstack(&frame->uc.uc_stack, NULL, regs->sp) == -EFAULT)
+		goto badframe;
+
+	return r0;
+
+badframe:
+	force_sig(SIGSEGV, current);
+	return 0;
+}
+
+/*
+ * Set up a signal frame.
+ */
+
+int setup_sigcontext(struct sigcontext __user *sc, struct pt_regs *regs)
+{
+	int i, err = 0;
+
+	for (i = 0; i < sizeof(struct pt_regs)/sizeof(long); ++i)
+		err |= __put_user(((long *)regs)[i],
+				  &((long *)(&sc->regs))[i]);
+
+	return err;
+}
+
+/*
+ * Determine which stack to use..
+ */
+static inline void __user *get_sigframe(struct k_sigaction *ka,
+					struct pt_regs *regs,
+					size_t frame_size)
+{
+	unsigned long sp;
+
+	/* Default to using normal stack */
+	sp = regs->sp;
+
+	/*
+	 * If we are on the alternate signal stack and would overflow
+	 * it, don't.  Return an always-bogus address instead so we
+	 * will die with SIGSEGV.
+	 */
+	if (on_sig_stack(sp) && !likely(on_sig_stack(sp - frame_size)))
+		return (void __user *) -1L;
+
+	/* This is the X/Open sanctioned signal stack switching.  */
+	if (ka->sa.sa_flags & SA_ONSTACK) {
+		if (sas_ss_flags(sp) == 0)
+			sp = current->sas_ss_sp + current->sas_ss_size;
+	}
+
+	sp -= frame_size;
+	/*
+	 * Align the stack pointer according to the TILE ABI,
+	 * i.e. so that on function entry (sp & 15) == 0.
+	 */
+	sp &= -16UL;
+	return (void __user *) sp;
+}
+
+static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
+			   sigset_t *set, struct pt_regs *regs)
+{
+	unsigned long restorer;
+	struct rt_sigframe __user *frame;
+	int err = 0;
+	int usig;
+
+	frame = get_sigframe(ka, regs, sizeof(*frame));
+
+	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
+		goto give_sigsegv;
+
+	usig = current_thread_info()->exec_domain
+		&& current_thread_info()->exec_domain->signal_invmap
+		&& sig < 32
+		? current_thread_info()->exec_domain->signal_invmap[sig]
+		: sig;
+
+	/* Always write at least the signal number for the stack backtracer. */
+	if (ka->sa.sa_flags & SA_SIGINFO) {
+		/* At sigreturn time, restore the callee-save registers too. */
+		err |= copy_siginfo_to_user(&frame->info, info);
+		regs->flags |= PT_FLAGS_RESTORE_REGS;
+	} else {
+		err |= __put_user(info->si_signo, &frame->info.si_signo);
+	}
+
+	/* Create the ucontext.  */
+	err |= __clear_user(&frame->save_area, sizeof(frame->save_area));
+	err |= __put_user(0, &frame->uc.uc_flags);
+	err |= __put_user(0, &frame->uc.uc_link);
+	err |= __put_user((void *)(current->sas_ss_sp),
+			  &frame->uc.uc_stack.ss_sp);
+	err |= __put_user(sas_ss_flags(regs->sp),
+			  &frame->uc.uc_stack.ss_flags);
+	err |= __put_user(current->sas_ss_size, &frame->uc.uc_stack.ss_size);
+	err |= setup_sigcontext(&frame->uc.uc_mcontext, regs);
+	err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
+	if (err)
+		goto give_sigsegv;
+
+	restorer = VDSO_BASE;
+	if (ka->sa.sa_flags & SA_RESTORER)
+		restorer = (unsigned long) ka->sa.sa_restorer;
+
+	/*
+	 * Set up registers for signal handler.
+	 * Registers that we don't modify keep the value they had from
+	 * user-space at the time we took the signal.
+	 */
+	regs->pc = (unsigned long) ka->sa.sa_handler;
+	regs->ex1 = PL_ICS_EX1(USER_PL, 1); /* set crit sec in handler */
+	regs->sp = (unsigned long) frame;
+	regs->lr = restorer;
+	regs->regs[0] = (unsigned long) usig;
+
+	if (ka->sa.sa_flags & SA_SIGINFO) {
+		/* Need extra arguments, so mark to restore caller-saves. */
+		regs->regs[1] = (unsigned long) &frame->info;
+		regs->regs[2] = (unsigned long) &frame->uc;
+		regs->flags |= PT_FLAGS_CALLER_SAVES;
+	}
+
+	/*
+	 * Notify any tracer that was single-stepping it.
+	 * The tracer may want to single-step inside the
+	 * handler too.
+	 */
+	if (test_thread_flag(TIF_SINGLESTEP))
+		ptrace_notify(SIGTRAP);
+
+	return 0;
+
+give_sigsegv:
+	force_sigsegv(sig, current);
+	return -EFAULT;
+}
+
+/*
+ * OK, we're invoking a handler
+ */
+
+static int handle_signal(unsigned long sig, siginfo_t *info,
+			 struct k_sigaction *ka, sigset_t *oldset,
+			 struct pt_regs *regs)
+{
+	int ret;
+
+
+	/* Are we from a system call? */
+	if (regs->faultnum == INT_SWINT_1) {
+		/* If so, check system call restarting.. */
+		switch (regs->regs[0]) {
+		case -ERESTART_RESTARTBLOCK:
+		case -ERESTARTNOHAND:
+			regs->regs[0] = -EINTR;
+			break;
+
+		case -ERESTARTSYS:
+			if (!(ka->sa.sa_flags & SA_RESTART)) {
+				regs->regs[0] = -EINTR;
+				break;
+			}
+			/* fallthrough */
+		case -ERESTARTNOINTR:
+			/* Reload caller-saves to restore r0..r5 and r10. */
+			regs->flags |= PT_FLAGS_CALLER_SAVES;
+			regs->regs[0] = regs->orig_r0;
+			regs->pc -= 8;
+		}
+	}
+
+	/* Set up the stack frame */
+#ifdef CONFIG_COMPAT
+	if (is_compat_task())
+		ret = compat_setup_rt_frame(sig, ka, info, oldset, regs);
+	else
+#endif
+		ret = setup_rt_frame(sig, ka, info, oldset, regs);
+	if (ret == 0) {
+		/* This code is only called from system calls or from
+		 * the work_pending path in the return-to-user code, and
+		 * either way we can re-enable interrupts unconditionally.
+		 */
+		spin_lock_irq(&current->sighand->siglock);
+		sigorsets(&current->blocked,
+			  &current->blocked, &ka->sa.sa_mask);
+		if (!(ka->sa.sa_flags & SA_NODEFER))
+			sigaddset(&current->blocked, sig);
+		recalc_sigpending();
+		spin_unlock_irq(&current->sighand->siglock);
+	}
+
+	return ret;
+}
+
+/*
+ * Note that 'init' is a special process: it doesn't get signals it doesn't
+ * want to handle. Thus you cannot kill init even with a SIGKILL even by
+ * mistake.
+ */
+void do_signal(struct pt_regs *regs)
+{
+	siginfo_t info;
+	int signr;
+	struct k_sigaction ka;
+	sigset_t *oldset;
+
+	/*
+	 * i386 will check if we're coming from kernel mode and bail out
+	 * here.  In my experience this just turns weird crashes into
+	 * weird spin-hangs.  But if we find a case where this seems
+	 * helpful, we can reinstate the check on "!user_mode(regs)".
+	 */
+
+	if (current_thread_info()->status & TS_RESTORE_SIGMASK)
+		oldset = &current->saved_sigmask;
+	else
+		oldset = &current->blocked;
+
+	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
+	if (signr > 0) {
+		/* Whee! Actually deliver the signal.  */
+		if (handle_signal(signr, &info, &ka, oldset, regs) == 0) {
+			/*
+			 * A signal was successfully delivered; the saved
+			 * sigmask will have been stored in the signal frame,
+			 * and will be restored by sigreturn, so we can simply
+			 * clear the TS_RESTORE_SIGMASK flag.
+			 */
+			current_thread_info()->status &= ~TS_RESTORE_SIGMASK;
+		}
+
+		return;
+	}
+
+	/* Did we come from a system call? */
+	if (regs->faultnum == INT_SWINT_1) {
+		/* Restart the system call - no handlers present */
+		switch (regs->regs[0]) {
+		case -ERESTARTNOHAND:
+		case -ERESTARTSYS:
+		case -ERESTARTNOINTR:
+			regs->flags |= PT_FLAGS_CALLER_SAVES;
+			regs->regs[0] = regs->orig_r0;
+			regs->pc -= 8;
+			break;
+
+		case -ERESTART_RESTARTBLOCK:
+			regs->flags |= PT_FLAGS_CALLER_SAVES;
+			regs->regs[TREG_SYSCALL_NR] = __NR_restart_syscall;
+			regs->pc -= 8;
+			break;
+		}
+	}
+
+	/* If there's no signal to deliver, just put the saved sigmask back. */
+	if (current_thread_info()->status & TS_RESTORE_SIGMASK) {
+		current_thread_info()->status &= ~TS_RESTORE_SIGMASK;
+		sigprocmask(SIG_SETMASK, &current->saved_sigmask, NULL);
+	}
+}
diff --git a/arch/tile/kernel/single_step.c b/arch/tile/kernel/single_step.c
new file mode 100644
index 0000000..266aae1
--- /dev/null
+++ b/arch/tile/kernel/single_step.c
@@ -0,0 +1,656 @@
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
+ *
+ * A code-rewriter that enables instruction single-stepping.
+ * Derived from iLib's single-stepping code.
+ */
+
+#ifndef __tilegx__   /* No support for single-step yet. */
+
+/* These functions are only used on the TILE platform */
+#include <linux/slab.h>
+#include <linux/thread_info.h>
+#include <linux/uaccess.h>
+#include <linux/mman.h>
+#include <linux/types.h>
+#include <asm/cacheflush.h>
+#include <asm/opcode-tile.h>
+#include <asm/opcode_constants.h>
+#include <arch/abi.h>
+
+#define signExtend17(val) sign_extend((val), 17)
+#define TILE_X1_MASK (0xffffffffULL << 31)
+
+int unaligned_printk;
+
+static int __init setup_unaligned_printk(char *str)
+{
+	long val;
+	if (strict_strtol(str, 0, &val) != 0)
+		return 0;
+	unaligned_printk = val;
+	printk("Printk for each unaligned data accesses is %s\n",
+	       unaligned_printk ? "enabled" : "disabled");
+	return 1;
+}
+__setup("unaligned_printk=", setup_unaligned_printk);
+
+unsigned int unaligned_fixup_count;
+
+enum mem_op {
+	MEMOP_NONE,
+	MEMOP_LOAD,
+	MEMOP_STORE,
+	MEMOP_LOAD_POSTINCR,
+	MEMOP_STORE_POSTINCR
+};
+
+static inline tile_bundle_bits set_BrOff_X1(tile_bundle_bits n, int32_t offset)
+{
+	tile_bundle_bits result;
+
+	/* mask out the old offset */
+	tile_bundle_bits mask = create_BrOff_X1(-1);
+	result = n & (~mask);
+
+	/* or in the new offset */
+	result |= create_BrOff_X1(offset);
+
+	return result;
+}
+
+static inline tile_bundle_bits move_X1(tile_bundle_bits n, int dest, int src)
+{
+	tile_bundle_bits result;
+	tile_bundle_bits op;
+
+	result = n & (~TILE_X1_MASK);
+
+	op = create_Opcode_X1(SPECIAL_0_OPCODE_X1) |
+		create_RRROpcodeExtension_X1(OR_SPECIAL_0_OPCODE_X1) |
+		create_Dest_X1(dest) |
+		create_SrcB_X1(TREG_ZERO) |
+		create_SrcA_X1(src) ;
+
+	result |= op;
+	return result;
+}
+
+static inline tile_bundle_bits nop_X1(tile_bundle_bits n)
+{
+	return move_X1(n, TREG_ZERO, TREG_ZERO);
+}
+
+static inline tile_bundle_bits addi_X1(
+	tile_bundle_bits n, int dest, int src, int imm)
+{
+	n &= ~TILE_X1_MASK;
+
+	n |=  (create_SrcA_X1(src) |
+	       create_Dest_X1(dest) |
+	       create_Imm8_X1(imm) |
+	       create_S_X1(0) |
+	       create_Opcode_X1(IMM_0_OPCODE_X1) |
+	       create_ImmOpcodeExtension_X1(ADDI_IMM_0_OPCODE_X1));
+
+	return n;
+}
+
+static tile_bundle_bits rewrite_load_store_unaligned(
+	struct single_step_state *state,
+	tile_bundle_bits bundle,
+	struct pt_regs *regs,
+	enum mem_op mem_op,
+	int size, int sign_ext)
+{
+	unsigned char *addr;
+	int val_reg, addr_reg, err, val;
+
+	/* Get address and value registers */
+	if (bundle & TILE_BUNDLE_Y_ENCODING_MASK) {
+		addr_reg = get_SrcA_Y2(bundle);
+		val_reg = get_SrcBDest_Y2(bundle);
+	} else if (mem_op == MEMOP_LOAD || mem_op == MEMOP_LOAD_POSTINCR) {
+		addr_reg = get_SrcA_X1(bundle);
+		val_reg  = get_Dest_X1(bundle);
+	} else {
+		addr_reg = get_SrcA_X1(bundle);
+		val_reg  = get_SrcB_X1(bundle);
+	}
+
+	/*
+	 * If registers are not GPRs, don't try to handle it.
+	 *
+	 * FIXME: we could handle non-GPR loads by getting the real value
+	 * from memory, writing it to the single step buffer, using a
+	 * temp_reg to hold a pointer to that memory, then executing that
+	 * instruction and resetting temp_reg.  For non-GPR stores, it's a
+	 * little trickier; we could use the single step buffer for that
+	 * too, but we'd have to add some more state bits so that we could
+	 * call back in here to copy that value to the real target.  For
+	 * now, we just handle the simple case.
+	 */
+	if ((val_reg >= PTREGS_NR_GPRS &&
+	     (val_reg != TREG_ZERO ||
+	      mem_op == MEMOP_LOAD ||
+	      mem_op == MEMOP_LOAD_POSTINCR)) ||
+	    addr_reg >= PTREGS_NR_GPRS)
+		return bundle;
+
+	/* If it's aligned, don't handle it specially */
+	addr = (void *)regs->regs[addr_reg];
+	if (((unsigned long)addr % size) == 0)
+		return bundle;
+
+#ifndef __LITTLE_ENDIAN
+# error We assume little-endian representation with copy_xx_user size 2 here
+#endif
+	/* Handle unaligned load/store */
+	if (mem_op == MEMOP_LOAD || mem_op == MEMOP_LOAD_POSTINCR) {
+		unsigned short val_16;
+		switch (size) {
+		case 2:
+			err = copy_from_user(&val_16, addr, sizeof(val_16));
+			val = sign_ext ? ((short)val_16) : val_16;
+			break;
+		case 4:
+			err = copy_from_user(&val, addr, sizeof(val));
+			break;
+		default:
+			BUG();
+		}
+		if (err == 0) {
+			state->update_reg = val_reg;
+			state->update_value = val;
+			state->update = 1;
+		}
+	} else {
+		val = (val_reg == TREG_ZERO) ? 0 : regs->regs[val_reg];
+		err = copy_to_user(addr, &val, size);
+	}
+
+	if (err) {
+		siginfo_t info = {
+			.si_signo = SIGSEGV,
+			.si_code = SEGV_MAPERR,
+			.si_addr = (void __user *)addr
+		};
+		force_sig_info(info.si_signo, &info, current);
+		return (tile_bundle_bits) 0;
+	}
+
+	if (unaligned_fixup == 0) {
+		siginfo_t info = {
+			.si_signo = SIGBUS,
+			.si_code = BUS_ADRALN,
+			.si_addr = (void __user *)addr
+		};
+		force_sig_info(info.si_signo, &info, current);
+		return (tile_bundle_bits) 0;
+	}
+
+	if (unaligned_printk || unaligned_fixup_count == 0) {
+		printk("Process %d/%s: PC %#lx: Fixup of"
+		       " unaligned %s at %#lx.\n",
+		       current->pid, current->comm, regs->pc,
+		       (mem_op == MEMOP_LOAD || mem_op == MEMOP_LOAD_POSTINCR) ?
+			 "load" : "store",
+		       (unsigned long)addr);
+		if (!unaligned_printk) {
+			printk("\n"
+"Unaligned fixups in the kernel will slow your application considerably.\n"
+"You can find them by writing \"1\" to /proc/sys/tile/unaligned_fixup/printk,\n"
+"which requests the kernel show all unaligned fixups, or writing a \"0\"\n"
+"to /proc/sys/tile/unaligned_fixup/enabled, in which case each unaligned\n"
+"access will become a SIGBUS you can debug. No further warnings will be\n"
+"shown so as to avoid additional slowdown, but you can track the number\n"
+"of fixups performed via /proc/sys/tile/unaligned_fixup/count.\n"
+"Use the tile-addr2line command (see \"info addr2line\") to decode PCs.\n"
+				"\n");
+		}
+	}
+	++unaligned_fixup_count;
+
+	if (bundle & TILE_BUNDLE_Y_ENCODING_MASK) {
+		/* Convert the Y2 instruction to a prefetch. */
+		bundle &= ~(create_SrcBDest_Y2(-1) |
+			    create_Opcode_Y2(-1));
+		bundle |= (create_SrcBDest_Y2(TREG_ZERO) |
+			   create_Opcode_Y2(LW_OPCODE_Y2));
+	/* Replace the load postincr with an addi */
+	} else if (mem_op == MEMOP_LOAD_POSTINCR) {
+		bundle = addi_X1(bundle, addr_reg, addr_reg,
+				 get_Imm8_X1(bundle));
+	/* Replace the store postincr with an addi */
+	} else if (mem_op == MEMOP_STORE_POSTINCR) {
+		bundle = addi_X1(bundle, addr_reg, addr_reg,
+				 get_Dest_Imm8_X1(bundle));
+	} else {
+		/* Convert the X1 instruction to a nop. */
+		bundle &= ~(create_Opcode_X1(-1) |
+			    create_UnShOpcodeExtension_X1(-1) |
+			    create_UnOpcodeExtension_X1(-1));
+		bundle |= (create_Opcode_X1(SHUN_0_OPCODE_X1) |
+			   create_UnShOpcodeExtension_X1(
+				   UN_0_SHUN_0_OPCODE_X1) |
+			   create_UnOpcodeExtension_X1(
+				   NOP_UN_0_SHUN_0_OPCODE_X1));
+	}
+
+	return bundle;
+}
+
+/**
+ * single_step_once() - entry point when single stepping has been triggered.
+ * @regs: The machine register state
+ *
+ *  When we arrive at this routine via a trampoline, the single step
+ *  engine copies the executing bundle to the single step buffer.
+ *  If the instruction is a condition branch, then the target is
+ *  reset to one past the next instruction. If the instruction
+ *  sets the lr, then that is noted. If the instruction is a jump
+ *  or call, then the new target pc is preserved and the current
+ *  bundle instruction set to null.
+ *
+ *  The necessary post-single-step rewriting information is stored in
+ *  single_step_state->  We use data segment values because the
+ *  stack will be rewound when we run the rewritten single-stepped
+ *  instruction.
+ */
+void single_step_once(struct pt_regs *regs)
+{
+	extern tile_bundle_bits __single_step_ill_insn;
+	extern tile_bundle_bits __single_step_j_insn;
+	extern tile_bundle_bits __single_step_addli_insn;
+	extern tile_bundle_bits __single_step_auli_insn;
+	struct thread_info *info = (void *)current_thread_info();
+	struct single_step_state *state = info->step_state;
+	int is_single_step = test_ti_thread_flag(info, TIF_SINGLESTEP);
+	tile_bundle_bits *buffer, *pc;
+	tile_bundle_bits bundle;
+	int temp_reg;
+	int target_reg = TREG_LR;
+	int err;
+	enum mem_op mem_op = MEMOP_NONE;
+	int size = 0, sign_ext = 0;  /* happy compiler */
+
+	asm(
+"    .pushsection .rodata.single_step\n"
+"    .align 8\n"
+"    .globl    __single_step_ill_insn\n"
+"__single_step_ill_insn:\n"
+"    ill\n"
+"    .globl    __single_step_addli_insn\n"
+"__single_step_addli_insn:\n"
+"    { nop; addli r0, zero, 0 }\n"
+"    .globl    __single_step_auli_insn\n"
+"__single_step_auli_insn:\n"
+"    { nop; auli r0, r0, 0 }\n"
+"    .globl    __single_step_j_insn\n"
+"__single_step_j_insn:\n"
+"    j .\n"
+"    .popsection\n"
+	);
+
+	if (state == NULL) {
+		/* allocate a page of writable, executable memory */
+		state = kmalloc(sizeof(struct single_step_state), GFP_KERNEL);
+		if (state == NULL) {
+			printk("Out of kernel memory trying to single-step\n");
+			return;
+		}
+
+		/* allocate a cache line of writable, executable memory */
+		down_write(&current->mm->mmap_sem);
+		buffer = (void *) do_mmap(0, 0, 64,
+					  PROT_EXEC | PROT_READ | PROT_WRITE,
+					  MAP_PRIVATE | MAP_ANONYMOUS,
+					  0);
+		up_write(&current->mm->mmap_sem);
+
+		if ((int)buffer < 0 && (int)buffer > -PAGE_SIZE) {
+			kfree(state);
+			printk("Out of kernel pages trying to single-step\n");
+			return;
+		}
+
+		state->buffer = buffer;
+		state->is_enabled = 0;
+
+		info->step_state = state;
+
+		/* Validate our stored instruction patterns */
+		BUG_ON(get_Opcode_X1(__single_step_addli_insn) !=
+		       ADDLI_OPCODE_X1);
+		BUG_ON(get_Opcode_X1(__single_step_auli_insn) !=
+		       AULI_OPCODE_X1);
+		BUG_ON(get_SrcA_X1(__single_step_addli_insn) != TREG_ZERO);
+		BUG_ON(get_Dest_X1(__single_step_addli_insn) != 0);
+		BUG_ON(get_JOffLong_X1(__single_step_j_insn) != 0);
+	}
+
+	/*
+	 * If we are returning from a syscall, we still haven't hit the
+	 * "ill" for the swint1 instruction.  So back the PC up to be
+	 * pointing at the swint1, but we'll actually return directly
+	 * back to the "ill" so we come back in via SIGILL as if we
+	 * had "executed" the swint1 without ever being in kernel space.
+	 */
+	if (regs->faultnum == INT_SWINT_1)
+		regs->pc -= 8;
+
+	pc = (tile_bundle_bits *)(regs->pc);
+	bundle = pc[0];
+
+	/* We'll follow the instruction with 2 ill op bundles */
+	state->orig_pc = (unsigned long) pc;
+	state->next_pc = (unsigned long)(pc + 1);
+	state->branch_next_pc = 0;
+	state->update = 0;
+
+	if (!(bundle & TILE_BUNDLE_Y_ENCODING_MASK)) {
+		/* two wide, check for control flow */
+		int opcode = get_Opcode_X1(bundle);
+
+		switch (opcode) {
+		/* branches */
+		case BRANCH_OPCODE_X1:
+		{
+			int32_t offset = signExtend17(get_BrOff_X1(bundle));
+
+			/*
+			 * For branches, we use a rewriting trick to let the
+			 * hardware evaluate whether the branch is taken or
+			 * untaken.  We record the target offset and then
+			 * rewrite the branch instruction to target 1 insn
+			 * ahead if the branch is taken.  We then follow the
+			 * rewritten branch with two bundles, each containing
+			 * an "ill" instruction. The supervisor examines the
+			 * pc after the single step code is executed, and if
+			 * the pc is the first ill instruction, then the
+			 * branch (if any) was not taken.  If the pc is the
+			 * second ill instruction, then the branch was
+			 * taken. The new pc is computed for these cases, and
+			 * inserted into the registers for the thread.  If
+			 * the pc is the start of the single step code, then
+			 * an exception or interrupt was taken before the
+			 * code started processing, and the same "original"
+			 * pc is restored.  This change, different from the
+			 * original implementation, has the advantage of
+			 * executing a single user instruction.
+			 */
+			state->branch_next_pc = (unsigned long)(pc + offset);
+
+			/* rewrite branch offset to go forward one bundle */
+			bundle = set_BrOff_X1(bundle, 2);
+		}
+		break;
+
+		/* jumps */
+		case JALB_OPCODE_X1:
+		case JALF_OPCODE_X1:
+			state->update = 1;
+			state->next_pc =
+				(unsigned long) (pc + get_JOffLong_X1(bundle));
+			break;
+
+		case JB_OPCODE_X1:
+		case JF_OPCODE_X1:
+			state->next_pc =
+				(unsigned long) (pc + get_JOffLong_X1(bundle));
+			bundle = nop_X1(bundle);
+			break;
+
+		case SPECIAL_0_OPCODE_X1:
+			switch (get_RRROpcodeExtension_X1(bundle)) {
+			/* jump-register */
+			case JALRP_SPECIAL_0_OPCODE_X1:
+			case JALR_SPECIAL_0_OPCODE_X1:
+				state->update = 1;
+				state->next_pc =
+					regs->regs[get_SrcA_X1(bundle)];
+				break;
+
+			case JRP_SPECIAL_0_OPCODE_X1:
+			case JR_SPECIAL_0_OPCODE_X1:
+				state->next_pc =
+					regs->regs[get_SrcA_X1(bundle)];
+				bundle = nop_X1(bundle);
+				break;
+
+			case LNK_SPECIAL_0_OPCODE_X1:
+				state->update = 1;
+				target_reg = get_Dest_X1(bundle);
+				break;
+
+			/* stores */
+			case SH_SPECIAL_0_OPCODE_X1:
+				mem_op = MEMOP_STORE;
+				size = 2;
+				break;
+
+			case SW_SPECIAL_0_OPCODE_X1:
+				mem_op = MEMOP_STORE;
+				size = 4;
+				break;
+			}
+			break;
+
+		/* loads and iret */
+		case SHUN_0_OPCODE_X1:
+			if (get_UnShOpcodeExtension_X1(bundle) ==
+			    UN_0_SHUN_0_OPCODE_X1) {
+				switch (get_UnOpcodeExtension_X1(bundle)) {
+				case LH_UN_0_SHUN_0_OPCODE_X1:
+					mem_op = MEMOP_LOAD;
+					size = 2;
+					sign_ext = 1;
+					break;
+
+				case LH_U_UN_0_SHUN_0_OPCODE_X1:
+					mem_op = MEMOP_LOAD;
+					size = 2;
+					sign_ext = 0;
+					break;
+
+				case LW_UN_0_SHUN_0_OPCODE_X1:
+					mem_op = MEMOP_LOAD;
+					size = 4;
+					break;
+
+				case IRET_UN_0_SHUN_0_OPCODE_X1:
+				{
+					unsigned long ex0_0 = __insn_mfspr(
+						SPR_EX_CONTEXT_0_0);
+					unsigned long ex0_1 = __insn_mfspr(
+						SPR_EX_CONTEXT_0_1);
+					/*
+					 * Special-case it if we're iret'ing
+					 * to PL0 again.  Otherwise just let
+					 * it run and it will generate SIGILL.
+					 */
+					if (EX1_PL(ex0_1) == USER_PL) {
+						state->next_pc = ex0_0;
+						regs->ex1 = ex0_1;
+						bundle = nop_X1(bundle);
+					}
+				}
+				}
+			}
+			break;
+
+#if CHIP_HAS_WH64()
+		/* postincrement operations */
+		case IMM_0_OPCODE_X1:
+			switch (get_ImmOpcodeExtension_X1(bundle)) {
+			case LWADD_IMM_0_OPCODE_X1:
+				mem_op = MEMOP_LOAD_POSTINCR;
+				size = 4;
+				break;
+
+			case LHADD_IMM_0_OPCODE_X1:
+				mem_op = MEMOP_LOAD_POSTINCR;
+				size = 2;
+				sign_ext = 1;
+				break;
+
+			case LHADD_U_IMM_0_OPCODE_X1:
+				mem_op = MEMOP_LOAD_POSTINCR;
+				size = 2;
+				sign_ext = 0;
+				break;
+
+			case SWADD_IMM_0_OPCODE_X1:
+				mem_op = MEMOP_STORE_POSTINCR;
+				size = 4;
+				break;
+
+			case SHADD_IMM_0_OPCODE_X1:
+				mem_op = MEMOP_STORE_POSTINCR;
+				size = 2;
+				break;
+
+			default:
+				break;
+			}
+			break;
+#endif /* CHIP_HAS_WH64() */
+		}
+
+		if (state->update) {
+			/*
+			 * Get an available register.  We start with a
+			 * bitmask with 1's for available registers.
+			 * We truncate to the low 32 registers since
+			 * we are guaranteed to have set bits in the
+			 * low 32 bits, then use ctz to pick the first.
+			 */
+			u32 mask = (u32) ~((1ULL << get_Dest_X0(bundle)) |
+					   (1ULL << get_SrcA_X0(bundle)) |
+					   (1ULL << get_SrcB_X0(bundle)) |
+					   (1ULL << target_reg));
+			temp_reg = __builtin_ctz(mask);
+			state->update_reg = temp_reg;
+			state->update_value = regs->regs[temp_reg];
+			regs->regs[temp_reg] = (unsigned long) (pc+1);
+			regs->flags |= PT_FLAGS_RESTORE_REGS;
+			bundle = move_X1(bundle, target_reg, temp_reg);
+		}
+	} else {
+		int opcode = get_Opcode_Y2(bundle);
+
+		switch (opcode) {
+		/* loads */
+		case LH_OPCODE_Y2:
+			mem_op = MEMOP_LOAD;
+			size = 2;
+			sign_ext = 1;
+			break;
+
+		case LH_U_OPCODE_Y2:
+			mem_op = MEMOP_LOAD;
+			size = 2;
+			sign_ext = 0;
+			break;
+
+		case LW_OPCODE_Y2:
+			mem_op = MEMOP_LOAD;
+			size = 4;
+			break;
+
+		/* stores */
+		case SH_OPCODE_Y2:
+			mem_op = MEMOP_STORE;
+			size = 2;
+			break;
+
+		case SW_OPCODE_Y2:
+			mem_op = MEMOP_STORE;
+			size = 4;
+			break;
+		}
+	}
+
+	/*
+	 * Check if we need to rewrite an unaligned load/store.
+	 * Returning zero is a special value meaning we need to SIGSEGV.
+	 */
+	if (mem_op != MEMOP_NONE && unaligned_fixup >= 0) {
+		bundle = rewrite_load_store_unaligned(state, bundle, regs,
+						      mem_op, size, sign_ext);
+		if (bundle == 0)
+			return;
+	}
+
+	/* write the bundle to our execution area */
+	buffer = state->buffer;
+	err = __put_user(bundle, buffer++);
+
+	/*
+	 * If we're really single-stepping, we take an INT_ILL after.
+	 * If we're just handling an unaligned access, we can just
+	 * jump directly back to where we were in user code.
+	 */
+	if (is_single_step) {
+		err |= __put_user(__single_step_ill_insn, buffer++);
+		err |= __put_user(__single_step_ill_insn, buffer++);
+	} else {
+		long delta;
+
+		if (state->update) {
+			/* We have some state to update; do it inline */
+			int ha16;
+			bundle = __single_step_addli_insn;
+			bundle |= create_Dest_X1(state->update_reg);
+			bundle |= create_Imm16_X1(state->update_value);
+			err |= __put_user(bundle, buffer++);
+			bundle = __single_step_auli_insn;
+			bundle |= create_Dest_X1(state->update_reg);
+			bundle |= create_SrcA_X1(state->update_reg);
+			ha16 = (state->update_value + 0x8000) >> 16;
+			bundle |= create_Imm16_X1(ha16);
+			err |= __put_user(bundle, buffer++);
+			state->update = 0;
+		}
+
+		/* End with a jump back to the next instruction */
+		delta = ((regs->pc + TILE_BUNDLE_SIZE_IN_BYTES) -
+			(unsigned long)buffer) >>
+			TILE_LOG2_BUNDLE_ALIGNMENT_IN_BYTES;
+		bundle = __single_step_j_insn;
+		bundle |= create_JOffLong_X1(delta);
+		err |= __put_user(bundle, buffer++);
+	}
+
+	if (err) {
+		printk("Fault when writing to single-step buffer\n");
+		return;
+	}
+
+	/*
+	 * Flush the buffer.
+	 * We do a local flush only, since this is a thread-specific buffer.
+	 */
+	__flush_icache_range((unsigned long) state->buffer,
+			     (unsigned long) buffer);
+
+	/* Indicate enabled */
+	state->is_enabled = is_single_step;
+	regs->pc = (unsigned long) state->buffer;
+
+	/* Fault immediately if we are coming back from a syscall. */
+	if (regs->faultnum == INT_SWINT_1)
+		regs->pc += 8;
+}
+
+#endif /* !__tilegx__ */
diff --git a/arch/tile/kernel/smp.c b/arch/tile/kernel/smp.c
new file mode 100644
index 0000000..782c1bf
--- /dev/null
+++ b/arch/tile/kernel/smp.c
@@ -0,0 +1,202 @@
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
+ *
+ * TILE SMP support routines.
+ */
+
+#include <linux/smp.h>
+#include <linux/irq.h>
+#include <asm/cacheflush.h>
+
+HV_Topology smp_topology __write_once;
+
+
+/*
+ * Top-level send_IPI*() functions to send messages to other cpus.
+ */
+
+/* Set by smp_send_stop() to avoid recursive panics. */
+static int stopping_cpus;
+
+void send_IPI_single(int cpu, int tag)
+{
+	HV_Recipient recip = {
+		.y = cpu / smp_width,
+		.x = cpu % smp_width,
+		.state = HV_TO_BE_SENT
+	};
+	int rc = hv_send_message(&recip, 1, (HV_VirtAddr)&tag, sizeof(tag));
+	BUG_ON(rc <= 0);
+}
+
+void send_IPI_many(const struct cpumask *mask, int tag)
+{
+	HV_Recipient recip[NR_CPUS];
+	int cpu, sent;
+	int nrecip = 0;
+	int my_cpu = smp_processor_id();
+	for_each_cpu(cpu, mask) {
+		HV_Recipient *r;
+		BUG_ON(cpu == my_cpu);
+		r = &recip[nrecip++];
+		r->y = cpu / smp_width;
+		r->x = cpu % smp_width;
+		r->state = HV_TO_BE_SENT;
+	}
+	sent = 0;
+	while (sent < nrecip) {
+		int rc = hv_send_message(recip, nrecip,
+					 (HV_VirtAddr)&tag, sizeof(tag));
+		if (rc <= 0) {
+			if (!stopping_cpus)  /* avoid recursive panic */
+				panic("hv_send_message returned %d", rc);
+			break;
+		}
+		sent += rc;
+	}
+}
+
+void send_IPI_allbutself(int tag)
+{
+	struct cpumask mask;
+	cpumask_copy(&mask, cpu_online_mask);
+	cpumask_clear_cpu(smp_processor_id(), &mask);
+	send_IPI_many(&mask, tag);
+}
+
+
+/*
+ * Provide smp_call_function_mask, but also run function locally
+ * if specified in the mask.
+ */
+void on_each_cpu_mask(const struct cpumask *mask, void (*func)(void *),
+		      void *info, bool wait)
+{
+	int cpu = get_cpu();
+	smp_call_function_many(mask, func, info, wait);
+	if (cpumask_test_cpu(cpu, mask)) {
+		local_irq_disable();
+		func(info);
+		local_irq_enable();
+	}
+	put_cpu();
+}
+
+
+/*
+ * Functions related to starting/stopping cpus.
+ */
+
+/* Handler to start the current cpu. */
+static void smp_start_cpu_interrupt(void)
+{
+	extern unsigned long start_cpu_function_addr;
+	get_irq_regs()->pc = start_cpu_function_addr;
+}
+
+/* Handler to stop the current cpu. */
+static void smp_stop_cpu_interrupt(void)
+{
+	set_cpu_online(smp_processor_id(), 0);
+	raw_local_irq_disable_all();
+	for (;;)
+		asm("nap");
+}
+
+/* This function calls the 'stop' function on all other CPUs in the system. */
+void smp_send_stop(void)
+{
+	stopping_cpus = 1;
+	send_IPI_allbutself(MSG_TAG_STOP_CPU);
+}
+
+
+/*
+ * Dispatch code called from hv_message_intr() for HV_MSG_TILE hv messages.
+ */
+void evaluate_message(int tag)
+{
+	switch (tag) {
+	case MSG_TAG_START_CPU: /* Start up a cpu */
+		smp_start_cpu_interrupt();
+		break;
+
+	case MSG_TAG_STOP_CPU: /* Sent to shut down slave CPU's */
+		smp_stop_cpu_interrupt();
+		break;
+
+	case MSG_TAG_CALL_FUNCTION_MANY: /* Call function on cpumask */
+		generic_smp_call_function_interrupt();
+		break;
+
+	case MSG_TAG_CALL_FUNCTION_SINGLE: /* Call function on one other CPU */
+		generic_smp_call_function_single_interrupt();
+		break;
+
+	default:
+		panic("Unknown IPI message tag %d", tag);
+		break;
+	}
+}
+
+
+/*
+ * flush_icache_range() code uses smp_call_function().
+ */
+
+struct ipi_flush {
+	unsigned long start;
+	unsigned long end;
+};
+
+static void ipi_flush_icache_range(void *info)
+{
+	struct ipi_flush *flush = (struct ipi_flush *) info;
+	__flush_icache_range(flush->start, flush->end);
+}
+
+void flush_icache_range(unsigned long start, unsigned long end)
+{
+	struct ipi_flush flush = { start, end };
+	preempt_disable();
+	on_each_cpu(ipi_flush_icache_range, &flush, 1);
+	preempt_enable();
+}
+
+
+/*
+ * The smp_send_reschedule() path does not use the hv_message_intr()
+ * path but instead the faster tile_dev_intr() path for interrupts.
+ */
+
+irqreturn_t handle_reschedule_ipi(int irq, void *token)
+{
+	/*
+	 * Nothing to do here; when we return from interrupt, the
+	 * rescheduling will occur there. But do bump the interrupt
+	 * profiler count in the meantime.
+	 */
+	__get_cpu_var(irq_stat).irq_resched_count++;
+
+	return IRQ_HANDLED;
+}
+
+void smp_send_reschedule(int cpu)
+{
+	HV_Coord coord;
+
+	WARN_ON(cpu_is_offline(cpu));
+	coord.y = cpu / smp_width;
+	coord.x = cpu % smp_width;
+	hv_trigger_ipi(coord, IRQ_RESCHEDULE);
+}
diff --git a/arch/tile/kernel/smpboot.c b/arch/tile/kernel/smpboot.c
new file mode 100644
index 0000000..aa3aafd
--- /dev/null
+++ b/arch/tile/kernel/smpboot.c
@@ -0,0 +1,293 @@
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
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/sched.h>
+#include <linux/kernel_stat.h>
+#include <linux/smp_lock.h>
+#include <linux/bootmem.h>
+#include <linux/notifier.h>
+#include <linux/cpu.h>
+#include <linux/percpu.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <asm/mmu_context.h>
+#include <asm/tlbflush.h>
+#include <asm/sections.h>
+
+/*
+ * This assembly function is provided in entry.S.
+ * When called, it loops on a nap instruction forever.
+ * FIXME: should be in a header somewhere.
+ */
+extern void smp_nap(void);
+
+/* State of each CPU. */
+DEFINE_PER_CPU(int, cpu_state) = { 0 };
+
+/* The messaging code jumps to this pointer during boot-up */
+unsigned long start_cpu_function_addr;
+
+/* Called very early during startup to mark boot cpu as online */
+void __init smp_prepare_boot_cpu(void)
+{
+	int cpu = smp_processor_id();
+	set_cpu_online(cpu, 1);
+	set_cpu_present(cpu, 1);
+	__get_cpu_var(cpu_state) = CPU_ONLINE;
+
+	init_messaging();
+}
+
+static void start_secondary(void);
+
+/*
+ * Called at the top of init() to launch all the other CPUs.
+ * They run free to complete their initialization and then wait
+ * until they get an IPI from the boot cpu to come online.
+ */
+void __init smp_prepare_cpus(unsigned int max_cpus)
+{
+	long rc;
+	int cpu, cpu_count;
+	int boot_cpu = smp_processor_id();
+
+	current_thread_info()->cpu = boot_cpu;
+
+	/*
+	 * Pin this task to the boot CPU while we bring up the others,
+	 * just to make sure we don't uselessly migrate as they come up.
+	 */
+	rc = sched_setaffinity(current->pid, cpumask_of(boot_cpu));
+	if (rc != 0)
+		printk("Couldn't set init affinity to boot cpu (%ld)\n", rc);
+
+	/* Print information about disabled and dataplane cpus. */
+	print_disabled_cpus();
+
+	/*
+	 * Tell the messaging subsystem how to respond to the
+	 * startup message.  We use a level of indirection to avoid
+	 * confusing the linker with the fact that the messaging
+	 * subsystem is calling __init code.
+	 */
+	start_cpu_function_addr = (unsigned long) &online_secondary;
+
+	/* Set up thread context for all new processors. */
+	cpu_count = 1;
+	for (cpu = 0; cpu < NR_CPUS; ++cpu)	{
+		struct task_struct *idle;
+
+		if (cpu == boot_cpu)
+			continue;
+
+		if (!cpu_possible(cpu)) {
+			/*
+			 * Make this processor do nothing on boot.
+			 * Note that we don't give the boot_pc function
+			 * a stack, so it has to be assembly code.
+			 */
+			per_cpu(boot_sp, cpu) = 0;
+			per_cpu(boot_pc, cpu) = (unsigned long) smp_nap;
+			continue;
+		}
+
+		/* Create a new idle thread to run start_secondary() */
+		idle = fork_idle(cpu);
+		if (IS_ERR(idle))
+			panic("failed fork for CPU %d", cpu);
+		idle->thread.pc = (unsigned long) start_secondary;
+
+		/* Make this thread the boot thread for this processor */
+		per_cpu(boot_sp, cpu) = task_ksp0(idle);
+		per_cpu(boot_pc, cpu) = idle->thread.pc;
+
+		++cpu_count;
+	}
+	BUG_ON(cpu_count > (max_cpus ? max_cpus : 1));
+
+	/* Fire up the other tiles, if any */
+	init_cpu_present(cpu_possible_mask);
+	if (cpumask_weight(cpu_present_mask) > 1) {
+		mb();  /* make sure all data is visible to new processors */
+		hv_start_all_tiles();
+	}
+}
+
+static __initdata struct cpumask init_affinity;
+
+static __init int reset_init_affinity(void)
+{
+	long rc = sched_setaffinity(current->pid, &init_affinity);
+	if (rc != 0)
+		printk(KERN_WARNING "couldn't reset init affinity (%ld)\n",
+		       rc);
+	return 0;
+}
+late_initcall(reset_init_affinity);
+
+struct cpumask cpu_started __cpuinitdata;
+
+/*
+ * Activate a secondary processor.  Very minimal; don't add anything
+ * to this path without knowing what you're doing, since SMP booting
+ * is pretty fragile.
+ */
+static void __cpuinit start_secondary(void)
+{
+	int cpuid = smp_processor_id();
+
+	/* Set our thread pointer appropriately. */
+	set_my_cpu_offset(__per_cpu_offset[cpuid]);
+
+	preempt_disable();
+
+	/*
+	 * In large machines even this will slow us down, since we
+	 * will be contending for for the printk spinlock.
+	 */
+	/* printk(KERN_DEBUG "Initializing CPU#%d\n", cpuid); */
+
+	/* Initialize the current asid for our first page table. */
+	__get_cpu_var(current_asid) = min_asid;
+
+	/* Set up this thread as another owner of the init_mm */
+	atomic_inc(&init_mm.mm_count);
+	current->active_mm = &init_mm;
+	if (current->mm)
+		BUG();
+	enter_lazy_tlb(&init_mm, current);
+
+	/* Enable IRQs. */
+	init_per_tile_IRQs();
+
+	/* Allow hypervisor messages to be received */
+	init_messaging();
+	local_irq_enable();
+
+	/* Indicate that we're ready to come up. */
+	/* Must not do this before we're ready to receive messages */
+	if (cpumask_test_and_set_cpu(cpuid, &cpu_started)) {
+		printk(KERN_WARNING "CPU#%d already started!\n", cpuid);
+		for (;;)
+			local_irq_enable();
+	}
+
+	smp_nap();
+}
+
+void setup_mpls(void);  /* from kernel/setup.c */
+void store_permanent_mappings(void);
+
+/*
+ * Bring a secondary processor online.
+ */
+void __cpuinit online_secondary()
+{
+	/*
+	 * low-memory mappings have been cleared, flush them from
+	 * the local TLBs too.
+	 */
+	local_flush_tlb();
+
+	BUG_ON(in_interrupt());
+
+	/* This must be done before setting cpu_online_mask */
+	wmb();
+
+	/*
+	 * We need to hold call_lock, so there is no inconsistency
+	 * between the time smp_call_function() determines number of
+	 * IPI recipients, and the time when the determination is made
+	 * for which cpus receive the IPI. Holding this
+	 * lock helps us to not include this cpu in a currently in progress
+	 * smp_call_function().
+	 */
+	ipi_call_lock();
+	set_cpu_online(smp_processor_id(), 1);
+	ipi_call_unlock();
+	__get_cpu_var(cpu_state) = CPU_ONLINE;
+
+	/* Set up MPLs for this processor */
+	setup_mpls();
+
+
+	/* Set up tile-timer clock-event device on this cpu */
+	setup_tile_timer();
+
+	preempt_enable();
+
+	store_permanent_mappings();
+
+	cpu_idle();
+}
+
+int __cpuinit __cpu_up(unsigned int cpu)
+{
+	/* Wait 5s total for all CPUs for them to come online */
+	static int timeout;
+	for (; !cpumask_test_cpu(cpu, &cpu_started); timeout++) {
+		if (timeout >= 50000) {
+			printk(KERN_INFO "skipping unresponsive cpu%d\n", cpu);
+			local_irq_enable();
+			return -EIO;
+		}
+		udelay(100);
+	}
+
+	local_irq_enable();
+	per_cpu(cpu_state, cpu) = CPU_UP_PREPARE;
+
+	/* Unleash the CPU! */
+	send_IPI_single(cpu, MSG_TAG_START_CPU);
+	while (!cpumask_test_cpu(cpu, cpu_online_mask))
+		cpu_relax();
+	return 0;
+}
+
+static void panic_start_cpu(void)
+{
+	panic("Received a MSG_START_CPU IPI after boot finished.");
+}
+
+void __init smp_cpus_done(unsigned int max_cpus)
+{
+	int cpu, next, rc;
+
+	/* Reset the response to a (now illegal) MSG_START_CPU IPI. */
+	start_cpu_function_addr = (unsigned long) &panic_start_cpu;
+
+	cpumask_copy(&init_affinity, cpu_online_mask);
+
+	/*
+	 * Pin ourselves to a single cpu in the initial affinity set
+	 * so that kernel mappings for the rootfs are not in the dataplane,
+	 * if set, and to avoid unnecessary migrating during bringup.
+	 * Use the last cpu just in case the whole chip has been
+	 * isolated from the scheduler, to keep init away from likely
+	 * more useful user code.  This also ensures that work scheduled
+	 * via schedule_delayed_work() in the init routines will land
+	 * on this cpu.
+	 */
+	for (cpu = cpumask_first(&init_affinity);
+	     (next = cpumask_next(cpu, &init_affinity)) < nr_cpu_ids;
+	     cpu = next)
+		;
+	rc = sched_setaffinity(current->pid, cpumask_of(cpu));
+	if (rc != 0)
+		printk("Couldn't set init affinity to cpu %d (%d)\n", cpu, rc);
+}
diff --git a/arch/tile/kernel/stack.c b/arch/tile/kernel/stack.c
new file mode 100644
index 0000000..382170b
--- /dev/null
+++ b/arch/tile/kernel/stack.c
@@ -0,0 +1,485 @@
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
+#include <linux/sched.h>
+#include <linux/kernel.h>
+#include <linux/kprobes.h>
+#include <linux/module.h>
+#include <linux/pfn.h>
+#include <linux/kallsyms.h>
+#include <linux/stacktrace.h>
+#include <linux/uaccess.h>
+#include <linux/mmzone.h>
+#include <asm/backtrace.h>
+#include <asm/page.h>
+#include <asm/tlbflush.h>
+#include <asm/ucontext.h>
+#include <asm/sigframe.h>
+#include <asm/stack.h>
+#include <arch/abi.h>
+#include <arch/interrupts.h>
+
+
+/* Is address on the specified kernel stack? */
+static int in_kernel_stack(struct KBacktraceIterator *kbt, VirtualAddress sp)
+{
+	ulong kstack_base = (ulong) kbt->task->stack;
+	if (kstack_base == 0)  /* corrupt task pointer; just follow stack... */
+		return sp >= PAGE_OFFSET && sp < (unsigned long)high_memory;
+	return sp >= kstack_base && sp < kstack_base + THREAD_SIZE;
+}
+
+/* Is address in the specified kernel code? */
+static int in_kernel_text(VirtualAddress address)
+{
+	return (address >= MEM_SV_INTRPT &&
+		address < MEM_SV_INTRPT + HPAGE_SIZE);
+}
+
+/* Is address valid for reading? */
+static int valid_address(struct KBacktraceIterator *kbt, VirtualAddress address)
+{
+	HV_PTE *l1_pgtable = kbt->pgtable;
+	HV_PTE *l2_pgtable;
+	unsigned long pfn;
+	HV_PTE pte;
+	struct page *page;
+
+	pte = l1_pgtable[HV_L1_INDEX(address)];
+	if (!hv_pte_get_present(pte))
+		return 0;
+	pfn = hv_pte_get_pfn(pte);
+	if (pte_huge(pte)) {
+		if (!pfn_valid(pfn)) {
+			printk(KERN_ERR "huge page has bad pfn %#lx\n", pfn);
+			return 0;
+		}
+		return hv_pte_get_present(pte) && hv_pte_get_readable(pte);
+	}
+
+	page = pfn_to_page(pfn);
+	if (PageHighMem(page)) {
+		printk(KERN_ERR "L2 page table not in LOWMEM (%#llx)\n",
+		       HV_PFN_TO_CPA(pfn));
+		return 0;
+	}
+	l2_pgtable = (HV_PTE *)pfn_to_kaddr(pfn);
+	pte = l2_pgtable[HV_L2_INDEX(address)];
+	return hv_pte_get_present(pte) && hv_pte_get_readable(pte);
+}
+
+/* Callback for backtracer; basically a glorified memcpy */
+static bool read_memory_func(void *result, VirtualAddress address,
+			     unsigned int size, void *vkbt)
+{
+	int retval;
+	struct KBacktraceIterator *kbt = (struct KBacktraceIterator *)vkbt;
+	if (in_kernel_text(address)) {
+		/* OK to read kernel code. */
+	} else if (address >= PAGE_OFFSET) {
+		/* We only tolerate kernel-space reads of this task's stack */
+		if (!in_kernel_stack(kbt, address))
+			return 0;
+	} else if (kbt->pgtable == NULL) {
+		return 0;	/* can't read user space in other tasks */
+	} else if (!valid_address(kbt, address)) {
+		return 0;	/* invalid user-space address */
+	}
+	pagefault_disable();
+	retval = __copy_from_user_inatomic(result, (const void *)address,
+					   size);
+	pagefault_enable();
+	return (retval == 0);
+}
+
+/* Return a pt_regs pointer for a valid fault handler frame */
+static struct pt_regs *valid_fault_handler(struct KBacktraceIterator* kbt)
+{
+#ifndef __tilegx__
+	const char *fault = NULL;  /* happy compiler */
+	char fault_buf[64];
+	VirtualAddress sp = kbt->it.sp;
+	struct pt_regs *p;
+
+	if (!in_kernel_stack(kbt, sp))
+		return NULL;
+	if (!in_kernel_stack(kbt, sp + C_ABI_SAVE_AREA_SIZE + PTREGS_SIZE-1))
+		return NULL;
+	p = (struct pt_regs *)(sp + C_ABI_SAVE_AREA_SIZE);
+	if (p->faultnum == INT_SWINT_1 || p->faultnum == INT_SWINT_1_SIGRETURN)
+		fault = "syscall";
+	else {
+		if (kbt->verbose) {     /* else we aren't going to use it */
+			snprintf(fault_buf, sizeof(fault_buf),
+				 "interrupt %ld", p->faultnum);
+			fault = fault_buf;
+		}
+	}
+	if (EX1_PL(p->ex1) == KERNEL_PL &&
+	    in_kernel_text(p->pc) &&
+	    in_kernel_stack(kbt, p->sp) &&
+	    p->sp >= sp) {
+		if (kbt->verbose)
+			printk(KERN_ERR "  <%s while in kernel mode>\n", fault);
+	} else if (EX1_PL(p->ex1) == USER_PL &&
+	    p->pc < PAGE_OFFSET &&
+	    p->sp < PAGE_OFFSET) {
+		if (kbt->verbose)
+			printk(KERN_ERR "  <%s while in user mode>\n", fault);
+	} else if (kbt->verbose) {
+		printk(KERN_ERR "  (odd fault: pc %#lx, sp %#lx, ex1 %#lx?)\n",
+		       p->pc, p->sp, p->ex1);
+		p = NULL;
+	}
+	if (!kbt->profile || (INT_MASK(p->faultnum) & QUEUED_INTERRUPTS) == 0)
+		return p;
+#endif
+	return NULL;
+}
+
+/* Is the pc pointing to a sigreturn trampoline? */
+static int is_sigreturn(VirtualAddress pc)
+{
+	return (pc == VDSO_BASE);
+}
+
+/* Return a pt_regs pointer for a valid signal handler frame */
+static struct pt_regs *valid_sigframe(struct KBacktraceIterator* kbt)
+{
+	BacktraceIterator *b = &kbt->it;
+
+	if (b->pc == VDSO_BASE) {
+		struct rt_sigframe *frame;
+		unsigned long sigframe_top =
+			b->sp + sizeof(struct rt_sigframe) - 1;
+		if (!valid_address(kbt, b->sp) ||
+		    !valid_address(kbt, sigframe_top)) {
+			if (kbt->verbose)
+				printk("  (odd signal: sp %#lx?)\n",
+				       (unsigned long)(b->sp));
+			return NULL;
+		}
+		frame = (struct rt_sigframe *)b->sp;
+		if (kbt->verbose) {
+			printk(KERN_ERR "  <received signal %d>\n",
+			       frame->info.si_signo);
+		}
+		return &frame->uc.uc_mcontext.regs;
+	}
+	return NULL;
+}
+
+int KBacktraceIterator_is_sigreturn(struct KBacktraceIterator *kbt)
+{
+	return is_sigreturn(kbt->it.pc);
+}
+
+static int KBacktraceIterator_restart(struct KBacktraceIterator *kbt)
+{
+	struct pt_regs *p;
+
+	p = valid_fault_handler(kbt);
+	if (p == NULL)
+		p = valid_sigframe(kbt);
+	if (p == NULL)
+		return 0;
+	backtrace_init(&kbt->it, read_memory_func, kbt,
+		       p->pc, p->lr, p->sp, p->regs[52]);
+	kbt->new_context = 1;
+	return 1;
+}
+
+/* Find a frame that isn't a sigreturn, if there is one. */
+static int KBacktraceIterator_next_item_inclusive(
+	struct KBacktraceIterator *kbt)
+{
+	for (;;) {
+		do {
+			if (!KBacktraceIterator_is_sigreturn(kbt))
+				return 1;
+		} while (backtrace_next(&kbt->it));
+
+		if (!KBacktraceIterator_restart(kbt))
+			return 0;
+	}
+}
+
+/*
+ * If the current sp is on a page different than what we recorded
+ * as the top-of-kernel-stack last time we context switched, we have
+ * probably blown the stack, and nothing is going to work out well.
+ * If we can at least get out a warning, that may help the debug,
+ * though we probably won't be able to backtrace into the code that
+ * actually did the recursive damage.
+ */
+static void validate_stack(struct pt_regs *regs)
+{
+	int cpu = smp_processor_id();
+	unsigned long ksp0 = get_current_ksp0();
+	unsigned long ksp0_base = ksp0 - THREAD_SIZE;
+	unsigned long sp = stack_pointer;
+
+	if (EX1_PL(regs->ex1) == KERNEL_PL && regs->sp >= ksp0) {
+		printk("WARNING: cpu %d: kernel stack page %#lx underrun!\n"
+		       "  sp %#lx (%#lx in caller), caller pc %#lx, lr %#lx\n",
+		       cpu, ksp0_base, sp, regs->sp, regs->pc, regs->lr);
+	}
+
+	else if (sp < ksp0_base + sizeof(struct thread_info)) {
+		printk("WARNING: cpu %d: kernel stack page %#lx overrun!\n"
+		       "  sp %#lx (%#lx in caller), caller pc %#lx, lr %#lx\n",
+		       cpu, ksp0_base, sp, regs->sp, regs->pc, regs->lr);
+	}
+}
+
+void KBacktraceIterator_init(struct KBacktraceIterator *kbt,
+			     struct task_struct *t, struct pt_regs *regs)
+{
+	VirtualAddress pc, lr, sp, r52;
+	int is_current;
+
+	/*
+	 * Set up callback information.  We grab the kernel stack base
+	 * so we will allow reads of that address range, and if we're
+	 * asking about the current process we grab the page table
+	 * so we can check user accesses before trying to read them.
+	 * We flush the TLB to avoid any weird skew issues.
+	 */
+	is_current = (t == NULL);
+	kbt->is_current = is_current;
+	if (is_current)
+		t = validate_current();
+	kbt->task = t;
+	kbt->pgtable = NULL;
+	kbt->verbose = 0;   /* override in caller if desired */
+	kbt->profile = 0;   /* override in caller if desired */
+	kbt->end = 0;
+	kbt->new_context = 0;
+	if (is_current) {
+		HV_PhysAddr pgdir_pa = hv_inquire_context().page_table;
+		if (pgdir_pa == (unsigned long)swapper_pg_dir - PAGE_OFFSET) {
+			/*
+			 * Not just an optimization: this also allows
+			 * this to work at all before va/pa mappings
+			 * are set up.
+			 */
+			kbt->pgtable = swapper_pg_dir;
+		} else {
+			struct page *page = pfn_to_page(PFN_DOWN(pgdir_pa));
+			if (!PageHighMem(page))
+				kbt->pgtable = __va(pgdir_pa);
+			else
+				printk(KERN_ERR "page table not in LOWMEM"
+				       " (%#llx)\n", pgdir_pa);
+		}
+		local_flush_tlb_all();
+		validate_stack(regs);
+	}
+
+	if (regs == NULL) {
+		extern const void *get_switch_to_pc(void);
+		if (is_current || t->state == TASK_RUNNING) {
+			/* Can't do this; we need registers */
+			kbt->end = 1;
+			return;
+		}
+		pc = (ulong) get_switch_to_pc();
+		lr = t->thread.pc;
+		sp = t->thread.ksp;
+		r52 = 0;
+	} else {
+		pc = regs->pc;
+		lr = regs->lr;
+		sp = regs->sp;
+		r52 = regs->regs[52];
+	}
+
+	backtrace_init(&kbt->it, read_memory_func, kbt, pc, lr, sp, r52);
+	kbt->end = !KBacktraceIterator_next_item_inclusive(kbt);
+}
+EXPORT_SYMBOL(KBacktraceIterator_init);
+
+int KBacktraceIterator_end(struct KBacktraceIterator *kbt)
+{
+	return kbt->end;
+}
+EXPORT_SYMBOL(KBacktraceIterator_end);
+
+void KBacktraceIterator_next(struct KBacktraceIterator *kbt)
+{
+	kbt->new_context = 0;
+	if (!backtrace_next(&kbt->it) &&
+	    !KBacktraceIterator_restart(kbt)) {
+			kbt->end = 1;
+			return;
+		}
+
+	kbt->end = !KBacktraceIterator_next_item_inclusive(kbt);
+}
+EXPORT_SYMBOL(KBacktraceIterator_next);
+
+/*
+ * This method wraps the backtracer's more generic support.
+ * It is only invoked from the architecture-specific code; show_stack()
+ * and dump_stack() (in entry.S) are architecture-independent entry points.
+ */
+void tile_show_stack(struct KBacktraceIterator *kbt, int headers)
+{
+	int i;
+
+	if (headers) {
+		/*
+		 * Add a blank line since if we are called from panic(),
+		 * then bust_spinlocks() spit out a space in front of us
+		 * and it will mess up our KERN_ERR.
+		 */
+		printk("\n");
+		printk(KERN_ERR "Starting stack dump of tid %d, pid %d (%s)"
+		       " on cpu %d at cycle %lld\n",
+		       kbt->task->pid, kbt->task->tgid, kbt->task->comm,
+		       smp_processor_id(), get_cycles());
+	}
+#ifdef __tilegx__
+	if (kbt->is_current) {
+		__insn_mtspr(SPR_SIM_CONTROL,
+			     SIM_DUMP_SPR_ARG(SIM_DUMP_BACKTRACE));
+	}
+#endif
+	kbt->verbose = 1;
+	i = 0;
+	for (; !KBacktraceIterator_end(kbt); KBacktraceIterator_next(kbt)) {
+		char *modname;
+		const char *name;
+		unsigned long address = kbt->it.pc;
+		unsigned long offset, size;
+		char namebuf[KSYM_NAME_LEN+100];
+
+		if (address >= PAGE_OFFSET)
+			name = kallsyms_lookup(address, &size, &offset,
+					       &modname, namebuf);
+		else
+			name = NULL;
+
+		if (!name)
+			namebuf[0] = '\0';
+		else {
+			size_t namelen = strlen(namebuf);
+			size_t remaining = (sizeof(namebuf) - 1) - namelen;
+			char *p = namebuf + namelen;
+			int rc = snprintf(p, remaining, "+%#lx/%#lx ",
+					  offset, size);
+			if (modname && rc < remaining)
+				snprintf(p + rc, remaining - rc,
+					 "[%s] ", modname);
+			namebuf[sizeof(namebuf)-1] = '\0';
+		}
+
+		printk(KERN_ERR "  frame %d: 0x%lx %s(sp 0x%lx)\n",
+		       i++, address, namebuf, (unsigned long)(kbt->it.sp));
+
+		if (i >= 100) {
+			printk(KERN_ERR "Stack dump truncated"
+			       " (%d frames)\n", i);
+			break;
+		}
+	}
+	if (headers)
+		printk(KERN_ERR "Stack dump complete\n");
+}
+EXPORT_SYMBOL(tile_show_stack);
+
+
+/* This is called from show_regs() and _dump_stack() */
+void dump_stack_regs(struct pt_regs *regs)
+{
+	struct KBacktraceIterator kbt;
+	KBacktraceIterator_init(&kbt, NULL, regs);
+	tile_show_stack(&kbt, 1);
+}
+EXPORT_SYMBOL(dump_stack_regs);
+
+static struct pt_regs *regs_to_pt_regs(struct pt_regs *regs,
+				       ulong pc, ulong lr, ulong sp, ulong r52)
+{
+	memset(regs, 0, sizeof(struct pt_regs));
+	regs->pc = pc;
+	regs->lr = lr;
+	regs->sp = sp;
+	regs->regs[52] = r52;
+	return regs;
+}
+
+/* This is called from dump_stack() and just converts to pt_regs */
+void _dump_stack(int dummy, ulong pc, ulong lr, ulong sp, ulong r52)
+{
+	struct pt_regs regs;
+	dump_stack_regs(regs_to_pt_regs(&regs, pc, lr, sp, r52));
+}
+
+/* This is called from KBacktraceIterator_init_current() */
+void _KBacktraceIterator_init_current(struct KBacktraceIterator *kbt, ulong pc,
+				      ulong lr, ulong sp, ulong r52)
+{
+	struct pt_regs regs;
+	KBacktraceIterator_init(kbt, NULL,
+				regs_to_pt_regs(&regs, pc, lr, sp, r52));
+}
+
+/* This is called only from kernel/sched.c, with esp == NULL */
+void show_stack(struct task_struct *task, unsigned long *esp)
+{
+	struct KBacktraceIterator kbt;
+	if (task == NULL || task == current)
+		KBacktraceIterator_init_current(&kbt);
+	else
+		KBacktraceIterator_init(&kbt, task, NULL);
+	tile_show_stack(&kbt, 0);
+}
+
+#ifdef CONFIG_STACKTRACE
+
+/* Support generic Linux stack API too */
+
+void save_stack_trace_tsk(struct task_struct *task, struct stack_trace *trace)
+{
+	struct KBacktraceIterator kbt;
+	int skip = trace->skip;
+	int i = 0;
+
+	if (task == NULL || task == current)
+		KBacktraceIterator_init_current(&kbt);
+	else
+		KBacktraceIterator_init(&kbt, task, NULL);
+	for (; !KBacktraceIterator_end(&kbt); KBacktraceIterator_next(&kbt)) {
+		if (skip) {
+			--skip;
+			continue;
+		}
+		if (i >= trace->max_entries || kbt.it.pc < PAGE_OFFSET)
+			break;
+		trace->entries[i++] = kbt.it.pc;
+	}
+	trace->nr_entries = i;
+}
+EXPORT_SYMBOL(save_stack_trace_tsk);
+
+void save_stack_trace(struct stack_trace *trace)
+{
+	save_stack_trace_tsk(NULL, trace);
+}
+
+#endif
+
+/* In entry.S */
+EXPORT_SYMBOL(KBacktraceIterator_init_current);
diff --git a/arch/tile/kernel/sys.c b/arch/tile/kernel/sys.c
new file mode 100644
index 0000000..a3d982b
--- /dev/null
+++ b/arch/tile/kernel/sys.c
@@ -0,0 +1,122 @@
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
+ *
+ * This file contains various random system calls that
+ * have a non-standard calling sequence on the Linux/TILE
+ * platform.
+ */
+
+#include <linux/errno.h>
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/smp.h>
+#include <linux/smp_lock.h>
+#include <linux/syscalls.h>
+#include <linux/mman.h>
+#include <linux/file.h>
+#include <linux/mempolicy.h>
+#include <linux/binfmts.h>
+#include <linux/fs.h>
+#include <linux/syscalls.h>
+#include <linux/uaccess.h>
+#include <linux/signal.h>
+#include <asm/syscalls.h>
+
+#include <asm/pgtable.h>
+#include <asm/homecache.h>
+#include <arch/chip.h>
+
+SYSCALL_DEFINE0(flush_cache)
+{
+	homecache_evict(cpumask_of(smp_processor_id()));
+	return 0;
+}
+
+/*
+ * Syscalls that pass 64-bit values on 32-bit systems normally
+ * pass them as (low,high) word packed into the immediately adjacent
+ * registers.  If the low word naturally falls on an even register,
+ * our ABI makes it work correctly; if not, we adjust it here.
+ * Handling it here means we don't have to fix uclibc AND glibc AND
+ * any other standard libcs we want to support.
+ */
+
+#if !defined(__tilegx__) || defined(CONFIG_COMPAT)
+
+ssize_t sys32_readahead(int fd, u32 offset_lo, u32 offset_hi, u32 count)
+{
+	return sys_readahead(fd, ((loff_t)offset_hi << 32) | offset_lo, count);
+}
+
+long sys32_fadvise64(int fd, u32 offset_lo, u32 offset_hi,
+		     u32 len, int advice)
+{
+	return sys_fadvise64_64(fd, ((loff_t)offset_hi << 32) | offset_lo,
+				len, advice);
+}
+
+int sys32_fadvise64_64(int fd, u32 offset_lo, u32 offset_hi,
+		       u32 len_lo, u32 len_hi, int advice)
+{
+	return sys_fadvise64_64(fd, ((loff_t)offset_hi << 32) | offset_lo,
+				((loff_t)len_hi << 32) | len_lo, advice);
+}
+
+#endif /* 32-bit syscall wrappers */
+
+/*
+ * This API uses a 4KB-page-count offset into the file descriptor.
+ * It is likely not the right API to use on a 64-bit platform.
+ */
+SYSCALL_DEFINE6(mmap2, unsigned long, addr, unsigned long, len,
+		unsigned long, prot, unsigned long, flags,
+		unsigned long, fd, unsigned long, off_4k)
+{
+#define PAGE_ADJUST (PAGE_SHIFT - 12)
+	if (off_4k & ((1 << PAGE_ADJUST) - 1))
+		return -EINVAL;
+	return sys_mmap_pgoff(addr, len, prot, flags, fd,
+			      off_4k >> PAGE_ADJUST);
+}
+
+/*
+ * This API uses a byte offset into the file descriptor.
+ * It is likely not the right API to use on a 32-bit platform.
+ */
+SYSCALL_DEFINE6(mmap, unsigned long, addr, unsigned long, len,
+		unsigned long, prot, unsigned long, flags,
+		unsigned long, fd, unsigned long, offset)
+{
+	if (offset & ((1 << PAGE_SHIFT) - 1))
+		return -EINVAL;
+	return sys_mmap_pgoff(addr, len, prot, flags, fd,
+			      offset >> PAGE_SHIFT);
+}
+
+
+/* Provide the actual syscall number to call mapping. */
+#undef __SYSCALL
+#define __SYSCALL(nr, call) [nr] = (call),
+
+#ifndef __tilegx__
+/* See comments at the top of the file. */
+#define sys_fadvise64 sys32_fadvise64
+#define sys_fadvise64_64 sys32_fadvise64_64
+#define sys_readahead sys32_readahead
+#define sys_sync_file_range sys_sync_file_range2
+#endif
+
+void *sys_call_table[__NR_syscalls] = {
+	[0 ... __NR_syscalls-1] = sys_ni_syscall,
+#include <asm/unistd.h>
+};
diff --git a/arch/tile/kernel/time.c b/arch/tile/kernel/time.c
new file mode 100644
index 0000000..47500a3
--- /dev/null
+++ b/arch/tile/kernel/time.c
@@ -0,0 +1,220 @@
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
+ *
+ * Support the cycle counter clocksource and tile timer clock event device.
+ */
+
+#include <linux/time.h>
+#include <linux/timex.h>
+#include <linux/clocksource.h>
+#include <linux/clockchips.h>
+#include <linux/hardirq.h>
+#include <linux/sched.h>
+#include <linux/smp.h>
+#include <linux/delay.h>
+#include <asm/irq_regs.h>
+#include <hv/hypervisor.h>
+#include <arch/interrupts.h>
+#include <arch/spr_def.h>
+
+
+/*
+ * Define the cycle counter clock source.
+ */
+
+/* How many cycles per second we are running at. */
+static cycles_t cycles_per_sec __write_once;
+
+/*
+ * We set up shift and multiply values with a minsec of five seconds,
+ * since our timer counter counts down 31 bits at a frequency of
+ * no less than 500 MHz.  See @minsec for clocks_calc_mult_shift().
+ * We could use a different value for the 64-bit free-running
+ * cycle counter, but we use the same one for consistency, and since
+ * we will be reasonably precise with this value anyway.
+ */
+#define TILE_MINSEC 5
+
+cycles_t get_clock_rate()
+{
+	return cycles_per_sec;
+}
+
+#if CHIP_HAS_SPLIT_CYCLE()
+cycles_t get_cycles()
+{
+	unsigned int high = __insn_mfspr(SPR_CYCLE_HIGH);
+	unsigned int low = __insn_mfspr(SPR_CYCLE_LOW);
+	unsigned int high2 = __insn_mfspr(SPR_CYCLE_HIGH);
+
+	while (unlikely(high != high2)) {
+		low = __insn_mfspr(SPR_CYCLE_LOW);
+		high = high2;
+		high2 = __insn_mfspr(SPR_CYCLE_HIGH);
+	}
+
+	return (((cycles_t)high) << 32) | low;
+}
+#endif
+
+cycles_t clocksource_get_cycles(struct clocksource *cs)
+{
+	return get_cycles();
+}
+
+static struct clocksource cycle_counter_cs = {
+	.name = "cycle counter",
+	.rating = 300,
+	.read = clocksource_get_cycles,
+	.mask = CLOCKSOURCE_MASK(64),
+	.flags = CLOCK_SOURCE_IS_CONTINUOUS,
+};
+
+/*
+ * Called very early from setup_arch() to set cycles_per_sec.
+ * We initialize it early so we can use it to set up loops_per_jiffy.
+ */
+void __init setup_clock(void)
+{
+	cycles_per_sec = hv_sysconf(HV_SYSCONF_CPU_SPEED);
+	clocksource_calc_mult_shift(&cycle_counter_cs, cycles_per_sec,
+				    TILE_MINSEC);
+}
+
+void __init calibrate_delay(void)
+{
+	loops_per_jiffy = get_clock_rate() / HZ;
+	pr_info("Clock rate yields %lu.%02lu BogoMIPS (lpj=%lu)\n",
+		loops_per_jiffy/(500000/HZ),
+		(loops_per_jiffy/(5000/HZ)) % 100, loops_per_jiffy);
+}
+
+/* Called fairly late in init/main.c, but before we go smp. */
+void __init time_init(void)
+{
+	/* Initialize and register the clock source. */
+	clocksource_register(&cycle_counter_cs);
+
+	/* Start up the tile-timer interrupt source on the boot cpu. */
+	setup_tile_timer();
+}
+
+
+/*
+ * Define the tile timer clock event device.  The timer is driven by
+ * the TILE_TIMER_CONTROL register, which consists of a 31-bit down
+ * counter, plus bit 31, which signifies that the counter has wrapped
+ * from zero to (2**31) - 1.  The INT_TILE_TIMER interrupt will be
+ * raised as long as bit 31 is set.
+ */
+
+#define MAX_TICK 0x7fffffff   /* we have 31 bits of countdown timer */
+
+static int tile_timer_set_next_event(unsigned long ticks,
+				     struct clock_event_device *evt)
+{
+	BUG_ON(ticks > MAX_TICK);
+	__insn_mtspr(SPR_TILE_TIMER_CONTROL, ticks);
+	raw_local_irq_unmask_now(INT_TILE_TIMER);
+	return 0;
+}
+
+/*
+ * Whenever anyone tries to change modes, we just mask interrupts
+ * and wait for the next event to get set.
+ */
+static void tile_timer_set_mode(enum clock_event_mode mode,
+				struct clock_event_device *evt)
+{
+	raw_local_irq_mask_now(INT_TILE_TIMER);
+}
+
+/*
+ * Set min_delta_ns to 1 microsecond, since it takes about
+ * that long to fire the interrupt.
+ */
+static DEFINE_PER_CPU(struct clock_event_device, tile_timer) = {
+	.name = "tile timer",
+	.features = CLOCK_EVT_FEAT_ONESHOT,
+	.min_delta_ns = 1000,
+	.rating = 100,
+	.irq = -1,
+	.set_next_event = tile_timer_set_next_event,
+	.set_mode = tile_timer_set_mode,
+};
+
+void __cpuinit setup_tile_timer(void)
+{
+	struct clock_event_device *evt = &__get_cpu_var(tile_timer);
+
+	/* Fill in fields that are speed-specific. */
+	clockevents_calc_mult_shift(evt, cycles_per_sec, TILE_MINSEC);
+	evt->max_delta_ns = clockevent_delta2ns(MAX_TICK, evt);
+
+	/* Mark as being for this cpu only. */
+	evt->cpumask = cpumask_of(smp_processor_id());
+
+	/* Start out with timer not firing. */
+	raw_local_irq_mask_now(INT_TILE_TIMER);
+
+	/* Register tile timer. */
+	clockevents_register_device(evt);
+}
+
+/* Called from the interrupt vector. */
+void do_timer_interrupt(struct pt_regs *regs, int fault_num)
+{
+	struct pt_regs *old_regs = set_irq_regs(regs);
+	struct clock_event_device *evt = &__get_cpu_var(tile_timer);
+
+	/*
+	 * Mask the timer interrupt here, since we are a oneshot timer
+	 * and there are now by definition no events pending.
+	 */
+	raw_local_irq_mask(INT_TILE_TIMER);
+
+	/* Track time spent here in an interrupt context */
+	irq_enter();
+
+	/* Track interrupt count. */
+	__get_cpu_var(irq_stat).irq_timer_count++;
+
+	/* Call the generic timer handler */
+	evt->event_handler(evt);
+
+	/*
+	 * Track time spent against the current process again and
+	 * process any softirqs if they are waiting.
+	 */
+	irq_exit();
+
+	set_irq_regs(old_regs);
+}
+
+/*
+ * Scheduler clock - returns current time in nanosec units.
+ * Note that with LOCKDEP, this is called during lockdep_init(), and
+ * we will claim that sched_clock() is zero for a little while, until
+ * we run setup_clock(), above.
+ */
+unsigned long long sched_clock(void)
+{
+	return clocksource_cyc2ns(get_cycles(),
+				  cycle_counter_cs.mult,
+				  cycle_counter_cs.shift);
+}
+
+int setup_profiling_timer(unsigned int multiplier)
+{
+	return -EINVAL;
+}
diff --git a/arch/tile/kernel/tlb.c b/arch/tile/kernel/tlb.c
new file mode 100644
index 0000000..2dffc10
--- /dev/null
+++ b/arch/tile/kernel/tlb.c
@@ -0,0 +1,97 @@
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
+ *
+ */
+
+#include <linux/cpumask.h>
+#include <linux/module.h>
+#include <asm/tlbflush.h>
+#include <asm/homecache.h>
+#include <hv/hypervisor.h>
+
+/* From tlbflush.h */
+DEFINE_PER_CPU(int, current_asid);
+int min_asid, max_asid;
+
+/*
+ * Note that we flush the L1I (for VM_EXEC pages) as well as the TLB
+ * so that when we are unmapping an executable page, we also flush it.
+ * Combined with flushing the L1I at context switch time, this means
+ * we don't have to do any other icache flushes.
+ */
+
+void flush_tlb_mm(struct mm_struct *mm)
+{
+	HV_Remote_ASID asids[NR_CPUS];
+	int i = 0, cpu;
+	for_each_cpu(cpu, &mm->cpu_vm_mask) {
+		HV_Remote_ASID *asid = &asids[i++];
+		asid->y = cpu / smp_topology.width;
+		asid->x = cpu % smp_topology.width;
+		asid->asid = per_cpu(current_asid, cpu);
+	}
+	flush_remote(0, HV_FLUSH_EVICT_L1I, &mm->cpu_vm_mask,
+		     0, 0, 0, NULL, asids, i);
+}
+
+void flush_tlb_current_task(void)
+{
+	flush_tlb_mm(current->mm);
+}
+
+void flush_tlb_page_mm(const struct vm_area_struct *vma, struct mm_struct *mm,
+		       unsigned long va)
+{
+	unsigned long size = hv_page_size(vma);
+	int cache = (vma->vm_flags & VM_EXEC) ? HV_FLUSH_EVICT_L1I : 0;
+	flush_remote(0, cache, &mm->cpu_vm_mask,
+		     va, size, size, &mm->cpu_vm_mask, NULL, 0);
+}
+
+void flush_tlb_page(const struct vm_area_struct *vma, unsigned long va)
+{
+	flush_tlb_page_mm(vma, vma->vm_mm, va);
+}
+EXPORT_SYMBOL(flush_tlb_page);
+
+void flush_tlb_range(const struct vm_area_struct *vma,
+		     unsigned long start, unsigned long end)
+{
+	unsigned long size = hv_page_size(vma);
+	struct mm_struct *mm = vma->vm_mm;
+	int cache = (vma->vm_flags & VM_EXEC) ? HV_FLUSH_EVICT_L1I : 0;
+	flush_remote(0, cache, &mm->cpu_vm_mask, start, end - start, size,
+		     &mm->cpu_vm_mask, NULL, 0);
+}
+
+void flush_tlb_all(void)
+{
+	int i;
+	for (i = 0; ; ++i) {
+		HV_VirtAddrRange r = hv_inquire_virtual(i);
+		if (r.size == 0)
+			break;
+		flush_remote(0, HV_FLUSH_EVICT_L1I, cpu_online_mask,
+			     r.start, r.size, PAGE_SIZE, cpu_online_mask,
+			     NULL, 0);
+		flush_remote(0, 0, NULL,
+			     r.start, r.size, HPAGE_SIZE, cpu_online_mask,
+			     NULL, 0);
+	}
+}
+
+void flush_tlb_kernel_range(unsigned long start, unsigned long end)
+{
+	flush_remote(0, HV_FLUSH_EVICT_L1I, cpu_online_mask,
+		     start, end - start, PAGE_SIZE, cpu_online_mask, NULL, 0);
+}
diff --git a/arch/tile/kernel/traps.c b/arch/tile/kernel/traps.c
new file mode 100644
index 0000000..12cb10f
--- /dev/null
+++ b/arch/tile/kernel/traps.c
@@ -0,0 +1,237 @@
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
+#include <linux/sched.h>
+#include <linux/kernel.h>
+#include <linux/kprobes.h>
+#include <linux/module.h>
+#include <linux/reboot.h>
+#include <linux/uaccess.h>
+#include <linux/ptrace.h>
+#include <asm/opcode-tile.h>
+
+#include <arch/interrupts.h>
+#include <arch/spr_def.h>
+
+void __init trap_init(void)
+{
+	/* Nothing needed here since we link code at .intrpt1 */
+}
+
+int unaligned_fixup = 1;
+
+static int __init setup_unaligned_fixup(char *str)
+{
+	/*
+	 * Say "=-1" to completely disable it.  If you just do "=0", we
+	 * will still parse the instruction, then fire a SIGBUS with
+	 * the correct address from inside the single_step code.
+	 */
+	long val;
+	if (strict_strtol(str, 0, &val) != 0)
+		return 0;
+	unaligned_fixup = val;
+	printk("Fixups for unaligned data accesses are %s\n",
+	       unaligned_fixup >= 0 ?
+	       (unaligned_fixup ? "enabled" : "disabled") :
+	       "completely disabled");
+	return 1;
+}
+__setup("unaligned_fixup=", setup_unaligned_fixup);
+
+#if CHIP_HAS_TILE_DMA()
+
+static int dma_disabled;
+
+static int __init nodma(char *str)
+{
+	printk("User-space DMA is disabled\n");
+	dma_disabled = 1;
+	return 1;
+}
+__setup("nodma", nodma);
+
+/* How to decode SPR_GPV_REASON */
+#define IRET_ERROR (1U << 31)
+#define MT_ERROR   (1U << 30)
+#define MF_ERROR   (1U << 29)
+#define SPR_INDEX  ((1U << 15) - 1)
+#define SPR_MPL_SHIFT  9  /* starting bit position for MPL encoded in SPR */
+
+/*
+ * See if this GPV is just to notify the kernel of SPR use and we can
+ * retry the user instruction after adjusting some MPLs suitably.
+ */
+static int retry_gpv(unsigned int gpv_reason)
+{
+	int mpl;
+
+	if (gpv_reason & IRET_ERROR)
+		return 0;
+
+	BUG_ON((gpv_reason & (MT_ERROR|MF_ERROR)) == 0);
+	mpl = (gpv_reason & SPR_INDEX) >> SPR_MPL_SHIFT;
+	if (mpl == INT_DMA_NOTIFY && !dma_disabled) {
+		/* User is turning on DMA. Allow it and retry. */
+		printk(KERN_DEBUG "Process %d/%s is now enabled for DMA\n",
+		       current->pid, current->comm);
+		BUG_ON(current->thread.tile_dma_state.enabled);
+		current->thread.tile_dma_state.enabled = 1;
+		grant_dma_mpls();
+		return 1;
+	}
+
+	return 0;
+}
+
+#endif /* CHIP_HAS_TILE_DMA() */
+
+/* Defined inside do_trap(), below. */
+#ifdef __tilegx__
+extern tilegx_bundle_bits bpt_code;
+#else
+extern tile_bundle_bits bpt_code;
+#endif
+
+void __kprobes do_trap(struct pt_regs *regs, int fault_num,
+		       unsigned long reason)
+{
+	siginfo_t info = { 0 };
+	int signo, code;
+	unsigned long address;
+	__typeof__(bpt_code) instr;
+
+	/* Re-enable interrupts. */
+	local_irq_enable();
+
+	/*
+	 * If it hits in kernel mode and we can't fix it up, just exit the
+	 * current process and hope for the best.
+	 */
+	if (!user_mode(regs)) {
+		if (fixup_exception(regs))  /* only UNALIGN_DATA in practice */
+			return;
+		printk(KERN_ALERT "Kernel took bad trap %d at PC %#lx\n",
+		       fault_num, regs->pc);
+		if (fault_num == INT_GPV)
+			printk(KERN_ALERT "GPV_REASON is %#lx\n", reason);
+		show_regs(regs);
+		do_exit(SIGKILL);  /* FIXME: implement i386 die() */
+		return;
+	}
+
+	switch (fault_num) {
+	case INT_ILL:
+		asm(".pushsection .rodata.bpt_code,\"a\";"
+		    ".align 8;"
+		    "bpt_code: bpt;"
+		    ".size bpt_code,.-bpt_code;"
+		    ".popsection");
+
+		if (copy_from_user(&instr, (void *)regs->pc, sizeof(instr))) {
+			printk(KERN_ERR "Unreadable instruction for INT_ILL:"
+			       " %#lx\n", regs->pc);
+			do_exit(SIGKILL);
+			return;
+		}
+		if (instr == bpt_code) {
+			signo = SIGTRAP;
+			code = TRAP_BRKPT;
+		} else {
+			signo = SIGILL;
+			code = ILL_ILLOPC;
+		}
+		address = regs->pc;
+		break;
+	case INT_GPV:
+#if CHIP_HAS_TILE_DMA()
+		if (retry_gpv(reason))
+			return;
+#endif
+		/*FALLTHROUGH*/
+	case INT_UDN_ACCESS:
+	case INT_IDN_ACCESS:
+#if CHIP_HAS_SN()
+	case INT_SN_ACCESS:
+#endif
+		signo = SIGILL;
+		code = ILL_PRVREG;
+		address = regs->pc;
+		break;
+	case INT_SWINT_3:
+	case INT_SWINT_2:
+	case INT_SWINT_0:
+		signo = SIGILL;
+		code = ILL_ILLTRP;
+		address = regs->pc;
+		break;
+	case INT_UNALIGN_DATA:
+#ifndef __tilegx__  /* FIXME: GX: no single-step yet */
+		if (unaligned_fixup >= 0) {
+			struct single_step_state *state =
+				current_thread_info()->step_state;
+			if (!state || (void *)(regs->pc) != state->buffer) {
+				single_step_once(regs);
+				return;
+			}
+		}
+#endif
+		signo = SIGBUS;
+		code = BUS_ADRALN;
+		address = 0;
+		break;
+	case INT_DOUBLE_FAULT:
+		/*
+		 * For double fault, "reason" is actually passed as
+		 * SYSTEM_SAVE_1_2, the hypervisor's double-fault info, so
+		 * we can provide the original fault number rather than
+		 * the uninteresting "INT_DOUBLE_FAULT" so the user can
+		 * learn what actually struck while PL0 ICS was set.
+		 */
+		fault_num = reason;
+		signo = SIGILL;
+		code = ILL_DBLFLT;
+		address = regs->pc;
+		break;
+#ifdef __tilegx__
+	case INT_ILL_TRANS:
+		signo = SIGSEGV;
+		code = SEGV_MAPERR;
+		if (reason & SPR_ILL_TRANS_REASON__I_STREAM_VA_RMASK)
+			address = regs->pc;
+		else
+			address = 0;  /* FIXME: GX: single-step for address */
+		break;
+#endif
+	default:
+		panic("Unexpected do_trap interrupt number %d", fault_num);
+		return;
+	}
+
+	info.si_signo = signo;
+	info.si_code = code;
+	info.si_addr = (void *)address;
+	if (signo == SIGILL)
+		info.si_trapno = fault_num;
+	force_sig_info(signo, &info, current);
+}
+
+extern void _dump_stack(int dummy, ulong pc, ulong lr, ulong sp, ulong r52);
+
+void kernel_double_fault(int dummy, ulong pc, ulong lr, ulong sp, ulong r52)
+{
+	_dump_stack(dummy, pc, lr, sp, r52);
+	printk("Double fault: exiting\n");
+	machine_halt();
+}
diff --git a/arch/tile/kernel/vmlinux.lds.S b/arch/tile/kernel/vmlinux.lds.S
new file mode 100644
index 0000000..77388c1
--- /dev/null
+++ b/arch/tile/kernel/vmlinux.lds.S
@@ -0,0 +1,98 @@
+#include <asm-generic/vmlinux.lds.h>
+#include <asm/page.h>
+#include <asm/cache.h>
+#include <asm/thread_info.h>
+#include <hv/hypervisor.h>
+
+/* Text loads starting from the supervisor interrupt vector address. */
+#define TEXT_OFFSET MEM_SV_INTRPT
+
+OUTPUT_ARCH(tile)
+ENTRY(_start)
+jiffies = jiffies_64;
+
+PHDRS
+{
+  intrpt1 PT_LOAD ;
+  text PT_LOAD ;
+  data PT_LOAD ;
+}
+SECTIONS
+{
+  /* Text is loaded with a different VA than data; start with text. */
+  #undef LOAD_OFFSET
+  #define LOAD_OFFSET TEXT_OFFSET
+
+  /* Interrupt vectors */
+  .intrpt1 (LOAD_OFFSET) : AT ( 0 )   /* put at the start of physical memory */
+  {
+    _text = .;
+    _stext = .;
+    *(.intrpt1)
+  } :intrpt1 =0
+
+  /* Hypervisor call vectors */
+  #include "hvglue.lds"
+
+  /* Now the real code */
+  . = ALIGN(0x20000);
+  HEAD_TEXT_SECTION :text =0
+  .text : AT (ADDR(.text) - LOAD_OFFSET) {
+    SCHED_TEXT
+    LOCK_TEXT
+    __fix_text_end = .;   /* tile-cpack won't rearrange before this */
+    TEXT_TEXT
+    *(.text.*)
+    *(.coldtext*)
+    *(.fixup)
+    *(.gnu.warning)
+  }
+  _etext = .;
+
+  /* "Init" is divided into two areas with very different virtual addresses. */
+  INIT_TEXT_SECTION(PAGE_SIZE)
+
+  /* Now we skip back to PAGE_OFFSET for the data. */
+  . = (. - TEXT_OFFSET + PAGE_OFFSET);
+  #undef LOAD_OFFSET
+  #define LOAD_OFFSET PAGE_OFFSET
+
+  . = ALIGN(PAGE_SIZE);
+  VMLINUX_SYMBOL(_sinitdata) = .;
+  .init.page : AT (ADDR(.init.page) - LOAD_OFFSET) {
+    *(.init.page)
+  } :data =0
+  INIT_DATA_SECTION(16)
+  PERCPU(PAGE_SIZE)
+  . = ALIGN(PAGE_SIZE);
+  VMLINUX_SYMBOL(_einitdata) = .;
+
+  _sdata = .;                   /* Start of data section */
+
+  RO_DATA_SECTION(PAGE_SIZE)
+
+  /* initially writeable, then read-only */
+  . = ALIGN(PAGE_SIZE);
+  __w1data_begin = .;
+  .w1data : AT(ADDR(.w1data) - LOAD_OFFSET) {
+    VMLINUX_SYMBOL(__w1data_begin) = .;
+    *(.w1data)
+    VMLINUX_SYMBOL(__w1data_end) = .;
+  }
+
+  RW_DATA_SECTION(L2_CACHE_BYTES, PAGE_SIZE, THREAD_SIZE)
+
+  _edata = .;
+
+  EXCEPTION_TABLE(L2_CACHE_BYTES)
+  NOTES
+
+
+  BSS_SECTION(8, PAGE_SIZE, 1)
+  _end = . ;
+
+  STABS_DEBUG
+  DWARF_DEBUG
+
+  DISCARDS
+}
-- 
1.6.5.2

