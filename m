Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758661Ab2GFVLA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 17:11:00 -0400
Received: from service87.mimecast.com ([91.220.42.44]:33023 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758380Ab2GFVGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 17:06:43 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>
Subject: [PATCH 22/36] AArch64: ELF definitions
Date: Fri,  6 Jul 2012 22:06:03 +0100
Message-Id: <1341608777-12982-23-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
In-Reply-To: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 06 Jul 2012 21:07:36.0591 (UTC) FILETIME=[5E7D89F0:01CD5BBB]
X-MC-Unique: 112070622064201801
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id q66LBG3s005400

This patch adds definitions for the ELF format, including personality
personality setting and EXEC_PAGESIZE. The are only two hwcap
definitions for 64-bit applications - HWCAP_FP and HWCAP_ASIMD.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/aarch64/include/asm/auxvec.h   |   23 +++++
 arch/aarch64/include/asm/elf.h      |  177 +++++++++++++++++++++++++++++++++++
 arch/aarch64/include/asm/hwcap.h    |   58 ++++++++++++
 arch/aarch64/include/asm/param.h    |   24 +++++
 arch/aarch64/include/asm/shmparam.h |   29 ++++++
 arch/aarch64/kernel/elf.c           |   42 ++++++++
 6 files changed, 353 insertions(+), 0 deletions(-)
 create mode 100644 arch/aarch64/include/asm/auxvec.h
 create mode 100644 arch/aarch64/include/asm/elf.h
 create mode 100644 arch/aarch64/include/asm/hwcap.h
 create mode 100644 arch/aarch64/include/asm/param.h
 create mode 100644 arch/aarch64/include/asm/shmparam.h
 create mode 100644 arch/aarch64/kernel/elf.c

diff --git a/arch/aarch64/include/asm/auxvec.h b/arch/aarch64/include/asm/auxvec.h
new file mode 100644
index 0000000..0fcd431
--- /dev/null
+++ b/arch/aarch64/include/asm/auxvec.h
@@ -0,0 +1,23 @@
+/*
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+#ifndef __ASM_AUXVEC_H
+#define __ASM_AUXVEC_H
+
+/* vDSO location */
+#define AT_SYSINFO_EHDR	33
+
+#endif
diff --git a/arch/aarch64/include/asm/elf.h b/arch/aarch64/include/asm/elf.h
new file mode 100644
index 0000000..b10ac43
--- /dev/null
+++ b/arch/aarch64/include/asm/elf.h
@@ -0,0 +1,177 @@
+/*
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+#ifndef __ASM_ELF_H
+#define __ASM_ELF_H
+
+#include <asm/hwcap.h>
+
+/*
+ * ELF register definitions..
+ */
+#include <asm/ptrace.h>
+#include <asm/user.h>
+
+typedef unsigned long elf_greg_t;
+typedef unsigned long elf_freg_t[3];
+
+#define ELF_NGREG (sizeof (struct pt_regs) / sizeof(elf_greg_t))
+typedef elf_greg_t elf_gregset_t[ELF_NGREG];
+
+typedef struct user_fp elf_fpregset_t;
+
+#define EM_AARCH64		183
+
+/*
+ * AArch64 static relocation types.
+ */
+
+/* Miscellaneous. */
+#define R_ARM_NONE			0
+#define R_AARCH64_NONE			256
+
+/* Data. */
+#define R_AARCH64_ABS64			257
+#define R_AARCH64_ABS32			258
+#define R_AARCH64_ABS16			259
+#define R_AARCH64_PREL64		260
+#define R_AARCH64_PREL32		261
+#define R_AARCH64_PREL16		262
+
+/* Instructions. */
+#define R_AARCH64_MOVW_UABS_G0		263
+#define R_AARCH64_MOVW_UABS_G0_NC	264
+#define R_AARCH64_MOVW_UABS_G1		265
+#define R_AARCH64_MOVW_UABS_G1_NC	266
+#define R_AARCH64_MOVW_UABS_G2		267
+#define R_AARCH64_MOVW_UABS_G2_NC	268
+#define R_AARCH64_MOVW_UABS_G3		269
+
+#define R_AARCH64_MOVW_SABS_G0		270
+#define R_AARCH64_MOVW_SABS_G1		271
+#define R_AARCH64_MOVW_SABS_G2		272
+
+#define R_AARCH64_LD_PREL_LO19		273
+#define R_AARCH64_ADR_PREL_LO21		274
+#define R_AARCH64_ADR_PREL_PG_HI21	275
+#define R_AARCH64_ADR_PREL_PG_HI21_NC	276
+#define R_AARCH64_ADD_ABS_LO12_NC	277
+#define R_AARCH64_LDST8_ABS_LO12_NC	278
+
+#define R_AARCH64_TSTBR14		279
+#define R_AARCH64_CONDBR19		280
+#define R_AARCH64_JUMP26		282
+#define R_AARCH64_CALL26		283
+#define R_AARCH64_LDST16_ABS_LO12_NC	284
+#define R_AARCH64_LDST32_ABS_LO12_NC	285
+#define R_AARCH64_LDST64_ABS_LO12_NC	286
+#define R_AARCH64_LDST128_ABS_LO12_NC	299
+
+#define R_AARCH64_MOVW_PREL_G0		287
+#define R_AARCH64_MOVW_PREL_G0_NC	288
+#define R_AARCH64_MOVW_PREL_G1		289
+#define R_AARCH64_MOVW_PREL_G1_NC	290
+#define R_AARCH64_MOVW_PREL_G2		291
+#define R_AARCH64_MOVW_PREL_G2_NC	292
+#define R_AARCH64_MOVW_PREL_G3		293
+
+
+/*
+ * These are used to set parameters in the core dumps.
+ */
+#define ELF_CLASS	ELFCLASS64
+#define ELF_DATA	ELFDATA2LSB
+#define ELF_ARCH	EM_AARCH64
+
+#define ELF_PLATFORM_SIZE	16
+#define ELF_PLATFORM		("aarch64")
+
+/*
+ * This is used to ensure we don't load something for the wrong architecture.
+ */
+#define elf_check_arch(x)		((x)->e_machine == EM_AARCH64)
+
+#define elf_read_implies_exec(ex,stk)	(stk != EXSTACK_DISABLE_X)
+
+#define CORE_DUMP_USE_REGSET
+#define ELF_EXEC_PAGESIZE	PAGE_SIZE
+
+/*
+ * This is the location that an ET_DYN program is loaded if exec'ed.  Typical
+ * use of this is to invoke "./ld.so someprog" to test out a new version of
+ * the loader.  We need to make sure that it is out of the way of the program
+ * that it will "exec", and that there is sufficient room for the brk.
+ */
+extern unsigned long randomize_et_dyn(unsigned long base);
+#define ELF_ET_DYN_BASE	(randomize_et_dyn(2 * TASK_SIZE_64 / 3))
+
+/*
+ * When the program starts, a1 contains a pointer to a function to be
+ * registered with atexit, as per the SVR4 ABI.  A value of 0 means we have no
+ * such handler.
+ */
+#define ELF_PLAT_INIT(_r, load_addr)	(_r)->regs[0] = 0
+
+extern void				elf_set_personality(int personality);
+#define SET_PERSONALITY(ex)		elf_set_personality(PER_LINUX)
+
+#define ARCH_DLINFO							\
+do {									\
+	NEW_AUX_ENT(AT_SYSINFO_EHDR,					\
+		    (elf_addr_t)current->mm->context.vdso);		\
+} while (0)
+
+#define ARCH_HAS_SETUP_ADDITIONAL_PAGES
+struct linux_binprm;
+extern int arch_setup_additional_pages(struct linux_binprm *bprm,
+				       int uses_interp);
+
+/* 1GB of VA */
+#define STACK_RND_MASK			(test_thread_flag(TIF_32BIT) ? \
+						0x7ff >> (PAGE_SHIFT - 12) : \
+						0x3ffff >> (PAGE_SHIFT - 12))
+
+struct mm_struct;
+extern unsigned long arch_randomize_brk(struct mm_struct *mm);
+#define arch_randomize_brk arch_randomize_brk
+
+#ifdef CONFIG_AARCH32_EMULATION
+#define EM_ARM				40
+#define COMPAT_ELF_PLATFORM		("v8l")
+
+#define COMPAT_ELF_ET_DYN_BASE		(randomize_et_dyn(2 * TASK_SIZE_32 / 3))
+
+/* AArch32 registers. */
+#define COMPAT_ELF_NGREG		18
+typedef unsigned int			compat_elf_greg_t;
+typedef compat_elf_greg_t		compat_elf_gregset_t[COMPAT_ELF_NGREG];
+
+/* AArch32 EABI. */
+#define EF_ARM_EABI_MASK		0xff000000
+#define compat_elf_check_arch(x)	(((x)->e_machine == EM_ARM) && \
+					 ((x)->e_flags & EF_ARM_EABI_MASK))
+
+#define compat_start_thread		compat_start_thread
+#define COMPAT_SET_PERSONALITY(ex)	elf_set_personality(PER_LINUX32)
+#define COMPAT_ARCH_DLINFO
+extern int aarch32_setup_vectors_page(struct linux_binprm *bprm,
+				      int uses_interp);
+#define compat_arch_setup_additional_pages \
+					aarch32_setup_vectors_page
+
+#endif /* CONFIG_AARCH32_EMULATION */
+
+#endif
diff --git a/arch/aarch64/include/asm/hwcap.h b/arch/aarch64/include/asm/hwcap.h
new file mode 100644
index 0000000..d6f2eef
--- /dev/null
+++ b/arch/aarch64/include/asm/hwcap.h
@@ -0,0 +1,58 @@
+/*
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+#ifndef __ASM_HWCAP_H
+#define __ASM_HWCAP_H
+
+/*
+ * HWCAP flags - for elf_hwcap (in kernel) and AT_HWCAP
+ */
+#define HWCAP_FP		(1 << 0)
+#define HWCAP_ASIMD		(1 << 1)
+
+#ifdef CONFIG_AARCH32_EMULATION
+#define COMPAT_HWCAP_HALF	(1 << 1)
+#define COMPAT_HWCAP_THUMB	(1 << 2)
+#define COMPAT_HWCAP_FAST_MULT	(1 << 4)
+#define COMPAT_HWCAP_VFP	(1 << 6)
+#define COMPAT_HWCAP_EDSP	(1 << 7)
+#define COMPAT_HWCAP_NEON	(1 << 12)
+#define COMPAT_HWCAP_VFPv3	(1 << 13)
+#define COMPAT_HWCAP_TLS	(1 << 15)
+#define COMPAT_HWCAP_VFPv4	(1 << 16)
+#define COMPAT_HWCAP_IDIVA	(1 << 17)
+#define COMPAT_HWCAP_IDIVT	(1 << 18)
+#define COMPAT_HWCAP_IDIV	(COMPAT_HWCAP_IDIVA|COMPAT_HWCAP_IDIVT)
+
+#endif /* CONFIG_AARCH32_EMULATION */
+
+#if defined(__KERNEL__) && !defined(__ASSEMBLY__)
+/*
+ * This yields a mask that user programs can use to figure out what
+ * instruction set this cpu supports.
+ */
+#define ELF_HWCAP		(elf_hwcap)
+#ifdef CONFIG_AARCH32_EMULATION
+#define COMPAT_ELF_HWCAP	(COMPAT_HWCAP_HALF|COMPAT_HWCAP_THUMB|\
+				 COMPAT_HWCAP_FAST_MULT|COMPAT_HWCAP_EDSP|\
+				 COMPAT_HWCAP_TLS|COMPAT_HWCAP_VFP|\
+				 COMPAT_HWCAP_VFPv3|COMPAT_HWCAP_VFPv4|\
+				 COMPAT_HWCAP_NEON|COMPAT_HWCAP_IDIV)
+#endif
+extern unsigned int elf_hwcap;
+#endif
+
+#endif
diff --git a/arch/aarch64/include/asm/param.h b/arch/aarch64/include/asm/param.h
new file mode 100644
index 0000000..8977c76
--- /dev/null
+++ b/arch/aarch64/include/asm/param.h
@@ -0,0 +1,24 @@
+/*
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+#ifndef __ASM_PARAM_H
+#define __ASM_PARAM_H
+
+#define EXEC_PAGESIZE	65536
+
+#include <asm-generic/param.h>
+
+#endif
diff --git a/arch/aarch64/include/asm/shmparam.h b/arch/aarch64/include/asm/shmparam.h
new file mode 100644
index 0000000..e0e2eed
--- /dev/null
+++ b/arch/aarch64/include/asm/shmparam.h
@@ -0,0 +1,29 @@
+/*
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+#ifndef __ASM_SHMPARAM_H
+#define __ASM_SHMPARAM_H
+
+/*
+ * For IPC syscalls from compat tasks, we need to use the legacy 16k
+ * alignment value. Since we don't have aliasing D-caches, the rest of
+ * the time we can safely use PAGE_SIZE.
+ */
+#define COMPAT_SHMLBA	0x4000
+
+#include <asm-generic/shmparam.h>
+
+#endif /* __ASM_SHMPARAM_H */
diff --git a/arch/aarch64/kernel/elf.c b/arch/aarch64/kernel/elf.c
new file mode 100644
index 0000000..7c2ff95
--- /dev/null
+++ b/arch/aarch64/kernel/elf.c
@@ -0,0 +1,42 @@
+/*
+ * ELF personality setting
+ *
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+#include <linux/export.h>
+#include <linux/sched.h>
+#include <linux/personality.h>
+#include <linux/binfmts.h>
+#include <linux/elf.h>
+
+void elf_set_personality(int personality)
+{
+	switch (personality & PER_MASK) {
+	case PER_LINUX:
+		clear_thread_flag(TIF_32BIT);
+		break;
+	case PER_LINUX32:
+		set_thread_flag(TIF_32BIT);
+		break;
+	default:
+		pr_warning("Process %s tried to assume unknown personality %d\n",
+			   current->comm, personality);
+		return;
+	}
+
+	current->personality = personality;
+}
+EXPORT_SYMBOL(elf_set_personality);

