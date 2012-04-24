Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932228Ab2DXXgd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 19:36:33 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16931 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758221Ab2DXXg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 19:36:26 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 24 Apr 2012 16:36:15 -0700
From: Rhyland Klein <rklein@nvidia.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Liam Girdwood <lrg@ti.com>
CC: <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        Rhyland Klein <rklein@nvidia.com>
Subject: [PATCH 7/8 v2] mfd: tps65910-irq: Add devicetree init support
Date: Tue, 24 Apr 2012 16:36:09 -0700
Message-ID: <1335310570-12455-8-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1335310570-12455-1-git-send-email-rklein@nvidia.com>
References: <1335310570-12455-1-git-send-email-rklein@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for initializing when boot using devicetree. The main difference
is that the irq_base will not be setup, so it needs to be manually handled.

Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
 v2: split off irq specific changes based on previous review comments

 drivers/mfd/tps65910-irq.c |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/tps65910-irq.c b/drivers/mfd/tps65910-irq.c
index 0f1ff7f..066a30f 100644
--- a/drivers/mfd/tps65910-irq.c
+++ b/drivers/mfd/tps65910-irq.c
@@ -180,12 +180,6 @@ int tps65910_irq_init(struct tps65910 *tps65910, int irq,
 		return -EINVAL;
 	}
 
-	tps65910->irq_mask = 0xFFFFFF;
-
-	mutex_init(&tps65910->irq_lock);
-	tps65910->chip_irq = irq;
-	tps65910->irq_base = pdata->irq_base;
-
 	switch (tps65910_chip_id(tps65910)) {
 	case TPS65910:
 		tps65910->irq_num = TPS65910_NUM_IRQ;
@@ -195,6 +189,21 @@ int tps65910_irq_init(struct tps65910 *tps65910, int irq,
 		break;
 	}
 
+	if (pdata->irq_base <= 0)
+		pdata->irq_base = irq_alloc_descs(-1, 0, tps65910->irq_num, -1);
+
+	if (pdata->irq_base <= 0) {
+		dev_err(tps65910->dev, "Failed to allocate irq descs: %d\n",
+			pdata->irq_base);
+		return pdata->irq_base;
+	}
+
+	tps65910->irq_mask = 0xFFFFFF;
+
+	mutex_init(&tps65910->irq_lock);
+	tps65910->chip_irq = irq;
+	tps65910->irq_base = pdata->irq_base;
+
 	/* Register with genirq */
 	for (cur_irq = tps65910->irq_base;
 	     cur_irq < tps65910->irq_num + tps65910->irq_base;
-- 
1.7.0.4

