Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932338Ab0KLOoo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 09:44:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932274Ab0KLOoc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 09:44:32 -0500
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 4/6] x86, NMI: Remove DIE_NMI_IPI and add priorties to handlers
Date: Fri, 12 Nov 2010 09:43:51 -0500
Message-Id: <1289573033-2889-5-git-send-email-dzickus@redhat.com>
In-Reply-To: <1289573033-2889-1-git-send-email-dzickus@redhat.com>
References: <1289573033-2889-1-git-send-email-dzickus@redhat.com>
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
 arch/x86/kernel/traps.c                 |    9 +--------
 arch/x86/oprofile/nmi_int.c             |    4 ++--
 arch/x86/oprofile/nmi_timer_int.c       |    4 ++--
 11 files changed, 37 insertions(+), 26 deletions(-)

diff --git a/arch/x86/include/asm/kdebug.h b/arch/x86/include/asm/kdebug.h
index 5bdfca8..e28ec43 100644
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
index 932f0f8..cfb6156 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -68,6 +68,26 @@ static inline int nmi_watchdog_active(void)
 }
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
 void lapic_watchdog_stop(void);
 int lapic_watchdog_init(unsigned nmi_hz);
 int lapic_wd_event(unsigned nmi_hz);
diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index cefd694..fabe4fe 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -53,7 +53,6 @@ arch_trigger_all_cpu_backtrace_handler(struct notifier_block *self,
 
 	switch (cmd) {
 	case DIE_NMI:
-	case DIE_NMI_IPI:
 		break;
 
 	default:
@@ -80,7 +79,7 @@ arch_trigger_all_cpu_backtrace_handler(struct notifier_block *self,
 static __read_mostly struct notifier_block backtrace_notifier = {
 	.notifier_call          = arch_trigger_all_cpu_backtrace_handler,
 	.next                   = NULL,
-	.priority               = 1
+	.priority               = NMI_LOCAL_LOW_PRIOR,
 };
 
 static int __init register_trigger_all_cpu_backtrace(void)
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index ed4118d..1c2e9b1 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -618,7 +618,7 @@ void __cpuinit uv_cpu_init(void)
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
index e98d65c..bbe3c4a 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1224,7 +1224,7 @@ perf_event_nmi_handler(struct notifier_block *self,
 		return NOTIFY_DONE;
 
 	switch (cmd) {
-	case DIE_NMI_IPI:
+	case DIE_NMI:
 		break;
 	case DIE_NMIUNKNOWN:
 		this_nmi = percpu_read(irq_stat.__nmi_count);
@@ -1274,7 +1274,7 @@ perf_event_nmi_handler(struct notifier_block *self,
 static __read_mostly struct notifier_block perf_event_nmi_notifier = {
 	.notifier_call		= perf_event_nmi_handler,
 	.next			= NULL,
-	.priority		= 1
+	.priority		= NMI_LOCAL_LOW_PRIOR,
 };
 
 static struct event_constraint unconstrained;
diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index ec592ca..06fd89d 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -521,10 +521,6 @@ static int __kgdb_notify(struct die_args *args, unsigned long cmd)
 		}
 		return NOTIFY_DONE;
 
-	case DIE_NMI_IPI:
-		/* Just ignore, we will handle the roundup on DIE_NMI. */
-		return NOTIFY_DONE;
-
 	case DIE_NMIUNKNOWN:
 		if (was_in_debug_nmi[raw_smp_processor_id()]) {
 			was_in_debug_nmi[raw_smp_processor_id()] = 0;
@@ -602,7 +598,7 @@ static struct notifier_block kgdb_notifier = {
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
index e63bf59..79b9b2f 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -395,8 +395,7 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 	 * CPU-specific NMI: send to specific CPU or NMI sources must
 	 * be processed on specific CPU
 	 */
-	if (notify_die(DIE_NMI_IPI, "nmi_ipi", regs, 0, 2, SIGINT)
-	    == NOTIFY_STOP)
+	if (notify_die(DIE_NMI, "nmi", regs, 0, 2, SIGINT) == NOTIFY_STOP)
 		return;
 
 	/* Non-CPU-specific NMI: NMI sources can be processed on any CPU */
@@ -405,9 +404,6 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 	if (!cpu) {
 		reason = get_nmi_reason();
 		if (reason & NMI_REASON_MASK) {
-			if (notify_die(DIE_NMI, "nmi", regs, reason, 2, SIGINT)
-			    == NOTIFY_STOP)
-				return;
 			if (reason & NMI_REASON_SERR)
 				pci_serr_error(reason, regs);
 			else if (reason & NMI_REASON_IOCHK)
@@ -423,9 +419,6 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 		}
 	}
 
-	if (notify_die(DIE_NMI, "nmi", regs, 0, 2, SIGINT) == NOTIFY_STOP)
-		return;
-
 #if defined(CONFIG_X86_LOCAL_APIC) && !defined(CONFIG_LOCKUP_DETECTOR)
 	if (nmi_watchdog_tick(regs, reason))
 		return;
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
index ab72a21..5f14fcb 100644
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
1.7.2.3

