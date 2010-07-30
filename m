Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758468Ab0G3LIp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 07:08:45 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54890 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758208Ab0G3LIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 07:08:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=w9eWvN4bjc2aGWw+EYhTC62sWBhwLa9KYAO52E0iOG4IK0fkdkR1Ed6oS5qrzS1H/Z
         Bz9TCJZmnJimTkEod7I3bx0muNdFs0k7ip/rsnl2E1y6GmXmrgIpDgIiziOtha56e0Jr
         jSeQh7rdE/G5wu9oT5d0qr1syaslnaNUuXO7M=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>,
        Peter Huewe <peterhuewe@gmx.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Julia Lawall <julia@diku.dk>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/9] staging: panel: fix error path
Date: Fri, 30 Jul 2010 15:08:20 +0400
Message-Id: <1280488100-20819-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

panel_attach() poorly handles errors. On error unregister everything we
have registered.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/panel/panel.c |   22 +++++++++++++++++++---
 1 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index 8bd7182..f58da32 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -2127,12 +2127,18 @@ static void panel_attach(struct parport *port)
 				       NULL,
 				       /*PARPORT_DEV_EXCL */
 				       0, (void *)&pprt);
+	if (pprt == NULL) {
+		pr_err("panel_attach(): port->number=%d parport=%d, "
+		       "parport_register_device() failed\n",
+		       port->number, parport);
+		return;
+	}
 
 	if (parport_claim(pprt)) {
 		printk(KERN_ERR
 		       "Panel: could not claim access to parport%d. "
 		       "Aborting.\n", parport);
-		return;
+		goto err_unreg_device;
 	}
 
 	/* must init LCD first, just in case an IRQ from the keypad is
@@ -2140,13 +2146,23 @@ static void panel_attach(struct parport *port)
 	 */
 	if (lcd_enabled) {
 		lcd_init();
-		misc_register(&lcd_dev);
+		if (misc_register(&lcd_dev))
+			goto err_unreg_device;
 	}
 
 	if (keypad_enabled) {
 		keypad_init();
-		misc_register(&keypad_dev);
+		if (misc_register(&keypad_dev))
+			goto err_lcd_unreg;
 	}
+	return;
+
+err_lcd_unreg:
+	if (lcd_enabled)
+		misc_deregister(&lcd_dev);
+err_unreg_device:
+	parport_unregister_device(pprt);
+	pprt = NULL;
 }
 
 static void panel_detach(struct parport *port)
-- 
1.7.0.4

