Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553Ab2FQQSI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 12:18:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55844 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757476Ab2FQQSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 12:18:06 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Evgeniy Polyakov <zbr@ioremap.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH] drivers/w1: free the w1_master at w1_free_dev and return a correct return value
Date: Sun, 17 Jun 2012 21:47:59 +0530
Message-Id: <1339949879-26085-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the w1_master pointer is allced at the w1_alloc_master and is not freed when called with
w1_remove_master.

when w1_alloc_dev fails the return should be -ENODEV as it does
device_register, and that is the last case where that function
will fail.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/w1/w1_int.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/w1/w1_int.c b/drivers/w1/w1_int.c
index 6828835..a3cf27d 100644
--- a/drivers/w1/w1_int.c
+++ b/drivers/w1/w1_int.c
@@ -100,6 +100,7 @@ static struct w1_master * w1_alloc_dev(u32 id, int slave_count, int slave_ttl,
 static void w1_free_dev(struct w1_master *dev)
 {
 	device_unregister(&dev->dev);
+	kfree(dev);
 }
 
 int w1_add_master_device(struct w1_bus_master *master)
@@ -148,7 +149,7 @@ int w1_add_master_device(struct w1_bus_master *master)
 		&w1_master_driver, &w1_master_device);
 	if (!dev) {
 		mutex_unlock(&w1_mlock);
-		return -ENOMEM;
+		return -ENODEV;
 	}
 
 	retval =  w1_create_master_attributes(dev);
-- 
1.7.9.5

