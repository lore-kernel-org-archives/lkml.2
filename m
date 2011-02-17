Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386Ab1BQTBx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 14:01:53 -0500
Received: from imr4.ericy.com ([198.24.6.8]:60240 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757798Ab1BQTBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 14:01:50 -0500
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
        Randy Dunlap <rdunlap@xenotime.net>, Greg Schnorr <gschnorr@cisco.com>,
        <lm-sensors@lm-sensors.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH v4 2/5] hwmon: (pmbus) Add support for Maxim MAX8688
Date: Thu, 17 Feb 2011 11:00:14 -0800
Message-ID: <1297969217-9564-3-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1297969217-9564-1-git-send-email-guenter.roeck@ericsson.com>
References: <1297969217-9564-1-git-send-email-guenter.roeck@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
---
 drivers/hwmon/Kconfig   |   10 +++
 drivers/hwmon/Makefile  |    1 +
 drivers/hwmon/max8688.c |  158 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 169 insertions(+), 0 deletions(-)
 create mode 100644 drivers/hwmon/max8688.c

diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 9f20e56..02ee4f2 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -757,6 +757,16 @@ config SENSORS_PMBUS
 	  This driver can also be built as a module. If so, the module will
 	  be called pmbus.
 
+config SENSORS_MAX8688
+	tristate "Maxim MAX8688"
+	default n
+	help
+	  If you say yes here you get hardware monitoring support for Maxim
+	  MAX8688.
+
+	  This driver can also be built as a module. If so, the module will
+	  be called max8688.
+
 endif # PMBUS
 
 config SENSORS_SHT15
diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
index f7f158b..00c2e77 100644
--- a/drivers/hwmon/Makefile
+++ b/drivers/hwmon/Makefile
@@ -115,6 +115,7 @@ obj-$(CONFIG_SENSORS_WM8350)	+= wm8350-hwmon.o
 # PMBus drivers
 obj-$(CONFIG_PMBUS)		+= pmbus_core.o
 obj-$(CONFIG_SENSORS_PMBUS)	+= pmbus.o
+obj-$(CONFIG_SENSORS_MAX8688)	+= max8688.o
 
 ifeq ($(CONFIG_HWMON_DEBUG_CHIP),y)
 EXTRA_CFLAGS += -DDEBUG
diff --git a/drivers/hwmon/max8688.c b/drivers/hwmon/max8688.c
new file mode 100644
index 0000000..8ebfef2
--- /dev/null
+++ b/drivers/hwmon/max8688.c
@@ -0,0 +1,158 @@
+/*
+ * Hardware monitoring driver for Maxim MAX8688
+ *
+ * Copyright (c) 2011 Ericsson AB.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/err.h>
+#include <linux/i2c.h>
+#include "pmbus.h"
+
+#define MAX8688_MFG_STATUS		0xd8
+
+#define MAX8688_STATUS_OC_FAULT		(1 << 4)
+#define MAX8688_STATUS_OV_FAULT		(1 << 5)
+#define MAX8688_STATUS_OV_WARNING	(1 << 8)
+#define MAX8688_STATUS_UV_FAULT		(1 << 9)
+#define MAX8688_STATUS_UV_WARNING	(1 << 10)
+#define MAX8688_STATUS_UC_FAULT		(1 << 11)
+#define MAX8688_STATUS_OC_WARNING	(1 << 12)
+#define MAX8688_STATUS_OT_FAULT		(1 << 13)
+#define MAX8688_STATUS_OT_WARNING	(1 << 14)
+
+static int max8688_get_status(struct i2c_client *client, int page, int reg)
+{
+	int ret = 0;
+	int mfg_status;
+
+	if (page)
+		return -EINVAL;
+
+	switch (reg) {
+	case PMBUS_STATUS_VOUT:
+		mfg_status = pmbus_read_word_data(client, 0,
+						  MAX8688_MFG_STATUS);
+		if (mfg_status < 0)
+			return mfg_status;
+		if (mfg_status & MAX8688_STATUS_UV_WARNING)
+			ret |= PB_VOLTAGE_UV_WARNING;
+		if (mfg_status & MAX8688_STATUS_UV_FAULT)
+			ret |= PB_VOLTAGE_UV_FAULT;
+		if (mfg_status & MAX8688_STATUS_OV_WARNING)
+			ret |= PB_VOLTAGE_OV_WARNING;
+		if (mfg_status & MAX8688_STATUS_OV_FAULT)
+			ret |= PB_VOLTAGE_OV_FAULT;
+		break;
+	case PMBUS_STATUS_IOUT:
+		mfg_status = pmbus_read_word_data(client, 0,
+						  MAX8688_MFG_STATUS);
+		if (mfg_status < 0)
+			return mfg_status;
+		if (mfg_status & MAX8688_STATUS_UC_FAULT)
+			ret |= PB_IOUT_UC_FAULT;
+		if (mfg_status & MAX8688_STATUS_OC_WARNING)
+			ret |= PB_IOUT_OC_WARNING;
+		if (mfg_status & MAX8688_STATUS_OC_FAULT)
+			ret |= PB_IOUT_OC_FAULT;
+		break;
+	case PMBUS_STATUS_TEMPERATURE:
+		mfg_status = pmbus_read_word_data(client, 0,
+						  MAX8688_MFG_STATUS);
+		if (mfg_status < 0)
+			return mfg_status;
+		if (mfg_status & MAX8688_STATUS_OT_WARNING)
+			ret |= PB_TEMP_OT_WARNING;
+		if (mfg_status & MAX8688_STATUS_OT_FAULT)
+			ret |= PB_TEMP_OT_FAULT;
+		break;
+	default:
+		ret = -ENODATA;
+		break;
+	}
+	return ret;
+}
+
+static struct pmbus_driver_info max8688_info = {
+	.pages = 1,
+	.direct[PSC_VOLTAGE_IN] = true,
+	.direct[PSC_VOLTAGE_OUT] = true,
+	.direct[PSC_TEMPERATURE] = true,
+	.direct[PSC_CURRENT_OUT] = true,
+	.m[PSC_VOLTAGE_IN] = 19995,
+	.b[PSC_VOLTAGE_IN] = 0,
+	.R[PSC_VOLTAGE_IN] = -1,
+	.m[PSC_VOLTAGE_OUT] = 19995,
+	.b[PSC_VOLTAGE_OUT] = 0,
+	.R[PSC_VOLTAGE_OUT] = -1,
+	.m[PSC_CURRENT_OUT] = 23109,
+	.b[PSC_CURRENT_OUT] = 0,
+	.R[PSC_CURRENT_OUT] = -2,
+	.m[PSC_TEMPERATURE] = -7612,
+	.b[PSC_TEMPERATURE] = 335,
+	.R[PSC_TEMPERATURE] = -3,
+	.func[0] = PMBUS_HAVE_VOUT | PMBUS_HAVE_IOUT | PMBUS_HAVE_TEMP
+		| PMBUS_HAVE_STATUS_VOUT | PMBUS_HAVE_STATUS_IOUT
+		| PMBUS_HAVE_STATUS_TEMP,
+	.get_status = max8688_get_status,
+};
+
+static int max8688_probe(struct i2c_client *client,
+			 const struct i2c_device_id *id)
+{
+	return pmbus_do_probe(client, id, &max8688_info);
+}
+
+static int max8688_remove(struct i2c_client *client)
+{
+	return pmbus_do_remove(client);
+}
+
+static const struct i2c_device_id max8688_id[] = {
+	{"max8688", 0},
+	{ }
+};
+
+MODULE_DEVICE_TABLE(i2c, max8688_id);
+
+/* This is the driver that will be inserted */
+static struct i2c_driver max8688_driver = {
+	.driver = {
+		   .name = "max8688",
+		   },
+	.probe = max8688_probe,
+	.remove = max8688_remove,
+	.id_table = max8688_id,
+};
+
+static int __init max8688_init(void)
+{
+	return i2c_add_driver(&max8688_driver);
+}
+
+static void __exit max8688_exit(void)
+{
+	i2c_del_driver(&max8688_driver);
+}
+
+MODULE_AUTHOR("Guenter Roeck");
+MODULE_DESCRIPTION("PMBus driver for Maxim MAX8688");
+MODULE_LICENSE("GPL");
+module_init(max8688_init);
+module_exit(max8688_exit);
-- 
1.7.3.1

