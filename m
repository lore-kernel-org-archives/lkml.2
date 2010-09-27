Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758669Ab0I0A6i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 20:58:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:61860 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754885Ab0I0A5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 20:57:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,240,1283756400"; 
   d="scan'208";a="841121741"
From: Huang Ying <ying.huang@intel.com>
To: Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Huang Ying <ying.huang@intel.com>
Subject: [PATCH -v2 4/7] x86, NMI, Rewrite NMI handler
Date: Mon, 27 Sep 2010 08:57:03 +0800
Message-Id: <1285549026-5008-4-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285549026-5008-1-git-send-email-ying.huang@intel.com>
References: <1285549026-5008-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original NMI handler is quite outdated in many aspects. This patch
try to fix it.

The order to process the NMI sources are changed as follow:

notify_die(DIE_NMI_IPI);
notify_die(DIE_NMI);
/* process io port 0x61 */
nmi_watchdog_touch();
notify_die(DIE_NMIUNKNOWN);
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


v2:

- Split process NMI reason (0x61) on non-BSP into another patch

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 arch/x86/kernel/cpu/perf_event.c  |    1 
 arch/x86/kernel/traps.c           |   80 +++++++++++++++++++-------------------
 arch/x86/oprofile/nmi_int.c       |    1 
 arch/x86/oprofile/nmi_timer_int.c |    2 
 drivers/char/ipmi/ipmi_watchdog.c |    2 
 drivers/watchdog/hpwdt.c          |    2 
 6 files changed, 43 insertions(+), 45 deletions(-)

--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1247,7 +1247,6 @@ perf_event_nmi_handler(struct notifier_b
 		return NOTIFY_DONE;
 
 	switch (cmd) {
-	case DIE_NMI:
 	case DIE_NMI_IPI:
 		break;
 	case DIE_NMIUNKNOWN:
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -354,9 +354,6 @@ io_check_error(unsigned char reason, str
 static notrace __kprobes void
 unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
 {
-	if (notify_die(DIE_NMIUNKNOWN, "nmi", regs, reason, 2, SIGINT) ==
-			NOTIFY_STOP)
-		return;
 #ifdef CONFIG_MCA
 	/*
 	 * Might actually be able to figure out what the guilty party
@@ -385,51 +382,54 @@ static notrace __kprobes void default_do
 
 	cpu = smp_processor_id();
 
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
+	if (!cpu) {
+		reason = get_nmi_reason();
+		if (reason & NMI_REASON_MASK) {
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
 #endif
+			return;
+		}
+	}
 
+#if defined(CONFIG_X86_LOCAL_APIC) && !defined(CONFIG_LOCKUP_DETECTOR)
+	if (nmi_watchdog_tick(regs, reason))
 		return;
-	}
-	if (notify_die(DIE_NMI, "nmi", regs, reason, 2, SIGINT) == NOTIFY_STOP)
+	if (do_nmi_callback(regs, smp_processor_id()))
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
