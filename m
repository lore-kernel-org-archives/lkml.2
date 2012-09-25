Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947Ab2IYPHS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 11:07:18 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:43130 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756889Ab2IYPHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 11:07:09 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 6/6] cputime: Make finegrained irqtime accounting generally available
Date: Tue, 25 Sep 2012 17:06:07 +0200
Message-Id: <1348585567-2925-7-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348585567-2925-1-git-send-email-fweisbec@gmail.com>
References: <1348585567-2925-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no known reason for this option to be unavailable on other
archs than x86. They just need to call enable_sched_clock_irqtime()
if they have a sufficiently finegrained clock to make it working.

Move it to the general option and let the user choose between
it and pure tick based or virtual cputime accounting.

Note that virtual cputime accounting already performs a finegrained
irqtime accounting. CONFIG_IRQ_TIME_ACCOUNTING is a kind of middle ground
between tick and virtual based accounting. So CONFIG_IRQ_TIME_ACCOUNTING
and CONFIG_VIRT_CPU_ACCOUNTING are mutually exclusive choices.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Russell King <linux@arm.linux.org.uk>
---
 arch/Kconfig     |    6 ++++++
 arch/x86/Kconfig |   12 +-----------
 init/Kconfig     |   30 +++++++++++++++++++++++++++++-
 3 files changed, 36 insertions(+), 12 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index f78de57..101c31a 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -284,4 +284,10 @@ config SECCOMP_FILTER
 config HAVE_VIRT_CPU_ACCOUNTING
 	bool
 
+config HAVE_IRQ_TIME_ACCOUNTING
+	bool
+	help
+	  Archs need to ensure they use a high enough resolution clock to
+	  support irq time accounting and then call enable_sched_clock_irqtime().
+
 source "kernel/gcov/Kconfig"
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 8ec3a1a..b86833a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -97,6 +97,7 @@ config X86
 	select KTIME_SCALAR if X86_32
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
+	select HAVE_IRQ_TIME_ACCOUNTING
 
 config INSTRUCTION_DECODER
 	def_bool (KPROBES || PERF_EVENTS || UPROBES)
@@ -796,17 +797,6 @@ config SCHED_MC
 	  making when dealing with multi-core CPU chips at a cost of slightly
 	  increased overhead in some places. If unsure say N here.
 
-config IRQ_TIME_ACCOUNTING
-	bool "Fine granularity task level IRQ time accounting"
-	default n
-	---help---
-	  Select this option to enable fine granularity task irq time
-	  accounting. This is done by reading a timestamp on each
-	  transitions between softirq and hardirq state, so there can be a
-	  small performance impact.
-
-	  If in doubt, say N here.
-
 source "kernel/Kconfig.preempt"
 
 config X86_UP_APIC
diff --git a/init/Kconfig b/init/Kconfig
index 2c5aa34..1862c68 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -326,10 +326,25 @@ source "kernel/time/Kconfig"
 
 menu "CPU/Task time and stats accounting"
 
+choice
+	prompt "Cputime accounting"
+	default TICK_CPU_ACCOUNTING if !PPC64
+	default VIRT_CPU_ACCOUNTING if PPC64
+
+# Kind of a stub config for the pure tick based cputime accounting
+config TICK_CPU_ACCOUNTING
+	bool "Simple tick based cputime accounting"
+	depends on !S390
+	help
+	  This is the basic tick based cputime accounting that maintains
+	  statistics about user, system and idle time spent on per jiffies
+	  granularity.
+
+	  If unsure, say Y.
+
 config VIRT_CPU_ACCOUNTING
 	bool "Deterministic task and CPU time accounting"
 	depends on HAVE_VIRT_CPU_ACCOUNTING
-	default y if PPC64
 	help
 	  Select this option to enable more accurate task and CPU time
 	  accounting.  This is done by reading a CPU counter on each
@@ -339,6 +354,19 @@ config VIRT_CPU_ACCOUNTING
 	  this also enables accounting of stolen time on logically-partitioned
 	  systems.
 
+config IRQ_TIME_ACCOUNTING
+	bool "Fine granularity task level IRQ time accounting"
+	depends on HAVE_IRQ_TIME_ACCOUNTING
+	help
+	  Select this option to enable fine granularity task irq time
+	  accounting. This is done by reading a timestamp on each
+	  transitions between softirq and hardirq state, so there can be a
+	  small performance impact.
+
+	  If in doubt, say N here.
+
+endchoice
+
 config BSD_PROCESS_ACCT
 	bool "BSD Process Accounting"
 	help
-- 
1.7.5.4

