Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009Ab2CLRfh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 13:35:37 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49090 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab2CLRff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 13:35:35 -0400
Subject: [PATCH] Added backlight driver for Acer Aspire 4736
From: Pradeep Subrahmanion <subrahmanion.pradeep@gmail.com>
To: rpurdie@rpsys.net
Cc: FlorianSchandinat@gmx.de, akpm@linux-foundation.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Mar 2012 23:12:17 -0400
Message-ID: <1331608337.2267.67.camel@debian.Gayathri>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi ,

  Brightness control was not  working on Acer Aspire 4736 using default ACPI interface.  acer-acpi also do not support 4730 series since it uses new WMI interface.
This driver adds brightness control by accessing the LBB PCI configuration register. This approach may also work on other laptops in 4730 series .But currently ,  it is only tested  for 
Aspire 4736. 

>From 03dbda16c90278aa1c088e5208bd99ac3c76f911 Mon Sep 17 00:00:00 2001
From: Pradeep Subrahmanion <subrahmanion.pradeep@gmail.com>
Date: Mon, 12 Mar 2012 23:08:20 -0400
Subject: [PATCH] Added backlight driver for Acer Aspire 4736

Added backlight driver for Acer Aspire 4736

Signed-off-by: Pradeep Subrahmanion <subrahmanion.pradeep@gmail.com>
---
 drivers/video/backlight/acer4736_bl.c |  110 +++++++++++++++++++++++++++++++++
 1 files changed, 110 insertions(+), 0 deletions(-)
 create mode 100644 drivers/video/backlight/acer4736_bl.c

diff --git a/drivers/video/backlight/acer4736_bl.c b/drivers/video/backlight/acer4736_bl.c
new file mode 100644
index 0000000..6fe2937
--- /dev/null
+++ b/drivers/video/backlight/acer4736_bl.c
@@ -0,0 +1,110 @@
+/*
+ * Backlight driver for Acer Aspire 4736
+ *
+ * Copyright (C) Pradeep Subrahmanion <subrahmanion.pradeep@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This driver uses LBB PCI configuration register to change the
+ * backlight brightness.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/backlight.h>
+#include <linux/err.h>
+#include <linux/dmi.h>
+#include <linux/io.h>
+#include <linux/pci.h>
+
+static u8 max_brightness = 0xFF;
+static u8 lbb_offset =  0xF4;
+static unsigned int device_id = 0x2a42;
+static unsigned int vendor_id = 0x8086;
+
+struct backlight_device *acer_backlight_device;
+struct pci_dev *pdev;
+
+static int acer_dmi_match(const struct dmi_system_id *id)
+{
+	printk(KERN_INFO "acer4736_bl: %s detected\n", id->ident);
+	return 1;
+}
+
+static const struct dmi_system_id __initdata acer_device_table[] = {
+{
+		.callback	= acer_dmi_match,
+		.ident		= "Aspire 4736",
+		.matches	= {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 4736"),
+		},
+	},
+	{}
+};
+static int read_brightness(struct backlight_device *bd)
+{
+	u8 result;
+	pci_read_config_byte(pdev, lbb_offset, &result);
+	return result;
+}
+
+static int update_brightness(struct backlight_device *bd)
+{
+	u8 intensity = bd->props.brightness;
+	if (intensity > max_brightness) {
+		printk(KERN_INFO "Acer4736_bl: Invalid parameter. Maximum value is %d"
+		, max_brightness);
+		return -1;
+	}
+	pci_write_config_byte(pdev, lbb_offset, intensity);
+	return 0;
+}
+static const struct  backlight_ops acer_backlight_ops = {
+	.get_brightness = read_brightness,
+	.update_status  = update_brightness,
+};
+
+static int __init acer4736_bl_init(void)
+{
+	struct backlight_properties props;
+	if (!dmi_check_system(acer_device_table))
+		return -ENODEV;
+
+	pdev = pci_get_device(vendor_id, device_id, NULL);
+
+	if (!pdev)
+		return -ENODEV;
+
+	printk(KERN_INFO "Loading Acer 4736 backlight driver\n");
+	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
+	props.max_brightness = max_brightness;
+
+	acer_backlight_device = backlight_device_register("acer_backlight",
+		NULL, NULL, &acer_backlight_ops, &props);
+	acer_backlight_device->props.max_brightness = max_brightness;
+	acer_backlight_device->props.brightness  =
+		read_brightness(acer_backlight_device);
+	backlight_update_status(acer_backlight_device);
+
+	return 0;
+}
+
+static void __exit acer4736_bl_exit(void)
+{
+	pci_dev_put(pdev);
+	backlight_device_unregister(acer_backlight_device);
+}
+
+module_init(acer4736_bl_init);
+module_exit(acer4736_bl_exit);
+
+MODULE_AUTHOR("Pradeep Subrahmanion <subrahmanion.pradeep@gmail.com>");
+MODULE_DESCRIPTION("Acer Aspire 4736 Backlight Driver");
+MODULE_LICENSE("GPL");
+MODULE_DEVICE_TABLE(dmi, acer_device_table);
-- 
1.7.2.5



------

Thanks , 

Pradeep Subrahmanion


