Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab1B1Uxb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 15:53:31 -0500
Received: from mxout1.idt.com ([157.165.5.25]:58633 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752805Ab1B1Uw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 15:52:29 -0500
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Kumar Gala <galak@kernel.crashing.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Thomas Moll <thomas.moll@sysgo.com>,
        Micha Nelissen <micha@neli.hopto.org>
Subject: [PATCH 1/5] RapidIO: Add architecture specific callbacks
Date: Mon, 28 Feb 2011 15:51:01 -0500
Message-Id: <1298926265-5381-2-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1298926265-5381-1-git-send-email-alexandre.bounine@idt.com>
References: <1298926265-5381-1-git-send-email-alexandre.bounine@idt.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extend number of mport callback functions to eliminate direct linking of
architecture specific mport operations.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
---
 arch/powerpc/sysdev/fsl_rio.c |   52 +++++++++++++++++++++-------------------
 drivers/rapidio/rio.c         |   38 ++++++++++++++++++++---------
 include/linux/rio.h           |   23 ++++++++++++++----
 include/linux/rio_drv.h       |    7 +++--
 4 files changed, 75 insertions(+), 45 deletions(-)

diff --git a/arch/powerpc/sysdev/fsl_rio.c b/arch/powerpc/sysdev/fsl_rio.c
index 8c6cab0..4c28226 100644
--- a/arch/powerpc/sysdev/fsl_rio.c
+++ b/arch/powerpc/sysdev/fsl_rio.c
@@ -482,7 +482,7 @@ fsl_rio_config_write(struct rio_mport *mport, int index, u16 destid,
 }
 
 /**
- * rio_hw_add_outb_message - Add message to the MPC85xx outbound message queue
+ * fsl_add_outb_message - Add message to the MPC85xx outbound message queue
  * @mport: Master port with outbound message queue
  * @rdev: Target of outbound message
  * @mbox: Outbound mailbox
@@ -492,8 +492,8 @@ fsl_rio_config_write(struct rio_mport *mport, int index, u16 destid,
  * Adds the @buffer message to the MPC85xx outbound message queue. Returns
  * %0 on success or %-EINVAL on failure.
  */
-int
-rio_hw_add_outb_message(struct rio_mport *mport, struct rio_dev *rdev, int mbox,
+static int
+fsl_add_outb_message(struct rio_mport *mport, struct rio_dev *rdev, int mbox,
 			void *buffer, size_t len)
 {
 	struct rio_priv *priv = mport->priv;
@@ -502,9 +502,8 @@ rio_hw_add_outb_message(struct rio_mport *mport, struct rio_dev *rdev, int mbox,
 					+ priv->msg_tx_ring.tx_slot;
 	int ret = 0;
 
-	pr_debug
-	    ("RIO: rio_hw_add_outb_message(): destid %4.4x mbox %d buffer %8.8x len %8.8x\n",
-	     rdev->destid, mbox, (int)buffer, len);
+	pr_debug("RIO: fsl_add_outb_message(): destid %4.4x mbox %d buffer " \
+		 "%8.8x len %8.8x\n", rdev->destid, mbox, (int)buffer, len);
 
 	if ((len < 8) || (len > RIO_MAX_MSG_SIZE)) {
 		ret = -EINVAL;
@@ -554,8 +553,6 @@ rio_hw_add_outb_message(struct rio_mport *mport, struct rio_dev *rdev, int mbox,
 	return ret;
 }
 
-EXPORT_SYMBOL_GPL(rio_hw_add_outb_message);
-
 /**
  * fsl_rio_tx_handler - MPC85xx outbound message interrupt handler
  * @irq: Linux interrupt number
@@ -600,7 +597,7 @@ fsl_rio_tx_handler(int irq, void *dev_instance)
 }
 
 /**
- * rio_open_outb_mbox - Initialize MPC85xx outbound mailbox
+ * fsl_open_outb_mbox - Initialize MPC85xx outbound mailbox
  * @mport: Master port implementing the outbound message unit
  * @dev_id: Device specific pointer to pass on event
  * @mbox: Mailbox to open
@@ -610,7 +607,8 @@ fsl_rio_tx_handler(int irq, void *dev_instance)
  * and enables the outbound message unit. Returns %0 on success and
  * %-EINVAL or %-ENOMEM on failure.
  */
-int rio_open_outb_mbox(struct rio_mport *mport, void *dev_id, int mbox, int entries)
+static int
+fsl_open_outb_mbox(struct rio_mport *mport, void *dev_id, int mbox, int entries)
 {
 	int i, j, rc = 0;
 	struct rio_priv *priv = mport->priv;
@@ -706,14 +704,14 @@ int rio_open_outb_mbox(struct rio_mport *mport, void *dev_id, int mbox, int entr
 }
 
 /**
- * rio_close_outb_mbox - Shut down MPC85xx outbound mailbox
+ * fsl_close_outb_mbox - Shut down MPC85xx outbound mailbox
  * @mport: Master port implementing the outbound message unit
  * @mbox: Mailbox to close
  *
  * Disables the outbound message unit, free all buffers, and
  * frees the outbound message interrupt.
  */
-void rio_close_outb_mbox(struct rio_mport *mport, int mbox)
+static void fsl_close_outb_mbox(struct rio_mport *mport, int mbox)
 {
 	struct rio_priv *priv = mport->priv;
 	/* Disable inbound message unit */
@@ -770,7 +768,7 @@ fsl_rio_rx_handler(int irq, void *dev_instance)
 }
 
 /**
- * rio_open_inb_mbox - Initialize MPC85xx inbound mailbox
+ * fsl_open_inb_mbox - Initialize MPC85xx inbound mailbox
  * @mport: Master port implementing the inbound message unit
  * @dev_id: Device specific pointer to pass on event
  * @mbox: Mailbox to open
@@ -780,7 +778,8 @@ fsl_rio_rx_handler(int irq, void *dev_instance)
  * and enables the inbound message unit. Returns %0 on success
  * and %-EINVAL or %-ENOMEM on failure.
  */
-int rio_open_inb_mbox(struct rio_mport *mport, void *dev_id, int mbox, int entries)
+static int
+fsl_open_inb_mbox(struct rio_mport *mport, void *dev_id, int mbox, int entries)
 {
 	int i, rc = 0;
 	struct rio_priv *priv = mport->priv;
@@ -844,14 +843,14 @@ int rio_open_inb_mbox(struct rio_mport *mport, void *dev_id, int mbox, int entri
 }
 
 /**
- * rio_close_inb_mbox - Shut down MPC85xx inbound mailbox
+ * fsl_close_inb_mbox - Shut down MPC85xx inbound mailbox
  * @mport: Master port implementing the inbound message unit
  * @mbox: Mailbox to close
  *
  * Disables the inbound message unit, free all buffers, and
  * frees the inbound message interrupt.
  */
-void rio_close_inb_mbox(struct rio_mport *mport, int mbox)
+static void fsl_close_inb_mbox(struct rio_mport *mport, int mbox)
 {
 	struct rio_priv *priv = mport->priv;
 	/* Disable inbound message unit */
@@ -866,7 +865,7 @@ void rio_close_inb_mbox(struct rio_mport *mport, int mbox)
 }
 
 /**
- * rio_hw_add_inb_buffer - Add buffer to the MPC85xx inbound message queue
+ * fsl_add_inb_buffer - Add buffer to the MPC85xx inbound message queue
  * @mport: Master port implementing the inbound message unit
  * @mbox: Inbound mailbox number
  * @buf: Buffer to add to inbound queue
@@ -874,12 +873,12 @@ void rio_close_inb_mbox(struct rio_mport *mport, int mbox)
  * Adds the @buf buffer to the MPC85xx inbound message queue. Returns
  * %0 on success or %-EINVAL on failure.
  */
-int rio_hw_add_inb_buffer(struct rio_mport *mport, int mbox, void *buf)
+static int fsl_add_inb_buffer(struct rio_mport *mport, int mbox, void *buf)
 {
 	int rc = 0;
 	struct rio_priv *priv = mport->priv;
 
-	pr_debug("RIO: rio_hw_add_inb_buffer(), msg_rx_ring.rx_slot %d\n",
+	pr_debug("RIO: fsl_add_inb_buffer(), msg_rx_ring.rx_slot %d\n",
 		 priv->msg_rx_ring.rx_slot);
 
 	if (priv->msg_rx_ring.virt_buffer[priv->msg_rx_ring.rx_slot]) {
@@ -898,17 +897,15 @@ int rio_hw_add_inb_buffer(struct rio_mport *mport, int mbox, void *buf)
 	return rc;
 }
 
-EXPORT_SYMBOL_GPL(rio_hw_add_inb_buffer);
-
 /**
- * rio_hw_get_inb_message - Fetch inbound message from the MPC85xx message unit
+ * fsl_get_inb_message - Fetch inbound message from the MPC85xx message unit
  * @mport: Master port implementing the inbound message unit
  * @mbox: Inbound mailbox number
  *
  * Gets the next available inbound message from the inbound message queue.
  * A pointer to the message is returned on success or NULL on failure.
  */
-void *rio_hw_get_inb_message(struct rio_mport *mport, int mbox)
+static void *fsl_get_inb_message(struct rio_mport *mport, int mbox)
 {
 	struct rio_priv *priv = mport->priv;
 	u32 phys_buf, virt_buf;
@@ -945,8 +942,6 @@ void *rio_hw_get_inb_message(struct rio_mport *mport, int mbox)
 	return buf;
 }
 
-EXPORT_SYMBOL_GPL(rio_hw_get_inb_message);
-
 /**
  * fsl_rio_dbell_handler - MPC85xx doorbell interrupt handler
  * @irq: Linux interrupt number
@@ -1431,6 +1426,13 @@ int fsl_rio_setup(struct platform_device *dev)
 	ops->cwrite = fsl_rio_config_write;
 	ops->dsend = fsl_rio_doorbell_send;
 	ops->pwenable = fsl_rio_pw_enable;
+	ops->open_outb_mbox = fsl_open_outb_mbox;
+	ops->open_inb_mbox = fsl_open_inb_mbox;
+	ops->close_outb_mbox = fsl_close_outb_mbox;
+	ops->close_inb_mbox = fsl_close_inb_mbox;
+	ops->add_outb_message = fsl_add_outb_message;
+	ops->add_inb_buffer = fsl_add_inb_buffer;
+	ops->get_inb_message = fsl_get_inb_message;
 
 	port = kzalloc(sizeof(struct rio_mport), GFP_KERNEL);
 	if (!port) {
diff --git a/drivers/rapidio/rio.c b/drivers/rapidio/rio.c
index cc2a3b7..d520dba 100644
--- a/drivers/rapidio/rio.c
+++ b/drivers/rapidio/rio.c
@@ -68,9 +68,13 @@ int rio_request_inb_mbox(struct rio_mport *mport,
 			 void (*minb) (struct rio_mport * mport, void *dev_id, int mbox,
 				       int slot))
 {
-	int rc = 0;
+	int rc = -ENOSYS;
+	struct resource *res;
 
-	struct resource *res = kmalloc(sizeof(struct resource), GFP_KERNEL);
+	if (mport->ops->open_inb_mbox == NULL)
+		goto out;
+
+	res = kmalloc(sizeof(struct resource), GFP_KERNEL);
 
 	if (res) {
 		rio_init_mbox_res(res, mbox, mbox);
@@ -88,7 +92,7 @@ int rio_request_inb_mbox(struct rio_mport *mport,
 		/* Hook the inbound message callback */
 		mport->inb_msg[mbox].mcback = minb;
 
-		rc = rio_open_inb_mbox(mport, dev_id, mbox, entries);
+		rc = mport->ops->open_inb_mbox(mport, dev_id, mbox, entries);
 	} else
 		rc = -ENOMEM;
 
@@ -106,10 +110,13 @@ int rio_request_inb_mbox(struct rio_mport *mport,
  */
 int rio_release_inb_mbox(struct rio_mport *mport, int mbox)
 {
-	rio_close_inb_mbox(mport, mbox);
+	if (mport->ops->close_inb_mbox) {
+		mport->ops->close_inb_mbox(mport, mbox);
 
-	/* Release the mailbox resource */
-	return release_resource(mport->inb_msg[mbox].res);
+		/* Release the mailbox resource */
+		return release_resource(mport->inb_msg[mbox].res);
+	} else
+		return -ENOSYS;
 }
 
 /**
@@ -129,9 +136,13 @@ int rio_request_outb_mbox(struct rio_mport *mport,
 			  int entries,
 			  void (*moutb) (struct rio_mport * mport, void *dev_id, int mbox, int slot))
 {
-	int rc = 0;
+	int rc = -ENOSYS;
+	struct resource *res;
 
-	struct resource *res = kmalloc(sizeof(struct resource), GFP_KERNEL);
+	if (mport->ops->open_outb_mbox == NULL)
+		goto out;
+
+	res = kmalloc(sizeof(struct resource), GFP_KERNEL);
 
 	if (res) {
 		rio_init_mbox_res(res, mbox, mbox);
@@ -149,7 +160,7 @@ int rio_request_outb_mbox(struct rio_mport *mport,
 		/* Hook the inbound message callback */
 		mport->outb_msg[mbox].mcback = moutb;
 
-		rc = rio_open_outb_mbox(mport, dev_id, mbox, entries);
+		rc = mport->ops->open_outb_mbox(mport, dev_id, mbox, entries);
 	} else
 		rc = -ENOMEM;
 
@@ -167,10 +178,13 @@ int rio_request_outb_mbox(struct rio_mport *mport,
  */
 int rio_release_outb_mbox(struct rio_mport *mport, int mbox)
 {
-	rio_close_outb_mbox(mport, mbox);
+	if (mport->ops->close_outb_mbox) {
+		mport->ops->close_outb_mbox(mport, mbox);
 
-	/* Release the mailbox resource */
-	return release_resource(mport->outb_msg[mbox].res);
+		/* Release the mailbox resource */
+		return release_resource(mport->outb_msg[mbox].res);
+	} else
+		return -ENOSYS;
 }
 
 /**
diff --git a/include/linux/rio.h b/include/linux/rio.h
index ff681eb..efed116 100644
--- a/include/linux/rio.h
+++ b/include/linux/rio.h
@@ -241,7 +241,7 @@ struct rio_mport {
 	struct rio_msg inb_msg[RIO_MAX_MBOX];
 	struct rio_msg outb_msg[RIO_MAX_MBOX];
 	int host_deviceid;	/* Host device ID */
-	struct rio_ops *ops;	/* maintenance transaction functions */
+	struct rio_ops *ops;	/* low-level architecture-dependent routines */
 	unsigned char id;	/* port ID, unique among all ports */
 	unsigned char index;	/* port index, unique among all port
 				   interfaces of the same type */
@@ -285,6 +285,13 @@ struct rio_net {
  * @cwrite: Callback to perform network write of config space.
  * @dsend: Callback to send a doorbell message.
  * @pwenable: Callback to enable/disable port-write message handling.
+ * @open_outb_mbox: Callback to initialize outbound mailbox.
+ * @close_outb_mbox: Callback to shut down outbound mailbox.
+ * @open_inb_mbox: Callback to initialize inbound mailbox.
+ * @close_inb_mbox: Callback to	shut down inbound mailbox.
+ * @add_outb_message: Callback to add a message to an outbound mailbox queue.
+ * @add_inb_buffer: Callback to	add a buffer to an inbound mailbox queue.
+ * @get_inb_message: Callback to get a message from an inbound mailbox queue.
  */
 struct rio_ops {
 	int (*lcread) (struct rio_mport *mport, int index, u32 offset, int len,
@@ -297,6 +304,16 @@ struct rio_ops {
 			u8 hopcount, u32 offset, int len, u32 data);
 	int (*dsend) (struct rio_mport *mport, int index, u16 destid, u16 data);
 	int (*pwenable) (struct rio_mport *mport, int enable);
+	int (*open_outb_mbox)(struct rio_mport *mport, void *dev_id,
+			      int mbox, int entries);
+	void (*close_outb_mbox)(struct rio_mport *mport, int mbox);
+	int  (*open_inb_mbox)(struct rio_mport *mport, void *dev_id,
+			     int mbox, int entries);
+	void (*close_inb_mbox)(struct rio_mport *mport, int mbox);
+	int  (*add_outb_message)(struct rio_mport *mport, struct rio_dev *rdev,
+				 int mbox, void *buffer, size_t len);
+	int (*add_inb_buffer)(struct rio_mport *mport, int mbox, void *buf);
+	void *(*get_inb_message)(struct rio_mport *mport, int mbox);
 };
 
 #define RIO_RESOURCE_MEM	0x00000100
@@ -380,10 +397,6 @@ union rio_pw_msg {
 /* Architecture and hardware-specific functions */
 extern int rio_init_mports(void);
 extern void rio_register_mport(struct rio_mport *);
-extern int rio_hw_add_outb_message(struct rio_mport *, struct rio_dev *, int,
-				   void *, size_t);
-extern int rio_hw_add_inb_buffer(struct rio_mport *, int, void *);
-extern void *rio_hw_get_inb_message(struct rio_mport *, int);
 extern int rio_open_inb_mbox(struct rio_mport *, void *, int, int);
 extern void rio_close_inb_mbox(struct rio_mport *, int);
 extern int rio_open_outb_mbox(struct rio_mport *, void *, int, int);
diff --git a/include/linux/rio_drv.h b/include/linux/rio_drv.h
index e09e565..229b3ca 100644
--- a/include/linux/rio_drv.h
+++ b/include/linux/rio_drv.h
@@ -317,7 +317,8 @@ static inline int rio_add_outb_message(struct rio_mport *mport,
 				       struct rio_dev *rdev, int mbox,
 				       void *buffer, size_t len)
 {
-	return rio_hw_add_outb_message(mport, rdev, mbox, buffer, len);
+	return mport->ops->add_outb_message(mport, rdev, mbox,
+						   buffer, len);
 }
 
 extern int rio_request_inb_mbox(struct rio_mport *, void *, int, int,
@@ -336,7 +337,7 @@ extern int rio_release_inb_mbox(struct rio_mport *, int);
 static inline int rio_add_inb_buffer(struct rio_mport *mport, int mbox,
 				     void *buffer)
 {
-	return rio_hw_add_inb_buffer(mport, mbox, buffer);
+	return mport->ops->add_inb_buffer(mport, mbox, buffer);
 }
 
 /**
@@ -348,7 +349,7 @@ static inline int rio_add_inb_buffer(struct rio_mport *mport, int mbox,
  */
 static inline void *rio_get_inb_message(struct rio_mport *mport, int mbox)
 {
-	return rio_hw_get_inb_message(mport, mbox);
+	return mport->ops->get_inb_message(mport, mbox);
 }
 
 /* Doorbell management */
-- 
1.7.3.1

