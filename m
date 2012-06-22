Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932957Ab2FVNQe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 09:16:34 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37424 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932878Ab2FVNQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 09:16:21 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <linux@arm.linux.org.uk>, <arnd@arndb.de>,
        <gregkh@linuxfoundation.org>, <kishon@ti.com>, <b-cousson@ti.com>,
        <rnayak@ti.com>, <tony@atomide.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <balbi@ti.com>
Subject: [RFC PATCH v2 1/2] drivers: misc: omap: add a new driver for ocp2scp
Date: Fri, 22 Jun 2012 18:45:41 +0530
Message-ID: <1340370942-23201-2-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1340370942-23201-1-git-send-email-kishon@ti.com>
References: <1340370942-23201-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds a new driver _ocp2scp_. This driver takes the responsibility of creating
all the devices that is connected to OCP2SCP. In the case of OMAP4, USB2PHY
is connected to ocp2scp.

This also includes device tree support for ocp2scp driver and
the documentation with device tree binding information is updated.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 .../devicetree/bindings/misc/omap-ocp2scp.txt      |    9 ++
 drivers/misc/Kconfig                               |    8 ++
 drivers/misc/Makefile                              |    1 +
 drivers/misc/omap-ocp2scp.c                        |   96 ++++++++++++++++++++
 4 files changed, 114 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/misc/omap-ocp2scp.txt
 create mode 100644 drivers/misc/omap-ocp2scp.c

diff --git a/Documentation/devicetree/bindings/misc/omap-ocp2scp.txt b/Documentation/devicetree/bindings/misc/omap-ocp2scp.txt
new file mode 100644
index 0000000..e9391d8
--- /dev/null
+++ b/Documentation/devicetree/bindings/misc/omap-ocp2scp.txt
@@ -0,0 +1,9 @@
+* OMAP OCP2SCP - ocp interface to scp interface
+
+properties:
+- compatible : Should be "ti,omap-ocp2scp"
+- #address-cells, #size-cells : Must be present if the device has sub-nodes
+- ti,hwmods : must be "ocp2scp_usb_phy"
+
+Sub-nodes:
+All the devices connected to ocp2scp are described using sub-node to ocp2scp
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 2661f6e..c70aa15 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -508,6 +508,14 @@ config USB_SWITCH_FSA9480
 	  stereo and mono audio, video, microphone and UART data to use
 	  a common connector port.
 
+config OMAP_OCP2SCP
+	tristate "OMAP OCP2SCP DRIVER"
+	help
+	  Driver to enable ocp2scp module which transforms ocp interface
+	  protocol to scp protocol. In OMAP4, USB PHY is connected via
+	  OCP2SCP and in OMAP5, both USB PHY and SATA PHY is connected via
+	  OCP2SCP.
+
 source "drivers/misc/c2port/Kconfig"
 source "drivers/misc/eeprom/Kconfig"
 source "drivers/misc/cb710/Kconfig"
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 456972f..4d7c8ce 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -50,4 +50,5 @@ obj-y				+= lis3lv02d/
 obj-y				+= carma/
 obj-$(CONFIG_USB_SWITCH_FSA9480) += fsa9480.o
 obj-$(CONFIG_ALTERA_STAPL)	+=altera-stapl/
+obj-$(CONFIG_OMAP_OCP2SCP)	+= omap-ocp2scp.o
 obj-$(CONFIG_INTEL_MEI)		+= mei/
diff --git a/drivers/misc/omap-ocp2scp.c b/drivers/misc/omap-ocp2scp.c
new file mode 100644
index 0000000..f3a11e4
--- /dev/null
+++ b/drivers/misc/omap-ocp2scp.c
@@ -0,0 +1,96 @@
+/*
+ * omap-ocp2scp.c - transform ocp interface protocol to scp protocol
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
+#include <linux/err.h>
+#include <linux/pm_runtime.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+
+static int ocp2scp_remove_devices(struct device *dev, void *c)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+
+	platform_device_unregister(pdev);
+
+	return 0;
+}
+
+static int __devinit omap_ocp2scp_probe(struct platform_device *pdev)
+{
+	int			ret;
+	struct device_node	*np = pdev->dev.of_node;
+
+	if (np) {
+		ret = of_platform_populate(np, NULL, NULL, &pdev->dev);
+		if (ret) {
+			dev_err(&pdev->dev, "failed to add resources for ocp2scp child\n");
+			goto err0;
+		}
+	}
+	pm_runtime_enable(&pdev->dev);
+
+	return 0;
+
+err0:
+	device_for_each_child(&pdev->dev, NULL, ocp2scp_remove_devices);
+
+	return ret;
+}
+
+static int __devexit omap_ocp2scp_remove(struct platform_device *pdev)
+{
+	pm_runtime_disable(&pdev->dev);
+	device_for_each_child(&pdev->dev, NULL, ocp2scp_remove_devices);
+
+	return 0;
+}
+
+static const struct of_device_id omap_ocp2scp_id_table[] = {
+	{ .compatible = "ti,omap-ocp2scp" },
+	{}
+};
+MODULE_DEVICE_TABLE(of, omap_usb2_id_table);
+
+static struct platform_driver omap_ocp2scp_driver = {
+	.probe		= omap_ocp2scp_probe,
+	.remove		= __devexit_p(omap_ocp2scp_remove),
+	.driver		= {
+		.name	= "omap-ocp2scp",
+		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(omap_ocp2scp_id_table),
+	},
+};
+
+static int __init omap_ocp2scp_init(void)
+{
+	return platform_driver_register(&omap_ocp2scp_driver);
+}
+arch_initcall(omap_ocp2scp_init);
+
+static void __exit omap_ocp2scp_exit(void)
+{
+	platform_driver_unregister(&omap_ocp2scp_driver);
+}
+module_exit(omap_ocp2scp_exit);
+
+MODULE_ALIAS("platform: omap-ocp2scp");
+MODULE_AUTHOR("Texas Instruments Inc.");
+MODULE_DESCRIPTION("OMAP OCP2SCP DRIVER");
+MODULE_LICENSE("GPLv2");
-- 
1.7.5.4

