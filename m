Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759522Ab2FGCij (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 22:38:39 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:47072 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757920Ab2FGCig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 22:38:36 -0400
Message-ID: <1339036710.7309.8.camel@phoenix>
Subject: [PATCH RFC/RFT] regulator: da903x: Don't read/write to
 DA9030_INVAL/DA9034_INVAL address
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Eric Miao <eric.y.miao@gmail.com>, Mike Rapoport <mike@compulab.co.il>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Thu, 07 Jun 2012 10:38:30 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For fixed voltage, DA9030_LDO13 and DA9034_LDO5, the info->vol_reg is
DA9030_INVAL/DA9034_INVAL.
It does not make sense to read/write to DA9030_INVAL/DA9034_INVAL address.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
Because we use [list|map]_voltage_linear for fixed voltage where uV_step is 0,
this patch also needs below patch:
[PATCH RFC 1/2] regulator: core: Allow uV_step to be 0 for linear mapping if fixed voltage

 drivers/regulator/da903x.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/regulator/da903x.c b/drivers/regulator/da903x.c
index 1005f5f..36c5b92 100644
--- a/drivers/regulator/da903x.c
+++ b/drivers/regulator/da903x.c
@@ -107,6 +107,9 @@ static int da903x_set_voltage_sel(struct regulator_dev *rdev, unsigned selector)
 	struct device *da9034_dev = to_da903x_dev(rdev);
 	uint8_t val, mask;
 
+	if (rdev->desc->n_voltages == 1)
+		return -EINVAL;
+
 	val = selector << info->vol_shift;
 	mask = ((1 << info->vol_nbits) - 1)  << info->vol_shift;
 
@@ -120,6 +123,9 @@ static int da903x_get_voltage_sel(struct regulator_dev *rdev)
 	uint8_t val, mask;
 	int ret;
 
+	if (rdev->desc->n_voltages == 1)
+		return 0;
+
 	ret = da903x_read(da9034_dev, info->vol_reg, &val);
 	if (ret)
 		return ret;
-- 
1.7.9.5



