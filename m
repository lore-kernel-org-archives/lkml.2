Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758468Ab2FZIB4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 04:01:56 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63711 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804Ab2FZIBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 04:01:55 -0400
Message-ID: <1340697707.12992.1.camel@phoenix>
Subject: [PATCH] regulator: arizona-micsupp: Fix choosing selector in
 arizona_micsupp_map_voltage
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Tue, 26 Jun 2012 16:01:47 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARIZONA_MICSUPP_MAX_SELECTOR is 0x1f

When selector is 0 ... 0x1e, we use below equation:
        (selector * 50000) + 1700000;
so the voltage range is 1700000 ... 3200000 uV.

When selector is 0x1f:
        voltage = 3300000 uV.

Thus in the map_voltage callback:

If min_uV > 3300000, we should return -EINVAL.
If min_uV > 3200000, selector should be ARIZONA_MICSUPP_MAX_SELECTOR.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/arizona-micsupp.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/arizona-micsupp.c b/drivers/regulator/arizona-micsupp.c
index 97d85b0..a27421e 100644
--- a/drivers/regulator/arizona-micsupp.c
+++ b/drivers/regulator/arizona-micsupp.c
@@ -54,10 +54,13 @@ static int arizona_micsupp_map_voltage(struct regulator_dev *rdev,
 	unsigned int voltage;
 	int selector;
 
+	if (min_uV > 3300000)
+		return -EINVAL;
+
 	if (min_uV < 1700000)
 		min_uV = 1700000;
 
-	if (min_uV >= 3300000)
+	if (min_uV > 3200000)
 		selector = ARIZONA_MICSUPP_MAX_SELECTOR;
 	else
 		selector = DIV_ROUND_UP(min_uV - 1700000, 50000);
-- 
1.7.9.5



