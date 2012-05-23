Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933976Ab2EWTcs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 15:32:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57723 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933921Ab2EWTco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 15:32:44 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: eranian@google.com, gorcunov@openvz.org, tzanussi@gmail.com,
        mhiramat@redhat.com, robert.richter@amd.com, fche@redhat.com,
        linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        drepper@gmail.com, asharma@fb.com, benjamin.redelings@nescent.org,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 01/16] perf: Unified API to record selective sets of arch registers
Date: Wed, 23 May 2012 21:32:00 +0200
Message-Id: <1337801535-12865-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1337801535-12865-1-git-send-email-jolsa@redhat.com>
References: <1337801535-12865-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This brings a new API to help the selective dump of registers on
event sampling, and its implementation in x86.

Added HAVE_PERF_REGS config option to determine if the architecture
provides perf registers ABI.

The architecture must provide a non-zero and unique id to
identify the origin of a register set because interpreting a
register dump requires to know from which architecture it comes.
The achitecture is considered different between the 32 and 64 bits.
x86-32 has the id 1, x86-64 has the id 2.

The information about desired registers will be passed
in u64 mask. It's up to the architecture to map the
registers into the mask bits.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 arch/Kconfig                        |    6 ++
 arch/x86/Kconfig                    |    1 +
 arch/x86/include/asm/perf_regs.h    |   10 ++++
 arch/x86/include/asm/perf_regs_32.h |   84 +++++++++++++++++++++++++++++
 arch/x86/include/asm/perf_regs_64.h |   99 +++++++++++++++++++++++++++++++++++
 include/linux/perf_regs.h           |   28 ++++++++++
 6 files changed, 228 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/include/asm/perf_regs.h
 create mode 100644 arch/x86/include/asm/perf_regs_32.h
 create mode 100644 arch/x86/include/asm/perf_regs_64.h
 create mode 100644 include/linux/perf_regs.h

diff --git a/arch/Kconfig b/arch/Kconfig
index e9a9108..6c37af4 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -219,6 +219,12 @@ config HAVE_PERF_EVENTS_NMI
 	  subsystem.  Also has support for calculating CPU cycle events
 	  to determine how many clock cycles in a given period.
 
+config HAVE_PERF_REGS
+	bool
+	help
+	  Support selective register dumps for perf events. This includes
+	  bit-mapping of each registers and a unique architecture id.
+
 config HAVE_ARCH_JUMP_LABEL
 	bool
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5638c74..77e155c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -59,6 +59,7 @@ config X86
 	select HAVE_MIXED_BREAKPOINTS_REGS
 	select PERF_EVENTS
 	select HAVE_PERF_EVENTS_NMI
+	select HAVE_PERF_REGS
 	select ANON_INODES
 	select HAVE_ALIGNED_STRUCT_PAGE if SLUB && !M386
 	select HAVE_CMPXCHG_LOCAL if !M386
diff --git a/arch/x86/include/asm/perf_regs.h b/arch/x86/include/asm/perf_regs.h
new file mode 100644
index 0000000..c2ea804
--- /dev/null
+++ b/arch/x86/include/asm/perf_regs.h
@@ -0,0 +1,10 @@
+#ifndef _ASM_X86_PERF_REGS_H
+#define _ASM_X86_PERF_REGS_H
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
index 0000000..8201750
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
+};
+
+enum {
+	PERF_REGS_ABI_X86_32 = 1UL
+};
+
+static inline u64 perf_reg_version(void)
+{
+	return PERF_REGS_ABI_X86_32;
+}
+
+#ifdef __KERNEL__
+#define PERF_X86_32_REG_RESERVED (~((1ULL << PERF_X86_32_REG_MAX) - 1ULL))
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
+#endif /* _ASM_X86_PERF_REGS_32_H */
diff --git a/arch/x86/include/asm/perf_regs_64.h b/arch/x86/include/asm/perf_regs_64.h
new file mode 100644
index 0000000..63d7f1f
--- /dev/null
+++ b/arch/x86/include/asm/perf_regs_64.h
@@ -0,0 +1,99 @@
+#ifndef _ASM_X86_PERF_REGS_64_H
+#define _ASM_X86_PERF_REGS_64_H
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
+};
+
+enum {
+	PERF_REGS_ABI_X86_64 = 2UL
+};
+
+static inline u64 perf_reg_version(void)
+{
+	return PERF_REGS_ABI_X86_64;
+}
+
+#ifdef __KERNEL__
+#define PERF_X86_64_REG_RESERVED (~((1ULL << PERF_X86_64_REG_MAX) - 1ULL))
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
+#endif /* _ASM_X86_PERF_REGS_64_H */
diff --git a/include/linux/perf_regs.h b/include/linux/perf_regs.h
new file mode 100644
index 0000000..3d761d5
--- /dev/null
+++ b/include/linux/perf_regs.h
@@ -0,0 +1,28 @@
+#ifndef _LINUX_PERF_REGS_H
+#define _LINUX_PERF_REGS_H
+
+enum {
+	PERF_REGS_ABI_NONE = 0UL,
+};
+
+#ifdef CONFIG_HAVE_PERF_REGS
+#include <asm/perf_regs.h>
+#else
+static inline unsigned long perf_reg_version(void)
+{
+	return PERF_REGS_ABI_NONE;
+}
+
+#ifdef __KERNEL__
+static inline unsigned long perf_reg_value(struct pt_regs *regs, int idx)
+{
+	return 0;
+}
+
+static inline int perf_reg_validate(u64 mask)
+{
+	return mask ? -ENOSYS : 0;
+}
+#endif /* __KERNEL__ */
+#endif /* CONFIG_HAVE_PERF_REGS */
+#endif /* __ASM_GENERIC_PERF_REGS_H */
-- 
1.7.7.6

