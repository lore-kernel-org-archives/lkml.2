Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab2IBTaj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 15:30:39 -0400
Received: from mail.ispras.ru ([83.149.199.43]:56882 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754417Ab2IBTai (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 15:30:38 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Kevin McKinney <klmckinney1@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: [PATCH v2] staging: bcm: fix error handling in bcm_init()
Date: Sun,  2 Sep 2012 23:30:13 +0400
Message-Id: <1346614214-14340-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20120902165130.GA3952@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bcm_init() does not have proper error handling of usb_register().
The patch implements one.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/staging/bcm/InterfaceInit.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/bcm/InterfaceInit.c b/drivers/staging/bcm/InterfaceInit.c
index 8f85de6..57452ef 100644
--- a/drivers/staging/bcm/InterfaceInit.c
+++ b/drivers/staging/bcm/InterfaceInit.c
@@ -669,6 +669,8 @@ struct class *bcm_class;
 
 static __init int bcm_init(void)
 {
+	int retval;
+
 	printk(KERN_INFO "%s: %s, %s\n", DRV_NAME, DRV_DESCRIPTION, DRV_VERSION);
 	printk(KERN_INFO "%s\n", DRV_COPYRIGHT);
 
@@ -678,7 +680,13 @@ static __init int bcm_init(void)
 		return PTR_ERR(bcm_class);
 	}
 
-	return usb_register(&usbbcm_driver);
+	retval = usb_register(&usbbcm_driver);
+	if (retval < 0) {
+		printk(KERN_ERR DRV_NAME ": could not register usb driver\n");
+		class_destroy(bcm_class);
+		return retval;
+	}
+	return 0;
 }
 
 static __exit void bcm_exit(void)
-- 
1.7.9.5

