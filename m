Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab2LRNMv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 08:12:51 -0500
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:44298 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754856Ab2LRNM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 08:12:26 -0500
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
Subject: [PATCH 6/9] mailbox: add shared memory mailbox type
Date: Tue, 18 Dec 2012 14:10:09 +0100
Message-ID: <1355836212-17956-7-git-send-email-loic.pallardy-ext@stericsson.com>
X-Mailer: git-send-email 1.7.11.1
In-Reply-To: <1355836212-17956-1-git-send-email-loic.pallardy-ext@stericsson.com>
References: <1355836212-17956-1-git-send-email-loic.pallardy-ext@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some mailboxes are made up of cross interrupts
and associated shared memory.
Shared memory mapping is fixed and cross interrupt/shared
memory relation make impossible the use of virtio.
Mailbox framework must be enough opened to support
any kind of mailbox.

Signed-off-by: Loic Pallardy <loic.pallardy@st.com>
---
 drivers/mailbox/mailbox-omap1.c | 40 +++++++++++++++++++++++++++++++---------
 drivers/mailbox/mailbox-omap2.c | 16 ++++++++++++----
 drivers/mailbox/mailbox.c       | 38 +++++++++++---------------------------
 drivers/mailbox/mailbox.h       | 14 ++++++++------
 4 files changed, 62 insertions(+), 46 deletions(-)

diff --git a/drivers/mailbox/mailbox-omap1.c b/drivers/mailbox/mailbox-omap1.c
index 94e90af..0097342 100644
--- a/drivers/mailbox/mailbox-omap1.c
+++ b/drivers/mailbox/mailbox-omap1.c
@@ -37,6 +37,7 @@ struct omap_mbox1_fifo {
 struct omap_mbox1_priv {
 	struct omap_mbox1_fifo tx_fifo;
 	struct omap_mbox1_fifo rx_fifo;
+	bool empty_flag;
 };
 
 static inline int mbox_read_reg(size_t ofs)
@@ -52,12 +53,12 @@ static inline void mbox_write_reg(u32 val, size_t ofs)
 /* msg */
 static int omap1_mbox_fifo_read(struct mailbox *mbox, struct mailbox_msg *msg)
 {
-	struct omap_mbox1_fifo *fifo =
-		&((struct omap_mbox1_priv *)mbox->priv)->rx_fifo;
+	struct omap_mbox1_priv *priv = (struct omap_mbox1_priv *)mbox->priv;
+	struct omap_mbox1_fifo *fifo = &priv->rx_fifo;
 
 	msg->header = mbox_read_reg(fifo->data);
 	msg->header |= ((mbox_msg_t) mbox_read_reg(fifo->cmd)) << 16;
-
+	priv->empty_flag = false;
 	return 0;
 }
 
@@ -69,12 +70,16 @@ omap1_mbox_fifo_write(struct mailbox *mbox, struct mailbox_msg *msg)
 
 	mbox_write_reg(msg->header & 0xffff, fifo->data);
 	mbox_write_reg(msg->header >> 16, fifo->cmd);
-	return 0
+	return 0;
 }
 
 static int omap1_mbox_fifo_empty(struct mailbox *mbox)
 {
-	return 0;
+	struct omap_mbox1_priv *priv = (struct omap_mbox1_priv *)mbox->priv;
+	if (priv->empty_flag)
+		return 0;
+	else
+		return 1;
 }
 
 static int omap1_mbox_fifo_full(struct mailbox *mbox)
@@ -85,6 +90,18 @@ static int omap1_mbox_fifo_full(struct mailbox *mbox)
 	return mbox_read_reg(fifo->flag);
 }
 
+static int ompa1_mbox_poll_for_space(struct mailbox *mbox)
+{
+	int ret = 0, i = 1000;
+
+	while (omap1_mbox_fifo_full(mbox)) {
+		if (--i == 0)
+			return -1;
+		udelay(1);
+	}
+	return ret;
+}
+
 /* irq */
 static void
 omap1_mbox_enable_irq(struct mailbox *mbox, mailbox_type_t irq)
@@ -103,17 +120,22 @@ omap1_mbox_disable_irq(struct mailbox *mbox, mailbox_type_t irq)
 static int
 omap1_mbox_is_irq(struct mailbox *mbox, mailbox_type_t irq)
 {
+	struct omap_mbox1_priv *priv = (struct omap_mbox1_priv *)mbox->priv;
+
 	if (irq == IRQ_TX)
 		return 0;
+	if (irq == IRQ_RX)
+		priv->empty_flag = true;
+
 	return 1;
 }
 
 static struct mailbox_ops omap1_mbox_ops = {
 	.type           = MBOX_HW_FIFO1_TYPE,
-	.fifo_read      = omap1_mbox_fifo_read,
-	.fifo_write     = omap1_mbox_fifo_write,
-	.fifo_empty     = omap1_mbox_fifo_empty,
-	.fifo_full      = omap1_mbox_fifo_full,
+	.read           = omap1_mbox_fifo_read,
+	.write          = omap1_mbox_fifo_write,
+	.empty     = omap1_mbox_fifo_empty,
+	.poll_for_space = ompa1_mbox_poll_for_space,
 	.enable_irq     = omap1_mbox_enable_irq,
 	.disable_irq    = omap1_mbox_disable_irq,
 	.is_irq         = omap1_mbox_is_irq,
diff --git a/drivers/mailbox/mailbox-omap2.c b/drivers/mailbox/mailbox-omap2.c
index 2299674..7c26bed 100644
--- a/drivers/mailbox/mailbox-omap2.c
+++ b/drivers/mailbox/mailbox-omap2.c
@@ -125,6 +125,14 @@ static int omap2_mbox_fifo_full(struct mailbox *mbox)
 	return mbox_read_reg(fifo->fifo_stat);
 }
 
+static int ompa2_mbox_poll_for_space(struct mailbox *mbox)
+{
+	if (omap2_mbox_fifo_full(mbox))
+		return -1;
+
+	return 0;
+}
+
 /* Mailbox IRQ handle functions */
 static void omap2_mbox_enable_irq(struct mailbox *mbox,
 		mailbox_type_t irq)
@@ -210,10 +218,10 @@ static struct mailbox_ops omap2_mbox_ops = {
 	.type           = MBOX_HW_FIFO2_TYPE,
 	.startup        = omap2_mbox_startup,
 	.shutdown       = omap2_mbox_shutdown,
-	.fifo_read      = omap2_mbox_fifo_read,
-	.fifo_write     = omap2_mbox_fifo_write,
-	.fifo_empty     = omap2_mbox_fifo_empty,
-	.fifo_full      = omap2_mbox_fifo_full,
+	.read           = omap2_mbox_fifo_read,
+	.write          = omap2_mbox_fifo_write,
+	.empty          = omap2_mbox_fifo_empty,
+	.poll_for_space = ompa2_mbox_poll_for_space,
 	.enable_irq     = omap2_mbox_enable_irq,
 	.disable_irq    = omap2_mbox_disable_irq,
 	.ack_irq        = omap2_mbox_ack_irq,
diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
index 8b7d7bd..c0a8e49 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -45,21 +45,17 @@ MODULE_PARM_DESC(mbox_kfifo_size, "Size of mailbox kfifo (bytes)");
 
 
 /* Mailbox FIFO handle functions */
-static inline mbox_msg_t mbox_fifo_read(struct mailbox *mbox, struct mailbox_msg *msg)
+static inline mbox_msg_t mbox_read(struct mailbox *mbox, struct mailbox_msg *msg)
 {
-	return mbox->ops->fifo_read(mbox, msg);
+	return mbox->ops->read(mbox, msg);
 }
-static inline void mbox_fifo_write(struct mailbox *mbox, struct mailbox_msg *msg)
+static inline void mbox_write(struct mailbox *mbox, struct mailbox_msg *msg)
 {
-	mbox->ops->fifo_write(mbox, msg);
+	mbox->ops->write(mbox, msg);
 }
-static inline int mbox_fifo_empty(struct mailbox *mbox)
+static inline int mbox_empty(struct mailbox *mbox)
 {
-	return mbox->ops->fifo_empty(mbox);
-}
-static inline int mbox_fifo_full(struct mailbox *mbox)
-{
-	return mbox->ops->fifo_full(mbox);
+	return mbox->ops->empty(mbox);
 }
 
 /* Mailbox IRQ handle functions */
@@ -78,16 +74,7 @@ static inline int is_mbox_irq(struct mailbox *mbox, mailbox_irq_t irq)
  */
 static int __mbox_poll_for_space(struct mailbox *mbox)
 {
-	int ret = 0, i = 1000;
-
-	while (mbox_fifo_full(mbox)) {
-		if (mbox->ops->type == MBOX_HW_FIFO2_TYPE)
-			return -1;
-		if (--i == 0)
-			return -1;
-		udelay(1);
-	}
-	return ret;
+	return mbox->ops->poll_for_space(mbox);
 }
 
 int mailbox_msg_send(struct mailbox *mbox, struct mailbox_msg *msg)
@@ -103,7 +90,7 @@ int mailbox_msg_send(struct mailbox *mbox, struct mailbox_msg *msg)
 	}
 
 	if (kfifo_is_empty(&mq->fifo) && !__mbox_poll_for_space(mbox)) {
-		mbox_fifo_write(mbox, msg);
+		mbox_write(mbox, msg);
 		goto out;
 	}
 
@@ -182,7 +169,7 @@ static void mbox_tx_tasklet(unsigned long tx_data)
 			msg.pdata = tx_data_buf;
 		}
 
-		mbox_fifo_write(mbox, &msg);
+		mbox_write(mbox, &msg);
 	}
 }
 
@@ -236,7 +223,7 @@ static void __mbox_rx_interrupt(struct mailbox *mbox)
 	struct mailbox_msg msg;
 	int len;
 
-	while (!mbox_fifo_empty(mbox)) {
+	while (!mbox_empty(mbox)) {
 		if (unlikely(kfifo_avail(&mq->fifo) <
 				(sizeof(msg) + CONFIG_MBOX_DATA_SIZE))) {
 			mailbox_disable_irq(mbox, IRQ_RX);
@@ -244,7 +231,7 @@ static void __mbox_rx_interrupt(struct mailbox *mbox)
 			goto nomem;
 		}
 
-		mbox_fifo_read(mbox, &msg);
+		mbox_read(mbox, &msg);
 
 		len = kfifo_in(&mq->fifo, (unsigned char *)&msg, sizeof(msg));
 		WARN_ON(len != sizeof(msg));
@@ -254,9 +241,6 @@ static void __mbox_rx_interrupt(struct mailbox *mbox)
 					msg.size);
 			WARN_ON(len != msg.size);
 		}
-
-		if (mbox->ops->type == MBOX_HW_FIFO1_TYPE)
-			break;
 	}
 
 	/* no more messages in the fifo. clear IRQ source. */
diff --git a/drivers/mailbox/mailbox.h b/drivers/mailbox/mailbox.h
index 0a31c99..f103194 100644
--- a/drivers/mailbox/mailbox.h
+++ b/drivers/mailbox/mailbox.h
@@ -11,18 +11,19 @@
 #include <linux/mailbox.h>
 
 typedef int __bitwise mailbox_type_t;
-#define MBOX_HW_FIFO1_TYPE ((__force mailbox_type_t) 1)
-#define MBOX_HW_FIFO2_TYPE ((__force mailbox_type_t) 2)
+#define MBOX_HW_FIFO1_TYPE	((__force mailbox_type_t) 1)
+#define MBOX_HW_FIFO2_TYPE	((__force mailbox_type_t) 2)
+#define MBOX_SHARED_MEM_TYPE	((__force mailbox_type_t) 3)
 
 struct mailbox_ops {
 	mailbox_type_t        type;
 	int             (*startup)(struct mailbox *mbox);
 	void            (*shutdown)(struct mailbox *mbox);
 	/* fifo */
-	mbox_msg_t      (*fifo_read)(struct mailbox *mbox, struct mailbox_msg *msg);
-	int             (*fifo_write)(struct mailbox *mbox, struct mailbox_msg *msg);
-	int             (*fifo_empty)(struct mailbox *mbox);
-	int             (*fifo_full)(struct mailbox *mbox);
+	int             (*read)(struct mailbox *mbox, struct mailbox_msg *msg);
+	int             (*write)(struct mailbox *mbox, struct mailbox_msg *msg);
+	int             (*empty)(struct mailbox *mbox);
+	int             (*poll_for_space)(struct mailbox *mbox);
 	/* irq */
 	void            (*enable_irq)(struct mailbox *mbox,
 			mailbox_irq_t irq);
@@ -47,6 +48,7 @@ struct mailbox_queue {
 
 struct mailbox {
 	char                    *name;
+	unsigned int            id;
 	unsigned int            irq;
 	struct mailbox_queue  *txq, *rxq;
 	struct mailbox_ops    *ops;
-- 
1.7.11.1

