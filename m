Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab1BALqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 06:46:19 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57180 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754063Ab1BALqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 06:46:18 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] mfd: Add fast path for WM831x touchscreen interrupts
Date: Tue,  1 Feb 2011 11:46:13 +0000
Message-Id: <1296560773-14918-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1296560773-14918-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1296560773-14918-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WM831x interrupt controller provides reporting of the touchscreen
related interrupts in the primary interrupt status register as a
performance optimisation - use this to avoid reading the secondary
status registers for those interrupts.

For code simplicity and to avoid iterating over all interrupts we open
code for the two affected interrupt sources.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm831x-irq.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/wm831x-irq.c b/drivers/mfd/wm831x-irq.c
index 90ad3fa..03eb61d 100644
--- a/drivers/mfd/wm831x-irq.c
+++ b/drivers/mfd/wm831x-irq.c
@@ -449,6 +449,18 @@ static irqreturn_t wm831x_irq_thread(int irq, void *data)
 		goto out;
 	}
 
+	/* The touch interrupts are visible in the primary register as
+	 * an optimisation; open code this to avoid complicating the
+	 * main handling loop and so we can also skip iterating the
+	 * descriptors.
+	 */
+	if (primary & WM831X_TCHPD_INT)
+		handle_nested_irq(wm831x->irq_base + WM831X_IRQ_TCHPD);
+	if (primary & WM831X_TCHDATA_INT)
+		handle_nested_irq(wm831x->irq_base + WM831X_IRQ_TCHDATA);
+	if (primary & (WM831X_TCHDATA_EINT | WM831X_TCHPD_EINT))
+		goto out;
+
 	for (i = 0; i < ARRAY_SIZE(wm831x_irqs); i++) {
 		int offset = wm831x_irqs[i].reg - 1;
 
-- 
1.7.2.3

