Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758665Ab2GFWqI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 18:46:08 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:37448 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932495Ab2GFWpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 18:45:10 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: ewust@umich.edu, zakir@umich.edu, nadiah@cs.ucsd.edu, jhalderm@umich.edu,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Theodore Ts'o" <tytso@mit.edu>, stable@vger.kernel.org
Subject: [PATCH 11/12] rtc: wm831x: Feed the write counter into device_add_randomness()
Date: Fri,  6 Jul 2012 18:45:03 -0400
Message-Id: <1341614704-24965-12-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.7.11.1.108.gb129051
In-Reply-To: <1341614704-24965-1-git-send-email-tytso@mit.edu>
References: <1341614704-24965-1-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

The tamper evident features of the RTC include the "write counter" which
is a pseudo-random number regenerated whenever we set the RTC. Since this
value is unpredictable it should provide some useful seeding to the random
number generator.

Only do this on boot since the goal is to seed the pool rather than add
useful entropy.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@vger.kernel.org
---
 drivers/rtc/rtc-wm831x.c | 24 +++++++++++++++++++++++-
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
1.7.11.1.108.gb129051

