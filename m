Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab2GJJCv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 05:02:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47053 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab2GJJCs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 05:02:48 -0400
Message-ID: <1341910954.3462.102.camel@twins>
Subject: Re: [tip:perf/core] perf/x86: Fix USER/KERNEL tagging of samples
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        akpm@linux-foundation.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org,
        Robert Richter <robert.richter@amd.com>
Date: Tue, 10 Jul 2012 11:02:34 +0200
In-Reply-To: <CA+55aFyF-GT-BAjLCvwZPFCCKkkYz0ZznSSOYw4RVYizZhLE0g@mail.gmail.com>
References: <tip-xxrt0a1zronm1sm36obwc2vy@git.kernel.org>
	 <CA+55aFxY7SqwSQWuRXSg+W=ftp9FtCT1MMEqMiCi1H279Fis-A@mail.gmail.com>
	 <1341598329.7709.57.camel@twins>
	 <CA+55aFzqoz7dcUCQfSrXxX2T8=2wgWdb1H2vaBhk7V-r0uaogw@mail.gmail.com>
	 <CA+55aFw+vE4zMe1bJohLuoMDaFpqGCz6sBNRE8gkV7JOvtro0g@mail.gmail.com>
	 <1341832997.3462.41.camel@twins>
	 <CA+55aFyF-GT-BAjLCvwZPFCCKkkYz0ZznSSOYw4RVYizZhLE0g@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-09 at 10:55 -0700, Linus Torvalds wrote:
> However, it is worth pointing out that sp/bp have exactly the same
> segment base issue. So if you do stack tracing into user mode, you
> should really do the same thing for those. And quite frankly, at that
> point vm86 mode and the stack segment matters in other ways than just
> the base pointer: a 16-bit stack segment acts fundamentally
> differently from a 32-bit one. So at that point it may well make much
> more sense to take the approach Ingo suggests, and simply not follow
> stack frames at all. 

Right, so I amended the patch to ignore vm86 stacks and added
{cs,ss}_base magic to ia32 stacks.

Ingo, do you want me to do a version where I simply bail on everything
if regs->{cs,ss} != {__USER_CS, __USER32_CS} || regs->flags & VM ?

---
Subject: perf/x86: Fix USER/KERNEL tagging of samples properly
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Tue Jul 10 09:42:15 CEST 2012

Some PMUs don't provide a full register set for their sample,
specifically 'advanced' PMUs like AMD IBS and Intel PEBS which provide
'better' than regular interrupt accuracy.

In this case we use the interrupt regs as basis and over-write some
fields (typically IP) with different information.

The perf core however uses user_mode() to distinguish user/kernel
samples, user_mode() relies on regs->cs. If the interrupt skid pushed
us over a boundary the new IP might not be in the same domain as the
interrupt.

Commit ce5c1fe9a9e ("perf/x86: Fix USER/KERNEL tagging of samples")
tried to fix this by making the perf core use kernel_ip(). This
however is wrong (TM), as pointed out by Linus, since it doesn't allow
for VM86 and non-zero based segments in IA32 mode.

Therefore, provide a new helper to set the regs->ip field,
set_linear_ip(), which massages the regs into a suitable state
assuming the provided IP is in fact a linear address.

Also modify perf_instruction_pointer() and perf_callchain_user() to
deal with segments base offsets.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/include/asm/perf_event.h         |   11 ++-
 arch/x86/kernel/cpu/perf_event.c          |   89 ++++++++++++++++++++++++++----
 arch/x86/kernel/cpu/perf_event.h          |   20 ++++++
 arch/x86/kernel/cpu/perf_event_amd_ibs.c  |    4 +
 arch/x86/kernel/cpu/perf_event_intel_ds.c |    7 +-
 5 files changed, 114 insertions(+), 17 deletions(-)

--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -196,11 +196,16 @@ static inline u32 get_ibs_caps(void) { r
 extern void perf_events_lapic_init(void);
 
 /*
- * Abuse bit 3 of the cpu eflags register to indicate proper PEBS IP fixups.
- * This flag is otherwise unused and ABI specified to be 0, so nobody should
- * care what we do with it.
+ * Abuse bits {3,5} of the cpu eflags register. These flags are otherwise
+ * unused and ABI specified to be 0, so nobody should care what we do with
+ * them.
+ *
+ * EXACT    - the IP points to the exact instruction that triggered the
+ *            event (HW bugs exempt).
+ * NOUNWIND - do no unwind the stack.
  */
 #define PERF_EFLAGS_EXACT	(1UL << 3)
+#define PERF_EFLAGS_NOUNWIND	(1UL << 5)
 
 struct pt_regs;
 extern unsigned long perf_instruction_pointer(struct pt_regs *regs);
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -32,6 +32,8 @@
 #include <asm/smp.h>
 #include <asm/alternative.h>
 #include <asm/timer.h>
+#include <asm/desc.h>
+#include <asm/ldt.h>
 
 #include "perf_event.h"
 
@@ -1738,6 +1740,29 @@ valid_user_frame(const void __user *fp,
 	return (__range_not_ok(fp, size, TASK_SIZE) == 0);
 }
 
+static unsigned long get_segment_base(unsigned int segment)
+{
+	struct desc_struct *desc;
+	int idx = segment >> 3;
+
+	if ((segment & SEGMENT_TI_MASK) == SEGMENT_LDT) {
+		if (idx > LDT_ENTRIES)
+			return 0;
+
+		if (idx > current->active_mm->context.size)
+			return 0;
+
+		desc = current->active_mm->context.ldt;
+	} else {
+		if (idx > GDT_ENTRIES)
+			return 0;
+
+		desc = __this_cpu_ptr(&gdt_page.gdt[0]);
+	}
+
+	return get_desc_base(desc + idx);
+}
+
 #ifdef CONFIG_COMPAT
 
 #include <asm/compat.h>
@@ -1746,13 +1771,17 @@ static inline int
 perf_callchain_user32(struct pt_regs *regs, struct perf_callchain_entry *entry)
 {
 	/* 32-bit process in 64-bit kernel. */
+	unsigned long ss_base, cs_base;
 	struct stack_frame_ia32 frame;
 	const void __user *fp;
 
 	if (!test_thread_flag(TIF_IA32))
 		return 0;
 
-	fp = compat_ptr(regs->bp);
+	cs_base = get_segment_base(regs->cs);
+	ss_base = get_segment_base(regs->ss);
+
+	fp = compat_ptr(ss_base + regs->bp);
 	while (entry->nr < PERF_MAX_STACK_DEPTH) {
 		unsigned long bytes;
 		frame.next_frame     = 0;
@@ -1765,8 +1794,8 @@ perf_callchain_user32(struct pt_regs *re
 		if (!valid_user_frame(fp, sizeof(frame)))
 			break;
 
-		perf_callchain_store(entry, frame.return_address);
-		fp = compat_ptr(frame.next_frame);
+		perf_callchain_store(entry, cs_base + frame.return_address);
+		fp = compat_ptr(ss_base + frame.next_frame);
 	}
 	return 1;
 }
@@ -1789,6 +1818,12 @@ perf_callchain_user(struct perf_callchai
 		return;
 	}
 
+	/*
+	 * We don't know what to do with VM86 stacks.. ignore them for now.
+	 */
+	if (regs->flags & (X86_VM_MASK | PERF_EFLAGS_NOUNWIND))
+		return;
+
 	fp = (void __user *)regs->bp;
 
 	perf_callchain_store(entry, regs->ip);
@@ -1816,16 +1851,50 @@ perf_callchain_user(struct perf_callchai
 	}
 }
 
-unsigned long perf_instruction_pointer(struct pt_regs *regs)
+/*
+ * Deal with code segment offsets for the various execution modes:
+ *
+ *   VM86 - the good olde 16 bit days, where the linear address is
+ *          20 bits and we use regs->ip + 0x10 * regs->cs.
+ *
+ *   IA32 - Where we need to look at GDT/LDT segment descriptor tables
+ *          to figure out what the 32bit base address is.
+ *
+ *    X32 - has TIF_X32 set, but is running in x86_64
+ *
+ * X86_64 - CS,DS,SS,ES are all zero based.
+ */
+static unsigned long code_segment_base(struct pt_regs *regs)
 {
-	unsigned long ip;
+	/*
+	 * If we are in VM86 mode, add the segment offset to convert to a
+	 * linear address.
+	 */
+	if (regs->flags & X86_VM_MASK)
+		return 0x10 * regs->cs;
+
+	/*
+	 * For IA32 we look at the GDT/LDT segment base to convert the
+	 * effective IP to a linear address.
+	 */
+#ifdef CONFIG_32BIT
+	if (user_mode(regs) && regs->cs != __USER_CS)
+		return get_segment_base(regs->cs);
+#else
+	if (test_thread_flag(TIF_IA32)) {
+		if (user_mode(regs) && regs->cs != __USER32_CS)
+			return get_segment_base(regs->cs);
+	}
+#endif
+	return 0;
+}
 
+unsigned long perf_instruction_pointer(struct pt_regs *regs)
+{
 	if (perf_guest_cbs && perf_guest_cbs->is_in_guest())
-		ip = perf_guest_cbs->get_guest_ip();
-	else
-		ip = instruction_pointer(regs);
+		return perf_guest_cbs->get_guest_ip();
 
-	return ip;
+	return regs->ip + code_segment_base(regs);
 }
 
 unsigned long perf_misc_flags(struct pt_regs *regs)
@@ -1838,7 +1907,7 @@ unsigned long perf_misc_flags(struct pt_
 		else
 			misc |= PERF_RECORD_MISC_GUEST_KERNEL;
 	} else {
-		if (!kernel_ip(regs->ip))
+		if (user_mode(regs))
 			misc |= PERF_RECORD_MISC_USER;
 		else
 			misc |= PERF_RECORD_MISC_KERNEL;
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -516,6 +516,26 @@ static inline bool kernel_ip(unsigned lo
 #endif
 }
 
+/*
+ * Not all PMUs provide the right context information to place the reported IP
+ * into full context. Specifically segment registers are typically not
+ * supplied.
+ *
+ * Assuming the address is a linear address (it is for IBS), we fake the CS and
+ * vm86 mode using the known zero-based code segment and 'fix up' the registers
+ * to reflect this.
+ *
+ * Intel PEBS/LBR appear to typically provide the effective address, nothing
+ * much we can do about that but pray and treat it like a linear address.
+ */
+static inline void set_linear_ip(struct pt_regs *regs, unsigned long ip)
+{
+	regs->cs = kernel_ip(ip) ? __KERNEL_CS : __USER_CS;
+	if (regs->flags & X86_VM_MASK)
+		regs->flags ^= (PERF_EFLAGS_NOUNWIND | X86_VM_MASK);
+	regs->ip = ip;
+}
+
 #ifdef CONFIG_CPU_SUP_AMD
 
 int amd_pmu_init(void);
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -13,6 +13,8 @@
 
 #include <asm/apic.h>
 
+#include "perf_event.h"
+
 static u32 ibs_caps;
 
 #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_AMD)
@@ -536,7 +538,7 @@ static int perf_ibs_handle_irq(struct pe
 	if (check_rip && (ibs_data.regs[2] & IBS_RIP_INVALID)) {
 		regs.flags &= ~PERF_EFLAGS_EXACT;
 	} else {
-		instruction_pointer_set(&regs, ibs_data.regs[1]);
+		set_linear_ip(&regs, ibs_data.regs[1]);
 		regs.flags |= PERF_EFLAGS_EXACT;
 	}
 
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -499,7 +499,7 @@ static int intel_pmu_pebs_fixup_ip(struc
 	 * We sampled a branch insn, rewind using the LBR stack
 	 */
 	if (ip == to) {
-		regs->ip = from;
+		set_linear_ip(regs, from);
 		return 1;
 	}
 
@@ -529,7 +529,7 @@ static int intel_pmu_pebs_fixup_ip(struc
 	} while (to < ip);
 
 	if (to == ip) {
-		regs->ip = old_to;
+		set_linear_ip(regs, old_to);
 		return 1;
 	}
 
@@ -569,7 +569,8 @@ static void __intel_pmu_pebs_event(struc
 	 * A possible PERF_SAMPLE_REGS will have to transfer all regs.
 	 */
 	regs = *iregs;
-	regs.ip = pebs->ip;
+	regs.flags = pebs->flags;
+	set_linear_ip(&regs, pebs->ip);
 	regs.bp = pebs->bp;
 	regs.sp = pebs->sp;
 

