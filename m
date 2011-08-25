Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767Ab1HYA0G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 20:26:06 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:11387 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab1HYA0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 20:26:04 -0400
From: David Daney <david.daney@cavium.com>
To: devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org
Cc: David Daney <david.daney@cavium.com>
Subject: [RFC PATCH 2/2] i2c/of: Automatically populate i2c mux busses from device tree data.
Date: Wed, 24 Aug 2011 17:25:56 -0700
Message-Id: <1314231956-21115-3-git-send-email-david.daney@cavium.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1314231956-21115-1-git-send-email-david.daney@cavium.com>
References: <1314231956-21115-1-git-send-email-david.daney@cavium.com>
X-OriginalArrivalTime: 25 Aug 2011 00:26:03.0363 (UTC) FILETIME=[92880330:01CC62BD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For 'normal' i2c bus drivers, we can call of_i2c_register_devices()
and have the device tree framework automatically populate the bus with
the devices specified in the device tree.

This patch adds a common code to the i2c mux framework to hate the mux
sub-busses be populated by the of_i2c_register_devices() too.  If the
mux device has an of_node, we populate the sub-bus' of_node so that
the subsequent call to of_i2c_register_devices() will find the
corresponding devices.

It seemed better to put this logic in i2c_add_mux_adapter() rather
than the individual mux drivers, as they will all probably want to do
the same thing.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 Documentation/devicetree/bindings/i2c/mux.txt |   54 +++++++++++++++++++++++++
 drivers/i2c/i2c-mux.c                         |   25 +++++++++++
 2 files changed, 79 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/i2c/mux.txt

diff --git a/Documentation/devicetree/bindings/i2c/mux.txt b/Documentation/devicetree/bindings/i2c/mux.txt
new file mode 100644
index 0000000..7bd9192
--- /dev/null
+++ b/Documentation/devicetree/bindings/i2c/mux.txt
@@ -0,0 +1,54 @@
+Common i2c bus multiplexer/switch properties.
+
+An i2c bus multiplexer/switch will have several child busses that are
+numbered uniquely in a device dependent manner.  The nodes for an i2c bus
+multiplexer/switch will have one child node for each child
+bus.
+
+Required properties for child nodes:
+- #address-cells = <1>;
+- #size-cells = <0>;
+- cell-index : The sub-bus number.
+
+Optional properties for child nodes:
+- Other properties specific to the multiplexer/switch hardware.
+- Child nodes conforming to i2c bus binding
+
+
+Example :
+
+	/*
+	   An NXP pca9548 8 channel I2C multiplexer at address 0x70
+	   with two NXP pca8574 GPIO expanders attached, one each to
+	   ports 3 and 4.
+	 */
+
+	mux@70 {
+		compatible = "nxp,pca9548";
+		reg = <0x70>;
+
+		i2c@3 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			cell-index = <3>;
+
+			gpio1: gpio@38 {
+				compatible = "nxp,pca8574";
+				reg = <0x38>;
+				#gpio-cells = <2>;
+				gpio-controller;
+			};
+		};
+		i2c@4 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			cell-index = <4>;
+
+			gpio2: gpio@38 {
+				compatible = "nxp,pca8574";
+				reg = <0x38>;
+				#gpio-cells = <2>;
+				gpio-controller;
+			};
+		};
+	};
diff --git a/drivers/i2c/i2c-mux.c b/drivers/i2c/i2c-mux.c
index 6fc2dd4..63f8989 100644
--- a/drivers/i2c/i2c-mux.c
+++ b/drivers/i2c/i2c-mux.c
@@ -24,6 +24,8 @@
 #include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/i2c-mux.h>
+#include <linux/of.h>
+#include <linux/of_i2c.h>
 
 /* multiplexer per channel data */
 struct i2c_mux_priv {
@@ -143,6 +145,29 @@ struct i2c_adapter *i2c_add_mux_adapter(struct i2c_adapter *parent,
 	dev_info(&parent->dev, "Added multiplexed i2c bus %d\n",
 		 i2c_adapter_id(&priv->adap));
 
+#ifdef CONFIG_OF
+	/* Try to get populate the mux adapter's of_node */
+	if (mux_dev->of_node) {
+		struct device_node *child = NULL;
+		const __be32 *cell_index;
+		int len;
+
+		for (;;) {
+			child = of_get_next_child(mux_dev->of_node, child);
+			if (!child)
+				break;
+			cell_index = of_get_property(child, "cell-index", &len);
+			if (!cell_index || (len < sizeof(__be32)))
+				continue;
+			if (chan_id == be32_to_cpup(cell_index)) {
+				priv->adap.dev.of_node = child;
+				break;
+			}
+		}
+	}
+	of_i2c_register_devices(&priv->adap);
+#endif
+
 	return &priv->adap;
 }
 EXPORT_SYMBOL_GPL(i2c_add_mux_adapter);
-- 
1.7.2.3

