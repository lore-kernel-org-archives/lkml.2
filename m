Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119Ab0FWIs6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 04:48:58 -0400
Received: from www.tglx.de ([62.245.132.106]:58244 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367Ab0FWIs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 04:48:56 -0400
From: John Ogness <john.ogness@linutronix.de>
To: Ivo Clarysse <ivo.clarysse@gmail.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
       Sascha Hauer <kernel@pengutronix.de>,
       linux-arm-kernel@lists.infradead.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv3 4/5] mtd: mxc_nand fixups
References: <804oh0b7gx.fsf@merkur.tec.linutronix.de>
	<20100618205401.GA12115@pengutronix.de>
	<80sk4ivkga.fsf@merkur.tec.linutronix.de>
	<AANLkTimA7Rbm_nHpVYpEPqaPCjrOse9s8YyiInWlhfEK@mail.gmail.com>
	<80tyoyhxey.fsf_-_@merkur.tec.linutronix.de>
	<AANLkTikRj_dMkKLyFhW78yld9jIYAIFncfPaPAF8WqUY@mail.gmail.com>
	<80iq5bqd07.fsf_-_@merkur.tec.linutronix.de>
	<AANLkTimJKNEwOoKldq4a4_ufxNY6IY7r6tAfAM055hlW@mail.gmail.com>
Date: Wed, 23 Jun 2010 10:48:41 +0200
In-Reply-To: <AANLkTimJKNEwOoKldq4a4_ufxNY6IY7r6tAfAM055hlW@mail.gmail.com>
	(Ivo Clarysse's message of "Wed, 23 Jun 2010 09:34:55 +0200")
Message-ID: <80vd9ab0d2.fsf@merkur.tec.linutronix.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-06-23, Ivo Clarysse <ivo.clarysse@gmail.com> wrote:
> Unfortunately, this breaks i.MX21 support.
>
> With this patch, the driver gets stuck at the first send_addr()
> invocation:
>
> [...]
>
> Setting NFC_CONFIG1:NFC_INT_MSK in the interrupt handler causes
> NFC_CONFIG2:NFC_INT to always read out 0 (on i.MX21), causing
>
>     wait_event(host->irq_waitq,
>                readw(host->regs + NFC_CONFIG2) & NFC_INT);
>
> to wait forever.

OK. Now I understand the problem. Here is a new patch that introduces a
flag that is set by the interrupt handler. This way we do not rely on
the i.MX21 being able to read NFC_INT when the interrupt is masked.

I have also added a lot of comments so that it is (hopefully) clear why
we are enabling and disabling the irq line rather than only masking and
unmasking the interrupt.

The patch is against linux-next 20100618.

Signed-off-by: John Ogness <john.ogness@linutronix.de>
---
 drivers/mtd/nand/mxc_nand.c |   49 +++++++++++++++++++++++++++++-----
 1 file changed, 42 insertions(+), 7 deletions(-)

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
@@ -117,6 +118,7 @@ struct mxc_nand_host {
 	int			clk_act;
 	int			irq;
 
+	int			nfc_int;
 	wait_queue_head_t	irq_waitq;
 
 	uint8_t			*data_buf;
@@ -173,8 +175,21 @@ static const char *part_probes[] = { "Re
 static irqreturn_t mxc_nfc_irq(int irq, void *dev_id)
 {
 	struct mxc_nand_host *host = dev_id;
+	uint16_t tmp;
+
+	/* If NFC_INT is not set, we have a spurious interrupt! */
+	if ((readw(host->regs + NFC_CONFIG2) & NFC_INT) == 0)
+		return IRQ_NONE;
+
+	/* We use the host->nfc_int flag because the i.MX21 cannot
+	 * read the CONFIG2:NFC_INT bit if interrupts are masked. */
+	host->nfc_int = 1;
 
-	disable_irq_nosync(irq);
+	/* Mask the interrupts so that we avoid an interrupt
+	 * flood until the irq line is disabled. */
+	tmp = readw(host->regs + NFC_CONFIG1);
+	tmp |= NFC_INT_MSK;
+	writew(tmp, host->regs + NFC_CONFIG1);
 
 	wake_up(&host->irq_waitq);
 
@@ -192,15 +207,33 @@ static void wait_op_done(struct mxc_nand
 	if (useirq) {
 		if ((readw(host->regs + NFC_CONFIG2) & NFC_INT) == 0) {
 
+			/* Clear the interrupt flag. It will be set
+			 * by the interrupt handler. */
+			host->nfc_int = 0;
+
+			/* We enable the irq line and wait for an interrupt.
+			 * We must use irq line enable/disable rather than
+			 * simply masking of the interrupt because the i.MX21
+			 * cannot read the CONFIG2:NFC_INT bit if the
+			 * interrupt is masked. This is also the reason we
+			 * use the host->nfc_int flag. */
 			enable_irq(host->irq);
 
-			wait_event(host->irq_waitq,
-				readw(host->regs + NFC_CONFIG2) & NFC_INT);
+			wait_event(host->irq_waitq, host->nfc_int);
+
+			disable_irq(host->irq);
 
-			tmp = readw(host->regs + NFC_CONFIG2);
-			tmp  &= ~NFC_INT;
-			writew(tmp, host->regs + NFC_CONFIG2);
+			/* The irq line has been disabled. We can now
+			 * unmask the interrupts. */
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
@@ -846,7 +879,9 @@ static int __init mxcnd_probe(struct pla
 
 	host->irq = platform_get_irq(pdev, 0);
 
-	err = request_irq(host->irq, mxc_nfc_irq, IRQF_DISABLED, DRIVER_NAME, host);
+	/* request irq as disabled */
+	set_irq_flags(host->irq, IRQF_VALID | IRQF_NOAUTOEN);
+	err = request_irq(host->irq, mxc_nfc_irq, 0, DRIVER_NAME, host);
 	if (err)
 		goto eirq;
 
