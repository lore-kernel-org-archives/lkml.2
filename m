Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306Ab1BJMZU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 07:25:20 -0500
Received: from cantor.suse.de ([195.135.220.2]:33755 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756119Ab1BJMZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 07:25:12 -0500
From: stable-bot for Venkatesh Pallipadi <venki@google.com>
Date: Thu, 10 Feb 2011 10:23:27 +0100
Subject: [PATCH 18/28] x86: Add IRQ_TIME_ACCOUNTING
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>
Message-ID: <1297340644.5512.18.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit: e82b8e4ea4f3dffe6e7939f90e78da675fcc450e upstream
Author: Venkatesh Pallipadi <venki@google.com>
AuthorDate: Mon Oct 4 17:03:20 2010 -0700

This patch adds IRQ_TIME_ACCOUNTING option on x86 and runtime enables it
when TSC is enabled.

This change just enables fine grained irq time accounting, isn't used yet.
Following patches use it for different purposes.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1286237003-12406-6-git-send-email-venki@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 Documentation/kernel-parameters.txt |    4 ++++
 arch/x86/Kconfig                    |   11 +++++++++++
 arch/x86/kernel/tsc.c               |    8 ++++++++
 3 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 5f6aa11..86c1dde 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2577,6 +2577,10 @@ and is between 256 and 4096 characters. It is defined in the file
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
index cb5a57c..73ae02a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -753,6 +753,17 @@ config SCHED_MC
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
index aaefa71..bc07543 100644
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
 
@@ -802,6 +806,7 @@ void mark_tsc_unstable(char *reason)
 	if (!tsc_unstable) {
 		tsc_unstable = 1;
 		sched_clock_stable = 0;
+		disable_sched_clock_irqtime();
 		printk(KERN_INFO "Marking TSC unstable due to %s\n", reason);
 		/* Change only the rating, when not registered */
 		if (clocksource_tsc.mult)
@@ -990,6 +995,9 @@ void __init tsc_init(void)
 	/* now allow native_sched_clock() to use rdtsc */
 	tsc_disabled = 0;
 
+	if (!no_sched_irq_time)
+		enable_sched_clock_irqtime();
+
 	lpj = ((u64)tsc_khz * 1000);
 	do_div(lpj, HZ);
 	lpj_fine = lpj;
-- 
1.7.4


