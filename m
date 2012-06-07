Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760168Ab2FGIV7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 04:21:59 -0400
Received: from www84.your-server.de ([213.133.104.84]:39304 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758342Ab2FGIU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 04:20:29 -0400
From: stefani@seibold.net
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, oneukum@suse.de
Cc: linux-usb@vger.kernel.org, Stefani Seibold <stefani@seibold.net>
Subject: [PATCH 07/13] fix flush function
Date: Thu,  7 Jun 2012 10:20:37 +0200
Message-Id: <1339057243-10029-8-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1339057243-10029-1-git-send-email-stefani@seibold.net>
References: <1339057243-10029-1-git-send-email-stefani@seibold.net>
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefani Seibold <stefani@seibold.net>

- Check for disconnect
- Fix nameing of the return value

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 drivers/usb/usb-skeleton.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/usb-skeleton.c b/drivers/usb/usb-skeleton.c
index e4cb88a..dc95129 100644
--- a/drivers/usb/usb-skeleton.c
+++ b/drivers/usb/usb-skeleton.c
@@ -136,21 +136,25 @@ static void skel_draw_down(struct usb_skel *dev)
 static int skel_flush(struct file *file, fl_owner_t id)
 {
 	struct usb_skel *dev = file->private_data;
-	int res;
+	int retval;
 
 	/* wait for io to stop */
 	mutex_lock(&dev->io_mutex);
+	if (!dev->interface) {		/* disconnect() was called */
+		retval = -ENODEV;
+		goto exit;
+	}
 	skel_draw_down(dev);
 
 	/* read out errors, leave subsequent opens a clean slate */
 	spin_lock_irq(&dev->err_lock);
-	res = dev->errors ? (dev->errors == -EPIPE ? -EPIPE : -EIO) : 0;
+	retval = dev->errors ? (dev->errors == -EPIPE ? -EPIPE : -EIO) : 0;
 	dev->errors = 0;
 	spin_unlock_irq(&dev->err_lock);
-
+exit:
 	mutex_unlock(&dev->io_mutex);
 
-	return res;
+	return retval;
 }
 
 static void skel_read_bulk_callback(struct urb *urb)
-- 
1.7.8.6

