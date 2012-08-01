Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab2HAT5f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 15:57:35 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:56440 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899Ab2HAT5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 15:57:32 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V2] regmap: initialize all irqs to wake disabled
Date: Wed,  1 Aug 2012 13:57:24 -0600
Message-Id: <1343851044-7872-1-git-send-email-swarren@wwwdotorg.org>
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
v2: Use regmap_update_bits() instead of regmap_write().
---
 drivers/base/regmap/regmap-irq.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index 5ae5d0e..8bbb0ba 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -321,6 +321,22 @@ int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
 		}
 	}
 
+	/* Wake is disabled by default */
+	if (d->wake_buf) {
+		for (i = 0; i < chip->num_regs; i++) {
+			d->wake_buf[i] = d->mask_buf_def[i];
+			reg = chip->wake_base +
+				(i * map->reg_stride * d->irq_reg_stride);
+			ret = regmap_update_bits(map, reg, d->wake_buf[i],
+						 d->wake_buf[i]);
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

