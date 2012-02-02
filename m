Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932716Ab2BBX5H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 18:57:07 -0500
Received: from relay2.sgi.com ([192.48.179.30]:47557 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756040Ab2BBX4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 18:56:52 -0500
Message-Id: <20120202235651.025794606@gulag1.americas.sgi.com>
References: <20120202235650.563029146@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 02 Feb 2012 17:56:53 -0600
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Jack Steiner <steiner@sgi.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] UV Update NMI handlers
Content-Disposition: inline; filename=uv_update_nmi_handler
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These changes update the UV NMI handler to be compatible with the new
NMI processing.

In order to determine if an incoming NMI was generated externally
by the BMC, the UV BIOS sets a flag in an MMR register.  Reading
this register though is expensive especially when all CPU's on
a blade share the same MMR.  Part of this patch reduces the number
of readers to only the first CPU to enter the NMI handler.  The other
problem was all CPUs on a blade were clearing the flag, when only
one of them on each blade needs to clear the MMR bit.

This greatly reduces the overhead to enter either KDB or print the
trace, and also removes the possibility of some of the CPUs not
entering into KDB correctly, leaving their state somewhat undefined,
as some where not entering after KDB generated an IPI NMI.

Note that this patch does not have the capability of entering KDB
from the BMC NMI interrupt.  This will be in a separate patch.

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/apic/x2apic_uv_x.c |  132 +++++++++++++++++++++++++++++--------
 1 file changed, 105 insertions(+), 27 deletions(-)

--- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c
+++ linux/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -43,7 +43,17 @@
 #define UVH_NMI_MMR				UVH_SCRATCH5
 #define UVH_NMI_MMR_CLEAR			(UVH_NMI_MMR + 8)
 #define UV_NMI_PENDING_MASK			(1UL << 63)
-DEFINE_PER_CPU(unsigned long, cpu_last_nmi_count);
+static DEFINE_PER_CPU(unsigned long, cpu_nmi_count);
+
+static inline int check_nmi_mmr(void)
+{
+	return (uv_read_local_mmr(UVH_NMI_MMR & UV_NMI_PENDING_MASK) != 0);
+}
+
+static inline void clear_nmi_mmr(void)
+{
+	uv_write_local_mmr(UVH_NMI_MMR_CLEAR, UV_NMI_PENDING_MASK);
+}
 
 DEFINE_PER_CPU(int, x2apic_extra_bits);
 
@@ -57,6 +67,7 @@ EXPORT_SYMBOL_GPL(uv_min_hub_revision_id
 unsigned int uv_apicid_hibits;
 EXPORT_SYMBOL_GPL(uv_apicid_hibits);
 static DEFINE_SPINLOCK(uv_nmi_lock);
+static DEFINE_SPINLOCK(uv_nmi_reason_lock);
 
 static struct apic apic_x2apic_uv_x;
 
@@ -672,52 +683,119 @@ void __cpuinit uv_cpu_init(void)
 }
 
 /*
- * When NMI is received, print a stack trace.
+ * When an NMI from the BMC is received:
+ *	- call KDB if active (not yet implemented)
+ *	- print a stack trace if kdb is not active.
  */
-int uv_handle_nmi(unsigned int reason, struct pt_regs *regs)
+int uv_handle_nmi(unsigned int cmd, struct pt_regs *regs)
 {
-	unsigned long real_uv_nmi;
-	int bid;
+	static int in_uv_nmi = -1;
+	static atomic_t nr_nmi_cpus;
+	int bid, handled = 0;
+
+	if (cmd != NMI_LOCAL && cmd != NMI_UNKNOWN)
+		return NMI_DONE;
+
+	if (in_crash_kexec)
+		/* do nothing if entering the crash kernel */
+		return NMI_DONE;
+
+	/* note which NMI this one is */
+	__this_cpu_inc(cpu_nmi_count);
 
 	/*
 	 * Each blade has an MMR that indicates when an NMI has been sent
-	 * to cpus on the blade. If an NMI is detected, atomically
-	 * clear the MMR and update a per-blade NMI count used to
-	 * cause each cpu on the blade to notice a new NMI.
+	 * to cpus on the blade.  We optimize accesses to the MMR as the
+	 * read operation is expensive and only the first CPU to enter this
+	 * function needs to read the register and set a flag indicating
+	 * we are indeed servicing an external BMC NMI.  Once it's determined
+	 * whether or not this is a real NMI, the last responding CPU clears
+	 * the flag for the next NMI.
 	 */
-	bid = uv_numa_blade_id();
-	real_uv_nmi = (uv_read_local_mmr(UVH_NMI_MMR) & UV_NMI_PENDING_MASK);
+	if (in_uv_nmi < 0) {
+		spin_lock(&uv_nmi_reason_lock);
+		if (in_uv_nmi < 0) {
+			int nc = num_online_cpus();
+			atomic_set(&nr_nmi_cpus, nc);
+			in_uv_nmi = check_nmi_mmr();
+		}
+		spin_unlock(&uv_nmi_reason_lock);
+	}
+
+	if (likely(in_uv_nmi == 0)) {
+		if (atomic_sub_and_test(1, &nr_nmi_cpus) == 0)
+			in_uv_nmi = -1;
+		return NMI_DONE;
+	}
+
+	/* If we are here, we are processing a real BMC NMI */
+
+#ifdef CONFIG_KGDB_KDB_NOT_YET
+#include <linux/kdb.h>
+
+	/* Here we want to call KDB with reason == NMI */
+	if (kdb_on) {
+		static int controlling_cpu = -1;
+
+		spin_lock(&uv_nmi_lock);
+		if (controlling_cpu == -1) {
+			controlling_cpu = smp_processor_id();
+			spin_unlock(&uv_nmi_lock);
+			(void)kdb(LKDB_REASON_NMI, reason, regs);
+			controlling_cpu = -1;
+		} else {
+			spin_unlock(&uv_nmi_lock);
+			(void)kdb(LKDB_REASON_ENTER_SLAVE, reason, regs);
+			while (controlling_cpu != -1)
+				cpu_relax();
+		}
+		handled = 1;	/* handled by KDB */
+	}
+#endif
 
-	if (unlikely(real_uv_nmi)) {
+	/* Only one cpu per blade needs to clear the MMR BMC NMI flag */
+	bid = uv_numa_blade_id();
+	if (uv_blade_info[bid].nmi_count < __get_cpu_var(cpu_nmi_count)) {
 		spin_lock(&uv_blade_info[bid].nmi_lock);
-		real_uv_nmi = (uv_read_local_mmr(UVH_NMI_MMR) & UV_NMI_PENDING_MASK);
-		if (real_uv_nmi) {
-			uv_blade_info[bid].nmi_count++;
-			uv_write_local_mmr(UVH_NMI_MMR_CLEAR, UV_NMI_PENDING_MASK);
+		if (uv_blade_info[bid].nmi_count <
+						__get_cpu_var(cpu_nmi_count)) {
+			uv_blade_info[bid].nmi_count =
+						__get_cpu_var(cpu_nmi_count);
+			clear_nmi_mmr();
 		}
 		spin_unlock(&uv_blade_info[bid].nmi_lock);
 	}
 
-	if (likely(__get_cpu_var(cpu_last_nmi_count) == uv_blade_info[bid].nmi_count))
-		return NMI_DONE;
+	/* If not handled by KDB, then print a process trace for each cpu */
+	if (!handled) {
+		int saved_console_loglevel = console_loglevel;
 
-	__get_cpu_var(cpu_last_nmi_count) = uv_blade_info[bid].nmi_count;
+		/*
+		 * Use a lock so only one cpu prints at a time.
+		 * This prevents intermixed output.  We can reuse the
+		 * uv_nmi_lock since if KDB was called, then all the
+		 * CPUs have exited KDB, and if it was not called,
+		 * then the lock was not used.
+		 */
+		spin_lock(&uv_nmi_lock);
+		pr_err("== UV NMI process trace NMI %lu: ==\n",
+						__get_cpu_var(cpu_nmi_count));
+		console_loglevel = 15;
+		show_regs(regs);
+		console_loglevel = saved_console_loglevel;
+		spin_unlock(&uv_nmi_lock);
+	}
 
-	/*
-	 * Use a lock so only one cpu prints at a time.
-	 * This prevents intermixed output.
-	 */
-	spin_lock(&uv_nmi_lock);
-	pr_info("UV NMI stack dump cpu %u:\n", smp_processor_id());
-	dump_stack();
-	spin_unlock(&uv_nmi_lock);
+	/* last cpu resets the "in nmi" flag */
+	if (atomic_sub_and_test(1, &nr_nmi_cpus) == 0)
+		in_uv_nmi = -1;
 
 	return NMI_HANDLED;
 }
 
 void uv_register_nmi_notifier(void)
 {
-	if (register_nmi_handler(NMI_UNKNOWN, uv_handle_nmi, 0, "uv"))
+	if (register_nmi_handler(NMI_LOCAL, uv_handle_nmi, 0, "uv"))
 		printk(KERN_WARNING "UV NMI handler failed to register\n");
 }
 

-- 
