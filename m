Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433Ab2GEUUK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 16:20:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38371 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755551Ab2GEUUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 16:20:07 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Alessandro Zummo <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        rtc-linux@googlegroups.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] rtc: wm831x: Feed the write counter into device_add_randomness()
Date: Thu,  5 Jul 2012 21:19:17 +0100
Message-Id: <1341519557-5115-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tamper evident features of the RTC include the "write counter" which
is a pseudo-random number regenerated whenever we set the RTC. Since this
value is unpredictable it should provide some useful seeding to the random
number generator.

Only do this on boot since the goal is to seed the pool rather than add
useful entropy.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

add_device_randomness() has only just been added in -next, this will
need to either wait until after the merge window or be merged along with
the patch adding it.

 drivers/rtc/rtc-wm831x.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-wm831x.c b/drivers/rtc/rtc-wm831x.c
index 59c6245..ea5c6f8 100644
--- a/drivers/rtc/rtc-wm831x.c
+++ b/drivers/rtc/rtc-wm831x.c
@@ -24,7 +24,7 @@
 #include <linux/mfd/wm831x/core.h>
 #include <linux/delay.h>
 #include <linux/platform_device.h>
-
+#include <linux/random.h>
 
 /*
  * R16416 (0x4020) - RTC Write Counter
@@ -96,6 +96,26 @@ struct wm831x_rtc {
 	unsigned int alarm_enabled:1;
 };
 
+static void wm831x_rtc_add_randomness(struct wm831x *wm831x)
+{
+	int ret;
+	u16 reg;
+
+	/*
+	 * The write counter contains a pseudo-random number which is
+	 * regenerated every time we set the RTC so it should be a
+	 * useful per-system source of entropy.
+	 */
+	ret = wm831x_reg_read(wm831x, WM831X_RTC_WRITE_COUNTER);
+	if (ret >= 0) {
+		reg = ret;
+		add_device_randomness(&reg, sizeof(reg));
+	} else {
+		dev_warn(wm831x->dev, "Failed to read RTC write counter: %d\n",
+			 ret);
+	}
+}
+
 /*
  * Read current time and date in RTC
  */
@@ -431,6 +451,8 @@ static int wm831x_rtc_probe(struct platform_device *pdev)
 			alm_irq, ret);
 	}
 
+	wm831x_rtc_add_randomness(wm831x);
+
 	return 0;
 
 err:
-- 
1.7.10

