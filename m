Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872Ab2BXPNZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 10:13:25 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50490 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695Ab2BXPNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 10:13:24 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of axel.lin@gmail.com designates 10.68.226.41 as permitted sender) smtp.mail=axel.lin@gmail.com; dkim=pass header.i=axel.lin@gmail.com
Message-ID: <1330096399.5102.3.camel@phoenix>
Subject: [PATCH v3] regulator: Set delay to 0 if set_voltage_time_sel
 callback returns error
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Fri, 24 Feb 2012 23:13:19 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rdev->desc->ops->set_voltage_time_sel may return negative error code.
Set delay to 0 and also show warning if set_voltage_time_sel returns error.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
v3: only coding style change, the result should be the same as v2.
v2: show warning message if set_voltage_time_sel returns error.
 drivers/regulator/core.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index beeeb7f..5a6b8ba 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1890,8 +1890,12 @@ static int _regulator_do_set_voltage(struct regulator_dev *rdev,
 			if (ret < 0)
 				return ret;
 			old_selector = ret;
-			delay = rdev->desc->ops->set_voltage_time_sel(rdev,
+			ret = rdev->desc->ops->set_voltage_time_sel(rdev,
 						old_selector, selector);
+			if (ret < 0)
+				rdev_warn(rdev, "set_voltage_time_sel() failed: %d\n", ret);
+			else
+				delay = ret;
 		}
 
 		if (best_val != INT_MAX) {
-- 
1.7.5.4



