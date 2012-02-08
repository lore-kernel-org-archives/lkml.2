Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749Ab2BHKsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 05:48:18 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11120 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755608Ab2BHKsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 05:48:14 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 08 Feb 2012 02:48:07 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: sameo@linux.intel.com, lrg@ti.com, broonie@opensource.wolfsonmicro.com,
        jedu@slimlogic.co.uk, gg@slimlogic.co.uk, linux-kernel@vger.kernel.org
Cc: linux-tegra@vger.kernel.org, ldewangan@nvidia.com
Subject: [PATCH V1 2/2] regulator: tps65910: Enable register caching of voltage controls.
Date: Wed,  8 Feb 2012 16:16:25 +0530
Message-Id: <1328697985-22504-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1328697985-22504-1-git-send-email-ldewangan@nvidia.com>
References: <1328697985-22504-1-git-send-email-ldewangan@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enabling the caching of the registers which is used for voltage
controls. By doing this, the modify_bits operation is faster as
it does not involve the i2c register read from device, just read
from cache. This results faster set voltage operation.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/regulator/tps65910-regulator.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index 9092b7f..3731d69 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -1123,6 +1123,18 @@ static __devinit int tps65910_probe(struct platform_device *pdev)
 				pmic->desc[i].ops = &tps65911_ops;
 		}
 
+		/* Enable register caching */
+		tps65910_enable_reg_cache(tps65910, pmic->get_ctrl_reg(i));
+		/* VDD1/VDD2/VDDCTRL-TPS65911 have SR and OP register */
+		if ((i == TPS65910_REG_VDD1) || (i == TPS65910_REG_VDD2) ||
+			((tps65910_chip_id(tps65910) == TPS65911) &&
+				(i == TPS65911_REG_VDDCTRL))) {
+			tps65910_enable_reg_cache(tps65910,
+						pmic->get_ctrl_reg(i) + 1);
+			tps65910_enable_reg_cache(tps65910,
+						pmic->get_ctrl_reg(i) + 2);
+		}
+
 		err = tps65910_set_ext_sleep_config(pmic, i,
 				pmic_plat_data->regulator_ext_sleep_control[i]);
 		/*
-- 
1.7.1.1

