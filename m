Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab2ARWc6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 17:32:58 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:8711 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab2ARWc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 17:32:56 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 18 Jan 2012 14:32:55 -0800
From: Rakesh Iyer <riyer@nvidia.com>
To: dmitry.torokhov@gmail.com
Cc: swarren@nvidia.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rakesh Iyer <riyer@nvidia.com>
Subject: [PATCH v1] Input: tegra-kbc - enable key interrupt for wakeup
Date: Wed, 18 Jan 2012 14:33:01 -0800
Message-Id: <1326925981-14723-1-git-send-email-riyer@nvidia.com>
X-Mailer: git-send-email 1.7.4.1
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable keypress interrupt to support wakeup from low power state.

Signed-off-by: Rakesh Iyer <riyer@nvidia.com>
---
 drivers/input/keyboard/tegra-kbc.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/input/keyboard/tegra-kbc.c b/drivers/input/keyboard/tegra-kbc.c
index a136e2e..b307a46 100644
--- a/drivers/input/keyboard/tegra-kbc.c
+++ b/drivers/input/keyboard/tegra-kbc.c
@@ -48,6 +48,7 @@
 #define KBC_FIFO_TH_CNT_SHIFT(cnt)	(cnt << 14)
 #define KBC_DEBOUNCE_CNT_SHIFT(cnt)	(cnt << 4)
 #define KBC_CONTROL_FIFO_CNT_INT_EN	(1 << 3)
+#define KBC_CONTROL_KEYPRESS_INT_EN	(1 << 1)
 #define KBC_CONTROL_KBC_EN		(1 << 0)
 
 /* KBC Interrupt Register */
@@ -356,6 +357,18 @@ static void tegra_kbc_set_fifo_interrupt(struct tegra_kbc *kbc, bool enable)
 	writel(val, kbc->mmio + KBC_CONTROL_0);
 }
 
+static void tegra_kbc_set_keypress_interrupt(struct tegra_kbc *kbc, bool enable)
+{
+	u32 val;
+
+	val = readl(kbc->mmio + KBC_CONTROL_0);
+	if (enable)
+		val |= KBC_CONTROL_KEYPRESS_INT_EN;
+	else
+		val &= ~KBC_CONTROL_KEYPRESS_INT_EN;
+	writel(val, kbc->mmio + KBC_CONTROL_0);
+}
+
 static void tegra_kbc_keypress_timer(unsigned long data)
 {
 	struct tegra_kbc *kbc = (struct tegra_kbc *)data;
@@ -831,6 +844,8 @@ static int tegra_kbc_suspend(struct device *dev)
 		msleep(30);
 
 		kbc->keypress_caused_wake = false;
+		/* Enable keypress interrupt before going into suspend. */
+		tegra_kbc_set_keypress_interrupt(kbc, true);
 		enable_irq(kbc->irq);
 		enable_irq_wake(kbc->irq);
 	} else {
@@ -852,6 +867,8 @@ static int tegra_kbc_resume(struct device *dev)
 	if (device_may_wakeup(&pdev->dev)) {
 		disable_irq_wake(kbc->irq);
 		tegra_kbc_setup_wakekeys(kbc, false);
+		/* We will use fifo interrupts for key detection. */
+		tegra_kbc_set_keypress_interrupt(kbc, false);
 
 		/* Restore the resident time of continuous polling mode. */
 		writel(kbc->cp_to_wkup_dly, kbc->mmio + KBC_TO_CNT_0);
-- 
1.7.4.1

