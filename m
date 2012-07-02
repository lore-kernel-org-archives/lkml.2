Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab2GBOAu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 10:00:50 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58642 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750838Ab2GBOAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 10:00:47 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: core: Support fixed voltages in regulator_is_supported_voltage()
Date: Mon,  2 Jul 2012 15:00:44 +0100
Message-Id: <1341237644-21656-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently regulator_is_supported_voltage() works by enumerating the set
of voltages which can be set by the regulator but the checks we're doing
to impose constraints mean that if we can't vary the voltage we'll not
report any voltages as supported even though the regulator is actually
set at that voltage.

We could fix the voltage listing but this would mean that list_voltage()
could end up going to the hardware to get the current voltage which isn't
expected (it's supposed to be very cheap) so instead special case things
when we can't change the voltage and compare the requested range against
the current voltage.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 04f7d72..d3d26de 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1933,8 +1933,18 @@ EXPORT_SYMBOL_GPL(regulator_list_voltage);
 int regulator_is_supported_voltage(struct regulator *regulator,
 				   int min_uV, int max_uV)
 {
+	struct regulator_dev *rdev = regulator->rdev;
 	int i, voltages, ret;
 
+	/* If we can't change voltage check the current voltage */
+	if (!(rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_VOLTAGE)) {
+		ret = regulator_get_voltage(regulator);
+		if (ret >= 0)
+			return (min_uV >= ret && ret <= max_uV);
+		else
+			return ret;
+	}
+
 	ret = regulator_count_voltages(regulator);
 	if (ret < 0)
 		return ret;
-- 
1.7.10

