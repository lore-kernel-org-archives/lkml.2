Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab2LRNM0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 08:12:26 -0500
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:55940 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754795Ab2LRNMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 08:12:23 -0500
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
Subject: [PATCH 4/9] mailbox: create opened message type
Date: Tue, 18 Dec 2012 14:10:07 +0100
Message-ID: <1355836212-17956-5-git-send-email-loic.pallardy-ext@stericsson.com>
X-Mailer: git-send-email 1.7.11.1
In-Reply-To: <1355836212-17956-1-git-send-email-loic.pallardy-ext@stericsson.com>
References: <1355836212-17956-1-git-send-email-loic.pallardy-ext@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current message type is a u32 to fit HW fifo format.
This should be extended to support any message exchanges
and type of mailbox.
Propose structure owns the original u32 and an optional
pointer on additional data.

Signed-off-by: Loic Pallardy <loic.pallardy@st.com>
---
 drivers/mailbox/Kconfig         |  9 ++++++
 drivers/mailbox/mailbox-omap1.c | 18 ++++++------
 drivers/mailbox/mailbox-omap2.c | 10 ++++---
 drivers/mailbox/mailbox.c       | 64 +++++++++++++++++++++++++++++------------
 drivers/mailbox/mailbox.h       |  6 ++--
 include/linux/mailbox.h         | 17 ++++++++++-
 6 files changed, 89 insertions(+), 35 deletions(-)

diff --git a/drivers/mailbox/Kconfig b/drivers/mailbox/Kconfig
index d1e7d74..efb766f 100644
--- a/drivers/mailbox/Kconfig
+++ b/drivers/mailbox/Kconfig
@@ -33,4 +33,13 @@ config MBOX_KFIFO_SIZE
          This can also be changed at runtime (via the mbox_kfifo_size
          module parameter).
 
+config MBOX_DATA_SIZE
+	int "Mailbox associated data max size (bytes)"
+	default 64
+	help
+	  Specify the default size of mailbox's associated data buffer
+	  (bytes)
+          This can also be changed at runtime (via the mbox_kfifo_size
+          module parameter).
+
 endif
diff --git a/drivers/mailbox/mailbox-omap1.c b/drivers/mailbox/mailbox-omap1.c
index 31cb70a..94e90af 100644
--- a/drivers/mailbox/mailbox-omap1.c
+++ b/drivers/mailbox/mailbox-omap1.c
@@ -50,26 +50,26 @@ static inline void mbox_write_reg(u32 val, size_t ofs)
 }
 
 /* msg */
-static mbox_msg_t omap1_mbox_fifo_read(struct mailbox *mbox)
+static int omap1_mbox_fifo_read(struct mailbox *mbox, struct mailbox_msg *msg)
 {
 	struct omap_mbox1_fifo *fifo =
 		&((struct omap_mbox1_priv *)mbox->priv)->rx_fifo;
-	mbox_msg_t msg;
 
-	msg = mbox_read_reg(fifo->data);
-	msg |= ((mbox_msg_t) mbox_read_reg(fifo->cmd)) << 16;
+	msg->header = mbox_read_reg(fifo->data);
+	msg->header |= ((mbox_msg_t) mbox_read_reg(fifo->cmd)) << 16;
 
-	return msg;
+	return 0;
 }
 
-static void
-omap1_mbox_fifo_write(struct mailbox *mbox, mbox_msg_t msg)
+static int
+omap1_mbox_fifo_write(struct mailbox *mbox, struct mailbox_msg *msg)
 {
 	struct omap_mbox1_fifo *fifo =
 		&((struct omap_mbox1_priv *)mbox->priv)->tx_fifo;
 
-	mbox_write_reg(msg & 0xffff, fifo->data);
-	mbox_write_reg(msg >> 16, fifo->cmd);
+	mbox_write_reg(msg->header & 0xffff, fifo->data);
+	mbox_write_reg(msg->header >> 16, fifo->cmd);
+	return 0
 }
 
 static int omap1_mbox_fifo_empty(struct mailbox *mbox)
diff --git a/drivers/mailbox/mailbox-omap2.c b/drivers/mailbox/mailbox-omap2.c
index 230d9d3..2299674 100644
--- a/drivers/mailbox/mailbox-omap2.c
+++ b/drivers/mailbox/mailbox-omap2.c
@@ -95,18 +95,20 @@ static void omap2_mbox_shutdown(struct mailbox *mbox)
 }
 
 /* Mailbox FIFO handle functions */
-static mbox_msg_t omap2_mbox_fifo_read(struct mailbox *mbox)
+static int omap2_mbox_fifo_read(struct mailbox *mbox, struct mailbox_msg *msg)
 {
 	struct omap_mbox2_fifo *fifo =
 		&((struct omap_mbox2_priv *)mbox->priv)->rx_fifo;
-	return (mbox_msg_t) mbox_read_reg(fifo->msg);
+	msg->header = mbox_read_reg(fifo->msg);
+	return 0;
 }
 
-static void omap2_mbox_fifo_write(struct mailbox *mbox, mbox_msg_t msg)
+static int omap2_mbox_fifo_write(struct mailbox *mbox, struct mailbox_msg *msg)
 {
 	struct omap_mbox2_fifo *fifo =
 		&((struct omap_mbox2_priv *)mbox->priv)->tx_fifo;
-	mbox_write_reg(msg, fifo->msg);
+	mbox_write_reg(msg->header, fifo->msg);
+	return 0;
 }
 
 static int omap2_mbox_fifo_empty(struct mailbox *mbox)
diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
index b9389c6..727e67e 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -43,12 +43,13 @@ static unsigned int mbox_kfifo_size = CONFIG_MBOX_KFIFO_SIZE;
 module_param(mbox_kfifo_size, uint, S_IRUGO);
 MODULE_PARM_DESC(mbox_kfifo_size, "Size of mailbox kfifo (bytes)");
 
+
 /* Mailbox FIFO handle functions */
-static inline mbox_msg_t mbox_fifo_read(struct mailbox *mbox)
+static inline mbox_msg_t mbox_fifo_read(struct mailbox *mbox, struct mailbox_msg *msg)
 {
-	return mbox->ops->fifo_read(mbox);
+	return mbox->ops->fifo_read(mbox, msg);
 }
-static inline void mbox_fifo_write(struct mailbox *mbox, mbox_msg_t msg)
+static inline void mbox_fifo_write(struct mailbox *mbox, struct mailbox_msg *msg)
 {
 	mbox->ops->fifo_write(mbox, msg);
 }
@@ -89,14 +90,14 @@ static int __mbox_poll_for_space(struct mailbox *mbox)
 	return ret;
 }
 
-int mailbox_msg_send(struct mailbox *mbox, mbox_msg_t msg)
+int mailbox_msg_send(struct mailbox *mbox, struct mailbox_msg *msg)
 {
 	struct mailbox_queue *mq = mbox->txq;
 	int ret = 0, len;
 
 	spin_lock_bh(&mq->lock);
 
-	if (kfifo_avail(&mq->fifo) < sizeof(msg)) {
+	if (kfifo_avail(&mq->fifo) < (sizeof(msg) + msg->size)) {
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -106,9 +107,14 @@ int mailbox_msg_send(struct mailbox *mbox, mbox_msg_t msg)
 		goto out;
 	}
 
-	len = kfifo_in(&mq->fifo, (unsigned char *)&msg, sizeof(msg));
+	len = kfifo_in(&mq->fifo, (unsigned char *)msg, sizeof(msg));
 	WARN_ON(len != sizeof(msg));
 
+	if (msg->size && msg->pdata) {
+		len = kfifo_in(&mq->fifo, (unsigned char *)msg->pdata, msg->size);
+		WARN_ON(len != msg->size);
+	}
+
 	tasklet_schedule(&mbox->txq->tasklet);
 
 out:
@@ -151,11 +157,13 @@ void mailbox_disable_irq(struct mailbox *mbox, mailbox_irq_t irq)
 }
 EXPORT_SYMBOL(mailbox_disable_irq);
 
+static unsigned char tx_data_buf[CONFIG_MBOX_DATA_SIZE];
+
 static void mbox_tx_tasklet(unsigned long tx_data)
 {
 	struct mailbox *mbox = (struct mailbox *)tx_data;
 	struct mailbox_queue *mq = mbox->txq;
-	mbox_msg_t msg;
+	struct mailbox_msg msg;
 	int ret;
 
 	while (kfifo_len(&mq->fifo)) {
@@ -168,30 +176,44 @@ static void mbox_tx_tasklet(unsigned long tx_data)
 				sizeof(msg));
 		WARN_ON(ret != sizeof(msg));
 
-		mbox_fifo_write(mbox, msg);
+		if (msg.size) {
+			ret = kfifo_out(&mq->fifo, tx_data_buf,	sizeof(msg.size));
+			WARN_ON(ret != msg.size);
+			msg.pdata = tx_data_buf;
+		}
+
+		mbox_fifo_write(mbox, &msg);
 	}
 }
 
 /*
  * Message receiver(workqueue)
  */
+static unsigned char rx_work_data[CONFIG_MBOX_DATA_SIZE];
+
 static void mbox_rx_work(struct work_struct *work)
 {
 	struct mailbox_queue *mq =
 		container_of(work, struct mailbox_queue, work);
-	mbox_msg_t msg;
 	int len;
+	struct mailbox *mbox = mq->mbox;
+	struct mailbox_msg msg;
 
 	while (kfifo_len(&mq->fifo) >= sizeof(msg)) {
 		len = kfifo_out(&mq->fifo, (unsigned char *)&msg, sizeof(msg));
 		WARN_ON(len != sizeof(msg));
 
-		blocking_notifier_call_chain(&mq->mbox->notifier, len,
-				(void *)msg);
+		if (msg.size) {
+			len = kfifo_out(&mq->fifo, rx_work_data, msg.size);
+			WARN_ON(len != msg.size);
+			msg.pdata = rx_work_data;
+		}
+
+		blocking_notifier_call_chain(&mbox->notifier, len, (void *)&msg);
 		spin_lock_irq(&mq->lock);
 		if (mq->full) {
 			mq->full = false;
-			mailbox_enable_irq(mq->mbox, IRQ_RX);
+			mailbox_enable_irq(mbox, IRQ_RX);
 		}
 		spin_unlock_irq(&mq->lock);
 	}
@@ -210,21 +232,28 @@ static void __mbox_tx_interrupt(struct mailbox *mbox)
 static void __mbox_rx_interrupt(struct mailbox *mbox)
 {
 	struct mailbox_queue *mq = mbox->rxq;
-	mbox_msg_t msg;
+	struct mailbox_msg msg;
 	int len;
 
 	while (!mbox_fifo_empty(mbox)) {
-		if (unlikely(kfifo_avail(&mq->fifo) < sizeof(msg))) {
+		if (unlikely(kfifo_avail(&mq->fifo) <
+				(sizeof(msg) + CONFIG_MBOX_DATA_SIZE))) {
 			mailbox_disable_irq(mbox, IRQ_RX);
 			mq->full = true;
 			goto nomem;
 		}
 
-		msg = mbox_fifo_read(mbox);
+		mbox_fifo_read(mbox, &msg);
 
 		len = kfifo_in(&mq->fifo, (unsigned char *)&msg, sizeof(msg));
 		WARN_ON(len != sizeof(msg));
 
+		if (msg.pdata && msg.size) {
+			len = kfifo_in(&mq->fifo, (unsigned char *)msg.pdata,
+					msg.size);
+			WARN_ON(len != msg.size);
+		}
+
 		if (mbox->ops->type == MBOX_HW_FIFO1_TYPE)
 			break;
 	}
@@ -450,10 +479,9 @@ static int __init mailbox_init(void)
 		return err;
 
 	/* kfifo size sanity check: alignment and minimal size */
-	mbox_kfifo_size = ALIGN(mbox_kfifo_size, sizeof(mbox_msg_t));
+	mbox_kfifo_size = ALIGN(mbox_kfifo_size, sizeof(struct mailbox_msg));
 	mbox_kfifo_size = max_t(unsigned int, mbox_kfifo_size,
-			sizeof(mbox_msg_t));
-
+			sizeof(struct mailbox_msg) + CONFIG_MBOX_DATA_SIZE);
 	return 0;
 }
 subsys_initcall(mailbox_init);
diff --git a/drivers/mailbox/mailbox.h b/drivers/mailbox/mailbox.h
index 530f191..23ac551 100644
--- a/drivers/mailbox/mailbox.h
+++ b/drivers/mailbox/mailbox.h
@@ -19,8 +19,8 @@ struct mailbox_ops {
 	int             (*startup)(struct mailbox *mbox);
 	void            (*shutdown)(struct mailbox *mbox);
 	/* fifo */
-	mbox_msg_t      (*fifo_read)(struct mailbox *mbox);
-	void            (*fifo_write)(struct mailbox *mbox, mbox_msg_t msg);
+	mbox_msg_t      (*fifo_read)(struct mailbox *mbox, struct mailbox_msg *msg);
+	int             (*fifo_write)(struct mailbox *mbox, struct mailbox_msg *msg);
 	int             (*fifo_empty)(struct mailbox *mbox);
 	int             (*fifo_full)(struct mailbox *mbox);
 	/* irq */
@@ -40,7 +40,7 @@ struct mailbox_queue {
 	struct kfifo            fifo;
 	struct work_struct      work;
 	struct tasklet_struct   tasklet;
-	struct mailbox        *mbox;
+	struct mailbox          *mbox;
 	bool full;
 };
 
diff --git a/include/linux/mailbox.h b/include/linux/mailbox.h
index 18c9502..d256e1a 100644
--- a/include/linux/mailbox.h
+++ b/include/linux/mailbox.h
@@ -7,7 +7,22 @@ typedef int __bitwise mailbox_irq_t;
 #define IRQ_TX ((__force mailbox_irq_t) 1)
 #define IRQ_RX ((__force mailbox_irq_t) 2)
 
-int mailbox_msg_send(struct mailbox *, mbox_msg_t msg);
+struct mailbox_msg {
+	int		size;
+	u32		header;
+	void		*pdata;
+};
+
+#define MAILBOX_FILL_MSG(_msg, _header, _pdata, _size) { \
+	_msg.header = _header; \
+	_msg.pdata = (void *)_pdata; \
+	_msg.size = _size; \
+}
+
+#define MAILBOX_FILL_HEADER_MSG(_msg, _header) \
+	MAILBOX_FILL_MSG(_msg, _header, NULL, 0);
+
+int mailbox_msg_send(struct mailbox *, struct mailbox_msg *msg);
 
 struct mailbox *mailbox_get(const char *, struct notifier_block *nb);
 void mailbox_put(struct mailbox *mbox, struct notifier_block *nb);
-- 
1.7.11.1

