Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512Ab2BQN23 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 08:28:29 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16586 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505Ab2BQN22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 08:28:28 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 17 Feb 2012 05:28:27 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: broonie@opensource.wolfsonmicro.com, lrg@ti.com,
        linux-kernel@vger.kernel.org
Cc: linux-tegra@vger.kernel.org, ldewangan@nvidia.com
Subject: [PATCH V1] regulator: tps65910: Correct VIO voltage configuration
Date: Fri, 17 Feb 2012 18:56:11 +0530
Message-Id: <1329485171-14189-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The VIO regulator register specify the voltage configuration
on bit3:2 of its register. And hence only these bits should
be modified when setting voltage and used when reading voltage
from register setting.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/regulator/tps65910-regulator.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index 9092b7f..a9bb6d4 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -674,8 +674,9 @@ static int tps65911_get_voltage(struct regulator_dev *dev)
 		step_mv = 100;
 		break;
 	case TPS65910_REG_VIO:
+		value &= LDO_SEL_MASK;
+		value >>= LDO_SEL_SHIFT;
 		return pmic->info[id]->voltage_table[value] * 1000;
-		break;
 	default:
 		return -EINVAL;
 	}
@@ -767,9 +768,11 @@ static int tps65911_set_voltage(struct regulator_dev *dev, unsigned selector)
 	case TPS65911_REG_LDO6:
 	case TPS65911_REG_LDO7:
 	case TPS65911_REG_LDO8:
-	case TPS65910_REG_VIO:
 		return tps65910_modify_bits(pmic, reg,
 				(selector << LDO_SEL_SHIFT), LDO3_SEL_MASK);
+	case TPS65910_REG_VIO:
+		return tps65910_modify_bits(pmic, reg,
+				(selector << LDO_SEL_SHIFT), LDO_SEL_MASK);
 	}
 
 	return -EINVAL;
-- 
1.7.1.1

