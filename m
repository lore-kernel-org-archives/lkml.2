Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab2GPQLF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 12:11:05 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:47003 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab2GPQLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 12:11:01 -0400
Message-ID: <1342455042.25850.1.camel@phoenix>
Subject: [PATCH] regulator: anatop: Fix wrong mask used in
 anatop_get_voltage_sel
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Nancy Chen <Nancy.Chen@freescale.com>,
        "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Date: Tue, 17 Jul 2012 00:10:42 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mask used in anatop_get_voltage_sel does not match the mask used in
anatop_set_voltage_sel.
We need to do left shift anatop_reg->vol_bit_shift bits for the correct mask.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/anatop-regulator.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/anatop-regulator.c b/drivers/regulator/anatop-regulator.c
index e9c2085..ce0fe72 100644
--- a/drivers/regulator/anatop-regulator.c
+++ b/drivers/regulator/anatop-regulator.c
@@ -64,14 +64,15 @@ static int anatop_set_voltage_sel(struct regulator_dev *reg, unsigned selector)
 static int anatop_get_voltage_sel(struct regulator_dev *reg)
 {
 	struct anatop_regulator *anatop_reg = rdev_get_drvdata(reg);
-	u32 val;
+	u32 val, mask;
 
 	if (!anatop_reg->control_reg)
 		return -ENOTSUPP;
 
 	val = anatop_read_reg(anatop_reg->mfd, anatop_reg->control_reg);
-	val = (val & ((1 << anatop_reg->vol_bit_width) - 1)) >>
+	mask = ((1 << anatop_reg->vol_bit_width) - 1) <<
 		anatop_reg->vol_bit_shift;
+	val = (val & mask) >> anatop_reg->vol_bit_shift;
 
 	return val - anatop_reg->min_bit_val;
 }
-- 
1.7.9.5



