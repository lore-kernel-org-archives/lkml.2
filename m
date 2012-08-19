Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab2HSSey (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 14:34:54 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:39223 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab2HSSev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 14:34:51 -0400
From: Tomas Hlavacek <tmshlvck@gmail.com>
To: gregkh@linuxfoundation.org, alan@linux.intel.com,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: marek.vasut@gmail.com, Tomas Hlavacek <tmshlvck@gmail.com>
Subject: [PATCHv4 1/1] [RFC] uartclk from serial_core exposed to sysfs
Date: Sun, 19 Aug 2012 20:34:45 +0200
Message-Id: <1345401285-14473-1-git-send-email-tmshlvck@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1344929718-22736-1-git-send-email-tmshlvck@gmail.com>
References: <1344929718-22736-1-git-send-email-tmshlvck@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added file /sys/devices/.../tty/ttySX/uartclk to allow reading
uartclk value in struct uart_port in serial_core via sysfs.

It simplifies initialization verification of no-name cards that
have non-standard oscillator speed while having no distinguishing
PCI IDs to allow autodetection.

tty_register_device() has been generalized and refactored in order
to add support for setting drvdata and attribute_group to the device.

Signed-off-by: Tomas Hlavacek <tmshlvck@gmail.com>
---
 Documentation/ABI/testing/sysfs-tty |    9 +++++
 drivers/tty/serial/serial_core.c    |   37 +++++++++++++++++++-
 drivers/tty/tty_io.c                |   63 ++++++++++++++++++++++++++++++++---
 include/linux/tty.h                 |    4 +++
 4 files changed, 108 insertions(+), 5 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-tty b/Documentation/ABI/testing/sysfs-tty
index b138b66..b93a174 100644
--- a/Documentation/ABI/testing/sysfs-tty
+++ b/Documentation/ABI/testing/sysfs-tty
@@ -17,3 +17,12 @@ Description:
 		 device, like 'tty1'.
 		 The file supports poll() to detect virtual
 		 console switches.
+
+What:		/sys/class/tty/ttyS0/uartclk
+Date:		Aug 2012
+Contact:	Tomas Hlavacek <tmshlvck@gmail.com>
+Description:
+		Shows the current uartclk value associated with the
+		UART port in serial_core, that is bound to TTY like ttyS0.
+		uartclk = 16 * baud_base
+
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index a21dc8e..e0c11da 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2293,6 +2293,38 @@ struct tty_driver *uart_console_device(struct console *co, int *index)
 	return p->tty_driver;
 }
 
+static ssize_t uart_get_attr_uartclk(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	int ret;
+
+	struct tty_port *port = dev_get_drvdata(dev);
+	struct uart_state *state = container_of(port, struct uart_state, port);
+
+	mutex_lock(&state->port.mutex);
+	ret = snprintf(buf, PAGE_SIZE, "%d\n", state->uart_port->uartclk);
+	mutex_unlock(&state->port.mutex);
+
+	return ret;
+}
+
+static DEVICE_ATTR(uartclk, S_IRUSR | S_IRGRP, uart_get_attr_uartclk,
+		NULL);
+
+static struct attribute *tty_dev_attrs[] = {
+	&dev_attr_uartclk.attr,
+	NULL,
+};
+
+static struct attribute_group tty_dev_attr_group = {
+	.attrs = tty_dev_attrs,
+};
+
+static struct attribute_group *tty_dev_attr_groups[] = {
+	&tty_dev_attr_group,
+	NULL
+};
+
 /**
  *	uart_add_one_port - attach a driver-defined port structure
  *	@drv: pointer to the uart low level driver structure for this port
@@ -2345,8 +2377,11 @@ int uart_add_one_port(struct uart_driver *drv, struct uart_port *uport)
 	/*
 	 * Register the port whether it's detected or not.  This allows
 	 * setserial to be used to alter this ports parameters.
+	 * Use driverdata of the tty device for referencing the UART port.
+	 * Set default device attributes to the new device.
 	 */
-	tty_dev = tty_register_device(drv->tty_driver, uport->line, uport->dev);
+	tty_dev = tty_register_device_attr(drv->tty_driver, uport->line,
+			uport->dev, port, tty_dev_attr_groups);
 	if (likely(!IS_ERR(tty_dev))) {
 		device_set_wakeup_capable(tty_dev, 1);
 	} else {
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index b425c79..1c9d5b5 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -3009,12 +3009,42 @@ struct class *tty_class;
  *
  *	Locking: ??
  */
-
 struct device *tty_register_device(struct tty_driver *driver, unsigned index,
 				   struct device *device)
 {
+	return tty_register_device_attr(driver, index, device, NULL, NULL);
+}
+EXPORT_SYMBOL(tty_register_device);
+
+/**
+ *	tty_register_device_attr - register a tty device
+ *	@driver: the tty driver that describes the tty device
+ *	@index: the index in the tty driver for this tty device
+ *	@device: a struct device that is associated with this tty device.
+ *		This field is optional, if there is no known struct device
+ *		for this tty device it can be set to NULL safely.
+ *	@drvdata: Driver data to be set to device (NULL = do not touch).
+ *	@attr_grp: Attribute group to be set on device (NULL = do not touch).
+ *
+ *	Returns a pointer to the struct device for this tty device
+ *	(or ERR_PTR(-EFOO) on error).
+ *
+ *	This call is required to be made to register an individual tty device
+ *	if the tty driver's flags have the TTY_DRIVER_DYNAMIC_DEV bit set.  If
+ *	that bit is not set, this function should not be called by a tty
+ *	driver.
+ *
+ *	Locking: ??
+ */
+struct device *tty_register_device_attr(struct tty_driver *driver,
+				   unsigned index, struct device *device,
+				   void *drvdata,
+				   struct attribute_group **attr_grp)
+{
 	char name[64];
-	dev_t dev = MKDEV(driver->major, driver->minor_start) + index;
+	struct device *dev = NULL;
+	int retval = -ENODEV;
+	dev_t devt = MKDEV(driver->major, driver->minor_start) + index;
 
 	if (index >= driver->num) {
 		printk(KERN_ERR "Attempt to register invalid tty line number "
@@ -3027,9 +3057,34 @@ struct device *tty_register_device(struct tty_driver *driver, unsigned index,
 	else
 		tty_line_name(driver, index, name);
 
-	return device_create(tty_class, device, dev, NULL, name);
+
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev) {
+		retval = -ENOMEM;
+		goto error;
+	}
+
+	dev->devt = devt;
+	dev->class = tty_class;
+	dev->parent = device;
+	dev_set_name(dev, "%s", name);
+	if (attr_grp)
+		dev->groups = attr_grp;
+	if (drvdata)
+		dev_set_drvdata(dev, drvdata);
+
+	retval = device_register(dev);
+	if (retval)
+		goto error;
+
+	return dev;
+
+error:
+	put_device(dev);
+	return ERR_PTR(retval);
+
 }
-EXPORT_SYMBOL(tty_register_device);
+EXPORT_SYMBOL_GPL(tty_register_device_attr);
 
 /**
  * 	tty_unregister_device - unregister a tty device
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 9f47ab5..424777a 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -410,6 +410,10 @@ extern int tty_register_driver(struct tty_driver *driver);
 extern int tty_unregister_driver(struct tty_driver *driver);
 extern struct device *tty_register_device(struct tty_driver *driver,
 					  unsigned index, struct device *dev);
+struct device *tty_register_device_attr(struct tty_driver *driver,
+				   unsigned index, struct device *device,
+				   void *drvdata,
+				   struct attribute_group **attr_grp);
 extern void tty_unregister_device(struct tty_driver *driver, unsigned index);
 extern int tty_read_raw_data(struct tty_struct *tty, unsigned char *bufp,
 			     int buflen);
-- 
1.7.10.4

