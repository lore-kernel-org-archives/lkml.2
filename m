Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab0EPCeT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 22:34:19 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37093 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998Ab0EPCeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 22:34:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=oUDQQL4PXLA3T8KIQJWDgXMVNuEs09bZmvFMJ7ikNeCbeFvfg+eAmPdiUXxcS0F9Nz
         Vo+CrZBvtGyfdUWfn561KIm/QvNmd0mh4l838/0lJzlp+PoQFdeuaWwmIB+1rewsIHER
         4dOFt1XNAOY8DKGz8CynvUfR7PHqGVpwBDN1A=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Don Zickus <dzickus@redhat.com>, Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH 3/4] lockup_detector: Introduce CONFIG_HARDLOCKUP_DETECTOR
Date: Sun, 16 May 2010 04:33:59 +0200
Message-Id: <1273977240-30800-4-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <20100515073732.GA17120@elte.hu>
References: <20100515073732.GA17120@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This new config is deemed to simplify even more the lockup detector
dependencies and can make it easier to bring a smooth sorting
between archs that support the new generic lockup detector and those
that still have their own, especially for those that are in the
middle of this migration.

Instead of checking whether we have CONFIG_LOCKUP_DETECTOR +
CONFIG_PERF_EVENTS_NMI each time an arch wants to know if it needs
to build its own lockup detector, take a shortcut with this new
config. It is enabled only if the hardlockup detection part of
the whole lockup detector is on.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
---
 arch/Kconfig      |    4 ++++
 init/Kconfig      |    7 -------
 kernel/watchdog.c |   14 +++++++-------
 lib/Kconfig.debug |    3 +++
 4 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 89b0efb..35084f2 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -147,5 +147,9 @@ config HAVE_USER_RETURN_NOTIFIER
 
 config HAVE_PERF_EVENTS_NMI
 	bool
+	help
+	  System hardware can generate an NMI using the perf event
+	  subsystem.  Also has support for calculating CPU cycle events
+	  to determine how many clock cycles in a given period.
 
 source "kernel/gcov/Kconfig"
diff --git a/init/Kconfig b/init/Kconfig
index ab733c3..eb77e8c 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -942,13 +942,6 @@ config PERF_USE_VMALLOC
 	help
 	  See tools/perf/design.txt for details
 
-config PERF_EVENTS_NMI
-	def_bool PERF_EVENTS && HAVE_PERF_EVENTS_NMI
-	help
-	  System hardware can generate an NMI using the perf event
-	  subsystem.  Also has support for calculating CPU cycle events
-	  to determine how many clock cycles in a given period.
-
 menu "Kernel Performance Events And Counters"
 
 config PERF_EVENTS
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index be5e74e..83fb631 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -37,7 +37,7 @@ static DEFINE_PER_CPU(struct hrtimer, watchdog_hrtimer);
 static DEFINE_PER_CPU(bool, softlockup_touch_sync);
 static DEFINE_PER_CPU(bool, hard_watchdog_warn);
 static DEFINE_PER_CPU(bool, soft_watchdog_warn);
-#ifdef CONFIG_PERF_EVENTS_NMI
+#ifdef CONFIG_HARDLOCKUP_DETECTOR
 static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts);
 static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts_saved);
 static DEFINE_PER_CPU(struct perf_event *, watchdog_ev);
@@ -51,7 +51,7 @@ static int __initdata no_watchdog;
 /*
  * Should we panic when a soft-lockup or hard-lockup occurs:
  */
-#ifdef CONFIG_PERF_EVENTS_NMI
+#ifdef CONFIG_HARDLOCKUP_DETECTOR
 static int hardlockup_panic;
 
 static int __init hardlockup_panic_setup(char *str)
@@ -152,7 +152,7 @@ void touch_softlockup_watchdog_sync(void)
 	__raw_get_cpu_var(watchdog_touch_ts) = 0;
 }
 
-#ifdef CONFIG_PERF_EVENTS_NMI
+#ifdef CONFIG_HARDLOCKUP_DETECTOR
 /* watchdog detector functions */
 static int is_hardlockup(int cpu)
 {
@@ -189,7 +189,7 @@ static struct notifier_block panic_block = {
 	.notifier_call = watchdog_panic,
 };
 
-#ifdef CONFIG_PERF_EVENTS_NMI
+#ifdef CONFIG_HARDLOCKUP_DETECTOR
 static struct perf_event_attr wd_hw_attr = {
 	.type		= PERF_TYPE_HARDWARE,
 	.config		= PERF_COUNT_HW_CPU_CYCLES,
@@ -239,7 +239,7 @@ static void watchdog_interrupt_count(void)
 }
 #else
 static inline void watchdog_interrupt_count(void) { return; }
-#endif /* CONFIG_PERF_EVENTS_NMI */
+#endif /* CONFIG_HARDLOCKUP_DETECTOR */
 
 /* watchdog kicker functions */
 static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
@@ -342,7 +342,7 @@ static int watchdog(void *__bind_cpu)
 }
 
 
-#ifdef CONFIG_PERF_EVENTS_NMI
+#ifdef CONFIG_HARDLOCKUP_DETECTOR
 static int watchdog_nmi_enable(int cpu)
 {
 	struct perf_event_attr *wd_attr;
@@ -393,7 +393,7 @@ static void watchdog_nmi_disable(int cpu)
 #else
 static int watchdog_nmi_enable(int cpu) { return 0; }
 static void watchdog_nmi_disable(int cpu) { return; }
-#endif /* CONFIG_PERF_EVENTS_NMI */
+#endif /* CONFIG_HARDLOCKUP_DETECTOR */
 
 /* prepare/enable/disable routines */
 static int watchdog_prepare_cpu(int cpu)
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 3a18b0b..e65e47d 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -174,6 +174,9 @@ config LOCKUP_DETECTOR
 	  generate interrupts and kick the watchdog task every 10-12 seconds.
 	  An NMI is generated every 60 seconds or so to check for hardlockups.
 
+config HARDLOCKUP_DETECTOR
+	def_bool LOCKUP_DETECTOR && PERF_EVENTS && HAVE_PERF_EVENTS_NMI
+
 config BOOTPARAM_SOFTLOCKUP_PANIC
 	bool "Panic (Reboot) On Soft Lockups"
 	depends on LOCKUP_DETECTOR
-- 
1.6.2.3

