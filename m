Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab2HTKt4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 06:49:56 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44528 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678Ab2HTKty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 06:49:54 -0400
Date: Mon, 20 Aug 2012 11:49:49 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 5/8] mfd: Provide the PRCMU with its own IRQ domain
Message-ID: <20120820104944.GM8450@gmail.com>
References: <1344527635-6163-1-git-send-email-lee.jones@linaro.org>
 <1344527635-6163-6-git-send-email-lee.jones@linaro.org>
 <CACRpkdZ7bMBytyDppV2sB1d1sUbDpPRqAQVOq8k4UOYdmg+Mkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZ7bMBytyDppV2sB1d1sUbDpPRqAQVOq8k4UOYdmg+Mkw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lee Jones <lee.jones@linaro.org>
Date: Fri, 3 Aug 2012 15:45:50 +0100
Subject: [PATCH 1/1] mfd: Provide the PRCMU with its own IRQ domain

The PRCMU has its own USB, Thermal, GPIO, Modem, HSI and RTC drivers,
amongst other things. This patch allows those subordinate devices to
use it as an interrupt controller as and when they are DT enabled.

CC: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/db8500-prcmu.c |   48 ++++++++++++++++++++++++++++++++------------
 1 file changed, 35 insertions(+), 13 deletions(-)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index 7040a00..de09113 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -270,6 +270,8 @@ static struct {
 	struct prcmu_fw_version version;
 } fw_info;
 
+static struct irq_domain *db8500_irq_domain;
+
 /*
  * This vector maps irq numbers to the bits in the bit field used in
  * communication with the PRCMU firmware.
@@ -2583,7 +2585,7 @@ static void prcmu_irq_mask(struct irq_data *d)
 
 	spin_lock_irqsave(&mb0_transfer.dbb_irqs_lock, flags);
 
-	mb0_transfer.req.dbb_irqs &= ~prcmu_irq_bit[d->irq - IRQ_PRCMU_BASE];
+	mb0_transfer.req.dbb_irqs &= ~prcmu_irq_bit[d->hwirq];
 
 	spin_unlock_irqrestore(&mb0_transfer.dbb_irqs_lock, flags);
 
@@ -2597,7 +2599,7 @@ static void prcmu_irq_unmask(struct irq_data *d)
 
 	spin_lock_irqsave(&mb0_transfer.dbb_irqs_lock, flags);
 
-	mb0_transfer.req.dbb_irqs |= prcmu_irq_bit[d->irq - IRQ_PRCMU_BASE];
+	mb0_transfer.req.dbb_irqs |= prcmu_irq_bit[d->hwirq];
 
 	spin_unlock_irqrestore(&mb0_transfer.dbb_irqs_lock, flags);
 
@@ -2637,9 +2639,37 @@ static char *fw_project_name(u8 project)
 	}
 }
 
+static int db8500_irq_map(struct irq_domain *d, unsigned int virq,
+				irq_hw_number_t hwirq)
+{
+	irq_set_chip_and_handler(virq, &prcmu_irq_chip,
+				handle_simple_irq);
+	set_irq_flags(virq, IRQF_VALID);
+
+	return 0;
+}
+
+static struct irq_domain_ops db8500_irq_ops = {
+        .map    = db8500_irq_map,
+        .xlate  = irq_domain_xlate_twocell,
+};
+
+static int db8500_irq_init(struct device_node *np)
+{
+	db8500_irq_domain = irq_domain_add_legacy(
+		np, NUM_PRCMU_WAKEUPS, IRQ_PRCMU_BASE,
+		0, &db8500_irq_ops, NULL);
+
+	if (!db8500_irq_domain) {
+		pr_err("Failed to create irqdomain\n");
+		return -ENOSYS;
+	}
+
+	return 0;
+}
+
 void __init db8500_prcmu_early_init(void)
 {
-	unsigned int i;
 	if (cpu_is_u8500v2()) {
 		void *tcpm_base = ioremap_nocache(U8500_PRCMU_TCPM_BASE, SZ_4K);
 
@@ -2683,16 +2713,6 @@ void __init db8500_prcmu_early_init(void)
 	init_completion(&mb5_transfer.work);
 
 	INIT_WORK(&mb0_transfer.mask_work, prcmu_mask_work);
-
-	/* Initalize irqs. */
-	for (i = 0; i < NUM_PRCMU_WAKEUPS; i++) {
-		unsigned int irq;
-
-		irq = IRQ_PRCMU_BASE + i;
-		irq_set_chip_and_handler(irq, &prcmu_irq_chip,
-					 handle_simple_irq);
-		set_irq_flags(irq, IRQF_VALID);
-	}
 }
 
 static void __init init_prcm_registers(void)
@@ -2999,6 +3019,8 @@ static int __devinit db8500_prcmu_probe(struct platform_device *pdev)
 		goto no_irq_return;
 	}
 
+	db8500_irq_init(np);
+
 	for (i = 0; i < ARRAY_SIZE(db8500_prcmu_devs); i++) {
 		if (!strcmp(db8500_prcmu_devs[i].name, "ab8500-core")) {
 			db8500_prcmu_devs[i].platform_data = ab8500_platdata;
-- 
1.7.9.5
