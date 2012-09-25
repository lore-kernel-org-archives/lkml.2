Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758593Ab2IYQYD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 12:24:03 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:57024 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757599Ab2IYQN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 12:13:29 -0400
From: mathieu.poirier@linaro.org
To: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Cc: mathieu.poirier@linaro.org
Subject: [PATCH 15/57] power: ab8500_fg: Round capacity output
Date: Tue, 25 Sep 2012 10:12:12 -0600
Message-Id: <1348589574-25655-16-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: pender01 <peter.enderborg@stericsson.com>

Round the capacity values for better enduser experience.

Signed-off-by: pender01 <peter.enderborg@stericsson.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/power/ab8500_fg.c |   28 +++++++++++++++-------------
 1 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index 492f6bf..c4d9307 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -31,6 +31,7 @@
 #include <linux/mfd/abx500.h>
 #include <linux/time.h>
 #include <linux/completion.h>
+#include <linux/kernel.h>
 
 #define MILLI_TO_MICRO			1000
 #define FG_LSB_IN_MA			1627
@@ -1160,7 +1161,7 @@ static int ab8500_fg_capacity_level(struct ab8500_fg *di)
 {
 	int ret, percent;
 
-	percent = di->bat_cap.permille / 10;
+	percent = DIV_ROUND_CLOSEST(di->bat_cap.permille, 10);
 
 	if (percent <= di->bat->cap_levels->critical ||
 		di->flags.low_bat)
@@ -1281,6 +1282,7 @@ static void ab8500_fg_update_cap_scalers(struct ab8500_fg *di)
 static void ab8500_fg_check_capacity_limits(struct ab8500_fg *di, bool init)
 {
 	bool changed = false;
+	int percent = DIV_ROUND_CLOSEST(di->bat_cap.permille, 10);
 
 	di->bat_cap.level = ab8500_fg_capacity_level(di);
 
@@ -1312,6 +1314,7 @@ static void ab8500_fg_check_capacity_limits(struct ab8500_fg *di, bool init)
 		dev_dbg(di->dev, "Battery low, set capacity to 0\n");
 		di->bat_cap.prev_percent = 0;
 		di->bat_cap.permille = 0;
+		percent = 0;
 		di->bat_cap.prev_mah = 0;
 		di->bat_cap.mah = 0;
 		changed = true;
@@ -1321,7 +1324,7 @@ static void ab8500_fg_check_capacity_limits(struct ab8500_fg *di, bool init)
 		 * and show 100% during maintenance charging (scaling).
 		 */
 		if (di->flags.force_full) {
-			di->bat_cap.prev_percent = di->bat_cap.permille / 10;
+			di->bat_cap.prev_percent = percent;
 			di->bat_cap.prev_mah = di->bat_cap.mah;
 
 			changed = true;
@@ -1334,19 +1337,18 @@ static void ab8500_fg_check_capacity_limits(struct ab8500_fg *di, bool init)
 						di->bat_cap.prev_percent;
 				di->bat_cap.cap_scale.disable_cap_level = 100;
 			}
-		} else if (di->bat_cap.prev_percent !=
-			(di->bat_cap.permille) / 10) {
+		} else if (di->bat_cap.prev_percent != percent) {
 			dev_dbg(di->dev,
 				"battery reported full "
 				"but capacity dropping: %d\n",
-				di->bat_cap.permille / 10);
-			di->bat_cap.prev_percent = di->bat_cap.permille / 10;
+				percent);
+			di->bat_cap.prev_percent = percent;
 			di->bat_cap.prev_mah = di->bat_cap.mah;
 
 			changed = true;
 		}
-	} else if (di->bat_cap.prev_percent != di->bat_cap.permille / 10) {
-		if (di->bat_cap.permille / 10 == 0) {
+	} else if (di->bat_cap.prev_percent != percent) {
+		if (percent == 0) {
 			/*
 			 * We will not report 0% unless we've got
 			 * the LOW_BAT IRQ, no matter what the FG
@@ -1356,11 +1358,11 @@ static void ab8500_fg_check_capacity_limits(struct ab8500_fg *di, bool init)
 			di->bat_cap.permille = 1;
 			di->bat_cap.prev_mah = 1;
 			di->bat_cap.mah = 1;
+			percent = 1;
 
 			changed = true;
 		} else if (!(!di->flags.charging &&
-			(di->bat_cap.permille / 10) >
-			di->bat_cap.prev_percent) || init) {
+			percent > di->bat_cap.prev_percent) || init) {
 			/*
 			 * We do not allow reported capacity to go up
 			 * unless we're charging or if we're in init
@@ -1368,9 +1370,9 @@ static void ab8500_fg_check_capacity_limits(struct ab8500_fg *di, bool init)
 			dev_dbg(di->dev,
 				"capacity changed from %d to %d (%d)\n",
 				di->bat_cap.prev_percent,
-				di->bat_cap.permille / 10,
+				percent,
 				di->bat_cap.permille);
-			di->bat_cap.prev_percent = di->bat_cap.permille / 10;
+			di->bat_cap.prev_percent = percent;
 			di->bat_cap.prev_mah = di->bat_cap.mah;
 
 			changed = true;
@@ -1378,7 +1380,7 @@ static void ab8500_fg_check_capacity_limits(struct ab8500_fg *di, bool init)
 			dev_dbg(di->dev, "capacity not allowed to go up since "
 				"no charger is connected: %d to %d (%d)\n",
 				di->bat_cap.prev_percent,
-				di->bat_cap.permille / 10,
+				percent,
 				di->bat_cap.permille);
 		}
 	}
-- 
1.7.5.4

