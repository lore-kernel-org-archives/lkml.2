Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760219Ab2J2RGg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 13:06:36 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:63594 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756951Ab2J2RGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 13:06:32 -0400
From: Omar Ramirez Luna <omar.luna@linaro.org>
To: Tony Lindgren <tony@atomide.com>
Cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Ohad Ben-Cohen <ohad@wizery.com>, Suman Anna <s-anna@ti.com>,
        Juan Gutierrez <jgutierrez@ti.com>,
        Felipe Contreras <felipe.contreras@nokia.com>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Omar Ramirez Luna <omar.luna@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: [PATCH 1/2] ARM: OMAP2+: move mailbox.h out of plat-omap headers
Date: Mon, 29 Oct 2012 12:06:20 -0500
Message-Id: <1351530381-11459-2-git-send-email-omar.luna@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351530381-11459-1-git-send-email-omar.luna@linaro.org>
References: <1351530381-11459-1-git-send-email-omar.luna@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: devel@driverdev.osuosl.org
Signed-off-by: Omar Ramirez Luna <omar.luna@linaro.org>
---
 arch/arm/mach-omap2/mailbox.c                      |    2 +-
 arch/arm/plat-omap/include/plat/mailbox.h          |  105 --------------------
 arch/arm/plat-omap/mailbox.c                       |    2 +-
 .../tidspbridge/include/dspbridge/host_os.h        |    2 +-
 include/linux/platform_data/omap_mailbox.h         |  105 ++++++++++++++++++++
 5 files changed, 108 insertions(+), 108 deletions(-)
 delete mode 100644 arch/arm/plat-omap/include/plat/mailbox.h
 create mode 100644 include/linux/platform_data/omap_mailbox.h

diff --git a/arch/arm/mach-omap2/mailbox.c b/arch/arm/mach-omap2/mailbox.c
index 0d97456..f69e659 100644
--- a/arch/arm/mach-omap2/mailbox.c
+++ b/arch/arm/mach-omap2/mailbox.c
@@ -17,7 +17,7 @@
 #include <linux/io.h>
 #include <linux/pm_runtime.h>
 
-#include <plat/mailbox.h>
+#include <linux/platform_data/omap_mailbox.h>
 
 #include "soc.h"
 
diff --git a/arch/arm/plat-omap/include/plat/mailbox.h b/arch/arm/plat-omap/include/plat/mailbox.h
deleted file mode 100644
index cc3921e..0000000
--- a/arch/arm/plat-omap/include/plat/mailbox.h
+++ /dev/null
@@ -1,105 +0,0 @@
-/* mailbox.h */
-
-#ifndef MAILBOX_H
-#define MAILBOX_H
-
-#include <linux/spinlock.h>
-#include <linux/workqueue.h>
-#include <linux/interrupt.h>
-#include <linux/device.h>
-#include <linux/kfifo.h>
-
-typedef u32 mbox_msg_t;
-struct omap_mbox;
-
-typedef int __bitwise omap_mbox_irq_t;
-#define IRQ_TX ((__force omap_mbox_irq_t) 1)
-#define IRQ_RX ((__force omap_mbox_irq_t) 2)
-
-typedef int __bitwise omap_mbox_type_t;
-#define OMAP_MBOX_TYPE1 ((__force omap_mbox_type_t) 1)
-#define OMAP_MBOX_TYPE2 ((__force omap_mbox_type_t) 2)
-
-struct omap_mbox_ops {
-	omap_mbox_type_t	type;
-	int		(*startup)(struct omap_mbox *mbox);
-	void		(*shutdown)(struct omap_mbox *mbox);
-	/* fifo */
-	mbox_msg_t	(*fifo_read)(struct omap_mbox *mbox);
-	void		(*fifo_write)(struct omap_mbox *mbox, mbox_msg_t msg);
-	int		(*fifo_empty)(struct omap_mbox *mbox);
-	int		(*fifo_full)(struct omap_mbox *mbox);
-	/* irq */
-	void		(*enable_irq)(struct omap_mbox *mbox,
-						omap_mbox_irq_t irq);
-	void		(*disable_irq)(struct omap_mbox *mbox,
-						omap_mbox_irq_t irq);
-	void		(*ack_irq)(struct omap_mbox *mbox, omap_mbox_irq_t irq);
-	int		(*is_irq)(struct omap_mbox *mbox, omap_mbox_irq_t irq);
-	/* ctx */
-	void		(*save_ctx)(struct omap_mbox *mbox);
-	void		(*restore_ctx)(struct omap_mbox *mbox);
-};
-
-struct omap_mbox_queue {
-	spinlock_t		lock;
-	struct kfifo		fifo;
-	struct work_struct	work;
-	struct tasklet_struct	tasklet;
-	struct omap_mbox	*mbox;
-	bool full;
-};
-
-struct omap_mbox {
-	char			*name;
-	unsigned int		irq;
-	struct omap_mbox_queue	*txq, *rxq;
-	struct omap_mbox_ops	*ops;
-	struct device		*dev;
-	void			*priv;
-	int			use_count;
-	struct blocking_notifier_head   notifier;
-};
-
-int omap_mbox_msg_send(struct omap_mbox *, mbox_msg_t msg);
-void omap_mbox_init_seq(struct omap_mbox *);
-
-struct omap_mbox *omap_mbox_get(const char *, struct notifier_block *nb);
-void omap_mbox_put(struct omap_mbox *mbox, struct notifier_block *nb);
-
-int omap_mbox_register(struct device *parent, struct omap_mbox **);
-int omap_mbox_unregister(void);
-
-static inline void omap_mbox_save_ctx(struct omap_mbox *mbox)
-{
-	if (!mbox->ops->save_ctx) {
-		dev_err(mbox->dev, "%s:\tno save\n", __func__);
-		return;
-	}
-
-	mbox->ops->save_ctx(mbox);
-}
-
-static inline void omap_mbox_restore_ctx(struct omap_mbox *mbox)
-{
-	if (!mbox->ops->restore_ctx) {
-		dev_err(mbox->dev, "%s:\tno restore\n", __func__);
-		return;
-	}
-
-	mbox->ops->restore_ctx(mbox);
-}
-
-static inline void omap_mbox_enable_irq(struct omap_mbox *mbox,
-					omap_mbox_irq_t irq)
-{
-	mbox->ops->enable_irq(mbox, irq);
-}
-
-static inline void omap_mbox_disable_irq(struct omap_mbox *mbox,
-					 omap_mbox_irq_t irq)
-{
-	mbox->ops->disable_irq(mbox, irq);
-}
-
-#endif /* MAILBOX_H */
diff --git a/arch/arm/plat-omap/mailbox.c b/arch/arm/plat-omap/mailbox.c
index 42377ef..cae8692 100644
--- a/arch/arm/plat-omap/mailbox.c
+++ b/arch/arm/plat-omap/mailbox.c
@@ -31,7 +31,7 @@
 #include <linux/notifier.h>
 #include <linux/module.h>
 
-#include <plat/mailbox.h>
+#include <linux/platform_data/omap_mailbox.h>
 
 static struct omap_mbox **mboxes;
 
diff --git a/drivers/staging/tidspbridge/include/dspbridge/host_os.h b/drivers/staging/tidspbridge/include/dspbridge/host_os.h
index 896f157..bff9e3a 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/host_os.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/host_os.h
@@ -41,11 +41,11 @@
 #include <linux/ioport.h>
 #include <linux/platform_device.h>
 #include <linux/clk.h>
-#include <plat/mailbox.h>
 #include <linux/pagemap.h>
 #include <asm/cacheflush.h>
 #include <linux/dma-mapping.h>
 
+#include <linux/platform_data/omap_mailbox.h>
 /* TODO -- Remove, once BP defines them */
 #define INT_DSP_MMU_IRQ        28
 
diff --git a/include/linux/platform_data/omap_mailbox.h b/include/linux/platform_data/omap_mailbox.h
new file mode 100644
index 0000000..cc3921e
--- /dev/null
+++ b/include/linux/platform_data/omap_mailbox.h
@@ -0,0 +1,105 @@
+/* mailbox.h */
+
+#ifndef MAILBOX_H
+#define MAILBOX_H
+
+#include <linux/spinlock.h>
+#include <linux/workqueue.h>
+#include <linux/interrupt.h>
+#include <linux/device.h>
+#include <linux/kfifo.h>
+
+typedef u32 mbox_msg_t;
+struct omap_mbox;
+
+typedef int __bitwise omap_mbox_irq_t;
+#define IRQ_TX ((__force omap_mbox_irq_t) 1)
+#define IRQ_RX ((__force omap_mbox_irq_t) 2)
+
+typedef int __bitwise omap_mbox_type_t;
+#define OMAP_MBOX_TYPE1 ((__force omap_mbox_type_t) 1)
+#define OMAP_MBOX_TYPE2 ((__force omap_mbox_type_t) 2)
+
+struct omap_mbox_ops {
+	omap_mbox_type_t	type;
+	int		(*startup)(struct omap_mbox *mbox);
+	void		(*shutdown)(struct omap_mbox *mbox);
+	/* fifo */
+	mbox_msg_t	(*fifo_read)(struct omap_mbox *mbox);
+	void		(*fifo_write)(struct omap_mbox *mbox, mbox_msg_t msg);
+	int		(*fifo_empty)(struct omap_mbox *mbox);
+	int		(*fifo_full)(struct omap_mbox *mbox);
+	/* irq */
+	void		(*enable_irq)(struct omap_mbox *mbox,
+						omap_mbox_irq_t irq);
+	void		(*disable_irq)(struct omap_mbox *mbox,
+						omap_mbox_irq_t irq);
+	void		(*ack_irq)(struct omap_mbox *mbox, omap_mbox_irq_t irq);
+	int		(*is_irq)(struct omap_mbox *mbox, omap_mbox_irq_t irq);
+	/* ctx */
+	void		(*save_ctx)(struct omap_mbox *mbox);
+	void		(*restore_ctx)(struct omap_mbox *mbox);
+};
+
+struct omap_mbox_queue {
+	spinlock_t		lock;
+	struct kfifo		fifo;
+	struct work_struct	work;
+	struct tasklet_struct	tasklet;
+	struct omap_mbox	*mbox;
+	bool full;
+};
+
+struct omap_mbox {
+	char			*name;
+	unsigned int		irq;
+	struct omap_mbox_queue	*txq, *rxq;
+	struct omap_mbox_ops	*ops;
+	struct device		*dev;
+	void			*priv;
+	int			use_count;
+	struct blocking_notifier_head   notifier;
+};
+
+int omap_mbox_msg_send(struct omap_mbox *, mbox_msg_t msg);
+void omap_mbox_init_seq(struct omap_mbox *);
+
+struct omap_mbox *omap_mbox_get(const char *, struct notifier_block *nb);
+void omap_mbox_put(struct omap_mbox *mbox, struct notifier_block *nb);
+
+int omap_mbox_register(struct device *parent, struct omap_mbox **);
+int omap_mbox_unregister(void);
+
+static inline void omap_mbox_save_ctx(struct omap_mbox *mbox)
+{
+	if (!mbox->ops->save_ctx) {
+		dev_err(mbox->dev, "%s:\tno save\n", __func__);
+		return;
+	}
+
+	mbox->ops->save_ctx(mbox);
+}
+
+static inline void omap_mbox_restore_ctx(struct omap_mbox *mbox)
+{
+	if (!mbox->ops->restore_ctx) {
+		dev_err(mbox->dev, "%s:\tno restore\n", __func__);
+		return;
+	}
+
+	mbox->ops->restore_ctx(mbox);
+}
+
+static inline void omap_mbox_enable_irq(struct omap_mbox *mbox,
+					omap_mbox_irq_t irq)
+{
+	mbox->ops->enable_irq(mbox, irq);
+}
+
+static inline void omap_mbox_disable_irq(struct omap_mbox *mbox,
+					 omap_mbox_irq_t irq)
+{
+	mbox->ops->disable_irq(mbox, irq);
+}
+
+#endif /* MAILBOX_H */
-- 
1.7.9.5

