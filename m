Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771Ab2IAVhv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 17:37:51 -0400
Received: from mail.ispras.ru ([83.149.199.43]:46232 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754191Ab2IAVhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 17:37:50 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: [PATCH] staging: bcm: fix error handling in bcm_init()
Date: Sun,  2 Sep 2012 01:37:36 +0400
Message-Id: <1346535456-28941-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bcm_init() does not have proper error handling of usb_register().
The patch implements one.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/staging/bcm/InterfaceInit.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/bcm/InterfaceInit.c b/drivers/staging/bcm/InterfaceInit.c
index 8f85de6..0049890 100644
--- a/drivers/staging/bcm/InterfaceInit.c
+++ b/drivers/staging/bcm/InterfaceInit.c
@@ -669,6 +669,8 @@ struct class *bcm_class;
 
 static __init int bcm_init(void)
 {
+	int retval;
+
 	printk(KERN_INFO "%s: %s, %s\n", DRV_NAME, DRV_DESCRIPTION, DRV_VERSION);
 	printk(KERN_INFO "%s\n", DRV_COPYRIGHT);
 
@@ -678,7 +680,15 @@ static __init int bcm_init(void)
 		return PTR_ERR(bcm_class);
 	}
 
-	return usb_register(&usbbcm_driver);
+	retval = usb_register(&usbbcm_driver);
+	if (retval < 0) {
+		printk(KERN_ERR DRV_NAME ": could not register usb driver\n");
+		goto out_class;
+	}
+	return 0;
+out_class:
+	class_destroy(bcm_class);
+	return retval;
 }
 
 static __exit void bcm_exit(void)
-- 
1.7.9.5

