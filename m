Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154Ab2BHX5j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 18:57:39 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:51069 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932116Ab2BHX5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 18:57:38 -0500
MIME-Version: 1.0
From: Dmitry Antipov <dmitry.antipov@linaro.org>
To: Venki Pallipadi <venki@google.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, Dmitry Antipov <dmitry.antipov@linaro.org>
Subject: [PATCH] sched: generalize CONFIG_IRQ_TIME_ACCOUNTING for X86 and ARM
Date: Wed,  8 Feb 2012 15:58:36 -0800
Message-Id: <1328745516-14205-1-git-send-email-dmitry.antipov@linaro.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Generalize CONFIG_IRQ_TIME_ACCOUNTING  between X86 and
ARM, move "noirqtime=" option to common debugging code.
For a bit of backward compatibility, X86-specific option
"tsc=noirqtime" is preserved, but issues a warning.

Suggested-by: Russell King <rmk+kernel@arm.linux.org.uk>
Suggested-by: Venki Pallipadi <venki@google.com>
Signed-off-by: Dmitry Antipov <dmitry.antipov@linaro.org>
---
 Documentation/kernel-parameters.txt |    9 +++++----
 arch/arm/kernel/sched_clock.c       |    3 +++
 arch/x86/Kconfig                    |   11 -----------
 arch/x86/kernel/tsc.c               |    7 ++++---
 include/linux/sched.h               |    2 ++
 lib/Kconfig.debug                   |   12 ++++++++++++
 lib/Makefile                        |    2 ++
 lib/irqtime.c                       |   12 ++++++++++++
 8 files changed, 40 insertions(+), 18 deletions(-)
 create mode 100644 lib/irqtime.c

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 033d4e6..b64a13f 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1719,6 +1719,9 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 
 	noautogroup	Disable scheduler automatic task group creation.
 
+	noirqtime	[X86,ARM] Used to run time disable IRQ_TIME_ACCOUNTING,
+			should give a negligible performance improvement.			
+
 	nobats		[PPC] Do not use BATs for mapping kernel lowmem
 			on "Classic" PPC cores.
 
@@ -2636,10 +2639,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			as the stability checks done at bootup.	Used to enable
 			high-resolution timer mode on older hardware, and in
 			virtualized environment.
-			[x86] noirqtime: Do not use TSC to do irq accounting.
-			Used to run time disable IRQ_TIME_ACCOUNTING on any
-			platforms where RDTSC is slow and this accounting
-			can add overhead.
+			[x86] noirqtime: obsoleted by "noirqtime" generic option,
+			see it's documentation for details.
 
 	turbografx.map[2|3]=	[HW,JOY]
 			TurboGraFX parallel port interface
diff --git a/arch/arm/kernel/sched_clock.c b/arch/arm/kernel/sched_clock.c
index 5416c7c..961bd2d 100644
--- a/arch/arm/kernel/sched_clock.c
+++ b/arch/arm/kernel/sched_clock.c
@@ -144,6 +144,9 @@ void __init setup_sched_clock(u32 (*read)(void), int bits, unsigned long rate)
 	 */
 	cd.epoch_ns = 0;
 
+	if (!no_sched_irq_time)
+		enable_sched_clock_irqtime();
+
 	pr_debug("Registered %pF as sched_clock source\n", read);
 }
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5bed94e..4759676 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -805,17 +805,6 @@ config SCHED_MC
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
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index a62c201..70510a3 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -103,14 +103,15 @@ int __init notsc_setup(char *str)
 
 __setup("notsc", notsc_setup);
 
-static int no_sched_irq_time;
-
 static int __init tsc_setup(char *str)
 {
 	if (!strcmp(str, "reliable"))
 		tsc_clocksource_reliable = 1;
-	if (!strncmp(str, "noirqtime", 9))
+	if (!strncmp(str, "noirqtime", 9)) {
+		printk(KERN_WARNING "tsc: tsc=noirqtime is "
+		       "obsolete, use noirqtime instead\n");
 		no_sched_irq_time = 1;
+	}
 	return 1;
 }
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 7d379a6..b3575b5 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1966,9 +1966,11 @@ extern void sched_clock_idle_wakeup_event(u64 delta_ns);
  * The reason for this explicit opt-in is not to have perf penalty with
  * slow sched_clocks.
  */
+extern int no_sched_irq_time;
 extern void enable_sched_clock_irqtime(void);
 extern void disable_sched_clock_irqtime(void);
 #else
+#define no_sched_irq_time 1
 static inline void enable_sched_clock_irqtime(void) {}
 static inline void disable_sched_clock_irqtime(void) {}
 #endif
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 8745ac7..236e814 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -299,6 +299,18 @@ config SCHEDSTATS
 	  application, you can say N to avoid the very slight overhead
 	  this adds.
 
+config IRQ_TIME_ACCOUNTING
+	bool "Fine granularity task level IRQ time accounting"
+	depends on X86 || ARM
+	default n
+	---help---
+	  Select this option to enable fine granularity task irq time
+	  accounting. This is done by reading a timestamp on each
+	  transitions between softirq and hardirq state, so there can be a
+	  small performance impact.
+
+	  If in doubt, say N here.
+
 config TIMER_STATS
 	bool "Collect kernel timers statistics"
 	depends on DEBUG_KERNEL && PROC_FS
diff --git a/lib/Makefile b/lib/Makefile
index 18515f0..44d67d4 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -49,6 +49,8 @@ obj-$(CONFIG_DEBUG_PREEMPT) += smp_processor_id.o
 obj-$(CONFIG_DEBUG_LIST) += list_debug.o
 obj-$(CONFIG_DEBUG_OBJECTS) += debugobjects.o
 
+obj-$(CONFIG_IRQ_TIME_ACCOUNTING) += irqtime.o
+
 ifneq ($(CONFIG_HAVE_DEC_LOCK),y)
   lib-y += dec_and_lock.o
 endif
diff --git a/lib/irqtime.c b/lib/irqtime.c
new file mode 100644
index 0000000..10d440d
--- /dev/null
+++ b/lib/irqtime.c
@@ -0,0 +1,12 @@
+#include <linux/kernel.h>
+#include <linux/sched.h>
+
+int no_sched_irq_time;
+
+static int __init irqtime_setup(char *str)
+{
+	no_sched_irq_time = 1;
+	return 1;
+}
+
+__setup("noirqtime", irqtime_setup);
-- 
1.7.7.6

