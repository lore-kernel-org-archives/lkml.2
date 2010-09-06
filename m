Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806Ab0IFIny (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 04:43:54 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:52049 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114Ab0IFInx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 04:43:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=YFEuoXy10FmjuOXWYj9jqGYmOXkLgWitdO4PbmJoSkk+NjF6mp2TKJS9lrTbrt5ym1
         vg5zEmguxJPGejJxaifRonweP5tKGE6zQfVK5e6cNqVTc27ms9yfJUfdPxij6BZrz3AG
         mriRO5RPmvHCC6sMFbcDUh7re09C0JwWTChzg=
Subject: [PATCH] regulator: wm831x-ldo - fix the logic to set
	REGULATOR_MODE_IDLE and REGULATOR_MODE_STANDBY modes
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Content-Type: text/plain
Date: Mon, 06 Sep 2010 16:48:13 +0800
Message-Id: <1283762893.10643.2.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Problem description in current implementation:
When setting REGULATOR_MODE_IDLE mode, current implementation set
WM831X_LDO1_LP_MODE bit of ctrl_reg (which is wrong, it should clear the bit).
But due to a missing break statement for case REGULATOR_MODE_IDLE, the code
fall through to case REGULATOR_MODE_STANDBY and then clear
WM831X_LDO1_LP_MODE bit. So it still looks OK when checking the status
by wm831x_gp_ldo_get_mode().

When setting REGULATOR_MODE_STANDBY mode, it just does not work.
wm831x_gp_ldo_get_mode() will still return REGULATOR_MODE_IDLE because
the accordingly WM831X_LDO1_LP_MODE bit is clear.

Correct behavior should be:
Clear WM831X_LDO1_LP_MODE bit of ctrl_reg for REGULATOR_MODE_IDLE mode.
Set WM831X_LDO1_LP_MODE bit of ctrl_reg for REGULATOR_MODE_STANDBY mode.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/wm831x-ldo.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/wm831x-ldo.c b/drivers/regulator/wm831x-ldo.c
index e686cdb..9edf8f6 100644
--- a/drivers/regulator/wm831x-ldo.c
+++ b/drivers/regulator/wm831x-ldo.c
@@ -215,8 +215,7 @@ static int wm831x_gp_ldo_set_mode(struct regulator_dev *rdev,
 
 	case REGULATOR_MODE_IDLE:
 		ret = wm831x_set_bits(wm831x, ctrl_reg,
-				      WM831X_LDO1_LP_MODE,
-				      WM831X_LDO1_LP_MODE);
+				      WM831X_LDO1_LP_MODE, 0);
 		if (ret < 0)
 			return ret;
 
@@ -225,10 +224,12 @@ static int wm831x_gp_ldo_set_mode(struct regulator_dev *rdev,
 				      WM831X_LDO1_ON_MODE);
 		if (ret < 0)
 			return ret;
+		break;
 
 	case REGULATOR_MODE_STANDBY:
 		ret = wm831x_set_bits(wm831x, ctrl_reg,
-				      WM831X_LDO1_LP_MODE, 0);
+				      WM831X_LDO1_LP_MODE,
+				      WM831X_LDO1_LP_MODE);
 		if (ret < 0)
 			return ret;
 
-- 
1.7.2



