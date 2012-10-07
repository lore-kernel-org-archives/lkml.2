Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958Ab2JGXg5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:36:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38396 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754065Ab2JGXWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:22:37 -0400
Message-Id: <20121007225844.389031750@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:59:44 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [ 070/108] HID: hidraw: improve error handling in hidraw_init()
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Khoroshilov <khoroshilov@ispras.ru>

commit bcb4a75bde3821cecb17a71d287abfd6ef9bd68d upstream.

Several improvements in error handling:
- do not report success if alloc_chrdev_region() failed
- check for error code of cdev_add()
- use unregister_chrdev_region() instead of unregister_chrdev()
  if class_create() failed

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hid/hidraw.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
index 3b6f7bf..7c47fc3 100644
--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -559,21 +559,28 @@ int __init hidraw_init(void)
 
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


