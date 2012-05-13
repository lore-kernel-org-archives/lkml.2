Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab2EMUxv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 16:53:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37226 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752693Ab2EMUxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 16:53:50 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: wm831x: Don't try to flag IRQ 0 as a wake source
Date: Sun, 13 May 2012 21:53:45 +0100
Message-Id: <1336942425-26826-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we've not got a primary IRQ we shouldn't be trying to flag IRQ 0 as a
wake source.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm831x-irq.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/mfd/wm831x-irq.c b/drivers/mfd/wm831x-irq.c
index bec4d05..2be9628 100644
--- a/drivers/mfd/wm831x-irq.c
+++ b/drivers/mfd/wm831x-irq.c
@@ -565,17 +565,6 @@ int wm831x_irq_init(struct wm831x *wm831x, int irq)
 	wm831x_set_bits(wm831x, WM831X_IRQ_CONFIG,
 			WM831X_IRQ_OD, i);
 
-	/* Try to flag /IRQ as a wake source; there are a number of
-	 * unconditional wake sources in the PMIC so this isn't
-	 * conditional but we don't actually care *too* much if it
-	 * fails.
-	 */
-	ret = enable_irq_wake(irq);
-	if (ret != 0) {
-		dev_warn(wm831x->dev, "Can't enable IRQ as wake source: %d\n",
-			 ret);
-	}
-
 	wm831x->irq = irq;
 
 	/* Register them with genirq */
@@ -597,6 +586,18 @@ int wm831x_irq_init(struct wm831x *wm831x, int irq)
 	}
 
 	if (irq) {
+		/* Try to flag /IRQ as a wake source; there are a number of
+		 * unconditional wake sources in the PMIC so this isn't
+		 * conditional but we don't actually care *too* much if it
+		 * fails.
+		 */
+		ret = enable_irq_wake(irq);
+		if (ret != 0) {
+			dev_warn(wm831x->dev,
+				 "Can't enable IRQ as wake source: %d\n",
+				 ret);
+		}
+
 		ret = request_threaded_irq(irq, NULL, wm831x_irq_thread,
 					   IRQF_TRIGGER_LOW | IRQF_ONESHOT,
 					   "wm831x", wm831x);
-- 
1.7.10

