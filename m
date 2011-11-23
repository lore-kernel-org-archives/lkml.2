Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745Ab1KWCZQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 21:25:16 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64897 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297Ab1KWCZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 21:25:15 -0500
From: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Subject: [PATCH] rtc: Fix some bugs that allowed accumulating time drift in suspend/resume
Date: Tue, 22 Nov 2011 18:24:51 -0800
Message-Id: <1322015091-23560-1-git-send-email-arve@android.com>
X-Mailer: git-send-email 1.7.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current code checks if abs(delta_delta.tv_sec) is greater or
equal to two before it discards the old delta value, but this can
trigger at close to -1 seconds since -1.000000001 seconds is stored
as tv_sec -2 and tv_nsec 999999999 in a normalized timespec.

rtc_resume had an early return check if the rtc value had not changed
since rtc_suspend. This effectivly stops time for the duration of the
short sleep. Check if sleep_time is positive after all the adjustments
have been applied instead since this allows the old_system adjustment
in rtc_suspend to have an effect even for short sleep cycles.

Signed-off-by: Arve Hjønnevåg <arve@android.com>
---
 drivers/rtc/class.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index 01a7df5..b82a155 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -66,7 +66,7 @@ static int rtc_suspend(struct device *dev, pm_message_t mesg)
 	 */
 	delta = timespec_sub(old_system, old_rtc);
 	delta_delta = timespec_sub(delta, old_delta);
-	if (abs(delta_delta.tv_sec)  >= 2) {
+	if (delta_delta.tv_sec < -2 || delta_delta.tv_sec >= 2) {
 		/*
 		 * if delta_delta is too large, assume time correction
 		 * has occured and set old_delta to the current delta.
@@ -100,9 +100,8 @@ static int rtc_resume(struct device *dev)
 	rtc_tm_to_time(&tm, &new_rtc.tv_sec);
 	new_rtc.tv_nsec = 0;
 
-	if (new_rtc.tv_sec <= old_rtc.tv_sec) {
-		if (new_rtc.tv_sec < old_rtc.tv_sec)
-			pr_debug("%s:  time travel!\n", dev_name(&rtc->dev));
+	if (new_rtc.tv_sec < old_rtc.tv_sec) {
+		pr_debug("%s:  time travel!\n", dev_name(&rtc->dev));
 		return 0;
 	}
 
@@ -119,7 +118,8 @@ static int rtc_resume(struct device *dev)
 	sleep_time = timespec_sub(sleep_time,
 			timespec_sub(new_system, old_system));
 
-	timekeeping_inject_sleeptime(&sleep_time);
+	if (sleep_time.tv_sec >= 0)
+		timekeeping_inject_sleeptime(&sleep_time);
 	return 0;
 }
 
-- 
1.7.3.1

