Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757091Ab2DXRr4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 13:47:56 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:56896 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757061Ab2DXRry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 13:47:54 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Wolfram Sang <w.sang@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Cc: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V2] i2c: Add generic I2C multiplexer using pinctrl API
Date: Tue, 24 Apr 2012 11:47:44 -0600
Message-Id: <1335289664-21383-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

This is useful for SoCs whose I2C module's signals can be routed to
different sets of pins at run-time, using the pinctrl API.

                                 +-----+  +-----+
                                 | dev |  | dev |
    +------------------------+   +-----+  +-----+
    | SoC                    |      |        |
    |                   /----|------+--------+
    |   +---+   +------+     | child bus A, on first set of pins
    |   |I2C|---|Pinmux|     |
    |   +---+   +------+     | child bus B, on second set of pins
    |                   \----|------+--------+--------+
    |                        |      |        |        |
    +------------------------+  +-----+  +-----+  +-----+
                                | dev |  | dev |  | dev |
                                +-----+  +-----+  +-----+

Signed-off-by: Stephen Warren <swarren@nvidia.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
v2: Rebase onto David Daney's i2c-mux OF support, including slight binding
    changes. Add more error messages.
---
 .../devicetree/bindings/i2c/pinctrl-i2cmux.txt     |   79 ++++++
 drivers/i2c/muxes/Kconfig                          |   12 +
 drivers/i2c/muxes/Makefile                         |    1 +
 drivers/i2c/muxes/pinctrl-i2cmux.c                 |  277 ++++++++++++++++++++
 include/linux/pinctrl-i2cmux.h                     |   41 +++
 5 files changed, 410 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/i2c/pinctrl-i2cmux.txt
 create mode 100644 drivers/i2c/muxes/pinctrl-i2cmux.c
 create mode 100644 include/linux/pinctrl-i2cmux.h

diff --git a/Documentation/devicetree/bindings/i2c/pinctrl-i2cmux.txt b/Documentation/devicetree/bindings/i2c/pinctrl-i2cmux.txt
new file mode 100644
index 0000000..475f970
--- /dev/null
+++ b/Documentation/devicetree/bindings/i2c/pinctrl-i2cmux.txt
@@ -0,0 +1,79 @@
+Pinctrl-based I2C Bus Mux
+
+This binding describes an I2C bus multiplexer that uses pin multiplexing to
+route the I2C signals, and represents the pin multiplexing configuration
+using the pinctrl device tree bindings.
+
+Required properties:
+- compatible: pinctrl-i2cmux
+- i2c-parent: The phandle of the I2C bus that this multiplexer's master-side
+  port is connected to.
+
+Also required are:
+
+* Standard pinctrl properties that specify the pin mux state for each child
+  bus. See ../pinctrl/pinctrl-bindings.txt.
+
+* Standard I2C mux properties. See mux.txt in this directory.
+
+* I2C child bus nodes. See mux.txt in this directory.
+
+For each named state defined in the pinctrl-names property, an I2C child bus
+will be created. I2C child bus numbers are assigned based on the index into
+the pinctrl-names property.
+
+The only exception is that no bus will be created for a state named "idle". If
+such a state is defined, it must be the last entry in pinctrl-names. For
+example:
+
+	pinctrl-names = "ddc", "pta", "idle"  ->  ddc = bus 0, pta = bus 1
+	pinctrl-names = "ddc", "idle", "pta"  ->  Invalid ("idle" not last)
+	pinctrl-names = "idle", "ddc", "pta"  ->  Invalid ("idle" not last)
+
+Whenever an access is made to a device on a child bus, the relevant pinctrl
+state will be programmed into hardware.
+
+If an idle state is defined, whenever an access is not being made to a device
+on a child bus, the idle pinctrl state will be programmed into hardware.
+
+If an idle state is not defined, the most recently used pinctrl state will be
+left programmed into hardware whenever no access is being made of a device on
+a child bus.
+
+Example:
+
+	i2cmux {
+		compatible = "pinctrl-i2cmux";
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		i2c-parent = <&i2c1>;
+
+		pinctrl-names = "ddc", "pta", "idle";
+		pinctrl-0 = <&state_i2cmux_ddc>;
+		pinctrl-1 = <&state_i2cmux_pta>;
+		pinctrl-2 = <&state_i2cmux_idle>;
+
+		i2c@0 {
+			reg = <0>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			eeprom {
+				compatible = "eeprom";
+				reg = <0x50>;
+			};
+		};
+
+		i2c@1 {
+			reg = <1>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			eeprom {
+				compatible = "eeprom";
+				reg = <0x50>;
+			};
+		};
+	};
+
diff --git a/drivers/i2c/muxes/Kconfig b/drivers/i2c/muxes/Kconfig
index 90b7a01..8602384 100644
--- a/drivers/i2c/muxes/Kconfig
+++ b/drivers/i2c/muxes/Kconfig
@@ -37,4 +37,16 @@ config I2C_MUX_PCA954x
 	  This driver can also be built as a module.  If so, the module
 	  will be called pca954x.
 
+config I2C_MUX_PINCTRL
+	tristate "pinctrl-based I2C multiplexer"
+	depends on PINCTRL
+	help
+	  If you say yes to this option, support will be included for an I2C
+	  multiplexer that uses the pinctrl subsystem, i.e. pin multiplexing.
+	  This is useful for SoCs whose I2C module's signals can be routed to
+	  different sets of pins at run-time.
+
+	  This driver can also be built as a module. If so, the module will be
+	  called pinctrl-i2cmux.
+
 endmenu
diff --git a/drivers/i2c/muxes/Makefile b/drivers/i2c/muxes/Makefile
index 4640436..7ba65fc 100644
--- a/drivers/i2c/muxes/Makefile
+++ b/drivers/i2c/muxes/Makefile
@@ -4,5 +4,6 @@
 obj-$(CONFIG_I2C_MUX_GPIO)	+= gpio-i2cmux.o
 obj-$(CONFIG_I2C_MUX_PCA9541)	+= pca9541.o
 obj-$(CONFIG_I2C_MUX_PCA954x)	+= pca954x.o
+obj-$(CONFIG_I2C_MUX_PINCTRL)	+= pinctrl-i2cmux.o
 
 ccflags-$(CONFIG_I2C_DEBUG_BUS) := -DDEBUG
diff --git a/drivers/i2c/muxes/pinctrl-i2cmux.c b/drivers/i2c/muxes/pinctrl-i2cmux.c
new file mode 100644
index 0000000..86b5417
--- /dev/null
+++ b/drivers/i2c/muxes/pinctrl-i2cmux.c
@@ -0,0 +1,277 @@
+/*
+ * I2C multiplexer using pinctrl API
+ *
+ * Copyright (c) 2012, NVIDIA CORPORATION.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/i2c.h>
+#include <linux/i2c-mux.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/of_i2c.h>
+#include <linux/pinctrl/consumer.h>
+#include <linux/pinctrl-i2cmux.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+
+struct pinctrl_mux {
+	struct device *dev;
+	struct pinctrl_i2cmux_platform_data *pdata;
+	struct pinctrl *pinctrl;
+	struct pinctrl_state **states;
+	struct pinctrl_state *state_idle;
+	struct i2c_adapter *parent;
+	struct i2c_adapter **busses;
+};
+
+static int pinctrl_mux_select(struct i2c_adapter *adap, void *data, u32 chan)
+{
+	struct pinctrl_mux *mux = data;
+
+	return pinctrl_select_state(mux->pinctrl, mux->states[chan]);
+}
+
+static int pinctrl_mux_deselect(struct i2c_adapter *adap, void *data, u32 chan)
+{
+	struct pinctrl_mux *mux = data;
+
+	return pinctrl_select_state(mux->pinctrl, mux->state_idle);
+}
+
+#ifdef CONFIG_OF
+static int pinctrl_mux_parse_dt(struct pinctrl_mux *mux,
+				struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	int num_names, i, ret;
+	struct device_node *adapter_np;
+	struct i2c_adapter *adapter;
+
+	if (!np)
+		return 0;
+
+	mux->pdata = devm_kzalloc(&pdev->dev, sizeof(*mux->pdata), GFP_KERNEL);
+	if (!mux->pdata) {
+		dev_err(mux->dev,
+			"Cannot allocate pinctrl_i2cmux_platform_data\n");
+		return -ENOMEM;
+	}
+
+	num_names = of_property_count_strings(np, "pinctrl-names");
+	if (num_names < 0) {
+		dev_err(mux->dev, "Cannot parse pinctrl-names: %d\n",
+			num_names);
+		return num_names;
+	}
+
+	mux->pdata->pinctrl_states = devm_kzalloc(&pdev->dev,
+		sizeof(*mux->pdata->pinctrl_states) * num_names,
+		GFP_KERNEL);
+	if (!mux->pdata->pinctrl_states) {
+		dev_err(mux->dev, "Cannot allocate pinctrl_states\n");
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < num_names; i++) {
+		ret = of_property_read_string_index(np, "pinctrl-names", i,
+			&mux->pdata->pinctrl_states[mux->pdata->bus_count]);
+		if (ret < 0) {
+			dev_err(mux->dev, "Cannot parse pinctrl-names: %d\n",
+				ret);
+			return ret;
+		}
+		if (!strcmp(mux->pdata->pinctrl_states[mux->pdata->bus_count],
+			    "idle")) {
+			if (i != num_names - 1) {
+				dev_err(mux->dev, "idle state must be last\n");
+				return -EINVAL;
+			}
+			mux->pdata->pinctrl_state_idle = "idle";
+		} else {
+			mux->pdata->bus_count++;
+		}
+	}
+
+	adapter_np = of_parse_phandle(np, "i2c-parent", 0);
+	if (!adapter_np) {
+		dev_err(mux->dev, "Cannot parse i2c-parent\n");
+		return -ENODEV;
+	}
+	adapter = of_find_i2c_adapter_by_node(adapter_np);
+	if (!adapter) {
+		dev_err(mux->dev, "Cannot find parent bus\n");
+		return -ENODEV;
+	}
+	mux->pdata->parent_bus_num = i2c_adapter_id(adapter);
+	put_device(&adapter->dev);
+
+	return 0;
+}
+#else
+static inline int pinctrl_mux_parse_dt(struct pinctrl_mux *mux,
+				       struct platform_device *pdev)
+{
+	return 0;
+}
+#endif
+
+static int __devinit pinctrl_mux_probe(struct platform_device *pdev)
+{
+	struct pinctrl_mux *mux;
+	int (*deselect)(struct i2c_adapter *, void *, u32);
+	int i, ret;
+
+	mux = devm_kzalloc(&pdev->dev, sizeof(*mux), GFP_KERNEL);
+	if (!mux) {
+		dev_err(&pdev->dev, "Cannot allocate pinctrl_mux\n");
+		ret = -ENOMEM;
+		goto err;
+	}
+	platform_set_drvdata(pdev, mux);
+
+	mux->dev = &pdev->dev;
+
+	mux->pdata = pdev->dev.platform_data;
+	if (!mux->pdata) {
+		ret = pinctrl_mux_parse_dt(mux, pdev);
+		if (ret < 0)
+			goto err;
+	}
+	if (!mux->pdata) {
+		dev_err(&pdev->dev, "Missing platform data\n");
+		ret = -ENODEV;
+		goto err;
+	}
+
+	mux->states = devm_kzalloc(&pdev->dev,
+				   sizeof(*mux->states) * mux->pdata->bus_count,
+				   GFP_KERNEL);
+	if (!mux->states) {
+		dev_err(&pdev->dev, "Cannot allocate states\n");
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	mux->busses = devm_kzalloc(&pdev->dev,
+				   sizeof(mux->busses) * mux->pdata->bus_count,
+				   GFP_KERNEL);
+	if (!mux->states) {
+		dev_err(&pdev->dev, "Cannot allocate busses\n");
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	mux->pinctrl = devm_pinctrl_get(&pdev->dev);
+	if (IS_ERR(mux->pinctrl)) {
+		ret = PTR_ERR(mux->pinctrl);
+		dev_err(&pdev->dev, "Cannot get pinctrl: %d\n", ret);
+		goto err;
+	}
+	for (i = 0; i < mux->pdata->bus_count; i++) {
+		mux->states[i] = pinctrl_lookup_state(mux->pinctrl,
+						mux->pdata->pinctrl_states[i]);
+			if (IS_ERR(mux->states[i])) {
+				ret = PTR_ERR(mux->states[i]);
+				dev_err(&pdev->dev,
+					"Cannot look up pinctrl state %s: %d\n",
+					mux->pdata->pinctrl_states[i], ret);
+				goto err;
+			}
+	}
+	if (mux->pdata->pinctrl_state_idle) {
+		mux->state_idle = pinctrl_lookup_state(mux->pinctrl,
+						mux->pdata->pinctrl_state_idle);
+		if (IS_ERR(mux->state_idle)) {
+			ret = PTR_ERR(mux->state_idle);
+			dev_err(&pdev->dev,
+				"Cannot look up pinctrl state %s: %d\n",
+				mux->pdata->pinctrl_state_idle, ret);
+			goto err;
+		}
+
+		deselect = pinctrl_mux_deselect;
+	} else {
+		deselect = NULL;
+	}
+
+	mux->parent = i2c_get_adapter(mux->pdata->parent_bus_num);
+	if (!mux->parent) {
+		dev_err(&pdev->dev, "Parent adapter (%d) not found\n",
+			mux->pdata->parent_bus_num);
+		ret = -ENODEV;
+		goto err;
+	}
+
+	for (i = 0; i < mux->pdata->bus_count; i++) {
+		u32 bus = mux->pdata->base_bus_num ?
+				(mux->pdata->base_bus_num + i) : 0;
+
+		mux->busses[i] = i2c_add_mux_adapter(mux->parent, &pdev->dev,
+						     mux, bus, i,
+						     pinctrl_mux_select,
+						     deselect);
+		if (!mux->busses[i]) {
+			ret = -ENODEV;
+			dev_err(&pdev->dev, "Failed to add adapter %d\n", i);
+			goto err_del_adapter;
+		}
+	}
+
+	return 0;
+
+err_del_adapter:
+	for (; i > 0; i--)
+		i2c_del_mux_adapter(mux->busses[i - 1]);
+	i2c_put_adapter(mux->parent);
+err:
+	return ret;
+}
+
+static int __devexit pinctrl_mux_remove(struct platform_device *pdev)
+{
+	struct pinctrl_mux *mux = platform_get_drvdata(pdev);
+	int i;
+
+	for (i = 0; i < mux->pdata->bus_count; i++)
+		i2c_del_mux_adapter(mux->busses[i]);
+
+	i2c_put_adapter(mux->parent);
+
+	return 0;
+}
+
+#ifdef CONFIG_OF
+static const struct of_device_id pinctrl_mux_of_match[] __devinitconst = {
+	{ .compatible = "pinctrl-i2cmux", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, pinctrl_mux_of_match);
+#endif
+
+static struct platform_driver pinctrl_mux_driver = {
+	.driver	= {
+		.name	= "pinctrl-i2cmux",
+		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(pinctrl_mux_of_match),
+	},
+	.probe	= pinctrl_mux_probe,
+	.remove	= __devexit_p(pinctrl_mux_remove),
+};
+module_platform_driver(pinctrl_mux_driver);
+
+MODULE_DESCRIPTION("pinctrl-based I2C multiplexer driver");
+MODULE_AUTHOR("Stephen Warren <swarren@nvidia.com>");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:pinctrl-i2cmux");
diff --git a/include/linux/pinctrl-i2cmux.h b/include/linux/pinctrl-i2cmux.h
new file mode 100644
index 0000000..046e420
--- /dev/null
+++ b/include/linux/pinctrl-i2cmux.h
@@ -0,0 +1,41 @@
+/*
+ * pinctrl-i2cmux platform data
+ *
+ * Copyright (c) 2012, NVIDIA CORPORATION.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef _LINUX_PINCTRL_I2CMUX_H
+#define _LINUX_PINCTRL_I2CMUX_H
+
+/**
+ * struct pinctrl_i2cmux_platform_data - Platform data for pinctrl-i2cmux
+ * @parent_bus_num: Parent I2C bus number
+ * @base_bus_num: Base I2C bus number for the child busses. 0 for dynamic.
+ * @bus_count: Number of child busses. Also the number of elements in
+ *	@pinctrl_states
+ * @pinctrl_states: The names of the pinctrl state to select for each child bus
+ * @pinctrl_state_idle: The pinctrl state to select when no child bus is being
+ *	accessed. If NULL, the most recently used pinctrl state will be left
+ *	selected.
+ */
+struct pinctrl_i2cmux_platform_data {
+	int parent_bus_num;
+	int base_bus_num;
+	int bus_count;
+	const char **pinctrl_states;
+	const char *pinctrl_state_idle;
+};
+
+#endif
-- 
1.7.0.4

