Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621Ab0IAGZI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 02:25:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:47973 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752343Ab0IAGZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 02:25:05 -0400
Date: Wed, 1 Sep 2010 06:24:43 GMT
From: tip-bot for Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        akinobu.mita@gmail.com, tglx@linutronix.de, mingo@elte.hu,
        dzickus@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, akinobu.mita@gmail.com, dzickus@redhat.com,
        mingo@elte.hu
In-Reply-To: <1283310009-22168-3-git-send-email-dzickus@redhat.com>
References: <1283310009-22168-3-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] lockup_detector: Convert cpu notifier to return encapsulate errno value
Message-ID: <tip-eac243355a99d6b9d41bbeba4fc83e7f735485f9@git.kernel.org>
Git-Commit-ID: eac243355a99d6b9d41bbeba4fc83e7f735485f9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 01 Sep 2010 06:24:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eac243355a99d6b9d41bbeba4fc83e7f735485f9
Gitweb:     http://git.kernel.org/tip/eac243355a99d6b9d41bbeba4fc83e7f735485f9
Author:     Akinobu Mita <akinobu.mita@gmail.com>
AuthorDate: Tue, 31 Aug 2010 23:00:08 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 1 Sep 2010 07:33:34 +0200

lockup_detector: Convert cpu notifier to return encapsulate errno value

By the commit e6bde73b07edeb703d4c89c1daabc09c303de11f
("cpu-hotplug: return better errno on cpu hotplug failure"),
the cpu notifier can return encapsulate errno value, resulting
in more meaningful error codes for CPU hotplug failures.

This converts the cpu notifier to return encapsulate errno value
for the lockup_detector as well.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: peterz@infradead.org
Cc: gorcunov@gmail.com
Cc: fweisbec@gmail.com
LKML-Reference: <1283310009-22168-3-git-send-email-dzickus@redhat.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/watchdog.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 0d53c8e..501cb6e 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -371,7 +371,7 @@ static int watchdog_nmi_enable(int cpu)
 	}
 
 	printk(KERN_ERR "NMI watchdog failed to create perf event on cpu%i: %p\n", cpu, event);
-	return -1;
+	return PTR_ERR(event);
 
 	/* success path */
 out_save:
@@ -415,17 +415,19 @@ static int watchdog_prepare_cpu(int cpu)
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
@@ -519,17 +521,16 @@ static int __cpuinit
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
@@ -542,7 +543,7 @@ cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		break;
 #endif /* CONFIG_HOTPLUG_CPU */
 	}
-	return NOTIFY_OK;
+	return notifier_from_errno(err);
 }
 
 static struct notifier_block __cpuinitdata cpu_nfb = {
@@ -558,7 +559,7 @@ static int __init spawn_watchdog_task(void)
 		return 0;
 
 	err = cpu_callback(&cpu_nfb, CPU_UP_PREPARE, cpu);
-	WARN_ON(err == NOTIFY_BAD);
+	WARN_ON(notifier_to_errno(err));
 
 	cpu_callback(&cpu_nfb, CPU_ONLINE, cpu);
 	register_cpu_notifier(&cpu_nfb);
