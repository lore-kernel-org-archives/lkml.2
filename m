Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964931Ab2HGDje (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 23:39:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59930 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964866Ab2HGDjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 23:39:03 -0400
Message-Id: <20120807032759.091883912@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 07 Aug 2012 04:28:16 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [ 21/70] rtc: wm831x: Feed the write counter into device_add_randomness()
In-Reply-To: <20120807032755.803571133@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 9dccf55f4cb011a7552a8a2749a580662f5ed8ed upstream.

The tamper evident features of the RTC include the "write counter" which
is a pseudo-random number regenerated whenever we set the RTC. Since this
value is unpredictable it should provide some useful seeding to the random
number generator.

Only do this on boot since the goal is to seed the pool rather than add
useful entropy.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
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


