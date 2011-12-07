Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934034Ab1LGQ0L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:26:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34785 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757186Ab1LGQ0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:26:04 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:12:22 2011
Message-Id: <20111207161222.762773568@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:12:39 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [097/104] rtc: Fix some bugs that allowed accumulating time drift in suspend/resume
In-Reply-To: <20111207161246.GA10995@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>

commit 6a8943d9ec2567572fca25cf69ad45844d0141a3 upstream.

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
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/rtc/class.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -66,7 +66,7 @@ static int rtc_suspend(struct device *de
 	 */
 	delta = timespec_sub(old_system, old_rtc);
 	delta_delta = timespec_sub(delta, old_delta);
-	if (abs(delta_delta.tv_sec)  >= 2) {
+	if (delta_delta.tv_sec < -2 || delta_delta.tv_sec >= 2) {
 		/*
 		 * if delta_delta is too large, assume time correction
 		 * has occured and set old_delta to the current delta.
@@ -100,9 +100,8 @@ static int rtc_resume(struct device *dev
 	rtc_tm_to_time(&tm, &new_rtc.tv_sec);
 	new_rtc.tv_nsec = 0;
 
-	if (new_rtc.tv_sec <= old_rtc.tv_sec) {
-		if (new_rtc.tv_sec < old_rtc.tv_sec)
-			pr_debug("%s:  time travel!\n", dev_name(&rtc->dev));
+	if (new_rtc.tv_sec < old_rtc.tv_sec) {
+		pr_debug("%s:  time travel!\n", dev_name(&rtc->dev));
 		return 0;
 	}
 
@@ -119,7 +118,8 @@ static int rtc_resume(struct device *dev
 	sleep_time = timespec_sub(sleep_time,
 			timespec_sub(new_system, old_system));
 
-	timekeeping_inject_sleeptime(&sleep_time);
+	if (sleep_time.tv_sec >= 0)
+		timekeeping_inject_sleeptime(&sleep_time);
 	return 0;
 }
 


