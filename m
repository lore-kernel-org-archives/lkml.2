Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931Ab1CBWNq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 17:13:46 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41077 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757802Ab1CBWNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 17:13:42 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6273"; a="77449855"
From: adharmap@codeaurora.org
To: davidb@codeaurora.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        David Collins <collinsd@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Greg Kroah-Hartman <gregkh@suse.de>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linux.walleij@sterricsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [Qualcomm PM8921 MFD 1/6] mfd: pm8921: Add PMIC 8921 core driver
Date: Wed,  2 Mar 2011 14:13:16 -0800
Message-Id: <1299104001-5240-2-git-send-email-adharmap@codeaurora.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299104001-5240-1-git-send-email-adharmap@codeaurora.org>
References: <1299104001-5240-1-git-send-email-adharmap@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>

Add support for the Qualcomm PM8921 PMIC chip. The core driver
will communicate with the PMIC chip via the MSM SSBI bus.

Change-Id: I4b73e54916406fccc5286634bc0c024f0585c414
Signed-off-by: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
---
 drivers/mfd/Kconfig             |   23 +++++
 drivers/mfd/Makefile            |    1 +
 drivers/mfd/pm8921-core.c       |  172 +++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/pm8921.h      |   26 ++++++
 include/linux/mfd/pm8xxx/core.h |   66 +++++++++++++++
 5 files changed, 288 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/pm8921-core.c
 create mode 100644 include/linux/mfd/pm8921.h
 create mode 100644 include/linux/mfd/pm8xxx/core.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index fd01836..0a1bc22 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -624,6 +624,29 @@ config MFD_WL1273_CORE
 	  driver connects the radio-wl1273 V4L2 module and the wl1273
 	  audio codec.
 
+config MFD_PM8XXX
+	tristate "Support for Qualcomm PM8xxx subdevices"
+	help
+	  This option enables the usage of various Qualcomm PMIC 8xxx subdevice
+	  drivers. This is required in order to use generic PM8xxx subdevice
+	  drivers. Selecting with option will result in PM8xxx subdevice
+	  drivers being compiled by default.
+
+config MFD_PM8921_CORE
+	tristate "Qualcomm PM8921 PMIC chip"
+	depends on MSM_SSBI
+	select MFD_CORE
+	select MFD_PM8XXX
+	help
+	  If you say yes to this option, support will be included for the
+	  built-in PM8921 PMIC chip
+
+	  This is required if your board has a PM8921 and uses its features,
+	  such as: MPPs, GPIOs, regulators, interrupts, and PWM.
+
+	  Say M here if you want to include support for PM8921 chip as a module.
+	  This will build a module called "pm8921-core.ko".
+
 endif # MFD_SUPPORT
 
 menu "Multimedia Capabilities Port drivers"
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index a54e2c7..ec158da 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -83,3 +83,4 @@ obj-$(CONFIG_MFD_TPS6586X)	+= tps6586x.o
 obj-$(CONFIG_MFD_VX855)		+= vx855.o
 obj-$(CONFIG_MFD_WL1273_CORE)	+= wl1273-core.o
 obj-$(CONFIG_MFD_CS5535)	+= cs5535-mfd.o
+obj-$(CONFIG_MFD_PM8921_CORE) 	+= pm8921-core.o
diff --git a/drivers/mfd/pm8921-core.c b/drivers/mfd/pm8921-core.c
new file mode 100644
index 0000000..46ab2fc
--- /dev/null
+++ b/drivers/mfd/pm8921-core.c
@@ -0,0 +1,172 @@
+/* Copyright (c) 2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#define pr_fmt(fmt) "%s: " fmt, __func__
+
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/msm_ssbi.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/pm8921.h>
+#include <linux/mfd/pm8xxx/core.h>
+
+#define REG_HWREV		0x002  /* PMIC4 revision */
+#define REG_HWREV_2		0x0E8  /* PMIC4 revision 2 */
+
+struct pm8921 {
+	struct device *dev;
+};
+
+static int pm8921_readb(const struct device *dev, u16 addr, u8 *val)
+{
+	const struct pm8xxx_drvdata *pm8921_drvdata = dev_get_drvdata(dev);
+	const struct pm8921 *pmic = pm8921_drvdata->pm_chip_data;
+
+	return msm_ssbi_read(pmic->dev->parent, addr, val, 1);
+}
+
+static int pm8921_writeb(const struct device *dev, u16 addr, u8 val)
+{
+	const struct pm8xxx_drvdata *pm8921_drvdata = dev_get_drvdata(dev);
+	const struct pm8921 *pmic = pm8921_drvdata->pm_chip_data;
+
+	return msm_ssbi_write(pmic->dev->parent, addr, &val, 1);
+}
+
+static int pm8921_read_buf(const struct device *dev, u16 addr, u8 *buf,
+									int cnt)
+{
+	const struct pm8xxx_drvdata *pm8921_drvdata = dev_get_drvdata(dev);
+	const struct pm8921 *pmic = pm8921_drvdata->pm_chip_data;
+
+	return msm_ssbi_read(pmic->dev->parent, addr, buf, cnt);
+}
+
+static int pm8921_write_buf(const struct device *dev, u16 addr, u8 *buf,
+									int cnt)
+{
+	const struct pm8xxx_drvdata *pm8921_drvdata = dev_get_drvdata(dev);
+	const struct pm8921 *pmic = pm8921_drvdata->pm_chip_data;
+
+	return msm_ssbi_write(pmic->dev->parent, addr, buf, cnt);
+}
+
+static struct pm8xxx_drvdata pm8921_drvdata = {
+	.pmic_readb	= pm8921_readb,
+	.pmic_writeb	= pm8921_writeb,
+	.pmic_read_buf	= pm8921_read_buf,
+	.pmic_write_buf = pm8921_write_buf,
+};
+
+static int __devinit pm8921_add_subdevices(const struct pm8921_platform_data
+					   *pdata,
+					   struct pm8921 *pmic)
+{
+	return 0;
+}
+
+static int __devinit pm8921_probe(struct platform_device *pdev)
+{
+	const struct pm8921_platform_data *pdata = pdev->dev.platform_data;
+	struct pm8921 *pmic;
+	int rc;
+	u8 val;
+
+	if (!pdata) {
+		pr_err("missing platform data\n");
+		return -EINVAL;
+	}
+
+	pmic = kzalloc(sizeof(struct pm8921), GFP_KERNEL);
+	if (!pmic) {
+		pr_err("Cannot alloc pm8921 struct\n");
+		return -ENOMEM;
+	}
+
+	/* Read PMIC chip revision */
+	rc = msm_ssbi_read(pdev->dev.parent, REG_HWREV, &val, sizeof(val));
+	if (rc) {
+		pr_err("Failed to read hw rev reg %d:rc=%d\n", REG_HWREV, rc);
+		goto err_read_rev;
+	}
+	pr_info("PMIC revision:   %02X\n", val);
+
+	/* Read PMIC chip revision 2 */
+	rc = msm_ssbi_read(pdev->dev.parent, REG_HWREV_2, &val, sizeof(val));
+	if (rc) {
+		pr_err("Failed to read hw rev 2 reg %d:rc=%d\n",
+			REG_HWREV_2, rc);
+		goto err_read_rev;
+	}
+	pr_info("PMIC revision 2: %02X\n", val);
+
+	pmic->dev = &pdev->dev;
+	pm8921_drvdata.pm_chip_data = pmic;
+	platform_set_drvdata(pdev, &pm8921_drvdata);
+
+	rc = pm8921_add_subdevices(pdata, pmic);
+	if (rc) {
+		pr_err("Cannot add subdevices rc=%d\n", rc);
+		goto err;
+	}
+
+	return 0;
+
+err:
+	platform_set_drvdata(pdev, NULL);
+err_read_rev:
+	kfree(pmic);
+	return rc;
+}
+
+static int __devexit pm8921_remove(struct platform_device *pdev)
+{
+	struct pm8xxx_drvdata *drvdata;
+	struct pm8921 *pmic = NULL;
+
+	drvdata = platform_get_drvdata(pdev);
+	if (drvdata)
+		pmic = drvdata->pm_chip_data;
+	if (pmic)
+		mfd_remove_devices(pmic->dev);
+	platform_set_drvdata(pdev, NULL);
+	kfree(pmic);
+
+	return 0;
+}
+
+static struct platform_driver pm8921_driver = {
+	.probe		= pm8921_probe,
+	.remove		= __devexit_p(pm8921_remove),
+	.driver		= {
+		.name	= "pm8921-core",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init pm8921_init(void)
+{
+	return platform_driver_register(&pm8921_driver);
+}
+postcore_initcall(pm8921_init);
+
+static void __exit pm8921_exit(void)
+{
+	platform_driver_unregister(&pm8921_driver);
+}
+module_exit(pm8921_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("PMIC 8921 core driver");
+MODULE_VERSION("1.0");
+MODULE_ALIAS("platform:pm8921-core");
diff --git a/include/linux/mfd/pm8921.h b/include/linux/mfd/pm8921.h
new file mode 100644
index 0000000..17fc37b
--- /dev/null
+++ b/include/linux/mfd/pm8921.h
@@ -0,0 +1,26 @@
+/* Copyright (c) 2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+/*
+ * Qualcomm PMIC 8921 driver header file
+ *
+ */
+
+#ifndef __MFD_PM8921_H
+#define __MFD_PM8921_H
+
+#include <linux/device.h>
+
+struct pm8921_platform_data {
+	int irq_base;
+};
+
+#endif
diff --git a/include/linux/mfd/pm8xxx/core.h b/include/linux/mfd/pm8xxx/core.h
new file mode 100644
index 0000000..61f1c01
--- /dev/null
+++ b/include/linux/mfd/pm8xxx/core.h
@@ -0,0 +1,66 @@
+/* Copyright (c) 2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+/*
+ * Qualcomm PMIC 8xxx driver header file
+ *
+ */
+
+#ifndef __MFD_PM8XXX_CORE_H
+#define __MFD_PM8XXX_CORE_H
+
+#include <linux/mfd/core.h>
+
+struct pm8xxx_drvdata {
+	int	(*pmic_readb) (const struct device *dev, u16 addr, u8 *val);
+	int	(*pmic_writeb) (const struct device *dev, u16 addr, u8 val);
+	int	(*pmic_read_buf) (const struct device *dev, u16 addr, u8 *buf,
+									int n);
+	int	(*pmic_write_buf) (const struct device *dev, u16 addr, u8 *buf,
+									int n);
+	void	*pm_chip_data;
+};
+
+static inline int pm8xxx_readb(const struct device *dev, u16 addr, u8 *val)
+{
+	struct pm8xxx_drvdata *dd = dev_get_drvdata(dev);
+
+	BUG_ON(!dd);
+	return dd->pmic_readb(dev, addr, val);
+}
+
+static inline int pm8xxx_writeb(const struct device *dev, u16 addr, u8 val)
+{
+	struct pm8xxx_drvdata *dd = dev_get_drvdata(dev);
+
+	BUG_ON(!dd);
+	return dd->pmic_writeb(dev, addr, val);
+}
+
+static inline int pm8xxx_read_buf(const struct device *dev, u16 addr, u8 *buf,
+									int n)
+{
+	struct pm8xxx_drvdata *dd = dev_get_drvdata(dev);
+
+	BUG_ON(!dd);
+	return dd->pmic_read_buf(dev, addr, buf, n);
+}
+
+static inline int pm8xxx_write_buf(const struct device *dev, u16 addr, u8 *buf,
+									int n)
+{
+	struct pm8xxx_drvdata *dd = dev_get_drvdata(dev);
+
+	BUG_ON(!dd);
+	return dd->pmic_write_buf(dev, addr, buf, n);
+}
+
+#endif
-- 
1.7.1

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum
