Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767995Ab2KOOJm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 09:09:42 -0500
Received: from vsp-authed02.binero.net ([195.74.38.226]:19557 "HELO
	vsp-authed-03-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1767968Ab2KOOJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 09:09:28 -0500
From: Andreas Larsson <andreas@gaisler.com>
To: Wolfram Sang <w.sang@pengutronix.de>, Ben Dooks <ben-linux@fluff.org>,
        Peter Korsgaard <jacmet@sunsite.dk>
Cc: linux-i2c@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        software@gaisler.com
Subject: [PATCH v5 2/2] i2c: i2c-ocores: Add support for the GRLIB port of the controller and use function pointers for getreg and setreg functions
Date: Thu, 15 Nov 2012 15:09:08 +0100
Message-Id: <1352988548-10138-3-git-send-email-andreas@gaisler.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1352988548-10138-1-git-send-email-andreas@gaisler.com>
References: <1352988548-10138-1-git-send-email-andreas@gaisler.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The registers in the GRLIB port of the controller are 32-bit and in big endian
byte order. The PRELOW and PREHIGH registers are merged into one register. The
subsequent registers have their offset decreased accordingly. Hence the register
access needs to be handled in a non-standard manner using custom getreg and
setreg functions.

The single oc_getreg and one oc_setreg functions, that branches and call
different ioread and iowrite functions, are replaced by specific functions that
uses the appropriate ioread and iowrite functions and function pointers are
initiated and used to call the approproate functions.

A type is added as the data of the of match table entries. A new entry with a
different compatible string is added to the table. The type of that entry
triggers usage of the custom grlib functions by setting the new getreg and
setreg function pointers to these functions.

Signed-off-by: Andreas Larsson <andreas@gaisler.com>
---
 Changes since v4:
 - Replace the ocores_get_type function with inline code in the probe function
 - Replace the oc_(get|set)reg functions with oc_(get|set)reg_(8|16|32)
   functions and always use the function pointers to call them.

 .../devicetree/bindings/i2c/i2c-ocores.txt         |    2 +-
 drivers/i2c/busses/i2c-ocores.c                    |  176 +++++++++++++++-----
 2 files changed, 132 insertions(+), 46 deletions(-)

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
index 1d204cb..566193d 100644
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
@@ -71,34 +76,82 @@ struct ocores_i2c {
 #define STATE_READ		3
 #define STATE_ERROR		4
 
-static inline void oc_setreg(struct ocores_i2c *i2c, int reg, u8 value)
+#define TYPE_OCORES		0
+#define TYPE_GRLIB		1
+
+static void oc_setreg_8(struct ocores_i2c *i2c, int reg, u8 value)
 {
-	if (i2c->reg_io_width == 4)
-		iowrite32(value, i2c->base + (reg << i2c->reg_shift));
-	else if (i2c->reg_io_width == 2)
-		iowrite16(value, i2c->base + (reg << i2c->reg_shift));
-	else
-		iowrite8(value, i2c->base + (reg << i2c->reg_shift));
+	iowrite8(value, i2c->base + (reg << i2c->reg_shift));
+}
+
+static void oc_setreg_16(struct ocores_i2c *i2c, int reg, u8 value)
+{
+	iowrite16(value, i2c->base + (reg << i2c->reg_shift));
 }
 
-static inline u8 oc_getreg(struct ocores_i2c *i2c, int reg)
+static void oc_setreg_32(struct ocores_i2c *i2c, int reg, u8 value)
 {
-	if (i2c->reg_io_width == 4)
-		return ioread32(i2c->base + (reg << i2c->reg_shift));
-	else if (i2c->reg_io_width == 2)
-		return ioread16(i2c->base + (reg << i2c->reg_shift));
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
 	else
-		return ioread8(i2c->base + (reg << i2c->reg_shift));
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
 }
 
 static void ocores_process(struct ocores_i2c *i2c)
 {
 	struct i2c_msg *msg = i2c->msg;
-	u8 stat = oc_getreg(i2c, OCI2C_STATUS);
+	u8 stat = i2c->getreg(i2c, OCI2C_STATUS);
 
 	if ((i2c->state == STATE_DONE) || (i2c->state == STATE_ERROR)) {
 		/* stop has been sent */
-		oc_setreg(i2c, OCI2C_CMD, OCI2C_CMD_IACK);
+		i2c->setreg(i2c, OCI2C_CMD, OCI2C_CMD_IACK);
 		wake_up(&i2c->wait);
 		return;
 	}
@@ -106,7 +159,7 @@ static void ocores_process(struct ocores_i2c *i2c)
 	/* error? */
 	if (stat & OCI2C_STAT_ARBLOST) {
 		i2c->state = STATE_ERROR;
-		oc_setreg(i2c, OCI2C_CMD, OCI2C_CMD_STOP);
+		i2c->setreg(i2c, OCI2C_CMD, OCI2C_CMD_STOP);
 		return;
 	}
 
@@ -116,11 +169,11 @@ static void ocores_process(struct ocores_i2c *i2c)
 
 		if (stat & OCI2C_STAT_NACK) {
 			i2c->state = STATE_ERROR;
-			oc_setreg(i2c, OCI2C_CMD, OCI2C_CMD_STOP);
+			i2c->setreg(i2c, OCI2C_CMD, OCI2C_CMD_STOP);
 			return;
 		}
 	} else
-		msg->buf[i2c->pos++] = oc_getreg(i2c, OCI2C_DATA);
+		msg->buf[i2c->pos++] = i2c->getreg(i2c, OCI2C_DATA);
 
 	/* end of msg? */
 	if (i2c->pos == msg->len) {
@@ -139,25 +192,25 @@ static void ocores_process(struct ocores_i2c *i2c)
 
 				i2c->state = STATE_START;
 
-				oc_setreg(i2c, OCI2C_DATA, addr);
-				oc_setreg(i2c, OCI2C_CMD,  OCI2C_CMD_START);
+				i2c->setreg(i2c, OCI2C_DATA, addr);
+				i2c->setreg(i2c, OCI2C_CMD,  OCI2C_CMD_START);
 				return;
 			} else
 				i2c->state = (msg->flags & I2C_M_RD)
 					? STATE_READ : STATE_WRITE;
 		} else {
 			i2c->state = STATE_DONE;
-			oc_setreg(i2c, OCI2C_CMD, OCI2C_CMD_STOP);
+			i2c->setreg(i2c, OCI2C_CMD, OCI2C_CMD_STOP);
 			return;
 		}
 	}
 
 	if (i2c->state == STATE_READ) {
-		oc_setreg(i2c, OCI2C_CMD, i2c->pos == (msg->len-1) ?
-			  OCI2C_CMD_READ_NACK : OCI2C_CMD_READ_ACK);
+		i2c->setreg(i2c, OCI2C_CMD, i2c->pos == (msg->len-1) ?
+			    OCI2C_CMD_READ_NACK : OCI2C_CMD_READ_ACK);
 	} else {
-		oc_setreg(i2c, OCI2C_DATA, msg->buf[i2c->pos++]);
-		oc_setreg(i2c, OCI2C_CMD, OCI2C_CMD_WRITE);
+		i2c->setreg(i2c, OCI2C_DATA, msg->buf[i2c->pos++]);
+		i2c->setreg(i2c, OCI2C_CMD, OCI2C_CMD_WRITE);
 	}
 }
 
@@ -179,11 +232,11 @@ static int ocores_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 	i2c->nmsgs = num;
 	i2c->state = STATE_START;
 
-	oc_setreg(i2c, OCI2C_DATA,
-			(i2c->msg->addr << 1) |
-			((i2c->msg->flags & I2C_M_RD) ? 1:0));
+	i2c->setreg(i2c, OCI2C_DATA,
+		    (i2c->msg->addr << 1) |
+		    ((i2c->msg->flags & I2C_M_RD) ? 1:0));
 
-	oc_setreg(i2c, OCI2C_CMD, OCI2C_CMD_START);
+	i2c->setreg(i2c, OCI2C_CMD, OCI2C_CMD_START);
 
 	if (wait_event_timeout(i2c->wait, (i2c->state == STATE_ERROR) ||
 			       (i2c->state == STATE_DONE), HZ))
@@ -195,18 +248,18 @@ static int ocores_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 static void ocores_init(struct ocores_i2c *i2c)
 {
 	int prescale;
-	u8 ctrl = oc_getreg(i2c, OCI2C_CONTROL);
+	u8 ctrl = i2c->getreg(i2c, OCI2C_CONTROL);
 
 	/* make sure the device is disabled */
-	oc_setreg(i2c, OCI2C_CONTROL, ctrl & ~(OCI2C_CTRL_EN|OCI2C_CTRL_IEN));
+	i2c->setreg(i2c, OCI2C_CONTROL, ctrl & ~(OCI2C_CTRL_EN|OCI2C_CTRL_IEN));
 
 	prescale = (i2c->clock_khz / (5*100)) - 1;
-	oc_setreg(i2c, OCI2C_PRELOW, prescale & 0xff);
-	oc_setreg(i2c, OCI2C_PREHIGH, prescale >> 8);
+	i2c->setreg(i2c, OCI2C_PRELOW, prescale & 0xff);
+	i2c->setreg(i2c, OCI2C_PREHIGH, prescale >> 8);
 
 	/* Init the device */
-	oc_setreg(i2c, OCI2C_CMD, OCI2C_CMD_IACK);
-	oc_setreg(i2c, OCI2C_CONTROL, ctrl | OCI2C_CTRL_IEN | OCI2C_CTRL_EN);
+	i2c->setreg(i2c, OCI2C_CMD, OCI2C_CMD_IACK);
+	i2c->setreg(i2c, OCI2C_CONTROL, ctrl | OCI2C_CTRL_IEN | OCI2C_CTRL_EN);
 }
 
 
@@ -227,11 +280,25 @@ static struct i2c_adapter ocores_adapter = {
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
@@ -257,6 +324,14 @@ static int ocores_i2c_of_probe(struct platform_device *pdev,
 
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
@@ -311,6 +386,23 @@ static int __devinit ocores_i2c_probe(struct platform_device *pdev)
 	if (i2c->reg_io_width == 0)
 		i2c->reg_io_width = 1; /* Set to default value */
 
+	if (!i2c->getreg) {
+		if (i2c->reg_io_width == 4)
+			i2c->getreg = oc_getreg_32;
+		else if (i2c->reg_io_width == 2)
+			i2c->getreg = oc_getreg_16;
+		else
+			i2c->getreg = oc_getreg_8;
+	}
+	if (!i2c->setreg) {
+		if (i2c->reg_io_width == 4)
+			i2c->setreg = oc_setreg_32;
+		else if (i2c->reg_io_width == 2)
+			i2c->setreg = oc_setreg_16;
+		else
+			i2c->setreg = oc_setreg_8;
+	}
+
 	ocores_init(i2c);
 
 	init_waitqueue_head(&i2c->wait);
@@ -351,8 +443,8 @@ static int __devexit ocores_i2c_remove(struct platform_device *pdev)
 	struct ocores_i2c *i2c = platform_get_drvdata(pdev);
 
 	/* disable i2c logic */
-	oc_setreg(i2c, OCI2C_CONTROL, oc_getreg(i2c, OCI2C_CONTROL)
-		  & ~(OCI2C_CTRL_EN|OCI2C_CTRL_IEN));
+	i2c->setreg(i2c, OCI2C_CONTROL, i2c->getreg(i2c, OCI2C_CONTROL)
+		    & ~(OCI2C_CTRL_EN|OCI2C_CTRL_IEN));
 
 	/* remove adapter & data */
 	i2c_del_adapter(&i2c->adap);
@@ -365,10 +457,10 @@ static int __devexit ocores_i2c_remove(struct platform_device *pdev)
 static int ocores_i2c_suspend(struct device *dev)
 {
 	struct ocores_i2c *i2c = dev_get_drvdata(dev);
-	u8 ctrl = oc_getreg(i2c, OCI2C_CONTROL);
+	u8 ctrl = i2c->getreg(i2c, OCI2C_CONTROL);
 
 	/* make sure the device is disabled */
-	oc_setreg(i2c, OCI2C_CONTROL, ctrl & ~(OCI2C_CTRL_EN|OCI2C_CTRL_IEN));
+	i2c->setreg(i2c, OCI2C_CONTROL, ctrl & ~(OCI2C_CTRL_EN|OCI2C_CTRL_IEN));
 
 	return 0;
 }
@@ -388,12 +480,6 @@ static SIMPLE_DEV_PM_OPS(ocores_i2c_pm, ocores_i2c_suspend, ocores_i2c_resume);
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

