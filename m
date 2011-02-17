Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464Ab1BQTCL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 14:02:11 -0500
Received: from imr3.ericy.com ([198.24.6.13]:55117 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932450Ab1BQTCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 14:02:07 -0500
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
        Randy Dunlap <rdunlap@xenotime.net>, Greg Schnorr <gschnorr@cisco.com>,
        <lm-sensors@lm-sensors.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH v4 3/5] hwmon: (pmbus) Add support for Maxim MAX16064
Date: Thu, 17 Feb 2011 11:00:15 -0800
Message-ID: <1297969217-9564-4-git-send-email-guenter.roeck@ericsson.com>
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
 drivers/hwmon/Kconfig    |   10 +++++
 drivers/hwmon/Makefile   |    1 +
 drivers/hwmon/max16064.c |   91 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 102 insertions(+), 0 deletions(-)
 create mode 100644 drivers/hwmon/max16064.c

diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 02ee4f2..723cadd 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -757,6 +757,16 @@ config SENSORS_PMBUS
 	  This driver can also be built as a module. If so, the module will
 	  be called pmbus.
 
+config SENSORS_MAX16064
+	tristate "Maxim MAX16064"
+	default n
+	help
+	  If you say yes here you get hardware monitoring support for Maxim
+	  MAX16064.
+
+	  This driver can also be built as a module. If so, the module will
+	  be called max16064.
+
 config SENSORS_MAX8688
 	tristate "Maxim MAX8688"
 	default n
diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
index 00c2e77..9c83d0d 100644
--- a/drivers/hwmon/Makefile
+++ b/drivers/hwmon/Makefile
@@ -115,6 +115,7 @@ obj-$(CONFIG_SENSORS_WM8350)	+= wm8350-hwmon.o
 # PMBus drivers
 obj-$(CONFIG_PMBUS)		+= pmbus_core.o
 obj-$(CONFIG_SENSORS_PMBUS)	+= pmbus.o
+obj-$(CONFIG_SENSORS_MAX16064)	+= max16064.o
 obj-$(CONFIG_SENSORS_MAX8688)	+= max8688.o
 
 ifeq ($(CONFIG_HWMON_DEBUG_CHIP),y)
diff --git a/drivers/hwmon/max16064.c b/drivers/hwmon/max16064.c
new file mode 100644
index 0000000..1d6d717
--- /dev/null
+++ b/drivers/hwmon/max16064.c
@@ -0,0 +1,91 @@
+/*
+ * Hardware monitoring driver for Maxim MAX16064
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
+static struct pmbus_driver_info max16064_info = {
+	.pages = 4,
+	.direct[PSC_VOLTAGE_IN] = true,
+	.direct[PSC_VOLTAGE_OUT] = true,
+	.direct[PSC_TEMPERATURE] = true,
+	.m[PSC_VOLTAGE_IN] = 19995,
+	.b[PSC_VOLTAGE_IN] = 0,
+	.R[PSC_VOLTAGE_IN] = -1,
+	.m[PSC_VOLTAGE_OUT] = 19995,
+	.b[PSC_VOLTAGE_OUT] = 0,
+	.R[PSC_VOLTAGE_OUT] = -1,
+	.m[PSC_TEMPERATURE] = -7612,
+	.b[PSC_TEMPERATURE] = 335,
+	.R[PSC_TEMPERATURE] = -3,
+	.func[0] = PMBUS_HAVE_VOUT | PMBUS_HAVE_TEMP
+		| PMBUS_HAVE_STATUS_VOUT | PMBUS_HAVE_STATUS_TEMP,
+	.func[1] = PMBUS_HAVE_VOUT | PMBUS_HAVE_STATUS_VOUT,
+	.func[2] = PMBUS_HAVE_VOUT | PMBUS_HAVE_STATUS_VOUT,
+	.func[3] = PMBUS_HAVE_VOUT | PMBUS_HAVE_STATUS_VOUT,
+};
+
+static int max16064_probe(struct i2c_client *client,
+			  const struct i2c_device_id *id)
+{
+	return pmbus_do_probe(client, id, &max16064_info);
+}
+
+static int max16064_remove(struct i2c_client *client)
+{
+	return pmbus_do_remove(client);
+}
+
+static const struct i2c_device_id max16064_id[] = {
+	{"max16064", 0},
+	{}
+};
+
+MODULE_DEVICE_TABLE(i2c, max16064_id);
+
+/* This is the driver that will be inserted */
+static struct i2c_driver max16064_driver = {
+	.driver = {
+		   .name = "max16064",
+		   },
+	.probe = max16064_probe,
+	.remove = max16064_remove,
+	.id_table = max16064_id,
+};
+
+static int __init max16064_init(void)
+{
+	return i2c_add_driver(&max16064_driver);
+}
+
+static void __exit max16064_exit(void)
+{
+	i2c_del_driver(&max16064_driver);
+}
+
+MODULE_AUTHOR("Guenter Roeck");
+MODULE_DESCRIPTION("PMBus driver for Maxim MAX16064");
+MODULE_LICENSE("GPL");
+module_init(max16064_init);
+module_exit(max16064_exit);
-- 
1.7.3.1

