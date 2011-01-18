Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab1ARWjn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 17:39:43 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52232 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab1ARWjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 17:39:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=rGqTOypXEQXWvsqVgA2hk05IjgXUXZzOnKvopR8WmB3EMXCqixJRe+jLHNcU98aZux
         vBRmzbdjL4cmfZFYE34rCBYxyFeOprvQ5/SUAnC8FrrUmYy2FOoctijiKokeBxo15eOI
         VOfd3eWbzchbJHJPaihI47GtK3vzaZh18aSxE=
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Don Zickus <dzickus@redhat.com>, Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        stable@kernel.org
Subject: [PATCH 1/3] watchdog: fix broken nowatchdog logic
Date: Tue, 18 Jan 2011 23:37:44 +0100
Message-Id: <1295390266-9347-1-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.7.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 kernel/watchdog.c |   18 +++++-------------
 1 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 0a507b1..ba52aa3 100644
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
@@ -75,7 +72,7 @@ __setup("softlockup_panic=", softlockup_panic_setup);
 
 static int __init nowatchdog_setup(char *str)
 {
-	no_watchdog = 1;
+	watchdog_enabled = 0;
 	return 1;
 }
 __setup("nowatchdog", nowatchdog_setup);
@@ -83,7 +80,7 @@ __setup("nowatchdog", nowatchdog_setup);
 /* deprecated */
 static int __init nosoftlockup_setup(char *str)
 {
-	no_watchdog = 1;
+	watchdog_enabled = 0;
 	return 1;
 }
 __setup("nosoftlockup", nosoftlockup_setup);
@@ -469,9 +466,6 @@ static void watchdog_disable_all_cpus(void)
 {
 	int cpu;
 
-	if (no_watchdog)
-		return;
-
 	for_each_online_cpu(cpu)
 		watchdog_disable(cpu);
 
@@ -523,7 +517,8 @@ cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		break;
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
-		err = watchdog_enable(hotcpu);
+		if (watchdog_enabled)
+			err = watchdog_enable(hotcpu);
 		break;
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_UP_CANCELED:
@@ -548,9 +543,6 @@ static int __init spawn_watchdog_task(void)
 	void *cpu = (void *)(long)smp_processor_id();
 	int err;
 
-	if (no_watchdog)
-		return 0;
-
 	err = cpu_callback(&cpu_nfb, CPU_UP_PREPARE, cpu);
 	WARN_ON(notifier_to_errno(err));
 
-- 
1.7.3.3

