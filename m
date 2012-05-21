Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab2EUBiF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 21:38:05 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48610 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253Ab2EUBiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 21:38:04 -0400
Message-ID: <1337564272.4772.2.camel@phoenix>
Subject: [PATCH 1/2] regulator: core: Call set_voltage_time_sel() only when
 the regulator is on
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Mon, 21 May 2012 09:37:52 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the regulator is not on, it won't take time setting new voltage.
So only call set_voltage_time_sel() to get the necessary delay when
the regulator is on.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/core.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 0b15587..8d19ece 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2103,7 +2103,8 @@ static int _regulator_do_set_voltage(struct regulator_dev *rdev,
 	 * If we can't obtain the old selector there is not enough
 	 * info to call set_voltage_time_sel().
 	 */
-	if (rdev->desc->ops->set_voltage_time_sel &&
+	if (_regulator_is_enabled(rdev) &&
+	    rdev->desc->ops->set_voltage_time_sel &&
 	    rdev->desc->ops->get_voltage_sel) {
 		old_selector = rdev->desc->ops->get_voltage_sel(rdev);
 		if (old_selector < 0)
@@ -2135,7 +2136,7 @@ static int _regulator_do_set_voltage(struct regulator_dev *rdev,
 		best_val = -1;
 
 	/* Call set_voltage_time_sel if successfully obtained old_selector */
-	if (ret == 0 && old_selector >= 0 &&
+	if (_regulator_is_enabled(rdev) && ret == 0 && old_selector >= 0 &&
 	    rdev->desc->ops->set_voltage_time_sel) {
 
 		delay = rdev->desc->ops->set_voltage_time_sel(rdev,
-- 
1.7.5.4



