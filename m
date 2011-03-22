Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab1CVI2z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 04:28:55 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:45118 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755240Ab1CVI1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 04:27:39 -0400
X-Auth-Info: tYa63Ui8hUkKhj3DzebrSF+WdrmqYeRkAwwB06olvbA=
From: Heiko Schocher <hs@denx.de>
To: linuxppc-dev@lists.ozlabs.org
Cc: Heiko Schocher <hs@denx.de>, Wolfram Sang <w.sang@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-fbdev@vger.kernel.org, devicetree-discuss@ozlabs.org,
        Ben Dooks <ben@simtec.co.uk>, Vincent Sanders <vince@simtec.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>, Wolfgang Denk <wd@denx.de>,
        Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH v6 2/6] video, sm501: add I/O functions for use on powerpc
Date: Tue, 22 Mar 2011 09:27:28 +0100
Message-Id: <1300782452-528-3-git-send-email-hs@denx.de>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1300782452-528-1-git-send-email-hs@denx.de>
References: <1291451028-22532-1-git-send-email-hs@denx.de>
 <1300782452-528-1-git-send-email-hs@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- add read/write functions for using this driver
  also on powerpc plattforms

Signed-off-by: Heiko Schocher <hs@denx.de>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>
cc: Wolfram Sang <w.sang@pengutronix.de>
cc: Grant Likely <grant.likely@secretlab.ca>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: linux-fbdev@vger.kernel.org
cc: devicetree-discuss@ozlabs.org
cc: Ben Dooks <ben@simtec.co.uk>
cc: Vincent Sanders <vince@simtec.co.uk>
cc: Samuel Ortiz <sameo@linux.intel.com>
cc: linux-kernel@vger.kernel.org
cc: Randy Dunlap <rdunlap@xenotime.net>
cc: Wolfgang Denk <wd@denx.de>
cc: Paul Mundt <lethal@linux-sh.org>
---
- changes since v1:
  add Ben Dooks, Vincent Sanders and Samuel Ortiz to cc, as suggested from
  Paul Mundt.
- changes since v2:
  add comments from Randy Dunlap:
  - move parameter documentation to Documentation/fb/sm501.txt
- changes since v3:
  - rebased against v2.6.38-rc2
  - split in 3 patches
    - of support patch
    - i/o routine patch
      - use ioread/write32{be} accessors instead of
        __do_readl/__do_writel{_be}
    - edid support patch
- changes for v6:
  - repost complete patchserie
  - rebased against current head

 drivers/mfd/sm501.c     |  125 +++++++++++++++++-----------------
 drivers/video/sm501fb.c |  172 ++++++++++++++++++++++++----------------------
 include/linux/sm501.h   |    8 ++
 3 files changed, 161 insertions(+), 144 deletions(-)

diff --git a/drivers/mfd/sm501.c b/drivers/mfd/sm501.c
index 5de3a76..558d5f3 100644
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
 
@@ -902,7 +903,7 @@ static int sm501_gpio_get(struct gpio_chip *chip, unsigned offset)
 	struct sm501_gpio_chip *smgpio = to_sm501_gpio(chip);
 	unsigned long result;
 
-	result = readl(smgpio->regbase + SM501_GPIO_DATA_LOW);
+	result = smc501_readl(smgpio->regbase + SM501_GPIO_DATA_LOW);
 	result >>= offset;
 
 	return result & 1UL;
@@ -915,13 +916,13 @@ static void sm501_gpio_ensure_gpio(struct sm501_gpio_chip *smchip,
 
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
@@ -942,10 +943,10 @@ static void sm501_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
 
 	spin_lock_irqsave(&smgpio->lock, save);
 
-	val = readl(regs + SM501_GPIO_DATA_LOW) & ~bit;
+	val = smc501_readl(regs + SM501_GPIO_DATA_LOW) & ~bit;
 	if (value)
 		val |= bit;
-	writel(val, regs);
+	smc501_writel(val, regs);
 
 	sm501_sync_regs(sm501_gpio_to_dev(smgpio));
 	sm501_gpio_ensure_gpio(smchip, bit);
@@ -967,8 +968,8 @@ static int sm501_gpio_input(struct gpio_chip *chip, unsigned offset)
 
 	spin_lock_irqsave(&smgpio->lock, save);
 
-	ddr = readl(regs + SM501_GPIO_DDR_LOW);
-	writel(ddr & ~bit, regs + SM501_GPIO_DDR_LOW);
+	ddr = smc501_readl(regs + SM501_GPIO_DDR_LOW);
+	smc501_writel(ddr & ~bit, regs + SM501_GPIO_DDR_LOW);
 
 	sm501_sync_regs(sm501_gpio_to_dev(smgpio));
 	sm501_gpio_ensure_gpio(smchip, bit);
@@ -994,18 +995,18 @@ static int sm501_gpio_output(struct gpio_chip *chip,
 
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
@@ -1231,7 +1232,7 @@ static ssize_t sm501_dbg_regs(struct device *dev,
 
 	for (reg = 0x00; reg < 0x70; reg += 4) {
 		ret = sprintf(ptr, "%08x = %08x\n",
-			      reg, readl(sm->regs + reg));
+			      reg, smc501_readl(sm->regs + reg));
 		ptr += ret;
 	}
 
@@ -1255,10 +1256,10 @@ static inline void sm501_init_reg(struct sm501_devdata *sm,
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
@@ -1299,7 +1300,7 @@ static void sm501_init_regs(struct sm501_devdata *sm,
 
 static int sm501_check_clocks(struct sm501_devdata *sm)
 {
-	unsigned long pwrmode = readl(sm->regs + SM501_CURRENT_CLOCK);
+	unsigned long pwrmode = smc501_readl(sm->regs + SM501_CURRENT_CLOCK);
 	unsigned long msrc = (pwrmode & SM501_POWERMODE_M_SRC);
 	unsigned long m1src = (pwrmode & SM501_POWERMODE_M1_SRC);
 
@@ -1334,7 +1335,7 @@ static int __devinit sm501_init_dev(struct sm501_devdata *sm)
 
 	INIT_LIST_HEAD(&sm->devices);
 
-	devid = readl(sm->regs + SM501_DEVICEID);
+	devid = smc501_readl(sm->regs + SM501_DEVICEID);
 
 	if ((devid & SM501_DEVICEID_IDMASK) != SM501_DEVICEID_SM501) {
 		dev_err(sm->dev, "incorrect device id %08lx\n", devid);
@@ -1342,9 +1343,9 @@ static int __devinit sm501_init_dev(struct sm501_devdata *sm)
 	}
 
 	/* disable irqs */
-	writel(0, sm->regs + SM501_IRQ_MASK);
+	smc501_writel(0, sm->regs + SM501_IRQ_MASK);
 
-	dramctrl = readl(sm->regs + SM501_DRAM_CONTROL);
+	dramctrl = smc501_readl(sm->regs + SM501_DRAM_CONTROL);
 	mem_avail = sm501_mem_local[(dramctrl >> 13) & 0x7];
 
 	dev_info(sm->dev, "SM501 At %p: Version %08lx, %ld Mb, IRQ %d\n",
@@ -1489,7 +1490,7 @@ static int sm501_plat_suspend(struct platform_device *pdev, pm_message_t state)
 	struct sm501_devdata *sm = platform_get_drvdata(pdev);
 
 	sm->in_suspend = 1;
-	sm->pm_misc = readl(sm->regs + SM501_MISC_CONTROL);
+	sm->pm_misc = smc501_readl(sm->regs + SM501_MISC_CONTROL);
 
 	sm501_dump_regs(sm);
 
@@ -1513,9 +1514,9 @@ static int sm501_plat_resume(struct platform_device *pdev)
 
 	/* check to see if we are in the same state as when suspended */
 
-	if (readl(sm->regs + SM501_MISC_CONTROL) != sm->pm_misc) {
+	if (smc501_readl(sm->regs + SM501_MISC_CONTROL) != sm->pm_misc) {
 		dev_info(sm->dev, "SM501_MISC_CONTROL changed over sleep\n");
-		writel(sm->pm_misc, sm->regs + SM501_MISC_CONTROL);
+		smc501_writel(sm->pm_misc, sm->regs + SM501_MISC_CONTROL);
 
 		/* our suspend causes the controller state to change,
 		 * either by something attempting setup, power loss,
diff --git a/drivers/video/sm501fb.c b/drivers/video/sm501fb.c
index bcb44a5..5df406c 100644
--- a/drivers/video/sm501fb.c
+++ b/drivers/video/sm501fb.c
@@ -117,7 +117,7 @@ static inline int v_total(struct fb_var_screeninfo *var)
 
 static inline void sm501fb_sync_regs(struct sm501fb_info *info)
 {
-	readl(info->regs);
+	smc501_readl(info->regs);
 }
 
 /* sm501_alloc_mem
@@ -262,7 +262,7 @@ static void sm501fb_setup_gamma(struct sm501fb_info *fbi,
 
 	/* set gamma values */
 	for (offset = 0; offset < 256 * 4; offset += 4) {
-		writel(value, fbi->regs + palette + offset);
+		smc501_writel(value, fbi->regs + palette + offset);
 		value += 0x010101; 	/* Advance RGB by 1,1,1.*/
 	}
 }
@@ -476,7 +476,8 @@ static int sm501fb_set_par_common(struct fb_info *info,
 
 	/* set start of framebuffer to the screen */
 
-	writel(par->screen.sm_addr | SM501_ADDR_FLIP, fbi->regs + head_addr);
+	smc501_writel(par->screen.sm_addr | SM501_ADDR_FLIP,
+			fbi->regs + head_addr);
 
 	/* program CRT clock  */
 
@@ -519,7 +520,7 @@ static void sm501fb_set_par_geometry(struct fb_info *info,
 	reg = info->fix.line_length;
 	reg |= ((var->xres * var->bits_per_pixel)/8) << 16;
 
-	writel(reg, fbi->regs + (par->head == HEAD_CRT ?
+	smc501_writel(reg, fbi->regs + (par->head == HEAD_CRT ?
 		    SM501_DC_CRT_FB_OFFSET :  SM501_DC_PANEL_FB_OFFSET));
 
 	/* program horizontal total */
@@ -527,27 +528,27 @@ static void sm501fb_set_par_geometry(struct fb_info *info,
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
@@ -566,15 +567,15 @@ static int sm501fb_pan_crt(struct fb_var_screeninfo *var,
 
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
@@ -593,10 +594,10 @@ static int sm501fb_pan_pnl(struct fb_var_screeninfo *var,
 	unsigned long reg;
 
 	reg = var->xoffset | (var->xres_virtual << 16);
-	writel(reg, fbi->regs + SM501_DC_PANEL_FB_WIDTH);
+	smc501_writel(reg, fbi->regs + SM501_DC_PANEL_FB_WIDTH);
 
 	reg = var->yoffset | (var->yres_virtual << 16);
-	writel(reg, fbi->regs + SM501_DC_PANEL_FB_HEIGHT);
+	smc501_writel(reg, fbi->regs + SM501_DC_PANEL_FB_HEIGHT);
 
 	sm501fb_sync_regs(fbi);
 	return 0;
@@ -622,7 +623,7 @@ static int sm501fb_set_par_crt(struct fb_info *info)
 	/* enable CRT DAC - note 0 is on!*/
 	sm501_misc_control(fbi->dev->parent, 0, SM501_MISC_DAC_POWER);
 
-	control = readl(fbi->regs + SM501_DC_CRT_CONTROL);
+	control = smc501_readl(fbi->regs + SM501_DC_CRT_CONTROL);
 
 	control &= (SM501_DC_CRT_CONTROL_PIXEL_MASK |
 		    SM501_DC_CRT_CONTROL_GAMMA |
@@ -684,7 +685,7 @@ static int sm501fb_set_par_crt(struct fb_info *info)
  out_update:
 	dev_dbg(fbi->dev, "new control is %08lx\n", control);
 
-	writel(control, fbi->regs + SM501_DC_CRT_CONTROL);
+	smc501_writel(control, fbi->regs + SM501_DC_CRT_CONTROL);
 	sm501fb_sync_regs(fbi);
 
 	return 0;
@@ -696,18 +697,18 @@ static void sm501fb_panel_power(struct sm501fb_info *fbi, int to)
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
 
@@ -719,7 +720,7 @@ static void sm501fb_panel_power(struct sm501fb_info *fbi, int to)
 			else
 				control |= SM501_DC_PANEL_CONTROL_BIAS;
 
-			writel(control, ctrl_reg);
+			smc501_writel(control, ctrl_reg);
 			sm501fb_sync_regs(fbi);
 			mdelay(10);
 		}
@@ -730,7 +731,7 @@ static void sm501fb_panel_power(struct sm501fb_info *fbi, int to)
 			else
 				control |= SM501_DC_PANEL_CONTROL_FPEN;
 
-			writel(control, ctrl_reg);
+			smc501_writel(control, ctrl_reg);
 			sm501fb_sync_regs(fbi);
 			mdelay(10);
 		}
@@ -742,7 +743,7 @@ static void sm501fb_panel_power(struct sm501fb_info *fbi, int to)
 			else
 				control &= ~SM501_DC_PANEL_CONTROL_FPEN;
 
-			writel(control, ctrl_reg);
+			smc501_writel(control, ctrl_reg);
 			sm501fb_sync_regs(fbi);
 			mdelay(10);
 		}
@@ -753,18 +754,18 @@ static void sm501fb_panel_power(struct sm501fb_info *fbi, int to)
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
@@ -799,7 +800,7 @@ static int sm501fb_set_par_pnl(struct fb_info *info)
 
 	/* update control register */
 
-	control = readl(fbi->regs + SM501_DC_PANEL_CONTROL);
+	control = smc501_readl(fbi->regs + SM501_DC_PANEL_CONTROL);
 	control &= (SM501_DC_PANEL_CONTROL_GAMMA |
 		    SM501_DC_PANEL_CONTROL_VDD  |
 		    SM501_DC_PANEL_CONTROL_DATA |
@@ -833,16 +834,16 @@ static int sm501fb_set_par_pnl(struct fb_info *info)
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
 
@@ -855,7 +856,7 @@ static int sm501fb_set_par_pnl(struct fb_info *info)
 	if ((var->sync & FB_SYNC_VERT_HIGH_ACT) == 0)
 		control |= SM501_DC_PANEL_CONTROL_VSP;
 
-	writel(control, fbi->regs + SM501_DC_PANEL_CONTROL);
+	smc501_writel(control, fbi->regs + SM501_DC_PANEL_CONTROL);
 	sm501fb_sync_regs(fbi);
 
 	/* ensure the panel interface is not tristated at this point */
@@ -924,7 +925,7 @@ static int sm501fb_setcolreg(unsigned regno,
 			val |= (green >> 8) << 8;
 			val |= blue >> 8;
 
-			writel(val, base + (regno * 4));
+			smc501_writel(val, base + (regno * 4));
 		}
 
 		break;
@@ -980,7 +981,7 @@ static int sm501fb_blank_crt(int blank_mode, struct fb_info *info)
 
 	dev_dbg(fbi->dev, "%s(mode=%d, %p)\n", __func__, blank_mode, info);
 
-	ctrl = readl(fbi->regs + SM501_DC_CRT_CONTROL);
+	ctrl = smc501_readl(fbi->regs + SM501_DC_CRT_CONTROL);
 
 	switch (blank_mode) {
 	case FB_BLANK_POWERDOWN:
@@ -1004,7 +1005,7 @@ static int sm501fb_blank_crt(int blank_mode, struct fb_info *info)
 
 	}
 
-	writel(ctrl, fbi->regs + SM501_DC_CRT_CONTROL);
+	smc501_writel(ctrl, fbi->regs + SM501_DC_CRT_CONTROL);
 	sm501fb_sync_regs(fbi);
 
 	return 0;
@@ -1041,12 +1042,14 @@ static int sm501fb_cursor(struct fb_info *info, struct fb_cursor *cursor)
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
@@ -1060,7 +1063,7 @@ static int sm501fb_cursor(struct fb_info *info, struct fb_cursor *cursor)
 
 		//y += cursor->image.height;
 
-		writel(x | (y << 16), base + SM501_OFF_HWC_LOC);
+		smc501_writel(x | (y << 16), base + SM501_OFF_HWC_LOC);
 	}
 
 	if (cursor->set & FB_CUR_SETCMAP) {
@@ -1080,8 +1083,8 @@ static int sm501fb_cursor(struct fb_info *info, struct fb_cursor *cursor)
 
 		dev_dbg(fbi->dev, "fgcol %08lx, bgcol %08lx\n", fg, bg);
 
-		writel(bg, base + SM501_OFF_HWC_COLOR_1_2);
-		writel(fg, base + SM501_OFF_HWC_COLOR_3);
+		smc501_writel(bg, base + SM501_OFF_HWC_COLOR_1_2);
+		smc501_writel(fg, base + SM501_OFF_HWC_COLOR_3);
 	}
 
 	if (cursor->set & FB_CUR_SETSIZE ||
@@ -1102,7 +1105,7 @@ static int sm501fb_cursor(struct fb_info *info, struct fb_cursor *cursor)
 			__func__, cursor->image.width, cursor->image.height);
 
 		for (op = 0; op < (64*64*2)/8; op+=4)
-			writel(0x0, dst + op);
+			smc501_writel(0x0, dst + op);
 
 		for (y = 0; y < cursor->image.height; y++) {
 			for (x = 0; x < cursor->image.width; x++) {
@@ -1141,7 +1144,7 @@ static ssize_t sm501fb_crtsrc_show(struct device *dev,
 	struct sm501fb_info *info = dev_get_drvdata(dev);
 	unsigned long ctrl;
 
-	ctrl = readl(info->regs + SM501_DC_CRT_CONTROL);
+	ctrl = smc501_readl(info->regs + SM501_DC_CRT_CONTROL);
 	ctrl &= SM501_DC_CRT_CONTROL_SEL;
 
 	return snprintf(buf, PAGE_SIZE, "%s\n", ctrl ? "crt" : "panel");
@@ -1172,7 +1175,7 @@ static ssize_t sm501fb_crtsrc_store(struct device *dev,
 
 	dev_info(dev, "setting crt source to head %d\n", head);
 
-	ctrl = readl(info->regs + SM501_DC_CRT_CONTROL);
+	ctrl = smc501_readl(info->regs + SM501_DC_CRT_CONTROL);
 
 	if (head == HEAD_CRT) {
 		ctrl |= SM501_DC_CRT_CONTROL_SEL;
@@ -1184,7 +1187,7 @@ static ssize_t sm501fb_crtsrc_store(struct device *dev,
 		ctrl &= ~SM501_DC_CRT_CONTROL_TE;
 	}
 
-	writel(ctrl, info->regs + SM501_DC_CRT_CONTROL);
+	smc501_writel(ctrl, info->regs + SM501_DC_CRT_CONTROL);
 	sm501fb_sync_regs(info);
 
 	return len;
@@ -1205,7 +1208,8 @@ static int sm501fb_show_regs(struct sm501fb_info *info, char *ptr,
 	unsigned int reg;
 
 	for (reg = start; reg < (len + start); reg += 4)
-		ptr += sprintf(ptr, "%08x = %08x\n", reg, readl(mem + reg));
+		ptr += sprintf(ptr, "%08x = %08x\n", reg,
+				smc501_readl(mem + reg));
 
 	return ptr - buf;
 }
@@ -1257,7 +1261,7 @@ static int sm501fb_sync(struct fb_info *info)
 
 	/* wait for the 2d engine to be ready */
 	while ((count > 0) &&
-	       (readl(fbi->regs + SM501_SYSTEM_CONTROL) &
+	       (smc501_readl(fbi->regs + SM501_SYSTEM_CONTROL) &
 		SM501_SYSCTRL_2D_ENGINE_STATUS) != 0)
 		count--;
 
@@ -1312,45 +1316,46 @@ static void sm501fb_copyarea(struct fb_info *info, const struct fb_copyarea *are
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
@@ -1372,47 +1377,49 @@ static void sm501fb_fillrect(struct fb_info *info, const struct fb_fillrect *rec
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
 
 
@@ -1470,11 +1477,12 @@ static int sm501_init_cursor(struct fb_info *fbi, unsigned int reg_base)
 
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
@@ -1581,7 +1589,7 @@ static int sm501fb_start(struct sm501fb_info *info,
 
 	/* clear palette ram - undefined at power on */
 	for (k = 0; k < (256 * 3); k++)
-		writel(0, info->regs + SM501_DC_PANEL_PALETTE + (k * 4));
+		smc501_writel(0, info->regs + SM501_DC_PANEL_PALETTE + (k * 4));
 
 	/* enable display controller */
 	sm501_unit_power(dev->parent, SM501_GATE_DISPLAY, 1);
@@ -1649,20 +1657,20 @@ static int sm501fb_init_fb(struct fb_info *fb,
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
 
@@ -1680,7 +1688,7 @@ static int sm501fb_init_fb(struct fb_info *fb,
 
 	if (head == HEAD_CRT && info->pdata->fb_route == SM501_FB_CRT_PANEL) {
 		ctrl &= ~SM501_DC_CRT_CONTROL_SEL;
-		writel(ctrl, info->regs + SM501_DC_CRT_CONTROL);
+		smc501_writel(ctrl, info->regs + SM501_DC_CRT_CONTROL);
 		enable = 0;
 	}
 
@@ -2085,7 +2093,7 @@ static int sm501fb_suspend(struct platform_device *pdev, pm_message_t state)
 	struct sm501fb_info *info = platform_get_drvdata(pdev);
 
 	/* store crt control to resume with */
-	info->pm_crt_ctrl = readl(info->regs + SM501_DC_CRT_CONTROL);
+	info->pm_crt_ctrl = smc501_readl(info->regs + SM501_DC_CRT_CONTROL);
 
 	sm501fb_suspend_fb(info, HEAD_CRT);
 	sm501fb_suspend_fb(info, HEAD_PANEL);
@@ -2109,10 +2117,10 @@ static int sm501fb_resume(struct platform_device *pdev)
 
 	/* restore the items we want to be saved for crt control */
 
-	crt_ctrl = readl(info->regs + SM501_DC_CRT_CONTROL);
+	crt_ctrl = smc501_readl(info->regs + SM501_DC_CRT_CONTROL);
 	crt_ctrl &= ~SM501_CRT_CTRL_SAVE;
 	crt_ctrl |= info->pm_crt_ctrl & SM501_CRT_CTRL_SAVE;
-	writel(crt_ctrl, info->regs + SM501_DC_CRT_CONTROL);
+	smc501_writel(crt_ctrl, info->regs + SM501_DC_CRT_CONTROL);
 
 	sm501fb_resume_fb(info, HEAD_CRT);
 	sm501fb_resume_fb(info, HEAD_PANEL);
diff --git a/include/linux/sm501.h b/include/linux/sm501.h
index 214f932..02fde50 100644
--- a/include/linux/sm501.h
+++ b/include/linux/sm501.h
@@ -172,3 +172,11 @@ struct sm501_platdata {
 	struct sm501_platdata_gpio_i2c	*gpio_i2c;
 	unsigned int			 gpio_i2c_nr;
 };
+
+#if defined(CONFIG_PPC32)
+#define smc501_readl(addr)		ioread32be((addr))
+#define smc501_writel(val, addr)	iowrite32be((val), (addr))
+#else
+#define smc501_readl(addr)		readl(addr)
+#define smc501_writel(val, addr)	writel(val, addr)
+#endif
-- 
1.7.4

