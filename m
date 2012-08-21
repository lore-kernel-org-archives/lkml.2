Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328Ab2HUPqN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:46:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60154 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324Ab2HUPqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:46:10 -0400
Date: Tue, 21 Aug 2012 08:45:38 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-c5e63197db519bae1c33e41ea0342a50f39e7a93@git.kernel.org>
Cc: acme@redhat.com, eranian@google.com, mingo@kernel.org, gorcunov@openvz.org,
        a.p.zijlstra@chello.nl, benjamin.redelings@nescent.org,
        jolsa@redhat.com, drepper@gmail.com, robert.richter@amd.com,
        fweisbec@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        asharma@fb.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        fche@redhat.com, paulus@samba.org, tzanussi@gmail.com,
        masami.hiramatsu.pt@hitachi.com
Reply-To: mingo@kernel.org, eranian@google.com, acme@redhat.com,
        gorcunov@openvz.org, a.p.zijlstra@chello.nl,
        benjamin.redelings@nescent.org, jolsa@redhat.com, fweisbec@gmail.com,
        robert.richter@amd.com, drepper@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, asharma@fb.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com, fche@redhat.com,
        tzanussi@gmail.com, masami.hiramatsu.pt@hitachi.com
In-Reply-To: <1344345647-11536-2-git-send-email-jolsa@redhat.com>
References: <1344345647-11536-2-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf:
  Unified API to record selective sets of arch registers
Git-Commit-ID: c5e63197db519bae1c33e41ea0342a50f39e7a93
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 08:45:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c5e63197db519bae1c33e41ea0342a50f39e7a93
Gitweb:     http://git.kernel.org/tip/c5e63197db519bae1c33e41ea0342a50f39e7a93
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 7 Aug 2012 15:20:36 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 10 Aug 2012 11:21:37 -0300

perf: Unified API to record selective sets of arch registers

This brings a new API to help the selective dump of registers on event
sampling, and its implementation for x86 arch.

Added HAVE_PERF_REGS config option to determine if the architecture
provides perf registers ABI.

The information about desired registers will be passed in u64 mask.
It's up to the architecture to map the registers into the mask bits.

For the x86 arch implementation, both 32 and 64 bit registers bits are
defined within single enum to ensure 64 bit system can provide register
dump for compat task if needed in the future.

Original-patch-by: Frederic Weisbecker <fweisbec@gmail.com>
[ Added missing linux/errno.h include ]
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Arun Sharma <asharma@fb.com>
Cc: Benjamin Redelings <benjamin.redelings@nescent.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Ulrich Drepper <drepper@gmail.com>
Link: http://lkml.kernel.org/r/1344345647-11536-2-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 arch/Kconfig                     |    6 +++
 arch/x86/Kconfig                 |    1 +
 arch/x86/include/asm/perf_regs.h |   33 ++++++++++++++
 arch/x86/kernel/Makefile         |    2 +
 arch/x86/kernel/perf_regs.c      |   90 ++++++++++++++++++++++++++++++++++++++
 include/linux/perf_regs.h        |   19 ++++++++
 6 files changed, 151 insertions(+), 0 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 72f2fa1..68d827b 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -222,6 +222,12 @@ config HAVE_PERF_EVENTS_NMI
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
index 8ec3a1a..3fab6ec 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -60,6 +60,7 @@ config X86
 	select HAVE_MIXED_BREAKPOINTS_REGS
 	select PERF_EVENTS
 	select HAVE_PERF_EVENTS_NMI
+	select HAVE_PERF_REGS
 	select ANON_INODES
 	select HAVE_ALIGNED_STRUCT_PAGE if SLUB && !M386
 	select HAVE_CMPXCHG_LOCAL if !M386
diff --git a/arch/x86/include/asm/perf_regs.h b/arch/x86/include/asm/perf_regs.h
new file mode 100644
index 0000000..3f2207b
--- /dev/null
+++ b/arch/x86/include/asm/perf_regs.h
@@ -0,0 +1,33 @@
+#ifndef _ASM_X86_PERF_REGS_H
+#define _ASM_X86_PERF_REGS_H
+
+enum perf_event_x86_regs {
+	PERF_REG_X86_AX,
+	PERF_REG_X86_BX,
+	PERF_REG_X86_CX,
+	PERF_REG_X86_DX,
+	PERF_REG_X86_SI,
+	PERF_REG_X86_DI,
+	PERF_REG_X86_BP,
+	PERF_REG_X86_SP,
+	PERF_REG_X86_IP,
+	PERF_REG_X86_FLAGS,
+	PERF_REG_X86_CS,
+	PERF_REG_X86_SS,
+	PERF_REG_X86_DS,
+	PERF_REG_X86_ES,
+	PERF_REG_X86_FS,
+	PERF_REG_X86_GS,
+	PERF_REG_X86_R8,
+	PERF_REG_X86_R9,
+	PERF_REG_X86_R10,
+	PERF_REG_X86_R11,
+	PERF_REG_X86_R12,
+	PERF_REG_X86_R13,
+	PERF_REG_X86_R14,
+	PERF_REG_X86_R15,
+
+	PERF_REG_X86_32_MAX = PERF_REG_X86_GS + 1,
+	PERF_REG_X86_64_MAX = PERF_REG_X86_R15 + 1,
+};
+#endif /* _ASM_X86_PERF_REGS_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 8215e56..8d7a619 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -100,6 +100,8 @@ obj-$(CONFIG_SWIOTLB)			+= pci-swiotlb.o
 obj-$(CONFIG_OF)			+= devicetree.o
 obj-$(CONFIG_UPROBES)			+= uprobes.o
 
+obj-$(CONFIG_PERF_EVENTS)		+= perf_regs.o
+
 ###
 # 64 bit specific files
 ifeq ($(CONFIG_X86_64),y)
diff --git a/arch/x86/kernel/perf_regs.c b/arch/x86/kernel/perf_regs.c
new file mode 100644
index 0000000..3d692352
--- /dev/null
+++ b/arch/x86/kernel/perf_regs.c
@@ -0,0 +1,90 @@
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/bug.h>
+#include <linux/stddef.h>
+#include <asm/perf_regs.h>
+#include <asm/ptrace.h>
+
+#ifdef CONFIG_X86_32
+#define PERF_REG_X86_MAX PERF_REG_X86_32_MAX
+#else
+#define PERF_REG_X86_MAX PERF_REG_X86_64_MAX
+#endif
+
+#define PT_REGS_OFFSET(id, r) [id] = offsetof(struct pt_regs, r)
+
+static unsigned int pt_regs_offset[PERF_REG_X86_MAX] = {
+	PT_REGS_OFFSET(PERF_REG_X86_AX, ax),
+	PT_REGS_OFFSET(PERF_REG_X86_BX, bx),
+	PT_REGS_OFFSET(PERF_REG_X86_CX, cx),
+	PT_REGS_OFFSET(PERF_REG_X86_DX, dx),
+	PT_REGS_OFFSET(PERF_REG_X86_SI, si),
+	PT_REGS_OFFSET(PERF_REG_X86_DI, di),
+	PT_REGS_OFFSET(PERF_REG_X86_BP, bp),
+	PT_REGS_OFFSET(PERF_REG_X86_SP, sp),
+	PT_REGS_OFFSET(PERF_REG_X86_IP, ip),
+	PT_REGS_OFFSET(PERF_REG_X86_FLAGS, flags),
+	PT_REGS_OFFSET(PERF_REG_X86_CS, cs),
+	PT_REGS_OFFSET(PERF_REG_X86_SS, ss),
+#ifdef CONFIG_X86_32
+	PT_REGS_OFFSET(PERF_REG_X86_DS, ds),
+	PT_REGS_OFFSET(PERF_REG_X86_ES, es),
+	PT_REGS_OFFSET(PERF_REG_X86_FS, fs),
+	PT_REGS_OFFSET(PERF_REG_X86_GS, gs),
+#else
+	/*
+	 * The pt_regs struct does not store
+	 * ds, es, fs, gs in 64 bit mode.
+	 */
+	(unsigned int) -1,
+	(unsigned int) -1,
+	(unsigned int) -1,
+	(unsigned int) -1,
+#endif
+#ifdef CONFIG_X86_64
+	PT_REGS_OFFSET(PERF_REG_X86_R8, r8),
+	PT_REGS_OFFSET(PERF_REG_X86_R9, r9),
+	PT_REGS_OFFSET(PERF_REG_X86_R10, r10),
+	PT_REGS_OFFSET(PERF_REG_X86_R11, r11),
+	PT_REGS_OFFSET(PERF_REG_X86_R12, r12),
+	PT_REGS_OFFSET(PERF_REG_X86_R13, r13),
+	PT_REGS_OFFSET(PERF_REG_X86_R14, r14),
+	PT_REGS_OFFSET(PERF_REG_X86_R15, r15),
+#endif
+};
+
+u64 perf_reg_value(struct pt_regs *regs, int idx)
+{
+	if (WARN_ON_ONCE(idx > ARRAY_SIZE(pt_regs_offset)))
+		return 0;
+
+	return regs_get_register(regs, pt_regs_offset[idx]);
+}
+
+#define REG_RESERVED (~((1ULL << PERF_REG_X86_MAX) - 1ULL))
+
+#ifdef CONFIG_X86_32
+int perf_reg_validate(u64 mask)
+{
+	if (!mask || mask & REG_RESERVED)
+		return -EINVAL;
+
+	return 0;
+}
+#else /* CONFIG_X86_64 */
+#define REG_NOSUPPORT ((1ULL << PERF_REG_X86_DS) | \
+		       (1ULL << PERF_REG_X86_ES) | \
+		       (1ULL << PERF_REG_X86_FS) | \
+		       (1ULL << PERF_REG_X86_GS))
+
+int perf_reg_validate(u64 mask)
+{
+	if (!mask || mask & REG_RESERVED)
+		return -EINVAL;
+
+	if (mask & REG_NOSUPPORT)
+		return -EINVAL;
+
+	return 0;
+}
+#endif /* CONFIG_X86_32 */
diff --git a/include/linux/perf_regs.h b/include/linux/perf_regs.h
new file mode 100644
index 0000000..a2f1a98
--- /dev/null
+++ b/include/linux/perf_regs.h
@@ -0,0 +1,19 @@
+#ifndef _LINUX_PERF_REGS_H
+#define _LINUX_PERF_REGS_H
+
+#ifdef CONFIG_HAVE_PERF_REGS
+#include <asm/perf_regs.h>
+u64 perf_reg_value(struct pt_regs *regs, int idx);
+int perf_reg_validate(u64 mask);
+#else
+static inline u64 perf_reg_value(struct pt_regs *regs, int idx)
+{
+	return 0;
+}
+
+static inline int perf_reg_validate(u64 mask)
+{
+	return mask ? -ENOSYS : 0;
+}
+#endif /* CONFIG_HAVE_PERF_REGS */
+#endif /* _LINUX_PERF_REGS_H */
