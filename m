Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093Ab1F3JwH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 05:52:07 -0400
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:48675 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752043Ab1F3Jv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 05:51:26 -0400
From: Felipe Balbi <balbi@ti.com>
To: Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Thomas Gleixner <tglx@linutronix.de>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 3/7] mfd: twl4030-irq: drop the kthread
Date: Thu, 30 Jun 2011 12:51:06 +0300
Message-Id: <1309427470-605-4-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1309427470-605-1-git-send-email-balbi@ti.com>
References: <1309427470-605-1-git-send-email-balbi@ti.com>
Organization: Texas Instruments\n
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... and use threaded IRQ infrastructure. Later
patches will come dropping both workqueues and
setting the nested thread flag.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/mfd/twl4030-irq.c |   94 ++++++++++-----------------------------------
 1 files changed, 21 insertions(+), 73 deletions(-)

diff --git a/drivers/mfd/twl4030-irq.c b/drivers/mfd/twl4030-irq.c
index 291364c..e1e0944 100644
--- a/drivers/mfd/twl4030-irq.c
+++ b/drivers/mfd/twl4030-irq.c
@@ -30,7 +30,6 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
-#include <linux/kthread.h>
 #include <linux/slab.h>
 
 #include <linux/i2c/twl.h>
@@ -278,59 +277,6 @@ static const struct sih sih_modules_twl5031[8] = {
 
 static unsigned twl4030_irq_base;
 
-static struct completion irq_event;
-
-/*
- * This thread processes interrupts reported by the Primary Interrupt Handler.
- */
-static int twl4030_irq_thread(void *data)
-{
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
-
-		/* these handlers deal with the relevant SIH irq status */
-		local_irq_disable();
-		for (module_irq = twl4030_irq_base;
-				pih_isr;
-				pih_isr >>= 1, module_irq++) {
-			if (pih_isr & 0x1)
-				generic_handle_irq(module_irq);
-		}
-		local_irq_enable();
-
-		enable_irq(irq);
-	}
-
-	return 0;
-}
-
 /*
  * handle_twl4030_pih() is the desc->handle method for the twl4030 interrupt.
  * This is a chained interrupt, so there is no desc->action method for it.
@@ -342,9 +288,25 @@ static int twl4030_irq_thread(void *data)
  */
 static irqreturn_t handle_twl4030_pih(int irq, void *devid)
 {
-	/* Acknowledge, clear *AND* mask the interrupt... */
-	disable_irq_nosync(irq);
-	complete(devid);
+	int		module_irq;
+	irqreturn_t	ret;
+	u8		pih_isr;
+
+	ret = twl_i2c_read_u8(TWL4030_MODULE_PIH, &pih_isr,
+			REG_PIH_ISR_P1);
+	if (ret) {
+		pr_warning("twl4030: I2C error %d reading PIH ISR\n", ret);
+		return IRQ_NONE;
+	}
+
+	/* these handlers deal with the relevant SIH irq status */
+	for (module_irq = twl4030_irq_base;
+			pih_isr;
+			pih_isr >>= 1, module_irq++) {
+		if (pih_isr & 0x1)
+			generic_handle_irq(module_irq);
+	}
+
 	return IRQ_HANDLED;
 }
 /*----------------------------------------------------------------------*/
@@ -763,7 +725,6 @@ int twl4030_init_irq(int irq_num, unsigned irq_base, unsigned irq_end)
 
 	int			status;
 	int			i;
-	struct task_struct	*task;
 
 	/*
 	 * Mask and clear all TWL4030 interrupts since initially we do
@@ -806,27 +767,14 @@ int twl4030_init_irq(int irq_num, unsigned irq_base, unsigned irq_end)
 	}
 
 	/* install an irq handler to demultiplex the TWL4030 interrupt */
-
-
-	init_completion(&irq_event);
-
-	status = request_irq(irq_num, handle_twl4030_pih, IRQF_DISABLED,
-				"TWL4030-PIH", &irq_event);
+	status = request_threaded_irq(irq_num, NULL, handle_twl4030_pih,
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
 	return status;
-fail_kthread:
-	free_irq(irq_num, &irq_event);
 fail_rqirq:
 	/* clean up twl4030_sih_setup */
 fail:
-- 
1.7.6

