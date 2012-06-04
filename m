Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561Ab2FDBme (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 21:42:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61279 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755468Ab2FDBlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 21:41:46 -0400
Message-ID: <1338774098.5855.1.camel@phoenix>
Subject: [PATCH] regulator: core: Use map_voltage_linear() if
 list_voltage_linear() is in use and nothing is set
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Mon, 04 Jun 2012 09:41:38 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/core.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 8521e0d..3cbe312 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2118,12 +2118,18 @@ static int _regulator_do_set_voltage(struct regulator_dev *rdev,
 		ret = rdev->desc->ops->set_voltage(rdev, min_uV, max_uV,
 						   &selector);
 	} else if (rdev->desc->ops->set_voltage_sel) {
-		if (rdev->desc->ops->map_voltage)
+		if (rdev->desc->ops->map_voltage) {
 			ret = rdev->desc->ops->map_voltage(rdev, min_uV,
 							   max_uV);
-		else
-			ret = regulator_map_voltage_iterate(rdev, min_uV,
-							    max_uV);
+		} else {
+			if (rdev->desc->ops->list_voltage ==
+			    regulator_list_voltage_linear)
+				ret = regulator_map_voltage_linear(rdev,
+								min_uV, max_uV);
+			else
+				ret = regulator_map_voltage_iterate(rdev,
+								min_uV, max_uV);
+		}
 
 		if (ret >= 0) {
 			selector = ret;
-- 
1.7.9.5



