Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990Ab2LRNNj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 08:13:39 -0500
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:46789 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754803Ab2LRNMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 08:12:49 -0500
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
        Loic Pallardy <loic.pallardy-ext@stericsson.com>
Subject: [PATCH 8/9] mailbox: add no_irq send message
Date: Tue, 18 Dec 2012 14:10:11 +0100
Message-ID: <1355836212-17956-9-git-send-email-loic.pallardy-ext@stericsson.com>
X-Mailer: git-send-email 1.7.11.1
In-Reply-To: <1355836212-17956-1-git-send-email-loic.pallardy-ext@stericsson.com>
References: <1355836212-17956-1-git-send-email-loic.pallardy-ext@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For debug purpose, mailbox must be available when
interrupts are disabled to collect dump information.

Signed-off-by: Loic Pallardy <loic.pallardy@st.com>
---
 drivers/mailbox/mailbox.c | 66 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mailbox.h   |  3 +++
 2 files changed, 69 insertions(+)

diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
index 57cb566..2f50226 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -110,6 +110,72 @@ out:
 }
 EXPORT_SYMBOL(mailbox_msg_send);
 
+#define TRANSFER_TIMEOUT 30000 /* Becomes ~3s timeout */
+
+static struct mailbox_msg no_irq_msg_res;
+
+struct mailbox_msg *mailbox_msg_send_receive_no_irq(struct mailbox *mbox,
+		struct mailbox_msg *msg)
+{
+	int ret = 0;
+	int count = 0;
+
+	BUG_ON(!irqs_disabled());
+
+	if (likely(mbox->ops->write && mbox->ops->read)) {
+		if (__mbox_poll_for_space(mbox)) {
+			ret = -EBUSY;
+			goto out;
+		}
+		mbox->ops->write(mbox, msg);
+		while (!is_mbox_irq(mbox, IRQ_RX)) {
+			udelay(100);
+			cpu_relax();
+			count++;
+			if (count > TRANSFER_TIMEOUT) {
+				pr_err("%s: Error: transfer timed out\n",
+						__func__);
+				ret = -EINVAL;
+				goto out;
+			}
+		}
+		mbox->ops->read(mbox, &no_irq_msg_res);
+		ack_mbox_irq(mbox, IRQ_RX);
+	} else {
+		ret = -EINVAL;
+	}
+
+out:
+	BUG_ON(ret < 0);
+
+	return &no_irq_msg_res;
+}
+EXPORT_SYMBOL(mailbox_msg_send_receive_no_irq);
+
+int mailbox_msg_send_no_irq(struct mailbox *mbox,
+		struct mailbox_msg *msg)
+{
+	int ret = 0;
+
+	BUG_ON(!irqs_disabled());
+
+	if (likely(mbox->ops->write)) {
+		if (__mbox_poll_for_space(mbox)) {
+			ret = -EBUSY;
+			goto out;
+		}
+		mbox->ops->write(mbox, msg);
+	} else {
+		ret = -EINVAL;
+	}
+
+out:
+	WARN_ON(ret < 0);
+
+	return ret;
+}
+EXPORT_SYMBOL(mailbox_msg_send_no_irq);
+
 void mailbox_save_ctx(struct mailbox *mbox)
 {
 	if (!mbox->ops->save_ctx) {
diff --git a/include/linux/mailbox.h b/include/linux/mailbox.h
index d256e1a..3f9ec1e 100644
--- a/include/linux/mailbox.h
+++ b/include/linux/mailbox.h
@@ -23,6 +23,9 @@ struct mailbox_msg {
 	MAILBOX_FILL_MSG(_msg, _header, NULL, 0);
 
 int mailbox_msg_send(struct mailbox *, struct mailbox_msg *msg);
+struct mailbox_msg *mailbox_msg_send_receive_no_irq(struct mailbox *,
+		struct mailbox_msg *msg);
+int mailbox_msg_send_no_irq(struct mailbox *, struct mailbox_msg *msg);
 
 struct mailbox *mailbox_get(const char *, struct notifier_block *nb);
 void mailbox_put(struct mailbox *mbox, struct notifier_block *nb);
-- 
1.7.11.1

