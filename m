Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145Ab0JPQhO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 12:37:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:53224 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751063Ab0JPQhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 12:37:12 -0400
Date: Sat, 16 Oct 2010 16:36:49 GMT
From: tip-bot for Huang Ying <ying.huang@intel.com>
Cc: linux-kernel@vger.kernel.org, ying.huang@intel.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu,
        dzickus@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, ying.huang@intel.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, dzickus@redhat.com,
        mingo@elte.hu
In-Reply-To: <1287195738-3136-4-git-send-email-dzickus@redhat.com>
References: <1287195738-3136-4-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86, NMI: Rewrite NMI handler
Message-ID: <tip-e21f3e4957f4a55f546873605a5caa59556bb144@git.kernel.org>
Git-Commit-ID: e21f3e4957f4a55f546873605a5caa59556bb144
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 16 Oct 2010 16:36:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e21f3e4957f4a55f546873605a5caa59556bb144
Gitweb:     http://git.kernel.org/tip/e21f3e4957f4a55f546873605a5caa59556bb144
Author:     Huang Ying <ying.huang@intel.com>
AuthorDate: Fri, 15 Oct 2010 22:22:16 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 16 Oct 2010 15:01:27 +0200

x86, NMI: Rewrite NMI handler

The original NMI handler is quite outdated in many aspects. This
patch tries to fix it.

The order to process the NMI sources are changed as follow:

 notify_die(DIE_NMI_IPI);
 notify_die(DIE_NMI);
 /* process io port 0x61 */
 nmi_watchdog_touch();
 unknown_nmi();

DIE_NMI_IPI is used to process CPU specific NMI sources, such as
perf event, oprofile, crash IPI, etc. While DIE_NMI is used to
process non-CPU-specific NMI sources, such as APEI (ACPI
Platform Error Interface) GHES (Generic Hardware Error Source),
etc. Non-CPU-specific NMI sources can be processed on any CPU,

DIE_NMI_IPI must be processed before DIE_NMI. For example, perf
event trigger a NMI on CPU 1, at the same time, APEI GHES
trigger another NMI on CPU 0. If DIE_NMI is processed before
DIE_NMI_IPI, it is possible that APEI GHES is processed on CPU
1, while unknown NMI is gotten on CPU 0.

In this new order of processing, performance sensitive NMI
sources such as oprofile or perf event will have better
performance because the time consuming IO port reading is done
after them.

Only one NMI is eaten for each NMI handler call, even for PCI
SERR and IOCHK NMIs. Because one NMI should be raised for each
of them, eating too many NMI will cause unnecessary unknown NMI.

The die value used in NMI sources are fixed accordingly.

The NMI handler in the patch is designed by Andi Kleen.

v3:

- Make DIE_NMI and DIE_NMI_UNKNOWN work in more traditional way.

v2:

- Split process NMI reason (0x61) on non-BSP into another patch

Signed-off-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: andi@firstfloor.org
Cc: robert.richter@amd.com
Cc: peterz@infradead.org
LKML-Reference: <1287195738-3136-4-git-send-email-dzickus@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c  |    1 -
 arch/x86/kernel/traps.c           |   78 +++++++++++++++++++------------------
 arch/x86/oprofile/nmi_int.c       |    1 -
 arch/x86/oprofile/nmi_timer_int.c |    2 +-
 drivers/char/ipmi/ipmi_watchdog.c |    2 +-
 drivers/watchdog/hpwdt.c          |    2 +-
 6 files changed, 43 insertions(+), 43 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index e2513f2..8ed55be 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1245,7 +1245,6 @@ perf_event_nmi_handler(struct notifier_block *self,
 		return NOTIFY_DONE;
 
 	switch (cmd) {
-	case DIE_NMI:
 	case DIE_NMI_IPI:
 		break;
 	case DIE_NMIUNKNOWN:
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index bef859e..d8acab3 100644
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
index f1575c9..69f2453 100644
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
index 654d566..6a273fb 100644
--- a/drivers/char/ipmi/ipmi_watchdog.c
+++ b/drivers/char/ipmi/ipmi_watchdog.c
@@ -1080,7 +1080,7 @@ ipmi_nmi(struct notifier_block *self, unsigned long val, void *data)
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
