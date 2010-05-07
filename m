Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758598Ab0EGVMr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 17:12:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758509Ab0EGVMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 17:12:38 -0400
From: Don Zickus <dzickus@redhat.com>
To: mingo@elte.hu, fweisbec@gmail.com
Cc: peterz@infradead.org, gorcunov@gmail.com, aris@redhat.com,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com,
       dzickus@redhat.com
Subject: [PATCH 8/8] [watchdog] separate touch_nmi_watchdog code path from touch_watchdog
Date: Fri,  7 May 2010 17:11:51 -0400
Message-Id: <1273266711-18706-9-git-send-email-dzickus@redhat.com>
In-Reply-To: <1273266711-18706-1-git-send-email-dzickus@redhat.com>
References: <1273266711-18706-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I combined the nmi_watchdog (hardlockup) and softlockup code, I
also combined the paths the touch_watchdog and touch_nmi_watchdog took.
This may not be the best idea as pointed out by Frederic W., that the
touch_watchdog case probably should not reset the hardlockup count.

Therefore the patch belows falls back to the previous idea of keeping
the touch_nmi_watchdog a superset of the touch_watchdog case.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 kernel/watchdog.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 80a282c..09fb804 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -31,6 +31,7 @@ int watchdog_enabled;
 int __read_mostly softlockup_thresh = 60;
 
 static DEFINE_PER_CPU(unsigned long, watchdog_touch_ts);
+static DEFINE_PER_CPU(bool, watchdog_nmi_touch);
 static DEFINE_PER_CPU(struct task_struct *, softlockup_watchdog);
 static DEFINE_PER_CPU(struct hrtimer, watchdog_hrtimer);
 static DEFINE_PER_CPU(bool, softlockup_touch_sync);
@@ -145,6 +146,7 @@ void touch_softlockup_watchdog_sync(void)
 
 void touch_nmi_watchdog(void)
 {
+	__get_cpu_var(watchdog_nmi_touch) = true;
 	touch_softlockup_watchdog();
 }
 EXPORT_SYMBOL(touch_nmi_watchdog);
@@ -201,10 +203,9 @@ void watchdog_overflow_callback(struct perf_event *event, int nmi,
 		 struct pt_regs *regs)
 {
 	int this_cpu = smp_processor_id();
-	unsigned long touch_ts = per_cpu(watchdog_touch_ts, this_cpu);
 
-	if (touch_ts == 0) {
-		__touch_watchdog();
+	if (__get_cpu_var(watchdog_nmi_touch) == true) {
+		__get_cpu_var(watchdog_nmi_touch) = false;
 		return;
 	}
 
-- 
1.7.0.1

