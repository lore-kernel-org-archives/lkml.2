Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050Ab2LUVob (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 16:44:31 -0500
Received: from mail.ispras.ru ([83.149.199.43]:39088 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024Ab2LUVo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 16:44:28 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH] mei: fix mismatch in mutex unlock-lock in mei_amthif_read()
Date: Sat, 22 Dec 2012 01:44:16 +0400
Message-Id: <1356126256-21389-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Users of mei_amthif_read() expect it leaves dev->device_lock held,
while there is a path where mei_amthif_read() unlocks device_lock
and returns -ERESTARTSYS.

The patch move code locking device_lock back before the return.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/misc/mei/amthif.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/mei/amthif.c b/drivers/misc/mei/amthif.c
index 18794ae..e40ffd9 100644
--- a/drivers/misc/mei/amthif.c
+++ b/drivers/misc/mei/amthif.c
@@ -187,13 +187,13 @@ int mei_amthif_read(struct mei_device *dev, struct file *file,
 		wait_ret = wait_event_interruptible(dev->iamthif_cl.wait,
 			(cb = mei_amthif_find_read_list_entry(dev, file)));
 
+		/* Locking again the Mutex */
+		mutex_lock(&dev->device_lock);
+
 		if (wait_ret)
 			return -ERESTARTSYS;
 
 		dev_dbg(&dev->pdev->dev, "woke up from sleep\n");
-
-		/* Locking again the Mutex */
-		mutex_lock(&dev->device_lock);
 	}
 
 
-- 
1.7.9.5

