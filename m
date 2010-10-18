Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933149Ab0JRT0f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 15:26:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:58822 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933101Ab0JRT0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 15:26:33 -0400
Date: Mon, 18 Oct 2010 19:26:04 GMT
From: tip-bot for Venkatesh Pallipadi <venki@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu,
        venki@google.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, venki@google.com,
        mingo@elte.hu
In-Reply-To: <1286237003-12406-6-git-send-email-venki@google.com>
References: <1286237003-12406-6-git-send-email-venki@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] x86: Add IRQ_TIME_ACCOUNTING
Message-ID: <tip-e82b8e4ea4f3dffe6e7939f90e78da675fcc450e@git.kernel.org>
Git-Commit-ID: e82b8e4ea4f3dffe6e7939f90e78da675fcc450e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Oct 2010 19:26:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e82b8e4ea4f3dffe6e7939f90e78da675fcc450e
Gitweb:     http://git.kernel.org/tip/e82b8e4ea4f3dffe6e7939f90e78da675fcc450e
Author:     Venkatesh Pallipadi <venki@google.com>
AuthorDate: Mon, 4 Oct 2010 17:03:20 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 18 Oct 2010 20:52:25 +0200

x86: Add IRQ_TIME_ACCOUNTING

This patch adds IRQ_TIME_ACCOUNTING option on x86 and runtime enables it
when TSC is enabled.

This change just enables fine grained irq time accounting, isn't used yet.
Following patches use it for different purposes.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1286237003-12406-6-git-send-email-venki@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Documentation/kernel-parameters.txt |    4 ++++
 arch/x86/Kconfig                    |   11 +++++++++++
 arch/x86/kernel/tsc.c               |    8 ++++++++
 3 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 8dd7248..ed05a4a 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2435,6 +2435,10 @@ and is between 256 and 4096 characters. It is defined in the file
 			disables clocksource verification at runtime.
 			Used to enable high-resolution timer mode on older
 			hardware, and in virtualized environment.
+			[x86] noirqtime: Do not use TSC to do irq accounting.
+			Used to run time disable IRQ_TIME_ACCOUNTING on any
+			platforms where RDTSC is slow and this accounting
+			can add overhead.
 
 	turbografx.map[2|3]=	[HW,JOY]
 			TurboGraFX parallel port interface
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cea0cd9..f4c70c2 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -795,6 +795,17 @@ config SCHED_MC
 	  making when dealing with multi-core CPU chips at a cost of slightly
 	  increased overhead in some places. If unsure say N here.
 
+config IRQ_TIME_ACCOUNTING
+	bool "Fine granularity task level IRQ time accounting"
+	default n
+	---help---
+	  Select this option to enable fine granularity task irq time
+	  accounting. This is done by reading a timestamp on each
+	  transitions between softirq and hardirq state, so there can be a
+	  small performance impact.
+
+	  If in doubt, say N here.
+
 source "kernel/Kconfig.preempt"
 
 config X86_UP_APIC
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 26a863a..a1c2cd7 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -104,10 +104,14 @@ int __init notsc_setup(char *str)
 
 __setup("notsc", notsc_setup);
 
+static int no_sched_irq_time;
+
 static int __init tsc_setup(char *str)
 {
 	if (!strcmp(str, "reliable"))
 		tsc_clocksource_reliable = 1;
+	if (!strncmp(str, "noirqtime", 9))
+		no_sched_irq_time = 1;
 	return 1;
 }
 
@@ -801,6 +805,7 @@ void mark_tsc_unstable(char *reason)
 	if (!tsc_unstable) {
 		tsc_unstable = 1;
 		sched_clock_stable = 0;
+		disable_sched_clock_irqtime();
 		printk(KERN_INFO "Marking TSC unstable due to %s\n", reason);
 		/* Change only the rating, when not registered */
 		if (clocksource_tsc.mult)
@@ -987,6 +992,9 @@ void __init tsc_init(void)
 	/* now allow native_sched_clock() to use rdtsc */
 	tsc_disabled = 0;
 
+	if (!no_sched_irq_time)
+		enable_sched_clock_irqtime();
+
 	lpj = ((u64)tsc_khz * 1000);
 	do_div(lpj, HZ);
 	lpj_fine = lpj;
