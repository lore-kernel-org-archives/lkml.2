Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593Ab2FZKiI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 06:38:08 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39424 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756240Ab2FZKiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 06:38:07 -0400
Message-ID: <1340707078.3075.1.camel@phoenix>
Subject: [PATCH] regulator: arizona-micsupp: Fix choosing selector in
 arizona_micsupp_map_voltage
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Tue, 26 Jun 2012 18:37:58 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If min_uV is in the range of: 3250001~3269999,
current code uses the equation:
        selector = DIV_ROUND_UP(min_uV - 1700000, 50000);
Then selector will be 32.
Then arizona_micsupp_list_voltage returns -EINVAL for this case which is wrong.

This patch fixes this issue:
If min_uV > 3200000, selector should be ARIZONA_MICSUPP_MAX_SELECTOR.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/arizona-micsupp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/arizona-micsupp.c b/drivers/regulator/arizona-micsupp.c
index 97d85b0..fdd7473 100644
--- a/drivers/regulator/arizona-micsupp.c
+++ b/drivers/regulator/arizona-micsupp.c
@@ -57,7 +57,7 @@ static int arizona_micsupp_map_voltage(struct regulator_dev *rdev,
 	if (min_uV < 1700000)
 		min_uV = 1700000;
 
-	if (min_uV >= 3300000)
+	if (min_uV > 3200000)
 		selector = ARIZONA_MICSUPP_MAX_SELECTOR;
 	else
 		selector = DIV_ROUND_UP(min_uV - 1700000, 50000);
-- 
1.7.9.5



