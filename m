Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786Ab2KTEjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 23:39:19 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58173 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab2KTEjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 23:39:18 -0500
Message-ID: <1353386347.19552.1.camel@phoenix>
Subject: [PATCH RFT] regulator: da9055: Fix return wrong selector in
 da9055_regulator_get_voltage_sel
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Date: Tue, 20 Nov 2012 12:39:07 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We do "selector += info->volt.v_offset" in da9055_regulator_set_voltage_bits()
to take care of voltage range that does not start with 0 offset.
Thus in da9055_regulator_get_voltage_sel() we should do corresponding
"sel -= volt.v_offset" before returning selector.
Otherwise, we pass wrong selector for list_voltage callback.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/da9055-regulator.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/da9055-regulator.c b/drivers/regulator/da9055-regulator.c
index 79c5665..dbcb43d 100644
--- a/drivers/regulator/da9055-regulator.c
+++ b/drivers/regulator/da9055-regulator.c
@@ -232,10 +232,9 @@ static int da9055_regulator_get_voltage_sel(struct regulator_dev *rdev)
 		return ret;
 
 	sel = (ret & volt.v_mask);
-	if (sel <= volt.v_offset)
-		return 0;
-	else
-		return sel;
+	sel -= volt.v_offset;
+
+	return sel;
 }
 
 static int da9055_regulator_set_voltage_bits(struct regulator_dev *rdev,
-- 
1.7.9.5



