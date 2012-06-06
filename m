Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab2FFHvE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 03:51:04 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60830 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab2FFHvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 03:51:01 -0400
Message-ID: <1338969050.4274.1.camel@phoenix>
Subject: [PATCH] regulator: palmas: Slightly code change for better
 readability
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Graeme Gregory <gg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Wed, 06 Jun 2012 15:50:50 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's a little bit hard to read that the "else" case means id == PALMAS_REG_SMPS10.

This patch changes below syntax:
if (id != PALMAS_REG_SMPS10){
        do something for the cases id != PALMAS_REG_SMPS10;
} else {
        do something for the case id == PALMAS_REG_SMPS10;
}

to below syntax:
if (id == PALMAS_REG_SMPS10) {
        do something for the case id == PALMAS_REG_SMPS10;
} else {
        do something for the cases id != PALMAS_REG_SMPS10;
}

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/palmas-regulator.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index b4e10b0..5820d1a 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -517,7 +517,13 @@ static int palmas_smps_init(struct palmas *palmas, int id,
 	if (ret)
 		return ret;
 
-	if (id != PALMAS_REG_SMPS10) {
+	if (id == PALMAS_REG_SMPS10) {
+		if (reg_init->mode_sleep) {
+			reg &= ~PALMAS_SMPS10_CTRL_MODE_SLEEP_MASK;
+			reg |= reg_init->mode_sleep <<
+					PALMAS_SMPS10_CTRL_MODE_SLEEP_SHIFT;
+		}
+	} else {
 		if (reg_init->warm_reset)
 			reg |= PALMAS_SMPS12_CTRL_WR_S;
 
@@ -529,12 +535,6 @@ static int palmas_smps_init(struct palmas *palmas, int id,
 			reg |= reg_init->mode_sleep <<
 					PALMAS_SMPS12_CTRL_MODE_SLEEP_SHIFT;
 		}
-	} else {
-		if (reg_init->mode_sleep) {
-			reg &= ~PALMAS_SMPS10_CTRL_MODE_SLEEP_MASK;
-			reg |= reg_init->mode_sleep <<
-					PALMAS_SMPS10_CTRL_MODE_SLEEP_SHIFT;
-		}
 
 	}
 	ret = palmas_smps_write(palmas, addr, reg);
@@ -660,10 +660,7 @@ static __devinit int palmas_probe(struct platform_device *pdev)
 		pmic->desc[id].name = palmas_regs_info[id].name;
 		pmic->desc[id].id = id;
 
-		if (id != PALMAS_REG_SMPS10) {
-			pmic->desc[id].ops = &palmas_ops_smps;
-			pmic->desc[id].n_voltages = PALMAS_SMPS_NUM_VOLTAGES;
-		} else {
+		if (id == PALMAS_REG_SMPS10) {
 			pmic->desc[id].n_voltages = PALMAS_SMPS10_NUM_VOLTAGES;
 			pmic->desc[id].ops = &palmas_ops_smps10;
 			pmic->desc[id].vsel_reg = PALMAS_SMPS10_CTRL;
@@ -672,6 +669,9 @@ static __devinit int palmas_probe(struct platform_device *pdev)
 			pmic->desc[id].enable_mask = SMPS10_BOOST_EN;
 			pmic->desc[id].min_uV = 3750000;
 			pmic->desc[id].uV_step = 1250000;
+		} else {
+			pmic->desc[id].ops = &palmas_ops_smps;
+			pmic->desc[id].n_voltages = PALMAS_SMPS_NUM_VOLTAGES;
 		}
 
 		pmic->desc[id].type = REGULATOR_VOLTAGE;
-- 
1.7.9.5



