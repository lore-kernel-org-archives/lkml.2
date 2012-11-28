Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936Ab2K1Sfp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 13:35:45 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:45378 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755904Ab2K1Sfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 13:35:40 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: sameo@linux.intel.com, grant.likely@secretlab.ca,
        rabin.vincent@stericsson.com, shiraz.hashim@st.com
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, lee.jones@linaro.org,
        linus.walleij@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V4 2/3] mfd: stmpe: Remove irq_trigger from platform data
Date: Thu, 29 Nov 2012 00:05:21 +0530
Message-Id: <ebfdea124d815ee6b2ecdd8b68e8330a952cc626.1354127005.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <ed0ae069e49728a4c17f16e1735d8ffd6b1e0060.1354127005.git.viresh.kumar@linaro.org>
References: <ed0ae069e49728a4c17f16e1735d8ffd6b1e0060.1354127005.git.viresh.kumar@linaro.org>
In-Reply-To: <ed0ae069e49728a4c17f16e1735d8ffd6b1e0060.1354127005.git.viresh.kumar@linaro.org>
References: <ed0ae069e49728a4c17f16e1735d8ffd6b1e0060.1354127005.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

STMPE can confige the way the device emits interrupts and till now this
information is passed as part of platform data.

It would actually be good to ask the interrupt controller driver what kind of
interrupt signal it expects for a given interrupt line. We can get the irq type
by calling: irqd_get_trigger_type() routine.

So, now we don't need to pass it via platform data. This is earlier discussed
here:

https://lkml.org/lkml/2012/11/26/711

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---

Linus/Shiraz: Can you please test this patch? You don't really need to test 1/3
and 3/3, but would be good if you do that too..

This is actually V1 of this patch.

 arch/arm/mach-ux500/board-mop500-stuib.c | 1 -
 drivers/mfd/stmpe.c                      | 8 +++++---
 include/linux/mfd/stmpe.h                | 4 ++--
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-stuib.c b/arch/arm/mach-ux500/board-mop500-stuib.c
index 564f57d..0efcf97 100644
--- a/arch/arm/mach-ux500/board-mop500-stuib.c
+++ b/arch/arm/mach-ux500/board-mop500-stuib.c
@@ -57,7 +57,6 @@ static struct stmpe_keypad_platform_data stmpe1601_keypad_data = {
 static struct stmpe_platform_data stmpe1601_data = {
 	.id		= 1,
 	.blocks		= STMPE_BLOCK_KEYPAD,
-	.irq_trigger    = IRQF_TRIGGER_FALLING,
 	.irq_base       = MOP500_STMPE1601_IRQ(0),
 	.keypad		= &stmpe1601_keypad_data,
 	.autosleep      = true,
diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
index fece28b..fa22ef4 100644
--- a/drivers/mfd/stmpe.c
+++ b/drivers/mfd/stmpe.c
@@ -914,7 +914,7 @@ static int __devinit stmpe_irq_init(struct stmpe *stmpe,
 
 static int __devinit stmpe_chip_init(struct stmpe *stmpe)
 {
-	unsigned int irq_trigger = stmpe->pdata->irq_trigger;
+	unsigned int irq_trigger = stmpe->irq_trigger;
 	int autosleep_timeout = stmpe->pdata->autosleep_timeout;
 	struct stmpe_variant_info *variant = stmpe->variant;
 	u8 icr = 0;
@@ -1106,6 +1106,9 @@ int __devinit stmpe_probe(struct stmpe_client_info *ci, int partnum)
 			return -ENODEV;
 		}
 		stmpe->variant = stmpe_noirq_variant_info[stmpe->partnum];
+	} else {
+		stmpe->irq_trigger =
+			irqd_get_trigger_type(irq_get_irq_data(stmpe->irq));
 	}
 
 	ret = stmpe_chip_init(stmpe);
@@ -1118,8 +1121,7 @@ int __devinit stmpe_probe(struct stmpe_client_info *ci, int partnum)
 			return ret;
 
 		ret = devm_request_threaded_irq(ci->dev, stmpe->irq, NULL,
-				stmpe_irq, pdata->irq_trigger | IRQF_ONESHOT,
-				"stmpe", stmpe);
+				stmpe_irq, IRQF_ONESHOT, "stmpe", stmpe);
 		if (ret) {
 			dev_err(stmpe->dev, "failed to request IRQ: %d\n",
 					ret);
diff --git a/include/linux/mfd/stmpe.h b/include/linux/mfd/stmpe.h
index 383ac15..0f2ea36 100644
--- a/include/linux/mfd/stmpe.h
+++ b/include/linux/mfd/stmpe.h
@@ -71,6 +71,7 @@ struct stmpe_client_info;
  *	  different variants.  Indexed by one of STMPE_IDX_*.
  * @irq: irq number for stmpe
  * @irq_base: starting IRQ number for internal IRQs
+ * @irq_trigger: IRQ trigger to use for the interrupt to the host
  * @num_gpios: number of gpios, differs for variants
  * @ier: cache of IER registers for bus_lock
  * @oldier: cache of IER registers for bus_lock
@@ -89,6 +90,7 @@ struct stmpe {
 
 	int irq;
 	int irq_base;
+	unsigned int irq_trigger;
 	int num_gpios;
 	u8 ier[2];
 	u8 oldier[2];
@@ -189,7 +191,6 @@ struct stmpe_ts_platform_data {
  * struct stmpe_platform_data - STMPE platform data
  * @id: device id to distinguish between multiple STMPEs on the same board
  * @blocks: bitmask of blocks to enable (use STMPE_BLOCK_*)
- * @irq_trigger: IRQ trigger to use for the interrupt to the host
  * @autosleep: bool to enable/disable stmpe autosleep
  * @autosleep_timeout: inactivity timeout in milliseconds for autosleep
  * @irq_base: base IRQ number.  %STMPE_NR_IRQS irqs will be used, or
@@ -205,7 +206,6 @@ struct stmpe_platform_data {
 	int id;
 	unsigned int blocks;
 	int irq_base;
-	unsigned int irq_trigger;
 	bool autosleep;
 	bool irq_over_gpio;
 	int irq_gpio;
-- 
1.7.12.rc2.18.g61b472e

