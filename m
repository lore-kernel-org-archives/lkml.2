Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757864Ab2K0CYp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 21:24:45 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:40924 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755614Ab2K0CYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 21:24:44 -0500
Message-ID: <1353983073.5422.2.camel@phoenix>
Subject: [RFC/RFT][PATCH 1/4] regulator: core: Allow specific minimal
 selector for starting linear mapping
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Laxman Dewangan <ldewangan@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 27 Nov 2012 10:24:33 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some drivers (at least 3 drivers) have such variant of linear mapping that
the first few selectors are invalid and the reset are linear mapping.
Let's support this case in core.

This patch adds linear_min_sel in struct regulator_desc,
so we can allow specific minimal selector for starting linear mapping.
Then extends regulator_[map|list]_voltage_linear() to support this feature.

Note that for selectors less than min_linear_index, we need count them to
n_voltages so regulator_list_voltage() won't fail while checking the boundary
for selector before calling list_voltage callback.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/core.c         |    6 ++++++
 include/linux/regulator/driver.h |    2 ++
 2 files changed, 8 insertions(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 3db1e01..273a3b1 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1897,6 +1897,10 @@ int regulator_list_voltage_linear(struct regulator_dev *rdev,
 {
 	if (selector >= rdev->desc->n_voltages)
 		return -EINVAL;
+	if (selector < rdev->desc->linear_min_sel)
+		return 0;
+
+	selector -= rdev->desc->linear_min_sel;
 
 	return rdev->desc->min_uV + (rdev->desc->uV_step * selector);
 }
@@ -2125,6 +2129,8 @@ int regulator_map_voltage_linear(struct regulator_dev *rdev,
 	if (ret < 0)
 		return ret;
 
+	ret += rdev->desc->linear_min_sel;
+
 	/* Map back into a voltage to verify we're still in bounds */
 	voltage = rdev->desc->ops->list_voltage(rdev, ret);
 	if (voltage < min_uV || voltage > max_uV)
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index f2b72b2..d10bb0f 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -187,6 +187,7 @@ enum regulator_type {
  *
  * @min_uV: Voltage given by the lowest selector (if linear mapping)
  * @uV_step: Voltage increase with each selector (if linear mapping)
+ * @linear_min_sel: Minimal selector for starting linear mapping
  * @ramp_delay: Time to settle down after voltage change (unit: uV/us)
  * @volt_table: Voltage mapping table (if table based mapping)
  *
@@ -210,6 +211,7 @@ struct regulator_desc {
 
 	unsigned int min_uV;
 	unsigned int uV_step;
+	unsigned int linear_min_sel;
 	unsigned int ramp_delay;
 
 	const unsigned int *volt_table;
-- 
1.7.9.5



