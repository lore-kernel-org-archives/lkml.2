Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883Ab2GJJu7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 05:50:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:37684 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754789Ab2GJJu5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 05:50:57 -0400
Message-ID: <1341913846.3462.105.camel@twins>
Subject: Re: [tip:perf/core] perf/x86: Fix USER/KERNEL tagging of samples
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        akpm@linux-foundation.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org,
        Robert Richter <robert.richter@amd.com>
Date: Tue, 10 Jul 2012 11:50:46 +0200
In-Reply-To: <1341910954.3462.102.camel@twins>
References: <tip-xxrt0a1zronm1sm36obwc2vy@git.kernel.org>
	 <CA+55aFxY7SqwSQWuRXSg+W=ftp9FtCT1MMEqMiCi1H279Fis-A@mail.gmail.com>
	 <1341598329.7709.57.camel@twins>
	 <CA+55aFzqoz7dcUCQfSrXxX2T8=2wgWdb1H2vaBhk7V-r0uaogw@mail.gmail.com>
	 <CA+55aFw+vE4zMe1bJohLuoMDaFpqGCz6sBNRE8gkV7JOvtro0g@mail.gmail.com>
	 <1341832997.3462.41.camel@twins>
	 <CA+55aFyF-GT-BAjLCvwZPFCCKkkYz0ZznSSOYw4RVYizZhLE0g@mail.gmail.com>
	 <1341910954.3462.102.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-10 at 11:02 +0200, Peter Zijlstra wrote:
> Ingo, do you want me to do a version where I simply bail on everything
> if regs->{cs,ss} != {__USER_CS, __USER32_CS} || regs->flags & VM ?

Here's a variant that does that.. 

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
 arch/x86/include/asm/perf_event.h         |   11 +++++--
 arch/x86/kernel/cpu/perf_event.c          |   46 +++++++++++++++++++++++++-----
 arch/x86/kernel/cpu/perf_event.h          |   20 +++++++++++++
 arch/x86/kernel/cpu/perf_event_amd_ibs.c  |    4 +-
 arch/x86/kernel/cpu/perf_event_intel_ds.c |    7 ++--
 5 files changed, 74 insertions(+), 14 deletions(-)

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
+ * EXACT - the IP points to the exact instruction that triggered the
+ *         event (HW bugs exempt).
+ * VM    - original X86_VM_MASK; see set_linear_ip().
  */
 #define PERF_EFLAGS_EXACT	(1UL << 3)
+#define PERF_EFLAGS_VM		(1UL << 5)
 
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
 
@@ -1752,6 +1754,12 @@ perf_callchain_user32(struct pt_regs *re
 	if (!test_thread_flag(TIF_IA32))
 		return 0;
 
+	if (regs->cs != __USER32_CS && regs->cs != __USER_CS)
+		return 0;
+
+	if (regs->ss != __USER32_DS && regs->ss != __USER_DS)
+		return 0;
+
 	fp = compat_ptr(regs->bp);
 	while (entry->nr < PERF_MAX_STACK_DEPTH) {
 		unsigned long bytes;
@@ -1789,6 +1797,12 @@ perf_callchain_user(struct perf_callchai
 		return;
 	}
 
+	/*
+	 * We don't know what to do with VM86 stacks.. ignore them for now.
+	 */
+	if (regs->flags & (X86_VM_MASK | PERF_EFLAGS_VM))
+		return;
+
 	fp = (void __user *)regs->bp;
 
 	perf_callchain_store(entry, regs->ip);
@@ -1816,16 +1830,34 @@ perf_callchain_user(struct perf_callchai
 	}
 }
 
-unsigned long perf_instruction_pointer(struct pt_regs *regs)
+static bool flat_code_segment(struct pt_regs *regs)
 {
-	unsigned long ip;
+	if (regs->flags & (X86_VM_MASK | PERF_EFLAGS_VM))
+		return false;
 
+#ifdef CONFIG_32BIT
+	if (user_mode(regs) && (regs->cs != __USER_CS &&
+				regs->cs != __USER32_CS))
+		return false;
+#else
+	if (test_thread_flag(TIF_IA32)) {
+		if (user_mode(regs) && (regs->cs != __USER_CS &&
+					regs->cs != __USER32_CS))
+			return false;
+	}
+#endif
+	return true; /* X86_64 and X32 are guaranteed flat */
+}
+
+unsigned long perf_instruction_pointer(struct pt_regs *regs)
+{
 	if (perf_guest_cbs && perf_guest_cbs->is_in_guest())
-		ip = perf_guest_cbs->get_guest_ip();
-	else
-		ip = instruction_pointer(regs);
+		return perf_guest_cbs->get_guest_ip();
+
+	if (flat_code_segment(regs))
+		return regs->ip;
 
-	return ip;
+	return ~0UL;
 }
 
 unsigned long perf_misc_flags(struct pt_regs *regs)
@@ -1838,7 +1870,7 @@ unsigned long perf_misc_flags(struct pt_
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
+		regs->flags ^= (PERF_EFLAGS_VM | X86_VM_MASK);
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
 

