Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965203Ab2CNB4q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 21:56:46 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:33874 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964778Ab2CNB4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 21:56:45 -0400
X-AuditID: cbfee61a-b7b78ae000001ceb-3b-4f5ffadbf1a6
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: dirk.brandewie@gmail.com, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, Jason.Wortham@maxim-ic.com,
        bruce.e.robertson@intel.com,
        Karol Lewandowski <k.lewandowsk@samsung.com>, myungjoo.ham@gmail.com
Subject: [PATCH] max17042: fix CHARGE_FULL representation.
Date: Wed, 14 Mar 2012 10:56:47 +0900
Message-id: <1331690207-1289-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CHARGE_FULL should represent the full capacity of the battery in uAh.
The 0x10 (FullCAP) register shows the compensated full capacity in
mAh * 2; e.g., reg(0x10) = 0xBB8 means that it is 1500mAh.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
---
 drivers/power/max17042_battery.c       |    7 ++-----
 include/linux/power/max17042_battery.h |    2 +-
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/power/max17042_battery.c b/drivers/power/max17042_battery.c
index 86acee2..4474427b 100644
--- a/drivers/power/max17042_battery.c
+++ b/drivers/power/max17042_battery.c
@@ -143,14 +143,11 @@ static int max17042_get_property(struct power_supply *psy,
 		val->intval = ret >> 8;
 		break;
 	case POWER_SUPPLY_PROP_CHARGE_FULL:
-		ret = max17042_read_reg(chip->client, MAX17042_RepSOC);
+		ret = max17042_read_reg(chip->client, MAX17042_FullCAP);
 		if (ret < 0)
 			return ret;
 
-		if ((ret >> 8) >= MAX17042_BATTERY_FULL)
-			val->intval = 1;
-		else if (ret >= 0)
-			val->intval = 0;
+		val->intval = ret * 1000 / 2;
 		break;
 	case POWER_SUPPLY_PROP_TEMP:
 		ret = max17042_read_reg(chip->client, MAX17042_TEMP);
diff --git a/include/linux/power/max17042_battery.h b/include/linux/power/max17042_battery.h
index fe99211..a8fe98c 100644
--- a/include/linux/power/max17042_battery.h
+++ b/include/linux/power/max17042_battery.h
@@ -44,7 +44,7 @@ enum max17042_register {
 	MAX17042_SOC		= 0x0D,
 	MAX17042_AvSOC		= 0x0E,
 	MAX17042_RemCap		= 0x0F,
-	MAX17402_FullCAP	= 0x10,
+	MAX17042_FullCAP	= 0x10,
 	MAX17042_TTE		= 0x11,
 	MAX17042_V_empty	= 0x12,
 
-- 
1.7.4.1

