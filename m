Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab0IAJTi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 05:19:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:42706 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754427Ab0IAJTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 05:19:35 -0400
Date: Wed, 1 Sep 2010 09:19:10 GMT
From: tip-bot for Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        gorcunov@openvz.org, tglx@linutronix.de, mingo@elte.hu,
        dzickus@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        gorcunov@openvz.org, tglx@linutronix.de, dzickus@redhat.com,
        mingo@elte.hu
In-Reply-To: <1283310009-22168-2-git-send-email-dzickus@redhat.com>
References: <1283310009-22168-2-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] lockup_detector: Sync touch_*_watchdog back to old semantics
Message-ID: <tip-68d3f1d810500e8b975bdf0b20dd83d060076b4b@git.kernel.org>
Git-Commit-ID: 68d3f1d810500e8b975bdf0b20dd83d060076b4b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 01 Sep 2010 09:19:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  68d3f1d810500e8b975bdf0b20dd83d060076b4b
Gitweb:     http://git.kernel.org/tip/68d3f1d810500e8b975bdf0b20dd83d060076b4b
Author:     Don Zickus <dzickus@redhat.com>
AuthorDate: Tue, 31 Aug 2010 23:00:07 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 1 Sep 2010 10:02:28 +0200

lockup_detector: Sync touch_*_watchdog back to old semantics

During my rewrite, the semantics of touch_nmi_watchdog and
touch_softlockup_watchdog changed enough to break some drivers
(mostly over preemptable regions).

These are cases where long delays on one CPU (due to
print_delay for example) can cause long delays on other
CPUs - so we must 'touch' the nmi_watchdog flag of those
other CPUs as well.

This change brings those touch_*_watchdog() functions back in line
with to how they used to work.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: peterz@infradead.org
Cc: fweisbec@gmail.com
LKML-Reference: <1283310009-22168-2-git-send-email-dzickus@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
