Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab1HLI3m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 04:29:42 -0400
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:48794 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751317Ab1HLI3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 04:29:38 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Vijaya Kumar Kilari <vijay.kilari@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 14/23] mfd/db5500-prcmu: implement event handling
Date: Fri, 12 Aug 2011 10:29:28 +0200
Message-ID: <1313137768-31048-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vijaya Kumar Kilari <vijay.kilari@stericsson.com>

This adds code to handle the events spawned from the DB5500
PRCMU, and calls out to virtual interrupt handlers for these.

Vijaya Kumar Kilari <vijay.kilari@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/db5500-prcmu.c |  149 ++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 143 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/db5500-prcmu.c b/drivers/mfd/db5500-prcmu.c
index c8709b0..2762cfa 100644
--- a/drivers/mfd/db5500-prcmu.c
+++ b/drivers/mfd/db5500-prcmu.c
@@ -400,6 +400,78 @@ static struct {
 /* PRCMU TCDM base IO address. */
 static __iomem void *tcdm_base;
 
+/* This function should only be called while mb0_transfer.lock is held. */
+static void config_wakeups(void)
+{
+	static u32 last_dbb_events;
+	static u32 last_abb_events;
+	u32 dbb_events;
+	u32 abb_events;
+
+	dbb_events = mb0_transfer.req.dbb_irqs | mb0_transfer.req.dbb_wakeups;
+
+	abb_events = mb0_transfer.req.abb_events;
+
+	if ((dbb_events == last_dbb_events) && (abb_events == last_abb_events))
+		return;
+
+	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(0))
+		cpu_relax();
+
+	writel(dbb_events, PRCM_REQ_MB0_WAKEUP_DBB);
+	writel(abb_events, PRCM_REQ_MB0_WAKEUP_ABB);
+	writeb(MB0H_WAKE_UP_CFG, PRCM_REQ_MB0_HEADER);
+	writel(MBOX_BIT(0), PRCM_MBOX_CPU_SET);
+
+	last_dbb_events = dbb_events;
+	last_abb_events = abb_events;
+}
+
+void db5500_prcmu_enable_wakeups(u32 wakeups)
+{
+	unsigned long flags;
+	u32 bits;
+	int i;
+
+	BUG_ON(wakeups != (wakeups & VALID_WAKEUPS));
+
+	for (i = 0, bits = 0; i < NUM_PRCMU_WAKEUP_INDICES; i++) {
+		if (wakeups & BIT(i)) {
+			if (prcmu_wakeup_bit[i] == 0)
+				WARN(1, "WAKEUP NOT SUPPORTED");
+			else
+				bits |= prcmu_wakeup_bit[i];
+		}
+	}
+
+	spin_lock_irqsave(&mb0_transfer.lock, flags);
+
+	mb0_transfer.req.dbb_wakeups = bits;
+	config_wakeups();
+
+	spin_unlock_irqrestore(&mb0_transfer.lock, flags);
+}
+
+void db5500_prcmu_config_abb_event_readout(u32 abb_events)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&mb0_transfer.lock, flags);
+
+	mb0_transfer.req.abb_events = abb_events;
+	config_wakeups();
+
+	spin_unlock_irqrestore(&mb0_transfer.lock, flags);
+}
+
+void db5500_prcmu_get_abb_event_buffer(void __iomem **buf)
+{
+	if (readb(PRCM_ACK_MB0_READ_POINTER) & 1)
+		*buf = (PRCM_ACK_MB0_WAKEUP_1_ABB);
+	else
+		*buf = (PRCM_ACK_MB0_WAKEUP_0_ABB);
+}
+
 /**
  * db5500_prcmu_abb_read() - Read register value(s) from the ABB.
  * @slave:	The I2C slave address.
@@ -742,8 +814,57 @@ static irqreturn_t prcmu_irq_thread_fn(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
+static void prcmu_mask_work(struct work_struct *work)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&mb0_transfer.lock, flags);
+
+	config_wakeups();
+
+	spin_unlock_irqrestore(&mb0_transfer.lock, flags);
+}
+
+static void prcmu_irq_mask(struct irq_data *d)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&mb0_transfer.dbb_irqs_lock, flags);
+
+	mb0_transfer.req.dbb_irqs &= ~prcmu_irq_bit[d->irq - IRQ_DB5500_PRCMU_BASE];
+
+	spin_unlock_irqrestore(&mb0_transfer.dbb_irqs_lock, flags);
+	schedule_work(&mb0_transfer.mask_work);
+}
+
+static void prcmu_irq_unmask(struct irq_data *d)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&mb0_transfer.dbb_irqs_lock, flags);
+
+	mb0_transfer.req.dbb_irqs |= prcmu_irq_bit[d->irq - IRQ_DB5500_PRCMU_BASE];
+
+	spin_unlock_irqrestore(&mb0_transfer.dbb_irqs_lock, flags);
+	schedule_work(&mb0_transfer.mask_work);
+}
+
+static void noop(struct irq_data *d)
+{
+}
+
+static struct irq_chip prcmu_irq_chip = {
+	.name           = "prcmu",
+	.irq_disable    = prcmu_irq_mask,
+	.irq_ack        = noop,
+	.irq_mask       = prcmu_irq_mask,
+	.irq_unmask     = prcmu_irq_unmask,
+};
+
 void __init db5500_prcmu_early_init(void)
 {
+	unsigned int i;
+
 	tcdm_base = __io_address(U5500_PRCMU_TCDM_BASE);
 	spin_lock_init(&mb0_transfer.lock);
 	spin_lock_init(&mb0_transfer.dbb_irqs_lock);
@@ -755,6 +876,18 @@ void __init db5500_prcmu_early_init(void)
 	init_completion(&mb3_transfer.sysclk_work);
 	mutex_init(&mb5_transfer.lock);
 	init_completion(&mb5_transfer.work);
+
+	INIT_WORK(&mb0_transfer.mask_work, prcmu_mask_work);
+
+	/* Initalize irqs. */
+	for (i = 0; i < NUM_DB5500_PRCMU_WAKEUPS; i++) {
+		unsigned int irq;
+
+		irq = IRQ_DB5500_PRCMU_BASE + i;
+		irq_set_chip_and_handler(irq, &prcmu_irq_chip,
+					 handle_simple_irq);
+		set_irq_flags(irq, IRQF_VALID);
+	}
 }
 
 /**
@@ -763,7 +896,7 @@ void __init db5500_prcmu_early_init(void)
  */
 int __init db5500_prcmu_init(void)
 {
-	int r = 0;
+	int err = 0;
 
 	if (ux500_is_svp() || !cpu_is_u5500())
 		return -ENODEV;
@@ -771,13 +904,17 @@ int __init db5500_prcmu_init(void)
 	/* Clean up the mailbox interrupts after pre-kernel code. */
 	writel(ALL_MBOX_BITS, PRCM_ARM_IT1_CLR);
 
-	r = request_threaded_irq(IRQ_DB5500_PRCMU1, prcmu_irq_handler,
-		prcmu_irq_thread_fn, 0, "prcmu", NULL);
-	if (r < 0) {
+	err = request_threaded_irq(IRQ_DB5500_PRCMU1, prcmu_irq_handler,
+		prcmu_irq_thread_fn, IRQF_NO_SUSPEND, "prcmu", NULL);
+	if (err < 0) {
 		pr_err("prcmu: Failed to allocate IRQ_DB5500_PRCMU1.\n");
-		return -EBUSY;
+		err = -EBUSY;
+		goto no_irq_return;
 	}
-	return 0;
+
+no_irq_return:
+	return err;
+
 }
 
 arch_initcall(db5500_prcmu_init);
-- 
1.7.3.2

