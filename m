Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439Ab2JEMU5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 08:20:57 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:35183 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932193Ab2JEMU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 08:20:56 -0400
MIME-Version: 1.0
Date: Fri, 5 Oct 2012 14:20:55 +0200
Message-ID: <CAEk6gTD-Qqdm24VuPpLd9WCRG5NEwAZxi5V1_p-gMj1hhb+Krg@mail.gmail.com>
Subject: [PATCH][GPIO] Add IRQ edge setter to gpiolib
From: Drasko DRASKOVIC <drasko.draskovic@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, linus.walleij@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
please find a patch that adds IRQ edge set-up mechanism to sysfs that
can be called from the kernel.

This functionality can be very useful for embedded systems, as it
permits kernel to do GPIO set-up during boot stage. Configuration
which defines pins behavior is often kept in NVRAM, and during boot
stage these structures can be parsed and executed by the kernel, so
that when user processes already find all sysfs environment ready and
correctly set-up.

While at the present it is possible to export GPIO pins to sysfs (and
correct direction / value), it is not possible to export IRQ
configuration as well, so this must be done in user space (most often
via command line). this patch implements missing functionality, so
that  gpio_sysfs_set_edge() function can be called directly from the
kernel.

Best regards,
Drasko


---


>From eb07313ffb53b8ea080dbcc7400e0ec1a57c836e Mon Sep 17 00:00:00 2001
From: Drasko DRASKOVIC <drasko.draskovic@gmail.com>
Date: Fri, 5 Oct 2012 11:59:47 +0200
Subject: [PATCH] [PATCH][GPIO] Add IRQ edge setter to gpiolib Signed-off-by:
 Drasko DRASKOVIC <drasko.draskovic@gmail.com>

---
 Documentation/gpio.txt     |    3 ++
 drivers/gpio/gpiolib.c     |   70 ++++++++++++++++++++++++++++++++++++++++++++
 include/asm-generic/gpio.h |    5 +++
 3 files changed, 78 insertions(+), 0 deletions(-)

diff --git a/Documentation/gpio.txt b/Documentation/gpio.txt
index e08a883..8db95e1 100644
--- a/Documentation/gpio.txt
+++ b/Documentation/gpio.txt
@@ -712,6 +712,9 @@ requested using gpio_request():
 	/* change the polarity of a GPIO node in sysfs */
 	int gpio_sysfs_set_active_low(unsigned gpio, int value);

+	/* change the irq edge of a GPIO node in sysfs */
+	gpio_sysfs_set_edge(unsigned gpio, unsigned int irq_type);
+
 After a kernel driver requests a GPIO, it may only be made available in
 the sysfs interface by gpio_export().  The driver can control whether the
 signal direction may change.  This helps drivers prevent userspace code
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 5d6c71e..9b07d67 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -820,6 +820,76 @@ EXPORT_SYMBOL_GPL(gpio_export_link);


 /**
+ * gpio_sysfs_set_edge - sets irq edge type for an exported GPIO node
+ * @gpio: gpio to set-up edge to, already exported
+ * @irq_type: irq type to be set
+ *
+ * Returns zero on success, else an error.
+ */
+int gpio_sysfs_set_edge(unsigned gpio, unsigned int irq_type)
+{
+	struct gpio_desc        *desc;
+	struct device           *dev = NULL;
+	int                     status = -EINVAL;
+	unsigned long           trigger_flags = 0;
+
+	if (!gpio_is_valid(gpio))
+		goto done;
+
+	mutex_lock(&sysfs_lock);
+
+	desc = &gpio_desc[gpio];
+
+	if (test_bit(FLAG_EXPORT, &desc->flags)) {
+		dev = class_find_device(&gpio_class, NULL, desc, match_export);
+		if (dev == NULL) {
+			status = -ENODEV;
+			goto unlock;
+		}
+	}
+
+	switch (irq_type) {
+		case IRQ_TYPE_NONE:
+			trigger_flags = 0;
+			break;
+		case IRQ_TYPE_EDGE_FALLING:
+			trigger_flags = BIT(FLAG_TRIG_FALL);
+			break;
+		case IRQ_TYPE_EDGE_RISING:
+			trigger_flags = BIT(FLAG_TRIG_RISE);
+			break;
+		case IRQ_TYPE_EDGE_BOTH:
+			trigger_flags = BIT(FLAG_TRIG_FALL) | BIT(FLAG_TRIG_RISE);
+			break;
+		case IRQ_TYPE_LEVEL_HIGH:
+			trigger_flags = 0;
+			break;
+		case IRQ_TYPE_LEVEL_LOW:
+			trigger_flags = 0;
+			break;
+		default:
+			trigger_flags = 0;
+			break;
+	}
+
+	gpio_setup_irq(desc, dev, 0);
+	status = gpio_setup_irq(desc, dev, trigger_flags);
+
+unlock:
+    mutex_unlock(&sysfs_lock);
+
+done:
+    if (status)
+        pr_debug("%s: gpio%d status %d\n", __func__, gpio, status);
+
+    return status;
+}
+EXPORT_SYMBOL_GPL(gpio_sysfs_set_edge);
+
+
+
+
+/**
  * gpio_sysfs_set_active_low - set the polarity of gpio sysfs value
  * @gpio: gpio to change
  * @value: non-zero to use active low, i.e. inverted values
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index a9432fc..4827de8 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -252,6 +252,11 @@ static inline int
gpio_sysfs_set_active_low(unsigned gpio, int value)
 	return -ENOSYS;
 }

+static inline int gpio_sysfs_set_edge(unsigned gpio, unsigned int irq_type)
+{
+	return -ENOSYS;
+}
+
 static inline void gpio_unexport(unsigned gpio)
 {
 }
-- 
1.7.6
