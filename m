Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933874Ab1KJI4x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 03:56:53 -0500
Received: from h1778886.stratoserver.net ([85.214.133.74]:44061 "EHLO
	h1778886.stratoserver.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932301Ab1KJI4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 03:56:52 -0500
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH] s3c-adc-battery: Add naive POWER_SUPPLY_PROP_PRESENT implementation
Date: Thu, 10 Nov 2011 09:56:43 +0100
User-Agent: KMail/1.13.7 (Linux/2.6.39-2-amd64; KDE/4.6.4; x86_64; ; )
Cc: Vasily Khoruzhick <anarsoul@gmail.com>, linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201111100956.43979.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Userspace programs like upower seem to depend on the presence of the
POWER_SUPPLY_PROP_PRESENT property.

The real presence of the battery cannot be sensed and all other
routines of s3c-adc-battery simply expect it to be present.

Therefore we simply return 1, unless the battery struct is not present at all.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 drivers/power/s3c_adc_battery.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/power/s3c_adc_battery.c b/drivers/power/s3c_adc_battery.c
index d32d0d7..42d1f92 100644
--- a/drivers/power/s3c_adc_battery.c
+++ b/drivers/power/s3c_adc_battery.c
@@ -51,6 +51,7 @@ static enum power_supply_property s3c_adc_backup_bat_props[] = {
 	POWER_SUPPLY_PROP_VOLTAGE_NOW,
 	POWER_SUPPLY_PROP_VOLTAGE_MIN,
 	POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN,
+	POWER_SUPPLY_PROP_PRESENT,
 };
 
 static int s3c_adc_backup_bat_get_property(struct power_supply *psy,
@@ -60,6 +61,11 @@ static int s3c_adc_backup_bat_get_property(struct power_supply *psy,
 	struct s3c_adc_bat *bat = container_of(psy, struct s3c_adc_bat, psy);
 
 	if (!bat) {
+		if (psp == POWER_SUPPLY_PROP_PRESENT) {
+			val->intval = 0;
+			return 0;
+		}
+
 		dev_err(psy->dev, "%s: no battery infos ?!\n", __func__);
 		return -EINVAL;
 	}
@@ -83,6 +89,9 @@ static int s3c_adc_backup_bat_get_property(struct power_supply *psy,
 	case POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN:
 		val->intval = bat->pdata->backup_volt_max;
 		return 0;
+	case POWER_SUPPLY_PROP_PRESENT:
+		val->intval = 1;
+		return 0;
 	default:
 		return -EINVAL;
 	}
@@ -106,6 +115,7 @@ static enum power_supply_property s3c_adc_main_bat_props[] = {
 	POWER_SUPPLY_PROP_CHARGE_NOW,
 	POWER_SUPPLY_PROP_VOLTAGE_NOW,
 	POWER_SUPPLY_PROP_CURRENT_NOW,
+	POWER_SUPPLY_PROP_PRESENT,
 };
 
 static int calc_full_volt(int volt_val, int cur_val, int impedance)
@@ -132,6 +142,11 @@ static int s3c_adc_bat_get_property(struct power_supply *psy,
 	unsigned int lut_size = bat->pdata->lut_noac_cnt;
 
 	if (!bat) {
+		if (psp == POWER_SUPPLY_PROP_PRESENT) {
+			val->intval = 0;
+			return 0;
+		}
+
 		dev_err(psy->dev, "no battery infos ?!\n");
 		return -EINVAL;
 	}
@@ -205,6 +220,9 @@ static int s3c_adc_bat_get_property(struct power_supply *psy,
 	case POWER_SUPPLY_PROP_CURRENT_NOW:
 		val->intval = bat->cur_value;
 		return 0;
+	case POWER_SUPPLY_PROP_PRESENT:
+		val->intval = 1;
+		return 0;
 	default:
 		return -EINVAL;
 	}
-- 
1.6.1

