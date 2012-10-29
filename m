Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760258Ab2J2RGm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 13:06:42 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:60956 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756951Ab2J2RGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 13:06:36 -0400
From: Omar Ramirez Luna <omar.luna@linaro.org>
To: Tony Lindgren <tony@atomide.com>
Cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Ohad Ben-Cohen <ohad@wizery.com>, Suman Anna <s-anna@ti.com>,
        Juan Gutierrez <jgutierrez@ti.com>,
        Felipe Contreras <felipe.contreras@nokia.com>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Omar Ramirez Luna <omar.luna@linaro.org>
Subject: [PATCH 2/2] mailbox: OMAP: introduce mailbox framework
Date: Mon, 29 Oct 2012 12:06:21 -0500
Message-Id: <1351530381-11459-3-git-send-email-omar.luna@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351530381-11459-1-git-send-email-omar.luna@linaro.org>
References: <1351530381-11459-1-git-send-email-omar.luna@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actually moving it from plat-omap code as this is supposed to be
under drivers/ folder. This framework should work with the current
OMAP processors that have mailbox and can be used as a method of
interprocessor communication.

Signed-off-by: Omar Ramirez Luna <omar.luna@linaro.org>
---
 arch/arm/plat-omap/Kconfig   |   16 --
 arch/arm/plat-omap/Makefile  |    3 -
 arch/arm/plat-omap/mailbox.c |  435 ------------------------------------------
 drivers/Kconfig              |    2 +
 drivers/Makefile             |    1 +
 drivers/mailbox/Kconfig      |   28 +++
 drivers/mailbox/Makefile     |    1 +
 drivers/mailbox/mailbox.c    |  435 ++++++++++++++++++++++++++++++++++++++++++
 8 files changed, 467 insertions(+), 454 deletions(-)
 delete mode 100644 arch/arm/plat-omap/mailbox.c
 create mode 100644 drivers/mailbox/Kconfig
 create mode 100644 drivers/mailbox/Makefile
 create mode 100644 drivers/mailbox/mailbox.c

diff --git a/arch/arm/plat-omap/Kconfig b/arch/arm/plat-omap/Kconfig
index 82fcb20..419648f 100644
--- a/arch/arm/plat-omap/Kconfig
+++ b/arch/arm/plat-omap/Kconfig
@@ -116,22 +116,6 @@ config OMAP_MUX_WARNINGS
 	  to change the pin multiplexing setup.	 When there are no warnings
 	  printed, it's safe to deselect OMAP_MUX for your product.
 
-config OMAP_MBOX_FWK
-	tristate "Mailbox framework support"
-	depends on ARCH_OMAP
-	help
-	  Say Y here if you want to use OMAP Mailbox framework support for
-	  DSP, IVA1.0 and IVA2 in OMAP1/2/3.
-
-config OMAP_MBOX_KFIFO_SIZE
-	int "Mailbox kfifo default buffer size (bytes)"
-	depends on OMAP_MBOX_FWK
-	default 256
-	help
-	  Specify the default size of mailbox's kfifo buffers (bytes).
-	  This can also be changed at runtime (via the mbox_kfifo_size
-	  module parameter).
-
 config OMAP_IOMMU_IVA2
 	bool
 
diff --git a/arch/arm/plat-omap/Makefile b/arch/arm/plat-omap/Makefile
index 4bd0ace..4702d1f 100644
--- a/arch/arm/plat-omap/Makefile
+++ b/arch/arm/plat-omap/Makefile
@@ -16,7 +16,4 @@ obj-$(CONFIG_OMAP_DEBUG_LEDS) += debug-leds.o
 i2c-omap-$(CONFIG_I2C_OMAP) := i2c.o
 obj-y += $(i2c-omap-m) $(i2c-omap-y)
 
-# OMAP mailbox framework
-obj-$(CONFIG_OMAP_MBOX_FWK) += mailbox.o
-
 obj-$(CONFIG_OMAP_PM_NOOP) += omap-pm-noop.o
diff --git a/arch/arm/plat-omap/mailbox.c b/arch/arm/plat-omap/mailbox.c
deleted file mode 100644
index cae8692..0000000
--- a/arch/arm/plat-omap/mailbox.c
+++ /dev/null
@@ -1,435 +0,0 @@
-/*
- * OMAP mailbox driver
- *
- * Copyright (C) 2006-2009 Nokia Corporation. All rights reserved.
- *
- * Contact: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- *
- */
-
-#include <linux/interrupt.h>
-#include <linux/spinlock.h>
-#include <linux/mutex.h>
-#include <linux/delay.h>
-#include <linux/slab.h>
-#include <linux/kfifo.h>
-#include <linux/err.h>
-#include <linux/notifier.h>
-#include <linux/module.h>
-
-#include <linux/platform_data/omap_mailbox.h>
-
-static struct omap_mbox **mboxes;
-
-static int mbox_configured;
-static DEFINE_MUTEX(mbox_configured_lock);
-
-static unsigned int mbox_kfifo_size = CONFIG_OMAP_MBOX_KFIFO_SIZE;
-module_param(mbox_kfifo_size, uint, S_IRUGO);
-MODULE_PARM_DESC(mbox_kfifo_size, "Size of omap's mailbox kfifo (bytes)");
-
-/* Mailbox FIFO handle functions */
-static inline mbox_msg_t mbox_fifo_read(struct omap_mbox *mbox)
-{
-	return mbox->ops->fifo_read(mbox);
-}
-static inline void mbox_fifo_write(struct omap_mbox *mbox, mbox_msg_t msg)
-{
-	mbox->ops->fifo_write(mbox, msg);
-}
-static inline int mbox_fifo_empty(struct omap_mbox *mbox)
-{
-	return mbox->ops->fifo_empty(mbox);
-}
-static inline int mbox_fifo_full(struct omap_mbox *mbox)
-{
-	return mbox->ops->fifo_full(mbox);
-}
-
-/* Mailbox IRQ handle functions */
-static inline void ack_mbox_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq)
-{
-	if (mbox->ops->ack_irq)
-		mbox->ops->ack_irq(mbox, irq);
-}
-static inline int is_mbox_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq)
-{
-	return mbox->ops->is_irq(mbox, irq);
-}
-
-/*
- * message sender
- */
-static int __mbox_poll_for_space(struct omap_mbox *mbox)
-{
-	int ret = 0, i = 1000;
-
-	while (mbox_fifo_full(mbox)) {
-		if (mbox->ops->type == OMAP_MBOX_TYPE2)
-			return -1;
-		if (--i == 0)
-			return -1;
-		udelay(1);
-	}
-	return ret;
-}
-
-int omap_mbox_msg_send(struct omap_mbox *mbox, mbox_msg_t msg)
-{
-	struct omap_mbox_queue *mq = mbox->txq;
-	int ret = 0, len;
-
-	spin_lock_bh(&mq->lock);
-
-	if (kfifo_avail(&mq->fifo) < sizeof(msg)) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	if (kfifo_is_empty(&mq->fifo) && !__mbox_poll_for_space(mbox)) {
-		mbox_fifo_write(mbox, msg);
-		goto out;
-	}
-
-	len = kfifo_in(&mq->fifo, (unsigned char *)&msg, sizeof(msg));
-	WARN_ON(len != sizeof(msg));
-
-	tasklet_schedule(&mbox->txq->tasklet);
-
-out:
-	spin_unlock_bh(&mq->lock);
-	return ret;
-}
-EXPORT_SYMBOL(omap_mbox_msg_send);
-
-static void mbox_tx_tasklet(unsigned long tx_data)
-{
-	struct omap_mbox *mbox = (struct omap_mbox *)tx_data;
-	struct omap_mbox_queue *mq = mbox->txq;
-	mbox_msg_t msg;
-	int ret;
-
-	while (kfifo_len(&mq->fifo)) {
-		if (__mbox_poll_for_space(mbox)) {
-			omap_mbox_enable_irq(mbox, IRQ_TX);
-			break;
-		}
-
-		ret = kfifo_out(&mq->fifo, (unsigned char *)&msg,
-								sizeof(msg));
-		WARN_ON(ret != sizeof(msg));
-
-		mbox_fifo_write(mbox, msg);
-	}
-}
-
-/*
- * Message receiver(workqueue)
- */
-static void mbox_rx_work(struct work_struct *work)
-{
-	struct omap_mbox_queue *mq =
-			container_of(work, struct omap_mbox_queue, work);
-	mbox_msg_t msg;
-	int len;
-
-	while (kfifo_len(&mq->fifo) >= sizeof(msg)) {
-		len = kfifo_out(&mq->fifo, (unsigned char *)&msg, sizeof(msg));
-		WARN_ON(len != sizeof(msg));
-
-		blocking_notifier_call_chain(&mq->mbox->notifier, len,
-								(void *)msg);
-		spin_lock_irq(&mq->lock);
-		if (mq->full) {
-			mq->full = false;
-			omap_mbox_enable_irq(mq->mbox, IRQ_RX);
-		}
-		spin_unlock_irq(&mq->lock);
-	}
-}
-
-/*
- * Mailbox interrupt handler
- */
-static void __mbox_tx_interrupt(struct omap_mbox *mbox)
-{
-	omap_mbox_disable_irq(mbox, IRQ_TX);
-	ack_mbox_irq(mbox, IRQ_TX);
-	tasklet_schedule(&mbox->txq->tasklet);
-}
-
-static void __mbox_rx_interrupt(struct omap_mbox *mbox)
-{
-	struct omap_mbox_queue *mq = mbox->rxq;
-	mbox_msg_t msg;
-	int len;
-
-	while (!mbox_fifo_empty(mbox)) {
-		if (unlikely(kfifo_avail(&mq->fifo) < sizeof(msg))) {
-			omap_mbox_disable_irq(mbox, IRQ_RX);
-			mq->full = true;
-			goto nomem;
-		}
-
-		msg = mbox_fifo_read(mbox);
-
-		len = kfifo_in(&mq->fifo, (unsigned char *)&msg, sizeof(msg));
-		WARN_ON(len != sizeof(msg));
-
-		if (mbox->ops->type == OMAP_MBOX_TYPE1)
-			break;
-	}
-
-	/* no more messages in the fifo. clear IRQ source. */
-	ack_mbox_irq(mbox, IRQ_RX);
-nomem:
-	schedule_work(&mbox->rxq->work);
-}
-
-static irqreturn_t mbox_interrupt(int irq, void *p)
-{
-	struct omap_mbox *mbox = p;
-
-	if (is_mbox_irq(mbox, IRQ_TX))
-		__mbox_tx_interrupt(mbox);
-
-	if (is_mbox_irq(mbox, IRQ_RX))
-		__mbox_rx_interrupt(mbox);
-
-	return IRQ_HANDLED;
-}
-
-static struct omap_mbox_queue *mbox_queue_alloc(struct omap_mbox *mbox,
-					void (*work) (struct work_struct *),
-					void (*tasklet)(unsigned long))
-{
-	struct omap_mbox_queue *mq;
-
-	mq = kzalloc(sizeof(struct omap_mbox_queue), GFP_KERNEL);
-	if (!mq)
-		return NULL;
-
-	spin_lock_init(&mq->lock);
-
-	if (kfifo_alloc(&mq->fifo, mbox_kfifo_size, GFP_KERNEL))
-		goto error;
-
-	if (work)
-		INIT_WORK(&mq->work, work);
-
-	if (tasklet)
-		tasklet_init(&mq->tasklet, tasklet, (unsigned long)mbox);
-	return mq;
-error:
-	kfree(mq);
-	return NULL;
-}
-
-static void mbox_queue_free(struct omap_mbox_queue *q)
-{
-	kfifo_free(&q->fifo);
-	kfree(q);
-}
-
-static int omap_mbox_startup(struct omap_mbox *mbox)
-{
-	int ret = 0;
-	struct omap_mbox_queue *mq;
-
-	mutex_lock(&mbox_configured_lock);
-	if (!mbox_configured++) {
-		if (likely(mbox->ops->startup)) {
-			ret = mbox->ops->startup(mbox);
-			if (unlikely(ret))
-				goto fail_startup;
-		} else
-			goto fail_startup;
-	}
-
-	if (!mbox->use_count++) {
-		ret = request_irq(mbox->irq, mbox_interrupt, IRQF_SHARED,
-							mbox->name, mbox);
-		if (unlikely(ret)) {
-			pr_err("failed to register mailbox interrupt:%d\n",
-									ret);
-			goto fail_request_irq;
-		}
-		mq = mbox_queue_alloc(mbox, NULL, mbox_tx_tasklet);
-		if (!mq) {
-			ret = -ENOMEM;
-			goto fail_alloc_txq;
-		}
-		mbox->txq = mq;
-
-		mq = mbox_queue_alloc(mbox, mbox_rx_work, NULL);
-		if (!mq) {
-			ret = -ENOMEM;
-			goto fail_alloc_rxq;
-		}
-		mbox->rxq = mq;
-		mq->mbox = mbox;
-
-		omap_mbox_enable_irq(mbox, IRQ_RX);
-	}
-	mutex_unlock(&mbox_configured_lock);
-	return 0;
-
-fail_alloc_rxq:
-	mbox_queue_free(mbox->txq);
-fail_alloc_txq:
-	free_irq(mbox->irq, mbox);
-fail_request_irq:
-	if (mbox->ops->shutdown)
-		mbox->ops->shutdown(mbox);
-	mbox->use_count--;
-fail_startup:
-	mbox_configured--;
-	mutex_unlock(&mbox_configured_lock);
-	return ret;
-}
-
-static void omap_mbox_fini(struct omap_mbox *mbox)
-{
-	mutex_lock(&mbox_configured_lock);
-
-	if (!--mbox->use_count) {
-		omap_mbox_disable_irq(mbox, IRQ_RX);
-		free_irq(mbox->irq, mbox);
-		tasklet_kill(&mbox->txq->tasklet);
-		flush_work(&mbox->rxq->work);
-		mbox_queue_free(mbox->txq);
-		mbox_queue_free(mbox->rxq);
-	}
-
-	if (likely(mbox->ops->shutdown)) {
-		if (!--mbox_configured)
-			mbox->ops->shutdown(mbox);
-	}
-
-	mutex_unlock(&mbox_configured_lock);
-}
-
-struct omap_mbox *omap_mbox_get(const char *name, struct notifier_block *nb)
-{
-	struct omap_mbox *_mbox, *mbox = NULL;
-	int i, ret;
-
-	if (!mboxes)
-		return ERR_PTR(-EINVAL);
-
-	for (i = 0; (_mbox = mboxes[i]); i++) {
-		if (!strcmp(_mbox->name, name)) {
-			mbox = _mbox;
-			break;
-		}
-	}
-
-	if (!mbox)
-		return ERR_PTR(-ENOENT);
-
-	if (nb)
-		blocking_notifier_chain_register(&mbox->notifier, nb);
-
-	ret = omap_mbox_startup(mbox);
-	if (ret) {
-		blocking_notifier_chain_unregister(&mbox->notifier, nb);
-		return ERR_PTR(-ENODEV);
-	}
-
-	return mbox;
-}
-EXPORT_SYMBOL(omap_mbox_get);
-
-void omap_mbox_put(struct omap_mbox *mbox, struct notifier_block *nb)
-{
-	blocking_notifier_chain_unregister(&mbox->notifier, nb);
-	omap_mbox_fini(mbox);
-}
-EXPORT_SYMBOL(omap_mbox_put);
-
-static struct class omap_mbox_class = { .name = "mbox", };
-
-int omap_mbox_register(struct device *parent, struct omap_mbox **list)
-{
-	int ret;
-	int i;
-
-	mboxes = list;
-	if (!mboxes)
-		return -EINVAL;
-
-	for (i = 0; mboxes[i]; i++) {
-		struct omap_mbox *mbox = mboxes[i];
-		mbox->dev = device_create(&omap_mbox_class,
-				parent, 0, mbox, "%s", mbox->name);
-		if (IS_ERR(mbox->dev)) {
-			ret = PTR_ERR(mbox->dev);
-			goto err_out;
-		}
-
-		BLOCKING_INIT_NOTIFIER_HEAD(&mbox->notifier);
-	}
-	return 0;
-
-err_out:
-	while (i--)
-		device_unregister(mboxes[i]->dev);
-	return ret;
-}
-EXPORT_SYMBOL(omap_mbox_register);
-
-int omap_mbox_unregister(void)
-{
-	int i;
-
-	if (!mboxes)
-		return -EINVAL;
-
-	for (i = 0; mboxes[i]; i++)
-		device_unregister(mboxes[i]->dev);
-	mboxes = NULL;
-	return 0;
-}
-EXPORT_SYMBOL(omap_mbox_unregister);
-
-static int __init omap_mbox_init(void)
-{
-	int err;
-
-	err = class_register(&omap_mbox_class);
-	if (err)
-		return err;
-
-	/* kfifo size sanity check: alignment and minimal size */
-	mbox_kfifo_size = ALIGN(mbox_kfifo_size, sizeof(mbox_msg_t));
-	mbox_kfifo_size = max_t(unsigned int, mbox_kfifo_size,
-							sizeof(mbox_msg_t));
-
-	return 0;
-}
-subsys_initcall(omap_mbox_init);
-
-static void __exit omap_mbox_exit(void)
-{
-	class_unregister(&omap_mbox_class);
-}
-module_exit(omap_mbox_exit);
-
-MODULE_LICENSE("GPL v2");
-MODULE_DESCRIPTION("omap mailbox: interrupt driven messaging");
-MODULE_AUTHOR("Toshihiro Kobayashi");
-MODULE_AUTHOR("Hiroshi DOYU");
diff --git a/drivers/Kconfig b/drivers/Kconfig
index dbdefa3..7a4fb98 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -134,6 +134,8 @@ source "drivers/hwspinlock/Kconfig"
 
 source "drivers/clocksource/Kconfig"
 
+source "drivers/mailbox/Kconfig"
+
 source "drivers/iommu/Kconfig"
 
 source "drivers/remoteproc/Kconfig"
diff --git a/drivers/Makefile b/drivers/Makefile
index a16a8d0..78f2bf0 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -132,6 +132,7 @@ obj-y				+= clk/
 
 obj-$(CONFIG_HWSPINLOCK)	+= hwspinlock/
 obj-$(CONFIG_NFC)		+= nfc/
+obj-$(CONFIG_MAILBOX)		+= mailbox/
 obj-$(CONFIG_IOMMU_SUPPORT)	+= iommu/
 obj-$(CONFIG_REMOTEPROC)	+= remoteproc/
 obj-$(CONFIG_RPMSG)		+= rpmsg/
diff --git a/drivers/mailbox/Kconfig b/drivers/mailbox/Kconfig
new file mode 100644
index 0000000..937b887
--- /dev/null
+++ b/drivers/mailbox/Kconfig
@@ -0,0 +1,28 @@
+menuconfig MAILBOX
+	bool "Mailbox Hardware Support"
+	help
+	  Mailbox is a framework to control hardware communication between
+	  on-chip processors through queued messages and interrupt driven
+	  signals. Say Y if your platform supports hardware mailboxes.
+
+if MAILBOX
+
+config OMAP_MBOX_FWK
+	tristate "OMAP Mailbox framework support"
+	depends on ARCH_OMAP
+	help
+	  Mailbox implementation for OMAP family chips with hardware for
+	  interprocessor communication involving DSP, IVA1.0 and IVA2 in
+	  OMAP1/2/3; or IPU, IVA HD and DSP in OMAP4. Say Y here if you
+	  want to use OMAP Mailbox framework support.
+
+config OMAP_MBOX_KFIFO_SIZE
+	int "Mailbox kfifo default buffer size (bytes)"
+	depends on OMAP_MBOX_FWK
+	default 256
+	help
+	  Specify the default size of mailbox's kfifo buffers (bytes).
+	  This can also be changed at runtime (via the mbox_kfifo_size
+	  module parameter).
+
+endif
diff --git a/drivers/mailbox/Makefile b/drivers/mailbox/Makefile
new file mode 100644
index 0000000..1040ac5
--- /dev/null
+++ b/drivers/mailbox/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_OMAP_MBOX_FWK) += mailbox.o
diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
new file mode 100644
index 0000000..cae8692
--- /dev/null
+++ b/drivers/mailbox/mailbox.c
@@ -0,0 +1,435 @@
+/*
+ * OMAP mailbox driver
+ *
+ * Copyright (C) 2006-2009 Nokia Corporation. All rights reserved.
+ *
+ * Contact: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include <linux/interrupt.h>
+#include <linux/spinlock.h>
+#include <linux/mutex.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+#include <linux/kfifo.h>
+#include <linux/err.h>
+#include <linux/notifier.h>
+#include <linux/module.h>
+
+#include <linux/platform_data/omap_mailbox.h>
+
+static struct omap_mbox **mboxes;
+
+static int mbox_configured;
+static DEFINE_MUTEX(mbox_configured_lock);
+
+static unsigned int mbox_kfifo_size = CONFIG_OMAP_MBOX_KFIFO_SIZE;
+module_param(mbox_kfifo_size, uint, S_IRUGO);
+MODULE_PARM_DESC(mbox_kfifo_size, "Size of omap's mailbox kfifo (bytes)");
+
+/* Mailbox FIFO handle functions */
+static inline mbox_msg_t mbox_fifo_read(struct omap_mbox *mbox)
+{
+	return mbox->ops->fifo_read(mbox);
+}
+static inline void mbox_fifo_write(struct omap_mbox *mbox, mbox_msg_t msg)
+{
+	mbox->ops->fifo_write(mbox, msg);
+}
+static inline int mbox_fifo_empty(struct omap_mbox *mbox)
+{
+	return mbox->ops->fifo_empty(mbox);
+}
+static inline int mbox_fifo_full(struct omap_mbox *mbox)
+{
+	return mbox->ops->fifo_full(mbox);
+}
+
+/* Mailbox IRQ handle functions */
+static inline void ack_mbox_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq)
+{
+	if (mbox->ops->ack_irq)
+		mbox->ops->ack_irq(mbox, irq);
+}
+static inline int is_mbox_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq)
+{
+	return mbox->ops->is_irq(mbox, irq);
+}
+
+/*
+ * message sender
+ */
+static int __mbox_poll_for_space(struct omap_mbox *mbox)
+{
+	int ret = 0, i = 1000;
+
+	while (mbox_fifo_full(mbox)) {
+		if (mbox->ops->type == OMAP_MBOX_TYPE2)
+			return -1;
+		if (--i == 0)
+			return -1;
+		udelay(1);
+	}
+	return ret;
+}
+
+int omap_mbox_msg_send(struct omap_mbox *mbox, mbox_msg_t msg)
+{
+	struct omap_mbox_queue *mq = mbox->txq;
+	int ret = 0, len;
+
+	spin_lock_bh(&mq->lock);
+
+	if (kfifo_avail(&mq->fifo) < sizeof(msg)) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	if (kfifo_is_empty(&mq->fifo) && !__mbox_poll_for_space(mbox)) {
+		mbox_fifo_write(mbox, msg);
+		goto out;
+	}
+
+	len = kfifo_in(&mq->fifo, (unsigned char *)&msg, sizeof(msg));
+	WARN_ON(len != sizeof(msg));
+
+	tasklet_schedule(&mbox->txq->tasklet);
+
+out:
+	spin_unlock_bh(&mq->lock);
+	return ret;
+}
+EXPORT_SYMBOL(omap_mbox_msg_send);
+
+static void mbox_tx_tasklet(unsigned long tx_data)
+{
+	struct omap_mbox *mbox = (struct omap_mbox *)tx_data;
+	struct omap_mbox_queue *mq = mbox->txq;
+	mbox_msg_t msg;
+	int ret;
+
+	while (kfifo_len(&mq->fifo)) {
+		if (__mbox_poll_for_space(mbox)) {
+			omap_mbox_enable_irq(mbox, IRQ_TX);
+			break;
+		}
+
+		ret = kfifo_out(&mq->fifo, (unsigned char *)&msg,
+								sizeof(msg));
+		WARN_ON(ret != sizeof(msg));
+
+		mbox_fifo_write(mbox, msg);
+	}
+}
+
+/*
+ * Message receiver(workqueue)
+ */
+static void mbox_rx_work(struct work_struct *work)
+{
+	struct omap_mbox_queue *mq =
+			container_of(work, struct omap_mbox_queue, work);
+	mbox_msg_t msg;
+	int len;
+
+	while (kfifo_len(&mq->fifo) >= sizeof(msg)) {
+		len = kfifo_out(&mq->fifo, (unsigned char *)&msg, sizeof(msg));
+		WARN_ON(len != sizeof(msg));
+
+		blocking_notifier_call_chain(&mq->mbox->notifier, len,
+								(void *)msg);
+		spin_lock_irq(&mq->lock);
+		if (mq->full) {
+			mq->full = false;
+			omap_mbox_enable_irq(mq->mbox, IRQ_RX);
+		}
+		spin_unlock_irq(&mq->lock);
+	}
+}
+
+/*
+ * Mailbox interrupt handler
+ */
+static void __mbox_tx_interrupt(struct omap_mbox *mbox)
+{
+	omap_mbox_disable_irq(mbox, IRQ_TX);
+	ack_mbox_irq(mbox, IRQ_TX);
+	tasklet_schedule(&mbox->txq->tasklet);
+}
+
+static void __mbox_rx_interrupt(struct omap_mbox *mbox)
+{
+	struct omap_mbox_queue *mq = mbox->rxq;
+	mbox_msg_t msg;
+	int len;
+
+	while (!mbox_fifo_empty(mbox)) {
+		if (unlikely(kfifo_avail(&mq->fifo) < sizeof(msg))) {
+			omap_mbox_disable_irq(mbox, IRQ_RX);
+			mq->full = true;
+			goto nomem;
+		}
+
+		msg = mbox_fifo_read(mbox);
+
+		len = kfifo_in(&mq->fifo, (unsigned char *)&msg, sizeof(msg));
+		WARN_ON(len != sizeof(msg));
+
+		if (mbox->ops->type == OMAP_MBOX_TYPE1)
+			break;
+	}
+
+	/* no more messages in the fifo. clear IRQ source. */
+	ack_mbox_irq(mbox, IRQ_RX);
+nomem:
+	schedule_work(&mbox->rxq->work);
+}
+
+static irqreturn_t mbox_interrupt(int irq, void *p)
+{
+	struct omap_mbox *mbox = p;
+
+	if (is_mbox_irq(mbox, IRQ_TX))
+		__mbox_tx_interrupt(mbox);
+
+	if (is_mbox_irq(mbox, IRQ_RX))
+		__mbox_rx_interrupt(mbox);
+
+	return IRQ_HANDLED;
+}
+
+static struct omap_mbox_queue *mbox_queue_alloc(struct omap_mbox *mbox,
+					void (*work) (struct work_struct *),
+					void (*tasklet)(unsigned long))
+{
+	struct omap_mbox_queue *mq;
+
+	mq = kzalloc(sizeof(struct omap_mbox_queue), GFP_KERNEL);
+	if (!mq)
+		return NULL;
+
+	spin_lock_init(&mq->lock);
+
+	if (kfifo_alloc(&mq->fifo, mbox_kfifo_size, GFP_KERNEL))
+		goto error;
+
+	if (work)
+		INIT_WORK(&mq->work, work);
+
+	if (tasklet)
+		tasklet_init(&mq->tasklet, tasklet, (unsigned long)mbox);
+	return mq;
+error:
+	kfree(mq);
+	return NULL;
+}
+
+static void mbox_queue_free(struct omap_mbox_queue *q)
+{
+	kfifo_free(&q->fifo);
+	kfree(q);
+}
+
+static int omap_mbox_startup(struct omap_mbox *mbox)
+{
+	int ret = 0;
+	struct omap_mbox_queue *mq;
+
+	mutex_lock(&mbox_configured_lock);
+	if (!mbox_configured++) {
+		if (likely(mbox->ops->startup)) {
+			ret = mbox->ops->startup(mbox);
+			if (unlikely(ret))
+				goto fail_startup;
+		} else
+			goto fail_startup;
+	}
+
+	if (!mbox->use_count++) {
+		ret = request_irq(mbox->irq, mbox_interrupt, IRQF_SHARED,
+							mbox->name, mbox);
+		if (unlikely(ret)) {
+			pr_err("failed to register mailbox interrupt:%d\n",
+									ret);
+			goto fail_request_irq;
+		}
+		mq = mbox_queue_alloc(mbox, NULL, mbox_tx_tasklet);
+		if (!mq) {
+			ret = -ENOMEM;
+			goto fail_alloc_txq;
+		}
+		mbox->txq = mq;
+
+		mq = mbox_queue_alloc(mbox, mbox_rx_work, NULL);
+		if (!mq) {
+			ret = -ENOMEM;
+			goto fail_alloc_rxq;
+		}
+		mbox->rxq = mq;
+		mq->mbox = mbox;
+
+		omap_mbox_enable_irq(mbox, IRQ_RX);
+	}
+	mutex_unlock(&mbox_configured_lock);
+	return 0;
+
+fail_alloc_rxq:
+	mbox_queue_free(mbox->txq);
+fail_alloc_txq:
+	free_irq(mbox->irq, mbox);
+fail_request_irq:
+	if (mbox->ops->shutdown)
+		mbox->ops->shutdown(mbox);
+	mbox->use_count--;
+fail_startup:
+	mbox_configured--;
+	mutex_unlock(&mbox_configured_lock);
+	return ret;
+}
+
+static void omap_mbox_fini(struct omap_mbox *mbox)
+{
+	mutex_lock(&mbox_configured_lock);
+
+	if (!--mbox->use_count) {
+		omap_mbox_disable_irq(mbox, IRQ_RX);
+		free_irq(mbox->irq, mbox);
+		tasklet_kill(&mbox->txq->tasklet);
+		flush_work(&mbox->rxq->work);
+		mbox_queue_free(mbox->txq);
+		mbox_queue_free(mbox->rxq);
+	}
+
+	if (likely(mbox->ops->shutdown)) {
+		if (!--mbox_configured)
+			mbox->ops->shutdown(mbox);
+	}
+
+	mutex_unlock(&mbox_configured_lock);
+}
+
+struct omap_mbox *omap_mbox_get(const char *name, struct notifier_block *nb)
+{
+	struct omap_mbox *_mbox, *mbox = NULL;
+	int i, ret;
+
+	if (!mboxes)
+		return ERR_PTR(-EINVAL);
+
+	for (i = 0; (_mbox = mboxes[i]); i++) {
+		if (!strcmp(_mbox->name, name)) {
+			mbox = _mbox;
+			break;
+		}
+	}
+
+	if (!mbox)
+		return ERR_PTR(-ENOENT);
+
+	if (nb)
+		blocking_notifier_chain_register(&mbox->notifier, nb);
+
+	ret = omap_mbox_startup(mbox);
+	if (ret) {
+		blocking_notifier_chain_unregister(&mbox->notifier, nb);
+		return ERR_PTR(-ENODEV);
+	}
+
+	return mbox;
+}
+EXPORT_SYMBOL(omap_mbox_get);
+
+void omap_mbox_put(struct omap_mbox *mbox, struct notifier_block *nb)
+{
+	blocking_notifier_chain_unregister(&mbox->notifier, nb);
+	omap_mbox_fini(mbox);
+}
+EXPORT_SYMBOL(omap_mbox_put);
+
+static struct class omap_mbox_class = { .name = "mbox", };
+
+int omap_mbox_register(struct device *parent, struct omap_mbox **list)
+{
+	int ret;
+	int i;
+
+	mboxes = list;
+	if (!mboxes)
+		return -EINVAL;
+
+	for (i = 0; mboxes[i]; i++) {
+		struct omap_mbox *mbox = mboxes[i];
+		mbox->dev = device_create(&omap_mbox_class,
+				parent, 0, mbox, "%s", mbox->name);
+		if (IS_ERR(mbox->dev)) {
+			ret = PTR_ERR(mbox->dev);
+			goto err_out;
+		}
+
+		BLOCKING_INIT_NOTIFIER_HEAD(&mbox->notifier);
+	}
+	return 0;
+
+err_out:
+	while (i--)
+		device_unregister(mboxes[i]->dev);
+	return ret;
+}
+EXPORT_SYMBOL(omap_mbox_register);
+
+int omap_mbox_unregister(void)
+{
+	int i;
+
+	if (!mboxes)
+		return -EINVAL;
+
+	for (i = 0; mboxes[i]; i++)
+		device_unregister(mboxes[i]->dev);
+	mboxes = NULL;
+	return 0;
+}
+EXPORT_SYMBOL(omap_mbox_unregister);
+
+static int __init omap_mbox_init(void)
+{
+	int err;
+
+	err = class_register(&omap_mbox_class);
+	if (err)
+		return err;
+
+	/* kfifo size sanity check: alignment and minimal size */
+	mbox_kfifo_size = ALIGN(mbox_kfifo_size, sizeof(mbox_msg_t));
+	mbox_kfifo_size = max_t(unsigned int, mbox_kfifo_size,
+							sizeof(mbox_msg_t));
+
+	return 0;
+}
+subsys_initcall(omap_mbox_init);
+
+static void __exit omap_mbox_exit(void)
+{
+	class_unregister(&omap_mbox_class);
+}
+module_exit(omap_mbox_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("omap mailbox: interrupt driven messaging");
+MODULE_AUTHOR("Toshihiro Kobayashi");
+MODULE_AUTHOR("Hiroshi DOYU");
-- 
1.7.9.5

