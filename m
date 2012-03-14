Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758539Ab2CNOrm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 10:47:42 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:20061 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328Ab2CNOrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 10:47:40 -0400
X-AuditID: cbfee61a-b7b78ae000001ceb-a5-4f60af8a49cd
Message-id: <4F60AF8E.7050900@samsung.com>
Date: Wed, 14 Mar 2012 23:47:42 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, sameo@linux.intel.com,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, myungjoo.ham@samsung.com
Subject: Re: [PATCH v3 2/2] input: add driver support for MAX8997-haptic
References: <4F5DB459.9090701@samsung.com>
 <20120314084652.GC3964@core.coreip.homeip.net>
In-reply-to: <20120314084652.GC3964@core.coreip.homeip.net>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

> This is not proper locking between playing effect and suspend. Now that
> you are using workqueue you need to synchronize access with it, not with
> play_effect method.
> 
> Does the following patch work for you?
> 

Your patch is worked on TRATS board based on EXYNOS4210 but, you should
apply following patch because 'chip->enabled' is used on
max8997_haptic_configure() function to enable/disable haptic motor.

diff --git a/drivers/haptic/max8997_haptic.c
b/drivers/haptic/max8997_haptic.c
index 806bcf3..0347404 100644
--- a/drivers/haptic/max8997_haptic.c
+++ b/drivers/haptic/max8997_haptic.c
@@ -182,11 +182,11 @@ static void max8997_haptic_enable(struct
max8997_haptic *chip)
 	}

 	if (!chip->enabled) {
+		chip->enabled = true;
 		regulator_enable(chip->regulator);
 		max8997_haptic_configure(chip);
 		if (chip->mode == MAX8997_EXTERNAL_MODE)
 			pwm_enable(chip->pwm);
-		chip->enabled = true;
 	}

 out:
@@ -198,11 +198,11 @@ static void max8997_haptic_disable(struct
max8997_haptic *chip)
 	mutex_lock(&chip->mutex);

 	if (chip->enabled) {
+		chip->enabled = false;
 		max8997_haptic_configure(chip);
 		if (chip->mode == MAX8997_EXTERNAL_MODE)
 			pwm_disable(chip->pwm);
 		regulator_disable(chip->regulator);
-		chip->enabled = false;
 	}

 	mutex_unlock(&chip->mutex);
-- 
1.7.0.4

Thank you,
Chanwoo Choi
