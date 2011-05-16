Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab1EPGwV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 02:52:21 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38521 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558Ab1EPGwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 02:52:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=as/+IZo28hssIj7aZ/WoYpmJiGjSG1FLeoJJIXCYoxm/rAc9AV8Y/rS29+AZUvTe/o
         jTH6rEKZcpdyenicP2dOId4VOyPHXTuWvsxbA8mQha4uNJgaqrBos7rCCz3cbjHcZizz
         wAawmnbJFDpDWMzGK1nsO6SL5YqDvv+h+1C+Q=
Subject: [PATCH] regulator: Simplify
 MAX8997_REG_BUCK1DVS/MAX8997_REG_BUCK2DVS/MAX8997_REG_BUCK5DVS macros
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 May 2011 14:52:13 +0800
Message-ID: <1305528733.15009.8.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like the original macro implementation assumes the caller pass the
parameter starting from 1.
Since now we have +1 operation from all the caller, it would be easier to
assume the caller pass the parameter starting from 0.
Then we can simplify the +1 operation from the caller and then -1 operation
in the macro implementation.

I think this change also improves readability.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8997.c         |   12 ++++++------
 include/linux/mfd/max8997-private.h |    6 +++---
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
index b1c1444..664a31f 100644
--- a/drivers/regulator/max8997.c
+++ b/drivers/regulator/max8997.c
@@ -1032,11 +1032,11 @@ static __devinit int max8997_pmic_probe(struct platform_device *pdev)
 
 	/* For the safety, set max voltage before setting up */
 	for (i = 0; i < 8; i++) {
-		max8997_update_reg(i2c, MAX8997_REG_BUCK1DVS(i + 1),
+		max8997_update_reg(i2c, MAX8997_REG_BUCK1DVS(i),
 				max_buck1, 0x3f);
-		max8997_update_reg(i2c, MAX8997_REG_BUCK2DVS(i + 1),
+		max8997_update_reg(i2c, MAX8997_REG_BUCK2DVS(i),
 				max_buck2, 0x3f);
-		max8997_update_reg(i2c, MAX8997_REG_BUCK5DVS(i + 1),
+		max8997_update_reg(i2c, MAX8997_REG_BUCK5DVS(i),
 				max_buck5, 0x3f);
 	}
 
@@ -1113,13 +1113,13 @@ static __devinit int max8997_pmic_probe(struct platform_device *pdev)
 
 	/* Initialize all the DVS related BUCK registers */
 	for (i = 0; i < 8; i++) {
-		max8997_update_reg(i2c, MAX8997_REG_BUCK1DVS(i + 1),
+		max8997_update_reg(i2c, MAX8997_REG_BUCK1DVS(i),
 				max8997->buck1_vol[i],
 				0x3f);
-		max8997_update_reg(i2c, MAX8997_REG_BUCK2DVS(i + 1),
+		max8997_update_reg(i2c, MAX8997_REG_BUCK2DVS(i),
 				max8997->buck2_vol[i],
 				0x3f);
-		max8997_update_reg(i2c, MAX8997_REG_BUCK5DVS(i + 1),
+		max8997_update_reg(i2c, MAX8997_REG_BUCK5DVS(i),
 				max8997->buck5_vol[i],
 				0x3f);
 	}
diff --git a/include/linux/mfd/max8997-private.h b/include/linux/mfd/max8997-private.h
index 69d1010..bf580a4 100644
--- a/include/linux/mfd/max8997-private.h
+++ b/include/linux/mfd/max8997-private.h
@@ -311,9 +311,9 @@ enum max8997_irq {
 	MAX8997_IRQ_NR,
 };
 
-#define MAX8997_REG_BUCK1DVS(x)	(MAX8997_REG_BUCK1DVS1 + (x) - 1)
-#define MAX8997_REG_BUCK2DVS(x)	(MAX8997_REG_BUCK2DVS1 + (x) - 1)
-#define MAX8997_REG_BUCK5DVS(x)	(MAX8997_REG_BUCK5DVS1 + (x) - 1)
+#define MAX8997_REG_BUCK1DVS(x)	(MAX8997_REG_BUCK1DVS1 + (x))
+#define MAX8997_REG_BUCK2DVS(x)	(MAX8997_REG_BUCK2DVS1 + (x))
+#define MAX8997_REG_BUCK5DVS(x)	(MAX8997_REG_BUCK5DVS1 + (x))
 
 #define MAX8997_NUM_GPIO	12
 struct max8997_dev {
-- 
1.7.1



