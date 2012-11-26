Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037Ab2KZNRw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 08:17:52 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3969 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754339Ab2KZNQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 08:16:19 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 26 Nov 2012 05:16:13 -0800
From: Terje Bergstrom <tbergstrom@nvidia.com>
To: <thierry.reding@avionic-design.de>, <linux-tegra@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>
CC: <linux-kernel@vger.kernel.org>, Terje Bergstrom <tbergstrom@nvidia.com>
Subject: [RFC v2 1/8] video: tegra: Add nvhost driver
Date: Mon, 26 Nov 2012 15:19:07 +0200
Message-ID: <1353935954-13763-2-git-send-email-tbergstrom@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add nvhost, the driver for host1x. This patch adds support for reading and
incrementing sync points and dynamic power management.

Signed-off-by: Terje Bergstrom <tbergstrom@nvidia.com>
---
 drivers/video/Kconfig                              |    2 +
 drivers/video/Makefile                             |    2 +
 drivers/video/tegra/host/Kconfig                   |    5 +
 drivers/video/tegra/host/Makefile                  |   10 +
 drivers/video/tegra/host/chip_support.c            |   48 ++
 drivers/video/tegra/host/chip_support.h            |   52 +++
 drivers/video/tegra/host/dev.c                     |   96 ++++
 drivers/video/tegra/host/host1x/Makefile           |    7 +
 drivers/video/tegra/host/host1x/host1x.c           |  204 +++++++++
 drivers/video/tegra/host/host1x/host1x.h           |   78 ++++
 drivers/video/tegra/host/host1x/host1x01.c         |   37 ++
 drivers/video/tegra/host/host1x/host1x01.h         |   29 ++
 .../video/tegra/host/host1x/host1x01_hardware.h    |   36 ++
 drivers/video/tegra/host/host1x/host1x_syncpt.c    |  156 +++++++
 drivers/video/tegra/host/host1x/hw_host1x01_sync.h |  398 ++++++++++++++++
 drivers/video/tegra/host/nvhost_acm.c              |  481 ++++++++++++++++++++
 drivers/video/tegra/host/nvhost_acm.h              |   45 ++
 drivers/video/tegra/host/nvhost_syncpt.c           |  333 ++++++++++++++
 drivers/video/tegra/host/nvhost_syncpt.h           |  136 ++++++
 include/linux/nvhost.h                             |  143 ++++++
 20 files changed, 2298 insertions(+)
 create mode 100644 drivers/video/tegra/host/Kconfig
 create mode 100644 drivers/video/tegra/host/Makefile
 create mode 100644 drivers/video/tegra/host/chip_support.c
 create mode 100644 drivers/video/tegra/host/chip_support.h
 create mode 100644 drivers/video/tegra/host/dev.c
 create mode 100644 drivers/video/tegra/host/host1x/Makefile
 create mode 100644 drivers/video/tegra/host/host1x/host1x.c
 create mode 100644 drivers/video/tegra/host/host1x/host1x.h
 create mode 100644 drivers/video/tegra/host/host1x/host1x01.c
 create mode 100644 drivers/video/tegra/host/host1x/host1x01.h
 create mode 100644 drivers/video/tegra/host/host1x/host1x01_hardware.h
 create mode 100644 drivers/video/tegra/host/host1x/host1x_syncpt.c
 create mode 100644 drivers/video/tegra/host/host1x/hw_host1x01_sync.h
 create mode 100644 drivers/video/tegra/host/nvhost_acm.c
 create mode 100644 drivers/video/tegra/host/nvhost_acm.h
 create mode 100644 drivers/video/tegra/host/nvhost_syncpt.c
 create mode 100644 drivers/video/tegra/host/nvhost_syncpt.h
 create mode 100644 include/linux/nvhost.h

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index fb9a14e..94c861b 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -2463,4 +2463,6 @@ config FB_SH_MOBILE_MERAM
 	  Up to 4 memory channels can be configured, allowing 4 RGB or
 	  2 YCbCr framebuffers to be configured.
 
+source "drivers/video/tegra/host/Kconfig"
+
 endmenu
diff --git a/drivers/video/Makefile b/drivers/video/Makefile
index b936b00..61a4287 100644
--- a/drivers/video/Makefile
+++ b/drivers/video/Makefile
@@ -17,6 +17,8 @@ obj-y				  += backlight/
 
 obj-$(CONFIG_EXYNOS_VIDEO)     += exynos/
 
+obj-$(CONFIG_TEGRA_HOST1X)     += tegra/host/
+
 obj-$(CONFIG_FB_CFB_FILLRECT)  += cfbfillrect.o
 obj-$(CONFIG_FB_CFB_COPYAREA)  += cfbcopyarea.o
 obj-$(CONFIG_FB_CFB_IMAGEBLIT) += cfbimgblt.o
diff --git a/drivers/video/tegra/host/Kconfig b/drivers/video/tegra/host/Kconfig
new file mode 100644
index 0000000..ebe9bbc
--- /dev/null
+++ b/drivers/video/tegra/host/Kconfig
@@ -0,0 +1,5 @@
+config TEGRA_HOST1X
+	tristate "Tegra host1x driver"
+	help
+	  Driver for the Tegra host1x hardware.
+
diff --git a/drivers/video/tegra/host/Makefile b/drivers/video/tegra/host/Makefile
new file mode 100644
index 0000000..3edab4a
--- /dev/null
+++ b/drivers/video/tegra/host/Makefile
@@ -0,0 +1,10 @@
+ccflags-y = -Idrivers/video/tegra/host
+
+nvhost-objs = \
+	nvhost_acm.o \
+	nvhost_syncpt.o \
+	dev.o \
+	chip_support.o
+
+obj-$(CONFIG_TEGRA_HOST1X) += host1x/
+obj-$(CONFIG_TEGRA_HOST1X) += nvhost.o
diff --git a/drivers/video/tegra/host/chip_support.c b/drivers/video/tegra/host/chip_support.c
new file mode 100644
index 0000000..5a44147
--- /dev/null
+++ b/drivers/video/tegra/host/chip_support.c
@@ -0,0 +1,48 @@
+/*
+ * drivers/video/tegra/host/chip_support.c
+ *
+ * Tegra host1x chip support module
+ *
+ * Copyright (c) 2012, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/errno.h>
+#include <linux/types.h>
+#include <linux/slab.h>
+
+#include "chip_support.h"
+#include "host1x/host1x01.h"
+
+struct nvhost_chip_support *nvhost_chip_ops;
+
+struct nvhost_chip_support *nvhost_get_chip_ops(void)
+{
+	return nvhost_chip_ops;
+}
+
+int nvhost_init_chip_support(struct nvhost_master *host)
+{
+	if (nvhost_chip_ops == NULL) {
+		nvhost_chip_ops = kzalloc(sizeof(*nvhost_chip_ops), GFP_KERNEL);
+		if (nvhost_chip_ops == NULL) {
+			pr_err("%s: Cannot allocate nvhost_chip_support\n",
+				__func__);
+			return -ENOMEM;
+		}
+	}
+
+	nvhost_init_host1x01_support(host, nvhost_chip_ops);
+	return 0;
+}
diff --git a/drivers/video/tegra/host/chip_support.h b/drivers/video/tegra/host/chip_support.h
new file mode 100644
index 0000000..acfa2f1
--- /dev/null
+++ b/drivers/video/tegra/host/chip_support.h
@@ -0,0 +1,52 @@
+/*
+ * drivers/video/tegra/host/chip_support.h
+ *
+ * Tegra host1x chip Support
+ *
+ * Copyright (c) 2011-2012, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef _NVHOST_CHIP_SUPPORT_H_
+#define _NVHOST_CHIP_SUPPORT_H_
+
+#include <linux/types.h>
+
+struct output;
+
+struct nvhost_master;
+struct nvhost_syncpt;
+struct platform_device;
+
+struct nvhost_syncpt_ops {
+	void (*reset)(struct nvhost_syncpt *, u32 id);
+	void (*reset_wait_base)(struct nvhost_syncpt *, u32 id);
+	void (*read_wait_base)(struct nvhost_syncpt *, u32 id);
+	u32 (*update_min)(struct nvhost_syncpt *, u32 id);
+	void (*cpu_incr)(struct nvhost_syncpt *, u32 id);
+	void (*debug)(struct nvhost_syncpt *);
+	const char * (*name)(struct nvhost_syncpt *, u32 id);
+};
+
+struct nvhost_chip_support {
+	const char *soc_name;
+	struct nvhost_syncpt_ops syncpt;
+};
+
+struct nvhost_chip_support *nvhost_get_chip_ops(void);
+
+#define syncpt_op()		(nvhost_get_chip_ops()->syncpt)
+
+int nvhost_init_chip_support(struct nvhost_master *host);
+
+#endif /* _NVHOST_CHIP_SUPPORT_H_ */
diff --git a/drivers/video/tegra/host/dev.c b/drivers/video/tegra/host/dev.c
new file mode 100644
index 0000000..98c9c9f
--- /dev/null
+++ b/drivers/video/tegra/host/dev.c
@@ -0,0 +1,96 @@
+/*
+ * drivers/video/tegra/host/dev.c
+ *
+ * Tegra host1x driver
+ *
+ * Copyright (c) 2010-2012, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/module.h>
+#include "host1x/host1x.h"
+#include "nvhost_acm.h"
+
+u32 host1x_syncpt_incr_max(u32 id, u32 incrs)
+{
+	struct nvhost_syncpt *sp = &nvhost->syncpt;
+	return nvhost_syncpt_incr_max(sp, id, incrs);
+}
+EXPORT_SYMBOL(host1x_syncpt_incr_max);
+
+void host1x_syncpt_incr(u32 id)
+{
+	struct nvhost_syncpt *sp = &nvhost->syncpt;
+	nvhost_syncpt_incr(sp, id);
+}
+EXPORT_SYMBOL(host1x_syncpt_incr);
+
+u32 host1x_syncpt_read(u32 id)
+{
+	struct nvhost_syncpt *sp = &nvhost->syncpt;
+	return nvhost_syncpt_read(sp, id);
+}
+EXPORT_SYMBOL(host1x_syncpt_read);
+
+bool host1x_powered(struct platform_device *dev)
+{
+	bool ret = 0;
+
+	/* get the parent */
+	if (dev->dev.parent) {
+		struct platform_device *pdev;
+		pdev = to_platform_device(dev->dev.parent);
+
+		ret = nvhost_module_powered(pdev);
+	} else {
+		dev_warn(&dev->dev, "Cannot return power state, no parent\n");
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(host1x_powered);
+
+void host1x_busy(struct platform_device *dev)
+{
+	/* get the parent */
+	if (dev->dev.parent) {
+		struct platform_device *pdev;
+		pdev = to_platform_device(dev->dev.parent);
+
+		nvhost_module_busy(pdev);
+	} else {
+		dev_warn(&dev->dev, "Cannot turn on, no parent\n");
+	}
+}
+EXPORT_SYMBOL(host1x_busy);
+
+void host1x_idle(struct platform_device *dev)
+{
+	/* get the parent */
+	if (dev->dev.parent) {
+		struct platform_device *pdev;
+		pdev = to_platform_device(dev->dev.parent);
+
+		nvhost_module_idle(pdev);
+	} else {
+		dev_warn(&dev->dev, "Cannot idle, no parent\n");
+	}
+}
+EXPORT_SYMBOL(host1x_idle);
+
+MODULE_AUTHOR("Terje Bergstrom <tbergstrom@nvidia.com>");
+MODULE_DESCRIPTION("Host1x driver for Tegra products");
+MODULE_VERSION("1.0");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform-nvhost");
diff --git a/drivers/video/tegra/host/host1x/Makefile b/drivers/video/tegra/host/host1x/Makefile
new file mode 100644
index 0000000..330d507
--- /dev/null
+++ b/drivers/video/tegra/host/host1x/Makefile
@@ -0,0 +1,7 @@
+ccflags-y = -Idrivers/video/tegra/host
+
+nvhost-host1x-objs  = \
+	host1x.o \
+	host1x01.o
+
+obj-$(CONFIG_TEGRA_HOST1X) += nvhost-host1x.o
diff --git a/drivers/video/tegra/host/host1x/host1x.c b/drivers/video/tegra/host/host1x/host1x.c
new file mode 100644
index 0000000..77ff00b
--- /dev/null
+++ b/drivers/video/tegra/host/host1x/host1x.c
@@ -0,0 +1,204 @@
+/*
+ * drivers/video/tegra/host/host1x.c
+ *
+ * Tegra host1x Driver Entrypoint
+ *
+ * Copyright (c) 2010-2012, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/slab.h>
+#include <linux/fs.h>
+#include <linux/cdev.h>
+#include <linux/uaccess.h>
+#include <linux/file.h>
+#include <linux/clk.h>
+#include <linux/hrtimer.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/nvhost.h>
+
+#include "host1x/host1x.h"
+#include "nvhost_acm.h"
+#include "chip_support.h"
+
+#define DRIVER_NAME		"tegra-host1x"
+
+struct nvhost_master *nvhost;
+
+static void power_on_host(struct platform_device *dev)
+{
+	struct nvhost_master *host = nvhost_get_private_data(dev);
+
+	nvhost_syncpt_reset(&host->syncpt);
+}
+
+static int power_off_host(struct platform_device *dev)
+{
+	struct nvhost_master *host = nvhost_get_private_data(dev);
+
+	nvhost_syncpt_save(&host->syncpt);
+	return 0;
+}
+
+static void nvhost_free_resources(struct nvhost_master *host)
+{
+}
+
+static int __devinit nvhost_alloc_resources(struct nvhost_master *host)
+{
+	int err;
+
+	err = nvhost_init_chip_support(host);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static int __devinit nvhost_probe(struct platform_device *dev)
+{
+	struct nvhost_master *host;
+	struct resource *regs, *intr0, *intr1;
+	int i, err;
+	struct nvhost_device_data *pdata =
+		(struct nvhost_device_data *)dev->dev.platform_data;
+
+	regs = platform_get_resource(dev, IORESOURCE_MEM, 0);
+	intr0 = platform_get_resource(dev, IORESOURCE_IRQ, 0);
+	intr1 = platform_get_resource(dev, IORESOURCE_IRQ, 1);
+
+	if (!regs || !intr0 || !intr1) {
+		dev_err(&dev->dev, "missing required platform resources\n");
+		return -ENXIO;
+	}
+
+	host = devm_kzalloc(&dev->dev, sizeof(*host), GFP_KERNEL);
+	if (!host)
+		return -ENOMEM;
+
+	nvhost = host;
+
+	host->dev = dev;
+
+	/* Copy host1x parameters. The private_data gets replaced
+	 * by nvhost_master later */
+	memcpy(&host->info, pdata->private_data,
+			sizeof(struct host1x_device_info));
+
+	pdata->finalize_poweron = power_on_host;
+	pdata->prepare_poweroff = power_off_host;
+
+	pdata->pdev = dev;
+
+	/* set common host1x device data */
+	platform_set_drvdata(dev, pdata);
+
+	/* set private host1x device data */
+	nvhost_set_private_data(dev, host);
+
+	host->aperture = devm_request_and_ioremap(&dev->dev, regs);
+	if (!host->aperture) {
+		dev_err(&dev->dev, "failed to remap host registers\n");
+		err = -ENXIO;
+		goto fail;
+	}
+
+	err = nvhost_alloc_resources(host);
+	if (err) {
+		dev_err(&dev->dev, "failed to init chip support\n");
+		goto fail;
+	}
+
+	err = nvhost_syncpt_init(dev, &host->syncpt);
+	if (err)
+		goto fail;
+
+	err = nvhost_module_init(dev);
+	if (err)
+		goto fail;
+
+	for (i = 0; i < pdata->num_clks; i++)
+		clk_prepare_enable(pdata->clk[i]);
+	nvhost_syncpt_reset(&host->syncpt);
+	for (i = 0; i < pdata->num_clks; i++)
+		clk_disable_unprepare(pdata->clk[i]);
+
+	dev_info(&dev->dev, "initialized\n");
+
+	return 0;
+
+fail:
+	nvhost_free_resources(host);
+	kfree(host);
+	return err;
+}
+
+static int __exit nvhost_remove(struct platform_device *dev)
+{
+	struct nvhost_master *host = nvhost_get_private_data(dev);
+	nvhost_syncpt_deinit(&host->syncpt);
+	nvhost_module_deinit(dev);
+	nvhost_free_resources(host);
+	return 0;
+}
+
+static int nvhost_suspend(struct platform_device *dev, pm_message_t state)
+{
+	struct nvhost_master *host = nvhost_get_private_data(dev);
+	int ret = 0;
+
+	ret = nvhost_module_suspend(host->dev);
+	dev_info(&dev->dev, "suspend status: %d\n", ret);
+
+	return ret;
+}
+
+static int nvhost_resume(struct platform_device *dev)
+{
+	dev_info(&dev->dev, "resuming\n");
+	return 0;
+}
+
+static struct of_device_id host1x_match[] __devinitdata = {
+	{ .compatible = "nvidia,tegra20-host1x", },
+	{ .compatible = "nvidia,tegra30-host1x", },
+	{ },
+};
+
+static struct platform_driver platform_driver = {
+	.probe = nvhost_probe,
+	.remove = __exit_p(nvhost_remove),
+	.suspend = nvhost_suspend,
+	.resume = nvhost_resume,
+	.driver = {
+		.owner = THIS_MODULE,
+		.name = DRIVER_NAME,
+		.of_match_table = of_match_ptr(host1x_match),
+	},
+};
+
+static int __init nvhost_mod_init(void)
+{
+	return platform_driver_register(&platform_driver);
+}
+
+static void __exit nvhost_mod_exit(void)
+{
+	platform_driver_unregister(&platform_driver);
+}
+
+module_init(nvhost_mod_init);
+module_exit(nvhost_mod_exit);
+
diff --git a/drivers/video/tegra/host/host1x/host1x.h b/drivers/video/tegra/host/host1x/host1x.h
new file mode 100644
index 0000000..76748ac
--- /dev/null
+++ b/drivers/video/tegra/host/host1x/host1x.h
@@ -0,0 +1,78 @@
+/*
+ * drivers/video/tegra/host/host1x/host1x.h
+ *
+ * Tegra host1x Driver Entrypoint
+ *
+ * Copyright (c) 2010-2012, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef __NVHOST_HOST1X_H
+#define __NVHOST_HOST1X_H
+
+#include <linux/cdev.h>
+#include <linux/nvhost.h>
+
+#include "nvhost_syncpt.h"
+
+#define TRACE_MAX_LENGTH	128U
+#define IFACE_NAME		"nvhost"
+
+struct nvhost_master {
+	void __iomem *aperture;
+	void __iomem *sync_aperture;
+	struct nvhost_syncpt syncpt;
+	struct platform_device *dev;
+	struct host1x_device_info info;
+};
+
+extern struct nvhost_master *nvhost;
+
+static inline void *nvhost_get_private_data(struct platform_device *_dev)
+{
+	struct nvhost_device_data *pdata =
+		(struct nvhost_device_data *)platform_get_drvdata(_dev);
+	WARN_ON(!pdata);
+	return (pdata && pdata->private_data) ? pdata->private_data : NULL;
+}
+
+static inline void nvhost_set_private_data(struct platform_device *_dev,
+	void *priv_data)
+{
+	struct nvhost_device_data *pdata =
+		(struct nvhost_device_data *)platform_get_drvdata(_dev);
+	WARN_ON(!pdata);
+	if (pdata)
+		pdata->private_data = priv_data;
+}
+
+static inline
+struct nvhost_master *nvhost_get_host(struct platform_device *_dev)
+{
+	struct platform_device *pdev;
+
+	if (_dev->dev.parent) {
+		pdev = to_platform_device(_dev->dev.parent);
+		return nvhost_get_private_data(pdev);
+	} else
+		return nvhost_get_private_data(_dev);
+}
+
+static inline
+struct platform_device *nvhost_get_parent(struct platform_device *_dev)
+{
+	return _dev->dev.parent ? to_platform_device(_dev->dev.parent) : NULL;
+}
+
+#endif
diff --git a/drivers/video/tegra/host/host1x/host1x01.c b/drivers/video/tegra/host/host1x/host1x01.c
new file mode 100644
index 0000000..d53302d
--- /dev/null
+++ b/drivers/video/tegra/host/host1x/host1x01.c
@@ -0,0 +1,37 @@
+/*
+ * drivers/video/tegra/host/host1x01.c
+ *
+ * Host1x init for T20 and T30 Architecture Chips
+ *
+ * Copyright (c) 2011-2012, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/nvhost.h>
+
+#include "host1x/host1x01.h"
+#include "host1x/host1x.h"
+#include "host1x/host1x01_hardware.h"
+#include "chip_support.h"
+
+#include "host1x/host1x_syncpt.c"
+
+int nvhost_init_host1x01_support(struct nvhost_master *host,
+	struct nvhost_chip_support *op)
+{
+	host->sync_aperture = host->aperture + HOST1X_CHANNEL_SYNC_REG_BASE;
+	op->syncpt = host1x_syncpt_ops;
+
+	return 0;
+}
diff --git a/drivers/video/tegra/host/host1x/host1x01.h b/drivers/video/tegra/host/host1x/host1x01.h
new file mode 100644
index 0000000..91624d66
--- /dev/null
+++ b/drivers/video/tegra/host/host1x/host1x01.h
@@ -0,0 +1,29 @@
+/*
+ * drivers/video/tegra/host/host1x01.h
+ *
+ * Host1x init for T20 and T30 Architecture Chips
+ *
+ * Copyright (c) 2011-2012, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef NVHOST_HOST1X01_H
+#define NVHOST_HOST1X01_H
+
+struct nvhost_master;
+struct nvhost_chip_support;
+
+int nvhost_init_host1x01_support(struct nvhost_master *,
+	struct nvhost_chip_support *);
+
+#endif /* NVHOST_HOST1X01_H_ */
diff --git a/drivers/video/tegra/host/host1x/host1x01_hardware.h b/drivers/video/tegra/host/host1x/host1x01_hardware.h
new file mode 100644
index 0000000..0da7e06
--- /dev/null
+++ b/drivers/video/tegra/host/host1x/host1x01_hardware.h
@@ -0,0 +1,36 @@
+/*
+ * drivers/video/tegra/host/host1x/host1x01_hardware.h
+ *
+ * Tegra host1x Register Offsets for Tegra20 and Tegra30
+ *
+ * Copyright (c) 2010-2012 NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef __NVHOST_HOST1X01_HARDWARE_H
+#define __NVHOST_HOST1X01_HARDWARE_H
+
+#include <linux/types.h>
+#include <linux/bitops.h>
+#include "hw_host1x01_sync.h"
+
+/* channel registers */
+#define NV_HOST1X_CHANNEL_MAP_SIZE_BYTES 16384
+#define NV_HOST1X_SYNC_MLOCK_NUM 16
+
+/* sync registers */
+#define HOST1X_CHANNEL_SYNC_REG_BASE   0x3000
+#define NV_HOST1X_NB_MLOCKS 16
+
+#endif
diff --git a/drivers/video/tegra/host/host1x/host1x_syncpt.c b/drivers/video/tegra/host/host1x/host1x_syncpt.c
new file mode 100644
index 0000000..57cc1b1
--- /dev/null
+++ b/drivers/video/tegra/host/host1x/host1x_syncpt.c
@@ -0,0 +1,156 @@
+/*
+ * drivers/video/tegra/host/host1x/host1x_syncpt.c
+ *
+ * Tegra host1x Syncpoints
+ *
+ * Copyright (c) 2010-2012, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/io.h>
+#include "nvhost_syncpt.h"
+#include "nvhost_acm.h"
+#include "host1x.h"
+#include "chip_support.h"
+
+/**
+ * Write the current syncpoint value back to hw.
+ */
+static void host1x_syncpt_reset(struct nvhost_syncpt *sp, u32 id)
+{
+	struct nvhost_master *dev = syncpt_to_dev(sp);
+	int min = nvhost_syncpt_read_min(sp, id);
+	writel(min, dev->sync_aperture + (host1x_sync_syncpt_0_r() + id * 4));
+}
+
+/**
+ * Write the current waitbase value back to hw.
+ */
+static void host1x_syncpt_reset_wait_base(struct nvhost_syncpt *sp, u32 id)
+{
+	struct nvhost_master *dev = syncpt_to_dev(sp);
+	writel(sp->base_val[id],
+		dev->sync_aperture + (host1x_sync_syncpt_base_0_r() + id * 4));
+}
+
+/**
+ * Read waitbase value from hw.
+ */
+static void host1x_syncpt_read_wait_base(struct nvhost_syncpt *sp, u32 id)
+{
+	struct nvhost_master *dev = syncpt_to_dev(sp);
+	sp->base_val[id] = readl(dev->sync_aperture +
+				(host1x_sync_syncpt_base_0_r() + id * 4));
+}
+
+/**
+ * Updates the last value read from hardware.
+ * (was nvhost_syncpt_update_min)
+ */
+static u32 host1x_syncpt_update_min(struct nvhost_syncpt *sp, u32 id)
+{
+	struct nvhost_master *dev = syncpt_to_dev(sp);
+	void __iomem *sync_regs = dev->sync_aperture;
+	u32 old, live;
+
+	do {
+		old = nvhost_syncpt_read_min(sp, id);
+		live = readl(sync_regs + (host1x_sync_syncpt_0_r() + id * 4));
+	} while ((u32)atomic_cmpxchg(&sp->min_val[id], old, live) != old);
+
+	if (!nvhost_syncpt_check_max(sp, id, live))
+		dev_err(&syncpt_to_dev(sp)->dev->dev,
+				"%s failed: id=%u, min=%d, max=%d\n",
+				__func__,
+				id,
+				nvhost_syncpt_read_min(sp, id),
+				nvhost_syncpt_read_max(sp, id));
+
+	return live;
+}
+
+/**
+ * Write a cpu syncpoint increment to the hardware, without touching
+ * the cache. Caller is responsible for host being powered.
+ */
+static void host1x_syncpt_cpu_incr(struct nvhost_syncpt *sp, u32 id)
+{
+	struct nvhost_master *dev = syncpt_to_dev(sp);
+	u32 reg_offset = id / 32;
+
+	if (!nvhost_module_powered(dev->dev)) {
+		dev_err(&syncpt_to_dev(sp)->dev->dev,
+			"Trying to access host1x when it's off");
+		return;
+	}
+
+	if (!nvhost_syncpt_client_managed(sp, id)
+			&& nvhost_syncpt_min_eq_max(sp, id)) {
+		dev_err(&syncpt_to_dev(sp)->dev->dev,
+			"Trying to increment syncpoint id %d beyond max\n",
+			id);
+		return;
+	}
+	writel(BIT_MASK(id), dev->sync_aperture +
+			host1x_sync_syncpt_cpu_incr_r() + reg_offset * 4);
+	wmb();
+}
+
+static const char *host1x_syncpt_name(struct nvhost_syncpt *sp, u32 id)
+{
+	struct host1x_device_info *info = &syncpt_to_dev(sp)->info;
+	const char *name = NULL;
+
+	if (id < info->nb_pts)
+		name = info->syncpt_names[id];
+
+	return name ? name : "";
+}
+
+static void host1x_syncpt_debug(struct nvhost_syncpt *sp)
+{
+	u32 i;
+	for (i = 0; i < nvhost_syncpt_nb_pts(sp); i++) {
+		u32 max = nvhost_syncpt_read_max(sp, i);
+		u32 min = nvhost_syncpt_update_min(sp, i);
+		if (!max && !min)
+			continue;
+		dev_info(&syncpt_to_dev(sp)->dev->dev,
+			"id %d (%s) min %d max %d\n",
+			i, syncpt_op().name(sp, i),
+			min, max);
+
+	}
+
+	for (i = 0; i < nvhost_syncpt_nb_bases(sp); i++) {
+		u32 base_val;
+		host1x_syncpt_read_wait_base(sp, i);
+		base_val = sp->base_val[i];
+		if (base_val)
+			dev_info(&syncpt_to_dev(sp)->dev->dev,
+					"waitbase id %d val %d\n",
+					i, base_val);
+
+	}
+}
+
+static const struct nvhost_syncpt_ops host1x_syncpt_ops = {
+	.reset = host1x_syncpt_reset,
+	.reset_wait_base = host1x_syncpt_reset_wait_base,
+	.read_wait_base = host1x_syncpt_read_wait_base,
+	.update_min = host1x_syncpt_update_min,
+	.cpu_incr = host1x_syncpt_cpu_incr,
+	.debug = host1x_syncpt_debug,
+	.name = host1x_syncpt_name,
+};
diff --git a/drivers/video/tegra/host/host1x/hw_host1x01_sync.h b/drivers/video/tegra/host/host1x/hw_host1x01_sync.h
new file mode 100644
index 0000000..67f0cbf
--- /dev/null
+++ b/drivers/video/tegra/host/host1x/hw_host1x01_sync.h
@@ -0,0 +1,398 @@
+/*
+ * drivers/video/tegra/host/host1x/hw_host1x_sync_host1x.h
+ *
+ * Copyright (c) 2012, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ */
+
+ /*
+  * Function naming determines intended use:
+  *
+  *     <x>_r(void) : Returns the offset for register <x>.
+  *
+  *     <x>_w(void) : Returns the word offset for word (4 byte) element <x>.
+  *
+  *     <x>_<y>_s(void) : Returns size of field <y> of register <x> in bits.
+  *
+  *     <x>_<y>_f(u32 v) : Returns a value based on 'v' which has been shifted
+  *         and masked to place it at field <y> of register <x>.  This value
+  *         can be |'d with others to produce a full register value for
+  *         register <x>.
+  *
+  *     <x>_<y>_m(void) : Returns a mask for field <y> of register <x>.  This
+  *         value can be ~'d and then &'d to clear the value of field <y> for
+  *         register <x>.
+  *
+  *     <x>_<y>_<z>_f(void) : Returns the constant value <z> after being shifted
+  *         to place it at field <y> of register <x>.  This value can be |'d
+  *         with others to produce a full register value for <x>.
+  *
+  *     <x>_<y>_v(u32 r) : Returns the value of field <y> from a full register
+  *         <x> value 'r' after being shifted to place its LSB at bit 0.
+  *         This value is suitable for direct comparison with other unshifted
+  *         values appropriate for use in field <y> of register <x>.
+  *
+  *     <x>_<y>_<z>_v(void) : Returns the constant value for <z> defined for
+  *         field <y> of register <x>.  This value is suitable for direct
+  *         comparison with unshifted values appropriate for use in field <y>
+  *         of register <x>.
+  */
+
+#ifndef __hw_host1x_sync_host1x_h__
+#define __hw_host1x_sync_host1x_h__
+/*This file is autogenerated.  Do not edit. */
+
+static inline u32 host1x_sync_intmask_r(void)
+{
+	return 0x4;
+}
+static inline u32 host1x_sync_intc0mask_r(void)
+{
+	return 0x8;
+}
+static inline u32 host1x_sync_hintstatus_r(void)
+{
+	return 0x20;
+}
+static inline u32 host1x_sync_hintmask_r(void)
+{
+	return 0x24;
+}
+static inline u32 host1x_sync_hintstatus_ext_r(void)
+{
+	return 0x28;
+}
+static inline u32 host1x_sync_hintstatus_ext_ip_read_int_s(void)
+{
+	return 1;
+}
+static inline u32 host1x_sync_hintstatus_ext_ip_read_int_f(u32 v)
+{
+	return (v & 0x1) << 30;
+}
+static inline u32 host1x_sync_hintstatus_ext_ip_read_int_m(void)
+{
+	return 0x1 << 30;
+}
+static inline u32 host1x_sync_hintstatus_ext_ip_read_int_v(u32 r)
+{
+	return (r >> 30) & 0x1;
+}
+static inline u32 host1x_sync_hintstatus_ext_ip_write_int_s(void)
+{
+	return 1;
+}
+static inline u32 host1x_sync_hintstatus_ext_ip_write_int_f(u32 v)
+{
+	return (v & 0x1) << 31;
+}
+static inline u32 host1x_sync_hintstatus_ext_ip_write_int_m(void)
+{
+	return 0x1 << 31;
+}
+static inline u32 host1x_sync_hintstatus_ext_ip_write_int_v(u32 r)
+{
+	return (r >> 31) & 0x1;
+}
+static inline u32 host1x_sync_hintmask_ext_r(void)
+{
+	return 0x2c;
+}
+static inline u32 host1x_sync_syncpt_thresh_cpu0_int_status_r(void)
+{
+	return 0x40;
+}
+static inline u32 host1x_sync_syncpt_thresh_cpu1_int_status_r(void)
+{
+	return 0x48;
+}
+static inline u32 host1x_sync_syncpt_thresh_int_disable_r(void)
+{
+	return 0x60;
+}
+static inline u32 host1x_sync_syncpt_thresh_int_enable_cpu0_r(void)
+{
+	return 0x68;
+}
+static inline u32 host1x_sync_cf0_setup_r(void)
+{
+	return 0x80;
+}
+static inline u32 host1x_sync_cf0_setup_cf0_base_s(void)
+{
+	return 9;
+}
+static inline u32 host1x_sync_cf0_setup_cf0_base_f(u32 v)
+{
+	return (v & 0x1ff) << 0;
+}
+static inline u32 host1x_sync_cf0_setup_cf0_base_m(void)
+{
+	return 0x1ff << 0;
+}
+static inline u32 host1x_sync_cf0_setup_cf0_base_v(u32 r)
+{
+	return (r >> 0) & 0x1ff;
+}
+static inline u32 host1x_sync_cf0_setup_cf0_limit_s(void)
+{
+	return 9;
+}
+static inline u32 host1x_sync_cf0_setup_cf0_limit_f(u32 v)
+{
+	return (v & 0x1ff) << 16;
+}
+static inline u32 host1x_sync_cf0_setup_cf0_limit_m(void)
+{
+	return 0x1ff << 16;
+}
+static inline u32 host1x_sync_cf0_setup_cf0_limit_v(u32 r)
+{
+	return (r >> 16) & 0x1ff;
+}
+static inline u32 host1x_sync_cmdproc_stop_r(void)
+{
+	return 0xac;
+}
+static inline u32 host1x_sync_ch_teardown_r(void)
+{
+	return 0xb0;
+}
+static inline u32 host1x_sync_usec_clk_r(void)
+{
+	return 0x1a4;
+}
+static inline u32 host1x_sync_ctxsw_timeout_cfg_r(void)
+{
+	return 0x1a8;
+}
+static inline u32 host1x_sync_ip_busy_timeout_r(void)
+{
+	return 0x1bc;
+}
+static inline u32 host1x_sync_ip_read_timeout_addr_r(void)
+{
+	return 0x1c0;
+}
+static inline u32 host1x_sync_ip_write_timeout_addr_r(void)
+{
+	return 0x1c4;
+}
+static inline u32 host1x_sync_mlock_0_r(void)
+{
+	return 0x2c0;
+}
+static inline u32 host1x_sync_mlock_owner_0_r(void)
+{
+	return 0x340;
+}
+static inline u32 host1x_sync_mlock_owner_0_mlock_owner_chid_0_s(void)
+{
+	return 4;
+}
+static inline u32 host1x_sync_mlock_owner_0_mlock_owner_chid_0_f(u32 v)
+{
+	return (v & 0xf) << 8;
+}
+static inline u32 host1x_sync_mlock_owner_0_mlock_owner_chid_0_m(void)
+{
+	return 0xf << 8;
+}
+static inline u32 host1x_sync_mlock_owner_0_mlock_owner_chid_0_v(u32 r)
+{
+	return (r >> 8) & 0xf;
+}
+static inline u32 host1x_sync_mlock_owner_0_mlock_cpu_owns_0_s(void)
+{
+	return 1;
+}
+static inline u32 host1x_sync_mlock_owner_0_mlock_cpu_owns_0_f(u32 v)
+{
+	return (v & 0x1) << 1;
+}
+static inline u32 host1x_sync_mlock_owner_0_mlock_cpu_owns_0_m(void)
+{
+	return 0x1 << 1;
+}
+static inline u32 host1x_sync_mlock_owner_0_mlock_cpu_owns_0_v(u32 r)
+{
+	return (r >> 1) & 0x1;
+}
+static inline u32 host1x_sync_mlock_owner_0_mlock_ch_owns_0_s(void)
+{
+	return 1;
+}
+static inline u32 host1x_sync_mlock_owner_0_mlock_ch_owns_0_f(u32 v)
+{
+	return (v & 0x1) << 0;
+}
+static inline u32 host1x_sync_mlock_owner_0_mlock_ch_owns_0_m(void)
+{
+	return 0x1 << 0;
+}
+static inline u32 host1x_sync_mlock_owner_0_mlock_ch_owns_0_v(u32 r)
+{
+	return (r >> 0) & 0x1;
+}
+static inline u32 host1x_sync_syncpt_0_r(void)
+{
+	return 0x400;
+}
+static inline u32 host1x_sync_syncpt_int_thresh_0_r(void)
+{
+	return 0x500;
+}
+static inline u32 host1x_sync_syncpt_base_0_r(void)
+{
+	return 0x600;
+}
+static inline u32 host1x_sync_syncpt_cpu_incr_r(void)
+{
+	return 0x700;
+}
+static inline u32 host1x_sync_cbread0_r(void)
+{
+	return 0x720;
+}
+static inline u32 host1x_sync_cfpeek_ctrl_r(void)
+{
+	return 0x74c;
+}
+static inline u32 host1x_sync_cfpeek_ctrl_cfpeek_addr_s(void)
+{
+	return 9;
+}
+static inline u32 host1x_sync_cfpeek_ctrl_cfpeek_addr_f(u32 v)
+{
+	return (v & 0x1ff) << 0;
+}
+static inline u32 host1x_sync_cfpeek_ctrl_cfpeek_addr_m(void)
+{
+	return 0x1ff << 0;
+}
+static inline u32 host1x_sync_cfpeek_ctrl_cfpeek_addr_v(u32 r)
+{
+	return (r >> 0) & 0x1ff;
+}
+static inline u32 host1x_sync_cfpeek_ctrl_cfpeek_channr_s(void)
+{
+	return 3;
+}
+static inline u32 host1x_sync_cfpeek_ctrl_cfpeek_channr_f(u32 v)
+{
+	return (v & 0x7) << 16;
+}
+static inline u32 host1x_sync_cfpeek_ctrl_cfpeek_channr_m(void)
+{
+	return 0x7 << 16;
+}
+static inline u32 host1x_sync_cfpeek_ctrl_cfpeek_channr_v(u32 r)
+{
+	return (r >> 16) & 0x7;
+}
+static inline u32 host1x_sync_cfpeek_ctrl_cfpeek_ena_s(void)
+{
+	return 1;
+}
+static inline u32 host1x_sync_cfpeek_ctrl_cfpeek_ena_f(u32 v)
+{
+	return (v & 0x1) << 31;
+}
+static inline u32 host1x_sync_cfpeek_ctrl_cfpeek_ena_m(void)
+{
+	return 0x1 << 31;
+}
+static inline u32 host1x_sync_cfpeek_ctrl_cfpeek_ena_v(u32 r)
+{
+	return (r >> 31) & 0x1;
+}
+static inline u32 host1x_sync_cfpeek_read_r(void)
+{
+	return 0x750;
+}
+static inline u32 host1x_sync_cfpeek_ptrs_r(void)
+{
+	return 0x754;
+}
+static inline u32 host1x_sync_cfpeek_ptrs_cf_rd_ptr_s(void)
+{
+	return 9;
+}
+static inline u32 host1x_sync_cfpeek_ptrs_cf_rd_ptr_f(u32 v)
+{
+	return (v & 0x1ff) << 0;
+}
+static inline u32 host1x_sync_cfpeek_ptrs_cf_rd_ptr_m(void)
+{
+	return 0x1ff << 0;
+}
+static inline u32 host1x_sync_cfpeek_ptrs_cf_rd_ptr_v(u32 r)
+{
+	return (r >> 0) & 0x1ff;
+}
+static inline u32 host1x_sync_cfpeek_ptrs_cf_wr_ptr_s(void)
+{
+	return 9;
+}
+static inline u32 host1x_sync_cfpeek_ptrs_cf_wr_ptr_f(u32 v)
+{
+	return (v & 0x1ff) << 16;
+}
+static inline u32 host1x_sync_cfpeek_ptrs_cf_wr_ptr_m(void)
+{
+	return 0x1ff << 16;
+}
+static inline u32 host1x_sync_cfpeek_ptrs_cf_wr_ptr_v(u32 r)
+{
+	return (r >> 16) & 0x1ff;
+}
+static inline u32 host1x_sync_cbstat_0_r(void)
+{
+	return 0x758;
+}
+static inline u32 host1x_sync_cbstat_0_cboffset0_s(void)
+{
+	return 16;
+}
+static inline u32 host1x_sync_cbstat_0_cboffset0_f(u32 v)
+{
+	return (v & 0xffff) << 0;
+}
+static inline u32 host1x_sync_cbstat_0_cboffset0_m(void)
+{
+	return 0xffff << 0;
+}
+static inline u32 host1x_sync_cbstat_0_cboffset0_v(u32 r)
+{
+	return (r >> 0) & 0xffff;
+}
+static inline u32 host1x_sync_cbstat_0_cbclass0_s(void)
+{
+	return 10;
+}
+static inline u32 host1x_sync_cbstat_0_cbclass0_f(u32 v)
+{
+	return (v & 0x3ff) << 16;
+}
+static inline u32 host1x_sync_cbstat_0_cbclass0_m(void)
+{
+	return 0x3ff << 16;
+}
+static inline u32 host1x_sync_cbstat_0_cbclass0_v(u32 r)
+{
+	return (r >> 16) & 0x3ff;
+}
+
+#endif /* __hw_host1x_sync_host1x_h__ */
diff --git a/drivers/video/tegra/host/nvhost_acm.c b/drivers/video/tegra/host/nvhost_acm.c
new file mode 100644
index 0000000..15cf395
--- /dev/null
+++ b/drivers/video/tegra/host/nvhost_acm.c
@@ -0,0 +1,481 @@
+/*
+ * drivers/video/tegra/host/nvhost_acm.c
+ *
+ * Tegra host1x Automatic Clock Management
+ *
+ * Copyright (c) 2010-2012, NVIDIA Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/stat.h>
+#include <linux/string.h>
+#include <linux/sched.h>
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/device.h>
+#include <linux/delay.h>
+#include <linux/platform_device.h>
+
+#include <mach/powergate.h>
+#include <mach/clk.h>
+
+#include "nvhost_acm.h"
+
+#define ACM_SUSPEND_WAIT_FOR_IDLE_TIMEOUT	(2 * HZ)
+#define POWERGATE_DELAY				10
+#define MAX_DEVID_LENGTH			16
+
+static void do_powergate_locked(int id)
+{
+	if (id != -1 && tegra_powergate_is_powered(id))
+		tegra_powergate_power_off(id);
+}
+
+static void do_unpowergate_locked(int id)
+{
+	if (id != -1)
+		tegra_powergate_power_on(id);
+}
+
+static void to_state_clockgated_locked(struct platform_device *dev)
+{
+	struct nvhost_device_data *pdata = platform_get_drvdata(dev);
+
+	if (pdata->powerstate == NVHOST_POWER_STATE_RUNNING) {
+		int i, err;
+		if (pdata->prepare_clockoff) {
+			err = pdata->prepare_clockoff(dev);
+			if (err) {
+				dev_err(&dev->dev, "error clock gating");
+				return;
+			}
+		}
+
+		for (i = 0; i < pdata->num_clks; i++)
+			clk_disable_unprepare(pdata->clk[i]);
+		if (dev->dev.parent)
+			nvhost_module_idle(to_platform_device(dev->dev.parent));
+	} else if (pdata->powerstate == NVHOST_POWER_STATE_POWERGATED
+			&& pdata->can_powergate) {
+		do_unpowergate_locked(pdata->powergate_ids[0]);
+		do_unpowergate_locked(pdata->powergate_ids[1]);
+	}
+	pdata->powerstate = NVHOST_POWER_STATE_CLOCKGATED;
+}
+
+static void to_state_running_locked(struct platform_device *dev)
+{
+	struct nvhost_device_data *pdata = platform_get_drvdata(dev);
+	int prev_state = pdata->powerstate;
+
+	if (pdata->powerstate == NVHOST_POWER_STATE_POWERGATED)
+		to_state_clockgated_locked(dev);
+
+	if (pdata->powerstate == NVHOST_POWER_STATE_CLOCKGATED) {
+		int i;
+
+		if (dev->dev.parent)
+			nvhost_module_busy(to_platform_device(dev->dev.parent));
+
+		for (i = 0; i < pdata->num_clks; i++) {
+			int err = clk_prepare_enable(pdata->clk[i]);
+			if (err) {
+				dev_err(&dev->dev, "Cannot turn on clock %s",
+					pdata->clocks[i].name);
+				return;
+			}
+		}
+
+		if (pdata->finalize_clockon)
+			pdata->finalize_clockon(dev);
+
+		/* Invoke callback after power un-gating. This is used for
+		 * restoring context. */
+		if (prev_state == NVHOST_POWER_STATE_POWERGATED
+				&& pdata->finalize_poweron)
+			pdata->finalize_poweron(dev);
+	}
+	pdata->powerstate = NVHOST_POWER_STATE_RUNNING;
+}
+
+/* This gets called from powergate_handler() and from module suspend.
+ * Module suspend is done for all modules, runtime power gating only
+ * for modules with can_powergate set.
+ */
+static int to_state_powergated_locked(struct platform_device *dev)
+{
+	struct nvhost_device_data *pdata = platform_get_drvdata(dev);
+	int err = 0;
+
+	if (pdata->prepare_poweroff &&
+		pdata->powerstate != NVHOST_POWER_STATE_POWERGATED) {
+		/* Clock needs to be on in prepare_poweroff */
+		to_state_running_locked(dev);
+		err = pdata->prepare_poweroff(dev);
+		if (err)
+			return err;
+	}
+
+	if (pdata->powerstate == NVHOST_POWER_STATE_RUNNING)
+		to_state_clockgated_locked(dev);
+
+	if (pdata->can_powergate) {
+		do_powergate_locked(pdata->powergate_ids[0]);
+		do_powergate_locked(pdata->powergate_ids[1]);
+	}
+
+	pdata->powerstate = NVHOST_POWER_STATE_POWERGATED;
+	return 0;
+}
+
+static void schedule_powergating_locked(struct platform_device *dev)
+{
+	struct nvhost_device_data *pdata = platform_get_drvdata(dev);
+	if (pdata->can_powergate)
+		schedule_delayed_work(&pdata->powerstate_down,
+				msecs_to_jiffies(pdata->powergate_delay));
+}
+
+static void schedule_clockgating_locked(struct platform_device *dev)
+{
+	struct nvhost_device_data *pdata = platform_get_drvdata(dev);
+	schedule_delayed_work(&pdata->powerstate_down,
+			msecs_to_jiffies(pdata->clockgate_delay));
+}
+
+void nvhost_module_busy(struct platform_device *dev)
+{
+	struct nvhost_device_data *pdata = platform_get_drvdata(dev);
+
+	if (pdata->busy)
+		pdata->busy(dev);
+
+	mutex_lock(&pdata->lock);
+	cancel_delayed_work(&pdata->powerstate_down);
+
+	pdata->refcount++;
+	if (pdata->refcount > 0 && !nvhost_module_powered(dev))
+		to_state_running_locked(dev);
+	mutex_unlock(&pdata->lock);
+}
+
+static void powerstate_down_handler(struct work_struct *work)
+{
+	struct platform_device *dev;
+	struct nvhost_device_data *pdata;
+
+	pdata = container_of(to_delayed_work(work),
+			struct nvhost_device_data,
+			powerstate_down);
+
+	dev = pdata->pdev;
+
+	mutex_lock(&pdata->lock);
+	if (pdata->refcount == 0) {
+		switch (pdata->powerstate) {
+		case NVHOST_POWER_STATE_RUNNING:
+			to_state_clockgated_locked(dev);
+			schedule_powergating_locked(dev);
+			break;
+		case NVHOST_POWER_STATE_CLOCKGATED:
+			if (to_state_powergated_locked(dev))
+				schedule_powergating_locked(dev);
+			break;
+		default:
+			break;
+		}
+	}
+	mutex_unlock(&pdata->lock);
+}
+
+void nvhost_module_idle_mult(struct platform_device *dev, int refs)
+{
+	struct nvhost_device_data *pdata = platform_get_drvdata(dev);
+	bool kick = false;
+
+	mutex_lock(&pdata->lock);
+	pdata->refcount -= refs;
+	if (pdata->refcount == 0) {
+		if (nvhost_module_powered(dev))
+			schedule_clockgating_locked(dev);
+		kick = true;
+	}
+	mutex_unlock(&pdata->lock);
+
+	if (kick) {
+		wake_up(&pdata->idle_wq);
+
+		if (pdata->idle)
+			pdata->idle(dev);
+	}
+}
+
+static ssize_t refcount_show(struct kobject *kobj,
+	struct kobj_attribute *attr, char *buf)
+{
+	int ret;
+	struct nvhost_device_power_attr *power_attribute =
+		container_of(attr, struct nvhost_device_power_attr,
+			power_attr[NVHOST_POWER_SYSFS_ATTRIB_REFCOUNT]);
+	struct platform_device *dev = power_attribute->ndev;
+	struct nvhost_device_data *pdata = platform_get_drvdata(dev);
+
+	mutex_lock(&pdata->lock);
+	ret = sprintf(buf, "%d\n", pdata->refcount);
+	mutex_unlock(&pdata->lock);
+
+	return ret;
+}
+
+static ssize_t powergate_delay_store(struct kobject *kobj,
+	struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	int powergate_delay = 0, ret = 0;
+	struct nvhost_device_power_attr *power_attribute =
+		container_of(attr, struct nvhost_device_power_attr,
+			power_attr[NVHOST_POWER_SYSFS_ATTRIB_POWERGATE_DELAY]);
+	struct platform_device *dev = power_attribute->ndev;
+	struct nvhost_device_data *pdata = platform_get_drvdata(dev);
+
+	if (!pdata->can_powergate) {
+		dev_info(&dev->dev, "does not support power-gating\n");
+		return count;
+	}
+
+	mutex_lock(&pdata->lock);
+	ret = sscanf(buf, "%d", &powergate_delay);
+	if (ret == 1 && powergate_delay >= 0)
+		pdata->powergate_delay = powergate_delay;
+	else
+		dev_err(&dev->dev, "Invalid powergate delay\n");
+	mutex_unlock(&pdata->lock);
+
+	return count;
+}
+
+static ssize_t powergate_delay_show(struct kobject *kobj,
+	struct kobj_attribute *attr, char *buf)
+{
+	int ret;
+	struct nvhost_device_power_attr *power_attribute =
+		container_of(attr, struct nvhost_device_power_attr,
+			power_attr[NVHOST_POWER_SYSFS_ATTRIB_POWERGATE_DELAY]);
+	struct platform_device *dev = power_attribute->ndev;
+	struct nvhost_device_data *pdata = platform_get_drvdata(dev);
+
+	mutex_lock(&pdata->lock);
+	ret = sprintf(buf, "%d\n", pdata->powergate_delay);
+	mutex_unlock(&pdata->lock);
+
+	return ret;
+}
+
+static ssize_t clockgate_delay_store(struct kobject *kobj,
+	struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	int clockgate_delay = 0, ret = 0;
+	struct nvhost_device_power_attr *power_attribute =
+		container_of(attr, struct nvhost_device_power_attr,
+			power_attr[NVHOST_POWER_SYSFS_ATTRIB_CLOCKGATE_DELAY]);
+	struct platform_device *dev = power_attribute->ndev;
+	struct nvhost_device_data *pdata = platform_get_drvdata(dev);
+
+	mutex_lock(&pdata->lock);
+	ret = sscanf(buf, "%d", &clockgate_delay);
+	if (ret == 1 && clockgate_delay >= 0)
+		pdata->clockgate_delay = clockgate_delay;
+	else
+		dev_err(&dev->dev, "Invalid clockgate delay\n");
+	mutex_unlock(&pdata->lock);
+
+	return count;
+}
+
+static ssize_t clockgate_delay_show(struct kobject *kobj,
+	struct kobj_attribute *attr, char *buf)
+{
+	int ret;
+	struct nvhost_device_power_attr *power_attribute =
+		container_of(attr, struct nvhost_device_power_attr,
+			power_attr[NVHOST_POWER_SYSFS_ATTRIB_CLOCKGATE_DELAY]);
+	struct platform_device *dev = power_attribute->ndev;
+	struct nvhost_device_data *pdata = platform_get_drvdata(dev);
+
+	mutex_lock(&pdata->lock);
+	ret = sprintf(buf, "%d\n", pdata->clockgate_delay);
+	mutex_unlock(&pdata->lock);
+
+	return ret;
+}
+
+int nvhost_module_init(struct platform_device *dev)
+{
+	int i = 0, err = 0;
+	struct kobj_attribute *attr = NULL;
+	struct nvhost_device_data *pdata = platform_get_drvdata(dev);
+
+	/* initialize clocks to known state */
+	while (pdata->clocks[i].name && i < NVHOST_MODULE_MAX_CLOCKS) {
+		long rate = pdata->clocks[i].default_rate;
+		struct clk *c;
+
+		c = devm_clk_get(&dev->dev, pdata->clocks[i].name);
+		if (IS_ERR_OR_NULL(c)) {
+			dev_err(&dev->dev, "Cannot get clock %s\n",
+					pdata->clocks[i].name);
+			return -ENODEV;
+		}
+
+		rate = clk_round_rate(c, rate);
+		clk_prepare_enable(c);
+		clk_set_rate(c, rate);
+		clk_disable_unprepare(c);
+		pdata->clk[i] = c;
+		i++;
+	}
+	pdata->num_clks = i;
+
+	mutex_init(&pdata->lock);
+	init_waitqueue_head(&pdata->idle_wq);
+	INIT_DELAYED_WORK(&pdata->powerstate_down, powerstate_down_handler);
+
+	/* power gate units that we can power gate */
+	if (pdata->can_powergate) {
+		do_powergate_locked(pdata->powergate_ids[0]);
+		do_powergate_locked(pdata->powergate_ids[1]);
+		pdata->powerstate = NVHOST_POWER_STATE_POWERGATED;
+	} else {
+		do_unpowergate_locked(pdata->powergate_ids[0]);
+		do_unpowergate_locked(pdata->powergate_ids[1]);
+		pdata->powerstate = NVHOST_POWER_STATE_CLOCKGATED;
+	}
+
+	/* Init the power sysfs attributes for this device */
+	pdata->power_attrib = devm_kzalloc(&dev->dev,
+			sizeof(struct nvhost_device_power_attr),
+		GFP_KERNEL);
+	if (!pdata->power_attrib) {
+		dev_err(&dev->dev, "Unable to allocate sysfs attributes\n");
+		return -ENOMEM;
+	}
+	pdata->power_attrib->ndev = dev;
+
+	pdata->power_kobj = kobject_create_and_add("acm", &dev->dev.kobj);
+	if (!pdata->power_kobj) {
+		dev_err(&dev->dev, "Could not add dir 'power'\n");
+		err = -EIO;
+		goto fail_attrib_alloc;
+	}
+
+	attr = &pdata->power_attrib->power_attr[NVHOST_POWER_SYSFS_ATTRIB_CLOCKGATE_DELAY];
+	attr->attr.name = "clockgate_delay";
+	attr->attr.mode = S_IWUSR | S_IRUGO;
+	attr->show = clockgate_delay_show;
+	attr->store = clockgate_delay_store;
+	if (sysfs_create_file(pdata->power_kobj, &attr->attr)) {
+		dev_err(&dev->dev, "Could not create sysfs attribute clockgate_delay\n");
+		err = -EIO;
+		goto fail_clockdelay;
+	}
+
+	attr = &pdata->power_attrib->power_attr[NVHOST_POWER_SYSFS_ATTRIB_POWERGATE_DELAY];
+	attr->attr.name = "powergate_delay";
+	attr->attr.mode = S_IWUSR | S_IRUGO;
+	attr->show = powergate_delay_show;
+	attr->store = powergate_delay_store;
+	if (sysfs_create_file(pdata->power_kobj, &attr->attr)) {
+		dev_err(&dev->dev, "Could not create sysfs attribute powergate_delay\n");
+		err = -EIO;
+		goto fail_powergatedelay;
+	}
+
+	attr = &pdata->power_attrib->power_attr[NVHOST_POWER_SYSFS_ATTRIB_REFCOUNT];
+	attr->attr.name = "refcount";
+	attr->attr.mode = S_IRUGO;
+	attr->show = refcount_show;
+	if (sysfs_create_file(pdata->power_kobj, &attr->attr)) {
+		dev_err(&dev->dev, "Could not create sysfs attribute refcount\n");
+		err = -EIO;
+		goto fail_refcount;
+	}
+
+	return 0;
+
+fail_refcount:
+	attr = &pdata->power_attrib->power_attr[NVHOST_POWER_SYSFS_ATTRIB_POWERGATE_DELAY];
+	sysfs_remove_file(pdata->power_kobj, &attr->attr);
+
+fail_powergatedelay:
+	attr = &pdata->power_attrib->power_attr[NVHOST_POWER_SYSFS_ATTRIB_CLOCKGATE_DELAY];
+	sysfs_remove_file(pdata->power_kobj, &attr->attr);
+
+fail_clockdelay:
+	kobject_put(pdata->power_kobj);
+
+fail_attrib_alloc:
+	kfree(pdata->power_attrib);
+
+	return err;
+}
+
+static int is_module_idle(struct platform_device *dev)
+{
+	int count;
+	struct nvhost_device_data *pdata = platform_get_drvdata(dev);
+
+	mutex_lock(&pdata->lock);
+	count = pdata->refcount;
+	mutex_unlock(&pdata->lock);
+
+	return (count == 0);
+}
+
+int nvhost_module_suspend(struct platform_device *dev)
+{
+	int ret;
+	struct nvhost_device_data *pdata = platform_get_drvdata(dev);
+
+	ret = wait_event_timeout(pdata->idle_wq, is_module_idle(dev),
+			ACM_SUSPEND_WAIT_FOR_IDLE_TIMEOUT);
+	if (ret == 0) {
+		dev_info(&dev->dev, "%s prevented suspend\n",
+				dev_name(&dev->dev));
+		return -EBUSY;
+	}
+
+	mutex_lock(&pdata->lock);
+	cancel_delayed_work(&pdata->powerstate_down);
+	to_state_powergated_locked(dev);
+	mutex_unlock(&pdata->lock);
+
+	if (pdata->suspend_ndev)
+		pdata->suspend_ndev(dev);
+
+	return 0;
+}
+
+void nvhost_module_deinit(struct platform_device *dev)
+{
+	struct nvhost_device_data *pdata = platform_get_drvdata(dev);
+
+	kobject_put(pdata->power_kobj);
+
+	if (pdata->deinit)
+		pdata->deinit(dev);
+
+	nvhost_module_suspend(dev);
+	pdata->powerstate = NVHOST_POWER_STATE_DEINIT;
+}
diff --git a/drivers/video/tegra/host/nvhost_acm.h b/drivers/video/tegra/host/nvhost_acm.h
new file mode 100644
index 0000000..0892a57
--- /dev/null
+++ b/drivers/video/tegra/host/nvhost_acm.h
@@ -0,0 +1,45 @@
+/*
+ * drivers/video/tegra/host/nvhost_acm.h
+ *
+ * Tegra host1x Automatic Clock Management
+ *
+ * Copyright (c) 2010-2012, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef __NVHOST_ACM_H
+#define __NVHOST_ACM_H
+
+#include <linux/nvhost.h>
+
+/* Sets clocks and powergating state for a module */
+int nvhost_module_init(struct platform_device *ndev);
+void nvhost_module_deinit(struct platform_device *dev);
+int nvhost_module_suspend(struct platform_device *dev);
+
+void nvhost_module_busy(struct platform_device *dev);
+void nvhost_module_idle_mult(struct platform_device *dev, int refs);
+
+static inline bool nvhost_module_powered(struct platform_device *dev)
+{
+	struct nvhost_device_data *pdata = platform_get_drvdata(dev);
+	return pdata->powerstate == NVHOST_POWER_STATE_RUNNING;
+}
+
+static inline void nvhost_module_idle(struct platform_device *dev)
+{
+	nvhost_module_idle_mult(dev, 1);
+}
+
+#endif
diff --git a/drivers/video/tegra/host/nvhost_syncpt.c b/drivers/video/tegra/host/nvhost_syncpt.c
new file mode 100644
index 0000000..d7c8230
--- /dev/null
+++ b/drivers/video/tegra/host/nvhost_syncpt.c
@@ -0,0 +1,333 @@
+/*
+ * drivers/video/tegra/host/nvhost_syncpt.c
+ *
+ * Tegra host1x Syncpoints
+ *
+ * Copyright (c) 2010-2012, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/stat.h>
+#include "nvhost_syncpt.h"
+#include "nvhost_acm.h"
+#include "host1x/host1x.h"
+#include "chip_support.h"
+
+#define MAX_SYNCPT_LENGTH	5
+
+/* Name of sysfs node for min and max value */
+static const char *min_name = "min";
+static const char *max_name = "max";
+
+/**
+ * Resets syncpoint and waitbase values to sw shadows
+ */
+void nvhost_syncpt_reset(struct nvhost_syncpt *sp)
+{
+	u32 i;
+
+	for (i = 0; i < nvhost_syncpt_nb_pts(sp); i++)
+		syncpt_op().reset(sp, i);
+	for (i = 0; i < nvhost_syncpt_nb_bases(sp); i++)
+		syncpt_op().reset_wait_base(sp, i);
+	wmb();
+}
+
+/**
+ * Updates sw shadow state for client managed registers
+ */
+void nvhost_syncpt_save(struct nvhost_syncpt *sp)
+{
+	u32 i;
+
+	for (i = 0; i < nvhost_syncpt_nb_pts(sp); i++) {
+		if (nvhost_syncpt_client_managed(sp, i))
+			syncpt_op().update_min(sp, i);
+		else
+			WARN_ON(!nvhost_syncpt_min_eq_max(sp, i));
+	}
+
+	for (i = 0; i < nvhost_syncpt_nb_bases(sp); i++)
+		syncpt_op().read_wait_base(sp, i);
+}
+
+/**
+ * Updates the last value read from hardware.
+ */
+u32 nvhost_syncpt_update_min(struct nvhost_syncpt *sp, u32 id)
+{
+	u32 val;
+
+	val = syncpt_op().update_min(sp, id);
+
+	return val;
+}
+
+/**
+ * Get the current syncpoint value
+ */
+u32 nvhost_syncpt_read(struct nvhost_syncpt *sp, u32 id)
+{
+	u32 val;
+	nvhost_module_busy(syncpt_to_dev(sp)->dev);
+	val = syncpt_op().update_min(sp, id);
+	nvhost_module_idle(syncpt_to_dev(sp)->dev);
+	return val;
+}
+
+/**
+ * Get the current syncpoint base
+ */
+u32 nvhost_syncpt_read_wait_base(struct nvhost_syncpt *sp, u32 id)
+{
+	u32 val;
+	nvhost_module_busy(syncpt_to_dev(sp)->dev);
+	syncpt_op().read_wait_base(sp, id);
+	val = sp->base_val[id];
+	nvhost_module_idle(syncpt_to_dev(sp)->dev);
+	return val;
+}
+
+/**
+ * Write a cpu syncpoint increment to the hardware, without touching
+ * the cache. Caller is responsible for host being powered.
+ */
+void nvhost_syncpt_cpu_incr(struct nvhost_syncpt *sp, u32 id)
+{
+	syncpt_op().cpu_incr(sp, id);
+}
+
+/**
+ * Increment syncpoint value from cpu, updating cache
+ */
+void nvhost_syncpt_incr(struct nvhost_syncpt *sp, u32 id)
+{
+	if (nvhost_syncpt_client_managed(sp, id))
+		nvhost_syncpt_incr_max(sp, id, 1);
+	nvhost_module_busy(syncpt_to_dev(sp)->dev);
+	nvhost_syncpt_cpu_incr(sp, id);
+	nvhost_module_idle(syncpt_to_dev(sp)->dev);
+}
+
+/**
+ * Returns true if syncpoint is expired, false if we may need to wait
+ */
+bool nvhost_syncpt_is_expired(
+	struct nvhost_syncpt *sp,
+	u32 id,
+	u32 thresh)
+{
+	u32 current_val;
+	u32 future_val;
+	smp_rmb();
+	current_val = (u32)atomic_read(&sp->min_val[id]);
+	future_val = (u32)atomic_read(&sp->max_val[id]);
+
+	/* Note the use of unsigned arithmetic here (mod 1<<32).
+	 *
+	 * c = current_val = min_val	= the current value of the syncpoint.
+	 * t = thresh			= the value we are checking
+	 * f = future_val  = max_val	= the value c will reach when all
+	 *				  outstanding increments have completed.
+	 *
+	 * Note that c always chases f until it reaches f.
+	 *
+	 * Dtf = (f - t)
+	 * Dtc = (c - t)
+	 *
+	 *  Consider all cases:
+	 *
+	 *	A) .....c..t..f.....	Dtf < Dtc	need to wait
+	 *	B) .....c.....f..t..	Dtf > Dtc	expired
+	 *	C) ..t..c.....f.....	Dtf > Dtc	expired	   (Dct very large)
+	 *
+	 *  Any case where f==c: always expired (for any t).	Dtf == Dcf
+	 *  Any case where t==c: always expired (for any f).	Dtf >= Dtc (because Dtc==0)
+	 *  Any case where t==f!=c: always wait.		Dtf <  Dtc (because Dtf==0,
+	 *							Dtc!=0)
+	 *
+	 *  Other cases:
+	 *
+	 *	A) .....t..f..c.....	Dtf < Dtc	need to wait
+	 *	A) .....f..c..t.....	Dtf < Dtc	need to wait
+	 *	A) .....f..t..c.....	Dtf > Dtc	expired
+	 *
+	 *   So:
+	 *	   Dtf >= Dtc implies EXPIRED	(return true)
+	 *	   Dtf <  Dtc implies WAIT	(return false)
+	 *
+	 * Note: If t is expired then we *cannot* wait on it. We would wait
+	 * forever (hang the system).
+	 *
+	 * Note: do NOT get clever and remove the -thresh from both sides. It
+	 * is NOT the same.
+	 *
+	 * If future valueis zero, we have a client managed sync point. In that
+	 * case we do a direct comparison.
+	 */
+	if (!nvhost_syncpt_client_managed(sp, id))
+		return future_val - thresh >= current_val - thresh;
+	else
+		return (s32)(current_val - thresh) >= 0;
+}
+
+void nvhost_syncpt_debug(struct nvhost_syncpt *sp)
+{
+	syncpt_op().debug(sp);
+}
+/* Displays the current value of the sync point via sysfs */
+static ssize_t syncpt_min_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct nvhost_syncpt_attr *syncpt_attr =
+		container_of(attr, struct nvhost_syncpt_attr, attr);
+
+	return snprintf(buf, PAGE_SIZE, "%u",
+			nvhost_syncpt_read(&syncpt_attr->host->syncpt,
+				syncpt_attr->id));
+}
+
+static ssize_t syncpt_max_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct nvhost_syncpt_attr *syncpt_attr =
+		container_of(attr, struct nvhost_syncpt_attr, attr);
+
+	return snprintf(buf, PAGE_SIZE, "%u",
+			nvhost_syncpt_read_max(&syncpt_attr->host->syncpt,
+				syncpt_attr->id));
+}
+
+int nvhost_syncpt_init(struct platform_device *dev,
+		struct nvhost_syncpt *sp)
+{
+	int i;
+	struct nvhost_master *host = syncpt_to_dev(sp);
+	int err = 0;
+
+	/* Allocate structs for min, max and base values */
+	sp->min_val = kzalloc(sizeof(atomic_t) * nvhost_syncpt_nb_pts(sp),
+			GFP_KERNEL);
+	sp->max_val = kzalloc(sizeof(atomic_t) * nvhost_syncpt_nb_pts(sp),
+			GFP_KERNEL);
+	sp->base_val = kzalloc(sizeof(u32) * nvhost_syncpt_nb_bases(sp),
+			GFP_KERNEL);
+	sp->lock_counts =
+		kzalloc(sizeof(atomic_t) * nvhost_syncpt_nb_mlocks(sp),
+			GFP_KERNEL);
+
+	if (!(sp->min_val && sp->max_val && sp->base_val && sp->lock_counts)) {
+		/* frees happen in the deinit */
+		err = -ENOMEM;
+		goto fail;
+	}
+
+	sp->kobj = kobject_create_and_add("syncpt", &dev->dev.kobj);
+	if (!sp->kobj) {
+		err = -EIO;
+		goto fail;
+	}
+
+	/* Allocate two attributes for each sync point: min and max */
+	sp->syncpt_attrs = kzalloc(sizeof(*sp->syncpt_attrs)
+			* nvhost_syncpt_nb_pts(sp) * 2, GFP_KERNEL);
+	if (!sp->syncpt_attrs) {
+		err = -ENOMEM;
+		goto fail;
+	}
+
+	/* Fill in the attributes */
+	for (i = 0; i < nvhost_syncpt_nb_pts(sp); i++) {
+		char name[MAX_SYNCPT_LENGTH];
+		struct kobject *kobj;
+		struct nvhost_syncpt_attr *min = &sp->syncpt_attrs[i*2];
+		struct nvhost_syncpt_attr *max = &sp->syncpt_attrs[i*2+1];
+
+		/* Create one directory per sync point */
+		snprintf(name, sizeof(name), "%d", i);
+		kobj = kobject_create_and_add(name, sp->kobj);
+		if (!kobj) {
+			err = -EIO;
+			goto fail;
+		}
+
+		min->id = i;
+		min->host = host;
+		min->attr.attr.name = min_name;
+		min->attr.attr.mode = S_IRUGO;
+		min->attr.show = syncpt_min_show;
+		if (sysfs_create_file(kobj, &min->attr.attr)) {
+			err = -EIO;
+			goto fail;
+		}
+
+		max->id = i;
+		max->host = host;
+		max->attr.attr.name = max_name;
+		max->attr.attr.mode = S_IRUGO;
+		max->attr.show = syncpt_max_show;
+		if (sysfs_create_file(kobj, &max->attr.attr)) {
+			err = -EIO;
+			goto fail;
+		}
+	}
+
+	return err;
+
+fail:
+	nvhost_syncpt_deinit(sp);
+	return err;
+}
+
+void nvhost_syncpt_deinit(struct nvhost_syncpt *sp)
+{
+	kobject_put(sp->kobj);
+
+	kfree(sp->min_val);
+	sp->min_val = NULL;
+
+	kfree(sp->max_val);
+	sp->max_val = NULL;
+
+	kfree(sp->base_val);
+	sp->base_val = NULL;
+
+	kfree(sp->lock_counts);
+	sp->lock_counts = 0;
+
+	kfree(sp->syncpt_attrs);
+	sp->syncpt_attrs = NULL;
+}
+
+int nvhost_syncpt_client_managed(struct nvhost_syncpt *sp, u32 id)
+{
+	return BIT(id) & syncpt_to_dev(sp)->info.client_managed;
+}
+
+int nvhost_syncpt_nb_pts(struct nvhost_syncpt *sp)
+{
+	return syncpt_to_dev(sp)->info.nb_pts;
+}
+
+int nvhost_syncpt_nb_bases(struct nvhost_syncpt *sp)
+{
+	return syncpt_to_dev(sp)->info.nb_bases;
+}
+
+int nvhost_syncpt_nb_mlocks(struct nvhost_syncpt *sp)
+{
+	return syncpt_to_dev(sp)->info.nb_mlocks;
+}
diff --git a/drivers/video/tegra/host/nvhost_syncpt.h b/drivers/video/tegra/host/nvhost_syncpt.h
new file mode 100644
index 0000000..b883442
--- /dev/null
+++ b/drivers/video/tegra/host/nvhost_syncpt.h
@@ -0,0 +1,136 @@
+/*
+ * drivers/video/tegra/host/nvhost_syncpt.h
+ *
+ * Tegra host1x Syncpoints
+ *
+ * Copyright (c) 2010-2012, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef __NVHOST_SYNCPT_H
+#define __NVHOST_SYNCPT_H
+
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/nvhost.h>
+#include <linux/atomic.h>
+
+/* host managed and invalid syncpt id */
+#define NVSYNCPT_GRAPHICS_HOST		     (0)
+
+/* Attribute struct for sysfs min and max attributes */
+struct nvhost_syncpt_attr {
+	struct kobj_attribute attr;
+	struct nvhost_master *host;
+	int id;
+};
+
+struct nvhost_syncpt {
+	struct kobject *kobj;
+	atomic_t *min_val;
+	atomic_t *max_val;
+	u32 *base_val;
+	atomic_t *lock_counts;
+	const char **syncpt_names;
+	struct nvhost_syncpt_attr *syncpt_attrs;
+};
+
+int nvhost_syncpt_init(struct platform_device *, struct nvhost_syncpt *);
+void nvhost_syncpt_deinit(struct nvhost_syncpt *);
+
+#define syncpt_to_dev(sp) container_of(sp, struct nvhost_master, syncpt)
+#define SYNCPT_CHECK_PERIOD (2 * HZ)
+#define MAX_STUCK_CHECK_COUNT 15
+
+/**
+ * Updates the value sent to hardware.
+ */
+static inline u32 nvhost_syncpt_incr_max(struct nvhost_syncpt *sp,
+					u32 id, u32 incrs)
+{
+	return (u32)atomic_add_return(incrs, &sp->max_val[id]);
+}
+
+/**
+ * Updated the value sent to hardware.
+ */
+static inline u32 nvhost_syncpt_set_max(struct nvhost_syncpt *sp,
+					u32 id, u32 val)
+{
+	atomic_set(&sp->max_val[id], val);
+	smp_wmb();
+	return val;
+}
+
+static inline u32 nvhost_syncpt_read_max(struct nvhost_syncpt *sp, u32 id)
+{
+	smp_rmb();
+	return (u32)atomic_read(&sp->max_val[id]);
+}
+
+static inline u32 nvhost_syncpt_read_min(struct nvhost_syncpt *sp, u32 id)
+{
+	smp_rmb();
+	return (u32)atomic_read(&sp->min_val[id]);
+}
+
+int nvhost_syncpt_client_managed(struct nvhost_syncpt *sp, u32 id);
+int nvhost_syncpt_nb_pts(struct nvhost_syncpt *sp);
+int nvhost_syncpt_nb_bases(struct nvhost_syncpt *sp);
+int nvhost_syncpt_nb_mlocks(struct nvhost_syncpt *sp);
+
+static inline bool nvhost_syncpt_check_max(struct nvhost_syncpt *sp,
+		u32 id, u32 real)
+{
+	u32 max;
+	if (nvhost_syncpt_client_managed(sp, id))
+		return true;
+	max = nvhost_syncpt_read_max(sp, id);
+	return (s32)(max - real) >= 0;
+}
+
+/**
+ * Returns true if syncpoint min == max
+ */
+static inline bool nvhost_syncpt_min_eq_max(struct nvhost_syncpt *sp, u32 id)
+{
+	int min, max;
+	smp_rmb();
+	min = atomic_read(&sp->min_val[id]);
+	max = atomic_read(&sp->max_val[id]);
+	return (min == max);
+}
+
+void nvhost_syncpt_cpu_incr(struct nvhost_syncpt *sp, u32 id);
+
+u32 nvhost_syncpt_update_min(struct nvhost_syncpt *sp, u32 id);
+bool nvhost_syncpt_is_expired(struct nvhost_syncpt *sp, u32 id, u32 thresh);
+
+void nvhost_syncpt_save(struct nvhost_syncpt *sp);
+
+void nvhost_syncpt_reset(struct nvhost_syncpt *sp);
+
+u32 nvhost_syncpt_read(struct nvhost_syncpt *sp, u32 id);
+u32 nvhost_syncpt_read_wait_base(struct nvhost_syncpt *sp, u32 id);
+
+void nvhost_syncpt_incr(struct nvhost_syncpt *sp, u32 id);
+
+void nvhost_syncpt_debug(struct nvhost_syncpt *sp);
+
+static inline int nvhost_syncpt_is_valid(struct nvhost_syncpt *sp, u32 id)
+{
+	return id != NVSYNCPT_INVALID && id < nvhost_syncpt_nb_pts(sp);
+}
+
+#endif
diff --git a/include/linux/nvhost.h b/include/linux/nvhost.h
new file mode 100644
index 0000000..20ba2a5
--- /dev/null
+++ b/include/linux/nvhost.h
@@ -0,0 +1,143 @@
+/*
+ * include/linux/nvhost.h
+ *
+ * Tegra host1x driver
+ *
+ * Copyright (c) 2009-2012, NVIDIA Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+
+#ifndef __LINUX_NVHOST_H
+#define __LINUX_NVHOST_H
+
+#include <linux/device.h>
+#include <linux/types.h>
+#include <linux/platform_device.h>
+
+struct nvhost_device_power_attr;
+
+#define NVHOST_MODULE_MAX_CLOCKS		3
+#define NVHOST_MODULE_MAX_POWERGATE_IDS		2
+#define NVHOST_MODULE_NO_POWERGATE_IDS		.powergate_ids = {-1, -1}
+#define NVHOST_DEFAULT_CLOCKGATE_DELAY		.clockgate_delay = 25
+#define NVHOST_NAME_SIZE			24
+#define NVSYNCPT_INVALID			(-1)
+
+enum nvhost_power_sysfs_attributes {
+	NVHOST_POWER_SYSFS_ATTRIB_CLOCKGATE_DELAY = 0,
+	NVHOST_POWER_SYSFS_ATTRIB_POWERGATE_DELAY,
+	NVHOST_POWER_SYSFS_ATTRIB_REFCOUNT,
+	NVHOST_POWER_SYSFS_ATTRIB_MAX
+};
+
+struct nvhost_clock {
+	char *name;
+	unsigned long default_rate;
+	int reset;
+};
+
+enum nvhost_device_powerstate_t {
+	NVHOST_POWER_STATE_DEINIT,
+	NVHOST_POWER_STATE_RUNNING,
+	NVHOST_POWER_STATE_CLOCKGATED,
+	NVHOST_POWER_STATE_POWERGATED
+};
+
+struct host1x_device_info {
+	int		nb_channels;	/* host1x: num channels supported */
+	int		nb_pts;		/* host1x: num syncpoints supported */
+	int		nb_bases;	/* host1x: num syncpoints supported */
+	u32		client_managed; /* host1x: client managed syncpts */
+	int		nb_mlocks;	/* host1x: number of mlocks */
+	const char	**syncpt_names;	/* names of sync points */
+};
+
+struct nvhost_device_data {
+	int		version;	/* ip version number of device */
+	int		id;		/* Separates clients of same hw */
+	int		index;		/* Hardware channel number */
+	void __iomem	*aperture;	/* Iomem mapped to kernel */
+
+	u32		syncpts;	/* Bitfield of sync points used */
+	u32		modulemutexes;	/* Bit field of module mutexes */
+
+	u32		class;		/* Device class */
+	bool		serialize;	/* Serialize submits in the channel */
+
+	int		powergate_ids[NVHOST_MODULE_MAX_POWERGATE_IDS];
+	bool		can_powergate;	/* True if module can be power gated */
+	int		clockgate_delay;/* Delay before clock gated */
+	int		powergate_delay;/* Delay before power gated */
+	struct nvhost_clock clocks[NVHOST_MODULE_MAX_CLOCKS];/* Clock names */
+
+	struct delayed_work powerstate_down;/* Power state management */
+	int		num_clks;	/* Number of clocks opened for dev */
+	struct clk	*clk[NVHOST_MODULE_MAX_CLOCKS];
+	struct mutex	lock;		/* Power management lock */
+	int		powerstate;	/* Current power state */
+	int		refcount;	/* Number of tasks active */
+	wait_queue_head_t idle_wq;	/* Work queue for idle */
+
+	struct nvhost_channel *channel;	/* Channel assigned for the module */
+	struct kobject *power_kobj;	/* kobj to hold power sysfs entries */
+	struct nvhost_device_power_attr *power_attrib;	/* sysfs attributes */
+	struct dentry *debugfs;		/* debugfs directory */
+
+	void *private_data;		/* private platform data */
+	struct platform_device *pdev;	/* owner platform_device */
+
+	/* Finalize power on. Can be used for context restore. */
+	void (*finalize_poweron)(struct platform_device *dev);
+
+	/* Device is busy. */
+	void (*busy)(struct platform_device *);
+
+	/* Device is idle. */
+	void (*idle)(struct platform_device *);
+
+	/* Device is going to be suspended */
+	void (*suspend_ndev)(struct platform_device *);
+
+	/* Device is initialized */
+	void (*init)(struct platform_device *dev);
+
+	/* Device is de-initialized. */
+	void (*deinit)(struct platform_device *dev);
+
+	/* Preparing for power off. Used for context save. */
+	int (*prepare_poweroff)(struct platform_device *dev);
+
+	/* Clock gating callbacks */
+	int (*prepare_clockoff)(struct platform_device *dev);
+	void (*finalize_clockon)(struct platform_device *dev);
+};
+
+struct nvhost_device_power_attr {
+	struct platform_device *ndev;
+	struct kobj_attribute power_attr[NVHOST_POWER_SYSFS_ATTRIB_MAX];
+};
+
+/* public host1x power management APIs */
+bool host1x_powered(struct platform_device *dev);
+void host1x_busy(struct platform_device *dev);
+void host1x_idle(struct platform_device *dev);
+
+/* public host1x sync-point management APIs */
+u32 host1x_syncpt_incr_max(u32 id, u32 incrs);
+void host1x_syncpt_incr(u32 id);
+u32 host1x_syncpt_read(u32 id);
+
+#endif
-- 
1.7.9.5

