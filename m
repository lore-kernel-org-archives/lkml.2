Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab0K3W2h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 17:28:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754353Ab0K3W2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 17:28:19 -0500
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        Andi Kleen <andi@firstfloor.org>, gorcunov@gmail.com,
        LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 4/9] x86, NMI: Remove DIE_NMI_IPI and add priorties to handlers
Date: Tue, 30 Nov 2010 17:27:25 -0500
Message-Id: <1291156050-4482-5-git-send-email-dzickus@redhat.com>
In-Reply-To: <1291156050-4482-1-git-send-email-dzickus@redhat.com>
References: <1291156050-4482-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When re-ordering how the NMI handles its callbacks, a conversation started
asking what DIE_NMI_IPI meant.  No one could answer it.

Noticing that is was wasteful to call the die_chain a second time with just
another argument, DIE_NMI_IPI, it was decided to nuke it and add priorities
to the die_chain handlers to maintain existing behaviour.

This patch replaces DIE_NMI_IPI with the appropriate option, mostly DIE_NMI.
Then it adds priorities to those handlers, using a globally defined set of
priorities for NMI.

The thought is eventually we will just switch the nmi handlers from the
die_chain to something more nmi specific.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/include/asm/kdebug.h           |    1 -
 arch/x86/include/asm/nmi.h              |   20 ++++++++++++++++++++
 arch/x86/kernel/apic/hw_nmi.c           |    3 +--
 arch/x86/kernel/apic/x2apic_uv_x.c      |    2 +-
 arch/x86/kernel/cpu/mcheck/mce-inject.c |    5 +++--
 arch/x86/kernel/cpu/perf_event.c        |    4 ++--
 arch/x86/kernel/kgdb.c                  |    6 +-----
 arch/x86/kernel/reboot.c                |    5 ++++-
 arch/x86/kernel/traps.c                 |    8 +-------
 arch/x86/oprofile/nmi_int.c             |    4 ++--
 arch/x86/oprofile/nmi_timer_int.c       |    4 ++--
 11 files changed, 37 insertions(+), 25 deletions(-)

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
diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index 3545838..9c4ff0b 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -23,6 +23,26 @@ void arch_trigger_all_cpu_backtrace(void);
 #define arch_trigger_all_cpu_backtrace arch_trigger_all_cpu_backtrace
 #endif
 
+/*
+ * Define some priorities for the nmi notifier call chain.
+ *
+ * Create a local nmi bit that has a higher priority than
+ * external nmis, because the local ones are more frequent.
+ * 
+ * Also setup some default high/normal/low settings for
+ * subsystems to registers with.  Using 4 bits to seperate
+ * the priorities.  This can go alot higher if needed be.
+ */
+
+#define NMI_LOCAL_SHIFT		16	/* randomly picked */
+#define NMI_LOCAL_BIT		(1ULL << NMI_LOCAL_SHIFT)
+#define NMI_HIGH_PRIOR		(1ULL << 8)
+#define NMI_NORMAL_PRIOR	(1ULL << 4)
+#define NMI_LOW_PRIOR		(1ULL << 0)
+#define NMI_LOCAL_HIGH_PRIOR	(NMI_LOCAL_BIT | NMI_HIGH_PRIOR)
+#define NMI_LOCAL_NORMAL_PRIOR	(NMI_LOCAL_BIT | NMI_NORMAL_PRIOR)
+#define NMI_LOCAL_LOW_PRIOR	(NMI_LOCAL_BIT | NMI_LOW_PRIOR)
+
 void stop_nmi(void);
 void restart_nmi(void);
 
diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index a86840c..82bff25 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -63,7 +63,6 @@ arch_trigger_all_cpu_backtrace_handler(struct notifier_block *self,
 
 	switch (cmd) {
 	case DIE_NMI:
-	case DIE_NMI_IPI:
 		break;
 
 	default:
@@ -90,7 +89,7 @@ arch_trigger_all_cpu_backtrace_handler(struct notifier_block *self,
 static __read_mostly struct notifier_block backtrace_notifier = {
 	.notifier_call          = arch_trigger_all_cpu_backtrace_handler,
 	.next                   = NULL,
-	.priority               = 1
+	.priority               = NMI_LOCAL_LOW_PRIOR,
 };
 
 static int __init register_trigger_all_cpu_backtrace(void)
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index c1c52c3..927902d 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -639,7 +639,7 @@ void __cpuinit uv_cpu_init(void)
  */
 int uv_handle_nmi(struct notifier_block *self, unsigned long reason, void *data)
 {
-	if (reason != DIE_NMI_IPI)
+	if (reason != DIE_NMIUNKNOWN)
 		return NOTIFY_OK;
 
 	if (in_crash_kexec)
diff --git a/arch/x86/kernel/cpu/mcheck/mce-inject.c b/arch/x86/kernel/cpu/mcheck/mce-inject.c
index e7dbde7..a779719 100644
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
@@ -95,7 +96,7 @@ static int mce_raise_notify(struct notifier_block *self,
 
 static struct notifier_block mce_raise_nb = {
 	.notifier_call = mce_raise_notify,
-	.priority = 1000,
+	.priority = NMI_LOCAL_NORMAL_PRIOR,
 };
 
 /* Inject mce on current CPU */
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 48aa91f..7b91396 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1229,7 +1229,7 @@ perf_event_nmi_handler(struct notifier_block *self,
 		return NOTIFY_DONE;
 
 	switch (cmd) {
-	case DIE_NMI_IPI:
+	case DIE_NMI:
 		break;
 	case DIE_NMIUNKNOWN:
 		this_nmi = percpu_read(irq_stat.__nmi_count);
@@ -1279,7 +1279,7 @@ perf_event_nmi_handler(struct notifier_block *self,
 static __read_mostly struct notifier_block perf_event_nmi_notifier = {
 	.notifier_call		= perf_event_nmi_handler,
 	.next			= NULL,
-	.priority		= 1
+	.priority		= NMI_LOCAL_LOW_PRIOR,
 };
 
 static struct event_constraint unconstrained;
diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index cd21b65..1e8b583 100644
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
@@ -606,7 +602,7 @@ static struct notifier_block kgdb_notifier = {
 	/*
 	 * Lowest-prio notifier priority, we want to be notified last:
 	 */
-	.priority	= -INT_MAX,
+	.priority	= NMI_LOCAL_LOW_PRIOR,
 };
 
 /**
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index c495aa8..fc7aae1 100644
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
@@ -778,6 +779,8 @@ static void smp_send_nmi_allbutself(void)
 
 static struct notifier_block crash_nmi_nb = {
 	.notifier_call = crash_nmi_callback,
+	/* we want to be the first one called */
+	.priority = NMI_LOCAL_HIGH_PRIOR+1,
 };
 
 /* Halt all other CPUs, calling the specified function on each of them
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 5184b21..0668b51 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -404,8 +404,7 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 	 * CPU-specific NMI: send to specific CPU or NMI sources must
 	 * be processed on specific CPU
 	 */
-	if (notify_die(DIE_NMI_IPI, "nmi_ipi", regs, 0, 2, SIGINT)
-	    == NOTIFY_STOP)
+	if (notify_die(DIE_NMI, "nmi", regs, 0, 2, SIGINT) == NOTIFY_STOP)
 		return;
 
 	/* Non-CPU-specific NMI: NMI sources can be processed on any CPU */
@@ -414,9 +413,6 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 	if (!cpu) {
 		reason = get_nmi_reason();
 		if (reason & NMI_REASON_MASK) {
-			if (notify_die(DIE_NMI, "nmi", regs, reason, 2, SIGINT)
-			    == NOTIFY_STOP)
-				return;
 			if (reason & NMI_REASON_SERR)
 				pci_serr_error(reason, regs);
 			else if (reason & NMI_REASON_IOCHK)
@@ -431,8 +427,6 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 			return;
 		}
 	}
-	if (notify_die(DIE_NMI, "nmi", regs, 0, 2, SIGINT) == NOTIFY_STOP)
-		return;
 	unknown_nmi_error(reason, regs);
 }
 
diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index ee7ff0e..e476044 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -64,7 +64,7 @@ static int profile_exceptions_notify(struct notifier_block *self,
 	int ret = NOTIFY_DONE;
 
 	switch (val) {
-	case DIE_NMI_IPI:
+	case DIE_NMI:
 		if (ctr_running)
 			model->check_ctrs(args->regs, &__get_cpu_var(cpu_msrs));
 		else if (!nmi_enabled)
@@ -360,7 +360,7 @@ static void nmi_cpu_setup(void *dummy)
 static struct notifier_block profile_exceptions_nb = {
 	.notifier_call = profile_exceptions_notify,
 	.next = NULL,
-	.priority = 2
+	.priority = NMI_LOCAL_LOW_PRIOR,
 };
 
 static void nmi_cpu_restore_registers(struct op_msrs *msrs)
diff --git a/arch/x86/oprofile/nmi_timer_int.c b/arch/x86/oprofile/nmi_timer_int.c
index fb40645..720bf5a 100644
--- a/arch/x86/oprofile/nmi_timer_int.c
+++ b/arch/x86/oprofile/nmi_timer_int.c
@@ -25,7 +25,7 @@ static int profile_timer_exceptions_notify(struct notifier_block *self,
 	int ret = NOTIFY_DONE;
 
 	switch (val) {
-	case DIE_NMI_IPI:
+	case DIE_NMI:
 		oprofile_add_sample(args->regs, 0);
 		ret = NOTIFY_STOP;
 		break;
@@ -38,7 +38,7 @@ static int profile_timer_exceptions_notify(struct notifier_block *self,
 static struct notifier_block profile_timer_exceptions_nb = {
 	.notifier_call = profile_timer_exceptions_notify,
 	.next = NULL,
-	.priority = 0
+	.priority = NMI_LOW_PRIOR,
 };
 
 static int timer_start(void)
-- 
1.7.3.2

