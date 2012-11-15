Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993280Ab2KOKXc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 05:23:32 -0500
Received: from vsp-authed02.binero.net ([195.74.38.226]:12261 "HELO
	vsp-authed-03-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S2993255Ab2KOKX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 05:23:29 -0500
From: Andreas Larsson <andreas@gaisler.com>
To: Wolfram Sang <w.sang@pengutronix.de>, Ben Dooks <ben-linux@fluff.org>,
        Peter Korsgaard <jacmet@sunsite.dk>
Cc: linux-i2c@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        software@gaisler.com
Subject: [PATCH v4 2/2] i2c: i2c-ocores: Add support for the GRLIB port of the controller and custom getreg and setreg functions
Date: Thu, 15 Nov 2012 11:22:59 +0100
Message-Id: <1352974979-22638-3-git-send-email-andreas@gaisler.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1352974979-22638-1-git-send-email-andreas@gaisler.com>
References: <1352974979-22638-1-git-send-email-andreas@gaisler.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The registers in the GRLIB port of the controller are 32-bit and in big endian
byte order. The PRELOW and PREHIGH registers are merged into one register. The
subsequent registers have their offset decreased accordingly. Hence the register
access needs to be handled in a non-standard manner using custom getreg and
setreg functions.

A type is added as the data of the of match table entries. A new entry with a
different compatible string is added to the table. The type of that entry
triggers usage of the grlib functions.

Signed-off-by: Andreas Larsson <andreas@gaisler.com>
---
 Changes since v3:
 - Use a separate entry in the of match table for the grlib variant and trigger
   grlib function usage on type put in the data field of that table entry

 .../devicetree/bindings/i2c/i2c-ocores.txt         |    2 +-
 drivers/i2c/busses/i2c-ocores.c                    |   79 +++++++++++++++++++-
 2 files changed, 77 insertions(+), 4 deletions(-)

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
index 1d204cb..fc6e6e7 100644
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
@@ -71,9 +76,14 @@ struct ocores_i2c {
 #define STATE_READ		3
 #define STATE_ERROR		4
 
+#define TYPE_OCORES		0
+#define TYPE_GRLIB		1
+
 static inline void oc_setreg(struct ocores_i2c *i2c, int reg, u8 value)
 {
-	if (i2c->reg_io_width == 4)
+	if (i2c->setreg)
+		i2c->setreg(i2c, reg, value);
+	else if (i2c->reg_io_width == 4)
 		iowrite32(value, i2c->base + (reg << i2c->reg_shift));
 	else if (i2c->reg_io_width == 2)
 		iowrite16(value, i2c->base + (reg << i2c->reg_shift));
@@ -83,7 +93,9 @@ static inline void oc_setreg(struct ocores_i2c *i2c, int reg, u8 value)
 
 static inline u8 oc_getreg(struct ocores_i2c *i2c, int reg)
 {
-	if (i2c->reg_io_width == 4)
+	if (i2c->getreg)
+		return i2c->getreg(i2c, reg);
+	else if (i2c->reg_io_width == 4)
 		return ioread32(i2c->base + (reg << i2c->reg_shift));
 	else if (i2c->reg_io_width == 2)
 		return ioread16(i2c->base + (reg << i2c->reg_shift));
@@ -91,6 +103,40 @@ static inline u8 oc_getreg(struct ocores_i2c *i2c, int reg)
 		return ioread8(i2c->base + (reg << i2c->reg_shift));
 }
 
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
 static void ocores_process(struct ocores_i2c *i2c)
 {
 	struct i2c_msg *msg = i2c->msg;
@@ -228,6 +274,8 @@ static struct i2c_adapter ocores_adapter = {
 };
 
 #ifdef CONFIG_OF
+static int ocores_i2c_get_type(struct platform_device *pdev);
+
 static int ocores_i2c_of_probe(struct platform_device *pdev,
 				struct ocores_i2c *i2c)
 {
@@ -257,6 +305,13 @@ static int ocores_i2c_of_probe(struct platform_device *pdev,
 
 	of_property_read_u32(pdev->dev.of_node, "reg-io-width",
 				&i2c->reg_io_width);
+
+	if (ocores_i2c_get_type(pdev) == TYPE_GRLIB) {
+		dev_dbg(&pdev->dev, "GRLIB variant of i2c-ocores\n");
+		i2c->setreg = oc_setreg_grlib;
+		i2c->getreg = oc_getreg_grlib;
+	}
+
 	return 0;
 }
 #else
@@ -389,11 +444,29 @@ static SIMPLE_DEV_PM_OPS(ocores_i2c_pm, ocores_i2c_suspend, ocores_i2c_resume);
 #endif
 
 static struct of_device_id ocores_i2c_match[] = {
-	{ .compatible = "opencores,i2c-ocores", },
+	{
+		.compatible = "opencores,i2c-ocores",
+		.data = (void *)TYPE_OCORES,
+	},
+	{
+		.compatible = "aeroflexgaisler,i2cmst",
+		.data = (void *)TYPE_GRLIB,
+	},
 	{},
 };
 MODULE_DEVICE_TABLE(of, ocores_i2c_match);
 
+static int ocores_i2c_get_type(struct platform_device *pdev)
+{
+	const struct of_device_id *match;
+
+	match = of_match_node(ocores_i2c_match, pdev->dev.of_node);
+	if (match)
+		return (int)match->data;
+	else
+		return TYPE_OCORES;
+}
+
 static struct platform_driver ocores_i2c_driver = {
 	.probe   = ocores_i2c_probe,
 	.remove  = __devexit_p(ocores_i2c_remove),
-- 
1.7.0.4

