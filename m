Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760151Ab2D0MZZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 08:25:25 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:40742 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758860Ab2D0MZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 08:25:03 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <linux-kernel@vger.kernel.org>
CC: <greg@kroah.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Aneesh V <aneesh@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH v5 5/7] memory: emif: add interrupt and temperature handling
Date: Fri, 27 Apr 2012 17:54:07 +0530
Message-ID: <1335529449-28046-6-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1335529449-28046-1-git-send-email-santosh.shilimkar@ti.com>
References: <y>
 <1335529449-28046-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aneesh V <aneesh@ti.com>

Add an ISR for EMIF that:
	1. reports details of access errors
	2. takes action on thermal events

Also clear all interrupts on shut-down. Pending IRQs
may casue problems during warm-reset.

Temperature handling:
EMIF can be configured to poll the temperature level
of an LPDDR2 device from the MR4 mode register in the
device. EMIF generates an interrupt whenever it identifies
a temperature level change between two consecutive pollings.

Some of the timing parameters need to be de-rated at high
temperatures. The interrupt handler takes care of doing
this and also takes care of going back to nominal settings
when temperature falls back to nominal levels.

Signed-off-by: Aneesh V <aneesh@ti.com>
Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Reviewed-by: Benoit Cousson <b-cousson@ti.com>
[santosh.shilimkar@ti.com: Moved to drivers/memory from drivers/misc]
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Greg KH <greg@kroah.com>
---
 drivers/memory/emif.c |  211 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 209 insertions(+), 2 deletions(-)

diff --git a/drivers/memory/emif.c b/drivers/memory/emif.c
index bd116eb..a8dcf35 100644
--- a/drivers/memory/emif.c
+++ b/drivers/memory/emif.c
@@ -545,6 +545,42 @@ static u32 get_pwr_mgmt_ctrl(u32 freq, struct emif_data *emif, u32 ip_rev)
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
+	/* treat everything less than nominal(3) in MR4 as nominal */
+	if (unlikely(temperature_level < SDRAM_TEMP_NOMINAL))
+		temperature_level = SDRAM_TEMP_NOMINAL;
+
+	/* if we get reserved value in MR4 persist with the existing value */
+	if (likely(temperature_level != SDRAM_TEMP_RESERVED_4))
+		emif->temperature_level = temperature_level;
+}
+
+/*
  * Program EMIF shadow registers that are not dependent on temperature
  * or voltage
  */
@@ -627,6 +663,158 @@ out:
 	writel(ref_ctrl, base + EMIF_SDRAM_REFRESH_CTRL_SHDW);
 }
 
+static irqreturn_t handle_temp_alert(void __iomem *base, struct emif_data *emif)
+{
+	u32		old_temp_level;
+	irqreturn_t	ret = IRQ_HANDLED;
+
+	spin_lock_irqsave(&emif_lock, irq_state);
+	old_temp_level = emif->temperature_level;
+	get_temperature_level(emif);
+
+	if (unlikely(emif->temperature_level == old_temp_level)) {
+		goto out;
+	} else if (!emif->curr_regs) {
+		dev_err(emif->dev, "temperature alert before registers are calculated, not de-rating timings\n");
+		goto out;
+	}
+
+	if (emif->temperature_level < old_temp_level ||
+		emif->temperature_level == SDRAM_TEMP_VERY_HIGH_SHUTDOWN) {
+		/*
+		 * Temperature coming down - defer handling to thread OR
+		 * Temperature far too high - do kernel_power_off() from
+		 * thread context
+		 */
+		ret = IRQ_WAKE_THREAD;
+	} else {
+		/* Temperature is going up - handle immediately */
+		setup_temperature_sensitive_regs(emif, emif->curr_regs);
+		do_freq_update();
+	}
+
+out:
+	spin_unlock_irqrestore(&emif_lock, irq_state);
+	return ret;
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
+	spin_lock_irqsave(&emif_lock, irq_state);
+
+	if (emif->curr_regs) {
+		setup_temperature_sensitive_regs(emif, emif->curr_regs);
+		do_freq_update();
+	} else {
+		dev_err(emif->dev, "temperature alert before registers are calculated, not de-rating timings\n");
+	}
+
+	spin_unlock_irqrestore(&emif_lock, irq_state);
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
+static int __init_or_module setup_interrupts(struct emif_data *emif, u32 irq)
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
+	return devm_request_threaded_irq(emif->dev, irq,
+				    emif_interrupt_handler,
+				    emif_threaded_isr,
+				    0, dev_name(emif->dev),
+				    emif);
+
+}
+
 static void get_default_timings(struct emif_data *emif)
 {
 	struct emif_platform_data *pd = emif->plat_data;
@@ -803,6 +991,7 @@ static int __init_or_module emif_probe(struct platform_device *pdev)
 {
 	struct emif_data	*emif;
 	struct resource		*res;
+	int			irq;
 
 	emif = get_device_details(pdev);
 	if (!emif) {
@@ -831,6 +1020,16 @@ static int __init_or_module emif_probe(struct platform_device *pdev)
 		goto error;
 	}
 
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		dev_err(emif->dev, "%s: error getting IRQ resource - %d\n",
+			__func__, irq);
+		goto error;
+	}
+
+	disable_and_clear_all_interrupts(emif);
+	setup_interrupts(emif, irq);
+
 	/* One-time actions taken on probing the first device */
 	if (!emif1) {
 		emif1 = emif;
@@ -843,14 +1042,21 @@ static int __init_or_module emif_probe(struct platform_device *pdev)
 		 */
 	}
 
-	dev_info(&pdev->dev, "%s: device configured with addr = %p\n",
-		__func__, emif->base);
+	dev_info(&pdev->dev, "%s: device configured with addr = %p and IRQ%d\n",
+		__func__, emif->base, irq);
 
 	return 0;
 error:
 	return -ENODEV;
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
@@ -1154,6 +1360,7 @@ static void __attribute__((unused)) freq_post_notify_handling(void)
 }
 
 static struct platform_driver emif_driver = {
+	.shutdown	= emif_shutdown,
 	.driver = {
 		.name = "emif",
 	},
-- 
1.7.5.4

