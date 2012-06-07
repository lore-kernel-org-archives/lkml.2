Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760108Ab2FGIVy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 04:21:54 -0400
Received: from www84.your-server.de ([213.133.104.84]:39311 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758649Ab2FGIU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 04:20:29 -0400
From: stefani@seibold.net
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, oneukum@suse.de
Cc: linux-usb@vger.kernel.org, Stefani Seibold <stefani@seibold.net>
Subject: [PATCH 09/13] remove unneeded lock in skel_open
Date: Thu,  7 Jun 2012 10:20:39 +0200
Message-Id: <1339057243-10029-10-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1339057243-10029-1-git-send-email-stefani@seibold.net>
References: <1339057243-10029-1-git-send-email-stefani@seibold.net>
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefani Seibold <stefani@seibold.net>

The io_mutex must not acquired since a disconnect waits in usb_deregister_dev()
due the already locked minor_rwsem in the usb_open() function

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 drivers/usb/usb-skeleton.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/usb-skeleton.c b/drivers/usb/usb-skeleton.c
index 61f4ac8..6482acb 100644
--- a/drivers/usb/usb-skeleton.c
+++ b/drivers/usb/usb-skeleton.c
@@ -95,11 +95,11 @@ static int skel_open(struct inode *inode, struct file *file)
 	/* increment our usage count for the device */
 	kref_get(&dev->kref);
 
-	/* lock the device to allow correctly handling errors
-	 * in resumption */
-	mutex_lock(&dev->io_mutex);
+	/*
+	 * must be not locked since disconnect waits in usb_deregister_dev()
+	 * due the already locked minor_rwsem in the usb_open() function
+	 */
 	retval = usb_autopm_get_interface(interface);
-	mutex_unlock(&dev->io_mutex);
 
 	/* save our object in the file's private structure */
 	if (!retval)
-- 
1.7.8.6

