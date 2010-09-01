Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab0IADAY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 23:00:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60768 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912Ab0IADAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 23:00:23 -0400
From: Don Zickus <dzickus@redhat.com>
To: mingo@elte.hu
Cc: peterz@infradead.org, gorcunov@gmail.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, Akinobu Mita <akinobu.mita@gmail.com>,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 2/3] lockup_detector: convert cpu notifier to return encapsulate errno value
Date: Tue, 31 Aug 2010 23:00:08 -0400
Message-Id: <1283310009-22168-3-git-send-email-dzickus@redhat.com>
In-Reply-To: <1283310009-22168-1-git-send-email-dzickus@redhat.com>
References: <1283310009-22168-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akinobu Mita <akinobu.mita@gmail.com>

By the commit e6bde73b07edeb703d4c89c1daabc09c303de11f
("cpu-hotplug: return better errno on cpu hotplug failure"),
the cpu notifier can return encapsulate errno value.

This converts the cpu notifier to return encapsulate errno value
for lockup_detector.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 kernel/watchdog.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 7f9c3c5..db70647 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -378,7 +378,7 @@ static int watchdog_nmi_enable(int cpu)
 	}
 
 	printk(KERN_ERR "NMI watchdog failed to create perf event on cpu%i: %p\n", cpu, event);
-	return -1;
+	return PTR_ERR(event);
 
 	/* success path */
 out_save:
@@ -422,17 +422,19 @@ static int watchdog_prepare_cpu(int cpu)
 static int watchdog_enable(int cpu)
 {
 	struct task_struct *p = per_cpu(softlockup_watchdog, cpu);
+	int err;
 
 	/* enable the perf event */
-	if (watchdog_nmi_enable(cpu) != 0)
-		return -1;
+	err = watchdog_nmi_enable(cpu);
+	if (err)
+		return err;
 
 	/* create the watchdog thread */
 	if (!p) {
 		p = kthread_create(watchdog, (void *)(unsigned long)cpu, "watchdog/%d", cpu);
 		if (IS_ERR(p)) {
 			printk(KERN_ERR "softlockup watchdog for %i failed\n", cpu);
-			return -1;
+			return PTR_ERR(p);
 		}
 		kthread_bind(p, cpu);
 		per_cpu(watchdog_touch_ts, cpu) = 0;
@@ -526,17 +528,16 @@ static int __cpuinit
 cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 {
 	int hotcpu = (unsigned long)hcpu;
+	int err = 0;
 
 	switch (action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
-		if (watchdog_prepare_cpu(hotcpu))
-			return NOTIFY_BAD;
+		err = watchdog_prepare_cpu(hotcpu);
 		break;
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
-		if (watchdog_enable(hotcpu))
-			return NOTIFY_BAD;
+		err = watchdog_enable(hotcpu);
 		break;
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_UP_CANCELED:
@@ -549,7 +550,7 @@ cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		break;
 #endif /* CONFIG_HOTPLUG_CPU */
 	}
-	return NOTIFY_OK;
+	return notifier_from_errno(err);
 }
 
 static struct notifier_block __cpuinitdata cpu_nfb = {
@@ -565,7 +566,7 @@ static int __init spawn_watchdog_task(void)
 		return 0;
 
 	err = cpu_callback(&cpu_nfb, CPU_UP_PREPARE, cpu);
-	WARN_ON(err == NOTIFY_BAD);
+	WARN_ON(notifier_to_errno(err));
 
 	cpu_callback(&cpu_nfb, CPU_ONLINE, cpu);
 	register_cpu_notifier(&cpu_nfb);
-- 
1.7.2.2

