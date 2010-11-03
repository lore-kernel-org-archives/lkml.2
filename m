Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954Ab0KCKXm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 06:23:42 -0400
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:21223
	"EHLO DB3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754560Ab0KCKXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 06:23:40 -0400
X-SpamScore: 0
X-BigFish: VS0(zzbb2cK853kzz1202hzz8275bhz2dh2a8h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);(null);(null)
From: Shaohui Xie <b21989@freescale.com>
To: <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        Shaohui Xie <b21989@freescale.com>, Li Yang <leoli@freescale.com>,
        Kumar Gala <kumar.gala@freescale.com>,
        Roy Zang <tie-fei.zang@freescale.com>,
        Alexandre Bounine <alexandre.bounine@idt.com>
Subject: [PATCH 4/4][v2] rapidio, powerpc/85xx: Error interrupt handler for sRIO.
Date: Wed, 3 Nov 2010 17:37:28 +0800
Message-ID: <1288777048-25105-1-git-send-email-b21989@freescale.com>
X-Mailer: git-send-email 1.6.4
X-OriginalArrivalTime: 03 Nov 2010 10:09:10.0618 (UTC) FILETIME=[28B333A0:01CB7B3F]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: de01egw01.freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sRIO controller reports errors to the core with one signal, it uses
register EPWISR to provides the core quick access to where the error occurred.
The EPWISR indicates that there are 4 interrupts sources, port1, port2, message
unit and port write receive, but the sRIO driver does not support port2
for now, still the handler takes care of port2.
Currently the handler only clear error status without any recovery.

Signed-off-by: Shaohui Xie <b21989@freescale.com>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <kumar.gala@freescale.com>
Cc: Roy Zang <tie-fei.zang@freescale.com>
Cc: Alexandre Bounine <alexandre.bounine@idt.com>
---
 arch/powerpc/sysdev/fsl_rio.c |   86 +++++++++++++++++++++++++++++++++++++---
 1 files changed, 79 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/sysdev/fsl_rio.c b/arch/powerpc/sysdev/fsl_rio.c
index a9bc1e8..8de86a8 100644
--- a/arch/powerpc/sysdev/fsl_rio.c
+++ b/arch/powerpc/sysdev/fsl_rio.c
@@ -10,7 +10,7 @@
  * - Added Port-Write message handling
  * - Added Machine Check exception handling
  *
- * Copyright (C) 2007, 2008 Freescale Semiconductor, Inc.
+ * Copyright (C) 2007, 2008, 2010 Freescale Semiconductor, Inc.
  * Zhang Wei <wei.zhang@freescale.com>
  *
  * Copyright 2005 MontaVista Software, Inc.
@@ -47,10 +47,36 @@
 #define IRQ_RIO_RX(m)		(((struct rio_priv *)(m->priv))->rxirq)
 #define IRQ_RIO_PW(m)		(((struct rio_priv *)(m->priv))->pwirq)
 
+/* EPWISR Error match value */
+#define EPWISR_ERR_PINT1	0x80000000
+#define EPWISR_ERR_PINT2	0x40000000
+#define EPWISR_ERR_MU		0x2
+#define EPWISR_ERR_PW		0x1
+
+#define IPWMR_CLEAR_QUEUE      0x00000002
+#define IPWSR_CLEAR		0x98
+#define OMSR_CLEAR		0x1cb3
+#define IMSR_CLEAR		0x491
+#define IDSR_CLEAR		0x91
+#define ODSR_CLEAR		0x1c00
+#define LTLEECSR_ENABLE_ALL	0xFFC000FC
+#define ESCSR_CLEAR		0x07120204
+
+#define RIO_EDCSR		0x0640
+#define PORT2_RIO_EDCSR	0x0680
+#define RIO_IECSR		0x10130
+#define PORT2_RIO_IECSR	0x101B0
+#define RIO_IM0SR		0x13064
+#define RIO_IM1SR		0x13164
+#define RIO_OM0SR		0x13004
+#define RIO_OM1SR		0x13104
+
+#define RIO_EPWISR_OFFSET	0x10010
 #define RIO_ATMU_REGS_OFFSET	0x10c00
 #define RIO_P_MSG_REGS_OFFSET	0x11000
 #define RIO_S_MSG_REGS_OFFSET	0x13000
 #define RIO_ESCSR		0x158
+#define PORT2_RIO_ESCSR	0x178
 #define RIO_CCSR		0x15c
 #define RIO_LTLEDCSR		0x0608
 #define  RIO_LTLEDCSR_IER	0x80000000
@@ -1003,6 +1029,40 @@ fsl_rio_dbell_handler(int irq, void *dev_instance)
 	return IRQ_HANDLED;
 }
 
+static void port_error_handler(struct rio_mport *port, int offset)
+{
+	/*XXX: Error recovery is not implemented, we just clear errors */
+	out_be32((u32 *)(rio_regs_win + RIO_LTLEDCSR), 0);
+
+	if (offset == 0) {
+		out_be32((u32 *)(rio_regs_win + RIO_EDCSR), 0);
+		out_be32((u32 *)(rio_regs_win + RIO_IECSR), 0);
+		out_be32((u32 *)(rio_regs_win + RIO_ESCSR), ESCSR_CLEAR);
+	} else {
+		out_be32((u32 *)(rio_regs_win + PORT2_RIO_EDCSR), 0);
+		out_be32((u32 *)(rio_regs_win + PORT2_RIO_IECSR), 0);
+		out_be32((u32 *)(rio_regs_win + PORT2_RIO_ESCSR), ESCSR_CLEAR);
+	}
+}
+
+static void msg_unit_error_handler(struct rio_mport *port)
+{
+	struct rio_priv *priv = port->priv;
+
+	/*XXX: Error recovery is not implemented, we just clear errors */
+	out_be32((u32 *)(rio_regs_win + RIO_LTLEDCSR), 0);
+
+	out_be32((u32 *)(rio_regs_win + RIO_IM0SR), IMSR_CLEAR);
+	out_be32((u32 *)(rio_regs_win + RIO_IM1SR), IMSR_CLEAR);
+	out_be32((u32 *)(rio_regs_win + RIO_OM0SR), OMSR_CLEAR);
+	out_be32((u32 *)(rio_regs_win + RIO_OM1SR), OMSR_CLEAR);
+
+	out_be32(&priv->msg_regs->odsr, ODSR_CLEAR);
+	out_be32(&priv->msg_regs->dsr, IDSR_CLEAR);
+
+	out_be32(&priv->msg_regs->pwsr, IPWSR_CLEAR);
+}
+
 /**
  * fsl_rio_doorbell_init - MPC85xx doorbell interface init
  * @mport: Master port implementing the inbound doorbell unit
@@ -1082,14 +1142,24 @@ fsl_rio_port_write_handler(int irq, void *dev_instance)
 	ipwsr = in_be32(&priv->msg_regs->pwsr);
 
 	epwisr = in_be32(priv->regs_win + RIO_EPWISR);
-	if (epwisr & 0x80000000) {
+	if (epwisr & EPWISR_ERR_PINT1) {
 		tmp = in_be32(priv->regs_win + RIO_LTLEDCSR);
 		pr_info("RIO_LTLEDCSR = 0x%x\n", tmp);
-		out_be32(priv->regs_win + RIO_LTLEDCSR, 0);
+		port_error_handler(port, 0);
+	}
+
+	if (epwisr & EPWISR_ERR_PINT2) {
+		pr_info("RIO: port2 error\n");
+		port_error_handler(port, 1);
+	}
+
+	if (epwisr & EPWISR_ERR_MU) {
+		pr_info("RIO: message unit error\n");
+		msg_unit_error_handler(port);
 	}
 
-	if (!(epwisr & 0x00000001))
-		return IRQ_HANDLED;
+	if (!(epwisr & EPWISR_ERR_PW))
+		return IRQ_NONE;
 
 #ifdef DEBUG_PW
 	pr_debug("PW Int->IPWMR: 0x%08x IPWSR: 0x%08x (", ipwmr, ipwsr);
@@ -1249,12 +1319,14 @@ static int fsl_rio_port_write_init(struct rio_mport *mport)
 
 
 	/* Hook up port-write handler */
-	rc = request_irq(IRQ_RIO_PW(mport), fsl_rio_port_write_handler, 0,
-			 "port-write", (void *)mport);
+	rc = request_irq(IRQ_RIO_PW(mport), fsl_rio_port_write_handler,
+			IRQF_SHARED, "port-write", (void *)mport);
 	if (rc < 0) {
 		pr_err("MPC85xx RIO: unable to request inbound doorbell irq");
 		goto err_out;
 	}
+	/* Enable Error Interrupt */
+	out_be32((u32 *)(rio_regs_win + RIO_LTLEECSR), LTLEECSR_ENABLE_ALL);
 
 	INIT_WORK(&priv->pw_work, fsl_pw_dpc);
 	spin_lock_init(&priv->pw_fifo_lock);
-- 
1.6.4


