Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751741Ab0HUJuN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 05:50:13 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62268 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab0HUJuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 05:50:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=qiOM0mjTSeFLy15yUd7rkuiwmYAPT9fQzUpeT7KddWea8B+n2lP1JMqV1dZmd93tLG
         NB5lPXj0dZEYFE6qEviAwvf8OPPr0emZSidJqofTEHD+kg6ptACl3ZuYnEcBkZ7G2J2f
         1BUu+XDnQYocBu7p7DWkROkZERFDwusG9Ah9w=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 1/2] lockup_detector: convert cpu notifier to return encapsulate errno value
Date: Sat, 21 Aug 2010 18:43:46 +0900
Message-Id: <1282383827-12064-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By the commit e6bde73b07edeb703d4c89c1daabc09c303de11f
("cpu-hotplug: return better errno on cpu hotplug failure"),
the cpu notifier can return encapsulate errno value.

This converts the cpu notifier to return encapsulate errno value
for lockup_detector.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 kernel/watchdog.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 613bc1f..de98f77 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -368,7 +368,7 @@ static int watchdog_nmi_enable(int cpu)
 	}
 
 	printk(KERN_ERR "NMI watchdog failed to create perf event on cpu%i: %p\n", cpu, event);
-	return -1;
+	return PTR_ERR(event);
 
 	/* success path */
 out_save:
@@ -412,17 +412,19 @@ static int watchdog_prepare_cpu(int cpu)
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
@@ -516,17 +518,16 @@ static int __cpuinit
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
@@ -539,7 +540,7 @@ cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		break;
 #endif /* CONFIG_HOTPLUG_CPU */
 	}
-	return NOTIFY_OK;
+	return notifier_from_errno(err);
 }
 
 static struct notifier_block __cpuinitdata cpu_nfb = {
@@ -555,7 +556,7 @@ static int __init spawn_watchdog_task(void)
 		return 0;
 
 	err = cpu_callback(&cpu_nfb, CPU_UP_PREPARE, cpu);
-	WARN_ON(err == NOTIFY_BAD);
+	WARN_ON(notifier_to_errno(err));
 
 	cpu_callback(&cpu_nfb, CPU_ONLINE, cpu);
 	register_cpu_notifier(&cpu_nfb);
-- 
1.6.0.6

