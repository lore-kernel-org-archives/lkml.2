Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab1GRQrF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 12:47:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5652 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752899Ab1GRQrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 12:47:03 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>, Andy Walls <awalls@md.metrocast.net>,
        Chris W <lkml@psychogeeks.com>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [media] imon: don't submit urb before rc_dev set up
Date: Mon, 18 Jul 2011 12:46:49 -0400
Message-Id: <1311007609-28210-1-git-send-email-jarod@redhat.com>
In-Reply-To: <A91CBD95-B2AF-4F43-8BEC-6C8007ABB33C@wilsonet.com>
References: <A91CBD95-B2AF-4F43-8BEC-6C8007ABB33C@wilsonet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The interface 0 urb callback was being wired up before the rc_dev device
was allocated, meaning the callback could be called with a null rc_dev,
leading to an oops. This likely only ever happens on the older 0xffdc
SoundGraph devices, which continually trigger interrupts even when they
have no valid keydata, and the window in which it could happen is small,
but its actually happening regularly for at least one user, and its an
obvious fix. Compile and sanity-tested with one of my own imon devices.

CC: Andy Walls <awalls@md.metrocast.net>
CC: Chris W <lkml@psychogeeks.com>
CC: Randy Dunlap <rdunlap@xenotime.net>
CC: linux-kernel@vger.kernel.org
Reported-by: Chris W <lkml@psychogeeks.com>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/imon.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index caa3e3a..26238f5 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -2132,6 +2132,18 @@ static struct imon_context *imon_init_intf0(struct usb_interface *intf)
 		goto find_endpoint_failed;
 	}
 
+	ictx->idev = imon_init_idev(ictx);
+	if (!ictx->idev) {
+		dev_err(dev, "%s: input device setup failed\n", __func__);
+		goto idev_setup_failed;
+	}
+
+	ictx->rdev = imon_init_rdev(ictx);
+	if (!ictx->rdev) {
+		dev_err(dev, "%s: rc device setup failed\n", __func__);
+		goto rdev_setup_failed;
+	}
+
 	usb_fill_int_urb(ictx->rx_urb_intf0, ictx->usbdev_intf0,
 		usb_rcvintpipe(ictx->usbdev_intf0,
 			ictx->rx_endpoint_intf0->bEndpointAddress),
@@ -2145,26 +2157,14 @@ static struct imon_context *imon_init_intf0(struct usb_interface *intf)
 		goto urb_submit_failed;
 	}
 
-	ictx->idev = imon_init_idev(ictx);
-	if (!ictx->idev) {
-		dev_err(dev, "%s: input device setup failed\n", __func__);
-		goto idev_setup_failed;
-	}
-
-	ictx->rdev = imon_init_rdev(ictx);
-	if (!ictx->rdev) {
-		dev_err(dev, "%s: rc device setup failed\n", __func__);
-		goto rdev_setup_failed;
-	}
-
 	mutex_unlock(&ictx->lock);
 	return ictx;
 
+urb_submit_failed:
+	rc_unregister_device(ictx->rdev);
 rdev_setup_failed:
 	input_unregister_device(ictx->idev);
 idev_setup_failed:
-	usb_kill_urb(ictx->rx_urb_intf0);
-urb_submit_failed:
 find_endpoint_failed:
 	mutex_unlock(&ictx->lock);
 	usb_free_urb(tx_urb);
-- 
1.7.1

