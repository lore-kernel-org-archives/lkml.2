Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab2AMGdd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 01:33:33 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:45201 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656Ab2AMGda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 01:33:30 -0500
Date: Fri, 13 Jan 2012 09:33:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Richard Purdie <rpurdie@rpsys.net>, NeilBrown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] leds: cleanup error handling in tca6507_probe()
Message-ID: <20120113063315.GB23737@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4F0FD02E.00E3,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a small tidy-up.

1) There is a NULL dereference if the tca allocation fails.
2) The call to cancel_work_sync() isn't needed because we haven't
   scheduled any work.
3) The call to i2c_set_clientdata() isn't needed because the core
   handles that automatically if probe() fails.
4) I added some curly braces for style reasons.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/leds/leds-tca6507.c b/drivers/leds/leds-tca6507.c
index 133f89f..ec06a81 100644
--- a/drivers/leds/leds-tca6507.c
+++ b/drivers/leds/leds-tca6507.c
@@ -687,10 +687,9 @@ static int __devinit tca6507_probe(struct i2c_client *client,
 			NUM_LEDS);
 		return -ENODEV;
 	}
-	err = -ENOMEM;
 	tca = kzalloc(sizeof(*tca), GFP_KERNEL);
 	if (!tca)
-		goto exit;
+		return -ENOMEM;
 
 	tca->client = client;
 	INIT_WORK(&tca->work, tca6507_work);
@@ -724,11 +723,10 @@ static int __devinit tca6507_probe(struct i2c_client *client,
 
 	return 0;
 exit:
-	while (i--)
+	while (i--) {
 		if (tca->leds[i].led_cdev.name)
 			led_classdev_unregister(&tca->leds[i].led_cdev);
-	cancel_work_sync(&tca->work);
-	i2c_set_clientdata(client, NULL);
+	}
 	kfree(tca);
 	return err;
 }
