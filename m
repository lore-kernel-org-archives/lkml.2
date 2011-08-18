Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab1HRTDE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:03:04 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44271 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab1HRTDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:03:00 -0400
Date: Thu, 18 Aug 2011 20:02:59 +0100
To: richard@nod.at
Subject: Subject: [PATCH 24/91] um: merge arch/um/sys-{i386,x86_64}/asm
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7rn-0007bm-C3@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/Makefile                                   |    4 +-
 arch/um/sys-i386/asm/elf.h                         |  125 -----------
 arch/um/sys-i386/asm/module.h                      |   13 --
 arch/um/sys-i386/asm/vm-flags.h                    |   14 --
 arch/um/{sys-i386 => sys-x86}/asm/archparam.h      |    8 +-
 arch/um/sys-x86/asm/checksum.h                     |   10 +
 .../asm/checksum.h => sys-x86/asm/checksum_32.h}   |    0
 .../asm/checksum.h => sys-x86/asm/checksum_64.h}   |    0
 arch/um/sys-x86/asm/elf.h                          |  221 ++++++++++++++++++++
 arch/um/sys-x86/asm/module.h                       |   23 ++
 arch/um/sys-x86/asm/processor.h                    |   15 ++
 .../asm/processor.h => sys-x86/asm/processor_32.h} |    9 +-
 .../asm/processor.h => sys-x86/asm/processor_64.h} |    5 -
 arch/um/sys-x86/asm/ptrace.h                       |    5 +
 .../asm/ptrace.h => sys-x86/asm/ptrace_32.h}       |    0
 .../asm/ptrace.h => sys-x86/asm/ptrace_64.h}       |    0
 arch/um/{sys-x86_64 => sys-x86}/asm/vm-flags.h     |   14 +-
 arch/um/sys-x86_64/asm/archparam.h                 |   16 --
 arch/um/sys-x86_64/asm/elf.h                       |  132 ------------
 arch/um/sys-x86_64/asm/module.h                    |   20 --
 20 files changed, 296 insertions(+), 338 deletions(-)
 delete mode 100644 arch/um/sys-i386/asm/elf.h
 delete mode 100644 arch/um/sys-i386/asm/module.h
 delete mode 100644 arch/um/sys-i386/asm/vm-flags.h
 rename arch/um/{sys-i386 => sys-x86}/asm/archparam.h (62%)
 create mode 100644 arch/um/sys-x86/asm/checksum.h
 rename arch/um/{sys-i386/asm/checksum.h => sys-x86/asm/checksum_32.h} (100%)
 rename arch/um/{sys-x86_64/asm/checksum.h => sys-x86/asm/checksum_64.h} (100%)
 create mode 100644 arch/um/sys-x86/asm/elf.h
 create mode 100644 arch/um/sys-x86/asm/module.h
 create mode 100644 arch/um/sys-x86/asm/processor.h
 rename arch/um/{sys-i386/asm/processor.h => sys-x86/asm/processor_32.h} (91%)
 rename arch/um/{sys-x86_64/asm/processor.h => sys-x86/asm/processor_64.h} (91%)
 create mode 100644 arch/um/sys-x86/asm/ptrace.h
 rename arch/um/{sys-i386/asm/ptrace.h => sys-x86/asm/ptrace_32.h} (100%)
 rename arch/um/{sys-x86_64/asm/ptrace.h => sys-x86/asm/ptrace_64.h} (100%)
 rename arch/um/{sys-x86_64 => sys-x86}/asm/vm-flags.h (58%)
 delete mode 100644 arch/um/sys-x86_64/asm/archparam.h
 delete mode 100644 arch/um/sys-x86_64/asm/elf.h
 delete mode 100644 arch/um/sys-x86_64/asm/module.h

diff --git a/arch/um/Makefile b/arch/um/Makefile
index 649aebc..c121870 100644
--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -21,10 +21,12 @@ core-y			+= $(ARCH_DIR)/kernel/		\
 MODE_INCLUDE	+= -I$(srctree)/$(ARCH_DIR)/include/shared/skas
 
 include $(srctree)/$(ARCH_DIR)/Makefile-skas
+include $(srctree)/$(ARCH_DIR)/Makefile-$(SUBARCH)
 
 SHARED_HEADERS	:= $(ARCH_DIR)/include/shared
 ARCH_INCLUDE	:= -I$(srctree)/$(SHARED_HEADERS)
 ARCH_INCLUDE	+= -I$(srctree)/$(ARCH_DIR)/sys-$(SUBARCH)/shared
+KBUILD_CPPFLAGS += -I$(srctree)/$(ARCH_DIR)/sys-$(HEADER_ARCH)
 KBUILD_CPPFLAGS += -I$(srctree)/$(ARCH_DIR)/sys-$(SUBARCH)
 
 # -Dvmap=kernel_vmap prevents anything from referencing the libpcap.o symbol so
@@ -46,8 +48,6 @@ USER_CFLAGS = $(patsubst $(KERNEL_DEFINES),,$(patsubst -D__KERNEL__,,\
 	$(patsubst -I%,,$(KBUILD_CFLAGS)))) $(ARCH_INCLUDE) $(MODE_INCLUDE) \
 	$(filter -I%,$(CFLAGS)) -D_FILE_OFFSET_BITS=64 -idirafter include
 
-include $(srctree)/$(ARCH_DIR)/Makefile-$(SUBARCH)
-
 #This will adjust *FLAGS accordingly to the platform.
 include $(srctree)/$(ARCH_DIR)/Makefile-os-$(OS)
 
diff --git a/arch/um/sys-i386/asm/elf.h b/arch/um/sys-i386/asm/elf.h
deleted file mode 100644
index 4230555..0000000
--- a/arch/um/sys-i386/asm/elf.h
+++ /dev/null
@@ -1,125 +0,0 @@
-/*
- * Copyright (C) 2000 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
- * Licensed under the GPL
- */
-#ifndef __UM_ELF_I386_H
-#define __UM_ELF_I386_H
-
-#include <asm/user.h>
-#include "skas.h"
-
-#define R_386_NONE	0
-#define R_386_32	1
-#define R_386_PC32	2
-#define R_386_GOT32	3
-#define R_386_PLT32	4
-#define R_386_COPY	5
-#define R_386_GLOB_DAT	6
-#define R_386_JMP_SLOT	7
-#define R_386_RELATIVE	8
-#define R_386_GOTOFF	9
-#define R_386_GOTPC	10
-#define R_386_NUM	11
-
-typedef unsigned long elf_greg_t;
-
-#define ELF_NGREG (sizeof (struct user_regs_struct) / sizeof(elf_greg_t))
-typedef elf_greg_t elf_gregset_t[ELF_NGREG];
-
-typedef struct user_i387_struct elf_fpregset_t;
-
-/*
- * This is used to ensure we don't load something for the wrong architecture.
- */
-#define elf_check_arch(x) \
-	(((x)->e_machine == EM_386) || ((x)->e_machine == EM_486))
-
-#define ELF_CLASS	ELFCLASS32
-#define ELF_DATA        ELFDATA2LSB
-#define ELF_ARCH        EM_386
-
-#define ELF_PLAT_INIT(regs, load_addr) do { \
-	PT_REGS_EBX(regs) = 0; \
-	PT_REGS_ECX(regs) = 0; \
-	PT_REGS_EDX(regs) = 0; \
-	PT_REGS_ESI(regs) = 0; \
-	PT_REGS_EDI(regs) = 0; \
-	PT_REGS_EBP(regs) = 0; \
-	PT_REGS_EAX(regs) = 0; \
-} while (0)
-
-#define ELF_EXEC_PAGESIZE 4096
-
-#define ELF_ET_DYN_BASE (2 * TASK_SIZE / 3)
-
-/* Shamelessly stolen from include/asm-i386/elf.h */
-
-#define ELF_CORE_COPY_REGS(pr_reg, regs) do {	\
-	pr_reg[0] = PT_REGS_EBX(regs);		\
-	pr_reg[1] = PT_REGS_ECX(regs);		\
-	pr_reg[2] = PT_REGS_EDX(regs);		\
-	pr_reg[3] = PT_REGS_ESI(regs);		\
-	pr_reg[4] = PT_REGS_EDI(regs);		\
-	pr_reg[5] = PT_REGS_EBP(regs);		\
-	pr_reg[6] = PT_REGS_EAX(regs);		\
-	pr_reg[7] = PT_REGS_DS(regs);		\
-	pr_reg[8] = PT_REGS_ES(regs);		\
-	/* fake once used fs and gs selectors? */	\
-	pr_reg[9] = PT_REGS_DS(regs);		\
-	pr_reg[10] = PT_REGS_DS(regs);		\
-	pr_reg[11] = PT_REGS_SYSCALL_NR(regs);	\
-	pr_reg[12] = PT_REGS_IP(regs);		\
-	pr_reg[13] = PT_REGS_CS(regs);		\
-	pr_reg[14] = PT_REGS_EFLAGS(regs);	\
-	pr_reg[15] = PT_REGS_SP(regs);		\
-	pr_reg[16] = PT_REGS_SS(regs);		\
-} while (0);
-
-#define task_pt_regs(t) (&(t)->thread.regs)
-
-struct task_struct;
-
-extern int elf_core_copy_fpregs(struct task_struct *t, elf_fpregset_t *fpu);
-
-#define ELF_CORE_COPY_FPREGS(t, fpu) elf_core_copy_fpregs(t, fpu)
-
-extern long elf_aux_hwcap;
-#define ELF_HWCAP (elf_aux_hwcap)
-
-extern char * elf_aux_platform;
-#define ELF_PLATFORM (elf_aux_platform)
-
-#define SET_PERSONALITY(ex) do { } while (0)
-
-extern unsigned long vsyscall_ehdr;
-extern unsigned long vsyscall_end;
-extern unsigned long __kernel_vsyscall;
-
-#define VSYSCALL_BASE vsyscall_ehdr
-#define VSYSCALL_END vsyscall_end
-
-/*
- * This is the range that is readable by user mode, and things
- * acting like user mode such as get_user_pages.
- */
-#define FIXADDR_USER_START      VSYSCALL_BASE
-#define FIXADDR_USER_END        VSYSCALL_END
-
-#define __HAVE_ARCH_GATE_AREA 1
-
-/*
- * Architecture-neutral AT_ values in 0-17, leave some room
- * for more of them, start the x86-specific ones at 32.
- */
-#define AT_SYSINFO		32
-#define AT_SYSINFO_EHDR		33
-
-#define ARCH_DLINFO						\
-do {								\
-	if ( vsyscall_ehdr ) {					\
-		NEW_AUX_ENT(AT_SYSINFO,	__kernel_vsyscall);	\
-		NEW_AUX_ENT(AT_SYSINFO_EHDR, vsyscall_ehdr);	\
-	}							\
-} while (0)
-
-#endif
diff --git a/arch/um/sys-i386/asm/module.h b/arch/um/sys-i386/asm/module.h
deleted file mode 100644
index 5ead4a0..0000000
--- a/arch/um/sys-i386/asm/module.h
+++ /dev/null
@@ -1,13 +0,0 @@
-#ifndef __UM_MODULE_I386_H
-#define __UM_MODULE_I386_H
-
-/* UML is simple */
-struct mod_arch_specific
-{
-};
-
-#define Elf_Shdr Elf32_Shdr
-#define Elf_Sym Elf32_Sym
-#define Elf_Ehdr Elf32_Ehdr
-
-#endif
diff --git a/arch/um/sys-i386/asm/vm-flags.h b/arch/um/sys-i386/asm/vm-flags.h
deleted file mode 100644
index e0d24c5..0000000
--- a/arch/um/sys-i386/asm/vm-flags.h
+++ /dev/null
@@ -1,14 +0,0 @@
-/*
- * Copyright (C) 2004 Jeff Dike (jdike@addtoit.com)
- * Licensed under the GPL
- */
-
-#ifndef __VM_FLAGS_I386_H
-#define __VM_FLAGS_I386_H
-
-#define VM_DATA_DEFAULT_FLAGS \
-	(VM_READ | VM_WRITE | \
-	((current->personality & READ_IMPLIES_EXEC) ? VM_EXEC : 0 ) | \
-		 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
-
-#endif
diff --git a/arch/um/sys-i386/asm/archparam.h b/arch/um/sys-x86/asm/archparam.h
similarity index 62%
rename from arch/um/sys-i386/asm/archparam.h
rename to arch/um/sys-x86/asm/archparam.h
index 2a18a88..c17cf68 100644
--- a/arch/um/sys-i386/asm/archparam.h
+++ b/arch/um/sys-x86/asm/archparam.h
@@ -1,10 +1,13 @@
 /* 
  * Copyright (C) 2000 - 2003 Jeff Dike (jdike@addtoit.com)
+ * Copyright 2003 PathScale, Inc.
  * Licensed under the GPL
  */
 
-#ifndef __UM_ARCHPARAM_I386_H
-#define __UM_ARCHPARAM_I386_H
+#ifndef __UM_ARCHPARAM_H
+#define __UM_ARCHPARAM_H
+
+#ifdef CONFIG_X86_32
 
 #ifdef CONFIG_X86_PAE
 #define LAST_PKMAP 512
@@ -14,3 +17,4 @@
 
 #endif
 
+#endif
diff --git a/arch/um/sys-x86/asm/checksum.h b/arch/um/sys-x86/asm/checksum.h
new file mode 100644
index 0000000..b6efe23
--- /dev/null
+++ b/arch/um/sys-x86/asm/checksum.h
@@ -0,0 +1,10 @@
+#ifndef __UM_CHECKSUM_H
+#define __UM_CHECKSUM_H
+
+#ifdef CONFIG_X86_32
+# include "checksum_32.h"
+#else
+# include "checksum_64.h"
+#endif
+
+#endif
diff --git a/arch/um/sys-i386/asm/checksum.h b/arch/um/sys-x86/asm/checksum_32.h
similarity index 100%
rename from arch/um/sys-i386/asm/checksum.h
rename to arch/um/sys-x86/asm/checksum_32.h
diff --git a/arch/um/sys-x86_64/asm/checksum.h b/arch/um/sys-x86/asm/checksum_64.h
similarity index 100%
rename from arch/um/sys-x86_64/asm/checksum.h
rename to arch/um/sys-x86/asm/checksum_64.h
diff --git a/arch/um/sys-x86/asm/elf.h b/arch/um/sys-x86/asm/elf.h
new file mode 100644
index 0000000..f3b0633
--- /dev/null
+++ b/arch/um/sys-x86/asm/elf.h
@@ -0,0 +1,221 @@
+/*
+ * Copyright (C) 2000 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
+ * Licensed under the GPL
+ */
+#ifndef __UM_ELF_X86_H
+#define __UM_ELF_X86_H
+
+#include <asm/user.h>
+#include "skas.h"
+
+#ifdef CONFIG_X86_32
+
+#define R_386_NONE	0
+#define R_386_32	1
+#define R_386_PC32	2
+#define R_386_GOT32	3
+#define R_386_PLT32	4
+#define R_386_COPY	5
+#define R_386_GLOB_DAT	6
+#define R_386_JMP_SLOT	7
+#define R_386_RELATIVE	8
+#define R_386_GOTOFF	9
+#define R_386_GOTPC	10
+#define R_386_NUM	11
+
+/*
+ * This is used to ensure we don't load something for the wrong architecture.
+ */
+#define elf_check_arch(x) \
+	(((x)->e_machine == EM_386) || ((x)->e_machine == EM_486))
+
+#define ELF_CLASS	ELFCLASS32
+#define ELF_DATA        ELFDATA2LSB
+#define ELF_ARCH        EM_386
+
+#define ELF_PLAT_INIT(regs, load_addr) do { \
+	PT_REGS_EBX(regs) = 0; \
+	PT_REGS_ECX(regs) = 0; \
+	PT_REGS_EDX(regs) = 0; \
+	PT_REGS_ESI(regs) = 0; \
+	PT_REGS_EDI(regs) = 0; \
+	PT_REGS_EBP(regs) = 0; \
+	PT_REGS_EAX(regs) = 0; \
+} while (0)
+
+/* Shamelessly stolen from include/asm-i386/elf.h */
+
+#define ELF_CORE_COPY_REGS(pr_reg, regs) do {	\
+	pr_reg[0] = PT_REGS_EBX(regs);		\
+	pr_reg[1] = PT_REGS_ECX(regs);		\
+	pr_reg[2] = PT_REGS_EDX(regs);		\
+	pr_reg[3] = PT_REGS_ESI(regs);		\
+	pr_reg[4] = PT_REGS_EDI(regs);		\
+	pr_reg[5] = PT_REGS_EBP(regs);		\
+	pr_reg[6] = PT_REGS_EAX(regs);		\
+	pr_reg[7] = PT_REGS_DS(regs);		\
+	pr_reg[8] = PT_REGS_ES(regs);		\
+	/* fake once used fs and gs selectors? */	\
+	pr_reg[9] = PT_REGS_DS(regs);		\
+	pr_reg[10] = PT_REGS_DS(regs);		\
+	pr_reg[11] = PT_REGS_SYSCALL_NR(regs);	\
+	pr_reg[12] = PT_REGS_IP(regs);		\
+	pr_reg[13] = PT_REGS_CS(regs);		\
+	pr_reg[14] = PT_REGS_EFLAGS(regs);	\
+	pr_reg[15] = PT_REGS_SP(regs);		\
+	pr_reg[16] = PT_REGS_SS(regs);		\
+} while (0);
+
+extern char * elf_aux_platform;
+#define ELF_PLATFORM (elf_aux_platform)
+
+extern unsigned long vsyscall_ehdr;
+extern unsigned long vsyscall_end;
+extern unsigned long __kernel_vsyscall;
+
+/*
+ * This is the range that is readable by user mode, and things
+ * acting like user mode such as get_user_pages.
+ */
+#define FIXADDR_USER_START      vsyscall_ehdr
+#define FIXADDR_USER_END        vsyscall_end
+
+
+/*
+ * Architecture-neutral AT_ values in 0-17, leave some room
+ * for more of them, start the x86-specific ones at 32.
+ */
+#define AT_SYSINFO		32
+#define AT_SYSINFO_EHDR		33
+
+#define ARCH_DLINFO						\
+do {								\
+	if ( vsyscall_ehdr ) {					\
+		NEW_AUX_ENT(AT_SYSINFO,	__kernel_vsyscall);	\
+		NEW_AUX_ENT(AT_SYSINFO_EHDR, vsyscall_ehdr);	\
+	}							\
+} while (0)
+
+#else
+
+/* x86-64 relocation types, taken from asm-x86_64/elf.h */
+#define R_X86_64_NONE		0	/* No reloc */
+#define R_X86_64_64		1	/* Direct 64 bit  */
+#define R_X86_64_PC32		2	/* PC relative 32 bit signed */
+#define R_X86_64_GOT32		3	/* 32 bit GOT entry */
+#define R_X86_64_PLT32		4	/* 32 bit PLT address */
+#define R_X86_64_COPY		5	/* Copy symbol at runtime */
+#define R_X86_64_GLOB_DAT	6	/* Create GOT entry */
+#define R_X86_64_JUMP_SLOT	7	/* Create PLT entry */
+#define R_X86_64_RELATIVE	8	/* Adjust by program base */
+#define R_X86_64_GOTPCREL	9	/* 32 bit signed pc relative
+					   offset to GOT */
+#define R_X86_64_32		10	/* Direct 32 bit zero extended */
+#define R_X86_64_32S		11	/* Direct 32 bit sign extended */
+#define R_X86_64_16		12	/* Direct 16 bit zero extended */
+#define R_X86_64_PC16		13	/* 16 bit sign extended pc relative */
+#define R_X86_64_8		14	/* Direct 8 bit sign extended  */
+#define R_X86_64_PC8		15	/* 8 bit sign extended pc relative */
+
+#define R_X86_64_NUM		16
+
+/*
+ * This is used to ensure we don't load something for the wrong architecture.
+ */
+#define elf_check_arch(x) \
+	((x)->e_machine == EM_X86_64)
+
+#define ELF_CLASS	ELFCLASS64
+#define ELF_DATA        ELFDATA2LSB
+#define ELF_ARCH        EM_X86_64
+
+#define ELF_PLAT_INIT(regs, load_addr)    do { \
+	PT_REGS_RBX(regs) = 0; \
+	PT_REGS_RCX(regs) = 0; \
+	PT_REGS_RDX(regs) = 0; \
+	PT_REGS_RSI(regs) = 0; \
+	PT_REGS_RDI(regs) = 0; \
+	PT_REGS_RBP(regs) = 0; \
+	PT_REGS_RAX(regs) = 0; \
+	PT_REGS_R8(regs) = 0; \
+	PT_REGS_R9(regs) = 0; \
+	PT_REGS_R10(regs) = 0; \
+	PT_REGS_R11(regs) = 0; \
+	PT_REGS_R12(regs) = 0; \
+	PT_REGS_R13(regs) = 0; \
+	PT_REGS_R14(regs) = 0; \
+	PT_REGS_R15(regs) = 0; \
+} while (0)
+
+#define ELF_CORE_COPY_REGS(pr_reg, _regs)		\
+	(pr_reg)[0] = (_regs)->regs.gp[0];			\
+	(pr_reg)[1] = (_regs)->regs.gp[1];			\
+	(pr_reg)[2] = (_regs)->regs.gp[2];			\
+	(pr_reg)[3] = (_regs)->regs.gp[3];			\
+	(pr_reg)[4] = (_regs)->regs.gp[4];			\
+	(pr_reg)[5] = (_regs)->regs.gp[5];			\
+	(pr_reg)[6] = (_regs)->regs.gp[6];			\
+	(pr_reg)[7] = (_regs)->regs.gp[7];			\
+	(pr_reg)[8] = (_regs)->regs.gp[8];			\
+	(pr_reg)[9] = (_regs)->regs.gp[9];			\
+	(pr_reg)[10] = (_regs)->regs.gp[10];			\
+	(pr_reg)[11] = (_regs)->regs.gp[11];			\
+	(pr_reg)[12] = (_regs)->regs.gp[12];			\
+	(pr_reg)[13] = (_regs)->regs.gp[13];			\
+	(pr_reg)[14] = (_regs)->regs.gp[14];			\
+	(pr_reg)[15] = (_regs)->regs.gp[15];			\
+	(pr_reg)[16] = (_regs)->regs.gp[16];			\
+	(pr_reg)[17] = (_regs)->regs.gp[17];			\
+	(pr_reg)[18] = (_regs)->regs.gp[18];			\
+	(pr_reg)[19] = (_regs)->regs.gp[19];			\
+	(pr_reg)[20] = (_regs)->regs.gp[20];			\
+	(pr_reg)[21] = current->thread.arch.fs;			\
+	(pr_reg)[22] = 0;					\
+	(pr_reg)[23] = 0;					\
+	(pr_reg)[24] = 0;					\
+	(pr_reg)[25] = 0;					\
+	(pr_reg)[26] = 0;
+
+#define ELF_PLATFORM "x86_64"
+
+/* No user-accessible fixmap addresses, i.e. vsyscall */
+#define FIXADDR_USER_START      0
+#define FIXADDR_USER_END        0
+
+#define ARCH_HAS_SETUP_ADDITIONAL_PAGES 1
+struct linux_binprm;
+extern int arch_setup_additional_pages(struct linux_binprm *bprm,
+	int uses_interp);
+
+extern unsigned long um_vdso_addr;
+#define AT_SYSINFO_EHDR 33
+#define ARCH_DLINFO	NEW_AUX_ENT(AT_SYSINFO_EHDR, um_vdso_addr)
+
+#endif
+
+typedef unsigned long elf_greg_t;
+
+#define ELF_NGREG (sizeof (struct user_regs_struct) / sizeof(elf_greg_t))
+typedef elf_greg_t elf_gregset_t[ELF_NGREG];
+
+typedef struct user_i387_struct elf_fpregset_t;
+
+#define task_pt_regs(t) (&(t)->thread.regs)
+
+struct task_struct;
+
+extern int elf_core_copy_fpregs(struct task_struct *t, elf_fpregset_t *fpu);
+
+#define ELF_CORE_COPY_FPREGS(t, fpu) elf_core_copy_fpregs(t, fpu)
+
+#define ELF_EXEC_PAGESIZE 4096
+
+#define ELF_ET_DYN_BASE (2 * TASK_SIZE / 3)
+
+extern long elf_aux_hwcap;
+#define ELF_HWCAP (elf_aux_hwcap)
+
+#define SET_PERSONALITY(ex) do ; while(0)
+#define __HAVE_ARCH_GATE_AREA 1
+
+#endif
diff --git a/arch/um/sys-x86/asm/module.h b/arch/um/sys-x86/asm/module.h
new file mode 100644
index 0000000..61af80e
--- /dev/null
+++ b/arch/um/sys-x86/asm/module.h
@@ -0,0 +1,23 @@
+#ifndef __UM_MODULE_H
+#define __UM_MODULE_H
+
+/* UML is simple */
+struct mod_arch_specific
+{
+};
+
+#ifdef CONFIG_X86_32
+
+#define Elf_Shdr Elf32_Shdr
+#define Elf_Sym Elf32_Sym
+#define Elf_Ehdr Elf32_Ehdr
+
+#else
+
+#define Elf_Shdr Elf64_Shdr
+#define Elf_Sym Elf64_Sym
+#define Elf_Ehdr Elf64_Ehdr
+
+#endif
+
+#endif
diff --git a/arch/um/sys-x86/asm/processor.h b/arch/um/sys-x86/asm/processor.h
new file mode 100644
index 0000000..d3ac1ce
--- /dev/null
+++ b/arch/um/sys-x86/asm/processor.h
@@ -0,0 +1,15 @@
+#ifndef __UM_PROCESSOR_H
+#define __UM_PROCESSOR_H
+
+/* include faultinfo structure */
+#include <sysdep/faultinfo.h>
+
+#ifdef CONFIG_X86_32
+# include "processor_32.h"
+#else
+# include "processor_64.h"
+#endif
+
+#include <asm/processor-generic.h>
+
+#endif
diff --git a/arch/um/sys-i386/asm/processor.h b/arch/um/sys-x86/asm/processor_32.h
similarity index 91%
rename from arch/um/sys-i386/asm/processor.h
rename to arch/um/sys-x86/asm/processor_32.h
index 82a9061..ae0d189 100644
--- a/arch/um/sys-i386/asm/processor.h
+++ b/arch/um/sys-x86/asm/processor_32.h
@@ -6,15 +6,12 @@
 #ifndef __UM_PROCESSOR_I386_H
 #define __UM_PROCESSOR_I386_H
 
-#include "linux/string.h"
+#include <linux/string.h>
 #include <sysdep/host_ldt.h>
-#include "asm/segment.h"
+#include <asm/segment.h>
 
 extern int host_has_cmov;
 
-/* include faultinfo structure */
-#include "sysdep/faultinfo.h"
-
 struct uml_tls_struct {
 	struct user_desc tls;
 	unsigned flushed:1;
@@ -73,6 +70,4 @@ static inline void rep_nop(void)
 #define KSTK_ESP(tsk) KSTK_REG(tsk, UESP)
 #define KSTK_EBP(tsk) KSTK_REG(tsk, EBP)
 
-#include "asm/processor-generic.h"
-
 #endif
diff --git a/arch/um/sys-x86_64/asm/processor.h b/arch/um/sys-x86/asm/processor_64.h
similarity index 91%
rename from arch/um/sys-x86_64/asm/processor.h
rename to arch/um/sys-x86/asm/processor_64.h
index 875a26a..6db812b 100644
--- a/arch/um/sys-x86_64/asm/processor.h
+++ b/arch/um/sys-x86/asm/processor_64.h
@@ -7,9 +7,6 @@
 #ifndef __UM_PROCESSOR_X86_64_H
 #define __UM_PROCESSOR_X86_64_H
 
-/* include faultinfo structure */
-#include "sysdep/faultinfo.h"
-
 struct arch_thread {
         unsigned long debugregs[8];
         int debugregs_seq;
@@ -51,6 +48,4 @@ static inline void arch_copy_thread(struct arch_thread *from,
 #define KSTK_EIP(tsk) KSTK_REG(tsk, RIP)
 #define KSTK_ESP(tsk) KSTK_REG(tsk, RSP)
 
-#include "asm/processor-generic.h"
-
 #endif
diff --git a/arch/um/sys-x86/asm/ptrace.h b/arch/um/sys-x86/asm/ptrace.h
new file mode 100644
index 0000000..c8aca8c
--- /dev/null
+++ b/arch/um/sys-x86/asm/ptrace.h
@@ -0,0 +1,5 @@
+#ifdef CONFIG_X86_32
+# include "ptrace_32.h"
+#else
+# include "ptrace_64.h"
+#endif
diff --git a/arch/um/sys-i386/asm/ptrace.h b/arch/um/sys-x86/asm/ptrace_32.h
similarity index 100%
rename from arch/um/sys-i386/asm/ptrace.h
rename to arch/um/sys-x86/asm/ptrace_32.h
diff --git a/arch/um/sys-x86_64/asm/ptrace.h b/arch/um/sys-x86/asm/ptrace_64.h
similarity index 100%
rename from arch/um/sys-x86_64/asm/ptrace.h
rename to arch/um/sys-x86/asm/ptrace_64.h
diff --git a/arch/um/sys-x86_64/asm/vm-flags.h b/arch/um/sys-x86/asm/vm-flags.h
similarity index 58%
rename from arch/um/sys-x86_64/asm/vm-flags.h
rename to arch/um/sys-x86/asm/vm-flags.h
index 3978e55..7c297e9 100644
--- a/arch/um/sys-x86_64/asm/vm-flags.h
+++ b/arch/um/sys-x86/asm/vm-flags.h
@@ -4,8 +4,17 @@
  * Licensed under the GPL
  */
 
-#ifndef __VM_FLAGS_X86_64_H
-#define __VM_FLAGS_X86_64_H
+#ifndef __VM_FLAGS_X86_H
+#define __VM_FLAGS_X86_H
+
+#ifdef CONFIG_X86_32
+
+#define VM_DATA_DEFAULT_FLAGS \
+	(VM_READ | VM_WRITE | \
+	((current->personality & READ_IMPLIES_EXEC) ? VM_EXEC : 0 ) | \
+		 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
+
+#else
 
 #define VM_DATA_DEFAULT_FLAGS (VM_READ | VM_WRITE | VM_EXEC | \
 	VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
@@ -13,3 +22,4 @@
 	VM_EXEC | VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
 
 #endif
+#endif
diff --git a/arch/um/sys-x86_64/asm/archparam.h b/arch/um/sys-x86_64/asm/archparam.h
deleted file mode 100644
index 6c08366..0000000
--- a/arch/um/sys-x86_64/asm/archparam.h
+++ /dev/null
@@ -1,16 +0,0 @@
-/*
- * Copyright 2003 PathScale, Inc.
- *
- * Licensed under the GPL
- */
-
-#ifndef __UM_ARCHPARAM_X86_64_H
-#define __UM_ARCHPARAM_X86_64_H
-
-
-/* No user-accessible fixmap addresses, i.e. vsyscall */
-#define FIXADDR_USER_START	0
-#define FIXADDR_USER_END	0
-
-#endif
-
diff --git a/arch/um/sys-x86_64/asm/elf.h b/arch/um/sys-x86_64/asm/elf.h
deleted file mode 100644
index 11a2bfb..0000000
--- a/arch/um/sys-x86_64/asm/elf.h
+++ /dev/null
@@ -1,132 +0,0 @@
-/*
- * Copyright 2003 PathScale, Inc.
- * Copyright (C) 2003 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
- *
- * Licensed under the GPL
- */
-#ifndef __UM_ELF_X86_64_H
-#define __UM_ELF_X86_64_H
-
-#include <asm/user.h>
-#include "skas.h"
-
-/* x86-64 relocation types, taken from asm-x86_64/elf.h */
-#define R_X86_64_NONE		0	/* No reloc */
-#define R_X86_64_64		1	/* Direct 64 bit  */
-#define R_X86_64_PC32		2	/* PC relative 32 bit signed */
-#define R_X86_64_GOT32		3	/* 32 bit GOT entry */
-#define R_X86_64_PLT32		4	/* 32 bit PLT address */
-#define R_X86_64_COPY		5	/* Copy symbol at runtime */
-#define R_X86_64_GLOB_DAT	6	/* Create GOT entry */
-#define R_X86_64_JUMP_SLOT	7	/* Create PLT entry */
-#define R_X86_64_RELATIVE	8	/* Adjust by program base */
-#define R_X86_64_GOTPCREL	9	/* 32 bit signed pc relative
-					   offset to GOT */
-#define R_X86_64_32		10	/* Direct 32 bit zero extended */
-#define R_X86_64_32S		11	/* Direct 32 bit sign extended */
-#define R_X86_64_16		12	/* Direct 16 bit zero extended */
-#define R_X86_64_PC16		13	/* 16 bit sign extended pc relative */
-#define R_X86_64_8		14	/* Direct 8 bit sign extended  */
-#define R_X86_64_PC8		15	/* 8 bit sign extended pc relative */
-
-#define R_X86_64_NUM		16
-
-typedef unsigned long elf_greg_t;
-
-#define ELF_NGREG (sizeof (struct user_regs_struct) / sizeof(elf_greg_t))
-typedef elf_greg_t elf_gregset_t[ELF_NGREG];
-
-typedef struct user_i387_struct elf_fpregset_t;
-
-/*
- * This is used to ensure we don't load something for the wrong architecture.
- */
-#define elf_check_arch(x) \
-	((x)->e_machine == EM_X86_64)
-
-#define ELF_CLASS	ELFCLASS64
-#define ELF_DATA        ELFDATA2LSB
-#define ELF_ARCH        EM_X86_64
-
-#define ELF_PLAT_INIT(regs, load_addr)    do { \
-	PT_REGS_RBX(regs) = 0; \
-	PT_REGS_RCX(regs) = 0; \
-	PT_REGS_RDX(regs) = 0; \
-	PT_REGS_RSI(regs) = 0; \
-	PT_REGS_RDI(regs) = 0; \
-	PT_REGS_RBP(regs) = 0; \
-	PT_REGS_RAX(regs) = 0; \
-	PT_REGS_R8(regs) = 0; \
-	PT_REGS_R9(regs) = 0; \
-	PT_REGS_R10(regs) = 0; \
-	PT_REGS_R11(regs) = 0; \
-	PT_REGS_R12(regs) = 0; \
-	PT_REGS_R13(regs) = 0; \
-	PT_REGS_R14(regs) = 0; \
-	PT_REGS_R15(regs) = 0; \
-} while (0)
-
-#define ELF_CORE_COPY_REGS(pr_reg, _regs)		\
-	(pr_reg)[0] = (_regs)->regs.gp[0];			\
-	(pr_reg)[1] = (_regs)->regs.gp[1];			\
-	(pr_reg)[2] = (_regs)->regs.gp[2];			\
-	(pr_reg)[3] = (_regs)->regs.gp[3];			\
-	(pr_reg)[4] = (_regs)->regs.gp[4];			\
-	(pr_reg)[5] = (_regs)->regs.gp[5];			\
-	(pr_reg)[6] = (_regs)->regs.gp[6];			\
-	(pr_reg)[7] = (_regs)->regs.gp[7];			\
-	(pr_reg)[8] = (_regs)->regs.gp[8];			\
-	(pr_reg)[9] = (_regs)->regs.gp[9];			\
-	(pr_reg)[10] = (_regs)->regs.gp[10];			\
-	(pr_reg)[11] = (_regs)->regs.gp[11];			\
-	(pr_reg)[12] = (_regs)->regs.gp[12];			\
-	(pr_reg)[13] = (_regs)->regs.gp[13];			\
-	(pr_reg)[14] = (_regs)->regs.gp[14];			\
-	(pr_reg)[15] = (_regs)->regs.gp[15];			\
-	(pr_reg)[16] = (_regs)->regs.gp[16];			\
-	(pr_reg)[17] = (_regs)->regs.gp[17];			\
-	(pr_reg)[18] = (_regs)->regs.gp[18];			\
-	(pr_reg)[19] = (_regs)->regs.gp[19];			\
-	(pr_reg)[20] = (_regs)->regs.gp[20];			\
-	(pr_reg)[21] = current->thread.arch.fs;			\
-	(pr_reg)[22] = 0;					\
-	(pr_reg)[23] = 0;					\
-	(pr_reg)[24] = 0;					\
-	(pr_reg)[25] = 0;					\
-	(pr_reg)[26] = 0;
-
-#define task_pt_regs(t) (&(t)->thread.regs)
-
-struct task_struct;
-
-extern int elf_core_copy_fpregs(struct task_struct *t, elf_fpregset_t *fpu);
-
-#define ELF_CORE_COPY_FPREGS(t, fpu) elf_core_copy_fpregs(t, fpu)
-
-#ifdef TIF_IA32 /* XXX */
-#error XXX, indeed
-        clear_thread_flag(TIF_IA32);
-#endif
-
-#define ELF_EXEC_PAGESIZE 4096
-
-#define ELF_ET_DYN_BASE (2 * TASK_SIZE / 3)
-
-extern long elf_aux_hwcap;
-#define ELF_HWCAP (elf_aux_hwcap)
-
-#define ELF_PLATFORM "x86_64"
-
-#define SET_PERSONALITY(ex) do ; while(0)
-
-#define __HAVE_ARCH_GATE_AREA 1
-#define ARCH_HAS_SETUP_ADDITIONAL_PAGES 1
-struct linux_binprm;
-extern int arch_setup_additional_pages(struct linux_binprm *bprm,
-	int uses_interp);
-
-extern unsigned long um_vdso_addr;
-#define AT_SYSINFO_EHDR 33
-#define ARCH_DLINFO	NEW_AUX_ENT(AT_SYSINFO_EHDR, um_vdso_addr)
-
-#endif
diff --git a/arch/um/sys-x86_64/asm/module.h b/arch/um/sys-x86_64/asm/module.h
deleted file mode 100644
index 8eb79c2..0000000
--- a/arch/um/sys-x86_64/asm/module.h
+++ /dev/null
@@ -1,20 +0,0 @@
-/*
- * Copyright 2003 PathScale, Inc.
- *
- * Licensed under the GPL
- */
-
-#ifndef __UM_MODULE_X86_64_H
-#define __UM_MODULE_X86_64_H
-
-/* UML is simple */
-struct mod_arch_specific
-{
-};
-
-#define Elf_Shdr Elf64_Shdr
-#define Elf_Sym Elf64_Sym
-#define Elf_Ehdr Elf64_Ehdr
-
-#endif
-
-- 
1.7.2.5


