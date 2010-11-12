Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932868Ab0KLTTj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 14:19:39 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38984 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932858Ab0KLTTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 14:19:36 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Oritz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/3] mfd: Convert WM835x to new irq_ interrupt methods
Date: Fri, 12 Nov 2010 19:19:31 +0000
Message-Id: <1289589572-19261-2-git-send-email-broonie@opensource.wolfsonmicro.com>
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
 drivers/mfd/wm8350-irq.c |   32 +++++++++++++++++---------------
 1 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/mfd/wm8350-irq.c b/drivers/mfd/wm8350-irq.c
index f56c9ad..ba966ae 100644
--- a/drivers/mfd/wm8350-irq.c
+++ b/drivers/mfd/wm8350-irq.c
@@ -417,16 +417,16 @@ static irqreturn_t wm8350_irq(int irq, void *irq_data)
 	return IRQ_HANDLED;
 }
 
-static void wm8350_irq_lock(unsigned int irq)
+static void wm8350_irq_lock(struct irq_data *data)
 {
-	struct wm8350 *wm8350 = get_irq_chip_data(irq);
+	struct wm8350 *wm8350 = data->chip_data;
 
 	mutex_lock(&wm8350->irq_lock);
 }
 
-static void wm8350_irq_sync_unlock(unsigned int irq)
+static void wm8350_irq_sync_unlock(struct irq_data *data)
 {
-	struct wm8350 *wm8350 = get_irq_chip_data(irq);
+	struct wm8350 *wm8350 = data->chip_data;
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(wm8350->irq_masks); i++) {
@@ -442,28 +442,30 @@ static void wm8350_irq_sync_unlock(unsigned int irq)
 	mutex_unlock(&wm8350->irq_lock);
 }
 
-static void wm8350_irq_enable(unsigned int irq)
+static void wm8350_irq_enable(struct irq_data *data)
 {
-	struct wm8350 *wm8350 = get_irq_chip_data(irq);
-	struct wm8350_irq_data *irq_data = irq_to_wm8350_irq(wm8350, irq);
+	struct wm8350 *wm8350 = data->chip_data;
+	struct wm8350_irq_data *irq_data = irq_to_wm8350_irq(wm8350,
+							     data->irq);
 
 	wm8350->irq_masks[irq_data->reg] &= ~irq_data->mask;
 }
 
-static void wm8350_irq_disable(unsigned int irq)
+static void wm8350_irq_disable(struct irq_data *data)
 {
-	struct wm8350 *wm8350 = get_irq_chip_data(irq);
-	struct wm8350_irq_data *irq_data = irq_to_wm8350_irq(wm8350, irq);
+	struct wm8350 *wm8350 = data->chip_data;
+	struct wm8350_irq_data *irq_data = irq_to_wm8350_irq(wm8350,
+							     data->irq);
 
 	wm8350->irq_masks[irq_data->reg] |= irq_data->mask;
 }
 
 static struct irq_chip wm8350_irq_chip = {
-	.name = "wm8350",
-	.bus_lock = wm8350_irq_lock,
-	.bus_sync_unlock = wm8350_irq_sync_unlock,
-	.disable = wm8350_irq_disable,
-	.enable = wm8350_irq_enable,
+	.name			= "wm8350",
+	.irq_bus_lock		= wm8350_irq_lock,
+	.irq_bus_sync_unlock	= wm8350_irq_sync_unlock,
+	.irq_disable		= wm8350_irq_disable,
+	.irq_enable		= wm8350_irq_enable,
 };
 
 int wm8350_irq_init(struct wm8350 *wm8350, int irq,
-- 
1.7.1

