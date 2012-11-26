Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab2KZNQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 08:16:24 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3976 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632Ab2KZNQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 08:16:20 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 26 Nov 2012 05:16:13 -0800
From: Terje Bergstrom <tbergstrom@nvidia.com>
To: <thierry.reding@avionic-design.de>, <linux-tegra@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>
CC: <linux-kernel@vger.kernel.org>, Terje Bergstrom <tbergstrom@nvidia.com>
Subject: [RFC v2 2/8] video: tegra: Add syncpoint wait and interrupts
Date: Mon, 26 Nov 2012 15:19:08 +0200
Message-ID: <1353935954-13763-3-git-send-email-tbergstrom@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for sync point interrupts, and sync point wait. Sync point
wait uses interrupts for unblocking wait.

Signed-off-by: Terje Bergstrom <tbergstrom@nvidia.com>
---
 drivers/video/tegra/host/Makefile             |    1 +
 drivers/video/tegra/host/chip_support.h       |   17 ++
 drivers/video/tegra/host/dev.c                |    7 +
 drivers/video/tegra/host/host1x/host1x.c      |   33 +++
 drivers/video/tegra/host/host1x/host1x.h      |    2 +
 drivers/video/tegra/host/host1x/host1x01.c    |    2 +
 drivers/video/tegra/host/host1x/host1x_intr.c |  263 ++++++++++++++++++
 drivers/video/tegra/host/nvhost_intr.c        |  363 +++++++++++++++++++++++++
 drivers/video/tegra/host/nvhost_intr.h        |  102 +++++++
 drivers/video/tegra/host/nvhost_syncpt.c      |  111 ++++++++
 drivers/video/tegra/host/nvhost_syncpt.h      |   10 +
 include/linux/nvhost.h                        |    2 +
 12 files changed, 913 insertions(+)
 create mode 100644 drivers/video/tegra/host/host1x/host1x_intr.c
 create mode 100644 drivers/video/tegra/host/nvhost_intr.c
 create mode 100644 drivers/video/tegra/host/nvhost_intr.h

diff --git a/drivers/video/tegra/host/Makefile b/drivers/video/tegra/host/Makefile
index 3edab4a..24acccc 100644
--- a/drivers/video/tegra/host/Makefile
+++ b/drivers/video/tegra/host/Makefile
@@ -3,6 +3,7 @@ ccflags-y = -Idrivers/video/tegra/host
 nvhost-objs = \
 	nvhost_acm.o \
 	nvhost_syncpt.o \
+	nvhost_intr.o \
 	dev.o \
 	chip_support.o
 
diff --git a/drivers/video/tegra/host/chip_support.h b/drivers/video/tegra/host/chip_support.h
index acfa2f1..5c8f49f 100644
--- a/drivers/video/tegra/host/chip_support.h
+++ b/drivers/video/tegra/host/chip_support.h
@@ -25,6 +25,7 @@
 struct output;
 
 struct nvhost_master;
+struct nvhost_intr;
 struct nvhost_syncpt;
 struct platform_device;
 
@@ -38,14 +39,30 @@ struct nvhost_syncpt_ops {
 	const char * (*name)(struct nvhost_syncpt *, u32 id);
 };
 
+struct nvhost_intr_ops {
+	void (*init_host_sync)(struct nvhost_intr *);
+	void (*set_host_clocks_per_usec)(
+		struct nvhost_intr *, u32 clocks);
+	void (*set_syncpt_threshold)(
+		struct nvhost_intr *, u32 id, u32 thresh);
+	void (*enable_syncpt_intr)(struct nvhost_intr *, u32 id);
+	void (*disable_syncpt_intr)(struct nvhost_intr *, u32 id);
+	void (*disable_all_syncpt_intrs)(struct nvhost_intr *);
+	int  (*request_host_general_irq)(struct nvhost_intr *);
+	void (*free_host_general_irq)(struct nvhost_intr *);
+	int (*free_syncpt_irq)(struct nvhost_intr *);
+};
+
 struct nvhost_chip_support {
 	const char *soc_name;
 	struct nvhost_syncpt_ops syncpt;
+	struct nvhost_intr_ops intr;
 };
 
 struct nvhost_chip_support *nvhost_get_chip_ops(void);
 
 #define syncpt_op()		(nvhost_get_chip_ops()->syncpt)
+#define intr_op()		(nvhost_get_chip_ops()->intr)
 
 int nvhost_init_chip_support(struct nvhost_master *host);
 
diff --git a/drivers/video/tegra/host/dev.c b/drivers/video/tegra/host/dev.c
index 98c9c9f..025a820 100644
--- a/drivers/video/tegra/host/dev.c
+++ b/drivers/video/tegra/host/dev.c
@@ -43,6 +43,13 @@ u32 host1x_syncpt_read(u32 id)
 }
 EXPORT_SYMBOL(host1x_syncpt_read);
 
+int host1x_syncpt_wait(u32 id, u32 thresh, u32 timeout, u32 *value)
+{
+	struct nvhost_syncpt *sp = &nvhost->syncpt;
+	return nvhost_syncpt_wait_timeout(sp, id, thresh, timeout, value);
+}
+EXPORT_SYMBOL(host1x_syncpt_wait);
+
 bool host1x_powered(struct platform_device *dev)
 {
 	bool ret = 0;
diff --git a/drivers/video/tegra/host/host1x/host1x.c b/drivers/video/tegra/host/host1x/host1x.c
index 77ff00b..766931b 100644
--- a/drivers/video/tegra/host/host1x/host1x.c
+++ b/drivers/video/tegra/host/host1x/host1x.c
@@ -52,8 +52,24 @@ static int power_off_host(struct platform_device *dev)
 	return 0;
 }
 
+static void clock_on_host(struct platform_device *dev)
+{
+	struct nvhost_device_data *pdata = platform_get_drvdata(dev);
+	struct nvhost_master *host = nvhost_get_private_data(dev);
+	nvhost_intr_start(&host->intr, clk_get_rate(pdata->clk[0]));
+}
+
+static int clock_off_host(struct platform_device *dev)
+{
+	struct nvhost_master *host = nvhost_get_private_data(dev);
+	nvhost_intr_stop(&host->intr);
+	return 0;
+}
+
 static void nvhost_free_resources(struct nvhost_master *host)
 {
+	kfree(host->intr.syncpt);
+	host->intr.syncpt = 0;
 }
 
 static int __devinit nvhost_alloc_resources(struct nvhost_master *host)
@@ -64,6 +80,16 @@ static int __devinit nvhost_alloc_resources(struct nvhost_master *host)
 	if (err)
 		return err;
 
+	host->intr.syncpt = devm_kzalloc(&host->dev->dev,
+			sizeof(struct nvhost_intr_syncpt) *
+			nvhost_syncpt_nb_pts(&host->syncpt),
+			GFP_KERNEL);
+
+	if (!host->intr.syncpt) {
+		/* frees happen in the support removal phase */
+		return -ENOMEM;
+	}
+
 	return 0;
 }
 
@@ -99,6 +125,8 @@ static int __devinit nvhost_probe(struct platform_device *dev)
 
 	pdata->finalize_poweron = power_on_host;
 	pdata->prepare_poweroff = power_off_host;
+	pdata->prepare_clockoff = clock_off_host;
+	pdata->finalize_clockon = clock_on_host;
 
 	pdata->pdev = dev;
 
@@ -125,6 +153,10 @@ static int __devinit nvhost_probe(struct platform_device *dev)
 	if (err)
 		goto fail;
 
+	err = nvhost_intr_init(&host->intr, intr1->start, intr0->start);
+	if (err)
+		goto fail;
+
 	err = nvhost_module_init(dev);
 	if (err)
 		goto fail;
@@ -148,6 +180,7 @@ fail:
 static int __exit nvhost_remove(struct platform_device *dev)
 {
 	struct nvhost_master *host = nvhost_get_private_data(dev);
+	nvhost_intr_deinit(&host->intr);
 	nvhost_syncpt_deinit(&host->syncpt);
 	nvhost_module_deinit(dev);
 	nvhost_free_resources(host);
diff --git a/drivers/video/tegra/host/host1x/host1x.h b/drivers/video/tegra/host/host1x/host1x.h
index 76748ac..af9bfef 100644
--- a/drivers/video/tegra/host/host1x/host1x.h
+++ b/drivers/video/tegra/host/host1x/host1x.h
@@ -25,6 +25,7 @@
 #include <linux/nvhost.h>
 
 #include "nvhost_syncpt.h"
+#include "nvhost_intr.h"
 
 #define TRACE_MAX_LENGTH	128U
 #define IFACE_NAME		"nvhost"
@@ -33,6 +34,7 @@ struct nvhost_master {
 	void __iomem *aperture;
 	void __iomem *sync_aperture;
 	struct nvhost_syncpt syncpt;
+	struct nvhost_intr intr;
 	struct platform_device *dev;
 	struct host1x_device_info info;
 };
diff --git a/drivers/video/tegra/host/host1x/host1x01.c b/drivers/video/tegra/host/host1x/host1x01.c
index d53302d..5bf0e6e 100644
--- a/drivers/video/tegra/host/host1x/host1x01.c
+++ b/drivers/video/tegra/host/host1x/host1x01.c
@@ -26,12 +26,14 @@
 #include "chip_support.h"
 
 #include "host1x/host1x_syncpt.c"
+#include "host1x/host1x_intr.c"
 
 int nvhost_init_host1x01_support(struct nvhost_master *host,
 	struct nvhost_chip_support *op)
 {
 	host->sync_aperture = host->aperture + HOST1X_CHANNEL_SYNC_REG_BASE;
 	op->syncpt = host1x_syncpt_ops;
+	op->intr = host1x_intr_ops;
 
 	return 0;
 }
diff --git a/drivers/video/tegra/host/host1x/host1x_intr.c b/drivers/video/tegra/host/host1x/host1x_intr.c
new file mode 100644
index 0000000..94f08cb
--- /dev/null
+++ b/drivers/video/tegra/host/host1x/host1x_intr.c
@@ -0,0 +1,263 @@
+/*
+ * drivers/video/tegra/host/host1x/host1x_intr.c
+ *
+ * Tegra host1x Interrupt Management
+ *
+ * Copyright (C) 2010 Google, Inc.
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
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/io.h>
+#include <asm/mach/irq.h>
+
+#include "nvhost_intr.h"
+#include "host1x/host1x.h"
+
+/* Spacing between sync registers */
+#define REGISTER_STRIDE 4
+
+static void host1x_intr_syncpt_thresh_isr(struct nvhost_intr_syncpt *syncpt);
+
+static void syncpt_thresh_cascade_fn(struct work_struct *work)
+{
+	struct nvhost_intr_syncpt *sp =
+		container_of(work, struct nvhost_intr_syncpt, work);
+	nvhost_syncpt_thresh_fn(sp->irq, sp);
+}
+
+static irqreturn_t syncpt_thresh_cascade_isr(int irq, void *dev_id)
+{
+	struct nvhost_master *dev = dev_id;
+	void __iomem *sync_regs = dev->sync_aperture;
+	struct nvhost_intr *intr = &dev->intr;
+	unsigned long reg;
+	int i, id;
+
+	for (i = 0; i < dev->info.nb_pts / BITS_PER_LONG; i++) {
+		reg = readl(sync_regs +
+				host1x_sync_syncpt_thresh_cpu0_int_status_r() +
+				i * REGISTER_STRIDE);
+		for_each_set_bit(id, &reg, BITS_PER_LONG) {
+			struct nvhost_intr_syncpt *sp =
+				intr->syncpt + (i * BITS_PER_LONG + id);
+			host1x_intr_syncpt_thresh_isr(sp);
+			queue_work(intr->wq, &sp->work);
+		}
+	}
+
+	return IRQ_HANDLED;
+}
+
+static void host1x_intr_init_host_sync(struct nvhost_intr *intr)
+{
+	struct nvhost_master *dev = intr_to_dev(intr);
+	void __iomem *sync_regs = dev->sync_aperture;
+	int i, err, irq;
+
+	writel(0xffffffffUL,
+		sync_regs + host1x_sync_syncpt_thresh_int_disable_r());
+	writel(0xffffffffUL,
+		sync_regs + host1x_sync_syncpt_thresh_cpu0_int_status_r());
+
+	for (i = 0; i < dev->info.nb_pts; i++)
+		INIT_WORK(&intr->syncpt[i].work, syncpt_thresh_cascade_fn);
+
+	irq = platform_get_irq(dev->dev, 0);
+	WARN_ON(IS_ERR_VALUE(irq));
+	err = devm_request_irq(&dev->dev->dev, irq,
+				syncpt_thresh_cascade_isr,
+				IRQF_SHARED, "host_syncpt", dev);
+	WARN_ON(IS_ERR_VALUE(err));
+
+	/* disable the ip_busy_timeout. this prevents write drops, etc.
+	 * there's no real way to recover from a hung client anyway.
+	 */
+	writel(0, sync_regs + host1x_sync_ip_busy_timeout_r());
+
+	/* increase the auto-ack timout to the maximum value. 2d will hang
+	 * otherwise on Tegra2.
+	 */
+	writel(0xff, sync_regs + host1x_sync_ctxsw_timeout_cfg_r());
+}
+
+static void host1x_intr_set_host_clocks_per_usec(struct nvhost_intr *intr,
+		u32 cpm)
+{
+	struct nvhost_master *dev = intr_to_dev(intr);
+	void __iomem *sync_regs = dev->sync_aperture;
+	/* write microsecond clock register */
+	writel(cpm, sync_regs + host1x_sync_usec_clk_r());
+}
+
+static void host1x_intr_set_syncpt_threshold(struct nvhost_intr *intr,
+	u32 id, u32 thresh)
+{
+	struct nvhost_master *dev = intr_to_dev(intr);
+	void __iomem *sync_regs = dev->sync_aperture;
+	writel(thresh, sync_regs +
+		(host1x_sync_syncpt_int_thresh_0_r() + id * REGISTER_STRIDE));
+}
+
+static void host1x_intr_enable_syncpt_intr(struct nvhost_intr *intr, u32 id)
+{
+	struct nvhost_master *dev = intr_to_dev(intr);
+	void __iomem *sync_regs = dev->sync_aperture;
+
+	writel(BIT_MASK(id), sync_regs +
+			host1x_sync_syncpt_thresh_int_enable_cpu0_r() +
+			BIT_WORD(id) * REGISTER_STRIDE);
+}
+
+static void host1x_intr_disable_syncpt_intr(struct nvhost_intr *intr, u32 id)
+{
+	struct nvhost_master *dev = intr_to_dev(intr);
+	void __iomem *sync_regs = dev->sync_aperture;
+
+	writel(BIT_MASK(id), sync_regs +
+			host1x_sync_syncpt_thresh_int_disable_r() +
+			BIT_WORD(id) * REGISTER_STRIDE);
+
+	writel(BIT_MASK(id), sync_regs +
+		host1x_sync_syncpt_thresh_cpu0_int_status_r() +
+		BIT_WORD(id) * REGISTER_STRIDE);
+}
+
+static void host1x_intr_disable_all_syncpt_intrs(struct nvhost_intr *intr)
+{
+	struct nvhost_master *dev = intr_to_dev(intr);
+	void __iomem *sync_regs = dev->sync_aperture;
+	u32 reg;
+
+	for (reg = 0; reg <= BIT_WORD(dev->info.nb_pts) * REGISTER_STRIDE;
+			reg += REGISTER_STRIDE) {
+		writel(0xffffffffu, sync_regs +
+				host1x_sync_syncpt_thresh_int_disable_r() +
+				reg);
+
+		writel(0xffffffffu, sync_regs +
+			host1x_sync_syncpt_thresh_cpu0_int_status_r() + reg);
+	}
+}
+
+/**
+ * Sync point threshold interrupt service function
+ * Handles sync point threshold triggers, in interrupt context
+ */
+static void host1x_intr_syncpt_thresh_isr(struct nvhost_intr_syncpt *syncpt)
+{
+	unsigned int id = syncpt->id;
+	struct nvhost_intr *intr = intr_syncpt_to_intr(syncpt);
+
+	void __iomem *sync_regs = intr_to_dev(intr)->sync_aperture;
+
+	u32 reg = BIT_WORD(id) * REGISTER_STRIDE;
+
+	writel(BIT_MASK(id), sync_regs +
+		host1x_sync_syncpt_thresh_int_disable_r() + reg);
+	writel(BIT_MASK(id), sync_regs +
+		host1x_sync_syncpt_thresh_cpu0_int_status_r() + reg);
+}
+
+/**
+ * Host general interrupt service function
+ * Handles read / write failures
+ */
+static irqreturn_t host1x_intr_host1x_isr(int irq, void *dev_id)
+{
+	struct nvhost_intr *intr = dev_id;
+	void __iomem *sync_regs = intr_to_dev(intr)->sync_aperture;
+	u32 stat;
+	u32 ext_stat;
+	u32 addr;
+
+	stat = readl(sync_regs + host1x_sync_hintstatus_r());
+	ext_stat = readl(sync_regs + host1x_sync_hintstatus_ext_r());
+
+	if (host1x_sync_hintstatus_ext_ip_read_int_v(ext_stat)) {
+		addr = readl(sync_regs + host1x_sync_ip_read_timeout_addr_r());
+		pr_err("Host read timeout at address %x\n", addr);
+	}
+
+	if (host1x_sync_hintstatus_ext_ip_write_int_v(ext_stat)) {
+		addr = readl(sync_regs + host1x_sync_ip_write_timeout_addr_r());
+		pr_err("Host write timeout at address %x\n", addr);
+	}
+
+	writel(ext_stat, sync_regs + host1x_sync_hintstatus_ext_r());
+	writel(stat, sync_regs + host1x_sync_hintstatus_r());
+
+	return IRQ_HANDLED;
+}
+static int host1x_intr_request_host_general_irq(struct nvhost_intr *intr)
+{
+	void __iomem *sync_regs = intr_to_dev(intr)->sync_aperture;
+	int err;
+
+	/* master disable for general (not syncpt) host interrupts */
+	writel(0, sync_regs + host1x_sync_intmask_r());
+
+	/* clear status & extstatus */
+	writel(0xfffffffful, sync_regs + host1x_sync_hintstatus_ext_r());
+	writel(0xfffffffful, sync_regs + host1x_sync_hintstatus_r());
+
+	err = request_irq(intr->host_general_irq, host1x_intr_host1x_isr, 0,
+			"host_status", intr);
+	if (err)
+		return err;
+
+	/* enable extra interrupt sources IP_READ_INT and IP_WRITE_INT */
+	writel(BIT(30) | BIT(31), sync_regs + host1x_sync_hintmask_ext_r());
+
+	/* enable extra interrupt sources */
+	writel(BIT(12) | BIT(31), sync_regs + host1x_sync_hintmask_r());
+
+	/* enable host module interrupt to CPU0 */
+	writel(BIT(0), sync_regs + host1x_sync_intc0mask_r());
+
+	/* master enable for general (not syncpt) host interrupts */
+	writel(BIT(0), sync_regs + host1x_sync_intmask_r());
+
+	return err;
+}
+
+static void host1x_intr_free_host_general_irq(struct nvhost_intr *intr)
+{
+	void __iomem *sync_regs = intr_to_dev(intr)->sync_aperture;
+
+	/* master disable for general (not syncpt) host interrupts */
+	writel(0, sync_regs + host1x_sync_intmask_r());
+
+	free_irq(intr->host_general_irq, intr);
+}
+
+static int host1x_free_syncpt_irq(struct nvhost_intr *intr)
+{
+	flush_workqueue(intr->wq);
+	return 0;
+}
+
+static const struct nvhost_intr_ops host1x_intr_ops = {
+	.init_host_sync = host1x_intr_init_host_sync,
+	.set_host_clocks_per_usec = host1x_intr_set_host_clocks_per_usec,
+	.set_syncpt_threshold = host1x_intr_set_syncpt_threshold,
+	.enable_syncpt_intr = host1x_intr_enable_syncpt_intr,
+	.disable_syncpt_intr = host1x_intr_disable_syncpt_intr,
+	.disable_all_syncpt_intrs = host1x_intr_disable_all_syncpt_intrs,
+	.request_host_general_irq = host1x_intr_request_host_general_irq,
+	.free_host_general_irq = host1x_intr_free_host_general_irq,
+	.free_syncpt_irq = host1x_free_syncpt_irq,
+};
diff --git a/drivers/video/tegra/host/nvhost_intr.c b/drivers/video/tegra/host/nvhost_intr.c
new file mode 100644
index 0000000..35dd7bb
--- /dev/null
+++ b/drivers/video/tegra/host/nvhost_intr.c
@@ -0,0 +1,363 @@
+/*
+ * drivers/video/tegra/host/nvhost_intr.c
+ *
+ * Tegra host1x Interrupt Management
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
+#include "nvhost_intr.h"
+#include "nvhost_acm.h"
+#include <linux/interrupt.h>
+#include <linux/slab.h>
+#include <linux/irq.h>
+#include "chip_support.h"
+#include "host1x/host1x.h"
+
+/*** Wait list management ***/
+
+struct nvhost_waitlist {
+	struct list_head list;
+	struct kref refcount;
+	u32 thresh;
+	enum nvhost_intr_action action;
+	atomic_t state;
+	void *data;
+	int count;
+};
+
+enum waitlist_state {
+	WLS_PENDING,
+	WLS_REMOVED,
+	WLS_CANCELLED,
+	WLS_HANDLED
+};
+
+static void waiter_release(struct kref *kref)
+{
+	kfree(container_of(kref, struct nvhost_waitlist, refcount));
+}
+
+/**
+ * add a waiter to a waiter queue, sorted by threshold
+ * returns true if it was added at the head of the queue
+ */
+static bool add_waiter_to_queue(struct nvhost_waitlist *waiter,
+				struct list_head *queue)
+{
+	struct nvhost_waitlist *pos;
+	u32 thresh = waiter->thresh;
+
+	list_for_each_entry_reverse(pos, queue, list)
+		if ((s32)(pos->thresh - thresh) <= 0) {
+			list_add(&waiter->list, &pos->list);
+			return false;
+		}
+
+	list_add(&waiter->list, queue);
+	return true;
+}
+
+/**
+ * run through a waiter queue for a single sync point ID
+ * and gather all completed waiters into lists by actions
+ */
+static void remove_completed_waiters(struct list_head *head, u32 sync,
+			struct list_head completed[NVHOST_INTR_ACTION_COUNT])
+{
+	struct list_head *dest;
+	struct nvhost_waitlist *waiter, *next;
+
+	list_for_each_entry_safe(waiter, next, head, list) {
+		if ((s32)(waiter->thresh - sync) > 0)
+			break;
+
+		dest = completed + waiter->action;
+
+		/* PENDING->REMOVED or CANCELLED->HANDLED */
+		if (atomic_inc_return(&waiter->state) == WLS_HANDLED || !dest) {
+			list_del(&waiter->list);
+			kref_put(&waiter->refcount, waiter_release);
+		} else {
+			list_move_tail(&waiter->list, dest);
+		}
+	}
+}
+
+void reset_threshold_interrupt(struct nvhost_intr *intr,
+			       struct list_head *head,
+			       unsigned int id)
+{
+	u32 thresh = list_first_entry(head,
+				struct nvhost_waitlist, list)->thresh;
+
+	intr_op().set_syncpt_threshold(intr, id, thresh);
+	intr_op().enable_syncpt_intr(intr, id);
+}
+
+
+static void action_wakeup(struct nvhost_waitlist *waiter)
+{
+	wait_queue_head_t *wq = waiter->data;
+
+	wake_up(wq);
+}
+
+static void action_wakeup_interruptible(struct nvhost_waitlist *waiter)
+{
+	wait_queue_head_t *wq = waiter->data;
+
+	wake_up_interruptible(wq);
+}
+
+typedef void (*action_handler)(struct nvhost_waitlist *waiter);
+
+static action_handler action_handlers[NVHOST_INTR_ACTION_COUNT] = {
+	action_wakeup,
+	action_wakeup_interruptible,
+};
+
+static void run_handlers(struct list_head completed[NVHOST_INTR_ACTION_COUNT])
+{
+	struct list_head *head = completed;
+	int i;
+
+	for (i = 0; i < NVHOST_INTR_ACTION_COUNT; ++i, ++head) {
+		action_handler handler = action_handlers[i];
+		struct nvhost_waitlist *waiter, *next;
+
+		list_for_each_entry_safe(waiter, next, head, list) {
+			list_del(&waiter->list);
+			handler(waiter);
+			WARN_ON(atomic_xchg(&waiter->state, WLS_HANDLED)
+					!= WLS_REMOVED);
+			kref_put(&waiter->refcount, waiter_release);
+		}
+	}
+}
+
+/**
+ * Remove & handle all waiters that have completed for the given syncpt
+ */
+static int process_wait_list(struct nvhost_intr *intr,
+			     struct nvhost_intr_syncpt *syncpt,
+			     u32 threshold)
+{
+	struct list_head completed[NVHOST_INTR_ACTION_COUNT];
+	unsigned int i;
+	int empty;
+
+	for (i = 0; i < NVHOST_INTR_ACTION_COUNT; ++i)
+		INIT_LIST_HEAD(completed + i);
+
+	spin_lock(&syncpt->lock);
+
+	remove_completed_waiters(&syncpt->wait_head, threshold, completed);
+
+	empty = list_empty(&syncpt->wait_head);
+	if (empty)
+		intr_op().disable_syncpt_intr(intr, syncpt->id);
+	else
+		reset_threshold_interrupt(intr, &syncpt->wait_head,
+					  syncpt->id);
+
+	spin_unlock(&syncpt->lock);
+
+	run_handlers(completed);
+
+	return empty;
+}
+
+/*** host syncpt interrupt service functions ***/
+/**
+ * Sync point threshold interrupt service thread function
+ * Handles sync point threshold triggers, in thread context
+ */
+irqreturn_t nvhost_syncpt_thresh_fn(int irq, void *dev_id)
+{
+	struct nvhost_intr_syncpt *syncpt = dev_id;
+	unsigned int id = syncpt->id;
+	struct nvhost_intr *intr = intr_syncpt_to_intr(syncpt);
+	struct nvhost_master *dev = intr_to_dev(intr);
+
+	(void)process_wait_list(intr, syncpt,
+				nvhost_syncpt_update_min(&dev->syncpt, id));
+
+	return IRQ_HANDLED;
+}
+
+/*** host general interrupt service functions ***/
+
+
+/*** Main API ***/
+
+int nvhost_intr_add_action(struct nvhost_intr *intr, u32 id, u32 thresh,
+			enum nvhost_intr_action action, void *data,
+			void *_waiter,
+			void **ref)
+{
+	struct nvhost_waitlist *waiter = _waiter;
+	struct nvhost_intr_syncpt *syncpt;
+	int queue_was_empty;
+
+	if (waiter == NULL) {
+		pr_warn("%s: NULL waiter\n", __func__);
+		return -EINVAL;
+	}
+
+	/* initialize a new waiter */
+	INIT_LIST_HEAD(&waiter->list);
+	kref_init(&waiter->refcount);
+	if (ref)
+		kref_get(&waiter->refcount);
+	waiter->thresh = thresh;
+	waiter->action = action;
+	atomic_set(&waiter->state, WLS_PENDING);
+	waiter->data = data;
+	waiter->count = 1;
+
+	syncpt = intr->syncpt + id;
+
+	spin_lock(&syncpt->lock);
+
+	queue_was_empty = list_empty(&syncpt->wait_head);
+
+	if (add_waiter_to_queue(waiter, &syncpt->wait_head)) {
+		/* added at head of list - new threshold value */
+		intr_op().set_syncpt_threshold(intr, id, thresh);
+
+		/* added as first waiter - enable interrupt */
+		if (queue_was_empty)
+			intr_op().enable_syncpt_intr(intr, id);
+	}
+
+	spin_unlock(&syncpt->lock);
+
+	if (ref)
+		*ref = waiter;
+	return 0;
+}
+
+void *nvhost_intr_alloc_waiter()
+{
+	return kzalloc(sizeof(struct nvhost_waitlist),
+			GFP_KERNEL|__GFP_REPEAT);
+}
+
+void nvhost_intr_put_ref(struct nvhost_intr *intr, u32 id, void *ref)
+{
+	struct nvhost_waitlist *waiter = ref;
+	struct nvhost_intr_syncpt *syncpt;
+	struct nvhost_master *host = intr_to_dev(intr);
+
+	while (atomic_cmpxchg(&waiter->state,
+				WLS_PENDING, WLS_CANCELLED) == WLS_REMOVED)
+		schedule();
+
+	syncpt = intr->syncpt + id;
+	(void)process_wait_list(intr, syncpt,
+				nvhost_syncpt_update_min(&host->syncpt, id));
+
+	kref_put(&waiter->refcount, waiter_release);
+}
+
+
+/*** Init & shutdown ***/
+
+int nvhost_intr_init(struct nvhost_intr *intr, u32 irq_gen, u32 irq_sync)
+{
+	unsigned int id;
+	struct nvhost_intr_syncpt *syncpt;
+	struct nvhost_master *host = intr_to_dev(intr);
+	u32 nb_pts = nvhost_syncpt_nb_pts(&host->syncpt);
+
+	mutex_init(&intr->mutex);
+	intr->host_syncpt_irq_base = irq_sync;
+	intr->wq = create_workqueue("host_syncpt");
+	intr_op().init_host_sync(intr);
+	intr->host_general_irq = irq_gen;
+	intr_op().request_host_general_irq(intr);
+
+	for (id = 0, syncpt = intr->syncpt;
+	     id < nb_pts;
+	     ++id, ++syncpt) {
+		syncpt->intr = &host->intr;
+		syncpt->id = id;
+		syncpt->irq = irq_sync + id;
+		spin_lock_init(&syncpt->lock);
+		INIT_LIST_HEAD(&syncpt->wait_head);
+		snprintf(syncpt->thresh_irq_name,
+			sizeof(syncpt->thresh_irq_name),
+			"host_sp_%02d", id);
+	}
+
+	return 0;
+}
+
+void nvhost_intr_deinit(struct nvhost_intr *intr)
+{
+	nvhost_intr_stop(intr);
+	destroy_workqueue(intr->wq);
+}
+
+void nvhost_intr_start(struct nvhost_intr *intr, u32 hz)
+{
+	mutex_lock(&intr->mutex);
+
+	intr_op().init_host_sync(intr);
+	intr_op().set_host_clocks_per_usec(intr,
+					       (hz + 1000000 - 1)/1000000);
+
+	intr_op().request_host_general_irq(intr);
+
+	mutex_unlock(&intr->mutex);
+}
+
+void nvhost_intr_stop(struct nvhost_intr *intr)
+{
+	unsigned int id;
+	struct nvhost_intr_syncpt *syncpt;
+	u32 nb_pts = nvhost_syncpt_nb_pts(&intr_to_dev(intr)->syncpt);
+
+	mutex_lock(&intr->mutex);
+
+	intr_op().disable_all_syncpt_intrs(intr);
+
+	for (id = 0, syncpt = intr->syncpt;
+	     id < nb_pts;
+	     ++id, ++syncpt) {
+		struct nvhost_waitlist *waiter, *next;
+		list_for_each_entry_safe(waiter, next,
+				&syncpt->wait_head, list) {
+			if (atomic_cmpxchg(&waiter->state,
+						WLS_CANCELLED, WLS_HANDLED)
+				== WLS_CANCELLED) {
+				list_del(&waiter->list);
+				kref_put(&waiter->refcount, waiter_release);
+			}
+		}
+
+		if (!list_empty(&syncpt->wait_head)) {  /* output diagnostics */
+			pr_warn("%s cannot stop syncpt intr id=%d\n",
+					__func__, id);
+			return;
+		}
+	}
+
+	intr_op().free_host_general_irq(intr);
+	intr_op().free_syncpt_irq(intr);
+
+	mutex_unlock(&intr->mutex);
+}
diff --git a/drivers/video/tegra/host/nvhost_intr.h b/drivers/video/tegra/host/nvhost_intr.h
new file mode 100644
index 0000000..31b0a38
--- /dev/null
+++ b/drivers/video/tegra/host/nvhost_intr.h
@@ -0,0 +1,102 @@
+/*
+ * drivers/video/tegra/host/nvhost_intr.h
+ *
+ * Tegra host1x Interrupt Management
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
+#ifndef __NVHOST_INTR_H
+#define __NVHOST_INTR_H
+
+#include <linux/kthread.h>
+#include <linux/semaphore.h>
+#include <linux/interrupt.h>
+#include <linux/workqueue.h>
+
+enum nvhost_intr_action {
+	/**
+	 * Wake up a  task.
+	 * 'data' points to a wait_queue_head_t
+	 */
+	NVHOST_INTR_ACTION_WAKEUP,
+
+	/**
+	 * Wake up a interruptible task.
+	 * 'data' points to a wait_queue_head_t
+	 */
+	NVHOST_INTR_ACTION_WAKEUP_INTERRUPTIBLE,
+
+	NVHOST_INTR_ACTION_COUNT
+};
+
+struct nvhost_intr;
+
+struct nvhost_intr_syncpt {
+	struct nvhost_intr *intr;
+	u8 id;
+	u16 irq;
+	spinlock_t lock;
+	struct list_head wait_head;
+	char thresh_irq_name[12];
+	struct work_struct work;
+};
+
+struct nvhost_intr {
+	struct nvhost_intr_syncpt *syncpt;
+	struct mutex mutex;
+	int host_general_irq;
+	int host_syncpt_irq_base;
+	struct workqueue_struct *wq;
+};
+#define intr_to_dev(x) container_of(x, struct nvhost_master, intr)
+#define intr_syncpt_to_intr(is) (is->intr)
+
+/**
+ * Schedule an action to be taken when a sync point reaches the given threshold.
+ *
+ * @id the sync point
+ * @thresh the threshold
+ * @action the action to take
+ * @data a pointer to extra data depending on action, see above
+ * @waiter waiter allocated with nvhost_intr_alloc_waiter - assumes ownership
+ * @ref must be passed if cancellation is possible, else NULL
+ *
+ * This is a non-blocking api.
+ */
+int nvhost_intr_add_action(struct nvhost_intr *intr, u32 id, u32 thresh,
+			enum nvhost_intr_action action, void *data,
+			void *waiter,
+			void **ref);
+
+/**
+ * Allocate a waiter.
+ */
+void *nvhost_intr_alloc_waiter(void);
+
+/**
+ * Unreference an action submitted to nvhost_intr_add_action().
+ * You must call this if you passed non-NULL as ref.
+ * @ref the ref returned from nvhost_intr_add_action()
+ */
+void nvhost_intr_put_ref(struct nvhost_intr *intr, u32 id, void *ref);
+
+int nvhost_intr_init(struct nvhost_intr *intr, u32 irq_gen, u32 irq_sync);
+void nvhost_intr_deinit(struct nvhost_intr *intr);
+void nvhost_intr_start(struct nvhost_intr *intr, u32 hz);
+void nvhost_intr_stop(struct nvhost_intr *intr);
+
+irqreturn_t nvhost_syncpt_thresh_fn(int irq, void *dev_id);
+#endif
diff --git a/drivers/video/tegra/host/nvhost_syncpt.c b/drivers/video/tegra/host/nvhost_syncpt.c
index d7c8230..6ef0ba4 100644
--- a/drivers/video/tegra/host/nvhost_syncpt.c
+++ b/drivers/video/tegra/host/nvhost_syncpt.c
@@ -123,6 +123,117 @@ void nvhost_syncpt_incr(struct nvhost_syncpt *sp, u32 id)
 }
 
 /**
+ * Updated sync point form hardware, and returns true if syncpoint is expired,
+ * false if we may need to wait
+ */
+static bool syncpt_update_min_is_expired(
+	struct nvhost_syncpt *sp,
+	u32 id,
+	u32 thresh)
+{
+	syncpt_op().update_min(sp, id);
+	return nvhost_syncpt_is_expired(sp, id, thresh);
+}
+
+/**
+ * Main entrypoint for syncpoint value waits.
+ */
+int nvhost_syncpt_wait_timeout(struct nvhost_syncpt *sp, u32 id,
+			u32 thresh, u32 timeout, u32 *value)
+{
+	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(wq);
+	void *ref;
+	void *waiter;
+	int err = 0, check_count = 0, low_timeout = 0;
+	u32 val;
+
+	if (value)
+		*value = 0;
+
+	/* first check cache */
+	if (nvhost_syncpt_is_expired(sp, id, thresh)) {
+		if (value)
+			*value = nvhost_syncpt_read_min(sp, id);
+		return 0;
+	}
+
+	/* keep host alive */
+	nvhost_module_busy(syncpt_to_dev(sp)->dev);
+
+	/* try to read from register */
+	val = syncpt_op().update_min(sp, id);
+	if (nvhost_syncpt_is_expired(sp, id, thresh)) {
+		if (value)
+			*value = val;
+		goto done;
+	}
+
+	if (!timeout) {
+		err = -EAGAIN;
+		goto done;
+	}
+
+	/* schedule a wakeup when the syncpoint value is reached */
+	waiter = nvhost_intr_alloc_waiter();
+	if (!waiter) {
+		err = -ENOMEM;
+		goto done;
+	}
+
+	err = nvhost_intr_add_action(&(syncpt_to_dev(sp)->intr), id, thresh,
+				NVHOST_INTR_ACTION_WAKEUP_INTERRUPTIBLE, &wq,
+				waiter,
+				&ref);
+	if (err)
+		goto done;
+
+	err = -EAGAIN;
+	/* Caller-specified timeout may be impractically low */
+	if (timeout < SYNCPT_CHECK_PERIOD)
+		low_timeout = timeout;
+
+	/* wait for the syncpoint, or timeout, or signal */
+	while (timeout) {
+		u32 check = min_t(u32, SYNCPT_CHECK_PERIOD, timeout);
+		int remain = wait_event_interruptible_timeout(wq,
+				syncpt_update_min_is_expired(sp, id, thresh),
+				check);
+		if (remain > 0 || nvhost_syncpt_is_expired(sp, id, thresh)) {
+			if (value)
+				*value = nvhost_syncpt_read_min(sp, id);
+			err = 0;
+			break;
+		}
+		if (remain < 0) {
+			err = remain;
+			break;
+		}
+		if (timeout != NVHOST_NO_TIMEOUT)
+			timeout -= check;
+		if (timeout && check_count <= MAX_STUCK_CHECK_COUNT) {
+			dev_warn(&syncpt_to_dev(sp)->dev->dev,
+				"%s: syncpoint id %d (%s) stuck waiting %d, timeout=%d\n",
+				 current->comm, id, syncpt_op().name(sp, id),
+				 thresh, timeout);
+			syncpt_op().debug(sp);
+			if (check_count == MAX_STUCK_CHECK_COUNT) {
+				if (low_timeout) {
+					dev_warn(&syncpt_to_dev(sp)->dev->dev,
+						"is timeout %d too low?\n",
+						low_timeout);
+				}
+			}
+			check_count++;
+		}
+	}
+	nvhost_intr_put_ref(&(syncpt_to_dev(sp)->intr), id, ref);
+
+done:
+	nvhost_module_idle(syncpt_to_dev(sp)->dev);
+	return err;
+}
+
+/**
  * Returns true if syncpoint is expired, false if we may need to wait
  */
 bool nvhost_syncpt_is_expired(
diff --git a/drivers/video/tegra/host/nvhost_syncpt.h b/drivers/video/tegra/host/nvhost_syncpt.h
index b883442..dbd3890 100644
--- a/drivers/video/tegra/host/nvhost_syncpt.h
+++ b/drivers/video/tegra/host/nvhost_syncpt.h
@@ -126,6 +126,16 @@ u32 nvhost_syncpt_read_wait_base(struct nvhost_syncpt *sp, u32 id);
 
 void nvhost_syncpt_incr(struct nvhost_syncpt *sp, u32 id);
 
+int nvhost_syncpt_wait_timeout(struct nvhost_syncpt *sp, u32 id, u32 thresh,
+			u32 timeout, u32 *value);
+
+static inline int nvhost_syncpt_wait(struct nvhost_syncpt *sp,
+		u32 id, u32 thresh)
+{
+	return nvhost_syncpt_wait_timeout(sp, id, thresh,
+					  MAX_SCHEDULE_TIMEOUT, NULL);
+}
+
 void nvhost_syncpt_debug(struct nvhost_syncpt *sp);
 
 static inline int nvhost_syncpt_is_valid(struct nvhost_syncpt *sp, u32 id)
diff --git a/include/linux/nvhost.h b/include/linux/nvhost.h
index 20ba2a5..745f31c 100644
--- a/include/linux/nvhost.h
+++ b/include/linux/nvhost.h
@@ -35,6 +35,7 @@ struct nvhost_device_power_attr;
 #define NVHOST_DEFAULT_CLOCKGATE_DELAY		.clockgate_delay = 25
 #define NVHOST_NAME_SIZE			24
 #define NVSYNCPT_INVALID			(-1)
+#define NVHOST_NO_TIMEOUT			(-1)
 
 enum nvhost_power_sysfs_attributes {
 	NVHOST_POWER_SYSFS_ATTRIB_CLOCKGATE_DELAY = 0,
@@ -139,5 +140,6 @@ void host1x_idle(struct platform_device *dev);
 u32 host1x_syncpt_incr_max(u32 id, u32 incrs);
 void host1x_syncpt_incr(u32 id);
 u32 host1x_syncpt_read(u32 id);
+int host1x_syncpt_wait(u32 id, u32 thresh, u32 timeout, u32 *value);
 
 #endif
-- 
1.7.9.5

