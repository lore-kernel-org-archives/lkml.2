Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749Ab0L1OA1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 09:00:27 -0500
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:42186 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753527Ab0L1OAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 09:00:00 -0500
From: Felipe Balbi <balbi@ti.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Cc: Tony Lindgren <tony@atomide.com>, David Brownell <david-b@pacbell.net>,
        Thomas Gleixner <tglx@linutronix.de>, Felipe Balbi <balbi@ti.com>
Subject: [RFC/PATCH 1/2] mfd: twl6030-irq: move to threaded_irq
Date: Tue, 28 Dec 2010 15:59:49 +0200
Message-Id: <1293544790-793-2-git-send-email-balbi@ti.com>
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
 drivers/mfd/twl6030-irq.c |  141 ++++++++++++++++-----------------------------
 1 files changed, 49 insertions(+), 92 deletions(-)

diff --git a/drivers/mfd/twl6030-irq.c b/drivers/mfd/twl6030-irq.c
index aaedb11..1530411 100644
--- a/drivers/mfd/twl6030-irq.c
+++ b/drivers/mfd/twl6030-irq.c
@@ -84,99 +84,64 @@ static int twl6030_interrupt_mapping[24] = {
 
 static unsigned twl6030_irq_base;
 
-static struct completion irq_event;
-
 /*
  * This thread processes interrupts reported by the Primary Interrupt Handler.
  */
-static int twl6030_irq_thread(void *data)
+static irqreturn_t twl6030_irq_thread(int irq, void *unused)
 {
-	long irq = (long)data;
-	static unsigned i2c_errors;
-	static const unsigned max_i2c_errors = 100;
 	int ret;
-
-	current->flags |= PF_NOFREEZE;
-
-	while (!kthread_should_stop()) {
-		int i;
-		union {
+	int i;
+	union {
 		u8 bytes[4];
 		u32 int_sts;
-		} sts;
-
-		/* Wait for IRQ, then read PIH irq status (also blocking) */
-		wait_for_completion_interruptible(&irq_event);
-
-		/* read INT_STS_A, B and C in one shot using a burst read */
-		ret = twl_i2c_read(TWL_MODULE_PIH, sts.bytes,
-				REG_INT_STS_A, 3);
-		if (ret) {
-			pr_warning("twl6030: I2C error %d reading PIH ISR\n",
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
-
+	} sts;
 
+	disable_irq_nosync(irq);
 
-		sts.bytes[3] = 0; /* Only 24 bits are valid*/
+	/* read INT_STS_A, B and C in one shot using a burst read */
+	ret = twl_i2c_read(TWL_MODULE_PIH, sts.bytes,
+			REG_INT_STS_A, 3);
+	if (ret) {
+		pr_warning("twl6030: I2C error %d reading PIH ISR\n",
+				ret);
+		return IRQ_NONE;
+	}
 
-		for (i = 0; sts.int_sts; sts.int_sts >>= 1, i++) {
-			local_irq_disable();
-			if (sts.int_sts & 0x1) {
-				int module_irq = twl6030_irq_base +
-					twl6030_interrupt_mapping[i];
-				struct irq_desc *d = irq_to_desc(module_irq);
 
-				if (!d) {
-					pr_err("twl6030: Invalid SIH IRQ: %d\n",
-					       module_irq);
-					return -EINVAL;
-				}
+	sts.bytes[3] = 0; /* Only 24 bits are valid*/
 
-				/* These can't be masked ... always warn
-				 * if we get any surprises.
-				 */
-				if (d->status & IRQ_DISABLED)
-					note_interrupt(module_irq, d,
-							IRQ_NONE);
-				else
-					d->handle_irq(module_irq, d);
+	for (i = 0; sts.int_sts; sts.int_sts >>= 1, i++) {
+		local_irq_disable();
+		if (sts.int_sts & 0x1) {
+			int module_irq = twl6030_irq_base +
+				twl6030_interrupt_mapping[i];
+			struct irq_desc *d = irq_to_desc(module_irq);
 
+			if (!d) {
+				pr_err("twl6030: Invalid SIH IRQ: %d\n",
+						module_irq);
+				return IRQ_NONE;
 			}
-		local_irq_enable();
-		}
-		ret = twl_i2c_write(TWL_MODULE_PIH, sts.bytes,
-				REG_INT_STS_A, 3); /* clear INT_STS_A */
-		if (ret)
-			pr_warning("twl6030: I2C error in clearing PIH ISR\n");
 
-		enable_irq(irq);
+			/* These can't be masked ... always warn
+			 * if we get any surprises.
+			 */
+			if (d->status & IRQ_DISABLED)
+				note_interrupt(module_irq, d,
+						IRQ_NONE);
+			else
+				handle_nested_irq(module_irq);
+
+		}
+		local_irq_enable();
 	}
+	ret = twl_i2c_write(TWL_MODULE_PIH, sts.bytes,
+			REG_INT_STS_A, 3); /* clear INT_STS_A */
+	if (ret)
+		pr_warning("twl6030: I2C error in clearing PIH ISR\n");
 
-	return 0;
-}
+	enable_irq(irq);
 
-/*
- * handle_twl6030_int() is the desc->handle method for the twl6030 interrupt.
- * This is a chained interrupt, so there is no desc->action method for it.
- * Now we need to query the interrupt controller in the twl6030 to determine
- * which module is generating the interrupt request.  However, we can't do i2c
- * transactions in interrupt context, so we must defer that work to a kernel
- * thread.  All we do here is acknowledge and mask the interrupt and wakeup
- * the kernel thread.
- */
-static irqreturn_t handle_twl6030_pih(int irq, void *devid)
-{
-	disable_irq_nosync(irq);
-	complete(devid);
 	return IRQ_HANDLED;
 }
 
@@ -303,7 +268,6 @@ int twl6030_init_irq(int irq_num, unsigned irq_base, unsigned irq_end)
 
 	int	status = 0;
 	int	i;
-	struct task_struct	*task;
 	int ret;
 	u8 mask[4];
 
@@ -337,28 +301,21 @@ int twl6030_init_irq(int irq_num, unsigned irq_base, unsigned irq_end)
 	pr_info("twl6030: %s (irq %d) chaining IRQs %d..%d\n", "PIH",
 			irq_num, irq_base, twl6030_irq_next - 1);
 
-	/* install an irq handler to demultiplex the TWL6030 interrupt */
-	init_completion(&irq_event);
-	task = kthread_run(twl6030_irq_thread, (void *)irq_num, "twl6030-irq");
-	if (IS_ERR(task)) {
-		pr_err("twl6030: could not create irq %d thread!\n", irq_num);
-		status = PTR_ERR(task);
-		goto fail_kthread;
-	}
-
-	status = request_irq(irq_num, handle_twl6030_pih, IRQF_DISABLED,
-				"TWL6030-PIH", &irq_event);
+	status = request_threaded_irq(irq_num, NULL, twl6030_irq_thread,
+			IRQF_DISABLED, "TWL6030-PIH", NULL);
 	if (status < 0) {
 		pr_err("twl6030: could not claim irq%d: %d\n", irq_num, status);
-		goto fail_irq;
+		goto fail;
 	}
-	return status;
-fail_irq:
-	free_irq(irq_num, &irq_event);
 
-fail_kthread:
+	return 0;
+
+fail:
+	free_irq(irq_num, NULL);
+
 	for (i = irq_base; i < irq_end; i++)
 		set_irq_chip_and_handler(i, NULL, NULL);
+
 	return status;
 }
 
-- 
1.7.3.4.598.g85356

