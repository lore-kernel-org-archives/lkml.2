Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253Ab2LMPYr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 10:24:47 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:51533 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755909Ab2LMPWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 10:22:13 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: cbou@mail.ru, pender01 <peter.enderborg@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 11/18] power: ab8500_fg: Round capacity output
Date: Thu, 13 Dec 2012 15:21:34 +0000
Message-Id: <1355412102-14265-12-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355412102-14265-1-git-send-email-lee.jones@linaro.org>
References: <1355412102-14265-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: pender01 <peter.enderborg@stericsson.com>

Round the capacity values for better enduser experience.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: pender01 <peter.enderborg@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
Tested-by: Marcus COOPER <marcus.xm.cooper@stericsson.com>
---
 drivers/power/ab8500_fg.c |   28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index c24dba1..5aa981e 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -32,6 +32,7 @@
 #include <linux/mfd/abx500/ab8500.h>
 #include <linux/mfd/abx500/ab8500-bm.h>
 #include <linux/mfd/abx500/ab8500-gpadc.h>
+#include <linux/kernel.h>
 
 #define MILLI_TO_MICRO			1000
 #define FG_LSB_IN_MA			1627
@@ -1158,7 +1159,7 @@ static int ab8500_fg_capacity_level(struct ab8500_fg *di)
 {
 	int ret, percent;
 
-	percent = di->bat_cap.permille / 10;
+	percent = DIV_ROUND_CLOSEST(di->bat_cap.permille, 10);
 
 	if (percent <= di->bm->cap_levels->critical ||
 		di->flags.low_bat)
@@ -1279,6 +1280,7 @@ static void ab8500_fg_update_cap_scalers(struct ab8500_fg *di)
 static void ab8500_fg_check_capacity_limits(struct ab8500_fg *di, bool init)
 {
 	bool changed = false;
+	int percent = DIV_ROUND_CLOSEST(di->bat_cap.permille, 10);
 
 	di->bat_cap.level = ab8500_fg_capacity_level(di);
 
@@ -1310,6 +1312,7 @@ static void ab8500_fg_check_capacity_limits(struct ab8500_fg *di, bool init)
 		dev_dbg(di->dev, "Battery low, set capacity to 0\n");
 		di->bat_cap.prev_percent = 0;
 		di->bat_cap.permille = 0;
+		percent = 0;
 		di->bat_cap.prev_mah = 0;
 		di->bat_cap.mah = 0;
 		changed = true;
@@ -1319,7 +1322,7 @@ static void ab8500_fg_check_capacity_limits(struct ab8500_fg *di, bool init)
 		 * and show 100% during maintenance charging (scaling).
 		 */
 		if (di->flags.force_full) {
-			di->bat_cap.prev_percent = di->bat_cap.permille / 10;
+			di->bat_cap.prev_percent = percent;
 			di->bat_cap.prev_mah = di->bat_cap.mah;
 
 			changed = true;
@@ -1332,19 +1335,18 @@ static void ab8500_fg_check_capacity_limits(struct ab8500_fg *di, bool init)
 						di->bat_cap.prev_percent;
 				di->bat_cap.cap_scale.disable_cap_level = 100;
 			}
-		} else if ( di->bat_cap.prev_percent !=
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
@@ -1354,11 +1356,11 @@ static void ab8500_fg_check_capacity_limits(struct ab8500_fg *di, bool init)
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
@@ -1366,9 +1368,9 @@ static void ab8500_fg_check_capacity_limits(struct ab8500_fg *di, bool init)
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
@@ -1376,7 +1378,7 @@ static void ab8500_fg_check_capacity_limits(struct ab8500_fg *di, bool init)
 			dev_dbg(di->dev, "capacity not allowed to go up since "
 				"no charger is connected: %d to %d (%d)\n",
 				di->bat_cap.prev_percent,
-				di->bat_cap.permille / 10,
+				percent,
 				di->bat_cap.permille);
 		}
 	}
-- 
1.7.9.5

