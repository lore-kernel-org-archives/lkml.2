Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab1LIOID (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 09:08:03 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41606 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115Ab1LIOIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 09:08:00 -0500
From: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Linus Walleij <linus.walleij@linaro.org>,
        Paul Bolle <pebolle@tiscali.nl>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [PATCHv2 06/10] xshm: Add xshm device implementation
Date: Fri,  9 Dec 2011 15:07:24 +0100
Message-Id: <1323439648-22697-7-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323439648-22697-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1323439648-22697-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements the XSHM device.
- Channel management such as open/close.
- Modem start-up synchronization events.
- C2C power request indications, requesting power-on when transmit is ongoing,
  and power-off upon inactivity timeout.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/xshm/xshm_dev.c |  526 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 526 insertions(+), 0 deletions(-)
 create mode 100644 drivers/xshm/xshm_dev.c

diff --git a/drivers/xshm/xshm_dev.c b/drivers/xshm/xshm_dev.c
new file mode 100644
index 0000000..9abe3ed
--- /dev/null
+++ b/drivers/xshm/xshm_dev.c
@@ -0,0 +1,526 @@
+/*
+ * Copyright (C) ST-Ericsson AB 2011
+ * Author: Sjur Brendeland / sjur.brandeland@stericsson.com
+ * License terms: GNU General Public License (GPL) version 2
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": %s :" fmt, __func__
+#include <linux/version.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/netdevice.h>
+#include <linux/c2c_genio.h>
+#include <linux/xshm/xshm_ipctoc.h>
+#include <linux/xshm/xshm_dev.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Sjur Brændland <sjur.brandeland@stericsson.com>");
+MODULE_DESCRIPTION("External Shared Memory - Supporting direct boot and IPC");
+MODULE_VERSION("XSHM 0.6 : " __DATE__);
+
+static int xshm_inactivity_timeout = 1000;
+module_param(xshm_inactivity_timeout, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(xshm_inactivity_timeout, "Inactivity timeout, ms.");
+
+bool ready_for_ipc;
+EXPORT_SYMBOL(ready_for_ipc);
+
+bool ready_for_caif;
+EXPORT_SYMBOL(ready_for_caif);
+static spinlock_t timer_lock;
+static int inactivity_timeout;
+static struct timer_list inactivity_timer;
+static bool power_on;
+static struct device _parentdev;
+static struct device *parentdev;
+
+#if 1
+#define xdev_dbg(dev, fmt, arg...) printk(KERN_DEBUG "%s: %s - " fmt, \
+			dev_name(&dev->dev), __func__, ##arg)
+#define xdev_devl(dev, fmt, arg...) printk(KERN_DEBUG "%s: %s - " fmt, \
+			dev_name(&dev->dev), __func__, ##arg)
+#define pr_xshmstate(dev, str) \
+	pr_devel("xshm: %s %s: %s STATE: %s txch:%s(%p) rxch:%s(%p)\n", \
+			dev_name(&dev->dev), __func__, str,		\
+			dev->state == XSHM_DEV_OPEN ? "open" : "close", \
+			*dev->cfg.tx.state == cpu_to_le32(XSHM_OPEN) ?	\
+			"open" : "close",				\
+			dev->cfg.tx.state,				\
+			*dev->cfg.rx.state == cpu_to_le32(XSHM_OPEN) ?	\
+			"open" : "close",				\
+			dev->cfg.rx.state)
+#else
+#define xdev_dbg(...)
+#define xdev_devl(...)
+#undef pr_debug
+#undef pr_devel
+#define pr_debug(...)
+#define pr_devel(...)
+#define pr_xshmstate(...)
+#endif
+
+static void inactivity_tout(unsigned long arg)
+{
+	unsigned long flags;
+	pr_devel("enter\n");
+	spin_lock_irqsave(&timer_lock, flags);
+	/*
+	 * This is paranoia, but if timer is reactivated
+	 * before this tout function is scheduled,
+	 * we just ignore this timeout.
+	 */
+	if (timer_pending(&inactivity_timer))
+		goto out;
+
+	if (power_on) {
+		pr_devel("genio power req(off)\n");
+		genio_power_req(false);
+		power_on = false;
+	}
+out:
+	spin_unlock_irqrestore(&timer_lock, flags);
+}
+
+static void activity(void)
+{
+	unsigned long flags;
+	pr_devel("enter\n");
+	spin_lock_irqsave(&timer_lock, flags);
+	if (!power_on) {
+		pr_devel("genio power req(on)\n");
+		genio_power_req(true);
+		power_on = true;
+	}
+	mod_timer(&inactivity_timer,
+			jiffies + inactivity_timeout);
+	spin_unlock_irqrestore(&timer_lock, flags);
+}
+
+static void reset_activity_tout(void)
+{
+	unsigned long flags;
+	pr_devel("enter\n");
+	spin_lock_irqsave(&timer_lock, flags);
+	if (power_on) {
+		genio_power_req(false);
+		power_on = false;
+	}
+	del_timer_sync(&inactivity_timer);
+	spin_unlock_irqrestore(&timer_lock, flags);
+}
+
+static int xshmdev_ipc_tx(struct xshm_dev *dev)
+{
+	xdev_devl(dev, "call genio_set_bit(%d)\n", dev->cfg.tx.xfer_bit);
+	activity();
+	return genio_set_bit(dev->cfg.tx.xfer_bit);
+}
+
+static int xshmdev_ipc_rx_release(struct xshm_dev *dev, bool more)
+{
+	xdev_devl(dev, "call genio_set_bit(%d)\n", dev->cfg.tx.xfer_bit);
+	activity();
+	return genio_set_bit(dev->cfg.rx.xfer_done_bit);
+}
+
+static int do_open(struct xshm_dev *dev)
+{
+	int err;
+
+	pr_xshmstate(dev, "enter");
+	err = dev->open_cb(dev->driver_data);
+	if (err < 0) {
+		xdev_dbg(dev, "Error - open_cb failed\n");
+
+		/* Make sure ring-buffer is empty i RX and TX direction */
+		*dev->cfg.rx.read = *dev->cfg.rx.write;
+		*dev->cfg.tx.write = *dev->cfg.tx.read;
+		*dev->cfg.tx.state = cpu_to_le32(XSHM_CLOSED);
+		xdev_devl(dev, "set state = XSHM_DEV_CLOSED\n");
+		dev->state = XSHM_DEV_CLOSED;
+		return err;
+	}
+
+	/* Check is we already have any data in the pipe */
+	if (*dev->cfg.rx.write != *dev->cfg.rx.read) {
+		pr_devel("Received data during opening\n");
+		dev->ipc_rx_cb(dev->driver_data);
+	}
+
+	return err;
+}
+
+static void genio_rx_cb(void *data)
+{
+	struct xshm_dev *dev = data;
+
+	pr_xshmstate(dev, "Enter");
+
+	if (likely(dev->state == XSHM_DEV_OPEN)) {
+		if (unlikely(!ready_for_ipc)) {
+			xdev_devl(dev, "ready_for_ipc is not yet set\n");
+			return;
+		}
+
+		if (dev->ipc_rx_cb) {
+			int err = dev->ipc_rx_cb(dev->driver_data);
+			if (unlikely(err < 0))
+				goto remote_close;
+		}
+
+	} else if (*dev->cfg.rx.state == cpu_to_le32(XSHM_OPEN)) {
+		pr_xshmstate(dev, "");
+		dev->state = XSHM_DEV_OPEN;
+		if (!ready_for_ipc) {
+			xdev_devl(dev, "ready_for_ipc is not yet set\n");
+			return;
+		}
+		if (do_open(dev) < 0)
+			goto open_fail;
+	}
+	return;
+open_fail:
+	pr_xshmstate(dev, "exit open failed");
+	/* Make sure ring-buffer is empty i RX and TX direction */
+	*dev->cfg.rx.read = *dev->cfg.rx.write;
+	*dev->cfg.tx.write = *dev->cfg.tx.read;
+remote_close:
+	*dev->cfg.tx.state = cpu_to_le32(XSHM_CLOSED);
+	dev->state = XSHM_DEV_CLOSED;
+	dev->close_cb(dev->driver_data);
+}
+
+static void genio_tx_release_cb(void *data)
+{
+	struct xshm_dev *dev = data;
+
+	pr_xshmstate(dev, "Enter");
+	if (!ready_for_ipc) {
+		xdev_devl(dev, "not ready_for_ipc\n");
+		return;
+	}
+	if (dev->ipc_tx_release_cb)
+		dev->ipc_tx_release_cb(dev->driver_data);
+}
+
+struct xshm_xgroup {
+	bool prohibit;
+	u32 group;
+};
+
+static void check_exclgroup(struct xshm_dev *dev, void *data)
+{
+	struct xshm_xgroup *x = data;
+	if (dev->state == XSHM_DEV_OPEN &&
+		dev->cfg.excl_group != x->group) {
+		x->prohibit = true;
+		xdev_dbg(dev, "Exclusive group "
+				"prohibits device open\n");
+	}
+}
+
+static int xshmdev_open(struct xshm_dev *dev)
+{
+	int err = -EINVAL;
+	struct xshm_xgroup x = {
+		.prohibit = false,
+		.group = dev->cfg.excl_group
+	};
+
+
+	pr_xshmstate(dev, "Enter");
+	if (WARN_ON(dev->ipc_rx_cb == NULL) ||
+			WARN_ON(dev->ipc_tx_release_cb == NULL) ||
+			WARN_ON(dev->open_cb == NULL) ||
+			WARN_ON(dev->close_cb == NULL))
+		goto err;
+
+	xshm_foreach_dev(check_exclgroup, &x);
+	if (x.prohibit) {
+		xdev_dbg(dev, "Exclusive group prohibits device open\n");
+		err = -EPERM;
+		goto err;
+	}
+
+	pr_devel("call genio_subscribe(%d)\n", dev->cfg.rx.xfer_bit);
+	err = genio_subscribe(dev->cfg.rx.xfer_bit, genio_rx_cb, dev);
+	if (err)
+		goto err;
+
+	pr_devel("call genio_subscribe(%d)\n", dev->cfg.tx.xfer_done_bit);
+	err = genio_subscribe(dev->cfg.tx.xfer_done_bit,
+			genio_tx_release_cb, dev);
+	if (err)
+		goto err;
+
+	/* Indicate that our side is open and ready for action */
+	*dev->cfg.rx.read = *dev->cfg.rx.write;
+	*dev->cfg.tx.write = *dev->cfg.tx.read;
+	*dev->cfg.tx.state = cpu_to_le32(XSHM_OPEN);
+
+	if (ready_for_ipc)
+		err = xshmdev_ipc_tx(dev);
+
+	if (err < 0) {
+		xdev_dbg(dev, "can't update geno\n");
+		goto err;
+	}
+	/* If other side is ready as well we're ready to role */
+	if (*dev->cfg.rx.state == cpu_to_le32(XSHM_OPEN) && ready_for_ipc) {
+		if (do_open(dev) < 0)
+			goto err;
+		dev->state = XSHM_DEV_OPEN;
+	}
+
+	return 0;
+err:
+	pr_xshmstate(dev, "exit error");
+	*dev->cfg.rx.read = *dev->cfg.rx.write;
+	*dev->cfg.tx.write = *dev->cfg.tx.read;
+	*dev->cfg.tx.state = cpu_to_le32(XSHM_CLOSED);
+	return err;
+}
+
+static void xshmdev_close(struct xshm_dev *dev)
+{
+	pr_xshmstate(dev, "enter");
+
+	dev->state = XSHM_DEV_CLOSED;
+	*dev->cfg.rx.read = *dev->cfg.rx.write;
+	*dev->cfg.tx.state = cpu_to_le32(XSHM_CLOSED);
+	xshmdev_ipc_tx(dev);
+	if (dev->close_cb)
+		dev->close_cb(dev->driver_data);
+
+	pr_devel("call genio_unsubscribe(%d)\n", dev->cfg.rx.xfer_bit);
+	genio_unsubscribe(dev->cfg.rx.xfer_bit);
+	pr_devel("call genio_unsubscribe(%d)\n", dev->cfg.tx.xfer_done_bit);
+	genio_unsubscribe(dev->cfg.tx.xfer_done_bit);
+}
+
+int xshm_register_devices(struct xshm_dev *devs[], int devices,
+				const struct bin_attribute *attr)
+{
+
+	int i, err;
+
+	for (i = 0; i < devices; i++) {
+		struct xshm_dev *dev = devs[i];
+		dev->state = XSHM_DEV_CLOSED;
+		dev->open = xshmdev_open;
+		dev->close = xshmdev_close;
+		dev->ipc_rx_release = xshmdev_ipc_rx_release;
+		dev->ipc_tx = xshmdev_ipc_tx;
+		xdev_devl(dev, "register XSHM device %s\n",
+				dev_name(&dev->dev));
+		dev->dev.parent = parentdev;
+
+		err = xshm_register_device(dev);
+		if (err) {
+			xdev_dbg(dev, "registration failed (%d)\n", err);
+			return err;
+		}
+	}
+
+	return device_create_bin_file(parentdev, attr);
+}
+EXPORT_SYMBOL(xshm_register_devices);
+
+static void genio_caif_ready_cb(bool ready)
+{
+	pr_devel("enter\n");
+	/* Set global variable ready_for_caif true */
+	if (ready_for_caif != ready) {
+		ready_for_caif = ready;
+		xshm_caif_ready();
+	}
+}
+
+static void genio_errhandler(int errno)
+{
+	/* Fake CAIF_READY low to trigger modem restart */
+	pr_warn("Driver reported error:%d\n", errno);
+	ready_for_caif = 0;
+	xshm_caif_ready();
+}
+
+struct xshm_bits {
+	u32 setter;
+	u32 getter;
+};
+
+static void collect_bits(struct xshm_dev *dev, void *data)
+{
+	struct xshm_bits *bits = data;
+	bits->setter |= 1 << dev->cfg.tx.xfer_bit;
+	bits->setter |= 1 << dev->cfg.rx.xfer_done_bit;
+	bits->getter |= 1 << dev->cfg.rx.xfer_bit;
+	bits->getter |= 1 << dev->cfg.tx.xfer_done_bit;
+}
+
+static void handle_open(struct xshm_dev *dev, void *data)
+{
+		if (dev->cfg.rx.state != NULL && dev->cfg.tx.state != NULL &&
+				*dev->cfg.rx.state == cpu_to_le32(XSHM_OPEN) &&
+				*dev->cfg.tx.state == cpu_to_le32(XSHM_OPEN)) {
+			dev->state = XSHM_DEV_OPEN;
+			do_open(dev);
+		}
+}
+
+void genio_ipc_ready_cb(void)
+{
+	int err;
+	struct xshm_bits bits = {0, 0};
+
+	pr_devel("enter\n");
+	/* Set global variable ready_for_ipc true */
+#ifdef DEBUG
+	/*
+	 * In real life read_for_ipc doesn't change, but it's
+	 * convenient for testing.
+	 */
+	ready_for_ipc = !ready_for_ipc;
+#else
+	ready_for_ipc = true;
+#endif
+
+	xshm_ipc_ready();
+
+	genio_register_errhandler(genio_errhandler);
+
+	pr_devel("call genio_subscribe_caif_ready()\n");
+	err = genio_subscribe_caif_ready(genio_caif_ready_cb);
+	if (err < 0)
+		pr_debug("genio_subscribe_caif_ready failed:%d\n", err);
+
+	/* Collect the bit-mask for GENIO bits */
+	xshm_foreach_dev(collect_bits, &bits);
+	pr_devel("call genio_bit_alloc(%x,%x)\n", bits.setter, bits.getter);
+	err = genio_bit_alloc(bits.setter, bits.getter);
+	if (err < 0)
+		pr_debug("genio_bit_alloc failed:%d\n", err);
+	xshm_foreach_dev(handle_open, NULL);
+}
+EXPORT_SYMBOL(genio_ipc_ready_cb);
+
+/* sysfs: ipc_ready file */
+static ssize_t ipc_ready_show(struct device *dev, struct device_attribute *attr,
+				char *buf)
+{
+	return sprintf(buf, "%d\n", ready_for_ipc);
+}
+
+/* sysfs: ipc_ready file */
+static ssize_t caif_ready_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%d\n", ready_for_caif);
+}
+
+static DEVICE_ATTR(ipc_ready, S_IRUSR | S_IRUGO, ipc_ready_show, NULL);
+static DEVICE_ATTR(caif_ready, S_IRUSR | S_IRUGO, caif_ready_show, NULL);
+
+
+/* sysfs: notification on change of ipc_ready to user space */
+void xshm_ipc_ready(void)
+{
+	sysfs_notify(&parentdev->kobj, NULL, dev_attr_ipc_ready.attr.name);
+}
+
+/* sysfs: notification on change of caif_ready to user space */
+void xshm_caif_ready(void)
+{
+	sysfs_notify(&parentdev->kobj, NULL, dev_attr_caif_ready.attr.name);
+}
+
+static void parent_release(struct device *dev)
+{
+}
+
+static int __init xshm_init(void)
+{
+	int err;
+
+	pr_devel("Initializing\n");
+
+	/* Pre-calculate inactivity timeout. */
+	if (xshm_inactivity_timeout != -1) {
+		inactivity_timeout =
+				xshm_inactivity_timeout * HZ / 1000;
+		if (inactivity_timeout == 0)
+			inactivity_timeout = 1;
+		else if (inactivity_timeout > NEXT_TIMER_MAX_DELTA)
+			inactivity_timeout = NEXT_TIMER_MAX_DELTA;
+	} else
+		inactivity_timeout = NEXT_TIMER_MAX_DELTA;
+
+	spin_lock_init(&timer_lock);
+	init_timer(&inactivity_timer);
+	inactivity_timer.data = 0L;
+	inactivity_timer.function = inactivity_tout;
+
+	pr_devel("call genio_init()\n");
+
+	parentdev = &_parentdev;
+	memset(parentdev, 0, sizeof(parentdev));
+	dev_set_name(parentdev, "xshm");
+	parentdev->release = parent_release;
+
+	err = device_register(parentdev);
+	if (err)
+		goto err;
+
+	err = device_create_file(parentdev, &dev_attr_ipc_ready);
+	if (err)
+		goto err_unreg;
+	err = device_create_file(parentdev, &dev_attr_caif_ready);
+	if (err)
+		goto err_unreg;
+
+	return err;
+err_unreg:
+	pr_debug("initialization failed\n");
+	device_unregister(parentdev);
+err:
+	pr_devel("call genio_exit()\n");
+	return err;
+}
+
+static void handle_close(struct xshm_dev *dev, void *data)
+{
+		if (dev->close_cb)
+			dev->close_cb(dev->driver_data);
+}
+
+void close_devices(void)
+{
+	xshm_foreach_dev(handle_close, NULL);
+}
+
+static void handle_reset(struct xshm_dev *dev, void *data)
+{
+	if (dev->close_cb)
+		dev->close_cb(dev->driver_data);
+	xshm_unregister_device(dev);
+}
+
+void xshm_reset(void)
+{
+	xshm_foreach_dev(handle_reset, NULL);
+	reset_activity_tout();
+	genio_reset();
+}
+EXPORT_SYMBOL(xshm_reset);
+
+static void __exit xshm_exit(void)
+{
+	device_unregister(parentdev);
+	xshm_reset();
+	genio_unsubscribe(READY_FOR_IPC_BIT);
+	genio_unsubscribe(READY_FOR_CAIF_BIT);
+}
+
+module_init(xshm_init);
+module_exit(xshm_exit);
-- 
1.7.0.4

