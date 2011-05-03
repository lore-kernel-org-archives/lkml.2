Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757663Ab1ECAXE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 20:23:04 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:15273 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010Ab1ECAXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 20:23:02 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 02 May 2011 17:23:01 -0700
From: riyer@nvidia.com
To: dmitry.torokhov@gmail.com, rydberg@euromail.se
Cc: amartin@nvidia.com, olof@lixom.net, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, Rakesh Iyer <riyer@nvidia.com>
Subject: [v1] Input: tegra-kbc - modify keypress wakeup logic.
Date: Mon,  2 May 2011 17:23:08 -0700
Message-Id: <1304382188-29530-1-git-send-email-riyer@nvidia.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rakesh Iyer <riyer@nvidia.com>

Modify wakeup logic so either all keypresses wake the system or none do.

Signed-off-by: Rakesh Iyer <riyer@nvidia.com>
---
v1: Modify wakeup logic so either all keypresses wake the system or none do.

 arch/arm/mach-tegra/include/mach/kbc.h |    4 +---
 drivers/input/keyboard/tegra-kbc.c     |   28 ++++------------------------
 2 files changed, 5 insertions(+), 27 deletions(-)

diff --git a/arch/arm/mach-tegra/include/mach/kbc.h b/arch/arm/mach-tegra/include/mach/kbc.h
index bd99744..6b8e934 100644
--- a/arch/arm/mach-tegra/include/mach/kbc.h
+++ b/arch/arm/mach-tegra/include/mach/kbc.h
@@ -50,14 +50,12 @@ struct tegra_kbc_platform_data {
 	unsigned int debounce_cnt;
 	unsigned int repeat_cnt;
 
-	unsigned int wake_cnt; /* 0:wake on any key >1:wake on wake_cfg */
-	const struct tegra_kbc_wake_key *wake_cfg;
-
 	struct tegra_kbc_pin_cfg pin_cfg[KBC_MAX_GPIO];
 	const struct matrix_keymap_data *keymap_data;
 
 	bool wakeup;
 	bool use_fn_map;
 	bool use_ghost_filter;
+	bool wake_on_keypress;
 };
 #endif
diff --git a/drivers/input/keyboard/tegra-kbc.c b/drivers/input/keyboard/tegra-kbc.c
index 5fb4b97..cdbc55b 100644
--- a/drivers/input/keyboard/tegra-kbc.c
+++ b/drivers/input/keyboard/tegra-kbc.c
@@ -66,8 +66,6 @@ struct tegra_kbc {
 	void __iomem *mmio;
 	struct input_dev *idev;
 	unsigned int irq;
-	unsigned int wake_enable_rows;
-	unsigned int wake_enable_cols;
 	spinlock_t lock;
 	unsigned int repoll_dly;
 	unsigned long cp_dly_jiffies;
@@ -291,7 +289,7 @@ static void tegra_kbc_report_keys(struct tegra_kbc *kbc)
 	 * Matrix keyboard designs are prone to keyboard ghosting.
 	 * Ghosting occurs if there are 3 keys such that -
 	 * any 2 of the 3 keys share a row, and any 2 of them share a column.
-	 * If so ignore the key presses for this iteration.
+	 * If so ignore the keypresses for this iteration.
 	 */
 	if ((kbc->use_ghost_filter) && (num_down >= 3)) {
 		for (i = 0; i < num_down; i++) {
@@ -328,7 +326,7 @@ static void tegra_kbc_report_keys(struct tegra_kbc *kbc)
 
 	spin_unlock_irqrestore(&kbc->lock, flags);
 
-	/* Ignore the key presses for this iteration? */
+	/* Ignore the keypresses for this iteration? */
 	if (key_in_same_col && key_in_same_row)
 		return;
 
@@ -418,21 +416,11 @@ static void tegra_kbc_setup_wakekeys(struct tegra_kbc *kbc, bool filter)
 	int i;
 	unsigned int rst_val;
 
-	BUG_ON(pdata->wake_cnt > KBC_MAX_KEY);
-	rst_val = (filter && pdata->wake_cnt) ? ~0 : 0;
+	/* Either mask all keys or none. */
+	rst_val = (filter && !pdata->wake_on_keypress) ? ~0 : 0;
 
 	for (i = 0; i < KBC_MAX_ROW; i++)
 		writel(rst_val, kbc->mmio + KBC_ROW0_MASK_0 + i * 4);
-
-	if (filter) {
-		for (i = 0; i < pdata->wake_cnt; i++) {
-			u32 val, addr;
-			addr = pdata->wake_cfg[i].row * 4 + KBC_ROW0_MASK_0;
-			val = readl(kbc->mmio + addr);
-			val &= ~(1 << pdata->wake_cfg[i].col);
-			writel(val, kbc->mmio + addr);
-		}
-	}
 }
 
 static void tegra_kbc_config_pins(struct tegra_kbc *kbc)
@@ -594,7 +582,6 @@ static int __devinit tegra_kbc_probe(struct platform_device *pdev)
 	struct resource *res;
 	int irq;
 	int err;
-	int i;
 	int num_rows = 0;
 	unsigned int debounce_cnt;
 	unsigned int scan_time_rows;
@@ -651,13 +638,6 @@ static int __devinit tegra_kbc_probe(struct platform_device *pdev)
 		goto err_iounmap;
 	}
 
-	kbc->wake_enable_rows = 0;
-	kbc->wake_enable_cols = 0;
-	for (i = 0; i < pdata->wake_cnt; i++) {
-		kbc->wake_enable_rows |= (1 << pdata->wake_cfg[i].row);
-		kbc->wake_enable_cols |= (1 << pdata->wake_cfg[i].col);
-	}
-
 	/*
 	 * The time delay between two consecutive reads of the FIFO is
 	 * the sum of the repeat time and the time taken for scanning
-- 
1.7.2.3

