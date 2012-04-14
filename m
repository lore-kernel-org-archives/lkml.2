Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab2DNBOo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 21:14:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37071 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348Ab2DNBOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 21:14:43 -0400
Message-ID: <1334366074.2694.3.camel@phoenix>
Subject: [PATCH RFC/RFT] regulator: core: Support setting
 suspend_[mode|voltage] if set_suspend_[en|dis]able is NULL
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Sat, 14 Apr 2012 09:14:34 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current implementation, to support set_suspend_voltage and set_suspend_mode
the regulator code needs the regulator driver to implement both
set_suspend_enable and set_suspend_disable callbacks.

This patch removes this limitation. In the case set_suspend_enable and/or
set_suspend_disable are NULL, the regulator code assumes we don't need to
do any thing to enable/disable regulator when system is suspended and
then will continue to handle set_suspend_mode and set_suspend_voltage.

Currently the regulator core creates suspend state related sysfs entries only
if both set_suspend_enable and set_suspend_disable callbacks are not NULL.
A side-effect of this change is that the regulator core will create suspend
state related sysfs entries unconditionally now.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/core.c |   27 +++++++++------------------
 1 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index f241671..ecbf37c 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -673,17 +673,14 @@ static int suspend_set_state(struct regulator_dev *rdev,
 	struct regulator_state *rstate)
 {
 	int ret = 0;
-	bool can_set_state;
-
-	can_set_state = rdev->desc->ops->set_suspend_enable &&
-		rdev->desc->ops->set_suspend_disable;
 
 	/* If we have no suspend mode configration don't set anything;
-	 * only warn if the driver actually makes the suspend mode
-	 * configurable.
+	 * only warn if the driver implements set_suspend_voltage or
+	 * set_suspend_mode callback.
 	 */
 	if (!rstate->enabled && !rstate->disabled) {
-		if (can_set_state)
+		if (rdev->desc->ops->set_suspend_voltage ||
+		    rdev->desc->ops->set_suspend_mode)
 			rdev_warn(rdev, "No configuration\n");
 		return 0;
 	}
@@ -693,15 +690,13 @@ static int suspend_set_state(struct regulator_dev *rdev,
 		return -EINVAL;
 	}
 
-	if (!can_set_state) {
-		rdev_err(rdev, "no way to set suspend state\n");
-		return -EINVAL;
-	}
-
-	if (rstate->enabled)
+	if (rstate->enabled && rdev->desc->ops->set_suspend_enable)
 		ret = rdev->desc->ops->set_suspend_enable(rdev);
-	else
+	else if (rstate->disabled && rdev->desc->ops->set_suspend_disable)
 		ret = rdev->desc->ops->set_suspend_disable(rdev);
+	else /* OK if set_suspend_enable or set_suspend_disable is NULL */
+		ret = 0;
+
 	if (ret < 0) {
 		rdev_err(rdev, "failed to enabled/disable\n");
 		return ret;
@@ -2781,10 +2776,6 @@ static int add_regulator_attributes(struct regulator_dev *rdev)
 			return status;
 	}
 
-	/* suspend mode constraints need multiple supporting methods */
-	if (!(ops->set_suspend_enable && ops->set_suspend_disable))
-		return status;
-
 	status = device_create_file(dev, &dev_attr_suspend_standby_state);
 	if (status < 0)
 		return status;
-- 
1.7.5.4



