Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990Ab1EIVkB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 17:40:01 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:50373 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754950Ab1EIVj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:39:59 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: alsa-devel@alsa-project.org
Subject: [PATCH 3/3] fm801: convert TEA575x support to new interface
Date: Mon, 9 May 2011 23:39:51 +0200
User-Agent: KMail/1.9.10
Cc: linux-media@vger.kernel.org,
        "Kernel development list" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201105092339.54051.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use common functions to access TEA575x tuner - remove original read/write
functions and provide new pin manipulation functions instead.

Also convert the original triple implementation to a simple GPIO pin map.

Tested with SF256-PCP and SF64-PCR (added the GPIO pin for MO/ST signal
for them).
SF256-PCS untested (pin for MO/ST signal is a guess).

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-2.6.39-rc2-/sound/pci/fm801.c	2011-05-06 22:44:22.000000000 +0200
+++ linux-2.6.39-rc2/sound/pci/fm801.c	2011-05-09 22:59:16.000000000 +0200
@@ -717,308 +717,86 @@ static int __devinit snd_fm801_pcm(struc
 
 #ifdef TEA575X_RADIO
 
-/* 256PCS GPIO numbers */
-#define TEA_256PCS_DATA			1
-#define TEA_256PCS_WRITE_ENABLE		2	/* inverted */
-#define TEA_256PCS_BUS_CLOCK		3
-
-static void snd_fm801_tea575x_256pcs_write(struct snd_tea575x *tea, unsigned int val)
-{
-	struct fm801 *chip = tea->private_data;
-	unsigned short reg;
-	int i = 25;
-
-	spin_lock_irq(&chip->reg_lock);
-	reg = inw(FM801_REG(chip, GPIO_CTRL));
-	/* use GPIO lines and set write enable bit */
-	reg |= FM801_GPIO_GS(TEA_256PCS_DATA) |
-	       FM801_GPIO_GS(TEA_256PCS_WRITE_ENABLE) |
-	       FM801_GPIO_GS(TEA_256PCS_BUS_CLOCK);
-	/* all of lines are in the write direction */
-	/* clear data and clock lines */
-	reg &= ~(FM801_GPIO_GD(TEA_256PCS_DATA) |
-	         FM801_GPIO_GD(TEA_256PCS_WRITE_ENABLE) |
-	         FM801_GPIO_GD(TEA_256PCS_BUS_CLOCK) |
-	         FM801_GPIO_GP(TEA_256PCS_DATA) |
-	         FM801_GPIO_GP(TEA_256PCS_BUS_CLOCK) |
-		 FM801_GPIO_GP(TEA_256PCS_WRITE_ENABLE));
-	outw(reg, FM801_REG(chip, GPIO_CTRL));
-	udelay(1);
-
-	while (i--) {
-		if (val & (1 << i))
-			reg |= FM801_GPIO_GP(TEA_256PCS_DATA);
-		else
-			reg &= ~FM801_GPIO_GP(TEA_256PCS_DATA);
-		outw(reg, FM801_REG(chip, GPIO_CTRL));
-		udelay(1);
-		reg |= FM801_GPIO_GP(TEA_256PCS_BUS_CLOCK);
-		outw(reg, FM801_REG(chip, GPIO_CTRL));
-		reg &= ~FM801_GPIO_GP(TEA_256PCS_BUS_CLOCK);
-		outw(reg, FM801_REG(chip, GPIO_CTRL));
-		udelay(1);
-	}
-
-	/* and reset the write enable bit */
-	reg |= FM801_GPIO_GP(TEA_256PCS_WRITE_ENABLE) |
-	       FM801_GPIO_GP(TEA_256PCS_DATA);
-	outw(reg, FM801_REG(chip, GPIO_CTRL));
-	spin_unlock_irq(&chip->reg_lock);
-}
-
-static unsigned int snd_fm801_tea575x_256pcs_read(struct snd_tea575x *tea)
-{
-	struct fm801 *chip = tea->private_data;
-	unsigned short reg;
-	unsigned int val = 0;
-	int i;
-	
-	spin_lock_irq(&chip->reg_lock);
-	reg = inw(FM801_REG(chip, GPIO_CTRL));
-	/* use GPIO lines, set data direction to input */
-	reg |= FM801_GPIO_GS(TEA_256PCS_DATA) |
-	       FM801_GPIO_GS(TEA_256PCS_WRITE_ENABLE) |
-	       FM801_GPIO_GS(TEA_256PCS_BUS_CLOCK) |
-	       FM801_GPIO_GD(TEA_256PCS_DATA) |
-	       FM801_GPIO_GP(TEA_256PCS_DATA) |
-	       FM801_GPIO_GP(TEA_256PCS_WRITE_ENABLE);
-	/* all of lines are in the write direction, except data */
-	/* clear data, write enable and clock lines */
-	reg &= ~(FM801_GPIO_GD(TEA_256PCS_WRITE_ENABLE) |
-	         FM801_GPIO_GD(TEA_256PCS_BUS_CLOCK) |
-	         FM801_GPIO_GP(TEA_256PCS_BUS_CLOCK));
-
-	for (i = 0; i < 24; i++) {
-		reg &= ~FM801_GPIO_GP(TEA_256PCS_BUS_CLOCK);
-		outw(reg, FM801_REG(chip, GPIO_CTRL));
-		udelay(1);
-		reg |= FM801_GPIO_GP(TEA_256PCS_BUS_CLOCK);
-		outw(reg, FM801_REG(chip, GPIO_CTRL));
-		udelay(1);
-		val <<= 1;
-		if (inw(FM801_REG(chip, GPIO_CTRL)) & FM801_GPIO_GP(TEA_256PCS_DATA))
-			val |= 1;
-	}
-
-	spin_unlock_irq(&chip->reg_lock);
-
-	return val;
-}
+/* GPIO to TEA575x maps */
+struct snd_fm801_tea575x_gpio {
+	u8 data, clk, wren, most;
+};
 
-/* 256PCPR GPIO numbers */
-#define TEA_256PCPR_BUS_CLOCK		0
-#define TEA_256PCPR_DATA		1
-#define TEA_256PCPR_WRITE_ENABLE	2	/* inverted */
+static struct snd_fm801_tea575x_gpio snd_fm801_tea575x_gpios[] = {
+	{ .data = 1, .clk = 3, .wren = 2, .most = 0 },	/* SF256-PCS */
+	{ .data = 1, .clk = 0, .wren = 2, .most = 3 },	/* SF256-PCP */
+	{ .data = 2, .clk = 0, .wren = 1, .most = 3 },	/* SF64-PCR */
+};
 
-static void snd_fm801_tea575x_256pcpr_write(struct snd_tea575x *tea, unsigned int val)
+static void snd_fm801_tea575x_set_pins(struct snd_tea575x *tea, u8 pins)
 {
 	struct fm801 *chip = tea->private_data;
-	unsigned short reg;
-	int i = 25;
+	unsigned short reg = inw(FM801_REG(chip, GPIO_CTRL));
+	struct snd_fm801_tea575x_gpio gpio = snd_fm801_tea575x_gpios[(chip->tea575x_tuner & TUNER_TYPE_MASK) - 1];
 
-	spin_lock_irq(&chip->reg_lock);
-	reg = inw(FM801_REG(chip, GPIO_CTRL));
-	/* use GPIO lines and set write enable bit */
-	reg |= FM801_GPIO_GS(TEA_256PCPR_DATA) |
-	       FM801_GPIO_GS(TEA_256PCPR_WRITE_ENABLE) |
-	       FM801_GPIO_GS(TEA_256PCPR_BUS_CLOCK);
-	/* all of lines are in the write direction */
-	/* clear data and clock lines */
-	reg &= ~(FM801_GPIO_GD(TEA_256PCPR_DATA) |
-	         FM801_GPIO_GD(TEA_256PCPR_WRITE_ENABLE) |
-	         FM801_GPIO_GD(TEA_256PCPR_BUS_CLOCK) |
-	         FM801_GPIO_GP(TEA_256PCPR_DATA) |
-	         FM801_GPIO_GP(TEA_256PCPR_BUS_CLOCK) |
-		 FM801_GPIO_GP(TEA_256PCPR_WRITE_ENABLE));
-	outw(reg, FM801_REG(chip, GPIO_CTRL));
-	udelay(1);
+	reg &= ~(FM801_GPIO_GP(gpio.data) |
+		 FM801_GPIO_GP(gpio.clk) |
+		 FM801_GPIO_GP(gpio.wren));
+
+	reg |= (pins & TEA575X_DATA) ? FM801_GPIO_GP(gpio.data) : 0;
+	reg |= (pins & TEA575X_CLK)  ? FM801_GPIO_GP(gpio.clk) : 0;
+	/* WRITE_ENABLE is inverted */
+	reg |= (pins & TEA575X_WREN) ? 0 : FM801_GPIO_GP(gpio.wren);
 
-	while (i--) {
-		if (val & (1 << i))
-			reg |= FM801_GPIO_GP(TEA_256PCPR_DATA);
-		else
-			reg &= ~FM801_GPIO_GP(TEA_256PCPR_DATA);
-		outw(reg, FM801_REG(chip, GPIO_CTRL));
-		udelay(1);
-		reg |= FM801_GPIO_GP(TEA_256PCPR_BUS_CLOCK);
-		outw(reg, FM801_REG(chip, GPIO_CTRL));
-		reg &= ~FM801_GPIO_GP(TEA_256PCPR_BUS_CLOCK);
-		outw(reg, FM801_REG(chip, GPIO_CTRL));
-		udelay(1);
-	}
-
-	/* and reset the write enable bit */
-	reg |= FM801_GPIO_GP(TEA_256PCPR_WRITE_ENABLE) |
-	       FM801_GPIO_GP(TEA_256PCPR_DATA);
 	outw(reg, FM801_REG(chip, GPIO_CTRL));
-	spin_unlock_irq(&chip->reg_lock);
 }
 
-static unsigned int snd_fm801_tea575x_256pcpr_read(struct snd_tea575x *tea)
+static u8 snd_fm801_tea575x_get_pins(struct snd_tea575x *tea)
 {
 	struct fm801 *chip = tea->private_data;
-	unsigned short reg;
-	unsigned int val = 0;
-	int i;
-	
-	spin_lock_irq(&chip->reg_lock);
-	reg = inw(FM801_REG(chip, GPIO_CTRL));
-	/* use GPIO lines, set data direction to input */
-	reg |= FM801_GPIO_GS(TEA_256PCPR_DATA) |
-	       FM801_GPIO_GS(TEA_256PCPR_WRITE_ENABLE) |
-	       FM801_GPIO_GS(TEA_256PCPR_BUS_CLOCK) |
-	       FM801_GPIO_GD(TEA_256PCPR_DATA) |
-	       FM801_GPIO_GP(TEA_256PCPR_DATA) |
-	       FM801_GPIO_GP(TEA_256PCPR_WRITE_ENABLE);
-	/* all of lines are in the write direction, except data */
-	/* clear data, write enable and clock lines */
-	reg &= ~(FM801_GPIO_GD(TEA_256PCPR_WRITE_ENABLE) |
-	         FM801_GPIO_GD(TEA_256PCPR_BUS_CLOCK) |
-	         FM801_GPIO_GP(TEA_256PCPR_BUS_CLOCK));
-
-	for (i = 0; i < 24; i++) {
-		reg &= ~FM801_GPIO_GP(TEA_256PCPR_BUS_CLOCK);
-		outw(reg, FM801_REG(chip, GPIO_CTRL));
-		udelay(1);
-		reg |= FM801_GPIO_GP(TEA_256PCPR_BUS_CLOCK);
-		outw(reg, FM801_REG(chip, GPIO_CTRL));
-		udelay(1);
-		val <<= 1;
-		if (inw(FM801_REG(chip, GPIO_CTRL)) & FM801_GPIO_GP(TEA_256PCPR_DATA))
-			val |= 1;
-	}
+	unsigned short reg = inw(FM801_REG(chip, GPIO_CTRL));
+	struct snd_fm801_tea575x_gpio gpio = snd_fm801_tea575x_gpios[(chip->tea575x_tuner & TUNER_TYPE_MASK) - 1];
 
-	spin_unlock_irq(&chip->reg_lock);
-
-	return val;
+	return  (reg & FM801_GPIO_GP(gpio.data)) ? TEA575X_DATA : 0 |
+		(reg & FM801_GPIO_GP(gpio.most)) ? TEA575X_MOST : 0;
 }
 
-/* 64PCR GPIO numbers */
-#define TEA_64PCR_BUS_CLOCK		0
-#define TEA_64PCR_WRITE_ENABLE		1	/* inverted */
-#define TEA_64PCR_DATA			2
-
-static void snd_fm801_tea575x_64pcr_write(struct snd_tea575x *tea, unsigned int val)
+static void snd_fm801_tea575x_set_direction(struct snd_tea575x *tea, bool output)
 {
 	struct fm801 *chip = tea->private_data;
-	unsigned short reg;
-	int i = 25;
+	unsigned short reg = inw(FM801_REG(chip, GPIO_CTRL));
+	struct snd_fm801_tea575x_gpio gpio = snd_fm801_tea575x_gpios[(chip->tea575x_tuner & TUNER_TYPE_MASK) - 1];
 
-	spin_lock_irq(&chip->reg_lock);
-	reg = inw(FM801_REG(chip, GPIO_CTRL));
 	/* use GPIO lines and set write enable bit */
-	reg |= FM801_GPIO_GS(TEA_64PCR_DATA) |
-	       FM801_GPIO_GS(TEA_64PCR_WRITE_ENABLE) |
-	       FM801_GPIO_GS(TEA_64PCR_BUS_CLOCK);
-	/* all of lines are in the write direction */
-	/* clear data and clock lines */
-	reg &= ~(FM801_GPIO_GD(TEA_64PCR_DATA) |
-	         FM801_GPIO_GD(TEA_64PCR_WRITE_ENABLE) |
-	         FM801_GPIO_GD(TEA_64PCR_BUS_CLOCK) |
-	         FM801_GPIO_GP(TEA_64PCR_DATA) |
-	         FM801_GPIO_GP(TEA_64PCR_BUS_CLOCK) |
-		 FM801_GPIO_GP(TEA_64PCR_WRITE_ENABLE));
-	outw(reg, FM801_REG(chip, GPIO_CTRL));
-	udelay(1);
-
-	while (i--) {
-		if (val & (1 << i))
-			reg |= FM801_GPIO_GP(TEA_64PCR_DATA);
-		else
-			reg &= ~FM801_GPIO_GP(TEA_64PCR_DATA);
-		outw(reg, FM801_REG(chip, GPIO_CTRL));
-		udelay(1);
-		reg |= FM801_GPIO_GP(TEA_64PCR_BUS_CLOCK);
-		outw(reg, FM801_REG(chip, GPIO_CTRL));
-		reg &= ~FM801_GPIO_GP(TEA_64PCR_BUS_CLOCK);
-		outw(reg, FM801_REG(chip, GPIO_CTRL));
-		udelay(1);
-	}
-
-	/* and reset the write enable bit */
-	reg |= FM801_GPIO_GP(TEA_64PCR_WRITE_ENABLE) |
-	       FM801_GPIO_GP(TEA_64PCR_DATA);
-	outw(reg, FM801_REG(chip, GPIO_CTRL));
-	spin_unlock_irq(&chip->reg_lock);
-}
-
-static unsigned int snd_fm801_tea575x_64pcr_read(struct snd_tea575x *tea)
-{
-	struct fm801 *chip = tea->private_data;
-	unsigned short reg;
-	unsigned int val = 0;
-	int i;
-	
-	spin_lock_irq(&chip->reg_lock);
-	reg = inw(FM801_REG(chip, GPIO_CTRL));
-	/* use GPIO lines, set data direction to input */
-	reg |= FM801_GPIO_GS(TEA_64PCR_DATA) |
-	       FM801_GPIO_GS(TEA_64PCR_WRITE_ENABLE) |
-	       FM801_GPIO_GS(TEA_64PCR_BUS_CLOCK) |
-	       FM801_GPIO_GD(TEA_64PCR_DATA) |
-	       FM801_GPIO_GP(TEA_64PCR_DATA) |
-	       FM801_GPIO_GP(TEA_64PCR_WRITE_ENABLE);
-	/* all of lines are in the write direction, except data */
-	/* clear data, write enable and clock lines */
-	reg &= ~(FM801_GPIO_GD(TEA_64PCR_WRITE_ENABLE) |
-	         FM801_GPIO_GD(TEA_64PCR_BUS_CLOCK) |
-	         FM801_GPIO_GP(TEA_64PCR_BUS_CLOCK));
-
-	for (i = 0; i < 24; i++) {
-		reg &= ~FM801_GPIO_GP(TEA_64PCR_BUS_CLOCK);
-		outw(reg, FM801_REG(chip, GPIO_CTRL));
-		udelay(1);
-		reg |= FM801_GPIO_GP(TEA_64PCR_BUS_CLOCK);
-		outw(reg, FM801_REG(chip, GPIO_CTRL));
-		udelay(1);
-		val <<= 1;
-		if (inw(FM801_REG(chip, GPIO_CTRL)) & FM801_GPIO_GP(TEA_64PCR_DATA))
-			val |= 1;
+	reg |= FM801_GPIO_GS(gpio.data) |
+	       FM801_GPIO_GS(gpio.wren) |
+	       FM801_GPIO_GS(gpio.clk) |
+	       FM801_GPIO_GS(gpio.most);
+	if (output) {
+		/* all of lines are in the write direction */
+		/* clear data and clock lines */
+		reg &= ~(FM801_GPIO_GD(gpio.data) |
+			 FM801_GPIO_GD(gpio.wren) |
+			 FM801_GPIO_GD(gpio.clk) |
+			 FM801_GPIO_GP(gpio.data) |
+			 FM801_GPIO_GP(gpio.clk) |
+			 FM801_GPIO_GP(gpio.wren));
+	} else {
+		/* use GPIO lines, set data direction to input */
+		reg |= FM801_GPIO_GD(gpio.data) |
+		       FM801_GPIO_GD(gpio.most) |
+		       FM801_GPIO_GP(gpio.data) |
+		       FM801_GPIO_GP(gpio.most) |
+		       FM801_GPIO_GP(gpio.wren);
+		/* all of lines are in the write direction, except data */
+		/* clear data, write enable and clock lines */
+		reg &= ~(FM801_GPIO_GD(gpio.wren) |
+			 FM801_GPIO_GD(gpio.clk) |
+			 FM801_GPIO_GP(gpio.clk));
 	}
 
-	spin_unlock_irq(&chip->reg_lock);
-
-	return val;
-}
-
-static void snd_fm801_tea575x_64pcr_mute(struct snd_tea575x *tea,
-					  unsigned int mute)
-{
-	struct fm801 *chip = tea->private_data;
-	unsigned short reg;
-
-	spin_lock_irq(&chip->reg_lock);
-
-	reg = inw(FM801_REG(chip, GPIO_CTRL));
-	if (mute)
-		/* 0xf800 (mute) */
-		reg &= ~FM801_GPIO_GP(TEA_64PCR_WRITE_ENABLE);
-	else
-		/* 0xf802 (unmute) */
-		reg |= FM801_GPIO_GP(TEA_64PCR_WRITE_ENABLE);
 	outw(reg, FM801_REG(chip, GPIO_CTRL));
-	udelay(1);
-
-	spin_unlock_irq(&chip->reg_lock);
 }
 
-static struct snd_tea575x_ops snd_fm801_tea_ops[3] = {
-	{
-		/* 1 = MediaForte 256-PCS */
-		.write = snd_fm801_tea575x_256pcs_write,
-		.read = snd_fm801_tea575x_256pcs_read,
-	},
-	{
-		/* 2 = MediaForte 256-PCPR */
-		.write = snd_fm801_tea575x_256pcpr_write,
-		.read = snd_fm801_tea575x_256pcpr_read,
-	},
-	{
-		/* 3 = MediaForte 64-PCR */
-		.write = snd_fm801_tea575x_64pcr_write,
-		.read = snd_fm801_tea575x_64pcr_read,
-		.mute = snd_fm801_tea575x_64pcr_mute,
-	}
+static struct snd_tea575x_ops snd_fm801_tea_ops = {
+	.set_pins = snd_fm801_tea575x_set_pins,
+	.get_pins = snd_fm801_tea575x_get_pins,
+	.set_direction = snd_fm801_tea575x_set_direction,
 };
 #endif
 
@@ -1456,7 +1234,7 @@ static int __devinit snd_fm801_create(st
 		chip->tea.card = card;
 		chip->tea.freq_fixup = 10700;
 		chip->tea.private_data = chip;
-		chip->tea.ops = &snd_fm801_tea_ops[(tea575x_tuner & TUNER_TYPE_MASK) - 1];
+		chip->tea.ops = &snd_fm801_tea_ops;
 		snd_tea575x_init(&chip->tea);
 	}
 #endif



-- 
Ondrej Zary
