Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548Ab1DUWK0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 18:10:26 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:9645 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998Ab1DUWKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 18:10:22 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 21 Apr 2011 15:10:21 -0700
From: riyer@nvidia.com
To: dmitry.torokhov@gmail.com, rydberg@euromail.se
Cc: olof@lixom.net, amartin@nvidia.com, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, Rakesh Iyer <riyer@nvidia.com>
Subject: [PATCH v2] Input: tegra-kbc - add ghost key filter.
Date: Thu, 21 Apr 2011 15:10:15 -0700
Message-Id: <1303423815-22786-1-git-send-email-riyer@nvidia.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rakesh Iyer <riyer@nvidia.com>

Add ghost key filtering support for the Nvidia Tegra matrix keyboard.

Signed-off-by: Rakesh Iyer <riyer@nvidia.com>
---
v2: Incorporated Henrik Rydberg's suggestions.
v1: Do not report keypresses when matrix keyboard encounters key ghosting.

 arch/arm/mach-tegra/include/mach/kbc.h |    1 +
 drivers/input/keyboard/tegra-kbc.c     |   36 ++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-tegra/include/mach/kbc.h b/arch/arm/mach-tegra/include/mach/kbc.h
index 04c7798..bd99744 100644
--- a/arch/arm/mach-tegra/include/mach/kbc.h
+++ b/arch/arm/mach-tegra/include/mach/kbc.h
@@ -58,5 +58,6 @@ struct tegra_kbc_platform_data {
 
 	bool wakeup;
 	bool use_fn_map;
+	bool use_ghost_filter;
 };
 #endif
diff --git a/drivers/input/keyboard/tegra-kbc.c b/drivers/input/keyboard/tegra-kbc.c
index 99ce903..56f6668 100644
--- a/drivers/input/keyboard/tegra-kbc.c
+++ b/drivers/input/keyboard/tegra-kbc.c
@@ -72,6 +72,7 @@ struct tegra_kbc {
 	unsigned int repoll_dly;
 	unsigned long cp_dly_jiffies;
 	bool use_fn_map;
+	bool use_ghost_filter;
 	const struct tegra_kbc_platform_data *pdata;
 	unsigned short keycode[KBC_MAX_KEY * 2];
 	unsigned short current_keys[KBC_MAX_KPENT];
@@ -260,6 +261,8 @@ static void tegra_kbc_report_keys(struct tegra_kbc *kbc)
 	unsigned int num_down = 0;
 	unsigned long flags;
 	bool fn_keypress = false;
+	bool key_in_same_row = false;
+	bool key_in_same_col = false;
 
 	spin_lock_irqsave(&kbc->lock, flags);
 	for (i = 0; i < KBC_MAX_KPENT; i++) {
@@ -285,6 +288,34 @@ static void tegra_kbc_report_keys(struct tegra_kbc *kbc)
 	}
 
 	/*
+	 * Matrix keyboard designs are prone to keyboard ghosting.
+	 * Ghosting occurs if there are 3 keys such that -
+	 * any 2 of the 3 keys share a row, and any 2 of them share a column.
+	 * If so ignore the keypresses for this iteration.
+	 */
+	if ((kbc->use_ghost_filter) && (num_down >= 3)) {
+		for (i = 0; i < num_down; i++) {
+			unsigned int j;
+			u8 curr_col = scancodes[i] & 0x07;
+			u8 curr_row = scancodes[i] >> KBC_ROW_SHIFT;
+
+			/*
+			 * Find 2 keys such that one key is in the same row
+			 * and the other is in the same column as the i-th key.
+			 */
+			for (j = i + 1; j < num_down; j++) {
+				u8 col = scancodes[j] & 0x07;
+				u8 row = scancodes[j] >> KBC_ROW_SHIFT;
+
+				if (col == curr_col)
+					key_in_same_col = true;
+				if (row == curr_row)
+					key_in_same_row = true;
+			}
+		}
+	}
+
+	/*
 	 * If the platform uses Fn keymaps, translate keys on a Fn keypress.
 	 * Function keycodes are KBC_MAX_KEY apart from the plain keycodes.
 	 */
@@ -297,6 +328,10 @@ static void tegra_kbc_report_keys(struct tegra_kbc *kbc)
 
 	spin_unlock_irqrestore(&kbc->lock, flags);
 
+	/* Ignore the keypresses for this iteration? */
+	if (key_in_same_col && key_in_same_row)
+		return;
+
 	tegra_kbc_report_released_keys(kbc->idev,
 				       kbc->current_keys, kbc->num_pressed_keys,
 				       keycodes, num_down);
@@ -652,6 +687,7 @@ static int __devinit tegra_kbc_probe(struct platform_device *pdev)
 		input_dev->keycodemax *= 2;
 
 	kbc->use_fn_map = pdata->use_fn_map;
+	kbc->use_ghost_filter = pdata->use_ghost_filter;
 	keymap_data = pdata->keymap_data ?: &tegra_kbc_default_keymap_data;
 	matrix_keypad_build_keymap(keymap_data, KBC_ROW_SHIFT,
 				   input_dev->keycode, input_dev->keybit);
-- 
1.7.1

