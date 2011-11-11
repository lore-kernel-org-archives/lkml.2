Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761Ab1KKJlJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 04:41:09 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:59652 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765Ab1KKJlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 04:41:07 -0500
From: Patrick Combes <p-combes@ti.com>
To: <grant.likely@secretlab.ca>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Hugo Dupras <h-dupras@ti.com>, Patrick Combes <p-combes@ti.com>
Subject: [RFC][PATCH] gpiolib: add irq_wake (power-management) sysfs file
Date: Fri, 11 Nov 2011 10:40:06 +0100
Message-ID: <1321004406-15663-1-git-send-email-p-combes@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hugo Dupras <h-dupras@ti.com>

By calling poll() on the /sys/class/gpio/gpioN/value sysfs file, usermode
application can take benefit of gpio interrupts.
However, depending on the power state reached, this interrupt may not wake-up
the CPU.
This patch creates a new sysfs file /sys/class/gpio/gpioN/irq_wake to enable
usermode application to set the wake properties of a gpio IRQ.
This option can be set or not for each gpio to preserve power consumption (e.g
embedded systems).

Signed-off-by: Hugo Dupras <h-dupras@ti.com>
Signed-off-by: Patrick Combes <p-combes@ti.com>
---
 drivers/gpio/gpiolib.c |   55 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 54 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index a971e3d..cf03aed 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -543,6 +543,55 @@ static ssize_t gpio_active_low_store(struct device *dev,
 static const DEVICE_ATTR(active_low, 0644,
 		gpio_active_low_show, gpio_active_low_store);
 
+static ssize_t gpio_irq_wake_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	const struct gpio_desc  *desc = dev_get_drvdata(dev);
+	unsigned		gpio = desc - gpio_desc;
+	ssize_t			status;
+
+	mutex_lock(&sysfs_lock);
+
+	if (!test_bit(FLAG_EXPORT, &desc->flags))
+		status = -EIO;
+	else if (sysfs_streq(buf, "enable") || sysfs_streq(buf, "1"))
+		status = enable_irq_wake(gpio_to_irq(gpio));
+	else if (sysfs_streq(buf, "disable") || sysfs_streq(buf, "0"))
+		status = disable_irq_wake(gpio_to_irq(gpio));
+	else
+		status = -EINVAL;
+
+	mutex_unlock(&sysfs_lock);
+
+	return status ? : size;
+}
+
+static ssize_t gpio_irq_wake_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	const struct gpio_desc	*desc = dev_get_drvdata(dev);
+	unsigned		gpio = desc - gpio_desc;
+	int			irq = gpio_to_irq(gpio);
+	ssize_t			status;
+	struct irq_data		*gpio_irq_data = irq_get_irq_data(irq);
+
+	mutex_lock(&sysfs_lock);
+
+	if (gpio_irq_data)
+		status = sprintf(buf, " Wakeup %s\n",
+					irqd_is_wakeup_set(gpio_irq_data)
+					? " enable" : "disable");
+	else
+		status = -EINVAL;
+
+	mutex_unlock(&sysfs_lock);
+
+	return status;
+}
+
+static const DEVICE_ATTR(irq_wake, 0644,
+		gpio_irq_wake_show, gpio_irq_wake_store);
+
 static const struct attribute *gpio_attrs[] = {
 	&dev_attr_value.attr,
 	&dev_attr_active_low.attr,
@@ -744,9 +793,13 @@ int gpio_export(unsigned gpio, bool direction_may_change)
 			if (!status && gpio_to_irq(gpio) >= 0
 					&& (direction_may_change
 						|| !test_bit(FLAG_IS_OUT,
-							&desc->flags)))
+							&desc->flags))) {
 				status = device_create_file(dev,
 						&dev_attr_edge);
+				if (!status)
+					status = device_create_file(dev,
+							&dev_attr_irq_wake);
+			}
 
 			if (status != 0)
 				device_unregister(dev);
-- 
1.7.0.4

