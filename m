Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab2AYJcm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 04:32:42 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:25436 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab2AYJcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 04:32:39 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Wed, 25 Jan 2012 10:31:45 +0100
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: [PATCH] regulator: Set apply_uV only when min and max voltages are
 defined
To: broonie@opensource.wolfsonmicro.com
Cc: linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        s.nawrocki@samsung.com, lrg@ti.com,
        Karol Lewandowski <k.lewandowsk@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>
Message-id: <1327483905-27007-1-git-send-email-k.lewandowsk@samsung.com>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

apply_uV is errornously set when regulator is instantiated from device
tree, even when it doesn't contain any voltage constraints.

This commit fixes error:

  machine_constraints_voltage: CHARGER: failed to apply 0uV constraint

for following regulator description in DTS:

  CHARGER {
	regulator-min-microamp = <100000>;
	regulator-max-microamp = <200000>;
  }

Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Thomas Abraham <thomas.abraham@linaro.org>
---
 drivers/regulator/of_regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
index f1651eb..679734d 100644
--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -35,7 +35,7 @@ static void of_get_regulation_constraints(struct device_node *np,
 	if (constraints->min_uV != constraints->max_uV)
 		constraints->valid_ops_mask |= REGULATOR_CHANGE_VOLTAGE;
 	/* Only one voltage?  Then make sure it's set. */
-	if (constraints->min_uV == constraints->max_uV)
+	if (min_uV && max_uV && constraints->min_uV == constraints->max_uV)
 		constraints->apply_uV = true;
 
 	uV_offset = of_get_property(np, "regulator-microvolt-offset", NULL);
-- 
1.7.8.3

