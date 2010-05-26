Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934742Ab0EZWyq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 18:54:46 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48576 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934280Ab0EZWyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 18:54:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :user-agent;
        b=UxX1j1nzusoD8fSG81bji4/AuNfjcy/4Tx30m2xgI2KKahjLTAlc6VbncNHdWShB4h
         35zx1zugD2zGSi1ZJfrZS8I83QmW+1le5t6JKwoZuS8uyvVlM1wXTaXAtGOq6DvItxMC
         A8D3cxnMqLiSAlOmuXvkGmKG0Z1lw4cG+/0JU=
Date: Thu, 27 May 2010 00:54:09 +0200
From: Dan Carpenter <error27@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [patch] mfd/88pm860x: fix uninitialized variable and clean up
Message-ID: <20100526225409.GQ22515@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Haojian Zhuang <haojian.zhuang@marvell.com>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original code had a compile warning:
drivers/mfd/88pm860x-core.c:431: warning: ‘ret’ may be used
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
