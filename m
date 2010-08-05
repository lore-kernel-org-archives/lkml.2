Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933400Ab0HEOka (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 10:40:30 -0400
Received: from mail.windriver.com ([147.11.1.11]:41214 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933329Ab0HEOit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 10:38:49 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 06/17] kgdb,arm: Individual register get/set for arm
Date: Thu,  5 Aug 2010 09:37:47 -0500
Message-Id: <1281019078-6636-7-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1281019078-6636-6-git-send-email-jason.wessel@windriver.com>
References: <1281019078-6636-1-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-2-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-3-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-4-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-5-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-6-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 05 Aug 2010 14:38:16.0058 (UTC) FILETIME=[D6F455A0:01CB34AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement the ability to individually get and set registers for kdb
and kgdb for arm.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
CC: Russell King <linux@arm.linux.org.uk>
CC: linux-arm-kernel@lists.infradead.org
---
 arch/arm/include/asm/kgdb.h |    6 +-
 arch/arm/kernel/kgdb.c      |   88 ++++++++++++++++++++++--------------------
 2 files changed, 49 insertions(+), 45 deletions(-)

diff --git a/arch/arm/include/asm/kgdb.h b/arch/arm/include/asm/kgdb.h
index 67af4b8..0826599 100644
--- a/arch/arm/include/asm/kgdb.h
+++ b/arch/arm/include/asm/kgdb.h
@@ -70,11 +70,11 @@ extern int kgdb_fault_expected;
 #define _GP_REGS		16
 #define _FP_REGS		8
 #define _EXTRA_REGS		2
-#define GDB_MAX_REGS		(_GP_REGS + (_FP_REGS * 3) + _EXTRA_REGS)
+#define DBG_MAX_REG_NUM		(_GP_REGS + (_FP_REGS * 3) + _EXTRA_REGS)
 
 #define KGDB_MAX_NO_CPUS	1
 #define BUFMAX			400
-#define NUMREGBYTES		(GDB_MAX_REGS << 2)
+#define NUMREGBYTES		(DBG_MAX_REG_NUM << 2)
 #define NUMCRITREGBYTES		(32 << 2)
 
 #define _R0			0
@@ -93,7 +93,7 @@ extern int kgdb_fault_expected;
 #define _SPT			13
 #define _LR			14
 #define _PC			15
-#define _CPSR			(GDB_MAX_REGS - 1)
+#define _CPSR			(DBG_MAX_REG_NUM - 1)
 
 /*
  * So that we can denote the end of a frame for tracing,
diff --git a/arch/arm/kernel/kgdb.c b/arch/arm/kernel/kgdb.c
index c868a88..cf846ca 100644
--- a/arch/arm/kernel/kgdb.c
+++ b/arch/arm/kernel/kgdb.c
@@ -13,54 +13,58 @@
 #include <linux/kgdb.h>
 #include <asm/traps.h>
 
-/* Make a local copy of the registers passed into the handler (bletch) */
-void pt_regs_to_gdb_regs(unsigned long *gdb_regs, struct pt_regs *kernel_regs)
+struct dbg_reg_def_t dbg_reg_def[DBG_MAX_REG_NUM] =
 {
-	int regno;
-
-	/* Initialize all to zero. */
-	for (regno = 0; regno < GDB_MAX_REGS; regno++)
-		gdb_regs[regno] = 0;
+	{ "r0", 4, offsetof(struct pt_regs, ARM_r0)},
+	{ "r1", 4, offsetof(struct pt_regs, ARM_r1)},
+	{ "r2", 4, offsetof(struct pt_regs, ARM_r2)},
+	{ "r3", 4, offsetof(struct pt_regs, ARM_r3)},
+	{ "r4", 4, offsetof(struct pt_regs, ARM_r4)},
+	{ "r5", 4, offsetof(struct pt_regs, ARM_r5)},
+	{ "r6", 4, offsetof(struct pt_regs, ARM_r6)},
+	{ "r7", 4, offsetof(struct pt_regs, ARM_r7)},
+	{ "r8", 4, offsetof(struct pt_regs, ARM_r8)},
+	{ "r9", 4, offsetof(struct pt_regs, ARM_r9)},
+	{ "r10", 4, offsetof(struct pt_regs, ARM_r10)},
+	{ "fp", 4, offsetof(struct pt_regs, ARM_fp)},
+	{ "ip", 4, offsetof(struct pt_regs, ARM_ip)},
+	{ "sp", 4, offsetof(struct pt_regs, ARM_sp)},
+	{ "lr", 4, offsetof(struct pt_regs, ARM_lr)},
+	{ "pc", 4, offsetof(struct pt_regs, ARM_pc)},
+	{ "f0", 12, -1 },
+	{ "f1", 12, -1 },
+	{ "f2", 12, -1 },
+	{ "f3", 12, -1 },
+	{ "f4", 12, -1 },
+	{ "f5", 12, -1 },
+	{ "f6", 12, -1 },
+	{ "f7", 12, -1 },
+	{ "fps", 4, -1 },
+	{ "cpsr", 4, offsetof(struct pt_regs, ARM_cpsr)},
+};
 
-	gdb_regs[_R0]		= kernel_regs->ARM_r0;
-	gdb_regs[_R1]		= kernel_regs->ARM_r1;
-	gdb_regs[_R2]		= kernel_regs->ARM_r2;
-	gdb_regs[_R3]		= kernel_regs->ARM_r3;
-	gdb_regs[_R4]		= kernel_regs->ARM_r4;
-	gdb_regs[_R5]		= kernel_regs->ARM_r5;
-	gdb_regs[_R6]		= kernel_regs->ARM_r6;
-	gdb_regs[_R7]		= kernel_regs->ARM_r7;
-	gdb_regs[_R8]		= kernel_regs->ARM_r8;
-	gdb_regs[_R9]		= kernel_regs->ARM_r9;
-	gdb_regs[_R10]		= kernel_regs->ARM_r10;
-	gdb_regs[_FP]		= kernel_regs->ARM_fp;
-	gdb_regs[_IP]		= kernel_regs->ARM_ip;
-	gdb_regs[_SPT]		= kernel_regs->ARM_sp;
-	gdb_regs[_LR]		= kernel_regs->ARM_lr;
-	gdb_regs[_PC]		= kernel_regs->ARM_pc;
-	gdb_regs[_CPSR]		= kernel_regs->ARM_cpsr;
+char *dbg_get_reg(int regno, void *mem, struct pt_regs *regs)
+{
+	if (regno >= DBG_MAX_REG_NUM || regno < 0)
+		return NULL;
+
+	if (dbg_reg_def[regno].offset != -1)
+		memcpy(mem, (void *)regs + dbg_reg_def[regno].offset,
+		       dbg_reg_def[regno].size);
+	else
+		memset(mem, 0, dbg_reg_def[regno].size);
+	return dbg_reg_def[regno].name;
 }
 
-/* Copy local gdb registers back to kgdb regs, for later copy to kernel */
-void gdb_regs_to_pt_regs(unsigned long *gdb_regs, struct pt_regs *kernel_regs)
+int dbg_set_reg(int regno, void *mem, struct pt_regs *regs)
 {
-	kernel_regs->ARM_r0	= gdb_regs[_R0];
-	kernel_regs->ARM_r1	= gdb_regs[_R1];
-	kernel_regs->ARM_r2	= gdb_regs[_R2];
-	kernel_regs->ARM_r3	= gdb_regs[_R3];
-	kernel_regs->ARM_r4	= gdb_regs[_R4];
-	kernel_regs->ARM_r5	= gdb_regs[_R5];
-	kernel_regs->ARM_r6	= gdb_regs[_R6];
-	kernel_regs->ARM_r7	= gdb_regs[_R7];
-	kernel_regs->ARM_r8	= gdb_regs[_R8];
-	kernel_regs->ARM_r9	= gdb_regs[_R9];
-	kernel_regs->ARM_r10	= gdb_regs[_R10];
-	kernel_regs->ARM_fp	= gdb_regs[_FP];
-	kernel_regs->ARM_ip	= gdb_regs[_IP];
-	kernel_regs->ARM_sp	= gdb_regs[_SPT];
-	kernel_regs->ARM_lr	= gdb_regs[_LR];
-	kernel_regs->ARM_pc	= gdb_regs[_PC];
-	kernel_regs->ARM_cpsr	= gdb_regs[_CPSR];
+	if (regno >= DBG_MAX_REG_NUM || regno < 0)
+		return -EINVAL;
+
+	if (dbg_reg_def[regno].offset != -1)
+		memcpy((void *)regs + dbg_reg_def[regno].offset, mem,
+		       dbg_reg_def[regno].size);
+	return 0;
 }
 
 void
-- 
1.6.3.3

