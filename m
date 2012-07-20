Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451Ab2GTPLD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 11:11:03 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64018 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab2GTPLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 11:11:01 -0400
Message-ID: <1342797055.3401.3.camel@phoenix>
Subject: [PATCH] regulator: Use BUCK_FPWM_[MASK|SHIFT] macros to replace
 buck_pmap table
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: "Milo(Woogyom) Kim" <milo.kim@ti.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 20 Jul 2012 23:10:55 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the buck_pmap mapping table:

BUCK1:  mask = 1 << 0,  shift = 0
BUCK2:  mask = 1 << 1,  shift = 1
BUCK3:  mask = 1 << 2,  shift = 2
BUCK4:  mask = 1 << 3,  shift = 3

The mask and shift can be easily calculated by:
        mask = 1 << BUCK_ID
        shift = BUCK_ID

This patch defines BUCK_FPWM_MASK and BUCK_FPWM_SHIFT macros to replace
buck_pmap mapping table.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/lp8788-buck.c |   55 +++++++++------------------------------
 1 file changed, 12 insertions(+), 43 deletions(-)

diff --git a/drivers/regulator/lp8788-buck.c b/drivers/regulator/lp8788-buck.c
index 0c93a6a..ba3e0aa 100644
--- a/drivers/regulator/lp8788-buck.c
+++ b/drivers/regulator/lp8788-buck.c
@@ -69,6 +69,9 @@
 #define PIN_HIGH			1
 #define ENABLE_TIME_USEC		32
 
+#define BUCK_FPWM_MASK(x)		(1 << (x))
+#define BUCK_FPWM_SHIFT(x)		(x)
+
 enum lp8788_dvs_state {
 	DVS_LOW  = GPIOF_OUT_INIT_LOW,
 	DVS_HIGH = GPIOF_OUT_INIT_HIGH,
@@ -86,15 +89,9 @@ enum lp8788_buck_id {
 	BUCK4,
 };
 
-struct lp8788_pwm_map {
-	u8 mask;
-	u8 shift;
-};
-
 struct lp8788_buck {
 	struct lp8788 *lp;
 	struct regulator_dev *regulator;
-	struct lp8788_pwm_map *pmap;
 	void *dvs;
 };
 
@@ -106,29 +103,6 @@ static const int lp8788_buck_vtbl[] = {
 	1950000, 2000000,
 };
 
-/* buck pwm mode selection : used for set/get_mode in regulator ops
- * @forced pwm : fast mode
- * @auto pwm   : normal mode
- */
-static struct lp8788_pwm_map buck_pmap[] = {
-	[BUCK1] = {
-		.mask = LP8788_FPWM_BUCK1_M,
-		.shift = LP8788_FPWM_BUCK1_S,
-	},
-	[BUCK2] = {
-		.mask = LP8788_FPWM_BUCK2_M,
-		.shift = LP8788_FPWM_BUCK2_S,
-	},
-	[BUCK3] = {
-		.mask = LP8788_FPWM_BUCK3_M,
-		.shift = LP8788_FPWM_BUCK3_S,
-	},
-	[BUCK4] = {
-		.mask = LP8788_FPWM_BUCK4_M,
-		.shift = LP8788_FPWM_BUCK4_S,
-	},
-};
-
 static const u8 buck1_vout_addr[] = {
 	LP8788_BUCK1_VOUT0, LP8788_BUCK1_VOUT1,
 	LP8788_BUCK1_VOUT2, LP8788_BUCK1_VOUT3,
@@ -347,41 +321,37 @@ static int lp8788_buck_enable_time(struct regulator_dev *rdev)
 static int lp8788_buck_set_mode(struct regulator_dev *rdev, unsigned int mode)
 {
 	struct lp8788_buck *buck = rdev_get_drvdata(rdev);
-	struct lp8788_pwm_map *pmap = buck->pmap;
-	u8 val;
-
-	if (!pmap)
-		return -EINVAL;
+	enum lp8788_buck_id id = rdev_get_id(rdev);
+	u8 mask, val;
 
+	mask = BUCK_FPWM_MASK(id);
 	switch (mode) {
 	case REGULATOR_MODE_FAST:
-		val = LP8788_FORCE_PWM << pmap->shift;
+		val = LP8788_FORCE_PWM << BUCK_FPWM_SHIFT(id);
 		break;
 	case REGULATOR_MODE_NORMAL:
-		val = LP8788_AUTO_PWM << pmap->shift;
+		val = LP8788_AUTO_PWM << BUCK_FPWM_SHIFT(id);
 		break;
 	default:
 		return -EINVAL;
 	}
 
-	return lp8788_update_bits(buck->lp, LP8788_BUCK_PWM, pmap->mask, val);
+	return lp8788_update_bits(buck->lp, LP8788_BUCK_PWM, mask, val);
 }
 
 static unsigned int lp8788_buck_get_mode(struct regulator_dev *rdev)
 {
 	struct lp8788_buck *buck = rdev_get_drvdata(rdev);
-	struct lp8788_pwm_map *pmap = buck->pmap;
+	enum lp8788_buck_id id = rdev_get_id(rdev);
 	u8 val;
 	int ret;
 
-	if (!pmap)
-		return -EINVAL;
-
 	ret = lp8788_read_byte(buck->lp, LP8788_BUCK_PWM, &val);
 	if (ret)
 		return ret;
 
-	return val & pmap->mask ? REGULATOR_MODE_FAST : REGULATOR_MODE_NORMAL;
+	return val & BUCK_FPWM_MASK(id) ?
+				REGULATOR_MODE_FAST : REGULATOR_MODE_NORMAL;
 }
 
 static struct regulator_ops lp8788_buck12_ops = {
@@ -548,7 +518,6 @@ static __devinit int lp8788_buck_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	buck->lp = lp;
-	buck->pmap = &buck_pmap[id];
 
 	ret = lp8788_init_dvs(buck, id);
 	if (ret)
-- 
1.7.9.5



