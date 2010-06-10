Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab0FJFlO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 01:41:14 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:59920 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555Ab0FJFlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 01:41:08 -0400
Subject: [PATCH v2 3/5] of/gpio: stop using device_node data pointer to find
	gpio_chip
To: dbrownell@users.sourceforge.net, avorontsov@ru.mvista.com
From: Grant Likely <grant.likely@secretlab.ca>
Cc: bgat@billgatliff.com, dbaryshkov@gmail.com, benh@kernel.crashing.org,
       devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, linuxppc-dev@lists.ozlabs.org
Date: Wed, 09 Jun 2010 23:40:57 -0600
Message-ID: <20100610054057.16716.51090.stgit@angua>
In-Reply-To: <20100610053439.16716.53944.stgit@angua>
References: <20100610053439.16716.53944.stgit@angua>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the kernel uses the struct device_node.data pointer to resolve
a struct gpio_chip pointer from a device tree node.  However, the .data
member doesn't provide any type checking and there aren't any rules
enforced on what it should be used for.  There's no guarantee that the
data stored in it actually points to an gpio_chip pointer.

Instead of relying on the .data pointer, this patch modifies the code
to add a lookup function which scans through the registered gpio_chips
and returns the gpio_chip that has a pointer to the specified
device_node.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Anton Vorontsov <avorontsov@ru.mvista.com>
CC: Grant Likely <grant.likely@secretlab.ca>
CC: David Brownell <dbrownell@users.sourceforge.net>
CC: Bill Gatliff <bgat@billgatliff.com>
CC: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Jean Delvare <khali@linux-fr.org>
CC: linux-kernel@vger.kernel.org
CC: devicetree-discuss@lists.ozlabs.org
---
 arch/microblaze/kernel/reset.c                 |    2 +-
 arch/powerpc/platforms/52xx/mpc52xx_gpt.c      |    1 +
 arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c |   23 ++---------------
 arch/powerpc/sysdev/qe_lib/gpio.c              |    2 +-
 drivers/gpio/gpiolib.c                         |   32 ++++++++++++++++++++++++
 drivers/of/gpio.c                              |   15 +++++++++--
 include/asm-generic/gpio.h                     |    3 ++
 include/linux/of_gpio.h                        |    3 ++
 8 files changed, 56 insertions(+), 25 deletions(-)

diff --git a/arch/microblaze/kernel/reset.c b/arch/microblaze/kernel/reset.c
index 5476d3c..bd8ccab 100644
--- a/arch/microblaze/kernel/reset.c
+++ b/arch/microblaze/kernel/reset.c
@@ -39,7 +39,7 @@ static int of_reset_gpio_handle(void)
 		goto err0;
 	}
 
-	gc = gpio->data;
+	gc = of_node_to_gpiochip(gpio);
 	if (!gc) {
 		pr_debug("%s: gpio controller %s isn't registered\n",
 			 root->full_name, gpio->full_name);
diff --git a/arch/powerpc/platforms/52xx/mpc52xx_gpt.c b/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
index 3f2ee47..6e82bd2 100644
--- a/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
+++ b/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
@@ -350,6 +350,7 @@ mpc52xx_gpt_gpio_setup(struct mpc52xx_gpt_priv *gpt, struct device_node *node)
 	gpt->gc.base = -1;
 	gpt->gc.of_gpio_n_cells = 2;
 	gpt->gc.of_xlate = of_gpio_simple_xlate;
+	gpt->gc.of_node = node;
 	of_node_get(node);
 
 	/* Setup external pin in GPIO mode */
diff --git a/arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c b/arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c
index e49f4bd..f0dbace 100644
--- a/arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c
+++ b/arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c
@@ -35,7 +35,6 @@
 
 struct mcu {
 	struct mutex lock;
-	struct device_node *np;
 	struct i2c_client *client;
 	struct gpio_chip gc;
 	u8 reg_ctrl;
@@ -79,7 +78,6 @@ static int mcu_gpiochip_add(struct mcu *mcu)
 {
 	struct device_node *np;
 	struct gpio_chip *gc = &mcu->gc;
-	int ret;
 
 	np = of_find_compatible_node(NULL, NULL, "fsl,mcu-mpc8349emitx");
 	if (!np)
@@ -94,29 +92,14 @@ static int mcu_gpiochip_add(struct mcu *mcu)
 	gc->direction_output = mcu_gpio_dir_out;
 	gc->of_gpio_n_cells = 2;
 	gc->of_xlate = of_gpio_simple_xlate;
+	gc->of_node = np;
 
-	mcu->np = np;
-
-	/*
-	 * We don't want to lose the node, its ->data and ->full_name...
-	 * So, if succeeded, we don't put the node here.
-	 */
-	ret = gpiochip_add(gc);
-	if (ret)
-		of_node_put(np);
-	return ret;
+	return gpiochip_add(gc);
 }
 
 static int mcu_gpiochip_remove(struct mcu *mcu)
 {
-	int ret;
-
-	ret = gpiochip_remove(&mcu->gc);
-	if (ret)
-		return ret;
-	of_node_put(mcu->np);
-
-	return 0;
+	return gpiochip_remove(&mcu->gc);
 }
 
 static int __devinit mcu_probe(struct i2c_client *client,
diff --git a/arch/powerpc/sysdev/qe_lib/gpio.c b/arch/powerpc/sysdev/qe_lib/gpio.c
index 194478c..32e9440 100644
--- a/arch/powerpc/sysdev/qe_lib/gpio.c
+++ b/arch/powerpc/sysdev/qe_lib/gpio.c
@@ -167,7 +167,7 @@ struct qe_pin *qe_pin_request(struct device_node *np, int index)
 		goto err1;
 	}
 
-	gc = gpio_np->data;
+	gc = of_node_to_gpiochip(gpio_np);
 	if (!gc) {
 		pr_debug("%s: gpio controller %s isn't registered\n",
 			 np->full_name, gpio_np->full_name);
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 713ca0e..73fd328 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1153,6 +1153,38 @@ int gpiochip_remove(struct gpio_chip *chip)
 }
 EXPORT_SYMBOL_GPL(gpiochip_remove);
 
+/**
+ * gpiochip_find() - iterator for locating a specific gpio_chip
+ * @data: data to pass to match function
+ * @callback: Callback function to check gpio_chip
+ *
+ * Similar to bus_find_device.  It returns a reference to a gpio_chip as
+ * determined by a user supplied @match callback.  The callback should return
+ * 0 if the device doesn't match and non-zero if it does.  If the callback is
+ * non-zero, this function will return to the caller and not iterate over any
+ * more gpio_chips.
+ */
+struct gpio_chip *gpiochip_find(void *data,
+				int (*match)(struct gpio_chip *chip, void *data))
+{
+	struct gpio_chip *chip = NULL;
+	unsigned long flags;
+	int i;
+
+	spin_lock_irqsave(&gpio_lock, flags);
+	for (i = 0; i < ARCH_NR_GPIOS; i++) {
+		if (!gpio_desc[i].chip)
+			continue;
+
+		if (match(gpio_desc[i].chip, data)) {
+			chip = gpio_desc[i].chip;
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&gpio_lock, flags);
+
+	return chip;
+}
 
 /* These "optional" allocation calls help prevent drivers from stomping
  * on each other, and help provide better diagnostics in debugfs.
diff --git a/drivers/of/gpio.c b/drivers/of/gpio.c
index fde53a3..c8618d3 100644
--- a/drivers/of/gpio.c
+++ b/drivers/of/gpio.c
@@ -46,7 +46,7 @@ int of_get_gpio_flags(struct device_node *np, int index,
 		goto err0;
 	}
 
-	gc = gpio_np->data;
+	gc = of_node_to_gpiochip(gpio_np);
 	if (!gc) {
 		pr_debug("%s: gpio controller %s isn't registered\n",
 			 np->full_name, gpio_np->full_name);
@@ -193,7 +193,6 @@ int of_mm_gpiochip_add(struct device_node *np,
 	if (mm_gc->save_regs)
 		mm_gc->save_regs(mm_gc);
 
-	np->data = &mm_gc->gc;
 	mm_gc->gc.of_node = np;
 
 	ret = gpiochip_add(gc);
@@ -207,7 +206,6 @@ int of_mm_gpiochip_add(struct device_node *np,
 		 np->full_name, gc->base);
 	return 0;
 err2:
-	np->data = NULL;
 	iounmap(mm_gc->regs);
 err1:
 	kfree(gc->label);
@@ -217,3 +215,14 @@ err0:
 	return ret;
 }
 EXPORT_SYMBOL(of_mm_gpiochip_add);
+
+/* Private function for resolving node pointer to gpio_chip */
+static int of_gpiochip_is_match(struct gpio_chip *chip, void *data)
+{
+	return chip->of_node == data;
+}
+
+struct gpio_chip *of_node_to_gpiochip(struct device_node *np)
+{
+	return gpiochip_find(np, of_gpiochip_is_match);
+}
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index af2544e..c7376bf 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -127,6 +127,9 @@ extern int __must_check gpiochip_reserve(int start, int ngpio);
 /* add/remove chips */
 extern int gpiochip_add(struct gpio_chip *chip);
 extern int __must_check gpiochip_remove(struct gpio_chip *chip);
+extern struct gpio_chip *gpiochip_find(void *data,
+					int (*match)(struct gpio_chip *chip,
+						     void *data));
 
 
 /* Always use the library code for GPIO management calls,
diff --git a/include/linux/of_gpio.h b/include/linux/of_gpio.h
index 460d681..1020587 100644
--- a/include/linux/of_gpio.h
+++ b/include/linux/of_gpio.h
@@ -54,6 +54,9 @@ extern int of_mm_gpiochip_add(struct device_node *np,
 			      struct of_mm_gpio_chip *mm_gc);
 extern int of_gpio_simple_xlate(struct gpio_chip *gc, struct device_node *np,
 				const void *gpio_spec, u32 *flags);
+
+extern struct gpio_chip *of_node_to_gpiochip(struct device_node *np);
+
 #else /* CONFIG_OF_GPIO */
 
 /* Drivers may not strictly depend on the GPIO support, so let them link. */

