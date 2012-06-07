Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760208Ab2FGIWK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 04:22:10 -0400
Received: from www84.your-server.de ([213.133.104.84]:39296 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758274Ab2FGIU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 04:20:28 -0400
From: stefani@seibold.net
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, oneukum@suse.de
Cc: linux-usb@vger.kernel.org, Stefani Seibold <stefani@seibold.net>
Subject: [PATCH 04/13] remove unneeded forward declaration
Date: Thu,  7 Jun 2012 10:20:34 +0200
Message-Id: <1339057243-10029-5-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1339057243-10029-1-git-send-email-stefani@seibold.net>
References: <1339057243-10029-1-git-send-email-stefani@seibold.net>
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefani Seibold <stefani@seibold.net>

Place the skel_draw_down() function at the rigth place to remove
the forward declaration.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 drivers/usb/usb-skeleton.c |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/usb-skeleton.c b/drivers/usb/usb-skeleton.c
index 92cdfca..7fc9621 100644
--- a/drivers/usb/usb-skeleton.c
+++ b/drivers/usb/usb-skeleton.c
@@ -67,7 +67,6 @@ struct usb_skel {
 #define to_skel_dev(d) container_of(d, struct usb_skel, kref)
 
 static struct usb_driver skel_driver;
-static void skel_draw_down(struct usb_skel *dev);
 
 static void skel_delete(struct kref *kref)
 {
@@ -130,6 +129,16 @@ static int skel_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
+static void skel_draw_down(struct usb_skel *dev)
+{
+	int time;
+
+	time = usb_wait_anchor_empty_timeout(&dev->submitted, 1000);
+	if (!time)
+		usb_kill_anchored_urbs(&dev->submitted);
+	usb_kill_urb(dev->bulk_in_urb);
+}
+
 static int skel_flush(struct file *file, fl_owner_t id)
 {
 	struct usb_skel *dev = file->private_data;
@@ -586,16 +595,6 @@ static void skel_disconnect(struct usb_interface *interface)
 	dev_info(&interface->dev, "USB Skeleton #%d now disconnected", minor);
 }
 
-static void skel_draw_down(struct usb_skel *dev)
-{
-	int time;
-
-	time = usb_wait_anchor_empty_timeout(&dev->submitted, 1000);
-	if (!time)
-		usb_kill_anchored_urbs(&dev->submitted);
-	usb_kill_urb(dev->bulk_in_urb);
-}
-
 static int skel_suspend(struct usb_interface *intf, pm_message_t message)
 {
 	struct usb_skel *dev = usb_get_intfdata(intf);
-- 
1.7.8.6

