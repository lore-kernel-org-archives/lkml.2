Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761542Ab0J2So1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 14:44:27 -0400
Received: from mail.windriver.com ([147.11.1.11]:58517 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760282Ab0J2SoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 14:44:22 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Dongdong Deng <dongdong.deng@windriver.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 7/7] kgdb,ppc: Individual register get/set for ppc
Date: Fri, 29 Oct 2010 13:43:41 -0500
Message-Id: <1288377821-24520-8-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1288377821-24520-1-git-send-email-jason.wessel@windriver.com>
References: <1288377821-24520-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 29 Oct 2010 18:43:53.0910 (UTC) FILETIME=[3C82D560:01CB7799]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dongdong Deng <dongdong.deng@windriver.com>

commit 534af1082329392bc29f6badf815e69ae2ae0f4c(kgdb,kdb: individual
register set and and get API) introduce dbg_get_reg/dbg_set_reg API
for individual register get and set.

This patch implement those APIs for ppc.

Signed-off-by: Dongdong Deng <dongdong.deng@windriver.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
CC: linuxppc-dev@lists.ozlabs.org

---
 arch/powerpc/include/asm/kgdb.h |    1 +
 arch/powerpc/kernel/kgdb.c      |  188 ++++++++++++++++++++++++++-------------
 2 files changed, 126 insertions(+), 63 deletions(-)

diff --git a/arch/powerpc/include/asm/kgdb.h b/arch/powerpc/include/asm/kgdb.h
index edd2170..9db24e7 100644
--- a/arch/powerpc/include/asm/kgdb.h
+++ b/arch/powerpc/include/asm/kgdb.h
@@ -31,6 +31,7 @@ static inline void arch_kgdb_breakpoint(void)
 	asm(".long 0x7d821008"); /* twge r2, r2 */
 }
 #define CACHE_FLUSH_IS_SAFE	1
+#define DBG_MAX_REG_NUM     70
 
 /* The number bytes of registers we have to save depends on a few
  * things.  For 64bit we default to not including vector registers and
diff --git a/arch/powerpc/kernel/kgdb.c b/arch/powerpc/kernel/kgdb.c
index 7f61a3a..7a9db64 100644
--- a/arch/powerpc/kernel/kgdb.c
+++ b/arch/powerpc/kernel/kgdb.c
@@ -194,40 +194,6 @@ static int kgdb_dabr_match(struct pt_regs *regs)
 	ptr = (unsigned long *)ptr32; \
 	} while (0)
 
-
-void pt_regs_to_gdb_regs(unsigned long *gdb_regs, struct pt_regs *regs)
-{
-	unsigned long *ptr = gdb_regs;
-	int reg;
-
-	memset(gdb_regs, 0, NUMREGBYTES);
-
-	for (reg = 0; reg < 32; reg++)
-		PACK64(ptr, regs->gpr[reg]);
-
-#ifdef CONFIG_FSL_BOOKE
-#ifdef CONFIG_SPE
-	for (reg = 0; reg < 32; reg++)
-		PACK64(ptr, current->thread.evr[reg]);
-#else
-	ptr += 32;
-#endif
-#else
-	/* fp registers not used by kernel, leave zero */
-	ptr += 32 * 8 / sizeof(long);
-#endif
-
-	PACK64(ptr, regs->nip);
-	PACK64(ptr, regs->msr);
-	PACK32(ptr, regs->ccr);
-	PACK64(ptr, regs->link);
-	PACK64(ptr, regs->ctr);
-	PACK32(ptr, regs->xer);
-
-	BUG_ON((unsigned long)ptr >
-	       (unsigned long)(((void *)gdb_regs) + NUMREGBYTES));
-}
-
 void sleeping_thread_to_gdb_regs(unsigned long *gdb_regs, struct task_struct *p)
 {
 	struct pt_regs *regs = (struct pt_regs *)(p->thread.ksp +
@@ -271,44 +237,140 @@ void sleeping_thread_to_gdb_regs(unsigned long *gdb_regs, struct task_struct *p)
 	       (unsigned long)(((void *)gdb_regs) + NUMREGBYTES));
 }
 
-#define UNPACK64(dest, ptr) do { dest = *(ptr++); } while (0)
+#define GDB_SIZEOF_REG sizeof(unsigned long)
+#define GDB_SIZEOF_REG_U32 sizeof(u32)
 
-#define UNPACK32(dest, ptr) do {       \
-	u32 *ptr32;                   \
-	ptr32 = (u32 *)ptr;           \
-	dest = *(ptr32++);            \
-	ptr = (unsigned long *)ptr32; \
-	} while (0)
+#ifdef CONFIG_FSL_BOOKE
+#define GDB_SIZEOF_FLOAT_REG sizeof(unsigned long)
+#else
+#define GDB_SIZEOF_FLOAT_REG sizeof(u64)
+#endif
 
-void gdb_regs_to_pt_regs(unsigned long *gdb_regs, struct pt_regs *regs)
+struct dbg_reg_def_t dbg_reg_def[DBG_MAX_REG_NUM] =
 {
-	unsigned long *ptr = gdb_regs;
-	int reg;
-
-	for (reg = 0; reg < 32; reg++)
-		UNPACK64(regs->gpr[reg], ptr);
+	{ "r0", GDB_SIZEOF_REG, offsetof(struct pt_regs, gpr[0]) },
+	{ "r1", GDB_SIZEOF_REG, offsetof(struct pt_regs, gpr[1]) },
+	{ "r2", GDB_SIZEOF_REG, offsetof(struct pt_regs, gpr[2]) },
+	{ "r3", GDB_SIZEOF_REG, offsetof(struct pt_regs, gpr[3]) },
+	{ "r4", GDB_SIZEOF_REG, offsetof(struct pt_regs, gpr[4]) },
+	{ "r5", GDB_SIZEOF_REG, offsetof(struct pt_regs, gpr[5]) },
+	{ "r6", GDB_SIZEOF_REG, offsetof(struct pt_regs, gpr[6]) },
+	{ "r7", GDB_SIZEOF_REG, offsetof(struct pt_regs, gpr[7]) },
+	{ "r8", GDB_SIZEOF_REG, offsetof(struct pt_regs, gpr[8]) },
+	{ "r9", GDB_SIZEOF_REG, offsetof(struct pt_regs, gpr[9]) },
+	{ "r10", GDB_SIZEOF_REG, offsetof(struct pt_regs, gpr[10]) },
+	{ "r11", GDB_SIZEOF_REG, offsetof(struct pt_regs, gpr[11]) },
+	{ "r12", GDB_SIZEOF_REG, offsetof(struct pt_regs, gpr[12]) },
+	{ "r13", GDB_SIZEOF_REG, offsetof(struct pt_regs, gpr[13]) },
+	{ "r14", GDB_SIZEOF_REG, offsetof(struct pt_regs, gpr[14]) },
+	{ "r15", GDB_SIZEOF_REG, offsetof(struct pt_regs, gpr[15]) },
+	{ "r16", GDB_SIZEOF_REG, offsetof(struct pt_regs, gpr[16]) },
+	{ "r17", GDB_SIZEOF_REG, offsetof(struct pt_regs, gpr[17]) },
+	{ "r18", GDB_SIZEOF_REG, offsetof(struct pt_regs, gpr[18]) },
+	{ "r19", GDB_SIZEOF_REG, offsetof(struct pt_regs, gpr[19]) },
+	{ "r20", GDB_SIZEOF_REG, offsetof(struct pt_regs, gpr[20]) },
+	{ "r21", GDB_SIZEOF_REG, offsetof(struct pt_regs, gpr[21]) },
+	{ "r22", GDB_SIZEOF_REG, offsetof(struct pt_regs, gpr[22]) },
+	{ "r23", GDB_SIZEOF_REG, offsetof(struct pt_regs, gpr[23]) },
+	{ "r24", GDB_SIZEOF_REG, offsetof(struct pt_regs, gpr[24]) },
+	{ "r25", GDB_SIZEOF_REG, offsetof(struct pt_regs, gpr[25]) },
+	{ "r26", GDB_SIZEOF_REG, offsetof(struct pt_regs, gpr[26]) },
+	{ "r27", GDB_SIZEOF_REG, offsetof(struct pt_regs, gpr[27]) },
+	{ "r28", GDB_SIZEOF_REG, offsetof(struct pt_regs, gpr[28]) },
+	{ "r29", GDB_SIZEOF_REG, offsetof(struct pt_regs, gpr[29]) },
+	{ "r30", GDB_SIZEOF_REG, offsetof(struct pt_regs, gpr[30]) },
+	{ "r31", GDB_SIZEOF_REG, offsetof(struct pt_regs, gpr[31]) },
+
+	{ "f0", GDB_SIZEOF_FLOAT_REG, 0 },
+	{ "f1", GDB_SIZEOF_FLOAT_REG, 1 },
+	{ "f2", GDB_SIZEOF_FLOAT_REG, 2 },
+	{ "f3", GDB_SIZEOF_FLOAT_REG, 3 },
+	{ "f4", GDB_SIZEOF_FLOAT_REG, 4 },
+	{ "f5", GDB_SIZEOF_FLOAT_REG, 5 },
+	{ "f6", GDB_SIZEOF_FLOAT_REG, 6 },
+	{ "f7", GDB_SIZEOF_FLOAT_REG, 7 },
+	{ "f8", GDB_SIZEOF_FLOAT_REG, 8 },
+	{ "f9", GDB_SIZEOF_FLOAT_REG, 9 },
+	{ "f10", GDB_SIZEOF_FLOAT_REG, 10 },
+	{ "f11", GDB_SIZEOF_FLOAT_REG, 11 },
+	{ "f12", GDB_SIZEOF_FLOAT_REG, 12 },
+	{ "f13", GDB_SIZEOF_FLOAT_REG, 13 },
+	{ "f14", GDB_SIZEOF_FLOAT_REG, 14 },
+	{ "f15", GDB_SIZEOF_FLOAT_REG, 15 },
+	{ "f16", GDB_SIZEOF_FLOAT_REG, 16 },
+	{ "f17", GDB_SIZEOF_FLOAT_REG, 17 },
+	{ "f18", GDB_SIZEOF_FLOAT_REG, 18 },
+	{ "f19", GDB_SIZEOF_FLOAT_REG, 19 },
+	{ "f20", GDB_SIZEOF_FLOAT_REG, 20 },
+	{ "f21", GDB_SIZEOF_FLOAT_REG, 21 },
+	{ "f22", GDB_SIZEOF_FLOAT_REG, 22 },
+	{ "f23", GDB_SIZEOF_FLOAT_REG, 23 },
+	{ "f24", GDB_SIZEOF_FLOAT_REG, 24 },
+	{ "f25", GDB_SIZEOF_FLOAT_REG, 25 },
+	{ "f26", GDB_SIZEOF_FLOAT_REG, 26 },
+	{ "f27", GDB_SIZEOF_FLOAT_REG, 27 },
+	{ "f28", GDB_SIZEOF_FLOAT_REG, 28 },
+	{ "f29", GDB_SIZEOF_FLOAT_REG, 29 },
+	{ "f30", GDB_SIZEOF_FLOAT_REG, 30 },
+	{ "f31", GDB_SIZEOF_FLOAT_REG, 31 },
+
+	{ "pc", GDB_SIZEOF_REG, offsetof(struct pt_regs, nip) },
+	{ "msr", GDB_SIZEOF_REG, offsetof(struct pt_regs, msr) },
+	{ "cr", GDB_SIZEOF_REG_U32, offsetof(struct pt_regs, ccr) },
+	{ "lr", GDB_SIZEOF_REG, offsetof(struct pt_regs, link) },
+	{ "ctr", GDB_SIZEOF_REG_U32, offsetof(struct pt_regs, ctr) },
+	{ "xer", GDB_SIZEOF_REG, offsetof(struct pt_regs, xer) },
+};
 
-#ifdef CONFIG_FSL_BOOKE
-#ifdef CONFIG_SPE
-	for (reg = 0; reg < 32; reg++)
-		UNPACK64(current->thread.evr[reg], ptr);
+char *dbg_get_reg(int regno, void *mem, struct pt_regs *regs)
+{
+	if (regno >= DBG_MAX_REG_NUM || regno < 0)
+		return NULL;
+
+	if (regno < 32 || regno >= 64)
+		/* First 0 -> 31 gpr registers*/
+		/* pc, msr, ls... registers 64 -> 69 */
+		memcpy(mem, (void *)regs + dbg_reg_def[regno].offset,
+				dbg_reg_def[regno].size);
+
+	if (regno >= 32 && regno < 64) {
+		/* FP registers 32 -> 63 */
+#if defined(CONFIG_FSL_BOOKE) && defined(CONFIG_SPE)
+		if (current)
+			memcpy(mem, current->thread.evr[regno-32],
+					dbg_reg_def[regno].size);
 #else
-	ptr += 32;
+		/* fp registers not used by kernel, leave zero */
+		memset(mem, 0, dbg_reg_def[regno].size);
 #endif
+	}
+
+	return dbg_reg_def[regno].name;
+}
+
+int dbg_set_reg(int regno, void *mem, struct pt_regs *regs)
+{
+	if (regno >= DBG_MAX_REG_NUM || regno < 0)
+		return -EINVAL;
+
+	if (regno < 32 || regno >= 64)
+		/* First 0 -> 31 gpr registers*/
+		/* pc, msr, ls... registers 64 -> 69 */
+		memcpy((void *)regs + dbg_reg_def[regno].offset, mem,
+				dbg_reg_def[regno].size);
+
+	if (regno >= 32 && regno < 64) {
+		/* FP registers 32 -> 63 */
+#if defined(CONFIG_FSL_BOOKE) && defined(CONFIG_SPE)
+		memcpy(current->thread.evr[regno-32], mem,
+				dbg_reg_def[regno].size);
 #else
-	/* fp registers not used by kernel, leave zero */
-	ptr += 32 * 8 / sizeof(int);
+		/* fp registers not used by kernel, leave zero */
+		return 0;
 #endif
+	}
 
-	UNPACK64(regs->nip, ptr);
-	UNPACK64(regs->msr, ptr);
-	UNPACK32(regs->ccr, ptr);
-	UNPACK64(regs->link, ptr);
-	UNPACK64(regs->ctr, ptr);
-	UNPACK32(regs->xer, ptr);
-
-	BUG_ON((unsigned long)ptr >
-	       (unsigned long)(((void *)gdb_regs) + NUMREGBYTES));
+	return 0;
 }
 
 void kgdb_arch_set_pc(struct pt_regs *regs, unsigned long pc)
-- 
1.6.3.3

