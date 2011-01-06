Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab1AFVTm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 16:19:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20456 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753977Ab1AFVTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 16:19:38 -0500
From: Don Zickus <dzickus@redhat.com>
To: x86@kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        gorcunov@gmail.com, LKML <linux-kernel@vger.kernel.org>,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 4/6] x86, NMI: Remove DIE_NMI_IPI
Date: Thu,  6 Jan 2011 16:18:50 -0500
Message-Id: <1294348732-15030-5-git-send-email-dzickus@redhat.com>
In-Reply-To: <1294348732-15030-1-git-send-email-dzickus@redhat.com>
References: <1294348732-15030-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With priorities in place and no one really understanding the difference between
DIE_NMI and DIE_NMI_IPI, just remove DIE_NMI_IPI and convert everyone to DIE_NMI.

This also simplifies default_do_nmi() a little bit.  Instead of calling the
die_notifier in both the if and else part, just pull it out and call it before
the if-statement.  This has the side benefit of avoiding a call to the ioport
to see if there is an external NMI sitting around until after the (more frequent)
internal NMIs are dealt with.

Patch-Inspired-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/include/asm/kdebug.h           |    1 -
 arch/x86/kernel/apic/hw_nmi.c           |    1 -
 arch/x86/kernel/cpu/mcheck/mce-inject.c |    3 ++-
 arch/x86/kernel/cpu/perf_event.c        |    1 -
 arch/x86/kernel/kgdb.c                  |    4 ----
 arch/x86/kernel/reboot.c                |    3 ++-
 arch/x86/kernel/traps.c                 |   19 ++++++++-----------
 arch/x86/oprofile/nmi_int.c             |    1 -
 8 files changed, 12 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/kdebug.h b/arch/x86/include/asm/kdebug.h
index f23eb25..ca242d3 100644
--- a/arch/x86/include/asm/kdebug.h
+++ b/arch/x86/include/asm/kdebug.h
@@ -18,7 +18,6 @@ enum die_val {
 	DIE_TRAP,
 	DIE_GPF,
 	DIE_CALL,
-	DIE_NMI_IPI,
 	DIE_PAGE_FAULT,
 	DIE_NMIUNKNOWN,
 };
diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index 8bc49f1..79fd43c 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -68,7 +68,6 @@ arch_trigger_all_cpu_backtrace_handler(struct notifier_block *self,
 
 	switch (cmd) {
 	case DIE_NMI:
-	case DIE_NMI_IPI:
 		break;
 
 	default:
diff --git a/arch/x86/kernel/cpu/mcheck/mce-inject.c b/arch/x86/kernel/cpu/mcheck/mce-inject.c
index 59546c1..a779719 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
@@ -25,6 +25,7 @@
 #include <linux/gfp.h>
 #include <asm/mce.h>
 #include <asm/apic.h>
+#include <asm/nmi.h>
 
 /* Update fake mce registers on current CPU. */
 static void inject_mce(struct mce *m)
@@ -83,7 +84,7 @@ static int mce_raise_notify(struct notifier_block *self,
 	struct die_args *args = (struct die_args *)data;
 	int cpu = smp_processor_id();
 	struct mce *m = &__get_cpu_var(injectm);
-	if (val != DIE_NMI_IPI || !cpumask_test_cpu(cpu, mce_inject_cpumask))
+	if (val != DIE_NMI || !cpumask_test_cpu(cpu, mce_inject_cpumask))
 		return NOTIFY_DONE;
 	cpumask_clear_cpu(cpu, mce_inject_cpumask);
 	if (m->inject_flags & MCJ_EXCEPTION)
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 5e14b5e..c71bae4 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1268,7 +1268,6 @@ perf_event_nmi_handler(struct notifier_block *self,
 
 	switch (cmd) {
 	case DIE_NMI:
-	case DIE_NMI_IPI:
 		break;
 	case DIE_NMIUNKNOWN:
 		this_nmi = percpu_read(irq_stat.__nmi_count);
diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index 983fb54..1e8b583 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -525,10 +525,6 @@ static int __kgdb_notify(struct die_args *args, unsigned long cmd)
 		}
 		return NOTIFY_DONE;
 
-	case DIE_NMI_IPI:
-		/* Just ignore, we will handle the roundup on DIE_NMI. */
-		return NOTIFY_DONE;
-
 	case DIE_NMIUNKNOWN:
 		if (was_in_debug_nmi[raw_smp_processor_id()]) {
 			was_in_debug_nmi[raw_smp_processor_id()] = 0;
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 9c1c83e..fc7aae1 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -18,6 +18,7 @@
 #include <asm/pci_x86.h>
 #include <asm/virtext.h>
 #include <asm/cpu.h>
+#include <asm/nmi.h>
 
 #ifdef CONFIG_X86_32
 # include <linux/ctype.h>
@@ -747,7 +748,7 @@ static int crash_nmi_callback(struct notifier_block *self,
 {
 	int cpu;
 
-	if (val != DIE_NMI_IPI)
+	if (val != DIE_NMI)
 		return NOTIFY_OK;
 
 	cpu = raw_smp_processor_id();
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index c7fd1ce..23f6ac0 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -394,6 +394,14 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 	unsigned char reason = 0;
 	int cpu;
 
+	/*
+	 * CPU-specific NMI must be processed before non-CPU-specific
+	 * NMI, otherwise we may lose it, because the CPU-specific
+	 * NMI can not be detected/processed on other CPUs.
+	 */
+	if (notify_die(DIE_NMI, "nmi", regs, 0, 2, SIGINT) == NOTIFY_STOP)
+		return;
+
 	cpu = smp_processor_id();
 
 	/* Only the BSP gets external NMIs from the system. */
@@ -401,21 +409,10 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 		reason = get_nmi_reason();
 
 	if (!(reason & NMI_REASON_MASK)) {
-		if (notify_die(DIE_NMI_IPI, "nmi_ipi", regs, reason, 2, SIGINT)
-								== NOTIFY_STOP)
-			return;
-
-#ifdef CONFIG_X86_LOCAL_APIC
-		if (notify_die(DIE_NMI, "nmi", regs, reason, 2, SIGINT)
-							== NOTIFY_STOP)
-			return;
-#endif
 		unknown_nmi_error(reason, regs);
 
 		return;
 	}
-	if (notify_die(DIE_NMI, "nmi", regs, reason, 2, SIGINT) == NOTIFY_STOP)
-		return;
 
 	/* AK: following checks seem to be broken on modern chipsets. FIXME */
 	if (reason & NMI_REASON_SERR)
diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 6e84ea4..e77ea0b 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -65,7 +65,6 @@ static int profile_exceptions_notify(struct notifier_block *self,
 
 	switch (val) {
 	case DIE_NMI:
-	case DIE_NMI_IPI:
 		if (ctr_running)
 			model->check_ctrs(args->regs, &__get_cpu_var(cpu_msrs));
 		else if (!nmi_enabled)
-- 
1.7.3.4

