Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab2KLRAF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 12:00:05 -0500
Received: from vsp-authed02.binero.net ([195.74.38.226]:31878 "HELO
	vsp-authed-03-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751292Ab2KLRAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 12:00:02 -0500
From: Andreas Larsson <andreas@gaisler.com>
To: Wolfram Sang <w.sang@pengutronix.de>, Ben Dooks <ben-linux@fluff.org>,
        Peter Korsgaard <jacmet@sunsite.dk>
Cc: linux-i2c@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        software@gaisler.com
Subject: [PATCH v2 2/2] i2c: i2c-ocores: Add support for the GRLIB port of the controller and custom getreg and setreg functions
Date: Mon, 12 Nov 2012 17:59:51 +0100
Message-Id: <1352739591-1317-3-git-send-email-andreas@gaisler.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1352739591-1317-1-git-send-email-andreas@gaisler.com>
References: <1352739591-1317-1-git-send-email-andreas@gaisler.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The registers in the GRLIB port of the controller are 32-bit and in big endian
byte order. The PRELOW and PREHIGH registers are merged into one register. The
subsequent registers have their offset decreased accordingly. Hence the register
access needs to be handled in a non-standard manner using custom getreg and
setreg functions.

Signed-off-by: Andreas Larsson <andreas@gaisler.com>
Acked-by: Peter Korsgaard <jacmet@sunsite.dk>
---
Changes since v1:
 - Acked by Peter Korsgaard <jacmet@sunsite.dk>

 drivers/i2c/busses/i2c-ocores.c |   57 +++++++++++++++++++++++++++++++++++++-
 1 files changed, 55 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-ocores.c b/drivers/i2c/busses/i2c-ocores.c
index 0b71dc6..a4dc5c4 100644
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
@@ -73,7 +78,9 @@ struct ocores_i2c {
 
 static inline void oc_setreg(struct ocores_i2c *i2c, int reg, u8 value)
 {
-	if (i2c->reg_io_width == 4)
+	if (i2c->setreg)
+		i2c->setreg(i2c, reg, value);
+	else if (i2c->reg_io_width == 4)
 		iowrite32(value, i2c->base + (reg << i2c->reg_shift));
 	else if (i2c->reg_io_width == 2)
 		iowrite16(value, i2c->base + (reg << i2c->reg_shift));
@@ -83,7 +90,9 @@ static inline void oc_setreg(struct ocores_i2c *i2c, int reg, u8 value)
 
 static inline u8 oc_getreg(struct ocores_i2c *i2c, int reg)
 {
-	if (i2c->reg_io_width == 4)
+	if (i2c->getreg)
+		return i2c->getreg(i2c, reg);
+	else if (i2c->reg_io_width == 4)
 		return ioread32(i2c->base + (reg << i2c->reg_shift));
 	else if (i2c->reg_io_width == 2)
 		return ioread16(i2c->base + (reg << i2c->reg_shift));
@@ -91,6 +100,40 @@ static inline u8 oc_getreg(struct ocores_i2c *i2c, int reg)
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
+		return (u8)rd >> 8;
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
@@ -233,6 +276,7 @@ static int ocores_i2c_of_probe(struct platform_device *pdev,
 {
 	struct device_node *np = pdev->dev.of_node;
 	u32 val;
+	const char *name;
 
 	if (of_property_read_u32(np, "reg-shift", &i2c->reg_shift)) {
 		/* no 'reg-shift', check for deprecated 'regstep' */
@@ -257,6 +301,15 @@ static int ocores_i2c_of_probe(struct platform_device *pdev,
 
 	of_property_read_u32(pdev->dev.of_node, "reg-io-width",
 				&i2c->reg_io_width);
+
+	name = of_get_property(pdev->dev.of_node, "name", NULL);
+	if (name && (!strcmp(name, "GAISLER_I2CMST") ||
+		     !strcmp(name, "01_028"))) {
+		dev_dbg(&pdev->dev, "GRLIB variant of i2c-ocores\n");
+		i2c->setreg = oc_setreg_grlib;
+		i2c->getreg = oc_getreg_grlib;
+	}
+
 	return 0;
 }
 #else
-- 
1.7.0.4

