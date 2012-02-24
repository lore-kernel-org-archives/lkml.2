Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab2BXGw4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 01:52:56 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38470 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab2BXGwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 01:52:54 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of axel.lin@gmail.com designates 10.68.241.170 as permitted sender) smtp.mail=axel.lin@gmail.com; dkim=pass header.i=axel.lin@gmail.com
Message-ID: <1330066365.21167.1.camel@phoenix>
Subject: [PATCH RFC] regulator: Fix the logic of s5m8767_set_voltage_time_sel
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Fri, 24 Feb 2012 14:52:45 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch includes below fixes:
1. The mask variable is not used at all here, remove it.
2. We already have the new_sel and old_sel, simply returns the delay by:
  DIV_ROUND_UP(desc->step * (new_sel - old_sel), s5m8767->ramp_delay);

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
Hi Sangbeom,
I don't have this hardware, I'd appreciate if you can review and test this patch.

The fix of the logic is base on the original post of the patch(v2):
https://lkml.org/lkml/2011/12/24/31

I think the implementation got wrong when converting to
s5m8767_set_voltage_time_sel.

Axel
 drivers/regulator/s5m8767.c |   30 ++----------------------------
 1 files changed, 2 insertions(+), 28 deletions(-)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index 2fb2add..9b97aa3 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -452,39 +452,13 @@ static int s5m8767_set_voltage_time_sel(struct regulator_dev *rdev,
 	struct s5m8767_info *s5m8767 = rdev_get_drvdata(rdev);
 	const struct s5m_voltage_desc *desc;
 	int reg_id = rdev_get_id(rdev);
-	int mask;
-	int new_val, old_val;
 
-	switch (reg_id) {
-	case S5M8767_LDO1 ... S5M8767_LDO28:
-		mask = 0x3f;
-		break;
-	case S5M8767_BUCK1 ... S5M8767_BUCK6:
-		mask = 0xff;
-		break;
-	case S5M8767_BUCK7 ... S5M8767_BUCK8:
-		return -EINVAL;
-	case S5M8767_BUCK9:
-		mask = 0xff;
-		break;
-	default:
-		return -EINVAL;
-	}
 	desc = reg_voltage_map[reg_id];
 
-	new_val = s5m8767_convert_voltage(desc, new_sel, new_sel);
-	if (new_val < 0)
-		return new_val;
-
-	old_val = s5m8767_convert_voltage(desc, old_sel, old_sel);
-	if (old_val < 0)
-		return old_val;
-
 	if (old_sel < new_sel)
-		return DIV_ROUND_UP(desc->step * (new_val - old_val),
+		return DIV_ROUND_UP(desc->step * (new_sel - old_sel),
 					s5m8767->ramp_delay);
-	else
-		return 0;
+	return 0;
 }
 
 static struct regulator_ops s5m8767_ldo_ops = {
-- 
1.7.5.4



