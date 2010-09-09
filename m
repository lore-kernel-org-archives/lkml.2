Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab0IINWl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 09:22:41 -0400
Received: from imr3.ericy.com ([198.24.6.13]:58441 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754350Ab0IINWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 09:22:38 -0400
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Andrew Morton <akpm@linux-foundation.org>, lm-sensors@lm-sensors.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH v2 3/7] hwmon: (lm90) Introduce function to delete sysfs files
Date: Thu, 9 Sep 2010 06:25:46 -0700
Message-ID: <1284038750-8833-4-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.0.87.g0901d
In-Reply-To: <1284038750-8833-1-git-send-email-guenter.roeck@ericsson.com>
References: <1284038750-8833-1-git-send-email-guenter.roeck@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
---
 drivers/hwmon/lm90.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
index a81a053..f21dde5 100644
--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -815,6 +815,15 @@ static int lm90_detect(struct i2c_client *new_client,
 	return 0;
 }
 
+static void lm90_remove_files(struct i2c_client *client, struct lm90_data *data)
+{
+	if (data->flags & LM90_HAVE_OFFSET)
+		device_remove_file(&client->dev,
+				   &sensor_dev_attr_temp2_offset.dev_attr);
+	device_remove_file(&client->dev, &dev_attr_pec);
+	sysfs_remove_group(&client->dev.kobj, &lm90_group);
+}
+
 static int lm90_probe(struct i2c_client *new_client,
 		      const struct i2c_device_id *id)
 {
@@ -889,8 +898,7 @@ static int lm90_probe(struct i2c_client *new_client,
 	return 0;
 
 exit_remove_files:
-	sysfs_remove_group(&new_client->dev.kobj, &lm90_group);
-	device_remove_file(&new_client->dev, &dev_attr_pec);
+	lm90_remove_files(new_client, data);
 exit_free:
 	kfree(data);
 exit:
@@ -937,11 +945,7 @@ static int lm90_remove(struct i2c_client *client)
 	struct lm90_data *data = i2c_get_clientdata(client);
 
 	hwmon_device_unregister(data->hwmon_dev);
-	sysfs_remove_group(&client->dev.kobj, &lm90_group);
-	device_remove_file(&client->dev, &dev_attr_pec);
-	if (data->flags & LM90_HAVE_OFFSET)
-		device_remove_file(&client->dev,
-				   &sensor_dev_attr_temp2_offset.dev_attr);
+	lm90_remove_files(client, data);
 
 	/* Restore initial configuration */
 	i2c_smbus_write_byte_data(client, LM90_REG_W_CONFIG1,
-- 
1.7.0.87.g0901d

