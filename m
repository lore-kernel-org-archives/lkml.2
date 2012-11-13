Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378Ab2KMSGn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 13:06:43 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:57309 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119Ab2KMSGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 13:06:41 -0500
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: linux-i2c@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
        Till Harbaum <till@harbaum.org>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 1/2] i2c: Add possibility for user-defined (i2c-)devices for bus-drivers.
Date: Tue, 13 Nov 2012 19:06:07 +0100
Message-Id: <1352829968-4908-1-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes it possible to define i2c-devices at the kernel command line
or as a module parameter for bus-drivers which want to offer such
an functionality.

Drivers which are using it will have the a parameter named
devices with format devname1@addr1,devname2@addr2,...
e.g. devices=ds1307@0x68,pcf8563@0x51

The devices will be probed using the standard probe mechanism,
the definition of up to 8 devices is allowed.

Cc: Jean Delvare <khali@linux-fr.org>
Cc: Till Harbaum <till@harbaum.org>
Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 Documentation/i2c/instantiating-devices | 37 ++++++++++++++++++++++++++++++
 drivers/i2c/i2c-core.c                  | 40 +++++++++++++++++++++++++++++++++
 include/linux/i2c.h                     | 14 ++++++++++++
 3 files changed, 91 insertions(+)

diff --git a/Documentation/i2c/instantiating-devices b/Documentation/i2c/instantiating-devices
index abf6361..1dbfdf3 100644
--- a/Documentation/i2c/instantiating-devices
+++ b/Documentation/i2c/instantiating-devices
@@ -209,3 +209,40 @@ device driver individually, it is much more efficient, and also has the
 advantage that you do not have to reload the driver to change a setting.
 You can also instantiate the device before the driver is loaded or even
 available, and you don't need to know what driver the device needs.
+
+
+Method 5: By module parameter
+-----------------------------
+
+If you want to add the possibility for user-defined optional devices to
+your i2c-bus driver, do it like that in the source of the driver:
+
+(...)
+MODULE_PARAM_I2C_OPTIONAL_DEVICES(opt_devices);
+(...)
+
+static int i2c_my_bus_probe(...)
+{
+	(...)
+	i2c_add_adapter(&dev->adapter);
+	(...)
+
+	i2c_add_optional_devices(&dev->adapter, opt_devices);
+
+	return 0;
+}
+(...)
+
+The call to i2c_add_optional_devices() should only be done if and after
+the driver is registered. opt_devices will be used as a name for a
+static array of pointers to char (for usage with module_param_array_named()
+in the macro MODULE_PARAM_I2C_OPTIONAL_DEVICES).
+
+This interfaces offers users the possibility to define devices by using a
+module parameter. E.g.
+
+modprobe my_i2c_bus devices=ds1307@0x68,pcf8563@0x51
+
+or even at the kernel command line with
+
+my_i2c_bus.devices=ds1307@0x68,pcf8563@0x51
diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index a7edf98..7d84bc40 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -2204,6 +2204,46 @@ s32 i2c_smbus_xfer(struct i2c_adapter *adapter, u16 addr, unsigned short flags,
 }
 EXPORT_SYMBOL(i2c_smbus_xfer);
 
+void i2c_add_optional_devices(struct i2c_adapter *adapter, char **opt_devices)
+{
+	int i;
+	struct i2c_board_info i2c_info;
+	uint addr;
+	unsigned short i2c_addr[] = { 0, I2C_CLIENT_END };
+	char *at;
+
+	for (i = 0; opt_devices[i]; ++i) {
+		at = strchr(opt_devices[i], '@');
+		if (at == NULL) {
+			dev_warn(&adapter->dev,
+				"address need in device definition '%s'\n",
+				opt_devices[i]);
+			continue;
+		}
+		*at++ = 0;
+		if (kstrtouint(at, 0, &addr) || addr >= I2C_CLIENT_END) {
+			*--at = '@';
+			dev_warn(&adapter->dev,
+				"wrong address in slave definition '%s'\n",
+				opt_devices[i]);
+			continue;
+		}
+		memset(&i2c_info, 0, sizeof(struct i2c_board_info));
+		strlcpy(i2c_info.type, opt_devices[i], I2C_NAME_SIZE);
+		*--at = '@'; /* if someone uses opt_devices afterwards */
+		i2c_addr[0] = addr;
+		if (i2c_new_probed_device(adapter, &i2c_info, i2c_addr, NULL))
+			dev_info(&adapter->dev,
+				"device %s at address 0x%02x registered\n",
+				i2c_info.type, addr);
+		else
+			dev_warn(&adapter->dev,
+				"device %s at address 0x%02x not found\n",
+				i2c_info.type, addr);
+	}
+}
+EXPORT_SYMBOL(i2c_add_optional_devices);
+
 MODULE_AUTHOR("Simon G. Vogl <simon@tk.uni-linz.ac.at>");
 MODULE_DESCRIPTION("I2C-Bus main module");
 MODULE_LICENSE("GPL");
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index 800de22..bd0cbb1 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -489,6 +489,20 @@ static inline int i2c_adapter_id(struct i2c_adapter *adap)
 }
 
 /**
+ * Used for user-defined optional devices, see
+ * Documentation/i2c/instantiating-devices about how to use it.
+ */
+
+extern void i2c_add_optional_devices(struct i2c_adapter *adapter,
+				     char **opt_devices);
+
+#define MAX_OPTIONAL_I2C_DEVICES 8
+#define MODULE_PARAM_I2C_OPTIONAL_DEVICES(_opt_devices) \
+	static char *_opt_devices[MAX_OPTIONAL_I2C_DEVICES]; \
+	module_param_array_named(devices, _opt_devices, charp, NULL, 0); \
+	MODULE_PARM_DESC(devices, "devname1@adr1,... (e.g. ds1307@0x68)")
+
+/**
  * module_i2c_driver() - Helper macro for registering a I2C driver
  * @__i2c_driver: i2c_driver struct
  *
-- 
1.7.11.7

