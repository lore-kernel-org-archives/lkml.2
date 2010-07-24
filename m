Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822Ab0GXBmg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 21:42:36 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:16621 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757953Ab0GXBmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 21:42:18 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org, wim@iguana.be
Cc: linux-kernel@vger.kernel.org, David Daney <ddaney@caviumnetworks.com>
Subject: [PATCH 3/7] MIPS: Add option to export uasm API.
Date: Fri, 23 Jul 2010 18:41:43 -0700
Message-Id: <1279935707-3997-4-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1279935707-3997-1-git-send-email-ddaney@caviumnetworks.com>
References: <1279935707-3997-1-git-send-email-ddaney@caviumnetworks.com>
X-OriginalArrivalTime: 24 Jul 2010 01:42:18.0359 (UTC) FILETIME=[73724070:01CB2AD1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A 'select EXPORT_UASM' in Kconfig will cause the uasm to be exported
for use in modules.  When it is exported, all the uasm data and code
cease to be __init and __initdata.

Also daddiu_bug cannot be __cpuinitdata if uasm is exported.  The
cleanest thing is to just make it normal data.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
---
 arch/mips/Kconfig             |    3 +
 arch/mips/include/asm/uasm.h  |   37 ++++++++----
 arch/mips/kernel/cpu-bugs64.c |    2 +-
 arch/mips/mm/uasm.c           |  131 +++++++++++++++++++++++++---------------
 4 files changed, 110 insertions(+), 63 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index cdaae94..4588f42 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -892,6 +892,9 @@ config CPU_LITTLE_ENDIAN
 
 endchoice
 
+config EXPORT_UASM
+	bool
+
 config SYS_SUPPORTS_APM_EMULATION
 	bool
 
diff --git a/arch/mips/include/asm/uasm.h b/arch/mips/include/asm/uasm.h
index db9d449..892062d 100644
--- a/arch/mips/include/asm/uasm.h
+++ b/arch/mips/include/asm/uasm.h
@@ -10,44 +10,55 @@
 
 #include <linux/types.h>
 
+#ifdef CONFIG_EXPORT_UASM
+#include <linux/module.h>
+#define __uasminit
+#define __uasminitdata
+#define UASM_EXPORT_SYMBOL(sym) EXPORT_SYMBOL(sym)
+#else
+#define __uasminit __cpuinit
+#define __uasminitdata __cpuinitdata
+#define UASM_EXPORT_SYMBOL(sym)
+#endif
+
 #define Ip_u1u2u3(op)							\
-void __cpuinit								\
+void __uasminit								\
 uasm_i##op(u32 **buf, unsigned int a, unsigned int b, unsigned int c)
 
 #define Ip_u2u1u3(op)							\
-void __cpuinit								\
+void __uasminit								\
 uasm_i##op(u32 **buf, unsigned int a, unsigned int b, unsigned int c)
 
 #define Ip_u3u1u2(op)							\
-void __cpuinit								\
+void __uasminit								\
 uasm_i##op(u32 **buf, unsigned int a, unsigned int b, unsigned int c)
 
 #define Ip_u1u2s3(op)							\
-void __cpuinit								\
+void __uasminit								\
 uasm_i##op(u32 **buf, unsigned int a, unsigned int b, signed int c)
 
 #define Ip_u2s3u1(op)							\
-void __cpuinit								\
+void __uasminit								\
 uasm_i##op(u32 **buf, unsigned int a, signed int b, unsigned int c)
 
 #define Ip_u2u1s3(op)							\
-void __cpuinit								\
+void __uasminit								\
 uasm_i##op(u32 **buf, unsigned int a, unsigned int b, signed int c)
 
 #define Ip_u2u1msbu3(op)						\
-void __cpuinit								\
+void __uasminit								\
 uasm_i##op(u32 **buf, unsigned int a, unsigned int b, unsigned int c,	\
 	   unsigned int d)
 
 #define Ip_u1u2(op)							\
-void __cpuinit uasm_i##op(u32 **buf, unsigned int a, unsigned int b)
+void __uasminit uasm_i##op(u32 **buf, unsigned int a, unsigned int b)
 
 #define Ip_u1s2(op)							\
-void __cpuinit uasm_i##op(u32 **buf, unsigned int a, signed int b)
+void __uasminit uasm_i##op(u32 **buf, unsigned int a, signed int b)
 
-#define Ip_u1(op) void __cpuinit uasm_i##op(u32 **buf, unsigned int a)
+#define Ip_u1(op) void __uasminit uasm_i##op(u32 **buf, unsigned int a)
 
-#define Ip_0(op) void __cpuinit uasm_i##op(u32 **buf)
+#define Ip_0(op) void __uasminit uasm_i##op(u32 **buf)
 
 Ip_u2u1s3(_addiu);
 Ip_u3u1u2(_addu);
@@ -112,7 +123,7 @@ struct uasm_label {
 	int lab;
 };
 
-void __cpuinit uasm_build_label(struct uasm_label **lab, u32 *addr, int lid);
+void __uasminit uasm_build_label(struct uasm_label **lab, u32 *addr, int lid);
 #ifdef CONFIG_64BIT
 int uasm_in_compat_space_p(long addr);
 #endif
@@ -122,7 +133,7 @@ void UASM_i_LA_mostly(u32 **buf, unsigned int rs, long addr);
 void UASM_i_LA(u32 **buf, unsigned int rs, long addr);
 
 #define UASM_L_LA(lb)							\
-static inline void __cpuinit uasm_l##lb(struct uasm_label **lab, u32 *addr) \
+static inline void __uasminit uasm_l##lb(struct uasm_label **lab, u32 *addr) \
 {									\
 	uasm_build_label(lab, addr, label##lb);				\
 }
diff --git a/arch/mips/kernel/cpu-bugs64.c b/arch/mips/kernel/cpu-bugs64.c
index 408d0a0..b8bb8ba 100644
--- a/arch/mips/kernel/cpu-bugs64.c
+++ b/arch/mips/kernel/cpu-bugs64.c
@@ -239,7 +239,7 @@ static inline void check_daddi(void)
 	panic(bug64hit, !DADDI_WAR ? daddiwar : nowar);
 }
 
-int daddiu_bug __cpuinitdata = -1;
+int daddiu_bug  = -1;
 
 static inline void check_daddiu(void)
 {
diff --git a/arch/mips/mm/uasm.c b/arch/mips/mm/uasm.c
index 636b817..d2647a4 100644
--- a/arch/mips/mm/uasm.c
+++ b/arch/mips/mm/uasm.c
@@ -86,7 +86,7 @@ struct insn {
 	 | (e) << RE_SH						\
 	 | (f) << FUNC_SH)
 
-static struct insn insn_table[] __cpuinitdata = {
+static struct insn insn_table[] __uasminitdata = {
 	{ insn_addiu, M(addiu_op, 0, 0, 0, 0, 0), RS | RT | SIMM },
 	{ insn_addu, M(spec_op, 0, 0, 0, 0, addu_op), RS | RT | RD },
 	{ insn_and, M(spec_op, 0, 0, 0, 0, and_op), RS | RT | RD },
@@ -150,7 +150,7 @@ static struct insn insn_table[] __cpuinitdata = {
 
 #undef M
 
-static inline __cpuinit u32 build_rs(u32 arg)
+static inline __uasminit u32 build_rs(u32 arg)
 {
 	if (arg & ~RS_MASK)
 		printk(KERN_WARNING "Micro-assembler field overflow\n");
@@ -158,7 +158,7 @@ static inline __cpuinit u32 build_rs(u32 arg)
 	return (arg & RS_MASK) << RS_SH;
 }
 
-static inline __cpuinit u32 build_rt(u32 arg)
+static inline __uasminit u32 build_rt(u32 arg)
 {
 	if (arg & ~RT_MASK)
 		printk(KERN_WARNING "Micro-assembler field overflow\n");
@@ -166,7 +166,7 @@ static inline __cpuinit u32 build_rt(u32 arg)
 	return (arg & RT_MASK) << RT_SH;
 }
 
-static inline __cpuinit u32 build_rd(u32 arg)
+static inline __uasminit u32 build_rd(u32 arg)
 {
 	if (arg & ~RD_MASK)
 		printk(KERN_WARNING "Micro-assembler field overflow\n");
@@ -174,7 +174,7 @@ static inline __cpuinit u32 build_rd(u32 arg)
 	return (arg & RD_MASK) << RD_SH;
 }
 
-static inline __cpuinit u32 build_re(u32 arg)
+static inline __uasminit u32 build_re(u32 arg)
 {
 	if (arg & ~RE_MASK)
 		printk(KERN_WARNING "Micro-assembler field overflow\n");
@@ -182,7 +182,7 @@ static inline __cpuinit u32 build_re(u32 arg)
 	return (arg & RE_MASK) << RE_SH;
 }
 
-static inline __cpuinit u32 build_simm(s32 arg)
+static inline __uasminit u32 build_simm(s32 arg)
 {
 	if (arg > 0x7fff || arg < -0x8000)
 		printk(KERN_WARNING "Micro-assembler field overflow\n");
@@ -190,7 +190,7 @@ static inline __cpuinit u32 build_simm(s32 arg)
 	return arg & 0xffff;
 }
 
-static inline __cpuinit u32 build_uimm(u32 arg)
+static inline __uasminit u32 build_uimm(u32 arg)
 {
 	if (arg & ~IMM_MASK)
 		printk(KERN_WARNING "Micro-assembler field overflow\n");
@@ -198,7 +198,7 @@ static inline __cpuinit u32 build_uimm(u32 arg)
 	return arg & IMM_MASK;
 }
 
-static inline __cpuinit u32 build_bimm(s32 arg)
+static inline __uasminit u32 build_bimm(s32 arg)
 {
 	if (arg > 0x1ffff || arg < -0x20000)
 		printk(KERN_WARNING "Micro-assembler field overflow\n");
@@ -209,7 +209,7 @@ static inline __cpuinit u32 build_bimm(s32 arg)
 	return ((arg < 0) ? (1 << 15) : 0) | ((arg >> 2) & 0x7fff);
 }
 
-static inline __cpuinit u32 build_jimm(u32 arg)
+static inline __uasminit u32 build_jimm(u32 arg)
 {
 	if (arg & ~((JIMM_MASK) << 2))
 		printk(KERN_WARNING "Micro-assembler field overflow\n");
@@ -217,7 +217,7 @@ static inline __cpuinit u32 build_jimm(u32 arg)
 	return (arg >> 2) & JIMM_MASK;
 }
 
-static inline __cpuinit u32 build_scimm(u32 arg)
+static inline __uasminit u32 build_scimm(u32 arg)
 {
 	if (arg & ~SCIMM_MASK)
 		printk(KERN_WARNING "Micro-assembler field overflow\n");
@@ -225,7 +225,7 @@ static inline __cpuinit u32 build_scimm(u32 arg)
 	return (arg & SCIMM_MASK) << SCIMM_SH;
 }
 
-static inline __cpuinit u32 build_func(u32 arg)
+static inline __uasminit u32 build_func(u32 arg)
 {
 	if (arg & ~FUNC_MASK)
 		printk(KERN_WARNING "Micro-assembler field overflow\n");
@@ -233,7 +233,7 @@ static inline __cpuinit u32 build_func(u32 arg)
 	return arg & FUNC_MASK;
 }
 
-static inline __cpuinit u32 build_set(u32 arg)
+static inline __uasminit u32 build_set(u32 arg)
 {
 	if (arg & ~SET_MASK)
 		printk(KERN_WARNING "Micro-assembler field overflow\n");
@@ -245,7 +245,7 @@ static inline __cpuinit u32 build_set(u32 arg)
  * The order of opcode arguments is implicitly left to right,
  * starting with RS and ending with FUNC or IMM.
  */
-static void __cpuinit build_insn(u32 **buf, enum opcode opc, ...)
+static void __uasminit build_insn(u32 **buf, enum opcode opc, ...)
 {
 	struct insn *ip = NULL;
 	unsigned int i;
@@ -295,67 +295,78 @@ static void __cpuinit build_insn(u32 **buf, enum opcode opc, ...)
 Ip_u1u2u3(op)						\
 {							\
 	build_insn(buf, insn##op, a, b, c);		\
-}
+}							\
+UASM_EXPORT_SYMBOL(uasm_i##op);
 
 #define I_u2u1u3(op)					\
 Ip_u2u1u3(op)						\
 {							\
 	build_insn(buf, insn##op, b, a, c);		\
-}
+}							\
+UASM_EXPORT_SYMBOL(uasm_i##op);
 
 #define I_u3u1u2(op)					\
 Ip_u3u1u2(op)						\
 {							\
 	build_insn(buf, insn##op, b, c, a);		\
-}
+}							\
+UASM_EXPORT_SYMBOL(uasm_i##op);
 
 #define I_u1u2s3(op)					\
 Ip_u1u2s3(op)						\
 {							\
 	build_insn(buf, insn##op, a, b, c);		\
-}
+}							\
+UASM_EXPORT_SYMBOL(uasm_i##op);
 
 #define I_u2s3u1(op)					\
 Ip_u2s3u1(op)						\
 {							\
 	build_insn(buf, insn##op, c, a, b);		\
-}
+}							\
+UASM_EXPORT_SYMBOL(uasm_i##op);
 
 #define I_u2u1s3(op)					\
 Ip_u2u1s3(op)						\
 {							\
 	build_insn(buf, insn##op, b, a, c);		\
-}
+}							\
+UASM_EXPORT_SYMBOL(uasm_i##op);
 
 #define I_u2u1msbu3(op)					\
 Ip_u2u1msbu3(op)					\
 {							\
 	build_insn(buf, insn##op, b, a, c+d-1, c);	\
-}
+}							\
+UASM_EXPORT_SYMBOL(uasm_i##op);
 
 #define I_u1u2(op)					\
 Ip_u1u2(op)						\
 {							\
 	build_insn(buf, insn##op, a, b);		\
-}
+}							\
+UASM_EXPORT_SYMBOL(uasm_i##op);
 
 #define I_u1s2(op)					\
 Ip_u1s2(op)						\
 {							\
 	build_insn(buf, insn##op, a, b);		\
-}
+}							\
+UASM_EXPORT_SYMBOL(uasm_i##op);
 
 #define I_u1(op)					\
 Ip_u1(op)						\
 {							\
 	build_insn(buf, insn##op, a);			\
-}
+}							\
+UASM_EXPORT_SYMBOL(uasm_i##op);
 
 #define I_0(op)						\
 Ip_0(op)						\
 {							\
 	build_insn(buf, insn##op);			\
-}
+}							\
+UASM_EXPORT_SYMBOL(uasm_i##op);
 
 I_u2u1s3(_addiu)
 I_u3u1u2(_addu)
@@ -417,14 +428,15 @@ I_u1u2s3(_bbit0);
 I_u1u2s3(_bbit1);
 
 /* Handle labels. */
-void __cpuinit uasm_build_label(struct uasm_label **lab, u32 *addr, int lid)
+void __uasminit uasm_build_label(struct uasm_label **lab, u32 *addr, int lid)
 {
 	(*lab)->addr = addr;
 	(*lab)->lab = lid;
 	(*lab)++;
 }
+UASM_EXPORT_SYMBOL(uasm_build_label);
 
-int __cpuinit uasm_in_compat_space_p(long addr)
+int __uasminit uasm_in_compat_space_p(long addr)
 {
 	/* Is this address in 32bit compat space? */
 #ifdef CONFIG_64BIT
@@ -433,8 +445,9 @@ int __cpuinit uasm_in_compat_space_p(long addr)
 	return 1;
 #endif
 }
+UASM_EXPORT_SYMBOL(uasm_in_compat_space_p);
 
-static int __cpuinit uasm_rel_highest(long val)
+static int __uasminit uasm_rel_highest(long val)
 {
 #ifdef CONFIG_64BIT
 	return ((((val + 0x800080008000L) >> 48) & 0xffff) ^ 0x8000) - 0x8000;
@@ -443,7 +456,7 @@ static int __cpuinit uasm_rel_highest(long val)
 #endif
 }
 
-static int __cpuinit uasm_rel_higher(long val)
+static int __uasminit uasm_rel_higher(long val)
 {
 #ifdef CONFIG_64BIT
 	return ((((val + 0x80008000L) >> 32) & 0xffff) ^ 0x8000) - 0x8000;
@@ -452,17 +465,19 @@ static int __cpuinit uasm_rel_higher(long val)
 #endif
 }
 
-int __cpuinit uasm_rel_hi(long val)
+int __uasminit uasm_rel_hi(long val)
 {
 	return ((((val + 0x8000L) >> 16) & 0xffff) ^ 0x8000) - 0x8000;
 }
+UASM_EXPORT_SYMBOL(uasm_rel_hi);
 
-int __cpuinit uasm_rel_lo(long val)
+int __uasminit uasm_rel_lo(long val)
 {
 	return ((val & 0xffff) ^ 0x8000) - 0x8000;
 }
+UASM_EXPORT_SYMBOL(uasm_rel_lo);
 
-void __cpuinit UASM_i_LA_mostly(u32 **buf, unsigned int rs, long addr)
+void __uasminit UASM_i_LA_mostly(u32 **buf, unsigned int rs, long addr)
 {
 	if (!uasm_in_compat_space_p(addr)) {
 		uasm_i_lui(buf, rs, uasm_rel_highest(addr));
@@ -477,8 +492,9 @@ void __cpuinit UASM_i_LA_mostly(u32 **buf, unsigned int rs, long addr)
 	} else
 		uasm_i_lui(buf, rs, uasm_rel_hi(addr));
 }
+UASM_EXPORT_SYMBOL(UASM_i_LA_mostly);
 
-void __cpuinit UASM_i_LA(u32 **buf, unsigned int rs, long addr)
+void __uasminit UASM_i_LA(u32 **buf, unsigned int rs, long addr)
 {
 	UASM_i_LA_mostly(buf, rs, addr);
 	if (uasm_rel_lo(addr)) {
@@ -488,9 +504,10 @@ void __cpuinit UASM_i_LA(u32 **buf, unsigned int rs, long addr)
 			uasm_i_addiu(buf, rs, rs, uasm_rel_lo(addr));
 	}
 }
+UASM_EXPORT_SYMBOL(UASM_i_LA);
 
 /* Handle relocations. */
-void __cpuinit
+void __uasminit
 uasm_r_mips_pc16(struct uasm_reloc **rel, u32 *addr, int lid)
 {
 	(*rel)->addr = addr;
@@ -498,8 +515,9 @@ uasm_r_mips_pc16(struct uasm_reloc **rel, u32 *addr, int lid)
 	(*rel)->lab = lid;
 	(*rel)++;
 }
+UASM_EXPORT_SYMBOL(uasm_r_mips_pc16);
 
-static inline void __cpuinit
+static inline void __uasminit
 __resolve_relocs(struct uasm_reloc *rel, struct uasm_label *lab)
 {
 	long laddr = (long)lab->addr;
@@ -516,7 +534,7 @@ __resolve_relocs(struct uasm_reloc *rel, struct uasm_label *lab)
 	}
 }
 
-void __cpuinit
+void __uasminit
 uasm_resolve_relocs(struct uasm_reloc *rel, struct uasm_label *lab)
 {
 	struct uasm_label *l;
@@ -526,24 +544,27 @@ uasm_resolve_relocs(struct uasm_reloc *rel, struct uasm_label *lab)
 			if (rel->lab == l->lab)
 				__resolve_relocs(rel, l);
 }
+UASM_EXPORT_SYMBOL(uasm_resolve_relocs);
 
-void __cpuinit
+void __uasminit
 uasm_move_relocs(struct uasm_reloc *rel, u32 *first, u32 *end, long off)
 {
 	for (; rel->lab != UASM_LABEL_INVALID; rel++)
 		if (rel->addr >= first && rel->addr < end)
 			rel->addr += off;
 }
+UASM_EXPORT_SYMBOL(uasm_move_relocs);
 
-void __cpuinit
+void __uasminit
 uasm_move_labels(struct uasm_label *lab, u32 *first, u32 *end, long off)
 {
 	for (; lab->lab != UASM_LABEL_INVALID; lab++)
 		if (lab->addr >= first && lab->addr < end)
 			lab->addr += off;
 }
+UASM_EXPORT_SYMBOL(uasm_move_labels);
 
-void __cpuinit
+void __uasminit
 uasm_copy_handler(struct uasm_reloc *rel, struct uasm_label *lab, u32 *first,
 		  u32 *end, u32 *target)
 {
@@ -554,8 +575,9 @@ uasm_copy_handler(struct uasm_reloc *rel, struct uasm_label *lab, u32 *first,
 	uasm_move_relocs(rel, first, end, off);
 	uasm_move_labels(lab, first, end, off);
 }
+UASM_EXPORT_SYMBOL(uasm_copy_handler);
 
-int __cpuinit uasm_insn_has_bdelay(struct uasm_reloc *rel, u32 *addr)
+int __uasminit uasm_insn_has_bdelay(struct uasm_reloc *rel, u32 *addr)
 {
 	for (; rel->lab != UASM_LABEL_INVALID; rel++) {
 		if (rel->addr == addr
@@ -566,77 +588,88 @@ int __cpuinit uasm_insn_has_bdelay(struct uasm_reloc *rel, u32 *addr)
 
 	return 0;
 }
+UASM_EXPORT_SYMBOL(uasm_insn_has_bdelay);
 
 /* Convenience functions for labeled branches. */
-void __cpuinit
+void __uasminit
 uasm_il_bltz(u32 **p, struct uasm_reloc **r, unsigned int reg, int lid)
 {
 	uasm_r_mips_pc16(r, *p, lid);
 	uasm_i_bltz(p, reg, 0);
 }
+UASM_EXPORT_SYMBOL(uasm_il_bltz);
 
-void __cpuinit
+void __uasminit
 uasm_il_b(u32 **p, struct uasm_reloc **r, int lid)
 {
 	uasm_r_mips_pc16(r, *p, lid);
 	uasm_i_b(p, 0);
 }
+UASM_EXPORT_SYMBOL(uasm_il_b);
 
-void __cpuinit
+void __uasminit
 uasm_il_beqz(u32 **p, struct uasm_reloc **r, unsigned int reg, int lid)
 {
 	uasm_r_mips_pc16(r, *p, lid);
 	uasm_i_beqz(p, reg, 0);
 }
+UASM_EXPORT_SYMBOL(uasm_il_beqz);
 
-void __cpuinit
+void __uasminit
 uasm_il_beqzl(u32 **p, struct uasm_reloc **r, unsigned int reg, int lid)
 {
 	uasm_r_mips_pc16(r, *p, lid);
 	uasm_i_beqzl(p, reg, 0);
 }
+UASM_EXPORT_SYMBOL(uasm_il_beqzl);
 
-void __cpuinit
+void __uasminit
 uasm_il_bne(u32 **p, struct uasm_reloc **r, unsigned int reg1,
 	unsigned int reg2, int lid)
 {
 	uasm_r_mips_pc16(r, *p, lid);
 	uasm_i_bne(p, reg1, reg2, 0);
 }
+UASM_EXPORT_SYMBOL(uasm_il_bne);
 
-void __cpuinit
+void __uasminit
 uasm_il_bnez(u32 **p, struct uasm_reloc **r, unsigned int reg, int lid)
 {
 	uasm_r_mips_pc16(r, *p, lid);
 	uasm_i_bnez(p, reg, 0);
 }
+UASM_EXPORT_SYMBOL(uasm_il_bnez);
 
-void __cpuinit
+void __uasminit
 uasm_il_bgezl(u32 **p, struct uasm_reloc **r, unsigned int reg, int lid)
 {
 	uasm_r_mips_pc16(r, *p, lid);
 	uasm_i_bgezl(p, reg, 0);
 }
+UASM_EXPORT_SYMBOL(uasm_il_bgezl);
 
-void __cpuinit
+void __uasminit
 uasm_il_bgez(u32 **p, struct uasm_reloc **r, unsigned int reg, int lid)
 {
 	uasm_r_mips_pc16(r, *p, lid);
 	uasm_i_bgez(p, reg, 0);
 }
+UASM_EXPORT_SYMBOL(uasm_il_bgez);
 
-void __cpuinit
+void __uasminit
 uasm_il_bbit0(u32 **p, struct uasm_reloc **r, unsigned int reg,
 	      unsigned int bit, int lid)
 {
 	uasm_r_mips_pc16(r, *p, lid);
 	uasm_i_bbit0(p, reg, bit, 0);
 }
+UASM_EXPORT_SYMBOL(uasm_il_bbit0);
 
-void __cpuinit
+void __uasminit
 uasm_il_bbit1(u32 **p, struct uasm_reloc **r, unsigned int reg,
 	      unsigned int bit, int lid)
 {
 	uasm_r_mips_pc16(r, *p, lid);
 	uasm_i_bbit1(p, reg, bit, 0);
 }
+UASM_EXPORT_SYMBOL(uasm_il_bbit1);
-- 
1.7.1.1

