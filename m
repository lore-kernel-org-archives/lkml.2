Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981Ab1LTRaF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 12:30:05 -0500
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:48605
	"EHLO AM1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751557Ab1LTR3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 12:29:43 -0500
X-SpamScore: 4
X-BigFish: VS4(zzzz1202h1082kzz8275bh8275dhz2dh2a8h668h839hb79i)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 13,
From: Dong Aisheng <b29396@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linus.walleij@stericsson.com>,
        <s.hauer@pengutronix.de>, <shawn.guo@freescale.com>,
        <kernel@pengutronix.de>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <devicetree-discuss@lists.ozlabs.org>,
        <cjb@laptop.org>, <w.sang@pengutronix.de>
Subject: [RFC PATCH v3 2/5] pinctrl: add dt binding support for pinmux mappings
Date: Wed, 21 Dec 2011 01:40:37 +0800
Message-ID: <1324402840-32451-3-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1324402840-32451-1-git-send-email-b29396@freescale.com>
References: <1324402840-32451-1-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Aisheng <dong.aisheng@linaro.org>

This patch provies a common API for driver to use to register pinmux
mappings from dts file. It is needed for dt support.

Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
---
 .../devicetree/bindings/pinctrl/pinctrl.txt        |   33 +++++++
 drivers/pinctrl/pinmux.c                           |  101 ++++++++++++++++++++
 include/linux/pinctrl/machine.h                    |    6 +
 3 files changed, 140 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/pinctrl.txt

diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl.txt
new file mode 100644
index 0000000..a27a7ce
--- /dev/null
+++ b/Documentation/devicetree/bindings/pinctrl/pinctrl.txt
@@ -0,0 +1,33 @@
+The pin control subsystem
+
+The pin control subsystem provides a common API to support parsing pinmux
+mappings data from device tree. Each board dts file should provide a device
+node of which all the child nodes are the corresponding pinmux mappings.
+
+The required properties for pinmux mapping are:
+- map-name: the name of this specific map entry
+- clk-dev-name: the name of the device controlling this specific mapping
+- funcion: a function in the driver to use for this mapping
+
+Optional properties:
+- group: a certain specific pin group to activate for the function
+- dev-name: the name of the device using this specific mapping
+- hog-on-boot: indicate wether hog the mappings(do not need to specify value)
+
+Examples:
+
+pinmux: imx6q-sabreauto-map {
+	map-sd4 {
+		map-name = "usdhc4";
+		ctrl-dev-name = "20e0000.iomuxc";
+		function = "sd4";
+		dev-name = "219c000.usdhc";
+	};
+	...
+};
+
+Then calling pinmux_of_register_mappings() with the device node of
+imx6q-sabreauto-map as parameter to register pinmux mappings from dts.
+
+Usually user can get this device node via a phandle in driver then call
+the function to register maps. Please refer to pinctrl-imx.txt for example.
diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 432feb6..3ac3098 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -20,6 +20,7 @@
 #include <linux/err.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
+#include <linux/of_device.h>
 #include <linux/spinlock.h>
 #include <linux/string.h>
 #include <linux/sysfs.h>
@@ -410,6 +411,106 @@ int __init pinmux_register_mappings(struct pinmux_map const *maps,
 	return 0;
 }
 
+static int __devinit pinmux_of_parse_mapping(struct device_node *np,
+					struct pinmux_map *maps, unsigned id)
+{
+	struct pinmux_map *map = &maps[id];
+	int ret = 0;
+
+	pr_debug("parse pinmux map %d\n", id + 1);
+
+	if (of_find_property(np, "map-name", NULL)) {
+		ret = of_property_read_string(np, "map-name", &map->name);
+		if (ret) {
+			pr_err("failed to get map-name");
+			return ret;
+		}
+	}
+
+	if (of_find_property(np, "ctrl-dev-name", NULL)) {
+		ret = of_property_read_string(np, "ctrl-dev-name",
+						&map->ctrl_dev_name);
+		if (ret) {
+			pr_err("failed to get ctrl-dev-name");
+			return ret;
+		}
+	}
+
+	if (of_find_property(np, "function", NULL)) {
+		ret = of_property_read_string(np, "function", &map->function);
+		if (ret) {
+			pr_err("failed to get function");
+			return ret;
+		}
+	}
+
+	if (of_find_property(np, "group", NULL)) {
+		ret = of_property_read_string(np, "group", &map->group);
+		if (ret) {
+			pr_err("failed to get group");
+			return ret;
+		}
+	}
+
+	if (of_find_property(np, "dev-name", NULL)) {
+		ret = of_property_read_string(np, "dev-name", &map->dev_name);
+		if (ret) {
+			pr_err("failed to get dev-name");
+			return ret;
+		}
+	}
+
+	if (of_find_property(np, "hog-on-boot", NULL))
+		map->hog_on_boot = true;
+
+	pr_debug("map-name: %s ctrl-dev-name: %s function: %s group: %s dev-name: %s hog-on-boot: %d\n",
+			map->name, map->ctrl_dev_name, map->function,
+			map->group, map->dev_name, map->hog_on_boot);
+
+	return 0;
+}
+
+/**
+ * pinmux_of_register_mappings() - parse and register pinmux mappings from dt
+ * &np: a device node containing pinmux map properties
+ *
+ * Like pinmux_register_mappings(), the memory of pinmux maps are owned by
+ * pinctrl core and can not be freed.
+ */
+int __devinit pinmux_of_register_mappings(struct device_node *np)
+{
+	struct pinmux_map *maps;
+	struct device_node *child = NULL;
+	int count, i;
+	int ret;
+
+	pr_debug("parse pinmux maps from device node %s\n", np->name);
+
+	if (!np)
+		return -EINVAL;
+
+	count = of_get_child_count(np);
+	if (!count) {
+		pr_err("no available pinmux maps found\n");
+		return -EINVAL;
+	}
+
+	maps = kzalloc(count * sizeof(struct pinmux_map), GFP_KERNEL);
+	if (!maps)
+		return -ENOMEM;
+
+	i = 0;
+	for_each_child_of_node(np, child) {
+		ret = pinmux_of_parse_mapping(child, maps, i++);
+		if (ret) {
+			pr_err("failed to parse pinmux map\n");
+			return ret;
+		}
+	}
+
+	return pinmux_register_mappings(maps, count);
+}
+
 /**
  * acquire_pins() - acquire all the pins for a certain funcion on a pinmux
  * @pctldev: the device to take the pins on
diff --git a/include/linux/pinctrl/machine.h b/include/linux/pinctrl/machine.h
index ad430e0..74a695d 100644
--- a/include/linux/pinctrl/machine.h
+++ b/include/linux/pinctrl/machine.h
@@ -78,6 +78,7 @@ struct pinmux_map {
 extern int pinmux_register_mappings(struct pinmux_map const *map,
 				unsigned num_maps);
 
+extern int pinmux_of_register_mappings(struct device_node *np);
 #else
 
 static inline int pinmux_register_mappings(struct pinmux_map const *map,
@@ -86,5 +87,10 @@ static inline int pinmux_register_mappings(struct pinmux_map const *map,
 	return 0;
 }
 
+static inline int pinmux_of_register_mappings(struct device_node *np)
+{
+	return 0;
+}
+
 #endif /* !CONFIG_PINMUX */
 #endif
-- 
1.7.0.4


