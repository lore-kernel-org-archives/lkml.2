Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917Ab3AIODK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 09:03:10 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:43303 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757803Ab3AIODI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 09:03:08 -0500
Subject: [PATCH 02/10] goldfish: add the goldfish virtual bus
To: arve@android.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        mikechan@google.com
From: Alan Cox <alan@linux.intel.com>
Date: Wed, 09 Jan 2013 14:23:07 +0000
Message-ID: <20130109142305.9239.37581.stgit@bob.linux.org.uk>
In-Reply-To: <20130109142212.9239.62026.stgit@bob.linux.org.uk>
References: <20130109142212.9239.62026.stgit@bob.linux.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jun Nakajima <jnakajim@gmail.com>

This imports the current Google code and cleans it up slightly to use pr_ and
to properly request its resources.

Goldfish is an emulator used for Android development. It has a virtual bus where
the emulator passes platform device information to the guest which then creates
the appropriate devices.

This part of the emulation is not architecture specific so should not be hiding
in architecture trees as it does in the Google Android tree. The constants it
uses do depend on the platform and so live in arch/goldfish.h

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Yunhong Jiang <yunhong.jiang@intel.com>
Signed-off-by: Xiaohui Xin <xiaohui.xin@intel.com>
Signed-off-by: Jun Nakajima <jun.nakajima@intel.com>
Signed-off-by: Bruce Beare <bruce.j.beare@intel.com>
[Moved out of x86, cleaned up headers]
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/platform/Makefile            |    1 
 drivers/platform/goldfish/Makefile   |    4 +
 drivers/platform/goldfish/pdev_bus.c |  265 ++++++++++++++++++++++++++++++++++
 3 files changed, 270 insertions(+)
 create mode 100644 drivers/platform/goldfish/Makefile
 create mode 100644 drivers/platform/goldfish/pdev_bus.c


diff --git a/drivers/platform/Makefile b/drivers/platform/Makefile
index b17c16c..8a44a4c 100644
--- a/drivers/platform/Makefile
+++ b/drivers/platform/Makefile
@@ -4,3 +4,4 @@
 
 obj-$(CONFIG_X86)		+= x86/
 obj-$(CONFIG_OLPC)		+= olpc/
+obj-$(CONFIG_GOLDFISH)		+= goldfish/
diff --git a/drivers/platform/goldfish/Makefile b/drivers/platform/goldfish/Makefile
new file mode 100644
index 0000000..6c591f6
--- /dev/null
+++ b/drivers/platform/goldfish/Makefile
@@ -0,0 +1,4 @@
+#
+# Makefile for Goldfish platform specific drivers
+#
+obj-$(CONFIG_GOLDFISH)	+=	pdev_bus.o
diff --git a/drivers/platform/goldfish/pdev_bus.c b/drivers/platform/goldfish/pdev_bus.c
new file mode 100644
index 0000000..6d95492
--- /dev/null
+++ b/drivers/platform/goldfish/pdev_bus.c
@@ -0,0 +1,265 @@
+/*
+ * Copyright (C) 2007 Google, Inc.
+ * Copyright (C) 2011 Intel, Inc.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/io.h>
+
+#include <asm/goldfish.h>
+
+#define PDEV_BUS_OP_DONE        (0x00)
+#define PDEV_BUS_OP_REMOVE_DEV  (0x04)
+#define PDEV_BUS_OP_ADD_DEV     (0x08)
+
+#define PDEV_BUS_OP_INIT        (0x00)
+
+#define PDEV_BUS_OP             (0x00)
+#define PDEV_BUS_GET_NAME       (0x04)
+#define PDEV_BUS_NAME_LEN       (0x08)
+#define PDEV_BUS_ID             (0x0c)
+#define PDEV_BUS_IO_BASE        (0x10)
+#define PDEV_BUS_IO_SIZE        (0x14)
+#define PDEV_BUS_IRQ            (0x18)
+#define PDEV_BUS_IRQ_COUNT      (0x1c)
+
+struct pdev_bus_dev {
+	struct list_head list;
+	struct platform_device pdev;
+	struct resource resources[0];
+};
+
+static void goldfish_pdev_worker(struct work_struct *work);
+
+static void __iomem *pdev_bus_base;
+static unsigned long pdev_bus_addr;
+static u32 pdev_bus_irq;
+static LIST_HEAD(pdev_bus_new_devices);
+static LIST_HEAD(pdev_bus_registered_devices);
+static LIST_HEAD(pdev_bus_removed_devices);
+static DECLARE_WORK(pdev_bus_worker, goldfish_pdev_worker);
+
+
+static void goldfish_pdev_worker(struct work_struct *work)
+{
+	int ret;
+	struct pdev_bus_dev *pos, *n;
+
+	list_for_each_entry_safe(pos, n, &pdev_bus_removed_devices, list) {
+		list_del(&pos->list);
+		platform_device_unregister(&pos->pdev);
+		kfree(pos);
+	}
+	list_for_each_entry_safe(pos, n, &pdev_bus_new_devices, list) {
+		list_del(&pos->list);
+		ret = platform_device_register(&pos->pdev);
+		if (ret)
+			pr_err("goldfish_pdev_worker failed to register device, %s\n",
+								pos->pdev.name);
+		list_add_tail(&pos->list, &pdev_bus_registered_devices);
+	}
+}
+
+static void goldfish_pdev_remove(void)
+{
+	struct pdev_bus_dev *pos, *n;
+	u32 base;
+
+	base = readl(pdev_bus_base + PDEV_BUS_IO_BASE);
+
+	list_for_each_entry_safe(pos, n, &pdev_bus_new_devices, list) {
+		if (pos->resources[0].start == base) {
+			list_del(&pos->list);
+			kfree(pos);
+			return;
+		}
+	}
+	list_for_each_entry_safe(pos, n, &pdev_bus_registered_devices, list) {
+		if (pos->resources[0].start == base) {
+			list_del(&pos->list);
+			list_add_tail(&pos->list, &pdev_bus_removed_devices);
+			schedule_work(&pdev_bus_worker);
+			return;
+		}
+	};
+	pr_err("goldfish_pdev_remove could not find device at %x\n", base);
+}
+
+static int goldfish_new_pdev(void)
+{
+	struct pdev_bus_dev *dev;
+	u32 name_len;
+	u32 irq = -1, irq_count;
+	int resource_count = 2;
+	u32 base;
+	char *name;
+
+	base = readl(pdev_bus_base + PDEV_BUS_IO_BASE);
+
+	irq_count = readl(pdev_bus_base + PDEV_BUS_IRQ_COUNT);
+	name_len = readl(pdev_bus_base + PDEV_BUS_NAME_LEN);
+	if (irq_count)
+		resource_count++;
+
+	dev = kzalloc(sizeof(*dev) +
+		sizeof(struct resource) * resource_count +
+		name_len + 1 + sizeof(*dev->pdev.dev.dma_mask), GFP_ATOMIC);
+	if (dev == NULL)
+		return -ENOMEM;
+
+	dev->pdev.num_resources = resource_count;
+	dev->pdev.resource = (struct resource *)(dev + 1);
+	dev->pdev.name = name = (char *)(dev->pdev.resource + resource_count);
+	dev->pdev.dev.coherent_dma_mask = ~0;
+	dev->pdev.dev.dma_mask = (void *)(dev->pdev.name + name_len + 1);
+	*dev->pdev.dev.dma_mask = ~0;
+
+	writel((unsigned long)name, pdev_bus_base + PDEV_BUS_GET_NAME);
+	name[name_len] = '\0';
+	dev->pdev.id = readl(pdev_bus_base + PDEV_BUS_ID);
+	dev->pdev.resource[0].start = base;
+	dev->pdev.resource[0].end = base +
+				readl(pdev_bus_base + PDEV_BUS_IO_SIZE) - 1;
+	dev->pdev.resource[0].flags = IORESOURCE_MEM;
+	if (irq_count) {
+		irq = readl(pdev_bus_base + PDEV_BUS_IRQ);
+		dev->pdev.resource[1].start = irq;
+		dev->pdev.resource[1].end = irq + irq_count - 1;
+		dev->pdev.resource[1].flags = IORESOURCE_IRQ;
+	}
+
+	pr_debug("goldfish_new_pdev %s at %x irq %d\n", name, base, irq);
+	list_add_tail(&dev->list, &pdev_bus_new_devices);
+	schedule_work(&pdev_bus_worker);
+
+	return 0;
+}
+
+static irqreturn_t goldfish_pdev_bus_interrupt(int irq, void *dev_id)
+{
+	irqreturn_t ret = IRQ_NONE;
+	while (1) {
+		u32 op = readl(pdev_bus_base + PDEV_BUS_OP);
+		switch (op) {
+		case PDEV_BUS_OP_DONE:
+			return IRQ_NONE;
+
+		case PDEV_BUS_OP_REMOVE_DEV:
+			goldfish_pdev_remove();
+			break;
+
+		case PDEV_BUS_OP_ADD_DEV:
+			goldfish_new_pdev();
+			break;
+		}
+		ret = IRQ_HANDLED;
+	}
+}
+
+static int __devinit goldfish_pdev_bus_probe(struct platform_device *pdev)
+{
+	int ret;
+	struct resource *r;
+
+	r = platform_get_resource(pdev, IORESOURCE_IO, 0);
+	if (r == NULL)
+		return -EINVAL;
+
+	pdev_bus_addr = GOLDFISH_IO_START + r->start;
+
+	if (request_region(pdev_bus_addr, GOLDFISH_IO_SIZE, "goldfish")) {
+		pr_err("unable to reserve Goldfish MMIO.\n");
+		return -EBUSY;
+	}
+
+	pr_err("Goldfish bus at %lX\n", (long)pdev_bus_addr);
+	pdev_bus_base = ioremap(pdev_bus_addr, GOLDFISH_IO_SIZE);
+	if (pdev_bus_base == NULL) {
+		pr_err("unable to map Goldfish MMIO.\n");
+		return -EIO;
+	}
+
+	r = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (r == NULL)
+		return -EINVAL;
+	pdev_bus_irq = r->start;
+
+	ret = request_irq(pdev_bus_irq, goldfish_pdev_bus_interrupt,
+				IRQF_SHARED, "goldfish_pdev_bus", pdev);
+	if (ret)
+		goto err_request_irq_failed;
+
+	writel(PDEV_BUS_OP_INIT, pdev_bus_base + PDEV_BUS_OP);
+
+err_request_irq_failed:
+	return ret;
+}
+
+static int __devexit goldfish_pdev_bus_remove(struct platform_device *pdev)
+{
+	free_irq(pdev_bus_irq, pdev);
+	release_region(pdev_bus_addr, GOLDFISH_IO_SIZE);
+	return 0;
+}
+
+static struct platform_driver goldfish_pdev_bus_driver = {
+	.probe = goldfish_pdev_bus_probe,
+	.remove = __devexit_p(goldfish_pdev_bus_remove),
+	.driver = {
+		.name = "goldfish_pdev_bus"
+	}
+};
+
+static int __init goldfish_pdev_bus_init(void)
+{
+	return platform_driver_register(&goldfish_pdev_bus_driver);
+}
+
+static void __exit goldfish_pdev_bus_exit(void)
+{
+	platform_driver_unregister(&goldfish_pdev_bus_driver);
+}
+
+module_init(goldfish_pdev_bus_init);
+module_exit(goldfish_pdev_bus_exit);
+
+static struct resource goldfish_pdev_bus_resources[] = {
+	{
+		.start  = GOLDFISH_PDEV_BUS_BASE,
+		.end    = GOLDFISH_PDEV_BUS_BASE + GOLDFISH_PDEV_BUS_END - 1,
+		.flags  = IORESOURCE_IO,
+	},
+	{
+		.start	= GOLDFISH_PDEV_BUS_IRQ,
+		.end	= GOLDFISH_PDEV_BUS_IRQ,
+		.flags	= IORESOURCE_IRQ,
+	}
+};
+
+struct platform_device goldfish_pdev_bus_device = {
+	.name = "goldfish_pdev_bus",
+	.id = -1,
+	.num_resources = ARRAY_SIZE(goldfish_pdev_bus_resources),
+	.resource = goldfish_pdev_bus_resources
+};
+
+static int __init goldfish_init(void)
+{
+	return platform_device_register(&goldfish_pdev_bus_device);
+}
+device_initcall(goldfish_init);

