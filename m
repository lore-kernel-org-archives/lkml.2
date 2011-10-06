Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965050Ab1JFOv6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 10:51:58 -0400
Received: from smtp-out.google.com ([74.125.121.67]:23341 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964987Ab1JFOuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 10:50:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:from:to:cc:subject:date:message-id:x-mailer:
	in-reply-to:references:x-system-of-record;
	b=cZae8vOrkOuT2pIC9tKQgFcF9z0/McyD7wOTGfL9SUKMLE0wG+QB5p7/OYMEbSbG4
	UKDnDColfGEpo3r7J5DvQ==
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@redhat.com, ming.m.lin@intel.com,
        andi@firstfloor.org, robert.richter@amd.com, ravitillo@lbl.gov
Subject: [PATCH 07/12] perf_events: add LBR software filter support for Intel X86
Date: Thu,  6 Oct 2011 16:49:10 +0200
Message-Id: <1317912555-9559-8-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1317912555-9559-1-git-send-email-eranian@google.com>
References: <1317912555-9559-1-git-send-email-eranian@google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an internal sofware filter to complement
the (optional) LBR hardware filter.

The software filter is necessary:
- as a substitute when there is no HW LBR filter (e.g., Atom, Core)
- to complement HW LBR filter in case of errata (e.g., Nehalem/Westmere)
- to provide finer grain filtering (e.g., all processors)

Sometimes, the LBR HW filter cannot distinguish between two types
of branches. For instance, to capture syscall as CALLS, it is necessary
to enable the LBR_FAR filter which will also capture JMP instructions.
Thus, a second pass is necessary to filter those out, this is what the
SW filter can do.

The SW filter is built on top of the internal x86 disassembler. It
is a best effort filter especially for user level code. It is subject
to the availability of the text page of the program.

The SW filter is enabled on all Intel X86 processors. It is bypassed
when the user is capturing all branches at all priv levels.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event.c           |    1 +
 arch/x86/kernel/cpu/perf_event_intel_ds.c  |   11 -
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |  323 +++++++++++++++++++++++++++-
 3 files changed, 316 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 711cbaf..80aa2f1 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -120,6 +120,7 @@ struct cpu_hw_events {
 	struct perf_branch_stack	lbr_stack;
 	struct perf_branch_entry	lbr_entries[MAX_LBR_ENTRIES];
 	struct er_account		*lbr_sel;
+	u64				br_sel;
 
 	/*
 	 * manage shared (per-core, per-cpu) registers
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 238d82f..085f412 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -485,17 +485,6 @@ static void intel_pmu_pebs_disable_all(void)
 		wrmsrl(MSR_IA32_PEBS_ENABLE, 0);
 }
 
-#include <asm/insn.h>
-
-static inline bool kernel_ip(unsigned long ip)
-{
-#ifdef CONFIG_X86_32
-	return ip > PAGE_OFFSET;
-#else
-	return (long)ip < 0;
-#endif
-}
-
 static int intel_pmu_pebs_fixup_ip(struct pt_regs *regs)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index 76c4639..42baefc 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -1,5 +1,7 @@
 #ifdef CONFIG_CPU_SUP_INTEL
 
+#include <asm/insn.h>
+
 enum {
 	LBR_FORMAT_32		= 0x00,
 	LBR_FORMAT_LIP		= 0x01,
@@ -54,6 +56,62 @@ enum {
 	     (x) < PERF_SAMPLE_BRANCH_MAX; (x) <<= 1)
 
 /*
+ * X86 control flow change classification
+ * X86 control flow changes include branches, interrupts, traps, faults
+ */
+enum {
+        X86_BR_NONE    = 0,      /* unknown */
+
+        X86_BR_USER    = 1 << 0, /* branch target is user */
+        X86_BR_KERNEL  = 1 << 1, /* branch target is kernel */
+
+        X86_BR_CALL    = 1 << 2, /* call */
+        X86_BR_RET     = 1 << 3, /* return */
+        X86_BR_SYSCALL = 1 << 4, /* syscall */
+        X86_BR_SYSRET  = 1 << 5, /* syscall return */
+        X86_BR_INT     = 1 << 6, /* sw interrupt */
+        X86_BR_IRET    = 1 << 7, /* return from interrupt */
+        X86_BR_JCC     = 1 << 8, /* conditional */
+        X86_BR_JMP     = 1 << 9, /* jump */
+        X86_BR_IRQ     = 1 << 10,/* hw interrupt or trap or fault */
+        X86_BR_IND_CALL= 1 << 11,/* indirect calls */
+};
+
+#define X86_BR_PLM (X86_BR_USER | X86_BR_KERNEL)
+
+#define X86_BR_ANY       \
+        (X86_BR_CALL    |\
+         X86_BR_RET     |\
+         X86_BR_SYSCALL |\
+         X86_BR_SYSRET  |\
+         X86_BR_INT     |\
+         X86_BR_IRET    |\
+         X86_BR_JCC     |\
+         X86_BR_JMP	 |\
+	 X86_BR_IRQ	 |\
+	 X86_BR_IND_CALL)
+
+#define X86_BR_ALL (X86_BR_PLM | X86_BR_ANY)
+
+#define X86_BR_ANY_CALL 	 \
+	(X86_BR_CALL		|\
+	 X86_BR_IND_CALL	|\
+	 X86_BR_SYSCALL		|\
+	 X86_BR_IRQ		|\
+	 X86_BR_INT)
+
+static void intel_pmu_lbr_filter(struct cpu_hw_events *cpuc);
+
+static inline bool kernel_ip(unsigned long ip)
+{
+#ifdef CONFIG_X86_32
+	return ip > PAGE_OFFSET;
+#else
+	return (long)ip < 0;
+#endif
+}
+
+/*
  * We only support LBR implementations that have FREEZE_LBRS_ON_PMI
  * otherwise it becomes near impossible to get a reliable stack.
  */
@@ -126,6 +184,7 @@ static void intel_pmu_lbr_enable(struct perf_event *event)
 		intel_pmu_lbr_reset();
 		cpuc->lbr_context = event->ctx;
 	}
+	cpuc->br_sel = event->hw.branch_reg.reg;
 
 	cpuc->lbr_users++;
 }
@@ -247,6 +306,45 @@ static void intel_pmu_lbr_read(void)
 		intel_pmu_lbr_read_32(cpuc);
 	else
 		intel_pmu_lbr_read_64(cpuc);
+
+	intel_pmu_lbr_filter(cpuc);
+}
+
+/*
+ * SW filter is used:
+ * - in case there is no HW filter
+ * - in case the HW filter has errata or limitations
+ */
+static void intel_pmu_setup_sw_lbr_filter(struct perf_event *event)
+{
+	u64 br_type = event->attr.branch_sample_type;
+        int mask = 0;
+
+        if (br_type & PERF_SAMPLE_BRANCH_USER)
+                mask |= X86_BR_USER;
+
+        if (br_type & PERF_SAMPLE_BRANCH_KERNEL)
+                mask |= X86_BR_KERNEL;
+
+        if (br_type & PERF_SAMPLE_BRANCH_ANY) {
+                mask |= X86_BR_ANY;
+                goto done;
+        }
+
+        if (br_type & PERF_SAMPLE_BRANCH_ANY_CALL)
+                mask |= X86_BR_ANY_CALL;
+
+        if (br_type & PERF_SAMPLE_BRANCH_ANY_RETURN)
+                mask |= X86_BR_RET | X86_BR_IRET | X86_BR_SYSRET;
+
+        if (br_type & PERF_SAMPLE_BRANCH_IND_CALL)
+                mask |= X86_BR_IND_CALL;
+done:
+        /*
+         * stash actual user request into reg, it may
+         * be used by fixup code for some CPU
+         */
+        event->hw.branch_reg.reg = mask;
 }
 
 /*
@@ -284,7 +382,7 @@ static int intel_pmu_setup_hw_lbr_filter(struct perf_event *event)
 
 static int intel_pmu_setup_lbr_filter(struct perf_event *event)
 {
-	u64 br_type = event->attr.branch_sample_type;
+	int ret = 0;
 
 	/*
 	 * no LBR on this PMU
@@ -293,15 +391,203 @@ static int intel_pmu_setup_lbr_filter(struct perf_event *event)
 		return -EOPNOTSUPP;
 
 	/*
-	 * if no LBR HW filter, users can only
-	 * capture all branches
+	 * setup SW LBR filter
 	 */
-	if (!x86_pmu.lbr_sel_map) {
-		if (br_type != PERF_SAMPLE_BRANCH_ALL)
-			return -EOPNOTSUPP;
-		return 0;
+	intel_pmu_setup_sw_lbr_filter(event);
+
+	/*
+	 * setup HW LBR filter, if any
+	 */
+        if (x86_pmu.lbr_sel_map)
+                ret = intel_pmu_setup_hw_lbr_filter(event);
+
+	return ret;
+}
+
+/*
+ * return the type of control flow change at address "from"
+ * intruction is not necessarily a branch (in case of interrupt).
+ *
+ * The branch type returned also includes the priv level of the
+ * target of the control flow change (X86_BR_USER, X86_BR_KERNEL).
+ *
+ * If a branch type is unknown OR the instruction cannot be
+ * decoded (e.g., text page not present), then X86_BR_NONE is
+ * returned.
+ */
+static int branch_type(unsigned long from, unsigned long to)
+{
+	struct insn insn;
+	void *kaddr;
+	int bytes, size = MAX_INSN_SIZE;
+	int ret = X86_BR_NONE;
+	int ext, to_plm, from_plm;
+	u8 buf[MAX_INSN_SIZE];
+
+	to_plm = kernel_ip(to) ? X86_BR_KERNEL : X86_BR_USER;
+	from_plm = kernel_ip(from) ? X86_BR_KERNEL : X86_BR_USER;
+
+	/*
+	 * maybe zero if lbr did not fill up after a reset by the time
+	 * we get a PMU interrupt
+	 */
+	if (from == 0 || to == 0)
+		return X86_BR_NONE;
+
+	if (from_plm == X86_BR_USER) {
+		/*
+		 * can happen if measuring at the user level only
+		 * and we interrupt in a kernel thread, e.g., idle.
+		 */
+		if (!current->mm)
+			return X86_BR_NONE;
+
+		/* may fail if text not present */
+		bytes = copy_from_user_nmi(buf, (void __user *)from, size);
+		if (bytes != size)
+			return X86_BR_NONE;
+
+		kaddr = buf;
+	} else
+		kaddr = (void *)from;
+
+
+	kernel_insn_init(&insn, kaddr);
+	insn_get_opcode(&insn);
+
+	switch (insn.opcode.bytes[0]) {
+	case 0xf:
+		switch(insn.opcode.bytes[1]) {
+		case 0x05: /* syscall */
+		case 0x34: /* sysenter */
+			ret = X86_BR_SYSCALL;
+			break;
+		case 0x07: /* sysret */
+		case 0x35: /* sysexit */
+			ret = X86_BR_SYSRET;
+			break;
+		case 0x80 ... 0x8f: /* conditional */
+			ret = X86_BR_JCC;
+			break;
+		default:
+			ret = X86_BR_NONE;
+		}
+		break;
+	case 0x70 ... 0x7f: /* conditional */
+		ret = X86_BR_JCC;
+		break;
+	case 0xc2: /* near ret */
+	case 0xc3: /* near ret */
+	case 0xca: /* far ret */
+	case 0xcb: /* far ret */
+		ret = X86_BR_RET;
+		break;
+	case 0xcf: /* iret */
+		ret = X86_BR_IRET;
+		break;
+	case 0xcc ... 0xce: /* int */
+		ret = X86_BR_INT;
+		break;
+	case 0xe8: /* call near rel */
+	case 0x9a: /* call far absolute */
+		ret = X86_BR_CALL;
+		break;
+	case 0xe0 ... 0xe3: /* loop jmp */
+		ret = X86_BR_JCC;
+		break;
+	case 0xe9 ... 0xeb: /* jmp */
+		ret = X86_BR_JMP;
+		break;
+	case 0xff: /* call near absolute, call far absolute ind */
+		insn_get_modrm(&insn);
+		ext = (insn.modrm.bytes[0] >> 3) & 0x7;
+		switch (ext) {
+		case 2: /* near ind call */
+		case 3: /* far ind call */
+			ret = X86_BR_IND_CALL;
+			break;
+		case 4:
+		case 5:
+			ret = X86_BR_JMP;
+			break;
+		}
+		break;
+	default:
+		ret = X86_BR_NONE;
 	}
-	return intel_pmu_setup_hw_lbr_filter(event);
+	/*
+	 * interrupts, traps, faults (and thus ring transition) may
+	 * occur on any instructions. Thus, to classify them correctly,
+	 * we need to first look at the from and to priv levels. If they
+	 * are different and to is in the kernel, then it indicates
+	 * a ring transition. If the from instruction is not a ring
+	 * transition instr (syscall, systenter, int), then it means
+	 * it was a irq, trap or fault.
+	 *
+	 * we have no way of detecting kernel to kernel faults.
+	 */
+        if (from_plm == X86_BR_USER && to_plm == X86_BR_KERNEL
+	    && ret != X86_BR_SYSCALL && ret != X86_BR_INT)
+                        ret = X86_BR_IRQ;
+
+	/*
+	 * branch priv level determined by target as
+	 * is done by HW when LBR_SELECT is implemented
+	 */
+	if (ret != X86_BR_NONE)
+		ret |= to_plm;
+
+	return ret;
+}
+
+/*
+ * implement actual branch filter based on user demand.
+ * Hardware may not exactly satisfy that request, thus
+ * we need to inspect opcodes. Mismatched branches are
+ * discarded. Therefore, the number of branches returned
+ * in PERF_SAMPLE_BRANCH_STACK sample may vary.
+ */
+static void
+intel_pmu_lbr_filter(struct cpu_hw_events *cpuc)
+{
+	u64 from, to;
+        int br_sel = cpuc->br_sel;
+        int i, j, type;
+        bool compress = false;
+
+        /* if sampling all branches, then nothing to filter */
+        if ((br_sel & X86_BR_ALL) == X86_BR_ALL)
+                return;
+
+        for (i = 0; i < cpuc->lbr_stack.nr; i++) {
+
+		from = cpuc->lbr_entries[i].from;
+		to = cpuc->lbr_entries[i].to;
+
+                type = branch_type(from, to);
+
+                /* if type does not correspond, then discard */
+                if (type == X86_BR_NONE || (br_sel & type) != type) {
+                        cpuc->lbr_entries[i].from = 0;
+                        compress = true;
+                }
+        }
+
+        if (!compress)
+                return;
+
+        /* remove all entries with from=0 */
+        for (i = 0; i < cpuc->lbr_stack.nr; ) {
+                if (!cpuc->lbr_entries[i].from) {
+                        j = i;
+                        while (++j < cpuc->lbr_stack.nr)
+                                cpuc->lbr_entries[j-1] = cpuc->lbr_entries[j];
+                        cpuc->lbr_stack.nr--;
+                        if (!cpuc->lbr_entries[i].from)
+                                continue;
+                }
+                i++;
+        }
 }
 
 /*
@@ -343,6 +629,10 @@ static void intel_pmu_lbr_init_core(void)
 	x86_pmu.lbr_from   = MSR_LBR_CORE_FROM;
 	x86_pmu.lbr_to     = MSR_LBR_CORE_TO;
 
+	/*
+	 * SW branch filter usage:
+	 * - compensate for lack of HW filter
+	 */
 	pr_cont("4-deep LBR, ");
 }
 
@@ -357,6 +647,13 @@ static void intel_pmu_lbr_init_nhm(void)
 	x86_pmu.lbr_sel_mask = LBR_SEL_MASK;
 	x86_pmu.lbr_sel_map  = nhm_lbr_sel_map;
 
+	/*
+	 * SW branch filter usage:
+	 * - workaround LBR_SEL errata (see above)
+	 * - support syscall, sysret capture.
+	 *   That requires LBR_FAR but that means far
+	 *   jmp need to be filtered out
+	 */
 	pr_cont("16-deep LBR, ");
 }
 
@@ -371,6 +668,12 @@ static void intel_pmu_lbr_init_snb(void)
 	x86_pmu.lbr_sel_mask = LBR_SEL_MASK;
 	x86_pmu.lbr_sel_map  = snb_lbr_sel_map;
 
+	/*
+	 * SW branch filter usage:
+	 * - support syscall, sysret capture.
+	 *   That requires LBR_FAR but that means far
+	 *   jmp need to be filtered out
+	 */
 	pr_cont("16-deep LBR, ");
 }
 
@@ -392,6 +695,10 @@ static void intel_pmu_lbr_init_atom(void)
 	x86_pmu.lbr_from   = MSR_LBR_CORE_FROM;
 	x86_pmu.lbr_to     = MSR_LBR_CORE_TO;
 
+	/*
+	 * SW branch filter usage:
+	 * - compensate for lack of HW filter
+	 */
 	pr_cont("8-deep LBR, ");
 }
 
-- 
1.7.4.1

