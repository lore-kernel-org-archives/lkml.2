Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab1LLUOh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 15:14:37 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:36061 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081Ab1LLUOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 15:14:33 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.olzabs.org
Cc: microblaze-uclinux@itee.uq.edu.au,
        Grant Likely <grant.likely@secretlab.ca>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kumar Gala <galak@kernel.crashing.org>
Subject: [PATCH 2/4] gpio/powerpc: Eliminate duplication of of_get_named_gpio_flags()
Date: Mon, 12 Dec 2011 13:14:10 -0700
Message-Id: <1323720852-26311-3-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323720852-26311-1-git-send-email-grant.likely@secretlab.ca>
References: <1323720852-26311-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A large chunk of qe_pin_request() is unnecessarily cut-and-paste
directly from of_get_named_gpio_flags().  This patch cuts out the
duplicate code and replaces it with a call to of_get_gpio().

v2: fixed compile error due to missing gpio_to_chip()

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Kumar Gala <galak@kernel.crashing.org>
---
 arch/powerpc/sysdev/qe_lib/gpio.c |   42 +++++++-----------------------------
 drivers/gpio/gpiolib.c            |    2 +-
 include/asm-generic/gpio.h        |    1 +
 3 files changed, 10 insertions(+), 35 deletions(-)

diff --git a/arch/powerpc/sysdev/qe_lib/gpio.c b/arch/powerpc/sysdev/qe_lib/gpio.c
index e23f23c..521e67a 100644
--- a/arch/powerpc/sysdev/qe_lib/gpio.c
+++ b/arch/powerpc/sysdev/qe_lib/gpio.c
@@ -139,14 +139,10 @@ struct qe_pin {
 struct qe_pin *qe_pin_request(struct device_node *np, int index)
 {
 	struct qe_pin *qe_pin;
-	struct device_node *gpio_np;
 	struct gpio_chip *gc;
 	struct of_mm_gpio_chip *mm_gc;
 	struct qe_gpio_chip *qe_gc;
 	int err;
-	int size;
-	const void *gpio_spec;
-	const u32 *gpio_cells;
 	unsigned long flags;
 
 	qe_pin = kzalloc(sizeof(*qe_pin), GFP_KERNEL);
@@ -155,45 +151,25 @@ struct qe_pin *qe_pin_request(struct device_node *np, int index)
 		return ERR_PTR(-ENOMEM);
 	}
 
-	err = of_parse_phandles_with_args(np, "gpios", "#gpio-cells", index,
-					  &gpio_np, &gpio_spec);
-	if (err) {
-		pr_debug("%s: can't parse gpios property\n", __func__);
+	err = of_get_gpio(np, index);
+	if (err < 0)
+		goto err0;
+	gc = gpio_to_chip(err);
+	if (WARN_ON(!gc))
 		goto err0;
-	}
 
-	if (!of_device_is_compatible(gpio_np, "fsl,mpc8323-qe-pario-bank")) {
+	if (!of_device_is_compatible(gc->of_node, "fsl,mpc8323-qe-pario-bank")) {
 		pr_debug("%s: tried to get a non-qe pin\n", __func__);
 		err = -EINVAL;
-		goto err1;
-	}
-
-	gc = of_node_to_gpiochip(gpio_np);
-	if (!gc) {
-		pr_debug("%s: gpio controller %s isn't registered\n",
-			 np->full_name, gpio_np->full_name);
-		err = -ENODEV;
-		goto err1;
-	}
-
-	gpio_cells = of_get_property(gpio_np, "#gpio-cells", &size);
-	if (!gpio_cells || size != sizeof(*gpio_cells) ||
-			*gpio_cells != gc->of_gpio_n_cells) {
-		pr_debug("%s: wrong #gpio-cells for %s\n",
-			 np->full_name, gpio_np->full_name);
-		err = -EINVAL;
-		goto err1;
+		goto err0;
 	}
 
-	err = gc->of_xlate(gc, np, gpio_spec, NULL);
-	if (err < 0)
-		goto err1;
-
 	mm_gc = to_of_mm_gpio_chip(gc);
 	qe_gc = to_qe_gpio_chip(mm_gc);
 
 	spin_lock_irqsave(&qe_gc->lock, flags);
 
+	err -= gc->base;
 	if (test_and_set_bit(QE_PIN_REQUESTED, &qe_gc->pin_flags[err]) == 0) {
 		qe_pin->controller = qe_gc;
 		qe_pin->num = err;
@@ -206,8 +182,6 @@ struct qe_pin *qe_pin_request(struct device_node *np, int index)
 
 	if (!err)
 		return qe_pin;
-err1:
-	of_node_put(gpio_np);
 err0:
 	kfree(qe_pin);
 	pr_debug("%s failed with status %d\n", __func__, err);
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index a971e3d..dc315e9 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -114,7 +114,7 @@ static int gpio_ensure_requested(struct gpio_desc *desc, unsigned offset)
 }
 
 /* caller holds gpio_lock *OR* gpio is marked as requested */
-static inline struct gpio_chip *gpio_to_chip(unsigned gpio)
+struct gpio_chip *gpio_to_chip(unsigned gpio)
 {
 	return gpio_desc[gpio].chip;
 }
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index 8c86210..6b10bdc 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -135,6 +135,7 @@ struct gpio_chip {
 
 extern const char *gpiochip_is_requested(struct gpio_chip *chip,
 			unsigned offset);
+extern struct gpio_chip *gpio_to_chip(unsigned gpio);
 extern int __must_check gpiochip_reserve(int start, int ngpio);
 
 /* add/remove chips */
-- 
1.7.5.4

