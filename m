Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932681Ab0GOIEj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 04:04:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:23112 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932651Ab0GOIEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 04:04:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,206,1278313200"; 
   d="scan'208";a="586311668"
From: feng.tang@intel.com
To: linux-kernel@vger.kernel.org
Cc: Feng Tang <feng.tang@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>
Subject: [PATCH v2 1/3] timekeeping: moving xtime's init to a later time
Date: Thu, 15 Jul 2010 16:23:29 +0800
Message-Id: <1279182211-25264-2-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1279182211-25264-1-git-send-email-feng.tang@intel.com>
References: <1279182211-25264-1-git-send-email-feng.tang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Feng Tang <feng.tang@intel.com>

xtime doesn't need to be inited early, move it to a subsys_initcall,
as most of its consumers come from userspace. It will also give enough
time for some MMIO based wallclock devices to init

Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <johnstul@us.ibm.com>
---
 kernel/time/timekeeping.c |   28 +++++++++++++++++++++-------
 1 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index caf8d4d..0803a76 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -520,26 +520,37 @@ void __attribute__((weak)) read_boot_clock(struct timespec *ts)
 }
 
 /*
- * timekeeping_init - Initializes the clocksource and common timekeeping values
+ * timekeeping_init - Initializes the clocksource
  */
 void __init timekeeping_init(void)
 {
 	struct clocksource *clock;
 	unsigned long flags;
-	struct timespec now, boot;
-
-	read_persistent_clock(&now);
-	read_boot_clock(&boot);
 
 	write_seqlock_irqsave(&xtime_lock, flags);
 
-	ntp_init();
-
 	clock = clocksource_default_clock();
 	if (clock->enable)
 		clock->enable(clock);
 	timekeeper_setup_internals(clock);
 
+	ntp_init();
+	write_sequnlock_irqrestore(&xtime_lock, flags);
+}
+
+/*
+ *  timekeeping_late_init - Initaizes the common timekeeping values
+ */
+static int __init timekeeping_late_init(void)
+{
+	unsigned long flags;
+	struct timespec now, boot;
+
+	read_persistent_clock(&now);
+	read_boot_clock(&boot);
+
+	write_seqlock_irqsave(&xtime_lock, flags);
+
 	xtime.tv_sec = now.tv_sec;
 	xtime.tv_nsec = now.tv_nsec;
 	raw_time.tv_sec = 0;
@@ -553,7 +564,10 @@ void __init timekeeping_init(void)
 	total_sleep_time.tv_sec = 0;
 	total_sleep_time.tv_nsec = 0;
 	write_sequnlock_irqrestore(&xtime_lock, flags);
+
+	return 0;
 }
+subsys_initcall(timekeeping_late_init);
 
 /* time in seconds when suspend began */
 static struct timespec timekeeping_suspend_time;
-- 
1.7.0.4

