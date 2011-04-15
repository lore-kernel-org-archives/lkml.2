Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940Ab1DOLEw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 07:04:52 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3328 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057Ab1DOLEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 07:04:51 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 15 Apr 2011 04:04:10 -0700
From: wni@nvidia.com
To: khali@linux-fr.org, guenter.roeck@ericsson.com
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        olofj@chromium.org, achew@nvidia.com, Wei Ni <wni@nvidia.com>
Subject: [PATCH 2/3] hwmon (lm90) Support to configure nct1008 from platform data
Date: Fri, 15 Apr 2011 19:00:27 +0800
Message-Id: <1302865228-7185-3-git-send-email-wni@nvidia.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1302865228-7185-1-git-send-email-wni@nvidia.com>
References: <1302865228-7185-1-git-send-email-wni@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Ni <wni@nvidia.com>

This patch add support to configure nct1008 from platform data.

Signed-off-by: Wei Ni <wni@nvidia.com>
---
 drivers/hwmon/lm90.c    |   66 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/nct1008.h |   38 +++++++++++++++++++++++++++
 2 files changed, 104 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/nct1008.h

diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
index 1c2ee3f..8b639b0 100644
--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -83,6 +83,7 @@
 #include <linux/err.h>
 #include <linux/mutex.h>
 #include <linux/sysfs.h>
+#include <linux/nct1008.h>
 
 /*
  * Addresses to scan
@@ -1358,6 +1359,67 @@ static void lm90_init_client(struct i2c_client *client)
 		i2c_smbus_write_byte_data(client, LM90_REG_W_CONFIG1, config);
 }
 
+static void lm90_configure_client(struct i2c_client *client)
+{
+	struct lm90_data *data = i2c_get_clientdata(client);
+	u8 value;
+	u16 value16;
+
+	if (strcmp(client->name, "nct1008")) {
+		struct nct1008_platform_data *pdata = client->dev.platform_data;
+
+		/*
+		 * Initial Configuration - device is placed in standby and
+		 * ALERT/THERM2 pin is configured as THERM2
+		 */
+		lm90_read_reg(client, LM90_REG_R_CONFIG1, &value);
+		if (pdata->ext_range)
+			value |= 0x24;
+		else
+			value |= 0x20;
+		i2c_smbus_write_byte_data(client, LM90_REG_W_CONFIG1, value);
+
+		/* Check Temperature Range Select */
+		if (value & 0x04)
+			data->flags |= LM90_FLAG_ADT7461_EXT;
+
+		/* Temperature conversion rate */
+		value = pdata->conv_rate;
+		i2c_smbus_write_byte_data(client, LM90_REG_W_CONVRATE, value);
+
+		/* External temperature h/w shutdown limit */
+		value = temp_to_u8_adt7461(data, pdata->shutdown_ext_limit);
+		i2c_smbus_write_byte_data(client, LM90_REG_W_REMOTE_CRIT,
+					  value);
+
+		/* Local temperature h/w shutdown limit */
+		value = temp_to_u8_adt7461(data, pdata->shutdown_local_limit);
+		i2c_smbus_write_byte_data(client, LM90_REG_W_LOCAL_CRIT, value);
+
+		/* External Temperature Throttling limit */
+		value16 = temp_to_u16_adt7461(data, pdata->throttle_ext_limit);
+		i2c_smbus_write_byte_data(client, LM90_REG_W_REMOTE_HIGHH,
+					  value16 >> 8);
+		if (data->flags & LM90_HAVE_REM_LIMIT_EXT)
+			i2c_smbus_write_byte_data(client,
+						  LM90_REG_W_REMOTE_HIGHL,
+						  value16 & 0xff);
+
+		/* Local Temperature Throttling limit */
+		value = pdata->ext_range ? 191 : 127;
+		i2c_smbus_write_byte_data(client, LM90_REG_W_LOCAL_HIGH, value);
+
+		/* Remote channel offset */
+		value = pdata->offset;
+		i2c_smbus_write_byte_data(client,
+					  LM90_REG_W_REMOTE_OFFSH, value);
+
+		/* THERM hysteresis */
+		value = pdata->hysteresis;
+		i2c_smbus_write_byte_data(client, LM90_REG_W_TCRIT_HYST, value);
+	}
+}
+
 static int lm90_probe(struct i2c_client *new_client,
 		      const struct i2c_device_id *id)
 {
@@ -1393,6 +1455,10 @@ static int lm90_probe(struct i2c_client *new_client,
 	/* Initialize the LM90 chip */
 	lm90_init_client(new_client);
 
+	/* Configure the LM90 chip from platform_data */
+	if (new_client->dev.platform_data)
+		lm90_configure_client(new_client);
+
 	/* Register sysfs hooks */
 	err = sysfs_create_group(&new_client->dev.kobj, &lm90_group);
 	if (err)
diff --git a/include/linux/nct1008.h b/include/linux/nct1008.h
new file mode 100644
index 0000000..3a6ed69
--- /dev/null
+++ b/include/linux/nct1008.h
@@ -0,0 +1,38 @@
+/*
+ * include/linux/nct1008.h
+ *
+ * NCT1008, temperature monitoring device from ON Semiconductors
+ *
+ * Copyright (c) 2010, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+
+#ifndef _LINUX_NCT1008_H
+#define _LINUX_NCT1008_H
+
+#include <linux/types.h>
+
+struct nct1008_platform_data {
+	bool ext_range;
+	u8 conv_rate;
+	u8 offset;
+	u8 hysteresis;
+	long shutdown_ext_limit;
+	long shutdown_local_limit;
+	long throttle_ext_limit;
+};
+
+#endif /* _LINUX_NCT1008_H */
-- 
1.7.0

