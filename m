Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab2GRJUn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 05:20:43 -0400
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:53305 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752804Ab2GRJUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 05:20:22 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, peter.ujfalusi@ti.com,
        Sergio Aguirre <saaguirre@ti.com>
Subject: [PATCH 2/3] mfd: twl6040: Add twl6040-gpio child
Date: Wed, 18 Jul 2012 11:20:19 +0200
Message-Id: <1342603220-13287-3-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1342603220-13287-1-git-send-email-peter.ujfalusi@ti.com>
References: <1342603220-13287-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add needed platform data structure and code to be able to load
the GPO child of twl6040.
Update the devicetree binding documentation at the same time.

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 Documentation/devicetree/bindings/mfd/twl6040.txt |    4 +++
 drivers/mfd/twl6040-core.c                        |   27 +++++++++++++++++++++
 include/linux/mfd/twl6040.h                       |    9 ++++++-
 3 files changed, 39 insertions(+), 1 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/twl6040.txt b/Documentation/devicetree/bindings/mfd/twl6040.txt
index c855240..2a3d55c 100644
--- a/Documentation/devicetree/bindings/mfd/twl6040.txt
+++ b/Documentation/devicetree/bindings/mfd/twl6040.txt
@@ -10,6 +10,8 @@ Required properties:
 - reg: must be 0x4b for i2c address
 - interrupts: twl6040 has one interrupt line connecteded to the main SoC
 - interrupt-parent: The parent interrupt controller
+- gpio-controller:
+- #gpio-cells = <1>: twl6040 provides GPO lines.
 - twl6040,audpwron-gpio: Power on GPIO line for the twl6040
 
 - vio-supply: Regulator for the twl6040 VIO supply
@@ -29,6 +31,8 @@ Required properties:
 - ti,viblmotor-res: Resistance parameter for left motor
 - ti,viblmotor-res: Resistance parameter for right motor
 
+- ti,use-gpo: Set it to <1> if the GPO functionality is in use
+
 Optional properties within vibra { } section:
 - vddvibl_uV: If the vddvibl default voltage need to be changed
 - vddvibr_uV: If the vddvibr default voltage need to be changed
diff --git a/drivers/mfd/twl6040-core.c b/drivers/mfd/twl6040-core.c
index b0fad0f..8ea5b9e 100644
--- a/drivers/mfd/twl6040-core.c
+++ b/drivers/mfd/twl6040-core.c
@@ -59,6 +59,22 @@ static bool twl6040_has_vibra(struct twl6040_platform_data *pdata,
 	return false;
 }
 
+static bool twl6040_has_gpo(struct twl6040_platform_data *pdata,
+			      struct device_node *node)
+{
+	int use_gpo;
+
+	if (pdata && pdata->gpo)
+		return true;
+
+#ifdef CONFIG_OF
+	if (!of_property_read_u32(node, "ti,use-gpo", &use_gpo) && use_gpo)
+		return true;
+#endif
+
+	return false;
+}
+
 int twl6040_reg_read(struct twl6040 *twl6040, unsigned int reg)
 {
 	int ret;
@@ -631,6 +647,17 @@ static int __devinit twl6040_probe(struct i2c_client *client,
 		children++;
 	}
 
+	if (twl6040_has_gpo(pdata, node)) {
+		cell = &twl6040->cells[children];
+		cell->name = "twl6040-gpo";
+
+		if (pdata && pdata->gpo) {
+			cell->platform_data = pdata->gpo;
+			cell->pdata_size = sizeof(*pdata->gpo);
+		}
+		children++;
+	}
+
 	ret = mfd_add_devices(&client->dev, -1, twl6040->cells, children,
 			      NULL, 0);
 	if (ret)
diff --git a/include/linux/mfd/twl6040.h b/include/linux/mfd/twl6040.h
index 269b706..8991532 100644
--- a/include/linux/mfd/twl6040.h
+++ b/include/linux/mfd/twl6040.h
@@ -158,7 +158,7 @@
 #define TWL6040_VIBROCDET		0x20
 #define TWL6040_TSHUTDET                0x40
 
-#define TWL6040_CELLS			2
+#define TWL6040_CELLS			3
 
 #define TWL6040_REV_ES1_0		0x00
 #define TWL6040_REV_ES1_1		0x01 /* Rev ES1.1 and ES1.2 */
@@ -176,6 +176,8 @@
 #define TWL6040_SYSCLK_SEL_LPPLL	0
 #define TWL6040_SYSCLK_SEL_HPPLL	1
 
+#define TWL6040_GPO_MAX	3
+
 struct twl6040_codec_data {
 	u16 hs_left_step;
 	u16 hs_right_step;
@@ -192,12 +194,17 @@ struct twl6040_vibra_data {
 	int vddvibr_uV;			/* VDDVIBR volt, set 0 for fixed reg */
 };
 
+struct twl6040_gpo_data {
+	int gpio_base;
+};
+
 struct twl6040_platform_data {
 	int audpwron_gpio;	/* audio power-on gpio */
 	unsigned int irq_base;
 
 	struct twl6040_codec_data *codec;
 	struct twl6040_vibra_data *vibra;
+	struct twl6040_gpo_data *gpo;
 };
 
 struct regmap;
-- 
1.7.8.6

