Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964893Ab2KWHfn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 02:35:43 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:48134 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964843Ab2KWHfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 02:35:41 -0500
X-AuditID: cbfee61b-b7f616d00000319b-fc-50af274c4dda
From: Thomas Abraham <thomas.abraham@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, broonie@opensource.wolfsonmicro.com,
        myungjoo.ham@samsung.com, linux-samsung-soc@vger.kernel.org,
        kgene.kim@samsung.com, t.figa@samsung.com
Subject: [PATCH 1/3] regulator: max8997: reorder buck1/2/5 dvs setup code
Date: Fri, 23 Nov 2012 13:33:13 +0530
Message-id: <1353657795-1725-2-git-send-email-thomas.abraham@linaro.org>
X-Mailer: git-send-email 1.6.6.rc2
In-reply-to: <1353657795-1725-1-git-send-email-thomas.abraham@linaro.org>
References: <1353657795-1725-1-git-send-email-thomas.abraham@linaro.org>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKJMWRmVeSWpSXmKPExsVy+t9jQV0f9fUBBuvm8llc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGV8uXqYqeAbf8XfhfkNjK94uhg5OSQETCTmnNrCAmGL
	SVy4t56ti5GLQ0hgOqPE5e6f7BBOG5PEkyN/GEGq2AQMJB4tfMcOYosIKEhs7n3GClLELLCD
	UeJCywymLkYODmEBT4kbj6RBalgEVCUW3r8DtoFXwEPi0o5zzBDblCQ29B5lArE5gcqPnu9n
	BmkVAqr5+yB0AiPvAkaGVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjBnn8mvYNxVYPFIUYB
	DkYlHl7DsnUBQqyJZcWVuYcYJTiYlUR4mcTWBwjxpiRWVqUW5ccXleakFh9ilOZgURLnbfZI
	CRASSE8sSc1OTS1ILYLJMnFwSjUwMk+qf1qnvC2we9/y648Oe6ydpvb4p+/LkH23gkLOLbDc
	NKPfJ3NPb91eg41yBlwNCzUPtP+2/ZgeUxopwrT42NPIsq/Rb6Z3Ltgvd9q2+War0OOVnVON
	2Sct9ey49OjEOb32vctVljNnCvztkVpcH+zHN3vpxM0daXf6f89ZLHfH7nWY4aO8ZUosxRmJ
	hlrMRcWJAPLqusH4AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BUCKxDVSx register programming is now moved prior to setting up of the
gpio based dvs mode. This will ensure that all the BUCKxDVSx registers
are programmed with appropriate voltage values before the gpio based dvs
mode is selected for buck1/2/5.

Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
---
 drivers/regulator/max8997.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
index cea9ec9..8901371 100644
--- a/drivers/regulator/max8997.c
+++ b/drivers/regulator/max8997.c
@@ -1019,6 +1019,19 @@ static int max8997_pmic_probe(struct platform_device *pdev)
 				max_buck5, 0x3f);
 	}
 
+	/* Initialize all the DVS related BUCK registers */
+	for (i = 0; i < 8; i++) {
+		max8997_update_reg(i2c, MAX8997_REG_BUCK1DVS1 + i,
+				max8997->buck1_vol[i],
+				0x3f);
+		max8997_update_reg(i2c, MAX8997_REG_BUCK2DVS1 + i,
+				max8997->buck2_vol[i],
+				0x3f);
+		max8997_update_reg(i2c, MAX8997_REG_BUCK5DVS1 + i,
+				max8997->buck5_vol[i],
+				0x3f);
+	}
+
 	/*
 	 * If buck 1, 2, and 5 do not care DVS GPIO settings, ignore them.
 	 * If at least one of them cares, set gpios.
@@ -1068,19 +1081,6 @@ static int max8997_pmic_probe(struct platform_device *pdev)
 	max8997_update_reg(i2c, MAX8997_REG_BUCK5CTRL, (pdata->buck5_gpiodvs) ?
 			(1 << 1) : (0 << 1), 1 << 1);
 
-	/* Initialize all the DVS related BUCK registers */
-	for (i = 0; i < 8; i++) {
-		max8997_update_reg(i2c, MAX8997_REG_BUCK1DVS1 + i,
-				max8997->buck1_vol[i],
-				0x3f);
-		max8997_update_reg(i2c, MAX8997_REG_BUCK2DVS1 + i,
-				max8997->buck2_vol[i],
-				0x3f);
-		max8997_update_reg(i2c, MAX8997_REG_BUCK5DVS1 + i,
-				max8997->buck5_vol[i],
-				0x3f);
-	}
-
 	/* Misc Settings */
 	max8997->ramp_delay = 10; /* set 10mV/us, which is the default */
 	max8997_write_reg(i2c, MAX8997_REG_BUCKRAMP, (0xf << 4) | 0x9);
-- 
1.6.6.rc2

