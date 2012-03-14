Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030834Ab2CNNP3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 09:15:29 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51581 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030815Ab2CNNPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 09:15:24 -0400
Message-ID: <1331730914.12069.2.camel@phoenix>
Subject: [PATCH RFT] regulator: Fix setting new voltage in
 s5m8767_set_voltage
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 14 Mar 2012 21:15:14 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code does not really update the register with new value, fix it.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
Hi Sangbeom,
I don't have this hardware, can you test it?
Thanks,
Axel
 drivers/regulator/s5m8767.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index 58447db..4ca2db0 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -311,8 +311,7 @@ static int s5m8767_set_voltage(struct regulator_dev *rdev,
 	struct s5m8767_info *s5m8767 = rdev_get_drvdata(rdev);
 	const struct s5m_voltage_desc *desc;
 	int reg_id = rdev_get_id(rdev);
-	int reg, mask, ret;
-	int i;
+	int sel, reg, mask, ret;
 	u8 val;
 
 	switch (reg_id) {
@@ -333,19 +332,20 @@ static int s5m8767_set_voltage(struct regulator_dev *rdev,
 
 	desc = reg_voltage_map[reg_id];
 
-	i = s5m8767_convert_voltage_to_sel(desc, min_uV, max_uV);
-	if (i < 0)
-		return i;
+	sel = s5m8767_convert_voltage_to_sel(desc, min_uV, max_uV);
+	if (sel < 0)
+		return sel;
 
 	ret = s5m8767_get_voltage_register(rdev, &reg);
 	if (ret)
 		return ret;
 
 	s5m_reg_read(s5m8767->iodev, reg, &val);
-	val = val & mask;
+	val &= ~mask;
+	val |= sel;
 
 	ret = s5m_reg_write(s5m8767->iodev, reg, val);
-	*selector = i;
+	*selector = sel;
 
 	return ret;
 }
-- 
1.7.5.4



