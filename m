Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab2LRNL6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 08:11:58 -0500
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:59277 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754795Ab2LRNLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 08:11:55 -0500
From: Loic Pallardy <loic.pallardy-ext@stericsson.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Russell King <linux@arm.linux.org.uk>, Tony Lindgren <tony@atomide.com>,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Omar Ramirez Luna <omar.ramirez@copitl.com>,
        Loic PALLARDY <loic.pallardy@st.com>, Arnd Bergmann <arnd@arndb.de>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dom Cobley <popcornmix@gmail.com>, Wim Van Sebroeck <wim@iguana.be>,
        Linus Walleij <linus.walleij@linaro.org>, Suman Anna <s-anna@ti.com>,
        Juan Gutierrez <jgutierrez@ti.com>,
        Felipe Contreras <felipe.contreras@nokia.com>,
        Tejun Heo <tj@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        Loic Pallardy <loic.pallardy-ext@stericsson.com>,
        Omar Ramirez Luna <omar.luna@linaro.org>
Subject: [PATCH 2/9] mailbox: split internal header from API header
Date: Tue, 18 Dec 2012 14:10:05 +0100
Message-ID: <1355836212-17956-3-git-send-email-loic.pallardy-ext@stericsson.com>
X-Mailer: git-send-email 1.7.11.1
In-Reply-To: <1355836212-17956-1-git-send-email-loic.pallardy-ext@stericsson.com>
References: <1355836212-17956-1-git-send-email-loic.pallardy-ext@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now internal structures can remain hidden to the user and just API
related functions and defines are made available.

Signed-off-by: Omar Ramirez Luna <omar.luna@linaro.org>
---
 drivers/mailbox/mailbox.c | 34 ++++++++++++++++++++++++++++++++++
 drivers/mailbox/mailbox.h | 44 +-------------------------------------------
 include/linux/mailbox.h   | 18 ++++++++++++++++++
 3 files changed, 53 insertions(+), 43 deletions(-)
 create mode 100644 include/linux/mailbox.h

diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
index aec291d0..8cb3b15 100644
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
index 88a9f6a..bf3c1b4 100644
--- a/drivers/mailbox/mailbox.h
+++ b/drivers/mailbox/mailbox.h
@@ -8,13 +8,7 @@
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
+#include <linux/mailbox.h>
 
 typedef int __bitwise omap_mbox_type_t;
 #define OMAP_MBOX_TYPE1 ((__force omap_mbox_type_t) 1)
@@ -61,45 +55,9 @@ struct omap_mbox {
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
-		omap_mbox_irq_t irq)
-{
-	mbox->ops->enable_irq(mbox, irq);
-}
-
-static inline void omap_mbox_disable_irq(struct omap_mbox *mbox,
-		omap_mbox_irq_t irq)
-{
-	mbox->ops->disable_irq(mbox, irq);
-}
-
 #endif /* MAILBOX_H */
diff --git a/include/linux/mailbox.h b/include/linux/mailbox.h
new file mode 100644
index 0000000..78ef848
--- /dev/null
+++ b/include/linux/mailbox.h
@@ -0,0 +1,18 @@
+/* mailbox.h */
+
+typedef u32 mbox_msg_t;
+struct omap_mbox;
+
+typedef int __bitwise omap_mbox_irq_t;
+#define IRQ_TX ((__force omap_mbox_irq_t) 1)
+#define IRQ_RX ((__force omap_mbox_irq_t) 2)
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
1.7.11.1

