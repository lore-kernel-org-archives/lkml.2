Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab2LYCGe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 21:06:34 -0500
Received: from mail-da0-f52.google.com ([209.85.210.52]:60101 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385Ab2LYCGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 21:06:32 -0500
Message-ID: <1356401180.14680.6.camel@phoenix>
Subject: [PATCH] regulator: lp8755: Fix lp8755_regulator_init unwind code
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Daniel Jeong <gshark.jeong@gmail.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 25 Dec 2012 10:06:20 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's safe to pass NULL argument to regulator_unregister(), so we can remove
the NULL checking before calling regulator_unregister().
However pass a ERR_PTR to regulator_unregister() is wrong, so we need to
explicitly set "pchip->rdev[buck_num] = NULL" before goto err_buck.

This patch also includes below cleanups:
Show correct regulator id in dev_err.
Remove __devexit_p.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/lp8755.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/lp8755.c b/drivers/regulator/lp8755.c
index dbc4d12..06a82e2 100644
--- a/drivers/regulator/lp8755.c
+++ b/drivers/regulator/lp8755.c
@@ -358,7 +358,9 @@ static int lp8755_regulator_init(struct lp8755_chip *pchip)
 		    regulator_register(&lp8755_regulators[buck_num], &rconfig);
 		if (IS_ERR(pchip->rdev[buck_num])) {
 			ret = PTR_ERR(pchip->rdev[buck_num]);
-			dev_err(pchip->dev, "regulator init failed: buck 0\n");
+			pchip->rdev[buck_num] = NULL;
+			dev_err(pchip->dev, "regulator init failed: buck %d\n",
+				buck_num);
 			goto err_buck;
 		}
 	}
@@ -367,8 +369,7 @@ static int lp8755_regulator_init(struct lp8755_chip *pchip)
 
 err_buck:
 	for (icnt = 0; icnt < LP8755_BUCK_MAX; icnt++)
-		if (pchip->rdev[icnt] != NULL)
-			regulator_unregister(pchip->rdev[icnt]);
+		regulator_unregister(pchip->rdev[icnt]);
 	return ret;
 }
 
@@ -557,7 +558,7 @@ static struct i2c_driver lp8755_i2c_driver = {
 		   .name = LP8755_NAME,
 		   },
 	.probe = lp8755_probe,
-	.remove = __devexit_p(lp8755_remove),
+	.remove = lp8755_remove,
 	.id_table = lp8755_id,
 };
 
-- 
1.7.9.5



