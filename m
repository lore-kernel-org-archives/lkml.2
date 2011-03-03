Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787Ab1CCUeM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 15:34:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20447 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758739Ab1CCUeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 15:34:09 -0500
From: Don Zickus <dzickus@redhat.com>
To: <x86@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 2/2] watchdog:  Always return NOTIFY_OK during cpu up/down events
Date: Thu,  3 Mar 2011 15:33:59 -0500
Message-Id: <1299184439-9215-2-git-send-email-dzickus@redhat.com>
In-Reply-To: <1299184439-9215-1-git-send-email-dzickus@redhat.com>
References: <1299184439-9215-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch addresses a couple of problems.  One was the case when the
hardlockup failed to start, it also failed to start the softlockup.
There were valid cases when the hardlockup shouldn't start and that
shouldn't block the softlockup (no lapic, bios controls perf counters).

The second problem was when the hardlockup failed to start on boxes
(from a no lapic or bios controlled perf counter case), it reported
failure to the cpu notifier chain.  This blocked the notifier from
continuing to start other more critical pieces of cpu bring-up (in
our case based on a 2.6.32 fork, it was the mce).  As a result,
during soft cpu online/offline testing, the system would panic
when a cpu was offlined because the cpu notifier would succeed in
processing a watchdog disable cpu event and would panic in the mce
case as a result of un-initialized variables from a never executed
cpu up event.

I realized the hardlockup/softlockup cases are really just debugging
aids and should never impede the progress of a cpu up/down event.
Therefore I modified the code to always return NOTIFY_OK and instead
rely on printks to inform the user of problems.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
  Forgot to cc lkml, sorry for the spam

---
 kernel/watchdog.c |   22 ++++++++++++++++------
 1 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index f7c0272..c52645b 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -418,19 +418,22 @@ static int watchdog_prepare_cpu(int cpu)
 static int watchdog_enable(int cpu)
 {
 	struct task_struct *p = per_cpu(softlockup_watchdog, cpu);
-	int err;
+	int err = 0;
 
 	/* enable the perf event */
 	err = watchdog_nmi_enable(cpu);
-	if (err)
-		return err;
+
+	/* Regardless of err above, fall through and start softlockup */
 
 	/* create the watchdog thread */
 	if (!p) {
 		p = kthread_create(watchdog, (void *)(unsigned long)cpu, "watchdog/%d", cpu);
 		if (IS_ERR(p)) {
 			printk(KERN_ERR "softlockup watchdog for %i failed\n", cpu);
-			return PTR_ERR(p);
+			if (!err)
+				/* if hardlockup hasn't already set this */
+				err = PTR_ERR(p);
+			goto out;
 		}
 		kthread_bind(p, cpu);
 		per_cpu(watchdog_touch_ts, cpu) = 0;
@@ -438,7 +441,8 @@ static int watchdog_enable(int cpu)
 		wake_up_process(p);
 	}
 
-	return 0;
+out:
+	return err;
 }
 
 static void watchdog_disable(int cpu)
@@ -550,7 +554,13 @@ cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		break;
 #endif /* CONFIG_HOTPLUG_CPU */
 	}
-	return notifier_from_errno(err);
+
+	/*
+	 * hardlockup and softlockup are not important enough
+	 * to block cpu bring up.  Just always succeed and
+	 * rely on printk output to flag problems.
+	 */
+	return NOTIFY_OK;
 }
 
 static struct notifier_block __cpuinitdata cpu_nfb = {
-- 
1.7.3.5

