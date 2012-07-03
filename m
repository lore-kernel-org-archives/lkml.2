Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933442Ab2GCHTl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 03:19:41 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:48204 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756039Ab2GCHTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 03:19:40 -0400
Message-ID: <1341299973.4669.4.camel@phoenix>
Subject: [PATCH v2] regulator: tps65217: Fix voltage boundary checking in
 tps65217_pmic_map_voltage
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: "AnilKumar, Chimata" <anilkumar@ti.com>, "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>
Date: Tue, 03 Jul 2012 15:19:33 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is ok to request voltage with min_uV < tps->info[rid]->min_uV and
max_uV > tps->info[rid]->max_uV.

The equation we used in uv_to_vsel() does not allow
min_uV < tps->info[rid]->min_uV, otherwise it returns negative selector.
So we need to set min_uV = tps->info[rid]->min_uV if
min_uV < tps->info[rid]->min_uV.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps65217-regulator.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/tps65217-regulator.c b/drivers/regulator/tps65217-regulator.c
index 0a3df5b..f7d0495 100644
--- a/drivers/regulator/tps65217-regulator.c
+++ b/drivers/regulator/tps65217-regulator.c
@@ -206,10 +206,10 @@ static int tps65217_pmic_map_voltage(struct regulator_dev *dev,
 	if (rid < TPS65217_DCDC_1 || rid > TPS65217_LDO_4)
 		return -EINVAL;
 
-	if (min_uV < tps->info[rid]->min_uV || min_uV > tps->info[rid]->max_uV)
-		return -EINVAL;
+	if (min_uV < tps->info[rid]->min_uV)
+		min_uV = tps->info[rid]->min_uV;
 
-	if (max_uV < tps->info[rid]->min_uV || max_uV > tps->info[rid]->max_uV)
+	if (max_uV < tps->info[rid]->min_uV || min_uV > tps->info[rid]->max_uV)
 		return -EINVAL;
 
 	ret = tps->info[rid]->uv_to_vsel(min_uV, &sel);
-- 
1.7.9.5



