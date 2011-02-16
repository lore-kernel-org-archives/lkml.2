Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292Ab1BPHql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 02:46:41 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:57493 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346Ab1BPHqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 02:46:39 -0500
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
Cc: "Arnd Bergmann" <arnd@arndb.de>, "'Greg KH'" <greg@kroah.com>
Subject: [PATCH 02/12] unicore32 additional architecture files: float point handling
Date: Wed, 16 Feb 2011 15:46:32 +0800
Message-ID: <014501cbcdad$a117a9f0$e346fdd0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AcvNrZV7u2SjsUgcToOV8ga49O0YxQ==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Message-Id: <ca2658a5abba1e8d1ccd423724065490876d4316.1297842537.git.gxt@mprc.pku.edu.cn>
In-Reply-To: <cover.1297842537.git.gxt@mprc.pku.edu.cn>
References: <cover.1297842537.git.gxt@mprc.pku.edu.cn>
From: GuanXuetao <gxt@mprc.pku.edu.cn>
Date: Sat, 15 Jan 2011 18:21:31 +0800

This patch implements support for float point unit, which using UniCore-F64 FPU hardware in UniCore32 ISA.

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/unicore32/include/asm/fpstate.h   |   26 +++++++
 arch/unicore32/include/asm/fpu-ucf64.h |   53 +++++++++++++
 arch/unicore32/kernel/fpu-ucf64.c      |  126 ++++++++++++++++++++++++++++++++
 3 files changed, 205 insertions(+), 0 deletions(-)
 create mode 100644 arch/unicore32/include/asm/fpstate.h
 create mode 100644 arch/unicore32/include/asm/fpu-ucf64.h
 create mode 100644 arch/unicore32/kernel/fpu-ucf64.c

diff --git a/arch/unicore32/include/asm/fpstate.h b/arch/unicore32/include/asm/fpstate.h
new file mode 100644
index 0000000..ba97fac
--- /dev/null
+++ b/arch/unicore32/include/asm/fpstate.h
@@ -0,0 +1,26 @@
+/*
+ * linux/arch/unicore32/include/asm/fpstate.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __UNICORE_FPSTATE_H__
+#define __UNICORE_FPSTATE_H__
+
+#ifndef __ASSEMBLY__
+
+#define FP_REGS_NUMBER		33
+
+struct fp_state {
+	unsigned int regs[FP_REGS_NUMBER];
+} __attribute__((aligned(8)));
+
+#endif
+
+#endif
diff --git a/arch/unicore32/include/asm/fpu-ucf64.h b/arch/unicore32/include/asm/fpu-ucf64.h
new file mode 100644
index 0000000..16c1457
--- /dev/null
+++ b/arch/unicore32/include/asm/fpu-ucf64.h
@@ -0,0 +1,53 @@
+/*
+ * linux/arch/unicore32/include/asm/fpu-ucf64.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ *	Maintained by GUAN Xue-tao <gxt@mprc.pku.edu.cn>
+ *	Copyright (C) 2001-2010 Guan Xuetao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#define FPSCR			s31
+
+/* FPSCR bits */
+#define FPSCR_DEFAULT_NAN	(1<<25)
+
+#define FPSCR_CMPINSTR_BIT	(1<<31)
+
+#define FPSCR_CON		(1<<29)
+#define FPSCR_TRAP		(1<<27)
+
+/* RND mode */
+#define FPSCR_ROUND_NEAREST	(0<<0)
+#define FPSCR_ROUND_PLUSINF	(2<<0)
+#define FPSCR_ROUND_MINUSINF	(3<<0)
+#define FPSCR_ROUND_TOZERO	(1<<0)
+#define FPSCR_RMODE_BIT		(0)
+#define FPSCR_RMODE_MASK	(7 << FPSCR_RMODE_BIT)
+
+/* trap enable */
+#define FPSCR_IOE		(1<<16)
+#define FPSCR_OFE		(1<<14)
+#define FPSCR_UFE		(1<<13)
+#define FPSCR_IXE		(1<<12)
+#define FPSCR_HIE		(1<<11)
+#define FPSCR_NDE		(1<<10)	/* non denomal */
+
+/* flags */
+#define FPSCR_IDC		(1<<24)
+#define FPSCR_HIC		(1<<23)
+#define FPSCR_IXC		(1<<22)
+#define FPSCR_OFC		(1<<21)
+#define FPSCR_UFC		(1<<20)
+#define FPSCR_IOC		(1<<19)
+
+/* stick bits */
+#define FPSCR_IOS		(1<<9)
+#define FPSCR_OFS		(1<<7)
+#define FPSCR_UFS		(1<<6)
+#define FPSCR_IXS		(1<<5)
+#define FPSCR_HIS		(1<<4)
+#define FPSCR_NDS		(1<<3)	/*non denomal */
diff --git a/arch/unicore32/kernel/fpu-ucf64.c b/arch/unicore32/kernel/fpu-ucf64.c
new file mode 100644
index 0000000..282a60a
--- /dev/null
+++ b/arch/unicore32/kernel/fpu-ucf64.c
@@ -0,0 +1,126 @@
+/*
+ * linux/arch/unicore32/kernel/fpu-ucf64.c
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/signal.h>
+#include <linux/sched.h>
+#include <linux/init.h>
+
+#include <asm/fpu-ucf64.h>
+
+/*
+ * A special flag to tell the normalisation code not to normalise.
+ */
+#define F64_NAN_FLAG	0x100
+
+/*
+ * A bit pattern used to indicate the initial (unset) value of the
+ * exception mask, in case nothing handles an instruction.  This
+ * doesn't include the NAN flag, which get masked out before
+ * we check for an error.
+ */
+#define F64_EXCEPTION_ERROR	((u32)-1 & ~F64_NAN_FLAG)
+
+/*
+ * Since we aren't building with -mfpu=f64, we need to code
+ * these instructions using their MRC/MCR equivalents.
+ */
+#define f64reg(_f64_) #_f64_
+
+#define cff(_f64_) ({			\
+	u32 __v;			\
+	asm("cff %0, " f64reg(_f64_) "@ fmrx	%0, " #_f64_	\
+	    : "=r" (__v) : : "cc");	\
+	__v;				\
+	})
+
+#define ctf(_f64_, _var_)		\
+	asm("ctf %0, " f64reg(_f64_) "@ fmxr	" #_f64_ ", %0"	\
+	   : : "r" (_var_) : "cc")
+
+/*
+ * Raise a SIGFPE for the current process.
+ * sicode describes the signal being raised.
+ */
+void ucf64_raise_sigfpe(unsigned int sicode, struct pt_regs *regs)
+{
+	siginfo_t info;
+
+	memset(&info, 0, sizeof(info));
+
+	info.si_signo = SIGFPE;
+	info.si_code = sicode;
+	info.si_addr = (void __user *)(instruction_pointer(regs) - 4);
+
+	/*
+	 * This is the same as NWFPE, because it's not clear what
+	 * this is used for
+	 */
+	current->thread.error_code = 0;
+	current->thread.trap_no = 6;
+
+	send_sig_info(SIGFPE, &info, current);
+}
+
+/*
+ * Handle exceptions of UniCore-F64.
+ */
+void ucf64_exchandler(u32 inst, u32 fpexc, struct pt_regs *regs)
+{
+	u32 tmp = fpexc;
+	u32 exc = F64_EXCEPTION_ERROR & fpexc;
+
+	pr_debug("UniCore-F64: instruction %08x fpscr %08x\n",
+			inst, fpexc);
+
+	if (exc & FPSCR_CMPINSTR_BIT) {
+		if (exc & FPSCR_CON)
+			tmp |= FPSCR_CON;
+		else
+			tmp &= ~(FPSCR_CON);
+		exc &= ~(FPSCR_CMPINSTR_BIT | FPSCR_CON);
+	} else {
+		pr_debug(KERN_ERR "UniCore-F64 Error: unhandled exceptions\n");
+		pr_debug(KERN_ERR "UniCore-F64 FPSCR 0x%08x INST 0x%08x\n",
+				cff(FPSCR), inst);
+
+		ucf64_raise_sigfpe(0, regs);
+		return;
+	}
+
+	/*
+	 * Update the FPSCR with the additional exception flags.
+	 * Comparison instructions always return at least one of
+	 * these flags set.
+	 */
+	tmp &= ~(FPSCR_TRAP | FPSCR_IOS | FPSCR_OFS | FPSCR_UFS |
+			FPSCR_IXS | FPSCR_HIS | FPSCR_IOC | FPSCR_OFC |
+			FPSCR_UFC | FPSCR_IXC | FPSCR_HIC);
+
+	tmp |= exc;
+	ctf(FPSCR, tmp);
+}
+
+/*
+ * F64 support code initialisation.
+ */
+static int __init ucf64_init(void)
+{
+	ctf(FPSCR, 0x0);     /* FPSCR_UFE | FPSCR_NDE perhaps better */
+
+	printk(KERN_INFO "Enable UniCore-F64 support.\n");
+
+	return 0;
+}
+
+late_initcall(ucf64_init);
-- 
1.6.2.2


