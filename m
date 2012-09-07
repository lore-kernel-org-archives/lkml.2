Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab2IGQb5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 12:31:57 -0400
Received: from service87.mimecast.com ([91.220.42.44]:34594 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab2IGQ16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 12:27:58 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v3 22/31] arm64: Floating point and SIMD
Date: Fri,  7 Sep 2012 17:26:57 +0100
Message-Id: <1347035226-18649-23-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
In-Reply-To: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 07 Sep 2012 16:27:55.0972 (UTC) FILETIME=[BC7C8840:01CD8D15]
X-MC-Unique: 112090717275604301
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q87GW12X008403

This patch adds support for FP/ASIMD register bank saving and restoring
during context switch and FP exception handling to generate SIGFPE.
There are 32 128-bit registers and the context switching is currently
done non-lazily. Benchmarks on real hardware are required before
implementing lazy FP state saving/restoring.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Tony Lindgren <tony@atomide.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm64/include/asm/fpsimd.h  |   64 +++++++++++++++++++++++
 arch/arm64/kernel/entry-fpsimd.S |   80 ++++++++++++++++++++++++++++
 arch/arm64/kernel/fpsimd.c       |  106 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 250 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm64/include/asm/fpsimd.h
 create mode 100644 arch/arm64/kernel/entry-fpsimd.S
 create mode 100644 arch/arm64/kernel/fpsimd.c

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
new file mode 100644
index 0000000..b42fab9
--- /dev/null
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -0,0 +1,64 @@
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
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __ASM_FP_H
+#define __ASM_FP_H
+
+#include <asm/ptrace.h>
+
+#ifndef __ASSEMBLY__
+
+/*
+ * FP/SIMD storage area has:
+ *  - FPSR and FPCR
+ *  - 32 128-bit data registers
+ *
+ * Note that user_fp forms a prefix of this structure, which is relied
+ * upon in the ptrace FP/SIMD accessors. struct user_fpsimd_state must
+ * form a prefix of struct fpsimd_state.
+ */
+struct fpsimd_state {
+	union {
+		struct user_fpsimd_state user_fpsimd;
+		struct {
+			__uint128_t vregs[32];
+			u32 fpsr;
+			u32 fpcr;
+		};
+	};
+};
+
+#if defined(__KERNEL__) && defined(CONFIG_COMPAT)
+/* Masks for extracting the FPSR and FPCR from the FPSCR */
+#define VFP_FPSCR_STAT_MASK	0xf800009f
+#define VFP_FPSCR_CTRL_MASK	0x07f79f00
+/*
+ * The VFP state has 32x64-bit registers and a single 32-bit
+ * control/status register.
+ */
+#define VFP_STATE_SIZE		((32 * 8) + 4)
+#endif
+
+struct task_struct;
+
+extern void fpsimd_save_state(struct fpsimd_state *state);
+extern void fpsimd_load_state(struct fpsimd_state *state);
+
+extern void fpsimd_thread_switch(struct task_struct *next);
+extern void fpsimd_flush_thread(void);
+
+#endif
+
+#endif
diff --git a/arch/arm64/kernel/entry-fpsimd.S b/arch/arm64/kernel/entry-fpsimd.S
new file mode 100644
index 0000000..17988a6
--- /dev/null
+++ b/arch/arm64/kernel/entry-fpsimd.S
@@ -0,0 +1,80 @@
+/*
+ * FP/SIMD state saving and restoring
+ *
+ * Copyright (C) 2012 ARM Ltd.
+ * Author: Catalin Marinas <catalin.marinas@arm.com>
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
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/linkage.h>
+
+#include <asm/assembler.h>
+
+/*
+ * Save the FP registers.
+ *
+ * x0 - pointer to struct fpsimd_state
+ */
+ENTRY(fpsimd_save_state)
+	stp	q0, q1, [x0, #16 * 0]
+	stp	q2, q3, [x0, #16 * 2]
+	stp	q4, q5, [x0, #16 * 4]
+	stp	q6, q7, [x0, #16 * 6]
+	stp	q8, q9, [x0, #16 * 8]
+	stp	q10, q11, [x0, #16 * 10]
+	stp	q12, q13, [x0, #16 * 12]
+	stp	q14, q15, [x0, #16 * 14]
+	stp	q16, q17, [x0, #16 * 16]
+	stp	q18, q19, [x0, #16 * 18]
+	stp	q20, q21, [x0, #16 * 20]
+	stp	q22, q23, [x0, #16 * 22]
+	stp	q24, q25, [x0, #16 * 24]
+	stp	q26, q27, [x0, #16 * 26]
+	stp	q28, q29, [x0, #16 * 28]
+	stp	q30, q31, [x0, #16 * 30]!
+	mrs	x8, fpsr
+	str	w8, [x0, #16 * 2]
+	mrs	x8, fpcr
+	str	w8, [x0, #16 * 2 + 4]
+	ret
+ENDPROC(fpsimd_save_state)
+
+/*
+ * Load the FP registers.
+ *
+ * x0 - pointer to struct fpsimd_state
+ */
+ENTRY(fpsimd_load_state)
+	ldp	q0, q1, [x0, #16 * 0]
+	ldp	q2, q3, [x0, #16 * 2]
+	ldp	q4, q5, [x0, #16 * 4]
+	ldp	q6, q7, [x0, #16 * 6]
+	ldp	q8, q9, [x0, #16 * 8]
+	ldp	q10, q11, [x0, #16 * 10]
+	ldp	q12, q13, [x0, #16 * 12]
+	ldp	q14, q15, [x0, #16 * 14]
+	ldp	q16, q17, [x0, #16 * 16]
+	ldp	q18, q19, [x0, #16 * 18]
+	ldp	q20, q21, [x0, #16 * 20]
+	ldp	q22, q23, [x0, #16 * 22]
+	ldp	q24, q25, [x0, #16 * 24]
+	ldp	q26, q27, [x0, #16 * 26]
+	ldp	q28, q29, [x0, #16 * 28]
+	ldp	q30, q31, [x0, #16 * 30]!
+	ldr	w8, [x0, #16 * 2]
+	ldr	w9, [x0, #16 * 2 + 4]
+	msr	fpsr, x8
+	msr	fpcr, x9
+	ret
+ENDPROC(fpsimd_load_state)
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
new file mode 100644
index 0000000..e8b8357
--- /dev/null
+++ b/arch/arm64/kernel/fpsimd.c
@@ -0,0 +1,106 @@
+/*
+ * FP/SIMD context switching and fault handling
+ *
+ * Copyright (C) 2012 ARM Ltd.
+ * Author: Catalin Marinas <catalin.marinas@arm.com>
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
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/sched.h>
+#include <linux/signal.h>
+
+#include <asm/fpsimd.h>
+#include <asm/cputype.h>
+
+#define FPEXC_IOF	(1 << 0)
+#define FPEXC_DZF	(1 << 1)
+#define FPEXC_OFF	(1 << 2)
+#define FPEXC_UFF	(1 << 3)
+#define FPEXC_IXF	(1 << 4)
+#define FPEXC_IDF	(1 << 7)
+
+/*
+ * Trapped FP/ASIMD access.
+ */
+void do_fpsimd_acc(unsigned int esr, struct pt_regs *regs)
+{
+	/* TODO: implement lazy context saving/restoring */
+	WARN_ON(1);
+}
+
+/*
+ * Raise a SIGFPE for the current process.
+ */
+void do_fpsimd_exc(unsigned int esr, struct pt_regs *regs)
+{
+	siginfo_t info;
+	unsigned int si_code = 0;
+
+	if (esr & FPEXC_IOF)
+		si_code = FPE_FLTINV;
+	else if (esr & FPEXC_DZF)
+		si_code = FPE_FLTDIV;
+	else if (esr & FPEXC_OFF)
+		si_code = FPE_FLTOVF;
+	else if (esr & FPEXC_UFF)
+		si_code = FPE_FLTUND;
+	else if (esr & FPEXC_IXF)
+		si_code = FPE_FLTRES;
+
+	memset(&info, 0, sizeof(info));
+	info.si_signo = SIGFPE;
+	info.si_code = si_code;
+	info.si_addr = (void __user *)instruction_pointer(regs);
+
+	send_sig_info(SIGFPE, &info, current);
+}
+
+void fpsimd_thread_switch(struct task_struct *next)
+{
+	/* check if not kernel threads */
+	if (current->mm)
+		fpsimd_save_state(&current->thread.fpsimd_state);
+	if (next->mm)
+		fpsimd_load_state(&next->thread.fpsimd_state);
+}
+
+void fpsimd_flush_thread(void)
+{
+	memset(&current->thread.fpsimd_state, 0, sizeof(struct fpsimd_state));
+	fpsimd_load_state(&current->thread.fpsimd_state);
+}
+
+/*
+ * FP/SIMD support code initialisation.
+ */
+static int __init fpsimd_init(void)
+{
+	u64 pfr = read_cpuid(ID_AA64PFR0_EL1);
+
+	if (pfr & (0xf << 16)) {
+		pr_notice("Floating-point is not implemented\n");
+		return 0;
+	}
+	elf_hwcap |= HWCAP_FP;
+
+	if (pfr & (0xf << 20))
+		pr_notice("Advanced SIMD is not implemented\n");
+	else
+		elf_hwcap |= HWCAP_ASIMD;
+
+	return 0;
+}
+late_initcall(fpsimd_init);

