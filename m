Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759317Ab1D0NP0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 09:15:26 -0400
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:49943 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759181Ab1D0NOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 09:14:51 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Grant Likely <grant.likely@secretlab.ca>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 10/10] gpio/nomadik-gpio: merge pinconfig API
Date: Wed, 27 Apr 2011 15:14:35 +0200
Message-ID: <1303910075-3604-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This merges the pin configuration API from plat-nomadik into the
Nomadik GPIO driver and switches over to using the new generic
GPIO configuration API wherever apropriate. Some custom config
parameters are provided, and the bitstuffed pin configuration
vectors are internally converted into a proper configuration
struct.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-nomadik/board-nhk8815.c       |    2 +-
 arch/arm/mach-nomadik/i2c-8815nhk.c         |   12 +-
 arch/arm/mach-ux500/board-mop500-pins.c     |    1 -
 arch/arm/mach-ux500/board-u5500-sdi.c       |    1 -
 arch/arm/mach-ux500/pins-db5500.h           |    2 +
 arch/arm/mach-ux500/pins-db8500.h           |    2 +
 arch/arm/plat-nomadik/include/plat/pincfg.h |  139 ------
 drivers/gpio/nomadik-gpio.c                 |  673 ++++++++++++---------------
 include/linux/gpio/nomadik.h                |  282 ++++++++++--
 9 files changed, 560 insertions(+), 554 deletions(-)
 delete mode 100644 arch/arm/plat-nomadik/include/plat/pincfg.h

diff --git a/arch/arm/mach-nomadik/board-nhk8815.c b/arch/arm/mach-nomadik/board-nhk8815.c
index de7a1c1..3da7b81 100644
--- a/arch/arm/mach-nomadik/board-nhk8815.c
+++ b/arch/arm/mach-nomadik/board-nhk8815.c
@@ -227,7 +227,7 @@ static int __init nhk8815_eth_init(void)
 	int err;
 
 	err = gpio_request(gpio_nr, "eth_irq");
-	if (!err) err = nmk_gpio_set_mode(gpio_nr, NMK_GPIO_ALT_GPIO);
+	if (!err) err = gpio_config(gpio_nr, GPIO_CONFIG_NMK_ALTF_GPIO, NULL);
 	if (!err) err = gpio_direction_input(gpio_nr);
 	if (err)
 		pr_err("Error %i in %s\n", err, __func__);
diff --git a/arch/arm/mach-nomadik/i2c-8815nhk.c b/arch/arm/mach-nomadik/i2c-8815nhk.c
index a6c7dc4..f79252f 100644
--- a/arch/arm/mach-nomadik/i2c-8815nhk.c
+++ b/arch/arm/mach-nomadik/i2c-8815nhk.c
@@ -43,12 +43,16 @@ static struct platform_device nhk8815_i2c_dev1 = {
 
 static int __init nhk8815_i2c_init(void)
 {
-	nmk_gpio_set_mode(nhk8815_i2c_data0.scl_pin, NMK_GPIO_ALT_GPIO);
-	nmk_gpio_set_mode(nhk8815_i2c_data0.sda_pin, NMK_GPIO_ALT_GPIO);
+	gpio_config(nhk8815_i2c_data0.scl_pin,
+		    GPIO_CONFIG_NMK_ALTF_GPIO, NULL);
+	gpio_config(nhk8815_i2c_data0.sda_pin,
+		    GPIO_CONFIG_NMK_ALTF_GPIO, NULL);
 	platform_device_register(&nhk8815_i2c_dev0);
 
-	nmk_gpio_set_mode(nhk8815_i2c_data1.scl_pin, NMK_GPIO_ALT_GPIO);
-	nmk_gpio_set_mode(nhk8815_i2c_data1.sda_pin, NMK_GPIO_ALT_GPIO);
+	gpio_config(nhk8815_i2c_data1.scl_pin,
+		    GPIO_CONFIG_NMK_ALTF_GPIO, NULL);
+	gpio_config(nhk8815_i2c_data1.sda_pin,
+		    GPIO_CONFIG_NMK_ALTF_GPIO, NULL);
 	platform_device_register(&nhk8815_i2c_dev1);
 
 	return 0;
diff --git a/arch/arm/mach-ux500/board-mop500-pins.c b/arch/arm/mach-ux500/board-mop500-pins.c
index 9af4a4f..aafa0bf 100644
--- a/arch/arm/mach-ux500/board-mop500-pins.c
+++ b/arch/arm/mach-ux500/board-mop500-pins.c
@@ -9,7 +9,6 @@
 #include <linux/gpio/nomadik.h>
 
 #include <asm/mach-types.h>
-#include <plat/pincfg.h>
 #include <mach/hardware.h>
 
 #include "pins-db8500.h"
diff --git a/arch/arm/mach-ux500/board-u5500-sdi.c b/arch/arm/mach-ux500/board-u5500-sdi.c
index 16e87eb..005bef9 100644
--- a/arch/arm/mach-ux500/board-u5500-sdi.c
+++ b/arch/arm/mach-ux500/board-u5500-sdi.c
@@ -9,7 +9,6 @@
 #include <linux/mmc/host.h>
 #include <linux/gpio/nomadik.h>
 
-#include <plat/pincfg.h>
 #include <mach/db5500-regs.h>
 #include <plat/ste_dma40.h>
 
diff --git a/arch/arm/mach-ux500/pins-db5500.h b/arch/arm/mach-ux500/pins-db5500.h
index bf50c21..289404b 100644
--- a/arch/arm/mach-ux500/pins-db5500.h
+++ b/arch/arm/mach-ux500/pins-db5500.h
@@ -8,6 +8,8 @@
 #ifndef __MACH_DB5500_PINS_H
 #define __MACH_DB5500_PINS_H
 
+#include <linux/gpio/nomadik.h>
+
 #define GPIO0_GPIO		PIN_CFG(0, GPIO)
 #define GPIO0_SM_CS3n		PIN_CFG(0, ALT_A)
 
diff --git a/arch/arm/mach-ux500/pins-db8500.h b/arch/arm/mach-ux500/pins-db8500.h
index 8b1d1a7..74c4111 100644
--- a/arch/arm/mach-ux500/pins-db8500.h
+++ b/arch/arm/mach-ux500/pins-db8500.h
@@ -8,6 +8,8 @@
 #ifndef __MACH_PINS_DB8500_H
 #define __MACH_PINS_DB8500_H
 
+#include <linux/gpio/nomadik.h>
+
 /*
  * TODO: Eventually encode all non-board specific pull up/down configuration
  * here.
diff --git a/arch/arm/plat-nomadik/include/plat/pincfg.h b/arch/arm/plat-nomadik/include/plat/pincfg.h
deleted file mode 100644
index 22cb97d..0000000
--- a/arch/arm/plat-nomadik/include/plat/pincfg.h
+++ /dev/null
@@ -1,139 +0,0 @@
-/*
- * Copyright (C) ST-Ericsson SA 2010
- *
- * License terms: GNU General Public License, version 2
- * Author: Rabin Vincent <rabin.vincent@stericsson.com> for ST-Ericsson
- *
- * Based on arch/arm/mach-pxa/include/mach/mfp.h:
- *   Copyright (C) 2007 Marvell International Ltd.
- *   eric miao <eric.miao@marvell.com>
- */
-
-#ifndef __PLAT_PINCFG_H
-#define __PLAT_PINCFG_H
-
-/*
- * pin configurations are represented by 32-bit integers:
- *
- *	bit  0.. 8 - Pin Number (512 Pins Maximum)
- *	bit  9..10 - Alternate Function Selection
- *	bit 11..12 - Pull up/down state
- *	bit     13 - Sleep mode behaviour
- *	bit     14 - Direction
- *	bit     15 - Value (if output)
- *	bit 16..18 - SLPM pull up/down state
- *	bit 19..20 - SLPM direction
- *	bit 21..22 - SLPM Value (if output)
- *
- * to facilitate the definition, the following macros are provided
- *
- * PIN_CFG_DEFAULT - default config (0):
- *		     pull up/down = disabled
- *		     sleep mode = input/wakeup
- *		     direction = input
- *		     value = low
- *		     SLPM direction = same as normal
- *		     SLPM pull = same as normal
- *		     SLPM value = same as normal
- *
- * PIN_CFG	   - default config with alternate function
- */
-
-typedef unsigned long pin_cfg_t;
-
-#define PIN_NUM_MASK		0x1ff
-#define PIN_NUM(x)		((x) & PIN_NUM_MASK)
-
-#define PIN_ALT_SHIFT		9
-#define PIN_ALT_MASK		(0x3 << PIN_ALT_SHIFT)
-#define PIN_ALT(x)		(((x) & PIN_ALT_MASK) >> PIN_ALT_SHIFT)
-#define PIN_GPIO		(NMK_GPIO_ALT_GPIO << PIN_ALT_SHIFT)
-#define PIN_ALT_A		(NMK_GPIO_ALT_A << PIN_ALT_SHIFT)
-#define PIN_ALT_B		(NMK_GPIO_ALT_B << PIN_ALT_SHIFT)
-#define PIN_ALT_C		(NMK_GPIO_ALT_C << PIN_ALT_SHIFT)
-
-#define PIN_PULL_SHIFT		11
-#define PIN_PULL_MASK		(0x3 << PIN_PULL_SHIFT)
-#define PIN_PULL(x)		(((x) & PIN_PULL_MASK) >> PIN_PULL_SHIFT)
-#define PIN_PULL_NONE		(NMK_GPIO_PULL_NONE << PIN_PULL_SHIFT)
-#define PIN_PULL_UP		(NMK_GPIO_PULL_UP << PIN_PULL_SHIFT)
-#define PIN_PULL_DOWN		(NMK_GPIO_PULL_DOWN << PIN_PULL_SHIFT)
-
-#define PIN_SLPM_SHIFT		13
-#define PIN_SLPM_MASK		(0x1 << PIN_SLPM_SHIFT)
-#define PIN_SLPM(x)		(((x) & PIN_SLPM_MASK) >> PIN_SLPM_SHIFT)
-#define PIN_SLPM_MAKE_INPUT	(NMK_GPIO_SLPM_INPUT << PIN_SLPM_SHIFT)
-#define PIN_SLPM_NOCHANGE	(NMK_GPIO_SLPM_NOCHANGE << PIN_SLPM_SHIFT)
-/* These two replace the above in DB8500v2+ */
-#define PIN_SLPM_WAKEUP_ENABLE	(NMK_GPIO_SLPM_WAKEUP_ENABLE << PIN_SLPM_SHIFT)
-#define PIN_SLPM_WAKEUP_DISABLE	(NMK_GPIO_SLPM_WAKEUP_DISABLE << PIN_SLPM_SHIFT)
-
-#define PIN_DIR_SHIFT		14
-#define PIN_DIR_MASK		(0x1 << PIN_DIR_SHIFT)
-#define PIN_DIR(x)		(((x) & PIN_DIR_MASK) >> PIN_DIR_SHIFT)
-#define PIN_DIR_INPUT		(0 << PIN_DIR_SHIFT)
-#define PIN_DIR_OUTPUT		(1 << PIN_DIR_SHIFT)
-
-#define PIN_VAL_SHIFT		15
-#define PIN_VAL_MASK		(0x1 << PIN_VAL_SHIFT)
-#define PIN_VAL(x)		(((x) & PIN_VAL_MASK) >> PIN_VAL_SHIFT)
-#define PIN_VAL_LOW		(0 << PIN_VAL_SHIFT)
-#define PIN_VAL_HIGH		(1 << PIN_VAL_SHIFT)
-
-#define PIN_SLPM_PULL_SHIFT	16
-#define PIN_SLPM_PULL_MASK	(0x7 << PIN_SLPM_PULL_SHIFT)
-#define PIN_SLPM_PULL(x)	\
-	(((x) & PIN_SLPM_PULL_MASK) >> PIN_SLPM_PULL_SHIFT)
-#define PIN_SLPM_PULL_NONE	\
-	((1 + NMK_GPIO_PULL_NONE) << PIN_SLPM_PULL_SHIFT)
-#define PIN_SLPM_PULL_UP	\
-	((1 + NMK_GPIO_PULL_UP) << PIN_SLPM_PULL_SHIFT)
-#define PIN_SLPM_PULL_DOWN	\
-	((1 + NMK_GPIO_PULL_DOWN) << PIN_SLPM_PULL_SHIFT)
-
-#define PIN_SLPM_DIR_SHIFT	19
-#define PIN_SLPM_DIR_MASK	(0x3 << PIN_SLPM_DIR_SHIFT)
-#define PIN_SLPM_DIR(x)		\
-	(((x) & PIN_SLPM_DIR_MASK) >> PIN_SLPM_DIR_SHIFT)
-#define PIN_SLPM_DIR_INPUT	((1 + 0) << PIN_SLPM_DIR_SHIFT)
-#define PIN_SLPM_DIR_OUTPUT	((1 + 1) << PIN_SLPM_DIR_SHIFT)
-
-#define PIN_SLPM_VAL_SHIFT	21
-#define PIN_SLPM_VAL_MASK	(0x3 << PIN_SLPM_VAL_SHIFT)
-#define PIN_SLPM_VAL(x)		\
-	(((x) & PIN_SLPM_VAL_MASK) >> PIN_SLPM_VAL_SHIFT)
-#define PIN_SLPM_VAL_LOW	((1 + 0) << PIN_SLPM_VAL_SHIFT)
-#define PIN_SLPM_VAL_HIGH	((1 + 1) << PIN_SLPM_VAL_SHIFT)
-
-/* Shortcuts.  Use these instead of separate DIR, PULL, and VAL.  */
-#define PIN_INPUT_PULLDOWN	(PIN_DIR_INPUT | PIN_PULL_DOWN)
-#define PIN_INPUT_PULLUP	(PIN_DIR_INPUT | PIN_PULL_UP)
-#define PIN_INPUT_NOPULL	(PIN_DIR_INPUT | PIN_PULL_NONE)
-#define PIN_OUTPUT_LOW		(PIN_DIR_OUTPUT | PIN_VAL_LOW)
-#define PIN_OUTPUT_HIGH		(PIN_DIR_OUTPUT | PIN_VAL_HIGH)
-
-#define PIN_SLPM_INPUT_PULLDOWN	(PIN_SLPM_DIR_INPUT | PIN_SLPM_PULL_DOWN)
-#define PIN_SLPM_INPUT_PULLUP	(PIN_SLPM_DIR_INPUT | PIN_SLPM_PULL_UP)
-#define PIN_SLPM_INPUT_NOPULL	(PIN_SLPM_DIR_INPUT | PIN_SLPM_PULL_NONE)
-#define PIN_SLPM_OUTPUT_LOW	(PIN_SLPM_DIR_OUTPUT | PIN_SLPM_VAL_LOW)
-#define PIN_SLPM_OUTPUT_HIGH	(PIN_SLPM_DIR_OUTPUT | PIN_SLPM_VAL_HIGH)
-
-#define PIN_CFG_DEFAULT		(0)
-
-#define PIN_CFG(num, alt)		\
-	(PIN_CFG_DEFAULT |\
-	 (PIN_NUM(num) | PIN_##alt))
-
-#define PIN_CFG_INPUT(num, alt, pull)		\
-	(PIN_CFG_DEFAULT |\
-	 (PIN_NUM(num) | PIN_##alt | PIN_INPUT_##pull))
-
-#define PIN_CFG_OUTPUT(num, alt, val)		\
-	(PIN_CFG_DEFAULT |\
-	 (PIN_NUM(num) | PIN_##alt | PIN_OUTPUT_##val))
-
-extern int nmk_config_pin(pin_cfg_t cfg, bool sleep);
-extern int nmk_config_pins(pin_cfg_t *cfgs, int num);
-extern int nmk_config_pins_sleep(pin_cfg_t *cfgs, int num);
-
-#endif
diff --git a/drivers/gpio/nomadik-gpio.c b/drivers/gpio/nomadik-gpio.c
index b8d5bae..f8c1449 100644
--- a/drivers/gpio/nomadik-gpio.c
+++ b/drivers/gpio/nomadik-gpio.c
@@ -25,7 +25,6 @@
 #include <linux/slab.h>
 #include <linux/gpio/nomadik.h>
 
-#include <plat/pincfg.h>
 #include <mach/hardware.h>
 #include <mach/gpio.h>
 
@@ -39,6 +38,26 @@
 
 #define NMK_GPIO_PER_CHIP	32
 
+/* Register in the logic block */
+#define NMK_GPIO_DAT	0x00
+#define NMK_GPIO_DATS	0x04
+#define NMK_GPIO_DATC	0x08
+#define NMK_GPIO_PDIS	0x0c
+#define NMK_GPIO_DIR	0x10
+#define NMK_GPIO_DIRS	0x14
+#define NMK_GPIO_DIRC	0x18
+#define NMK_GPIO_SLPC	0x1c
+#define NMK_GPIO_AFSLA	0x20
+#define NMK_GPIO_AFSLB	0x24
+
+#define NMK_GPIO_RIMSC	0x40
+#define NMK_GPIO_FIMSC	0x44
+#define NMK_GPIO_IS	0x48
+#define NMK_GPIO_IC	0x4c
+#define NMK_GPIO_RWIMSC	0x50
+#define NMK_GPIO_FWIMSC	0x54
+#define NMK_GPIO_WKS	0x58
+
 struct nmk_gpio_chip {
 	struct gpio_chip chip;
 	void __iomem *addr;
@@ -60,6 +79,7 @@ struct nmk_gpio_chip {
 	u32 pull_up;
 };
 
+/* FIXME: this is insane since it will create chips for the GPIO expanders! */
 static struct nmk_gpio_chip *
 nmk_gpio_chips[DIV_ROUND_UP(ARCH_NR_GPIOS, NMK_GPIO_PER_CHIP)];
 
@@ -76,43 +96,156 @@ static inline struct nmk_gpio_chip *to_nmk_chip(struct gpio_chip *chip)
 }
 
 static void __nmk_gpio_set_mode(struct nmk_gpio_chip *nmk_chip,
-				unsigned offset, int gpio_mode)
+				unsigned offset, u16 altfunc)
 {
 	u32 bit = 1 << offset;
 	u32 afunc, bfunc;
+	bool glitch = (altfunc == GPIO_CONFIG_NMK_ALTF_C);
+	u32 rwimsc = readl(nmk_chip->addr + NMK_GPIO_RWIMSC);
+	u32 fwimsc = readl(nmk_chip->addr + NMK_GPIO_FWIMSC);
+	unsigned long flags = 0;
+	int i;
+
+	/*
+	 * If we're setting altfunc C by setting both AFSLA and AFSLB to 1,
+	 * we may pass through an undesired state. In this case we take
+	 * some extra care.
+	 *
+	 * Safe sequence used to switch IOs between GPIO and Alternate-C mode:
+	 *  - Save SLPM registers (since we have a shadow register in the
+	 *    nmk_chip we're using that as backup)
+	 *  - Set SLPM=0 for the IOs you want to switch and others to 1
+	 *  - Configure the GPIO registers for the IOs that are being switched
+	 *  - Set IOFORCE=1
+	 *  - Modify the AFLSA/B registers for the IOs that are being switched
+	 *  - Set IOFORCE=0
+	 *  - Restore SLPM registers
+	 *  - Any spurious wake up event during switch sequence to be ignored
+	 *    and cleared
+	 *
+	 * TODO: Do we REALLY need to save ALL slpm registers?? Isn't it
+	 * enough to save the one for the port we're modifying, really?
+	 */
+	if (glitch) {
+		u32 bit = BIT(offset);
+
+		/* Take the special sleep mode spinlock */
+		spin_lock_irqsave(&nmk_gpio_slpm_lock, flags);
+		for (i = 0; i < NUM_BANKS; i++) {
+			struct nmk_gpio_chip *chip = nmk_gpio_chips[i];
+
+			if (!chip)
+				break;
+			clk_enable(chip->clk);
+			writel(0xFFFFFFFFU, chip->addr + NMK_GPIO_SLPC);
+		}
+
+		/* Set "my" sleep bit to 0 */
+		writel(0xFFFFFFFFU & ~bit, nmk_chip->addr + NMK_GPIO_SLPC);
+		/* Prevent spurious wakeups */
+		writel(rwimsc & ~bit, nmk_chip->addr + NMK_GPIO_RWIMSC);
+		writel(fwimsc & ~bit, nmk_chip->addr + NMK_GPIO_FWIMSC);
+		if (nmk_chip->set_ioforce)
+			nmk_chip->set_ioforce(true);
+	}
 
+	/* Set desired altfunc */
 	afunc = readl(nmk_chip->addr + NMK_GPIO_AFSLA) & ~bit;
 	bfunc = readl(nmk_chip->addr + NMK_GPIO_AFSLB) & ~bit;
-	if (gpio_mode & NMK_GPIO_ALT_A)
+	if ((altfunc == GPIO_CONFIG_NMK_ALTF_A) ||
+	    (altfunc == GPIO_CONFIG_NMK_ALTF_C))
 		afunc |= bit;
-	if (gpio_mode & NMK_GPIO_ALT_B)
+	if ((altfunc == GPIO_CONFIG_NMK_ALTF_B) ||
+	    (altfunc == GPIO_CONFIG_NMK_ALTF_C))
 		bfunc |= bit;
 	writel(afunc, nmk_chip->addr + NMK_GPIO_AFSLA);
 	writel(bfunc, nmk_chip->addr + NMK_GPIO_AFSLB);
+
+	if (glitch) {
+		if (nmk_chip->set_ioforce)
+			nmk_chip->set_ioforce(false);
+		writel(rwimsc, nmk_chip->addr + NMK_GPIO_RWIMSC);
+		writel(fwimsc, nmk_chip->addr + NMK_GPIO_FWIMSC);
+
+		for (i = 0; i < NUM_BANKS; i++) {
+			struct nmk_gpio_chip *chip = nmk_gpio_chips[i];
+
+			if (!chip)
+				break;
+			writel(chip->slpm, chip->addr + NMK_GPIO_SLPC);
+			clk_disable(chip->clk);
+		}
+		spin_unlock_irqrestore(&nmk_gpio_slpm_lock, flags);
+	}
+}
+
+static int __nmk_gpio_get_mode(struct nmk_gpio_chip *nmk_chip,
+			       unsigned offset, u16 *data)
+{
+	u32 afunc, bfunc, bit;
+
+	bit = 1 << offset;
+
+	afunc = readl(nmk_chip->addr + NMK_GPIO_AFSLA) & bit;
+	bfunc = readl(nmk_chip->addr + NMK_GPIO_AFSLB) & bit;
+
+	if (afunc && bfunc)
+		*data = GPIO_CONFIG_NMK_ALTF_C;
+	else if (afunc)
+		*data = GPIO_CONFIG_NMK_ALTF_A;
+	else if (bfunc)
+		*data = GPIO_CONFIG_NMK_ALTF_B;
+	else
+		*data = GPIO_CONFIG_NMK_ALTF_GPIO;
+	return 0;
 }
 
+/**
+ * __nmk_gpio_set_slpm() - configure the sleep mode of a pin
+ * @offset: pin number
+ * @enable: enable wakeup on the pin on DB8500v2, or force the pin to retain
+ * its value in sleep mode (not become an input) on DB8500v1 if true
+ *
+ * Sets the sleep mode of a pin. On DB8500v1, if @enable is
+ * true, the pin is NOT changed to an input (with pullup/down enabled) in
+ * sleep and deep sleep. If @enable is false, the pin remains in the state
+ * it was configured even when in sleep and deep sleep.
+ *
+ * On DB8500v2 onwards, this setting loses the previous meaning and instead
+ * indicates if wakeup detection is enabled on the pin. Note that
+ * enable_irq_wake() will automatically enable wakeup detection.
+ */
 static void __nmk_gpio_set_slpm(struct nmk_gpio_chip *nmk_chip,
-				unsigned offset, enum nmk_gpio_slpm mode)
+				unsigned offset, bool enable)
 {
 	u32 bit = 1 << offset;
-	u32 slpm;
 
-	slpm = readl(nmk_chip->addr + NMK_GPIO_SLPC);
-	if (mode == NMK_GPIO_SLPM_NOCHANGE)
-		slpm |= bit;
+	/*
+	 * NOTE: the meaning of "enable" is inverted, nominally every GPIO
+	 * will wake up the system (or convert the pin to an input on DB8500v1)
+	 */
+	if (enable)
+		nmk_chip->slpm &= ~bit;
 	else
-		slpm &= ~bit;
-	writel(slpm, nmk_chip->addr + NMK_GPIO_SLPC);
+		/*
+		 * So setting this bit disables wakeups (or makes the pin
+		 * retain its value on DB8500v1)
+		 */
+		nmk_chip->slpm |= bit;
+
+	writel(nmk_chip->slpm, nmk_chip->addr + NMK_GPIO_SLPC);
 }
 
 static void __nmk_gpio_set_pull(struct nmk_gpio_chip *nmk_chip,
-				unsigned offset, enum nmk_gpio_pull pull)
+				unsigned offset, u16 pullmode)
 {
 	u32 bit = 1 << offset;
 	u32 pdis;
 
+	/* FIXME: use shadow registers instead of read-modify-write */
 	pdis = readl(nmk_chip->addr + NMK_GPIO_PDIS);
-	if (pull == NMK_GPIO_PULL_NONE) {
+	if ((pullmode == GPIO_CONFIG_BIAS_UNKNOWN) ||
+	    (pullmode == GPIO_CONFIG_BIAS_FLOAT)) {
 		pdis |= bit;
 		nmk_chip->pull_up &= ~bit;
 	} else {
@@ -121,10 +254,10 @@ static void __nmk_gpio_set_pull(struct nmk_gpio_chip *nmk_chip,
 
 	writel(pdis, nmk_chip->addr + NMK_GPIO_PDIS);
 
-	if (pull == NMK_GPIO_PULL_UP) {
+	if (pullmode == GPIO_CONFIG_BIAS_PULL_UP) {
 		nmk_chip->pull_up |= bit;
 		writel(bit, nmk_chip->addr + NMK_GPIO_DATS);
-	} else if (pull == NMK_GPIO_PULL_DOWN) {
+	} else if (pullmode == GPIO_CONFIG_BIAS_PULL_DOWN) {
 		nmk_chip->pull_up &= ~bit;
 		writel(bit, nmk_chip->addr + NMK_GPIO_DATC);
 	}
@@ -152,381 +285,169 @@ static void __nmk_gpio_make_output(struct nmk_gpio_chip *nmk_chip,
 	__nmk_gpio_set_output(nmk_chip, offset, val);
 }
 
-static void __nmk_gpio_set_mode_safe(struct nmk_gpio_chip *nmk_chip,
-				     unsigned offset, int gpio_mode,
-				     bool glitch)
-{
-	u32 rwimsc = readl(nmk_chip->addr + NMK_GPIO_RWIMSC);
-	u32 fwimsc = readl(nmk_chip->addr + NMK_GPIO_FWIMSC);
-
-	if (glitch && nmk_chip->set_ioforce) {
-		u32 bit = BIT(offset);
-
-		/* Prevent spurious wakeups */
-		writel(rwimsc & ~bit, nmk_chip->addr + NMK_GPIO_RWIMSC);
-		writel(fwimsc & ~bit, nmk_chip->addr + NMK_GPIO_FWIMSC);
-
-		nmk_chip->set_ioforce(true);
-	}
-
-	__nmk_gpio_set_mode(nmk_chip, offset, gpio_mode);
-
-	if (glitch && nmk_chip->set_ioforce) {
-		nmk_chip->set_ioforce(false);
-
-		writel(rwimsc, nmk_chip->addr + NMK_GPIO_RWIMSC);
-		writel(fwimsc, nmk_chip->addr + NMK_GPIO_FWIMSC);
-	}
-}
 
-static void __nmk_config_pin(struct nmk_gpio_chip *nmk_chip, unsigned offset,
-			     pin_cfg_t cfg, bool sleep, unsigned int *slpmregs)
+static void __nmk_setup_pin(struct nmk_gpio_chip *nmk_chip, unsigned offset,
+			    struct nmk_gpio_pin_config *cfg)
 {
 	static const char *afnames[] = {
-		[NMK_GPIO_ALT_GPIO]	= "GPIO",
-		[NMK_GPIO_ALT_A]	= "A",
-		[NMK_GPIO_ALT_B]	= "B",
-		[NMK_GPIO_ALT_C]	= "C"
-	};
-	static const char *pullnames[] = {
-		[NMK_GPIO_PULL_NONE]	= "none",
-		[NMK_GPIO_PULL_UP]	= "up",
-		[NMK_GPIO_PULL_DOWN]	= "down",
-		[3] /* illegal */	= "??"
+		[GPIO_CONFIG_NMK_ALTF_GPIO]	= "GPIO",
+		[GPIO_CONFIG_NMK_ALTF_A]	= "A",
+		[GPIO_CONFIG_NMK_ALTF_B]	= "B",
+		[GPIO_CONFIG_NMK_ALTF_C]	= "C"
 	};
-	static const char *slpmnames[] = {
-		[NMK_GPIO_SLPM_INPUT]		= "input/wakeup",
-		[NMK_GPIO_SLPM_NOCHANGE]	= "no-change/no-wakeup",
+	static const char *biasnames[] = {
+		[GPIO_CONFIG_BIAS_UNKNOWN]	= "none",
+		[GPIO_CONFIG_BIAS_FLOAT]	= "none",
+		[GPIO_CONFIG_BIAS_PULL_UP]	= "up",
+		[GPIO_CONFIG_BIAS_PULL_DOWN]	= "down",
 	};
 
-	int pin = PIN_NUM(cfg);
-	int pull = PIN_PULL(cfg);
-	int af = PIN_ALT(cfg);
-	int slpm = PIN_SLPM(cfg);
-	int output = PIN_DIR(cfg);
-	int val = PIN_VAL(cfg);
-	bool glitch = af == NMK_GPIO_ALT_C;
-
-	dev_dbg(nmk_chip->chip.dev, "pin %d [%#lx]: af %s, pull %s, slpm %s (%s%s)\n",
-		pin, cfg, afnames[af], pullnames[pull], slpmnames[slpm],
-		output ? "output " : "input",
-		output ? (val ? "high" : "low") : "");
-
-	if (sleep) {
-		int slpm_pull = PIN_SLPM_PULL(cfg);
-		int slpm_output = PIN_SLPM_DIR(cfg);
-		int slpm_val = PIN_SLPM_VAL(cfg);
-
-		af = NMK_GPIO_ALT_GPIO;
-
-		/*
-		 * The SLPM_* values are normal values + 1 to allow zero to
-		 * mean "same as normal".
-		 */
-		if (slpm_pull)
-			pull = slpm_pull - 1;
-		if (slpm_output)
-			output = slpm_output - 1;
-		if (slpm_val)
-			val = slpm_val - 1;
-
-		dev_dbg(nmk_chip->chip.dev, "pin %d: sleep pull %s, dir %s, val %s\n",
-			pin,
-			slpm_pull ? pullnames[pull] : "same",
-			slpm_output ? (output ? "output" : "input") : "same",
-			slpm_val ? (val ? "high" : "low") : "same");
-	}
+	dev_dbg(nmk_chip->chip.dev, "pin %d: af: %s, bias: %s, "
+		"slpm: %s (%s%s)\n",
+		cfg->pin, afnames[cfg->altfunc],
+		biasnames[cfg->bias_mode],
+		cfg->sleep_mode ? "input/wakeup" : "no-change/no-wakeup",
+		cfg->output ? "output " : "input",
+		cfg->output ? (cfg->outval ? "high" : "low") : "");
 
-	if (output)
-		__nmk_gpio_make_output(nmk_chip, offset, val);
+	if (cfg->output)
+		__nmk_gpio_make_output(nmk_chip, offset, cfg->outval);
 	else {
 		__nmk_gpio_make_input(nmk_chip, offset);
-		__nmk_gpio_set_pull(nmk_chip, offset, pull);
+		__nmk_gpio_set_pull(nmk_chip, offset, cfg->bias_mode);
 	}
-
-	/*
-	 * If we've backed up the SLPM registers (glitch workaround), modify
-	 * the backups since they will be restored.
-	 */
-	if (slpmregs) {
-		if (slpm == NMK_GPIO_SLPM_NOCHANGE)
-			slpmregs[nmk_chip->bank] |= BIT(offset);
-		else
-			slpmregs[nmk_chip->bank] &= ~BIT(offset);
-	} else
-		__nmk_gpio_set_slpm(nmk_chip, offset, slpm);
-
-	__nmk_gpio_set_mode_safe(nmk_chip, offset, af, glitch);
+	__nmk_gpio_set_slpm(nmk_chip, offset, cfg->sleep_mode);
+	__nmk_gpio_set_mode(nmk_chip, offset, cfg->altfunc);
 }
 
-/*
- * Safe sequence used to switch IOs between GPIO and Alternate-C mode:
- *  - Save SLPM registers
- *  - Set SLPM=0 for the IOs you want to switch and others to 1
- *  - Configure the GPIO registers for the IOs that are being switched
- *  - Set IOFORCE=1
- *  - Modify the AFLSA/B registers for the IOs that are being switched
- *  - Set IOFORCE=0
- *  - Restore SLPM registers
- *  - Any spurious wake up event during switch sequence to be ignored and
- *    cleared
+/**
+ * This translates the old pin config parameter type into a config
+ * struct and passes to the new API
  */
-static void nmk_gpio_glitch_slpm_init(unsigned int *slpm)
-{
-	int i;
-
-	for (i = 0; i < NUM_BANKS; i++) {
-		struct nmk_gpio_chip *chip = nmk_gpio_chips[i];
-		unsigned int temp = slpm[i];
-
-		if (!chip)
-			break;
-
-		clk_enable(chip->clk);
-
-		slpm[i] = readl(chip->addr + NMK_GPIO_SLPC);
-		writel(temp, chip->addr + NMK_GPIO_SLPC);
-	}
-}
-
-static void nmk_gpio_glitch_slpm_restore(unsigned int *slpm)
-{
-	int i;
-
-	for (i = 0; i < NUM_BANKS; i++) {
-		struct nmk_gpio_chip *chip = nmk_gpio_chips[i];
-
-		if (!chip)
-			break;
-
-		writel(slpm[i], chip->addr + NMK_GPIO_SLPC);
-
-		clk_disable(chip->clk);
-	}
-}
-
-static int __nmk_config_pins(pin_cfg_t *cfgs, int num, bool sleep)
+static void __nmk_setup_pin_legacy(struct nmk_gpio_chip *nmk_chip,
+				   unsigned offset,
+				   pin_cfg_t pincfg)
 {
-	static unsigned int slpm[NUM_BANKS];
-	unsigned long flags;
-	bool glitch = false;
-	int ret = 0;
-	int i;
-
-	for (i = 0; i < num; i++) {
-		if (PIN_ALT(cfgs[i]) == NMK_GPIO_ALT_C) {
-			glitch = true;
-			break;
-		}
+	struct nmk_gpio_pin_config cfg;
+
+	cfg.pin = PIN_NUM(pincfg);
+
+	switch (PIN_ALT(pincfg)) {
+	case NMK_GPIO_ALT_GPIO:
+		cfg.altfunc = GPIO_CONFIG_NMK_ALTF_GPIO;
+		break;
+	case NMK_GPIO_ALT_A:
+		cfg.altfunc = GPIO_CONFIG_NMK_ALTF_A;
+		break;
+	case NMK_GPIO_ALT_B:
+		cfg.altfunc = GPIO_CONFIG_NMK_ALTF_B;
+		break;
+	case NMK_GPIO_ALT_C:
+		cfg.altfunc = GPIO_CONFIG_NMK_ALTF_C;
+		break;
+	default:
+		cfg.altfunc = GPIO_CONFIG_NMK_ALTF_GPIO;
+		break;
 	}
 
-	spin_lock_irqsave(&nmk_gpio_slpm_lock, flags);
-
-	if (glitch) {
-		memset(slpm, 0xff, sizeof(slpm));
-
-		for (i = 0; i < num; i++) {
-			int pin = PIN_NUM(cfgs[i]);
-			int offset = pin % NMK_GPIO_PER_CHIP;
-
-			if (PIN_ALT(cfgs[i]) == NMK_GPIO_ALT_C)
-				slpm[pin / NMK_GPIO_PER_CHIP] &= ~BIT(offset);
-		}
-
-		nmk_gpio_glitch_slpm_init(slpm);
+	if (PIN_DIR(pincfg))
+		cfg.output = true;
+
+	if (PIN_VAL(pincfg))
+		cfg.outval = 1;
+
+	switch (PIN_PULL(pincfg)) {
+	case NMK_GPIO_PULL_NONE:
+		cfg.bias_mode = GPIO_CONFIG_BIAS_FLOAT;
+		break;
+	case NMK_GPIO_PULL_UP:
+		cfg.bias_mode = GPIO_CONFIG_BIAS_PULL_UP;
+		break;
+	case NMK_GPIO_PULL_DOWN:
+		cfg.bias_mode = GPIO_CONFIG_BIAS_PULL_DOWN;
+		break;
+	default:
+		cfg.bias_mode = GPIO_CONFIG_BIAS_FLOAT;
+		break;
 	}
 
-	for (i = 0; i < num; i++) {
-		struct nmk_gpio_chip *nmk_chip;
-		int pin = PIN_NUM(cfgs[i]);
-
-		nmk_chip = irq_get_chip_data(NOMADIK_GPIO_TO_IRQ(pin));
-		if (!nmk_chip) {
-			ret = -EINVAL;
-			break;
-		}
-
-		clk_enable(nmk_chip->clk);
-		spin_lock(&nmk_chip->lock);
-		__nmk_config_pin(nmk_chip, pin - nmk_chip->chip.base,
-				 cfgs[i], sleep, glitch ? slpm : NULL);
-		spin_unlock(&nmk_chip->lock);
-		clk_disable(nmk_chip->clk);
+	switch (PIN_SLPM(pincfg)) {
+	case NMK_GPIO_SLPM_WAKEUP_ENABLE:
+		/* Also NMK_GPIO_SLPM_INPUT */
+		break;
+	case NMK_GPIO_SLPM_WAKEUP_DISABLE:
+		/* Also NMK_GPIO_SLPM_NOCHANGE */
+		cfg.sleep_mode = true;
+	default:
+		break;
 	}
 
-	if (glitch)
-		nmk_gpio_glitch_slpm_restore(slpm);
-
-	spin_unlock_irqrestore(&nmk_gpio_slpm_lock, flags);
-
-	return ret;
-}
-
-/**
- * nmk_config_pin - configure a pin's mux attributes
- * @cfg: pin confguration
- *
- * Configures a pin's mode (alternate function or GPIO), its pull up status,
- * and its sleep mode based on the specified configuration.  The @cfg is
- * usually one of the SoC specific macros defined in mach/<soc>-pins.h.  These
- * are constructed using, and can be further enhanced with, the macros in
- * plat/pincfg.h.
- *
- * If a pin's mode is set to GPIO, it is configured as an input to avoid
- * side-effects.  The gpio can be manipulated later using standard GPIO API
- * calls.
- */
-int nmk_config_pin(pin_cfg_t cfg, bool sleep)
-{
-	return __nmk_config_pins(&cfg, 1, sleep);
-}
-EXPORT_SYMBOL(nmk_config_pin);
-
-/**
- * nmk_config_pins - configure several pins at once
- * @cfgs: array of pin configurations
- * @num: number of elments in the array
- *
- * Configures several pins using nmk_config_pin().  Refer to that function for
- * further information.
- */
-int nmk_config_pins(pin_cfg_t *cfgs, int num)
-{
-	return __nmk_config_pins(cfgs, num, false);
-}
-EXPORT_SYMBOL(nmk_config_pins);
-
-int nmk_config_pins_sleep(pin_cfg_t *cfgs, int num)
-{
-	return __nmk_config_pins(cfgs, num, true);
-}
-EXPORT_SYMBOL(nmk_config_pins_sleep);
-
-/**
- * nmk_gpio_set_slpm() - configure the sleep mode of a pin
- * @gpio: pin number
- * @mode: NMK_GPIO_SLPM_INPUT or NMK_GPIO_SLPM_NOCHANGE,
- *
- * Sets the sleep mode of a pin.  If @mode is NMK_GPIO_SLPM_INPUT, the pin is
- * changed to an input (with pullup/down enabled) in sleep and deep sleep.  If
- * @mode is NMK_GPIO_SLPM_NOCHANGE, the pin remains in the state it was
- * configured even when in sleep and deep sleep.
- *
- * On DB8500v2 onwards, this setting loses the previous meaning and instead
- * indicates if wakeup detection is enabled on the pin.  Note that
- * enable_irq_wake() will automatically enable wakeup detection.
- */
-int nmk_gpio_set_slpm(int gpio, enum nmk_gpio_slpm mode)
-{
-	struct nmk_gpio_chip *nmk_chip;
-	unsigned long flags;
-
-	nmk_chip = irq_get_chip_data(NOMADIK_GPIO_TO_IRQ(gpio));
-	if (!nmk_chip)
-		return -EINVAL;
-
-	clk_enable(nmk_chip->clk);
-	spin_lock_irqsave(&nmk_gpio_slpm_lock, flags);
-	spin_lock(&nmk_chip->lock);
-
-	__nmk_gpio_set_slpm(nmk_chip, gpio - nmk_chip->chip.base, mode);
-
-	spin_unlock(&nmk_chip->lock);
-	spin_unlock_irqrestore(&nmk_gpio_slpm_lock, flags);
-	clk_disable(nmk_chip->clk);
-
-	return 0;
+	__nmk_setup_pin(nmk_chip, offset, &cfg);
 }
 
-/**
- * nmk_gpio_set_pull() - enable/disable pull up/down on a gpio
- * @gpio: pin number
- * @pull: one of NMK_GPIO_PULL_DOWN, NMK_GPIO_PULL_UP, and NMK_GPIO_PULL_NONE
- *
- * Enables/disables pull up/down on a specified pin.  This only takes effect if
- * the pin is configured as an input (either explicitly or by the alternate
- * function).
- *
- * NOTE: If enabling the pull up/down, the caller must ensure that the GPIO is
- * configured as an input.  Otherwise, due to the way the controller registers
- * work, this function will change the value output on the pin.
- */
-int nmk_gpio_set_pull(int gpio, enum nmk_gpio_pull pull)
+static int nmk_gpio_config(struct gpio_chip *chip, unsigned offset,
+			   u16 param, unsigned long *data)
 {
-	struct nmk_gpio_chip *nmk_chip;
+	struct nmk_gpio_chip *nmk_chip = to_nmk_chip(chip);
 	unsigned long flags;
 
-	nmk_chip = irq_get_chip_data(NOMADIK_GPIO_TO_IRQ(gpio));
 	if (!nmk_chip)
 		return -EINVAL;
 
 	clk_enable(nmk_chip->clk);
-	spin_lock_irqsave(&nmk_chip->lock, flags);
-	__nmk_gpio_set_pull(nmk_chip, gpio - nmk_chip->chip.base, pull);
-	spin_unlock_irqrestore(&nmk_chip->lock, flags);
-	clk_disable(nmk_chip->clk);
-
-	return 0;
-}
-
-/* Mode functions */
-/**
- * nmk_gpio_set_mode() - set the mux mode of a gpio pin
- * @gpio: pin number
- * @gpio_mode: one of NMK_GPIO_ALT_GPIO, NMK_GPIO_ALT_A,
- *	       NMK_GPIO_ALT_B, and NMK_GPIO_ALT_C
- *
- * Sets the mode of the specified pin to one of the alternate functions or
- * plain GPIO.
- */
-int nmk_gpio_set_mode(int gpio, int gpio_mode)
-{
-	struct nmk_gpio_chip *nmk_chip;
-	unsigned long flags;
 
-	nmk_chip = irq_get_chip_data(NOMADIK_GPIO_TO_IRQ(gpio));
-	if (!nmk_chip)
+	switch (param) {
+	case GPIO_CONFIG_BIAS_UNKNOWN:
+	case GPIO_CONFIG_BIAS_FLOAT:
+	case GPIO_CONFIG_BIAS_PULL_UP:
+	case GPIO_CONFIG_BIAS_PULL_DOWN:
+		__nmk_gpio_set_pull(nmk_chip, offset, param);
+		break;
+	case GPIO_CONFIG_NMK_ALTF_GPIO:
+	case GPIO_CONFIG_NMK_ALTF_A:
+	case GPIO_CONFIG_NMK_ALTF_B:
+	case GPIO_CONFIG_NMK_ALTF_C:
+		__nmk_gpio_set_mode(nmk_chip, offset, param);
+		break;
+	case GPIO_CONFIG_NMK_GET_ALTF:
+		__nmk_gpio_get_mode(nmk_chip, offset, (u16 *) data);
+		break;
+	case GPIO_CONFIG_NMK_SLPM_INPUT:
+	case GPIO_CONFIG_NMK_WAKEUP_ENABLE:
+		spin_lock_irqsave(&nmk_gpio_slpm_lock, flags);
+		spin_lock(&nmk_chip->lock);
+		__nmk_gpio_set_slpm(nmk_chip, offset, true);
+		spin_unlock(&nmk_chip->lock);
+		spin_unlock_irqrestore(&nmk_gpio_slpm_lock, flags);
+		break;
+	case GPIO_CONFIG_NMK_SLPM_NOCHANGE:
+	case GPIO_CONFIG_NMK_WAKEUP_DISABLE:
+		spin_lock_irqsave(&nmk_gpio_slpm_lock, flags);
+		spin_lock(&nmk_chip->lock);
+		__nmk_gpio_set_slpm(nmk_chip, offset, false);
+		spin_unlock(&nmk_chip->lock);
+		spin_unlock_irqrestore(&nmk_gpio_slpm_lock, flags);
+		break;
+	case GPIO_CONFIG_NMK_SETUP_PIN:
+		__nmk_setup_pin(nmk_chip, offset,
+				(struct nmk_gpio_pin_config *) data);
+		break;
+	case GPIO_CONFIG_NMK_SETUP_PIN_LEGACY:
+		__nmk_setup_pin_legacy(nmk_chip, offset, (pin_cfg_t) *data);
+		break;
+	default:
+		dev_err(nmk_chip->chip.dev,
+			"illegal configuration requested\n");
+		clk_disable(nmk_chip->clk);
 		return -EINVAL;
+	};
 
-	clk_enable(nmk_chip->clk);
-	spin_lock_irqsave(&nmk_chip->lock, flags);
-	__nmk_gpio_set_mode(nmk_chip, gpio - nmk_chip->chip.base, gpio_mode);
-	spin_unlock_irqrestore(&nmk_chip->lock, flags);
 	clk_disable(nmk_chip->clk);
 
 	return 0;
 }
-EXPORT_SYMBOL(nmk_gpio_set_mode);
-
-int nmk_gpio_get_mode(int gpio)
-{
-	struct nmk_gpio_chip *nmk_chip;
-	u32 afunc, bfunc, bit;
-
-	nmk_chip = irq_get_chip_data(NOMADIK_GPIO_TO_IRQ(gpio));
-	if (!nmk_chip)
-		return -EINVAL;
-
-	bit = 1 << (gpio - nmk_chip->chip.base);
-
-	clk_enable(nmk_chip->clk);
-
-	afunc = readl(nmk_chip->addr + NMK_GPIO_AFSLA) & bit;
-	bfunc = readl(nmk_chip->addr + NMK_GPIO_AFSLB) & bit;
-
-	clk_disable(nmk_chip->clk);
-
-	return (afunc ? NMK_GPIO_ALT_A : 0) | (bfunc ? NMK_GPIO_ALT_B : 0);
-}
-EXPORT_SYMBOL(nmk_gpio_get_mode);
 
-static int nmk_gpio_config(struct gpio_chip *chip, unsigned offset,
-			   u16 param, unsigned long *data)
-{
-	struct nmk_gpio_chip *nmk_chip = to_nmk_chip(chip);
 
-	return 0;
-}
 
 /* IRQ functions */
 static inline int nmk_gpio_get_bitmask(int gpio)
@@ -585,11 +506,8 @@ static void __nmk_gpio_irq_modify(struct nmk_gpio_chip *nmk_chip,
 static void __nmk_gpio_set_wake(struct nmk_gpio_chip *nmk_chip,
 				int gpio, bool on)
 {
-	if (nmk_chip->sleepmode) {
-		__nmk_gpio_set_slpm(nmk_chip, gpio - nmk_chip->chip.base,
-				    on ? NMK_GPIO_SLPM_WAKEUP_ENABLE
-				    : NMK_GPIO_SLPM_WAKEUP_DISABLE);
-	}
+	if (nmk_chip->sleepmode)
+		__nmk_gpio_set_slpm(nmk_chip, gpio - nmk_chip->chip.base, on);
 
 	__nmk_gpio_irq_modify(nmk_chip, gpio, WAKE, on);
 }
@@ -650,6 +568,7 @@ static int nmk_gpio_irq_set_wake(struct irq_data *d, unsigned int on)
 	spin_lock_irqsave(&nmk_gpio_slpm_lock, flags);
 	spin_lock(&nmk_chip->lock);
 
+	/* Make sure we wake up on this pin */
 	if (irqd_irq_disabled(d))
 		__nmk_gpio_set_wake(nmk_chip, gpio, on);
 
@@ -884,35 +803,47 @@ static int nmk_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
 
 static void nmk_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 {
-	int mode;
+	u16 mode;
 	unsigned		i;
 	unsigned		gpio = chip->base;
 	int			is_out;
 	struct nmk_gpio_chip *nmk_chip = to_nmk_chip(chip);
-	const char *modes[] = {
-		[NMK_GPIO_ALT_GPIO]	= "gpio",
-		[NMK_GPIO_ALT_A]	= "altA",
-		[NMK_GPIO_ALT_B]	= "altB",
-		[NMK_GPIO_ALT_C]	= "altC",
-	};
 
 	clk_enable(nmk_chip->clk);
 
 	for (i = 0; i < chip->ngpio; i++, gpio++) {
 		const char *label = gpiochip_is_requested(chip, i);
+		const char *modetxt;
 		bool pull;
 		u32 bit = 1 << i;
 
 		is_out = readl(nmk_chip->addr + NMK_GPIO_DIR) & bit;
 		pull = !(readl(nmk_chip->addr + NMK_GPIO_PDIS) & bit);
-		mode = nmk_gpio_get_mode(gpio);
+		__nmk_gpio_get_mode(nmk_chip, gpio, &mode);
+		switch (mode) {
+		case GPIO_CONFIG_NMK_ALTF_GPIO:
+			modetxt = "gpio";
+			break;
+		case GPIO_CONFIG_NMK_ALTF_A:
+			modetxt = "altA";
+			break;
+		case GPIO_CONFIG_NMK_ALTF_B:
+			modetxt = "altB";
+			break;
+		case GPIO_CONFIG_NMK_ALTF_C:
+			modetxt = "altC";
+			break;
+		default:
+			modetxt = "unknown";
+			break;
+		}
 		seq_printf(s, " gpio-%-3d (%-20.20s) %s %s %s %s",
 			gpio, label ?: "(none)",
 			is_out ? "out" : "in ",
 			chip->get
 				? (chip->get(chip, i) ? "hi" : "lo")
 				: "?  ",
-			(mode < 0) ? "unknown" : modes[mode],
+			(mode < 0) ? "unknown" : modetxt,
 			pull ? "pull" : "none");
 
 		if (label && !is_out) {
@@ -951,7 +882,7 @@ static void nmk_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 #endif
 
 /* This structure is replicated for each GPIO block allocated at probe time */
-static struct gpio_chip nmk_gpio_template = {
+static struct gpio_chip nmk_gpio_chip = {
 	.direction_input	= nmk_gpio_make_input,
 	.get			= nmk_gpio_get_input,
 	.direction_output	= nmk_gpio_make_output,
@@ -962,6 +893,9 @@ static struct gpio_chip nmk_gpio_template = {
 	.can_sleep		= 0,
 };
 
+/**
+ * nmk_gpio_clocks_enable() - enable the clocks on all GPIO blocks
+ */
 void nmk_gpio_clocks_enable(void)
 {
 	int i;
@@ -976,6 +910,9 @@ void nmk_gpio_clocks_enable(void)
 	}
 }
 
+/**
+ * nmk_gpio_clocks_disable() - disable the clocks on all GPIO blocks
+ */
 void nmk_gpio_clocks_disable(void)
 {
 	int i;
@@ -1127,7 +1064,7 @@ static int __devinit nmk_gpio_probe(struct platform_device *dev)
 	nmk_chip->bank = dev->id;
 	nmk_chip->clk = clk;
 	nmk_chip->addr = io_p2v(res->start);
-	nmk_chip->chip = nmk_gpio_template;
+	nmk_chip->chip = nmk_gpio_chip;
 	nmk_chip->parent_irq = irq;
 	nmk_chip->secondary_parent_irq = secondary_irq;
 	nmk_chip->get_secondary_status = pdata->get_secondary_status;
diff --git a/include/linux/gpio/nomadik.h b/include/linux/gpio/nomadik.h
index c16ee56..c780681 100644
--- a/include/linux/gpio/nomadik.h
+++ b/include/linux/gpio/nomadik.h
@@ -4,6 +4,13 @@
  * Copyright (C) 2008 STMicroelectronics
  *     Author: Prafulla WADASKAR <prafulla.wadaskar@st.com>
  * Copyright (C) 2009 Alessandro Rubini <rubini@unipv.it>
+ * Copyright (C) 2011 ST-Ericsson SA
+ *  Author: Rabin Vincent <rabin.vincent@stericsson.com> for ST-Ericsson
+ *  Authot: Linus Walleij <linus.wallej@linaro.org>
+ *
+ * Pin config API based on arch/arm/mach-pxa/include/mach/mfp.h:
+ *   Copyright (C) 2007 Marvell International Ltd.
+ *   eric miao <eric.miao@marvell.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -13,31 +20,90 @@
 #define __GPIO_NOMADIK_H
 
 #include <linux/gpio.h>
+#include <asm-generic/gpio.h>
 
 /*
- * "nmk_gpio" and "NMK_GPIO" stand for "Nomadik GPIO", leaving
- * the "gpio" namespace for generic and cross-machine functions
+ * Custom pin configuration options
  */
+#define GPIO_CONFIG_NMK_ALTF_GPIO	(GPIO_CONFIG_CUSTOM_BASE+0)
+#define GPIO_CONFIG_NMK_ALTF_A		(GPIO_CONFIG_CUSTOM_BASE+1)
+#define GPIO_CONFIG_NMK_ALTF_B		(GPIO_CONFIG_CUSTOM_BASE+2)
+#define GPIO_CONFIG_NMK_ALTF_C		(GPIO_CONFIG_CUSTOM_BASE+3)
+#define GPIO_CONFIG_NMK_GET_ALTF	(GPIO_CONFIG_CUSTOM_BASE+4)
+#define GPIO_CONFIG_NMK_SLPM_INPUT	(GPIO_CONFIG_CUSTOM_BASE+5)
+#define GPIO_CONFIG_NMK_WAKEUP_ENABLE	(GPIO_CONFIG_CUSTOM_BASE+6)
+#define GPIO_CONFIG_NMK_SLPM_NOCHANGE	(GPIO_CONFIG_CUSTOM_BASE+7)
+#define GPIO_CONFIG_NMK_WAKEUP_DISABLE	(GPIO_CONFIG_CUSTOM_BASE+8)
+#define GPIO_CONFIG_NMK_SETUP_PIN	(GPIO_CONFIG_CUSTOM_BASE+9)
+#define GPIO_CONFIG_NMK_SETUP_PIN_LEGACY (GPIO_CONFIG_CUSTOM_BASE+10)
 
-/* Register in the logic block */
-#define NMK_GPIO_DAT	0x00
-#define NMK_GPIO_DATS	0x04
-#define NMK_GPIO_DATC	0x08
-#define NMK_GPIO_PDIS	0x0c
-#define NMK_GPIO_DIR	0x10
-#define NMK_GPIO_DIRS	0x14
-#define NMK_GPIO_DIRC	0x18
-#define NMK_GPIO_SLPC	0x1c
-#define NMK_GPIO_AFSLA	0x20
-#define NMK_GPIO_AFSLB	0x24
-
-#define NMK_GPIO_RIMSC	0x40
-#define NMK_GPIO_FIMSC	0x44
-#define NMK_GPIO_IS	0x48
-#define NMK_GPIO_IC	0x4c
-#define NMK_GPIO_RWIMSC	0x50
-#define NMK_GPIO_FWIMSC	0x54
-#define NMK_GPIO_WKS	0x58
+/*
+ * Platform data to register a block: only the initial gpio/irq number.
+ */
+struct nmk_gpio_platform_data {
+	char *name;
+	int first_gpio;
+	int first_irq;
+	int num_gpio;
+	u32 (*get_secondary_status)(unsigned int bank);
+	void (*set_ioforce)(bool enable);
+	bool supports_sleepmode;
+};
+
+/**
+ * nmk_gpio_pin_config - configuration data for a single GPIO pin
+ * @altfunc: the alternate function setting for the pin
+ * @bias_mode: pull up/down/none (float) bias setting for the pin
+ * @output: if this pin is to be configured for output or not
+ * @outval: if configured for output, the default output value (0 or 1)
+ * @sleep_mode: if true, this pin will wake up the system in sleep mode
+ *	(DB8500v2) or force the pin to retain its value and not become an
+ *	input (as is the default on DB8500v1, pull up/down is retained)
+ */
+struct nmk_gpio_pin_config {
+	int pin;
+	u16 altfunc;
+	u16 bias_mode;
+	bool output;
+	int outval;
+	bool sleep_mode;
+};
+
+/* A horde of exported functions */
+extern void nmk_gpio_wakeups_suspend(void);
+extern void nmk_gpio_wakeups_resume(void);
+extern void nmk_gpio_clocks_enable(void);
+extern void nmk_gpio_clocks_disable(void);
+extern void nmk_gpio_read_pull(int gpio_bank, u32 *pull_up);
+
+/*
+ * pin configurations are represented by 32-bit integers:
+ *
+ *	bit  0.. 8 - Pin Number (512 Pins Maximum)
+ *	bit  9..10 - Alternate Function Selection
+ *	bit 11..12 - Pull up/down state
+ *	bit     13 - Sleep mode behaviour
+ *	bit     14 - Direction
+ *	bit     15 - Value (if output)
+ *	bit 16..18 - SLPM pull up/down state
+ *	bit 19..20 - SLPM direction
+ *	bit 21..22 - SLPM Value (if output)
+ *
+ * to facilitate the definition, the following macros are provided
+ *
+ * PIN_CFG_DEFAULT - default config (0):
+ *		     pull up/down = disabled
+ *		     sleep mode = input/wakeup
+ *		     direction = input
+ *		     value = low
+ *		     SLPM direction = same as normal
+ *		     SLPM pull = same as normal
+ *		     SLPM value = same as normal
+ *
+ * PIN_CFG	   - default config with alternate function
+ */
+
+typedef unsigned long pin_cfg_t;
 
 /* Alternate functions: function C is set in hw by setting both A and B */
 #define NMK_GPIO_ALT_GPIO	0
@@ -60,30 +126,166 @@ enum nmk_gpio_slpm {
 	NMK_GPIO_SLPM_WAKEUP_DISABLE = NMK_GPIO_SLPM_NOCHANGE,
 };
 
-extern int nmk_gpio_set_slpm(int gpio, enum nmk_gpio_slpm mode);
-extern int nmk_gpio_set_pull(int gpio, enum nmk_gpio_pull pull);
-extern int nmk_gpio_set_mode(int gpio, int gpio_mode);
-extern int nmk_gpio_get_mode(int gpio);
+#define PIN_NUM_MASK		0x1ff
+#define PIN_NUM(x)		((x) & PIN_NUM_MASK)
 
-extern void nmk_gpio_wakeups_suspend(void);
-extern void nmk_gpio_wakeups_resume(void);
+#define PIN_ALT_SHIFT		9
+#define PIN_ALT_MASK		(0x3 << PIN_ALT_SHIFT)
+#define PIN_ALT(x)		(((x) & PIN_ALT_MASK) >> PIN_ALT_SHIFT)
+#define PIN_GPIO		(NMK_GPIO_ALT_GPIO << PIN_ALT_SHIFT)
+#define PIN_ALT_A		(NMK_GPIO_ALT_A << PIN_ALT_SHIFT)
+#define PIN_ALT_B		(NMK_GPIO_ALT_B << PIN_ALT_SHIFT)
+#define PIN_ALT_C		(NMK_GPIO_ALT_C << PIN_ALT_SHIFT)
 
-extern void nmk_gpio_clocks_enable(void);
-extern void nmk_gpio_clocks_disable(void);
+#define PIN_PULL_SHIFT		11
+#define PIN_PULL_MASK		(0x3 << PIN_PULL_SHIFT)
+#define PIN_PULL(x)		(((x) & PIN_PULL_MASK) >> PIN_PULL_SHIFT)
+#define PIN_PULL_NONE		(NMK_GPIO_PULL_NONE << PIN_PULL_SHIFT)
+#define PIN_PULL_UP		(NMK_GPIO_PULL_UP << PIN_PULL_SHIFT)
+#define PIN_PULL_DOWN		(NMK_GPIO_PULL_DOWN << PIN_PULL_SHIFT)
 
-extern void nmk_gpio_read_pull(int gpio_bank, u32 *pull_up);
+#define PIN_SLPM_SHIFT		13
+#define PIN_SLPM_MASK		(0x1 << PIN_SLPM_SHIFT)
+#define PIN_SLPM(x)		(((x) & PIN_SLPM_MASK) >> PIN_SLPM_SHIFT)
+#define PIN_SLPM_MAKE_INPUT	(NMK_GPIO_SLPM_INPUT << PIN_SLPM_SHIFT)
+#define PIN_SLPM_NOCHANGE	(NMK_GPIO_SLPM_NOCHANGE << PIN_SLPM_SHIFT)
+/* These two replace the above in DB8500v2+ */
+#define PIN_SLPM_WAKEUP_ENABLE	(NMK_GPIO_SLPM_WAKEUP_ENABLE << PIN_SLPM_SHIFT)
+#define PIN_SLPM_WAKEUP_DISABLE	(NMK_GPIO_SLPM_WAKEUP_DISABLE << PIN_SLPM_SHIFT)
+
+#define PIN_DIR_SHIFT		14
+#define PIN_DIR_MASK		(0x1 << PIN_DIR_SHIFT)
+#define PIN_DIR(x)		(((x) & PIN_DIR_MASK) >> PIN_DIR_SHIFT)
+#define PIN_DIR_INPUT		(0 << PIN_DIR_SHIFT)
+#define PIN_DIR_OUTPUT		(1 << PIN_DIR_SHIFT)
+
+#define PIN_VAL_SHIFT		15
+#define PIN_VAL_MASK		(0x1 << PIN_VAL_SHIFT)
+#define PIN_VAL(x)		(((x) & PIN_VAL_MASK) >> PIN_VAL_SHIFT)
+#define PIN_VAL_LOW		(0 << PIN_VAL_SHIFT)
+#define PIN_VAL_HIGH		(1 << PIN_VAL_SHIFT)
+
+#define PIN_SLPM_PULL_SHIFT	16
+#define PIN_SLPM_PULL_MASK	(0x7 << PIN_SLPM_PULL_SHIFT)
+#define PIN_SLPM_PULL(x)	\
+	(((x) & PIN_SLPM_PULL_MASK) >> PIN_SLPM_PULL_SHIFT)
+#define PIN_SLPM_PULL_NONE	\
+	((1 + NMK_GPIO_PULL_NONE) << PIN_SLPM_PULL_SHIFT)
+#define PIN_SLPM_PULL_UP	\
+	((1 + NMK_GPIO_PULL_UP) << PIN_SLPM_PULL_SHIFT)
+#define PIN_SLPM_PULL_DOWN	\
+	((1 + NMK_GPIO_PULL_DOWN) << PIN_SLPM_PULL_SHIFT)
+
+#define PIN_SLPM_DIR_SHIFT	19
+#define PIN_SLPM_DIR_MASK	(0x3 << PIN_SLPM_DIR_SHIFT)
+#define PIN_SLPM_DIR(x)		\
+	(((x) & PIN_SLPM_DIR_MASK) >> PIN_SLPM_DIR_SHIFT)
+#define PIN_SLPM_DIR_INPUT	((1 + 0) << PIN_SLPM_DIR_SHIFT)
+#define PIN_SLPM_DIR_OUTPUT	((1 + 1) << PIN_SLPM_DIR_SHIFT)
+
+#define PIN_SLPM_VAL_SHIFT	21
+#define PIN_SLPM_VAL_MASK	(0x3 << PIN_SLPM_VAL_SHIFT)
+#define PIN_SLPM_VAL(x)		\
+	(((x) & PIN_SLPM_VAL_MASK) >> PIN_SLPM_VAL_SHIFT)
+#define PIN_SLPM_VAL_LOW	((1 + 0) << PIN_SLPM_VAL_SHIFT)
+#define PIN_SLPM_VAL_HIGH	((1 + 1) << PIN_SLPM_VAL_SHIFT)
+
+/* Shortcuts.  Use these instead of separate DIR, PULL, and VAL.  */
+#define PIN_INPUT_PULLDOWN	(PIN_DIR_INPUT | PIN_PULL_DOWN)
+#define PIN_INPUT_PULLUP	(PIN_DIR_INPUT | PIN_PULL_UP)
+#define PIN_INPUT_NOPULL	(PIN_DIR_INPUT | PIN_PULL_NONE)
+#define PIN_OUTPUT_LOW		(PIN_DIR_OUTPUT | PIN_VAL_LOW)
+#define PIN_OUTPUT_HIGH		(PIN_DIR_OUTPUT | PIN_VAL_HIGH)
+
+#define PIN_SLPM_INPUT_PULLDOWN	(PIN_SLPM_DIR_INPUT | PIN_SLPM_PULL_DOWN)
+#define PIN_SLPM_INPUT_PULLUP	(PIN_SLPM_DIR_INPUT | PIN_SLPM_PULL_UP)
+#define PIN_SLPM_INPUT_NOPULL	(PIN_SLPM_DIR_INPUT | PIN_SLPM_PULL_NONE)
+#define PIN_SLPM_OUTPUT_LOW	(PIN_SLPM_DIR_OUTPUT | PIN_SLPM_VAL_LOW)
+#define PIN_SLPM_OUTPUT_HIGH	(PIN_SLPM_DIR_OUTPUT | PIN_SLPM_VAL_HIGH)
+
+#define PIN_CFG_DEFAULT		(0)
+
+#define PIN_CFG(num, alt)		\
+	(PIN_CFG_DEFAULT |\
+	 (PIN_NUM(num) | PIN_##alt))
+
+#define PIN_CFG_INPUT(num, alt, pull)		\
+	(PIN_CFG_DEFAULT |\
+	 (PIN_NUM(num) | PIN_##alt | PIN_INPUT_##pull))
+
+#define PIN_CFG_OUTPUT(num, alt, val)		\
+	(PIN_CFG_DEFAULT |\
+	 (PIN_NUM(num) | PIN_##alt | PIN_OUTPUT_##val))
 
 /*
- * Platform data to register a block: only the initial gpio/irq number.
+ * We want to keep this function outside the driver since it is only using the
+ * externally visible gpio_config() function and merely twisting bits around
+ * for the legacy pin configuration API.
  */
-struct nmk_gpio_platform_data {
-	char *name;
-	int first_gpio;
-	int first_irq;
-	int num_gpio;
-	u32 (*get_secondary_status)(unsigned int bank);
-	void (*set_ioforce)(bool enable);
-	bool supports_sleepmode;
-};
+static inline int __nmk_config_pins(pin_cfg_t *cfgs, int num, bool sleep)
+{
+	pin_cfg_t cfg;
+	int ret;
+	int i;
+
+	for (i = 0; i < num; i++) {
+		cfg = cfgs[i];
+
+		if (sleep) {
+			/*
+			 * We reconfigure for sleep mode, mask off the
+			 * normal configs and replace them with sleep mode
+			 * configs and pass into the same legacy config
+			 * function, simply. Zero values mean "same as in
+			 * normal mode".
+			 */
+			int slpm_pull = PIN_SLPM_PULL(cfg);
+			int slpm_output = PIN_SLPM_DIR(cfg);
+			int slpm_val = PIN_SLPM_VAL(cfg);
+
+			/* Override bias mode */
+			if (slpm_pull) {
+				cfg &= ~PIN_PULL_MASK;
+				cfg |= (slpm_pull - 1) << PIN_PULL_SHIFT;
+			}
+
+			/* Override in/output mode */
+			if (slpm_output) {
+				cfg &= ~PIN_DIR_MASK;
+				cfg |= (slpm_output - 1) << PIN_DIR_SHIFT;
+			}
+
+			/* Override output value */
+			if (slpm_val) {
+				cfg &= ~PIN_VAL_MASK;
+				cfg |= (slpm_output - 1) << PIN_VAL_SHIFT;
+			}
+		}
+
+		ret = gpio_config(PIN_NUM(cfg),
+				  GPIO_CONFIG_NMK_SETUP_PIN_LEGACY,
+				  (unsigned long *) &cfg);
+		if (ret < 0)
+			return ret;
+	}
+	return 0;
+}
+
+extern int __nmk_config_pins(pin_cfg_t *cfgs, int num, bool sleep);
+
+static inline int nmk_config_pin(pin_cfg_t cfg, bool sleep)
+{
+	return __nmk_config_pins(&cfg, 1, sleep);
+}
+
+static inline int nmk_config_pins(pin_cfg_t *cfgs, int num)
+{
+	return __nmk_config_pins(cfgs, num, false);
+}
+
+static inline int nmk_config_pins_sleep(pin_cfg_t *cfgs, int num)
+{
+	return __nmk_config_pins(cfgs, num, true);
+}
 
 #endif
-- 
1.7.3.2

