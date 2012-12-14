Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147Ab2LNQTw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 11:19:52 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:33675 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756538Ab2LNQTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 11:19:50 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, Philippe Langlais <philippe.langlais@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 01/21] gpio: ab8500: Activate and port AB8500 GPIO driver to new framework
Date: Fri, 14 Dec 2012 16:19:19 +0000
Message-Id: <1355501979-1157-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355501979-1157-1-git-send-email-lee.jones@linaro.org>
References: <1355501979-1157-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philippe Langlais <philippe.langlais@linaro.org>

The AB8500 GPIO driver is currently marked as broken, as it's still
using the old framework. This patch brings it back up to scratch and
enables it so we can make good use of it once more.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Philippe Langlais <philippe.langlais@linaro.org>
---
 drivers/gpio/Kconfig       |    2 +-
 drivers/gpio/gpio-ab8500.c |   60 +++++++++++++++++++++++---------------------
 2 files changed, 32 insertions(+), 30 deletions(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 47150f5..6bf9575 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -624,7 +624,7 @@ config GPIO_JANZ_TTL
 
 config GPIO_AB8500
 	bool "ST-Ericsson AB8500 Mixed Signal Circuit gpio functions"
-	depends on AB8500_CORE && BROKEN
+	depends on AB8500_CORE
 	help
 	  Select this to enable the AB8500 IC GPIO driver
 
diff --git a/drivers/gpio/gpio-ab8500.c b/drivers/gpio/gpio-ab8500.c
index 050c05d..db40acb 100644
--- a/drivers/gpio/gpio-ab8500.c
+++ b/drivers/gpio/gpio-ab8500.c
@@ -207,7 +207,7 @@ static struct gpio_chip ab8500gpio_chip = {
 
 static unsigned int irq_to_rising(unsigned int irq)
 {
-	struct ab8500_gpio *ab8500_gpio = get_irq_chip_data(irq);
+	struct ab8500_gpio *ab8500_gpio = irq_get_chip_data(irq);
 	int offset = irq - ab8500_gpio->irq_base;
 	int new_irq = offset +  AB8500_INT_GPIO6R
 			+ ab8500_gpio->parent->irq_base;
@@ -216,7 +216,7 @@ static unsigned int irq_to_rising(unsigned int irq)
 
 static unsigned int irq_to_falling(unsigned int irq)
 {
-	struct ab8500_gpio *ab8500_gpio = get_irq_chip_data(irq);
+	struct ab8500_gpio *ab8500_gpio = irq_get_chip_data(irq);
 	int offset = irq - ab8500_gpio->irq_base;
 	int new_irq = offset +  AB8500_INT_GPIO6F
 			+  ab8500_gpio->parent->irq_base;
@@ -261,15 +261,16 @@ static irqreturn_t handle_falling(int irq, void *dev)
 	return IRQ_HANDLED;
 }
 
-static void ab8500_gpio_irq_lock(unsigned int irq)
+static void ab8500_gpio_irq_lock(struct irq_data *data)
 {
-	struct ab8500_gpio *ab8500_gpio = get_irq_chip_data(irq);
+	struct ab8500_gpio *ab8500_gpio = irq_data_get_irq_chip_data(data);
 	mutex_lock(&ab8500_gpio->lock);
 }
 
-static void ab8500_gpio_irq_sync_unlock(unsigned int irq)
+static void ab8500_gpio_irq_sync_unlock(struct irq_data *data)
 {
-	struct ab8500_gpio *ab8500_gpio = get_irq_chip_data(irq);
+	struct ab8500_gpio *ab8500_gpio = irq_data_get_irq_chip_data(data);
+	unsigned int irq = data->irq;
 	int offset = irq - ab8500_gpio->irq_base;
 	bool rising = ab8500_gpio->rising & BIT(offset);
 	bool falling = ab8500_gpio->falling & BIT(offset);
@@ -316,21 +317,22 @@ static void ab8500_gpio_irq_sync_unlock(unsigned int irq)
 }
 
 
-static void ab8500_gpio_irq_mask(unsigned int irq)
+static void ab8500_gpio_irq_mask(struct irq_data *data)
 {
-	struct ab8500_gpio *ab8500_gpio = get_irq_chip_data(irq);
+	struct ab8500_gpio *ab8500_gpio = irq_data_get_irq_chip_data(data);
 	ab8500_gpio->irq_action = MASK;
 }
 
-static void ab8500_gpio_irq_unmask(unsigned int irq)
+static void ab8500_gpio_irq_unmask(struct irq_data *data)
 {
-	struct ab8500_gpio *ab8500_gpio = get_irq_chip_data(irq);
+	struct ab8500_gpio *ab8500_gpio =  irq_data_get_irq_chip_data(data);
 	ab8500_gpio->irq_action = UNMASK;
 }
 
-static int ab8500_gpio_irq_set_type(unsigned int irq, unsigned int type)
+static int ab8500_gpio_irq_set_type(struct irq_data *data, unsigned int type)
 {
-	struct ab8500_gpio *ab8500_gpio = get_irq_chip_data(irq);
+	struct ab8500_gpio *ab8500_gpio = irq_data_get_irq_chip_data(data);
+	unsigned int irq = data->irq;
 	int offset = irq - ab8500_gpio->irq_base;
 
 	if (type == IRQ_TYPE_EDGE_BOTH) {
@@ -344,28 +346,28 @@ static int ab8500_gpio_irq_set_type(unsigned int irq, unsigned int type)
 	return 0;
 }
 
-unsigned int ab8500_gpio_irq_startup(unsigned int irq)
+unsigned int ab8500_gpio_irq_startup(struct irq_data *data)
 {
-	struct ab8500_gpio *ab8500_gpio = get_irq_chip_data(irq);
+	struct ab8500_gpio *ab8500_gpio = irq_data_get_irq_chip_data(data);
 	ab8500_gpio->irq_action = STARTUP;
 	return 0;
 }
 
-void ab8500_gpio_irq_shutdown(unsigned int irq)
+void ab8500_gpio_irq_shutdown(struct irq_data *data)
 {
-	struct ab8500_gpio *ab8500_gpio = get_irq_chip_data(irq);
+	struct ab8500_gpio *ab8500_gpio = irq_data_get_irq_chip_data(data);
 	ab8500_gpio->irq_action = SHUTDOWN;
 }
 
 static struct irq_chip ab8500_gpio_irq_chip = {
 	.name			= "ab8500-gpio",
-	.startup		= ab8500_gpio_irq_startup,
-	.shutdown		= ab8500_gpio_irq_shutdown,
-	.bus_lock		= ab8500_gpio_irq_lock,
-	.bus_sync_unlock	= ab8500_gpio_irq_sync_unlock,
-	.mask			= ab8500_gpio_irq_mask,
-	.unmask			= ab8500_gpio_irq_unmask,
-	.set_type		= ab8500_gpio_irq_set_type,
+	.irq_startup		= ab8500_gpio_irq_startup,
+	.irq_shutdown		= ab8500_gpio_irq_shutdown,
+	.irq_bus_lock		= ab8500_gpio_irq_lock,
+	.irq_bus_sync_unlock	= ab8500_gpio_irq_sync_unlock,
+	.irq_mask		= ab8500_gpio_irq_mask,
+	.irq_unmask		= ab8500_gpio_irq_unmask,
+	.irq_set_type		= ab8500_gpio_irq_set_type,
 };
 
 static int ab8500_gpio_irq_init(struct ab8500_gpio *ab8500_gpio)
@@ -374,14 +376,14 @@ static int ab8500_gpio_irq_init(struct ab8500_gpio *ab8500_gpio)
 	int irq;
 
 	for (irq = base; irq < base + AB8500_NUM_VIR_GPIO_IRQ ; irq++) {
-		set_irq_chip_data(irq, ab8500_gpio);
-		set_irq_chip_and_handler(irq, &ab8500_gpio_irq_chip,
+		irq_set_chip_data(irq, ab8500_gpio);
+		irq_set_chip_and_handler(irq, &ab8500_gpio_irq_chip,
 				handle_simple_irq);
-		set_irq_nested_thread(irq, 1);
+		irq_set_nested_thread(irq, 1);
 #ifdef CONFIG_ARM
 		set_irq_flags(irq, IRQF_VALID);
 #else
-		set_irq_noprobe(irq);
+		irq_set_noprobe(irq);
 #endif
 	}
 
@@ -397,8 +399,8 @@ static void ab8500_gpio_irq_remove(struct ab8500_gpio *ab8500_gpio)
 #ifdef CONFIG_ARM
 		set_irq_flags(irq, 0);
 #endif
-		set_irq_chip_and_handler(irq, NULL, NULL);
-		set_irq_chip_data(irq, NULL);
+		irq_set_chip_and_handler(irq, NULL, NULL);
+		irq_set_chip_data(irq, NULL);
 	}
 }
 
-- 
1.7.9.5

