Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707Ab0CTOSc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 10:18:32 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59048 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162Ab0CTOOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 10:14:09 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: kernel-janitors@vger.kernel.org
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
       Wolfram Sang <w.sang@pengutronix.de>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org
Date: Sat, 20 Mar 2010 15:12:47 +0100
Message-Id: <1269094385-16114-7-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de>
References: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de>
X-SA-Exim-Connect-IP: 92.198.50.58
X-SA-Exim-Mail-From: w.sang@pengutronix.de
Subject: [PATCH 06/24] input/keyboard: fix dangling pointers
X-SA-Exim-Version: 4.2.1 (built Sat, 01 Aug 2009 12:09:26 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix I2C-drivers which missed setting clientdata to NULL before freeing the
structure it points to. Also fix drivers which do this _after_ the structure
was freed already.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---

Found using coccinelle, then reviewed. Full patchset is available via
kernel-janitors, linux-i2c, and LKML.
---
 drivers/input/keyboard/lm8323.c |    2 ++
 drivers/input/keyboard/qt2160.c |    2 +-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/input/keyboard/lm8323.c b/drivers/input/keyboard/lm8323.c
index 574eda2..2b8bf05 100644
--- a/drivers/input/keyboard/lm8323.c
+++ b/drivers/input/keyboard/lm8323.c
@@ -768,6 +768,7 @@ fail2:
 			led_classdev_unregister(&lm->pwm[i].cdev);
 fail1:
 	input_free_device(idev);
+	i2c_set_clientdata(client, NULL);
 	kfree(lm);
 	return err;
 }
@@ -789,6 +790,7 @@ static int __devexit lm8323_remove(struct i2c_client *client)
 		if (lm->pwm[i].enabled)
 			led_classdev_unregister(&lm->pwm[i].cdev);
 
+	i2c_set_clientdata(client, NULL);
 	kfree(lm);
 
 	return 0;
diff --git a/drivers/input/keyboard/qt2160.c b/drivers/input/keyboard/qt2160.c
index 31f3008..43db5e9 100644
--- a/drivers/input/keyboard/qt2160.c
+++ b/drivers/input/keyboard/qt2160.c
@@ -356,9 +356,9 @@ static int __devexit qt2160_remove(struct i2c_client *client)
 	cancel_delayed_work_sync(&qt2160->dwork);
 
 	input_unregister_device(qt2160->input);
+	i2c_set_clientdata(client, NULL);
 	kfree(qt2160);
 
-	i2c_set_clientdata(client, NULL);
 	return 0;
 }
 
-- 
1.7.0

