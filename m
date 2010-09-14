Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab0INPCx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 11:02:53 -0400
Received: from mxout1.idt.com ([157.165.5.25]:56587 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753983Ab0INPCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 11:02:46 -0400
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Thomas Moll <thomas.moll@sysgo.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Kumar Gala <galak@kernel.crashing.org>,
        Micha Nelissen <micha@neli.hopto.org>
Subject: [PATCH v2 02/10] RapidIO:powerpc/85xx: Modify RIO port-write interrupt handler
Date: Tue, 14 Sep 2010 10:59:15 -0400
Message-Id: <1284476363-1677-3-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.0.5
In-Reply-To: <1284476363-1677-1-git-send-email-alexandre.bounine@idt.com>
References: <1284476363-1677-1-git-send-email-alexandre.bounine@idt.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Rearranged RIO port-write interrupt handling to perform message buffering
as soon as possible.
- Modified to disable port-write controller when clearing Transaction Error (TE)
bit.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Thomas Moll <thomas.moll@sysgo.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Micha Nelissen <micha@neli.hopto.org>
---
 arch/powerpc/sysdev/fsl_rio.c |   68 +++++++++++++++++++++++-----------------
 1 files changed, 39 insertions(+), 29 deletions(-)

diff --git a/arch/powerpc/sysdev/fsl_rio.c b/arch/powerpc/sysdev/fsl_rio.c
index 3017532..551e8e2 100644
--- a/arch/powerpc/sysdev/fsl_rio.c
+++ b/arch/powerpc/sysdev/fsl_rio.c
@@ -87,6 +87,9 @@
 #define RIO_IPWSR_PWD		0x00000008
 #define RIO_IPWSR_PWB		0x00000004
 
+#define RIO_EPWISR_PINT		0x80000000
+#define RIO_EPWISR_PW		0x00000001
+
 #define RIO_MSG_DESC_SIZE	32
 #define RIO_MSG_BUFFER_SIZE	4096
 #define RIO_MIN_TX_RING_SIZE	2
@@ -1067,18 +1070,12 @@ fsl_rio_port_write_handler(int irq, void *dev_instance)
 	struct rio_priv *priv = port->priv;
 	u32 epwisr, tmp;
 
-	ipwmr = in_be32(&priv->msg_regs->pwmr);
-	ipwsr = in_be32(&priv->msg_regs->pwsr);
-
 	epwisr = in_be32(priv->regs_win + RIO_EPWISR);
-	if (epwisr & 0x80000000) {
-		tmp = in_be32(priv->regs_win + RIO_LTLEDCSR);
-		pr_info("RIO_LTLEDCSR = 0x%x\n", tmp);
-		out_be32(priv->regs_win + RIO_LTLEDCSR, 0);
-	}
+	if (!(epwisr & RIO_EPWISR_PW))
+		goto pw_done;
 
-	if (!(epwisr & 0x00000001))
-		return IRQ_HANDLED;
+	ipwmr = in_be32(&priv->msg_regs->pwmr);
+	ipwsr = in_be32(&priv->msg_regs->pwsr);
 
 #ifdef DEBUG_PW
 	pr_debug("PW Int->IPWMR: 0x%08x IPWSR: 0x%08x (", ipwmr, ipwsr);
@@ -1094,20 +1091,6 @@ fsl_rio_port_write_handler(int irq, void *dev_instance)
 		pr_debug(" PWB");
 	pr_debug(" )\n");
 #endif
-	out_be32(&priv->msg_regs->pwsr,
-		 ipwsr & (RIO_IPWSR_TE | RIO_IPWSR_QFI | RIO_IPWSR_PWD));
-
-	if ((ipwmr & RIO_IPWMR_EIE) && (ipwsr & RIO_IPWSR_TE)) {
-		priv->port_write_msg.err_count++;
-		pr_info("RIO: Port-Write Transaction Err (%d)\n",
-			 priv->port_write_msg.err_count);
-	}
-	if (ipwsr & RIO_IPWSR_PWD) {
-		priv->port_write_msg.discard_count++;
-		pr_info("RIO: Port Discarded Port-Write Msg(s) (%d)\n",
-			 priv->port_write_msg.discard_count);
-	}
-
 	/* Schedule deferred processing if PW was received */
 	if (ipwsr & RIO_IPWSR_QFI) {
 		/* Save PW message (if there is room in FIFO),
@@ -1119,16 +1102,43 @@ fsl_rio_port_write_handler(int irq, void *dev_instance)
 				 RIO_PW_MSG_SIZE);
 		} else {
 			priv->port_write_msg.discard_count++;
-			pr_info("RIO: ISR Discarded Port-Write Msg(s) (%d)\n",
+			pr_debug("RIO: ISR Discarded Port-Write Msg(s) (%d)\n",
 				 priv->port_write_msg.discard_count);
 		}
+		/* Clear interrupt and issue Clear Queue command. This allows
+		 * another port-write to be received.
+		 */
+		out_be32(&priv->msg_regs->pwsr,	RIO_IPWSR_QFI);
+		out_be32(&priv->msg_regs->pwmr, ipwmr | RIO_IPWMR_CQ);
+
 		schedule_work(&priv->pw_work);
 	}
 
-	/* Issue Clear Queue command. This allows another
-	 * port-write to be received.
-	 */
-	out_be32(&priv->msg_regs->pwmr, ipwmr | RIO_IPWMR_CQ);
+	if ((ipwmr & RIO_IPWMR_EIE) && (ipwsr & RIO_IPWSR_TE)) {
+		priv->port_write_msg.err_count++;
+		pr_debug("RIO: Port-Write Transaction Err (%d)\n",
+			 priv->port_write_msg.err_count);
+		/* Clear Transaction Error: port-write controller should be
+		 * disabled when clearing this error
+		 */
+		out_be32(&priv->msg_regs->pwmr, ipwmr & ~RIO_IPWMR_PWE);
+		out_be32(&priv->msg_regs->pwsr,	RIO_IPWSR_TE);
+		out_be32(&priv->msg_regs->pwmr, ipwmr);
+	}
+
+	if (ipwsr & RIO_IPWSR_PWD) {
+		priv->port_write_msg.discard_count++;
+		pr_debug("RIO: Port Discarded Port-Write Msg(s) (%d)\n",
+			 priv->port_write_msg.discard_count);
+		out_be32(&priv->msg_regs->pwsr, RIO_IPWSR_PWD);
+	}
+
+pw_done:
+	if (epwisr & RIO_EPWISR_PINT) {
+		tmp = in_be32(priv->regs_win + RIO_LTLEDCSR);
+		pr_debug("RIO_LTLEDCSR = 0x%x\n", tmp);
+		out_be32(priv->regs_win + RIO_LTLEDCSR, 0);
+	}
 
 	return IRQ_HANDLED;
 }
-- 
1.7.0.5

