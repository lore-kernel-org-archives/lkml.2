Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab1L0RUT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 12:20:19 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47137 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754464Ab1L0RUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 12:20:17 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@liniux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Still check other interrupts if we get a wm831x touchscreen IRQ
Date: Tue, 27 Dec 2011 17:20:10 +0000
Message-Id: <1325006410-22147-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is possible that we will see another interrupt triggering at the same
time as the touchscreen interrupts so it's still worth checking other
possible sources. Almost all of the win from the fast path comes from only
needing to read the primary register and saving the I/O costs.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm831x-irq.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/wm831x-irq.c b/drivers/mfd/wm831x-irq.c
index 7be5f09..bec4d05 100644
--- a/drivers/mfd/wm831x-irq.c
+++ b/drivers/mfd/wm831x-irq.c
@@ -472,8 +472,7 @@ static irqreturn_t wm831x_irq_thread(int irq, void *data)
 		handle_nested_irq(wm831x->irq_base + WM831X_IRQ_TCHPD);
 	if (primary & WM831X_TCHDATA_INT)
 		handle_nested_irq(wm831x->irq_base + WM831X_IRQ_TCHDATA);
-	if (primary & (WM831X_TCHDATA_EINT | WM831X_TCHPD_EINT))
-		goto out;
+	primary &= ~(WM831X_TCHDATA_EINT | WM831X_TCHPD_EINT);
 
 	for (i = 0; i < ARRAY_SIZE(wm831x_irqs); i++) {
 		int offset = wm831x_irqs[i].reg - 1;
-- 
1.7.7.3

