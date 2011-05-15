Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab1EOV2C (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 17:28:02 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59054 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061Ab1EOV16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 17:27:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=irqahxd20IHJlDhttCOqQFfDY7F/vs1llNmsVp+iMgw9BBt+mHiQLiyVcIZtOUbBSo
         Ui20hcAu9ybJU600kM30Nyk9mmuDOOG/65ITJsZRp2KNKpkXwtlDzECv7sl+tuUHGMaM
         9JDi/L7xg3uFu90q1V8egv+XHeGZ+B19dBfe8=
Date: Sun, 15 May 2011 22:31:54 +0100
From: Frederick van der Wyck <fvanderwyck@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Platform: Samsung Q10 backlight driver
Message-ID: <20110515213154.GA7935@ntl>
References: <20110221223743.GA8548@lat.lan>
 <20110222052709.GA11681@core.coreip.homeip.net>
 <20110222212703.GA7292@lat.lan>
 <20110311174329.GI16652@srcf.ucam.org>
 <20110312003930.GA32496@ntl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110312003930.GA32496@ntl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,

On Sat, Mar 12, 2011 at 12:39:30AM +0000, Frederick van der Wyck wrote:
> Hi Matthew,
> 
> > Hm. This patch makes both git-am and patch very unhappy, in that they 
> > fail to create samsung-q10.c despite it not already existing. How did 
> > you generate it?
> 
> I used git format-patch. I guess I must have done something wrong
> - I'm sorry about that. Here's a version made using diff.

Has this patch been queued for 2.6.40 release? It missed out in
2.6.39 because there was a problem with it which meant it wouldn't
apply, but the new version I sent fixed that. Here it is again.

Thanks,
Frederick

Signed-off-by: Frederick van der Wyck <fvanderwyck@gmail.com>
---
 drivers/platform/x86/Kconfig       |    7 ++
 drivers/platform/x86/Makefile      |    1 +
 drivers/platform/x86/samsung-q10.c |  179 ++++++++++++++++++++++++++++++++++++
 3 files changed, 187 insertions(+), 0 deletions(-)
 create mode 100644 drivers/platform/x86/samsung-q10.c

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 446f723..532a604 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -762,4 +762,11 @@ config INTEL_OAKTRAIL
 	  enable/disable the Camera, WiFi, BT etc. devices. If in doubt, say Y
 	  here; it will only load on supported platforms.
 
+config SAMSUNG_Q10
+	tristate "Samsung Q10 Extras"
+	select BACKLIGHT_CLASS_DEVICE
+	---help---
+          This driver provides support for backlight control on Samsung Q10
+          and some other laptops, including Dell Latitude X200.
+
 endif # X86_PLATFORM_DEVICES
diff --git a/drivers/platform/x86/Makefile b/drivers/platform/x86/Makefile
index 9058c72..fe577de 100644
--- a/drivers/platform/x86/Makefile
+++ b/drivers/platform/x86/Makefile
@@ -43,3 +43,4 @@ obj-$(CONFIG_IBM_RTL)		+= ibm_rtl.o
 obj-$(CONFIG_SAMSUNG_LAPTOP)	+= samsung-laptop.o
 obj-$(CONFIG_INTEL_MFLD_THERMAL)	+= intel_mid_thermal.o
 obj-$(CONFIG_INTEL_OAKTRAIL)	+= intel_oaktrail.o
+obj-$(CONFIG_SAMSUNG_Q10)	+= samsung-q10.o
diff --git a/drivers/platform/x86/samsung-q10.c b/drivers/platform/x86/samsung-q10.c
new file mode 100644
index 0000000..7b60c67
--- /dev/null
+++ b/drivers/platform/x86/samsung-q10.c
@@ -0,0 +1,179 @@
+/*
+ *  Driver for Samsung Q10: controls the backlight
+ *
+ *  Copyright (c) 2011 Frederick van der Wyck <fvanderwyck@gmail.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/backlight.h>
+#include <linux/i8042.h>
+#include <linux/dmi.h>
+
+#define SAMSUNGQ10_BL_MAX_INTENSITY      255
+#define SAMSUNGQ10_BL_DEFAULT_INTENSITY  185
+
+#define SAMSUNGQ10_BL_8042_CMD           0xbe
+#define SAMSUNGQ10_BL_8042_DATA          { 0x89, 0x91 }
+
+static int samsungq10_bl_brightness;
+
+static bool force;
+module_param(force, bool, 0);
+MODULE_PARM_DESC(force,
+		"Disable the DMI check and force the driver to be loaded");
+
+static int samsungq10_bl_set_intensity(struct backlight_device *bd)
+{
+
+	int brightness = bd->props.brightness;
+	unsigned char c[3] = SAMSUNGQ10_BL_8042_DATA;
+
+	c[2] = (unsigned char)brightness;
+	i8042_lock_chip();
+	i8042_command(c, (0x30 << 8) | SAMSUNGQ10_BL_8042_CMD);
+	i8042_unlock_chip();
+	samsungq10_bl_brightness = brightness;
+
+	return 0;
+}
+
+static int samsungq10_bl_get_intensity(struct backlight_device *bd)
+{
+	return samsungq10_bl_brightness;
+}
+
+static const struct backlight_ops samsungq10_bl_ops = {
+	.get_brightness = samsungq10_bl_get_intensity,
+	.update_status	= samsungq10_bl_set_intensity,
+};
+
+#ifdef CONFIG_PM_SLEEP
+static int samsungq10_suspend(struct device *dev)
+{
+	return 0;
+}
+
+static int samsungq10_resume(struct device *dev)
+{
+
+	struct backlight_device *bd = dev_get_drvdata(dev);
+
+	samsungq10_bl_set_intensity(bd);
+	return 0;
+}
+#else
+#define samsungq10_suspend NULL
+#define samsungq10_resume  NULL
+#endif
+
+static SIMPLE_DEV_PM_OPS(samsungq10_pm_ops,
+			  samsungq10_suspend, samsungq10_resume);
+
+static int __devinit samsungq10_probe(struct platform_device *pdev)
+{
+
+	struct backlight_properties props;
+	struct backlight_device *bd;
+
+	memset(&props, 0, sizeof(struct backlight_properties));
+	props.max_brightness = SAMSUNGQ10_BL_MAX_INTENSITY;
+	bd = backlight_device_register("samsung", &pdev->dev, NULL,
+				       &samsungq10_bl_ops, &props);
+	if (IS_ERR(bd))
+		return PTR_ERR(bd);
+
+	platform_set_drvdata(pdev, bd);
+
+	bd->props.brightness = SAMSUNGQ10_BL_DEFAULT_INTENSITY;
+	samsungq10_bl_set_intensity(bd);
+
+	return 0;
+}
+
+static int __devexit samsungq10_remove(struct platform_device *pdev)
+{
+
+	struct backlight_device *bd = platform_get_drvdata(pdev);
+
+	bd->props.brightness = SAMSUNGQ10_BL_DEFAULT_INTENSITY;
+	samsungq10_bl_set_intensity(bd);
+
+	backlight_device_unregister(bd);
+
+	return 0;
+}
+
+static struct platform_driver samsungq10_driver = {
+	.driver		= {
+		.name	= KBUILD_MODNAME,
+		.owner	= THIS_MODULE,
+		.pm	= &samsungq10_pm_ops,
+	},
+	.probe		= samsungq10_probe,
+	.remove		= __devexit_p(samsungq10_remove),
+};
+
+static struct platform_device *samsungq10_device;
+
+static int __init dmi_check_callback(const struct dmi_system_id *id)
+{
+	printk(KERN_INFO KBUILD_MODNAME ": found model '%s'\n", id->ident);
+	return 0;
+}
+
+static struct dmi_system_id __initdata samsungq10_dmi_table[] = {
+	{
+		.ident = "Samsung Q10",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Samsung"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "SQ10"),
+		},
+		.callback = dmi_check_callback,
+	},
+	{
+		.ident = "Dell Latitude X200",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Computer Corporation"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "X200"),
+		},
+		.callback = dmi_check_callback,
+	},
+	{ },
+};
+MODULE_DEVICE_TABLE(dmi, samsungq10_dmi_table);
+
+static int __init samsungq10_init(void)
+{
+	if (!force && !dmi_check_system(samsungq10_dmi_table))
+		return -ENODEV;
+
+	samsungq10_device = platform_create_bundle(&samsungq10_driver,
+						   samsungq10_probe,
+						   NULL, 0, NULL, 0);
+
+	if (IS_ERR(samsungq10_device))
+		return PTR_ERR(samsungq10_device);
+
+	return 0;
+}
+
+static void __exit samsungq10_exit(void)
+{
+	platform_device_unregister(samsungq10_device);
+	platform_driver_unregister(&samsungq10_driver);
+}
+
+module_init(samsungq10_init);
+module_exit(samsungq10_exit);
+
+MODULE_AUTHOR("Frederick van der Wyck <fvanderwyck@gmail.com>");
+MODULE_DESCRIPTION("Samsung Q10 Driver");
+MODULE_LICENSE("GPL");
