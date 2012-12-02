Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900Ab2LBClz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 21:41:55 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56589 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751628Ab2LBClx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 21:41:53 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] mfd: arizona: Defer patch initialistation until after first device boot
Date: Sun,  2 Dec 2012 11:41:46 +0900
Message-Id: <1354416107-17481-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure that we don't race with the initial device boot by only doing
the initialisation after we've waited for the boot to complete.

The runtime PM code already waits for the boot to complete before it
syncs the register patches so in most systems if a race does occur we will
power down very soon afterwards and recover anyway.

Reported-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index c784f46..bc8a3ed 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -292,6 +292,7 @@ int arizona_dev_init(struct arizona *arizona)
 	struct device *dev = arizona->dev;
 	const char *type_name;
 	unsigned int reg, val;
+	int (*apply_patch)(struct arizona *) = NULL;
 	int ret, i;
 
 	dev_set_drvdata(arizona->dev, arizona);
@@ -391,7 +392,7 @@ int arizona_dev_init(struct arizona *arizona)
 				arizona->type);
 			arizona->type = WM5102;
 		}
-		ret = wm5102_patch(arizona);
+		apply_patch = wm5102_patch;
 		break;
 #endif
 #ifdef CONFIG_MFD_WM5110
@@ -402,7 +403,7 @@ int arizona_dev_init(struct arizona *arizona)
 				arizona->type);
 			arizona->type = WM5110;
 		}
-		ret = wm5110_patch(arizona);
+		apply_patch = wm5110_patch;
 		break;
 #endif
 	default:
@@ -412,9 +413,6 @@ int arizona_dev_init(struct arizona *arizona)
 
 	dev_info(dev, "%s revision %c\n", type_name, arizona->rev + 'A');
 
-	if (ret != 0)
-		dev_err(arizona->dev, "Failed to apply patch: %d\n", ret);
-
 	/* If we have a /RESET GPIO we'll already be reset */
 	if (!arizona->pdata.reset) {
 		regcache_mark_dirty(arizona->regmap);
@@ -438,6 +436,15 @@ int arizona_dev_init(struct arizona *arizona)
 		goto err_reset;
 	}
 
+	if (apply_patch) {
+		ret = apply_patch(arizona);
+		if (ret != 0) {
+			dev_err(arizona->dev, "Failed to apply patch: %d\n",
+				ret);
+			goto err_reset;
+		}
+	}
+
 	for (i = 0; i < ARRAY_SIZE(arizona->pdata.gpio_defaults); i++) {
 		if (!arizona->pdata.gpio_defaults[i])
 			continue;
-- 
1.7.10.4

