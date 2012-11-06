Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964893Ab2KFC4a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 21:56:30 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55927 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964865Ab2KFC40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 21:56:26 -0500
From: Omar Ramirez Luna <omar.luna@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Russell King <linux@arm.linux.org.uk>, Tony Lindgren <tony@atomide.com>,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Omar Ramirez Luna <omar.luna@linaro.org>,
        Loic PALLARDY <loic.pallardy@st.com>, Arnd Bergmann <arnd@arndb.de>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dom Cobley <popcornmix@gmail.com>, Wim Van Sebroeck <wim@iguana.be>,
        Linus Walleij <linus.walleij@linaro.org>, Suman Anna <s-anna@ti.com>,
        Juan Gutierrez <jgutierrez@ti.com>,
        Felipe Contreras <felipe.contreras@nokia.com>,
        Tejun Heo <tj@kernel.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: [PATCH v2 2/2] mailbox: split internal header from API header
Date: Mon,  5 Nov 2012 20:55:52 -0600
Message-Id: <1352170552-29564-3-git-send-email-omar.luna@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352170552-29564-1-git-send-email-omar.luna@linaro.org>
References: <1352170552-29564-1-git-send-email-omar.luna@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now internal structures can remain hidden to the user and just API
related functions and defines are made available.

Signed-off-by: Omar Ramirez Luna <omar.luna@linaro.org>
---
 drivers/mailbox/mailbox.c |   34 ++++++++++++++++++++++++++++++++
 drivers/mailbox/mailbox.h |   48 +--------------------------------------------
 include/linux/mailbox.h   |   22 +++++++++++++++++++++
 3 files changed, 57 insertions(+), 47 deletions(-)
 create mode 100644 include/linux/mailbox.h

diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
index 6346ad3..aab9a13 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -116,6 +116,40 @@ out:
 }
 EXPORT_SYMBOL(omap_mbox_msg_send);
 
+void omap_mbox_save_ctx(struct omap_mbox *mbox)
+{
+	if (!mbox->ops->save_ctx) {
+		dev_err(mbox->dev, "%s:\tno save\n", __func__);
+		return;
+	}
+
+	mbox->ops->save_ctx(mbox);
+}
+EXPORT_SYMBOL(omap_mbox_save_ctx);
+
+void omap_mbox_restore_ctx(struct omap_mbox *mbox)
+{
+	if (!mbox->ops->restore_ctx) {
+		dev_err(mbox->dev, "%s:\tno restore\n", __func__);
+		return;
+	}
+
+	mbox->ops->restore_ctx(mbox);
+}
+EXPORT_SYMBOL(omap_mbox_restore_ctx);
+
+void omap_mbox_enable_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq)
+{
+	mbox->ops->enable_irq(mbox, irq);
+}
+EXPORT_SYMBOL(omap_mbox_enable_irq);
+
+void omap_mbox_disable_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq)
+{
+	mbox->ops->disable_irq(mbox, irq);
+}
+EXPORT_SYMBOL(omap_mbox_disable_irq);
+
 static void mbox_tx_tasklet(unsigned long tx_data)
 {
 	struct omap_mbox *mbox = (struct omap_mbox *)tx_data;
diff --git a/drivers/mailbox/mailbox.h b/drivers/mailbox/mailbox.h
index cc3921e..b05f64c 100644
--- a/drivers/mailbox/mailbox.h
+++ b/drivers/mailbox/mailbox.h
@@ -8,17 +8,7 @@
 #include <linux/interrupt.h>
 #include <linux/device.h>
 #include <linux/kfifo.h>
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
+#include <linux/mailbox.h>
 
 struct omap_mbox_ops {
 	omap_mbox_type_t	type;
@@ -61,45 +51,9 @@ struct omap_mbox {
 	struct blocking_notifier_head   notifier;
 };
 
-int omap_mbox_msg_send(struct omap_mbox *, mbox_msg_t msg);
 void omap_mbox_init_seq(struct omap_mbox *);
 
-struct omap_mbox *omap_mbox_get(const char *, struct notifier_block *nb);
-void omap_mbox_put(struct omap_mbox *mbox, struct notifier_block *nb);
-
 int omap_mbox_register(struct device *parent, struct omap_mbox **);
 int omap_mbox_unregister(void);
 
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
 #endif /* MAILBOX_H */
diff --git a/include/linux/mailbox.h b/include/linux/mailbox.h
new file mode 100644
index 0000000..e8e4131
--- /dev/null
+++ b/include/linux/mailbox.h
@@ -0,0 +1,22 @@
+/* mailbox.h */
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
+int omap_mbox_msg_send(struct omap_mbox *, mbox_msg_t msg);
+
+struct omap_mbox *omap_mbox_get(const char *, struct notifier_block *nb);
+void omap_mbox_put(struct omap_mbox *mbox, struct notifier_block *nb);
+
+void omap_mbox_save_ctx(struct omap_mbox *mbox);
+void omap_mbox_restore_ctx(struct omap_mbox *mbox);
+void omap_mbox_enable_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq);
+void omap_mbox_disable_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq);
-- 
1.7.9.5

