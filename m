Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933308Ab0HEOoJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 10:44:09 -0400
Received: from mail.windriver.com ([147.11.1.11]:41207 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933285Ab0HEOip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 10:38:45 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>, linux-mips@linux-mips.org
Subject: [PATCH 05/17] kgdb,mips: Individual register get/set for mips
Date: Thu,  5 Aug 2010 09:37:46 -0500
Message-Id: <1281019078-6636-6-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1281019078-6636-5-git-send-email-jason.wessel@windriver.com>
References: <1281019078-6636-1-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-2-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-3-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-4-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-5-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 05 Aug 2010 14:38:15.0136 (UTC) FILETIME=[D667A600:01CB34AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement the ability to individually get and set registers for kdb
and kgdb for mips.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
CC: linux-mips@linux-mips.org
---
 arch/mips/include/asm/kgdb.h |   19 ++--
 arch/mips/kernel/kgdb.c      |  203 ++++++++++++++++++++++++++++++------------
 2 files changed, 154 insertions(+), 68 deletions(-)

diff --git a/arch/mips/include/asm/kgdb.h b/arch/mips/include/asm/kgdb.h
index 19002d6..e6c0b0e 100644
--- a/arch/mips/include/asm/kgdb.h
+++ b/arch/mips/include/asm/kgdb.h
@@ -8,28 +8,27 @@
 #if (_MIPS_ISA == _MIPS_ISA_MIPS1) || (_MIPS_ISA == _MIPS_ISA_MIPS2) || \
 	(_MIPS_ISA == _MIPS_ISA_MIPS32)
 
-#define KGDB_GDB_REG_SIZE 32
+#define KGDB_GDB_REG_SIZE	32
+#define GDB_SIZEOF_REG		sizeof(u32)
 
 #elif (_MIPS_ISA == _MIPS_ISA_MIPS3) || (_MIPS_ISA == _MIPS_ISA_MIPS4) || \
 	(_MIPS_ISA == _MIPS_ISA_MIPS64)
 
 #ifdef CONFIG_32BIT
-#define KGDB_GDB_REG_SIZE 32
+#define KGDB_GDB_REG_SIZE	32
+#define GDB_SIZEOF_REG		sizeof(u32)
 #else /* CONFIG_CPU_32BIT */
-#define KGDB_GDB_REG_SIZE 64
+#define KGDB_GDB_REG_SIZE	64
+#define GDB_SIZEOF_REG		sizeof(u64)
 #endif
 #else
 #error "Need to set KGDB_GDB_REG_SIZE for MIPS ISA"
 #endif /* _MIPS_ISA */
 
 #define BUFMAX			2048
-#if (KGDB_GDB_REG_SIZE == 32)
-#define NUMREGBYTES		(90*sizeof(u32))
-#define NUMCRITREGBYTES		(12*sizeof(u32))
-#else
-#define NUMREGBYTES		(90*sizeof(u64))
-#define NUMCRITREGBYTES		(12*sizeof(u64))
-#endif
+#define DBG_MAX_REG_NUM		72
+#define NUMREGBYTES		(DBG_MAX_REG_NUM * sizeof(GDB_SIZEOF_REG))
+#define NUMCRITREGBYTES		(12 * sizeof(GDB_SIZEOF_REG))
 #define BREAK_INSTR_SIZE	4
 #define CACHE_FLUSH_IS_SAFE	0
 
diff --git a/arch/mips/kernel/kgdb.c b/arch/mips/kernel/kgdb.c
index 9b78ff6..5e76c2d 100644
--- a/arch/mips/kernel/kgdb.c
+++ b/arch/mips/kernel/kgdb.c
@@ -50,6 +50,151 @@ static struct hard_trap_info {
 	{ 0, 0}			/* Must be last */
 };
 
+struct dbg_reg_def_t dbg_reg_def[DBG_MAX_REG_NUM] =
+{
+	{ "zero", GDB_SIZEOF_REG, offsetof(struct pt_regs, regs[0]) },
+	{ "at", GDB_SIZEOF_REG, offsetof(struct pt_regs, regs[1]) },
+	{ "v0", GDB_SIZEOF_REG, offsetof(struct pt_regs, regs[2]) },
+	{ "v1", GDB_SIZEOF_REG, offsetof(struct pt_regs, regs[3]) },
+	{ "a0", GDB_SIZEOF_REG, offsetof(struct pt_regs, regs[4]) },
+	{ "a1", GDB_SIZEOF_REG, offsetof(struct pt_regs, regs[5]) },
+	{ "a2", GDB_SIZEOF_REG, offsetof(struct pt_regs, regs[6]) },
+	{ "a3", GDB_SIZEOF_REG, offsetof(struct pt_regs, regs[7]) },
+	{ "t0", GDB_SIZEOF_REG, offsetof(struct pt_regs, regs[8]) },
+	{ "t1", GDB_SIZEOF_REG, offsetof(struct pt_regs, regs[9]) },
+	{ "t2", GDB_SIZEOF_REG, offsetof(struct pt_regs, regs[10]) },
+	{ "t3", GDB_SIZEOF_REG, offsetof(struct pt_regs, regs[11]) },
+	{ "t4", GDB_SIZEOF_REG, offsetof(struct pt_regs, regs[12]) },
+	{ "t5", GDB_SIZEOF_REG, offsetof(struct pt_regs, regs[13]) },
+	{ "t6", GDB_SIZEOF_REG, offsetof(struct pt_regs, regs[14]) },
+	{ "t7", GDB_SIZEOF_REG, offsetof(struct pt_regs, regs[15]) },
+	{ "s0", GDB_SIZEOF_REG, offsetof(struct pt_regs, regs[16]) },
+	{ "s1", GDB_SIZEOF_REG, offsetof(struct pt_regs, regs[17]) },
+	{ "s2", GDB_SIZEOF_REG, offsetof(struct pt_regs, regs[18]) },
+	{ "s3", GDB_SIZEOF_REG, offsetof(struct pt_regs, regs[19]) },
+	{ "s4", GDB_SIZEOF_REG, offsetof(struct pt_regs, regs[20]) },
+	{ "s5", GDB_SIZEOF_REG, offsetof(struct pt_regs, regs[21]) },
+	{ "s6", GDB_SIZEOF_REG, offsetof(struct pt_regs, regs[22]) },
+	{ "s7", GDB_SIZEOF_REG, offsetof(struct pt_regs, regs[23]) },
+	{ "t8", GDB_SIZEOF_REG, offsetof(struct pt_regs, regs[24]) },
+	{ "t9", GDB_SIZEOF_REG, offsetof(struct pt_regs, regs[25]) },
+	{ "k0", GDB_SIZEOF_REG, offsetof(struct pt_regs, regs[26]) },
+	{ "k1", GDB_SIZEOF_REG, offsetof(struct pt_regs, regs[27]) },
+	{ "gp", GDB_SIZEOF_REG, offsetof(struct pt_regs, regs[28]) },
+	{ "sp", GDB_SIZEOF_REG, offsetof(struct pt_regs, regs[29]) },
+	{ "s8", GDB_SIZEOF_REG, offsetof(struct pt_regs, regs[30]) },
+	{ "ra", GDB_SIZEOF_REG, offsetof(struct pt_regs, regs[31]) },
+	{ "sr", GDB_SIZEOF_REG, offsetof(struct pt_regs, cp0_status) },
+	{ "lo", GDB_SIZEOF_REG, offsetof(struct pt_regs, lo) },
+	{ "hi", GDB_SIZEOF_REG, offsetof(struct pt_regs, hi) },
+	{ "bad", GDB_SIZEOF_REG, offsetof(struct pt_regs, cp0_badvaddr) },
+	{ "cause", GDB_SIZEOF_REG, offsetof(struct pt_regs, cp0_cause) },
+	{ "pc", GDB_SIZEOF_REG, offsetof(struct pt_regs, cp0_epc) },
+	{ "f0", GDB_SIZEOF_REG, 0 },
+	{ "f1", GDB_SIZEOF_REG, 1 },
+	{ "f2", GDB_SIZEOF_REG, 2 },
+	{ "f3", GDB_SIZEOF_REG, 3 },
+	{ "f4", GDB_SIZEOF_REG, 4 },
+	{ "f5", GDB_SIZEOF_REG, 5 },
+	{ "f6", GDB_SIZEOF_REG, 6 },
+	{ "f7", GDB_SIZEOF_REG, 7 },
+	{ "f8", GDB_SIZEOF_REG, 8 },
+	{ "f9", GDB_SIZEOF_REG, 9 },
+	{ "f10", GDB_SIZEOF_REG, 10 },
+	{ "f11", GDB_SIZEOF_REG, 11 },
+	{ "f12", GDB_SIZEOF_REG, 12 },
+	{ "f13", GDB_SIZEOF_REG, 13 },
+	{ "f14", GDB_SIZEOF_REG, 14 },
+	{ "f15", GDB_SIZEOF_REG, 15 },
+	{ "f16", GDB_SIZEOF_REG, 16 },
+	{ "f17", GDB_SIZEOF_REG, 17 },
+	{ "f18", GDB_SIZEOF_REG, 18 },
+	{ "f19", GDB_SIZEOF_REG, 19 },
+	{ "f20", GDB_SIZEOF_REG, 20 },
+	{ "f21", GDB_SIZEOF_REG, 21 },
+	{ "f22", GDB_SIZEOF_REG, 22 },
+	{ "f23", GDB_SIZEOF_REG, 23 },
+	{ "f24", GDB_SIZEOF_REG, 24 },
+	{ "f25", GDB_SIZEOF_REG, 25 },
+	{ "f26", GDB_SIZEOF_REG, 26 },
+	{ "f27", GDB_SIZEOF_REG, 27 },
+	{ "f28", GDB_SIZEOF_REG, 28 },
+	{ "f29", GDB_SIZEOF_REG, 29 },
+	{ "f30", GDB_SIZEOF_REG, 30 },
+	{ "f31", GDB_SIZEOF_REG, 31 },
+	{ "fsr", GDB_SIZEOF_REG, 0 },
+	{ "fir", GDB_SIZEOF_REG, 0 },
+};
+
+int dbg_set_reg(int regno, void *mem, struct pt_regs *regs)
+{
+	int fp_reg;
+
+	if (regno < 0 || regno >= DBG_MAX_REG_NUM)
+		return -EINVAL;
+
+	if (dbg_reg_def[regno].offset != -1 && regno < 38) {
+		memcpy((void *)regs + dbg_reg_def[regno].offset, mem,
+		       dbg_reg_def[regno].size);
+	} else if (current && dbg_reg_def[regno].offset != -1 && regno < 72) {
+		/* FP registers 38 -> 69 */
+		if (!(regs->cp0_status & ST0_CU1))
+			return 0;
+		if (regno == 70) {
+			/* Process the fcr31/fsr (register 70) */
+			memcpy((void *)&current->thread.fpu.fcr31, mem,
+			       dbg_reg_def[regno].size);
+			goto out_save;
+		} else if (regno == 71) {
+			/* Ignore the fir (register 71) */
+			goto out_save;
+		}
+		fp_reg = dbg_reg_def[regno].offset;
+		memcpy((void *)&current->thread.fpu.fpr[fp_reg], mem,
+		       dbg_reg_def[regno].size);
+out_save:
+		restore_fp(current);
+	}
+
+	return 0;
+}
+
+char *dbg_get_reg(int regno, void *mem, struct pt_regs *regs)
+{
+	int fp_reg;
+
+	if (regno >= DBG_MAX_REG_NUM || regno < 0)
+		return NULL;
+
+	if (dbg_reg_def[regno].offset != -1 && regno < 38) {
+		/* First 38 registers */
+		memcpy(mem, (void *)regs + dbg_reg_def[regno].offset,
+		       dbg_reg_def[regno].size);
+	} else if (current && dbg_reg_def[regno].offset != -1 && regno < 72) {
+		/* FP registers 38 -> 69 */
+		if (!(regs->cp0_status & ST0_CU1))
+			goto out;
+		save_fp(current);
+		if (regno == 70) {
+			/* Process the fcr31/fsr (register 70) */
+			memcpy(mem, (void *)&current->thread.fpu.fcr31,
+			       dbg_reg_def[regno].size);
+			goto out;
+		} else if (regno == 71) {
+			/* Ignore the fir (register 71) */
+			memset(mem, 0, dbg_reg_def[regno].size);
+			goto out;
+		}
+		fp_reg = dbg_reg_def[regno].offset;
+		memcpy(mem, (void *)&current->thread.fpu.fpr[fp_reg],
+		       dbg_reg_def[regno].size);
+	}
+
+out:
+	return dbg_reg_def[regno].name;
+
+}
+
 void arch_kgdb_breakpoint(void)
 {
 	__asm__ __volatile__(
@@ -84,64 +229,6 @@ static int compute_signal(int tt)
 	return SIGHUP;		/* default for things we don't know about */
 }
 
-void pt_regs_to_gdb_regs(unsigned long *gdb_regs, struct pt_regs *regs)
-{
-	int reg;
-
-#if (KGDB_GDB_REG_SIZE == 32)
-	u32 *ptr = (u32 *)gdb_regs;
-#else
-	u64 *ptr = (u64 *)gdb_regs;
-#endif
-
-	for (reg = 0; reg < 32; reg++)
-		*(ptr++) = regs->regs[reg];
-
-	*(ptr++) = regs->cp0_status;
-	*(ptr++) = regs->lo;
-	*(ptr++) = regs->hi;
-	*(ptr++) = regs->cp0_badvaddr;
-	*(ptr++) = regs->cp0_cause;
-	*(ptr++) = regs->cp0_epc;
-
-	/* FP REGS */
-	if (!(current && (regs->cp0_status & ST0_CU1)))
-		return;
-
-	save_fp(current);
-	for (reg = 0; reg < 32; reg++)
-		*(ptr++) = current->thread.fpu.fpr[reg];
-}
-
-void gdb_regs_to_pt_regs(unsigned long *gdb_regs, struct pt_regs *regs)
-{
-	int reg;
-
-#if (KGDB_GDB_REG_SIZE == 32)
-	const u32 *ptr = (u32 *)gdb_regs;
-#else
-	const u64 *ptr = (u64 *)gdb_regs;
-#endif
-
-	for (reg = 0; reg < 32; reg++)
-		regs->regs[reg] = *(ptr++);
-
-	regs->cp0_status = *(ptr++);
-	regs->lo = *(ptr++);
-	regs->hi = *(ptr++);
-	regs->cp0_badvaddr = *(ptr++);
-	regs->cp0_cause = *(ptr++);
-	regs->cp0_epc = *(ptr++);
-
-	/* FP REGS from current */
-	if (!(current && (regs->cp0_status & ST0_CU1)))
-		return;
-
-	for (reg = 0; reg < 32; reg++)
-		current->thread.fpu.fpr[reg] = *(ptr++);
-	restore_fp(current);
-}
-
 /*
  * Similar to regs_to_gdb_regs() except that process is sleeping and so
  * we may not be able to get all the info.
-- 
1.6.3.3

