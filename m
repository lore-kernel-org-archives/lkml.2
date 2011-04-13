Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134Ab1DMTXE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 15:23:04 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56544 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757720Ab1DMTXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 15:23:02 -0400
From: mathieu.poirier@linaro.org
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: lee.jones@linaro.org, patches@linaro.org, linus.walleij@linaro.org
Subject: [PATCH] ux500: Adding support for u8500 Hsem functionality V3
Date: Wed, 13 Apr 2011 13:22:50 -0600
Message-Id: <1302722570-9494-1-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu J. Poirier <mathieu.poirier@linaro.org>

This driver provides functionality for STE's Hsem protocol
1, with no interrupts.  It is folded in the hwspinlock scheme and
as such meant to provide synchronisation between various processors
on the SoC rather than processes inside the ARM core.

Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/hwspinlock/u8500_hsem.c |  245 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 245 insertions(+), 0 deletions(-)
 create mode 100644 drivers/hwspinlock/u8500_hsem.c

diff --git a/drivers/hwspinlock/u8500_hsem.c b/drivers/hwspinlock/u8500_hsem.c
new file mode 100644
index 0000000..85c3c07
--- /dev/null
+++ b/drivers/hwspinlock/u8500_hsem.c
@@ -0,0 +1,245 @@
+/*
+ * u8500 HWSEM driver
+ *
+ * Copyright (C) 2010-2011 ST-Ericsson
+ *
+ * Implements u8500 semaphore handling for protocol 1, no interrupts.
+ *
+ * Author: Mathieu Poirier <mathieu.poirier@linaro.org>
+ * Heavily borrowed from the work of :
+ *   Simon Que <sque@ti.com>
+ *   Hari Kanigeri <h-kanigeri2@ti.com>
+ *   Ohad Ben-Cohen <ohad@wizery.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/pm_runtime.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/hwspinlock.h>
+#include <linux/platform_device.h>
+
+#include "hwspinlock_internal.h"
+
+/*
+ * Implementation of STE's HSem protocol 1 without interrutps.
+ * The only masterID we allow is '0x01' to force people to use
+ * HSems for synchronisation between processors rather than processes
+ * on the ARM core.
+ */
+
+#define U8500_MAX_SEMAPHORE		32	/* a total of 32 semaphore */
+#define RESET_SEMAPHORE			(0)	/* free */
+
+/* CPU ID for master running u8500 kernel.
+ * Hswpinlocks should only be used to synchonise operations
+ * between the Cortex A9 core and the other CPUs.  Hence
+ * forcing the masterID to a preset value.
+ */
+#define HSEM_MASTER_ID			0x01
+
+#define HSEM_REGISTER_OFFSET		0x08
+
+#define HSEM_CTRL_REG			0x00
+#define HSEM_ICRALL			0x90
+#define HSEM_PROTOCOL_1			0x01
+
+#define to_u8500_hsem(lock)	\
+	container_of(lock, struct u8500_hsem, lock)
+
+struct u8500_hsem {
+	struct hwspinlock lock;
+	void __iomem *addr;
+};
+
+struct u8500_hsem_state {
+	void __iomem *io_base;		/* Mapped base address */
+};
+
+static int u8500_hsem_trylock(struct hwspinlock *lock)
+{
+	struct u8500_hsem *u8500_lock = to_u8500_hsem(lock);
+
+	writel(HSEM_MASTER_ID, u8500_lock->addr);
+
+	/*
+	 * get only first 4 bit and compare to masterID.
+	 * if equal, we have the semaphore, otherwise
+	 * someone else has it.
+	 */
+	return (HSEM_MASTER_ID == (0x0F & readl(u8500_lock->addr)));
+}
+
+static void u8500_hsem_unlock(struct hwspinlock *lock)
+{
+	struct u8500_hsem *u8500_lock = to_u8500_hsem(lock);
+
+	/* release the lock by writing 0 to it */
+	writel(RESET_SEMAPHORE, u8500_lock->addr);
+}
+
+/*
+ * u8500: what value is recommended here ?
+ */
+static void u8500_hsem_relax(struct hwspinlock *lock)
+{
+	ndelay(50);
+}
+
+static const struct hwspinlock_ops u8500_hwspinlock_ops = {
+	.trylock	= u8500_hsem_trylock,
+	.unlock		= u8500_hsem_unlock,
+	.relax		= u8500_hsem_relax,
+};
+
+static int __devinit u8500_hsem_probe(struct platform_device *pdev)
+{
+	struct u8500_hsem *u8500_lock;
+	struct u8500_hsem_state *state;
+	struct hwspinlock *lock;
+	struct resource *res;
+	void __iomem *io_base;
+	int i, ret;
+	ulong offset, val;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENODEV;
+
+	state = kzalloc(sizeof(*state), GFP_KERNEL);
+	if (!state)
+		return -ENOMEM;
+
+	io_base = ioremap(res->start, resource_size(res));
+	if (!io_base) {
+		ret = -ENOMEM;
+		goto free_state;
+	}
+
+	/* make sure protocol 1 is selected */
+	val = readl(io_base + HSEM_CTRL_REG);
+	writel((val & ~HSEM_PROTOCOL_1), io_base + HSEM_CTRL_REG);
+
+	/* clear all interrupts */
+	writel(0xFFFF, io_base + HSEM_ICRALL);
+
+	state->io_base = io_base;
+
+	platform_set_drvdata(pdev, state);
+
+	/*
+	 * no pm needed for HSem but required to comply
+	 * with hwspilock core.
+	 */
+	pm_runtime_enable(&pdev->dev);
+
+	offset = HSEM_REGISTER_OFFSET;
+
+	for (i = 0; i < U8500_MAX_SEMAPHORE; i++) {
+		u8500_lock = kzalloc(sizeof(*u8500_lock), GFP_KERNEL);
+		if (!u8500_lock) {
+			ret = -ENOMEM;
+			goto free_locks;
+		}
+
+		u8500_lock->lock.dev = &pdev->dev;
+		u8500_lock->lock.owner = THIS_MODULE;
+		u8500_lock->lock.id = i;
+		u8500_lock->lock.ops = &u8500_hwspinlock_ops;
+		u8500_lock->addr = io_base + offset + sizeof(u32) * i;
+
+		ret = hwspin_lock_register(&u8500_lock->lock);
+		if (ret) {
+			kfree(u8500_lock);
+			goto free_locks;
+		}
+	}
+
+	return 0;
+
+free_locks:
+	while (--i >= 0) {
+		lock = hwspin_lock_unregister(i);
+		/* this should't happen, but let's give our best effort */
+		if (!lock) {
+			dev_err(&pdev->dev, "%s: cleanups failed\n", __func__);
+			continue;
+		}
+		u8500_lock = to_u8500_hsem(lock);
+		kfree(u8500_lock);
+	}
+
+	pm_runtime_disable(&pdev->dev);
+	iounmap(io_base);
+free_state:
+	kfree(state);
+	return ret;
+}
+
+static int u8500_hsem_remove(struct platform_device *pdev)
+{
+	struct u8500_hsem_state *state = platform_get_drvdata(pdev);
+	struct hwspinlock *lock;
+	struct u8500_hsem *u8500_lock;
+	void __iomem *io_base;
+	int i;
+
+	io_base = state->io_base;
+
+	/* clear all interrupts */
+	writel(0xFFFF, io_base + HSEM_ICRALL);
+
+	for (i = 0; i < U8500_MAX_SEMAPHORE; i++) {
+		lock = hwspin_lock_unregister(i);
+		/* this shouldn't happen at this point. if it does, at least
+		 * don't continue with the remove */
+		if (!lock) {
+			dev_err(&pdev->dev, "%s: failed on %d\n", __func__, i);
+			return -EBUSY;
+		}
+
+		u8500_lock = to_u8500_hsem(lock);
+		kfree(u8500_lock);
+	}
+
+	pm_runtime_disable(&pdev->dev);
+	iounmap(io_base);
+	kfree(state);
+
+	return 0;
+}
+
+static struct platform_driver u8500_hsem_driver = {
+	.probe		= u8500_hsem_probe,
+	.remove		= u8500_hsem_remove,
+	.driver		= {
+		.name	= "u8500_hsem",
+	},
+};
+
+static int __init u8500_hsem_init(void)
+{
+	return platform_driver_register(&u8500_hsem_driver);
+}
+/* board init code might need to reserve hwspinlocks for predefined purposes */
+postcore_initcall(u8500_hsem_init);
+
+static void __exit u8500_hsem_exit(void)
+{
+	platform_driver_unregister(&u8500_hsem_driver);
+}
+module_exit(u8500_hsem_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("Hardware Semaphore driver for u8500");
+MODULE_AUTHOR("Mathieu Poirier <mathieu.poirier@linaro.org");
-- 
1.7.1

