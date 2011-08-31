Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab1HaXie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 19:38:34 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:14927 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898Ab1HaXic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 19:38:32 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 31 Aug 2011 16:38:31 -0700
From: riyer@nvidia.com
To: dmitry.torokhov@gmail.com
Cc: rydberg@euromail.se, olof@lixom.net, amartin@nvidia.com,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-tegra@vger.kernel.org, Rakesh Iyer <riyer@nvidia.com>
Subject: [PATCH v3] Input: tegra-kbc - fix wakeup from suspend.
Date: Wed, 31 Aug 2011 16:38:31 -0700
Message-Id: <1314833911-21622-1-git-send-email-riyer@nvidia.com>
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
v3: Simplified suspend path based on Dmitry Torokhov's suggestions.
v2: Incorporated Dmitry Torokhov's recommended changes.
v1: Initial Patch.

 drivers/input/keyboard/tegra-kbc.c |   63 +++++++++++++++++++++++++----------
 1 files changed, 45 insertions(+), 18 deletions(-)

diff --git a/drivers/input/keyboard/tegra-kbc.c b/drivers/input/keyboard/tegra-kbc.c
index a5a7791..48ea03f 100644
--- a/drivers/input/keyboard/tegra-kbc.c
+++ b/drivers/input/keyboard/tegra-kbc.c
@@ -55,6 +55,7 @@
 
 #define KBC_ROW_CFG0_0	0x8
 #define KBC_COL_CFG0_0	0x18
+#define KBC_TO_CNT_0	0x24
 #define KBC_INIT_DLY_0	0x28
 #define KBC_RPT_DLY_0	0x2c
 #define KBC_KP_ENT0_0	0x30
@@ -70,6 +71,7 @@ struct tegra_kbc {
 	spinlock_t lock;
 	unsigned int repoll_dly;
 	unsigned long cp_dly_jiffies;
+	unsigned int cp_to_wkup_dly;
 	bool use_fn_map;
 	bool use_ghost_filter;
 	const struct tegra_kbc_platform_data *pdata;
@@ -341,6 +343,18 @@ static void tegra_kbc_report_keys(struct tegra_kbc *kbc)
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
@@ -370,9 +384,7 @@ static void tegra_kbc_keypress_timer(unsigned long data)
 
 		/* All keys are released so enable the keypress interrupt */
 		spin_lock_irqsave(&kbc->lock, flags);
-		val = readl(kbc->mmio + KBC_CONTROL_0);
-		val |= KBC_CONTROL_FIFO_CNT_INT_EN;
-		writel(val, kbc->mmio + KBC_CONTROL_0);
+		tegra_kbc_set_fifo_interrupt(kbc, true);
 		spin_unlock_irqrestore(&kbc->lock, flags);
 	}
 }
@@ -380,15 +392,13 @@ static void tegra_kbc_keypress_timer(unsigned long data)
 static irqreturn_t tegra_kbc_isr(int irq, void *args)
 {
 	struct tegra_kbc *kbc = args;
-	u32 val, ctl;
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
@@ -397,16 +407,14 @@ static irqreturn_t tegra_kbc_isr(int irq, void *args)
 	val = readl(kbc->mmio + KBC_INT_0);
 	writel(val, kbc->mmio + KBC_INT_0);
 
-	if (val & KBC_INT_FIFO_CNT_INT_STATUS) {
+	if (val & KBC_INT_FIFO_CNT_INT_STATUS)
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
 
 	return IRQ_HANDLED;
 }
@@ -734,18 +742,30 @@ static int tegra_kbc_suspend(struct device *dev)
 	struct platform_device *pdev = to_platform_device(dev);
 	struct tegra_kbc *kbc = platform_get_drvdata(pdev);
 
+	mutex_lock(&kbc->idev->mutex);
 	if (device_may_wakeup(&pdev->dev)) {
-		tegra_kbc_setup_wakekeys(kbc, true);
-		enable_irq_wake(kbc->irq);
+		disable_irq(kbc->irq);
+		del_timer_sync(&kbc->timer);
+		tegra_kbc_set_fifo_interrupt(kbc, false);
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
 		msleep(30);
+
+		enable_irq_wake(kbc->irq);
 	} else {
-		mutex_lock(&kbc->idev->mutex);
 		if (kbc->idev->users)
 			tegra_kbc_stop(kbc);
-		mutex_unlock(&kbc->idev->mutex);
 	}
+	mutex_unlock(&kbc->idev->mutex);
 
 	return 0;
 }
@@ -756,15 +776,22 @@ static int tegra_kbc_resume(struct device *dev)
 	struct tegra_kbc *kbc = platform_get_drvdata(pdev);
 	int err = 0;
 
+	mutex_lock(&kbc->idev->mutex);
 	if (device_may_wakeup(&pdev->dev)) {
 		disable_irq_wake(kbc->irq);
 		tegra_kbc_setup_wakekeys(kbc, false);
+
+		/* Restore the resident time of continuous polling mode. */
+		writel(kbc->cp_to_wkup_dly, kbc->mmio + KBC_TO_CNT_0);
+
+		tegra_kbc_set_fifo_interrupt(kbc, true);
+
+		enable_irq(kbc->irq);
 	} else {
-		mutex_lock(&kbc->idev->mutex);
 		if (kbc->idev->users)
 			err = tegra_kbc_start(kbc);
-		mutex_unlock(&kbc->idev->mutex);
 	}
+	mutex_unlock(&kbc->idev->mutex);
 
 	return err;
 }
-- 
1.7.1

