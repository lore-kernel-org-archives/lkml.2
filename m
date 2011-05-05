Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346Ab1EEPdI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 11:33:08 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:44239 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362Ab1EEPdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 11:33:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=jtQM1D7T49QzzW9EY53qxWSGLBS8wipyCPs5xvghVXQ2L9RTfknzuDqA6Llygk3Y0K
         groLAnm6sQSOSyVGKxgGMf2V4WzA5nR5lhviVl2Xv2B86/RsAAivdcTfDcK2nPVTzsWp
         8+xVnngXOJ852s1vaVU6WwC7iU6lSZzw3RMXs=
Subject: [PATCH] regulator: Move VCOINCELL to be the last element of
 mc13892_regulators array
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Yong Shen <yong.shen@linaro.org>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 May 2011 23:32:58 +0800
Message-ID: <1304609578.5296.4.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In include/linux/mfd/mc13892.h, we define MC13892_VCOINCELL as 23.
Thus VCOINCELL should be defined as 23th element in mc13892_regulators array, not the first one.
This actually fixes an off-by-one bug while accessing mc13892_regulators array.

For example,
In mc13892_regulator_probe, we use MC13892_VCAM as array index of mc13892_regulators array.
        mc13892_regulators[MC13892_VCAM].desc.ops->set_mode
                = mc13892_vcam_set_mode;
Currently, it access mc13892_regulators[12] ,which is VAUDIO not VCAM.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
I don't have this hardware handy, just found this bug while reading the code.
I appreciate if someone can test it.

Axel

 drivers/regulator/mc13892-regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/mc13892-regulator.c b/drivers/regulator/mc13892-regulator.c
index 1b8f739..ba909cb 100644
--- a/drivers/regulator/mc13892-regulator.c
+++ b/drivers/regulator/mc13892-regulator.c
@@ -259,7 +259,6 @@ static struct regulator_ops mc13892_sw_regulator_ops;
 			mc13xxx_regulator_ops)
 
 static struct mc13xxx_regulator mc13892_regulators[] = {
-	MC13892_DEFINE_REGU(VCOINCELL, POWERCTL0, POWERCTL0, mc13892_vcoincell),
 	MC13892_SW_DEFINE(SW1, SWITCHERS0, SWITCHERS0, mc13892_sw1),
 	MC13892_SW_DEFINE(SW2, SWITCHERS1, SWITCHERS1, mc13892_sw),
 	MC13892_SW_DEFINE(SW3, SWITCHERS2, SWITCHERS2, mc13892_sw),
@@ -293,6 +292,7 @@ static struct mc13xxx_regulator mc13892_regulators[] = {
 	MC13892_GPO_DEFINE(GPO4, POWERMISC, mc13892_gpo),
 	MC13892_GPO_DEFINE(PWGT1SPI, POWERMISC, mc13892_pwgtdrv),
 	MC13892_GPO_DEFINE(PWGT2SPI, POWERMISC, mc13892_pwgtdrv),
+	MC13892_DEFINE_REGU(VCOINCELL, POWERCTL0, POWERCTL0, mc13892_vcoincell),
 };
 
 static int mc13892_powermisc_rmw(struct mc13xxx_regulator_priv *priv, u32 mask,
-- 
1.7.1



