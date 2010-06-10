Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab0FJFk7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 01:40:59 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:51045 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334Ab0FJFk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 01:40:56 -0400
Subject: [PATCH v2 2/5] of/gpio: Kill of_gpio_chip and add members directly to
	gpio_chip
To: dbrownell@users.sourceforge.net, avorontsov@ru.mvista.com
From: Grant Likely <grant.likely@secretlab.ca>
Cc: bgat@billgatliff.com, dbaryshkov@gmail.com, benh@kernel.crashing.org,
       devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, linuxppc-dev@lists.ozlabs.org
Date: Wed, 09 Jun 2010 23:40:52 -0600
Message-ID: <20100610054051.16716.41716.stgit@angua>
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

The OF gpio infrastructure is great for describing GPIO connections within
the device tree.  However, using a GPIO binding still requires changes to
the gpio controller just to add an of_gpio structure.  In most cases, the
gpio controller doesn't actually need any special support and the simple
OF gpio mapping function is more than sufficient.  Additional, the current
scheme of using of_gpio_chip requires a convoluted scheme to maintain
1:1 mappings between of_gpio_chip and gpio_chip instances.

If the struct of_gpio_chip data members were moved into struct gpio_chip,
then it would simplify the processing of OF gpio bindings, and it would
make it trivial to use device tree OF connections on existing gpiolib
controller drivers.

This patch eliminates the of_gpio_chip structure and moves the relevant
fields into struct gpio_chip (conditional on CONFIG_OF_GPIO).  This move
simplifies the existing code and prepares for adding automatic device tree
support to existing drivers.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Bill Gatliff <bgat@billgatliff.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jean Delvare <khali@linux-fr.org>
---
 arch/microblaze/kernel/reset.c                 |   12 +++---
 arch/powerpc/platforms/52xx/mpc52xx_gpio.c     |   32 ++++++++-------
 arch/powerpc/platforms/52xx/mpc52xx_gpt.c      |   29 +++++++-------
 arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c |   15 +++----
 arch/powerpc/platforms/86xx/gef_gpio.c         |   24 ++++++------
 arch/powerpc/sysdev/cpm1.c                     |   12 ++----
 arch/powerpc/sysdev/cpm_common.c               |    6 +--
 arch/powerpc/sysdev/mpc8xxx_gpio.c             |    6 +--
 arch/powerpc/sysdev/ppc4xx_gpio.c              |    6 +--
 arch/powerpc/sysdev/qe_lib/gpio.c              |   32 +++++++--------
 arch/powerpc/sysdev/simple_gpio.c              |    6 +--
 drivers/gpio/xilinx_gpio.c                     |   16 +++-----
 drivers/of/gpio.c                              |   50 ++++++++++++------------
 include/asm-generic/gpio.h                     |   12 ++++++
 include/linux/of_gpio.h                        |   29 ++------------
 15 files changed, 129 insertions(+), 158 deletions(-)

diff --git a/arch/microblaze/kernel/reset.c b/arch/microblaze/kernel/reset.c
index a1721a3..5476d3c 100644
--- a/arch/microblaze/kernel/reset.c
+++ b/arch/microblaze/kernel/reset.c
@@ -24,8 +24,8 @@ static int of_reset_gpio_handle(void)
 	int ret; /* variable which stored handle reset gpio pin */
 	struct device_node *root; /* root node */
 	struct device_node *gpio; /* gpio node */
-	struct of_gpio_chip *of_gc = NULL;
-	enum of_gpio_flags flags ;
+	struct gpio_chip *gc;
+	u32 flags;
 	const void *gpio_spec;
 
 	/* find out root node */
@@ -39,19 +39,19 @@ static int of_reset_gpio_handle(void)
 		goto err0;
 	}
 
-	of_gc = gpio->data;
-	if (!of_gc) {
+	gc = gpio->data;
+	if (!gc) {
 		pr_debug("%s: gpio controller %s isn't registered\n",
 			 root->full_name, gpio->full_name);
 		ret = -ENODEV;
 		goto err1;
 	}
 
-	ret = of_gc->xlate(of_gc, root, gpio_spec, &flags);
+	ret = gc->of_xlate(gc, root, gpio_spec, &flags);
 	if (ret < 0)
 		goto err1;
 
-	ret += of_gc->gc.base;
+	ret += gc->base;
 err1:
 	of_node_put(gpio);
 err0:
diff --git a/arch/powerpc/platforms/52xx/mpc52xx_gpio.c b/arch/powerpc/platforms/52xx/mpc52xx_gpio.c
index ca5305a..fd0912e 100644
--- a/arch/powerpc/platforms/52xx/mpc52xx_gpio.c
+++ b/arch/powerpc/platforms/52xx/mpc52xx_gpio.c
@@ -152,21 +152,21 @@ static int __devinit mpc52xx_wkup_gpiochip_probe(struct of_device *ofdev,
 {
 	struct mpc52xx_gpiochip *chip;
 	struct mpc52xx_gpio_wkup __iomem *regs;
-	struct of_gpio_chip *ofchip;
+	struct gpio_chip *gc;
 	int ret;
 
 	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
 	if (!chip)
 		return -ENOMEM;
 
-	ofchip = &chip->mmchip.of_gc;
+	gc = &chip->mmchip.gc;
 
-	ofchip->gpio_cells          = 2;
-	ofchip->gc.ngpio            = 8;
-	ofchip->gc.direction_input  = mpc52xx_wkup_gpio_dir_in;
-	ofchip->gc.direction_output = mpc52xx_wkup_gpio_dir_out;
-	ofchip->gc.get              = mpc52xx_wkup_gpio_get;
-	ofchip->gc.set              = mpc52xx_wkup_gpio_set;
+	gc->of_gpio_n_cells  = 2;
+	gc->ngpio            = 8;
+	gc->direction_input  = mpc52xx_wkup_gpio_dir_in;
+	gc->direction_output = mpc52xx_wkup_gpio_dir_out;
+	gc->get              = mpc52xx_wkup_gpio_get;
+	gc->set              = mpc52xx_wkup_gpio_set;
 
 	ret = of_mm_gpiochip_add(ofdev->dev.of_node, &chip->mmchip);
 	if (ret)
@@ -315,7 +315,7 @@ static int __devinit mpc52xx_simple_gpiochip_probe(struct of_device *ofdev,
 					const struct of_device_id *match)
 {
 	struct mpc52xx_gpiochip *chip;
-	struct of_gpio_chip *ofchip;
+	struct gpio_chip *gc;
 	struct mpc52xx_gpio __iomem *regs;
 	int ret;
 
@@ -323,14 +323,14 @@ static int __devinit mpc52xx_simple_gpiochip_probe(struct of_device *ofdev,
 	if (!chip)
 		return -ENOMEM;
 
-	ofchip = &chip->mmchip.of_gc;
+	gc = &chip->mmchip.gc;
 
-	ofchip->gpio_cells          = 2;
-	ofchip->gc.ngpio            = 32;
-	ofchip->gc.direction_input  = mpc52xx_simple_gpio_dir_in;
-	ofchip->gc.direction_output = mpc52xx_simple_gpio_dir_out;
-	ofchip->gc.get              = mpc52xx_simple_gpio_get;
-	ofchip->gc.set              = mpc52xx_simple_gpio_set;
+	gc->of_gpio_n_cells  = 2;
+	gc->ngpio            = 32;
+	gc->direction_input  = mpc52xx_simple_gpio_dir_in;
+	gc->direction_output = mpc52xx_simple_gpio_dir_out;
+	gc->get              = mpc52xx_simple_gpio_get;
+	gc->set              = mpc52xx_simple_gpio_set;
 
 	ret = of_mm_gpiochip_add(ofdev->dev.of_node, &chip->mmchip);
 	if (ret)
diff --git a/arch/powerpc/platforms/52xx/mpc52xx_gpt.c b/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
index 46c9357..3f2ee47 100644
--- a/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
+++ b/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
@@ -78,7 +78,7 @@ MODULE_LICENSE("GPL");
  * @dev: pointer to device structure
  * @regs: virtual address of GPT registers
  * @lock: spinlock to coordinate between different functions.
- * @of_gc: of_gpio_chip instance structure; used when GPIO is enabled
+ * @gc: gpio_chip instance structure; used when GPIO is enabled
  * @irqhost: Pointer to irq_host instance; used when IRQ mode is supported
  * @wdt_mode: only relevant for gpt0: bit 0 (MPC52xx_GPT_CAN_WDT) indicates
  *   if the gpt may be used as wdt, bit 1 (MPC52xx_GPT_IS_WDT) indicates
@@ -94,7 +94,7 @@ struct mpc52xx_gpt_priv {
 	u8 wdt_mode;
 
 #if defined(CONFIG_GPIOLIB)
-	struct of_gpio_chip of_gc;
+	struct gpio_chip gc;
 #endif
 };
 
@@ -280,7 +280,7 @@ mpc52xx_gpt_irq_setup(struct mpc52xx_gpt_priv *gpt, struct device_node *node)
 #if defined(CONFIG_GPIOLIB)
 static inline struct mpc52xx_gpt_priv *gc_to_mpc52xx_gpt(struct gpio_chip *gc)
 {
-	return container_of(to_of_gpio_chip(gc), struct mpc52xx_gpt_priv,of_gc);
+	return container_of(gc, struct mpc52xx_gpt_priv, gc);
 }
 
 static int mpc52xx_gpt_gpio_get(struct gpio_chip *gc, unsigned int gpio)
@@ -336,28 +336,27 @@ mpc52xx_gpt_gpio_setup(struct mpc52xx_gpt_priv *gpt, struct device_node *node)
 	if (!of_find_property(node, "gpio-controller", NULL))
 		return;
 
-	gpt->of_gc.gc.label = kstrdup(node->full_name, GFP_KERNEL);
-	if (!gpt->of_gc.gc.label) {
+	gpt->gc.label = kstrdup(node->full_name, GFP_KERNEL);
+	if (!gpt->gc.label) {
 		dev_err(gpt->dev, "out of memory\n");
 		return;
 	}
 
-	gpt->of_gc.gpio_cells = 2;
-	gpt->of_gc.gc.ngpio = 1;
-	gpt->of_gc.gc.direction_input  = mpc52xx_gpt_gpio_dir_in;
-	gpt->of_gc.gc.direction_output = mpc52xx_gpt_gpio_dir_out;
-	gpt->of_gc.gc.get = mpc52xx_gpt_gpio_get;
-	gpt->of_gc.gc.set = mpc52xx_gpt_gpio_set;
-	gpt->of_gc.gc.base = -1;
-	gpt->of_gc.xlate = of_gpio_simple_xlate;
-	node->data = &gpt->of_gc;
+	gpt->gc.ngpio = 1;
+	gpt->gc.direction_input  = mpc52xx_gpt_gpio_dir_in;
+	gpt->gc.direction_output = mpc52xx_gpt_gpio_dir_out;
+	gpt->gc.get = mpc52xx_gpt_gpio_get;
+	gpt->gc.set = mpc52xx_gpt_gpio_set;
+	gpt->gc.base = -1;
+	gpt->gc.of_gpio_n_cells = 2;
+	gpt->gc.of_xlate = of_gpio_simple_xlate;
 	of_node_get(node);
 
 	/* Setup external pin in GPIO mode */
 	clrsetbits_be32(&gpt->regs->mode, MPC52xx_GPT_MODE_MS_MASK,
 			MPC52xx_GPT_MODE_MS_GPIO);
 
-	rc = gpiochip_add(&gpt->of_gc.gc);
+	rc = gpiochip_add(&gpt->gc);
 	if (rc)
 		dev_err(gpt->dev, "gpiochip_add() failed; rc=%i\n", rc);
 
diff --git a/arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c b/arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c
index d119a7c..e49f4bd 100644
--- a/arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c
+++ b/arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c
@@ -37,7 +37,7 @@ struct mcu {
 	struct mutex lock;
 	struct device_node *np;
 	struct i2c_client *client;
-	struct of_gpio_chip of_gc;
+	struct gpio_chip gc;
 	u8 reg_ctrl;
 };
 
@@ -56,8 +56,7 @@ static void mcu_power_off(void)
 
 static void mcu_gpio_set(struct gpio_chip *gc, unsigned int gpio, int val)
 {
-	struct of_gpio_chip *of_gc = to_of_gpio_chip(gc);
-	struct mcu *mcu = container_of(of_gc, struct mcu, of_gc);
+	struct mcu *mcu = container_of(gc, struct mcu, gc);
 	u8 bit = 1 << (4 + gpio);
 
 	mutex_lock(&mcu->lock);
@@ -79,8 +78,7 @@ static int mcu_gpio_dir_out(struct gpio_chip *gc, unsigned int gpio, int val)
 static int mcu_gpiochip_add(struct mcu *mcu)
 {
 	struct device_node *np;
-	struct of_gpio_chip *of_gc = &mcu->of_gc;
-	struct gpio_chip *gc = &of_gc->gc;
+	struct gpio_chip *gc = &mcu->gc;
 	int ret;
 
 	np = of_find_compatible_node(NULL, NULL, "fsl,mcu-mpc8349emitx");
@@ -94,10 +92,9 @@ static int mcu_gpiochip_add(struct mcu *mcu)
 	gc->base = -1;
 	gc->set = mcu_gpio_set;
 	gc->direction_output = mcu_gpio_dir_out;
-	of_gc->gpio_cells = 2;
-	of_gc->xlate = of_gpio_simple_xlate;
+	gc->of_gpio_n_cells = 2;
+	gc->of_xlate = of_gpio_simple_xlate;
 
-	np->data = of_gc;
 	mcu->np = np;
 
 	/*
@@ -114,7 +111,7 @@ static int mcu_gpiochip_remove(struct mcu *mcu)
 {
 	int ret;
 
-	ret = gpiochip_remove(&mcu->of_gc.gc);
+	ret = gpiochip_remove(&mcu->gc);
 	if (ret)
 		return ret;
 	of_node_put(mcu->np);
diff --git a/arch/powerpc/platforms/86xx/gef_gpio.c b/arch/powerpc/platforms/86xx/gef_gpio.c
index b8cb08d..4ff7b1e 100644
--- a/arch/powerpc/platforms/86xx/gef_gpio.c
+++ b/arch/powerpc/platforms/86xx/gef_gpio.c
@@ -118,12 +118,12 @@ static int __init gef_gpio_init(void)
 		}
 
 		/* Setup pointers to chip functions */
-		gef_gpio_chip->of_gc.gpio_cells = 2;
-		gef_gpio_chip->of_gc.gc.ngpio = 19;
-		gef_gpio_chip->of_gc.gc.direction_input = gef_gpio_dir_in;
-		gef_gpio_chip->of_gc.gc.direction_output = gef_gpio_dir_out;
-		gef_gpio_chip->of_gc.gc.get = gef_gpio_get;
-		gef_gpio_chip->of_gc.gc.set = gef_gpio_set;
+		gef_gpio_chip->gc.of_gpio_n_cells = 2;
+		gef_gpio_chip->gc.ngpio = 19;
+		gef_gpio_chip->gc.direction_input = gef_gpio_dir_in;
+		gef_gpio_chip->gc.direction_output = gef_gpio_dir_out;
+		gef_gpio_chip->gc.get = gef_gpio_get;
+		gef_gpio_chip->gc.set = gef_gpio_set;
 
 		/* This function adds a memory mapped GPIO chip */
 		retval = of_mm_gpiochip_add(np, gef_gpio_chip);
@@ -146,12 +146,12 @@ static int __init gef_gpio_init(void)
 		}
 
 		/* Setup pointers to chip functions */
-		gef_gpio_chip->of_gc.gpio_cells = 2;
-		gef_gpio_chip->of_gc.gc.ngpio = 6;
-		gef_gpio_chip->of_gc.gc.direction_input = gef_gpio_dir_in;
-		gef_gpio_chip->of_gc.gc.direction_output = gef_gpio_dir_out;
-		gef_gpio_chip->of_gc.gc.get = gef_gpio_get;
-		gef_gpio_chip->of_gc.gc.set = gef_gpio_set;
+		gef_gpio_chip->gc.of_gpio_n_cells = 2;
+		gef_gpio_chip->gc.ngpio = 6;
+		gef_gpio_chip->gc.direction_input = gef_gpio_dir_in;
+		gef_gpio_chip->gc.direction_output = gef_gpio_dir_out;
+		gef_gpio_chip->gc.get = gef_gpio_get;
+		gef_gpio_chip->gc.set = gef_gpio_set;
 
 		/* This function adds a memory mapped GPIO chip */
 		retval = of_mm_gpiochip_add(np, gef_gpio_chip);
diff --git a/arch/powerpc/sysdev/cpm1.c b/arch/powerpc/sysdev/cpm1.c
index 8d103ca..d5cf7d4 100644
--- a/arch/powerpc/sysdev/cpm1.c
+++ b/arch/powerpc/sysdev/cpm1.c
@@ -621,7 +621,6 @@ int cpm1_gpiochip_add16(struct device_node *np)
 {
 	struct cpm1_gpio16_chip *cpm1_gc;
 	struct of_mm_gpio_chip *mm_gc;
-	struct of_gpio_chip *of_gc;
 	struct gpio_chip *gc;
 
 	cpm1_gc = kzalloc(sizeof(*cpm1_gc), GFP_KERNEL);
@@ -631,11 +630,10 @@ int cpm1_gpiochip_add16(struct device_node *np)
 	spin_lock_init(&cpm1_gc->lock);
 
 	mm_gc = &cpm1_gc->mm_gc;
-	of_gc = &mm_gc->of_gc;
-	gc = &of_gc->gc;
+	gc = &mm_gc->gc;
 
 	mm_gc->save_regs = cpm1_gpio16_save_regs;
-	of_gc->gpio_cells = 2;
+	gc->of_gpio_n_cells = 2;
 	gc->ngpio = 16;
 	gc->direction_input = cpm1_gpio16_dir_in;
 	gc->direction_output = cpm1_gpio16_dir_out;
@@ -745,7 +743,6 @@ int cpm1_gpiochip_add32(struct device_node *np)
 {
 	struct cpm1_gpio32_chip *cpm1_gc;
 	struct of_mm_gpio_chip *mm_gc;
-	struct of_gpio_chip *of_gc;
 	struct gpio_chip *gc;
 
 	cpm1_gc = kzalloc(sizeof(*cpm1_gc), GFP_KERNEL);
@@ -755,11 +752,10 @@ int cpm1_gpiochip_add32(struct device_node *np)
 	spin_lock_init(&cpm1_gc->lock);
 
 	mm_gc = &cpm1_gc->mm_gc;
-	of_gc = &mm_gc->of_gc;
-	gc = &of_gc->gc;
+	gc = &mm_gc->gc;
 
 	mm_gc->save_regs = cpm1_gpio32_save_regs;
-	of_gc->gpio_cells = 2;
+	gc->of_gpio_n_cells = 2;
 	gc->ngpio = 32;
 	gc->direction_input = cpm1_gpio32_dir_in;
 	gc->direction_output = cpm1_gpio32_dir_out;
diff --git a/arch/powerpc/sysdev/cpm_common.c b/arch/powerpc/sysdev/cpm_common.c
index 88b9812..67e9b47 100644
--- a/arch/powerpc/sysdev/cpm_common.c
+++ b/arch/powerpc/sysdev/cpm_common.c
@@ -325,7 +325,6 @@ int cpm2_gpiochip_add32(struct device_node *np)
 {
 	struct cpm2_gpio32_chip *cpm2_gc;
 	struct of_mm_gpio_chip *mm_gc;
-	struct of_gpio_chip *of_gc;
 	struct gpio_chip *gc;
 
 	cpm2_gc = kzalloc(sizeof(*cpm2_gc), GFP_KERNEL);
@@ -335,11 +334,10 @@ int cpm2_gpiochip_add32(struct device_node *np)
 	spin_lock_init(&cpm2_gc->lock);
 
 	mm_gc = &cpm2_gc->mm_gc;
-	of_gc = &mm_gc->of_gc;
-	gc = &of_gc->gc;
+	gc = &mm_gc->gc;
 
 	mm_gc->save_regs = cpm2_gpio32_save_regs;
-	of_gc->gpio_cells = 2;
+	gc->of_gpio_n_cells = 2;
 	gc->ngpio = 32;
 	gc->direction_input = cpm2_gpio32_dir_in;
 	gc->direction_output = cpm2_gpio32_dir_out;
diff --git a/arch/powerpc/sysdev/mpc8xxx_gpio.c b/arch/powerpc/sysdev/mpc8xxx_gpio.c
index 83f5196..ec8fcd4 100644
--- a/arch/powerpc/sysdev/mpc8xxx_gpio.c
+++ b/arch/powerpc/sysdev/mpc8xxx_gpio.c
@@ -257,7 +257,6 @@ static void __init mpc8xxx_add_controller(struct device_node *np)
 {
 	struct mpc8xxx_gpio_chip *mpc8xxx_gc;
 	struct of_mm_gpio_chip *mm_gc;
-	struct of_gpio_chip *of_gc;
 	struct gpio_chip *gc;
 	unsigned hwirq;
 	int ret;
@@ -271,11 +270,10 @@ static void __init mpc8xxx_add_controller(struct device_node *np)
 	spin_lock_init(&mpc8xxx_gc->lock);
 
 	mm_gc = &mpc8xxx_gc->mm_gc;
-	of_gc = &mm_gc->of_gc;
-	gc = &of_gc->gc;
+	gc = &mm_gc->gc;
 
 	mm_gc->save_regs = mpc8xxx_gpio_save_regs;
-	of_gc->gpio_cells = 2;
+	gc->of_gpio_n_cells = 2;
 	gc->ngpio = MPC8XXX_GPIO_PINS;
 	gc->direction_input = mpc8xxx_gpio_dir_in;
 	gc->direction_output = mpc8xxx_gpio_dir_out;
diff --git a/arch/powerpc/sysdev/ppc4xx_gpio.c b/arch/powerpc/sysdev/ppc4xx_gpio.c
index 3812fc3..42e7a5e 100644
--- a/arch/powerpc/sysdev/ppc4xx_gpio.c
+++ b/arch/powerpc/sysdev/ppc4xx_gpio.c
@@ -181,7 +181,6 @@ static int __init ppc4xx_add_gpiochips(void)
 		int ret;
 		struct ppc4xx_gpio_chip *ppc4xx_gc;
 		struct of_mm_gpio_chip *mm_gc;
-		struct of_gpio_chip *of_gc;
 		struct gpio_chip *gc;
 
 		ppc4xx_gc = kzalloc(sizeof(*ppc4xx_gc), GFP_KERNEL);
@@ -193,10 +192,9 @@ static int __init ppc4xx_add_gpiochips(void)
 		spin_lock_init(&ppc4xx_gc->lock);
 
 		mm_gc = &ppc4xx_gc->mm_gc;
-		of_gc = &mm_gc->of_gc;
-		gc = &of_gc->gc;
+		gc = &mm_gc->gc;
 
-		of_gc->gpio_cells = 2;
+		gc->of_gpio_n_cells = 2;
 		gc->ngpio = 32;
 		gc->direction_input = ppc4xx_gpio_dir_in;
 		gc->direction_output = ppc4xx_gpio_dir_out;
diff --git a/arch/powerpc/sysdev/qe_lib/gpio.c b/arch/powerpc/sysdev/qe_lib/gpio.c
index dc8f8d6..194478c 100644
--- a/arch/powerpc/sysdev/qe_lib/gpio.c
+++ b/arch/powerpc/sysdev/qe_lib/gpio.c
@@ -138,8 +138,8 @@ struct qe_pin {
 struct qe_pin *qe_pin_request(struct device_node *np, int index)
 {
 	struct qe_pin *qe_pin;
-	struct device_node *gc;
-	struct of_gpio_chip *of_gc = NULL;
+	struct device_node *gpio_np;
+	struct gpio_chip *gc;
 	struct of_mm_gpio_chip *mm_gc;
 	struct qe_gpio_chip *qe_gc;
 	int err;
@@ -155,40 +155,40 @@ struct qe_pin *qe_pin_request(struct device_node *np, int index)
 	}
 
 	err = of_parse_phandles_with_args(np, "gpios", "#gpio-cells", index,
-					  &gc, &gpio_spec);
+					  &gpio_np, &gpio_spec);
 	if (err) {
 		pr_debug("%s: can't parse gpios property\n", __func__);
 		goto err0;
 	}
 
-	if (!of_device_is_compatible(gc, "fsl,mpc8323-qe-pario-bank")) {
+	if (!of_device_is_compatible(gpio_np, "fsl,mpc8323-qe-pario-bank")) {
 		pr_debug("%s: tried to get a non-qe pin\n", __func__);
 		err = -EINVAL;
 		goto err1;
 	}
 
-	of_gc = gc->data;
-	if (!of_gc) {
+	gc = gpio_np->data;
+	if (!gc) {
 		pr_debug("%s: gpio controller %s isn't registered\n",
-			 np->full_name, gc->full_name);
+			 np->full_name, gpio_np->full_name);
 		err = -ENODEV;
 		goto err1;
 	}
 
-	gpio_cells = of_get_property(gc, "#gpio-cells", &size);
+	gpio_cells = of_get_property(gpio_np, "#gpio-cells", &size);
 	if (!gpio_cells || size != sizeof(*gpio_cells) ||
-			*gpio_cells != of_gc->gpio_cells) {
+			*gpio_cells != gc->of_gpio_n_cells) {
 		pr_debug("%s: wrong #gpio-cells for %s\n",
-			 np->full_name, gc->full_name);
+			 np->full_name, gpio_np->full_name);
 		err = -EINVAL;
 		goto err1;
 	}
 
-	err = of_gc->xlate(of_gc, np, gpio_spec, NULL);
+	err = gc->of_xlate(gc, np, gpio_spec, NULL);
 	if (err < 0)
 		goto err1;
 
-	mm_gc = to_of_mm_gpio_chip(&of_gc->gc);
+	mm_gc = to_of_mm_gpio_chip(gc);
 	qe_gc = to_qe_gpio_chip(mm_gc);
 
 	spin_lock_irqsave(&qe_gc->lock, flags);
@@ -206,7 +206,7 @@ struct qe_pin *qe_pin_request(struct device_node *np, int index)
 	if (!err)
 		return qe_pin;
 err1:
-	of_node_put(gc);
+	of_node_put(gpio_np);
 err0:
 	kfree(qe_pin);
 	pr_debug("%s failed with status %d\n", __func__, err);
@@ -307,7 +307,6 @@ static int __init qe_add_gpiochips(void)
 		int ret;
 		struct qe_gpio_chip *qe_gc;
 		struct of_mm_gpio_chip *mm_gc;
-		struct of_gpio_chip *of_gc;
 		struct gpio_chip *gc;
 
 		qe_gc = kzalloc(sizeof(*qe_gc), GFP_KERNEL);
@@ -319,11 +318,10 @@ static int __init qe_add_gpiochips(void)
 		spin_lock_init(&qe_gc->lock);
 
 		mm_gc = &qe_gc->mm_gc;
-		of_gc = &mm_gc->of_gc;
-		gc = &of_gc->gc;
+		gc = &mm_gc->gc;
 
 		mm_gc->save_regs = qe_gpio_save_regs;
-		of_gc->gpio_cells = 2;
+		gc->of_gpio_n_cells = 2;
 		gc->ngpio = QE_PIO_PINS;
 		gc->direction_input = qe_gpio_dir_in;
 		gc->direction_output = qe_gpio_dir_out;
diff --git a/arch/powerpc/sysdev/simple_gpio.c b/arch/powerpc/sysdev/simple_gpio.c
index d5fb173..b7559aa 100644
--- a/arch/powerpc/sysdev/simple_gpio.c
+++ b/arch/powerpc/sysdev/simple_gpio.c
@@ -91,7 +91,6 @@ static int __init u8_simple_gpiochip_add(struct device_node *np)
 	int ret;
 	struct u8_gpio_chip *u8_gc;
 	struct of_mm_gpio_chip *mm_gc;
-	struct of_gpio_chip *of_gc;
 	struct gpio_chip *gc;
 
 	u8_gc = kzalloc(sizeof(*u8_gc), GFP_KERNEL);
@@ -101,11 +100,10 @@ static int __init u8_simple_gpiochip_add(struct device_node *np)
 	spin_lock_init(&u8_gc->lock);
 
 	mm_gc = &u8_gc->mm_gc;
-	of_gc = &mm_gc->of_gc;
-	gc = &of_gc->gc;
+	gc = &mm_gc->gc;
 
 	mm_gc->save_regs = u8_gpio_save_regs;
-	of_gc->gpio_cells = 2;
+	gc->of_gpio_n_cells = 2;
 	gc->ngpio = 8;
 	gc->direction_input = u8_gpio_dir_in;
 	gc->direction_output = u8_gpio_dir_out;
diff --git a/drivers/gpio/xilinx_gpio.c b/drivers/gpio/xilinx_gpio.c
index b8fa65b..2993c40 100644
--- a/drivers/gpio/xilinx_gpio.c
+++ b/drivers/gpio/xilinx_gpio.c
@@ -161,14 +161,12 @@ static void xgpio_save_regs(struct of_mm_gpio_chip *mm_gc)
 static int __devinit xgpio_of_probe(struct device_node *np)
 {
 	struct xgpio_instance *chip;
-	struct of_gpio_chip *ofchip;
 	int status = 0;
 	const u32 *tree_info;
 
 	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
 	if (!chip)
 		return -ENOMEM;
-	ofchip = &chip->mmchip.of_gc;
 
 	/* Update GPIO state shadow register with default value */
 	tree_info = of_get_property(np, "xlnx,dout-default", NULL);
@@ -182,21 +180,21 @@ static int __devinit xgpio_of_probe(struct device_node *np)
 		chip->gpio_dir = *tree_info;
 
 	/* Check device node and parent device node for device width */
-	ofchip->gc.ngpio = 32; /* By default assume full GPIO controller */
+	chip->mmchip.gc.ngpio = 32; /* By default assume full GPIO controller */
 	tree_info = of_get_property(np, "xlnx,gpio-width", NULL);
 	if (!tree_info)
 		tree_info = of_get_property(np->parent,
 					    "xlnx,gpio-width", NULL);
 	if (tree_info)
-		ofchip->gc.ngpio = *tree_info;
+		chip->mmchip.gc.ngpio = *tree_info;
 
 	spin_lock_init(&chip->gpio_lock);
 
-	ofchip->gpio_cells = 2;
-	ofchip->gc.direction_input = xgpio_dir_in;
-	ofchip->gc.direction_output = xgpio_dir_out;
-	ofchip->gc.get = xgpio_get;
-	ofchip->gc.set = xgpio_set;
+	chip->mmchip.gc.of_gpio_n_cells = 2;
+	chip->mmchip.gc.direction_input = xgpio_dir_in;
+	chip->mmchip.gc.direction_output = xgpio_dir_out;
+	chip->mmchip.gc.get = xgpio_get;
+	chip->mmchip.gc.set = xgpio_set;
 
 	chip->mmchip.save_regs = xgpio_save_regs;
 
diff --git a/drivers/of/gpio.c b/drivers/of/gpio.c
index a1b31a4..fde53a3 100644
--- a/drivers/of/gpio.c
+++ b/drivers/of/gpio.c
@@ -33,32 +33,32 @@ int of_get_gpio_flags(struct device_node *np, int index,
 		      enum of_gpio_flags *flags)
 {
 	int ret;
-	struct device_node *gc;
-	struct of_gpio_chip *of_gc = NULL;
+	struct device_node *gpio_np;
+	struct gpio_chip *gc;
 	int size;
 	const void *gpio_spec;
 	const __be32 *gpio_cells;
 
 	ret = of_parse_phandles_with_args(np, "gpios", "#gpio-cells", index,
-					  &gc, &gpio_spec);
+					  &gpio_np, &gpio_spec);
 	if (ret) {
 		pr_debug("%s: can't parse gpios property\n", __func__);
 		goto err0;
 	}
 
-	of_gc = gc->data;
-	if (!of_gc) {
+	gc = gpio_np->data;
+	if (!gc) {
 		pr_debug("%s: gpio controller %s isn't registered\n",
-			 np->full_name, gc->full_name);
+			 np->full_name, gpio_np->full_name);
 		ret = -ENODEV;
 		goto err1;
 	}
 
-	gpio_cells = of_get_property(gc, "#gpio-cells", &size);
+	gpio_cells = of_get_property(gpio_np, "#gpio-cells", &size);
 	if (!gpio_cells || size != sizeof(*gpio_cells) ||
-			be32_to_cpup(gpio_cells) != of_gc->gpio_cells) {
+			be32_to_cpup(gpio_cells) != gc->of_gpio_n_cells) {
 		pr_debug("%s: wrong #gpio-cells for %s\n",
-			 np->full_name, gc->full_name);
+			 np->full_name, gpio_np->full_name);
 		ret = -EINVAL;
 		goto err1;
 	}
@@ -67,13 +67,13 @@ int of_get_gpio_flags(struct device_node *np, int index,
 	if (flags)
 		*flags = 0;
 
-	ret = of_gc->xlate(of_gc, np, gpio_spec, flags);
+	ret = gc->of_xlate(gc, np, gpio_spec, flags);
 	if (ret < 0)
 		goto err1;
 
-	ret += of_gc->gc.base;
+	ret += gc->base;
 err1:
-	of_node_put(gc);
+	of_node_put(gpio_np);
 err0:
 	pr_debug("%s exited with status %d\n", __func__, ret);
 	return ret;
@@ -116,7 +116,7 @@ EXPORT_SYMBOL(of_gpio_count);
 
 /**
  * of_gpio_simple_xlate - translate gpio_spec to the GPIO number and flags
- * @of_gc:	pointer to the of_gpio_chip structure
+ * @gc:		pointer to the gpio_chip structure
  * @np:		device node of the GPIO chip
  * @gpio_spec:	gpio specifier as found in the device tree
  * @flags:	a flags pointer to fill in
@@ -125,8 +125,8 @@ EXPORT_SYMBOL(of_gpio_count);
  * gpio chips. This function performs only one sanity check: whether gpio
  * is less than ngpios (that is specified in the gpio_chip).
  */
-int of_gpio_simple_xlate(struct of_gpio_chip *of_gc, struct device_node *np,
-			 const void *gpio_spec, enum of_gpio_flags *flags)
+int of_gpio_simple_xlate(struct gpio_chip *gc, struct device_node *np,
+			 const void *gpio_spec, u32 *flags)
 {
 	const __be32 *gpio = gpio_spec;
 	const u32 n = be32_to_cpup(gpio);
@@ -137,12 +137,12 @@ int of_gpio_simple_xlate(struct of_gpio_chip *of_gc, struct device_node *np,
 	 * number and the flags from a single gpio cell -- this is possible,
 	 * but not recommended).
 	 */
-	if (of_gc->gpio_cells < 2) {
+	if (gc->of_gpio_n_cells < 2) {
 		WARN_ON(1);
 		return -EINVAL;
 	}
 
-	if (n > of_gc->gc.ngpio)
+	if (n > gc->ngpio)
 		return -EINVAL;
 
 	if (flags)
@@ -161,10 +161,8 @@ EXPORT_SYMBOL(of_gpio_simple_xlate);
  *
  * 1) In the gpio_chip structure:
  *    - all the callbacks
- *
- * 2) In the of_gpio_chip structure:
- *    - gpio_cells
- *    - xlate callback (optional)
+ *    - of_gpio_n_cells
+ *    - of_xlate callback (optional)
  *
  * 3) In the of_mm_gpio_chip structure:
  *    - save_regs callback (optional)
@@ -177,8 +175,7 @@ int of_mm_gpiochip_add(struct device_node *np,
 		       struct of_mm_gpio_chip *mm_gc)
 {
 	int ret = -ENOMEM;
-	struct of_gpio_chip *of_gc = &mm_gc->of_gc;
-	struct gpio_chip *gc = &of_gc->gc;
+	struct gpio_chip *gc = &mm_gc->gc;
 
 	gc->label = kstrdup(np->full_name, GFP_KERNEL);
 	if (!gc->label)
@@ -190,13 +187,14 @@ int of_mm_gpiochip_add(struct device_node *np,
 
 	gc->base = -1;
 
-	if (!of_gc->xlate)
-		of_gc->xlate = of_gpio_simple_xlate;
+	if (!gc->of_xlate)
+		gc->of_xlate = of_gpio_simple_xlate;
 
 	if (mm_gc->save_regs)
 		mm_gc->save_regs(mm_gc);
 
-	np->data = of_gc;
+	np->data = &mm_gc->gc;
+	mm_gc->gc.of_node = np;
 
 	ret = gpiochip_add(gc);
 	if (ret)
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index 4f3d75e..af2544e 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -31,6 +31,7 @@ static inline int gpio_is_valid(int number)
 struct device;
 struct seq_file;
 struct module;
+struct device_node;
 
 /**
  * struct gpio_chip - abstract a GPIO controller
@@ -106,6 +107,17 @@ struct gpio_chip {
 	const char		*const *names;
 	unsigned		can_sleep:1;
 	unsigned		exported:1;
+
+#if defined(CONFIG_OF_GPIO)
+	/*
+	 * If CONFIG_OF is enabled, then all GPIO controllers described in the
+	 * device tree automatically may have an OF translation
+	 */
+	struct device_node *of_node;
+	int of_gpio_n_cells;
+	int (*of_xlate)(struct gpio_chip *gc, struct device_node *np,
+		        const void *gpio_spec, u32 *flags);
+#endif
 };
 
 extern const char *gpiochip_is_requested(struct gpio_chip *chip,
diff --git a/include/linux/of_gpio.h b/include/linux/of_gpio.h
index fc2472c..460d681 100644
--- a/include/linux/of_gpio.h
+++ b/include/linux/of_gpio.h
@@ -33,34 +33,17 @@ enum of_gpio_flags {
 #ifdef CONFIG_OF_GPIO
 
 /*
- * Generic OF GPIO chip
- */
-struct of_gpio_chip {
-	struct gpio_chip gc;
-	int gpio_cells;
-	int (*xlate)(struct of_gpio_chip *of_gc, struct device_node *np,
-		     const void *gpio_spec, enum of_gpio_flags *flags);
-};
-
-static inline struct of_gpio_chip *to_of_gpio_chip(struct gpio_chip *gc)
-{
-	return container_of(gc, struct of_gpio_chip, gc);
-}
-
-/*
  * OF GPIO chip for memory mapped banks
  */
 struct of_mm_gpio_chip {
-	struct of_gpio_chip of_gc;
+	struct gpio_chip gc;
 	void (*save_regs)(struct of_mm_gpio_chip *mm_gc);
 	void __iomem *regs;
 };
 
 static inline struct of_mm_gpio_chip *to_of_mm_gpio_chip(struct gpio_chip *gc)
 {
-	struct of_gpio_chip *of_gc = to_of_gpio_chip(gc);
-
-	return container_of(of_gc, struct of_mm_gpio_chip, of_gc);
+	return container_of(gc, struct of_mm_gpio_chip, gc);
 }
 
 extern int of_get_gpio_flags(struct device_node *np, int index,
@@ -69,11 +52,9 @@ extern unsigned int of_gpio_count(struct device_node *np);
 
 extern int of_mm_gpiochip_add(struct device_node *np,
 			      struct of_mm_gpio_chip *mm_gc);
-extern int of_gpio_simple_xlate(struct of_gpio_chip *of_gc,
-				struct device_node *np,
-				const void *gpio_spec,
-				enum of_gpio_flags *flags);
-#else
+extern int of_gpio_simple_xlate(struct gpio_chip *gc, struct device_node *np,
+				const void *gpio_spec, u32 *flags);
+#else /* CONFIG_OF_GPIO */
 
 /* Drivers may not strictly depend on the GPIO support, so let them link. */
 static inline int of_get_gpio_flags(struct device_node *np, int index,

