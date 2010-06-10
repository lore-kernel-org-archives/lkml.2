Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab0FJFlM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 01:41:12 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41158 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754376Ab0FJFlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 01:41:08 -0400
Subject: [PATCH v2 4/5] of/gpio: add default of_xlate function if device has a
	node pointer
To: dbrownell@users.sourceforge.net, avorontsov@ru.mvista.com
From: Grant Likely <grant.likely@secretlab.ca>
Cc: bgat@billgatliff.com, dbaryshkov@gmail.com, benh@kernel.crashing.org,
       devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, linuxppc-dev@lists.ozlabs.org
Date: Wed, 09 Jun 2010 23:41:02 -0600
Message-ID: <20100610054102.16716.67077.stgit@angua>
In-Reply-To: <20100610053439.16716.53944.stgit@angua>
References: <20100610053439.16716.53944.stgit@angua>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Vorontsov <avorontsov@ru.mvista.com>

Implement generic OF gpio hooks and thus make device-enabled GPIO chips
(i.e.  the ones that have gpio_chip->dev specified) automatically attach
to the OpenFirmware subsystem.  Which means that now we can handle I2C and
SPI GPIO chips almost* transparently.

* "Almost" because some chips still require platform data, and for these
  chips OF-glue is still needed, though with this change the glue will
  be much smaller.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Bill Gatliff <bgat@billgatliff.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
CC: devicetree-discuss@lists.ozlabs.org
---
 arch/powerpc/platforms/52xx/mpc52xx_gpio.c     |    2 -
 arch/powerpc/platforms/52xx/mpc52xx_gpt.c      |    3 --
 arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c |    2 -
 arch/powerpc/sysdev/cpm1.c                     |    2 -
 arch/powerpc/sysdev/cpm_common.c               |    1 -
 arch/powerpc/sysdev/mpc8xxx_gpio.c             |    1 -
 arch/powerpc/sysdev/ppc4xx_gpio.c              |    1 -
 arch/powerpc/sysdev/qe_lib/gpio.c              |    1 -
 arch/powerpc/sysdev/simple_gpio.c              |    1 -
 drivers/gpio/gpiolib.c                         |    5 ++++
 drivers/gpio/xilinx_gpio.c                     |    1 -
 drivers/of/gpio.c                              |   33 +++++++++++++++++-------
 include/linux/of_gpio.h                        |    7 ++++-
 13 files changed, 34 insertions(+), 26 deletions(-)

diff --git a/arch/powerpc/platforms/52xx/mpc52xx_gpio.c b/arch/powerpc/platforms/52xx/mpc52xx_gpio.c
index fd0912e..0855e80 100644
--- a/arch/powerpc/platforms/52xx/mpc52xx_gpio.c
+++ b/arch/powerpc/platforms/52xx/mpc52xx_gpio.c
@@ -161,7 +161,6 @@ static int __devinit mpc52xx_wkup_gpiochip_probe(struct of_device *ofdev,
 
 	gc = &chip->mmchip.gc;
 
-	gc->of_gpio_n_cells  = 2;
 	gc->ngpio            = 8;
 	gc->direction_input  = mpc52xx_wkup_gpio_dir_in;
 	gc->direction_output = mpc52xx_wkup_gpio_dir_out;
@@ -325,7 +324,6 @@ static int __devinit mpc52xx_simple_gpiochip_probe(struct of_device *ofdev,
 
 	gc = &chip->mmchip.gc;
 
-	gc->of_gpio_n_cells  = 2;
 	gc->ngpio            = 32;
 	gc->direction_input  = mpc52xx_simple_gpio_dir_in;
 	gc->direction_output = mpc52xx_simple_gpio_dir_out;
diff --git a/arch/powerpc/platforms/52xx/mpc52xx_gpt.c b/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
index 6e82bd2..5d7d607 100644
--- a/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
+++ b/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
@@ -348,10 +348,7 @@ mpc52xx_gpt_gpio_setup(struct mpc52xx_gpt_priv *gpt, struct device_node *node)
 	gpt->gc.get = mpc52xx_gpt_gpio_get;
 	gpt->gc.set = mpc52xx_gpt_gpio_set;
 	gpt->gc.base = -1;
-	gpt->gc.of_gpio_n_cells = 2;
-	gpt->gc.of_xlate = of_gpio_simple_xlate;
 	gpt->gc.of_node = node;
-	of_node_get(node);
 
 	/* Setup external pin in GPIO mode */
 	clrsetbits_be32(&gpt->regs->mode, MPC52xx_GPT_MODE_MS_MASK,
diff --git a/arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c b/arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c
index f0dbace..59b0ed1 100644
--- a/arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c
+++ b/arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c
@@ -90,8 +90,6 @@ static int mcu_gpiochip_add(struct mcu *mcu)
 	gc->base = -1;
 	gc->set = mcu_gpio_set;
 	gc->direction_output = mcu_gpio_dir_out;
-	gc->of_gpio_n_cells = 2;
-	gc->of_xlate = of_gpio_simple_xlate;
 	gc->of_node = np;
 
 	return gpiochip_add(gc);
diff --git a/arch/powerpc/sysdev/cpm1.c b/arch/powerpc/sysdev/cpm1.c
index d5cf7d4..0085212 100644
--- a/arch/powerpc/sysdev/cpm1.c
+++ b/arch/powerpc/sysdev/cpm1.c
@@ -633,7 +633,6 @@ int cpm1_gpiochip_add16(struct device_node *np)
 	gc = &mm_gc->gc;
 
 	mm_gc->save_regs = cpm1_gpio16_save_regs;
-	gc->of_gpio_n_cells = 2;
 	gc->ngpio = 16;
 	gc->direction_input = cpm1_gpio16_dir_in;
 	gc->direction_output = cpm1_gpio16_dir_out;
@@ -755,7 +754,6 @@ int cpm1_gpiochip_add32(struct device_node *np)
 	gc = &mm_gc->gc;
 
 	mm_gc->save_regs = cpm1_gpio32_save_regs;
-	gc->of_gpio_n_cells = 2;
 	gc->ngpio = 32;
 	gc->direction_input = cpm1_gpio32_dir_in;
 	gc->direction_output = cpm1_gpio32_dir_out;
diff --git a/arch/powerpc/sysdev/cpm_common.c b/arch/powerpc/sysdev/cpm_common.c
index 67e9b47..2b69aa0 100644
--- a/arch/powerpc/sysdev/cpm_common.c
+++ b/arch/powerpc/sysdev/cpm_common.c
@@ -337,7 +337,6 @@ int cpm2_gpiochip_add32(struct device_node *np)
 	gc = &mm_gc->gc;
 
 	mm_gc->save_regs = cpm2_gpio32_save_regs;
-	gc->of_gpio_n_cells = 2;
 	gc->ngpio = 32;
 	gc->direction_input = cpm2_gpio32_dir_in;
 	gc->direction_output = cpm2_gpio32_dir_out;
diff --git a/arch/powerpc/sysdev/mpc8xxx_gpio.c b/arch/powerpc/sysdev/mpc8xxx_gpio.c
index ec8fcd4..2b69084 100644
--- a/arch/powerpc/sysdev/mpc8xxx_gpio.c
+++ b/arch/powerpc/sysdev/mpc8xxx_gpio.c
@@ -273,7 +273,6 @@ static void __init mpc8xxx_add_controller(struct device_node *np)
 	gc = &mm_gc->gc;
 
 	mm_gc->save_regs = mpc8xxx_gpio_save_regs;
-	gc->of_gpio_n_cells = 2;
 	gc->ngpio = MPC8XXX_GPIO_PINS;
 	gc->direction_input = mpc8xxx_gpio_dir_in;
 	gc->direction_output = mpc8xxx_gpio_dir_out;
diff --git a/arch/powerpc/sysdev/ppc4xx_gpio.c b/arch/powerpc/sysdev/ppc4xx_gpio.c
index 42e7a5e..fc65ad1 100644
--- a/arch/powerpc/sysdev/ppc4xx_gpio.c
+++ b/arch/powerpc/sysdev/ppc4xx_gpio.c
@@ -194,7 +194,6 @@ static int __init ppc4xx_add_gpiochips(void)
 		mm_gc = &ppc4xx_gc->mm_gc;
 		gc = &mm_gc->gc;
 
-		gc->of_gpio_n_cells = 2;
 		gc->ngpio = 32;
 		gc->direction_input = ppc4xx_gpio_dir_in;
 		gc->direction_output = ppc4xx_gpio_dir_out;
diff --git a/arch/powerpc/sysdev/qe_lib/gpio.c b/arch/powerpc/sysdev/qe_lib/gpio.c
index 32e9440..36bf845 100644
--- a/arch/powerpc/sysdev/qe_lib/gpio.c
+++ b/arch/powerpc/sysdev/qe_lib/gpio.c
@@ -321,7 +321,6 @@ static int __init qe_add_gpiochips(void)
 		gc = &mm_gc->gc;
 
 		mm_gc->save_regs = qe_gpio_save_regs;
-		gc->of_gpio_n_cells = 2;
 		gc->ngpio = QE_PIO_PINS;
 		gc->direction_input = qe_gpio_dir_in;
 		gc->direction_output = qe_gpio_dir_out;
diff --git a/arch/powerpc/sysdev/simple_gpio.c b/arch/powerpc/sysdev/simple_gpio.c
index b7559aa..b6defda 100644
--- a/arch/powerpc/sysdev/simple_gpio.c
+++ b/arch/powerpc/sysdev/simple_gpio.c
@@ -103,7 +103,6 @@ static int __init u8_simple_gpiochip_add(struct device_node *np)
 	gc = &mm_gc->gc;
 
 	mm_gc->save_regs = u8_gpio_save_regs;
-	gc->of_gpio_n_cells = 2;
 	gc->ngpio = 8;
 	gc->direction_input = u8_gpio_dir_in;
 	gc->direction_output = u8_gpio_dir_out;
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 73fd328..83cbc34 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -8,6 +8,7 @@
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
 #include <linux/gpio.h>
+#include <linux/of_gpio.h>
 #include <linux/idr.h>
 #include <linux/slab.h>
 
@@ -1099,6 +1100,8 @@ int gpiochip_add(struct gpio_chip *chip)
 		}
 	}
 
+	of_gpiochip_add(chip);
+
 unlock:
 	spin_unlock_irqrestore(&gpio_lock, flags);
 
@@ -1133,6 +1136,8 @@ int gpiochip_remove(struct gpio_chip *chip)
 
 	spin_lock_irqsave(&gpio_lock, flags);
 
+	of_gpiochip_remove(chip);
+
 	for (id = chip->base; id < chip->base + chip->ngpio; id++) {
 		if (test_bit(FLAG_REQUESTED, &gpio_desc[id].flags)) {
 			status = -EBUSY;
diff --git a/drivers/gpio/xilinx_gpio.c b/drivers/gpio/xilinx_gpio.c
index 2993c40..7096909 100644
--- a/drivers/gpio/xilinx_gpio.c
+++ b/drivers/gpio/xilinx_gpio.c
@@ -190,7 +190,6 @@ static int __devinit xgpio_of_probe(struct device_node *np)
 
 	spin_lock_init(&chip->gpio_lock);
 
-	chip->mmchip.gc.of_gpio_n_cells = 2;
 	chip->mmchip.gc.direction_input = xgpio_dir_in;
 	chip->mmchip.gc.direction_output = xgpio_dir_out;
 	chip->mmchip.gc.get = xgpio_get;
diff --git a/drivers/of/gpio.c b/drivers/of/gpio.c
index c8618d3..09f05a1 100644
--- a/drivers/of/gpio.c
+++ b/drivers/of/gpio.c
@@ -125,8 +125,8 @@ EXPORT_SYMBOL(of_gpio_count);
  * gpio chips. This function performs only one sanity check: whether gpio
  * is less than ngpios (that is specified in the gpio_chip).
  */
-int of_gpio_simple_xlate(struct gpio_chip *gc, struct device_node *np,
-			 const void *gpio_spec, u32 *flags)
+static int of_gpio_simple_xlate(struct gpio_chip *gc, struct device_node *np,
+				const void *gpio_spec, u32 *flags)
 {
 	const __be32 *gpio = gpio_spec;
 	const u32 n = be32_to_cpup(gpio);
@@ -150,7 +150,6 @@ int of_gpio_simple_xlate(struct gpio_chip *gc, struct device_node *np,
 
 	return n;
 }
-EXPORT_SYMBOL(of_gpio_simple_xlate);
 
 /**
  * of_mm_gpiochip_add - Add memory mapped GPIO chip (bank)
@@ -187,9 +186,6 @@ int of_mm_gpiochip_add(struct device_node *np,
 
 	gc->base = -1;
 
-	if (!gc->of_xlate)
-		gc->of_xlate = of_gpio_simple_xlate;
-
 	if (mm_gc->save_regs)
 		mm_gc->save_regs(mm_gc);
 
@@ -199,9 +195,6 @@ int of_mm_gpiochip_add(struct device_node *np,
 	if (ret)
 		goto err2;
 
-	/* We don't want to lose the node and its ->data */
-	of_node_get(np);
-
 	pr_debug("%s: registered as generic GPIO chip, base is %d\n",
 		 np->full_name, gc->base);
 	return 0;
@@ -216,6 +209,28 @@ err0:
 }
 EXPORT_SYMBOL(of_mm_gpiochip_add);
 
+void of_gpiochip_add(struct gpio_chip *chip)
+{
+	if ((!chip->of_node) && (chip->dev))
+		chip->of_node = chip->dev->of_node;
+
+	if (!chip->of_node)
+		return;
+
+	if (!chip->of_xlate) {
+		chip->of_gpio_n_cells = 2;
+		chip->of_xlate = of_gpio_simple_xlate;
+	}
+
+	of_node_get(chip->of_node);
+}
+
+void of_gpiochip_remove(struct gpio_chip *chip)
+{
+	if (chip->of_node)
+		of_node_put(chip->of_node);
+}
+
 /* Private function for resolving node pointer to gpio_chip */
 static int of_gpiochip_is_match(struct gpio_chip *chip, void *data)
 {
diff --git a/include/linux/of_gpio.h b/include/linux/of_gpio.h
index 1020587..6598c04 100644
--- a/include/linux/of_gpio.h
+++ b/include/linux/of_gpio.h
@@ -52,9 +52,9 @@ extern unsigned int of_gpio_count(struct device_node *np);
 
 extern int of_mm_gpiochip_add(struct device_node *np,
 			      struct of_mm_gpio_chip *mm_gc);
-extern int of_gpio_simple_xlate(struct gpio_chip *gc, struct device_node *np,
-				const void *gpio_spec, u32 *flags);
 
+extern void of_gpiochip_add(struct gpio_chip *gc);
+extern void of_gpiochip_remove(struct gpio_chip *gc);
 extern struct gpio_chip *of_node_to_gpiochip(struct device_node *np);
 
 #else /* CONFIG_OF_GPIO */
@@ -71,6 +71,9 @@ static inline unsigned int of_gpio_count(struct device_node *np)
 	return 0;
 }
 
+static inline void of_gpiochip_add(struct gpio_chip *gc) { }
+static inline void of_gpiochip_remove(struct gpio_chip *gc) { }
+
 #endif /* CONFIG_OF_GPIO */
 
 /**

