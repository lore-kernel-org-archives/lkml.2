Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab2L0Ctw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 21:49:52 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:58858 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab2L0Cts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 21:49:48 -0500
X-AuditID: 9c93016f-b7b54ae000000e9e-e2-50dbb74a74d0
From: Namhyung Kim <namhyung@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>, Don Zickus <dzickus@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/2] watchdog: Use local_clock for get_timestamp()
Date: Thu, 27 Dec 2012 11:49:44 +0900
Message-Id: <1356576585-28782-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The get_timestamp() function is always called with current cpu, thus
using local_clock() would be more appropriate and it makes the code
shorter and cleaner IMHO.

Cc: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/watchdog.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 75a2ab3d0b02..082ca6878a3f 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -112,9 +112,9 @@ static int get_softlockup_thresh(void)
  * resolution, and we don't need to waste time with a big divide when
  * 2^30ns == 1.074s.
  */
-static unsigned long get_timestamp(int this_cpu)
+static unsigned long get_timestamp(void)
 {
-	return cpu_clock(this_cpu) >> 30LL;  /* 2^30 ~= 10^9 */
+	return local_clock() >> 30LL;  /* 2^30 ~= 10^9 */
 }
 
 static void set_sample_period(void)
@@ -132,9 +132,7 @@ static void set_sample_period(void)
 /* Commands for resetting the watchdog */
 static void __touch_watchdog(void)
 {
-	int this_cpu = smp_processor_id();
-
-	__this_cpu_write(watchdog_touch_ts, get_timestamp(this_cpu));
+	__this_cpu_write(watchdog_touch_ts, get_timestamp());
 }
 
 void touch_softlockup_watchdog(void)
@@ -195,7 +193,7 @@ static int is_hardlockup(void)
 
 static int is_softlockup(unsigned long touch_ts)
 {
-	unsigned long now = get_timestamp(smp_processor_id());
+	unsigned long now = get_timestamp();
 
 	/* Warn about unreasonable delays: */
 	if (time_after(now, touch_ts + get_softlockup_thresh()))
-- 
1.7.11.7

