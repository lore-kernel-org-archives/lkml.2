Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791Ab2HAShi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 14:37:38 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:64076 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352Ab2HAShh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 14:37:37 -0400
X-Greylist: delayed 321 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Aug 2012 14:37:36 EDT
Message-Id: <201208011832.q71IWEHu013706@latitude.olech.com>
From: Anthony Olech (Opensource) <anthony.olech.opensource@diasemi.com>
Date: Wed, 1 Aug 2012 19:05:15 +0100
Subject: [PATCH] regmap-irq: allow auto-allocated IRQs to be mapped
To: LKML <linux-kernel@vger.kernel.org>
Cc: Anthony Olech <anthony.olech@diasemi.com>
Cc: Dajun Chen <david.chen@diasemi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

if the irq_base is set to -1 when calling regmap_add_irq_chip()
then allow the IRQ to be mapped even if the allocated irq_base
is actually zero.

This restores the behaviour seen in v3.4, and I assume that the
tidy-ups just made in v3.5 INADVERTENTLY introduce this change
in behaviour.

Signed-off-by: Anthony Olech (Opensource) <anthony.olech.opensource@diasemi.com>
---
 drivers/base/regmap/regmap-irq.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index a897346..2441785 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -238,6 +238,7 @@ int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
 	struct regmap_irq_chip_data *d;
 	int i;
 	int ret = -ENOMEM;
+	int orig_irq_base = irq_base;
 
 	for (i = 0; i < chip->num_irqs; i++) {
 		if (chip->irqs[i].reg_offset % map->reg_stride)
@@ -313,7 +314,7 @@ int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
 		}
 	}
 
-	if (irq_base)
+	if (irq_base || orig_irq_base)
 		d->domain = irq_domain_add_legacy(map->dev->of_node,
 						  chip->num_irqs, irq_base, 0,
 						  &regmap_domain_ops, d);
-- 
end-of-patch for regmap-irq-bug-fix

