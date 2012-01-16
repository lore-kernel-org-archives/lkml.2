Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab2APJmv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 04:42:51 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36447 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628Ab2APJmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 04:42:49 -0500
Message-ID: <4F13F10F.7030606@gmail.com>
Date: Mon, 16 Jan 2012 03:42:39 -0600
From: Alejandro del Rio <scasbyte@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Rodolfo Giometti <giometti@enneenne.it>
CC: Jean Delvare <khali@linux-fr.org>, guenter.roeck@ericsson.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 2/2] hwmon: (w83627ehf) Add GPIO port 3 functionality
References: <CAPbJ=B=_Xubsni7R00kSotDQ9AE9jmhmyRV0gPkXGqAPGrNaXg@mail.gmail.com> <20120114211856.7e1b816d@endymion.delvare> <4F11FE6C.8020808@gmail.com> <20120115105300.GF3178@enneenne.com>
In-Reply-To: <20120115105300.GF3178@enneenne.com>
Content-Type: multipart/mixed;
 boundary="------------060700080003080408090306"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060700080003080408090306
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Rodolfo,

On 15-Jan-12 4:53 AM, Rodolfo Giometti wrote:
> On Sat, Jan 14, 2012 at 04:15:08PM -0600, Alejandro wrote:
>>
>> The patch looks great, and it is definitely more maintainable. I'll
>> create a patch for the w83627ehf driver and send it as soon as
>> possible. Should I make the patch for the w83627hf or wait for
>> Rodolfo???
>
> I already sent a new version of my patches... here you can find a copy
> of my message:
>
>     http://www.spinics.net/lists/lm-sensors/msg33656.html
>
> Please, ask to me whatever you need since I'd like very much these
> patches will be added to the kernel main tree! :)
>
> Ciao,
>
> Rodolfo

The patch as it is posted on "lm-sensors/msg33656.html" mailing list 
does not apply to the latest tree. After making some changes it applies 
cleanly to 3.2 tree. The issues were:

-The gpio naming convention is now "gpio-[name of the driver]" instead 
of "[name of driver]_gpio"
-Line changes in the Kconfig
-Some email addresses converted to @xxxxxxx (by the lm-sensors mailing 
list I guess)

Please look at the attachments for the new patches (I take no credit for 
the changes as it was a trivial clean-up), if you like the changes I 
would recommend starting a new thread on this list to get reviews.

Note: I couldn't test the driver because my platform has not an HF chip 
but the patch looks good so far =)

BR!

Alex

--------------060700080003080408090306
Content-Type: text/plain;
 name="0001-temporal-change.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-temporal-change.txt"

>From 932beeb80d022c5bab861ea4d8d78cd82cae0bba Mon Sep 17 00:00:00 2001
From: Alejandro del Rio <scasbyte@gmail.com>
Date: Mon, 16 Jan 2012 00:32:21 -0800
Subject: [PATCH 1/2] [temporal change]

[temporal change]


Signed-off-by: Alejandro del Rio <scasbyte@gmail.com>
---
 drivers/hwmon/w83627hf.c |  331 ++++++++++++----------------------------------
 1 files changed, 86 insertions(+), 245 deletions(-)

diff --git a/drivers/hwmon/w83627hf.c b/drivers/hwmon/w83627hf.c
index 374118f..3c29146 100644
--- a/drivers/hwmon/w83627hf.c
+++ b/drivers/hwmon/w83627hf.c
@@ -6,6 +6,8 @@
     and Mark Studebaker <mdsxyz123@yahoo.com>
     Ported to 2.6 by Bernhard C. Schrenk <clemy@clemy.org>
     Copyright (c) 2007  Jean Delvare <khali@linux-fr.org>
+    MFD support added by Rodolfo Giometti <giometti@enneenne.it>
+    Copyright (c) 2010 Rodolfo Giometti <giometti@enneenne.it>
 
     This program is free software; you can redistribute it and/or modify
     it under the terms of the GNU General Public License as published by
@@ -54,17 +56,10 @@
 #include <linux/ioport.h>
 #include <linux/acpi.h>
 #include <linux/io.h>
+#include <linux/mfd/w83627hf.h>
 #include "lm75.h"
 
-static struct platform_device *pdev;
 
-#define DRVNAME "w83627hf"
-enum chips { w83627hf, w83627thf, w83697hf, w83637hf, w83687thf };
-
-struct w83627hf_sio_data {
-	enum chips type;
-	int sioaddr;
-};
 
 static u8 force_i2c = 0x1f;
 module_param(force_i2c, byte, 0);
@@ -75,86 +70,8 @@ static bool init = 1;
 module_param(init, bool, 0);
 MODULE_PARM_DESC(init, "Set to zero to bypass chip initialization");
 
-static unsigned short force_id;
-module_param(force_id, ushort, 0);
-MODULE_PARM_DESC(force_id, "Override the detected device ID");
-
-/* modified from kernel/include/traps.c */
-#define	DEV	0x07	/* Register: Logical device select */
-
-/* logical device numbers for superio_select (below) */
-#define W83627HF_LD_FDC		0x00
-#define W83627HF_LD_PRT		0x01
-#define W83627HF_LD_UART1	0x02
-#define W83627HF_LD_UART2	0x03
-#define W83627HF_LD_KBC		0x05
-#define W83627HF_LD_CIR		0x06 /* w83627hf only */
-#define W83627HF_LD_GAME	0x07
-#define W83627HF_LD_MIDI	0x07
-#define W83627HF_LD_GPIO1	0x07
-#define W83627HF_LD_GPIO5	0x07 /* w83627thf only */
-#define W83627HF_LD_GPIO2	0x08
-#define W83627HF_LD_GPIO3	0x09
-#define W83627HF_LD_GPIO4	0x09 /* w83627thf only */
-#define W83627HF_LD_ACPI	0x0a
-#define W83627HF_LD_HWM		0x0b
-
-#define	DEVID	0x20	/* Register: Device ID */
-
-#define W83627THF_GPIO5_EN	0x30 /* w83627thf only */
-#define W83627THF_GPIO5_IOSR	0xf3 /* w83627thf only */
-#define W83627THF_GPIO5_DR	0xf4 /* w83627thf only */
-
-#define W83687THF_VID_EN	0x29 /* w83687thf only */
-#define W83687THF_VID_CFG	0xF0 /* w83687thf only */
-#define W83687THF_VID_DATA	0xF1 /* w83687thf only */
-
-static inline void
-superio_outb(struct w83627hf_sio_data *sio, int reg, int val)
-{
-	outb(reg, sio->sioaddr);
-	outb(val, sio->sioaddr + 1);
-}
-
-static inline int
-superio_inb(struct w83627hf_sio_data *sio, int reg)
-{
-	outb(reg, sio->sioaddr);
-	return inb(sio->sioaddr + 1);
-}
-
-static inline void
-superio_select(struct w83627hf_sio_data *sio, int ld)
-{
-	outb(DEV, sio->sioaddr);
-	outb(ld,  sio->sioaddr + 1);
-}
-
-static inline void
-superio_enter(struct w83627hf_sio_data *sio)
-{
-	outb(0x87, sio->sioaddr);
-	outb(0x87, sio->sioaddr);
-}
-
-static inline void
-superio_exit(struct w83627hf_sio_data *sio)
-{
-	outb(0xAA, sio->sioaddr);
-}
-
-#define W627_DEVID 0x52
-#define W627THF_DEVID 0x82
-#define W697_DEVID 0x60
-#define W637_DEVID 0x70
-#define W687THF_DEVID 0x85
-#define WINB_ACT_REG 0x30
-#define WINB_BASE_REG 0x60
 /* Constants specified below */
 
-/* Alignment of the base address */
-#define WINB_ALIGNMENT		~7
-
 /* Offset & size of I/O region we are interested in */
 #define WINB_REGION_OFFSET	5
 #define WINB_REGION_SIZE	2
@@ -394,7 +311,7 @@ static void w83627hf_init_device(struct platform_device *pdev);
 static struct platform_driver w83627hf_driver = {
 	.driver = {
 		.owner	= THIS_MODULE,
-		.name	= DRVNAME,
+		.name	= DRVNAME "_hwmon",
 	},
 	.probe		= w83627hf_probe,
 	.remove		= __devexit_p(w83627hf_remove),
@@ -1123,70 +1040,6 @@ show_name(struct device *dev, struct device_attribute *devattr, char *buf)
 }
 static DEVICE_ATTR(name, S_IRUGO, show_name, NULL);
 
-static int __init w83627hf_find(int sioaddr, unsigned short *addr,
-				struct w83627hf_sio_data *sio_data)
-{
-	int err = -ENODEV;
-	u16 val;
-
-	static const __initdata char *names[] = {
-		"W83627HF",
-		"W83627THF",
-		"W83697HF",
-		"W83637HF",
-		"W83687THF",
-	};
-
-	sio_data->sioaddr = sioaddr;
-	superio_enter(sio_data);
-	val = force_id ? force_id : superio_inb(sio_data, DEVID);
-	switch (val) {
-	case W627_DEVID:
-		sio_data->type = w83627hf;
-		break;
-	case W627THF_DEVID:
-		sio_data->type = w83627thf;
-		break;
-	case W697_DEVID:
-		sio_data->type = w83697hf;
-		break;
-	case W637_DEVID:
-		sio_data->type = w83637hf;
-		break;
-	case W687THF_DEVID:
-		sio_data->type = w83687thf;
-		break;
-	case 0xff:	/* No device at all */
-		goto exit;
-	default:
-		pr_debug(DRVNAME ": Unsupported chip (DEVID=0x%02x)\n", val);
-		goto exit;
-	}
-
-	superio_select(sio_data, W83627HF_LD_HWM);
-	val = (superio_inb(sio_data, WINB_BASE_REG) << 8) |
-	       superio_inb(sio_data, WINB_BASE_REG + 1);
-	*addr = val & WINB_ALIGNMENT;
-	if (*addr == 0) {
-		pr_warn("Base address not set, skipping\n");
-		goto exit;
-	}
-
-	val = superio_inb(sio_data, WINB_ACT_REG);
-	if (!(val & 0x01)) {
-		pr_warn("Enabling HWM logical device\n");
-		superio_outb(sio_data, WINB_ACT_REG, val | 0x01);
-	}
-
-	err = 0;
-	pr_info(DRVNAME ": Found %s chip at %#x\n",
-		names[sio_data->type], *addr);
-
- exit:
-	superio_exit(sio_data);
-	return err;
-}
-
 #define VIN_UNIT_ATTRS(_X_)	\
 	&sensor_dev_attr_in##_X_##_input.dev_attr.attr,		\
 	&sensor_dev_attr_in##_X_##_min.dev_attr.attr,		\
@@ -1265,27 +1118,81 @@ static const struct attribute_group w83627hf_group_opt = {
 	.attrs = w83627hf_attributes_opt,
 };
 
+static int w83627hf_enable_hwmon(struct w83627hf_sio_data *sio_data)
+{
+	u16 val;
+	int ret;
+
+	superio_enter(sio_data);
+
+	superio_select(sio_data, W83627HF_LD_HWM);
+
+	val = (superio_inb(sio_data, 0x60) << 8) |
+	       superio_inb(sio_data, 0x60 + 1);
+	ret = val & (~7);
+	pr_info(DRVNAME ": hwmon chip %s at %#x\n", sio_data->name, ret);
+
+	if (ret == 0) {
+		printk(KERN_WARNING DRVNAME ": Base address not set, "
+		       "skipping\n");
+		ret = -EINVAL;
+		goto exit;
+	}
+
+	val = superio_inb(sio_data, 0x30);
+	superio_outb(sio_data, 0x30, val | 0x01);
+
+exit:
+	superio_exit(sio_data);
+
+	return ret;
+}
+
+static void w83627hf_disable_hwmon(struct w83627hf_sio_data *sio_data)
+{
+	u16 val;
+
+	superio_enter(sio_data);
+
+	superio_select(sio_data, W83627HF_LD_HWM);
+
+	val = superio_inb(sio_data, 0x30);
+	superio_outb(sio_data, 0x30, val & ~0x01);
+
+	superio_exit(sio_data);
+}
+
 static int __devinit w83627hf_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
-	struct w83627hf_sio_data *sio_data = dev->platform_data;
+	struct w83627hf_sio_data *sio_data = dev->parent->platform_data;
 	struct w83627hf_data *data;
-	struct resource *res;
 	int err, i;
 
-	static const char *names[] = {
-		"w83627hf",
-		"w83627thf",
-		"w83697hf",
-		"w83637hf",
-		"w83687thf",
+	struct resource res = {
+		.start  = /* address + */ WINB_REGION_OFFSET,
+		.end    = /* address + */ WINB_REGION_OFFSET +
+						WINB_REGION_SIZE - 1,
+		.name   = DRVNAME "_hwmon",
+		.flags  = IORESOURCE_IO,
 	};
 
-	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
-	if (!request_region(res->start, WINB_REGION_SIZE, DRVNAME)) {
+	err = w83627hf_enable_hwmon(sio_data);
+	if (err < 0)
+		return err;
+
+	/* Before doing our job we should fixup ioport range */
+	res.start += err;
+	res.end += err;
+
+	err = acpi_check_resource_conflict(&res);
+	if (err)
+		goto ERROR0;
+
+	if (!request_region(res.start, WINB_REGION_SIZE, DRVNAME "_hwmon")) {
 		dev_err(dev, "Failed to request region 0x%lx-0x%lx\n",
-			(unsigned long)res->start,
-			(unsigned long)(res->start + WINB_REGION_SIZE - 1));
+			(unsigned long) res.start,
+			(unsigned long) (res.start + WINB_REGION_SIZE - 1));
 		err = -EBUSY;
 		goto ERROR0;
 	}
@@ -1294,9 +1201,9 @@ static int __devinit w83627hf_probe(struct platform_device *pdev)
 		err = -ENOMEM;
 		goto ERROR1;
 	}
-	data->addr = res->start;
+	data->addr = res.start;
 	data->type = sio_data->type;
-	data->name = names[sio_data->type];
+	data->name = sio_data->name;
 	mutex_init(&data->lock);
 	mutex_init(&data->update_lock);
 	platform_set_drvdata(pdev, data);
@@ -1429,15 +1336,20 @@ static int __devinit w83627hf_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, NULL);
 	kfree(data);
       ERROR1:
-	release_region(res->start, WINB_REGION_SIZE);
+	release_region(res.start, WINB_REGION_SIZE);
       ERROR0:
+	w83627hf_disable_hwmon(sio_data);
 	return err;
 }
 
 static int __devexit w83627hf_remove(struct platform_device *pdev)
 {
+	struct device *dev = &pdev->dev;
+	struct w83627hf_sio_data *sio_data = dev->parent->platform_data;
 	struct w83627hf_data *data = platform_get_drvdata(pdev);
-	struct resource *res;
+	unsigned int addr = data->addr;
+
+	w83627hf_disable_hwmon(sio_data);
 
 	hwmon_device_unregister(data->hwmon_dev);
 
@@ -1446,8 +1358,7 @@ static int __devexit w83627hf_remove(struct platform_device *pdev)
 	platform_set_drvdata(pdev, NULL);
 	kfree(data);
 
-	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
-	release_region(res->start, WINB_REGION_SIZE);
+	release_region(addr, WINB_REGION_SIZE);
 
 	return 0;
 }
@@ -1498,7 +1409,8 @@ static int w83627hf_read_value(struct w83627hf_data *data, u16 reg)
 
 static int __devinit w83627thf_read_gpio5(struct platform_device *pdev)
 {
-	struct w83627hf_sio_data *sio_data = pdev->dev.platform_data;
+	struct device *dev = &pdev->dev;
+	struct w83627hf_sio_data *sio_data = dev->parent->platform_data;
 	int res = 0xff, sel;
 
 	superio_enter(sio_data);
@@ -1529,7 +1441,8 @@ exit:
 
 static int __devinit w83687thf_read_vid(struct platform_device *pdev)
 {
-	struct w83627hf_sio_data *sio_data = pdev->dev.platform_data;
+	struct device *dev = &pdev->dev;
+	struct w83627hf_sio_data *sio_data = dev->parent->platform_data;
 	int res = 0xff;
 
 	superio_enter(sio_data);
@@ -1772,92 +1685,20 @@ static struct w83627hf_data *w83627hf_update_device(struct device *dev)
 	return data;
 }
 
-static int __init w83627hf_device_add(unsigned short address,
-				      const struct w83627hf_sio_data *sio_data)
-{
-	struct resource res = {
-		.start	= address + WINB_REGION_OFFSET,
-		.end	= address + WINB_REGION_OFFSET + WINB_REGION_SIZE - 1,
-		.name	= DRVNAME,
-		.flags	= IORESOURCE_IO,
-	};
-	int err;
-
-	err = acpi_check_resource_conflict(&res);
-	if (err)
-		goto exit;
-
-	pdev = platform_device_alloc(DRVNAME, address);
-	if (!pdev) {
-		err = -ENOMEM;
-		pr_err("Device allocation failed\n");
-		goto exit;
-	}
-
-	err = platform_device_add_resources(pdev, &res, 1);
-	if (err) {
-		pr_err("Device resource addition failed (%d)\n", err);
-		goto exit_device_put;
-	}
-
-	err = platform_device_add_data(pdev, sio_data,
-				       sizeof(struct w83627hf_sio_data));
-	if (err) {
-		pr_err("Platform data allocation failed\n");
-		goto exit_device_put;
-	}
-
-	err = platform_device_add(pdev);
-	if (err) {
-		pr_err("Device addition failed (%d)\n", err);
-		goto exit_device_put;
-	}
-
-	return 0;
-
-exit_device_put:
-	platform_device_put(pdev);
-exit:
-	return err;
-}
-
 static int __init sensors_w83627hf_init(void)
 {
-	int err;
-	unsigned short address;
-	struct w83627hf_sio_data sio_data;
-
-	if (w83627hf_find(0x2e, &address, &sio_data)
-	 && w83627hf_find(0x4e, &address, &sio_data))
-		return -ENODEV;
-
-	err = platform_driver_register(&w83627hf_driver);
-	if (err)
-		goto exit;
-
-	/* Sets global pdev as a side effect */
-	err = w83627hf_device_add(address, &sio_data);
-	if (err)
-		goto exit_driver;
-
-	return 0;
-
-exit_driver:
-	platform_driver_unregister(&w83627hf_driver);
-exit:
-	return err;
+	return platform_driver_register(&w83627hf_driver);
 }
 
 static void __exit sensors_w83627hf_exit(void)
 {
-	platform_device_unregister(pdev);
 	platform_driver_unregister(&w83627hf_driver);
 }
 
 MODULE_AUTHOR("Frodo Looijaard <frodol@dds.nl>, "
 	      "Philip Edelbrock <phil@netroedge.com>, "
 	      "and Mark Studebaker <mdsxyz123@yahoo.com>");
-MODULE_DESCRIPTION("W83627HF driver");
+MODULE_DESCRIPTION("W83627HF hwmon driver");
 MODULE_LICENSE("GPL");
 
 module_init(sensors_w83627hf_init);
-- 
1.7.4.1


--------------060700080003080408090306
Content-Type: text/plain;
 name="0002-temporal-change.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0002-temporal-change.txt"

>From 0aed2aee358992d46ebfc2783569a8b3c350bd63 Mon Sep 17 00:00:00 2001
From: Alejandro del Rio <scasbyte@gmail.com>
Date: Mon, 16 Jan 2012 00:33:05 -0800
Subject: [PATCH 2/2] [temporal change]

[temporal change]


Signed-off-by: Alejandro del Rio <scasbyte@gmail.com>
---
 drivers/gpio/Kconfig         |   12 +
 drivers/gpio/Makefile        |    1 +
 drivers/gpio/gpio-w83627hf.c |  492 ++++++++++++++++++++++++++++++++++++++++++
 drivers/hwmon/Kconfig        |    1 +
 4 files changed, 506 insertions(+), 0 deletions(-)
 create mode 100644 drivers/gpio/gpio-w83627hf.c

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 37c4bd1..1ada7ad 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -189,6 +189,18 @@ config GPIO_VX855
 	  additional drivers must be enabled in order to use the
 	  functionality of the device.
 
+config GPIO_W83627HF
+	tristate "Winbond W83627HF, W83627THF, W83637HF, W83687THF, W83697HF"
+	select MFD_CORE
+	select MFD_W83627HF
+	help
+	  If you say yes here you get support for the Winbond W836X7 series
+	  of sensor chips: the W83627HF, W83627THF, W83637HF, W83687THF and
+	  W83697HF.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called w83627hf.
+
 comment "I2C GPIO expanders:"
 
 config GPIO_MAX7300
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index fa10df6..48979bb 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -57,6 +57,7 @@ obj-$(CONFIG_GPIO_TWL4030)	+= gpio-twl4030.o
 obj-$(CONFIG_GPIO_UCB1400)	+= gpio-ucb1400.o
 obj-$(CONFIG_GPIO_VR41XX)	+= gpio-vr41xx.o
 obj-$(CONFIG_GPIO_VX855)	+= gpio-vx855.o
+obj-$(CONFIG_GPIO_W83627HF)	+= gpio-w83627hf.o
 obj-$(CONFIG_GPIO_WM831X)	+= gpio-wm831x.o
 obj-$(CONFIG_GPIO_WM8350)	+= gpio-wm8350.o
 obj-$(CONFIG_GPIO_WM8994)	+= gpio-wm8994.o
diff --git a/drivers/gpio/gpio-w83627hf.c b/drivers/gpio/gpio-w83627hf.c
new file mode 100644
index 0000000..934333e
--- /dev/null
+++ b/drivers/gpio/gpio-w83627hf.c
@@ -0,0 +1,492 @@
+/*
+ *  gpio-w83627hf.c - GPIO support for w83627hf chip
+ *
+ *  Copyright (c) 2010-2011  Rodolfo Giometti <giometti@enneenne.it>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+#include <linux/gpio.h>
+#include <linux/err.h>
+#include <linux/mutex.h>
+#include <linux/ioport.h>
+#include <linux/io.h>
+#include <linux/mfd/w83627hf.h>
+
+/* Constants specified below */
+
+#define W83627HF_LD_GPIO3_MUX	0x29
+#define W83627HF_LD_GPIO1_MUX	0x2a
+#define W83627HF_LD_GPIO2_MUX	0x2b
+
+static const unsigned int ngpio[] = {
+	/* port 1 - port 2 - port 3 */
+	    8 +      8 +      6,
+	    0,
+	    0,
+	    0,
+	    0,
+};
+
+struct w83627hf_data {
+	struct gpio_chip chip;
+	struct bitmap {
+		unsigned long status:1;
+	} bit[3 * 8];
+};
+
+/*
+ * Local functions
+ */
+
+static void gpio_mode(struct w83627hf_sio_data *sio,
+				unsigned int bit, unsigned int mode)
+{
+	u8 val;
+
+	val = superio_inb(sio, 0xf0);
+	if (mode == 0)
+		val &= ~(1 << bit);
+	else
+		val |= (1 << bit);
+	superio_outb(sio, 0xf0, val);
+}
+
+static int gpio_get(struct w83627hf_sio_data *sio, unsigned int bit)
+{
+	u8 val;
+
+	val = superio_inb(sio, 0xf1);
+	val &= (1 << bit);
+
+	return val;
+}
+
+static void gpio_set(struct w83627hf_sio_data *sio,
+				unsigned int bit, unsigned int status)
+{
+	u8 val;
+
+	val = superio_inb(sio, 0xf1);
+	if (status)
+		val |= (1 << bit);
+	else
+		val &= ~(1 << bit);
+	superio_outb(sio, 0xf1, val);
+}
+
+static void gpio1_enable(struct w83627hf_sio_data *sio)
+{
+	u8 val;
+
+	superio_enter(sio);
+
+	/* Select GPIO1 into pins multiplxer */
+	val = superio_inb(sio, W83627HF_LD_GPIO1_MUX);
+	superio_outb(sio, W83627HF_LD_GPIO1_MUX, val | 0xfc);
+
+	/* Enable GPIO1 */
+	superio_select(sio, W83627HF_LD_GPIO1);
+	val = superio_inb(sio, 0x30);
+	superio_outb(sio, 0x30, val | 0x01);
+
+	superio_exit(sio);
+}
+
+static void gpio1_disable(struct w83627hf_sio_data *sio)
+{
+	u8 val;
+
+	superio_enter(sio);
+
+	/* Disable GPIO1 */
+	superio_select(sio, W83627HF_LD_GPIO1);
+	val = superio_inb(sio, 0x30);
+	superio_outb(sio, 0x30, val & ~0x01);
+
+	superio_exit(sio);
+}
+
+static void gpio2_enable(struct w83627hf_sio_data *sio)
+{
+	u8 val;
+
+	superio_enter(sio);
+
+	/* Select GPIO2 into pins multiplxer */
+	val = superio_inb(sio, W83627HF_LD_GPIO1_MUX);
+	superio_outb(sio, W83627HF_LD_GPIO1_MUX, val | 0x01);
+	val = superio_inb(sio, W83627HF_LD_GPIO2_MUX);
+	superio_outb(sio, W83627HF_LD_GPIO2_MUX, val | 0xff);
+
+	/* Enable GPIO2 */
+	superio_select(sio, W83627HF_LD_GPIO2);
+	val = superio_inb(sio, 0x30);
+	superio_outb(sio, 0x30, val | 0x01);
+
+	superio_exit(sio);
+}
+
+static void gpio2_disable(struct w83627hf_sio_data *sio)
+{
+	u8 val;
+
+	superio_enter(sio);
+
+	/* Disable GPIO2 */
+	superio_select(sio, W83627HF_LD_GPIO2);
+	val = superio_inb(sio, 0x30);
+	superio_outb(sio, 0x30, val & ~0x01);
+
+	superio_exit(sio);
+}
+
+static void gpio3_enable(struct w83627hf_sio_data *sio)
+{
+	u8 val;
+
+	superio_enter(sio);
+
+	/* Select GPIO3 into pins multiplxer */
+	val = superio_inb(sio, W83627HF_LD_GPIO3_MUX);
+	superio_outb(sio, W83627HF_LD_GPIO3_MUX, val | 0xfc);
+
+	/* Enable GPIO3 */
+	superio_select(sio, W83627HF_LD_GPIO3);
+	val = superio_inb(sio, 0x30);
+	superio_outb(sio, 0x30, val | 0x01);
+
+	superio_exit(sio);
+}
+
+static void gpio3_disable(struct w83627hf_sio_data *sio)
+{
+	u8 val;
+
+	superio_enter(sio);
+
+	/* Disable GPIO3 */
+	superio_select(sio, W83627HF_LD_GPIO3);
+	val = superio_inb(sio, 0x30);
+	superio_outb(sio, 0x30, val & ~0x01);
+
+	superio_exit(sio);
+}
+
+/*
+ * GPIOs methods
+ */
+
+static int w83627hf_request(struct gpio_chip *chip, unsigned offset)
+{
+	struct device *dev = chip->dev;
+	struct w83627hf_sio_data *sio_data = dev->parent->platform_data;
+	struct w83627hf_data *data = container_of(chip,
+						struct w83627hf_data, chip);
+	struct bitmap *bit = data->bit;
+
+	switch (offset) {
+	case 0 ... 7:
+		gpio1_enable(sio_data);
+		break;
+
+	case 8 ... 15:
+		/* Port2 is currently not supported */
+		gpio2_enable(sio_data);
+		break;
+
+	case 16 ... 21:
+		gpio3_enable(sio_data);
+		break;
+
+	default:
+		BUG();
+		return -EINVAL;
+	}
+
+	bit[offset].status = 1;
+
+	return 0;
+}
+
+static void w83627hf_free(struct gpio_chip *chip, unsigned offset)
+{
+	struct device *dev = chip->dev;
+	struct w83627hf_sio_data *sio_data = dev->parent->platform_data;
+	struct w83627hf_data *data = container_of(chip,
+						struct w83627hf_data, chip);
+	struct bitmap *bit = data->bit;
+	int i;
+
+	switch (offset) {
+	case 0 ... 7:
+		bit[offset].status = 0;
+		for (i = 0; i < 8; i++)
+			if (bit[i].status)
+				break;
+		if (i == 8)
+			gpio1_disable(sio_data);
+		break;
+
+	case 8 ... 15:
+		bit[offset].status = 0;
+		for (i = 8; i < 16; i++)
+			if (bit[i].status)
+				break;
+		if (i == 16)
+			gpio2_disable(sio_data);
+		break;
+
+	case 16 ... 21:
+		bit[offset].status = 0;
+		for (i = 16; i < 22; i++)
+			if (bit[i].status)
+				break;
+		if (i == 22)
+			gpio3_disable(sio_data);
+		break;
+
+	default:
+		BUG();
+	}
+}
+
+static int w83627hf_direction_in(struct gpio_chip *chip, unsigned offset)
+{
+	struct device *dev = chip->dev;
+	struct w83627hf_sio_data *sio = dev->parent->platform_data;
+
+	superio_enter(sio);
+
+	switch (offset) {
+	case 0 ... 7:
+		superio_select(sio, W83627HF_LD_GPIO1);
+		gpio_mode(sio, offset, 1);
+		break;
+
+	case 8 ... 15:
+		superio_select(sio, W83627HF_LD_GPIO2);
+		gpio_mode(sio, offset - 8, 1);
+		break;
+
+	case 16 ... 21:
+		superio_select(sio, W83627HF_LD_GPIO3);
+		gpio_mode(sio, offset - 16, 1);
+		break;
+
+	default:
+		BUG();
+	}
+
+	superio_exit(sio);
+
+	return 0;
+}
+
+static int w83627hf_get(struct gpio_chip *chip, unsigned offset)
+{
+	struct device *dev = chip->dev;
+	struct w83627hf_sio_data *sio = dev->parent->platform_data;
+	u8 val;
+
+	superio_enter(sio);
+
+	switch (offset) {
+	case 0 ... 7:
+		superio_select(sio, W83627HF_LD_GPIO1);
+		val = gpio_get(sio, offset);
+		break;
+
+	case 8 ... 15:
+		superio_select(sio, W83627HF_LD_GPIO2);
+		val = gpio_get(sio, offset - 8);
+		break;
+
+	case 16 ... 21:
+		superio_select(sio, W83627HF_LD_GPIO3);
+		val = gpio_get(sio, offset - 16);
+		break;
+
+	default:
+		BUG();
+		val = -EINVAL;
+	}
+
+	superio_exit(sio);
+
+	return val;
+}
+
+static int w83627hf_direction_out(struct gpio_chip *chip,
+						unsigned offset, int value)
+{
+	struct device *dev = chip->dev;
+	struct w83627hf_sio_data *sio = dev->parent->platform_data;
+	int ret = 0;
+
+	superio_enter(sio);
+
+	switch (offset) {
+	case 0 ... 7:
+		superio_select(sio, W83627HF_LD_GPIO1);
+		gpio_mode(sio, offset, 0);
+		break;
+
+	case 8 ... 15:
+		superio_select(sio, W83627HF_LD_GPIO2);
+		gpio_mode(sio, offset - 8, value);
+		break;
+
+	case 16 ... 21:
+		superio_select(sio, W83627HF_LD_GPIO3);
+		gpio_mode(sio, offset - 16, value);
+		break;
+
+	default:
+		BUG();
+	}
+
+	superio_exit(sio);
+
+	return ret;
+}
+
+static void w83627hf_set(struct gpio_chip *chip, unsigned offset, int value)
+{
+	struct device *dev = chip->dev;
+	struct w83627hf_sio_data *sio = dev->parent->platform_data;
+
+	superio_enter(sio);
+
+	switch (offset) {
+	case 0 ... 7:
+		superio_select(sio, W83627HF_LD_GPIO1);
+		gpio_set(sio, offset, value);
+		break;
+
+	case 8 ... 15:
+		superio_select(sio, W83627HF_LD_GPIO2);
+		gpio_set(sio, offset - 8, value);
+		break;
+
+	case 16 ... 21:
+		superio_select(sio, W83627HF_LD_GPIO3);
+		gpio_set(sio, offset - 16, value);
+		break;
+
+	default:
+		BUG();
+	}
+
+	superio_exit(sio);
+}
+
+static int __devinit w83627hf_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct w83627hf_sio_data *sio_data = dev->parent->platform_data;
+	struct w83627hf_data *data;
+	int err;
+
+	if (ngpio[sio_data->type] == 0) {
+		dev_err(&pdev->dev, "gpio support not available "
+					"for this chip type\n");
+		return -ENODEV;
+	}
+
+	data = kzalloc(sizeof(struct w83627hf_data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+	platform_set_drvdata(pdev, data);
+
+	data->chip.base = -1;
+	data->chip.ngpio = ngpio[sio_data->type];
+	data->chip.label = sio_data->name;
+	data->chip.dev = dev;
+
+	data->chip.owner = THIS_MODULE;
+	data->chip.request = w83627hf_request;
+	data->chip.free = w83627hf_free;
+	data->chip.direction_input = w83627hf_direction_in;
+	data->chip.get = w83627hf_get;
+	data->chip.direction_output = w83627hf_direction_out;
+	data->chip.set = w83627hf_set;
+	data->chip.can_sleep = 1;
+
+	err = gpiochip_add(&data->chip);
+	if (err < 0) {
+		dev_err(&pdev->dev, "could not register gpiochip, %d\n", err);
+		goto free_platform_data;
+	}
+
+	return 0;
+
+free_platform_data:
+	kfree(data);
+	platform_set_drvdata(pdev, NULL);
+
+	return err;
+}
+
+static int __devexit w83627hf_remove(struct platform_device *pdev)
+{
+	struct w83627hf_data *data = platform_get_drvdata(pdev);
+	int err;
+
+	err = gpiochip_remove(&data->chip);
+	if (err < 0) {
+		dev_err(&pdev->dev, "could not deregister gpiochip, %d\n", err);
+		return err;
+	}
+
+	kfree(data);
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+static struct platform_driver w83627hf_driver = {
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= DRVNAME "_gpio",
+	},
+	.probe		= w83627hf_probe,
+	.remove		= __devexit_p(w83627hf_remove),
+};
+
+/*
+ * Module stuff
+ */
+
+static int __init gpio_w83627hf_init(void)
+{
+	return platform_driver_register(&w83627hf_driver);
+}
+
+static void __exit gpio_w83627hf_exit(void)
+{
+	platform_driver_unregister(&w83627hf_driver);
+}
+
+MODULE_AUTHOR("Rodolfo Giometti <giometti@enneenne.it>");
+MODULE_DESCRIPTION("W83627HF gpio driver");
+MODULE_LICENSE("GPL");
+
+module_init(gpio_w83627hf_init);
+module_exit(gpio_w83627hf_exit);
diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index cb351d3..029b8b1 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -1272,6 +1272,7 @@ config SENSORS_W83L786NG
 config SENSORS_W83627HF
 	tristate "Winbond W83627HF, W83627THF, W83637HF, W83687THF, W83697HF"
 	depends on !PPC
+	select MFD_W83627HF
 	select HWMON_VID
 	help
 	  If you say yes here you get support for the Winbond W836X7 series
-- 
1.7.4.1


--------------060700080003080408090306--
