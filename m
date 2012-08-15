Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122Ab2HOT4B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:56:01 -0400
Received: from mail1.windriver.com ([147.11.146.13]:63184 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932246Ab2HOTxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:53:03 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 163/165] rtc: wm831x: Feed the write counter into device_add_randomness()
Date: Wed, 15 Aug 2012 15:48:27 -0400
Message-ID: <1345060109-9187-164-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 9dccf55f4cb011a7552a8a2749a580662f5ed8ed upstream.

The tamper evident features of the RTC include the "write counter" which
is a pseudo-random number regenerated whenever we set the RTC. Since this
value is unpredictable it should provide some useful seeding to the random
number generator.

Only do this on boot since the goal is to seed the pool rather than add
useful entropy.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/rtc/rtc-wm831x.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-wm831x.c b/drivers/rtc/rtc-wm831x.c
index b16cfe5..dce35ed 100644
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
@@ -465,6 +485,8 @@ static int wm831x_rtc_probe(struct platform_device *pdev)
 			alm_irq, ret);
 	}
 
+	wm831x_rtc_add_randomness(wm831x);
+
 	return 0;
 
 err:
-- 
1.7.12.rc2

