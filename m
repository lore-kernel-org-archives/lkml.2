Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab2AaItI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 03:49:08 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:64111 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753348Ab2AaItF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 03:49:05 -0500
From: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Linus Walleij <linus.walleij@linaro.org>,
        sjurbren@gmail.com,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [RESEND PATCHv5 06/11] modem_shm: Add SHM device bus.
Date: Tue, 31 Jan 2012 09:48:41 +0100
Message-Id: <1327999726-8774-7-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1327999726-8774-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1327999726-8774-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a simple shm device bus, providing device and driver registration
and a simple device iterator. Device mode (packet or stream) is used
for matching device and driver.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/modem_shm/shm_bus.c |  113 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 113 insertions(+), 0 deletions(-)
 create mode 100644 drivers/modem_shm/shm_bus.c

diff --git a/drivers/modem_shm/shm_bus.c b/drivers/modem_shm/shm_bus.c
new file mode 100644
index 0000000..6ca238d
--- /dev/null
+++ b/drivers/modem_shm/shm_bus.c
@@ -0,0 +1,113 @@
+/*
+ * Copyright (C) ST-Ericsson AB 2012
+ * Author: Sjur Brændeland / sjur.brandeland@stericsson.com
+ * License terms: GNU General Public License (GPL) version 2
+ */
+
+#include <linux/spinlock.h>
+#include <linux/module.h>
+#include <linux/modem_shm/shm_dev.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Sjur Brændland <sjur.brandeland@stericsson.com>");
+
+static int shm_dev_match(struct device *_dv, struct device_driver *_dr)
+{
+	struct shm_dev *dev = container_of(_dv, struct shm_dev, dev);
+	struct shm_driver *drv = container_of(_dr, struct shm_driver, driver);
+
+	return drv->mode ==  (drv->mode & dev->cfg.mode);
+}
+
+static int shm_dev_probe(struct device *_d)
+{
+	struct shm_dev *dev = container_of(_d, struct shm_dev, dev);
+	struct shm_driver *drv = container_of(dev->dev.driver,
+						 struct shm_driver, driver);
+	return drv->probe(dev);
+}
+
+static int shm_dev_remove(struct device *_d)
+{
+	struct shm_dev *dev = container_of(_d, struct shm_dev, dev);
+	struct shm_driver *drv = container_of(dev->dev.driver,
+						 struct shm_driver, driver);
+	drv->remove(dev);
+	return 0;
+}
+
+static struct bus_type shm_bus = {
+	.name  = "modem_shm",
+	.match = shm_dev_match,
+	.probe = shm_dev_probe,
+	.remove = shm_dev_remove,
+};
+
+struct shm_iter_data {
+	void *data;
+	void (*fn)(struct shm_dev *, void *);
+};
+
+int shm_iter(struct device *_dev, void *data)
+{
+	struct shm_dev *dev = container_of(_dev, struct shm_dev, dev);
+	struct shm_iter_data *iter_data = data;
+
+	iter_data->fn(dev, iter_data->data);
+	return 0;
+}
+
+void modem_shm_foreach_dev(void fn(struct shm_dev *, void *), void *data)
+{
+	struct shm_iter_data iter = {
+		.data = data,
+		.fn = fn
+	};
+
+	bus_for_each_dev(&shm_bus, NULL, &iter, shm_iter);
+}
+EXPORT_SYMBOL_GPL(modem_shm_foreach_dev);
+
+int modem_shm_register_driver(struct shm_driver *driver)
+{
+	driver->driver.bus = &shm_bus;
+	return driver_register(&driver->driver);
+}
+EXPORT_SYMBOL_GPL(modem_shm_register_driver);
+
+void modem_shm_unregister_driver(struct shm_driver *driver)
+{
+	driver_unregister(&driver->driver);
+}
+EXPORT_SYMBOL_GPL(modem_shm_unregister_driver);
+
+int modem_shm_register_device(struct shm_dev *dev)
+{
+	int err;
+
+	dev->dev.bus = &shm_bus;
+	err = device_register(&dev->dev);
+	return err;
+}
+EXPORT_SYMBOL_GPL(modem_shm_register_device);
+
+void modem_shm_unregister_device(struct shm_dev *dev)
+{
+	device_unregister(&dev->dev);
+}
+EXPORT_SYMBOL_GPL(modem_shm_unregister_device);
+
+static int shm_bus_init(void)
+{
+	if (bus_register(&shm_bus) != 0)
+		panic("shm bus registration failed");
+	return 0;
+}
+
+static void __exit shm_bus_exit(void)
+{
+	bus_unregister(&shm_bus);
+}
+
+core_initcall(shm_bus_init);
+module_exit(shm_bus_exit);
-- 
1.7.0.4

