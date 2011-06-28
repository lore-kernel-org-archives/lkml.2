Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481Ab1F1DlS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 23:41:18 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:62758 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756446Ab1F1Djv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 23:39:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=KYdMzRhPL/fVXi8mhuaHNcoLk5cv1Q5AxSJHibgw5sSrkH4RH2L38ZPBjuOuMIkJg+
         aN84umA0kYdmqwPdmcJpMXsqR5miQ9R6oNQztj2hv9hMxxBtzxzzlJ68BIxkkhUvOqgP
         /PaMWhRA5HWxOYFnnbCNL4BNZ9ZXWyNSE7mf8=
Subject: [PATCH] leds: leds-sunfire: fix sunfire_led_generic_probe error
 handling
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Richard Purdie <rpurdie@rpsys.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Jun 2011 11:39:43 +0800
Message-ID: <1309232383.6146.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch includes below fixes:
1. Return -ENOMEM if kzalloc fails
2. Fix a memory leak in the case of goto out_unregister_led_cdevs.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/leds/leds-sunfire.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/leds/leds-sunfire.c b/drivers/leds/leds-sunfire.c
index ab6d18f..1757396 100644
--- a/drivers/leds/leds-sunfire.c
+++ b/drivers/leds/leds-sunfire.c
@@ -127,17 +127,19 @@ static int __devinit sunfire_led_generic_probe(struct platform_device *pdev,
 					       struct led_type *types)
 {
 	struct sunfire_drvdata *p;
-	int i, err = -EINVAL;
+	int i, err;
 
 	if (pdev->num_resources != 1) {
 		printk(KERN_ERR PFX "Wrong number of resources %d, should be 1\n",
 		       pdev->num_resources);
+		err = -EINVAL;
 		goto out;
 	}
 
 	p = kzalloc(sizeof(*p), GFP_KERNEL);
 	if (!p) {
 		printk(KERN_ERR PFX "Could not allocate struct sunfire_drvdata\n");
+		err = -ENOMEM;
 		goto out;
 	}
 
@@ -160,14 +162,14 @@ static int __devinit sunfire_led_generic_probe(struct platform_device *pdev,
 
 	dev_set_drvdata(&pdev->dev, p);
 
-	err = 0;
-out:
-	return err;
+	return 0;
 
 out_unregister_led_cdevs:
 	for (i--; i >= 0; i--)
 		led_classdev_unregister(&p->leds[i].led_cdev);
-	goto out;
+	kfree(p);
+out:
+	return err;
 }
 
 static int __devexit sunfire_led_generic_remove(struct platform_device *pdev)
-- 
1.7.4.1



