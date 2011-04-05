Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab1DEOsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 10:48:11 -0400
Received: from smtp.nokia.com ([147.243.128.26]:50658 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753795Ab1DEOrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 10:47:48 -0400
From: Ilkka Koskinen <ilkka.koskinen@nokia.com>
To: eric.piel@tremplin-utc.net, mjg@redhat.com
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        samu.p.onkalo@nokia.com, ilkka.koskinen@nokia.com
Subject: [RFC PATCHv2 5/5] hwmon: lis3: Register hwif and remove references to global variable
Date: Tue,  5 Apr 2011 17:45:14 +0300
Message-Id: <1302014714-7334-6-git-send-email-ilkka.koskinen@nokia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1302014714-7334-1-git-send-email-ilkka.koskinen@nokia.com>
References: <1302014714-7334-1-git-send-email-ilkka.koskinen@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces an interface, which clients may allocate
new hw interface for lis3 device. In addition, the global lis3
device is removed and the devices are allocated dynamically.
That is, several lis3 devices can be supported and multiple
hw interfaces can be enabled without introducing problems.

Signed-off-by: Ilkka Koskinen <ilkka.koskinen@nokia.com>
---
 drivers/misc/lis3lv02d/lis3lv02d.c     |   30 +++++++++++++---
 drivers/misc/lis3lv02d/lis3lv02d.h     |    4 +-
 drivers/misc/lis3lv02d/lis3lv02d_i2c.c |   60 ++++++++++++++++++--------------
 drivers/misc/lis3lv02d/lis3lv02d_spi.c |   33 ++++++++++++------
 drivers/platform/x86/hp_accel.c        |   52 ++++++++++++++++-----------
 5 files changed, 113 insertions(+), 66 deletions(-)

diff --git a/drivers/misc/lis3lv02d/lis3lv02d.c b/drivers/misc/lis3lv02d/lis3lv02d.c
index 11cbe57..bec9ca3 100644
--- a/drivers/misc/lis3lv02d/lis3lv02d.c
+++ b/drivers/misc/lis3lv02d/lis3lv02d.c
@@ -85,11 +85,6 @@
 #define LIS3_DEFAULT_FUZZ_8B		1
 #define LIS3_DEFAULT_FLAT_8B		1
 
-struct lis3lv02d lis3_dev = {
-	.misc_wait   = __WAIT_QUEUE_HEAD_INITIALIZER(lis3_dev.misc_wait),
-};
-EXPORT_SYMBOL_GPL(lis3_dev);
-
 /* just like param_set_int() but does sanity-check so that it won't point
  * over the axis array size
  */
@@ -111,7 +106,8 @@ static struct kernel_param_ops param_ops_axis = {
 	.get = param_get_int,
 };
 
-module_param_array_named(axes, lis3_dev.ac.as_array, axis, NULL, 0644);
+static union axis_conversion ac;
+module_param_array_named(axes, ac.as_array, axis, NULL, 0644);
 MODULE_PARM_DESC(axes, "Axis-mapping for x,y,z directions");
 
 static s16 lis3lv02d_read_8(struct lis3lv02d *lis3, int reg)
@@ -888,6 +884,28 @@ static void lis3lv02d_8b_configure(struct lis3lv02d *lis3,
 	}
 }
 
+struct lis3lv02d *lis3_allocate_device(void)
+{
+	struct lis3lv02d *lis3;
+
+	lis3 = kzalloc(sizeof(*lis3), GFP_KERNEL);
+	if (!lis3)
+		return NULL;
+
+	init_waitqueue_head(&lis3->misc_wait);
+	memcpy(&lis3->ac.as_array, &ac.as_array,
+	       sizeof(lis3->ac.as_array));
+
+	return lis3;
+}
+EXPORT_SYMBOL(lis3_allocate_device);
+
+void lis3_free_device(struct lis3lv02d *lis3)
+{
+	kfree(lis3);
+}
+EXPORT_SYMBOL(lis3_free_device);
+
 /*
  * Initialise the accelerometer and the various subsystems.
  * Should be rather independent of the bus system.
diff --git a/drivers/misc/lis3lv02d/lis3lv02d.h b/drivers/misc/lis3lv02d/lis3lv02d.h
index 7d0f554..ef077d5 100644
--- a/drivers/misc/lis3lv02d/lis3lv02d.h
+++ b/drivers/misc/lis3lv02d/lis3lv02d.h
@@ -290,5 +290,5 @@ void lis3lv02d_joystick_disable(struct lis3lv02d *lis3);
 void lis3lv02d_poweroff(struct lis3lv02d *lis3);
 void lis3lv02d_poweron(struct lis3lv02d *lis3);
 int lis3lv02d_remove_fs(struct lis3lv02d *lis3);
-
-extern struct lis3lv02d lis3_dev;
+struct lis3lv02d *lis3_allocate_device(void);
+void lis3_free_device(struct lis3lv02d *lis3);
diff --git a/drivers/misc/lis3lv02d/lis3lv02d_i2c.c b/drivers/misc/lis3lv02d/lis3lv02d_i2c.c
index 6cdc38f..108d05d 100644
--- a/drivers/misc/lis3lv02d/lis3lv02d_i2c.c
+++ b/drivers/misc/lis3lv02d/lis3lv02d_i2c.c
@@ -104,16 +104,21 @@ static int __devinit lis3lv02d_i2c_probe(struct i2c_client *client,
 {
 	int ret = 0;
 	struct lis3lv02d_platform_data *pdata = client->dev.platform_data;
+	struct lis3lv02d *lis3;
+
+	lis3 = lis3_allocate_device();
+	if (!lis3)
+		return -ENOMEM;
 
 	if (pdata) {
 		/* Regulator control is optional */
 		if (pdata->driver_features & LIS3_USE_REGULATOR_CTRL)
-			lis3_dev.reg_ctrl = lis3_reg_ctrl;
+			lis3->reg_ctrl = lis3_reg_ctrl;
 
 		if ((pdata->driver_features & LIS3_USE_BLOCK_READ) &&
 			(i2c_check_functionality(client->adapter,
 						I2C_FUNC_SMBUS_I2C_BLOCK)))
-			lis3_dev.blkread  = lis3_i2c_blockread;
+			lis3->blkread  = lis3_i2c_blockread;
 
 		if (pdata->axis_x)
 			lis3lv02d_axis_map.x = pdata->axis_x;
@@ -131,44 +136,45 @@ static int __devinit lis3lv02d_i2c_probe(struct i2c_client *client,
 			goto fail;
 	}
 
-	if (lis3_dev.reg_ctrl) {
-		lis3_dev.regulators[0].supply = reg_vdd;
-		lis3_dev.regulators[1].supply = reg_vdd_io;
+	if (lis3->reg_ctrl) {
+		lis3->regulators[0].supply = reg_vdd;
+		lis3->regulators[1].supply = reg_vdd_io;
 		ret = regulator_bulk_get(&client->dev,
-					ARRAY_SIZE(lis3_dev.regulators),
-					lis3_dev.regulators);
+					ARRAY_SIZE(lis3->regulators),
+					lis3->regulators);
 		if (ret < 0)
 			goto fail;
 	}
 
-	lis3_dev.pdata	  = pdata;
-	lis3_dev.bus_priv = client;
-	lis3_dev.init	  = lis3_i2c_init;
-	lis3_dev.read	  = lis3_i2c_read;
-	lis3_dev.write	  = lis3_i2c_write;
-	lis3_dev.irq	  = client->irq;
-	lis3_dev.ac	  = lis3lv02d_axis_map;
-	lis3_dev.pm_dev	  = &client->dev;
+	lis3->pdata	  = pdata;
+	lis3->bus_priv	  = client;
+	lis3->init	  = lis3_i2c_init;
+	lis3->read	  = lis3_i2c_read;
+	lis3->write	  = lis3_i2c_write;
+	lis3->irq	  = client->irq;
+	lis3->ac	  = lis3lv02d_axis_map;
+	lis3->pm_dev	  = &client->dev;
 
-	i2c_set_clientdata(client, &lis3_dev);
+	i2c_set_clientdata(client, lis3);
 
 	/* Provide power over the init call */
-	if (lis3_dev.reg_ctrl)
-		lis3_reg_ctrl(&lis3_dev, LIS3_REG_ON);
+	if (lis3->reg_ctrl)
+		lis3_reg_ctrl(lis3, LIS3_REG_ON);
 
-	ret = lis3lv02d_init_device(&lis3_dev);
+	ret = lis3lv02d_init_device(lis3);
 
-	if (lis3_dev.reg_ctrl)
-		lis3_reg_ctrl(&lis3_dev, LIS3_REG_OFF);
+	if (lis3->reg_ctrl)
+		lis3_reg_ctrl(lis3, LIS3_REG_OFF);
 
 	if (ret)
 		goto fail2;
 	return 0;
 
 fail2:
-	regulator_bulk_free(ARRAY_SIZE(lis3_dev.regulators),
-				lis3_dev.regulators);
+	regulator_bulk_free(ARRAY_SIZE(lis3->regulators),
+				lis3->regulators);
 fail:
+	lis3_free_device(lis3);
 	if (pdata && pdata->release_resources)
 		pdata->release_resources();
 	return ret;
@@ -183,11 +189,13 @@ static int __devexit lis3lv02d_i2c_remove(struct i2c_client *client)
 		pdata->release_resources();
 
 	lis3lv02d_joystick_disable(lis3);
-	lis3lv02d_remove_fs(&lis3_dev);
+	lis3lv02d_remove_fs(lis3);
 
-	if (lis3_dev.reg_ctrl)
+	if (lis3->reg_ctrl)
 		regulator_bulk_free(ARRAY_SIZE(lis3->regulators),
-				lis3_dev.regulators);
+				lis3->regulators);
+
+	lis3_free_device(lis3);
 	return 0;
 }
 
diff --git a/drivers/misc/lis3lv02d/lis3lv02d_spi.c b/drivers/misc/lis3lv02d/lis3lv02d_spi.c
index b2c1be1..c078f38 100644
--- a/drivers/misc/lis3lv02d/lis3lv02d_spi.c
+++ b/drivers/misc/lis3lv02d/lis3lv02d_spi.c
@@ -61,6 +61,7 @@ static union axis_conversion lis3lv02d_axis_normal =
 static int __devinit lis302dl_spi_probe(struct spi_device *spi)
 {
 	int ret;
+	struct lis3lv02d *lis3;
 
 	spi->bits_per_word = 8;
 	spi->mode = SPI_MODE_0;
@@ -68,16 +69,24 @@ static int __devinit lis302dl_spi_probe(struct spi_device *spi)
 	if (ret < 0)
 		return ret;
 
-	lis3_dev.bus_priv	= spi;
-	lis3_dev.init		= lis3_spi_init;
-	lis3_dev.read		= lis3_spi_read;
-	lis3_dev.write		= lis3_spi_write;
-	lis3_dev.irq		= spi->irq;
-	lis3_dev.ac		= lis3lv02d_axis_normal;
-	lis3_dev.pdata		= spi->dev.platform_data;
-	spi_set_drvdata(spi, &lis3_dev);
+	lis3 = lis3_allocate_device();
+	if (!lis3)
+		return -ENOMEM;
 
-	return lis3lv02d_init_device(&lis3_dev);
+	lis3->bus_priv		= spi;
+	lis3->init		= lis3_spi_init;
+	lis3->read		= lis3_spi_read;
+	lis3->write		= lis3_spi_write;
+	lis3->irq		= spi->irq;
+	lis3->ac		= lis3lv02d_axis_normal;
+	lis3->pdata		= spi->dev.platform_data;
+	spi_set_drvdata(spi, lis3);
+
+	ret = lis3lv02d_init_device(lis3);
+	if (ret < 0)
+		lis3_free_device(lis3);
+
+	return ret;
 }
 
 static int __devexit lis302dl_spi_remove(struct spi_device *spi)
@@ -86,7 +95,9 @@ static int __devexit lis302dl_spi_remove(struct spi_device *spi)
 	lis3lv02d_joystick_disable(lis3);
 	lis3lv02d_poweroff(lis3);
 
-	return lis3lv02d_remove_fs(&lis3_dev);
+	lis3lv02d_remove_fs(lis3);
+	lis3_free_device(lis3);
+	return 0;
 }
 
 #ifdef CONFIG_PM_SLEEP
@@ -96,7 +107,7 @@ static int lis3lv02d_spi_suspend(struct device *dev)
 	struct lis3lv02d *lis3 = spi_get_drvdata(spi);
 
 	if (!lis3->pdata || !lis3->pdata->wakeup_flags)
-		lis3lv02d_poweroff(&lis3_dev);
+		lis3lv02d_poweroff(lis3);
 
 	return 0;
 }
diff --git a/drivers/platform/x86/hp_accel.c b/drivers/platform/x86/hp_accel.c
index 2148d77..fb31669 100644
--- a/drivers/platform/x86/hp_accel.c
+++ b/drivers/platform/x86/hp_accel.c
@@ -54,6 +54,8 @@ struct delayed_led_classdev {
 	void (*set_brightness)(struct delayed_led_classdev *data, enum led_brightness value);
 };
 
+struct lis3lv02d *lis3_dev;
+
 static inline void delayed_set_status_worker(struct work_struct *work)
 {
 	struct delayed_led_classdev *data =
@@ -148,7 +150,7 @@ int lis3lv02d_acpi_write(struct lis3lv02d *lis3, int reg, u8 val)
 
 static int lis3lv02d_dmi_matched(const struct dmi_system_id *dmi)
 {
-	lis3_dev.ac = *((union axis_conversion *)dmi->driver_data);
+	lis3_dev->ac = *((union axis_conversion *)dmi->driver_data);
 	pr_info("hardware type %s found\n", dmi->ident);
 
 	return 1;
@@ -240,7 +242,7 @@ static struct dmi_system_id lis3lv02d_dmi_ids[] = {
 
 static void hpled_set(struct delayed_led_classdev *led_cdev, enum led_brightness value)
 {
-	struct acpi_device *dev = lis3_dev.bus_priv;
+	struct acpi_device *dev = lis3_dev->bus_priv;
 	unsigned long long ret; /* Not used when writing */
 	union acpi_object in_obj[1];
 	struct acpi_object_list args = { 1, in_obj };
@@ -280,7 +282,7 @@ static void lis3lv02d_enum_resources(struct acpi_device *device)
 	acpi_status status;
 
 	status = acpi_walk_resources(device->handle, METHOD_NAME__CRS,
-					lis3lv02d_get_resource, &lis3_dev.irq);
+					lis3lv02d_get_resource, &lis3_dev->irq);
 	if (ACPI_FAILURE(status))
 		printk(KERN_DEBUG DRIVER_NAME ": Error getting resources\n");
 }
@@ -292,41 +294,49 @@ static int lis3lv02d_add(struct acpi_device *device)
 	if (!device)
 		return -EINVAL;
 
-	lis3_dev.bus_priv = device;
-	lis3_dev.init = lis3lv02d_acpi_init;
-	lis3_dev.read = lis3lv02d_acpi_read;
-	lis3_dev.write = lis3lv02d_acpi_write;
+	lis3_dev = lis3_allocate_device();
+	if (!lis3_dev)
+		return -ENOMEM;
+
+	lis3_dev->bus_priv = device;
+	lis3_dev->init = lis3lv02d_acpi_init;
+	lis3_dev->read = lis3lv02d_acpi_read;
+	lis3_dev->write = lis3lv02d_acpi_write;
 	strcpy(acpi_device_name(device), DRIVER_NAME);
 	strcpy(acpi_device_class(device), ACPI_MDPS_CLASS);
-	device->driver_data = &lis3_dev;
+	device->driver_data = lis3_dev;
 
 	/* obtain IRQ number of our device from ACPI */
 	lis3lv02d_enum_resources(device);
 
 	/* If possible use a "standard" axes order */
-	if (lis3_dev.ac.x && lis3_dev.ac.y && lis3_dev.ac.z) {
+	if (lis3_dev->ac.x && lis3_dev->ac.y && lis3_dev->ac.z) {
 		pr_info("Using custom axes %d,%d,%d\n",
-			lis3_dev.ac.x, lis3_dev.ac.y, lis3_dev.ac.z);
+			lis3_dev->ac.x, lis3_dev->ac.y, lis3_dev->ac.z);
 	} else if (dmi_check_system(lis3lv02d_dmi_ids) == 0) {
 		pr_info("laptop model unknown, using default axes configuration\n");
-		lis3_dev.ac = lis3lv02d_axis_normal;
+		lis3_dev->ac = lis3lv02d_axis_normal;
 	}
 
 	/* call the core layer do its init */
-	ret = lis3lv02d_init_device(&lis3_dev);
+	ret = lis3lv02d_init_device(lis3_dev);
 	if (ret)
-		return ret;
+		goto fail;
 
 	INIT_WORK(&hpled_led.work, delayed_set_status_worker);
 	ret = led_classdev_register(NULL, &hpled_led.led_classdev);
 	if (ret) {
-		lis3lv02d_joystick_disable(&lis3_dev);
-		lis3lv02d_poweroff(&lis3_dev);
+		lis3lv02d_joystick_disable(lis3_dev);
+		lis3lv02d_poweroff(lis3_dev);
 		flush_work(&hpled_led.work);
-		return ret;
+		goto fail;
 	}
 
 	return ret;
+
+fail:
+	lis3_free_device(lis3_dev);
+	return ret;
 }
 
 static int lis3lv02d_remove(struct acpi_device *device, int type)
@@ -334,13 +344,13 @@ static int lis3lv02d_remove(struct acpi_device *device, int type)
 	if (!device)
 		return -EINVAL;
 
-	lis3lv02d_joystick_disable(&lis3_dev);
-	lis3lv02d_poweroff(&lis3_dev);
+	lis3lv02d_joystick_disable(lis3_dev);
+	lis3lv02d_poweroff(lis3_dev);
 
 	led_classdev_unregister(&hpled_led.led_classdev);
 	flush_work(&hpled_led.work);
 
-	return lis3lv02d_remove_fs(&lis3_dev);
+	return lis3lv02d_remove_fs(lis3_dev);
 }
 
 
@@ -348,13 +358,13 @@ static int lis3lv02d_remove(struct acpi_device *device, int type)
 static int lis3lv02d_suspend(struct acpi_device *device, pm_message_t state)
 {
 	/* make sure the device is off when we suspend */
-	lis3lv02d_poweroff(&lis3_dev);
+	lis3lv02d_poweroff(lis3_dev);
 	return 0;
 }
 
 static int lis3lv02d_resume(struct acpi_device *device)
 {
-	lis3lv02d_poweron(&lis3_dev);
+	lis3lv02d_poweron(lis3_dev);
 	return 0;
 }
 #else
-- 
1.7.0.4

