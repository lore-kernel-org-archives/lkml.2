Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab1H2RGj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 13:06:39 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:55239 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754382Ab1H2RGg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 13:06:36 -0400
From: Philip Rakity <prakity@marvell.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "adharmap@codeaurora.org" <adharmap@codeaurora.org>,
        "cbou@mail.ru" <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Mon, 29 Aug 2011 10:04:09 -0700
Subject: [PATCH 3/3]  power: max17042:  allow battery to return
 charge/voltage  to use
Thread-Topic: [PATCH 3/3]  power: max17042:  allow battery to return
 charge/voltage  to use
Thread-Index: Acxmbarq+Hz6FZdEQdyL4oQ6TZmXxA==
Message-ID: <B2B81E54-40A9-4A70-B258-D5E031893264@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


implement the properties
POWER_SUPPLY_PROP_CHARGE_TO_USE
POWER_SUPPLY_PROP_VOLTAGE_TO_USE

these properties return to the caller the voltage and current
to use to charge the battery.  The calculation is handled
by board specific functions otherwise 0 voltage/current is returned.

In our implementation the intersil charger is told it is supplying
power to the max17042 using the supplied_to field.  The intersil
driver will ask the battery what power and charge to use.

Similarly the max8925 is told it is supplying power to the intersil
driver using the supplied_to field.  The intersil driver implements
the external_power_changed callback to know if you should ask
the battery what charge to supply.

Signed-off-by: Philip Rakity <prakity@marvell.com>
---
 drivers/power/max17042_battery.c       |   88 +++++++++++++++++++++++++++----
 include/linux/power/max17042_battery.h |    4 ++
 2 files changed, 80 insertions(+), 12 deletions(-)

diff --git a/drivers/power/max17042_battery.c b/drivers/power/max17042_battery.c
index 9a85f90..ab69849 100644
--- a/drivers/power/max17042_battery.c
+++ b/drivers/power/max17042_battery.c
@@ -75,10 +75,74 @@ static enum power_supply_property max17042_battery_props[] = {
 	POWER_SUPPLY_PROP_CAPACITY,
 	POWER_SUPPLY_PROP_CHARGE_FULL,
 	POWER_SUPPLY_PROP_TEMP,
+	POWER_SUPPLY_PROP_CHARGE_TO_USE,
+	POWER_SUPPLY_PROP_VOLTAGE_TO_USE,
 	POWER_SUPPLY_PROP_CURRENT_NOW,
 	POWER_SUPPLY_PROP_CURRENT_AVG,
 };
 
+static int max17042_get_voltage(struct max17042_chip *chip)
+{
+	int temp;
+
+	temp = max17042_read_reg(chip->client,
+			MAX17042_VCELL) * 625 / 8; /* mV */
+	return temp;
+}
+
+static int max17042_get_temperature(struct max17042_chip *chip)
+{
+	int temp;
+
+	temp = max17042_read_reg(chip->client,
+			MAX17042_TEMP);
+	/* The value is signed. */
+	if (temp & 0x8000) {
+		temp = (0x7fff & ~temp) + 1;
+		temp *= -1;
+	}
+	/* The value is converted into deci-centigrade scale */
+	/* Units of LSB = 1 / 256 degree Celsius */
+	temp = temp * 10 / 256;
+	pr_debug("%s: temperature = %d\n", __func__, temp);
+	return temp;
+}
+
+static int max17042_get_charge_to_use(struct max17042_chip *chip)
+{
+	int voltage;
+	int charge;
+
+	if (max17042_get_temperature(chip) >
+			chip->pdata->max_temperature) {
+		charge = 0;	/* no charge - temp too high */
+		pr_debug("%s: Temp too high to charge\n", __func__);
+	} else {
+		voltage = max17042_get_voltage(chip);
+		if (chip->pdata->charge_to_use)
+			charge = chip->pdata->charge_to_use(voltage);
+		else
+			charge = 0;
+	}
+	pr_debug("%s: charge_to_use = %d\n", __func__, charge);
+	return charge;
+}
+
+static int max17042_get_voltage_to_use(struct max17042_chip *chip)
+{
+	int voltage;
+	int charge;
+
+	charge = max17042_get_charge_to_use(chip);
+	if (chip->pdata->voltage_to_use)
+		voltage = chip->pdata->voltage_to_use(charge);
+	else
+		voltage = 0;
+
+	pr_debug("%s: voltage_to_use = %d\n", __func__, voltage);
+	return voltage;
+}
+
 static int max17042_get_property(struct power_supply *psy,
 			    enum power_supply_property psp,
 			    union power_supply_propval *val)
@@ -112,8 +176,7 @@ static int max17042_get_property(struct power_supply *psy,
 		val->intval *= 10000; /* Units of LSB = 10mV */
 		break;
 	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
-		val->intval = max17042_read_reg(chip->client, MAX17042_VCELL)
-			    * 625 / 8;
+		val->intval = max17042_get_voltage(chip);
 		break;
 	case POWER_SUPPLY_PROP_VOLTAGE_AVG:
 		val->intval = max17042_read_reg(chip->client, MAX17042_AvgVCELL)
@@ -132,16 +195,7 @@ static int max17042_get_property(struct power_supply *psy,
 			val->intval = 0;
 		break;
 	case POWER_SUPPLY_PROP_TEMP:
-		val->intval = max17042_read_reg(chip->client,
-				MAX17042_TEMP);
-		/* The value is signed. */
-		if (val->intval & 0x8000) {
-			val->intval = (0x7fff & ~val->intval) + 1;
-			val->intval *= -1;
-		}
-		/* The value is converted into deci-centigrade scale */
-		/* Units of LSB = 1 / 256 degree Celsius */
-		val->intval = val->intval * 10 / 256;
+		val->intval = max17042_get_temperature(chip);
 		break;
 	case POWER_SUPPLY_PROP_CURRENT_NOW:
 		if (chip->pdata->enable_current_sense) {
@@ -173,6 +227,13 @@ static int max17042_get_property(struct power_supply *psy,
 			return -EINVAL;
 		}
 		break;
+
+	case POWER_SUPPLY_PROP_CHARGE_TO_USE:
+		val->intval = max17042_get_charge_to_use(chip);
+		break;
+	case POWER_SUPPLY_PROP_VOLTAGE_TO_USE:
+		val->intval =  max17042_get_voltage_to_use(chip);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -212,6 +273,9 @@ static int __devinit max17042_probe(struct i2c_client *client,
 	if (chip->pdata->r_sns == 0)
 		chip->pdata->r_sns = MAX17042_DEFAULT_SNS_RESISTOR;
 
+	if (chip->pdata->max_temperature == 0)
+		chip->pdata->max_temperature = MAX17042_MAX_TEMP_NO_CHARGE;
+
 	ret = power_supply_register(&client->dev, &chip->battery);
 	if (ret) {
 		dev_err(&client->dev, "failed: power supply register\n");
diff --git a/include/linux/power/max17042_battery.h b/include/linux/power/max17042_battery.h
index fe99211..e924363 100644
--- a/include/linux/power/max17042_battery.h
+++ b/include/linux/power/max17042_battery.h
@@ -26,6 +26,7 @@
 #define MAX17042_STATUS_BattAbsent	(1 << 3)
 #define MAX17042_BATTERY_FULL	(100)
 #define MAX17042_DEFAULT_SNS_RESISTOR	(10000)
+#define MAX17042_MAX_TEMP_NO_CHARGE	(450)  /* 45 C */
 
 enum max17042_register {
 	MAX17042_STATUS		= 0x00,
@@ -116,6 +117,9 @@ struct max17042_platform_data {
 	 * the datasheet although it can be changed by board designers.
 	 */
 	unsigned int r_sns;
+	unsigned int max_temperature;  /* do not charge above this */
+	int (*charge_to_use) (int voltage);
+	int (*voltage_to_use)(int charge);
 };
 
 #endif /* __MAX17042_BATTERY_H_ */
-- 
1.7.6


