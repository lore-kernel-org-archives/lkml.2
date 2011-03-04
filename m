Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932585Ab1CDR6u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 12:58:50 -0500
Received: from imr3.ericy.com ([198.24.6.13]:37344 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932454Ab1CDR47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 12:56:59 -0500
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Ian Dobson <i.dobson@planet-ian.com>, Andy Lutomirski <luto@mit.edu>,
        Randy Dunlap <rdunlap@xenotime.net>, <binximeng@gmail.com>,
        <lmsensors@tapanitarvainen.fi>, <andrea.rizzolo@gmail.com>,
        <jeff.sadowski@gmail.com>, <lm-sensors@lm-sensors.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH v5 07/11] hwmon: (w83627ehf) Permit enabling SmartFan IV mode if configured at startup
Date: Fri, 4 Mar 2011 09:58:02 -0800
Message-ID: <1299261486-15190-8-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1299261486-15190-1-git-send-email-guenter.roeck@ericsson.com>
References: <1299261486-15190-1-git-send-email-guenter.roeck@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If SmartFan IV mode was configured at startup, it should be possible
to re-enable it later on.

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
---
 drivers/hwmon/w83627ehf.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/w83627ehf.c b/drivers/hwmon/w83627ehf.c
index 2420f1c..2f17f99 100644
--- a/drivers/hwmon/w83627ehf.c
+++ b/drivers/hwmon/w83627ehf.c
@@ -346,7 +346,10 @@ struct w83627ehf_data {
 			     2->thermal cruise mode (also called SmartFan I)
 			     3->fan speed cruise mode
 			     4->variable thermal cruise (also called
-				SmartFan III) */
+				SmartFan III)
+			     5->enhanced variable thermal cruise (also called
+				SmartFan IV) */
+	u8 pwm_enable_orig[4];	/* original value of pwm_enable */
 	u8 pwm_num;		/* number of pwm */
 	u8 pwm[4];
 	u8 target_temp[4];
@@ -1055,7 +1058,7 @@ store_pwm_enable(struct device *dev, struct device_attribute *attr,
 	if (err < 0)
 		return err;
 
-	if (!val || (val > 4))
+	if (!val || (val > 4 && val != data->pwm_enable_orig[nr]))
 		return -EINVAL;
 	mutex_lock(&data->update_lock);
 	reg = w83627ehf_read_value(data, W83627EHF_REG_PWM_ENABLE[nr]);
@@ -1617,6 +1620,11 @@ static int __devinit w83627ehf_probe(struct platform_device *pdev)
 	/* Read fan clock dividers immediately */
 	w83627ehf_update_fan_div(data);
 
+	/* Read pwm data to save original values */
+	w83627ehf_update_pwm_common(dev, data);
+	for (i = 0; i < data->pwm_num; i++)
+		data->pwm_enable_orig[i] = data->pwm_enable[i];
+
 	/* Register sysfs hooks */
 	for (i = 0; i < ARRAY_SIZE(sda_sf3_arrays); i++) {
 		err = device_create_file(dev, &sda_sf3_arrays[i].dev_attr);
-- 
1.7.3.1

