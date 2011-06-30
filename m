Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366Ab1F3Jw2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 05:52:28 -0400
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:53088 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755134Ab1F3Jvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 05:51:35 -0400
From: Felipe Balbi <balbi@ti.com>
To: Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Thomas Gleixner <tglx@linutronix.de>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 6/7] mfd: twl4030-irq: set irq nested flag
Date: Thu, 30 Jun 2011 12:51:09 +0300
Message-Id: <1309427470-605-7-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1309427470-605-1-git-send-email-balbi@ti.com>
References: <1309427470-605-1-git-send-email-balbi@ti.com>
Organization: Texas Instruments\n
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

threads from twl4030's children will be called
nested in the context of the demultiplexing
handler on twl4030-irq.c.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/mfd/twl4030-irq.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/twl4030-irq.c b/drivers/mfd/twl4030-irq.c
index 1b9ab2f..ff16e9c 100644
--- a/drivers/mfd/twl4030-irq.c
+++ b/drivers/mfd/twl4030-irq.c
@@ -304,7 +304,7 @@ static irqreturn_t handle_twl4030_pih(int irq, void *devid)
 			pih_isr;
 			pih_isr >>= 1, module_irq++) {
 		if (pih_isr & 0x1)
-			generic_handle_irq(module_irq);
+			handle_nested_irq(module_irq);
 	}
 
 	return IRQ_HANDLED;
@@ -596,9 +596,7 @@ static void handle_twl4030_sih(unsigned irq, struct irq_desc *desc)
 	int isr;
 
 	/* reading ISR acks the IRQs, using clear-on-read mode */
-	local_irq_enable();
 	isr = sih_read_isr(sih);
-	local_irq_disable();
 
 	if (isr < 0) {
 		pr_err("twl4030: %s SIH, read ISR error %d\n",
@@ -613,7 +611,7 @@ static void handle_twl4030_sih(unsigned irq, struct irq_desc *desc)
 		isr &= ~BIT(irq);
 
 		if (irq < sih->bits)
-			generic_handle_irq(agent->irq_base + irq);
+			handle_nested_irq(agent->irq_base + irq);
 		else
 			pr_err("twl4030: %s SIH, invalid ISR bit %d\n",
 				sih->name, irq);
@@ -720,6 +718,7 @@ int twl4030_init_irq(int irq_num, unsigned irq_base, unsigned irq_end)
 	for (i = irq_base; i < irq_end; i++) {
 		irq_set_chip_and_handler(i, &twl4030_irq_chip,
 					 handle_simple_irq);
+		irq_set_nested_thread(i, 1);
 		activate_irq(i);
 	}
 	twl4030_irq_next = i;
@@ -745,8 +744,10 @@ int twl4030_init_irq(int irq_num, unsigned irq_base, unsigned irq_end)
 fail_rqirq:
 	/* clean up twl4030_sih_setup */
 fail:
-	for (i = irq_base; i < irq_end; i++)
+	for (i = irq_base; i < irq_end; i++) {
+		irq_set_nested_thread(i, 0);
 		irq_set_chip_and_handler(i, NULL, NULL);
+	}
 
 	return status;
 }
-- 
1.7.6

