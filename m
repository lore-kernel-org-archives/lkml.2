Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab1K1SvG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 13:51:06 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59608 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753150Ab1K1SvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 13:51:03 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: Report if we actually handled an interrupt in regmap-irq
Date: Mon, 28 Nov 2011 18:50:59 +0000
Message-Id: <1322506259-4768-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While the IRQ core doesn't currently support shared threaded interrupts
that's no reason for drivers not to do their bit and report IRQ_NONE when
they don't get an interrupt. This allows the core spurious/wedget interrupt
detection support to do its thing.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap-irq.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index bd54f63..6b8a74c 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -100,6 +100,7 @@ static irqreturn_t regmap_irq_thread(int irq, void *d)
 	u8 *buf8 = data->status_reg_buf;
 	u16 *buf16 = data->status_reg_buf;
 	u32 *buf32 = data->status_reg_buf;
+	bool handled = false;
 
 	ret = regmap_bulk_read(map, chip->status_base, data->status_reg_buf,
 			       chip->num_regs);
@@ -146,10 +147,14 @@ static irqreturn_t regmap_irq_thread(int irq, void *d)
 		if (data->status_buf[chip->irqs[i].reg_offset] &
 		    chip->irqs[i].mask) {
 			handle_nested_irq(data->irq_base + i);
+			handled = true;
 		}
 	}
 
-	return IRQ_HANDLED;
+	if (handled)
+		return IRQ_HANDLED;
+	else
+		return IRQ_NONE;
 }
 
 /**
-- 
1.7.7.3

