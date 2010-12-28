Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab0L1OAY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 09:00:24 -0500
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:42205 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753554Ab0L1OAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 09:00:01 -0500
From: Felipe Balbi <balbi@ti.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Cc: Tony Lindgren <tony@atomide.com>, David Brownell <david-b@pacbell.net>,
        Thomas Gleixner <tglx@linutronix.de>, Felipe Balbi <balbi@ti.com>
Subject: [RFC/PATCH 2/2] mfd: twl4030-irq: move to threaded_irq
Date: Tue, 28 Dec 2010 15:59:50 +0200
Message-Id: <1293544790-793-3-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.3.4.598.g85356
In-Reply-To: <1293544790-793-1-git-send-email-balbi@ti.com>
References: <1293544790-793-1-git-send-email-balbi@ti.com>
Organization: Texas Instruments\n
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... and while at that, also start using
handle_nested_irq() as we should.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/mfd/twl4030-irq.c |  133 ++++++++++++++-------------------------------
 1 files changed, 42 insertions(+), 91 deletions(-)

diff --git a/drivers/mfd/twl4030-irq.c b/drivers/mfd/twl4030-irq.c
index 5d3a147..e88d0c6 100644
--- a/drivers/mfd/twl4030-irq.c
+++ b/drivers/mfd/twl4030-irq.c
@@ -278,91 +278,56 @@ static const struct sih sih_modules_twl5031[8] = {
 
 static unsigned twl4030_irq_base;
 
-static struct completion irq_event;
-
 /*
  * This thread processes interrupts reported by the Primary Interrupt Handler.
  */
-static int twl4030_irq_thread(void *data)
+static irqreturn_t twl4030_irq_thread(int irq, void *unused)
 {
-	long irq = (long)data;
-	static unsigned i2c_errors;
-	static const unsigned max_i2c_errors = 100;
-
-
-	current->flags |= PF_NOFREEZE;
-
-	while (!kthread_should_stop()) {
-		int ret;
-		int module_irq;
-		u8 pih_isr;
-
-		/* Wait for IRQ, then read PIH irq status (also blocking) */
-		wait_for_completion_interruptible(&irq_event);
-
-		ret = twl_i2c_read_u8(TWL4030_MODULE_PIH, &pih_isr,
-					  REG_PIH_ISR_P1);
-		if (ret) {
-			pr_warning("twl4030: I2C error %d reading PIH ISR\n",
-					ret);
-			if (++i2c_errors >= max_i2c_errors) {
-				printk(KERN_ERR "Maximum I2C error count"
-						" exceeded.  Terminating %s.\n",
-						__func__);
-				break;
-			}
-			complete(&irq_event);
-			continue;
-		}
+	int ret;
+	int module_irq;
+	u8 pih_isr;
 
-		/* these handlers deal with the relevant SIH irq status */
-		local_irq_disable();
-		for (module_irq = twl4030_irq_base;
-				pih_isr;
-				pih_isr >>= 1, module_irq++) {
-			if (pih_isr & 0x1) {
-				struct irq_desc *d = irq_to_desc(module_irq);
-
-				if (!d) {
-					pr_err("twl4030: Invalid SIH IRQ: %d\n",
-					       module_irq);
-					return -EINVAL;
-				}
-
-				/* These can't be masked ... always warn
-				 * if we get any surprises.
-				 */
-				if (d->status & IRQ_DISABLED)
-					note_interrupt(module_irq, d,
-							IRQ_NONE);
-				else
-					d->handle_irq(module_irq, d);
+	disable_irq_nosync(irq);
+
+	ret = twl_i2c_read_u8(TWL4030_MODULE_PIH, &pih_isr,
+			REG_PIH_ISR_P1);
+	if (ret) {
+		pr_warning("twl4030: I2C error %d reading PIH ISR\n",
+				ret);
+		return IRQ_NONE;
+	}
+
+	/* these handlers deal with the relevant SIH irq status */
+	local_irq_disable();
+	for (module_irq = twl4030_irq_base;
+			pih_isr;
+			pih_isr >>= 1, module_irq++) {
+		if (pih_isr & 0x1) {
+			struct irq_desc *d = irq_to_desc(module_irq);
+
+			if (!d) {
+				pr_err("twl4030: Invalid SIH IRQ: %d\n",
+						module_irq);
+				return IRQ_NONE;
 			}
-		}
-		local_irq_enable();
 
-		enable_irq(irq);
+			/* These can't be masked ... always warn
+			 * if we get any surprises.
+			 */
+			if (d->status & IRQ_DISABLED)
+				note_interrupt(module_irq, d,
+						IRQ_NONE);
+			else
+				handle_nested_irq(module_irq);
+		}
 	}
 
+	local_irq_enable();
+	enable_irq(irq);
+
 	return 0;
 }
 
-/*
- * handle_twl4030_pih() is the desc->handle method for the twl4030 interrupt.
- * This is a chained interrupt, so there is no desc->action method for it.
- * Now we need to query the interrupt controller in the twl4030 to determine
- * which module is generating the interrupt request.  However, we can't do i2c
- * transactions in interrupt context, so we must defer that work to a kernel
- * thread.  All we do here is acknowledge and mask the interrupt and wakeup
- * the kernel thread.
- */
-static irqreturn_t handle_twl4030_pih(int irq, void *devid)
-{
-	/* Acknowledge, clear *AND* mask the interrupt... */
-	disable_irq_nosync(irq);
-	complete(devid);
-	return IRQ_HANDLED;
-}
 /*----------------------------------------------------------------------*/
 
 /*
@@ -788,7 +753,6 @@ int twl4030_init_irq(int irq_num, unsigned irq_base, unsigned irq_end)
 
 	int			status;
 	int			i;
-	struct task_struct	*task;
 
 	/*
 	 * Mask and clear all TWL4030 interrupts since initially we do
@@ -830,28 +794,15 @@ int twl4030_init_irq(int irq_num, unsigned irq_base, unsigned irq_end)
 		goto fail;
 	}
 
-	/* install an irq handler to demultiplex the TWL4030 interrupt */
-
-
-	init_completion(&irq_event);
-
-	status = request_irq(irq_num, handle_twl4030_pih, IRQF_DISABLED,
-				"TWL4030-PIH", &irq_event);
+	status = request_threaded_irq(irq_num, NULL, twl4030_irq_thread,
+			IRQF_DISABLED, "TWL4030-PIH", NULL);
 	if (status < 0) {
 		pr_err("twl4030: could not claim irq%d: %d\n", irq_num, status);
 		goto fail_rqirq;
 	}
 
-	task = kthread_run(twl4030_irq_thread, (void *)(long)irq_num,
-								"twl4030-irq");
-	if (IS_ERR(task)) {
-		pr_err("twl4030: could not create irq %d thread!\n", irq_num);
-		status = PTR_ERR(task);
-		goto fail_kthread;
-	}
-	return status;
-fail_kthread:
-	free_irq(irq_num, &irq_event);
+	return 0;
+
 fail_rqirq:
 	/* clean up twl4030_sih_setup */
 fail:
-- 
1.7.3.4.598.g85356

