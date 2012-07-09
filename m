Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab2GILXa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 07:23:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:47302 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991Ab2GILX3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 07:23:29 -0400
Message-ID: <1341832997.3462.41.camel@twins>
Subject: Re: [tip:perf/core] perf/x86: Fix USER/KERNEL tagging of samples
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        akpm@linux-foundation.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org,
        Robert Richter <robert.richter@amd.com>
Date: Mon, 09 Jul 2012 13:23:17 +0200
In-Reply-To: <CA+55aFw+vE4zMe1bJohLuoMDaFpqGCz6sBNRE8gkV7JOvtro0g@mail.gmail.com>
References: <tip-xxrt0a1zronm1sm36obwc2vy@git.kernel.org>
	 <CA+55aFxY7SqwSQWuRXSg+W=ftp9FtCT1MMEqMiCi1H279Fis-A@mail.gmail.com>
	 <1341598329.7709.57.camel@twins>
	 <CA+55aFzqoz7dcUCQfSrXxX2T8=2wgWdb1H2vaBhk7V-r0uaogw@mail.gmail.com>
	 <CA+55aFw+vE4zMe1bJohLuoMDaFpqGCz6sBNRE8gkV7JOvtro0g@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-06 at 11:34 -0700, Linus Torvalds wrote:

> But any code that does "kernel_ip(regs->ip)" is just terminally
> confused and can never be sane.

How about something like the below?

I've also modified perf_instruction_pointer() to account for the VM86
and IA32 non-zero segment base cases. At least, I tried to do so, I've
never had the 'pleasure' of poking at this segment descriptor stuff
before.

Ingo didn't really like doing that though, his suggestion was to kill
all those IPs by mapping them to a special value (~0UL or so).

---
Subject: perf/x86: Fix USER/KERNEL tagging of samples properly

Some PMUs don't provide a full register set for their sample,
specifically 'advanced' PMUs like AMD IBS and Intel PEBS which provide
'better' then regular interrupt accuracy.

In this case we use the interrupt regs as basis and over-write some
fields (typically IP) with different information.

The perf core however users user_mode() to distinguish user/kernel
samples, user_mode() relies on regs->cs. If the interrupt skid pushed us
over a boundary the new IP might not be in the same domain as the
interrupt. 

Commit ce5c1fe9a9e ("perf/x86: Fix USER/KERNEL tagging of samples")
tried to fix this by making the perf core use kernel_ip(). This however
is wrong (TM), as pointed out by Linus, since it doesn't allow for VM86
and non-zero based segments in IA32 mode.

Therefore, provide a new helper to set the regs->ip field,
set_linear_ip(), which massages the regs into a suitable state assuming
the provided IP is in fact a linear address.

Also modify perf_instruction_pointer() to deal with these 'fun' cases.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/kernel/cpu/perf_event.c          | 58 ++++++++++++++++++++++++++++---
 arch/x86/kernel/cpu/perf_event.h          | 19 ++++++++++
 arch/x86/kernel/cpu/perf_event_amd_ibs.c  |  4 ++-
 arch/x86/kernel/cpu/perf_event_intel_ds.c |  6 ++--
 4 files changed, 79 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 29557aa..03a474c 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -32,6 +32,8 @@
 #include <asm/smp.h>
 #include <asm/alternative.h>
 #include <asm/timer.h>
+#include <asm/desc.h>
+#include <asm/ldt.h>
 
 #include "perf_event.h"
 
@@ -1816,14 +1818,62 @@ perf_callchain_user(struct perf_callchain_entry *entry, struct pt_regs *regs)
 	}
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
+static unsigned long code_segment_base(struct pt_regs *regs)
+{
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
+
 unsigned long perf_instruction_pointer(struct pt_regs *regs)
 {
 	unsigned long ip;
 
 	if (perf_guest_cbs && perf_guest_cbs->is_in_guest())
-		ip = perf_guest_cbs->get_guest_ip();
-	else
-		ip = instruction_pointer(regs);
+		return perf_guest_cbs->get_guest_ip();
+
+	ip = regs->ip;
+
+	if (regs->flags & X86_VM_MASK) {
+		/*
+		 * If we are in VM86 mode, add the segment offset to convert to
+		 * a linear address.
+		 */
+		ip += 0x10 * regs->cs;
+	} else {
+		/*
+		 * For IA32 we look at the GDT/LDT segment base to convert the
+		 * effective IP to a linear address.
+		 */
+		ip += code_segment_base(regs);
+	}
 
 	return ip;
 }
@@ -1838,7 +1888,7 @@ unsigned long perf_misc_flags(struct pt_regs *regs)
 		else
 			misc |= PERF_RECORD_MISC_GUEST_KERNEL;
 	} else {
-		if (!kernel_ip(regs->ip))
+		if (user_mode(regs))
 			misc |= PERF_RECORD_MISC_USER;
 		else
 			misc |= PERF_RECORD_MISC_KERNEL;
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index a15df4b..71fa4c6 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -516,6 +516,25 @@ static inline bool kernel_ip(unsigned long ip)
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
+	regs->flags &= ~X86_VM_MASK;
+	regs->ip = ip;
+}
+
 #ifdef CONFIG_CPU_SUP_AMD
 
 int amd_pmu_init(void);
diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index da9bcdc..7bfb5be 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -13,6 +13,8 @@
 
 #include <asm/apic.h>
 
+#include "perf_event.h"
+
 static u32 ibs_caps;
 
 #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_AMD)
@@ -536,7 +538,7 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 	if (check_rip && (ibs_data.regs[2] & IBS_RIP_INVALID)) {
 		regs.flags &= ~PERF_EFLAGS_EXACT;
 	} else {
-		instruction_pointer_set(&regs, ibs_data.regs[1]);
+		set_linear_ip(&regs, ibs_data.regs[1]);
 		regs.flags |= PERF_EFLAGS_EXACT;
 	}
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 629ae0b..0549fa9 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -499,7 +499,7 @@ static int intel_pmu_pebs_fixup_ip(struct pt_regs *regs)
 	 * We sampled a branch insn, rewind using the LBR stack
 	 */
 	if (ip == to) {
-		regs->ip = from;
+		set_linear_ip(regs, from);
 		return 1;
 	}
 
@@ -529,7 +529,7 @@ static int intel_pmu_pebs_fixup_ip(struct pt_regs *regs)
 	} while (to < ip);
 
 	if (to == ip) {
-		regs->ip = old_to;
+		set_linear_ip(regs, old_to);
 		return 1;
 	}
 
@@ -569,7 +569,7 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 	 * A possible PERF_SAMPLE_REGS will have to transfer all regs.
 	 */
 	regs = *iregs;
-	regs.ip = pebs->ip;
+	set_linear_ip(&regs, pebs->ip);
 	regs.bp = pebs->bp;
 	regs.sp = pebs->sp;
 

