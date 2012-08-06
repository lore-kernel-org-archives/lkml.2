Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331Ab2HFNJi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 09:09:38 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43342 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756241Ab2HFNIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 09:08:36 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <linux@arm.linux.org.uk>, <gregkh@linuxfoundation.org>,
        <b-cousson@ti.com>, <rnayak@ti.com>, <tony@atomide.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-usb@vger.kernel.org>
CC: Kishon Vijay Abraham I <kishon@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH v7 1/7] drivers: usb: phy: add a new driver for omap usb2 phy
Date: Mon, 6 Aug 2012 18:37:54 +0530
Message-ID: <1344258480-4304-2-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344258480-4304-1-git-send-email-kishon@ti.com>
References: <1344258480-4304-1-git-send-email-kishon@ti.com>
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

Currently writing to control module register is taken care in this
driver which will be removed once the control module driver is in place.

Cc: Felipe Balbi <balbi@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 .../devicetree/bindings/bus/omap-ocp2scp.txt       |    3 +
 Documentation/devicetree/bindings/usb/omap-usb.txt |   17 ++
 drivers/usb/phy/Kconfig                            |   10 +
 drivers/usb/phy/Makefile                           |    1 +
 drivers/usb/phy/omap-usb2.c                        |  271 ++++++++++++++++++++
 include/linux/usb/omap_usb.h                       |   46 ++++
 include/linux/usb/phy_companion.h                  |   34 +++
 7 files changed, 382 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/usb/omap-usb.txt
 create mode 100644 drivers/usb/phy/omap-usb2.c
 create mode 100644 include/linux/usb/omap_usb.h
 create mode 100644 include/linux/usb/phy_companion.h

diff --git a/Documentation/devicetree/bindings/bus/omap-ocp2scp.txt b/Documentation/devicetree/bindings/bus/omap-ocp2scp.txt
index d2fe064..bb0c7f4 100644
--- a/Documentation/devicetree/bindings/bus/omap-ocp2scp.txt
+++ b/Documentation/devicetree/bindings/bus/omap-ocp2scp.txt
@@ -8,3 +8,6 @@ properties:
 
 Sub-nodes:
 All the devices connected to ocp2scp are described using sub-node to ocp2scp
+- usb2phy :
+   The binding details of usb2phy can be found in:
+   Documentation/devicetree/bindings/usb/omap-usb.txt
diff --git a/Documentation/devicetree/bindings/usb/omap-usb.txt b/Documentation/devicetree/bindings/usb/omap-usb.txt
new file mode 100644
index 0000000..52f503b
--- /dev/null
+++ b/Documentation/devicetree/bindings/usb/omap-usb.txt
@@ -0,0 +1,17 @@
+OMAP USB PHY
+
+OMAP USB2 PHY
+
+Required properties:
+ - compatible: Should be "ti,omap-usb2"
+ - reg : Address and length of the register set for the device. Also
+add the address of control module dev conf register until a driver for
+control module is added
+
+This is usually a subnode of ocp2scp to which it is connected.
+
+usb2phy@4a0ad080 {
+	compatible = "ti,omap-usb2";
+	reg = <0x4a0ad080 0x58>,
+		<0x4a002300 0x1>;
+};
diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
index e7cf84f..c2ab461 100644
--- a/drivers/usb/phy/Kconfig
+++ b/drivers/usb/phy/Kconfig
@@ -4,6 +4,16 @@
 comment "USB Physical Layer drivers"
 	depends on USB || USB_GADGET
 
+config OMAP_USB2
+	tristate "OMAP USB2 PHY Driver"
+	depends on OMAP_OCP2SCP
+	select USB_OTG_UTILS
+	help
+	  Enable this to support the transceiver that is part of SOC. This
+	  driver takes care of all the PHY functionality apart from comparator.
+	  The USB OTG controller communicates with the comparator using this
+	  driver.
+
 config USB_ISP1301
 	tristate "NXP ISP1301 USB transceiver support"
 	depends on USB || USB_GADGET
diff --git a/drivers/usb/phy/Makefile b/drivers/usb/phy/Makefile
index eca095b..d3fcec9 100644
--- a/drivers/usb/phy/Makefile
+++ b/drivers/usb/phy/Makefile
@@ -4,4 +4,5 @@
 
 ccflags-$(CONFIG_USB_DEBUG) := -DDEBUG
 
+obj-$(CONFIG_OMAP_USB2)			+= omap-usb2.o
 obj-$(CONFIG_USB_ISP1301)		+= isp1301.o
diff --git a/drivers/usb/phy/omap-usb2.c b/drivers/usb/phy/omap-usb2.c
new file mode 100644
index 0000000..984899b
--- /dev/null
+++ b/drivers/usb/phy/omap-usb2.c
@@ -0,0 +1,271 @@
+/*
+ * omap-usb2.c - USB PHY, talking to musb controller in OMAP.
+ *
+ * Copyright (C) 2012 Texas Instruments Incorporated - http://www.ti.com
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
+#include <linux/io.h>
+#include <linux/usb/omap_usb.h>
+#include <linux/usb/phy_companion.h>
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/pm_runtime.h>
+#include <linux/delay.h>
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
+int omap_usb2_set_comparator(struct phy_companion *comparator)
+{
+	struct omap_usb	*phy;
+	struct usb_phy	*x = usb_get_phy(USB_PHY_TYPE_USB2);
+
+	if (IS_ERR(x))
+		return -ENODEV;
+
+	phy = phy_to_omapusb(x);
+	phy->comparator = comparator;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(omap_usb2_set_comparator);
+
+/**
+ * omap_usb_phy_power - power on/off the phy using control module reg
+ * @phy: struct omap_usb *
+ * @on: 0 or 1, based on powering on or off the PHY
+ *
+ * XXX: Remove this function once control module driver gets merged
+ */
+static void omap_usb_phy_power(struct omap_usb *phy, int on)
+{
+	u32 val;
+
+	if (on) {
+		val = readl(phy->control_dev);
+		if (val & PHY_PD) {
+			writel(~PHY_PD, phy->control_dev);
+			/* XXX: add proper documentation for this delay */
+			mdelay(200);
+		}
+	} else {
+		writel(PHY_PD, phy->control_dev);
+	}
+}
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
+	u32 ret;
+	struct omap_usb *phy = phy_to_omapusb(x);
+
+	if (suspend && !phy->is_suspended) {
+		omap_usb_phy_power(phy, 0);
+		pm_runtime_put_sync(phy->dev);
+		phy->is_suspended = 1;
+	} else if (!suspend && phy->is_suspended) {
+		ret = pm_runtime_get_sync(phy->dev);
+		if (ret < 0) {
+			dev_err(phy->dev, "get_sync failed with err %d\n",
+									ret);
+			return ret;
+		}
+		omap_usb_phy_power(phy, 1);
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
+	struct resource			*res;
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
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+
+	phy->control_dev = devm_request_and_ioremap(&pdev->dev, res);
+	if (phy->control_dev == NULL) {
+		dev_err(&pdev->dev, "Failed to obtain io memory\n");
+		return -ENXIO;
+	}
+
+	phy->is_suspended	= 1;
+	omap_usb_phy_power(phy, 0);
+
+	otg->set_host		= omap_usb_set_host;
+	otg->set_peripheral	= omap_usb_set_peripheral;
+	otg->set_vbus		= omap_usb_set_vbus;
+	otg->start_srp		= omap_usb_start_srp;
+	otg->phy		= &phy->phy;
+
+	phy->wkupclk = devm_clk_get(phy->dev, "usb_phy_cm_clk32k");
+	if (IS_ERR(phy->wkupclk)) {
+		dev_err(&pdev->dev, "unable to get usb_phy_cm_clk32k\n");
+		return PTR_ERR(phy->wkupclk);
+	}
+	clk_prepare(phy->wkupclk);
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
+	clk_unprepare(phy->wkupclk);
+	usb_remove_phy(&phy->phy);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM_RUNTIME
+
+static int omap_usb2_runtime_suspend(struct device *dev)
+{
+	struct platform_device	*pdev = to_platform_device(dev);
+	struct omap_usb	*phy = platform_get_drvdata(pdev);
+
+	clk_disable(phy->wkupclk);
+
+	return 0;
+}
+
+static int omap_usb2_runtime_resume(struct device *dev)
+{
+	u32 ret = 0;
+	struct platform_device	*pdev = to_platform_device(dev);
+	struct omap_usb	*phy = platform_get_drvdata(pdev);
+
+	ret = clk_enable(phy->wkupclk);
+	if (ret < 0)
+		dev_err(phy->dev, "Failed to enable wkupclk %d\n", ret);
+
+	return ret;
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
+#ifdef CONFIG_OF
+static const struct of_device_id omap_usb2_id_table[] = {
+	{ .compatible = "ti,omap-usb2" },
+	{}
+};
+MODULE_DEVICE_TABLE(of, omap_usb2_id_table);
+#endif
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
+module_platform_driver(omap_usb2_driver);
+
+MODULE_ALIAS("platform: omap_usb2");
+MODULE_AUTHOR("Texas Instruments Inc.");
+MODULE_DESCRIPTION("OMAP USB2 phy driver");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/usb/omap_usb.h b/include/linux/usb/omap_usb.h
new file mode 100644
index 0000000..0ea17f8
--- /dev/null
+++ b/include/linux/usb/omap_usb.h
@@ -0,0 +1,46 @@
+/*
+ * omap_usb.h -- omap usb2 phy header file
+ *
+ * Copyright (C) 2012 Texas Instruments Incorporated - http://www.ti.com
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
+	u32 __iomem		*control_dev;
+	struct clk		*wkupclk;
+	u8			is_suspended:1;
+};
+
+#define	PHY_PD	0x1
+
+#define	phy_to_omapusb(x)	container_of((x), struct omap_usb, phy)
+
+#if defined(CONFIG_OMAP_USB2) || defined(CONFIG_OMAP_USB2_MODULE)
+extern int omap_usb2_set_comparator(struct phy_companion *comparator);
+#else
+static inline int omap_usb2_set_comparator(struct phy_companion *comparator)
+{
+	return -ENODEV;
+}
+#endif
+
+#endif /* __DRIVERS_OMAP_USB_H */
diff --git a/include/linux/usb/phy_companion.h b/include/linux/usb/phy_companion.h
new file mode 100644
index 0000000..edd2ec2
--- /dev/null
+++ b/include/linux/usb/phy_companion.h
@@ -0,0 +1,34 @@
+/*
+ * phy-companion.h -- phy companion to indicate the comparator part of PHY
+ *
+ * Copyright (C) 2012 Texas Instruments Incorporated - http://www.ti.com
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
1.7.9.5

