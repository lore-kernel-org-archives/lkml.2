Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900Ab1LVO6y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 09:58:54 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:41419 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753207Ab1LVO6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 09:58:36 -0500
From: Benoit Cousson <b-cousson@ti.com>
To: <rob.herring@calxeda.com>, <tony@atomide.com>
CC: <linux-omap@vger.kernel.org>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <grant.likely@secretlab.ca>,
        <linux-i2c@vger.kernel.org>, <sameo@linux.intel.com>,
        <ben-linux@fluff.org>, Benoit Cousson <b-cousson@ti.com>,
        Kevin Hilman <khilman@ti.com>
Subject: [PATCH v4 02/12] i2c: OMAP: Add DT support for i2c controller
Date: Thu, 22 Dec 2011 15:56:36 +0100
Message-ID: <1324565806-31142-3-git-send-email-b-cousson@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1324565806-31142-1-git-send-email-b-cousson@ti.com>
References: <1324565806-31142-1-git-send-email-b-cousson@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add initial DT support to retrieve the frequency using a
DT attribute instead of the pdata pointer if of_node exist.

Add documentation for omap i2c controller binding.

Based on original patches from Manju and Grant.

Signed-off-by: Benoit Cousson <b-cousson@ti.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Kevin Hilman <khilman@ti.com>
Reviewed-by: Rob Herring <rob.herring@calxeda.com>
---
 Documentation/devicetree/bindings/i2c/omap-i2c.txt |   30 ++++++
 drivers/i2c/busses/i2c-omap.c                      |  102 +++++++++++++-------
 2 files changed, 97 insertions(+), 35 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/i2c/omap-i2c.txt

diff --git a/Documentation/devicetree/bindings/i2c/omap-i2c.txt b/Documentation/devicetree/bindings/i2c/omap-i2c.txt
new file mode 100644
index 0000000..56564aa
--- /dev/null
+++ b/Documentation/devicetree/bindings/i2c/omap-i2c.txt
@@ -0,0 +1,30 @@
+I2C for OMAP platforms
+
+Required properties :
+- compatible : Must be "ti,omap3-i2c" or "ti,omap4-i2c"
+- ti,hwmods : Must be "i2c<n>", n being the instance number (1-based)
+- #address-cells = <1>;
+- #size-cells = <0>;
+
+Recommended properties :
+- clock-frequency : Desired I2C bus clock frequency in Hz. Otherwise
+  the default 100 kHz frequency will be used.
+
+Optional properties:
+- Child nodes conforming to i2c bus binding
+
+Note: Current implementation will fetch base address, irq and dma
+from omap hwmod data base during device registration.
+Future plan is to migrate hwmod data base contents into device tree
+blob so that, all the required data will be used from device tree dts
+file.
+
+Examples :
+
+i2c1: i2c@0 {
+    compatible = "ti,omap3-i2c";
+    #address-cells = <1>;
+    #size-cells = <0>;
+    ti,hwmods = "i2c1";
+    clock-frequency = <400000>;
+};
diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index a43d002..b03b3e3 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -37,6 +37,9 @@
 #include <linux/platform_device.h>
 #include <linux/clk.h>
 #include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_i2c.h>
+#include <linux/of_device.h>
 #include <linux/slab.h>
 #include <linux/i2c-omap.h>
 #include <linux/pm_runtime.h>
@@ -182,7 +185,9 @@ struct omap_i2c_dev {
 	u32			latency;	/* maximum mpu wkup latency */
 	void			(*set_mpu_wkup_lat)(struct device *dev,
 						    long latency);
-	u32			speed;		/* Speed of bus in Khz */
+	u32			speed;		/* Speed of bus in kHz */
+	u32			dtrev;		/* extra revision from DT */
+	u32			flags;
 	u16			cmd_err;
 	u8			*buf;
 	u8			*regs;
@@ -266,11 +271,7 @@ static inline u16 omap_i2c_read_reg(struct omap_i2c_dev *i2c_dev, int reg)
 
 static void omap_i2c_unidle(struct omap_i2c_dev *dev)
 {
-	struct omap_i2c_bus_platform_data *pdata;
-
-	pdata = dev->dev->platform_data;
-
-	if (pdata->flags & OMAP_I2C_FLAG_RESET_REGS_POSTIDLE) {
+	if (dev->flags & OMAP_I2C_FLAG_RESET_REGS_POSTIDLE) {
 		omap_i2c_write_reg(dev, OMAP_I2C_CON_REG, 0);
 		omap_i2c_write_reg(dev, OMAP_I2C_PSC_REG, dev->pscstate);
 		omap_i2c_write_reg(dev, OMAP_I2C_SCLL_REG, dev->scllstate);
@@ -291,13 +292,10 @@ static void omap_i2c_unidle(struct omap_i2c_dev *dev)
 
 static void omap_i2c_idle(struct omap_i2c_dev *dev)
 {
-	struct omap_i2c_bus_platform_data *pdata;
 	u16 iv;
 
-	pdata = dev->dev->platform_data;
-
 	dev->iestate = omap_i2c_read_reg(dev, OMAP_I2C_IE_REG);
-	if (pdata->rev == OMAP_I2C_IP_VERSION_2)
+	if (dev->dtrev == OMAP_I2C_IP_VERSION_2)
 		omap_i2c_write_reg(dev, OMAP_I2C_IP_V2_IRQENABLE_CLR, 1);
 	else
 		omap_i2c_write_reg(dev, OMAP_I2C_IE_REG, 0);
@@ -320,9 +318,6 @@ static int omap_i2c_init(struct omap_i2c_dev *dev)
 	unsigned long timeout;
 	unsigned long internal_clk = 0;
 	struct clk *fclk;
-	struct omap_i2c_bus_platform_data *pdata;
-
-	pdata = dev->dev->platform_data;
 
 	if (dev->rev >= OMAP_I2C_OMAP1_REV_2) {
 		/* Disable I2C controller before soft reset */
@@ -373,7 +368,7 @@ static int omap_i2c_init(struct omap_i2c_dev *dev)
 	}
 	omap_i2c_write_reg(dev, OMAP_I2C_CON_REG, 0);
 
-	if (pdata->flags & OMAP_I2C_FLAG_ALWAYS_ARMXOR_CLK) {
+	if (dev->flags & OMAP_I2C_FLAG_ALWAYS_ARMXOR_CLK) {
 		/*
 		 * The I2C functional clock is the armxor_ck, so there's
 		 * no need to get "armxor_ck" separately.  Now, if OMAP2420
@@ -397,7 +392,7 @@ static int omap_i2c_init(struct omap_i2c_dev *dev)
 			psc = fclk_rate / 12000000;
 	}
 
-	if (!(pdata->flags & OMAP_I2C_FLAG_SIMPLE_CLOCK)) {
+	if (!(dev->flags & OMAP_I2C_FLAG_SIMPLE_CLOCK)) {
 
 		/*
 		 * HSI2C controller internal clk rate should be 19.2 Mhz for
@@ -406,7 +401,7 @@ static int omap_i2c_init(struct omap_i2c_dev *dev)
 		 * The filter is iclk (fclk for HS) period.
 		 */
 		if (dev->speed > 400 ||
-			       pdata->flags & OMAP_I2C_FLAG_FORCE_19200_INT_CLK)
+			       dev->flags & OMAP_I2C_FLAG_FORCE_19200_INT_CLK)
 			internal_clk = 19200;
 		else if (dev->speed > 100)
 			internal_clk = 9600;
@@ -475,7 +470,7 @@ static int omap_i2c_init(struct omap_i2c_dev *dev)
 
 	dev->errata = 0;
 
-	if (pdata->flags & OMAP_I2C_FLAG_APPLY_ERRATA_I207)
+	if (dev->flags & OMAP_I2C_FLAG_APPLY_ERRATA_I207)
 		dev->errata |= I2C_OMAP_ERRATA_I207;
 
 	/* Enable interrupts */
@@ -484,7 +479,7 @@ static int omap_i2c_init(struct omap_i2c_dev *dev)
 			OMAP_I2C_IE_AL)  | ((dev->fifo_size) ?
 				(OMAP_I2C_IE_RDR | OMAP_I2C_IE_XDR) : 0);
 	omap_i2c_write_reg(dev, OMAP_I2C_IE_REG, dev->iestate);
-	if (pdata->flags & OMAP_I2C_FLAG_RESET_REGS_POSTIDLE) {
+	if (dev->flags & OMAP_I2C_FLAG_RESET_REGS_POSTIDLE) {
 		dev->pscstate = psc;
 		dev->scllstate = scll;
 		dev->sclhstate = sclh;
@@ -804,9 +799,6 @@ omap_i2c_isr(int this_irq, void *dev_id)
 	u16 bits;
 	u16 stat, w;
 	int err, count = 0;
-	struct omap_i2c_bus_platform_data *pdata;
-
-	pdata = dev->dev->platform_data;
 
 	if (pm_runtime_suspended(dev->dev))
 		return IRQ_NONE;
@@ -875,7 +867,7 @@ complete:
 					 * Data reg in 2430, omap3 and
 					 * omap4 is 8 bit wide
 					 */
-					if (pdata->flags &
+					if (dev->flags &
 						 OMAP_I2C_FLAG_16BIT_DATA_REG) {
 						if (dev->buf_len) {
 							*dev->buf++ = w >> 8;
@@ -918,7 +910,7 @@ complete:
 					 * Data reg in 2430, omap3 and
 					 * omap4 is 8 bit wide
 					 */
-					if (pdata->flags &
+					if (dev->flags &
 						 OMAP_I2C_FLAG_16BIT_DATA_REG) {
 						if (dev->buf_len) {
 							w |= *dev->buf++ << 8;
@@ -965,6 +957,32 @@ static const struct i2c_algorithm omap_i2c_algo = {
 	.functionality	= omap_i2c_func,
 };
 
+#ifdef CONFIG_OF
+static struct omap_i2c_bus_platform_data omap3_pdata = {
+	.rev = OMAP_I2C_IP_VERSION_1,
+	.flags = OMAP_I2C_FLAG_APPLY_ERRATA_I207 |
+		 OMAP_I2C_FLAG_RESET_REGS_POSTIDLE |
+		 OMAP_I2C_FLAG_BUS_SHIFT_2,
+};
+
+static struct omap_i2c_bus_platform_data omap4_pdata = {
+	.rev = OMAP_I2C_IP_VERSION_2,
+};
+
+static const struct of_device_id omap_i2c_of_match[] = {
+	{
+		.compatible = "ti,omap4-i2c",
+		.data = &omap4_pdata,
+	},
+	{
+		.compatible = "ti,omap3-i2c",
+		.data = &omap3_pdata,
+	},
+	{ },
+};
+MODULE_DEVICE_TABLE(of, omap_i2c_of_match);
+#endif
+
 static int __devinit
 omap_i2c_probe(struct platform_device *pdev)
 {
@@ -972,9 +990,10 @@ omap_i2c_probe(struct platform_device *pdev)
 	struct i2c_adapter	*adap;
 	struct resource		*mem, *irq, *ioarea;
 	struct omap_i2c_bus_platform_data *pdata = pdev->dev.platform_data;
+	struct device_node	*node = pdev->dev.of_node;
+	const struct of_device_id *match;
 	irq_handler_t isr;
 	int r;
-	u32 speed = 0;
 
 	/* NOTE: driver uses the static register mapping */
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -1001,15 +1020,24 @@ omap_i2c_probe(struct platform_device *pdev)
 		goto err_release_region;
 	}
 
-	if (pdata != NULL) {
-		speed = pdata->clkrate;
+	match = of_match_device(omap_i2c_of_match, &pdev->dev);
+	if (match) {
+		u32 freq = 100000; /* default to 100000 Hz */
+
+		pdata = match->data;
+		dev->dtrev = pdata->rev;
+		dev->flags = pdata->flags;
+
+		of_property_read_u32(node, "clock-frequency", &freq);
+		/* convert DT freq value in Hz into kHz for speed */
+		dev->speed = freq / 1000;
+	} else if (pdata != NULL) {
+		dev->speed = pdata->clkrate;
+		dev->flags = pdata->flags;
 		dev->set_mpu_wkup_lat = pdata->set_mpu_wkup_lat;
-	} else {
-		speed = 100;	/* Default speed */
-		dev->set_mpu_wkup_lat = NULL;
+		dev->dtrev = pdata->rev;
 	}
 
-	dev->speed = speed;
 	dev->dev = &pdev->dev;
 	dev->irq = irq->start;
 	dev->base = ioremap(mem->start, resource_size(mem));
@@ -1020,9 +1048,9 @@ omap_i2c_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, dev);
 
-	dev->reg_shift = (pdata->flags >> OMAP_I2C_FLAG_BUS_SHIFT__SHIFT) & 3;
+	dev->reg_shift = (dev->flags >> OMAP_I2C_FLAG_BUS_SHIFT__SHIFT) & 3;
 
-	if (pdata->rev == OMAP_I2C_IP_VERSION_2)
+	if (dev->dtrev == OMAP_I2C_IP_VERSION_2)
 		dev->regs = (u8 *)reg_map_ip_v2;
 	else
 		dev->regs = (u8 *)reg_map_ip_v1;
@@ -1035,7 +1063,7 @@ omap_i2c_probe(struct platform_device *pdev)
 	if (dev->rev <= OMAP_I2C_REV_ON_3430)
 		dev->errata |= I2C_OMAP3_1P153;
 
-	if (!(pdata->flags & OMAP_I2C_FLAG_NO_FIFO)) {
+	if (!(dev->flags & OMAP_I2C_FLAG_NO_FIFO)) {
 		u16 s;
 
 		/* Set up the fifo size - Get total size */
@@ -1057,7 +1085,7 @@ omap_i2c_probe(struct platform_device *pdev)
 		/* calculate wakeup latency constraint for MPU */
 		if (dev->set_mpu_wkup_lat != NULL)
 			dev->latency = (1000000 * dev->fifo_size) /
-				       (1000 * speed / 8);
+				       (1000 * dev->speed / 8);
 	}
 
 	/* reset ASAP, clearing any IRQs */
@@ -1073,7 +1101,7 @@ omap_i2c_probe(struct platform_device *pdev)
 	}
 
 	dev_info(dev->dev, "bus %d rev%d.%d.%d at %d kHz\n", pdev->id,
-		 pdata->rev, dev->rev >> 4, dev->rev & 0xf, dev->speed);
+		 dev->dtrev, dev->rev >> 4, dev->rev & 0xf, dev->speed);
 
 	pm_runtime_put(dev->dev);
 
@@ -1084,6 +1112,7 @@ omap_i2c_probe(struct platform_device *pdev)
 	strlcpy(adap->name, "OMAP I2C adapter", sizeof(adap->name));
 	adap->algo = &omap_i2c_algo;
 	adap->dev.parent = &pdev->dev;
+	adap->dev.of_node = pdev->dev.of_node;
 
 	/* i2c device drivers may be active on return from add_adapter() */
 	adap->nr = pdev->id;
@@ -1093,6 +1122,8 @@ omap_i2c_probe(struct platform_device *pdev)
 		goto err_free_irq;
 	}
 
+	of_i2c_register_devices(adap);
+
 	return 0;
 
 err_free_irq:
@@ -1165,6 +1196,7 @@ static struct platform_driver omap_i2c_driver = {
 		.name	= "omap_i2c",
 		.owner	= THIS_MODULE,
 		.pm	= OMAP_I2C_PM_OPS,
+		.of_match_table = of_match_ptr(omap_i2c_of_match),
 	},
 };
 
-- 
1.7.0.4

