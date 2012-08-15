Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867Ab2HOTcA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:32:00 -0400
Received: from smtp.ispras.ru ([83.149.198.202]:54939 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752663Ab2HOTb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:31:59 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: [PATCH] HID: hidraw: improve error handling in hidraw_init()
Date: Wed, 15 Aug 2012 23:31:45 +0400
Message-Id: <1345059105-26827-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several improvements in error handling:
- do not report success if alloc_chrdev_region() failed
- check for error code of cdev_add()
- use unregister_chrdev_region() instead of unregister_chrdev()
  if class_create() failed

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/hid/hidraw.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
index 36fa77b..15e6660 100644
--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -549,21 +549,28 @@ int __init hidraw_init(void)
 
 	if (result < 0) {
 		pr_warn("can't get major number\n");
-		result = 0;
 		goto out;
 	}
 
 	hidraw_class = class_create(THIS_MODULE, "hidraw");
 	if (IS_ERR(hidraw_class)) {
 		result = PTR_ERR(hidraw_class);
-		unregister_chrdev(hidraw_major, "hidraw");
-		goto out;
+		goto error_cdev;
 	}
 
         cdev_init(&hidraw_cdev, &hidraw_ops);
-        cdev_add(&hidraw_cdev, dev_id, HIDRAW_MAX_DEVICES);
+	result = cdev_add(&hidraw_cdev, dev_id, HIDRAW_MAX_DEVICES);
+	if (result < 0)
+		goto error_class;
+
 out:
 	return result;
+
+error_class:
+	class_destroy(hidraw_class);
+error_cdev:
+	unregister_chrdev_region(dev_id, HIDRAW_MAX_DEVICES);
+	goto out;
 }
 
 void hidraw_exit(void)
-- 
1.7.9.5

