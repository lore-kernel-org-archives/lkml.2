Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab2HARkz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 13:40:55 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:37445 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281Ab2HARky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 13:40:54 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 1/3] regmap: store irq_chip inside regmap_irq_chip_data
Date: Wed,  1 Aug 2012 11:40:47 -0600
Message-Id: <1343842849-15958-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

This will allow later patches to adjust portions of the irq_chip
individually for each regmap_irq_chip that is created.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/base/regmap/regmap-irq.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index 75b6939..07fae4c 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -22,6 +22,7 @@
 
 struct regmap_irq_chip_data {
 	struct mutex lock;
+	struct irq_chip irq_chip;
 
 	struct regmap *map;
 	const struct regmap_irq_chip *chip;
@@ -129,7 +130,7 @@ static int regmap_irq_set_wake(struct irq_data *data, unsigned int on)
 	return 0;
 }
 
-static struct irq_chip regmap_irq_chip = {
+static const struct irq_chip regmap_irq_chip = {
 	.name			= "regmap",
 	.irq_bus_lock		= regmap_irq_lock,
 	.irq_bus_sync_unlock	= regmap_irq_sync_unlock,
@@ -197,7 +198,7 @@ static int regmap_irq_map(struct irq_domain *h, unsigned int virq,
 	struct regmap_irq_chip_data *data = h->host_data;
 
 	irq_set_chip_data(virq, data);
-	irq_set_chip_and_handler(virq, &regmap_irq_chip, handle_edge_irq);
+	irq_set_chip_and_handler(virq, &data->irq_chip, handle_edge_irq);
 	irq_set_nested_thread(virq, 1);
 
 	/* ARM needs us to explicitly flag the IRQ as valid
@@ -285,6 +286,7 @@ int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
 			goto err_alloc;
 	}
 
+	d->irq_chip = regmap_irq_chip;
 	d->irq = irq;
 	d->map = map;
 	d->chip = chip;
-- 
1.7.0.4

