Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267Ab2FFQ2i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 12:28:38 -0400
Received: from www84.your-server.de ([213.133.104.84]:36696 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757175Ab2FFQ1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 12:27:23 -0400
From: stefani@seibold.net
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, oneukum@suse.de
Cc: alan@lxorguk.ukuu.org.uk, linux-usb@vger.kernel.org,
        Stefani Seibold <stefani@seibold.net>
Subject: [PATCH 05/11] remove unneeded forward declaration
Date: Wed,  6 Jun 2012 18:27:06 +0200
Message-Id: <1339000032-10313-6-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1339000032-10313-1-git-send-email-stefani@seibold.net>
References: <1339000032-10313-1-git-send-email-stefani@seibold.net>
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefani Seibold <stefani@seibold.net>

place the skel_draw_down() function at the rigth place to remove
the forward declaration.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 drivers/usb/usb-skeleton.c |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/usb-skeleton.c b/drivers/usb/usb-skeleton.c
index f7fe32f..e8d337a 100644
--- a/drivers/usb/usb-skeleton.c
+++ b/drivers/usb/usb-skeleton.c
@@ -69,7 +69,6 @@ struct usb_skel {
 #define to_skel_dev(d) container_of(d, struct usb_skel, kref)
 
 static struct usb_driver skel_driver;
-static void skel_draw_down(struct usb_skel *dev);
 
 static void skel_delete(struct kref *kref)
 {
@@ -139,6 +138,16 @@ static int skel_release(struct inode *inode, struct file *file)
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
@@ -601,16 +610,6 @@ static void skel_disconnect(struct usb_interface *interface)
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

