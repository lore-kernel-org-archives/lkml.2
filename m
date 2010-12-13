Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021Ab0LMK2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 05:28:36 -0500
Received: from mail-ew0-f45.google.com ([209.85.215.45]:42725 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757001Ab0LMK2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 05:28:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=esuYFAw67HGIlOfyqhsFb0wohpvtn0GKNGjiz1W3mu+64EyvYis+07Qi3e2CmOSOOB
         zlvKAP8mKWPJ9ap3tG9yTCo5iV1rxyqmZDy0WvMJMbWzOuWFvEzpjXlLGnlULAlEKtGy
         rMqA/vofpjwp/JPxXHKnVv6c+KjZXyIhEBpOo=
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>, linux-kernel@vger.kernel.org
Cc: Vasily Khoruzhick <anarsoul@gmail.com>
Subject: [PATCH] s3c_adc_battery: Add gpio_inverted field to pdata
Date: Mon, 13 Dec 2010 12:26:21 +0200
Message-Id: <1292235981-9842-1-git-send-email-anarsoul@gmail.com>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for inverted gpio_charge_finished values.
This change is necessary for H1940 support.

Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
---
 drivers/power/s3c_adc_battery.c |   12 +++++++++---
 include/linux/s3c_adc_battery.h |    1 +
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/power/s3c_adc_battery.c b/drivers/power/s3c_adc_battery.c
index 4a8ae39..4255f23 100644
--- a/drivers/power/s3c_adc_battery.c
+++ b/drivers/power/s3c_adc_battery.c
@@ -112,6 +112,13 @@ static int calc_full_volt(int volt_val, int cur_val, int impedance)
 	return volt_val + cur_val * impedance / 1000;
 }
 
+static int charge_finished(struct s3c_adc_bat *bat)
+{
+	return bat->pdata->gpio_inverted ?
+		!gpio_get_value(bat->pdata->gpio_charge_finished) :
+		gpio_get_value(bat->pdata->gpio_charge_finished);
+}
+
 static int s3c_adc_bat_get_property(struct power_supply *psy,
 				    enum power_supply_property psp,
 				    union power_supply_propval *val)
@@ -140,7 +147,7 @@ static int s3c_adc_bat_get_property(struct power_supply *psy,
 
 	if (bat->cable_plugged &&
 		((bat->pdata->gpio_charge_finished < 0) ||
-		!gpio_get_value(bat->pdata->gpio_charge_finished))) {
+		!charge_finished(bat))) {
 		lut = bat->pdata->lut_acin;
 		lut_size = bat->pdata->lut_acin_cnt;
 	}
@@ -236,8 +243,7 @@ static void s3c_adc_bat_work(struct work_struct *work)
 		}
 	} else {
 		if ((bat->pdata->gpio_charge_finished >= 0) && is_plugged) {
-			is_charged = gpio_get_value(
-				main_bat.pdata->gpio_charge_finished);
+			is_charged = charge_finished(&main_bat);
 			if (is_charged) {
 				if (bat->pdata->disable_charger)
 					bat->pdata->disable_charger();
diff --git a/include/linux/s3c_adc_battery.h b/include/linux/s3c_adc_battery.h
index dbce22f..fbe58b7 100644
--- a/include/linux/s3c_adc_battery.h
+++ b/include/linux/s3c_adc_battery.h
@@ -14,6 +14,7 @@ struct s3c_adc_bat_pdata {
 	void (*disable_charger)(void);
 
 	int gpio_charge_finished;
+	int gpio_inverted;
 
 	const struct s3c_adc_bat_thresh *lut_noac;
 	unsigned int lut_noac_cnt;
-- 
1.7.3.2

