Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996Ab1I0SuL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 14:50:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57314 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752175Ab1I0SuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 14:50:10 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lrg@ti.com>
Cc: alsa-devel@alsa-project.org, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/3] mfd: Add WM1811 support
Date: Tue, 27 Sep 2011 19:50:05 +0100
Message-Id: <1317149407-27635-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WM1811 is mostly register compatible with the WM8994 and WM8958,
providing a high performance audio hub CODEC in a small form factor
suitable for ultra compact system designs.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

Due to the ASoC cross dependencies it seems like it'll be easier to
merge this via ASoC - Samuel, does this make sense to you?

 drivers/mfd/wm8994-core.c       |   28 ++++++++++++++++++++++++++++
 include/linux/mfd/wm8994/core.h |    1 +
 2 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index 719fee8..61894fc 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -167,6 +167,18 @@ static struct mfd_cell wm8994_devs[] = {
  * and should be handled via the standard regulator API supply
  * management.
  */
+static const char *wm1811_main_supplies[] = {
+	"DBVDD1",
+	"DBVDD2",
+	"DBVDD3",
+	"DCVDD",
+	"AVDD1",
+	"AVDD2",
+	"CPVDD",
+	"SPKVDD1",
+	"SPKVDD2",
+};
+
 static const char *wm8994_main_supplies[] = {
 	"DBVDD",
 	"DCVDD",
@@ -227,6 +239,7 @@ static int wm8994_suspend(struct device *dev)
 
 	switch (wm8994->type) {
 	case WM8958:
+	case WM1811:
 		ret = wm8994_reg_read(wm8994, WM8958_MIC_DETECT_1);
 		if (ret < 0) {
 			dev_err(dev, "Failed to read power status: %d\n", ret);
@@ -375,6 +388,9 @@ static int wm8994_device_init(struct wm8994 *wm8994, int irq)
 	}
 
 	switch (wm8994->type) {
+	case WM1811:
+		wm8994->num_supplies = ARRAY_SIZE(wm1811_main_supplies);
+		break;
 	case WM8994:
 		wm8994->num_supplies = ARRAY_SIZE(wm8994_main_supplies);
 		break;
@@ -395,6 +411,10 @@ static int wm8994_device_init(struct wm8994 *wm8994, int irq)
 	}
 
 	switch (wm8994->type) {
+	case WM1811:
+		for (i = 0; i < ARRAY_SIZE(wm1811_main_supplies); i++)
+			wm8994->supplies[i].supply = wm1811_main_supplies[i];
+		break;
 	case WM8994:
 		for (i = 0; i < ARRAY_SIZE(wm8994_main_supplies); i++)
 			wm8994->supplies[i].supply = wm8994_main_supplies[i];
@@ -428,6 +448,13 @@ static int wm8994_device_init(struct wm8994 *wm8994, int irq)
 		goto err_enable;
 	}
 	switch (ret) {
+	case 0x1811:
+		devname = "WM1811";
+		if (wm8994->type != WM1811)
+			dev_warn(wm8994->dev, "Device registered as type %d\n",
+				 wm8994->type);
+		wm8994->type = WM1811;
+		break;
 	case 0x8994:
 		devname = "WM8994";
 		if (wm8994->type != WM8994)
@@ -592,6 +619,7 @@ static int wm8994_i2c_remove(struct i2c_client *i2c)
 }
 
 static const struct i2c_device_id wm8994_i2c_id[] = {
+	{ "wm1811", WM1811 },
 	{ "wm8994", WM8994 },
 	{ "wm8958", WM8958 },
 	{ }
diff --git a/include/linux/mfd/wm8994/core.h b/include/linux/mfd/wm8994/core.h
index a275798..f44bdb7 100644
--- a/include/linux/mfd/wm8994/core.h
+++ b/include/linux/mfd/wm8994/core.h
@@ -20,6 +20,7 @@
 enum wm8994_type {
 	WM8994 = 0,
 	WM8958 = 1,
+	WM1811 = 2,
 };
 
 struct regulator_dev;
-- 
1.7.6.3

