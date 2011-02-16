Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932452Ab1BPAYz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:24:55 -0500
Received: from kroah.org ([198.145.64.141]:49706 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932367Ab1BPAYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:24:33 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:48 2011
Message-Id: <20110216001448.004953483@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:14:46 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Don Zickus <dzickus@redhat.com>, Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: [229/272] watchdog: Fix broken nowatchdog logic
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Marcin Slusarz <marcin.slusarz@gmail.com>

commit 4135038a582c20ffdadfcf6564852e0b72a20968 upstream.

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
LKML-Reference: <1296230433-6261-1-git-send-email-dzickus@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

---
 kernel/watchdog.c |   18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -27,7 +27,7 @@
 #include <asm/irq_regs.h>
 #include <linux/perf_event.h>
 
-int watchdog_enabled;
+int watchdog_enabled = 1;
 int __read_mostly softlockup_thresh = 60;
 
 static DEFINE_PER_CPU(unsigned long, watchdog_touch_ts);
@@ -43,9 +43,6 @@ static DEFINE_PER_CPU(unsigned long, hrt
 static DEFINE_PER_CPU(struct perf_event *, watchdog_ev);
 #endif
 
-static int no_watchdog;
-
-
 /* boot commands */
 /*
  * Should we panic when a soft-lockup or hard-lockup occurs:
@@ -75,7 +72,7 @@ __setup("softlockup_panic=", softlockup_
 
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
@@ -475,9 +472,6 @@ static void watchdog_disable_all_cpus(vo
 {
 	int cpu;
 
-	if (no_watchdog)
-		return;
-
 	for_each_online_cpu(cpu)
 		watchdog_disable(cpu);
 
@@ -531,7 +525,8 @@ cpu_callback(struct notifier_block *nfb,
 		break;
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
-		err = watchdog_enable(hotcpu);
+		if (watchdog_enabled)
+			err = watchdog_enable(hotcpu);
 		break;
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_UP_CANCELED:
@@ -556,9 +551,6 @@ static int __init spawn_watchdog_task(vo
 	void *cpu = (void *)(long)smp_processor_id();
 	int err;
 
-	if (no_watchdog)
-		return 0;
-
 	err = cpu_callback(&cpu_nfb, CPU_UP_PREPARE, cpu);
 	WARN_ON(notifier_to_errno(err));
 


