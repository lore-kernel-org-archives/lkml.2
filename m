Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517Ab2DMTYm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 15:24:42 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:43309 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756476Ab2DMTYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 15:24:40 -0400
Date: Fri, 13 Apr 2012 22:24:24 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: linux-kernel@vger.kernel.org
Subject: [patch] leds-lp5523: BUG() in error handling in probe()
Message-ID: <20120413192424.GB18505@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4F887D6F.0087,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inside the error handling in lp5523_init_led(), there is a place that
calls to led_classdev_unregister().  When we unregister the LED drivers,
it tries to set the brightness to OFF.  In this driver setting the
brightness is done through a work queue and the work queue hasn't been
initialized yet.

The result is that we trigger a BUG_ON() in the __queue_work().

The fix is to move the INIT_WORK() in front of the call to
lp5523_init_led().

Matt Renzelmann found this using a bug finding tool.

Reported-by: Matt Renzelmann <mjr@cs.wisc.edu>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
I don't have this hardware, so I can't test it.

diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index 857a3e1..e8a2712 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -943,6 +943,9 @@ static int __devinit lp5523_probe(struct i2c_client *client,
 		if (pdata->led_config[i].led_current == 0)
 			continue;
 
+		INIT_WORK(&chip->leds[led].brightness_work,
+			lp5523_led_brightness_work);
+
 		ret = lp5523_init_led(&chip->leds[led], &client->dev, i, pdata);
 		if (ret) {
 			dev_err(&client->dev, "error initializing leds\n");
@@ -956,9 +959,6 @@ static int __devinit lp5523_probe(struct i2c_client *client,
 			  LP5523_REG_LED_CURRENT_BASE + chip->leds[led].chan_nr,
 			  chip->leds[led].led_current);
 
-		INIT_WORK(&(chip->leds[led].brightness_work),
-			lp5523_led_brightness_work);
-
 		led++;
 	}
 
