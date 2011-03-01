Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425Ab1CAUMf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 15:12:35 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36979 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757399Ab1CAUMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 15:12:32 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/3] mfd: Convert WM8994/58 interrupt masking to enable/disable operations
Date: Tue,  1 Mar 2011 20:12:45 +0000
Message-Id: <1299010366-31453-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1299010366-31453-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1299010366-31453-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WM8994/58 interrupt masking support is a much better match for the genirq
enable and disable operations than for the mask and unmask operations. The
latter are intended to used during interrupt handling for temporary changes
which isn't really practical on a slow bus. Convert the operations over to
match this.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8994-irq.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/wm8994-irq.c b/drivers/mfd/wm8994-irq.c
index 29e8faf..f5e439a 100644
--- a/drivers/mfd/wm8994-irq.c
+++ b/drivers/mfd/wm8994-irq.c
@@ -182,7 +182,7 @@ static void wm8994_irq_sync_unlock(struct irq_data *data)
 	mutex_unlock(&wm8994->irq_lock);
 }
 
-static void wm8994_irq_unmask(struct irq_data *data)
+static void wm8994_irq_enable(struct irq_data *data)
 {
 	struct wm8994 *wm8994 = irq_data_get_irq_chip_data(data);
 	struct wm8994_irq_data *irq_data = irq_to_wm8994_irq(wm8994,
@@ -191,7 +191,7 @@ static void wm8994_irq_unmask(struct irq_data *data)
 	wm8994->irq_masks_cur[irq_data->reg - 1] &= ~irq_data->mask;
 }
 
-static void wm8994_irq_mask(struct irq_data *data)
+static void wm8994_irq_disable(struct irq_data *data)
 {
 	struct wm8994 *wm8994 = irq_data_get_irq_chip_data(data);
 	struct wm8994_irq_data *irq_data = irq_to_wm8994_irq(wm8994,
@@ -204,8 +204,8 @@ static struct irq_chip wm8994_irq_chip = {
 	.name			= "wm8994",
 	.irq_bus_lock		= wm8994_irq_lock,
 	.irq_bus_sync_unlock	= wm8994_irq_sync_unlock,
-	.irq_mask		= wm8994_irq_mask,
-	.irq_unmask		= wm8994_irq_unmask,
+	.irq_disable		= wm8994_irq_disable,
+	.irq_enable		= wm8994_irq_enable,
 };
 
 /* The processing of the primary interrupt occurs in a thread so that
-- 
1.7.2.3

