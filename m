Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933056Ab2FVNeO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 09:34:14 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:35897 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932987Ab2FVNc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 09:32:59 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <linux@arm.linux.org.uk>, <gregkh@linuxfoundation.org>,
        <kishon@ti.com>, <b-cousson@ti.com>, <rnayak@ti.com>,
        <tony@atomide.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <balbi@ti.com>,
        <hvaibhav@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: [RFC PATCH 01/10] drivers: usb: otg: add a new driver for omap usb2 phy
Date: Fri, 22 Jun 2012 19:02:10 +0530
Message-ID: <1340371939-23572-2-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1340371939-23572-1-git-send-email-kishon@ti.com>
References: <1340371939-23572-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All phy related programming like enabling/disabling the clocks, powering
on/off the phy is taken care of by this driver. It is also used for OTG
related functionality like srp.

This also includes device tree support for usb2 phy driver and
the documentation with device tree binding information is updated.

Cc: Felipe Balbi <balbi@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 .../devicetree/bindings/misc/omap-ocp2scp.txt      |    3 +
 Documentation/devicetree/bindings/usb/omap-usb.txt |   14 ++
 drivers/usb/otg/Kconfig                            |   17 +-
 drivers/usb/otg/Makefile                           |    1 +
 drivers/usb/otg/omap-usb2.c                        |  239 ++++++++++++++++++++
 include/linux/usb/omap_usb.h                       |   43 ++++
 include/linux/usb/phy_companion.h                  |   34 +++
 7 files changed, 347 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/usb/omap-usb.txt
 create mode 100644 drivers/usb/otg/omap-usb2.c
 create mode 100644 include/linux/usb/omap_usb.h
 create mode 100644 include/linux/usb/phy_companion.h

diff --git a/Documentation/devicetree/bindings/misc/omap-ocp2scp.txt b/Documentation/devicetree/bindings/misc/omap-ocp2scp.txt
index e9391d8..d1c7480 100644
--- a/Documentation/devicetree/bindings/misc/omap-ocp2scp.txt
+++ b/Documentation/devicetree/bindings/misc/omap-ocp2scp.txt
@@ -7,3 +7,6 @@ properties:
 
 Sub-nodes:
 All the devices connected to ocp2scp are described using sub-node to ocp2scp
+- usb2phy :
+   The binding details of usb2phy can be found in:
+   Documentation/devicetree/bindings/usb/omap-usb.txt
diff --git a/Documentation/devicetree/bindings/usb/omap-usb.txt b/Documentation/devicetree/bindings/usb/omap-usb.txt
new file mode 100644
index 0000000..1c38feb
--- /dev/null
+++ b/Documentation/devicetree/bindings/usb/omap-usb.txt
@@ -0,0 +1,14 @@
+OMAP USB PHY AND OMAP USB GLUE
+
+OMAP USB2 PHY
+
+Required properties:
+ - compatible: Should be "ti,omap-usb2"
+ - reg : Address and length of the register set for the device
+
+This is usually a subnode of ocp2scp to which it is connected.
+
+usb2phy@0x4a0ad080 {
+	compatible = "ti,omap-usb2";
+	reg = <0x4a0ad080 0x58>;
+};
diff --git a/drivers/usb/otg/Kconfig b/drivers/usb/otg/Kconfig
index e2840f1..18fb625 100644
--- a/drivers/usb/otg/Kconfig
+++ b/drivers/usb/otg/Kconfig
@@ -73,10 +73,8 @@ config TWL6030_USB
 	help
 	  Enable this to support the USB OTG transceiver on TWL6030
 	  family chips. This TWL6030 transceiver has the VBUS and ID GND
-	  and OTG SRP events capabilities. For all other transceiver functionality
-	  UTMI PHY is embedded in OMAP4430. The internal PHY configurations APIs
-	  are hooked to this driver through platform_data structure.
-	  The definition of internal PHY APIs are in the mach-omap2 layer.
+	  and OTG SRP events capabilities. For all other transceiver
+	  functionality UTMI PHY is embedded in OMAP4430.
 
 config OMAP4_USB_PHY
 	tristate "Texas Instruments OMAP4+ USB pin control driver"
@@ -91,6 +89,17 @@ config OMAP4_USB_PHY
 	  performing the above mentioned configuration, API's are added in
 	  by this children of the control module driver.
 
+config OMAP_USB2
+	tristate "OMAP USB2 PHY Driver"
+	depends on OMAP_OCP2SCP
+	depends on OMAP4_USB_PHY
+	select USB_OTG_UTILS
+	help
+	  Enable this to support the transceiver that is part of SOC. This
+	  driver takes care of all the PHY functionality apart from comparator.
+	  The USB OTG controller communicates with the comparator using this
+	  driver.
+
 config NOP_USB_XCEIV
 	tristate "NOP USB Transceiver Driver"
 	select USB_OTG_UTILS
diff --git a/drivers/usb/otg/Makefile b/drivers/usb/otg/Makefile
index 60c8c83..2f02912 100644
--- a/drivers/usb/otg/Makefile
+++ b/drivers/usb/otg/Makefile
@@ -14,6 +14,7 @@ obj-$(CONFIG_ISP1301_OMAP)	+= isp1301_omap.o
 obj-$(CONFIG_TWL4030_USB)	+= twl4030-usb.o
 obj-$(CONFIG_TWL6030_USB)	+= twl6030-usb.o
 obj-$(CONFIG_OMAP4_USB_PHY)	+= omap4-usb-phy.o
+obj-$(CONFIG_OMAP_USB2)		+= omap-usb2.o
 obj-$(CONFIG_NOP_USB_XCEIV)	+= nop-usb-xceiv.o
 obj-$(CONFIG_USB_ULPI)		+= ulpi.o
 obj-$(CONFIG_USB_ULPI_VIEWPORT)	+= ulpi_viewport.o
diff --git a/drivers/usb/otg/omap-usb2.c b/drivers/usb/otg/omap-usb2.c
new file mode 100644
index 0000000..d355570
--- /dev/null
+++ b/drivers/usb/otg/omap-usb2.c
@@ -0,0 +1,239 @@
+/*
+ * omap-usb2.c - USB PHY, talking to musb controller in OMAP.
+ *
+ * Copyright (C) 2011 Texas Instruments Incorporated - http://www.ti.com
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * Author: Kishon Vijay Abraham I <kishon@ti.com>
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/of.h>
+#include <linux/usb/omap_usb.h>
+#include <linux/usb/phy_companion.h>
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/pm_runtime.h>
+#include <linux/delay.h>
+#include <linux/mfd/omap_control.h>
+#include <linux/usb/omap4_usb_phy.h>
+
+/**
+ * omap_usb2_set_comparator - links the comparator present in the sytem with
+ *	this phy
+ * @comparator - the companion phy(comparator) for this phy
+ *
+ * The phy companion driver should call this API passing the phy_companion
+ * filled with set_vbus and start_srp to be used by usb phy.
+ *
+ * For use by phy companion driver
+ */
+void omap_usb2_set_comparator(struct phy_companion *comparator)
+{
+	struct usb_phy	*x = usb_get_phy(USB_PHY_TYPE_USB2);
+	struct omap_usb	*phy = phy_to_omapusb(x);
+
+	phy->comparator = comparator;
+}
+EXPORT_SYMBOL_GPL(omap_usb2_set_comparator);
+
+static int omap_usb_set_vbus(struct usb_otg *otg, bool enabled)
+{
+	struct omap_usb *phy = phy_to_omapusb(otg->phy);
+
+	if (!phy->comparator)
+		return -ENODEV;
+
+	return phy->comparator->set_vbus(phy->comparator, enabled);
+}
+
+static int omap_usb_start_srp(struct usb_otg *otg)
+{
+	struct omap_usb *phy = phy_to_omapusb(otg->phy);
+
+	if (!phy->comparator)
+		return -ENODEV;
+
+	return phy->comparator->start_srp(phy->comparator);
+}
+
+static int omap_usb_set_host(struct usb_otg *otg, struct usb_bus *host)
+{
+	struct usb_phy	*phy = otg->phy;
+
+	otg->host = host;
+	if (!host)
+		phy->state = OTG_STATE_UNDEFINED;
+
+	return 0;
+}
+
+static int omap_usb_set_peripheral(struct usb_otg *otg,
+		struct usb_gadget *gadget)
+{
+	struct usb_phy	*phy = otg->phy;
+
+	otg->gadget = gadget;
+	if (!gadget)
+		phy->state = OTG_STATE_UNDEFINED;
+
+	return 0;
+}
+
+static int omap_usb2_suspend(struct usb_phy *x, int suspend)
+{
+	struct omap_usb *phy = phy_to_omapusb(x);
+
+	if (suspend && !phy->is_suspended) {
+		pm_runtime_put_sync(phy->dev);
+		phy->is_suspended = 1;
+	} else if (!suspend && phy->is_suspended) {
+		pm_runtime_get_sync(phy->dev);
+		phy->is_suspended = 0;
+	}
+
+	return 0;
+}
+
+static int __devinit omap_usb2_probe(struct platform_device *pdev)
+{
+	struct omap_usb			*phy;
+	struct usb_otg			*otg;
+
+	phy = devm_kzalloc(&pdev->dev, sizeof(*phy), GFP_KERNEL);
+	if (!phy) {
+		dev_err(&pdev->dev, "unable to allocate memory for USB2 PHY\n");
+		return -ENOMEM;
+	}
+
+	otg = devm_kzalloc(&pdev->dev, sizeof(*otg), GFP_KERNEL);
+	if (!otg) {
+		dev_err(&pdev->dev, "unable to allocate memory for USB OTG\n");
+		return -ENOMEM;
+	}
+
+	phy->dev		= &pdev->dev;
+
+	phy->phy.dev		= phy->dev;
+	phy->phy.label		= "omap-usb2";
+	phy->phy.set_suspend	= omap_usb2_suspend;
+	phy->phy.otg		= otg;
+
+	phy->control_dev	= omap_control_get();
+	if (IS_ERR(phy->control_dev)) {
+		dev_err(&pdev->dev, "no control device present in system\n");
+		return PTR_ERR(phy->control_dev);
+	}
+
+	phy->is_suspended	= 1;
+	omap4_usb_phy_power(phy->control_dev, 0);
+
+	otg->set_host		= omap_usb_set_host;
+	otg->set_peripheral	= omap_usb_set_peripheral;
+	otg->set_vbus		= omap_usb_set_vbus;
+	otg->start_srp		= omap_usb_start_srp;
+	otg->phy		= &phy->phy;
+
+	phy->wkupclk = clk_get(phy->dev, "usb_phy_cm_clk32k");
+	if (IS_ERR(phy->wkupclk)) {
+		dev_err(&pdev->dev, "unable to get usb_phy_cm_clk32k\n");
+		return PTR_ERR(phy->wkupclk);
+	}
+
+	usb_add_phy(&phy->phy, USB_PHY_TYPE_USB2);
+
+	platform_set_drvdata(pdev, phy);
+
+	pm_runtime_enable(phy->dev);
+
+	return 0;
+}
+
+static int __devexit omap_usb2_remove(struct platform_device *pdev)
+{
+	struct omap_usb	*phy = platform_get_drvdata(pdev);
+
+	usb_remove_phy(&phy->phy);
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+
+static int omap_usb2_runtime_suspend(struct device *dev)
+{
+	struct platform_device	*pdev = to_platform_device(dev);
+	struct omap_usb	*phy = platform_get_drvdata(pdev);
+
+	clk_disable(phy->wkupclk);
+	omap4_usb_phy_power(phy->control_dev, 0);
+
+	return 0;
+}
+
+static int omap_usb2_runtime_resume(struct device *dev)
+{
+	struct platform_device	*pdev = to_platform_device(dev);
+	struct omap_usb	*phy = platform_get_drvdata(pdev);
+
+	omap4_usb_phy_power(phy->control_dev, 1);
+	clk_enable(phy->wkupclk);
+
+	return 0;
+}
+
+static const struct dev_pm_ops omap_usb2_pm_ops = {
+	SET_RUNTIME_PM_OPS(omap_usb2_runtime_suspend, omap_usb2_runtime_resume,
+		NULL)
+};
+
+#define DEV_PM_OPS     (&omap_usb2_pm_ops)
+#else
+#define DEV_PM_OPS     NULL
+#endif
+
+static const struct of_device_id omap_usb2_id_table[] = {
+	{ .compatible = "ti,omap-usb2" },
+	{}
+};
+MODULE_DEVICE_TABLE(of, omap_usb2_id_table);
+
+static struct platform_driver omap_usb2_driver = {
+	.probe		= omap_usb2_probe,
+	.remove		= __devexit_p(omap_usb2_remove),
+	.driver		= {
+		.name	= "omap-usb2",
+		.owner	= THIS_MODULE,
+		.pm	= DEV_PM_OPS,
+		.of_match_table = of_match_ptr(omap_usb2_id_table),
+	},
+};
+
+static int __init usb2_omap_init(void)
+{
+	return platform_driver_register(&omap_usb2_driver);
+}
+arch_initcall(usb2_omap_init);
+
+static void __exit usb2_omap_exit(void)
+{
+	platform_driver_unregister(&omap_usb2_driver);
+}
+module_exit(usb2_omap_exit);
+
+MODULE_ALIAS("platform: omap_usb2");
+MODULE_AUTHOR("Texas Instruments Inc.");
+MODULE_DESCRIPTION("OMAP USB2 PHY DRIVER");
+MODULE_LICENSE("GPLv2");
diff --git a/include/linux/usb/omap_usb.h b/include/linux/usb/omap_usb.h
new file mode 100644
index 0000000..7b7b9cd
--- /dev/null
+++ b/include/linux/usb/omap_usb.h
@@ -0,0 +1,43 @@
+/*
+ * omap_usb.h -- omap usb2 phy header file
+ *
+ * Copyright (C) 2011 Texas Instruments Incorporated - http://www.ti.com
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * Author: Kishon Vijay Abraham I <kishon@ti.com>
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef __DRIVERS_OMAP_USB2_H
+#define __DRIVERS_OMAP_USB2_H
+
+#include <linux/usb/otg.h>
+
+struct omap_usb {
+	struct usb_phy		phy;
+	struct phy_companion	*comparator;
+	struct device		*dev;
+	struct device		*control_dev;
+	struct clk		*wkupclk;
+	u8			is_suspended:1;
+};
+
+#define	phy_to_omapusb(x)	container_of((x), struct omap_usb, phy)
+
+#if defined(CONFIG_OMAP_USB2) || defined(CONFIG_OMAP_USB2_MODULE)
+void omap_usb2_set_comparator(struct phy_companion *comparator);
+#else
+static inline void omap_usb2_set_comparator(struct phy_companion *comparator)
+{
+}
+#endif
+
+#endif /* __DRIVERS_OMAP_USB_H */
diff --git a/include/linux/usb/phy_companion.h b/include/linux/usb/phy_companion.h
new file mode 100644
index 0000000..321290f
--- /dev/null
+++ b/include/linux/usb/phy_companion.h
@@ -0,0 +1,34 @@
+/*
+ * phy-companion.h -- phy companion to indicate the comparator part of PHY
+ *
+ * Copyright (C) 2011 Texas Instruments Incorporated - http://www.ti.com
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * Author: Kishon Vijay Abraham I <kishon@ti.com>
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef __DRIVERS_PHY_COMPANION_H
+#define __DRIVERS_PHY_COMPANION_H
+
+#include <linux/usb/otg.h>
+
+/* phy_companion to take care of VBUS, ID and srp capabilities */
+struct phy_companion {
+
+	/* effective for A-peripheral, ignored for B devices */
+	int	(*set_vbus)(struct phy_companion *x, bool enabled);
+
+	/* for B devices only:  start session with A-Host */
+	int	(*start_srp)(struct phy_companion *x);
+};
+
+#endif /* __DRIVERS_PHY_COMPANION_H */
-- 
1.7.5.4

