Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941Ab1HRTFZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:05:25 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44322 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868Ab1HRTFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:05:20 -0400
Date: Thu, 18 Aug 2011 20:05:19 +0100
To: richard@nod.at
Subject: Subject: [PATCH 38/91] um: finish conversion to mcontext_t
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7u3-0007h0-GT@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


now we don't mix host and guest signal frame layouts anymore; moreover,
we don't need host's struct sigcontext at all.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/os-Linux/signal.c                     |    6 ++--
 arch/um/os-Linux/sys-x86/Makefile             |    2 +-
 arch/um/os-Linux/sys-x86/mcontext.c           |   31 ++++++++++++++++++++++++
 arch/um/sys-x86/shared/sysdep/mcontext.h      |   31 ++++++++++++++++++++++++
 arch/um/sys-x86/shared/sysdep/sigcontext.h    |    5 ----
 arch/um/sys-x86/shared/sysdep/sigcontext_32.h |   32 -------------------------
 arch/um/sys-x86/shared/sysdep/sigcontext_64.h |   32 -------------------------
 arch/um/sys-x86/stub_segv.c                   |    2 +-
 arch/um/sys-x86/user-offsets.c                |    7 -----
 9 files changed, 67 insertions(+), 81 deletions(-)
 create mode 100644 arch/um/os-Linux/sys-x86/mcontext.c
 create mode 100644 arch/um/sys-x86/shared/sysdep/mcontext.h
 delete mode 100644 arch/um/sys-x86/shared/sysdep/sigcontext.h
 delete mode 100644 arch/um/sys-x86/shared/sysdep/sigcontext_32.h
 delete mode 100644 arch/um/sys-x86/shared/sysdep/sigcontext_64.h

diff --git a/arch/um/os-Linux/signal.c b/arch/um/os-Linux/signal.c
index 07d9905..9f2c222 100644
--- a/arch/um/os-Linux/signal.c
+++ b/arch/um/os-Linux/signal.c
@@ -14,7 +14,7 @@
 #include "os.h"
 #include "process.h"
 #include "sysdep/barrier.h"
-#include "sysdep/sigcontext.h"
+#include "sysdep/mcontext.h"
 
 void (*sig_info[NSIG])(int, struct uml_pt_regs *) = {
 	[SIGTRAP]	= relay_signal,
@@ -34,7 +34,7 @@ static void sig_handler_common(int sig, mcontext_t *mc)
 	r.is_user = 0;
 	if (sig == SIGSEGV) {
 		/* For segfaults, we want the data from the sigcontext. */
-		copy_sc(&r, (struct sigcontext *)mc);
+		get_regs_from_mc(&r, mc);
 		GET_FAULTINFO_FROM_MC(r.faultinfo, mc);
 	}
 
@@ -84,7 +84,7 @@ static void real_alarm_handler(mcontext_t *mc)
 	struct uml_pt_regs regs;
 
 	if (mc != NULL)
-		copy_sc(&regs, (struct sigcontext *)mc);
+		get_regs_from_mc(&regs, mc);
 	regs.is_user = 0;
 	unblock_signals();
 	timer_handler(SIGVTALRM, &regs);
diff --git a/arch/um/os-Linux/sys-x86/Makefile b/arch/um/os-Linux/sys-x86/Makefile
index 22cc507..253bfb8 100644
--- a/arch/um/os-Linux/sys-x86/Makefile
+++ b/arch/um/os-Linux/sys-x86/Makefile
@@ -3,7 +3,7 @@
 # Licensed under the GPL
 #
 
-obj-y = registers.o task_size.o
+obj-y = registers.o task_size.o mcontext.o
 
 obj-$(CONFIG_X86_32) += tls.o
 obj-$(CONFIG_64BIT) += prctl.o
diff --git a/arch/um/os-Linux/sys-x86/mcontext.c b/arch/um/os-Linux/sys-x86/mcontext.c
new file mode 100644
index 0000000..1d33d72
--- /dev/null
+++ b/arch/um/os-Linux/sys-x86/mcontext.c
@@ -0,0 +1,31 @@
+#include <sys/ucontext.h>
+#define __FRAME_OFFSETS
+#include <asm/ptrace.h>
+#include <sysdep/ptrace.h>
+
+void get_regs_from_mc(struct uml_pt_regs *regs, mcontext_t *mc)
+{
+#ifdef __i386__
+#define COPY2(X,Y) regs->gp[X] = mc->gregs[REG_##Y]
+#define COPY(X) regs->gp[X] = mc->gregs[REG_##X]
+#define COPY_SEG(X) regs->gp[X] = mc->gregs[REG_##X] & 0xffff;
+#define COPY_SEG_CPL3(X) regs->gp[X] = (mc->gregs[REG_##X] & 0xffff) | 3;
+	COPY_SEG(GS); COPY_SEG(FS); COPY_SEG(ES); COPY_SEG(DS);
+	COPY(EDI); COPY(ESI); COPY(EBP);
+	COPY2(UESP, ESP); /* sic */
+	COPY(EBX); COPY(EDX); COPY(ECX); COPY(EAX);
+	COPY(EIP); COPY_SEG_CPL3(CS); COPY(EFL); COPY_SEG_CPL3(SS);
+#else
+#define COPY2(X,Y) regs->gp[X/sizeof(unsigned long)] = mc->gregs[REG_##Y]
+#define COPY(X) regs->gp[X/sizeof(unsigned long)] = mc->gregs[REG_##X]
+	COPY(R8); COPY(R9); COPY(R10); COPY(R11);
+	COPY(R12); COPY(R13); COPY(R14); COPY(R15);
+	COPY(RDI); COPY(RSI); COPY(RBP); COPY(RBX);
+	COPY(RDX); COPY(RAX); COPY(RCX); COPY(RSP);
+	COPY(RIP);
+	COPY2(EFLAGS, EFL);
+	COPY2(CS, CSGSFS);
+	regs->gp[CS / sizeof(unsigned long)] &= 0xffff;
+	regs->gp[CS / sizeof(unsigned long)] |= 3;
+#endif
+}
diff --git a/arch/um/sys-x86/shared/sysdep/mcontext.h b/arch/um/sys-x86/shared/sysdep/mcontext.h
new file mode 100644
index 0000000..b724c54
--- /dev/null
+++ b/arch/um/sys-x86/shared/sysdep/mcontext.h
@@ -0,0 +1,31 @@
+/* 
+ * Copyright (C) 2000 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
+ * Licensed under the GPL
+ */
+
+#ifndef __SYS_SIGCONTEXT_X86_H
+#define __SYS_SIGCONTEXT_X86_H
+
+extern void get_regs_from_mc(struct uml_pt_regs *, mcontext_t *);
+
+#ifdef __i386__
+
+#define GET_FAULTINFO_FROM_MC(fi, mc) \
+	{ \
+		(fi).cr2 = (mc)->cr2; \
+		(fi).error_code = (mc)->gregs[REG_ERR]; \
+		(fi).trap_no = (mc)->gregs[REG_TRAPNO]; \
+	}
+
+#else
+
+#define GET_FAULTINFO_FROM_MC(fi, mc) \
+	{ \
+		(fi).cr2 = (mc)->gregs[REG_CR2]; \
+		(fi).error_code = (mc)->gregs[REG_ERR]; \
+		(fi).trap_no = (mc)->gregs[REG_TRAPNO]; \
+	}
+
+#endif
+
+#endif
diff --git a/arch/um/sys-x86/shared/sysdep/sigcontext.h b/arch/um/sys-x86/shared/sysdep/sigcontext.h
deleted file mode 100644
index f7f49f4..0000000
--- a/arch/um/sys-x86/shared/sysdep/sigcontext.h
+++ /dev/null
@@ -1,5 +0,0 @@
-#ifdef __i386__
-#include "sigcontext_32.h"
-#else
-#include "sigcontext_64.h"
-#endif
diff --git a/arch/um/sys-x86/shared/sysdep/sigcontext_32.h b/arch/um/sys-x86/shared/sysdep/sigcontext_32.h
deleted file mode 100644
index 548c3cd..0000000
--- a/arch/um/sys-x86/shared/sysdep/sigcontext_32.h
+++ /dev/null
@@ -1,32 +0,0 @@
-/* 
- * Copyright (C) 2000 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
- * Licensed under the GPL
- */
-
-#ifndef __SYS_SIGCONTEXT_I386_H
-#define __SYS_SIGCONTEXT_I386_H
-
-#include <generated/user_constants.h>
-
-#define SC_OFFSET(sc, field) \
-	*((unsigned long *) &(((char *) (sc))[HOST_##field]))
-
-#define SC_TRAPNO(sc) SC_OFFSET(sc, SC_TRAPNO)
-#define SC_ERR(sc) SC_OFFSET(sc, SC_ERR)
-#define SC_CR2(sc) SC_OFFSET(sc, SC_CR2)
-
-#define GET_FAULTINFO_FROM_SC(fi, sc) \
-	{ \
-		(fi).cr2 = SC_CR2(sc); \
-		(fi).error_code = SC_ERR(sc); \
-		(fi).trap_no = SC_TRAPNO(sc); \
-	}
-
-#define GET_FAULTINFO_FROM_MC(fi, mc) \
-	{ \
-		(fi).cr2 = (mc)->cr2; \
-		(fi).error_code = (mc)->gregs[REG_ERR]; \
-		(fi).trap_no = (mc)->gregs[REG_TRAPNO]; \
-	}
-
-#endif
diff --git a/arch/um/sys-x86/shared/sysdep/sigcontext_64.h b/arch/um/sys-x86/shared/sysdep/sigcontext_64.h
deleted file mode 100644
index 5c4a6a3..0000000
--- a/arch/um/sys-x86/shared/sysdep/sigcontext_64.h
+++ /dev/null
@@ -1,32 +0,0 @@
-/*
- * Copyright 2003 PathScale, Inc.
- *
- * Licensed under the GPL
- */
-
-#ifndef __SYSDEP_X86_64_SIGCONTEXT_H
-#define __SYSDEP_X86_64_SIGCONTEXT_H
-
-#include <generated/user_constants.h>
-
-#define SC_OFFSET(sc, field) \
-	 *((unsigned long *) &(((char *) (sc))[HOST_##field]))
-#define SC_CR2(sc) SC_OFFSET(sc, SC_CR2)
-#define SC_ERR(sc) SC_OFFSET(sc, SC_ERR)
-#define SC_TRAPNO(sc) SC_OFFSET(sc, SC_TRAPNO)
-
-#define GET_FAULTINFO_FROM_SC(fi, sc) \
-	{ \
-		(fi).cr2 = SC_CR2(sc); \
-		(fi).error_code = SC_ERR(sc); \
-		(fi).trap_no = SC_TRAPNO(sc); \
-	}
-
-#define GET_FAULTINFO_FROM_MC(fi, mc) \
-	{ \
-		(fi).cr2 = (mc)->gregs[REG_CR2]; \
-		(fi).error_code = (mc)->gregs[REG_ERR]; \
-		(fi).trap_no = (mc)->gregs[REG_TRAPNO]; \
-	}
-
-#endif
diff --git a/arch/um/sys-x86/stub_segv.c b/arch/um/sys-x86/stub_segv.c
index bd2eaf6..b7450bd 100644
--- a/arch/um/sys-x86/stub_segv.c
+++ b/arch/um/sys-x86/stub_segv.c
@@ -5,7 +5,7 @@
 
 #include "sysdep/stub.h"
 #include "sysdep/faultinfo.h"
-#include "sysdep/sigcontext.h"
+#include "sysdep/mcontext.h"
 
 void __attribute__ ((__section__ (".__syscall_stub")))
 stub_segv_handler(int sig, siginfo_t *info, void *p)
diff --git a/arch/um/sys-x86/user-offsets.c b/arch/um/sys-x86/user-offsets.c
index 718f0c0..3c19c48 100644
--- a/arch/um/sys-x86/user-offsets.c
+++ b/arch/um/sys-x86/user-offsets.c
@@ -14,15 +14,8 @@
 #define DEFINE_LONGS(sym, val) \
 	asm volatile("\n->" #sym " %0 " #val : : "i" (val/sizeof(unsigned long)))
 
-#define OFFSET(sym, str, mem) \
-	DEFINE(sym, offsetof(struct str, mem));
-
 void foo(void)
 {
-	OFFSET(HOST_SC_TRAPNO, sigcontext, trapno);
-	OFFSET(HOST_SC_ERR, sigcontext, err);
-	OFFSET(HOST_SC_CR2, sigcontext, cr2);
-
 #ifdef __i386__
 	DEFINE_LONGS(HOST_FP_SIZE, sizeof(struct user_fpregs_struct));
 	DEFINE_LONGS(HOST_FPX_SIZE, sizeof(struct user_fpxregs_struct));
-- 
1.7.2.5


