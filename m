Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047Ab2HHMWm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 08:22:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59067 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664Ab2HHMWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 08:22:41 -0400
Message-ID: <1344428555.3199.6.camel@phoenix>
Subject: [PATCH 6/7] regulator: lp872x: set_current_limit should select the
 maximum current in specific range
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: "Milo(Woogyom) Kim" <milo.kim@ti.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 08 Aug 2012 20:22:35 +0800
In-Reply-To: <1344428238.3199.1.camel@phoenix>
References: <1344428238.3199.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/lp872x.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/regulator/lp872x.c b/drivers/regulator/lp872x.c
index 212c38e..6199d0f 100644
--- a/drivers/regulator/lp872x.c
+++ b/drivers/regulator/lp872x.c
@@ -374,8 +374,8 @@ static int lp8725_buck_set_current_limit(struct regulator_dev *rdev,
 {
 	struct lp872x *lp = rdev_get_drvdata(rdev);
 	enum lp872x_regulator_id buck = rdev_get_id(rdev);
-	int i, max = ARRAY_SIZE(lp8725_buck_uA);
-	u8 addr, val;
+	int i;
+	u8 addr;
 
 	switch (buck) {
 	case LP8725_ID_BUCK1:
@@ -388,17 +388,15 @@ static int lp8725_buck_set_current_limit(struct regulator_dev *rdev,
 		return -EINVAL;
 	}
 
-	for (i = 0 ; i < max ; i++)
+	for (i = ARRAY_SIZE(lp8725_buck_uA) - 1 ; i >= 0; i--) {
 		if (lp8725_buck_uA[i] >= min_uA &&
 			lp8725_buck_uA[i] <= max_uA)
-			break;
-
-	if (i == max)
-		return -EINVAL;
-
-	val = i << LP8725_BUCK_CL_S;
+			return lp872x_update_bits(lp, addr,
+						  LP8725_BUCK_CL_M,
+						  i << LP8725_BUCK_CL_S);
+	}
 
-	return lp872x_update_bits(lp, addr, LP8725_BUCK_CL_M, val);
+	return -EINVAL;
 }
 
 static int lp8725_buck_get_current_limit(struct regulator_dev *rdev)
-- 
1.7.9.5



