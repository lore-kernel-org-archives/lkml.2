Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961Ab0FZJRv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 05:17:51 -0400
Received: from www.tglx.de ([62.245.132.106]:47705 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824Ab0FZJRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 05:17:49 -0400
From: John Ogness <john.ogness@linutronix.de>
To: Ivo Clarysse <ivo.clarysse@gmail.com>
Cc: Sascha Hauer <kernel@pengutronix.de>, linux-arm-kernel@lists.infradead.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv3 4/5] mtd: mxc_nand fixups
References: <20100618205401.GA12115@pengutronix.de>
	<80sk4ivkga.fsf@merkur.tec.linutronix.de>
	<AANLkTimA7Rbm_nHpVYpEPqaPCjrOse9s8YyiInWlhfEK@mail.gmail.com>
	<80tyoyhxey.fsf_-_@merkur.tec.linutronix.de>
	<AANLkTikRj_dMkKLyFhW78yld9jIYAIFncfPaPAF8WqUY@mail.gmail.com>
	<80iq5bqd07.fsf_-_@merkur.tec.linutronix.de>
	<AANLkTimJKNEwOoKldq4a4_ufxNY6IY7r6tAfAM055hlW@mail.gmail.com>
	<80vd9ab0d2.fsf@merkur.tec.linutronix.de>
	<AANLkTinVaXjCneg-XpxB7YNlmGOwQFTnm5RUcetPdToI@mail.gmail.com>
	<80lja6awlb.fsf@merkur.tec.linutronix.de>
	<20100624072732.GQ12115@pengutronix.de>
	<807hloag6w.fsf@merkur.tec.linutronix.de>
	<AANLkTilTbvlPxRhioMiKrBUNggcxZeboi1YpB8Y9Bdpm@mail.gmail.com>
Date: Sat, 26 Jun 2010 11:17:35 +0200
In-Reply-To: <AANLkTilTbvlPxRhioMiKrBUNggcxZeboi1YpB8Y9Bdpm@mail.gmail.com>
	(Ivo Clarysse's message of "Fri, 25 Jun 2010 16:50:45 +0200")
Message-ID: <80y6e2kv9s.fsf@merkur.tec.linutronix.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-06-25, Ivo Clarysse <ivo.clarysse@gmail.com> wrote:
> Tested on an MX21ADS board, and it still works.
>
> [...]
>
> Naming is not very consistent; I'd suggest nfc_set_interrupt /
> nfc_clear_interrupt

Actually, the set function is a query, not an action. I've renamed it
nfc_isset_interrupt() so that it is clearer. I also fixed a typo in one
of the comments.

This patch is based on linux-next 20100618.

Signed-off-by: John Ogness <john.ogness@linutronix.de>
---
 drivers/mtd/nand/mxc_nand.c |   81 +++++++++++++++++++++++++---------
 1 file changed, 61 insertions(+), 20 deletions(-)

Index: linux-next-20100618/drivers/mtd/nand/mxc_nand.c
===================================================================
--- linux-next-20100618.orig/drivers/mtd/nand/mxc_nand.c
+++ linux-next-20100618/drivers/mtd/nand/mxc_nand.c
@@ -30,6 +30,8 @@
 #include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/completion.h>
 
 #include <asm/mach/flash.h>
 #include <mach/mxc_nand.h>
@@ -40,6 +42,13 @@
 #define nfc_is_v21()		(cpu_is_mx25() || cpu_is_mx35())
 #define nfc_is_v1()		(cpu_is_mx31() || cpu_is_mx27() || cpu_is_mx21())
 
+/* It has been observed that the i.MX21 cannot read the CONFIG2:INT bit
+ * if interrupts are masked (CONFIG1:INT_MSK is set). To handle this, the
+ * driver can enable/disable the irq line rather than simply masking the
+ * interrupts. The nfc_avoid_masking() macro identifies the systems that
+ * should use this workaround. */
+#define nfc_avoid_masking()	(cpu_is_mx21())
+
 /* Addresses for NFC registers */
 #define NFC_BUF_SIZE		0xE00
 #define NFC_BUF_ADDR		0xE04
@@ -100,6 +109,18 @@
 
 #define NFC_RSLTSPARE_AREA_MASK  0xff
 
+#define nfc_isset_interrupt(_regs) \
+		(readw(_regs + NFC_CONFIG2) & NFC_INT)
+#define nfc_clear_interrupt(_regs) \
+		writew(readw(_regs + NFC_CONFIG2) & ~NFC_INT, \
+		       _regs + NFC_CONFIG2)
+#define nfc_mask_irq(_regs) \
+		writew(readw(_regs + NFC_CONFIG1) | NFC_INT_MSK, \
+		       _regs + NFC_CONFIG1)
+#define nfc_unmask_irq(_regs) \
+		writew(readw(_regs + NFC_CONFIG1) & ~NFC_INT_MSK, \
+		       _regs + NFC_CONFIG1)
+
 struct mxc_nand_host {
 	struct mtd_info		mtd;
 	struct nand_chip	nand;
@@ -117,7 +138,7 @@ struct mxc_nand_host {
 	int			clk_act;
 	int			irq;
 
-	wait_queue_head_t	irq_waitq;
+	struct completion	op_completion;
 
 	uint8_t			*data_buf;
 	unsigned int		buf_start;
@@ -174,9 +195,18 @@ static irqreturn_t mxc_nfc_irq(int irq, 
 {
 	struct mxc_nand_host *host = dev_id;
 
-	disable_irq_nosync(irq);
-
-	wake_up(&host->irq_waitq);
+	/* If NFC_INT is not set, we have a spurious interrupt! */
+	if (!nfc_isset_interrupt(host->regs))
+		return IRQ_NONE;
+
+	/* Even with nfc_avoid_masking() we mask the interrupt
+	 * here to avoid an interrupt flood until the irq line
+	 * is disabled by the driver thread. */
+	nfc_mask_irq(host->regs);
+
+	/* Notify the driver thread that an interrupt has occurred.
+	 * The driver thread will clear the interrupt. */
+	complete(&host->op_completion);
 
 	return IRQ_HANDLED;
 }
@@ -186,27 +216,32 @@ static irqreturn_t mxc_nfc_irq(int irq, 
  */
 static void wait_op_done(struct mxc_nand_host *host, int useirq)
 {
-	uint16_t tmp;
 	int max_retries = 8000;
 
 	if (useirq) {
-		if ((readw(host->regs + NFC_CONFIG2) & NFC_INT) == 0) {
+		if (!nfc_isset_interrupt(host->regs)) {
+
+			INIT_COMPLETION(host->op_completion);
 
-			enable_irq(host->irq);
+			if (nfc_avoid_masking())
+				enable_irq(host->irq);
+			else
+				nfc_unmask_irq(host->regs);
 
-			wait_event(host->irq_waitq,
-				readw(host->regs + NFC_CONFIG2) & NFC_INT);
+			/* wait for the interrupt */
+			wait_for_completion(&host->op_completion);
 
-			tmp = readw(host->regs + NFC_CONFIG2);
-			tmp  &= ~NFC_INT;
-			writew(tmp, host->regs + NFC_CONFIG2);
+			if (nfc_avoid_masking()) {
+				disable_irq(host->irq);
+				nfc_unmask_irq(host->regs);
+			}
 		}
+
+		nfc_clear_interrupt(host->regs);
 	} else {
 		while (max_retries-- > 0) {
-			if (readw(host->regs + NFC_CONFIG2) & NFC_INT) {
-				tmp = readw(host->regs + NFC_CONFIG2);
-				tmp  &= ~NFC_INT;
-				writew(tmp, host->regs + NFC_CONFIG2);
+			if (nfc_isset_interrupt(host->regs)) {
+				nfc_clear_interrupt(host->regs);
 				break;
 			}
 			udelay(1);
@@ -582,9 +617,8 @@ static void preset(struct mtd_info *mtd)
 	struct mxc_nand_host *host = nand_chip->priv;
 	uint16_t tmp;
 
-	/* enable interrupt, disable spare enable, setup ECC */
+	/* disable spare-only, setup ECC */
 	tmp = readw(host->regs + NFC_CONFIG1);
-	tmp &= ~NFC_INT_MSK;
 	tmp &= ~NFC_SP_EN;
 	if (nand_chip->ecc.mode == NAND_ECC_HW) {
 		tmp |= NFC_ECC_EN;
@@ -842,11 +876,18 @@ static int __init mxcnd_probe(struct pla
 		this->options |= NAND_USE_FLASH_BBT;
 	}
 
-	init_waitqueue_head(&host->irq_waitq);
+	init_completion(&host->op_completion);
 
 	host->irq = platform_get_irq(pdev, 0);
 
-	err = request_irq(host->irq, mxc_nfc_irq, IRQF_DISABLED, DRIVER_NAME, host);
+	if (nfc_avoid_masking()) {
+		set_irq_flags(host->irq, IRQF_VALID | IRQF_NOAUTOEN);
+		nfc_unmask_irq(host->regs);
+	} else {
+		nfc_mask_irq(host->regs);
+	}
+
+	err = request_irq(host->irq, mxc_nfc_irq, 0, DRIVER_NAME, host);
 	if (err)
 		goto eirq;
 
