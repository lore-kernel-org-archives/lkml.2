Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716Ab2F0JLV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 05:11:21 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:47459 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201Ab2F0JLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 05:11:14 -0400
Date: Wed, 27 Jun 2012 12:10:56 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch -resend] leds-lp5523: BUG() in error handling in probe()
Message-ID: <20120627091055.GW31212@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120627085800.GA3007@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inside the error handling in lp5523_init_led(), there is a place that
calls to led_classdev_unregister().  When we unregister the LED drivers,
it tries to set the brightness to OFF.  In this driver setting the
brightness is done through a work queue and the work queue hasn't been
initialized yet.

The result is that we trigger a WARN_ON() in the __queue_work().

The fix is to move the INIT_WORK() in front of the call to
lp5523_init_led().

Matt Renzelmann found this using a bug finding tool.

Reported-by: Matt Renzelmann <mjr@cs.wisc.edu>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
I don't have this hardware, so I can't test it.  I originally sent this
on Fri, 13 Apr 2012, and that was before Bryan Wu took on the LED
subsystem.  Also when I sent it, the WARN_ON() in __queue_work() was
a BUG_ON() so I've updated the commit message.

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
 
