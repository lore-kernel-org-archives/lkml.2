Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663Ab1L2LwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 06:52:18 -0500
Received: from s15407518.onlinehome-server.info ([82.165.136.167]:49515 "EHLO
	s15407518.onlinehome-server.info" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753205Ab1L2LwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 06:52:15 -0500
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH] s3c_adc_battery: average over more than one adc sample
Date: Thu, 29 Dec 2011 12:52:07 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-2-686; KDE/4.4.5; i686; ; )
Cc: Vasily Khoruzhick <anarsoul@gmail.com>, linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201112291252.08563.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some sources for adc battery information provide only inaccurate results
where the read value differs from the real value with positive and negative
offsets. For such sources it can be more accurate to collect two or more
value sample and use the average of all collected values.

This patch adds pdata options volt_samples, current_samples and
backup_volt_samples to specifiy the number of samples to collect,
reads the specified number of samples and calculates the average of those.
For unset sample-number-values a default of 1 is assumed.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 drivers/power/s3c_adc_battery.c |   25 ++++++++++++++++++++++---
 include/linux/s3c_adc_battery.h |    4 ++++
 2 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/power/s3c_adc_battery.c b/drivers/power/s3c_adc_battery.c
index d32d0d7..98520a8 100644
--- a/drivers/power/s3c_adc_battery.c
+++ b/drivers/power/s3c_adc_battery.c
@@ -47,6 +47,22 @@ static void s3c_adc_bat_ext_power_changed(struct power_supply *psy)
 		msecs_to_jiffies(JITTER_DELAY));
 }
 
+static int gather_samples(struct s3c_adc_client *client, int num, int channel)
+{
+	int value, i;
+
+	/* default to 1 if nothing is set */
+	if (num < 1)
+		num = 1;
+
+	value = 0;
+	for (i = 0; i < num; i++)
+		value += s3c_adc_read(client, channel);
+	value /= num;
+
+	return value;
+}
+
 static enum power_supply_property s3c_adc_backup_bat_props[] = {
 	POWER_SUPPLY_PROP_VOLTAGE_NOW,
 	POWER_SUPPLY_PROP_VOLTAGE_MIN,
@@ -67,7 +83,8 @@ static int s3c_adc_backup_bat_get_property(struct power_supply *psy,
 	if (bat->volt_value < 0 ||
 		jiffies_to_msecs(jiffies - bat->timestamp) >
 			BAT_POLL_INTERVAL) {
-		bat->volt_value = s3c_adc_read(bat->client,
+		bat->volt_value = gather_samples(bat->client,
+			bat->pdata->backup_volt_samples,
 			bat->pdata->backup_volt_channel);
 		bat->volt_value *= bat->pdata->backup_volt_mult;
 		bat->timestamp = jiffies;
@@ -139,9 +156,11 @@ static int s3c_adc_bat_get_property(struct power_supply *psy,
 	if (bat->volt_value < 0 || bat->cur_value < 0 ||
 		jiffies_to_msecs(jiffies - bat->timestamp) >
 			BAT_POLL_INTERVAL) {
-		bat->volt_value = s3c_adc_read(bat->client,
+		bat->volt_value = gather_samples(bat->client,
+			bat->pdata->volt_samples,
 			bat->pdata->volt_channel) * bat->pdata->volt_mult;
-		bat->cur_value = s3c_adc_read(bat->client,
+		bat->cur_value = gather_samples(bat->client,
+			bat->pdata->current_samples,
 			bat->pdata->current_channel) * bat->pdata->current_mult;
 		bat->timestamp = jiffies;
 	}
diff --git a/include/linux/s3c_adc_battery.h b/include/linux/s3c_adc_battery.h
index fbe58b7..99dadbf 100644
--- a/include/linux/s3c_adc_battery.h
+++ b/include/linux/s3c_adc_battery.h
@@ -25,6 +25,10 @@ struct s3c_adc_bat_pdata {
 	const unsigned int current_channel;
 	const unsigned int backup_volt_channel;
 
+	const unsigned int volt_samples;
+	const unsigned int current_samples;
+	const unsigned int backup_volt_samples;
+
 	const unsigned int volt_mult;
 	const unsigned int current_mult;
 	const unsigned int backup_volt_mult;
-- 
1.7.2.3

