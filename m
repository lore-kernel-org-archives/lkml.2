Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752Ab2DIUPc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 16:15:32 -0400
Received: from csmtp3.one.com ([91.198.169.23]:58565 "EHLO csmtp3.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756273Ab2DIUPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 16:15:30 -0400
From: Eric Andersson <eric.andersson@unixphere.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, alan@lxorguk.ukuu.org.uk, arnd@arndb.de,
        zhengguang.guo@bosch-sensortec.com, peter.moeller@cn.bosch.com,
        stefan.nilsson@unixphere.com, broonie@opensource.wolfsonmicro.com,
        christoph.mair@gmail.com,
        Eric Andersson <eric.andersson@unixphere.com>
Subject: [PATCHv5 2/3] misc: bmp085: add device tree properties
Date: Mon,  9 Apr 2012 22:16:16 +0200
Message-Id: <1334002577-7786-3-git-send-email-eric.andersson@unixphere.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1334002577-7786-1-git-send-email-eric.andersson@unixphere.com>
References: <1334002577-7786-1-git-send-email-eric.andersson@unixphere.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reviewed-by: Stefan Nilsson <stefan.nilsson@unixphere.com>
Signed-off-by: Eric Andersson <eric.andersson@unixphere.com>
---
 Documentation/devicetree/bindings/misc/bmp085.txt  |   20 +++++++++++
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 drivers/misc/bmp085.c                              |   37 +++++++++++++++++++-
 3 files changed, 57 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/misc/bmp085.txt

diff --git a/Documentation/devicetree/bindings/misc/bmp085.txt b/Documentation/devicetree/bindings/misc/bmp085.txt
new file mode 100644
index 0000000..91dfda2
--- /dev/null
+++ b/Documentation/devicetree/bindings/misc/bmp085.txt
@@ -0,0 +1,20 @@
+BMP085/BMP18x digital pressure sensors
+
+Required properties:
+- compatible: bosch,bmp085
+
+Optional properties:
+- chip-id: configurable chip id for non-default chip revisions
+- temp-measurement-period: temperature measurement period (milliseconds)
+- default-oversampling: default oversampling value to be used at startup,
+  value range is 0-3 with rising sensitivity.
+
+Example:
+
+pressure@77 {
+	compatible = "bosch,bmp085";
+	reg = <0x77>;
+	chip-id = <10>;
+	temp-measurement-period = <100>;
+	default-oversampling = <2>;
+};
diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 82ac057..107d8ad 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -8,6 +8,7 @@ amcc	Applied Micro Circuits Corporation (APM, formally AMCC)
 apm	Applied Micro Circuits Corporation (APM)
 arm	ARM Ltd.
 atmel	Atmel Corporation
+bosch	Bosch Sensortec GmbH
 cavium	Cavium, Inc.
 chrp	Common Hardware Reference Platform
 cortina	Cortina Systems, Inc.
diff --git a/drivers/misc/bmp085.c b/drivers/misc/bmp085.c
index 6f572bc..6adde9e 100644
--- a/drivers/misc/bmp085.c
+++ b/drivers/misc/bmp085.c
@@ -50,6 +50,7 @@
 #include <linux/i2c.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
+#include <linux/of.h>
 
 #define BMP085_NAME			"bmp085"
 #define BMP085_I2C_ADDRESS		0x77
@@ -85,6 +86,7 @@ struct bmp085_data {
 	u32	raw_pressure;
 	u32	temp_measurement_period;
 	unsigned long last_temp_measurement;
+	u8	chip_id;
 	s32	b6; /* calculated temperature correction coefficient */
 };
 
@@ -385,6 +387,27 @@ static int bmp085_detect(struct i2c_client *client, struct i2c_board_info *info)
 	return 0;
 }
 
+static void __init bmp085_get_of_properties(struct i2c_client *client,
+					    struct bmp085_data *data)
+{
+#ifdef CONFIG_OF
+	struct device_node *np = client->dev.of_node;
+	u32 prop;
+
+	if (!np)
+		return;
+
+	if (!of_property_read_u32(np, "chip-id", &prop))
+		data->chip_id = prop & 0xff;
+
+	if (!of_property_read_u32(np, "temp-measurement-period", &prop))
+		data->temp_measurement_period = (prop/100)*HZ;
+
+	if (!of_property_read_u32(np, "default-oversampling", &prop))
+		data->oversampling_setting = prop & 0xff;
+#endif
+}
+
 static int bmp085_init_client(struct i2c_client *client)
 {
 	struct bmp085_data *data = i2c_get_clientdata(client);
@@ -393,10 +416,15 @@ static int bmp085_init_client(struct i2c_client *client)
 	if (status < 0)
 		return status;
 
+	/* default settings */
 	data->client = client;
+	data->chip_id = BMP085_CHIP_ID;
 	data->last_temp_measurement = 0;
 	data->temp_measurement_period = 1*HZ;
 	data->oversampling_setting = 3;
+
+	bmp085_get_of_properties(client, data);
+
 	mutex_init(&data->lock);
 
 	return 0;
@@ -446,6 +474,12 @@ static int __devexit bmp085_remove(struct i2c_client *client)
 	return 0;
 }
 
+static const struct of_device_id bmp085_of_match[] = {
+	{ .compatible = "bosch,bmp085", },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, bmp085_of_match);
+
 static const struct i2c_device_id bmp085_id[] = {
 	{ BMP085_NAME, 0 },
 	{ }
@@ -455,7 +489,8 @@ MODULE_DEVICE_TABLE(i2c, bmp085_id);
 static struct i2c_driver bmp085_driver = {
 	.driver = {
 		.owner = THIS_MODULE,
-		.name	= BMP085_NAME
+		.name	= BMP085_NAME,
+		.of_match_table = bmp085_of_match
 	},
 	.id_table	= bmp085_id,
 	.probe		= bmp085_probe,
-- 
1.7.3.4

