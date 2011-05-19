Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934145Ab1ESS4v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:56:51 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44921 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756851Ab1ESS4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:56:49 -0400
Date: Thu, 19 May 2011 20:56:48 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd wm8350: allocate irq descs dynamically
Message-ID: <20110519185648.GR30963@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 20:48:36 up 12 days, 10:26, 26 users,  load average: 0.53, 0.99,
 1.12
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This allows boards to leave the irq_base field unitialized and
prevents them having to reserve irqs in the platform.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/mfd/wm8350-irq.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

As this seems to be the first user of irq_alloc_descs outside the core I
added Thomas to cc to check if this is the correct usage of this
function.
Unfortunately I have no hardware to test this. I created this patch
since one of the wm8350 users is the mx31ads board which prevents me
from getting rid of the irq ifdeffery in i.MX land, so it would be nice
if someone could give it a test run.

diff --git a/drivers/mfd/wm8350-irq.c b/drivers/mfd/wm8350-irq.c
index ed4b22a..04408a5 100644
--- a/drivers/mfd/wm8350-irq.c
+++ b/drivers/mfd/wm8350-irq.c
@@ -479,8 +479,8 @@ int wm8350_irq_init(struct wm8350 *wm8350, int irq,
 		return 0;
 	}
 
-	if (!pdata || !pdata->irq_base) {
-		dev_warn(wm8350->dev, "No interrupt support, no IRQ base\n");
+	if (!pdata) {
+		dev_warn(wm8350->dev, "No interrupt support, no platform data\n");
 		return 0;
 	}
 
@@ -500,7 +500,17 @@ int wm8350_irq_init(struct wm8350 *wm8350, int irq,
 
 	mutex_init(&wm8350->irq_lock);
 	wm8350->chip_irq = irq;
-	wm8350->irq_base = pdata->irq_base;
+
+	if (!pdata->irq_base) {
+		wm8350->irq_base = irq_alloc_descs(-1, 0, ARRAY_SIZE(wm8350_irqs), 0);
+		if (wm8350->irq_base < 0) {
+			dev_warn(wm8350->dev, "Allocating irqs failed with %d\n",
+				wm8350->irq_base);
+			return 0;
+		}
+	} else {
+		wm8350->irq_base = pdata->irq_base;
+	}
 
 	if (pdata->irq_high) {
 		flags |= IRQF_TRIGGER_HIGH;
-- 
1.7.4.1

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
