Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932952Ab2KWHge (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 02:36:34 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:43145 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932412Ab2KWHgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 02:36:31 -0500
X-AuditID: cbfee61b-b7f616d00000319b-4d-50af27767a7d
From: Thomas Abraham <thomas.abraham@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, broonie@opensource.wolfsonmicro.com,
        myungjoo.ham@samsung.com, linux-samsung-soc@vger.kernel.org,
        kgene.kim@samsung.com, t.figa@samsung.com
Subject: [PATCH 2/3] regulator: max8997: limit the number of dvs registers
 programmed in non-dvs mode
Date: Fri, 23 Nov 2012 13:33:14 +0530
Message-id: <1353657795-1725-3-git-send-email-thomas.abraham@linaro.org>
X-Mailer: git-send-email 1.6.6.rc2
In-reply-to: <1353657795-1725-1-git-send-email-thomas.abraham@linaro.org>
References: <1353657795-1725-1-git-send-email-thomas.abraham@linaro.org>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKJMWRmVeSWpSXmKPExsVy+t9jQd0y9fUBBu2tEhaXd81hs5hxfh+T
	A5PH501yAYxRXDYpqTmZZalF+nYJXBn/jj1gKzjAW7Gm5SBzA+Nfri5GTg4JAROJ59/3s0HY
	YhIX7q0Hsrk4hASmM0qcWnGCCcJpY5I4euMxO0gVm4CBxKOF78BsEQEFic29z1hBipgFdjBK
	XGiZAdTBwSEskC6x54gwSA2LgKrEiV1P2UHCvAIeEhtXeUAsU5LY0HuUCcTmFPCUOHq+nxmk
	RAio5O+D0AmMvAsYGVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBHv+mfQOxlUNFocYBTgY
	lXh4DcvWBQixJpYVV+YeYpTgYFYS4WUSWx8gxJuSWFmVWpQfX1Sak1p8iFGag0VJnLfZIyVA
	SCA9sSQ1OzW1ILUIJsvEwSnVwKj3sfPBwnMXt3wLKJcu8Zx7nSNHZNL+qS9Pv/pqfmBOzPxN
	qyW9+Z22r/mTXuQ/lffomo1rOzJY0teLl7fs0tko6bP0hH/Zi32NbMsXVk/5UOqf2xbVYBww
	ceb/vWKqrP/9FS63l8k/ZIie7VZvMTl3on5jkNcktwn/4pSjM/It2D3zJ/YFtCixFGckGmox
	FxUnAgDtq0Lu+AEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case the gpio based volatage selection mode is not used for either of
buck 1/2/5, then only the BUCKxDVS1 register need to be programmed. So
determine whether dvs mode is used and limit the loop count appropriately.

Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
---
 drivers/regulator/max8997.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
index 8901371..231fcdb 100644
--- a/drivers/regulator/max8997.c
+++ b/drivers/regulator/max8997.c
@@ -941,7 +941,7 @@ static int max8997_pmic_probe(struct platform_device *pdev)
 	struct regulator_dev **rdev;
 	struct max8997_data *max8997;
 	struct i2c_client *i2c;
-	int i, ret, size;
+	int i, ret, size, nr_dvs;
 	u8 max_buck1 = 0, max_buck2 = 0, max_buck5 = 0;
 
 	if (!pdata) {
@@ -973,7 +973,10 @@ static int max8997_pmic_probe(struct platform_device *pdev)
 	memcpy(max8997->buck125_gpios, pdata->buck125_gpios, sizeof(int) * 3);
 	max8997->ignore_gpiodvs_side_effect = pdata->ignore_gpiodvs_side_effect;
 
-	for (i = 0; i < 8; i++) {
+	nr_dvs = (pdata->buck1_gpiodvs || pdata->buck2_gpiodvs ||
+			pdata->buck5_gpiodvs) ? 8 : 1;
+
+	for (i = 0; i < nr_dvs; i++) {
 		max8997->buck1_vol[i] = ret =
 			max8997_get_voltage_proper_val(
 					&buck1245_voltage_map_desc,
@@ -1020,7 +1023,7 @@ static int max8997_pmic_probe(struct platform_device *pdev)
 	}
 
 	/* Initialize all the DVS related BUCK registers */
-	for (i = 0; i < 8; i++) {
+	for (i = 0; i < nr_dvs; i++) {
 		max8997_update_reg(i2c, MAX8997_REG_BUCK1DVS1 + i,
 				max8997->buck1_vol[i],
 				0x3f);
-- 
1.6.6.rc2

