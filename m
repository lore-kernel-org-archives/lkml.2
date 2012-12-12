Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab2LLBW6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 20:22:58 -0500
Received: from mail-da0-f51.google.com ([209.85.210.51]:62646 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043Ab2LLBW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 20:22:57 -0500
Message-ID: <1355275366.11924.2.camel@phoenix>
Subject: [PATCH RFC/RFT] regulator: core: Fix continuous_voltage_range case
 in regulator_can_change_voltage
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Pawel Moll <pawel.moll@arm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Date: Wed, 12 Dec 2012 09:22:46 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regulator drivers with continuous_voltage_range flag set allows not setting
n_voltages. Thus if continuous_voltage_range is set, check the constraint range
instead.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/core.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 0f65b24..d7448ad 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1885,9 +1885,15 @@ int regulator_can_change_voltage(struct regulator *regulator)
 	struct regulator_dev	*rdev = regulator->rdev;
 
 	if (rdev->constraints &&
-	    rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_VOLTAGE &&
-	    (rdev->desc->n_voltages - rdev->desc->linear_min_sel) > 1)
-		return 1;
+	    (rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_VOLTAGE)) {
+		if (rdev->desc->n_voltages - rdev->desc->linear_min_sel > 1)
+			return 1;
+
+		if (rdev->desc->continuous_voltage_range &&
+		    rdev->constraints->min_uV && rdev->constraints->max_uV &&
+		    rdev->constraints->min_uV != rdev->constraints->max_uV)
+			return 1;
+	}
 
 	return 0;
 }
-- 
1.7.9.5



