Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233Ab2LSOMs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 09:12:48 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19571 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327Ab2LSOMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 09:12:40 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 19 Dec 2012 06:11:02 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@opensource.wolfsonmicro.com>, <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] regmap: irq: enable wake support by default
Date: Wed, 19 Dec 2012 19:42:28 +0530
Message-ID: <1355926348-16100-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

regmap-irq framework is used vastly by mfd drivers and some of
devices like TPS65910, TPS80036 do not support the wake base
register to enable wake.

Currently wake in regmap-irq only supported if client driver
passes the wake base register.

As the regmap-irq is mostly used by mfd devices and it is require
to have wake support from these devices in most of use cases,
enabling wake support by default in regmap-irq.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/base/regmap/regmap-irq.c |   18 ++++++------------
 1 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index 5972ad9..9129493 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -129,16 +129,15 @@ static int regmap_irq_set_wake(struct irq_data *data, unsigned int on)
 	struct regmap *map = d->map;
 	const struct regmap_irq *irq_data = irq_to_regmap_irq(d, data->hwirq);
 
-	if (!d->chip->wake_base)
-		return -EINVAL;
-
 	if (on) {
-		d->wake_buf[irq_data->reg_offset / map->reg_stride]
-			&= ~irq_data->mask;
+		if (d->wake_buf)
+			d->wake_buf[irq_data->reg_offset / map->reg_stride]
+				&= ~irq_data->mask;
 		d->wake_count++;
 	} else {
-		d->wake_buf[irq_data->reg_offset / map->reg_stride]
-			|= irq_data->mask;
+		if (d->wake_buf)
+			d->wake_buf[irq_data->reg_offset / map->reg_stride]
+				|= irq_data->mask;
 		d->wake_count--;
 	}
 
@@ -316,11 +315,6 @@ int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
 
 	d->irq_chip = regmap_irq_chip;
 	d->irq_chip.name = chip->name;
-	if (!chip->wake_base) {
-		d->irq_chip.irq_set_wake = NULL;
-		d->irq_chip.flags |= IRQCHIP_MASK_ON_SUSPEND |
-				     IRQCHIP_SKIP_SET_WAKE;
-	}
 	d->irq = irq;
 	d->map = map;
 	d->chip = chip;
-- 
1.7.1.1

