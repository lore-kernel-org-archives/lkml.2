Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab2LULgC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 06:36:02 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11649 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab2LULex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 06:34:53 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 21 Dec 2012 03:32:08 -0800
From: Terje Bergstrom <tbergstrom@nvidia.com>
To: <thierry.reding@avionic-design.de>, <airlied@linux.ie>, <dev@lynxeye.de>,
        <dri-devel@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Terje Bergstrom <tbergstrom@nvidia.com>
Subject: [PATCHv4 2/8] gpu: host1x: Add syncpoint wait and interrupts
Date: Fri, 21 Dec 2012 13:39:18 +0200
Message-ID: <1356089964-5265-3-git-send-email-tbergstrom@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1356089964-5265-1-git-send-email-tbergstrom@nvidia.com>
References: <1356089964-5265-1-git-send-email-tbergstrom@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for sync point interrupts, and sync point wait. Sync
point wait used interrupts for unblocking wait.

Signed-off-by: Terje Bergstrom <tbergstrom@nvidia.com>
---
 drivers/gpu/host1x/Makefile              |    2 +
 drivers/gpu/host1x/dev.c                 |   37 +++-
 drivers/gpu/host1x/dev.h                 |   15 ++
 drivers/gpu/host1x/hw/host1x01.c         |    2 +
 drivers/gpu/host1x/hw/hw_host1x01_sync.h |   30 ++-
 drivers/gpu/host1x/hw/intr_hw.c          |  178 +++++++++++++++
 drivers/gpu/host1x/intr.c                |  350 ++++++++++++++++++++++++++++++
 drivers/gpu/host1x/intr.h                |  100 +++++++++
 drivers/gpu/host1x/syncpt.c              |  164 +++++++++++++-
 drivers/gpu/host1x/syncpt.h              |    4 +
 include/linux/host1x.h                   |    1 +
 11 files changed, 880 insertions(+), 3 deletions(-)
 create mode 100644 drivers/gpu/host1x/hw/intr_hw.c
 create mode 100644 drivers/gpu/host1x/intr.c
 create mode 100644 drivers/gpu/host1x/intr.h

diff --git a/drivers/gpu/host1x/Makefile b/drivers/gpu/host1x/Makefile
index 363e6ab..d3eb3b4 100644
--- a/drivers/gpu/host1x/Makefile
+++ b/drivers/gpu/host1x/Makefile
@@ -3,6 +3,8 @@ ccflags-y = -Idrivers/gpu/host1x
 host1x-y = \
 	syncpt.o \
 	dev.o \
+	intr.o \
 	hw/host1x01.o
 
+host1x-$(CONFIG_TEGRA_HOST1X_CMA) += cma.o
 obj-$(CONFIG_TEGRA_HOST1X) += host1x.o
diff --git a/drivers/gpu/host1x/dev.c b/drivers/gpu/host1x/dev.c
index b0d630d..f441b6c 100644
--- a/drivers/gpu/host1x/dev.c
+++ b/drivers/gpu/host1x/dev.c
@@ -25,6 +25,7 @@
 #include <linux/clk.h>
 #include <linux/io.h>
 #include "dev.h"
+#include "intr.h"
 #include "hw/host1x01.h"
 
 #define CREATE_TRACE_POINTS
@@ -48,6 +49,13 @@ u32 host1x_syncpt_read_byid(u32 id)
 }
 EXPORT_SYMBOL(host1x_syncpt_read_byid);
 
+int host1x_syncpt_wait_byid(u32 id, u32 thresh, long timeout, u32 *value)
+{
+	struct host1x_syncpt *sp = host1x->syncpt + id;
+	return host1x_syncpt_wait(sp, thresh, timeout, value);
+}
+EXPORT_SYMBOL(host1x_syncpt_wait_byid);
+
 void host1x_sync_writel(struct host1x *host1x, u32 v, u32 r)
 {
 	void __iomem *sync_regs = host1x->regs + host1x->info.sync_offset;
@@ -62,6 +70,21 @@ u32 host1x_sync_readl(struct host1x *host1x, u32 r)
 	return readl(sync_regs + r);
 }
 
+static int host1x_alloc_resources(struct host1x *host)
+{
+	host->intr.syncpt = devm_kzalloc(&host->dev->dev,
+			sizeof(struct host1x_intr_syncpt) *
+			host->info.nb_pts,
+			GFP_KERNEL);
+
+	if (!host->intr.syncpt) {
+		/* frees happen in the support removal phase */
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
 static struct host1x_device_info host1x_info = {
 	.nb_channels	= 8,
 	.nb_pts		= 32,
@@ -110,7 +133,6 @@ static int host1x_probe(struct platform_device *dev)
 
 	/* set common host1x device data */
 	platform_set_drvdata(dev, host);
-
 	host->regs = devm_request_and_ioremap(&dev->dev, regs);
 	if (!host->regs) {
 		dev_err(&dev->dev, "failed to remap host registers\n");
@@ -118,6 +140,12 @@ static int host1x_probe(struct platform_device *dev)
 		goto fail;
 	}
 
+	err = host1x_alloc_resources(host);
+	if (err) {
+		dev_err(&dev->dev, "failed to init chip support\n");
+		goto fail;
+	}
+
 	if (host->info.init) {
 		err = host->info.init(host);
 		if (err)
@@ -132,6 +160,10 @@ static int host1x_probe(struct platform_device *dev)
 	if (!host->nop_sp)
 		goto fail;
 
+	err = host1x_intr_init(&host->intr, syncpt_irq);
+	if (err)
+		goto fail;
+
 	host->clk = devm_clk_get(&dev->dev, NULL);
 	if (IS_ERR(host->clk)) {
 		dev_err(&dev->dev, "failed to get clock\n");
@@ -145,6 +177,8 @@ static int host1x_probe(struct platform_device *dev)
 
 	host1x_syncpt_reset(host);
 
+	host1x_intr_start(&host->intr, clk_get_rate(host->clk));
+
 	host1x = host;
 
 	dev_info(&dev->dev, "initialized\n");
@@ -160,6 +194,7 @@ fail:
 static int __exit host1x_remove(struct platform_device *dev)
 {
 	struct host1x *host = platform_get_drvdata(dev);
+	host1x_intr_deinit(&host->intr);
 	host1x_syncpt_deinit(host);
 	clk_disable_unprepare(host->clk);
 	return 0;
diff --git a/drivers/gpu/host1x/dev.h b/drivers/gpu/host1x/dev.h
index 8245e24..a1622bb 100644
--- a/drivers/gpu/host1x/dev.h
+++ b/drivers/gpu/host1x/dev.h
@@ -20,6 +20,7 @@
 #include <linux/host1x.h>
 
 #include "syncpt.h"
+#include "intr.h"
 
 struct host1x;
 struct host1x_syncpt;
@@ -36,6 +37,18 @@ struct host1x_syncpt_ops {
 	const char * (*name)(struct host1x_syncpt *);
 };
 
+struct host1x_intr_ops {
+	void (*init_host_sync)(struct host1x_intr *);
+	void (*set_host_clocks_per_usec)(
+		struct host1x_intr *, u32 clocks);
+	void (*set_syncpt_threshold)(
+		struct host1x_intr *, u32 id, u32 thresh);
+	void (*enable_syncpt_intr)(struct host1x_intr *, u32 id);
+	void (*disable_syncpt_intr)(struct host1x_intr *, u32 id);
+	void (*disable_all_syncpt_intrs)(struct host1x_intr *);
+	int (*free_syncpt_irq)(struct host1x_intr *);
+};
+
 struct host1x_device_info {
 	int	nb_channels;		/* host1x: num channels supported */
 	int	nb_pts;			/* host1x: num syncpoints supported */
@@ -48,6 +61,7 @@ struct host1x_device_info {
 struct host1x {
 	void __iomem *regs;
 	struct host1x_syncpt *syncpt;
+	struct host1x_intr intr;
 	struct platform_device *dev;
 	atomic_t clientid;
 	struct host1x_device_info info;
@@ -57,6 +71,7 @@ struct host1x {
 
 	const char *soc_name;
 	struct host1x_syncpt_ops syncpt_op;
+	struct host1x_intr_ops intr_op;
 
 	struct dentry *debugfs;
 };
diff --git a/drivers/gpu/host1x/hw/host1x01.c b/drivers/gpu/host1x/hw/host1x01.c
index 59176ba..c5c55a3 100644
--- a/drivers/gpu/host1x/hw/host1x01.c
+++ b/drivers/gpu/host1x/hw/host1x01.c
@@ -27,10 +27,12 @@
 #include "hw/host1x01_hardware.h"
 
 #include "hw/syncpt_hw.c"
+#include "hw/intr_hw.c"
 
 int host1x01_init(struct host1x *host)
 {
 	host->syncpt_op = host1x_syncpt_ops;
+	host->intr_op = host1x_intr_ops;
 
 	return 0;
 }
diff --git a/drivers/gpu/host1x/hw/hw_host1x01_sync.h b/drivers/gpu/host1x/hw/hw_host1x01_sync.h
index 63a71c8..b06a2c5 100644
--- a/drivers/gpu/host1x/hw/hw_host1x01_sync.h
+++ b/drivers/gpu/host1x/hw/hw_host1x01_sync.h
@@ -51,10 +51,38 @@
 #ifndef __hw_host1x_sync_h__
 #define __hw_host1x_sync_h__
 
+static inline u32 host1x_sync_syncpt_thresh_cpu0_int_status_r(void)
+{
+	return 0x40;
+}
+static inline u32 host1x_sync_syncpt_thresh_int_disable_r(void)
+{
+	return 0x60;
+}
+static inline u32 host1x_sync_syncpt_thresh_int_enable_cpu0_r(void)
+{
+	return 0x68;
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
 static inline u32 host1x_sync_syncpt_0_r(void)
 {
 	return 0x400;
 }
+static inline u32 host1x_sync_syncpt_int_thresh_0_r(void)
+{
+	return 0x500;
+}
 static inline u32 host1x_sync_syncpt_base_0_r(void)
 {
 	return 0x600;
@@ -63,4 +91,4 @@ static inline u32 host1x_sync_syncpt_cpu_incr_r(void)
 {
 	return 0x700;
 }
-#endif /* __hw_host1x_host1x_h__ */
+#endif /* __hw_host1x_sync_h__ */
diff --git a/drivers/gpu/host1x/hw/intr_hw.c b/drivers/gpu/host1x/hw/intr_hw.c
new file mode 100644
index 0000000..9e8ce28
--- /dev/null
+++ b/drivers/gpu/host1x/hw/intr_hw.c
@@ -0,0 +1,178 @@
+/*
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
+#include "intr.h"
+#include "dev.h"
+
+/* Spacing between sync registers */
+#define REGISTER_STRIDE 4
+
+static void host1x_intr_syncpt_thresh_isr(struct host1x_intr_syncpt *syncpt);
+
+static void syncpt_thresh_cascade_fn(struct work_struct *work)
+{
+	struct host1x_intr_syncpt *sp =
+		container_of(work, struct host1x_intr_syncpt, work);
+	host1x_syncpt_thresh_fn(sp);
+}
+
+static irqreturn_t syncpt_thresh_cascade_isr(int irq, void *dev_id)
+{
+	struct host1x *host1x = dev_id;
+	struct host1x_intr *intr = &host1x->intr;
+	unsigned long reg;
+	int i, id;
+
+	for (i = 0; i < host1x->info.nb_pts / BITS_PER_LONG; i++) {
+		reg = host1x_sync_readl(host1x,
+				host1x_sync_syncpt_thresh_cpu0_int_status_r() +
+				i * REGISTER_STRIDE);
+		for_each_set_bit(id, &reg, BITS_PER_LONG) {
+			struct host1x_intr_syncpt *sp =
+				intr->syncpt + (i * BITS_PER_LONG + id);
+			host1x_intr_syncpt_thresh_isr(sp);
+			queue_work(intr->wq, &sp->work);
+		}
+	}
+
+	return IRQ_HANDLED;
+}
+
+static void host1x_intr_init_host_sync(struct host1x_intr *intr)
+{
+	struct host1x *host1x = intr_to_host1x(intr);
+	int i, err;
+
+	host1x_sync_writel(host1x, 0xffffffffUL,
+		host1x_sync_syncpt_thresh_int_disable_r());
+	host1x_sync_writel(host1x, 0xffffffffUL,
+		host1x_sync_syncpt_thresh_cpu0_int_status_r());
+
+	for (i = 0; i < host1x->info.nb_pts; i++)
+		INIT_WORK(&intr->syncpt[i].work, syncpt_thresh_cascade_fn);
+
+	err = devm_request_irq(&host1x->dev->dev, intr->syncpt_irq,
+				syncpt_thresh_cascade_isr,
+				IRQF_SHARED, "host1x_syncpt", host1x);
+	WARN_ON(IS_ERR_VALUE(err));
+
+	/* disable the ip_busy_timeout. this prevents write drops */
+	host1x_sync_writel(host1x, 0, host1x_sync_ip_busy_timeout_r());
+
+	/*
+	 * increase the auto-ack timout to the maximum value. 2d will hang
+	 * otherwise on Tegra2.
+	 */
+	host1x_sync_writel(host1x, 0xff, host1x_sync_ctxsw_timeout_cfg_r());
+}
+
+static void host1x_intr_set_host_clocks_per_usec(struct host1x_intr *intr,
+		u32 cpm)
+{
+	struct host1x *host1x = intr_to_host1x(intr);
+	/* write microsecond clock register */
+	host1x_sync_writel(host1x, cpm, host1x_sync_usec_clk_r());
+}
+
+static void host1x_intr_set_syncpt_threshold(struct host1x_intr *intr,
+	u32 id, u32 thresh)
+{
+	struct host1x *host1x = intr_to_host1x(intr);
+	host1x_sync_writel(host1x, thresh,
+		host1x_sync_syncpt_int_thresh_0_r() + id * REGISTER_STRIDE);
+}
+
+static void host1x_intr_enable_syncpt_intr(struct host1x_intr *intr, u32 id)
+{
+	struct host1x *host1x = intr_to_host1x(intr);
+
+	host1x_sync_writel(host1x, BIT_MASK(id),
+			host1x_sync_syncpt_thresh_int_enable_cpu0_r() +
+			BIT_WORD(id) * REGISTER_STRIDE);
+}
+
+static void host1x_intr_disable_syncpt_intr(struct host1x_intr *intr, u32 id)
+{
+	struct host1x *host1x = intr_to_host1x(intr);
+
+	host1x_sync_writel(host1x, BIT_MASK(id),
+			host1x_sync_syncpt_thresh_int_disable_r() +
+			BIT_WORD(id) * REGISTER_STRIDE);
+
+	host1x_sync_writel(host1x, BIT_MASK(id),
+		host1x_sync_syncpt_thresh_cpu0_int_status_r() +
+		BIT_WORD(id) * REGISTER_STRIDE);
+}
+
+static void host1x_intr_disable_all_syncpt_intrs(struct host1x_intr *intr)
+{
+	struct host1x *host1x = intr_to_host1x(intr);
+	u32 reg;
+
+	for (reg = 0; reg <= BIT_WORD(host1x->info.nb_pts) * REGISTER_STRIDE;
+			reg += REGISTER_STRIDE) {
+		host1x_sync_writel(host1x, 0xffffffffu,
+				host1x_sync_syncpt_thresh_int_disable_r() +
+				reg);
+
+		host1x_sync_writel(host1x, 0xffffffffu,
+			host1x_sync_syncpt_thresh_cpu0_int_status_r() + reg);
+	}
+}
+
+/*
+ * Sync point threshold interrupt service function
+ * Handles sync point threshold triggers, in interrupt context
+ */
+static void host1x_intr_syncpt_thresh_isr(struct host1x_intr_syncpt *syncpt)
+{
+	unsigned int id = syncpt->id;
+	struct host1x_intr *intr = intr_syncpt_to_intr(syncpt);
+	struct host1x *host1x = intr_to_host1x(intr);
+	u32 reg = BIT_WORD(id) * REGISTER_STRIDE;
+
+	host1x_sync_writel(host1x, BIT_MASK(id),
+		host1x_sync_syncpt_thresh_int_disable_r() + reg);
+	host1x_sync_writel(host1x, BIT_MASK(id),
+		host1x_sync_syncpt_thresh_cpu0_int_status_r() + reg);
+}
+
+static int host1x_free_syncpt_irq(struct host1x_intr *intr)
+{
+	struct host1x *host1x = intr_to_host1x(intr);
+
+	devm_free_irq(&host1x->dev->dev, intr->syncpt_irq, host1x);
+	flush_workqueue(intr->wq);
+	return 0;
+}
+
+static const struct host1x_intr_ops host1x_intr_ops = {
+	.init_host_sync = host1x_intr_init_host_sync,
+	.set_host_clocks_per_usec = host1x_intr_set_host_clocks_per_usec,
+	.set_syncpt_threshold = host1x_intr_set_syncpt_threshold,
+	.enable_syncpt_intr = host1x_intr_enable_syncpt_intr,
+	.disable_syncpt_intr = host1x_intr_disable_syncpt_intr,
+	.disable_all_syncpt_intrs = host1x_intr_disable_all_syncpt_intrs,
+	.free_syncpt_irq = host1x_free_syncpt_irq,
+};
diff --git a/drivers/gpu/host1x/intr.c b/drivers/gpu/host1x/intr.c
new file mode 100644
index 0000000..bc51e4d
--- /dev/null
+++ b/drivers/gpu/host1x/intr.c
@@ -0,0 +1,350 @@
+/*
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
+#include "intr.h"
+#include <linux/interrupt.h>
+#include <linux/slab.h>
+#include <linux/irq.h>
+#include "dev.h"
+
+/* Wait list management */
+
+struct host1x_waitlist {
+	struct list_head list;
+	struct kref refcount;
+	u32 thresh;
+	enum host1x_intr_action action;
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
+	kfree(container_of(kref, struct host1x_waitlist, refcount));
+}
+
+/*
+ * add a waiter to a waiter queue, sorted by threshold
+ * returns true if it was added at the head of the queue
+ */
+static bool add_waiter_to_queue(struct host1x_waitlist *waiter,
+				struct list_head *queue)
+{
+	struct host1x_waitlist *pos;
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
+/*
+ * run through a waiter queue for a single sync point ID
+ * and gather all completed waiters into lists by actions
+ */
+static void remove_completed_waiters(struct list_head *head, u32 sync,
+			struct list_head completed[HOST1X_INTR_ACTION_COUNT])
+{
+	struct list_head *dest;
+	struct host1x_waitlist *waiter, *next;
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
+static void reset_threshold_interrupt(struct host1x_intr *intr,
+			       struct list_head *head,
+			       unsigned int id)
+{
+	struct host1x *host1x = intr_to_host1x(intr);
+	u32 thresh = list_first_entry(head,
+				struct host1x_waitlist, list)->thresh;
+
+	host1x->intr_op.set_syncpt_threshold(intr, id, thresh);
+	host1x->intr_op.enable_syncpt_intr(intr, id);
+}
+
+static void action_wakeup(struct host1x_waitlist *waiter)
+{
+	wait_queue_head_t *wq = waiter->data;
+
+	wake_up(wq);
+}
+
+static void action_wakeup_interruptible(struct host1x_waitlist *waiter)
+{
+	wait_queue_head_t *wq = waiter->data;
+
+	wake_up_interruptible(wq);
+}
+
+typedef void (*action_handler)(struct host1x_waitlist *waiter);
+
+static action_handler action_handlers[HOST1X_INTR_ACTION_COUNT] = {
+	action_wakeup,
+	action_wakeup_interruptible,
+};
+
+static void run_handlers(struct list_head completed[HOST1X_INTR_ACTION_COUNT])
+{
+	struct list_head *head = completed;
+	int i;
+
+	for (i = 0; i < HOST1X_INTR_ACTION_COUNT; ++i, ++head) {
+		action_handler handler = action_handlers[i];
+		struct host1x_waitlist *waiter, *next;
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
+/*
+ * Remove & handle all waiters that have completed for the given syncpt
+ */
+static int process_wait_list(struct host1x_intr *intr,
+			     struct host1x_intr_syncpt *syncpt,
+			     u32 threshold)
+{
+	struct host1x *host1x = intr_to_host1x(intr);
+	struct list_head completed[HOST1X_INTR_ACTION_COUNT];
+	unsigned int i;
+	int empty;
+
+	for (i = 0; i < HOST1X_INTR_ACTION_COUNT; ++i)
+		INIT_LIST_HEAD(completed + i);
+
+	spin_lock(&syncpt->lock);
+
+	remove_completed_waiters(&syncpt->wait_head, threshold, completed);
+
+	empty = list_empty(&syncpt->wait_head);
+	if (empty)
+		host1x->intr_op.disable_syncpt_intr(intr, syncpt->id);
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
+/*
+ * Sync point threshold interrupt service thread function
+ * Handles sync point threshold triggers, in thread context
+ */
+irqreturn_t host1x_syncpt_thresh_fn(void *dev_id)
+{
+	struct host1x_intr_syncpt *syncpt = dev_id;
+	unsigned int id = syncpt->id;
+	struct host1x_intr *intr = intr_syncpt_to_intr(syncpt);
+	struct host1x *host1x = intr_to_host1x(intr);
+
+	(void)process_wait_list(intr, syncpt,
+				host1x_syncpt_load_min(host1x->syncpt + id));
+
+	return IRQ_HANDLED;
+}
+
+int host1x_intr_add_action(struct host1x_intr *intr, u32 id, u32 thresh,
+			enum host1x_intr_action action, void *data,
+			void *_waiter,
+			void **ref)
+{
+	struct host1x *host1x = intr_to_host1x(intr);
+	struct host1x_waitlist *waiter = _waiter;
+	struct host1x_intr_syncpt *syncpt;
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
+		host1x->intr_op.set_syncpt_threshold(intr, id, thresh);
+
+		/* added as first waiter - enable interrupt */
+		if (queue_was_empty)
+			host1x->intr_op.enable_syncpt_intr(intr, id);
+	}
+
+	spin_unlock(&syncpt->lock);
+
+	if (ref)
+		*ref = waiter;
+	return 0;
+}
+
+void *host1x_intr_alloc_waiter(void)
+{
+	return kzalloc(sizeof(struct host1x_waitlist), GFP_KERNEL);
+}
+
+void host1x_intr_put_ref(struct host1x_intr *intr, u32 id, void *ref)
+{
+	struct host1x_waitlist *waiter = ref;
+	struct host1x_intr_syncpt *syncpt;
+	struct host1x *host1x = intr_to_host1x(intr);
+
+	while (atomic_cmpxchg(&waiter->state,
+				WLS_PENDING, WLS_CANCELLED) == WLS_REMOVED)
+		schedule();
+
+	syncpt = intr->syncpt + id;
+	(void)process_wait_list(intr, syncpt,
+				host1x_syncpt_load_min(host1x->syncpt + id));
+
+	kref_put(&waiter->refcount, waiter_release);
+}
+
+int host1x_intr_init(struct host1x_intr *intr, u32 irq_sync)
+{
+	unsigned int id;
+	struct host1x *host1x = intr_to_host1x(intr);
+	u32 nb_pts = host1x_syncpt_nb_pts(host1x);
+
+	mutex_init(&intr->mutex);
+	intr->syncpt_irq = irq_sync;
+	intr->wq = create_workqueue("host_syncpt");
+	if (!intr->wq)
+		return -ENOMEM;
+
+	host1x->intr_op.init_host_sync(intr);
+
+	for (id = 0; id < nb_pts; ++id) {
+		struct host1x_intr_syncpt *syncpt = &intr->syncpt[id];
+
+		syncpt->intr = &host1x->intr;
+		syncpt->id = id;
+		spin_lock_init(&syncpt->lock);
+		INIT_LIST_HEAD(&syncpt->wait_head);
+		snprintf(syncpt->thresh_irq_name,
+			sizeof(syncpt->thresh_irq_name),
+			"host1x_sp_%02d", id);
+	}
+
+	return 0;
+}
+
+void host1x_intr_deinit(struct host1x_intr *intr)
+{
+	host1x_intr_stop(intr);
+	destroy_workqueue(intr->wq);
+}
+
+void host1x_intr_start(struct host1x_intr *intr, u32 hz)
+{
+	struct host1x *host1x = intr_to_host1x(intr);
+	mutex_lock(&intr->mutex);
+
+	host1x->intr_op.init_host_sync(intr);
+	host1x->intr_op.set_host_clocks_per_usec(intr,
+			DIV_ROUND_UP(hz, 1000000));
+
+	mutex_unlock(&intr->mutex);
+}
+
+void host1x_intr_stop(struct host1x_intr *intr)
+{
+	unsigned int id;
+	struct host1x *host1x = intr_to_host1x(intr);
+	struct host1x_intr_syncpt *syncpt;
+	u32 nb_pts = host1x_syncpt_nb_pts(intr_to_host1x(intr));
+
+	mutex_lock(&intr->mutex);
+
+	host1x->intr_op.disable_all_syncpt_intrs(intr);
+
+	for (id = 0, syncpt = intr->syncpt;
+	     id < nb_pts;
+	     ++id, ++syncpt) {
+		struct host1x_waitlist *waiter, *next;
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
+			mutex_unlock(&intr->mutex);
+			pr_warn("%s cannot stop syncpt intr id=%d\n",
+					__func__, id);
+			return;
+		}
+	}
+
+	host1x->intr_op.free_syncpt_irq(intr);
+
+	mutex_unlock(&intr->mutex);
+}
diff --git a/drivers/gpu/host1x/intr.h b/drivers/gpu/host1x/intr.h
new file mode 100644
index 0000000..3625bf3
--- /dev/null
+++ b/drivers/gpu/host1x/intr.h
@@ -0,0 +1,100 @@
+/*
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
+#ifndef __HOST1X_INTR_H
+#define __HOST1X_INTR_H
+
+#include <linux/kthread.h>
+#include <linux/semaphore.h>
+#include <linux/interrupt.h>
+#include <linux/workqueue.h>
+
+struct host1x_channel;
+
+enum host1x_intr_action {
+	/*
+	 * Wake up a  task.
+	 * 'data' points to a wait_queue_head_t
+	 */
+	HOST1X_INTR_ACTION_WAKEUP,
+
+	/*
+	 * Wake up a interruptible task.
+	 * 'data' points to a wait_queue_head_t
+	 */
+	HOST1X_INTR_ACTION_WAKEUP_INTERRUPTIBLE,
+
+	HOST1X_INTR_ACTION_COUNT
+};
+
+struct host1x_intr;
+
+struct host1x_intr_syncpt {
+	struct host1x_intr *intr;
+	u8 id;
+	spinlock_t lock;
+	struct list_head wait_head;
+	char thresh_irq_name[12];
+	struct work_struct work;
+};
+
+struct host1x_intr {
+	struct host1x_intr_syncpt *syncpt;
+	struct mutex mutex;
+	int syncpt_irq;
+	struct workqueue_struct *wq;
+};
+#define intr_to_host1x(x) container_of(x, struct host1x, intr)
+#define intr_syncpt_to_intr(is) (is->intr)
+
+/*
+ * Schedule an action to be taken when a sync point reaches the given threshold.
+ *
+ * @id the sync point
+ * @thresh the threshold
+ * @action the action to take
+ * @data a pointer to extra data depending on action, see above
+ * @waiter waiter allocated with host1x_intr_alloc_waiter - assumes ownership
+ * @ref must be passed if cancellation is possible, else NULL
+ *
+ * This is a non-blocking api.
+ */
+int host1x_intr_add_action(struct host1x_intr *intr, u32 id, u32 thresh,
+			enum host1x_intr_action action, void *data,
+			void *waiter,
+			void **ref);
+
+/*
+ * Allocate a waiter.
+ */
+void *host1x_intr_alloc_waiter(void);
+
+/*
+ * Unreference an action submitted to host1x_intr_add_action().
+ * You must call this if you passed non-NULL as ref.
+ * @ref the ref returned from host1x_intr_add_action()
+ */
+void host1x_intr_put_ref(struct host1x_intr *intr, u32 id, void *ref);
+
+int host1x_intr_init(struct host1x_intr *intr, u32 irq_sync);
+void host1x_intr_deinit(struct host1x_intr *intr);
+void host1x_intr_start(struct host1x_intr *intr, u32 hz);
+void host1x_intr_stop(struct host1x_intr *intr);
+
+irqreturn_t host1x_syncpt_thresh_fn(void *dev_id);
+#endif
diff --git a/drivers/gpu/host1x/syncpt.c b/drivers/gpu/host1x/syncpt.c
index d551325..adf439f 100644
--- a/drivers/gpu/host1x/syncpt.c
+++ b/drivers/gpu/host1x/syncpt.c
@@ -22,6 +22,7 @@
 #include <linux/module.h>
 #include "syncpt.h"
 #include "dev.h"
+#include "intr.h"
 #include <trace/events/host1x.h>
 
 #define MAX_SYNCPT_LENGTH	5
@@ -129,6 +130,166 @@ void host1x_syncpt_incr(struct host1x_syncpt *sp)
 }
 EXPORT_SYMBOL(host1x_syncpt_incr);
 
+/*
+ * Updated sync point form hardware, and returns true if syncpoint is expired,
+ * false if we may need to wait
+ */
+static bool syncpt_load_min_is_expired(
+	struct host1x_syncpt *sp,
+	u32 thresh)
+{
+	sp->dev->syncpt_op.load_min(sp);
+	return host1x_syncpt_is_expired(sp, thresh);
+}
+
+/*
+ * Main entrypoint for syncpoint value waits.
+ */
+int host1x_syncpt_wait(struct host1x_syncpt *sp,
+			u32 thresh, long timeout, u32 *value)
+{
+	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(wq);
+	void *ref;
+	void *waiter;
+	int err = 0, check_count = 0;
+	u32 val;
+
+	if (value)
+		*value = 0;
+
+	/* first check cache */
+	if (host1x_syncpt_is_expired(sp, thresh)) {
+		if (value)
+			*value = host1x_syncpt_read_min(sp);
+		return 0;
+	}
+
+	/* try to read from register */
+	val = sp->dev->syncpt_op.load_min(sp);
+	if (host1x_syncpt_is_expired(sp, thresh)) {
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
+	waiter = host1x_intr_alloc_waiter();
+	if (!waiter) {
+		err = -ENOMEM;
+		goto done;
+	}
+
+	err = host1x_intr_add_action(&(sp->dev->intr), sp->id, thresh,
+				HOST1X_INTR_ACTION_WAKEUP_INTERRUPTIBLE, &wq,
+				waiter,
+				&ref);
+	if (err)
+		goto done;
+
+	err = -EAGAIN;
+	/* Caller-specified timeout may be impractically low */
+	if (timeout < 0)
+		timeout = LONG_MAX;
+
+	/* wait for the syncpoint, or timeout, or signal */
+	while (timeout) {
+		long check = min_t(long, SYNCPT_CHECK_PERIOD, timeout);
+		int remain = wait_event_interruptible_timeout(wq,
+				syncpt_load_min_is_expired(sp, thresh),
+				check);
+		if (remain > 0 || host1x_syncpt_is_expired(sp, thresh)) {
+			if (value)
+				*value = host1x_syncpt_read_min(sp);
+			err = 0;
+			break;
+		}
+		if (remain < 0) {
+			err = remain;
+			break;
+		}
+		timeout -= check;
+		if (timeout && check_count <= MAX_STUCK_CHECK_COUNT) {
+			dev_warn(&sp->dev->dev->dev,
+				"%s: syncpoint id %d (%s) stuck waiting %d, timeout=%ld\n",
+				 current->comm, sp->id, sp->name,
+				 thresh, timeout);
+			sp->dev->syncpt_op.debug(sp);
+			check_count++;
+		}
+	}
+	host1x_intr_put_ref(&(sp->dev->intr), sp->id, ref);
+
+done:
+	return err;
+}
+EXPORT_SYMBOL(host1x_syncpt_wait);
+
+/*
+ * Returns true if syncpoint is expired, false if we may need to wait
+ */
+bool host1x_syncpt_is_expired(
+	struct host1x_syncpt *sp,
+	u32 thresh)
+{
+	u32 current_val;
+	u32 future_val;
+	smp_rmb();
+	current_val = (u32)atomic_read(&sp->min_val);
+	future_val = (u32)atomic_read(&sp->max_val);
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
+	if (!host1x_syncpt_client_managed(sp))
+		return future_val - thresh >= current_val - thresh;
+	else
+		return (s32)(current_val - thresh) >= 0;
+}
+
 void host1x_syncpt_debug(struct host1x_syncpt *sp)
 {
 	sp->dev->syncpt_op.debug(sp);
@@ -202,7 +363,8 @@ void host1x_syncpt_deinit(struct host1x *host)
 	int i;
 	struct host1x_syncpt *sp = host->syncpt;
 	for (i = 0; i < host->info.nb_pts; i++, sp++)
-		kfree(sp->name);
+		if (sp->name)
+			kfree(sp->name);
 	kfree(sp);
 }
 
diff --git a/drivers/gpu/host1x/syncpt.h b/drivers/gpu/host1x/syncpt.h
index 4f7777b..d4d1f3f 100644
--- a/drivers/gpu/host1x/syncpt.h
+++ b/drivers/gpu/host1x/syncpt.h
@@ -106,6 +106,7 @@ struct host1x_syncpt *host1x_syncpt_get(struct host1x *dev, u32 id);
 void host1x_syncpt_cpu_incr(struct host1x_syncpt *sp);
 
 u32 host1x_syncpt_load_min(struct host1x_syncpt *sp);
+bool host1x_syncpt_is_expired(struct host1x_syncpt *sp, u32 thresh);
 
 void host1x_syncpt_save(struct host1x *dev);
 
@@ -117,6 +118,9 @@ u32 host1x_syncpt_read_wait_base(struct host1x_syncpt *sp);
 void host1x_syncpt_incr(struct host1x_syncpt *sp);
 u32 host1x_syncpt_incr_max(struct host1x_syncpt *sp, u32 incrs);
 
+int host1x_syncpt_wait(struct host1x_syncpt *sp, u32 thresh,
+			long timeout, u32 *value);
+
 void host1x_syncpt_debug(struct host1x_syncpt *sp);
 
 static inline int host1x_syncpt_is_valid(struct host1x_syncpt *sp)
diff --git a/include/linux/host1x.h b/include/linux/host1x.h
index 6c2cc8a..00060ee 100644
--- a/include/linux/host1x.h
+++ b/include/linux/host1x.h
@@ -33,6 +33,7 @@ struct host1x_syncpt;
 u32 host1x_syncpt_id(struct host1x_syncpt *sp);
 void host1x_syncpt_incr_byid(u32 id);
 u32 host1x_syncpt_read_byid(u32 id);
+int host1x_syncpt_wait_byid(u32 id, u32 thresh, long timeout, u32 *value);
 
 struct host1x_syncpt *host1x_syncpt_alloc(struct platform_device *pdev,
 		int client_managed);
-- 
1.7.9.5

