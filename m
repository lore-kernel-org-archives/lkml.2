Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab2LMCFh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 21:05:37 -0500
Received: from mga11.intel.com ([192.55.52.93]:59521 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755020Ab2LMCFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 21:05:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,269,1355126400"; 
   d="scan'208";a="261429944"
From: Feng Tang <feng.tang@intel.com>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org
Cc: alek.du@intel.com, Feng Tang <feng.tang@intel.com>
Subject: [PATCH 1/3] timekeeping: Add persistent_clock_exist flag
Date: Thu, 13 Dec 2012 10:05:26 +0800
Message-Id: <1355364328-19550-1-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current kernel, there are several places which need to check
whether there is a persistent clock for the platform. Current check
is done by calling the read_persistent_clock() and validating the
return value.

Add such a flag to make code more readable and call read_persistent_clock()
only once for all the checks.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 include/linux/time.h      |    1 +
 kernel/time/timekeeping.c |   15 +++++++++++----
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/include/linux/time.h b/include/linux/time.h
index 4d358e9..19388ad 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -115,6 +115,7 @@ static inline bool timespec_valid_strict(const struct timespec *ts)
 	return true;
 }
 
+extern int persistent_clock_exist;
 extern void read_persistent_clock(struct timespec *ts);
 extern void read_boot_clock(struct timespec *ts);
 extern int update_persistent_clock(struct timespec now);
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 4c7de02..b82f218 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -28,6 +28,9 @@ static struct timekeeper timekeeper;
 /* flag for if timekeeping is suspended */
 int __read_mostly timekeeping_suspended;
 
+/* Flag for if there is a persistent clock on this platform */
+int __read_mostly persistent_clock_exist;
+
 static inline void tk_normalize_xtime(struct timekeeper *tk)
 {
 	while (tk->xtime_nsec >= ((u64)NSEC_PER_SEC << tk->shift)) {
@@ -590,12 +593,14 @@ void __init timekeeping_init(void)
 	struct timespec now, boot, tmp;
 
 	read_persistent_clock(&now);
+
 	if (!timespec_valid_strict(&now)) {
 		pr_warn("WARNING: Persistent clock returned invalid value!\n"
 			"         Check your CMOS/BIOS settings.\n");
 		now.tv_sec = 0;
 		now.tv_nsec = 0;
-	}
+	} else if (now.tv_sec || now.tv_nsec)
+		persistent_clock_exist = 1;
 
 	read_boot_clock(&boot);
 	if (!timespec_valid_strict(&boot)) {
@@ -670,9 +675,11 @@ void timekeeping_inject_sleeptime(struct timespec *delta)
 	unsigned long flags;
 	struct timespec ts;
 
-	/* Make sure we don't set the clock twice */
-	read_persistent_clock(&ts);
-	if (!(ts.tv_sec == 0 && ts.tv_nsec == 0))
+	/*
+	 * Make sure we don't set the clock twice, as timekeeping_resume()
+	 * already did it
+	 */
+	if (persistent_clock_exist)
 		return;
 
 	write_seqlock_irqsave(&tk->lock, flags);
-- 
1.7.9.5

