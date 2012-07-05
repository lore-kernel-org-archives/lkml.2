Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278Ab2GEUXZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 16:23:25 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45763 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754030Ab2GEUXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 16:23:24 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: wm831x: Feed the device UUID into device_add_randomness()
Date: Thu,  5 Jul 2012 21:23:21 +0100
Message-Id: <1341519801-5904-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wm831x devices contain a unique ID value. Feed this into the newly added
device_add_randomness() to add some per device seed data to the pool.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

add_device_randomness() has only just been added in -next, this will
need to either wait until after the merge window or be merged along with
the patch adding it.

 drivers/mfd/wm831x-otp.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/mfd/wm831x-otp.c b/drivers/mfd/wm831x-otp.c
index f742745..b90f3e0 100644
--- a/drivers/mfd/wm831x-otp.c
+++ b/drivers/mfd/wm831x-otp.c
@@ -18,6 +18,7 @@
 #include <linux/bcd.h>
 #include <linux/delay.h>
 #include <linux/mfd/core.h>
+#include <linux/random.h>
 
 #include <linux/mfd/wm831x/core.h>
 #include <linux/mfd/wm831x/otp.h>
@@ -66,6 +67,7 @@ static DEVICE_ATTR(unique_id, 0444, wm831x_unique_id_show, NULL);
 
 int wm831x_otp_init(struct wm831x *wm831x)
 {
+	char uuid[WM831X_UNIQUE_ID_LEN];
 	int ret;
 
 	ret = device_create_file(wm831x->dev, &dev_attr_unique_id);
@@ -73,6 +75,12 @@ int wm831x_otp_init(struct wm831x *wm831x)
 		dev_err(wm831x->dev, "Unique ID attribute not created: %d\n",
 			ret);
 
+	ret = wm831x_unique_id_read(wm831x, uuid);
+	if (ret == 0)
+		add_device_randomness(uuid, sizeof(uuid));
+	else
+		dev_err(wm831x->dev, "Failed to read UUID: %d\n", ret);
+
 	return ret;
 }
 
-- 
1.7.10

