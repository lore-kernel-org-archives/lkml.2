Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163Ab2DVPL5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 11:11:57 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:42151 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504Ab2DVPL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 11:11:56 -0400
Message-ID: <1335107508.6261.3.camel@phoenix>
Subject: [PATCH] leds: lm3530: fix handling of already enabled regulators
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>,
        "Milo(Woogyom) Kim" <milo.kim@ti.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Sun, 22 Apr 2012 23:11:48 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is possible that the regulator has been previously enabled by bootloader or
kernel board initialization code. Thus, don't assume the regulator is disabled
by default. Get the correct status by regulator_is_enabled().

The leds-lm3530 driver was ignoring the initial status of the
regulator; this resulted in rdev->use_count being incremented to 2 after
calling lm3530_init_registers() in the .probe method when a regulator
was already enabled at insmod time, which made it impossible to ever
disable the regulator.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/leds/leds-lm3530.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/leds/leds-lm3530.c b/drivers/leds/leds-lm3530.c
index 968fd5f..859bf04 100644
--- a/drivers/leds/leds-lm3530.c
+++ b/drivers/leds/leds-lm3530.c
@@ -397,7 +397,6 @@ static int __devinit lm3530_probe(struct i2c_client *client,
 	drvdata->client = client;
 	drvdata->pdata = pdata;
 	drvdata->brightness = LED_OFF;
-	drvdata->enable = false;
 	drvdata->led_dev.name = LM3530_LED_DEV;
 	drvdata->led_dev.brightness_set = lm3530_brightness_set;
 	drvdata->led_dev.max_brightness = MAX_BRIGHTNESS;
@@ -411,6 +410,7 @@ static int __devinit lm3530_probe(struct i2c_client *client,
 		drvdata->regulator = NULL;
 		goto err_regulator_get;
 	}
+	drvdata->enable = regulator_is_enabled(drvdata->regulator);
 
 	if (drvdata->pdata->brt_val) {
 		err = lm3530_init_registers(drvdata);
-- 
1.7.5.4



