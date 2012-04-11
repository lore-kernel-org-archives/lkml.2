Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635Ab2DKFhi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 01:37:38 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60505 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab2DKFhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 01:37:36 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] regmap: fix compile errors in regmap-irq.c due to stride changes
Date: Tue, 10 Apr 2012 23:37:22 -0600
Message-Id: <1334122642-14864-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Commit f01ee60fffa4 ("regmap: implement register striding") caused the
compile errors below. Fix them.

drivers/base/regmap/regmap-irq.c: In function 'regmap_irq_sync_unlock':
drivers/base/regmap/regmap-irq.c:62:12: error: 'map' undeclared (first use in this function)
drivers/base/regmap/regmap-irq.c:62:12: note: each undeclared identifier is reported only once for each function it appears in
drivers/base/regmap/regmap-irq.c: In function 'regmap_irq_enable':
drivers/base/regmap/regmap-irq.c:77:37: error: 'map' undeclared (first use in this function)
drivers/base/regmap/regmap-irq.c: In function 'regmap_irq_disable':
drivers/base/regmap/regmap-irq.c:85:37: error: 'map' undeclared (first use in this function)

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
I apologize for the lame patches. I didn't notice that regmap-irq.c had a
separate config option that wasn't enabled.

 drivers/base/regmap/regmap-irq.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index 56b8136..fc69d29 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -50,6 +50,7 @@ static void regmap_irq_lock(struct irq_data *data)
 static void regmap_irq_sync_unlock(struct irq_data *data)
 {
 	struct regmap_irq_chip_data *d = irq_data_get_irq_chip_data(data);
+	struct regmap *map = d->map;
 	int i, ret;
 
 	/*
@@ -59,7 +60,7 @@ static void regmap_irq_sync_unlock(struct irq_data *data)
 	 */
 	for (i = 0; i < d->chip->num_regs; i++) {
 		ret = regmap_update_bits(d->map, d->chip->mask_base +
-						(i * map->map->reg_stride),
+						(i * map->reg_stride),
 					 d->mask_buf_def[i], d->mask_buf[i]);
 		if (ret != 0)
 			dev_err(d->map->dev, "Failed to sync masks in %x\n",
@@ -72,6 +73,7 @@ static void regmap_irq_sync_unlock(struct irq_data *data)
 static void regmap_irq_enable(struct irq_data *data)
 {
 	struct regmap_irq_chip_data *d = irq_data_get_irq_chip_data(data);
+	struct regmap *map = d->map;
 	const struct regmap_irq *irq_data = irq_to_regmap_irq(d, data->irq);
 
 	d->mask_buf[irq_data->reg_offset / map->reg_stride] &= ~irq_data->mask;
@@ -80,6 +82,7 @@ static void regmap_irq_enable(struct irq_data *data)
 static void regmap_irq_disable(struct irq_data *data)
 {
 	struct regmap_irq_chip_data *d = irq_data_get_irq_chip_data(data);
+	struct regmap *map = d->map;
 	const struct regmap_irq *irq_data = irq_to_regmap_irq(d, data->irq);
 
 	d->mask_buf[irq_data->reg_offset / map->reg_stride] |= irq_data->mask;
-- 
1.7.0.4

