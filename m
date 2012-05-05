Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab2EEMKB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 08:10:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47269 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754915Ab2EEMJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 08:09:59 -0400
Date: Sat, 5 May 2012 05:08:35 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Karl Komierowski <karl.komierowski@stericsson.com>,
        Arun Murthy <arun.murthy@stericsson.com>
Subject: Re: [PATCH 1/3] power/ab8500_charger: harden platform data check
Message-ID: <20120505120835.GA26976@lizard>
References: <1334304949-18301-1-git-send-email-linus.walleij@stericsson.com>
 <CACRpkdaM=OecD=M_J9X9shYKQkWO03mhb2BFxCWOeocr8_m=DQ@mail.gmail.com>
 <4F9C1CF5.3050706@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4F9C1CF5.3050706@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2012 at 05:38:13PM +0100, Lee Jones wrote:
> Find my version of the 3 patches below.
> 
> These also clean up some ugliness and brings the variable initialisation 
> formatting more into line with other drivers. If you like them I can 
> officially send them to the MLs as patches.
> 
> Your call of course.

Sorry for the delay.

I like these cleanups. The patch below is what I've applied on top
of Linus' series. Please check if there's everything OK.

Notice that I inserted your Signed-off-by line in advance. But for
the history, please provide your formal sign-off (no need to resend
the patch, publicly replying to this email with something like
'Signed-off-by: Lee Jones <lee.jones@linaro.org>' would work ;-)

Much thanks!

- - - -
commit 2aac3de19b72608f474c90034185c2be4908728f
Author: Lee Jones <lee.jones@linaro.org>
Date:   Sat May 5 04:38:19 2012 -0700

    ab8500: Clean up probe routines
    
    These patches clean up some ugliness and brings the variable
    initialisation formatting more into line with other drivers.
    
    Signed-off-by: Lee Jones <lee.jones@linaro.org>
    Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>

diff --git a/drivers/power/ab8500_btemp.c b/drivers/power/ab8500_btemp.c
index e266f03..bba3cca 100644
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
+	di = kzalloc(sizeof(*di), GFP_KERNEL);
 	if (!di)
 		return -ENOMEM;
 
@@ -977,13 +982,12 @@ static int __devinit ab8500_btemp_probe(struct platform_device *pdev)
 	di->gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
 
 	/* get btemp specific platform data */
-	plat_data = pdev->dev.platform_data;
-	if (!plat_data || !plat_data->btemp) {
+	di->pdata = plat_data->btemp;
+	if (!di->pdata) {
 		dev_err(di->dev, "no btemp platform data supplied\n");
 		ret = -EINVAL;
 		goto free_device_info;
 	}
-	di->pdata = plat_data->btemp;
 
 	/* get battery specific platform data */
 	di->bat = plat_data->battery;
diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index 79dc584..d2303d0 100644
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
+	di = kzalloc(sizeof(*di), GFP_KERNEL);
 	if (!di)
 		return -ENOMEM;
 
@@ -2550,13 +2555,12 @@ static int __devinit ab8500_charger_probe(struct platform_device *pdev)
 	spin_lock_init(&di->usb_state.usb_lock);
 
 	/* get charger specific platform data */
-	plat_data = pdev->dev.platform_data;
-	if (!plat_data || !plat_data->charger) {
+	di->pdata = plat_data->charger;
+	if (!di->pdata) {
 		dev_err(di->dev, "no charger platform data supplied\n");
 		ret = -EINVAL;
 		goto free_device_info;
 	}
-	di->pdata = plat_data->charger;
 
 	/* get battery specific platform data */
 	di->bat = plat_data->battery;
diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index 0ebea39..bf02225 100644
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
+	di = kzalloc(sizeof(*di), GFP_KERNEL);
 	if (!di)
 		return -ENOMEM;
 
@@ -2461,13 +2466,12 @@ static int __devinit ab8500_fg_probe(struct platform_device *pdev)
 	di->gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
 
 	/* get fg specific platform data */
-	plat_data = pdev->dev.platform_data;
-	if (!plat_data || !plat_data->fg) {
+	di->pdata = plat_data->fg;
+	if (!di->pdata) {
 		dev_err(di->dev, "no fg platform data supplied\n");
 		ret = -EINVAL;
 		goto free_device_info;
 	}
-	di->pdata = plat_data->fg;
 
 	/* get battery specific platform data */
 	di->bat = plat_data->battery;
