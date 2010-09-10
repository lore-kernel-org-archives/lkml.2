Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561Ab0IJCvk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 22:51:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:56172 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755126Ab0IJCvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 22:51:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,344,1280732400"; 
   d="scan'208";a="655886356"
From: Huang Ying <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Huang Ying <ying.huang@intel.com>
Subject: [RFC 4/6] x86, NMI, Rewrite NMI handler
Date: Fri, 10 Sep 2010 10:51:03 +0800
Message-Id: <1284087065-32722-4-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284087065-32722-1-git-send-email-ying.huang@intel.com>
References: <1284087065-32722-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original NMI handler is quite outdated in many aspects. This patch
try to fix it.

In original code, NMI reason io port (0x61) is only processed on
BSP. This makes it impossible to hot-remove BSP. To solve the issue,
a raw spinlock is used to make the port can be processed on any CPU.

Because the io port 0x61 and other non-CPU-specific NMI sources can be
processed on any CPU, the order to process the NMI sources are changed
as follow:

notify_die(DIE_NMI_IPI);
notify_die(DIE_NMI);
/* process io port 0x61 */
nmi_watchdog_touch();
notify_die(DIE_NMIUNKNOWN);
unknown_nmi();

DIE_NMI_IPI is used to process CPU specific NMI sources, such as perf
event, oprofile, crash IPI, etc. While DIE_NMI is used to process
non-CPU-specific NMI sources, such as APEI (ACPI Platform Error
Interface) GHES (Generic Hardware Error Source), etc.

DIE_NMI_IPI must be processed before DIE_NMI. For example, perf event
trigger a NMI on CPU 1, at the same time, APEI GHES trigger another
NMI on CPU 0. If DIE_NMI is processed before DIE_NMI_IPI, it is
possible that APEI GHES is processed on CPU 1, while unknown NMI is
gotten on CPU 0.

In this new order of processing, performance sensitive NMI sources
such as oprofile or perf event will have better performance because
the time consuming IO port reading is done after them.

Only one NMI is eaten for each NMI handler call, even for PCI SERR and
IOCHK NMIs. Because one NMI should be raised for each of them, eating
too many NMI will cause unnecessary unknown NMI.

The die value used in NMI sources are fixed accordingly.

The NMI handler in the patch is designed by Andi Kleen.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 arch/x86/kernel/cpu/perf_event.c  |    1 
 arch/x86/kernel/traps.c           |   86 +++++++++++++++++++-------------------
 arch/x86/oprofile/nmi_int.c       |    1 
 arch/x86/oprofile/nmi_timer_int.c |    2 
 drivers/char/ipmi/ipmi_watchdog.c |    2 
 drivers/watchdog/hpwdt.c          |    2 
 6 files changed, 48 insertions(+), 46 deletions(-)

--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1237,7 +1237,6 @@ perf_event_nmi_handler(struct notifier_b
 		return NOTIFY_DONE;
 
 	switch (cmd) {
-	case DIE_NMI:
 	case DIE_NMI_IPI:
 		break;
 	case DIE_NMIUNKNOWN:
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -83,6 +83,12 @@ EXPORT_SYMBOL_GPL(used_vectors);
 
 static int ignore_nmis;
 
+/*
+ * Prevent NMI reason port (0x61) being accessed simultaneously, can
+ * only be used in NMI handler.
+ */
+static DEFINE_RAW_SPINLOCK(nmi_reason_lock);
+
 static inline void conditional_sti(struct pt_regs *regs)
 {
 	if (regs->flags & X86_EFLAGS_IF)
@@ -343,9 +349,6 @@ io_check_error(unsigned char reason, str
 static notrace __kprobes void
 unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
 {
-	if (notify_die(DIE_NMIUNKNOWN, "nmi", regs, reason, 2, SIGINT) ==
-			NOTIFY_STOP)
-		return;
 #ifdef CONFIG_MCA
 	/*
 	 * Might actually be able to figure out what the guilty party
@@ -370,55 +373,56 @@ unknown_nmi_error(unsigned char reason,
 static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 {
 	unsigned char reason = 0;
-	int cpu;
-
-	cpu = smp_processor_id();
 
-	/* Only the BSP gets external NMIs from the system. */
-	if (!cpu)
-		reason = get_nmi_reason();
+	/*
+	 * CPU-specific NMI must be processed before non-CPU-specific
+	 * NMI, otherwise we may lose it, because the CPU-specific
+	 * NMI can not be detected/processed on other CPUs.
+	 */
 
-	if (!(reason & NMI_REASON_MASK)) {
-		if (notify_die(DIE_NMI_IPI, "nmi_ipi", regs, reason, 2, SIGINT)
-								== NOTIFY_STOP)
-			return;
+	/*
+	 * CPU-specific NMI: send to specific CPU or NMI sources must
+	 * be processed on specific CPU
+	 */
+	if (notify_die(DIE_NMI_IPI, "nmi_ipi", regs, 0, 2, SIGINT)
+	    == NOTIFY_STOP)
+		return;
 
-#ifdef CONFIG_X86_LOCAL_APIC
-		if (notify_die(DIE_NMI, "nmi", regs, reason, 2, SIGINT)
-							== NOTIFY_STOP)
-			return;
+	/* Non-CPU-specific NMI: NMI sources can be processed on any CPU */
+	if (notify_die(DIE_NMI, "nmi", regs, 0, 2, SIGINT) == NOTIFY_STOP)
+		return;
 
-#ifndef CONFIG_LOCKUP_DETECTOR
+	raw_spin_lock(&nmi_reason_lock);
+	reason = get_nmi_reason();
+	if (reason & NMI_REASON_MASK) {
+		if (reason & NMI_REASON_SERR)
+			pci_serr_error(reason, regs);
+		else if (reason & NMI_REASON_IOCHK)
+			io_check_error(reason, regs);
+#ifdef CONFIG_X86_32
 		/*
-		 * Ok, so this is none of the documented NMI sources,
-		 * so it must be the NMI watchdog.
+		 * Reassert NMI in case it became active
+		 * meanwhile as it's edge-triggered:
 		 */
-		if (nmi_watchdog_tick(regs, reason))
-			return;
-		if (!do_nmi_callback(regs, cpu))
-#endif /* !CONFIG_LOCKUP_DETECTOR */
-			unknown_nmi_error(reason, regs);
-#else
-		unknown_nmi_error(reason, regs);
+		reassert_nmi();
 #endif
-
+		raw_spin_unlock(&nmi_reason_lock);
 		return;
 	}
-	if (notify_die(DIE_NMI, "nmi", regs, reason, 2, SIGINT) == NOTIFY_STOP)
-		return;
+	raw_spin_unlock(&nmi_reason_lock);
 
-	/* AK: following checks seem to be broken on modern chipsets. FIXME */
-	if (reason & NMI_REASON_SERR)
-		pci_serr_error(reason, regs);
-	if (reason & NMI_REASON_IOCHK)
-		io_check_error(reason, regs);
-#ifdef CONFIG_X86_32
-	/*
-	 * Reassert NMI in case it became active meanwhile
-	 * as it's edge-triggered:
-	 */
-	reassert_nmi();
+#if defined(CONFIG_X86_LOCAL_APIC) && !defined(CONFIG_LOCKUP_DETECTOR)
+	if (nmi_watchdog_tick(regs, reason))
+		return;
+	if (do_nmi_callback(regs, smp_processor_id()))
+		return;
 #endif
+
+	if (notify_die(DIE_NMIUNKNOWN, "nmi_unknown", regs, reason, 2, SIGINT)
+	    == NOTIFY_STOP)
+		return;
+
+	unknown_nmi_error(reason, regs);
 }
 
 dotraplinkage notrace __kprobes void
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -64,7 +64,6 @@ static int profile_exceptions_notify(str
 	int ret = NOTIFY_DONE;
 
 	switch (val) {
-	case DIE_NMI:
 	case DIE_NMI_IPI:
 		if (ctr_running)
 			model->check_ctrs(args->regs, &__get_cpu_var(cpu_msrs));
--- a/arch/x86/oprofile/nmi_timer_int.c
+++ b/arch/x86/oprofile/nmi_timer_int.c
@@ -25,7 +25,7 @@ static int profile_timer_exceptions_noti
 	int ret = NOTIFY_DONE;
 
 	switch (val) {
-	case DIE_NMI:
+	case DIE_NMI_IPI:
 		oprofile_add_sample(args->regs, 0);
 		ret = NOTIFY_STOP;
 		break;
--- a/drivers/char/ipmi/ipmi_watchdog.c
+++ b/drivers/char/ipmi/ipmi_watchdog.c
@@ -1080,7 +1080,7 @@ ipmi_nmi(struct notifier_block *self, un
 {
 	struct die_args *args = data;
 
-	if (val != DIE_NMI)
+	if (val != DIE_NMIUNKNOWN)
 		return NOTIFY_OK;
 
 	/* Hack, if it's a memory or I/O error, ignore it. */
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -469,7 +469,7 @@ static int hpwdt_pretimeout(struct notif
 	unsigned long rom_pl;
 	static int die_nmi_called;
 
-	if (ulReason != DIE_NMI && ulReason != DIE_NMI_IPI)
+	if (ulReason != DIE_NMIUNKNOWN)
 		goto out;
 
 	if (!hpwdt_nmi_decoding)
