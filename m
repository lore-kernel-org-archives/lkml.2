Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647Ab2DQLSK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 07:18:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49281 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755496Ab2DQLSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 07:18:08 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: eranian@google.com, gorcunov@openvz.org, tzanussi@gmail.com,
        mhiramat@redhat.com, rostedt@goodmis.org, robert.richter@amd.com,
        fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 02/16] perf: Unified API to record selective sets of arch registers
Date: Tue, 17 Apr 2012 13:17:07 +0200
Message-Id: <1334661441-4420-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1334661441-4420-1-git-send-email-jolsa@redhat.com>
References: <1334661441-4420-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This brings a new API to help the selective dump of registers on
event sampling, and its implementation in x86.

- The informations about the desired registers will be passed
  to a single u64 mask. It's up to the architecture to map the
  registers into the mask bits.

- The architecture must provide a non-zero and unique id to
  identify the origin of a register set because interpreting a
  register dump requires to know from which architecture it comes.
  The achitecture is considered different between the 32 and 64 bits
  version. x86-32 has the id 1, x86-64 has the id 2.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 arch/x86/include/asm/perf_regs.h    |   16 ++++++
 arch/x86/include/asm/perf_regs_32.h |   84 +++++++++++++++++++++++++++++
 arch/x86/include/asm/perf_regs_64.h |  101 +++++++++++++++++++++++++++++++++++
 include/asm-generic/perf_regs.h     |   23 ++++++++
 4 files changed, 224 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/include/asm/perf_regs.h
 create mode 100644 arch/x86/include/asm/perf_regs_32.h
 create mode 100644 arch/x86/include/asm/perf_regs_64.h
 create mode 100644 include/asm-generic/perf_regs.h

diff --git a/arch/x86/include/asm/perf_regs.h b/arch/x86/include/asm/perf_regs.h
new file mode 100644
index 0000000..80b7fbe
--- /dev/null
+++ b/arch/x86/include/asm/perf_regs.h
@@ -0,0 +1,16 @@
+#ifndef _ASM_X86_PERF_REGS_H
+#define _ASM_X86_PERF_REGS_H
+
+enum {
+	PERF_REGS_VERSION_NONE   = 0UL,
+	PERF_REGS_VERSION_X86_32 = 1UL,
+	PERF_REGS_VERSION_X86_64 = 2UL,
+};
+
+#ifdef CONFIG_X86_32
+#include "perf_regs_32.h"
+#else
+#include "perf_regs_64.h"
+#endif
+
+#endif /* _ASM_X86_PERF_REGS_H */
diff --git a/arch/x86/include/asm/perf_regs_32.h b/arch/x86/include/asm/perf_regs_32.h
new file mode 100644
index 0000000..3c5aa80
--- /dev/null
+++ b/arch/x86/include/asm/perf_regs_32.h
@@ -0,0 +1,84 @@
+#ifndef _ASM_X86_PERF_REGS_32_H
+#define _ASM_X86_PERF_REGS_32_H
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
+	PERF_REG_IP = PERF_X86_32_REG_EIP,
+	PERF_REG_SP = PERF_X86_32_REG_ESP,
+};
+
+#ifdef __KERNEL__
+
+#define PERF_X86_32_REG_RESERVED (~((1ULL << PERF_X86_32_REG_MAX) - 1ULL))
+
+static inline u64 perf_reg_version(void)
+{
+	return PERF_REGS_VERSION_X86_32;
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
+	return 0;
+}
+
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_X86_PERF_REGS_32_H */
diff --git a/arch/x86/include/asm/perf_regs_64.h b/arch/x86/include/asm/perf_regs_64.h
new file mode 100644
index 0000000..d775213
--- /dev/null
+++ b/arch/x86/include/asm/perf_regs_64.h
@@ -0,0 +1,101 @@
+#ifndef _ASM_X86_PERF_REGS_64_H
+#define _ASM_X86_PERF_REGS_64_H
+
+#define PERF_X86_64_REG_VERSION		1ULL
+
+enum perf_event_x86_64_regs {
+	PERF_X86_64_REG_RAX,
+	PERF_X86_64_REG_RBX,
+	PERF_X86_64_REG_RCX,
+	PERF_X86_64_REG_RDX,
+	PERF_X86_64_REG_RSI,
+	PERF_X86_64_REG_RDI,
+	PERF_X86_64_REG_R8,
+	PERF_X86_64_REG_R9,
+	PERF_X86_64_REG_R10,
+	PERF_X86_64_REG_R11,
+	PERF_X86_64_REG_R12,
+	PERF_X86_64_REG_R13,
+	PERF_X86_64_REG_R14,
+	PERF_X86_64_REG_R15,
+	PERF_X86_64_REG_RBP,
+	PERF_X86_64_REG_RSP,
+	PERF_X86_64_REG_RIP,
+	PERF_X86_64_REG_FLAGS,
+	PERF_X86_64_REG_CS,
+	PERF_X86_64_REG_SS,
+
+	/* Non ABI */
+	PERF_X86_64_REG_MAX,
+	PERF_REG_IP = PERF_X86_64_REG_RIP,
+	PERF_REG_SP = PERF_X86_64_REG_RSP,
+};
+
+#ifdef __KERNEL__
+
+#define PERF_X86_64_REG_RESERVED (~((1ULL << PERF_X86_64_REG_MAX) - 1ULL))
+
+static inline u64 perf_reg_version(void)
+{
+	return PERF_REGS_VERSION_X86_64;
+}
+
+static inline int perf_reg_validate(u64 mask)
+{
+	if (mask & PERF_X86_64_REG_RESERVED)
+		return -EINVAL;
+
+	return 0;
+}
+
+static inline u64 perf_reg_value(struct pt_regs *regs, int idx)
+{
+	switch (idx) {
+	case PERF_X86_64_REG_RAX:
+		return regs->ax;
+	case PERF_X86_64_REG_RBX:
+		return regs->bx;
+	case PERF_X86_64_REG_RCX:
+		return regs->cx;
+	case PERF_X86_64_REG_RDX:
+		return regs->dx;
+	case PERF_X86_64_REG_RSI:
+		return regs->si;
+	case PERF_X86_64_REG_RDI:
+		return regs->di;
+	case PERF_X86_64_REG_R8:
+		return regs->r8;
+	case PERF_X86_64_REG_R9:
+		return regs->r9;
+	case PERF_X86_64_REG_R10:
+		return regs->r10;
+	case PERF_X86_64_REG_R11:
+		return regs->r11;
+	case PERF_X86_64_REG_R12:
+		return regs->r12;
+	case PERF_X86_64_REG_R13:
+		return regs->r13;
+	case PERF_X86_64_REG_R14:
+		return regs->r14;
+	case PERF_X86_64_REG_R15:
+		return regs->r15;
+	case PERF_X86_64_REG_RBP:
+		return regs->bp;
+	case PERF_X86_64_REG_RSP:
+		return regs->sp;
+	case PERF_X86_64_REG_RIP:
+		return regs->ip;
+	case PERF_X86_64_REG_FLAGS:
+		return regs->flags;
+	case PERF_X86_64_REG_CS:
+		return regs->cs;
+	case PERF_X86_64_REG_SS:
+		return regs->ss;
+	}
+
+	return 0;
+}
+
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_X86_PERF_REGS_64_H */
diff --git a/include/asm-generic/perf_regs.h b/include/asm-generic/perf_regs.h
new file mode 100644
index 0000000..f616096
--- /dev/null
+++ b/include/asm-generic/perf_regs.h
@@ -0,0 +1,23 @@
+#ifndef __ASM_GENERIC_PERF_REGS_H
+#define __ASM_GENERIC_PERF_REGS_H
+
+enum {
+	PERF_REGS_VERSION_NONE = 0UL,
+};
+
+static inline int perf_reg_value(struct pt_regs *regs, int idx)
+{
+	return 0;
+}
+
+static inline int perf_reg_version(void)
+{
+	return PERF_REGS_VERSION_NONE;
+}
+
+static inline int perf_reg_validate(u64 mask)
+{
+	return mask ? -ENOSYS : 0;
+}
+
+#endif /* __ASM_GENERIC_PERF_REGS_H */
-- 
1.7.7.6

