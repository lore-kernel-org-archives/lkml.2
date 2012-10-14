Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab2JNTX4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 15:23:56 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:50480 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202Ab2JNTXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 15:23:52 -0400
From: Rabin Vincent <rabin@rab.in>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>, oleg@redhat.com,
        Rabin Vincent <rabin@rab.in>, Jon Medhurst <tixy@yxit.co.uk>
Subject: [PATCH 8/9] ARM: support uprobe handling
Date: Sun, 14 Oct 2012 21:23:12 +0200
Message-Id: <1350242593-17761-8-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350242593-17761-1-git-send-email-rabin@rab.in>
References: <1350242593-17761-1-git-send-email-rabin@rab.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extend the kprobes code to handle user-space probes.  Much of the code
can be reused so currently the ARM uprobes code reuses the kprobes
structures.  The decode tables are reused, with the modification that
for those instruction that require custom decoding for uprobes, a new
element is added in the table to specify a custom decoder function.

Thumb is not handled.

Cc: Jon Medhurst <tixy@yxit.co.uk>
Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 arch/arm/include/asm/kprobes.h   |   17 +---
 arch/arm/include/asm/probes.h    |   23 +++++
 arch/arm/kernel/kprobes-arm.c    |   27 +++++-
 arch/arm/kernel/kprobes-common.c |   63 ++++++++++----
 arch/arm/kernel/kprobes-test.c   |   12 ++-
 arch/arm/kernel/kprobes-thumb.c  |   31 ++++---
 arch/arm/kernel/kprobes.c        |    2 +-
 arch/arm/kernel/kprobes.h        |   36 +++++---
 arch/arm/kernel/uprobes-arm.c    |  178 ++++++++++++++++++++++++++++++++++++++
 arch/arm/kernel/uprobes.h        |   23 +++++
 10 files changed, 349 insertions(+), 63 deletions(-)
 create mode 100644 arch/arm/include/asm/probes.h
 create mode 100644 arch/arm/kernel/uprobes-arm.c
 create mode 100644 arch/arm/kernel/uprobes.h

diff --git a/arch/arm/include/asm/kprobes.h b/arch/arm/include/asm/kprobes.h
index f82ec22..53b1a80 100644
--- a/arch/arm/include/asm/kprobes.h
+++ b/arch/arm/include/asm/kprobes.h
@@ -27,22 +27,7 @@
 #define flush_insn_slot(p)		do { } while (0)
 #define kretprobe_blacklist_size	0
 
-typedef u32 kprobe_opcode_t;
-
-struct kprobe;
-typedef void (kprobe_insn_handler_t)(struct kprobe *, struct pt_regs *);
-typedef unsigned long (kprobe_check_cc)(unsigned long);
-typedef void (kprobe_insn_singlestep_t)(struct kprobe *, struct pt_regs *);
-typedef void (kprobe_insn_fn_t)(void);
-
-/* Architecture specific copy of original instruction. */
-struct arch_specific_insn {
-	kprobe_opcode_t			*insn;
-	kprobe_insn_handler_t		*insn_handler;
-	kprobe_check_cc			*insn_check_cc;
-	kprobe_insn_singlestep_t	*insn_singlestep;
-	kprobe_insn_fn_t		*insn_fn;
-};
+#include <asm/probes.h>
 
 struct prev_kprobe {
 	struct kprobe *kp;
diff --git a/arch/arm/include/asm/probes.h b/arch/arm/include/asm/probes.h
new file mode 100644
index 0000000..df46994
--- /dev/null
+++ b/arch/arm/include/asm/probes.h
@@ -0,0 +1,23 @@
+#ifndef _ASM_PROBES_H
+#define _ASM_PROBES_H
+
+#ifdef CONFIG_KPROBES
+typedef u32 kprobe_opcode_t;
+
+struct kprobe;
+typedef void (kprobe_insn_handler_t)(struct kprobe *, struct pt_regs *);
+typedef unsigned long (kprobe_check_cc)(unsigned long);
+typedef void (kprobe_insn_singlestep_t)(struct kprobe *, struct pt_regs *);
+typedef void (kprobe_insn_fn_t)(void);
+
+/* Architecture specific copy of original instruction. */
+struct arch_specific_insn {
+	kprobe_opcode_t			*insn;
+	kprobe_insn_handler_t		*insn_handler;
+	kprobe_check_cc			*insn_check_cc;
+	kprobe_insn_singlestep_t	*insn_singlestep;
+	kprobe_insn_fn_t		*insn_fn;
+};
+#endif
+
+#endif
diff --git a/arch/arm/kernel/kprobes-arm.c b/arch/arm/kernel/kprobes-arm.c
index 8a30c89..d9cf0e2 100644
--- a/arch/arm/kernel/kprobes-arm.c
+++ b/arch/arm/kernel/kprobes-arm.c
@@ -62,6 +62,7 @@
 #include <linux/kprobes.h>
 #include <linux/module.h>
 
+#include "uprobes.h"
 #include "kprobes.h"
 
 #define sign_extend(x, signbit) ((x) | (0 - ((x) & (1 << (signbit)))))
@@ -545,31 +546,37 @@ static const union decode_item arm_cccc_000x_____1xx1_table[] = {
 
 	/* LDRD (register)	cccc 000x x0x0 xxxx xxxx xxxx 1101 xxxx */
 	/* STRD (register)	cccc 000x x0x0 xxxx xxxx xxxx 1111 xxxx */
+	UDECODE_NEXT (decode_pc_ro)
 	DECODE_EMULATEX	(0x0e5000d0, 0x000000d0, emulate_ldrdstrd,
 						 REGS(NOPCWB, NOPCX, 0, 0, NOPC)),
 
 	/* LDRD (immediate)	cccc 000x x1x0 xxxx xxxx xxxx 1101 xxxx */
 	/* STRD (immediate)	cccc 000x x1x0 xxxx xxxx xxxx 1111 xxxx */
+	UDECODE_NEXT (decode_pc_ro)
 	DECODE_EMULATEX	(0x0e5000d0, 0x004000d0, emulate_ldrdstrd,
 						 REGS(NOPCWB, NOPCX, 0, 0, 0)),
 
 	/* STRH (register)	cccc 000x x0x0 xxxx xxxx xxxx 1011 xxxx */
+	UDECODE_NEXT (decode_pc_ro)
 	DECODE_EMULATEX	(0x0e5000f0, 0x000000b0, emulate_str,
 						 REGS(NOPCWB, NOPC, 0, 0, NOPC)),
 
 	/* LDRH (register)	cccc 000x x0x1 xxxx xxxx xxxx 1011 xxxx */
 	/* LDRSB (register)	cccc 000x x0x1 xxxx xxxx xxxx 1101 xxxx */
 	/* LDRSH (register)	cccc 000x x0x1 xxxx xxxx xxxx 1111 xxxx */
+	UDECODE_NEXT (decode_pc_ro)
 	DECODE_EMULATEX	(0x0e500090, 0x00100090, emulate_ldr,
 						 REGS(NOPCWB, NOPC, 0, 0, NOPC)),
 
 	/* STRH (immediate)	cccc 000x x1x0 xxxx xxxx xxxx 1011 xxxx */
+	UDECODE_NEXT (decode_pc_ro)
 	DECODE_EMULATEX	(0x0e5000f0, 0x004000b0, emulate_str,
 						 REGS(NOPCWB, NOPC, 0, 0, 0)),
 
 	/* LDRH (immediate)	cccc 000x x1x1 xxxx xxxx xxxx 1011 xxxx */
 	/* LDRSB (immediate)	cccc 000x x1x1 xxxx xxxx xxxx 1101 xxxx */
 	/* LDRSH (immediate)	cccc 000x x1x1 xxxx xxxx xxxx 1111 xxxx */
+	UDECODE_NEXT (decode_pc_ro)
 	DECODE_EMULATEX	(0x0e500090, 0x00500090, emulate_ldr,
 						 REGS(NOPCWB, NOPC, 0, 0, 0)),
 
@@ -589,11 +596,13 @@ static const union decode_item arm_cccc_000x_table[] = {
 	/* TEQ (register)	cccc 0001 0011 xxxx xxxx xxxx xxx0 xxxx */
 	/* CMP (register)	cccc 0001 0101 xxxx xxxx xxxx xxx0 xxxx */
 	/* CMN (register)	cccc 0001 0111 xxxx xxxx xxxx xxx0 xxxx */
+	UDECODE_NEXT (decode_rd12rn16rm0rs8_rwflags)
 	DECODE_EMULATEX	(0x0f900010, 0x01100000, emulate_rd12rn16rm0rs8_rwflags,
 						 REGS(ANY, 0, 0, 0, ANY)),
 
 	/* MOV (register)	cccc 0001 101x xxxx xxxx xxxx xxx0 xxxx */
 	/* MVN (register)	cccc 0001 111x xxxx xxxx xxxx xxx0 xxxx */
+	UDECODE_NEXT (decode_rd12rn16rm0rs8_rwflags)
 	DECODE_EMULATEX	(0x0fa00010, 0x01a00000, emulate_rd12rn16rm0rs8_rwflags,
 						 REGS(0, ANY, 0, 0, ANY)),
 
@@ -607,6 +616,7 @@ static const union decode_item arm_cccc_000x_table[] = {
 	/* RSC (register)	cccc 0000 111x xxxx xxxx xxxx xxx0 xxxx */
 	/* ORR (register)	cccc 0001 100x xxxx xxxx xxxx xxx0 xxxx */
 	/* BIC (register)	cccc 0001 110x xxxx xxxx xxxx xxx0 xxxx */
+	UDECODE_NEXT (decode_rd12rn16rm0rs8_rwflags)
 	DECODE_EMULATEX	(0x0e000010, 0x00000000, emulate_rd12rn16rm0rs8_rwflags,
 						 REGS(ANY, ANY, 0, 0, ANY)),
 
@@ -614,11 +624,13 @@ static const union decode_item arm_cccc_000x_table[] = {
 	/* TEQ (reg-shift reg)	cccc 0001 0011 xxxx xxxx xxxx 0xx1 xxxx */
 	/* CMP (reg-shift reg)	cccc 0001 0101 xxxx xxxx xxxx 0xx1 xxxx */
 	/* CMN (reg-shift reg)	cccc 0001 0111 xxxx xxxx xxxx 0xx1 xxxx */
+	UDECODE_NEXT (decode_rd12rn16rm0rs8_rwflags)
 	DECODE_EMULATEX	(0x0f900090, 0x01100010, emulate_rd12rn16rm0rs8_rwflags,
 						 REGS(ANY, 0, NOPC, 0, ANY)),
 
 	/* MOV (reg-shift reg)	cccc 0001 101x xxxx xxxx xxxx 0xx1 xxxx */
 	/* MVN (reg-shift reg)	cccc 0001 111x xxxx xxxx xxxx 0xx1 xxxx */
+	UDECODE_NEXT (decode_rd12rn16rm0rs8_rwflags)
 	DECODE_EMULATEX	(0x0fa00090, 0x01a00010, emulate_rd12rn16rm0rs8_rwflags,
 						 REGS(0, ANY, NOPC, 0, ANY)),
 
@@ -632,6 +644,7 @@ static const union decode_item arm_cccc_000x_table[] = {
 	/* RSC (reg-shift reg)	cccc 0000 111x xxxx xxxx xxxx 0xx1 xxxx */
 	/* ORR (reg-shift reg)	cccc 0001 100x xxxx xxxx xxxx 0xx1 xxxx */
 	/* BIC (reg-shift reg)	cccc 0001 110x xxxx xxxx xxxx 0xx1 xxxx */
+	UDECODE_NEXT (decode_rd12rn16rm0rs8_rwflags)
 	DECODE_EMULATEX	(0x0e000090, 0x00000010, emulate_rd12rn16rm0rs8_rwflags,
 						 REGS(ANY, ANY, NOPC, 0, ANY)),
 
@@ -666,11 +679,13 @@ static const union decode_item arm_cccc_001x_table[] = {
 	/* TEQ (immediate)	cccc 0011 0011 xxxx xxxx xxxx xxxx xxxx */
 	/* CMP (immediate)	cccc 0011 0101 xxxx xxxx xxxx xxxx xxxx */
 	/* CMN (immediate)	cccc 0011 0111 xxxx xxxx xxxx xxxx xxxx */
+	UDECODE_NEXT (decode_rd12rn16rm0rs8_rwflags)
 	DECODE_EMULATEX	(0x0f900000, 0x03100000, emulate_rd12rn16rm0rs8_rwflags,
 						 REGS(ANY, 0, 0, 0, 0)),
 
 	/* MOV (immediate)	cccc 0011 101x xxxx xxxx xxxx xxxx xxxx */
 	/* MVN (immediate)	cccc 0011 111x xxxx xxxx xxxx xxxx xxxx */
+	UDECODE_NEXT (decode_rd12rn16rm0rs8_rwflags)
 	DECODE_EMULATEX	(0x0fa00000, 0x03a00000, emulate_rd12rn16rm0rs8_rwflags,
 						 REGS(0, ANY, 0, 0, 0)),
 
@@ -684,6 +699,7 @@ static const union decode_item arm_cccc_001x_table[] = {
 	/* RSC (immediate)	cccc 0010 111x xxxx xxxx xxxx xxxx xxxx */
 	/* ORR (immediate)	cccc 0011 100x xxxx xxxx xxxx xxxx xxxx */
 	/* BIC (immediate)	cccc 0011 110x xxxx xxxx xxxx xxxx xxxx */
+	UDECODE_NEXT (decode_rd12rn16rm0rs8_rwflags)
 	DECODE_EMULATEX	(0x0e000000, 0x02000000, emulate_rd12rn16rm0rs8_rwflags,
 						 REGS(ANY, ANY, 0, 0, 0)),
 
@@ -850,21 +866,25 @@ static const union decode_item arm_cccc_01xx_table[] = {
 
 	/* STR (immediate)	cccc 010x x0x0 xxxx xxxx xxxx xxxx xxxx */
 	/* STRB (immediate)	cccc 010x x1x0 xxxx xxxx xxxx xxxx xxxx */
+	UDECODE_NEXT (decode_pc_ro)
 	DECODE_EMULATEX	(0x0e100000, 0x04000000, emulate_str,
 						 REGS(NOPCWB, ANY, 0, 0, 0)),
 
 	/* LDR (immediate)	cccc 010x x0x1 xxxx xxxx xxxx xxxx xxxx */
 	/* LDRB (immediate)	cccc 010x x1x1 xxxx xxxx xxxx xxxx xxxx */
+	UDECODE_NEXT (decode_ldr)
 	DECODE_EMULATEX	(0x0e100000, 0x04100000, emulate_ldr,
 						 REGS(NOPCWB, ANY, 0, 0, 0)),
 
 	/* STR (register)	cccc 011x x0x0 xxxx xxxx xxxx xxxx xxxx */
 	/* STRB (register)	cccc 011x x1x0 xxxx xxxx xxxx xxxx xxxx */
+	UDECODE_NEXT (decode_pc_ro)
 	DECODE_EMULATEX	(0x0e100000, 0x06000000, emulate_str,
 						 REGS(NOPCWB, ANY, 0, 0, NOPC)),
 
 	/* LDR (register)	cccc 011x x0x1 xxxx xxxx xxxx xxxx xxxx */
 	/* LDRB (register)	cccc 011x x1x1 xxxx xxxx xxxx xxxx xxxx */
+	UDECODE_NEXT (decode_ldr)
 	DECODE_EMULATEX	(0x0e100000, 0x06100000, emulate_ldr,
 						 REGS(NOPCWB, ANY, 0, 0, NOPC)),
 
@@ -876,6 +896,7 @@ static const union decode_item arm_cccc_100x_table[] = {
 
 	/* LDM			cccc 100x x0x1 xxxx xxxx xxxx xxxx xxxx */
 	/* STM			cccc 100x x0x0 xxxx xxxx xxxx xxxx xxxx */
+	UDECODE_NEXT (uprobe_decode_ldmstm)
 	DECODE_CUSTOM	(0x0e400000, 0x08000000, kprobe_decode_ldmstm),
 
 	/* STM (user registers)	cccc 100x x1x0 xxxx xxxx xxxx xxxx xxxx */
@@ -997,9 +1018,11 @@ static void __kprobes arm_singlestep(struct kprobe *p, struct pt_regs *regs)
  *   should also be very rare.
  */
 enum kprobe_insn __kprobes
-arm_kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi)
+arm_kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
+		       bool uprobe)
 {
 	asi->insn_singlestep = arm_singlestep;
 	asi->insn_check_cc = kprobe_condition_checks[insn>>28];
-	return kprobe_decode_insn(insn, asi, kprobe_decode_arm_table, false);
+	return kprobe_decode_insn(insn, asi, kprobe_decode_arm_table, false,
+				  uprobe);
 }
diff --git a/arch/arm/kernel/kprobes-common.c b/arch/arm/kernel/kprobes-common.c
index 18a7628..f811bfb 100644
--- a/arch/arm/kernel/kprobes-common.c
+++ b/arch/arm/kernel/kprobes-common.c
@@ -277,7 +277,8 @@ emulate_ldm_r3_15(struct kprobe *p, struct pt_regs *regs)
 }
 
 enum kprobe_insn __kprobes
-kprobe_decode_ldmstm(kprobe_opcode_t insn, struct arch_specific_insn *asi)
+kprobe_decode_ldmstm(kprobe_opcode_t insn, struct arch_specific_insn *asi,
+		     void *d)
 {
 	kprobe_insn_handler_t *handler = 0;
 	unsigned reglist = insn & 0xffff;
@@ -389,7 +390,7 @@ set_emulated_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
  * non-zero value, the corresponding nibble in pinsn is validated and modified
  * according to the type.
  */
-static bool __kprobes decode_regs(kprobe_opcode_t* pinsn, u32 regs)
+static bool __kprobes decode_regs(kprobe_opcode_t *pinsn, u32 regs, bool modify)
 {
 	kprobe_opcode_t insn = *pinsn;
 	kprobe_opcode_t mask = 0xf; /* Start at least significant nibble */
@@ -450,12 +451,16 @@ static bool __kprobes decode_regs(kprobe_opcode_t* pinsn, u32 regs)
 			break;
 		}
 
-		/* Replace value of nibble with new register number... */
-		insn &= ~mask;
-		insn |= new_bits & mask;
+		if (modify) {
+			/* Replace value of nibble with new register number */
+			insn &= ~mask;
+			insn |= new_bits & mask;
+		}
 	}
 
-	*pinsn = insn;
+	if (modify)
+		*pinsn = insn;
+
 	return true;
 
 reject:
@@ -468,7 +473,8 @@ static const int decode_struct_sizes[NUM_DECODE_TYPES] = {
 	[DECODE_TYPE_SIMULATE]	= sizeof(struct decode_simulate),
 	[DECODE_TYPE_EMULATE]	= sizeof(struct decode_emulate),
 	[DECODE_TYPE_OR]	= sizeof(struct decode_or),
-	[DECODE_TYPE_REJECT]	= sizeof(struct decode_reject)
+	[DECODE_TYPE_REJECT]	= sizeof(struct decode_reject),
+	[UDECODE_TYPE_NEXT]	= sizeof(struct decode_header)
 };
 
 /*
@@ -516,13 +522,17 @@ static const int decode_struct_sizes[NUM_DECODE_TYPES] = {
  */
 int __kprobes
 kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
-				const union decode_item *table, bool thumb)
+				const union decode_item *table, bool thumb,
+				bool uprobe)
 {
+	enum kprobe_insn (*decoder)(kprobe_opcode_t,
+			  struct arch_specific_insn *, void *d) = NULL;
 	const struct decode_header *h = (struct decode_header *)table;
 	const struct decode_header *next;
 	bool matched = false;
 
-	insn = prepare_emulated_insn(insn, asi, thumb);
+	if (!uprobe)
+		insn = prepare_emulated_insn(insn, asi, thumb);
 
 	for (;; h = next) {
 		enum decode_type type = h->type_regs.bits & DECODE_TYPE_MASK;
@@ -534,13 +544,24 @@ kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
 		next = (struct decode_header *)
 				((uintptr_t)h + decode_struct_sizes[type]);
 
-		if (!matched && (insn & h->mask.bits) != h->value.bits)
+		if (!uprobe && type == UDECODE_TYPE_NEXT)
 			continue;
 
-		if (!decode_regs(&insn, regs))
-			return INSN_REJECTED;
+		if (type != UDECODE_TYPE_NEXT) {
+			if (!matched &&
+			    (insn & h->mask.bits) != h->value.bits) {
+				decoder = NULL;
+				continue;
+			}
+
+			if (!decode_regs(&insn, regs, !uprobe))
+				return INSN_REJECTED;
+		}
 
 		switch (type) {
+		case UDECODE_TYPE_NEXT:
+			decoder = h->mask.decoder;
+			break;
 
 		case DECODE_TYPE_TABLE: {
 			struct decode_table *d = (struct decode_table *)h;
@@ -550,7 +571,11 @@ kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
 
 		case DECODE_TYPE_CUSTOM: {
 			struct decode_custom *d = (struct decode_custom *)h;
-			return (*d->decoder.decoder)(insn, asi);
+
+			if (decoder)
+				return decoder(insn, asi, d);
+
+			return (*d->decoder.decoder)(insn, asi, d);
 		}
 
 		case DECODE_TYPE_SIMULATE: {
@@ -561,8 +586,14 @@ kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
 
 		case DECODE_TYPE_EMULATE: {
 			struct decode_emulate *d = (struct decode_emulate *)h;
-			asi->insn_handler = d->handler.handler;
-			set_emulated_insn(insn, asi, thumb);
+
+			if (decoder)
+				return decoder(insn, asi, d);
+
+			if (!uprobe) {
+				asi->insn_handler = d->handler.handler;
+				set_emulated_insn(insn, asi, thumb);
+			}
 			return INSN_GOOD;
 		}
 
@@ -574,5 +605,5 @@ kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
 		default:
 			return INSN_REJECTED;
 		}
-		}
 	}
+}
diff --git a/arch/arm/kernel/kprobes-test.c b/arch/arm/kernel/kprobes-test.c
index 1862d8f..a2d4213 100644
--- a/arch/arm/kernel/kprobes-test.c
+++ b/arch/arm/kernel/kprobes-test.c
@@ -630,7 +630,8 @@ static const int decode_struct_sizes[NUM_DECODE_TYPES] = {
 	[DECODE_TYPE_SIMULATE]	= sizeof(struct decode_simulate),
 	[DECODE_TYPE_EMULATE]	= sizeof(struct decode_emulate),
 	[DECODE_TYPE_OR]	= sizeof(struct decode_or),
-	[DECODE_TYPE_REJECT]	= sizeof(struct decode_reject)
+	[DECODE_TYPE_REJECT]	= sizeof(struct decode_reject),
+	[UDECODE_TYPE_NEXT]	= sizeof(struct decode_header)
 };
 
 static int table_iter(const union decode_item *table,
@@ -646,9 +647,11 @@ static int table_iter(const union decode_item *table,
 		if (type == DECODE_TYPE_END)
 			return 0;
 
-		result = fn(h, args);
-		if (result)
-			return result;
+		if (type != UDECODE_TYPE_NEXT) {
+			result = fn(h, args);
+			if (result)
+				return result;
+		}
 
 		h = (struct decode_header *)
 			((uintptr_t)h + decode_struct_sizes[type]);
@@ -918,6 +921,7 @@ static void coverage_add(kprobe_opcode_t insn)
 			break;
 
 		case DECODE_TYPE_REJECT:
+		case UDECODE_TYPE_NEXT:
 		default:
 			return;
 		}
diff --git a/arch/arm/kernel/kprobes-thumb.c b/arch/arm/kernel/kprobes-thumb.c
index 6123daf..761aa55 100644
--- a/arch/arm/kernel/kprobes-thumb.c
+++ b/arch/arm/kernel/kprobes-thumb.c
@@ -83,7 +83,8 @@ t32_simulate_cond_branch(struct kprobe *p, struct pt_regs *regs)
 }
 
 static enum kprobe_insn __kprobes
-t32_decode_cond_branch(kprobe_opcode_t insn, struct arch_specific_insn *asi)
+t32_decode_cond_branch(kprobe_opcode_t insn, struct arch_specific_insn *asi,
+		       void *d)
 {
 	int cc = (insn >> 22) & 0xf;
 	asi->insn_check_cc = kprobe_condition_checks[cc];
@@ -158,9 +159,10 @@ t32_simulate_ldr_literal(struct kprobe *p, struct pt_regs *regs)
 }
 
 static enum kprobe_insn __kprobes
-t32_decode_ldmstm(kprobe_opcode_t insn, struct arch_specific_insn *asi)
+t32_decode_ldmstm(kprobe_opcode_t insn, struct arch_specific_insn *asi,
+		  void *d)
 {
-	enum kprobe_insn ret = kprobe_decode_ldmstm(insn, asi);
+	enum kprobe_insn ret = kprobe_decode_ldmstm(insn, asi, d);
 
 	/* Fixup modified instruction to have halfwords in correct order...*/
 	insn = asi->insn[0];
@@ -1046,7 +1048,7 @@ t16_singlestep_it(struct kprobe *p, struct pt_regs *regs)
 }
 
 static enum kprobe_insn __kprobes
-t16_decode_it(kprobe_opcode_t insn, struct arch_specific_insn *asi)
+t16_decode_it(kprobe_opcode_t insn, struct arch_specific_insn *asi, void *d)
 {
 	asi->insn_singlestep = t16_singlestep_it;
 	return INSN_GOOD_NO_SLOT;
@@ -1063,7 +1065,8 @@ t16_simulate_cond_branch(struct kprobe *p, struct pt_regs *regs)
 }
 
 static enum kprobe_insn __kprobes
-t16_decode_cond_branch(kprobe_opcode_t insn, struct arch_specific_insn *asi)
+t16_decode_cond_branch(kprobe_opcode_t insn, struct arch_specific_insn *asi,
+		       void *d)
 {
 	int cc = (insn >> 8) & 0xf;
 	asi->insn_check_cc = kprobe_condition_checks[cc];
@@ -1149,7 +1152,7 @@ t16_emulate_hiregs(struct kprobe *p, struct pt_regs *regs)
 }
 
 static enum kprobe_insn __kprobes
-t16_decode_hiregs(kprobe_opcode_t insn, struct arch_specific_insn *asi)
+t16_decode_hiregs(kprobe_opcode_t insn, struct arch_specific_insn *asi, void *d)
 {
 	insn &= ~0x00ff;
 	insn |= 0x001; /* Set Rdn = R1 and Rm = R0 */
@@ -1175,7 +1178,7 @@ t16_emulate_push(struct kprobe *p, struct pt_regs *regs)
 }
 
 static enum kprobe_insn __kprobes
-t16_decode_push(kprobe_opcode_t insn, struct arch_specific_insn *asi)
+t16_decode_push(kprobe_opcode_t insn, struct arch_specific_insn *asi, void *d)
 {
 	/*
 	 * To simulate a PUSH we use a Thumb-2 "STMDB R9!, {registers}"
@@ -1225,7 +1228,7 @@ t16_emulate_pop_pc(struct kprobe *p, struct pt_regs *regs)
 }
 
 static enum kprobe_insn __kprobes
-t16_decode_pop(kprobe_opcode_t insn, struct arch_specific_insn *asi)
+t16_decode_pop(kprobe_opcode_t insn, struct arch_specific_insn *asi, void *d)
 {
 	/*
 	 * To simulate a POP we use a Thumb-2 "LDMDB R9!, {registers}"
@@ -1453,17 +1456,21 @@ static void __kprobes thumb32_singlestep(struct kprobe *p, struct pt_regs *regs)
 }
 
 enum kprobe_insn __kprobes
-thumb16_kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi)
+thumb16_kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
+			   bool uprobes)
 {
 	asi->insn_singlestep = thumb16_singlestep;
 	asi->insn_check_cc = thumb_check_cc;
-	return kprobe_decode_insn(insn, asi, kprobe_decode_thumb16_table, true);
+	return kprobe_decode_insn(insn, asi, kprobe_decode_thumb16_table, true,
+				  uprobes);
 }
 
 enum kprobe_insn __kprobes
-thumb32_kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi)
+thumb32_kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
+			   bool uprobes)
 {
 	asi->insn_singlestep = thumb32_singlestep;
 	asi->insn_check_cc = thumb_check_cc;
-	return kprobe_decode_insn(insn, asi, kprobe_decode_thumb32_table, true);
+	return kprobe_decode_insn(insn, asi, kprobe_decode_thumb32_table, true,
+				  uprobes);
 }
diff --git a/arch/arm/kernel/kprobes.c b/arch/arm/kernel/kprobes.c
index 4dd41fc..1b2a324 100644
--- a/arch/arm/kernel/kprobes.c
+++ b/arch/arm/kernel/kprobes.c
@@ -80,7 +80,7 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
 	p->opcode = insn;
 	p->ainsn.insn = tmp_insn;
 
-	switch ((*decode_insn)(insn, &p->ainsn)) {
+	switch ((*decode_insn)(insn, &p->ainsn, false)) {
 	case INSN_REJECTED:	/* not supported */
 		return -EINVAL;
 
diff --git a/arch/arm/kernel/kprobes.h b/arch/arm/kernel/kprobes.h
index 38945f7..442a161 100644
--- a/arch/arm/kernel/kprobes.h
+++ b/arch/arm/kernel/kprobes.h
@@ -35,20 +35,19 @@ enum kprobe_insn {
 };
 
 typedef enum kprobe_insn (kprobe_decode_insn_t)(kprobe_opcode_t,
-						struct arch_specific_insn *);
-
-#ifdef CONFIG_THUMB2_KERNEL
+						struct arch_specific_insn *,
+						bool uprobes);
 
 enum kprobe_insn thumb16_kprobe_decode_insn(kprobe_opcode_t,
-						struct arch_specific_insn *);
+					    struct arch_specific_insn *,
+					    bool uprobes);
 enum kprobe_insn thumb32_kprobe_decode_insn(kprobe_opcode_t,
-						struct arch_specific_insn *);
-
-#else /* !CONFIG_THUMB2_KERNEL */
+					    struct arch_specific_insn *,
+					    bool uprobes);
 
 enum kprobe_insn arm_kprobe_decode_insn(kprobe_opcode_t,
-					struct arch_specific_insn *);
-#endif
+					struct arch_specific_insn *,
+					bool uprobes);
 
 void __init arm_kprobe_decode_init(void);
 
@@ -165,7 +164,8 @@ void __kprobes kprobe_simulate_nop(struct kprobe *p, struct pt_regs *regs);
 void __kprobes kprobe_emulate_none(struct kprobe *p, struct pt_regs *regs);
 
 enum kprobe_insn __kprobes
-kprobe_decode_ldmstm(kprobe_opcode_t insn, struct arch_specific_insn *asi);
+kprobe_decode_ldmstm(kprobe_opcode_t insn, struct arch_specific_insn *asi,
+		     void *d);
 
 /*
  * Test if load/store instructions writeback the address register.
@@ -292,6 +292,7 @@ enum decode_type {
 	DECODE_TYPE_EMULATE,
 	DECODE_TYPE_OR,
 	DECODE_TYPE_REJECT,
+	UDECODE_TYPE_NEXT,
 	NUM_DECODE_TYPES /* Must be last enum */
 };
 
@@ -331,7 +332,9 @@ union decode_item {
 	u32			bits;
 	const union decode_item	*table;
 	kprobe_insn_handler_t	*handler;
-	kprobe_decode_insn_t	*decoder;
+	enum kprobe_insn (*decoder)(kprobe_opcode_t,
+				    struct arch_specific_insn *,
+				    void *d);
 };
 
 
@@ -396,6 +399,14 @@ struct decode_emulate {
 #define DECODE_EMULATE(_mask, _value, _handler)		\
 	DECODE_EMULATEX(_mask, _value, _handler, 0)
 
+#ifdef CONFIG_UPROBES
+#define UDECODE_NEXT(_decoder)				\
+	{.bits = UDECODE_TYPE_NEXT },			\
+	{.decoder = _decoder},				\
+	{.bits = 0 },
+#else
+#define UDECODE_NEXT(_decoder)
+#endif
 
 struct decode_or {
 	struct decode_header	header;
@@ -422,7 +433,8 @@ extern const union decode_item kprobe_decode_arm_table[];
 
 
 int kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
-			const union decode_item *table, bool thumb16);
+			const union decode_item *table, bool thumb16,
+			bool uprobe);
 
 
 #endif /* _ARM_KERNEL_KPROBES_H */
diff --git a/arch/arm/kernel/uprobes-arm.c b/arch/arm/kernel/uprobes-arm.c
new file mode 100644
index 0000000..8d7de10
--- /dev/null
+++ b/arch/arm/kernel/uprobes-arm.c
@@ -0,0 +1,178 @@
+#include <linux/kernel.h>
+#include <linux/kprobes.h>
+#include <linux/uprobes.h>
+#include <linux/module.h>
+
+#include "uprobes.h"
+#include "kprobes.h"
+
+static int uprobes_substitute_pc(kprobe_opcode_t *pinsn, u32 oregs)
+{
+	kprobe_opcode_t insn = *pinsn;
+	kprobe_opcode_t temp;
+	kprobe_opcode_t mask;
+	int freereg;
+	u32 free = 0xffff;
+	u32 regs;
+
+	for (regs = oregs; regs; regs >>= 4, insn >>= 4) {
+		if ((regs & 0xf) == REG_TYPE_NONE)
+			continue;
+
+		free &= ~(1 << (insn & 0xf));
+	}
+
+	/* No PC, no problem */
+	if (free & (1 << 15))
+		return 15;
+
+	if (!free)
+		return -1;
+
+	/*
+	 * fls instead of ffs ensures that for "ldrd r0, r1, [pc]" we would
+	 * pick LR instead of R1.
+	 */
+	freereg = free = fls(free) - 1;
+
+	temp = *pinsn;
+	insn = *pinsn;
+	regs = oregs;
+	mask = 0xf;
+
+	for (; regs; regs >>= 4, mask <<= 4, free <<= 4, temp >>= 4) {
+		if ((regs & 0xf) == REG_TYPE_NONE)
+			continue;
+
+		if ((temp & 0xf) != 15)
+			continue;
+
+		insn &= ~mask;
+		insn |= free & mask;
+	}
+
+	*pinsn = insn;
+	return freereg;
+}
+
+static void uprobe_set_pc(struct arch_uprobe *auprobe,
+			  struct arch_uprobe_task *autask,
+			  struct pt_regs *regs)
+{
+	u32 pcreg = auprobe->pcreg;
+
+	autask->backup = regs->uregs[pcreg];
+	regs->uregs[pcreg] = regs->ARM_pc + 8;
+}
+
+static void uprobe_unset_pc(struct arch_uprobe *auprobe,
+			    struct arch_uprobe_task *autask,
+			    struct pt_regs *regs)
+{
+	/* PC will be taken care of by common code */
+	regs->uregs[auprobe->pcreg] = autask->backup;
+}
+
+static void uprobe_aluwrite_pc(struct arch_uprobe *auprobe,
+			       struct arch_uprobe_task *autask,
+			       struct pt_regs *regs)
+{
+	u32 pcreg = auprobe->pcreg;
+
+	alu_write_pc(regs->uregs[pcreg], regs);
+	regs->uregs[pcreg] = autask->backup;
+}
+
+static void uprobe_write_pc(struct arch_uprobe *auprobe,
+			    struct arch_uprobe_task *autask,
+			    struct pt_regs *regs)
+{
+	u32 pcreg = auprobe->pcreg;
+
+	load_write_pc(regs->uregs[pcreg], regs);
+	regs->uregs[pcreg] = autask->backup;
+}
+
+enum kprobe_insn
+decode_pc_ro(kprobe_opcode_t insn, struct arch_specific_insn *asi, void *d)
+{
+	struct arch_uprobe *auprobe = container_of(asi, struct arch_uprobe, asi);
+	struct decode_emulate *decode = d;
+	u32 regs = decode->header.type_regs.bits >> DECODE_TYPE_BITS;
+	int reg;
+
+	reg = uprobes_substitute_pc(&auprobe->modinsn, regs);
+	if (reg == 15)
+		return INSN_GOOD;
+
+	if (reg == -1)
+		return INSN_REJECTED;
+
+	auprobe->pcreg = reg;
+	auprobe->prehandler = uprobe_set_pc;
+	auprobe->posthandler = uprobe_unset_pc;
+
+	return INSN_GOOD;
+}
+
+enum kprobe_insn
+decode_wb_pc(kprobe_opcode_t insn, struct arch_specific_insn *asi,
+	     void *d, bool alu)
+{
+	struct arch_uprobe *auprobe = container_of(asi, struct arch_uprobe, asi);
+	enum kprobe_insn ret = decode_pc_ro(insn, asi, d);
+
+	if (((insn >> 12) & 0xf) == 15)
+		auprobe->posthandler = alu ? uprobe_aluwrite_pc
+					   : uprobe_write_pc;
+
+	return ret;
+}
+
+enum kprobe_insn
+decode_rd12rn16rm0rs8_rwflags(kprobe_opcode_t insn,
+			      struct arch_specific_insn *asi, void *d)
+{
+	return decode_wb_pc(insn, asi, d, true);
+}
+
+enum kprobe_insn
+decode_ldr(kprobe_opcode_t insn, struct arch_specific_insn *asi, void *d)
+{
+	return decode_wb_pc(insn, asi, d, false);
+}
+
+enum kprobe_insn
+uprobe_decode_ldmstm(kprobe_opcode_t insn,
+		     struct arch_specific_insn *asi, void *d)
+{
+	struct arch_uprobe *auprobe = container_of(asi, struct arch_uprobe,
+						   asi);
+	unsigned reglist = insn & 0xffff;
+	int rn = (insn >> 16) & 0xf;
+	int lbit = insn & (1 << 20);
+	unsigned used = reglist | (1 << rn);
+
+	if (rn == 15)
+		return INSN_REJECTED;
+
+	if (!(used & (1 << 15)))
+		return INSN_GOOD;
+
+	if (used & (1 << 14))
+		return INSN_REJECTED;
+
+	/* Use LR instead of PC */
+	insn ^= 0xc000;
+
+	auprobe->pcreg = 14;
+	auprobe->modinsn = insn;
+
+	auprobe->prehandler = uprobe_set_pc;
+	if (lbit)
+		auprobe->posthandler = uprobe_write_pc;
+	else
+		auprobe->posthandler = uprobe_unset_pc;
+
+	return INSN_GOOD;
+}
diff --git a/arch/arm/kernel/uprobes.h b/arch/arm/kernel/uprobes.h
new file mode 100644
index 0000000..a1a4897
--- /dev/null
+++ b/arch/arm/kernel/uprobes.h
@@ -0,0 +1,23 @@
+#ifndef __ARM_KERNEL_UPROBES_H
+#define __ARM_KERNEL_UPROBES_H
+
+enum kprobe_insn uprobe_decode_ldmstm(kprobe_opcode_t insn,
+				      struct arch_specific_insn *asi,
+				      void *d);
+
+enum kprobe_insn decode_ldr(kprobe_opcode_t insn,
+			    struct arch_specific_insn *asi,
+			    void *d);
+
+enum kprobe_insn
+decode_rd12rn16rm0rs8_rwflags(kprobe_opcode_t insn,
+			      struct arch_specific_insn *asi, void *d);
+
+enum kprobe_insn
+decode_wb_pc(kprobe_opcode_t insn, struct arch_specific_insn *asi,
+	     void *d, bool alu);
+
+enum kprobe_insn
+decode_pc_ro(kprobe_opcode_t insn, struct arch_specific_insn *asi, void *d);
+
+#endif
-- 
1.7.9.5

