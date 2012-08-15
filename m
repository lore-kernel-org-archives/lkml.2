Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab2HORMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 13:12:23 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:56009 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781Ab2HORMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 13:12:21 -0400
From: Tomas Hlavacek <tmshlvck@gmail.com>
To: gregkh@linuxfoundation.org, alan@linux.intel.com,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: marek.vasut@gmail.com, Tomas Hlavacek <tmshlvck@gmail.com>
Subject: [PATCHv2 1/1] [RFC] uartclk from serial_core exposed to sysfs
Date: Wed, 15 Aug 2012 19:12:13 +0200
Message-Id: <1345050733-20252-1-git-send-email-tmshlvck@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1344929718-22736-1-git-send-email-tmshlvck@gmail.com>
References: <1344929718-22736-1-git-send-email-tmshlvck@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added file /sys/devices/.../tty/ttySX/uartclk to allow read/modify
uartclk value in struct uart_port in serial_core via sysfs.

It simplifies initialization of no-name cards that have non-standard
oscillator speed while having no distinguishing PCI IDs to allow
autodetection.

Signed-off-by: Tomas Hlavacek <tmshlvck@gmail.com>
---
 drivers/tty/serial/serial_core.c |   55 ++++++++++++++++++++++++++++++++++++++
 drivers/tty/tty_io.c             |   17 ++++++++++++
 include/linux/tty.h              |    2 ++
 3 files changed, 74 insertions(+)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index a21dc8e..0929fe3 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2293,6 +2293,47 @@ struct tty_driver *uart_console_device(struct console *co, int *index)
 	return p->tty_driver;
 }
 
+static ssize_t uart_get_attr_uartclk(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	int ret;
+
+	struct uart_state *state = dev_get_drvdata(dev);
+	mutex_lock(&state->port.mutex);
+	ret = snprintf(buf, PAGE_SIZE, "%d\n", state->uart_port->uartclk);
+	mutex_unlock(&state->port.mutex);
+	return ret;
+}
+
+static ssize_t uart_set_attr_uartclk(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct uart_state *state = dev_get_drvdata(dev);
+	unsigned int val;
+	int ret;
+
+	ret = kstrtouint(buf, 10, &val);
+	if (ret)
+		return ret;
+
+	mutex_lock(&state->port.mutex);
+
+	/*
+	 * Check value: baud_base does not make sense to be set below 9600
+	 * and since uartclock = (baud_base * 16) it has to be equal or greater
+	 * than 9600 * 16 = 153600.
+	 */
+	if (val >= 153600)
+		state->uart_port->uartclk = val;
+
+	mutex_unlock(&state->port.mutex);
+
+	return count;
+}
+
+static DEVICE_ATTR(uartclk, S_IRUGO | S_IWUSR, uart_get_attr_uartclk,
+		uart_set_attr_uartclk);
+
 /**
  *	uart_add_one_port - attach a driver-defined port structure
  *	@drv: pointer to the uart low level driver structure for this port
@@ -2355,6 +2396,14 @@ int uart_add_one_port(struct uart_driver *drv, struct uart_port *uport)
 	}
 
 	/*
+	 * Expose uartclk in sysfs. Use driverdata of the tty device for
+	 * referencing the UART port.
+	 */
+	dev_set_drvdata(tty_dev, state);
+	if (device_create_file(tty_dev, &dev_attr_uartclk) < 0)
+		dev_err(tty_dev, "Failed to add uartclk attr\n");
+
+	/*
 	 * Ensure UPF_DEAD is not set.
 	 */
 	uport->flags &= ~UPF_DEAD;
@@ -2397,6 +2446,12 @@ int uart_remove_one_port(struct uart_driver *drv, struct uart_port *uport)
 	mutex_unlock(&port->mutex);
 
 	/*
+	 * Remove uartclk file from sysfs.
+	 */
+	device_remove_file(tty_lookup_device(drv->tty_driver, uport->line),
+			&dev_attr_uartclk);
+
+	/*
 	 * Remove the devices from the tty layer
 	 */
 	tty_unregister_device(drv->tty_driver, uport->line);
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index b425c79..8ea8622 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -3049,6 +3049,23 @@ void tty_unregister_device(struct tty_driver *driver, unsigned index)
 }
 EXPORT_SYMBOL(tty_unregister_device);
 
+/*
+ *	tty_lookup_device - lookup a tty device
+ *	@driver: the tty driver that describes the tty device
+ *	@index: the index in the tty driver for this tty device
+ *
+ *	This function returns a struct device pointer when device has
+ *	been found and NULL otherwise.
+ *
+ *	Locking: ??
+ */
+struct device *tty_lookup_device(struct tty_driver *driver, unsigned index)
+{
+	dev_t devt = MKDEV(driver->major, driver->minor_start) + index;
+	return class_find_device(tty_class, NULL, &devt, dev_match_devt);
+}
+EXPORT_SYMBOL(tty_lookup_device);
+
 struct tty_driver *__alloc_tty_driver(int lines, struct module *owner)
 {
 	struct tty_driver *driver;
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 9f47ab5..5d408a1 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -410,6 +410,8 @@ extern int tty_register_driver(struct tty_driver *driver);
 extern int tty_unregister_driver(struct tty_driver *driver);
 extern struct device *tty_register_device(struct tty_driver *driver,
 					  unsigned index, struct device *dev);
+extern struct device *tty_lookup_device(struct tty_driver *driver,
+					unsigned index);
 extern void tty_unregister_device(struct tty_driver *driver, unsigned index);
 extern int tty_read_raw_data(struct tty_struct *tty, unsigned char *bufp,
 			     int buflen);
-- 
1.7.10.4

