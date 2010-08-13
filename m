Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934548Ab0HMPVn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 11:21:43 -0400
Received: from mxout1.idt.com ([157.165.5.25]:47113 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761783Ab0HMPUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 11:20:14 -0400
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Kumar Gala <galak@kernel.crashing.org>
Subject: [PATCH 2/9] RapidIO,powerpc/85xx: modify RIO port-write interrupt handler
Date: Fri, 13 Aug 2010 11:17:59 -0400
Message-Id: <1281712686-31308-3-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.0.5
In-Reply-To: <1281712686-31308-1-git-send-email-alexandre.bounine@idt.com>
References: <1281712686-31308-1-git-send-email-alexandre.bounine@idt.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Rearranged RIO port-write interrupt handling to perform message buffering
as soon as possible.
- Modified to disable port-write controller when clearing Transaction Error (TE)
bit.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Reviewed-by: Thomas Moll <thomas.moll@sysgo.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
---
 arch/powerpc/sysdev/fsl_rio.c |   67 ++++++++++++++++++++++------------------
 1 files changed, 37 insertions(+), 30 deletions(-)

diff --git a/arch/powerpc/sysdev/fsl_rio.c b/arch/powerpc/sysdev/fsl_rio.c
index cd71dc1..708d94e 100644
--- a/arch/powerpc/sysdev/fsl_rio.c
+++ b/arch/powerpc/sysdev/fsl_rio.c
@@ -1065,18 +1065,12 @@ fsl_rio_port_write_handler(int irq, void *dev_instance)
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
-
 	if (!(epwisr & 0x00000001))
-		return IRQ_HANDLED;
+		goto pw_done;
+
+	ipwmr = in_be32(&priv->msg_regs->pwmr);
+	ipwsr = in_be32(&priv->msg_regs->pwsr);
 
 #ifdef DEBUG_PW
 	pr_debug("PW Int->IPWMR: 0x%08x IPWSR: 0x%08x (", ipwmr, ipwsr);
@@ -1092,22 +1086,8 @@ fsl_rio_port_write_handler(int irq, void *dev_instance)
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
-	if (ipwsr & RIO_IPWSR_QFI) {
+	if ((ipwmr & RIO_IPWMR_QFIE) && (ipwsr & RIO_IPWSR_QFI)) {
 		/* Save PW message (if there is room in FIFO),
 		 * otherwise discard it.
 		 */
@@ -1117,16 +1097,43 @@ fsl_rio_port_write_handler(int irq, void *dev_instance)
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
+	if (epwisr & 0x80000000) {
+		tmp = in_be32(priv->regs_win + RIO_LTLEDCSR);
+		pr_debug("RIO_LTLEDCSR = 0x%x\n", tmp);
+		out_be32(priv->regs_win + RIO_LTLEDCSR, 0);
+	}
 
 	return IRQ_HANDLED;
 }
-- 
1.7.0.5

