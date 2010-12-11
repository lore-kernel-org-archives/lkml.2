Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324Ab0LKGbW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Dec 2010 01:31:22 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:60452 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab0LKGbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Dec 2010 01:31:20 -0500
X-Auth-Info: L1SxCGnf1QBWRXj5MQWqMwH3IpILRCURClIvQEosFto=
From: Heiko Schocher <hs@denx.de>
To: linuxppc-dev@lists.ozlabs.org
Cc: Heiko Schocher <hs@denx.de>, linux-fbdev@vger.kernel.org,
        devicetree-discuss@ozlabs.org, Ben Dooks <ben@simtec.co.uk>,
        Vincent Sanders <vince@simtec.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] video, sm501: add OF binding to support SM501
Date: Sat, 11 Dec 2010 07:31:15 +0100
Message-Id: <1292049075-1809-1-git-send-email-hs@denx.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1291451028-22532-1-git-send-email-hs@denx.de>
References: <1291451028-22532-1-git-send-email-hs@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- add binding to OF, compatible name "smi,sm501"

- add read/write functions for using this driver
  also on powerpc plattforms

- add commandline options:
  sm501.fb_mode:
    Specify resolution as "<xres>x<yres>[-<bpp>][@<refresh>]"
  sm501.bpp:
    Specify bit-per-pixel if not specified mode

- Add support for encoding display mode information
  in the device tree using verbatim EDID block.

  If the "edid" entry in the "smi,sm501" node is present,
  the driver will build mode database using EDID data
  and allow setting the display modes from this database.

Signed-off-by: Heiko Schocher <hs@denx.de>
cc: linux-fbdev@vger.kernel.org
cc: devicetree-discuss@ozlabs.org
cc: Ben Dooks <ben@simtec.co.uk>
cc: Vincent Sanders <vince@simtec.co.uk>
cc: Samuel Ortiz <sameo@linux.intel.com>
cc: linux-kernel@vger.kernel.org

---
- changes since v1:
  add Ben Dooks, Vincent Sanders and Samuel Ortiz to cc, as suggested from
  Paul Mundt.

 Documentation/kernel-parameters.txt          |    7 +
 Documentation/powerpc/dts-bindings/sm501.txt |   30 +++
 drivers/mfd/sm501.c                          |  141 ++++++++------
 drivers/video/sm501fb.c                      |  264 +++++++++++++++++---------
 include/linux/sm501.h                        |    8 +
 5 files changed, 299 insertions(+), 151 deletions(-)
 create mode 100644 Documentation/powerpc/dts-bindings/sm501.txt

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index cdd2a6e..6341541 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2301,6 +2301,13 @@ and is between 256 and 4096 characters. It is defined in the file
 			merging on their own.
 			For more information see Documentation/vm/slub.txt.
 
+	sm501.bpp=	SM501 Display driver:
+			Specify bit-per-pixel if not specified mode
+
+	sm501fb.mode=	SM501 Display driver:
+			Specify resolution as
+			"<xres>x<yres>[-<bpp>][@<refresh>]"
+
 	smart2=		[HW]
 			Format: <io1>[,<io2>[,...,<io8>]]
 
diff --git a/Documentation/powerpc/dts-bindings/sm501.txt b/Documentation/powerpc/dts-bindings/sm501.txt
new file mode 100644
index 0000000..9905dd9
--- /dev/null
+++ b/Documentation/powerpc/dts-bindings/sm501.txt
@@ -0,0 +1,30 @@
+* SM SM501
+
+The SM SM501 is a LCD controller, with proper hardware, it can also
+drive DVI monitors.
+
+Required properties:
+- compatible : should be "smi,sm501".
+- reg : contain two entries:
+    - First entry: System Configuration register
+    - Second entry: IO space (Display Controller register)
+- interrupts : SMI interrupt to the cpu should be described here.
+- interrupt-parent : the phandle for the interrupt controller that
+  services interrupts for this device.
+
+Optional properties:
+- mode : select a video mode:
+    <xres>x<yres>[-<bpp>][@<refresh>]
+- edid : verbatim EDID data block describing attached display.
+  Data from the detailed timing descriptor will be used to
+  program the display controller.
+
+Example for MPC5200:
+	display@1,0 {
+		compatible = "smi,sm501";
+		reg = <1 0x00000000 0x00800000
+		       1 0x03e00000 0x00200000>;
+		interrupts = <1 1 3>;
+		mode = "640x480-32@60";
+		edid = [edid-data];
+	};
diff --git a/drivers/mfd/sm501.c b/drivers/mfd/sm501.c
index bc9275c..d1f952c 100644
--- a/drivers/mfd/sm501.c
+++ b/drivers/mfd/sm501.c
@@ -133,10 +133,10 @@ static unsigned long decode_div(unsigned long pll2, unsigned long val,
 
 static void sm501_dump_clk(struct sm501_devdata *sm)
 {
-	unsigned long misct = readl(sm->regs + SM501_MISC_TIMING);
-	unsigned long pm0 = readl(sm->regs + SM501_POWER_MODE_0_CLOCK);
-	unsigned long pm1 = readl(sm->regs + SM501_POWER_MODE_1_CLOCK);
-	unsigned long pmc = readl(sm->regs + SM501_POWER_MODE_CONTROL);
+	unsigned long misct = smc501_readl(sm->regs + SM501_MISC_TIMING);
+	unsigned long pm0 = smc501_readl(sm->regs + SM501_POWER_MODE_0_CLOCK);
+	unsigned long pm1 = smc501_readl(sm->regs + SM501_POWER_MODE_1_CLOCK);
+	unsigned long pmc = smc501_readl(sm->regs + SM501_POWER_MODE_CONTROL);
 	unsigned long sdclk0, sdclk1;
 	unsigned long pll2 = 0;
 
@@ -193,29 +193,29 @@ static void sm501_dump_regs(struct sm501_devdata *sm)
 	void __iomem *regs = sm->regs;
 
 	dev_info(sm->dev, "System Control   %08x\n",
-			readl(regs + SM501_SYSTEM_CONTROL));
+			smc501_readl(regs + SM501_SYSTEM_CONTROL));
 	dev_info(sm->dev, "Misc Control     %08x\n",
-			readl(regs + SM501_MISC_CONTROL));
+			smc501_readl(regs + SM501_MISC_CONTROL));
 	dev_info(sm->dev, "GPIO Control Low %08x\n",
-			readl(regs + SM501_GPIO31_0_CONTROL));
+			smc501_readl(regs + SM501_GPIO31_0_CONTROL));
 	dev_info(sm->dev, "GPIO Control Hi  %08x\n",
-			readl(regs + SM501_GPIO63_32_CONTROL));
+			smc501_readl(regs + SM501_GPIO63_32_CONTROL));
 	dev_info(sm->dev, "DRAM Control     %08x\n",
-			readl(regs + SM501_DRAM_CONTROL));
+			smc501_readl(regs + SM501_DRAM_CONTROL));
 	dev_info(sm->dev, "Arbitration Ctrl %08x\n",
-			readl(regs + SM501_ARBTRTN_CONTROL));
+			smc501_readl(regs + SM501_ARBTRTN_CONTROL));
 	dev_info(sm->dev, "Misc Timing      %08x\n",
-			readl(regs + SM501_MISC_TIMING));
+			smc501_readl(regs + SM501_MISC_TIMING));
 }
 
 static void sm501_dump_gate(struct sm501_devdata *sm)
 {
 	dev_info(sm->dev, "CurrentGate      %08x\n",
-			readl(sm->regs + SM501_CURRENT_GATE));
+			smc501_readl(sm->regs + SM501_CURRENT_GATE));
 	dev_info(sm->dev, "CurrentClock     %08x\n",
-			readl(sm->regs + SM501_CURRENT_CLOCK));
+			smc501_readl(sm->regs + SM501_CURRENT_CLOCK));
 	dev_info(sm->dev, "PowerModeControl %08x\n",
-			readl(sm->regs + SM501_POWER_MODE_CONTROL));
+			smc501_readl(sm->regs + SM501_POWER_MODE_CONTROL));
 }
 
 #else
@@ -231,7 +231,7 @@ static inline void sm501_dump_clk(struct sm501_devdata *sm) { }
 
 static void sm501_sync_regs(struct sm501_devdata *sm)
 {
-	readl(sm->regs);
+	smc501_readl(sm->regs);
 }
 
 static inline void sm501_mdelay(struct sm501_devdata *sm, unsigned int delay)
@@ -261,11 +261,11 @@ int sm501_misc_control(struct device *dev,
 
 	spin_lock_irqsave(&sm->reg_lock, save);
 
-	misc = readl(sm->regs + SM501_MISC_CONTROL);
+	misc = smc501_readl(sm->regs + SM501_MISC_CONTROL);
 	to = (misc & ~clear) | set;
 
 	if (to != misc) {
-		writel(to, sm->regs + SM501_MISC_CONTROL);
+		smc501_writel(to, sm->regs + SM501_MISC_CONTROL);
 		sm501_sync_regs(sm);
 
 		dev_dbg(sm->dev, "MISC_CONTROL %08lx\n", misc);
@@ -294,11 +294,11 @@ unsigned long sm501_modify_reg(struct device *dev,
 
 	spin_lock_irqsave(&sm->reg_lock, save);
 
-	data = readl(sm->regs + reg);
+	data = smc501_readl(sm->regs + reg);
 	data |= set;
 	data &= ~clear;
 
-	writel(data, sm->regs + reg);
+	smc501_writel(data, sm->regs + reg);
 	sm501_sync_regs(sm);
 
 	spin_unlock_irqrestore(&sm->reg_lock, save);
@@ -322,9 +322,9 @@ int sm501_unit_power(struct device *dev, unsigned int unit, unsigned int to)
 
 	mutex_lock(&sm->clock_lock);
 
-	mode = readl(sm->regs + SM501_POWER_MODE_CONTROL);
-	gate = readl(sm->regs + SM501_CURRENT_GATE);
-	clock = readl(sm->regs + SM501_CURRENT_CLOCK);
+	mode = smc501_readl(sm->regs + SM501_POWER_MODE_CONTROL);
+	gate = smc501_readl(sm->regs + SM501_CURRENT_GATE);
+	clock = smc501_readl(sm->regs + SM501_CURRENT_CLOCK);
 
 	mode &= 3;		/* get current power mode */
 
@@ -356,14 +356,14 @@ int sm501_unit_power(struct device *dev, unsigned int unit, unsigned int to)
 
 	switch (mode) {
 	case 1:
-		writel(gate, sm->regs + SM501_POWER_MODE_0_GATE);
-		writel(clock, sm->regs + SM501_POWER_MODE_0_CLOCK);
+		smc501_writel(gate, sm->regs + SM501_POWER_MODE_0_GATE);
+		smc501_writel(clock, sm->regs + SM501_POWER_MODE_0_CLOCK);
 		mode = 0;
 		break;
 	case 2:
 	case 0:
-		writel(gate, sm->regs + SM501_POWER_MODE_1_GATE);
-		writel(clock, sm->regs + SM501_POWER_MODE_1_CLOCK);
+		smc501_writel(gate, sm->regs + SM501_POWER_MODE_1_GATE);
+		smc501_writel(clock, sm->regs + SM501_POWER_MODE_1_CLOCK);
 		mode = 1;
 		break;
 
@@ -372,7 +372,7 @@ int sm501_unit_power(struct device *dev, unsigned int unit, unsigned int to)
 		goto already;
 	}
 
-	writel(mode, sm->regs + SM501_POWER_MODE_CONTROL);
+	smc501_writel(mode, sm->regs + SM501_POWER_MODE_CONTROL);
 	sm501_sync_regs(sm);
 
 	dev_dbg(sm->dev, "gate %08lx, clock %08lx, mode %08lx\n",
@@ -519,9 +519,9 @@ unsigned long sm501_set_clock(struct device *dev,
 			      unsigned long req_freq)
 {
 	struct sm501_devdata *sm = dev_get_drvdata(dev);
-	unsigned long mode = readl(sm->regs + SM501_POWER_MODE_CONTROL);
-	unsigned long gate = readl(sm->regs + SM501_CURRENT_GATE);
-	unsigned long clock = readl(sm->regs + SM501_CURRENT_CLOCK);
+	unsigned long mode = smc501_readl(sm->regs + SM501_POWER_MODE_CONTROL);
+	unsigned long gate = smc501_readl(sm->regs + SM501_CURRENT_GATE);
+	unsigned long clock = smc501_readl(sm->regs + SM501_CURRENT_CLOCK);
 	unsigned char reg;
 	unsigned int pll_reg = 0;
 	unsigned long sm501_freq; /* the actual frequency achieved */
@@ -592,9 +592,9 @@ unsigned long sm501_set_clock(struct device *dev,
 
 	mutex_lock(&sm->clock_lock);
 
-	mode = readl(sm->regs + SM501_POWER_MODE_CONTROL);
-	gate = readl(sm->regs + SM501_CURRENT_GATE);
-	clock = readl(sm->regs + SM501_CURRENT_CLOCK);
+	mode = smc501_readl(sm->regs + SM501_POWER_MODE_CONTROL);
+	gate = smc501_readl(sm->regs + SM501_CURRENT_GATE);
+	clock = smc501_readl(sm->regs + SM501_CURRENT_CLOCK);
 
 	clock = clock & ~(0xFF << clksrc);
 	clock |= reg<<clksrc;
@@ -603,14 +603,14 @@ unsigned long sm501_set_clock(struct device *dev,
 
 	switch (mode) {
 	case 1:
-		writel(gate, sm->regs + SM501_POWER_MODE_0_GATE);
-		writel(clock, sm->regs + SM501_POWER_MODE_0_CLOCK);
+		smc501_writel(gate, sm->regs + SM501_POWER_MODE_0_GATE);
+		smc501_writel(clock, sm->regs + SM501_POWER_MODE_0_CLOCK);
 		mode = 0;
 		break;
 	case 2:
 	case 0:
-		writel(gate, sm->regs + SM501_POWER_MODE_1_GATE);
-		writel(clock, sm->regs + SM501_POWER_MODE_1_CLOCK);
+		smc501_writel(gate, sm->regs + SM501_POWER_MODE_1_GATE);
+		smc501_writel(clock, sm->regs + SM501_POWER_MODE_1_CLOCK);
 		mode = 1;
 		break;
 
@@ -619,10 +619,11 @@ unsigned long sm501_set_clock(struct device *dev,
 		return -1;
 	}
 
-	writel(mode, sm->regs + SM501_POWER_MODE_CONTROL);
+	smc501_writel(mode, sm->regs + SM501_POWER_MODE_CONTROL);
 
 	if (pll_reg)
-		writel(pll_reg, sm->regs + SM501_PROGRAMMABLE_PLL_CONTROL);
+		smc501_writel(pll_reg,
+				sm->regs + SM501_PROGRAMMABLE_PLL_CONTROL);
 
 	sm501_sync_regs(sm);
 
@@ -905,7 +906,7 @@ static int sm501_gpio_get(struct gpio_chip *chip, unsigned offset)
 	struct sm501_gpio_chip *smgpio = to_sm501_gpio(chip);
 	unsigned long result;
 
-	result = readl(smgpio->regbase + SM501_GPIO_DATA_LOW);
+	result = smc501_readl(smgpio->regbase + SM501_GPIO_DATA_LOW);
 	result >>= offset;
 
 	return result & 1UL;
@@ -918,13 +919,13 @@ static void sm501_gpio_ensure_gpio(struct sm501_gpio_chip *smchip,
 
 	/* check and modify if this pin is not set as gpio. */
 
-	if (readl(smchip->control) & bit) {
+	if (smc501_readl(smchip->control) & bit) {
 		dev_info(sm501_gpio_to_dev(smchip->ourgpio)->dev,
 			 "changing mode of gpio, bit %08lx\n", bit);
 
-		ctrl = readl(smchip->control);
+		ctrl = smc501_readl(smchip->control);
 		ctrl &= ~bit;
-		writel(ctrl, smchip->control);
+		smc501_writel(ctrl, smchip->control);
 
 		sm501_sync_regs(sm501_gpio_to_dev(smchip->ourgpio));
 	}
@@ -945,10 +946,10 @@ static void sm501_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
 
 	spin_lock_irqsave(&smgpio->lock, save);
 
-	val = readl(regs + SM501_GPIO_DATA_LOW) & ~bit;
+	val = smc501_readl(regs + SM501_GPIO_DATA_LOW) & ~bit;
 	if (value)
 		val |= bit;
-	writel(val, regs);
+	smc501_writel(val, regs);
 
 	sm501_sync_regs(sm501_gpio_to_dev(smgpio));
 	sm501_gpio_ensure_gpio(smchip, bit);
@@ -970,8 +971,8 @@ static int sm501_gpio_input(struct gpio_chip *chip, unsigned offset)
 
 	spin_lock_irqsave(&smgpio->lock, save);
 
-	ddr = readl(regs + SM501_GPIO_DDR_LOW);
-	writel(ddr & ~bit, regs + SM501_GPIO_DDR_LOW);
+	ddr = smc501_readl(regs + SM501_GPIO_DDR_LOW);
+	smc501_writel(ddr & ~bit, regs + SM501_GPIO_DDR_LOW);
 
 	sm501_sync_regs(sm501_gpio_to_dev(smgpio));
 	sm501_gpio_ensure_gpio(smchip, bit);
@@ -997,18 +998,18 @@ static int sm501_gpio_output(struct gpio_chip *chip,
 
 	spin_lock_irqsave(&smgpio->lock, save);
 
-	val = readl(regs + SM501_GPIO_DATA_LOW);
+	val = smc501_readl(regs + SM501_GPIO_DATA_LOW);
 	if (value)
 		val |= bit;
 	else
 		val &= ~bit;
-	writel(val, regs);
+	smc501_writel(val, regs);
 
-	ddr = readl(regs + SM501_GPIO_DDR_LOW);
-	writel(ddr | bit, regs + SM501_GPIO_DDR_LOW);
+	ddr = smc501_readl(regs + SM501_GPIO_DDR_LOW);
+	smc501_writel(ddr | bit, regs + SM501_GPIO_DDR_LOW);
 
 	sm501_sync_regs(sm501_gpio_to_dev(smgpio));
-	writel(val, regs + SM501_GPIO_DATA_LOW);
+	smc501_writel(val, regs + SM501_GPIO_DATA_LOW);
 
 	sm501_sync_regs(sm501_gpio_to_dev(smgpio));
 	spin_unlock_irqrestore(&smgpio->lock, save);
@@ -1234,7 +1235,7 @@ static ssize_t sm501_dbg_regs(struct device *dev,
 
 	for (reg = 0x00; reg < 0x70; reg += 4) {
 		ret = sprintf(ptr, "%08x = %08x\n",
-			      reg, readl(sm->regs + reg));
+			      reg, smc501_readl(sm->regs + reg));
 		ptr += ret;
 	}
 
@@ -1258,10 +1259,10 @@ static inline void sm501_init_reg(struct sm501_devdata *sm,
 {
 	unsigned long tmp;
 
-	tmp = readl(sm->regs + reg);
+	tmp = smc501_readl(sm->regs + reg);
 	tmp &= ~r->mask;
 	tmp |= r->set;
-	writel(tmp, sm->regs + reg);
+	smc501_writel(tmp, sm->regs + reg);
 }
 
 /* sm501_init_regs
@@ -1302,7 +1303,7 @@ static void sm501_init_regs(struct sm501_devdata *sm,
 
 static int sm501_check_clocks(struct sm501_devdata *sm)
 {
-	unsigned long pwrmode = readl(sm->regs + SM501_CURRENT_CLOCK);
+	unsigned long pwrmode = smc501_readl(sm->regs + SM501_CURRENT_CLOCK);
 	unsigned long msrc = (pwrmode & SM501_POWERMODE_M_SRC);
 	unsigned long m1src = (pwrmode & SM501_POWERMODE_M1_SRC);
 
@@ -1337,7 +1338,7 @@ static int __devinit sm501_init_dev(struct sm501_devdata *sm)
 
 	INIT_LIST_HEAD(&sm->devices);
 
-	devid = readl(sm->regs + SM501_DEVICEID);
+	devid = smc501_readl(sm->regs + SM501_DEVICEID);
 
 	if ((devid & SM501_DEVICEID_IDMASK) != SM501_DEVICEID_SM501) {
 		dev_err(sm->dev, "incorrect device id %08lx\n", devid);
@@ -1345,9 +1346,9 @@ static int __devinit sm501_init_dev(struct sm501_devdata *sm)
 	}
 
 	/* disable irqs */
-	writel(0, sm->regs + SM501_IRQ_MASK);
+	smc501_writel(0, sm->regs + SM501_IRQ_MASK);
 
-	dramctrl = readl(sm->regs + SM501_DRAM_CONTROL);
+	dramctrl = smc501_readl(sm->regs + SM501_DRAM_CONTROL);
 	mem_avail = sm501_mem_local[(dramctrl >> 13) & 0x7];
 
 	dev_info(sm->dev, "SM501 At %p: Version %08lx, %ld Mb, IRQ %d\n",
@@ -1379,7 +1380,7 @@ static int __devinit sm501_init_dev(struct sm501_devdata *sm)
 			sm501_register_gpio(sm);
 	}
 
-	if (pdata->gpio_i2c != NULL && pdata->gpio_i2c_nr > 0) {
+	if (pdata && pdata->gpio_i2c != NULL && pdata->gpio_i2c_nr > 0) {
 		if (!sm501_gpio_isregistered(sm))
 			dev_err(sm->dev, "no gpio available for i2c gpio.\n");
 		else
@@ -1424,6 +1425,14 @@ static int __devinit sm501_plat_probe(struct platform_device *dev)
 
 	sm->io_res = platform_get_resource(dev, IORESOURCE_MEM, 1);
 	sm->mem_res = platform_get_resource(dev, IORESOURCE_MEM, 0);
+
+	if (sm->mem_res)
+		pr_debug("sm501 mem 0x%lx, 0x%lx\n",
+			 sm->mem_res->start, sm->mem_res->end);
+	if (sm->io_res)
+		pr_debug("sm501 io 0x%lx, 0x%lx\n",
+			 sm->io_res->start, sm->io_res->end);
+
 	if (sm->io_res == NULL || sm->mem_res == NULL) {
 		dev_err(&dev->dev, "failed to get IO resource\n");
 		ret = -ENOENT;
@@ -1492,7 +1501,7 @@ static int sm501_plat_suspend(struct platform_device *pdev, pm_message_t state)
 	struct sm501_devdata *sm = platform_get_drvdata(pdev);
 
 	sm->in_suspend = 1;
-	sm->pm_misc = readl(sm->regs + SM501_MISC_CONTROL);
+	sm->pm_misc = smc501_readl(sm->regs + SM501_MISC_CONTROL);
 
 	sm501_dump_regs(sm);
 
@@ -1516,9 +1525,9 @@ static int sm501_plat_resume(struct platform_device *pdev)
 
 	/* check to see if we are in the same state as when suspended */
 
-	if (readl(sm->regs + SM501_MISC_CONTROL) != sm->pm_misc) {
+	if (smc501_readl(sm->regs + SM501_MISC_CONTROL) != sm->pm_misc) {
 		dev_info(sm->dev, "SM501_MISC_CONTROL changed over sleep\n");
-		writel(sm->pm_misc, sm->regs + SM501_MISC_CONTROL);
+		smc501_writel(sm->pm_misc, sm->regs + SM501_MISC_CONTROL);
 
 		/* our suspend causes the controller state to change,
 		 * either by something attempting setup, power loss,
@@ -1737,10 +1746,16 @@ static struct pci_driver sm501_pci_driver = {
 
 MODULE_ALIAS("platform:sm501");
 
+static struct of_device_id __devinitdata of_sm501_match_tbl[] = {
+	{ .compatible = "smi,sm501", },
+	{ /* end */ }
+};
+
 static struct platform_driver sm501_plat_driver = {
 	.driver		= {
 		.name	= "sm501",
 		.owner	= THIS_MODULE,
+		.of_match_table = of_sm501_match_tbl,
 	},
 	.probe		= sm501_plat_probe,
 	.remove		= sm501_plat_remove,
diff --git a/drivers/video/sm501fb.c b/drivers/video/sm501fb.c
index b7dc180..fec8461 100644
--- a/drivers/video/sm501fb.c
+++ b/drivers/video/sm501fb.c
@@ -41,6 +41,26 @@
 #include <linux/sm501.h>
 #include <linux/sm501-regs.h>
 
+#include "edid.h"
+
+static char *fb_mode = "640x480-16@60";
+static unsigned long default_bpp = 16;
+
+static struct fb_videomode __devinitdata sm501_default_mode = {
+	.refresh	= 60,
+	.xres		= 640,
+	.yres		= 480,
+	.pixclock	= 20833,
+	.left_margin	= 142,
+	.right_margin	= 13,
+	.upper_margin	= 21,
+	.lower_margin	= 1,
+	.hsync_len	= 69,
+	.vsync_len	= 3,
+	.sync		= FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
+	.vmode		= FB_VMODE_NONINTERLACED
+};
+
 #define NR_PALETTE	256
 
 enum sm501_controller {
@@ -77,6 +97,7 @@ struct sm501fb_info {
 	void __iomem		*regs2d;	/* 2d remapped registers */
 	void __iomem		*fbmem;		/* remapped framebuffer */
 	size_t			 fbmem_len;	/* length of remapped region */
+	u8 *edid_data;
 };
 
 /* per-framebuffer private data */
@@ -117,7 +138,7 @@ static inline int v_total(struct fb_var_screeninfo *var)
 
 static inline void sm501fb_sync_regs(struct sm501fb_info *info)
 {
-	readl(info->regs);
+	smc501_readl(info->regs);
 }
 
 /* sm501_alloc_mem
@@ -262,7 +283,7 @@ static void sm501fb_setup_gamma(struct sm501fb_info *fbi,
 
 	/* set gamma values */
 	for (offset = 0; offset < 256 * 4; offset += 4) {
-		writel(value, fbi->regs + palette + offset);
+		smc501_writel(value, fbi->regs + palette + offset);
 		value += 0x010101; 	/* Advance RGB by 1,1,1.*/
 	}
 }
@@ -476,7 +497,8 @@ static int sm501fb_set_par_common(struct fb_info *info,
 
 	/* set start of framebuffer to the screen */
 
-	writel(par->screen.sm_addr | SM501_ADDR_FLIP, fbi->regs + head_addr);
+	smc501_writel(par->screen.sm_addr | SM501_ADDR_FLIP,
+			fbi->regs + head_addr);
 
 	/* program CRT clock  */
 
@@ -519,7 +541,7 @@ static void sm501fb_set_par_geometry(struct fb_info *info,
 	reg = info->fix.line_length;
 	reg |= ((var->xres * var->bits_per_pixel)/8) << 16;
 
-	writel(reg, fbi->regs + (par->head == HEAD_CRT ?
+	smc501_writel(reg, fbi->regs + (par->head == HEAD_CRT ?
 		    SM501_DC_CRT_FB_OFFSET :  SM501_DC_PANEL_FB_OFFSET));
 
 	/* program horizontal total */
@@ -527,27 +549,27 @@ static void sm501fb_set_par_geometry(struct fb_info *info,
 	reg  = (h_total(var) - 1) << 16;
 	reg |= (var->xres - 1);
 
-	writel(reg, base + SM501_OFF_DC_H_TOT);
+	smc501_writel(reg, base + SM501_OFF_DC_H_TOT);
 
 	/* program horizontal sync */
 
 	reg  = var->hsync_len << 16;
 	reg |= var->xres + var->right_margin - 1;
 
-	writel(reg, base + SM501_OFF_DC_H_SYNC);
+	smc501_writel(reg, base + SM501_OFF_DC_H_SYNC);
 
 	/* program vertical total */
 
 	reg  = (v_total(var) - 1) << 16;
 	reg |= (var->yres - 1);
 
-	writel(reg, base + SM501_OFF_DC_V_TOT);
+	smc501_writel(reg, base + SM501_OFF_DC_V_TOT);
 
 	/* program vertical sync */
 	reg  = var->vsync_len << 16;
 	reg |= var->yres + var->lower_margin - 1;
 
-	writel(reg, base + SM501_OFF_DC_V_SYNC);
+	smc501_writel(reg, base + SM501_OFF_DC_V_SYNC);
 }
 
 /* sm501fb_pan_crt
@@ -566,15 +588,15 @@ static int sm501fb_pan_crt(struct fb_var_screeninfo *var,
 
 	xoffs = var->xoffset * bytes_pixel;
 
-	reg = readl(fbi->regs + SM501_DC_CRT_CONTROL);
+	reg = smc501_readl(fbi->regs + SM501_DC_CRT_CONTROL);
 
 	reg &= ~SM501_DC_CRT_CONTROL_PIXEL_MASK;
 	reg |= ((xoffs & 15) / bytes_pixel) << 4;
-	writel(reg, fbi->regs + SM501_DC_CRT_CONTROL);
+	smc501_writel(reg, fbi->regs + SM501_DC_CRT_CONTROL);
 
 	reg = (par->screen.sm_addr + xoffs +
 	       var->yoffset * info->fix.line_length);
-	writel(reg | SM501_ADDR_FLIP, fbi->regs + SM501_DC_CRT_FB_ADDR);
+	smc501_writel(reg | SM501_ADDR_FLIP, fbi->regs + SM501_DC_CRT_FB_ADDR);
 
 	sm501fb_sync_regs(fbi);
 	return 0;
@@ -593,10 +615,10 @@ static int sm501fb_pan_pnl(struct fb_var_screeninfo *var,
 	unsigned long reg;
 
 	reg = var->xoffset | (var->xres_virtual << 16);
-	writel(reg, fbi->regs + SM501_DC_PANEL_FB_WIDTH);
+	smc501_writel(reg, fbi->regs + SM501_DC_PANEL_FB_WIDTH);
 
 	reg = var->yoffset | (var->yres_virtual << 16);
-	writel(reg, fbi->regs + SM501_DC_PANEL_FB_HEIGHT);
+	smc501_writel(reg, fbi->regs + SM501_DC_PANEL_FB_HEIGHT);
 
 	sm501fb_sync_regs(fbi);
 	return 0;
@@ -622,7 +644,7 @@ static int sm501fb_set_par_crt(struct fb_info *info)
 	/* enable CRT DAC - note 0 is on!*/
 	sm501_misc_control(fbi->dev->parent, 0, SM501_MISC_DAC_POWER);
 
-	control = readl(fbi->regs + SM501_DC_CRT_CONTROL);
+	control = smc501_readl(fbi->regs + SM501_DC_CRT_CONTROL);
 
 	control &= (SM501_DC_CRT_CONTROL_PIXEL_MASK |
 		    SM501_DC_CRT_CONTROL_GAMMA |
@@ -684,7 +706,7 @@ static int sm501fb_set_par_crt(struct fb_info *info)
  out_update:
 	dev_dbg(fbi->dev, "new control is %08lx\n", control);
 
-	writel(control, fbi->regs + SM501_DC_CRT_CONTROL);
+	smc501_writel(control, fbi->regs + SM501_DC_CRT_CONTROL);
 	sm501fb_sync_regs(fbi);
 
 	return 0;
@@ -696,18 +718,18 @@ static void sm501fb_panel_power(struct sm501fb_info *fbi, int to)
 	void __iomem *ctrl_reg = fbi->regs + SM501_DC_PANEL_CONTROL;
 	struct sm501_platdata_fbsub *pd = fbi->pdata->fb_pnl;
 
-	control = readl(ctrl_reg);
+	control = smc501_readl(ctrl_reg);
 
 	if (to && (control & SM501_DC_PANEL_CONTROL_VDD) == 0) {
 		/* enable panel power */
 
 		control |= SM501_DC_PANEL_CONTROL_VDD;	/* FPVDDEN */
-		writel(control, ctrl_reg);
+		smc501_writel(control, ctrl_reg);
 		sm501fb_sync_regs(fbi);
 		mdelay(10);
 
 		control |= SM501_DC_PANEL_CONTROL_DATA;	/* DATA */
-		writel(control, ctrl_reg);
+		smc501_writel(control, ctrl_reg);
 		sm501fb_sync_regs(fbi);
 		mdelay(10);
 
@@ -719,7 +741,7 @@ static void sm501fb_panel_power(struct sm501fb_info *fbi, int to)
 			else
 				control |= SM501_DC_PANEL_CONTROL_BIAS;
 
-			writel(control, ctrl_reg);
+			smc501_writel(control, ctrl_reg);
 			sm501fb_sync_regs(fbi);
 			mdelay(10);
 		}
@@ -730,7 +752,7 @@ static void sm501fb_panel_power(struct sm501fb_info *fbi, int to)
 			else
 				control |= SM501_DC_PANEL_CONTROL_FPEN;
 
-			writel(control, ctrl_reg);
+			smc501_writel(control, ctrl_reg);
 			sm501fb_sync_regs(fbi);
 			mdelay(10);
 		}
@@ -742,7 +764,7 @@ static void sm501fb_panel_power(struct sm501fb_info *fbi, int to)
 			else
 				control &= ~SM501_DC_PANEL_CONTROL_FPEN;
 
-			writel(control, ctrl_reg);
+			smc501_writel(control, ctrl_reg);
 			sm501fb_sync_regs(fbi);
 			mdelay(10);
 		}
@@ -753,18 +775,18 @@ static void sm501fb_panel_power(struct sm501fb_info *fbi, int to)
 			else
 				control &= ~SM501_DC_PANEL_CONTROL_BIAS;
 
-			writel(control, ctrl_reg);
+			smc501_writel(control, ctrl_reg);
 			sm501fb_sync_regs(fbi);
 			mdelay(10);
 		}
 
 		control &= ~SM501_DC_PANEL_CONTROL_DATA;
-		writel(control, ctrl_reg);
+		smc501_writel(control, ctrl_reg);
 		sm501fb_sync_regs(fbi);
 		mdelay(10);
 
 		control &= ~SM501_DC_PANEL_CONTROL_VDD;
-		writel(control, ctrl_reg);
+		smc501_writel(control, ctrl_reg);
 		sm501fb_sync_regs(fbi);
 		mdelay(10);
 	}
@@ -799,7 +821,7 @@ static int sm501fb_set_par_pnl(struct fb_info *info)
 
 	/* update control register */
 
-	control = readl(fbi->regs + SM501_DC_PANEL_CONTROL);
+	control = smc501_readl(fbi->regs + SM501_DC_PANEL_CONTROL);
 	control &= (SM501_DC_PANEL_CONTROL_GAMMA |
 		    SM501_DC_PANEL_CONTROL_VDD  |
 		    SM501_DC_PANEL_CONTROL_DATA |
@@ -833,16 +855,16 @@ static int sm501fb_set_par_pnl(struct fb_info *info)
 		BUG();
 	}
 
-	writel(0x0, fbi->regs + SM501_DC_PANEL_PANNING_CONTROL);
+	smc501_writel(0x0, fbi->regs + SM501_DC_PANEL_PANNING_CONTROL);
 
 	/* panel plane top left and bottom right location */
 
-	writel(0x00, fbi->regs + SM501_DC_PANEL_TL_LOC);
+	smc501_writel(0x00, fbi->regs + SM501_DC_PANEL_TL_LOC);
 
 	reg  = var->xres - 1;
 	reg |= (var->yres - 1) << 16;
 
-	writel(reg, fbi->regs + SM501_DC_PANEL_BR_LOC);
+	smc501_writel(reg, fbi->regs + SM501_DC_PANEL_BR_LOC);
 
 	/* program panel control register */
 
@@ -855,7 +877,7 @@ static int sm501fb_set_par_pnl(struct fb_info *info)
 	if ((var->sync & FB_SYNC_VERT_HIGH_ACT) == 0)
 		control |= SM501_DC_PANEL_CONTROL_VSP;
 
-	writel(control, fbi->regs + SM501_DC_PANEL_CONTROL);
+	smc501_writel(control, fbi->regs + SM501_DC_PANEL_CONTROL);
 	sm501fb_sync_regs(fbi);
 
 	/* ensure the panel interface is not tristated at this point */
@@ -924,7 +946,7 @@ static int sm501fb_setcolreg(unsigned regno,
 			val |= (green >> 8) << 8;
 			val |= blue >> 8;
 
-			writel(val, base + (regno * 4));
+			smc501_writel(val, base + (regno * 4));
 		}
 
 		break;
@@ -980,7 +1002,7 @@ static int sm501fb_blank_crt(int blank_mode, struct fb_info *info)
 
 	dev_dbg(fbi->dev, "%s(mode=%d, %p)\n", __func__, blank_mode, info);
 
-	ctrl = readl(fbi->regs + SM501_DC_CRT_CONTROL);
+	ctrl = smc501_readl(fbi->regs + SM501_DC_CRT_CONTROL);
 
 	switch (blank_mode) {
 	case FB_BLANK_POWERDOWN:
@@ -1004,7 +1026,7 @@ static int sm501fb_blank_crt(int blank_mode, struct fb_info *info)
 
 	}
 
-	writel(ctrl, fbi->regs + SM501_DC_CRT_CONTROL);
+	smc501_writel(ctrl, fbi->regs + SM501_DC_CRT_CONTROL);
 	sm501fb_sync_regs(fbi);
 
 	return 0;
@@ -1041,12 +1063,14 @@ static int sm501fb_cursor(struct fb_info *info, struct fb_cursor *cursor)
 	if (cursor->image.depth > 1)
 		return -EINVAL;
 
-	hwc_addr = readl(base + SM501_OFF_HWC_ADDR);
+	hwc_addr = smc501_readl(base + SM501_OFF_HWC_ADDR);
 
 	if (cursor->enable)
-		writel(hwc_addr | SM501_HWC_EN, base + SM501_OFF_HWC_ADDR);
+		smc501_writel(hwc_addr | SM501_HWC_EN,
+				base + SM501_OFF_HWC_ADDR);
 	else
-		writel(hwc_addr & ~SM501_HWC_EN, base + SM501_OFF_HWC_ADDR);
+		smc501_writel(hwc_addr & ~SM501_HWC_EN,
+				base + SM501_OFF_HWC_ADDR);
 
 	/* set data */
 	if (cursor->set & FB_CUR_SETPOS) {
@@ -1060,7 +1084,7 @@ static int sm501fb_cursor(struct fb_info *info, struct fb_cursor *cursor)
 
 		//y += cursor->image.height;
 
-		writel(x | (y << 16), base + SM501_OFF_HWC_LOC);
+		smc501_writel(x | (y << 16), base + SM501_OFF_HWC_LOC);
 	}
 
 	if (cursor->set & FB_CUR_SETCMAP) {
@@ -1080,8 +1104,8 @@ static int sm501fb_cursor(struct fb_info *info, struct fb_cursor *cursor)
 
 		dev_dbg(fbi->dev, "fgcol %08lx, bgcol %08lx\n", fg, bg);
 
-		writel(bg, base + SM501_OFF_HWC_COLOR_1_2);
-		writel(fg, base + SM501_OFF_HWC_COLOR_3);
+		smc501_writel(bg, base + SM501_OFF_HWC_COLOR_1_2);
+		smc501_writel(fg, base + SM501_OFF_HWC_COLOR_3);
 	}
 
 	if (cursor->set & FB_CUR_SETSIZE ||
@@ -1102,7 +1126,7 @@ static int sm501fb_cursor(struct fb_info *info, struct fb_cursor *cursor)
 			__func__, cursor->image.width, cursor->image.height);
 
 		for (op = 0; op < (64*64*2)/8; op+=4)
-			writel(0x0, dst + op);
+			smc501_writel(0x0, dst + op);
 
 		for (y = 0; y < cursor->image.height; y++) {
 			for (x = 0; x < cursor->image.width; x++) {
@@ -1141,7 +1165,7 @@ static ssize_t sm501fb_crtsrc_show(struct device *dev,
 	struct sm501fb_info *info = dev_get_drvdata(dev);
 	unsigned long ctrl;
 
-	ctrl = readl(info->regs + SM501_DC_CRT_CONTROL);
+	ctrl = smc501_readl(info->regs + SM501_DC_CRT_CONTROL);
 	ctrl &= SM501_DC_CRT_CONTROL_SEL;
 
 	return snprintf(buf, PAGE_SIZE, "%s\n", ctrl ? "crt" : "panel");
@@ -1172,7 +1196,7 @@ static ssize_t sm501fb_crtsrc_store(struct device *dev,
 
 	dev_info(dev, "setting crt source to head %d\n", head);
 
-	ctrl = readl(info->regs + SM501_DC_CRT_CONTROL);
+	ctrl = smc501_readl(info->regs + SM501_DC_CRT_CONTROL);
 
 	if (head == HEAD_CRT) {
 		ctrl |= SM501_DC_CRT_CONTROL_SEL;
@@ -1184,7 +1208,7 @@ static ssize_t sm501fb_crtsrc_store(struct device *dev,
 		ctrl &= ~SM501_DC_CRT_CONTROL_TE;
 	}
 
-	writel(ctrl, info->regs + SM501_DC_CRT_CONTROL);
+	smc501_writel(ctrl, info->regs + SM501_DC_CRT_CONTROL);
 	sm501fb_sync_regs(info);
 
 	return len;
@@ -1205,7 +1229,8 @@ static int sm501fb_show_regs(struct sm501fb_info *info, char *ptr,
 	unsigned int reg;
 
 	for (reg = start; reg < (len + start); reg += 4)
-		ptr += sprintf(ptr, "%08x = %08x\n", reg, readl(mem + reg));
+		ptr += sprintf(ptr, "%08x = %08x\n", reg,
+				smc501_readl(mem + reg));
 
 	return ptr - buf;
 }
@@ -1257,7 +1282,7 @@ static int sm501fb_sync(struct fb_info *info)
 
 	/* wait for the 2d engine to be ready */
 	while ((count > 0) &&
-	       (readl(fbi->regs + SM501_SYSTEM_CONTROL) &
+	       (smc501_readl(fbi->regs + SM501_SYSTEM_CONTROL) &
 		SM501_SYSCTRL_2D_ENGINE_STATUS) != 0)
 		count--;
 
@@ -1312,45 +1337,46 @@ static void sm501fb_copyarea(struct fb_info *info, const struct fb_copyarea *are
 		return;
 
 	/* set the base addresses */
-	writel(par->screen.sm_addr, fbi->regs2d + SM501_2D_SOURCE_BASE);
-	writel(par->screen.sm_addr, fbi->regs2d + SM501_2D_DESTINATION_BASE);
+	smc501_writel(par->screen.sm_addr, fbi->regs2d + SM501_2D_SOURCE_BASE);
+	smc501_writel(par->screen.sm_addr,
+			fbi->regs2d + SM501_2D_DESTINATION_BASE);
 
 	/* set the window width */
-	writel((info->var.xres << 16) | info->var.xres,
+	smc501_writel((info->var.xres << 16) | info->var.xres,
 	       fbi->regs2d + SM501_2D_WINDOW_WIDTH);
 
 	/* set window stride */
-	writel((info->var.xres_virtual << 16) | info->var.xres_virtual,
+	smc501_writel((info->var.xres_virtual << 16) | info->var.xres_virtual,
 	       fbi->regs2d + SM501_2D_PITCH);
 
 	/* set data format */
 	switch (info->var.bits_per_pixel) {
 	case 8:
-		writel(0, fbi->regs2d + SM501_2D_STRETCH);
+		smc501_writel(0, fbi->regs2d + SM501_2D_STRETCH);
 		break;
 	case 16:
-		writel(0x00100000, fbi->regs2d + SM501_2D_STRETCH);
+		smc501_writel(0x00100000, fbi->regs2d + SM501_2D_STRETCH);
 		break;
 	case 32:
-		writel(0x00200000, fbi->regs2d + SM501_2D_STRETCH);
+		smc501_writel(0x00200000, fbi->regs2d + SM501_2D_STRETCH);
 		break;
 	}
 
 	/* 2d compare mask */
-	writel(0xffffffff, fbi->regs2d + SM501_2D_COLOR_COMPARE_MASK);
+	smc501_writel(0xffffffff, fbi->regs2d + SM501_2D_COLOR_COMPARE_MASK);
 
 	/* 2d mask */
-	writel(0xffffffff, fbi->regs2d + SM501_2D_MASK);
+	smc501_writel(0xffffffff, fbi->regs2d + SM501_2D_MASK);
 
 	/* source and destination x y */
-	writel((sx << 16) | sy, fbi->regs2d + SM501_2D_SOURCE);
-	writel((dx << 16) | dy, fbi->regs2d + SM501_2D_DESTINATION);
+	smc501_writel((sx << 16) | sy, fbi->regs2d + SM501_2D_SOURCE);
+	smc501_writel((dx << 16) | dy, fbi->regs2d + SM501_2D_DESTINATION);
 
 	/* w/h */
-	writel((width << 16) | height, fbi->regs2d + SM501_2D_DIMENSION);
+	smc501_writel((width << 16) | height, fbi->regs2d + SM501_2D_DIMENSION);
 
 	/* do area move */
-	writel(0x800000cc | rtl, fbi->regs2d + SM501_2D_CONTROL);
+	smc501_writel(0x800000cc | rtl, fbi->regs2d + SM501_2D_CONTROL);
 }
 
 static void sm501fb_fillrect(struct fb_info *info, const struct fb_fillrect *rect)
@@ -1372,47 +1398,49 @@ static void sm501fb_fillrect(struct fb_info *info, const struct fb_fillrect *rec
 		return;
 
 	/* set the base addresses */
-	writel(par->screen.sm_addr, fbi->regs2d + SM501_2D_SOURCE_BASE);
-	writel(par->screen.sm_addr, fbi->regs2d + SM501_2D_DESTINATION_BASE);
+	smc501_writel(par->screen.sm_addr, fbi->regs2d + SM501_2D_SOURCE_BASE);
+	smc501_writel(par->screen.sm_addr,
+			fbi->regs2d + SM501_2D_DESTINATION_BASE);
 
 	/* set the window width */
-	writel((info->var.xres << 16) | info->var.xres,
+	smc501_writel((info->var.xres << 16) | info->var.xres,
 	       fbi->regs2d + SM501_2D_WINDOW_WIDTH);
 
 	/* set window stride */
-	writel((info->var.xres_virtual << 16) | info->var.xres_virtual,
+	smc501_writel((info->var.xres_virtual << 16) | info->var.xres_virtual,
 	       fbi->regs2d + SM501_2D_PITCH);
 
 	/* set data format */
 	switch (info->var.bits_per_pixel) {
 	case 8:
-		writel(0, fbi->regs2d + SM501_2D_STRETCH);
+		smc501_writel(0, fbi->regs2d + SM501_2D_STRETCH);
 		break;
 	case 16:
-		writel(0x00100000, fbi->regs2d + SM501_2D_STRETCH);
+		smc501_writel(0x00100000, fbi->regs2d + SM501_2D_STRETCH);
 		break;
 	case 32:
-		writel(0x00200000, fbi->regs2d + SM501_2D_STRETCH);
+		smc501_writel(0x00200000, fbi->regs2d + SM501_2D_STRETCH);
 		break;
 	}
 
 	/* 2d compare mask */
-	writel(0xffffffff, fbi->regs2d + SM501_2D_COLOR_COMPARE_MASK);
+	smc501_writel(0xffffffff, fbi->regs2d + SM501_2D_COLOR_COMPARE_MASK);
 
 	/* 2d mask */
-	writel(0xffffffff, fbi->regs2d + SM501_2D_MASK);
+	smc501_writel(0xffffffff, fbi->regs2d + SM501_2D_MASK);
 
 	/* colour */
-	writel(rect->color, fbi->regs2d + SM501_2D_FOREGROUND);
+	smc501_writel(rect->color, fbi->regs2d + SM501_2D_FOREGROUND);
 
 	/* x y */
-	writel((rect->dx << 16) | rect->dy, fbi->regs2d + SM501_2D_DESTINATION);
+	smc501_writel((rect->dx << 16) | rect->dy,
+			fbi->regs2d + SM501_2D_DESTINATION);
 
 	/* w/h */
-	writel((width << 16) | height, fbi->regs2d + SM501_2D_DIMENSION);
+	smc501_writel((width << 16) | height, fbi->regs2d + SM501_2D_DIMENSION);
 
 	/* do rectangle fill */
-	writel(0x800100cc, fbi->regs2d + SM501_2D_CONTROL);
+	smc501_writel(0x800100cc, fbi->regs2d + SM501_2D_CONTROL);
 }
 
 
@@ -1470,11 +1498,12 @@ static int sm501_init_cursor(struct fb_info *fbi, unsigned int reg_base)
 
 	/* initialise the colour registers */
 
-	writel(par->cursor.sm_addr, par->cursor_regs + SM501_OFF_HWC_ADDR);
+	smc501_writel(par->cursor.sm_addr,
+			par->cursor_regs + SM501_OFF_HWC_ADDR);
 
-	writel(0x00, par->cursor_regs + SM501_OFF_HWC_LOC);
-	writel(0x00, par->cursor_regs + SM501_OFF_HWC_COLOR_1_2);
-	writel(0x00, par->cursor_regs + SM501_OFF_HWC_COLOR_3);
+	smc501_writel(0x00, par->cursor_regs + SM501_OFF_HWC_LOC);
+	smc501_writel(0x00, par->cursor_regs + SM501_OFF_HWC_COLOR_1_2);
+	smc501_writel(0x00, par->cursor_regs + SM501_OFF_HWC_COLOR_3);
 	sm501fb_sync_regs(info);
 
 	return 0;
@@ -1581,7 +1610,7 @@ static int sm501fb_start(struct sm501fb_info *info,
 
 	/* clear palette ram - undefined at power on */
 	for (k = 0; k < (256 * 3); k++)
-		writel(0, info->regs + SM501_DC_PANEL_PALETTE + (k * 4));
+		smc501_writel(0, info->regs + SM501_DC_PANEL_PALETTE + (k * 4));
 
 	/* enable display controller */
 	sm501_unit_power(dev->parent, SM501_GATE_DISPLAY, 1);
@@ -1649,20 +1678,20 @@ static int sm501fb_init_fb(struct fb_info *fb,
 	switch (head) {
 	case HEAD_CRT:
 		pd = info->pdata->fb_crt;
-		ctrl = readl(info->regs + SM501_DC_CRT_CONTROL);
+		ctrl = smc501_readl(info->regs + SM501_DC_CRT_CONTROL);
 		enable = (ctrl & SM501_DC_CRT_CONTROL_ENABLE) ? 1 : 0;
 
 		/* ensure we set the correct source register */
 		if (info->pdata->fb_route != SM501_FB_CRT_PANEL) {
 			ctrl |= SM501_DC_CRT_CONTROL_SEL;
-			writel(ctrl, info->regs + SM501_DC_CRT_CONTROL);
+			smc501_writel(ctrl, info->regs + SM501_DC_CRT_CONTROL);
 		}
 
 		break;
 
 	case HEAD_PANEL:
 		pd = info->pdata->fb_pnl;
-		ctrl = readl(info->regs + SM501_DC_PANEL_CONTROL);
+		ctrl = smc501_readl(info->regs + SM501_DC_PANEL_CONTROL);
 		enable = (ctrl & SM501_DC_PANEL_CONTROL_EN) ? 1 : 0;
 		break;
 
@@ -1680,7 +1709,7 @@ static int sm501fb_init_fb(struct fb_info *fb,
 
 	if (head == HEAD_CRT && info->pdata->fb_route == SM501_FB_CRT_PANEL) {
 		ctrl &= ~SM501_DC_CRT_CONTROL_SEL;
-		writel(ctrl, info->regs + SM501_DC_CRT_CONTROL);
+		smc501_writel(ctrl, info->regs + SM501_DC_CRT_CONTROL);
 		enable = 0;
 	}
 
@@ -1698,6 +1727,9 @@ static int sm501fb_init_fb(struct fb_info *fb,
 	fb->fbops = &par->ops;
 	fb->flags = FBINFO_FLAG_DEFAULT | FBINFO_READS_FAST |
 		FBINFO_HWACCEL_COPYAREA | FBINFO_HWACCEL_FILLRECT |
+#if defined(CONFIG_PPC_MPC52xx)
+		FBINFO_FOREIGN_ENDIAN |
+#endif
 		FBINFO_HWACCEL_XPAN | FBINFO_HWACCEL_YPAN;
 
 	/* fixed data */
@@ -1717,9 +1749,16 @@ static int sm501fb_init_fb(struct fb_info *fb,
 	fb->var.vmode		= FB_VMODE_NONINTERLACED;
 	fb->var.bits_per_pixel  = 16;
 
+	if (info->edid_data) {
+			/* Now build modedb from EDID */
+			fb_edid_to_monspecs(info->edid_data, &fb->monspecs);
+			fb_videomode_to_modelist(fb->monspecs.modedb,
+						 fb->monspecs.modedb_len,
+						 &fb->modelist);
+	}
+
 	if (enable && (pd->flags & SM501FB_FLAG_USE_INIT_MODE) && 0) {
 		/* TODO read the mode from the current display */
-
 	} else {
 		if (pd->def_mode) {
 			dev_info(info->dev, "using supplied mode\n");
@@ -1729,12 +1768,34 @@ static int sm501fb_init_fb(struct fb_info *fb,
 			fb->var.xres_virtual = fb->var.xres;
 			fb->var.yres_virtual = fb->var.yres;
 		} else {
-			ret = fb_find_mode(&fb->var, fb,
+			if (info->edid_data)
+				ret = fb_find_mode(&fb->var, fb, fb_mode,
+					fb->monspecs.modedb,
+					fb->monspecs.modedb_len,
+					&sm501_default_mode, default_bpp);
+			else
+				ret = fb_find_mode(&fb->var, fb,
 					   NULL, NULL, 0, NULL, 8);
 
-			if (ret == 0 || ret == 4) {
-				dev_err(info->dev,
-					"failed to get initial mode\n");
+			switch (ret) {
+			case 1:
+				dev_info(info->dev, "using mode specified in "
+						"@mode\n");
+				break;
+			case 2:
+				dev_info(info->dev, "using mode specified in "
+					"@mode with ignored refresh rate\n");
+				break;
+			case 3:
+				dev_info(info->dev, "using mode default "
+					"mode\n");
+				break;
+			case 4:
+				dev_info(info->dev, "using mode from list\n");
+				break;
+			default:
+				dev_info(info->dev, "ret = %d\n", ret);
+				dev_info(info->dev, "failed to find mode\n");
 				return -EINVAL;
 			}
 		}
@@ -1819,6 +1880,7 @@ static void sm501_free_init_fb(struct sm501fb_info *info,
 {
 	struct fb_info *fbi = info->fb[head];
 
+	kfree(info->edid_data);
 	fb_dealloc_cmap(&fbi->cmap);
 }
 
@@ -1875,8 +1937,29 @@ static int __devinit sm501fb_probe(struct platform_device *pdev)
 	}
 
 	if (info->pdata == NULL) {
-		dev_info(dev, "using default configuration data\n");
+		int found = 0;
+#if defined(CONFIG_OF)
+		struct device_node *np = pdev->dev.parent->of_node;
+		const u8 *prop;
+		const char *cp;
+		int len;
+
 		info->pdata = &sm501fb_def_pdata;
+		if (np) {
+			/* Get EDID */
+			cp = of_get_property(np, "mode", &len);
+			if (cp)
+				strcpy(fb_mode, cp);
+			prop = of_get_property(np, "edid", &len);
+			if (prop && len == EDID_LENGTH) {
+				info->edid_data = kmemdup(prop, EDID_LENGTH,
+							  GFP_KERNEL);
+				found = 1;
+			}
+		}
+#endif
+		if (!found)
+			dev_info(dev, "using default configuration data\n");
 	}
 
 	/* probe for the presence of each panel */
@@ -2085,7 +2168,7 @@ static int sm501fb_suspend(struct platform_device *pdev, pm_message_t state)
 	struct sm501fb_info *info = platform_get_drvdata(pdev);
 
 	/* store crt control to resume with */
-	info->pm_crt_ctrl = readl(info->regs + SM501_DC_CRT_CONTROL);
+	info->pm_crt_ctrl = smc501_readl(info->regs + SM501_DC_CRT_CONTROL);
 
 	sm501fb_suspend_fb(info, HEAD_CRT);
 	sm501fb_suspend_fb(info, HEAD_PANEL);
@@ -2109,10 +2192,10 @@ static int sm501fb_resume(struct platform_device *pdev)
 
 	/* restore the items we want to be saved for crt control */
 
-	crt_ctrl = readl(info->regs + SM501_DC_CRT_CONTROL);
+	crt_ctrl = smc501_readl(info->regs + SM501_DC_CRT_CONTROL);
 	crt_ctrl &= ~SM501_CRT_CTRL_SAVE;
 	crt_ctrl |= info->pm_crt_ctrl & SM501_CRT_CTRL_SAVE;
-	writel(crt_ctrl, info->regs + SM501_DC_CRT_CONTROL);
+	smc501_writel(crt_ctrl, info->regs + SM501_DC_CRT_CONTROL);
 
 	sm501fb_resume_fb(info, HEAD_CRT);
 	sm501fb_resume_fb(info, HEAD_PANEL);
@@ -2149,6 +2232,11 @@ static void __exit sm501fb_cleanup(void)
 module_init(sm501fb_init);
 module_exit(sm501fb_cleanup);
 
+module_param_named(mode, fb_mode, charp, 0);
+MODULE_PARM_DESC(mode,
+	"Specify resolution as \"<xres>x<yres>[-<bpp>][@<refresh>]\" ");
+module_param_named(bpp, default_bpp, ulong, 0);
+MODULE_PARM_DESC(bpp, "Specify bit-per-pixel if not specified mode");
 MODULE_AUTHOR("Ben Dooks, Vincent Sanders");
 MODULE_DESCRIPTION("SM501 Framebuffer driver");
 MODULE_LICENSE("GPL v2");
diff --git a/include/linux/sm501.h b/include/linux/sm501.h
index 214f932..090a07b 100644
--- a/include/linux/sm501.h
+++ b/include/linux/sm501.h
@@ -172,3 +172,11 @@ struct sm501_platdata {
 	struct sm501_platdata_gpio_i2c	*gpio_i2c;
 	unsigned int			 gpio_i2c_nr;
 };
+
+#if defined(CONFIG_PPC_MPC52xx)
+#define smc501_readl(addr)	__do_readl_be((addr))
+#define smc501_writel(val, addr)	__do_writel_be((val), (addr))
+#else
+#define smc501_readl(addr)		readl(addr)
+#define smc501_writel(val, addr)	writel(val, addr)
+#endif
-- 
1.7.2.3

