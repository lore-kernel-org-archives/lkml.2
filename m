Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059Ab0DWQOr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 12:14:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3325 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758028Ab0DWQOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 12:14:34 -0400
From: Don Zickus <dzickus@redhat.com>
To: mingo@elte.hu, fweisbec@gmail.com
Cc: peterz@infradead.org, gorcunov@gmail.com, aris@redhat.com,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com,
       dzickus@redhat.com
Subject: [PATCH 8/8] [watchdog] separate touch_nmi_watchdog code path from touch_watchdog
Date: Fri, 23 Apr 2010 12:13:36 -0400
Message-Id: <1272039216-8890-9-git-send-email-dzickus@redhat.com>
In-Reply-To: <1272039216-8890-1-git-send-email-dzickus@redhat.com>
References: <1272039216-8890-1-git-send-email-dzickus@redhat.com>
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
index 463976a..9c6a344 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -31,6 +31,7 @@ int watchdog_enabled;
 int __read_mostly softlockup_thresh = 60;
 
 static DEFINE_PER_CPU(unsigned long, watchdog_touch_ts);
+static DEFINE_PER_CPU(bool, watchdog_nmi_touch);
 static DEFINE_PER_CPU(struct task_struct *, softlockup_watchdog);
 static DEFINE_PER_CPU(struct hrtimer, watchdog_hrtimer);
 static DEFINE_PER_CPU(bool, watchdog_touch_sync);
@@ -147,6 +148,7 @@ void touch_watchdog_sync(void)
 
 void touch_nmi_watchdog(void)
 {
+	__get_cpu_var(watchdog_nmi_touch) = true;
 	touch_watchdog();
 }
 EXPORT_SYMBOL(touch_nmi_watchdog);
@@ -203,11 +205,10 @@ void watchdog_overflow_callback(struct perf_event *event, int nmi,
 		 struct pt_regs *regs)
 {
 	int this_cpu = smp_processor_id();
-	unsigned long touch_ts = per_cpu(watchdog_touch_ts, this_cpu);
 	char warn = __get_cpu_var(watchdog_warn);
 
-	if (touch_ts == 0) {
-		__touch_watchdog();
+	if (__get_cpu_var(watchdog_nmi_touch) == true) {
+		__get_cpu_var(watchdog_nmi_touch) = false;
 		return;
 	}
 
-- 
1.7.0.1

