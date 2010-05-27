Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757113Ab0E0CIc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 22:08:32 -0400
Received: from dakia2.marvell.com ([65.219.4.35]:50400 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801Ab0E0CIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 22:08:30 -0400
X-ASG-Debug-ID: 1274926109-44a376030001-xx1T2L
X-Barracuda-Envelope-From: hzhuang1@marvell.com
From: Haojian Zhuang <hzhuang1@marvell.com>
To: Dan Carpenter <error27@gmail.com>, Samuel Ortiz <sameo@linux.intel.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Date: Wed, 26 May 2010 19:08:25 -0700
X-ASG-Orig-Subj: RE: [patch] mfd/88pm860x: fix uninitialized variable and clean up
Subject: RE: [patch] mfd/88pm860x: fix uninitialized variable and clean up
Thread-Topic: [patch] mfd/88pm860x: fix uninitialized variable and clean up
X-ASG-Orig-Subj: RE: [patch] mfd/88pm860x: fix uninitialized variable and clean up
Thread-Index: Acr9Jm8rBh5kUv/8T3q46+gIb0YLvAAGv/kA
Message-ID: <25B60CDC2F704E4E9D88FFD52780CB4C04D6304643@SC-VEXCH1.marvell.com>
References: <20100526225409.GQ22515@bicker>
In-Reply-To: <20100526225409.GQ22515@bicker>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginalArrivalTime: 27 May 2010 02:08:28.0894 (UTC) FILETIME=[7F995FE0:01CAFD41]
X-Barracuda-Connect: msi-mta.marvell.com[10.68.76.91]
X-Barracuda-Start-Time: 1274926109
X-Barracuda-URL: http://10.68.76.222:80/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: -1002.00
X-Barracuda-Spam-Status: No, SCORE=-1002.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o4R2A7im013020

I'm OK on this patch.

Thanks
Haojian

-----Original Message-----
From: Dan Carpenter [mailto:error27@gmail.com] 
Sent: 2010å¹´5æœˆ27æ—¥ 6:54 AM
To: Samuel Ortiz
Cc: Haojian Zhuang; Mark Brown; Liam Girdwood; linux-kernel@vger.kernel.org; kernel-janitors@vger.kernel.org
Subject: [patch] mfd/88pm860x: fix uninitialized variable and clean up

The original code had a compile warning:
drivers/mfd/88pm860x-core.c:431: warning: â€˜retâ€™ may be used
	uninitialized in this function
It seems like the warning is valid if either pdata or pdata->touch is
NULL.

This patch checks pdata and pdata->touch at the beginning of the 
function.  That means everything can be pulled in one indent level.
Now all the statements fit within the 80 character limit.

Also at that point the "use_gpadc" variable isn't needed and removing
it simplifies the logic.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/mfd/88pm860x-core.c b/drivers/mfd/88pm860x-core.c
index 405d2d5..f9ada69 100644
--- a/drivers/mfd/88pm860x-core.c
+++ b/drivers/mfd/88pm860x-core.c
@@ -428,52 +428,44 @@ static int __devinit device_gpadc_init(struct pm860x_chip *chip,
 {
 	struct i2c_client *i2c = (chip->id == CHIP_PM8607) ? chip->client \
 				: chip->companion;
-	int use_gpadc = 0, data, ret;
+	int data;
+	int ret;
 
 	/* initialize GPADC without activating it */
 
-	if (pdata && pdata->touch) {
-		/* set GPADC MISC1 register */
-		data = 0;
-		data |= (pdata->touch->gpadc_prebias << 1)
-			& PM8607_GPADC_PREBIAS_MASK;
-		data |= (pdata->touch->slot_cycle << 3)
-			& PM8607_GPADC_SLOT_CYCLE_MASK;
-		data |= (pdata->touch->off_scale << 5)
-			& PM8607_GPADC_OFF_SCALE_MASK;
-		data |= (pdata->touch->sw_cal << 7)
-			& PM8607_GPADC_SW_CAL_MASK;
-		if (data) {
-			ret = pm860x_reg_write(i2c, PM8607_GPADC_MISC1, data);
-			if (ret < 0)
-				goto out;
-		}
-		/* set tsi prebias time */
-		if (pdata->touch->tsi_prebias) {
-			data = pdata->touch->tsi_prebias;
-			ret = pm860x_reg_write(i2c, PM8607_TSI_PREBIAS, data);
-			if (ret < 0)
-				goto out;
-		}
-		/* set prebias & prechg time of pen detect */
-		data = 0;
-		data |= pdata->touch->pen_prebias & PM8607_PD_PREBIAS_MASK;
-		data |= (pdata->touch->pen_prechg << 5)
-			& PM8607_PD_PRECHG_MASK;
-		if (data) {
-			ret = pm860x_reg_write(i2c, PM8607_PD_PREBIAS, data);
-			if (ret < 0)
-				goto out;
-		}
+	if (!pdata || !pdata->touch)
+		return -EINVAL;
 
-		use_gpadc = 1;
+	/* set GPADC MISC1 register */
+	data = 0;
+	data |= (pdata->touch->gpadc_prebias << 1) & PM8607_GPADC_PREBIAS_MASK;
+	data |= (pdata->touch->slot_cycle << 3) & PM8607_GPADC_SLOT_CYCLE_MASK;
+	data |= (pdata->touch->off_scale << 5) & PM8607_GPADC_OFF_SCALE_MASK;
+	data |= (pdata->touch->sw_cal << 7) & PM8607_GPADC_SW_CAL_MASK;
+	if (data) {
+		ret = pm860x_reg_write(i2c, PM8607_GPADC_MISC1, data);
+		if (ret < 0)
+			goto out;
 	}
-
-	/* turn on GPADC */
-	if (use_gpadc) {
-		ret = pm860x_set_bits(i2c, PM8607_GPADC_MISC1,
-				      PM8607_GPADC_EN, PM8607_GPADC_EN);
+	/* set tsi prebias time */
+	if (pdata->touch->tsi_prebias) {
+		data = pdata->touch->tsi_prebias;
+		ret = pm860x_reg_write(i2c, PM8607_TSI_PREBIAS, data);
+		if (ret < 0)
+			goto out;
 	}
+	/* set prebias & prechg time of pen detect */
+	data = 0;
+	data |= pdata->touch->pen_prebias & PM8607_PD_PREBIAS_MASK;
+	data |= (pdata->touch->pen_prechg << 5) & PM8607_PD_PRECHG_MASK;
+	if (data) {
+		ret = pm860x_reg_write(i2c, PM8607_PD_PREBIAS, data);
+		if (ret < 0)
+			goto out;
+	}
+
+	ret = pm860x_set_bits(i2c, PM8607_GPADC_MISC1,
+			      PM8607_GPADC_EN, PM8607_GPADC_EN);
 out:
 	return ret;
 }
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éÝ¶¥Šwÿº{.nÇ+‰·¥Š{±þG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŽŠÝ¢j"ú¶m§ÿÿ¾«þG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
