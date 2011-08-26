Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab1HZA3m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 20:29:42 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16293 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126Ab1HZA3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 20:29:41 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 25 Aug 2011 17:29:40 -0700
From: riyer@nvidia.com
To: dmitry.torokhov@gmail.com
Cc: rydberg@euromail.se, axel.lin@gmail.com, olof@lixom.net,
        amartin@nvidia.com, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, Rakesh Iyer <riyer@nvidia.com>
Subject: [PATCH v1] Input: tegra-kbc - fix wakeup from suspend.
Date: Thu, 25 Aug 2011 17:29:47 -0700
Message-Id: <1314318587-31348-1-git-send-email-riyer@nvidia.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rakesh Iyer <riyer@nvidia.com>

For wakeup to be reliable, kbc needs to be in interrupt mode before suspend.
Created common routine to control the FIFO interrupt.
Added synchronization to ensure orderly suspend.

Signed-off-by: Rakesh Iyer <riyer@nvidia.com>
---
 drivers/input/keyboard/tegra-kbc.c |   83 +++++++++++++++++++++++++++++-------
 1 files changed, 67 insertions(+), 16 deletions(-)

diff --git a/drivers/input/keyboard/tegra-kbc.c b/drivers/input/keyboard/tegra-kbc.c
index a5a7791..41de11f 100644
--- a/drivers/input/keyboard/tegra-kbc.c
+++ b/drivers/input/keyboard/tegra-kbc.c
@@ -38,7 +38,7 @@
 #define KBC_ROW_SCAN_DLY	5
 
 /* KBC uses a 32KHz clock so a cycle = 1/32Khz */
-#define KBC_CYCLE_MS	32
+#define KBC_CYCLES_PER_MS	32
 
 /* KBC Registers */
 
@@ -55,6 +55,7 @@
 
 #define KBC_ROW_CFG0_0	0x8
 #define KBC_COL_CFG0_0	0x18
+#define KBC_TO_CNT_0	0x24
 #define KBC_INIT_DLY_0	0x28
 #define KBC_RPT_DLY_0	0x2c
 #define KBC_KP_ENT0_0	0x30
@@ -70,8 +71,10 @@ struct tegra_kbc {
 	spinlock_t lock;
 	unsigned int repoll_dly;
 	unsigned long cp_dly_jiffies;
+	unsigned int cp_to_wkup_dly;
 	bool use_fn_map;
 	bool use_ghost_filter;
+	bool in_suspend;
 	const struct tegra_kbc_platform_data *pdata;
 	unsigned short keycode[KBC_MAX_KEY * 2];
 	unsigned short current_keys[KBC_MAX_KPENT];
@@ -341,6 +344,18 @@ static void tegra_kbc_report_keys(struct tegra_kbc *kbc)
 	kbc->num_pressed_keys = num_down;
 }
 
+static void tegra_kbc_set_fifo_interrupt(struct tegra_kbc *kbc, bool enable)
+{
+	u32 val;
+
+	val = readl(kbc->mmio + KBC_CONTROL_0);
+	if (enable)
+		val |= KBC_CONTROL_FIFO_CNT_INT_EN;
+	else
+		val &= ~KBC_CONTROL_FIFO_CNT_INT_EN;
+	writel(val, kbc->mmio + KBC_CONTROL_0);
+}
+
 static void tegra_kbc_keypress_timer(unsigned long data)
 {
 	struct tegra_kbc *kbc = (struct tegra_kbc *)data;
@@ -348,6 +363,14 @@ static void tegra_kbc_keypress_timer(unsigned long data)
 	u32 val;
 	unsigned int i;
 
+	/* Exit immediately if driver is trying to enter suspend. */
+	spin_lock_irqsave(&kbc->lock, flags);
+	if (kbc->in_suspend) {
+		tegra_kbc_set_fifo_interrupt(kbc, true);
+		spin_unlock_irqrestore(&kbc->lock, flags);
+		return;
+	}
+	spin_unlock_irqrestore(&kbc->lock, flags);
 	val = (readl(kbc->mmio + KBC_INT_0) >> 4) & 0xf;
 	if (val) {
 		unsigned long dly;
@@ -370,9 +393,7 @@ static void tegra_kbc_keypress_timer(unsigned long data)
 
 		/* All keys are released so enable the keypress interrupt */
 		spin_lock_irqsave(&kbc->lock, flags);
-		val = readl(kbc->mmio + KBC_CONTROL_0);
-		val |= KBC_CONTROL_FIFO_CNT_INT_EN;
-		writel(val, kbc->mmio + KBC_CONTROL_0);
+		tegra_kbc_set_fifo_interrupt(kbc, true);
 		spin_unlock_irqrestore(&kbc->lock, flags);
 	}
 }
@@ -380,15 +401,14 @@ static void tegra_kbc_keypress_timer(unsigned long data)
 static irqreturn_t tegra_kbc_isr(int irq, void *args)
 {
 	struct tegra_kbc *kbc = args;
-	u32 val, ctl;
+	unsigned long flags;
+	u32 val;
 
 	/*
 	 * Until all keys are released, defer further processing to
 	 * the polling loop in tegra_kbc_keypress_timer
 	 */
-	ctl = readl(kbc->mmio + KBC_CONTROL_0);
-	ctl &= ~KBC_CONTROL_FIFO_CNT_INT_EN;
-	writel(ctl, kbc->mmio + KBC_CONTROL_0);
+	tegra_kbc_set_fifo_interrupt(kbc, false);
 
 	/*
 	 * Quickly bail out & reenable interrupts if the fifo threshold
@@ -397,16 +417,18 @@ static irqreturn_t tegra_kbc_isr(int irq, void *args)
 	val = readl(kbc->mmio + KBC_INT_0);
 	writel(val, kbc->mmio + KBC_INT_0);
 
-	if (val & KBC_INT_FIFO_CNT_INT_STATUS) {
+	/* Exit immediately if driver is trying to enter suspend. */
+	spin_lock_irqsave(&kbc->lock, flags);
+	if (!kbc->in_suspend && (val & KBC_INT_FIFO_CNT_INT_STATUS))
 		/*
 		 * Schedule timer to run when hardware is in continuous
 		 * polling mode.
 		 */
 		mod_timer(&kbc->timer, jiffies + kbc->cp_dly_jiffies);
-	} else {
-		ctl |= KBC_CONTROL_FIFO_CNT_INT_EN;
-		writel(ctl, kbc->mmio + KBC_CONTROL_0);
-	}
+	else
+		tegra_kbc_set_fifo_interrupt(kbc, true);
+
+	spin_unlock_irqrestore(&kbc->lock, flags);
 
 	return IRQ_HANDLED;
 }
@@ -648,7 +670,7 @@ static int __devinit tegra_kbc_probe(struct platform_device *pdev)
 	debounce_cnt = min(pdata->debounce_cnt, KBC_MAX_DEBOUNCE_CNT);
 	scan_time_rows = (KBC_ROW_SCAN_TIME + debounce_cnt) * num_rows;
 	kbc->repoll_dly = KBC_ROW_SCAN_DLY + scan_time_rows + pdata->repeat_cnt;
-	kbc->repoll_dly = DIV_ROUND_UP(kbc->repoll_dly, KBC_CYCLE_MS);
+	kbc->repoll_dly = DIV_ROUND_UP(kbc->repoll_dly, KBC_CYCLES_PER_MS);
 
 	input_dev->name = pdev->name;
 	input_dev->id.bustype = BUS_HOST;
@@ -735,10 +757,29 @@ static int tegra_kbc_suspend(struct device *dev)
 	struct tegra_kbc *kbc = platform_get_drvdata(pdev);
 
 	if (device_may_wakeup(&pdev->dev)) {
-		tegra_kbc_setup_wakekeys(kbc, true);
-		enable_irq_wake(kbc->irq);
+		unsigned long flags;
+
+		spin_lock_irqsave(&kbc->lock, flags);
+		kbc->in_suspend = 1;
+		spin_unlock_irqrestore(&kbc->lock, flags);
+
+		del_timer(&kbc->timer);
+
+		spin_lock_irqsave(&kbc->lock, flags);
+		tegra_kbc_set_fifo_interrupt(kbc, false);
+		spin_unlock_irqrestore(&kbc->lock, flags);
+
 		/* Forcefully clear the interrupt status */
 		writel(0x7, kbc->mmio + KBC_INT_0);
+		/*
+		 * Store the previous resident time of continuous polling mode.
+		 * Force the keyboard into interrupt mode.
+		 */
+		kbc->cp_to_wkup_dly = readl(kbc->mmio + KBC_TO_CNT_0);
+		writel(0, kbc->mmio + KBC_TO_CNT_0);
+
+		tegra_kbc_setup_wakekeys(kbc, true);
+		enable_irq_wake(kbc->irq);
 		msleep(30);
 	} else {
 		mutex_lock(&kbc->idev->mutex);
@@ -757,8 +798,18 @@ static int tegra_kbc_resume(struct device *dev)
 	int err = 0;
 
 	if (device_may_wakeup(&pdev->dev)) {
+		unsigned long flags;
+
 		disable_irq_wake(kbc->irq);
 		tegra_kbc_setup_wakekeys(kbc, false);
+
+		/* Restore the resident time of continuous polling mode. */
+		writel(kbc->cp_to_wkup_dly, kbc->mmio + KBC_TO_CNT_0);
+		kbc->in_suspend = 0;
+
+		spin_lock_irqsave(&kbc->lock, flags);
+		tegra_kbc_set_fifo_interrupt(kbc, true);
+		spin_unlock_irqrestore(&kbc->lock, flags);
 	} else {
 		mutex_lock(&kbc->idev->mutex);
 		if (kbc->idev->users)
-- 
1.7.1

