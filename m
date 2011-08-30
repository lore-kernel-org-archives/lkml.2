Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab1H3SPm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 14:15:42 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19013 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643Ab1H3SPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 14:15:40 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 30 Aug 2011 11:15:38 -0700
From: riyer@nvidia.com
To: dmitry.torokhov@gmail.com
Cc: rydberg@euromail.se, olof@lixom.net, amartin@nvidia.com,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-tegra@vger.kernel.org, Rakesh Iyer <riyer@nvidia.com>
Subject: [PATCH v2] Input: tegra-kbc - fix wakeup from suspend.
Date: Tue, 30 Aug 2011 11:15:36 -0700
Message-Id: <1314728136-10754-1-git-send-email-riyer@nvidia.com>
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
v2: Incorporated Dmitry Torokhov's recommended changes.
v1: Initial patch.

 drivers/input/keyboard/tegra-kbc.c |   81 +++++++++++++++++++++++++++++------
 1 files changed, 67 insertions(+), 14 deletions(-)

diff --git a/drivers/input/keyboard/tegra-kbc.c b/drivers/input/keyboard/tegra-kbc.c
index a5a7791..f0507bf 100644
--- a/drivers/input/keyboard/tegra-kbc.c
+++ b/drivers/input/keyboard/tegra-kbc.c
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
@@ -735,10 +757,30 @@ static int tegra_kbc_suspend(struct device *dev)
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
+		del_timer_sync(&kbc->timer);
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
+		disable_irq(kbc->irq);
+		enable_irq_wake(kbc->irq);
 		msleep(30);
 	} else {
 		mutex_lock(&kbc->idev->mutex);
@@ -757,8 +799,19 @@ static int tegra_kbc_resume(struct device *dev)
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
+		enable_irq(kbc->irq);
+		spin_lock_irqsave(&kbc->lock, flags);
+		tegra_kbc_set_fifo_interrupt(kbc, true);
+		spin_unlock_irqrestore(&kbc->lock, flags);
 	} else {
 		mutex_lock(&kbc->idev->mutex);
 		if (kbc->idev->users)
-- 
1.7.1

