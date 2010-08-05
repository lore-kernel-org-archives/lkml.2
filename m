Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760713Ab0HEOjG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 10:39:06 -0400
Received: from mail.windriver.com ([147.11.1.11]:41206 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933245Ab0HEOio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 10:38:44 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org
Subject: [PATCH 04/17] kgdb,x86: Individual register get/set for x86
Date: Thu,  5 Aug 2010 09:37:45 -0500
Message-Id: <1281019078-6636-5-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1281019078-6636-4-git-send-email-jason.wessel@windriver.com>
References: <1281019078-6636-1-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-2-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-3-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-4-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 05 Aug 2010 14:38:14.0340 (UTC) FILETIME=[D5EE3040:01CB34AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement the ability to individually get and set registers for kdb
and kgdb for x86.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Acked-by: H. Peter Anvin <hpa@zytor.com>
CC: Ingo Molnar <mingo@redhat.com>
CC: x86@kernel.org
---
 arch/x86/include/asm/kgdb.h |   20 +++---
 arch/x86/kernel/kgdb.c      |  168 +++++++++++++++++++++----------------------
 2 files changed, 94 insertions(+), 94 deletions(-)

diff --git a/arch/x86/include/asm/kgdb.h b/arch/x86/include/asm/kgdb.h
index 006da36..396f5b5 100644
--- a/arch/x86/include/asm/kgdb.h
+++ b/arch/x86/include/asm/kgdb.h
@@ -39,9 +39,11 @@ enum regnames {
 	GDB_FS,			/* 14 */
 	GDB_GS,			/* 15 */
 };
+#define GDB_ORIG_AX		41
+#define DBG_MAX_REG_NUM		16
 #define NUMREGBYTES		((GDB_GS+1)*4)
 #else /* ! CONFIG_X86_32 */
-enum regnames64 {
+enum regnames {
 	GDB_AX,			/* 0 */
 	GDB_BX,			/* 1 */
 	GDB_CX,			/* 2 */
@@ -59,15 +61,15 @@ enum regnames64 {
 	GDB_R14,		/* 14 */
 	GDB_R15,		/* 15 */
 	GDB_PC,			/* 16 */
+	GDB_PS,			/* 17 */
+	GDB_CS,			/* 18 */
+	GDB_SS,			/* 19 */
 };
-
-enum regnames32 {
-	GDB_PS = 34,
-	GDB_CS,
-	GDB_SS,
-};
-#define NUMREGBYTES		((GDB_SS+1)*4)
-#endif /* CONFIG_X86_32 */
+#define GDB_ORIG_AX		57
+#define DBG_MAX_REG_NUM		20
+/* 17 64 bit regs and 3 32 bit regs */
+#define NUMREGBYTES		((17 * 8) + (3 * 4))
+#endif /* ! CONFIG_X86_32 */
 
 static inline void arch_kgdb_breakpoint(void)
 {
diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index 01ab17a..bae8982 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -49,55 +49,94 @@
 #include <asm/system.h>
 #include <asm/apic.h>
 
-/**
- *	pt_regs_to_gdb_regs - Convert ptrace regs to GDB regs
- *	@gdb_regs: A pointer to hold the registers in the order GDB wants.
- *	@regs: The &struct pt_regs of the current process.
- *
- *	Convert the pt_regs in @regs into the format for registers that
- *	GDB expects, stored in @gdb_regs.
- */
-void pt_regs_to_gdb_regs(unsigned long *gdb_regs, struct pt_regs *regs)
+struct dbg_reg_def_t dbg_reg_def[DBG_MAX_REG_NUM] =
 {
-#ifndef CONFIG_X86_32
-	u32 *gdb_regs32 = (u32 *)gdb_regs;
+#ifdef CONFIG_X86_32
+	{ "ax", 4, offsetof(struct pt_regs, ax) },
+	{ "cx", 4, offsetof(struct pt_regs, cx) },
+	{ "dx", 4, offsetof(struct pt_regs, dx) },
+	{ "bx", 4, offsetof(struct pt_regs, bx) },
+	{ "sp", 4, offsetof(struct pt_regs, sp) },
+	{ "bp", 4, offsetof(struct pt_regs, bp) },
+	{ "si", 4, offsetof(struct pt_regs, si) },
+	{ "di", 4, offsetof(struct pt_regs, di) },
+	{ "ip", 4, offsetof(struct pt_regs, ip) },
+	{ "flags", 4, offsetof(struct pt_regs, flags) },
+	{ "cs", 4, offsetof(struct pt_regs, cs) },
+	{ "ss", 4, offsetof(struct pt_regs, ss) },
+	{ "ds", 4, offsetof(struct pt_regs, ds) },
+	{ "es", 4, offsetof(struct pt_regs, es) },
+	{ "fs", 4, -1 },
+	{ "gs", 4, -1 },
+#else
+	{ "ax", 8, offsetof(struct pt_regs, ax) },
+	{ "bx", 8, offsetof(struct pt_regs, bx) },
+	{ "cx", 8, offsetof(struct pt_regs, cx) },
+	{ "dx", 8, offsetof(struct pt_regs, dx) },
+	{ "si", 8, offsetof(struct pt_regs, dx) },
+	{ "di", 8, offsetof(struct pt_regs, di) },
+	{ "bp", 8, offsetof(struct pt_regs, bp) },
+	{ "sp", 8, offsetof(struct pt_regs, sp) },
+	{ "r8", 8, offsetof(struct pt_regs, r8) },
+	{ "r9", 8, offsetof(struct pt_regs, r9) },
+	{ "r10", 8, offsetof(struct pt_regs, r10) },
+	{ "r11", 8, offsetof(struct pt_regs, r11) },
+	{ "r12", 8, offsetof(struct pt_regs, r12) },
+	{ "r13", 8, offsetof(struct pt_regs, r13) },
+	{ "r14", 8, offsetof(struct pt_regs, r14) },
+	{ "r15", 8, offsetof(struct pt_regs, r15) },
+	{ "ip", 8, offsetof(struct pt_regs, ip) },
+	{ "flags", 4, offsetof(struct pt_regs, flags) },
+	{ "cs", 4, offsetof(struct pt_regs, cs) },
+	{ "ss", 4, offsetof(struct pt_regs, ss) },
 #endif
-	gdb_regs[GDB_AX]	= regs->ax;
-	gdb_regs[GDB_BX]	= regs->bx;
-	gdb_regs[GDB_CX]	= regs->cx;
-	gdb_regs[GDB_DX]	= regs->dx;
-	gdb_regs[GDB_SI]	= regs->si;
-	gdb_regs[GDB_DI]	= regs->di;
-	gdb_regs[GDB_BP]	= regs->bp;
-	gdb_regs[GDB_PC]	= regs->ip;
+};
+
+int dbg_set_reg(int regno, void *mem, struct pt_regs *regs)
+{
+	if (
 #ifdef CONFIG_X86_32
-	gdb_regs[GDB_PS]	= regs->flags;
-	gdb_regs[GDB_DS]	= regs->ds;
-	gdb_regs[GDB_ES]	= regs->es;
-	gdb_regs[GDB_CS]	= regs->cs;
-	gdb_regs[GDB_FS]	= 0xFFFF;
-	gdb_regs[GDB_GS]	= 0xFFFF;
-	if (user_mode_vm(regs)) {
-		gdb_regs[GDB_SS] = regs->ss;
-		gdb_regs[GDB_SP] = regs->sp;
-	} else {
-		gdb_regs[GDB_SS] = __KERNEL_DS;
-		gdb_regs[GDB_SP] = kernel_stack_pointer(regs);
+	    regno == GDB_SS || regno == GDB_FS || regno == GDB_GS ||
+#endif
+	    regno == GDB_SP || regno == GDB_ORIG_AX)
+		return 0;
+
+	if (dbg_reg_def[regno].offset != -1)
+		memcpy((void *)regs + dbg_reg_def[regno].offset, mem,
+		       dbg_reg_def[regno].size);
+	return 0;
+}
+
+char *dbg_get_reg(int regno, void *mem, struct pt_regs *regs)
+{
+	if (regno == GDB_ORIG_AX) {
+		memcpy(mem, &regs->orig_ax, sizeof(regs->orig_ax));
+		return "orig_ax";
 	}
-#else
-	gdb_regs[GDB_R8]	= regs->r8;
-	gdb_regs[GDB_R9]	= regs->r9;
-	gdb_regs[GDB_R10]	= regs->r10;
-	gdb_regs[GDB_R11]	= regs->r11;
-	gdb_regs[GDB_R12]	= regs->r12;
-	gdb_regs[GDB_R13]	= regs->r13;
-	gdb_regs[GDB_R14]	= regs->r14;
-	gdb_regs[GDB_R15]	= regs->r15;
-	gdb_regs32[GDB_PS]	= regs->flags;
-	gdb_regs32[GDB_CS]	= regs->cs;
-	gdb_regs32[GDB_SS]	= regs->ss;
-	gdb_regs[GDB_SP]	= kernel_stack_pointer(regs);
+	if (regno >= DBG_MAX_REG_NUM || regno < 0)
+		return NULL;
+
+	if (dbg_reg_def[regno].offset != -1)
+		memcpy(mem, (void *)regs + dbg_reg_def[regno].offset,
+		       dbg_reg_def[regno].size);
+
+	switch (regno) {
+#ifdef CONFIG_X86_32
+	case GDB_SS:
+		if (!user_mode_vm(regs))
+			*(unsigned long *)mem = __KERNEL_DS;
+		break;
+	case GDB_SP:
+		if (!user_mode_vm(regs))
+			*(unsigned long *)mem = kernel_stack_pointer(regs);
+		break;
+	case GDB_GS:
+	case GDB_FS:
+		*(unsigned long *)mem = 0xFFFF;
+		break;
 #endif
+	}
+	return dbg_reg_def[regno].name;
 }
 
 /**
@@ -150,47 +189,6 @@ void sleeping_thread_to_gdb_regs(unsigned long *gdb_regs, struct task_struct *p)
 	gdb_regs[GDB_SP]	= p->thread.sp;
 }
 
-/**
- *	gdb_regs_to_pt_regs - Convert GDB regs to ptrace regs.
- *	@gdb_regs: A pointer to hold the registers we've received from GDB.
- *	@regs: A pointer to a &struct pt_regs to hold these values in.
- *
- *	Convert the GDB regs in @gdb_regs into the pt_regs, and store them
- *	in @regs.
- */
-void gdb_regs_to_pt_regs(unsigned long *gdb_regs, struct pt_regs *regs)
-{
-#ifndef CONFIG_X86_32
-	u32 *gdb_regs32 = (u32 *)gdb_regs;
-#endif
-	regs->ax		= gdb_regs[GDB_AX];
-	regs->bx		= gdb_regs[GDB_BX];
-	regs->cx		= gdb_regs[GDB_CX];
-	regs->dx		= gdb_regs[GDB_DX];
-	regs->si		= gdb_regs[GDB_SI];
-	regs->di		= gdb_regs[GDB_DI];
-	regs->bp		= gdb_regs[GDB_BP];
-	regs->ip		= gdb_regs[GDB_PC];
-#ifdef CONFIG_X86_32
-	regs->flags		= gdb_regs[GDB_PS];
-	regs->ds		= gdb_regs[GDB_DS];
-	regs->es		= gdb_regs[GDB_ES];
-	regs->cs		= gdb_regs[GDB_CS];
-#else
-	regs->r8		= gdb_regs[GDB_R8];
-	regs->r9		= gdb_regs[GDB_R9];
-	regs->r10		= gdb_regs[GDB_R10];
-	regs->r11		= gdb_regs[GDB_R11];
-	regs->r12		= gdb_regs[GDB_R12];
-	regs->r13		= gdb_regs[GDB_R13];
-	regs->r14		= gdb_regs[GDB_R14];
-	regs->r15		= gdb_regs[GDB_R15];
-	regs->flags		= gdb_regs32[GDB_PS];
-	regs->cs		= gdb_regs32[GDB_CS];
-	regs->ss		= gdb_regs32[GDB_SS];
-#endif
-}
-
 static struct hw_breakpoint {
 	unsigned		enabled;
 	unsigned long		addr;
-- 
1.6.3.3

