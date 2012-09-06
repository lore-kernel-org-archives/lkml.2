Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933213Ab2IFVT5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 17:19:57 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60285 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933142Ab2IFVT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 17:19:56 -0400
From: Tomas Hlavacek <tmshlvck@gmail.com>
To: gregkh@linuxfoundation.org, alan@linux.intel.com,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: marek.vasut@gmail.com, Tomas Hlavacek <tmshlvck@gmail.com>
Subject: [PATCH] tty_register_device_attr updated for tty-next
Date: Thu,  6 Sep 2012 23:17:47 +0200
Message-Id: <1346966267-1780-1-git-send-email-tmshlvck@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added tty_device_create_release() and bound to dev->release in
tty_register_device_attr().
Added tty_port_register_device_attr() and used in uart_add_one_port()
instead of tty_register_device_attr().

Signed-off-by: Tomas Hlavacek <tmshlvck@gmail.com>
---
 drivers/tty/serial/serial_core.c |    8 ++++----
 drivers/tty/tty_io.c             |    7 +++++++
 drivers/tty/tty_port.c           |   24 ++++++++++++++++++++++++
 include/linux/tty.h              |    4 ++++
 4 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index f629bdf..046279c 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2313,9 +2313,9 @@ static ssize_t uart_get_attr_uartclk(struct device *dev,
 	struct device_attribute *attr, char *buf)
 {
 	int ret;
-
 	struct tty_port *port = dev_get_drvdata(dev);
 	struct uart_state *state = container_of(port, struct uart_state, port);
+
 	mutex_lock(&state->port.mutex);
 	ret = snprintf(buf, PAGE_SIZE, "%d\n", state->uart_port->uartclk);
 	mutex_unlock(&state->port.mutex);
@@ -2330,7 +2330,7 @@ static struct attribute *tty_dev_attrs[] = {
 	NULL,
 	};
 
-static struct attribute_group tty_dev_attr_group = {
+static const struct attribute_group tty_dev_attr_group = {
 	.attrs = tty_dev_attrs,
 	};
 
@@ -2392,8 +2392,8 @@ int uart_add_one_port(struct uart_driver *drv, struct uart_port *uport)
 	 * Register the port whether it's detected or not.  This allows
 	 * setserial to be used to alter this ports parameters.
 	 */
-	tty_dev = tty_register_device_attr(drv->tty_driver, uport->line,
-			uport->dev, port, tty_dev_attr_groups);
+	tty_dev = tty_port_register_device_attr(port, drv->tty_driver,
+			uport->line, uport->dev, port, tty_dev_attr_groups);
 	if (likely(!IS_ERR(tty_dev))) {
 		device_set_wakeup_capable(tty_dev, 1);
 	} else {
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index dcb30d5..8a5a8b0 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -3045,6 +3045,12 @@ struct device *tty_register_device(struct tty_driver *driver, unsigned index,
 }
 EXPORT_SYMBOL(tty_register_device);
 
+static void tty_device_create_release(struct device *dev)
+{
+	pr_debug("device: '%s': %s\n", dev_name(dev), __func__);
+	kfree(dev);
+}
+
 /**
  *	tty_register_device_attr - register a tty device
  *	@driver: the tty driver that describes the tty device
@@ -3103,6 +3109,7 @@ struct device *tty_register_device_attr(struct tty_driver *driver,
 	dev->devt = devt;
 	dev->class = tty_class;
 	dev->parent = device;
+	dev->release = tty_device_create_release;
 	dev_set_name(dev, "%s", name);
 	dev->groups = attr_grp;
 	dev_set_drvdata(dev, drvdata);
diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
index 96302f4..d7bdd8d 100644
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -73,6 +73,30 @@ struct device *tty_port_register_device(struct tty_port *port,
 }
 EXPORT_SYMBOL_GPL(tty_port_register_device);
 
+/**
+ * tty_port_register_device_attr - register tty device
+ * @port: tty_port of the device
+ * @driver: tty_driver for this device
+ * @index: index of the tty
+ * @device: parent if exists, otherwise NULL
+ * @drvdata: Driver data to be set to device.
+ * @attr_grp: Attribute group to be set on device.
+ *
+ * It is the same as tty_register_device_attr except the provided @port is
+ * linked to a concrete tty specified by @index. Use this or tty_port_install
+ * (or both). Call tty_port_link_device as a last resort.
+ */
+struct device *tty_port_register_device_attr(struct tty_port *port,
+		struct tty_driver *driver, unsigned index,
+		struct device *device, void *drvdata,
+		const struct attribute_group **attr_grp)
+{
+	tty_port_link_device(port, driver, index);
+	return tty_register_device_attr(driver, index, device, drvdata,
+			attr_grp);
+}
+EXPORT_SYMBOL_GPL(tty_port_register_device_attr);
+
 int tty_port_alloc_xmit_buf(struct tty_port *port)
 {
 	/* We may sleep in get_zeroed_page() */
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 599d603..1509b86 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -507,6 +507,10 @@ extern void tty_port_link_device(struct tty_port *port,
 extern struct device *tty_port_register_device(struct tty_port *port,
 		struct tty_driver *driver, unsigned index,
 		struct device *device);
+extern struct device *tty_port_register_device_attr(struct tty_port *port,
+		struct tty_driver *driver, unsigned index,
+		struct device *device, void *drvdata,
+		const struct attribute_group **attr_grp);
 extern int tty_port_alloc_xmit_buf(struct tty_port *port);
 extern void tty_port_free_xmit_buf(struct tty_port *port);
 extern void tty_port_put(struct tty_port *port);
-- 
1.7.10.4

