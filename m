Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab2KZHXt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 02:23:49 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:59183 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622Ab2KZHXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 02:23:48 -0500
Message-ID: <1353914618.11550.1.camel@phoenix>
Subject: [PATCH] regulator: da9052: Ensure setting current limit within
 specific range
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Date: Mon, 26 Nov 2012 15:23:38 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checking da9052_current_limits[row][i] <= max_uA is not enough, it is possible
da9052_current_limits[row][i] may less than the requested min_uA.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/da9052-regulator.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/da9052-regulator.c b/drivers/regulator/da9052-regulator.c
index d6fbfd3..d096309 100644
--- a/drivers/regulator/da9052-regulator.c
+++ b/drivers/regulator/da9052-regulator.c
@@ -129,17 +129,17 @@ static int da9052_dcdc_set_current_limit(struct regulator_dev *rdev, int min_uA,
 	else if (offset == 0)
 		row = 1;
 
-	if (min_uA > da9052_current_limits[row][DA9052_MAX_UA] ||
-	    max_uA < da9052_current_limits[row][DA9052_MIN_UA])
-		return -EINVAL;
-
 	for (i = DA9052_CURRENT_RANGE - 1; i >= 0; i--) {
-		if (da9052_current_limits[row][i] <= max_uA) {
+		if ((min_uA <= da9052_current_limits[row][i]) &&
+		    (da9052_current_limits[row][i] <= max_uA)) {
 			reg_val = i;
 			break;
 		}
 	}
 
+	if (i < 0)
+		return -EINVAL;
+
 	/* Determine the even or odd position of the buck current limit
 	 * register field
 	*/
-- 
1.7.9.5



