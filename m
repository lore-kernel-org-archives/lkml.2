Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab1LAAd4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 19:33:56 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3088 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025Ab1LAAdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 19:33:54 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 30 Nov 2011 16:33:54 -0800
From: riyer@nvidia.com
To: dmitry.torokhov@gmail.com
Cc: rydberg@euromail.se, swarren@nvidia.com, ldewangan@nvidia.com,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-tegra@vger.kernel.org, Rakesh Iyer <riyer@nvidia.com>
Subject: [PATCH v2] Input: tegra-kbc - report wakeup key for some platforms.
Date: Wed, 30 Nov 2011 16:33:51 -0800
Message-Id: <1322699631-30373-1-git-send-email-riyer@nvidia.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rakesh Iyer <riyer@nvidia.com>

Tegra kbc cannot detect exact keypress causing wakeup in interrupt mode.
Allow wakeup keypress to be reported for certain platforms.

Signed-off-by: Rakesh Iyer <riyer@nvidia.com>
---
v2: Modifications based on review by Dmitry Trokhov.
v1: Initial patch

 arch/arm/mach-tegra/include/mach/kbc.h |    1 +
 drivers/input/keyboard/tegra-kbc.c     |   20 +++++++++++++++++---
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-tegra/include/mach/kbc.h b/arch/arm/mach-tegra/include/mach/kbc.h
index 4f3572a..20bb054 100644
--- a/arch/arm/mach-tegra/include/mach/kbc.h
+++ b/arch/arm/mach-tegra/include/mach/kbc.h
@@ -53,6 +53,7 @@ struct tegra_kbc_platform_data {
 	struct tegra_kbc_pin_cfg pin_cfg[KBC_MAX_GPIO];
 	const struct matrix_keymap_data *keymap_data;
 
+	u32 wakeup_key;
 	bool wakeup;
 	bool use_fn_map;
 	bool use_ghost_filter;
diff --git a/drivers/input/keyboard/tegra-kbc.c b/drivers/input/keyboard/tegra-kbc.c
index cf3228b..249f525 100644
--- a/drivers/input/keyboard/tegra-kbc.c
+++ b/drivers/input/keyboard/tegra-kbc.c
@@ -52,6 +52,7 @@
 /* KBC Interrupt Register */
 #define KBC_INT_0	0x4
 #define KBC_INT_FIFO_CNT_INT_STATUS	(1 << 2)
+#define KBC_INT_KEYPRESS_INT_STATUS	(1 << 0)
 
 #define KBC_ROW_CFG0_0	0x8
 #define KBC_COL_CFG0_0	0x18
@@ -74,10 +75,12 @@ struct tegra_kbc {
 	unsigned int cp_to_wkup_dly;
 	bool use_fn_map;
 	bool use_ghost_filter;
+	bool keypress_caused_wake;
 	const struct tegra_kbc_platform_data *pdata;
 	unsigned short keycode[KBC_MAX_KEY * 2];
 	unsigned short current_keys[KBC_MAX_KPENT];
 	unsigned int num_pressed_keys;
+	u32 wakeup_key;
 	struct timer_list timer;
 	struct clk *clk;
 };
@@ -409,6 +412,9 @@ static irqreturn_t tegra_kbc_isr(int irq, void *args)
 		 */
 		tegra_kbc_set_fifo_interrupt(kbc, false);
 		mod_timer(&kbc->timer, jiffies + kbc->cp_dly_jiffies);
+	} else if (val & KBC_INT_KEYPRESS_INT_STATUS) {
+		/* We can be here only through system resume path */
+		kbc->keypress_caused_wake = true;
 	}
 
 	spin_unlock_irqrestore(&kbc->lock, flags);
@@ -674,9 +680,10 @@ static int __devinit tegra_kbc_probe(struct platform_device *pdev)
 	keymap_data = pdata->keymap_data ?: &tegra_kbc_default_keymap_data;
 	matrix_keypad_build_keymap(keymap_data, KBC_ROW_SHIFT,
 				   input_dev->keycode, input_dev->keybit);
+	kbc->wakeup_key = pdata->wakeup_key;
 
-	err = request_irq(kbc->irq, tegra_kbc_isr, IRQF_TRIGGER_HIGH,
-			  pdev->name, kbc);
+	err = request_irq(kbc->irq, tegra_kbc_isr,
+			  IRQF_NO_SUSPEND | IRQF_TRIGGER_HIGH, pdev->name, kbc);
 	if (err) {
 		dev_err(&pdev->dev, "failed to request keyboard IRQ\n");
 		goto err_put_clk;
@@ -754,6 +761,8 @@ static int tegra_kbc_suspend(struct device *dev)
 		tegra_kbc_setup_wakekeys(kbc, true);
 		msleep(30);
 
+		kbc->keypress_caused_wake = false;
+		enable_irq(kbc->irq);
 		enable_irq_wake(kbc->irq);
 	} else {
 		if (kbc->idev->users)
@@ -780,7 +789,12 @@ static int tegra_kbc_resume(struct device *dev)
 
 		tegra_kbc_set_fifo_interrupt(kbc, true);
 
-		enable_irq(kbc->irq);
+		if (kbc->keypress_caused_wake && kbc->wakeup_key) {
+			input_report_key(kbc->idev, kbc->wakeup_key, 1);
+			input_sync(kbc->idev);
+			input_report_key(kbc->idev, kbc->wakeup_key, 0);
+			input_sync(kbc->idev);
+		}
 	} else {
 		if (kbc->idev->users)
 			err = tegra_kbc_start(kbc);
-- 
1.7.4.1

