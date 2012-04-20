Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab2DTVsv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 17:48:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63800 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755232Ab2DTVst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 17:48:49 -0400
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Aurelien Jacquiot <a-jacquiot@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Mark Salter <msalter@redhat.com>
Subject: [PATCH] C6X: add support to build with BINFMT_ELF_FDPIC
Date: Fri, 20 Apr 2012 17:47:56 -0400
Message-Id: <1334958476-6296-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

C6x userspace supports a shared library mechanism called DSBT for systems with
no MMU. DSBT is similar to FDPIC in allowing shared text segments and private
copies of data segments without an MMU. Both methods access data using a base
register and offset. With FDPIC, the caller of an external function sets up the
base register for the callee. With DSBT, the called function sets up its own
base register. Other details differ but both userspaces need the same thing
from the kernel loader: a map of where each ELF segment was loaded. The FDPIC
loader already provides this, so DSBT just uses it.

This patch enables BINFMT_ELF_FDPIC by default for C6X and provides the
necessary architecture hooks for the generic loader.

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 arch/c6x/include/asm/elf.h    |   12 +++++++++++-
 arch/c6x/include/asm/mmu.h    |    4 ++++
 arch/c6x/include/asm/ptrace.h |    5 +++++
 arch/c6x/kernel/process.c     |    7 +++++++
 fs/Kconfig.binfmt             |    2 +-
 5 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/arch/c6x/include/asm/elf.h b/arch/c6x/include/asm/elf.h
index d57865b..6f592a2 100644
--- a/arch/c6x/include/asm/elf.h
+++ b/arch/c6x/include/asm/elf.h
@@ -30,7 +30,17 @@ typedef elf_fpreg_t elf_fpregset_t[ELF_NFPREG];
  */
 #define elf_check_arch(x) ((x)->e_machine == EM_TI_C6000)
 
-#define elf_check_const_displacement(x) (1)
+#define elf_check_fdpic(x) (1)
+#define elf_check_const_displacement(x) (0)
+
+#define ELF_FDPIC_PLAT_INIT(_regs, _exec_map, _interp_map, _dynamic_addr) \
+do {								\
+	_regs->b4	= (_exec_map);				\
+	_regs->a6	= (_interp_map);			\
+	_regs->b6	= (_dynamic_addr);			\
+} while (0)
+
+#define ELF_FDPIC_CORE_EFLAGS	0
 
 /*
  * These are used to set parameters in the core dumps.
diff --git a/arch/c6x/include/asm/mmu.h b/arch/c6x/include/asm/mmu.h
index 41592bf..4467e77 100644
--- a/arch/c6x/include/asm/mmu.h
+++ b/arch/c6x/include/asm/mmu.h
@@ -13,6 +13,10 @@
 
 typedef struct {
 	unsigned long		end_brk;
+#ifdef CONFIG_BINFMT_ELF_FDPIC
+	unsigned long	exec_fdpic_loadmap;
+	unsigned long	interp_fdpic_loadmap;
+#endif
 } mm_context_t;
 
 #endif /* _ASM_C6X_MMU_H */
diff --git a/arch/c6x/include/asm/ptrace.h b/arch/c6x/include/asm/ptrace.h
index 21e8d79..b04ff59 100644
--- a/arch/c6x/include/asm/ptrace.h
+++ b/arch/c6x/include/asm/ptrace.h
@@ -97,6 +97,11 @@
 #define PT_DP	   PT_B14  /* Data Segment Pointer (B14) */
 #define PT_SP	   PT_B15  /* Stack Pointer (B15)  */
 
+#define PTRACE_GETFDPIC		31	/* get the ELF fdpic loadmap address */
+
+#define PTRACE_GETFDPIC_EXEC	0	/* [addr] request the executable loadmap */
+#define PTRACE_GETFDPIC_INTERP	1	/* [addr] request the interpreter loadmap */
+
 #ifndef __ASSEMBLY__
 
 #ifdef _BIG_ENDIAN
diff --git a/arch/c6x/kernel/process.c b/arch/c6x/kernel/process.c
index 7ca8c41..e12adf0 100644
--- a/arch/c6x/kernel/process.c
+++ b/arch/c6x/kernel/process.c
@@ -263,3 +263,10 @@ unsigned long get_wchan(struct task_struct *p)
 {
 	return p->thread.wchan;
 }
+
+/* Fill in the fpu structure for a core dump. This is easy -- we don't have any */
+int dump_fpu(struct pt_regs *regs, elf_fpregset_t *fpu)
+{
+	/* Not valid */
+	return 0;
+}
diff --git a/fs/Kconfig.binfmt b/fs/Kconfig.binfmt
index e95d1b6..e851721 100644
--- a/fs/Kconfig.binfmt
+++ b/fs/Kconfig.binfmt
@@ -33,7 +33,7 @@ config ARCH_BINFMT_ELF_RANDOMIZE_PIE
 config BINFMT_ELF_FDPIC
 	bool "Kernel support for FDPIC ELF binaries"
 	default y
-	depends on (FRV || BLACKFIN || (SUPERH32 && !MMU))
+	depends on (FRV || BLACKFIN || (SUPERH32 && !MMU) || TMS320C6X)
 	help
 	  ELF FDPIC binaries are based on ELF, but allow the individual load
 	  segments of a binary to be located in memory independently of each
-- 
1.7.9.1

