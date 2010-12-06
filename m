Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab0LFUfk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 15:35:40 -0500
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:55274 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753172Ab0LFUfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 15:35:39 -0500
From: Daniel Drake <dsd@laptop.org>
To: cbou@mail.ru
To: dwmw2@infradead.org
Cc: pgf@laptop.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] olpc_battery: Hide ambient temperature attribute on XO-1.5
Message-Id: <20101206203535.59D959D401B@zog.reactivated.net>
Date: Mon,  6 Dec 2010 20:35:35 +0000 (GMT)
X-Cloudmark-Analysis: v=1.1 cv=X0sWjjQ37bMP4yB/pNNinY3VxVB2n/hmdAjhihaCFGs= c=1 sm=0 a=bR5GZkS9C54A:10 a=Op-mwl0xAAAA:8 a=sMi1VdoOrEbKczwXpg4A:9 a=R3GBjH34jmDMXMOQepgA:7 a=rT6GSCVq1AmNEZAGeriISbeGoGsA:4 a=d4CUUju0HPYA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This attribute is not available on the XO-1.5 laptop, but remains
functional on the XO-1.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/power/olpc_battery.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/power/olpc_battery.c b/drivers/power/olpc_battery.c
index 5bc1dcf..8986701 100644
--- a/drivers/power/olpc_battery.c
+++ b/drivers/power/olpc_battery.c
@@ -204,6 +204,16 @@ static int olpc_bat_get_tech(union power_supply_propval *val)
 /*********************************************************************
  *		Battery properties
  *********************************************************************/
+static bool olpc_bat_property_is_available(struct power_supply *psy,
+					   enum power_supply_property psp)
+{
+	/* Ambient temperature is only available on XO-1 */
+	if (olpc_platform_info.boardrev >= olpc_board_pre(0xd0) &&
+			psp == POWER_SUPPLY_PROP_TEMP_AMBIENT)
+		return false;
+	return true;
+}
+
 static int olpc_bat_get_property(struct power_supply *psy,
 				 enum power_supply_property psp,
 				 union power_supply_propval *val)
@@ -301,7 +311,7 @@ static int olpc_bat_get_property(struct power_supply *psy,
 
 		val->intval = (s16)be16_to_cpu(ec_word) * 100 / 256;
 		break;
-	case POWER_SUPPLY_PROP_TEMP_AMBIENT:
+	case POWER_SUPPLY_PROP_TEMP_AMBIENT: /* XO-1 only */
 		ret = olpc_ec_cmd(EC_AMB_TEMP, NULL, 0, (void *)&ec_word, 2);
 		if (ret)
 			return ret;
@@ -421,6 +431,7 @@ static struct platform_device *bat_pdev;
 static struct power_supply olpc_bat = {
 	.properties = olpc_bat_props,
 	.num_properties = ARRAY_SIZE(olpc_bat_props),
+	.property_is_available = olpc_bat_property_is_available,
 	.get_property = olpc_bat_get_property,
 	.use_for_apm = 1,
 };
-- 
1.7.3.2

