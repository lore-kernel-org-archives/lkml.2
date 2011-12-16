Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759078Ab1LPKu2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 05:50:28 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:46633 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758943Ab1LPKtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 05:49:33 -0500
From: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Linus Walleij <linus.walleij@linaro.org>,
        sjurbren@gmail.com,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [PATCHv4 06/11] xshm: Add XSHM device bus.
Date: Fri, 16 Dec 2011 11:49:09 +0100
Message-Id: <1324032554-30398-7-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1324032554-30398-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1324032554-30398-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a simple xshm device bus, providing device and driver registration
and a simple iterator. Device mode (packet or stream) is used
for matching device and driver.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/xshm/xshm_bus.c |  113 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 113 insertions(+), 0 deletions(-)
 create mode 100644 drivers/xshm/xshm_bus.c

diff --git a/drivers/xshm/xshm_bus.c b/drivers/xshm/xshm_bus.c
new file mode 100644
index 0000000..d6410a6
--- /dev/null
+++ b/drivers/xshm/xshm_bus.c
@@ -0,0 +1,113 @@
+/*
+ * Copyright (C) ST-Ericsson AB 2011
+ * Author: Sjur Brændeland / sjur.brandeland@stericsson.com
+ * License terms: GNU General Public License (GPL) version 2
+ */
+
+#include <linux/spinlock.h>
+#include <linux/module.h>
+#include <linux/xshm/xshm_dev.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Sjur Brændland <sjur.brandeland@stericsson.com>");
+
+static int xshm_dev_match(struct device *_dv, struct device_driver *_dr)
+{
+	struct xshm_dev *dev = container_of(_dv, struct xshm_dev, dev);
+	struct xshm_driver *drv = container_of(_dr, struct xshm_driver, driver);
+
+	return drv->mode ==  (drv->mode & dev->cfg.mode);
+}
+
+static int xshm_dev_probe(struct device *_d)
+{
+	struct xshm_dev *dev = container_of(_d, struct xshm_dev, dev);
+	struct xshm_driver *drv = container_of(dev->dev.driver,
+						 struct xshm_driver, driver);
+	return drv->probe(dev);
+}
+
+static int xshm_dev_remove(struct device *_d)
+{
+	struct xshm_dev *dev = container_of(_d, struct xshm_dev, dev);
+	struct xshm_driver *drv = container_of(dev->dev.driver,
+						 struct xshm_driver, driver);
+	drv->remove(dev);
+	return 0;
+}
+
+static struct bus_type xshm_bus = {
+	.name  = "xshm",
+	.match = xshm_dev_match,
+	.probe = xshm_dev_probe,
+	.remove = xshm_dev_remove,
+};
+
+struct xshm_iter_data {
+	void *data;
+	void (*fn)(struct xshm_dev *, void *);
+};
+
+int xshm_iter(struct device *_dev, void *data)
+{
+	struct xshm_dev *dev = container_of(_dev, struct xshm_dev, dev);
+	struct xshm_iter_data *iter_data = data;
+
+	iter_data->fn(dev, iter_data->data);
+	return 0;
+}
+
+void xshm_foreach_dev(void fn(struct xshm_dev *, void *), void *data)
+{
+	struct xshm_iter_data iter = {
+		.data = data,
+		.fn = fn
+	};
+
+	bus_for_each_dev(&xshm_bus, NULL, &iter, xshm_iter);
+}
+EXPORT_SYMBOL_GPL(xshm_foreach_dev);
+
+int xshm_register_driver(struct xshm_driver *driver)
+{
+	driver->driver.bus = &xshm_bus;
+	return driver_register(&driver->driver);
+}
+EXPORT_SYMBOL_GPL(xshm_register_driver);
+
+void xshm_unregister_driver(struct xshm_driver *driver)
+{
+	driver_unregister(&driver->driver);
+}
+EXPORT_SYMBOL_GPL(xshm_unregister_driver);
+
+int xshm_register_device(struct xshm_dev *dev)
+{
+	int err;
+
+	dev->dev.bus = &xshm_bus;
+	err = device_register(&dev->dev);
+	return err;
+}
+EXPORT_SYMBOL_GPL(xshm_register_device);
+
+void xshm_unregister_device(struct xshm_dev *dev)
+{
+	device_unregister(&dev->dev);
+}
+EXPORT_SYMBOL_GPL(xshm_unregister_device);
+
+static int xshm_bus_init(void)
+{
+	if (bus_register(&xshm_bus) != 0)
+		panic("xshm bus registration failed");
+	return 0;
+}
+
+static void __exit xshm_bus_exit(void)
+{
+	bus_unregister(&xshm_bus);
+}
+
+core_initcall(xshm_bus_init);
+module_exit(xshm_bus_exit);
-- 
1.7.1

