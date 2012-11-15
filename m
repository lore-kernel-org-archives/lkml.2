Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768246Ab2KOPvN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 10:51:13 -0500
Received: from vsp-authed02.binero.net ([195.74.38.226]:31887 "HELO
	vsp-authed-03-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933338Ab2KOPvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 10:51:08 -0500
From: Andreas Larsson <andreas@gaisler.com>
To: Wolfram Sang <w.sang@pengutronix.de>, Ben Dooks <ben-linux@fluff.org>,
        Peter Korsgaard <jacmet@sunsite.dk>
Cc: linux-i2c@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        software@gaisler.com
Subject: [PATCH v6 2/2] i2c: i2c-ocores: Add support for the GRLIB port of the controller and use function pointers for getreg and setreg functions
Date: Thu, 15 Nov 2012 16:50:59 +0100
Message-Id: <1352994659-22392-3-git-send-email-andreas@gaisler.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1352994659-22392-1-git-send-email-andreas@gaisler.com>
References: <1352994659-22392-1-git-send-email-andreas@gaisler.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The registers in the GRLIB port of the controller are 32-bit and in big endian
byte order. The PRELOW and PREHIGH registers are merged into one register. The
subsequent registers have their offset decreased accordingly. Hence the register
access needs to be handled in a non-standard manner using custom getreg and
setreg functions.

Add setreg and getreg functions for different register widths and let oc_setreg
and oc_getreg use function pointers to call the appropriate functions.

A type is added as the data of the of match table entries. A new entry with a
different compatible string is added to the table. The type of that entry
triggers usage of the custom grlib functions by setting the setreg and getreg
function pointers.

Signed-off-by: Andreas Larsson <andreas@gaisler.com>
---
 Changes since v5:
 - Function pointers for different widths are set together
 - oc_setreg and oc_getreg are kept as wrappers

 .../devicetree/bindings/i2c/i2c-ocores.txt         |    2 +-
 drivers/i2c/busses/i2c-ocores.c                    |  138 +++++++++++++++++---
 2 files changed, 121 insertions(+), 19 deletions(-)

diff --git a/Documentation/devicetree/bindings/i2c/i2c-ocores.txt b/Documentation/devicetree/bindings/i2c/i2c-ocores.txt
index c15781f..1637c29 100644
--- a/Documentation/devicetree/bindings/i2c/i2c-ocores.txt
+++ b/Documentation/devicetree/bindings/i2c/i2c-ocores.txt
@@ -1,7 +1,7 @@
 Device tree configuration for i2c-ocores
 
 Required properties:
-- compatible      : "opencores,i2c-ocores"
+- compatible      : "opencores,i2c-ocores" or "aeroflexgaisler,i2cmst"
 - reg             : bus address start and address range size of device
 - interrupts      : interrupt number
 - clock-frequency : frequency of bus clock in Hz
diff --git a/drivers/i2c/busses/i2c-ocores.c b/drivers/i2c/busses/i2c-ocores.c
index 1d204cb..2ef318b 100644
--- a/drivers/i2c/busses/i2c-ocores.c
+++ b/drivers/i2c/busses/i2c-ocores.c
@@ -4,6 +4,9 @@
  *
  * Peter Korsgaard <jacmet@sunsite.dk>
  *
+ * Support for the GRLIB port of the controller by
+ * Andreas Larsson <andreas@gaisler.com>
+ *
  * This file is licensed under the terms of the GNU General Public License
  * version 2.  This program is licensed "as is" without any warranty of any
  * kind, whether express or implied.
@@ -38,6 +41,8 @@ struct ocores_i2c {
 	int nmsgs;
 	int state; /* see STATE_ */
 	int clock_khz;
+	void (*setreg)(struct ocores_i2c *i2c, int reg, u8 value);
+	u8 (*getreg)(struct ocores_i2c *i2c, int reg);
 };
 
 /* registers */
@@ -71,24 +76,81 @@ struct ocores_i2c {
 #define STATE_READ		3
 #define STATE_ERROR		4
 
+#define TYPE_OCORES		0
+#define TYPE_GRLIB		1
+
+static void oc_setreg_8(struct ocores_i2c *i2c, int reg, u8 value)
+{
+	iowrite8(value, i2c->base + (reg << i2c->reg_shift));
+}
+
+static void oc_setreg_16(struct ocores_i2c *i2c, int reg, u8 value)
+{
+	iowrite16(value, i2c->base + (reg << i2c->reg_shift));
+}
+
+static void oc_setreg_32(struct ocores_i2c *i2c, int reg, u8 value)
+{
+	iowrite32(value, i2c->base + (reg << i2c->reg_shift));
+}
+
+static inline u8 oc_getreg_8(struct ocores_i2c *i2c, int reg)
+{
+	return ioread8(i2c->base + (reg << i2c->reg_shift));
+}
+
+static inline u8 oc_getreg_16(struct ocores_i2c *i2c, int reg)
+{
+	return ioread16(i2c->base + (reg << i2c->reg_shift));
+}
+
+static inline u8 oc_getreg_32(struct ocores_i2c *i2c, int reg)
+{
+	return ioread32(i2c->base + (reg << i2c->reg_shift));
+}
+
+/* Read and write functions for the GRLIB port of the controller. Registers are
+ * 32-bit big endian and the PRELOW and PREHIGH registers are merged into one
+ * register. The subsequent registers has their offset decreased accordingly. */
+static u8 oc_getreg_grlib(struct ocores_i2c *i2c, int reg)
+{
+	u32 rd;
+	int rreg = reg;
+	if (reg != OCI2C_PRELOW)
+		rreg--;
+	rd = ioread32be(i2c->base + (rreg << i2c->reg_shift));
+	if (reg == OCI2C_PREHIGH)
+		return (u8)(rd >> 8);
+	else
+		return (u8)rd;
+}
+
+static void oc_setreg_grlib(struct ocores_i2c *i2c, int reg, u8 value)
+{
+	u32 curr, wr;
+	int rreg = reg;
+	if (reg != OCI2C_PRELOW)
+		rreg--;
+	if (reg == OCI2C_PRELOW || reg == OCI2C_PREHIGH) {
+		curr = ioread32be(i2c->base + (rreg << i2c->reg_shift));
+		if (reg == OCI2C_PRELOW)
+			wr = (curr & 0xff00) | value;
+		else
+			wr = (((u32)value) << 8) | (curr & 0xff);
+	} else {
+		wr = value;
+	}
+	iowrite32be(wr, i2c->base + (rreg << i2c->reg_shift));
+}
+
 static inline void oc_setreg(struct ocores_i2c *i2c, int reg, u8 value)
 {
-	if (i2c->reg_io_width == 4)
-		iowrite32(value, i2c->base + (reg << i2c->reg_shift));
-	else if (i2c->reg_io_width == 2)
-		iowrite16(value, i2c->base + (reg << i2c->reg_shift));
-	else
-		iowrite8(value, i2c->base + (reg << i2c->reg_shift));
+	i2c->setreg(i2c, reg, value);
 }
 
 static inline u8 oc_getreg(struct ocores_i2c *i2c, int reg)
 {
-	if (i2c->reg_io_width == 4)
-		return ioread32(i2c->base + (reg << i2c->reg_shift));
-	else if (i2c->reg_io_width == 2)
-		return ioread16(i2c->base + (reg << i2c->reg_shift));
-	else
-		return ioread8(i2c->base + (reg << i2c->reg_shift));
+	return i2c->getreg(i2c, reg);
 }
 
 static void ocores_process(struct ocores_i2c *i2c)
@@ -227,11 +289,25 @@ static struct i2c_adapter ocores_adapter = {
 	.algo		= &ocores_algorithm,
 };
 
+static struct of_device_id ocores_i2c_match[] = {
+	{
+		.compatible = "opencores,i2c-ocores",
+		.data = (void *)TYPE_OCORES,
+	},
+	{
+		.compatible = "aeroflexgaisler,i2cmst",
+		.data = (void *)TYPE_GRLIB,
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(of, ocores_i2c_match);
+
 #ifdef CONFIG_OF
 static int ocores_i2c_of_probe(struct platform_device *pdev,
 				struct ocores_i2c *i2c)
 {
 	struct device_node *np = pdev->dev.of_node;
+	const struct of_device_id *match;
 	u32 val;
 
 	if (of_property_read_u32(np, "reg-shift", &i2c->reg_shift)) {
@@ -257,6 +333,14 @@ static int ocores_i2c_of_probe(struct platform_device *pdev,
 
 	of_property_read_u32(pdev->dev.of_node, "reg-io-width",
 				&i2c->reg_io_width);
+
+	match = of_match_node(ocores_i2c_match, pdev->dev.of_node);
+	if (match && (int)match->data == TYPE_GRLIB) {
+		dev_dbg(&pdev->dev, "GRLIB variant of i2c-ocores\n");
+		i2c->setreg = oc_setreg_grlib;
+		i2c->getreg = oc_getreg_grlib;
+	}
+
 	return 0;
 }
 #else
@@ -311,6 +395,30 @@ static int __devinit ocores_i2c_probe(struct platform_device *pdev)
 	if (i2c->reg_io_width == 0)
 		i2c->reg_io_width = 1; /* Set to default value */
 
+	if (!i2c->setreg || !i2c->getreg) {
+		switch (i2c->reg_io_width) {
+		case 1:
+			i2c->setreg = oc_setreg_8;
+			i2c->getreg = oc_getreg_8;
+			break;
+
+		case 2:
+			i2c->setreg = oc_setreg_16;
+			i2c->getreg = oc_getreg_16;
+			break;
+
+		case 4:
+			i2c->setreg = oc_setreg_32;
+			i2c->getreg = oc_getreg_32;
+			break;
+
+		default:
+			dev_err(&pdev->dev, "Unsupported I/O width (%d)\n",
+				i2c->reg_io_width);
+			return -EINVAL;
+		}
+	}
+
 	ocores_init(i2c);
 
 	init_waitqueue_head(&i2c->wait);
@@ -388,12 +496,6 @@ static SIMPLE_DEV_PM_OPS(ocores_i2c_pm, ocores_i2c_suspend, ocores_i2c_resume);
 #define OCORES_I2C_PM	NULL
 #endif
 
-static struct of_device_id ocores_i2c_match[] = {
-	{ .compatible = "opencores,i2c-ocores", },
-	{},
-};
-MODULE_DEVICE_TABLE(of, ocores_i2c_match);
-
 static struct platform_driver ocores_i2c_driver = {
 	.probe   = ocores_i2c_probe,
 	.remove  = __devexit_p(ocores_i2c_remove),
-- 
1.7.0.4

