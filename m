Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932600Ab2HWSTc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 14:19:32 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:34270 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756327Ab2HWST0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 14:19:26 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Axel Lin <axel.lin@gmail.com>, Laxman Dewangan <ldewangan@nvidia.com>,
        Gyungoh Yoo <jack.yoo@maxim-ic.com>, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] max8907: fix use of possibly NULL idata
Date: Thu, 23 Aug 2012 12:19:18 -0600
Message-Id: <1345745958-16782-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

If a regulator is not used by a board, it's quite legitimate not to
provide platform data or a device tree node to configure it (i.e.
regulator_init_data). In that case, during MAX8907 regulator's
probe(), the idata variable will be NULL for that regulator. Prevent
dereferincing it.

If the MBATT regulator's init_data is not specified, or no name was
specified in the constraints, the regulator will be named based on
the regulator descriptor, so initialize mbatt_rail_name from there.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/regulator/max8907-regulator.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/max8907-regulator.c b/drivers/regulator/max8907-regulator.c
index 3a5104f..e97af8e 100644
--- a/drivers/regulator/max8907-regulator.c
+++ b/drivers/regulator/max8907-regulator.c
@@ -323,7 +323,10 @@ static __devinit int max8907_regulator_probe(struct platform_device *pdev)
 
 		switch (pmic->desc[i].id) {
 		case MAX8907_MBATT:
-			mbatt_rail_name = idata->constraints.name;
+			if (idata && idata->constraints.name)
+				mbatt_rail_name = idata->constraints.name;
+			else
+				mbatt_rail_name = pmic->desc[i].name;
 			break;
 		case MAX8907_BBAT:
 		case MAX8907_SDBY:
-- 
1.7.0.4

