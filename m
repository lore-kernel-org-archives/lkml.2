Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759Ab2LMOAv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:00:51 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19418 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755706Ab2LMOAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:00:49 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 13 Dec 2012 05:59:39 -0800
From: Terje Bergstrom <tbergstrom@nvidia.com>
To: <tbergstrom@nvidia.com>, <thierry.reding@avionic-design.de>,
        <dev@lynxeye.de>, <linux-tegra@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>
CC: <amerilainen@nvidia.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCHv3 1/7] gpu: host1x: Add host1x driver
Date: Thu, 13 Dec 2012 16:04:38 +0200
Message-ID: <1355407484-28904-2-git-send-email-tbergstrom@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407484-28904-1-git-send-email-tbergstrom@nvidia.com>
References: <1355407484-28904-1-git-send-email-tbergstrom@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add host1x, the driver for host1x and its client unit 2D.

Signed-off-by: Terje Bergstrom <tbergstrom@nvidia.com>
---
 drivers/gpu/Makefile                      |    1 +
 drivers/gpu/host1x/Kconfig                |    6 +
 drivers/gpu/host1x/Makefile               |    8 +
 drivers/gpu/host1x/dev.c                  |  182 +++++++++++++++++++++++
 drivers/gpu/host1x/dev.h                  |   79 ++++++++++
 drivers/gpu/host1x/hw/Makefile            |    6 +
 drivers/gpu/host1x/hw/host1x01.c          |   36 +++++
 drivers/gpu/host1x/hw/host1x01.h          |   25 ++++
 drivers/gpu/host1x/hw/host1x01_hardware.h |   26 ++++
 drivers/gpu/host1x/hw/hw_host1x01_sync.h  |   66 +++++++++
 drivers/gpu/host1x/hw/syncpt_hw.c         |  146 +++++++++++++++++++
 drivers/gpu/host1x/syncpt.c               |  227 +++++++++++++++++++++++++++++
 drivers/gpu/host1x/syncpt.h               |  128 ++++++++++++++++
 drivers/video/Kconfig                     |    2 +
 include/linux/host1x.h                    |   41 ++++++
 include/trace/events/host1x.h             |   61 ++++++++
 16 files changed, 1040 insertions(+)
 create mode 100644 drivers/gpu/host1x/Kconfig
 create mode 100644 drivers/gpu/host1x/Makefile
 create mode 100644 drivers/gpu/host1x/dev.c
 create mode 100644 drivers/gpu/host1x/dev.h
 create mode 100644 drivers/gpu/host1x/hw/Makefile
 create mode 100644 drivers/gpu/host1x/hw/host1x01.c
 create mode 100644 drivers/gpu/host1x/hw/host1x01.h
 create mode 100644 drivers/gpu/host1x/hw/host1x01_hardware.h
 create mode 100644 drivers/gpu/host1x/hw/hw_host1x01_sync.h
 create mode 100644 drivers/gpu/host1x/hw/syncpt_hw.c
 create mode 100644 drivers/gpu/host1x/syncpt.c
 create mode 100644 drivers/gpu/host1x/syncpt.h
 create mode 100644 include/linux/host1x.h
 create mode 100644 include/trace/events/host1x.h

diff --git a/drivers/gpu/Makefile b/drivers/gpu/Makefile
index cc92778..7fa2f68 100644
--- a/drivers/gpu/Makefile
+++ b/drivers/gpu/Makefile
@@ -1 +1,2 @@
+obj-$(CONFIG_TEGRA_HOST1X)	+= host1x/
 obj-y			+= drm/ vga/ stub/
diff --git a/drivers/gpu/host1x/Kconfig b/drivers/gpu/host1x/Kconfig
new file mode 100644
index 0000000..e89fb2b
--- /dev/null
+++ b/drivers/gpu/host1x/Kconfig
@@ -0,0 +1,6 @@
+config TEGRA_HOST1X
+	tristate "Tegra host1x driver"
+	help
+	  Driver for the Tegra host1x hardware.
+
+	  Required for enabling tegradrm.
diff --git a/drivers/gpu/host1x/Makefile b/drivers/gpu/host1x/Makefile
new file mode 100644
index 0000000..a4adcc6
--- /dev/null
+++ b/drivers/gpu/host1x/Makefile
@@ -0,0 +1,8 @@
+ccflags-y = -Idrivers/gpu/host1x
+
+host1x-objs = \
+	syncpt.o \
+	dev.o
+
+obj-$(CONFIG_TEGRA_HOST1X) += hw/
+obj-$(CONFIG_TEGRA_HOST1X) += host1x.o
diff --git a/drivers/gpu/host1x/dev.c b/drivers/gpu/host1x/dev.c
new file mode 100644
index 0000000..b0d630d
--- /dev/null
+++ b/drivers/gpu/host1x/dev.c
@@ -0,0 +1,182 @@
+/*
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
+#include <linux/host1x.h>
+#include <linux/list.h>
+#include <linux/slab.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/clk.h>
+#include <linux/io.h>
+#include "dev.h"
+#include "hw/host1x01.h"
+
+#define CREATE_TRACE_POINTS
+#include <trace/events/host1x.h>
+
+#define DRIVER_NAME		"tegra-host1x"
+
+struct host1x *host1x;
+
+void host1x_syncpt_incr_byid(u32 id)
+{
+	struct host1x_syncpt *sp = host1x->syncpt + id;
+	return host1x_syncpt_incr(sp);
+}
+EXPORT_SYMBOL(host1x_syncpt_incr_byid);
+
+u32 host1x_syncpt_read_byid(u32 id)
+{
+	struct host1x_syncpt *sp = host1x->syncpt + id;
+	return host1x_syncpt_read(sp);
+}
+EXPORT_SYMBOL(host1x_syncpt_read_byid);
+
+void host1x_sync_writel(struct host1x *host1x, u32 v, u32 r)
+{
+	void __iomem *sync_regs = host1x->regs + host1x->info.sync_offset;
+
+	writel(v, sync_regs + r);
+}
+
+u32 host1x_sync_readl(struct host1x *host1x, u32 r)
+{
+	void __iomem *sync_regs = host1x->regs + host1x->info.sync_offset;
+
+	return readl(sync_regs + r);
+}
+
+static struct host1x_device_info host1x_info = {
+	.nb_channels	= 8,
+	.nb_pts		= 32,
+	.nb_mlocks	= 16,
+	.nb_bases	= 8,
+	.init		= host1x01_init,
+	.sync_offset	= 0x3000,
+};
+
+static struct of_device_id host1x_match[] = {
+	{ .compatible = "nvidia,tegra30-host1x", .data = &host1x_info, },
+	{ .compatible = "nvidia,tegra20-host1x", .data = &host1x_info, },
+	{ },
+};
+
+static int host1x_probe(struct platform_device *dev)
+{
+	struct host1x *host;
+	struct resource *regs;
+	int syncpt_irq;
+	int err;
+	const struct of_device_id *devid =
+		of_match_device(host1x_match, &dev->dev);
+
+	if (!devid)
+		return -EINVAL;
+
+	regs = platform_get_resource(dev, IORESOURCE_MEM, 0);
+	if (!regs) {
+		dev_err(&dev->dev, "missing regs\n");
+		return -ENXIO;
+	}
+
+	syncpt_irq = platform_get_irq(dev, 0);
+	if (IS_ERR_VALUE(syncpt_irq)) {
+		dev_err(&dev->dev, "missing irq\n");
+		return -ENXIO;
+	}
+
+	host = devm_kzalloc(&dev->dev, sizeof(*host), GFP_KERNEL);
+	if (!host)
+		return -ENOMEM;
+
+	host->dev = dev;
+	memcpy(&host->info, devid->data, sizeof(struct host1x_device_info));
+
+	/* set common host1x device data */
+	platform_set_drvdata(dev, host);
+
+	host->regs = devm_request_and_ioremap(&dev->dev, regs);
+	if (!host->regs) {
+		dev_err(&dev->dev, "failed to remap host registers\n");
+		err = -ENXIO;
+		goto fail;
+	}
+
+	if (host->info.init) {
+		err = host->info.init(host);
+		if (err)
+			goto fail;
+	}
+
+	host->syncpt = host1x_syncpt_init(host);
+	if (!host->syncpt)
+		goto fail;
+
+	host->nop_sp = _host1x_syncpt_alloc(host, NULL, 0);
+	if (!host->nop_sp)
+		goto fail;
+
+	host->clk = devm_clk_get(&dev->dev, NULL);
+	if (IS_ERR(host->clk)) {
+		dev_err(&dev->dev, "failed to get clock\n");
+		err = PTR_ERR(host->clk);
+		goto fail;
+	}
+
+	err = clk_prepare_enable(host->clk);
+	if (err < 0)
+		goto fail;
+
+	host1x_syncpt_reset(host);
+
+	host1x = host;
+
+	dev_info(&dev->dev, "initialized\n");
+
+	return 0;
+
+fail:
+	host1x_syncpt_free(host->nop_sp);
+	kfree(host);
+	return err;
+}
+
+static int __exit host1x_remove(struct platform_device *dev)
+{
+	struct host1x *host = platform_get_drvdata(dev);
+	host1x_syncpt_deinit(host);
+	clk_disable_unprepare(host->clk);
+	return 0;
+}
+
+static struct platform_driver platform_driver = {
+	.probe = host1x_probe,
+	.remove = __exit_p(host1x_remove),
+	.driver = {
+		.owner = THIS_MODULE,
+		.name = DRIVER_NAME,
+		.of_match_table = host1x_match,
+	},
+};
+
+module_platform_driver(platform_driver);
+
+MODULE_AUTHOR("Terje Bergstrom <tbergstrom@nvidia.com>");
+MODULE_DESCRIPTION("Host1x driver for Tegra products");
+MODULE_LICENSE("GPL");
diff --git a/drivers/gpu/host1x/dev.h b/drivers/gpu/host1x/dev.h
new file mode 100644
index 0000000..8245e24
--- /dev/null
+++ b/drivers/gpu/host1x/dev.h
@@ -0,0 +1,79 @@
+/*
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
+#ifndef HOST1X_DEV_H
+#define HOST1X_DEV_H
+
+#include <linux/host1x.h>
+
+#include "syncpt.h"
+
+struct host1x;
+struct host1x_syncpt;
+struct platform_device;
+
+struct host1x_syncpt_ops {
+	void (*reset)(struct host1x_syncpt *);
+	void (*reset_wait_base)(struct host1x_syncpt *);
+	void (*read_wait_base)(struct host1x_syncpt *);
+	u32 (*load_min)(struct host1x_syncpt *);
+	void (*cpu_incr)(struct host1x_syncpt *);
+	int (*patch_wait)(struct host1x_syncpt *, void *patch_addr);
+	void (*debug)(struct host1x_syncpt *);
+	const char * (*name)(struct host1x_syncpt *);
+};
+
+struct host1x_device_info {
+	int	nb_channels;		/* host1x: num channels supported */
+	int	nb_pts;			/* host1x: num syncpoints supported */
+	int	nb_bases;		/* host1x: num syncpoints supported */
+	int	nb_mlocks;		/* host1x: number of mlocks */
+	int	(*init)(struct host1x *); /* initialize per SoC ops */
+	int	sync_offset;
+};
+
+struct host1x {
+	void __iomem *regs;
+	struct host1x_syncpt *syncpt;
+	struct platform_device *dev;
+	atomic_t clientid;
+	struct host1x_device_info info;
+	struct clk *clk;
+
+	struct host1x_syncpt *nop_sp;
+
+	const char *soc_name;
+	struct host1x_syncpt_ops syncpt_op;
+
+	struct dentry *debugfs;
+};
+
+static inline
+struct host1x *host1x_get_host(struct platform_device *_dev)
+{
+	struct platform_device *pdev;
+
+	if (_dev->dev.parent) {
+		pdev = to_platform_device(_dev->dev.parent);
+		return platform_get_drvdata(pdev);
+	} else
+		return platform_get_drvdata(_dev);
+}
+
+void host1x_sync_writel(struct host1x *host1x, u32 r, u32 v);
+u32 host1x_sync_readl(struct host1x *host1x, u32 r);
+
+#endif
diff --git a/drivers/gpu/host1x/hw/Makefile b/drivers/gpu/host1x/hw/Makefile
new file mode 100644
index 0000000..9b50863
--- /dev/null
+++ b/drivers/gpu/host1x/hw/Makefile
@@ -0,0 +1,6 @@
+ccflags-y = -Idrivers/gpu/host1x
+
+host1x-hw-objs  = \
+	host1x01.o
+
+obj-$(CONFIG_TEGRA_HOST1X) += host1x-hw.o
diff --git a/drivers/gpu/host1x/hw/host1x01.c b/drivers/gpu/host1x/hw/host1x01.c
new file mode 100644
index 0000000..59176ba
--- /dev/null
+++ b/drivers/gpu/host1x/hw/host1x01.c
@@ -0,0 +1,36 @@
+/*
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
+#include <linux/init.h>
+#include <linux/clk.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <linux/host1x.h>
+
+#include "hw/host1x01.h"
+#include "dev.h"
+#include "hw/host1x01_hardware.h"
+
+#include "hw/syncpt_hw.c"
+
+int host1x01_init(struct host1x *host)
+{
+	host->syncpt_op = host1x_syncpt_ops;
+
+	return 0;
+}
diff --git a/drivers/gpu/host1x/hw/host1x01.h b/drivers/gpu/host1x/hw/host1x01.h
new file mode 100644
index 0000000..177725b
--- /dev/null
+++ b/drivers/gpu/host1x/hw/host1x01.h
@@ -0,0 +1,25 @@
+/*
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
+#ifndef HOST1X_HOST1X01_H
+#define HOST1X_HOST1X01_H
+
+struct host1x;
+
+int host1x01_init(struct host1x *);
+
+#endif /* HOST1X_HOST1X01_H_ */
diff --git a/drivers/gpu/host1x/hw/host1x01_hardware.h b/drivers/gpu/host1x/hw/host1x01_hardware.h
new file mode 100644
index 0000000..4e57f21
--- /dev/null
+++ b/drivers/gpu/host1x/hw/host1x01_hardware.h
@@ -0,0 +1,26 @@
+/*
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
+#ifndef __HOST1X_HOST1X01_HARDWARE_H
+#define __HOST1X_HOST1X01_HARDWARE_H
+
+#include <linux/types.h>
+#include <linux/bitops.h>
+#include "hw_host1x01_sync.h"
+
+#endif
diff --git a/drivers/gpu/host1x/hw/hw_host1x01_sync.h b/drivers/gpu/host1x/hw/hw_host1x01_sync.h
new file mode 100644
index 0000000..63a71c8
--- /dev/null
+++ b/drivers/gpu/host1x/hw/hw_host1x01_sync.h
@@ -0,0 +1,66 @@
+/*
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
+#ifndef __hw_host1x_sync_h__
+#define __hw_host1x_sync_h__
+
+static inline u32 host1x_sync_syncpt_0_r(void)
+{
+	return 0x400;
+}
+static inline u32 host1x_sync_syncpt_base_0_r(void)
+{
+	return 0x600;
+}
+static inline u32 host1x_sync_syncpt_cpu_incr_r(void)
+{
+	return 0x700;
+}
+#endif /* __hw_host1x_host1x_h__ */
diff --git a/drivers/gpu/host1x/hw/syncpt_hw.c b/drivers/gpu/host1x/hw/syncpt_hw.c
new file mode 100644
index 0000000..44a10b0
--- /dev/null
+++ b/drivers/gpu/host1x/hw/syncpt_hw.c
@@ -0,0 +1,146 @@
+/*
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
+#include "syncpt.h"
+#include "dev.h"
+
+/*
+ * Write the current syncpoint value back to hw.
+ */
+static void syncpt_reset(struct host1x_syncpt *sp)
+{
+	struct host1x *dev = sp->dev;
+	int min = host1x_syncpt_read_min(sp);
+	host1x_sync_writel(dev, min, host1x_sync_syncpt_0_r() + sp->id * 4);
+}
+
+/*
+ * Write the current waitbase value back to hw.
+ */
+static void syncpt_reset_wait_base(struct host1x_syncpt *sp)
+{
+	struct host1x *dev = sp->dev;
+	host1x_sync_writel(dev, sp->base_val,
+			host1x_sync_syncpt_base_0_r() + sp->id * 4);
+}
+
+/*
+ * Read waitbase value from hw.
+ */
+static void syncpt_read_wait_base(struct host1x_syncpt *sp)
+{
+	struct host1x *dev = sp->dev;
+	sp->base_val = host1x_sync_readl(dev,
+				host1x_sync_syncpt_base_0_r() + sp->id * 4);
+}
+
+/*
+ * Updates the last value read from hardware.
+ * (was host1x_syncpt_load_min)
+ */
+static u32 syncpt_load_min(struct host1x_syncpt *sp)
+{
+	struct host1x *dev = sp->dev;
+	u32 old, live;
+
+	do {
+		old = host1x_syncpt_read_min(sp);
+		live = host1x_sync_readl(dev,
+				host1x_sync_syncpt_0_r() + sp->id * 4);
+	} while ((u32)atomic_cmpxchg(&sp->min_val, old, live) != old);
+
+	if (!host1x_syncpt_check_max(sp, live))
+		dev_err(&dev->dev->dev,
+				"%s failed: id=%u, min=%d, max=%d\n",
+				__func__,
+				sp->id,
+				host1x_syncpt_read_min(sp),
+				host1x_syncpt_read_max(sp));
+
+	return live;
+}
+
+/*
+ * Write a cpu syncpoint increment to the hardware, without touching
+ * the cache. Caller is responsible for host being powered.
+ */
+static void syncpt_cpu_incr(struct host1x_syncpt *sp)
+{
+	struct host1x *dev = sp->dev;
+	u32 reg_offset = sp->id / 32;
+
+	if (!host1x_syncpt_client_managed(sp)
+			&& host1x_syncpt_min_eq_max(sp)) {
+		dev_err(&dev->dev->dev,
+			"Trying to increment syncpoint id %d beyond max\n",
+			sp->id);
+		return;
+	}
+	host1x_sync_writel(dev, BIT_MASK(sp->id),
+			host1x_sync_syncpt_cpu_incr_r() + reg_offset * 4);
+	wmb();
+}
+
+static const char *syncpt_name(struct host1x_syncpt *sp)
+{
+	struct host1x_device_info *info = &sp->dev->info;
+	const char *name = NULL;
+
+	if (sp->id < info->nb_pts)
+		name = sp->name;
+
+	return name ? name : "";
+}
+
+static void syncpt_debug(struct host1x_syncpt *sp)
+{
+	u32 i;
+	for (i = 0; i < host1x_syncpt_nb_pts(sp->dev); i++) {
+		u32 max = host1x_syncpt_read_max(sp);
+		u32 min = host1x_syncpt_load_min(sp);
+		if (!max && !min)
+			continue;
+		dev_info(&sp->dev->dev->dev,
+			"id %d (%s) min %d max %d\n",
+			i, sp->name,
+			min, max);
+
+	}
+
+	for (i = 0; i < host1x_syncpt_nb_bases(sp->dev); i++) {
+		u32 base_val;
+		host1x_syncpt_read_wait_base(sp);
+		base_val = sp->base_val;
+		if (base_val)
+			dev_info(&sp->dev->dev->dev,
+					"waitbase id %d val %d\n",
+					i, base_val);
+
+	}
+}
+
+static const struct host1x_syncpt_ops host1x_syncpt_ops = {
+	.reset = syncpt_reset,
+	.reset_wait_base = syncpt_reset_wait_base,
+	.read_wait_base = syncpt_read_wait_base,
+	.load_min = syncpt_load_min,
+	.cpu_incr = syncpt_cpu_incr,
+	.debug = syncpt_debug,
+	.name = syncpt_name,
+};
diff --git a/drivers/gpu/host1x/syncpt.c b/drivers/gpu/host1x/syncpt.c
new file mode 100644
index 0000000..d551325
--- /dev/null
+++ b/drivers/gpu/host1x/syncpt.c
@@ -0,0 +1,227 @@
+/*
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
+#include <linux/module.h>
+#include "syncpt.h"
+#include "dev.h"
+#include <trace/events/host1x.h>
+
+#define MAX_SYNCPT_LENGTH	5
+
+u32 host1x_syncpt_id(struct host1x_syncpt *sp)
+{
+	return sp->id;
+}
+EXPORT_SYMBOL(host1x_syncpt_id);
+
+/*
+ * Updates the value sent to hardware.
+ */
+u32 host1x_syncpt_incr_max(struct host1x_syncpt *sp, u32 incrs)
+{
+	return (u32)atomic_add_return(incrs, &sp->max_val);
+}
+EXPORT_SYMBOL(host1x_syncpt_incr_max);
+
+/*
+ * Resets syncpoint and waitbase values to sw shadows
+ */
+void host1x_syncpt_reset(struct host1x *dev)
+{
+	struct host1x_syncpt *sp_base = dev->syncpt;
+	u32 i;
+
+	for (i = 0; i < host1x_syncpt_nb_pts(dev); i++)
+		dev->syncpt_op.reset(sp_base + i);
+	for (i = 0; i < host1x_syncpt_nb_bases(dev); i++)
+		dev->syncpt_op.reset_wait_base(sp_base + i);
+	wmb();
+}
+
+/*
+ * Updates sw shadow state for client managed registers
+ */
+void host1x_syncpt_save(struct host1x *dev)
+{
+	struct host1x_syncpt *sp_base = dev->syncpt;
+	u32 i;
+
+	for (i = 0; i < host1x_syncpt_nb_pts(dev); i++) {
+		if (host1x_syncpt_client_managed(sp_base + i))
+			dev->syncpt_op.load_min(sp_base + i);
+		else
+			WARN_ON(!host1x_syncpt_min_eq_max(sp_base + i));
+	}
+
+	for (i = 0; i < host1x_syncpt_nb_bases(dev); i++)
+		dev->syncpt_op.read_wait_base(sp_base + i);
+}
+
+/*
+ * Updates the last value read from hardware.
+ */
+u32 host1x_syncpt_load_min(struct host1x_syncpt *sp)
+{
+	u32 val;
+	val = sp->dev->syncpt_op.load_min(sp);
+	trace_host1x_syncpt_load_min(sp->id, val);
+
+	return val;
+}
+
+/*
+ * Get the current syncpoint value
+ */
+u32 host1x_syncpt_read(struct host1x_syncpt *sp)
+{
+	u32 val;
+	val = sp->dev->syncpt_op.load_min(sp);
+	return val;
+}
+EXPORT_SYMBOL(host1x_syncpt_read);
+
+/*
+ * Get the current syncpoint base
+ */
+u32 host1x_syncpt_read_wait_base(struct host1x_syncpt *sp)
+{
+	u32 val;
+	sp->dev->syncpt_op.read_wait_base(sp);
+	val = sp->base_val;
+	return val;
+}
+
+/*
+ * Write a cpu syncpoint increment to the hardware, without touching
+ * the cache. Caller is responsible for host being powered.
+ */
+void host1x_syncpt_cpu_incr(struct host1x_syncpt *sp)
+{
+	sp->dev->syncpt_op.cpu_incr(sp);
+}
+
+/*
+ * Increment syncpoint value from cpu, updating cache
+ */
+void host1x_syncpt_incr(struct host1x_syncpt *sp)
+{
+	if (host1x_syncpt_client_managed(sp))
+		host1x_syncpt_incr_max(sp, 1);
+	host1x_syncpt_cpu_incr(sp);
+}
+EXPORT_SYMBOL(host1x_syncpt_incr);
+
+void host1x_syncpt_debug(struct host1x_syncpt *sp)
+{
+	sp->dev->syncpt_op.debug(sp);
+}
+
+struct host1x_syncpt *host1x_syncpt_init(struct host1x *host)
+{
+	struct host1x_syncpt *syncpt, *sp;
+	int i;
+
+	syncpt = sp = kzalloc(sizeof(struct host1x_syncpt) * host->info.nb_pts,
+		GFP_KERNEL);
+	if (!syncpt)
+		return NULL;
+
+	for (i = 0; i < host->info.nb_pts; ++i, ++sp) {
+		sp->id = i;
+		sp->dev = host;
+	}
+
+	return syncpt;
+}
+
+struct host1x_syncpt *_host1x_syncpt_alloc(struct host1x *host,
+		struct platform_device *pdev,
+		int client_managed)
+{
+	int i;
+	struct host1x_syncpt *sp = host->syncpt;
+	char *name;
+
+	for (i = 0; i < host->info.nb_pts && sp->name; i++, sp++)
+		;
+	if (sp->pdev)
+		return NULL;
+
+	name = kasprintf(GFP_KERNEL, "%02d-%s", sp->id,
+			pdev ? dev_name(&pdev->dev) : NULL);
+	if (!name)
+		return NULL;
+
+	sp->pdev = pdev;
+	sp->name = name;
+	sp->client_managed = client_managed;
+
+	return sp;
+}
+
+struct host1x_syncpt *host1x_syncpt_alloc(struct platform_device *pdev,
+		int client_managed)
+{
+	struct host1x *host = host1x_get_host(pdev);
+	return _host1x_syncpt_alloc(host, pdev, client_managed);
+}
+EXPORT_SYMBOL(host1x_syncpt_alloc);
+
+void host1x_syncpt_free(struct host1x_syncpt *sp)
+{
+	if (!sp)
+		return;
+
+	kfree(sp->name);
+	sp->pdev = NULL;
+	sp->name = NULL;
+	sp->client_managed = 0;
+}
+EXPORT_SYMBOL(host1x_syncpt_free);
+
+void host1x_syncpt_deinit(struct host1x *host)
+{
+	int i;
+	struct host1x_syncpt *sp = host->syncpt;
+	for (i = 0; i < host->info.nb_pts; i++, sp++)
+		kfree(sp->name);
+	kfree(sp);
+}
+
+int host1x_syncpt_nb_pts(struct host1x *dev)
+{
+	return dev->info.nb_pts;
+}
+
+int host1x_syncpt_nb_bases(struct host1x *dev)
+{
+	return dev->info.nb_bases;
+}
+
+int host1x_syncpt_nb_mlocks(struct host1x *dev)
+{
+	return dev->info.nb_mlocks;
+}
+
+struct host1x_syncpt *host1x_syncpt_get(struct host1x *dev, u32 id)
+{
+	return dev->syncpt + id;
+}
diff --git a/drivers/gpu/host1x/syncpt.h b/drivers/gpu/host1x/syncpt.h
new file mode 100644
index 0000000..4f7777b
--- /dev/null
+++ b/drivers/gpu/host1x/syncpt.h
@@ -0,0 +1,128 @@
+/*
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
+#ifndef __HOST1X_SYNCPT_H
+#define __HOST1X_SYNCPT_H
+
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/host1x.h>
+#include <linux/atomic.h>
+
+/* host managed and invalid syncpt id */
+#define NVSYNCPT_GRAPHICS_HOST		     (0)
+
+struct host1x;
+
+struct host1x_syncpt {
+	int id;
+	atomic_t min_val;
+	atomic_t max_val;
+	u32 base_val;
+	const char *name;
+	int client_managed;
+	struct host1x *dev;
+	struct platform_device *pdev;
+};
+
+struct host1x_syncpt *host1x_syncpt_init(struct host1x *);
+void host1x_syncpt_deinit(struct host1x *);
+
+struct host1x_syncpt *_host1x_syncpt_alloc(struct host1x *,
+		struct platform_device *, int);
+void _host1x_syncpt_free(struct host1x_syncpt *sp);
+
+#define SYNCPT_CHECK_PERIOD (2 * HZ)
+#define MAX_STUCK_CHECK_COUNT 15
+
+/*
+ * Updated the value sent to hardware.
+ */
+static inline u32 host1x_syncpt_set_max(struct host1x_syncpt *sp, u32 val)
+{
+	atomic_set(&sp->max_val, val);
+	smp_wmb();
+	return val;
+}
+
+static inline u32 host1x_syncpt_read_max(struct host1x_syncpt *sp)
+{
+	smp_rmb();
+	return (u32)atomic_read(&sp->max_val);
+}
+
+static inline u32 host1x_syncpt_read_min(struct host1x_syncpt *sp)
+{
+	smp_rmb();
+	return (u32)atomic_read(&sp->min_val);
+}
+
+int host1x_syncpt_nb_pts(struct host1x *dev);
+int host1x_syncpt_nb_bases(struct host1x *dev);
+int host1x_syncpt_nb_mlocks(struct host1x *dev);
+
+static inline bool host1x_syncpt_check_max(struct host1x_syncpt *sp, u32 real)
+{
+	u32 max;
+	if (sp->client_managed)
+		return true;
+	max = host1x_syncpt_read_max(sp);
+	return (s32)(max - real) >= 0;
+}
+
+static inline int host1x_syncpt_client_managed(struct host1x_syncpt *sp)
+{
+	return sp->client_managed;
+}
+/*
+ * Returns true if syncpoint min == max
+ */
+static inline bool host1x_syncpt_min_eq_max(struct host1x_syncpt *sp)
+{
+	int min, max;
+	smp_rmb();
+	min = atomic_read(&sp->min_val);
+	max = atomic_read(&sp->max_val);
+	return (min == max);
+}
+
+struct host1x_syncpt *host1x_syncpt_get(struct host1x *dev, u32 id);
+
+void host1x_syncpt_cpu_incr(struct host1x_syncpt *sp);
+
+u32 host1x_syncpt_load_min(struct host1x_syncpt *sp);
+
+void host1x_syncpt_save(struct host1x *dev);
+
+void host1x_syncpt_reset(struct host1x *dev);
+
+u32 host1x_syncpt_read(struct host1x_syncpt *sp);
+u32 host1x_syncpt_read_wait_base(struct host1x_syncpt *sp);
+
+void host1x_syncpt_incr(struct host1x_syncpt *sp);
+u32 host1x_syncpt_incr_max(struct host1x_syncpt *sp, u32 incrs);
+
+void host1x_syncpt_debug(struct host1x_syncpt *sp);
+
+static inline int host1x_syncpt_is_valid(struct host1x_syncpt *sp)
+{
+	return sp->id != NVSYNCPT_INVALID &&
+		sp->id < host1x_syncpt_nb_pts(sp->dev);
+}
+
+#endif
diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index e7068c5..09b3762 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -19,6 +19,8 @@ source "drivers/char/agp/Kconfig"
 
 source "drivers/gpu/vga/Kconfig"
 
+source "drivers/gpu/host1x/Kconfig"
+
 source "drivers/gpu/drm/Kconfig"
 
 source "drivers/gpu/stub/Kconfig"
diff --git a/include/linux/host1x.h b/include/linux/host1x.h
new file mode 100644
index 0000000..6c2cc8a
--- /dev/null
+++ b/include/linux/host1x.h
@@ -0,0 +1,41 @@
+/*
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
+#ifndef __LINUX_HOST1X_H
+#define __LINUX_HOST1X_H
+
+#include <linux/device.h>
+#include <linux/types.h>
+#include <linux/platform_device.h>
+
+struct host1x_syncpt;
+
+#define NVSYNCPT_INVALID			(-1)
+
+/* public host1x sync-point management APIs */
+u32 host1x_syncpt_id(struct host1x_syncpt *sp);
+void host1x_syncpt_incr_byid(u32 id);
+u32 host1x_syncpt_read_byid(u32 id);
+
+struct host1x_syncpt *host1x_syncpt_alloc(struct platform_device *pdev,
+		int client_managed);
+void host1x_syncpt_free(struct host1x_syncpt *sp);
+
+#endif
diff --git a/include/trace/events/host1x.h b/include/trace/events/host1x.h
new file mode 100644
index 0000000..d98d74c
--- /dev/null
+++ b/include/trace/events/host1x.h
@@ -0,0 +1,61 @@
+/*
+ * include/trace/events/host1x.h
+ *
+ * Nvhost event logging to ftrace.
+ *
+ * Copyright (c) 2010-2012, NVIDIA Corporation.
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
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM host1x
+
+#if !defined(_TRACE_HOST1X_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_HOST1X_H
+
+#include <linux/ktime.h>
+#include <linux/tracepoint.h>
+
+DECLARE_EVENT_CLASS(host1x,
+	TP_PROTO(const char *name),
+	TP_ARGS(name),
+	TP_STRUCT__entry(__field(const char *, name)),
+	TP_fast_assign(__entry->name = name;),
+	TP_printk("name=%s", __entry->name)
+);
+
+TRACE_EVENT(host1x_syncpt_load_min,
+	TP_PROTO(u32 id, u32 val),
+
+	TP_ARGS(id, val),
+
+	TP_STRUCT__entry(
+		__field(u32, id)
+		__field(u32, val)
+	),
+
+	TP_fast_assign(
+		__entry->id = id;
+		__entry->val = val;
+	),
+
+	TP_printk("id=%d, val=%d", __entry->id, __entry->val)
+);
+
+#endif /*  _TRACE_HOST1X_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
1.7.9.5

