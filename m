Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761344Ab0FRRBr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 13:01:47 -0400
Received: from www.tglx.de ([62.245.132.106]:33403 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761110Ab0FRRBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 13:01:46 -0400
From: John Ogness <john.ogness@linutronix.de>
To: Sascha Hauer <kernel@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/5] mtd: mxc_nand fixups
Date: Fri, 18 Jun 2010 19:01:34 +0200
Message-ID: <804oh0b7gx.fsf@merkur.tec.linutronix.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch reverts the driver to enabling/disabling the NFC interrupt
mask rather than enabling/disabling the system interrupt. This cleans
up the driver so that it doesn't rely on interrupts being disabled
within the interrupt handler.

The patch is against linux-next 20100618.

Signed-off-by: John Ogness <john.ogness@linutronix.de>
---
 drivers/mtd/nand/mxc_nand.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

Index: linux-next-20100618/drivers/mtd/nand/mxc_nand.c
===================================================================
--- linux-next-20100618.orig/drivers/mtd/nand/mxc_nand.c
+++ linux-next-20100618/drivers/mtd/nand/mxc_nand.c
@@ -173,8 +173,11 @@ static const char *part_probes[] = { "Re
 static irqreturn_t mxc_nfc_irq(int irq, void *dev_id)
 {
 	struct mxc_nand_host *host = dev_id;
+	uint16_t tmp;
 
-	disable_irq_nosync(irq);
+	tmp = readw(host->regs + NFC_CONFIG1);
+	tmp |= NFC_INT_MSK; /* disable NFC interrupts */
+	writew(tmp, host->regs + NFC_CONFIG1);
 
 	wake_up(&host->irq_waitq);
 
@@ -192,7 +195,9 @@ static void wait_op_done(struct mxc_nand
 	if (useirq) {
 		if ((readw(host->regs + NFC_CONFIG2) & NFC_INT) == 0) {
 
-			enable_irq(host->irq);
+			tmp = readw(host->regs + NFC_CONFIG1);
+			tmp  &= ~NFC_INT_MSK;   /* enable NFC interrupts */
+			writew(tmp, host->regs + NFC_CONFIG1);
 
 			wait_event(host->irq_waitq,
 				readw(host->regs + NFC_CONFIG2) & NFC_INT);
@@ -846,7 +851,7 @@ static int __init mxcnd_probe(struct pla
 
 	host->irq = platform_get_irq(pdev, 0);
 
-	err = request_irq(host->irq, mxc_nfc_irq, IRQF_DISABLED, DRIVER_NAME, host);
+	err = request_irq(host->irq, mxc_nfc_irq, 0, DRIVER_NAME, host);
 	if (err)
 		goto eirq;
 
