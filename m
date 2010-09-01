Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab0IADAq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 23:00:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22240 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754550Ab0IADA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 23:00:29 -0400
From: Don Zickus <dzickus@redhat.com>
To: mingo@elte.hu
Cc: peterz@infradead.org, gorcunov@gmail.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 1/3] [lockup detector] sync touch_*_watchdog back to old semantics
Date: Tue, 31 Aug 2010 23:00:07 -0400
Message-Id: <1283310009-22168-2-git-send-email-dzickus@redhat.com>
In-Reply-To: <1283310009-22168-1-git-send-email-dzickus@redhat.com>
References: <1283310009-22168-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During my rewrite, the semantics of touch_nmi_watchdog and
touch_softlockup_watchdog changed enough to break some drivers
(mostly over preemptable regions).

This change brings those touch_*_watchdog functions back in line
to how they used to work.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 kernel/watchdog.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 0d53c8e..7f9c3c5 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -122,7 +122,7 @@ static void __touch_watchdog(void)
 
 void touch_softlockup_watchdog(void)
 {
-	__get_cpu_var(watchdog_touch_ts) = 0;
+	__raw_get_cpu_var(watchdog_touch_ts) = 0;
 }
 EXPORT_SYMBOL(touch_softlockup_watchdog);
 
@@ -142,7 +142,14 @@ void touch_all_softlockup_watchdogs(void)
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
 void touch_nmi_watchdog(void)
 {
-	__get_cpu_var(watchdog_nmi_touch) = true;
+	if (watchdog_enabled) {
+		unsigned cpu;
+
+		for_each_present_cpu(cpu) {
+			if (per_cpu(watchdog_nmi_touch, cpu) != true)
+				per_cpu(watchdog_nmi_touch, cpu) = true;
+		}
+	}
 	touch_softlockup_watchdog();
 }
 EXPORT_SYMBOL(touch_nmi_watchdog);
@@ -433,6 +440,9 @@ static int watchdog_enable(int cpu)
 		wake_up_process(p);
 	}
 
+	/* if any cpu succeeds, watchdog is considered enabled for the system */
+	watchdog_enabled = 1;
+
 	return 0;
 }
 
@@ -455,9 +465,6 @@ static void watchdog_disable(int cpu)
 		per_cpu(softlockup_watchdog, cpu) = NULL;
 		kthread_stop(p);
 	}
-
-	/* if any cpu succeeds, watchdog is considered enabled for the system */
-	watchdog_enabled = 1;
 }
 
 static void watchdog_enable_all_cpus(void)
-- 
1.7.2.2

