Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352Ab0FTJVn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 05:21:43 -0400
Received: from www.tglx.de ([62.245.132.106]:56660 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755939Ab0FTJVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 05:21:41 -0400
From: John Ogness <john.ogness@linutronix.de>
To: Ivo Clarysse <ivo.clarysse@gmail.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
       Sascha Hauer <kernel@pengutronix.de>,
       linux-arm-kernel@lists.infradead.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCHv2 4/5] mtd: mxc_nand fixups
References: <804oh0b7gx.fsf@merkur.tec.linutronix.de>
	<20100618205401.GA12115@pengutronix.de>
	<80sk4ivkga.fsf@merkur.tec.linutronix.de>
	<AANLkTimA7Rbm_nHpVYpEPqaPCjrOse9s8YyiInWlhfEK@mail.gmail.com>
Date: Sun, 20 Jun 2010 11:21:25 +0200
In-Reply-To: <AANLkTimA7Rbm_nHpVYpEPqaPCjrOse9s8YyiInWlhfEK@mail.gmail.com>
	(Ivo Clarysse's message of "Sun, 20 Jun 2010 11:09:03 +0200")
Message-ID: <80tyoyhxey.fsf_-_@merkur.tec.linutronix.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-06-20, Ivo Clarysse <ivo.clarysse@gmail.com> wrote:
> Yes, on i.MX21, NFC interrupts can be masked using
> NFC_CONFIG1:NFC_INT_MSK.  But I observed that as long as NFC_INT_MSK
> is set, NFC_CONFIG2:NFC_INT will always read out 0 on i.MX21, even if
> the operation is completed.
>
> So the driver will remain stuck at:
>
>                  wait_event(host->irq_waitq,
>                          readw(host->regs + NFC_CONFIG2) & NFC_INT);

OK. Here is alternative patch. Do you have access to an i.MX21 to test
this on?

This patch fixes the driver so that the irq is requested as disabled. This
prevents double irq enabling and also does not require the interrupt to
be disabled within the interrupt handler. (Actually, I beleive this was
the true intention of the original author.)

The patch is against linux-next 20100618.

Signed-off-by: John Ogness <john.ogness@linutronix.de>
---
 drivers/mtd/nand/mxc_nand.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

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
@@ -846,7 +847,9 @@ static int __init mxcnd_probe(struct pla
 
 	host->irq = platform_get_irq(pdev, 0);
 
-	err = request_irq(host->irq, mxc_nfc_irq, IRQF_DISABLED, DRIVER_NAME, host);
+	/* request irq as disabled */
+	err = request_irq(host->irq, mxc_nfc_irq, IRQF_NOAUTOEN,
+			  DRIVER_NAME, host);
 	if (err)
 		goto eirq;
 
