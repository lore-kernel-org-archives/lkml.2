Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759837Ab0JVTQE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:16:04 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37529 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758596Ab0JVTNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 15:13:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=LwC7f3DCL/mB9yWCz96dFCDmr4FZwwreTw/V0pXzHHccGwvqbSLXGszQ9WmWCdO1qz
         gxTr7y0Q+G/dOmeNE/fPzu6ewCIxnIaKsUPYl9y7iaX4eSeutEM/hhsUMltUR7c0tePf
         H49GCiBYGdPV3CnrzRldcpNqaA+97MkEzHKMM=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Robert Richter <robert.richter@amd.com>,
        "Frank Ch. Eigler" <fche@redhat.com>
Subject: [RFC PATCH 02/11] perf: Unified API to record selective sets of arch registers
Date: Fri, 22 Oct 2010 21:13:03 +0200
Message-Id: <1287774792-23123-3-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1287774792-23123-1-git-send-regression-fweisbec@gmail.com>
References: <1287774792-23123-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This brings a new API to help the selective dump of registers on
event sampling, and its implementation in x86-32.

- The informations about the desired registers will be passed
  to a single u64 mask. It's up to the architecture to map the
  registers into the mask bits.

- The architecture must provide a non-zero and unique id to
  identify the origin of a register set because interpreting a
  register dump requires to know from which architecture it comes.
  The achitecture is considered different between the 32 and 64 bits
  version. x86-32 has the id 1.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Frank Ch. Eigler <fche@redhat.com>
---
 arch/Kconfig                        |    7 +++
 arch/x86/Kconfig                    |    1 +
 arch/x86/include/asm/perf_regs.h    |   10 ++++
 arch/x86/include/asm/perf_regs_32.h |   85 +++++++++++++++++++++++++++++++++++
 4 files changed, 103 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/include/asm/perf_regs.h
 create mode 100644 arch/x86/include/asm/perf_regs_32.h

diff --git a/arch/Kconfig b/arch/Kconfig
index 53d7f61..a2bcd04 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -158,6 +158,13 @@ config HAVE_PERF_EVENTS_NMI
 	  subsystem.  Also has support for calculating CPU cycle events
 	  to determine how many clock cycles in a given period.
 
+config HAVE_PERF_REGS_DEFS
+	bool
+	help
+	  Support selective register dumps for perf events. This includes
+	  bit-mapping of each registers and a unique architecture version,
+	  also different between 32 and 64 bits.
+
 config HAVE_ARCH_JUMP_LABEL
 	bool
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index fd227d6..2b0ef54 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -58,6 +58,7 @@ config X86
 	select HAVE_MIXED_BREAKPOINTS_REGS
 	select PERF_EVENTS
 	select HAVE_PERF_EVENTS_NMI
+	select HAVE_PERF_REGS_DEFS if X86_32
 	select ANON_INODES
 	select HAVE_ARCH_KMEMCHECK
 	select HAVE_USER_RETURN_NOTIFIER
diff --git a/arch/x86/include/asm/perf_regs.h b/arch/x86/include/asm/perf_regs.h
new file mode 100644
index 0000000..fdf5df5
--- /dev/null
+++ b/arch/x86/include/asm/perf_regs.h
@@ -0,0 +1,10 @@
+#ifndef _ASM_X86_PERF_REGS_H
+#define _ASM_X86_PERF_REGS_H
+
+#ifdef CONFIG_X86_32
+#include "perf_regs_32.h"
+#endif
+
+/* TODO: x86-64 and compat */
+
+#endif /* _ASM_X86_PERF_REGS_H */
diff --git a/arch/x86/include/asm/perf_regs_32.h b/arch/x86/include/asm/perf_regs_32.h
new file mode 100644
index 0000000..660808b
--- /dev/null
+++ b/arch/x86/include/asm/perf_regs_32.h
@@ -0,0 +1,85 @@
+#ifndef _ASM_X86_PERF_REGS_32_H
+#define _ASM_X86_PERF_REGS_32_H
+
+#define PERF_X86_32_REG_VERSION		1ULL
+
+enum perf_event_x86_32_regs {
+	PERF_X86_32_REG_EAX,
+	PERF_X86_32_REG_EBX,
+	PERF_X86_32_REG_ECX,
+	PERF_X86_32_REG_EDX,
+	PERF_X86_32_REG_ESI,
+	PERF_X86_32_REG_EDI,
+	PERF_X86_32_REG_EBP,
+	PERF_X86_32_REG_ESP,
+	PERF_X86_32_REG_EIP,
+	PERF_X86_32_REG_FLAGS,
+	PERF_X86_32_REG_CS,
+	PERF_X86_32_REG_DS,
+	PERF_X86_32_REG_ES,
+	PERF_X86_32_REG_FS,
+	PERF_X86_32_REG_GS,
+
+	/* Non ABI */
+	PERF_X86_32_REG_MAX,
+};
+
+#ifdef __KERNEL__
+
+#define PERF_X86_32_REG_RESERVED (~((1ULL << PERF_X86_32_REG_MAX) - 1ULL))
+
+static inline u64 perf_reg_version(void)
+{
+	return PERF_X86_32_REG_VERSION;
+}
+
+static inline int perf_reg_validate(u64 mask)
+{
+	if (mask & PERF_X86_32_REG_RESERVED)
+		return -EINVAL;
+
+	return 0;
+}
+
+static inline u64 perf_reg_value(struct pt_regs *regs, int idx)
+{
+	switch (idx) {
+	case PERF_X86_32_REG_EAX:
+		return regs->ax;
+	case PERF_X86_32_REG_EBX:
+		return regs->bx;
+	case PERF_X86_32_REG_ECX:
+		return regs->cx;
+	case PERF_X86_32_REG_EDX:
+		return regs->dx;
+	case PERF_X86_32_REG_ESI:
+		return regs->si;
+	case PERF_X86_32_REG_EDI:
+		return regs->di;
+	case PERF_X86_32_REG_EBP:
+		return regs->bp;
+	case PERF_X86_32_REG_ESP:
+		return regs->sp;
+	case PERF_X86_32_REG_EIP:
+		return regs->ip;
+	case PERF_X86_32_REG_FLAGS:
+		return regs->flags;
+	case PERF_X86_32_REG_CS:
+		return regs->cs;
+	case PERF_X86_32_REG_DS:
+		return regs->ds;
+	case PERF_X86_32_REG_ES:
+		return regs->es;
+	case PERF_X86_32_REG_FS:
+		return regs->fs;
+	case PERF_X86_32_REG_GS:
+		return regs->gs;
+	}
+
+	/* Well... */
+	return 0;
+}
+
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_X86_PERF_REGS_32_H */
-- 
1.6.2.3

