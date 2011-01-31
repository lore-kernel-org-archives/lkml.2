Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799Ab1AaMwF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 07:52:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:33282 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755783Ab1AaMwC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 07:52:02 -0500
Date: Mon, 31 Jan 2011 12:51:30 GMT
From: tip-bot for Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, marcin.slusarz@gmail.com,
        fweisbec@gmail.com, stable@kernel.org, tglx@linutronix.de,
        mingo@elte.hu, dzickus@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        marcin.slusarz@gmail.com, fweisbec@gmail.com, stable@kernel.org,
        tglx@linutronix.de, dzickus@redhat.com, mingo@elte.hu
In-Reply-To: <1296230433-6261-1-git-send-email-dzickus@redhat.com>
References: <1296230433-6261-1-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] watchdog: Fix broken nowatchdog logic
Message-ID: <tip-4135038a582c20ffdadfcf6564852e0b72a20968@git.kernel.org>
Git-Commit-ID: 4135038a582c20ffdadfcf6564852e0b72a20968
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 31 Jan 2011 12:51:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4135038a582c20ffdadfcf6564852e0b72a20968
Gitweb:     http://git.kernel.org/tip/4135038a582c20ffdadfcf6564852e0b72a20968
Author:     Marcin Slusarz <marcin.slusarz@gmail.com>
AuthorDate: Fri, 28 Jan 2011 11:00:31 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 31 Jan 2011 13:22:42 +0100

watchdog: Fix broken nowatchdog logic

Passing nowatchdog to kernel disables 2 things: creation of
watchdog threads AND initialization of percpu watchdog_hrtimer.
As hrtimers are initialized only at boot it's not possible to
enable watchdog later - for me all watchdog threads started to
eat 100% of CPU time, but they could just crash.

Additionally, even if these threads would start properly,
watchdog_disable_all_cpus was guarded by no_watchdog check, so
you couldn't disable watchdog.

To fix this, remove no_watchdog variable and use already
existing watchdog_enabled variable.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
[ removed another no_watchdog instance ]
Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: <stable@kernel.org>
LKML-Reference: <1296230433-6261-1-git-send-email-dzickus@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/watchdog.c |   20 ++++++--------------
 1 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index d7ebdf4..d9961ea 100644
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
 
