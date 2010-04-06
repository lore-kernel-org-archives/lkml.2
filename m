Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435Ab0DFV2k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 17:28:40 -0400
Received: from mxout1.idt.com ([157.165.5.25]:34953 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757336Ab0DFV2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 17:28:31 -0400
Date: Tue, 6 Apr 2010 17:23:22 -0400
From: Alexandre Bounine <abounine@tundra.com>
To: torvalds@linux-foundation.org
Cc: mporter@kernel.crashing.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@lists.ozlabs.org, thomas.moll@sysgo.com,
       abounine@tundra.com
Subject: [PATCH v3 4/6] RapidIO, powerpc/85xx: Add Port-Write message handler for SRIO port
Message-ID: <20100406212322.GD26292@amak.tundra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Alexandre Bounine <alexandre.bounine@idt.com>

Add RapidIO Port-Write message handler for Freescale SoCs with RapidIO port.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Tested-by: Thomas Moll <thomas.moll@sysgo.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
---

 fsl_rio.c |  263 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 260 insertions(+), 3 deletions(-)

diff -x '*.pj' -X dontdiff_2.6.32-rc5 -pNur w34r3a/arch/powerpc/sysdev/fsl_rio.c w34r3b/arch/powerpc/sysdev/fsl_rio.c
--- w34r3a/arch/powerpc/sysdev/fsl_rio.c	2010-04-06 14:51:48.274437000 -0400
+++ w34r3b/arch/powerpc/sysdev/fsl_rio.c	2010-04-06 14:54:05.413394000 -0400
@@ -1,6 +1,11 @@
 /*
  * Freescale MPC85xx/MPC86xx RapidIO support
  *
+ * Copyright 2009 Integrated Device Technology, Inc.
+ * Alex Bounine <alexandre.bounine@idt.com>
+ * - Added Port-Write message handling
+ * - Added Machine Check exception handling
+ *
  * Copyright (C) 2007, 2008 Freescale Semiconductor, Inc.
  * Zhang Wei <wei.zhang@freescale.com>
  *
@@ -23,19 +28,26 @@
 #include <linux/rio_drv.h>
 #include <linux/of_platform.h>
 #include <linux/delay.h>
+#include <linux/kfifo.h>
 
 #include <asm/io.h>
 
+#undef DEBUG_PW	/* Port-Write debugging */
+
 /* RapidIO definition irq, which read from OF-tree */
 #define IRQ_RIO_BELL(m)		(((struct rio_priv *)(m->priv))->bellirq)
 #define IRQ_RIO_TX(m)		(((struct rio_priv *)(m->priv))->txirq)
 #define IRQ_RIO_RX(m)		(((struct rio_priv *)(m->priv))->rxirq)
+#define IRQ_RIO_PW(m)		(((struct rio_priv *)(m->priv))->pwirq)
 
 #define RIO_ATMU_REGS_OFFSET	0x10c00
 #define RIO_P_MSG_REGS_OFFSET	0x11000
 #define RIO_S_MSG_REGS_OFFSET	0x13000
 #define RIO_ESCSR		0x158
 #define RIO_CCSR		0x15c
+#define RIO_LTLEDCSR		0x0608
+#define RIO_LTLEECSR		0x060c
+#define RIO_EPWISR		0x10010
 #define RIO_ISR_AACR		0x10120
 #define RIO_ISR_AACR_AA		0x1	/* Accept All ID */
 #define RIO_MAINT_WIN_SIZE	0x400000
@@ -54,6 +66,18 @@
 #define RIO_MSG_ISR_QFI		0x00000010
 #define RIO_MSG_ISR_DIQI	0x00000001
 
+#define RIO_IPWMR_SEN		0x00100000
+#define RIO_IPWMR_QFIE		0x00000100
+#define RIO_IPWMR_EIE		0x00000020
+#define RIO_IPWMR_CQ		0x00000002
+#define RIO_IPWMR_PWE		0x00000001
+
+#define RIO_IPWSR_QF		0x00100000
+#define RIO_IPWSR_TE		0x00000080
+#define RIO_IPWSR_QFI		0x00000010
+#define RIO_IPWSR_PWD		0x00000008
+#define RIO_IPWSR_PWB		0x00000004
+
 #define RIO_MSG_DESC_SIZE	32
 #define RIO_MSG_BUFFER_SIZE	4096
 #define RIO_MIN_TX_RING_SIZE	2
@@ -120,7 +144,7 @@ struct rio_msg_regs {
 	u32 pad10[26];
 	u32 pwmr;
 	u32 pwsr;
-	u32 pad11;
+	u32 epwqbar;
 	u32 pwqbar;
 };
 
@@ -159,6 +183,14 @@ struct rio_msg_rx_ring {
 	void *dev_id;
 };
 
+struct rio_port_write_msg {
+	void *virt;
+	dma_addr_t phys;
+	u32 msg_count;
+	u32 err_count;
+	u32 discard_count;
+};
+
 struct rio_priv {
 	struct device *dev;
 	void __iomem *regs_win;
@@ -171,9 +203,14 @@ struct rio_priv {
 	struct rio_dbell_ring dbell_ring;
 	struct rio_msg_tx_ring msg_tx_ring;
 	struct rio_msg_rx_ring msg_rx_ring;
+	struct rio_port_write_msg port_write_msg;
 	int bellirq;
 	int txirq;
 	int rxirq;
+	int pwirq;
+	struct work_struct pw_work;
+	struct kfifo pw_fifo;
+	spinlock_t pw_fifo_lock;
 };
 
 /**
@@ -929,6 +966,223 @@ static int fsl_rio_doorbell_init(struct 
 	return rc;
 }
 
+/**
+ * fsl_rio_port_write_handler - MPC85xx port write interrupt handler
+ * @irq: Linux interrupt number
+ * @dev_instance: Pointer to interrupt-specific data
+ *
+ * Handles port write interrupts. Parses a list of registered
+ * port write event handlers and executes a matching event handler.
+ */
+static irqreturn_t
+fsl_rio_port_write_handler(int irq, void *dev_instance)
+{
+	u32 ipwmr, ipwsr;
+	struct rio_mport *port = (struct rio_mport *)dev_instance;
+	struct rio_priv *priv = port->priv;
+	u32 epwisr, tmp;
+
+	ipwmr = in_be32(&priv->msg_regs->pwmr);
+	ipwsr = in_be32(&priv->msg_regs->pwsr);
+
+	epwisr = in_be32(priv->regs_win + RIO_EPWISR);
+	if (epwisr & 0x80000000) {
+		tmp = in_be32(priv->regs_win + RIO_LTLEDCSR);
+		pr_info("RIO_LTLEDCSR = 0x%x\n", tmp);
+		out_be32(priv->regs_win + RIO_LTLEDCSR, 0);
+	}
+
+	if (!(epwisr & 0x00000001))
+		return IRQ_HANDLED;
+
+#ifdef DEBUG_PW
+	pr_debug("PW Int->IPWMR: 0x%08x IPWSR: 0x%08x (", ipwmr, ipwsr);
+	if (ipwsr & RIO_IPWSR_QF)
+		pr_debug(" QF");
+	if (ipwsr & RIO_IPWSR_TE)
+		pr_debug(" TE");
+	if (ipwsr & RIO_IPWSR_QFI)
+		pr_debug(" QFI");
+	if (ipwsr & RIO_IPWSR_PWD)
+		pr_debug(" PWD");
+	if (ipwsr & RIO_IPWSR_PWB)
+		pr_debug(" PWB");
+	pr_debug(" )\n");
+#endif
+	out_be32(&priv->msg_regs->pwsr,
+		 ipwsr & (RIO_IPWSR_TE | RIO_IPWSR_QFI | RIO_IPWSR_PWD));
+
+	if ((ipwmr & RIO_IPWMR_EIE) && (ipwsr & RIO_IPWSR_TE)) {
+		priv->port_write_msg.err_count++;
+		pr_info("RIO: Port-Write Transaction Err (%d)\n",
+			 priv->port_write_msg.err_count);
+	}
+	if (ipwsr & RIO_IPWSR_PWD) {
+		priv->port_write_msg.discard_count++;
+		pr_info("RIO: Port Discarded Port-Write Msg(s) (%d)\n",
+			 priv->port_write_msg.discard_count);
+	}
+
+	/* Schedule deferred processing if PW was received */
+	if (ipwsr & RIO_IPWSR_QFI) {
+		/* Save PW message (if there is room in FIFO),
+		 * otherwise discard it.
+		 */
+		if (kfifo_avail(&priv->pw_fifo) >= RIO_PW_MSG_SIZE) {
+			priv->port_write_msg.msg_count++;
+			kfifo_in(&priv->pw_fifo, priv->port_write_msg.virt,
+				 RIO_PW_MSG_SIZE);
+		} else {
+			priv->port_write_msg.discard_count++;
+			pr_info("RIO: ISR Discarded Port-Write Msg(s) (%d)\n",
+				 priv->port_write_msg.discard_count);
+		}
+		schedule_work(&priv->pw_work);
+	}
+
+	/* Issue Clear Queue command. This allows another
+	 * port-write to be received.
+	 */
+	out_be32(&priv->msg_regs->pwmr, ipwmr | RIO_IPWMR_CQ);
+
+	return IRQ_HANDLED;
+}
+
+static void fsl_pw_dpc(struct work_struct *work)
+{
+	struct rio_priv *priv = container_of(work, struct rio_priv, pw_work);
+	unsigned long flags;
+	u32 msg_buffer[RIO_PW_MSG_SIZE/sizeof(u32)];
+
+	/*
+	 * Process port-write messages
+	 */
+	spin_lock_irqsave(&priv->pw_fifo_lock, flags);
+	while (kfifo_out(&priv->pw_fifo, (unsigned char *)msg_buffer,
+			 RIO_PW_MSG_SIZE)) {
+		/* Process one message */
+		spin_unlock_irqrestore(&priv->pw_fifo_lock, flags);
+#ifdef DEBUG_PW
+		{
+		u32 i;
+		pr_debug("%s : Port-Write Message:", __func__);
+		for (i = 0; i < RIO_PW_MSG_SIZE/sizeof(u32); i++) {
+			if ((i%4) == 0)
+				pr_debug("\n0x%02x: 0x%08x", i*4,
+					 msg_buffer[i]);
+			else
+				pr_debug(" 0x%08x", msg_buffer[i]);
+		}
+		pr_debug("\n");
+		}
+#endif
+		/* Pass the port-write message to RIO core for processing */
+		rio_inb_pwrite_handler((union rio_pw_msg *)msg_buffer);
+		spin_lock_irqsave(&priv->pw_fifo_lock, flags);
+	}
+	spin_unlock_irqrestore(&priv->pw_fifo_lock, flags);
+}
+
+/**
+ * fsl_rio_pw_enable - enable/disable port-write interface init
+ * @mport: Master port implementing the port write unit
+ * @enable:    1=enable; 0=disable port-write message handling
+ */
+static int fsl_rio_pw_enable(struct rio_mport *mport, int enable)
+{
+	struct rio_priv *priv = mport->priv;
+	u32 rval;
+
+	rval = in_be32(&priv->msg_regs->pwmr);
+
+	if (enable)
+		rval |= RIO_IPWMR_PWE;
+	else
+		rval &= ~RIO_IPWMR_PWE;
+
+	out_be32(&priv->msg_regs->pwmr, rval);
+
+	return 0;
+}
+
+/**
+ * fsl_rio_port_write_init - MPC85xx port write interface init
+ * @mport: Master port implementing the port write unit
+ *
+ * Initializes port write unit hardware and DMA buffer
+ * ring. Called from fsl_rio_setup(). Returns %0 on success
+ * or %-ENOMEM on failure.
+ */
+static int fsl_rio_port_write_init(struct rio_mport *mport)
+{
+	struct rio_priv *priv = mport->priv;
+	int rc = 0;
+
+	/* Following configurations require a disabled port write controller */
+	out_be32(&priv->msg_regs->pwmr,
+		 in_be32(&priv->msg_regs->pwmr) & ~RIO_IPWMR_PWE);
+
+	/* Initialize port write */
+	priv->port_write_msg.virt = dma_alloc_coherent(priv->dev,
+					RIO_PW_MSG_SIZE,
+					&priv->port_write_msg.phys, GFP_KERNEL);
+	if (!priv->port_write_msg.virt) {
+		pr_err("RIO: unable allocate port write queue\n");
+		return -ENOMEM;
+	}
+
+	priv->port_write_msg.err_count = 0;
+	priv->port_write_msg.discard_count = 0;
+
+	/* Point dequeue/enqueue pointers at first entry */
+	out_be32(&priv->msg_regs->epwqbar, 0);
+	out_be32(&priv->msg_regs->pwqbar, (u32) priv->port_write_msg.phys);
+
+	pr_debug("EIPWQBAR: 0x%08x IPWQBAR: 0x%08x\n",
+		 in_be32(&priv->msg_regs->epwqbar),
+		 in_be32(&priv->msg_regs->pwqbar));
+
+	/* Clear interrupt status IPWSR */
+	out_be32(&priv->msg_regs->pwsr,
+		 (RIO_IPWSR_TE | RIO_IPWSR_QFI | RIO_IPWSR_PWD));
+
+	/* Configure port write contoller for snooping enable all reporting,
+	   clear queue full */
+	out_be32(&priv->msg_regs->pwmr,
+		 RIO_IPWMR_SEN | RIO_IPWMR_QFIE | RIO_IPWMR_EIE | RIO_IPWMR_CQ);
+
+
+	/* Hook up port-write handler */
+	rc = request_irq(IRQ_RIO_PW(mport), fsl_rio_port_write_handler, 0,
+			 "port-write", (void *)mport);
+	if (rc < 0) {
+		pr_err("MPC85xx RIO: unable to request inbound doorbell irq");
+		goto err_out;
+	}
+
+	INIT_WORK(&priv->pw_work, fsl_pw_dpc);
+	spin_lock_init(&priv->pw_fifo_lock);
+	if (kfifo_alloc(&priv->pw_fifo, RIO_PW_MSG_SIZE * 32, GFP_KERNEL)) {
+		pr_err("FIFO allocation failed\n");
+		rc = -ENOMEM;
+		goto err_out_irq;
+	}
+
+	pr_debug("IPWMR: 0x%08x IPWSR: 0x%08x\n",
+		 in_be32(&priv->msg_regs->pwmr),
+		 in_be32(&priv->msg_regs->pwsr));
+
+	return rc;
+
+err_out_irq:
+	free_irq(IRQ_RIO_PW(mport), (void *)mport);
+err_out:
+	dma_free_coherent(priv->dev, RIO_PW_MSG_SIZE,
+			  priv->port_write_msg.virt,
+			  priv->port_write_msg.phys);
+	return rc;
+}
+
 static char *cmdline = NULL;
 
 static int fsl_rio_get_hdid(int index)
@@ -1066,6 +1320,7 @@ int fsl_rio_setup(struct of_device *dev)
 	ops->cread = fsl_rio_config_read;
 	ops->cwrite = fsl_rio_config_write;
 	ops->dsend = fsl_rio_doorbell_send;
+	ops->pwenable = fsl_rio_pw_enable;
 
 	port = kzalloc(sizeof(struct rio_mport), GFP_KERNEL);
 	if (!port) {
@@ -1088,11 +1343,12 @@ int fsl_rio_setup(struct of_device *dev)
 	port->iores.flags = IORESOURCE_MEM;
 	port->iores.name = "rio_io_win";
 
+	priv->pwirq   = irq_of_parse_and_map(dev->node, 0);
 	priv->bellirq = irq_of_parse_and_map(dev->node, 2);
 	priv->txirq = irq_of_parse_and_map(dev->node, 3);
 	priv->rxirq = irq_of_parse_and_map(dev->node, 4);
-	dev_info(&dev->dev, "bellirq: %d, txirq: %d, rxirq %d\n", priv->bellirq,
-				priv->txirq, priv->rxirq);
+	dev_info(&dev->dev, "pwirq: %d, bellirq: %d, txirq: %d, rxirq %d\n",
+		 priv->pwirq, priv->bellirq, priv->txirq, priv->rxirq);
 
 	rio_init_dbell_res(&port->riores[RIO_DOORBELL_RESOURCE], 0, 0xffff);
 	rio_init_mbox_res(&port->riores[RIO_INB_MBOX_RESOURCE], 0, 0);
@@ -1174,6 +1430,7 @@ int fsl_rio_setup(struct of_device *dev)
 			(law_start + RIO_MAINT_WIN_SIZE) >> 12);
 	out_be32(&priv->dbell_atmu_regs->rowar, 0x8004200b);	/* 4k */
 	fsl_rio_doorbell_init(port);
+	fsl_rio_port_write_init(port);
 
 	return 0;
 err:
