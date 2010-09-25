Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561Ab0IYSTq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 14:19:46 -0400
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:8054 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756401Ab0IYSTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 14:19:45 -0400
From: Daniel Drake <dsd@laptop.org>
To: cbou@mail.ru
To: dwmw2@infradead.org
Cc: dilinger@queued.net
Cc: linux-kernel@vger.kernel.org
Cc: harvey.harrison@gmail.com
Cc: richard@laptop.org
Subject: [PATCH v2] olpc_battery: Fix endian neutral breakage for s16 values
Message-Id: <20100925181927.2C3389D401B@zog.reactivated.net>
Date: Sat, 25 Sep 2010 19:19:26 +0100 (BST)
X-Cloudmark-Analysis: v=1.1 cv=3ENABmdyEd/Fm7fR7+mZIuMDn6+IErAeEhlfWBImZFk= c=1 sm=0 a=LvBF6_Ggx1IA:10 a=Op-mwl0xAAAA:8 a=CO44wLD3zDV2wQM6bmIA:9 a=udBbNTxSvXYdvBAZJik7cT9IM94A:4 a=d4CUUju0HPYA:10 a=Quc-RyF8ODyGqE2m:21 a=guVw3mFjel9zR-51:21 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard A. Smith <richard@laptop.org>

When the driver was updated to be endian neutral (8e9c7716c)
the signed part of the s16 values was lost.  This is because be16_to_cpu()
returns a signed value.  This patch casts the values back to a s16 number
prior to the the implicit cast up to an int.

Signed-off-by: Richard A. Smith <richard@laptop.org>
Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/power/olpc_battery.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

v2 drops the unneeded int casts, which are implicit.

diff --git a/drivers/power/olpc_battery.c b/drivers/power/olpc_battery.c
index aafc1c5..5bc1dcf 100644
--- a/drivers/power/olpc_battery.c
+++ b/drivers/power/olpc_battery.c
@@ -271,14 +271,14 @@ static int olpc_bat_get_property(struct power_supply *psy,
 		if (ret)
 			return ret;
 
-		val->intval = (int)be16_to_cpu(ec_word) * 9760L / 32;
+		val->intval = (s16)be16_to_cpu(ec_word) * 9760L / 32;
 		break;
 	case POWER_SUPPLY_PROP_CURRENT_AVG:
 		ret = olpc_ec_cmd(EC_BAT_CURRENT, NULL, 0, (void *)&ec_word, 2);
 		if (ret)
 			return ret;
 
-		val->intval = (int)be16_to_cpu(ec_word) * 15625L / 120;
+		val->intval = (s16)be16_to_cpu(ec_word) * 15625L / 120;
 		break;
 	case POWER_SUPPLY_PROP_CAPACITY:
 		ret = olpc_ec_cmd(EC_BAT_SOC, NULL, 0, &ec_byte, 1);
@@ -299,7 +299,7 @@ static int olpc_bat_get_property(struct power_supply *psy,
 		if (ret)
 			return ret;
 
-		val->intval = (int)be16_to_cpu(ec_word) * 100 / 256;
+		val->intval = (s16)be16_to_cpu(ec_word) * 100 / 256;
 		break;
 	case POWER_SUPPLY_PROP_TEMP_AMBIENT:
 		ret = olpc_ec_cmd(EC_AMB_TEMP, NULL, 0, (void *)&ec_word, 2);
@@ -313,7 +313,7 @@ static int olpc_bat_get_property(struct power_supply *psy,
 		if (ret)
 			return ret;
 
-		val->intval = (int)be16_to_cpu(ec_word) * 6250 / 15;
+		val->intval = (s16)be16_to_cpu(ec_word) * 6250 / 15;
 		break;
 	case POWER_SUPPLY_PROP_SERIAL_NUMBER:
 		ret = olpc_ec_cmd(EC_BAT_SERIAL, NULL, 0, (void *)&ser_buf, 8);
-- 
1.7.2.2

