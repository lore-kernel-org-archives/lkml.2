Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641Ab1HHFVf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 01:21:35 -0400
Received: from cluster-d.mailcontrol.com ([85.115.60.190]:54787 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab1HHFVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 01:21:32 -0400
From: Barry Song <Baohua.Song@csr.com>
To: <grant.likely@secretlab.ca>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <workgroup.linux@csr.com>, Barry Song <Baohua.Song@csr.com>
Subject: [PATCH] GPIOLIB: add generic gpio_set_pull API
Date: Sun, 7 Aug 2011 22:19:33 -0700
Message-ID: <1312780773-23142-1-git-send-email-Baohua.Song@csr.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.125.36.59]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now there are many different implementations for GPIO pull configuration, for
example:
s3c_gpio_setpull()
tegra_pinmux_set_pullupdown()
chipcHw_setPinPullup()
gpio_pullup()
s3c2410_gpio_pullup()

This patch adds a new generic gpio_set_pull API so that all SoCs can have unified
codes.

Signed-off-by: Barry Song <Baohua.Song@csr.com>
---
 drivers/gpio/gpiolib.c     |   17 +++++++++++++++++
 include/asm-generic/gpio.h |    3 +++
 include/linux/gpio.h       |    4 ++++
 3 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index a971e3d..a2afa95 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1620,6 +1620,23 @@ int __gpio_to_irq(unsigned gpio)
 }
 EXPORT_SYMBOL_GPL(__gpio_to_irq);
 
+/**
+ * __gpio_set_pull() - set pull up, pull down or no pull for a gpio
+ * @gpio: gpio which will be configurated
+ * @mode: one of GPIO_PULL_NONE, GPIO_PULL_UP and GPIO_PULL_DOWN
+ * Context: any
+ *
+ * This is used directly or indirectly to implement gpio_set_pull().
+ */
+void __gpio_set_pull(unsigned gpio, unsigned mode)
+{
+	struct gpio_chip	*chip;
+
+	chip = gpio_to_chip(gpio);
+
+	chip->pull(chip, gpio, mode);
+}
+EXPORT_SYMBOL_GPL(__gpio_set_pull);
 
 
 /* There's no value in making it easy to inline GPIO calls that may sleep.
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index d494001..f953835 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -112,6 +112,9 @@ struct gpio_chip {
 	int			(*to_irq)(struct gpio_chip *chip,
 						unsigned offset);
 
+	void			(*pull)(struct gpio_chip *chip,
+						unsigned offset, unsigned mode);
+
 	void			(*dbg_show)(struct seq_file *s,
 						struct gpio_chip *chip);
 	int			base;
diff --git a/include/linux/gpio.h b/include/linux/gpio.h
index 17b5a0d..ac48166 100644
--- a/include/linux/gpio.h
+++ b/include/linux/gpio.h
@@ -14,6 +14,10 @@
 #define GPIOF_OUT_INIT_LOW	(GPIOF_DIR_OUT | GPIOF_INIT_LOW)
 #define GPIOF_OUT_INIT_HIGH	(GPIOF_DIR_OUT | GPIOF_INIT_HIGH)
 
+#define GPIO_PULL_NONE	0
+#define GPIO_PULL_UP	1
+#define GPIO_PULL_DOWN	2
+
 #ifdef CONFIG_GENERIC_GPIO
 #include <asm/gpio.h>
 
-- 
1.7.1



Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
More information can be found at www.csr.com. Follow CSR on Twitter at http://twitter.com/CSR_PLC and read our blog at www.csr.com/blog
