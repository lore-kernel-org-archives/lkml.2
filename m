Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133Ab2BDMRT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 07:17:19 -0500
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:42399 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753943Ab2BDMRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 07:17:14 -0500
From: Aneesh V <aneesh@ti.com>
To: linux-omap@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Aneesh V <aneesh@ti.com>
Subject: [RFC PATCH 6/8] misc: emif: add interrupt and temperature handling
Date: Sat,  4 Feb 2012 17:46:09 +0530
Message-Id: <1328357771-31644-7-git-send-email-aneesh@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1328357771-31644-1-git-send-email-aneesh@ti.com>
References: <1328357771-31644-1-git-send-email-aneesh@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an ISR for EMIF that:
	1. reports details of access errors
	2. takes action on thermal events

On thermal events SDRAM timing parameters are
adjusted to ensure safe operation

Also clear all interrupts on shut-down. Pending IRQs
may casue problems during warm-reset.

Signed-off-by: Aneesh V <aneesh@ti.com>
---
 drivers/misc/emif.c |  209 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 207 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/emif.c b/drivers/misc/emif.c
index 36ba6f4..5c2b0ae 100644
--- a/drivers/misc/emif.c
+++ b/drivers/misc/emif.c
@@ -500,6 +500,45 @@ static u32 get_pwr_mgmt_ctrl(u32 freq, struct emif_data *emif, u32 ip_rev)
 }
 
 /*
+ * Get the temperature level of the EMIF instance:
+ * Reads the MR4 register of attached SDRAM parts to find out the temperature
+ * level. If there are two parts attached(one on each CS), then the temperature
+ * level for the EMIF instance is the higher of the two temperatures.
+ */
+static void get_temperature_level(struct emif_data *emif)
+{
+	u32		temp, temperature_level;
+	unsigned long	irqs;
+	void __iomem	*base;
+
+	base = emif->base;
+
+	/* Read mode register 4 */
+	writel(DDR_MR4, base + EMIF_LPDDR2_MODE_REG_CONFIG);
+	temperature_level = readl(base + EMIF_LPDDR2_MODE_REG_DATA);
+	temperature_level = (temperature_level & MR4_SDRAM_REF_RATE_MASK) >>
+				MR4_SDRAM_REF_RATE_SHIFT;
+
+	if (emif->plat_data->device_info->cs1_used) {
+		writel(DDR_MR4 | CS_MASK, base + EMIF_LPDDR2_MODE_REG_CONFIG);
+		temp = readl(base + EMIF_LPDDR2_MODE_REG_DATA);
+		temp = (temp & MR4_SDRAM_REF_RATE_MASK)
+				>> MR4_SDRAM_REF_RATE_SHIFT;
+		temperature_level = max(temp, temperature_level);
+	}
+
+	spin_lock_irqsave(&emif->lock, irqs);
+	/* treat everything less than nominal(3) in MR4 as nominal */
+	if (unlikely(temperature_level < SDRAM_TEMP_NOMINAL))
+		temperature_level = SDRAM_TEMP_NOMINAL;
+
+	/* if we get reserved value in MR4 persist with the existing value */
+	if (likely(temperature_level != SDRAM_TEMP_RESERVED_4))
+		emif->temperature_level = temperature_level;
+	spin_unlock_irqrestore(&emif->lock, irqs);
+}
+
+/*
  * Program EMIF shadow registers that are not dependent on temperature
  * or voltage
  */
@@ -553,7 +592,8 @@ static void setup_volt_sensitive_regs(struct emif_data *emif,
 static void setup_temperature_sensitive_regs(struct emif_data *emif,
 		struct emif_regs *regs)
 {
-	u32		tim1, tim3, ref_ctrl, type, irqs;
+	u32		tim1, tim3, ref_ctrl, type;
+	unsigned long	irqs;
 	void __iomem	*base = emif->base;
 	u32		temperature;
 
@@ -568,7 +608,7 @@ static void setup_temperature_sensitive_regs(struct emif_data *emif,
 	if (type != DDR_TYPE_LPDDR2_S2 && type != DDR_TYPE_LPDDR2_S4)
 		goto out;
 
-	temperature_level = emif->temperature_level;
+	temperature = emif->temperature_level;
 	if (temperature == SDRAM_TEMP_HIGH_DERATE_REFRESH) {
 		ref_ctrl = regs->ref_ctrl_shdw_derated;
 	} else if (temperature == SDRAM_TEMP_HIGH_DERATE_REFRESH_AND_TIMINGS) {
@@ -584,6 +624,153 @@ out:
 	spin_unlock_irqrestore(&emif->lock, irqs);
 }
 
+static irqreturn_t handle_temp_alert(void __iomem *base, struct emif_data *emif)
+{
+	u32		old_temp_level;
+
+	old_temp_level = emif->temperature_level;
+	get_temperature_level(emif);
+
+	if (unlikely(emif->temperature_level == old_temp_level))
+		goto handled;
+
+	if (emif->temperature_level < old_temp_level ||
+		emif->temperature_level == SDRAM_TEMP_VERY_HIGH_SHUTDOWN) {
+		/*
+		 * Temperature coming down - defer handling to thread OR
+		 * Temperature far too high - do kernel_power_off() from
+		 * thread context
+		 */
+		goto thread;
+	} else {
+		/* Temperature is going up - handle immediately */
+		if (!emif->curr_regs) {
+			dev_err(emif->dev, "temperature alert before registers are calculated, not de-rating timings\n");
+			goto handled;
+		}
+		setup_temperature_sensitive_regs(emif, emif->curr_regs);
+		do_freq_update();
+	}
+
+handled:
+	return IRQ_HANDLED;
+thread:
+	return IRQ_WAKE_THREAD;
+}
+
+static irqreturn_t emif_interrupt_handler(int irq, void *dev_id)
+{
+	u32			interrupts;
+	struct emif_data	*emif = dev_id;
+	void __iomem		*base = emif->base;
+	struct device		*dev = emif->dev;
+	irqreturn_t		ret = IRQ_HANDLED;
+
+	/* Save the status and clear it */
+	interrupts = readl(base + EMIF_SYSTEM_OCP_INTERRUPT_STATUS);
+	writel(interrupts, base + EMIF_SYSTEM_OCP_INTERRUPT_STATUS);
+
+	/*
+	 * Handle temperature alert
+	 * Temperature alert should be same for all ports
+	 * So, it's enough to process it only for one of the ports
+	 */
+	if (interrupts & TA_SYS_MASK)
+		ret = handle_temp_alert(base, emif);
+
+	if (interrupts & ERR_SYS_MASK)
+		dev_err(dev, "Access error from SYS port - %x\n", interrupts);
+
+	if (emif->plat_data->hw_caps & EMIF_HW_CAPS_LL_INTERFACE) {
+		/* Save the status and clear it */
+		interrupts = readl(base + EMIF_LL_OCP_INTERRUPT_STATUS);
+		writel(interrupts, base + EMIF_LL_OCP_INTERRUPT_STATUS);
+
+		if (interrupts & ERR_LL_MASK)
+			dev_err(dev, "Access error from LL port - %x\n",
+				interrupts);
+	}
+
+	return ret;
+}
+
+static irqreturn_t emif_threaded_isr(int irq, void *dev_id)
+{
+	struct emif_data	*emif = dev_id;
+
+	if (emif->temperature_level == SDRAM_TEMP_VERY_HIGH_SHUTDOWN) {
+		dev_emerg(emif->dev, "SDRAM temperature exceeds operating limit.. Needs shut down!!!\n");
+		kernel_power_off();
+		return IRQ_HANDLED;
+	}
+
+	if (emif->curr_regs) {
+		setup_temperature_sensitive_regs(emif, emif->curr_regs);
+		do_freq_update();
+	} else {
+		dev_err(emif->dev, "temperature alert before registers are calculated, not de-rating timings\n");
+	}
+
+	return IRQ_HANDLED;
+}
+
+static void clear_all_interrupts(struct emif_data *emif)
+{
+	void __iomem	*base = emif->base;
+
+	writel(readl(base + EMIF_SYSTEM_OCP_INTERRUPT_STATUS),
+		base + EMIF_SYSTEM_OCP_INTERRUPT_STATUS);
+	if (emif->plat_data->hw_caps & EMIF_HW_CAPS_LL_INTERFACE)
+		writel(readl(base + EMIF_LL_OCP_INTERRUPT_STATUS),
+			base + EMIF_LL_OCP_INTERRUPT_STATUS);
+}
+
+static void disable_and_clear_all_interrupts(struct emif_data *emif)
+{
+	void __iomem		*base = emif->base;
+
+	/* Disable all interrupts */
+	writel(readl(base + EMIF_SYSTEM_OCP_INTERRUPT_ENABLE_SET),
+		base + EMIF_SYSTEM_OCP_INTERRUPT_ENABLE_CLEAR);
+	if (emif->plat_data->hw_caps & EMIF_HW_CAPS_LL_INTERFACE)
+		writel(readl(base + EMIF_LL_OCP_INTERRUPT_ENABLE_SET),
+			base + EMIF_LL_OCP_INTERRUPT_ENABLE_CLEAR);
+
+	/* Clear all interrupts */
+	clear_all_interrupts(emif);
+}
+
+static int __init setup_interrupts(struct emif_data *emif)
+{
+	u32		interrupts, type;
+	void __iomem	*base = emif->base;
+
+	type = emif->plat_data->device_info->type;
+
+	clear_all_interrupts(emif);
+
+	/* Enable interrupts for SYS interface */
+	interrupts = EN_ERR_SYS_MASK;
+	if (type == DDR_TYPE_LPDDR2_S2 || type == DDR_TYPE_LPDDR2_S4)
+		interrupts |= EN_TA_SYS_MASK;
+	writel(interrupts, base + EMIF_SYSTEM_OCP_INTERRUPT_ENABLE_SET);
+
+	/* Enable interrupts for LL interface */
+	if (emif->plat_data->hw_caps & EMIF_HW_CAPS_LL_INTERFACE) {
+		/* TA need not be enabled for LL */
+		interrupts = EN_ERR_LL_MASK;
+		writel(interrupts, base + EMIF_LL_OCP_INTERRUPT_ENABLE_SET);
+	}
+
+	/* setup IRQ handlers */
+	return request_threaded_irq(emif->irq,
+				    emif_interrupt_handler,
+				    emif_threaded_isr,
+				    0, dev_name(emif->dev),
+				    emif);
+
+}
+
 static void __exit cleanup_emif(struct emif_data *emif)
 {
 	if (emif) {
@@ -779,6 +966,8 @@ static int __init emif_probe(struct platform_device *pdev)
 		goto error;
 	emif->irq = res->start;
 
+	disable_and_clear_all_interrupts(emif);
+
 	dev_info(&pdev->dev, "Device configured with addr = %p and IRQ%d\n",
 			emif->base, emif->irq);
 	return 0;
@@ -798,6 +987,13 @@ static int __exit emif_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static void emif_shutdown(struct platform_device *pdev)
+{
+	struct emif_data	*emif = platform_get_drvdata(pdev);
+
+	disable_and_clear_all_interrupts(emif);
+}
+
 static int get_emif_reg_values(struct emif_data *emif, u32 freq,
 		struct emif_regs *regs)
 {
@@ -1002,6 +1198,14 @@ static void __attribute__((unused)) do_freq_pre_notify_handling(void *emif_data,
 	if (!regs)
 		return;
 
+	/*
+	 * As soon as registers are calculated for the first time
+	 * setup interrupts. We are ready to handle the thermal events
+	 * now.
+	 */
+	if (!emif->curr_regs)
+		setup_interrupts(emif);
+
 	emif->curr_regs = regs;
 
 	/*
@@ -1018,6 +1222,7 @@ static void __attribute__((unused)) do_freq_pre_notify_handling(void *emif_data,
 
 static struct platform_driver emif_driver = {
 	.remove		= __exit_p(emif_remove),
+	.shutdown	= emif_shutdown,
 	.driver = {
 		.name = "emif",
 	},
-- 
1.7.1

