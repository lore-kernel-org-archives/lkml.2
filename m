Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183Ab2GRDa3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 23:30:29 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51537 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab2GRDaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 23:30:22 -0400
Message-ID: <1342582211.12515.2.camel@phoenix>
Subject: [PATCH] regulator: palmas: Fix calculating selector in
 palmas_map_voltage_ldo
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Graeme Gregory <gg@slimlogic.co.uk>,
        Liam Girdwood <lrg@ti.com>
Date: Wed, 18 Jul 2012 11:30:11 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes below issues when choosing selector:

1. Current code returns negative selector if min_uV < 900000 which is wrong.
   For example, it is possible to satisfy the request with selector = 1 if
   the requested min_uV is 850000.
2. Current code may select a voltage lower than requested min_uV.
   For example, if the requested min_uV is 945000, current code chooses
   selector = 1 which is lower than requested min_uV.
   DIV_ROUND_UP to avoid this case.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/palmas-regulator.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index 17d19fb..0fcf355 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -486,9 +486,12 @@ static int palmas_map_voltage_ldo(struct regulator_dev *rdev,
 {
 	int ret, voltage;
 
-	ret = ((min_uV - 900000) / 50000) + 1;
-	if (ret < 0)
-		return ret;
+	if (min_uV == 0)
+		return 0;
+
+	if (min_uV < 900000)
+		min_uV = 900000;
+	ret = DIV_ROUND_UP(min_uV - 900000, 50000) + 1;
 
 	/* Map back into a voltage to verify we're still in bounds */
 	voltage = palmas_list_voltage_ldo(rdev, ret);
-- 
1.7.9.5



