Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089Ab0KLTTp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 14:19:45 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38985 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932859Ab0KLTTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 14:19:36 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Oritz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/3] mfd: Convert WM8994 to new irq_ interrupt methods
Date: Fri, 12 Nov 2010 19:19:32 +0000
Message-Id: <1289589572-19261-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1289589572-19261-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1289589572-19261-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel 2.6.37 adds new interrupt methods which take a struct irq_data
rather than an irq number. Convert over to these as they will become
mandatory in future.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8994-irq.c |   32 +++++++++++++++++---------------
 1 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/mfd/wm8994-irq.c b/drivers/mfd/wm8994-irq.c
index 8400eb1..6259884 100644
--- a/drivers/mfd/wm8994-irq.c
+++ b/drivers/mfd/wm8994-irq.c
@@ -156,16 +156,16 @@ static inline struct wm8994_irq_data *irq_to_wm8994_irq(struct wm8994 *wm8994,
 	return &wm8994_irqs[irq - wm8994->irq_base];
 }
 
-static void wm8994_irq_lock(unsigned int irq)
+static void wm8994_irq_lock(struct irq_data *data)
 {
-	struct wm8994 *wm8994 = get_irq_chip_data(irq);
+	struct wm8994 *wm8994 = data->chip_data;
 
 	mutex_lock(&wm8994->irq_lock);
 }
 
-static void wm8994_irq_sync_unlock(unsigned int irq)
+static void wm8994_irq_sync_unlock(struct irq_data *data)
 {
-	struct wm8994 *wm8994 = get_irq_chip_data(irq);
+	struct wm8994 *wm8994 = data->chip_data;
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(wm8994->irq_masks_cur); i++) {
@@ -182,28 +182,30 @@ static void wm8994_irq_sync_unlock(unsigned int irq)
 	mutex_unlock(&wm8994->irq_lock);
 }
 
-static void wm8994_irq_unmask(unsigned int irq)
+static void wm8994_irq_unmask(struct irq_data *data)
 {
-	struct wm8994 *wm8994 = get_irq_chip_data(irq);
-	struct wm8994_irq_data *irq_data = irq_to_wm8994_irq(wm8994, irq);
+	struct wm8994 *wm8994 = data->chip_data;
+	struct wm8994_irq_data *irq_data = irq_to_wm8994_irq(wm8994,
+							     data->irq);
 
 	wm8994->irq_masks_cur[irq_data->reg - 1] &= ~irq_data->mask;
 }
 
-static void wm8994_irq_mask(unsigned int irq)
+static void wm8994_irq_mask(struct irq_data *data)
 {
-	struct wm8994 *wm8994 = get_irq_chip_data(irq);
-	struct wm8994_irq_data *irq_data = irq_to_wm8994_irq(wm8994, irq);
+	struct wm8994 *wm8994 = data->chip_data;
+	struct wm8994_irq_data *irq_data = irq_to_wm8994_irq(wm8994,
+							     data->irq);
 
 	wm8994->irq_masks_cur[irq_data->reg - 1] |= irq_data->mask;
 }
 
 static struct irq_chip wm8994_irq_chip = {
-	.name = "wm8994",
-	.bus_lock = wm8994_irq_lock,
-	.bus_sync_unlock = wm8994_irq_sync_unlock,
-	.mask = wm8994_irq_mask,
-	.unmask = wm8994_irq_unmask,
+	.name			= "wm8994",
+	.irq_bus_lock		= wm8994_irq_lock,
+	.irq_bus_sync_unlock	= wm8994_irq_sync_unlock,
+	.irq_mask		= wm8994_irq_mask,
+	.irq_unmask		= wm8994_irq_unmask,
 };
 
 /* The processing of the primary interrupt occurs in a thread so that
-- 
1.7.1

