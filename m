Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab2D1QiS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 12:38:18 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60058 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab2D1QiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 12:38:17 -0400
Message-ID: <4F9C1CF5.3050706@linaro.org>
Date: Sat, 28 Apr 2012 17:38:13 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120402 Thunderbird/11.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Anton Vorontsov <anton.vorontsov@linaro.org>, linux-kernel@vger.kernel.org,
        Karl Komierowski <karl.komierowski@stericsson.com>,
        Arun Murthy <arun.murthy@stericsson.com>
Subject: Re: [PATCH 1/3] power/ab8500_charger: harden platform data check
References: <1334304949-18301-1-git-send-email-linus.walleij@stericsson.com> <CACRpkdaM=OecD=M_J9X9shYKQkWO03mhb2BFxCWOeocr8_m=DQ@mail.gmail.com>
In-Reply-To: <CACRpkdaM=OecD=M_J9X9shYKQkWO03mhb2BFxCWOeocr8_m=DQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Find my version of the 3 patches below.

These also clean up some ugliness and brings the variable initialisation 
formatting more into line with other drivers. If you like them I can 
officially send them to the MLs as patches.

Your call of course.

On 28/04/12 13:59, Linus Walleij wrote:
> On Fri, Apr 13, 2012 at 10:15 AM, Linus Walleij
> <linus.walleij@stericsson.com>  wrote:
> 
>> From: Linus Walleij<linus.walleij@linaro.org>
>>
>> If no platform data at all is supplied the driver crashes,
>> extend the checks to be more careful so we can compile in the
>> driver and boot also without platform data present.
>>
>> Cc: Arun Murthy<arun.murthy@stericsson.com>
>> Signed-off-by: Linus Walleij<linus.walleij@linaro.org>
> 
> Anton have you picked these three patches for the -rc:s?
> 
> It seems Lee Jones is facing the problems so would be nice to
> have this upstream.
> 
> Yours,
> Linus Walleij

diff --git a/drivers/power/ab8500_btemp.c b/drivers/power/ab8500_btemp.c
index d8bb993..a2ebcb4 100644
--- a/drivers/power/ab8500_btemp.c
+++ b/drivers/power/ab8500_btemp.c
@@ -964,10 +964,15 @@ static int __devinit ab8500_btemp_probe(struct platform_device *pdev)
 {
 	int irq, i, ret = 0;
 	u8 val;
-	struct abx500_bm_plat_data *plat_data;
+	struct abx500_bm_plat_data *plat_data = pdev->dev.platform_data;
+	struct ab8500_btemp *di;
+
+	if (!plat_data) {
+		dev_err(&pdev->dev, "No platform data\n");
+		return -EINVAL;
+	}
 
-	struct ab8500_btemp *di =
-		kzalloc(sizeof(struct ab8500_btemp), GFP_KERNEL);
+	di = kzalloc(sizeof(struct ab8500_btemp), GFP_KERNEL);
 	if (!di)
 		return -ENOMEM;
 
@@ -977,7 +982,6 @@ static int __devinit ab8500_btemp_probe(struct platform_device *pdev)
 	di->gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
 
 	/* get btemp specific platform data */
-	plat_data = pdev->dev.platform_data;
 	di->pdata = plat_data->btemp;
 	if (!di->pdata) {
 		dev_err(di->dev, "no btemp platform data supplied\n");

##############################################################################

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index e2b4acc..a4e37a8 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -2534,10 +2534,15 @@ static int __devexit ab8500_charger_remove(struct platform_device *pdev)
 static int __devinit ab8500_charger_probe(struct platform_device *pdev)
 {
 	int irq, i, charger_status, ret = 0;
-	struct abx500_bm_plat_data *plat_data;
+	struct abx500_bm_plat_data *plat_data = pdev->dev.platform_data;
+	struct ab8500_charger *di;
 
-	struct ab8500_charger *di =
-		kzalloc(sizeof(struct ab8500_charger), GFP_KERNEL);
+	if (!plat_data) {
+		dev_err(&pdev->dev, "No platform data\n");
+		return -EINVAL;
+	}
+
+	di = kzalloc(sizeof(struct ab8500_charger), GFP_KERNEL);
 	if (!di)
 		return -ENOMEM;
 
@@ -2550,7 +2555,6 @@ static int __devinit ab8500_charger_probe(struct platform_device *pdev)
 	spin_lock_init(&di->usb_state.usb_lock);
 
 	/* get charger specific platform data */
-	plat_data = pdev->dev.platform_data;
 	di->pdata = plat_data->charger;
 
 	if (!di->pdata) {

##############################################################################

diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index c22f2f0..d88bc47 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -2446,10 +2446,15 @@ static int __devinit ab8500_fg_probe(struct platform_device *pdev)
 {
 	int i, irq;
 	int ret = 0;
-	struct abx500_bm_plat_data *plat_data;
+	struct abx500_bm_plat_data *plat_data = pdev->dev.platform_data;
+	struct ab8500_fg *di;
+
+	if (!plat_data) {
+		dev_err(&pdev->dev, "No platform data\n");
+		return -EINVAL;
+	}
 
-	struct ab8500_fg *di =
-		kzalloc(sizeof(struct ab8500_fg), GFP_KERNEL);
+	di = kzalloc(sizeof(struct ab8500_fg), GFP_KERNEL);
 	if (!di)
 		return -ENOMEM;
 
@@ -2461,7 +2466,6 @@ static int __devinit ab8500_fg_probe(struct platform_device *pdev)
 	di->gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
 
 	/* get fg specific platform data */
-	plat_data = pdev->dev.platform_data;
 	di->pdata = plat_data->fg;
 	if (!di->pdata) {
 		dev_err(di->dev, "no fg platform data supplied\n");
-- 
1.7.9.1
