Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab1DTB1f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 21:27:35 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:40250 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754367Ab1DTB1a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 21:27:30 -0400
From: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: [PATCHv3 1/4] MFD: TPS65910: Add new mfd device for TPS65910
Date: Tue, 19 Apr 2011 20:27:26 -0500
Message-Id: <79063DC4-EC65-45B1-B0E2-C556125BCCE7@slimlogic.co.uk>
Cc: broonie@opensource.wolfsonmicro.com, lrg@ti.com, sameo@linux.intel.com,
        Graeme Gregory <gg@slimlogic.co.uk>
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1084)
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graeme Gregory <gg@slimlogic.co.uk>

The TPS65910 chip is a power management IC for multimedia and handheld
devices. It contains the following components:

- Regulators
- GPIO controller
- RTC

The tps65910 core driver is registered as a platform driver and provides
communication through I2C with the host device for the different
components.

Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
Signed-off-by: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
---
 drivers/mfd/Kconfig          |    8 +
 drivers/mfd/Makefile         |    1 +
 drivers/mfd/tps65910.c       |  161 +++++++++
 include/linux/mfd/tps65910.h |  749 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 919 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/tps65910.c
 create mode 100644 include/linux/mfd/tps65910.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index e2fea58..65930a7 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -671,6 +671,14 @@ config MFD_OMAP_USB_HOST
 	  This MFD driver does the required setup functionalities for
 	  OMAP USB Host drivers.
 
+config MFD_TPS65910
+	tristate "TPS65910 Power Management chip"
+	depends on I2C &&  GPIOLIB
+	select MFD_CORE
+	help
+	  if you say yes here you get support for the TPS65910 series of
+	  Power Management chips.
+
 endif # MFD_SUPPORT
 
 menu "Multimedia Capabilities Port drivers"
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 419caa9..3afb7ac 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -88,3 +88,4 @@ obj-$(CONFIG_MFD_VX855)		+= vx855.o
 obj-$(CONFIG_MFD_WL1273_CORE)	+= wl1273-core.o
 obj-$(CONFIG_MFD_CS5535)	+= cs5535-mfd.o
 obj-$(CONFIG_MFD_OMAP_USB_HOST)	+= omap-usb-host.o
+obj-$(CONFIG_MFD_TPS65910)	+= tps65910.o
diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
new file mode 100644
index 0000000..f13e448
--- /dev/null
+++ b/drivers/mfd/tps65910.c
@@ -0,0 +1,161 @@
+/*
+ * tps65910.c  --  TI TPS6591x
+ *
+ * Copyright 2010 Texas Instruments Inc.
+ *
+ * Author: Graeme Gregory <gg@slimlogic.co.uk>
+ * Author: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
+ *
+ *  This program is free software; you can redistribute it and/or modify it
+ *  under  the terms of the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/gpio.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/tps65910.h>
+
+static struct mfd_cell tps65910s[] = {
+	{
+		.name = "tps65910-pmic",
+	},
+	{
+		.name = "tps65910-rtc",
+	},
+	{
+		.name = "tps65910-power",
+	},
+};
+
+
+static int tps65910_i2c_read(struct tps65910 *tps65910, u8 reg,
+				  int bytes, void *dest)
+{
+	struct i2c_client *i2c = tps65910->i2c_client;
+	struct i2c_msg xfer[2];
+	int ret;
+
+	/* Write register */
+	xfer[0].addr = i2c->addr;
+	xfer[0].flags = 0;
+	xfer[0].len = 1;
+	xfer[0].buf = &reg;
+
+	/* Read data */
+	xfer[1].addr = i2c->addr;
+	xfer[1].flags = I2C_M_RD;
+	xfer[1].len = bytes;
+	xfer[1].buf = dest;
+
+	ret = i2c_transfer(i2c->adapter, xfer, 2);
+	if (ret == 2)
+		ret = 0;
+	else if (ret >= 0)
+		ret = -EIO;
+
+	return ret;
+}
+
+static int tps65910_i2c_write(struct tps65910 *tps65910, u8 reg,
+				   int bytes, void *src)
+{
+	struct i2c_client *i2c = tps65910->i2c_client;
+	/* we add 1 byte for device register */
+	u8 msg[TPS65910_MAX_REGISTER + 1];
+	int ret;
+
+	if (bytes > (TPS65910_MAX_REGISTER + 1))
+		return -EINVAL;
+
+	msg[0] = reg;
+	memcpy(&msg[1], src, bytes);
+
+	ret = i2c_master_send(i2c, msg, bytes + 1);
+	if (ret < 0)
+		return ret;
+	if (ret != bytes + 1)
+		return -EIO;
+	return 0;
+}
+
+static int tps65910_i2c_probe(struct i2c_client *i2c,
+			    const struct i2c_device_id *id)
+{
+	struct tps65910 *tps65910;
+	int ret = 0;
+
+	tps65910 = kzalloc(sizeof(struct tps65910), GFP_KERNEL);
+	if (tps65910 == NULL)
+		return -ENOMEM;
+
+	i2c_set_clientdata(i2c, tps65910);
+	tps65910->dev = &i2c->dev;
+	tps65910->i2c_client = i2c;
+	tps65910->read = tps65910_i2c_read;
+	tps65910->write = tps65910_i2c_write;
+
+	ret = mfd_add_devices(tps65910->dev, -1,
+			      tps65910s, ARRAY_SIZE(tps65910s),
+			      NULL, 0);
+	if (ret < 0)
+		goto err;
+
+	return ret;
+
+err:
+	mfd_remove_devices(tps65910->dev);
+	kfree(tps65910);
+	return ret;
+}
+
+static int tps65910_i2c_remove(struct i2c_client *i2c)
+{
+	struct tps65910 *tps65910 = i2c_get_clientdata(i2c);
+
+	mfd_remove_devices(tps65910->dev);
+	kfree(tps65910);
+
+	return 0;
+}
+
+static const struct i2c_device_id tps65910_i2c_id[] = {
+       { "tps65910", 0 },
+       { }
+};
+MODULE_DEVICE_TABLE(i2c, tps65910_i2c_id);
+
+
+static struct i2c_driver tps65910_i2c_driver = {
+	.driver = {
+		   .name = "tps65910",
+		   .owner = THIS_MODULE,
+	},
+	.probe = tps65910_i2c_probe,
+	.remove = tps65910_i2c_remove,
+	.id_table = tps65910_i2c_id,
+};
+
+static int __init tps65910_i2c_init(void)
+{
+	return i2c_add_driver(&tps65910_i2c_driver);
+}
+/* init early so consumer devices can complete system boot */
+subsys_initcall(tps65910_i2c_init);
+
+static void __exit tps65910_i2c_exit(void)
+{
+	i2c_del_driver(&tps65910_i2c_driver);
+}
+module_exit(tps65910_i2c_exit);
+
+MODULE_AUTHOR("Graeme Gregory <gg@slimlogic.co.uk>");
+MODULE_AUTHOR("Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>");
+MODULE_DESCRIPTION("TPS6591x chip family multi-function driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/mfd/tps65910.h b/include/linux/mfd/tps65910.h
new file mode 100644
index 0000000..43c8631
--- /dev/null
+++ b/include/linux/mfd/tps65910.h
@@ -0,0 +1,749 @@
+/*
+ * tps65910.h  --  TI TPS6591x
+ *
+ * Copyright 2010-2011 Texas Instruments Inc.
+ *
+ * Author: Graeme Gregory <gg@slimlogic.co.uk>
+ * Author: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
+ * Author: Arnaud Deconinck <a-deconinck@ti.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify it
+ *  under  the terms of the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#ifndef __LINUX_MFD_TPS65910_H
+#define __LINUX_MFD_TPS65910_H
+
+/*
+ * List of registers for component TPS65910
+ *
+ */
+
+#define TPS65910_SECONDS				0x0
+#define TPS65910_MINUTES				0x1
+#define TPS65910_HOURS					0x2
+#define TPS65910_DAYS					0x3
+#define TPS65910_MONTHS					0x4
+#define TPS65910_YEARS					0x5
+#define TPS65910_WEEKS					0x6
+#define TPS65910_ALARM_SECONDS				0x8
+#define TPS65910_ALARM_MINUTES				0x9
+#define TPS65910_ALARM_HOURS				0xA
+#define TPS65910_ALARM_DAYS				0xB
+#define TPS65910_ALARM_MONTHS				0xC
+#define TPS65910_ALARM_YEARS				0xD
+#define TPS65910_RTC_CTRL				0x10
+#define TPS65910_RTC_STATUS				0x11
+#define TPS65910_RTC_INTERRUPTS				0x12
+#define TPS65910_RTC_COMP_LSB				0x13
+#define TPS65910_RTC_COMP_MSB				0x14
+#define TPS65910_RTC_RES_PROG				0x15
+#define TPS65910_RTC_RESET_STATUS			0x16
+#define TPS65910_BCK1					0x17
+#define TPS65910_BCK2					0x18
+#define TPS65910_BCK3					0x19
+#define TPS65910_BCK4					0x1A
+#define TPS65910_BCK5					0x1B
+#define TPS65910_PUADEN					0x1C
+#define TPS65910_REF					0x1D
+#define TPS65910_VRTC					0x1E
+#define TPS65910_VIO					0x20
+#define TPS65910_VDD1					0x21
+#define TPS65910_VDD1_OP				0x22
+#define TPS65910_VDD1_SR				0x23
+#define TPS65910_VDD2					0x24
+#define TPS65910_VDD2_OP				0x25
+#define TPS65910_VDD2_SR				0x26
+#define TPS65910_VDD3					0x27
+#define TPS65910_VDIG1					0x30
+#define TPS65910_VDIG2					0x31
+#define TPS65910_VAUX1					0x32
+#define TPS65910_VAUX2					0x33
+#define TPS65910_VAUX33					0x34
+#define TPS65910_VMMC					0x35
+#define TPS65910_VPLL					0x36
+#define TPS65910_VDAC					0x37
+#define TPS65910_THERM					0x38
+#define TPS65910_BBCH					0x39
+#define TPS65910_DCDCCTRL				0x3E
+#define TPS65910_DEVCTRL				0x3F
+#define TPS65910_DEVCTRL2				0x40
+#define TPS65910_SLEEP_KEEP_LDO_ON			0x41
+#define TPS65910_SLEEP_KEEP_RES_ON			0x42
+#define TPS65910_SLEEP_SET_LDO_OFF			0x43
+#define TPS65910_SLEEP_SET_RES_OFF			0x44
+#define TPS65910_EN1_LDO_ASS				0x45
+#define TPS65910_EN1_SMPS_ASS				0x46
+#define TPS65910_EN2_LDO_ASS				0x47
+#define TPS65910_EN2_SMPS_ASS				0x48
+#define TPS65910_EN3_LDO_ASS				0x49
+#define TPS65910_SPARE					0x4A
+#define TPS65910_INT_STS				0x50
+#define TPS65910_INT_MSK				0x51
+#define TPS65910_INT_STS2				0x52
+#define TPS65910_INT_MSK2				0x53
+#define TPS65910_INT_STS3				0x54
+#define TPS65910_INT_MSK3				0x55
+#define TPS65910_GPIO0					0x60
+#define TPS65910_GPIO1					0x61
+#define TPS65910_GPIO2					0x62
+#define TPS65910_GPIO3					0x63
+#define TPS65910_GPIO4					0x64
+#define TPS65910_GPIO5					0x65
+#define TPS65910_JTAGVERNUM				0x80
+#define TPS65910_MAX_REGISTER				0x80
+
+/*
+ * List of register bitfields for component TPS65910
+ *
+ */
+
+
+/*Register BCK1  (0x80) register.RegisterDescription */
+#define BCK1_BCKUP_MASK					0xFF
+#define BCK1_BCKUP_SHIFT				0
+
+
+/*Register BCK2  (0x80) register.RegisterDescription */
+#define BCK2_BCKUP_MASK					0xFF
+#define BCK2_BCKUP_SHIFT				0
+
+
+/*Register BCK3  (0x80) register.RegisterDescription */
+#define BCK3_BCKUP_MASK					0xFF
+#define BCK3_BCKUP_SHIFT				0
+
+
+/*Register BCK4  (0x80) register.RegisterDescription */
+#define BCK4_BCKUP_MASK					0xFF
+#define BCK4_BCKUP_SHIFT				0
+
+
+/*Register BCK5  (0x80) register.RegisterDescription */
+#define BCK5_BCKUP_MASK					0xFF
+#define BCK5_BCKUP_SHIFT				0
+
+
+/*Register PUADEN  (0x80) register.RegisterDescription */
+#define PUADEN_EN3P_MASK				0x80
+#define PUADEN_EN3P_SHIFT				7
+#define PUADEN_I2CCTLP_MASK				0x40
+#define PUADEN_I2CCTLP_SHIFT				6
+#define PUADEN_I2CSRP_MASK				0x20
+#define PUADEN_I2CSRP_SHIFT				5
+#define PUADEN_PWRONP_MASK				0x10
+#define PUADEN_PWRONP_SHIFT				4
+#define PUADEN_SLEEPP_MASK				0x08
+#define PUADEN_SLEEPP_SHIFT				3
+#define PUADEN_PWRHOLDP_MASK				0x04
+#define PUADEN_PWRHOLDP_SHIFT				2
+#define PUADEN_BOOT1P_MASK				0x02
+#define PUADEN_BOOT1P_SHIFT				1
+#define PUADEN_BOOT0P_MASK				0x01
+#define PUADEN_BOOT0P_SHIFT				0
+
+
+/*Register REF	(0x80) register.RegisterDescription */
+#define REF_VMBCH_SEL_MASK				0x0C
+#define REF_VMBCH_SEL_SHIFT				2
+#define REF_ST_MASK					0x03
+#define REF_ST_SHIFT					0
+
+
+/*Register VRTC  (0x80) register.RegisterDescription */
+#define VRTC_VRTC_OFFMASK_MASK				0x08
+#define VRTC_VRTC_OFFMASK_SHIFT				3
+#define VRTC_ST_MASK					0x03
+#define VRTC_ST_SHIFT					0
+
+
+/*Register VIO	(0x80) register.RegisterDescription */
+#define VIO_ILMAX_MASK					0xC0
+#define VIO_ILMAX_SHIFT					6
+#define VIO_SEL_MASK					0x0C
+#define VIO_SEL_SHIFT					2
+#define VIO_ST_MASK					0x03
+#define VIO_ST_SHIFT					0
+
+
+/*Register VDD1  (0x80) register.RegisterDescription */
+#define VDD1_VGAIN_SEL_MASK				0xC0
+#define VDD1_VGAIN_SEL_SHIFT				6
+#define VDD1_ILMAX_MASK					0x20
+#define VDD1_ILMAX_SHIFT				5
+#define VDD1_TSTEP_MASK					0x1C
+#define VDD1_TSTEP_SHIFT				2
+#define VDD1_ST_MASK					0x03
+#define VDD1_ST_SHIFT					0
+
+
+/*Register VDD1_OP  (0x80) register.RegisterDescription */
+#define VDD1_OP_CMD_MASK				0x80
+#define VDD1_OP_CMD_SHIFT				7
+#define VDD1_OP_SEL_MASK				0x7F
+#define VDD1_OP_SEL_SHIFT				0
+
+
+/*Register VDD1_SR  (0x80) register.RegisterDescription */
+#define VDD1_SR_SEL_MASK				0x7F
+#define VDD1_SR_SEL_SHIFT				0
+
+
+/*Register VDD2  (0x80) register.RegisterDescription */
+#define VDD2_VGAIN_SEL_MASK				0xC0
+#define VDD2_VGAIN_SEL_SHIFT				6
+#define VDD2_ILMAX_MASK					0x20
+#define VDD2_ILMAX_SHIFT				5
+#define VDD2_TSTEP_MASK					0x1C
+#define VDD2_TSTEP_SHIFT				2
+#define VDD2_ST_MASK					0x03
+#define VDD2_ST_SHIFT					0
+
+
+/*Register VDD2_OP  (0x80) register.RegisterDescription */
+#define VDD2_OP_CMD_MASK				0x80
+#define VDD2_OP_CMD_SHIFT				7
+#define VDD2_OP_SEL_MASK				0x7F
+#define VDD2_OP_SEL_SHIFT				0
+
+
+/*Register VDD2_SR  (0x80) register.RegisterDescription */
+#define VDD2_SR_SEL_MASK				0x7F
+#define VDD2_SR_SEL_SHIFT				0
+
+
+/*Register VDD3  (0x80) register.RegisterDescription */
+#define VDD3_CKINEN_MASK				0x04
+#define VDD3_CKINEN_SHIFT				2
+#define VDD3_ST_MASK					0x03
+#define VDD3_ST_SHIFT					0
+
+
+/*Register VDIG1  (0x80) register.RegisterDescription */
+#define VDIG1_SEL_MASK					0x0C
+#define VDIG1_SEL_SHIFT					2
+#define VDIG1_ST_MASK					0x03
+#define VDIG1_ST_SHIFT					0
+
+
+/*Register VDIG2  (0x80) register.RegisterDescription */
+#define VDIG2_SEL_MASK					0x0C
+#define VDIG2_SEL_SHIFT					2
+#define VDIG2_ST_MASK					0x03
+#define VDIG2_ST_SHIFT					0
+
+
+/*Register VAUX1  (0x80) register.RegisterDescription */
+#define VAUX1_SEL_MASK					0x0C
+#define VAUX1_SEL_SHIFT					2
+#define VAUX1_ST_MASK					0x03
+#define VAUX1_ST_SHIFT					0
+
+
+/*Register VAUX2  (0x80) register.RegisterDescription */
+#define VAUX2_SEL_MASK					0x0C
+#define VAUX2_SEL_SHIFT					2
+#define VAUX2_ST_MASK					0x03
+#define VAUX2_ST_SHIFT					0
+
+
+/*Register VAUX33  (0x80) register.RegisterDescription */
+#define VAUX33_SEL_MASK					0x0C
+#define VAUX33_SEL_SHIFT				2
+#define VAUX33_ST_MASK					0x03
+#define VAUX33_ST_SHIFT					0
+
+
+/*Register VMMC  (0x80) register.RegisterDescription */
+#define VMMC_SEL_MASK					0x0C
+#define VMMC_SEL_SHIFT					2
+#define VMMC_ST_MASK					0x03
+#define VMMC_ST_SHIFT					0
+
+
+/*Register VPLL  (0x80) register.RegisterDescription */
+#define VPLL_SEL_MASK					0x0C
+#define VPLL_SEL_SHIFT					2
+#define VPLL_ST_MASK					0x03
+#define VPLL_ST_SHIFT					0
+
+
+/*Register VDAC  (0x80) register.RegisterDescription */
+#define VDAC_SEL_MASK					0x0C
+#define VDAC_SEL_SHIFT					2
+#define VDAC_ST_MASK					0x03
+#define VDAC_ST_SHIFT					0
+
+
+/*Register THERM  (0x80) register.RegisterDescription */
+#define THERM_THERM_HD_MASK				0x20
+#define THERM_THERM_HD_SHIFT				5
+#define THERM_THERM_TS_MASK				0x10
+#define THERM_THERM_TS_SHIFT				4
+#define THERM_THERM_HDSEL_MASK				0x0C
+#define THERM_THERM_HDSEL_SHIFT				2
+#define THERM_RSVD1_MASK				0x02
+#define THERM_RSVD1_SHIFT				1
+#define THERM_THERM_STATE_MASK				0x01
+#define THERM_THERM_STATE_SHIFT				0
+
+
+/*Register BBCH  (0x80) register.RegisterDescription */
+#define BBCH_BBSEL_MASK					0x06
+#define BBCH_BBSEL_SHIFT				1
+#define BBCH_BBCHEN_MASK				0x01
+#define BBCH_BBCHEN_SHIFT				0
+
+
+/*Register DCDCCTRL  (0x80) register.RegisterDescription */
+#define DCDCCTRL_VDD2_PSKIP_MASK			0x20
+#define DCDCCTRL_VDD2_PSKIP_SHIFT			5
+#define DCDCCTRL_VDD1_PSKIP_MASK			0x10
+#define DCDCCTRL_VDD1_PSKIP_SHIFT			4
+#define DCDCCTRL_VIO_PSKIP_MASK				0x08
+#define DCDCCTRL_VIO_PSKIP_SHIFT			3
+#define DCDCCTRL_DCDCCKEXT_MASK				0x04
+#define DCDCCTRL_DCDCCKEXT_SHIFT			2
+#define DCDCCTRL_DCDCCKSYNC_MASK			0x03
+#define DCDCCTRL_DCDCCKSYNC_SHIFT			0
+
+
+/*Register DEVCTRL  (0x80) register.RegisterDescription */
+#define DEVCTRL_RTC_PWDN_MASK				0x40
+#define DEVCTRL_RTC_PWDN_SHIFT				6
+#define DEVCTRL_CK32K_CTRL_MASK				0x20
+#define DEVCTRL_CK32K_CTRL_SHIFT			5
+#define DEVCTRL_SR_CTL_I2C_SEL_MASK			0x10
+#define DEVCTRL_SR_CTL_I2C_SEL_SHIFT			4
+#define DEVCTRL_DEV_OFF_RST_MASK			0x08
+#define DEVCTRL_DEV_OFF_RST_SHIFT			3
+#define DEVCTRL_DEV_ON_MASK				0x04
+#define DEVCTRL_DEV_ON_SHIFT				2
+#define DEVCTRL_DEV_SLP_MASK				0x02
+#define DEVCTRL_DEV_SLP_SHIFT				1
+#define DEVCTRL_DEV_OFF_MASK				0x01
+#define DEVCTRL_DEV_OFF_SHIFT				0
+
+
+/*Register DEVCTRL2  (0x80) register.RegisterDescription */
+#define DEVCTRL2_TSLOT_LENGTH_MASK			0x30
+#define DEVCTRL2_TSLOT_LENGTH_SHIFT			4
+#define DEVCTRL2_SLEEPSIG_POL_MASK			0x08
+#define DEVCTRL2_SLEEPSIG_POL_SHIFT			3
+#define DEVCTRL2_PWON_LP_OFF_MASK			0x04
+#define DEVCTRL2_PWON_LP_OFF_SHIFT			2
+#define DEVCTRL2_PWON_LP_RST_MASK			0x02
+#define DEVCTRL2_PWON_LP_RST_SHIFT			1
+#define DEVCTRL2_IT_POL_MASK				0x01
+#define DEVCTRL2_IT_POL_SHIFT				0
+
+
+/*Register SLEEP_KEEP_LDO_ON  (0x80) register.RegisterDescription */
+#define SLEEP_KEEP_LDO_ON_VDAC_KEEPON_MASK		0x80
+#define SLEEP_KEEP_LDO_ON_VDAC_KEEPON_SHIFT		7
+#define SLEEP_KEEP_LDO_ON_VPLL_KEEPON_MASK		0x40
+#define SLEEP_KEEP_LDO_ON_VPLL_KEEPON_SHIFT		6
+#define SLEEP_KEEP_LDO_ON_VAUX33_KEEPON_MASK		0x20
+#define SLEEP_KEEP_LDO_ON_VAUX33_KEEPON_SHIFT		5
+#define SLEEP_KEEP_LDO_ON_VAUX2_KEEPON_MASK		0x10
+#define SLEEP_KEEP_LDO_ON_VAUX2_KEEPON_SHIFT		4
+#define SLEEP_KEEP_LDO_ON_VAUX1_KEEPON_MASK		0x08
+#define SLEEP_KEEP_LDO_ON_VAUX1_KEEPON_SHIFT		3
+#define SLEEP_KEEP_LDO_ON_VDIG2_KEEPON_MASK		0x04
+#define SLEEP_KEEP_LDO_ON_VDIG2_KEEPON_SHIFT		2
+#define SLEEP_KEEP_LDO_ON_VDIG1_KEEPON_MASK		0x02
+#define SLEEP_KEEP_LDO_ON_VDIG1_KEEPON_SHIFT		1
+#define SLEEP_KEEP_LDO_ON_VMMC_KEEPON_MASK		0x01
+#define SLEEP_KEEP_LDO_ON_VMMC_KEEPON_SHIFT		0
+
+
+/*Register SLEEP_KEEP_RES_ON  (0x80) register.RegisterDescription */
+#define SLEEP_KEEP_RES_ON_THERM_KEEPON_MASK		0x80
+#define SLEEP_KEEP_RES_ON_THERM_KEEPON_SHIFT		7
+#define SLEEP_KEEP_RES_ON_CLKOUT32K_KEEPON_MASK		0x40
+#define SLEEP_KEEP_RES_ON_CLKOUT32K_KEEPON_SHIFT	6
+#define SLEEP_KEEP_RES_ON_VRTC_KEEPON_MASK		0x20
+#define SLEEP_KEEP_RES_ON_VRTC_KEEPON_SHIFT		5
+#define SLEEP_KEEP_RES_ON_I2CHS_KEEPON_MASK		0x10
+#define SLEEP_KEEP_RES_ON_I2CHS_KEEPON_SHIFT		4
+#define SLEEP_KEEP_RES_ON_VDD3_KEEPON_MASK		0x08
+#define SLEEP_KEEP_RES_ON_VDD3_KEEPON_SHIFT		3
+#define SLEEP_KEEP_RES_ON_VDD2_KEEPON_MASK		0x04
+#define SLEEP_KEEP_RES_ON_VDD2_KEEPON_SHIFT		2
+#define SLEEP_KEEP_RES_ON_VDD1_KEEPON_MASK		0x02
+#define SLEEP_KEEP_RES_ON_VDD1_KEEPON_SHIFT		1
+#define SLEEP_KEEP_RES_ON_VIO_KEEPON_MASK		0x01
+#define SLEEP_KEEP_RES_ON_VIO_KEEPON_SHIFT		0
+
+
+/*Register SLEEP_SET_LDO_OFF  (0x80) register.RegisterDescription */
+#define SLEEP_SET_LDO_OFF_VDAC_SETOFF_MASK		0x80
+#define SLEEP_SET_LDO_OFF_VDAC_SETOFF_SHIFT		7
+#define SLEEP_SET_LDO_OFF_VPLL_SETOFF_MASK		0x40
+#define SLEEP_SET_LDO_OFF_VPLL_SETOFF_SHIFT		6
+#define SLEEP_SET_LDO_OFF_VAUX33_SETOFF_MASK		0x20
+#define SLEEP_SET_LDO_OFF_VAUX33_SETOFF_SHIFT		5
+#define SLEEP_SET_LDO_OFF_VAUX2_SETOFF_MASK		0x10
+#define SLEEP_SET_LDO_OFF_VAUX2_SETOFF_SHIFT		4
+#define SLEEP_SET_LDO_OFF_VAUX1_SETOFF_MASK		0x08
+#define SLEEP_SET_LDO_OFF_VAUX1_SETOFF_SHIFT		3
+#define SLEEP_SET_LDO_OFF_VDIG2_SETOFF_MASK		0x04
+#define SLEEP_SET_LDO_OFF_VDIG2_SETOFF_SHIFT		2
+#define SLEEP_SET_LDO_OFF_VDIG1_SETOFF_MASK		0x02
+#define SLEEP_SET_LDO_OFF_VDIG1_SETOFF_SHIFT		1
+#define SLEEP_SET_LDO_OFF_VMMC_SETOFF_MASK		0x01
+#define SLEEP_SET_LDO_OFF_VMMC_SETOFF_SHIFT		0
+
+
+/*Register SLEEP_SET_RES_OFF  (0x80) register.RegisterDescription */
+#define SLEEP_SET_RES_OFF_DEFAULT_VOLT_MASK		0x80
+#define SLEEP_SET_RES_OFF_DEFAULT_VOLT_SHIFT		7
+#define SLEEP_SET_RES_OFF_RSVD_MASK			0x60
+#define SLEEP_SET_RES_OFF_RSVD_SHIFT			5
+#define SLEEP_SET_RES_OFF_SPARE_SETOFF_MASK		0x10
+#define SLEEP_SET_RES_OFF_SPARE_SETOFF_SHIFT		4
+#define SLEEP_SET_RES_OFF_VDD3_SETOFF_MASK		0x08
+#define SLEEP_SET_RES_OFF_VDD3_SETOFF_SHIFT		3
+#define SLEEP_SET_RES_OFF_VDD2_SETOFF_MASK		0x04
+#define SLEEP_SET_RES_OFF_VDD2_SETOFF_SHIFT		2
+#define SLEEP_SET_RES_OFF_VDD1_SETOFF_MASK		0x02
+#define SLEEP_SET_RES_OFF_VDD1_SETOFF_SHIFT		1
+#define SLEEP_SET_RES_OFF_VIO_SETOFF_MASK		0x01
+#define SLEEP_SET_RES_OFF_VIO_SETOFF_SHIFT		0
+
+
+/*Register EN1_LDO_ASS	(0x80) register.RegisterDescription */
+#define EN1_LDO_ASS_VDAC_EN1_MASK			0x80
+#define EN1_LDO_ASS_VDAC_EN1_SHIFT			7
+#define EN1_LDO_ASS_VPLL_EN1_MASK			0x40
+#define EN1_LDO_ASS_VPLL_EN1_SHIFT			6
+#define EN1_LDO_ASS_VAUX33_EN1_MASK			0x20
+#define EN1_LDO_ASS_VAUX33_EN1_SHIFT			5
+#define EN1_LDO_ASS_VAUX2_EN1_MASK			0x10
+#define EN1_LDO_ASS_VAUX2_EN1_SHIFT			4
+#define EN1_LDO_ASS_VAUX1_EN1_MASK			0x08
+#define EN1_LDO_ASS_VAUX1_EN1_SHIFT			3
+#define EN1_LDO_ASS_VDIG2_EN1_MASK			0x04
+#define EN1_LDO_ASS_VDIG2_EN1_SHIFT			2
+#define EN1_LDO_ASS_VDIG1_EN1_MASK			0x02
+#define EN1_LDO_ASS_VDIG1_EN1_SHIFT			1
+#define EN1_LDO_ASS_VMMC_EN1_MASK			0x01
+#define EN1_LDO_ASS_VMMC_EN1_SHIFT			0
+
+
+/*Register EN1_SMPS_ASS  (0x80) register.RegisterDescription */
+#define EN1_SMPS_ASS_RSVD_MASK				0xE0
+#define EN1_SMPS_ASS_RSVD_SHIFT				5
+#define EN1_SMPS_ASS_SPARE_EN1_MASK			0x10
+#define EN1_SMPS_ASS_SPARE_EN1_SHIFT			4
+#define EN1_SMPS_ASS_VDD3_EN1_MASK			0x08
+#define EN1_SMPS_ASS_VDD3_EN1_SHIFT			3
+#define EN1_SMPS_ASS_VDD2_EN1_MASK			0x04
+#define EN1_SMPS_ASS_VDD2_EN1_SHIFT			2
+#define EN1_SMPS_ASS_VDD1_EN1_MASK			0x02
+#define EN1_SMPS_ASS_VDD1_EN1_SHIFT			1
+#define EN1_SMPS_ASS_VIO_EN1_MASK			0x01
+#define EN1_SMPS_ASS_VIO_EN1_SHIFT			0
+
+
+/*Register EN2_LDO_ASS	(0x80) register.RegisterDescription */
+#define EN2_LDO_ASS_VDAC_EN2_MASK			0x80
+#define EN2_LDO_ASS_VDAC_EN2_SHIFT			7
+#define EN2_LDO_ASS_VPLL_EN2_MASK			0x40
+#define EN2_LDO_ASS_VPLL_EN2_SHIFT			6
+#define EN2_LDO_ASS_VAUX33_EN2_MASK			0x20
+#define EN2_LDO_ASS_VAUX33_EN2_SHIFT			5
+#define EN2_LDO_ASS_VAUX2_EN2_MASK			0x10
+#define EN2_LDO_ASS_VAUX2_EN2_SHIFT			4
+#define EN2_LDO_ASS_VAUX1_EN2_MASK			0x08
+#define EN2_LDO_ASS_VAUX1_EN2_SHIFT			3
+#define EN2_LDO_ASS_VDIG2_EN2_MASK			0x04
+#define EN2_LDO_ASS_VDIG2_EN2_SHIFT			2
+#define EN2_LDO_ASS_VDIG1_EN2_MASK			0x02
+#define EN2_LDO_ASS_VDIG1_EN2_SHIFT			1
+#define EN2_LDO_ASS_VMMC_EN2_MASK			0x01
+#define EN2_LDO_ASS_VMMC_EN2_SHIFT			0
+
+
+/*Register EN2_SMPS_ASS  (0x80) register.RegisterDescription */
+#define EN2_SMPS_ASS_RSVD_MASK				0xE0
+#define EN2_SMPS_ASS_RSVD_SHIFT				5
+#define EN2_SMPS_ASS_SPARE_EN2_MASK			0x10
+#define EN2_SMPS_ASS_SPARE_EN2_SHIFT			4
+#define EN2_SMPS_ASS_VDD3_EN2_MASK			0x08
+#define EN2_SMPS_ASS_VDD3_EN2_SHIFT			3
+#define EN2_SMPS_ASS_VDD2_EN2_MASK			0x04
+#define EN2_SMPS_ASS_VDD2_EN2_SHIFT			2
+#define EN2_SMPS_ASS_VDD1_EN2_MASK			0x02
+#define EN2_SMPS_ASS_VDD1_EN2_SHIFT			1
+#define EN2_SMPS_ASS_VIO_EN2_MASK			0x01
+#define EN2_SMPS_ASS_VIO_EN2_SHIFT			0
+
+
+/*Register EN3_LDO_ASS	(0x80) register.RegisterDescription */
+#define EN3_LDO_ASS_VDAC_EN3_MASK			0x80
+#define EN3_LDO_ASS_VDAC_EN3_SHIFT			7
+#define EN3_LDO_ASS_VPLL_EN3_MASK			0x40
+#define EN3_LDO_ASS_VPLL_EN3_SHIFT			6
+#define EN3_LDO_ASS_VAUX33_EN3_MASK			0x20
+#define EN3_LDO_ASS_VAUX33_EN3_SHIFT			5
+#define EN3_LDO_ASS_VAUX2_EN3_MASK			0x10
+#define EN3_LDO_ASS_VAUX2_EN3_SHIFT			4
+#define EN3_LDO_ASS_VAUX1_EN3_MASK			0x08
+#define EN3_LDO_ASS_VAUX1_EN3_SHIFT			3
+#define EN3_LDO_ASS_VDIG2_EN3_MASK			0x04
+#define EN3_LDO_ASS_VDIG2_EN3_SHIFT			2
+#define EN3_LDO_ASS_VDIG1_EN3_MASK			0x02
+#define EN3_LDO_ASS_VDIG1_EN3_SHIFT			1
+#define EN3_LDO_ASS_VMMC_EN3_MASK			0x01
+#define EN3_LDO_ASS_VMMC_EN3_SHIFT			0
+
+
+/*Register SPARE  (0x80) register.RegisterDescription */
+#define SPARE_SPARE_MASK				0xFF
+#define SPARE_SPARE_SHIFT				0
+
+
+/*Register INT_STS  (0x80) register.RegisterDescription */
+#define INT_STS_RTC_PERIOD_IT_MASK			0x80
+#define INT_STS_RTC_PERIOD_IT_SHIFT			7
+#define INT_STS_RTC_ALARM_IT_MASK			0x40
+#define INT_STS_RTC_ALARM_IT_SHIFT			6
+#define INT_STS_HOTDIE_IT_MASK				0x20
+#define INT_STS_HOTDIE_IT_SHIFT				5
+#define INT_STS_PWRHOLD_IT_MASK				0x10
+#define INT_STS_PWRHOLD_IT_SHIFT			4
+#define INT_STS_PWRON_LP_IT_MASK			0x08
+#define INT_STS_PWRON_LP_IT_SHIFT			3
+#define INT_STS_PWRON_IT_MASK				0x04
+#define INT_STS_PWRON_IT_SHIFT				2
+#define INT_STS_VMBHI_IT_MASK				0x02
+#define INT_STS_VMBHI_IT_SHIFT				1
+#define INT_STS_VMBDCH_IT_MASK				0x01
+#define INT_STS_VMBDCH_IT_SHIFT				0
+
+
+/*Register INT_MSK  (0x80) register.RegisterDescription */
+#define INT_MSK_RTC_PERIOD_IT_MSK_MASK			0x80
+#define INT_MSK_RTC_PERIOD_IT_MSK_SHIFT			7
+#define INT_MSK_RTC_ALARM_IT_MSK_MASK			0x40
+#define INT_MSK_RTC_ALARM_IT_MSK_SHIFT			6
+#define INT_MSK_HOTDIE_IT_MSK_MASK			0x20
+#define INT_MSK_HOTDIE_IT_MSK_SHIFT			5
+#define INT_MSK_PWRHOLD_IT_MSK_MASK			0x10
+#define INT_MSK_PWRHOLD_IT_MSK_SHIFT			4
+#define INT_MSK_PWRON_LP_IT_MSK_MASK			0x08
+#define INT_MSK_PWRON_LP_IT_MSK_SHIFT			3
+#define INT_MSK_PWRON_IT_MSK_MASK			0x04
+#define INT_MSK_PWRON_IT_MSK_SHIFT			2
+#define INT_MSK_VMBHI_IT_MSK_MASK			0x02
+#define INT_MSK_VMBHI_IT_MSK_SHIFT			1
+#define INT_MSK_VMBDCH_IT_MSK_MASK			0x01
+#define INT_MSK_VMBDCH_IT_MSK_SHIFT			0
+
+
+/*Register INT_STS2  (0x80) register.RegisterDescription */
+#define INT_STS2_GPIO3_F_IT_MASK			0x80
+#define INT_STS2_GPIO3_F_IT_SHIFT			7
+#define INT_STS2_GPIO3_R_IT_MASK			0x40
+#define INT_STS2_GPIO3_R_IT_SHIFT			6
+#define INT_STS2_GPIO2_F_IT_MASK			0x20
+#define INT_STS2_GPIO2_F_IT_SHIFT			5
+#define INT_STS2_GPIO2_R_IT_MASK			0x10
+#define INT_STS2_GPIO2_R_IT_SHIFT			4
+#define INT_STS2_GPIO1_F_IT_MASK			0x08
+#define INT_STS2_GPIO1_F_IT_SHIFT			3
+#define INT_STS2_GPIO1_R_IT_MASK			0x04
+#define INT_STS2_GPIO1_R_IT_SHIFT			2
+#define INT_STS2_GPIO0_F_IT_MASK			0x02
+#define INT_STS2_GPIO0_F_IT_SHIFT			1
+#define INT_STS2_GPIO0_R_IT_MASK			0x01
+#define INT_STS2_GPIO0_R_IT_SHIFT			0
+
+
+/*Register INT_MSK2  (0x80) register.RegisterDescription */
+#define INT_MSK2_GPIO3_F_IT_MSK_MASK			0x80
+#define INT_MSK2_GPIO3_F_IT_MSK_SHIFT			7
+#define INT_MSK2_GPIO3_R_IT_MSK_MASK			0x40
+#define INT_MSK2_GPIO3_R_IT_MSK_SHIFT			6
+#define INT_MSK2_GPIO2_F_IT_MSK_MASK			0x20
+#define INT_MSK2_GPIO2_F_IT_MSK_SHIFT			5
+#define INT_MSK2_GPIO2_R_IT_MSK_MASK			0x10
+#define INT_MSK2_GPIO2_R_IT_MSK_SHIFT			4
+#define INT_MSK2_GPIO1_F_IT_MSK_MASK			0x08
+#define INT_MSK2_GPIO1_F_IT_MSK_SHIFT			3
+#define INT_MSK2_GPIO1_R_IT_MSK_MASK			0x04
+#define INT_MSK2_GPIO1_R_IT_MSK_SHIFT			2
+#define INT_MSK2_GPIO0_F_IT_MSK_MASK			0x02
+#define INT_MSK2_GPIO0_F_IT_MSK_SHIFT			1
+#define INT_MSK2_GPIO0_R_IT_MSK_MASK			0x01
+#define INT_MSK2_GPIO0_R_IT_MSK_SHIFT			0
+
+
+/*Register INT_STS3  (0x80) register.RegisterDescription */
+#define INT_STS3_GPIO5_F_IT_MASK			0x08
+#define INT_STS3_GPIO5_F_IT_SHIFT			3
+#define INT_STS3_GPIO5_R_IT_MASK			0x04
+#define INT_STS3_GPIO5_R_IT_SHIFT			2
+#define INT_STS3_GPIO4_F_IT_MASK			0x02
+#define INT_STS3_GPIO4_F_IT_SHIFT			1
+#define INT_STS3_GPIO4_R_IT_MASK			0x01
+#define INT_STS3_GPIO4_R_IT_SHIFT			0
+
+
+/*Register INT_MSK3  (0x80) register.RegisterDescription */
+#define INT_MSK3_GPIO5_F_IT_MSK_MASK			0x08
+#define INT_MSK3_GPIO5_F_IT_MSK_SHIFT			3
+#define INT_MSK3_GPIO5_R_IT_MSK_MASK			0x04
+#define INT_MSK3_GPIO5_R_IT_MSK_SHIFT			2
+#define INT_MSK3_GPIO4_F_IT_MSK_MASK			0x02
+#define INT_MSK3_GPIO4_F_IT_MSK_SHIFT			1
+#define INT_MSK3_GPIO4_R_IT_MSK_MASK			0x01
+#define INT_MSK3_GPIO4_R_IT_MSK_SHIFT			0
+
+
+/*Register GPIO0  (0x80) register.RegisterDescription */
+#define GPIO0_GPIO_DEB_MASK				0x10
+#define GPIO0_GPIO_DEB_SHIFT				4
+#define GPIO0_GPIO_PUEN_MASK				0x08
+#define GPIO0_GPIO_PUEN_SHIFT				3
+#define GPIO0_GPIO_CFG_MASK				0x04
+#define GPIO0_GPIO_CFG_SHIFT				2
+#define GPIO0_GPIO_STS_MASK				0x02
+#define GPIO0_GPIO_STS_SHIFT				1
+#define GPIO0_GPIO_SET_MASK				0x01
+#define GPIO0_GPIO_SET_SHIFT				0
+
+
+/*Register GPIO1  (0x80) register.RegisterDescription */
+#define GPIO1_GPIO_DEB_MASK				0x10
+#define GPIO1_GPIO_DEB_SHIFT				4
+#define GPIO1_GPIO_PUEN_MASK				0x08
+#define GPIO1_GPIO_PUEN_SHIFT				3
+#define GPIO1_GPIO_CFG_MASK				0x04
+#define GPIO1_GPIO_CFG_SHIFT				2
+#define GPIO1_GPIO_STS_MASK				0x02
+#define GPIO1_GPIO_STS_SHIFT				1
+#define GPIO1_GPIO_SET_MASK				0x01
+#define GPIO1_GPIO_SET_SHIFT				0
+
+
+/*Register GPIO2  (0x80) register.RegisterDescription */
+#define GPIO2_GPIO_DEB_MASK				0x10
+#define GPIO2_GPIO_DEB_SHIFT				4
+#define GPIO2_GPIO_PUEN_MASK			 	0x08
+#define GPIO2_GPIO_PUEN_SHIFT				3
+#define GPIO2_GPIO_CFG_MASK				0x04
+#define GPIO2_GPIO_CFG_SHIFT				2
+#define GPIO2_GPIO_STS_MASK				0x02
+#define GPIO2_GPIO_STS_SHIFT				1
+#define GPIO2_GPIO_SET_MASK				0x01
+#define GPIO2_GPIO_SET_SHIFT				0
+
+
+/*Register GPIO3  (0x80) register.RegisterDescription */
+#define GPIO3_GPIO_DEB_MASK				0x10
+#define GPIO3_GPIO_DEB_SHIFT				4
+#define GPIO3_GPIO_PUEN_MASK				0x08
+#define GPIO3_GPIO_PUEN_SHIFT				3
+#define GPIO3_GPIO_CFG_MASK				0x04
+#define GPIO3_GPIO_CFG_SHIFT				2
+#define GPIO3_GPIO_STS_MASK			 	0x02
+#define GPIO3_GPIO_STS_SHIFT				1
+#define GPIO3_GPIO_SET_MASK				0x01
+#define GPIO3_GPIO_SET_SHIFT				0
+
+
+/*Register GPIO4  (0x80) register.RegisterDescription */
+#define GPIO4_GPIO_DEB_MASK				0x10
+#define GPIO4_GPIO_DEB_SHIFT				4
+#define GPIO4_GPIO_PUEN_MASK				0x08
+#define GPIO4_GPIO_PUEN_SHIFT				3
+#define GPIO4_GPIO_CFG_MASK				0x04
+#define GPIO4_GPIO_CFG_SHIFT				2
+#define GPIO4_GPIO_STS_MASK				0x02
+#define GPIO4_GPIO_STS_SHIFT				1
+#define GPIO4_GPIO_SET_MASK				0x01
+#define GPIO4_GPIO_SET_SHIFT				0
+
+
+/*Register GPIO5  (0x80) register.RegisterDescription */
+#define GPIO5_GPIO_DEB_MASK				0x10
+#define GPIO5_GPIO_DEB_SHIFT				4
+#define GPIO5_GPIO_PUEN_MASK				0x08
+#define GPIO5_GPIO_PUEN_SHIFT				3
+#define GPIO5_GPIO_CFG_MASK				0x04
+#define GPIO5_GPIO_CFG_SHIFT				2
+#define GPIO5_GPIO_STS_MASK				0x02
+#define GPIO5_GPIO_STS_SHIFT				1
+#define GPIO5_GPIO_SET_MASK				0x01
+#define GPIO5_GPIO_SET_SHIFT				0
+
+
+/*Register JTAGVERNUM  (0x80) register.RegisterDescription */
+#define JTAGVERNUM_VERNUM_MASK				0x0F
+#define JTAGVERNUM_VERNUM_SHIFT				0
+
+
+/* IRQ Definitions */
+#define TPS65910_IRQ_VBAT_VMBDCH			0
+#define TPS65910_IRQ_VBAT_VMHI				1
+#define TPS65910_IRQ_PWRON				2
+#define TPS65910_IRQ_PWRON_LP				3
+#define TPS65910_IRQ_PWRHOLD				4
+#define TPS65910_IRQ_HOTDIE				5
+#define TPS65910_IRQ_RTC_ALARM				6
+#define TPS65910_IRQ_RTC_PERIOD				7
+#define TPS65910_IRQ_GPIO_R				8
+#define TPS65910_IRQ_GPIO_F				9
+#define TPS65910_NUM_IRQ				10
+
+/* GPIO Register Definitions */
+#define TPS65910_GPIO_DEB				BIT(2)
+#define TPS65910_GPIO_PUEN				BIT(3)
+#define TPS65910_GPIO_CFG				BIT(2)
+#define TPS65910_GPIO_STS				BIT(1)
+#define TPS65910_GPIO_SET				BIT(0)
+
+/**
+ * struct tps65910_board
+ * Board platform data may be used to initialize regulators.
+ */
+
+struct tps65910_board {
+	struct regulator_init_data *tps65910_pmic_init_data;
+};
+
+/**
+ * struct tps65910 - tps65910 sub-driver chip access routines
+ */
+
+struct tps65910 {
+	struct device *dev;
+	struct i2c_client *i2c_client;
+	int (*read)(struct tps65910 *tps65910, u8 reg, int size, void *dest);
+	int (*write)(struct tps65910 *tps65910, u8 reg, int size, void *src);
+
+	/* Client devices */
+	struct tps65910_pmic *pmic;
+	struct tps65910_rtc *rtc;
+	struct tps65910_power *power;
+
+	/* GPIO Handling */
+	struct gpio_chip gpio;
+
+	/* IRQ Handling */
+	struct mutex irq_lock;
+	int chip_irq;
+	int irq_base;
+	u16 irq_mask;
+};
+
+struct tps65910_platform_data {
+	int irq_base;
+};
+
+#endif /*  __LINUX_MFD_TPS65910_H */
-- 
1.7.1

