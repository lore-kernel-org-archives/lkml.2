Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab2HARk5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 13:40:57 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46466 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281Ab2HARk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 13:40:56 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 3/3] regmap: set MASK_ON_SUSPEND/SKIP_SET_WAKE if no wake_base
Date: Wed,  1 Aug 2012 11:40:49 -0600
Message-Id: <1343842849-15958-3-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1343842849-15958-1-git-send-email-swarren@wwwdotorg.org>
References: <1343842849-15958-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

If a regmap-irq chip has no wake base:

* There's no point calling .irq_set_wake, hence IRQCHIP_SKIP_SET_WAKE.

* If some IRQs in the chip are enabled for wake and some aren't, we
  should mask those interrupts that are not wake enabled, so that if
  they occur during suspend, the system is not awoken. Hence,
  IRQCHIP_MASK_ON_SUSPEND.

Note that IRQCHIP_MASK_ON_SUSPEND is handled by check_wakeup_irqs(),
which always iterates over every single interrupt in the system,
irrespective of whether an interrupt is a child of a controller whose
output interrupt has no wake-enabled inputs and hence is presumably
masked itself. Hence this change might cause interrupt unnecessary
masking operations and associated register I/O.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/base/regmap/regmap-irq.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index 5a3624f..da8aae7 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -287,6 +287,11 @@ int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
 
 	d->irq_chip = regmap_irq_chip;
 	d->irq_chip.name = chip->name;
+	if (!chip->wake_base) {
+		d->irq_chip.irq_set_wake = NULL;
+		d->irq_chip.flags |= IRQCHIP_MASK_ON_SUSPEND |
+				     IRQCHIP_SKIP_SET_WAKE;
+	}
 	d->irq = irq;
 	d->map = map;
 	d->chip = chip;
-- 
1.7.0.4

