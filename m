Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab1A1QBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 11:01:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40197 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755082Ab1A1QBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 11:01:13 -0500
From: Don Zickus <dzickus@redhat.com>
To: x86@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Don Zickus <dzickus@redhat.com>, Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        stable@kernel.org
Subject: [PATCH 1/3] watchdog: Fix broken nowatchdog logic
Date: Fri, 28 Jan 2011 11:00:31 -0500
Message-Id: <1296230433-6261-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcin Slusarz <marcin.slusarz@gmail.com>

Passing nowatchdog to kernel disables 2 things: creation of watchdog threads
AND initialization of percpu watchdog_hrtimer. As hrtimers are initialized
only at boot it's not possible to enable watchdog later - for me all watchdog
threads started to eat 100% of CPU time, but they could just crash.

Additionally, even if these threads would start properly,
watchdog_disable_all_cpus was guarded by no_watchdog check, so you
couldn't disable watchdog.

To fix this, remove no_watchdog variable and use already existing
watchdog_enabled variable.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: stable@kernel.org
[ removed another no_watchdog instance ]
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 kernel/watchdog.c |   20 ++++++--------------
 1 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index aaa8dae..7d4213e 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -27,7 +27,7 @@
 #include <asm/irq_regs.h>
 #include <linux/perf_event.h>
 
-int watchdog_enabled;
+int watchdog_enabled = 1;
 int __read_mostly softlockup_thresh = 60;
 
 static DEFINE_PER_CPU(unsigned long, watchdog_touch_ts);
@@ -43,9 +43,6 @@ static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts_saved);
 static DEFINE_PER_CPU(struct perf_event *, watchdog_ev);
 #endif
 
-static int no_watchdog;
-
-
 /* boot commands */
 /*
  * Should we panic when a soft-lockup or hard-lockup occurs:
@@ -58,7 +55,7 @@ static int __init hardlockup_panic_setup(char *str)
 	if (!strncmp(str, "panic", 5))
 		hardlockup_panic = 1;
 	else if (!strncmp(str, "0", 1))
-		no_watchdog = 1;
+		watchdog_enabled = 0;
 	return 1;
 }
 __setup("nmi_watchdog=", hardlockup_panic_setup);
@@ -77,7 +74,7 @@ __setup("softlockup_panic=", softlockup_panic_setup);
 
 static int __init nowatchdog_setup(char *str)
 {
-	no_watchdog = 1;
+	watchdog_enabled = 0;
 	return 1;
 }
 __setup("nowatchdog", nowatchdog_setup);
@@ -85,7 +82,7 @@ __setup("nowatchdog", nowatchdog_setup);
 /* deprecated */
 static int __init nosoftlockup_setup(char *str)
 {
-	no_watchdog = 1;
+	watchdog_enabled = 0;
 	return 1;
 }
 __setup("nosoftlockup", nosoftlockup_setup);
@@ -476,9 +473,6 @@ static void watchdog_disable_all_cpus(void)
 {
 	int cpu;
 
-	if (no_watchdog)
-		return;
-
 	for_each_online_cpu(cpu)
 		watchdog_disable(cpu);
 
@@ -530,7 +524,8 @@ cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		break;
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
-		err = watchdog_enable(hotcpu);
+		if (watchdog_enabled)
+			err = watchdog_enable(hotcpu);
 		break;
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_UP_CANCELED:
@@ -555,9 +550,6 @@ void __init lockup_detector_init(void)
 	void *cpu = (void *)(long)smp_processor_id();
 	int err;
 
-	if (no_watchdog)
-		return;
-
 	err = cpu_callback(&cpu_nfb, CPU_UP_PREPARE, cpu);
 	WARN_ON(notifier_to_errno(err));
 
-- 
1.7.3.4

