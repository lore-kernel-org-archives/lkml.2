Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112Ab0FVPyd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 11:54:33 -0400
Received: from www.tglx.de ([62.245.132.106]:52372 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752278Ab0FVPyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 11:54:32 -0400
From: John Ogness <john.ogness@linutronix.de>
To: Ivo Clarysse <ivo.clarysse@gmail.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
       Sascha Hauer <kernel@pengutronix.de>,
       linux-arm-kernel@lists.infradead.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCHv3 4/5] mtd: mxc_nand fixups
References: <804oh0b7gx.fsf@merkur.tec.linutronix.de>
	<20100618205401.GA12115@pengutronix.de>
	<80sk4ivkga.fsf@merkur.tec.linutronix.de>
	<AANLkTimA7Rbm_nHpVYpEPqaPCjrOse9s8YyiInWlhfEK@mail.gmail.com>
	<80tyoyhxey.fsf_-_@merkur.tec.linutronix.de>
	<AANLkTikRj_dMkKLyFhW78yld9jIYAIFncfPaPAF8WqUY@mail.gmail.com>
Date: Tue, 22 Jun 2010 17:54:16 +0200
In-Reply-To: <AANLkTikRj_dMkKLyFhW78yld9jIYAIFncfPaPAF8WqUY@mail.gmail.com>
	(Ivo Clarysse's message of "Mon, 21 Jun 2010 13:47:41 +0200")
Message-ID: <80iq5bqd07.fsf_-_@merkur.tec.linutronix.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The v2 version of this patch has 2 problems. I believe that this new
version addresses the problems and still respects the strange behavior
of the i.MX21.

Problem 1: The v2 patch passes IRQF_NOAUTOEN to request_irq(), but that
flag is not evaluated by request_irq(). That flag is only evaluated in
set_irq_flags(), which is now used by this patch.

Problem 2: We are still having problems with irq's possibly being
enabled twice when threaded interrupts are used. This happens because
the main thread that enables the irq can proceed even if the interrupt
hasn't fired yet (NFC_INT is set, but the irq thread hasn't processed it
yet). In this case it is possible for the main thread to enable the irq
again with a later call to wait_op_done().

This patch addresses the problem by allowing the function that enabled
the irq to also be responsible for disabling the irq. This obviously
avoids and double enabling.

In order to prevent interrupt flooding, the interrupt handler will mask
the interrupt. After the main thread has disabled the irq, it will
unmask the interrupt. This should allow the i.MX21 to work correctly
despite its masking behavior.

And finally, this patch correctly clears the interrupt bit each
time. Previously there was a case where the interrupt bit was not being
cleared.

The patch is against linux-next 20100618.

The patch is against linux-next 20100618.

Signed-off-by: John Ogness <john.ogness@linutronix.de>
---
 drivers/mtd/nand/mxc_nand.c |   25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

Index: linux-next-20100618/drivers/mtd/nand/mxc_nand.c
===================================================================
--- linux-next-20100618.orig/drivers/mtd/nand/mxc_nand.c
+++ linux-next-20100618/drivers/mtd/nand/mxc_nand.c
@@ -30,6 +30,7 @@
 #include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/io.h>
+#include <linux/irq.h>
 
 #include <asm/mach/flash.h>
 #include <mach/mxc_nand.h>
@@ -173,8 +174,12 @@ static const char *part_probes[] = { "Re
 static irqreturn_t mxc_nfc_irq(int irq, void *dev_id)
 {
 	struct mxc_nand_host *host = dev_id;
+	uint16_t tmp;
 
-	disable_irq_nosync(irq);
+	/* mask interrupts */
+	tmp = readw(host->regs + NFC_CONFIG1);
+	tmp |= NFC_INT_MSK;
+	writew(tmp, host->regs + NFC_CONFIG1);
 
 	wake_up(&host->irq_waitq);
 
@@ -197,10 +202,18 @@ static void wait_op_done(struct mxc_nand
 			wait_event(host->irq_waitq,
 				readw(host->regs + NFC_CONFIG2) & NFC_INT);
 
-			tmp = readw(host->regs + NFC_CONFIG2);
-			tmp  &= ~NFC_INT;
-			writew(tmp, host->regs + NFC_CONFIG2);
+			disable_irq(host->irq);
+
+			/* unmask interrupts */
+			tmp = readw(host->regs + NFC_CONFIG1);
+			tmp &= ~NFC_INT_MSK;
+			writew(tmp, host->regs + NFC_CONFIG1);
 		}
+
+		/* clear interrupt flag */
+		tmp = readw(host->regs + NFC_CONFIG2);
+		tmp &= ~NFC_INT;
+		writew(tmp, host->regs + NFC_CONFIG2);
 	} else {
 		while (max_retries-- > 0) {
 			if (readw(host->regs + NFC_CONFIG2) & NFC_INT) {
@@ -846,7 +859,9 @@ static int __init mxcnd_probe(struct pla
 
 	host->irq = platform_get_irq(pdev, 0);
 
-	err = request_irq(host->irq, mxc_nfc_irq, IRQF_DISABLED, DRIVER_NAME, host);
+	/* request irq as disabled */
+	set_irq_flags(host->irq, IRQF_VALID | IRQF_NOAUTOEN);
+	err = request_irq(host->irq, mxc_nfc_irq, 0, DRIVER_NAME, host);
 	if (err)
 		goto eirq;
 
