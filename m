Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932405Ab0KLOpH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 09:45:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18316 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932317Ab0KLOpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 09:45:03 -0500
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 3/6] x86, NMI: Rewrite NMI handler
Date: Fri, 12 Nov 2010 09:43:50 -0500
Message-Id: <1289573033-2889-4-git-send-email-dzickus@redhat.com>
In-Reply-To: <1289573033-2889-1-git-send-email-dzickus@redhat.com>
References: <1289573033-2889-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huang Ying <ying.huang@intel.com>

The original NMI handler is quite outdated in many aspects. This patch
try to fix it.

The order to process the NMI sources are changed as follow:

notify_die(DIE_NMI_IPI);
notify_die(DIE_NMI);
/* process io port 0x61 */
nmi_watchdog_touch();
unknown_nmi();

DIE_NMI_IPI is used to process CPU specific NMI sources, such as perf
event, oprofile, crash IPI, etc. While DIE_NMI is used to process
non-CPU-specific NMI sources, such as APEI (ACPI Platform Error
Interface) GHES (Generic Hardware Error Source), etc. Non-CPU-specific
NMI sources can be processed on any CPU,

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

v3:

- Make DIE_NMI and DIE_NMI_UNKNOWN work in more traditional way.

v2:

- Split process NMI reason (0x61) on non-BSP into another patch

Signed-off-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/kernel/cpu/perf_event.c  |    1 -
 arch/x86/kernel/traps.c           |   78 +++++++++++++++++++------------------
 arch/x86/oprofile/nmi_int.c       |    1 -
 arch/x86/oprofile/nmi_timer_int.c |    2 +-
 drivers/char/ipmi/ipmi_watchdog.c |    2 +-
 drivers/watchdog/hpwdt.c          |    2 +-
 6 files changed, 43 insertions(+), 43 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index ed63101..e98d65c 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1224,7 +1224,6 @@ perf_event_nmi_handler(struct notifier_block *self,
 		return NOTIFY_DONE;
 
 	switch (cmd) {
-	case DIE_NMI:
 	case DIE_NMI_IPI:
 		break;
 	case DIE_NMIUNKNOWN:
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 0d75c6b..e63bf59 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -385,53 +385,55 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 	unsigned char reason = 0;
 	int cpu;
 
-	cpu = smp_processor_id();
+	/*
+	 * CPU-specific NMI must be processed before non-CPU-specific
+	 * NMI, otherwise we may lose it, because the CPU-specific
+	 * NMI can not be detected/processed on other CPUs.
+	 */
+
+	/*
+	 * CPU-specific NMI: send to specific CPU or NMI sources must
+	 * be processed on specific CPU
+	 */
+	if (notify_die(DIE_NMI_IPI, "nmi_ipi", regs, 0, 2, SIGINT)
+	    == NOTIFY_STOP)
+		return;
 
+	/* Non-CPU-specific NMI: NMI sources can be processed on any CPU */
+	cpu = smp_processor_id();
 	/* Only the BSP gets external NMIs from the system. */
-	if (!cpu)
+	if (!cpu) {
 		reason = get_nmi_reason();
-
-	if (!(reason & NMI_REASON_MASK)) {
-		if (notify_die(DIE_NMI_IPI, "nmi_ipi", regs, reason, 2, SIGINT)
-								== NOTIFY_STOP)
-			return;
-
-#ifdef CONFIG_X86_LOCAL_APIC
-		if (notify_die(DIE_NMI, "nmi", regs, reason, 2, SIGINT)
-							== NOTIFY_STOP)
+		if (reason & NMI_REASON_MASK) {
+			if (notify_die(DIE_NMI, "nmi", regs, reason, 2, SIGINT)
+			    == NOTIFY_STOP)
+				return;
+			if (reason & NMI_REASON_SERR)
+				pci_serr_error(reason, regs);
+			else if (reason & NMI_REASON_IOCHK)
+				io_check_error(reason, regs);
+#ifdef CONFIG_X86_32
+			/*
+			 * Reassert NMI in case it became active
+			 * meanwhile as it's edge-triggered:
+			 */
+			reassert_nmi();
+#endif
 			return;
+		}
+	}
 
-#ifndef CONFIG_LOCKUP_DETECTOR
-		/*
-		 * Ok, so this is none of the documented NMI sources,
-		 * so it must be the NMI watchdog.
-		 */
-		if (nmi_watchdog_tick(regs, reason))
-			return;
-		if (!do_nmi_callback(regs, cpu))
-#endif /* !CONFIG_LOCKUP_DETECTOR */
-			unknown_nmi_error(reason, regs);
-#else
-		unknown_nmi_error(reason, regs);
-#endif
+	if (notify_die(DIE_NMI, "nmi", regs, 0, 2, SIGINT) == NOTIFY_STOP)
+		return;
 
+#if defined(CONFIG_X86_LOCAL_APIC) && !defined(CONFIG_LOCKUP_DETECTOR)
+	if (nmi_watchdog_tick(regs, reason))
 		return;
-	}
-	if (notify_die(DIE_NMI, "nmi", regs, reason, 2, SIGINT) == NOTIFY_STOP)
+	if (do_nmi_callback(regs, cpu))
 		return;
-
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
 #endif
+
+	unknown_nmi_error(reason, regs);
 }
 
 dotraplinkage notrace __kprobes void
diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 4e8baad..ee7ff0e 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -64,7 +64,6 @@ static int profile_exceptions_notify(struct notifier_block *self,
 	int ret = NOTIFY_DONE;
 
 	switch (val) {
-	case DIE_NMI:
 	case DIE_NMI_IPI:
 		if (ctr_running)
 			model->check_ctrs(args->regs, &__get_cpu_var(cpu_msrs));
diff --git a/arch/x86/oprofile/nmi_timer_int.c b/arch/x86/oprofile/nmi_timer_int.c
index e3ecb71..ab72a21 100644
--- a/arch/x86/oprofile/nmi_timer_int.c
+++ b/arch/x86/oprofile/nmi_timer_int.c
@@ -25,7 +25,7 @@ static int profile_timer_exceptions_notify(struct notifier_block *self,
 	int ret = NOTIFY_DONE;
 
 	switch (val) {
-	case DIE_NMI:
+	case DIE_NMI_IPI:
 		oprofile_add_sample(args->regs, 0);
 		ret = NOTIFY_STOP;
 		break;
diff --git a/drivers/char/ipmi/ipmi_watchdog.c b/drivers/char/ipmi/ipmi_watchdog.c
index f4d334f..320668f 100644
--- a/drivers/char/ipmi/ipmi_watchdog.c
+++ b/drivers/char/ipmi/ipmi_watchdog.c
@@ -1081,7 +1081,7 @@ ipmi_nmi(struct notifier_block *self, unsigned long val, void *data)
 {
 	struct die_args *args = data;
 
-	if (val != DIE_NMI)
+	if (val != DIE_NMIUNKNOWN)
 		return NOTIFY_OK;
 
 	/* Hack, if it's a memory or I/O error, ignore it. */
diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index 3d77116..d8010cc 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -469,7 +469,7 @@ static int hpwdt_pretimeout(struct notifier_block *nb, unsigned long ulReason,
 	unsigned long rom_pl;
 	static int die_nmi_called;
 
-	if (ulReason != DIE_NMI && ulReason != DIE_NMI_IPI)
+	if (ulReason != DIE_NMIUNKNOWN)
 		goto out;
 
 	if (!hpwdt_nmi_decoding)
-- 
1.7.2.3

