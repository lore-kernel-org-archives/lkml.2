Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab2HARjw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 13:39:52 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:42715 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092Ab2HARjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 13:39:51 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] regmap: initialize all irqs to wake disabled
Date: Wed,  1 Aug 2012 11:39:44 -0600
Message-Id: <1343842784-15912-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

The kerneldoc for irq_set_irq_wake() says:

    Enable/disable power management wakeup mode, which is
    disabled by default.

regmap_irq_set_wake() clears bits to enable wake for an interrupt,
and sets bits to disable wake. Hence, we should set all bits in
wake_buf initially, to mirror the expected disabled state.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/base/regmap/regmap-irq.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index c7e5b18..75b6939 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -314,6 +314,21 @@ int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
 		}
 	}
 
+	/* Wake is disabled by default */
+	if (d->wake_buf) {
+		for (i = 0; i < chip->num_regs; i++) {
+			d->wake_buf[i] = d->mask_buf_def[i];
+			reg = chip->wake_base +
+				(i * map->reg_stride * d->irq_reg_stride);
+			ret = regmap_write(map, reg, d->wake_buf[i]);
+			if (ret != 0) {
+				dev_err(map->dev, "Failed to set masks in 0x%x: %d\n",
+					reg, ret);
+				goto err_alloc;
+			}
+		}
+	}
+
 	if (irq_base)
 		d->domain = irq_domain_add_legacy(map->dev->of_node,
 						  chip->num_irqs, irq_base, 0,
-- 
1.7.0.4

