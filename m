Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760184Ab2FGIcW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 04:32:22 -0400
Received: from www84.your-server.de ([213.133.104.84]:40755 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755478Ab2FGIbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 04:31:51 -0400
From: stefani@seibold.net
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, oneukum@suse.de
Cc: linux-usb@vger.kernel.org, Stefani Seibold <stefani@seibold.net>
Subject: [PATCH 11/13] fix kref usage in skel_open
Date: Thu,  7 Jun 2012 10:20:41 +0200
Message-Id: <1339057243-10029-12-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1339057243-10029-1-git-send-email-stefani@seibold.net>
References: <1339057243-10029-1-git-send-email-stefani@seibold.net>
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefani Seibold <stefani@seibold.net>

Increment the kref at last, so we need no extra error path for decrement
them in a case of error..

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 drivers/usb/usb-skeleton.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/usb-skeleton.c b/drivers/usb/usb-skeleton.c
index 0a1ab0b..551fb51 100644
--- a/drivers/usb/usb-skeleton.c
+++ b/drivers/usb/usb-skeleton.c
@@ -92,18 +92,19 @@ static int skel_open(struct inode *inode, struct file *file)
 	if (!dev)
 		return -ENODEV;
 
-	/* increment our usage count for the device */
-	kref_get(&dev->kref);
-
 	/*
 	 * must be not locked since a disconnect waits in usb_deregister_dev()
 	 * due the already locked minor_rwsem in the usb_open() function
 	 */
 	retval = usb_autopm_get_interface(interface);
+	if (!retval)
+		return retval;
+
+	/* increment our usage count for the device */
+	kref_get(&dev->kref);
 
 	/* save our object in the file's private structure */
-	if (!retval)
-		file->private_data = dev;
+	file->private_data = dev;
 
 	return retval;
 }
-- 
1.7.8.6

