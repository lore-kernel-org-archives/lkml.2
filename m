Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022Ab0E0Mgx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 08:36:53 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:52104 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754720Ab0E0Mgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 08:36:50 -0400
Date: Thu, 27 May 2010 14:36:45 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 8/11] drivers/media: Eliminate a NULL pointer dereference
Message-ID: <Pine.LNX.4.64.1005271434030.5422@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

In each case, the print involves dereferencing a value that is NULL or is
near NULL.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
expression E,E1;
identifier f;
statement S1,S2,S3;
@@

if ((E == NULL && ...) || ...)
{
  ... when != if (...) S1 else S2
      when != E = E1
* E->f
  ... when any
  return ...;
}
else S3
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/media/dvb/firewire/firedtv-1394.c       |    2 +-
 drivers/media/video/hdpvr/hdpvr-video.c         |    2 +-
 drivers/media/video/usbvision/usbvision-video.c |    3 +--
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/usbvision/usbvision-video.c b/drivers/media/video/usbvision/usbvision-video.c
index 6248a63..c2690df 100644
--- a/drivers/media/video/usbvision/usbvision-video.c
+++ b/drivers/media/video/usbvision/usbvision-video.c
@@ -1671,8 +1671,7 @@ static void __devexit usbvision_disconnect(struct usb_interface *intf)
 	PDEBUG(DBG_PROBE, "");
 
 	if (usbvision == NULL) {
-		dev_err(&usbvision->dev->dev,
-			"%s: usb_get_intfdata() failed\n", __func__);
+		pr_err("%s: usb_get_intfdata() failed\n", __func__);
 		return;
 	}
 
diff --git a/drivers/media/video/hdpvr/hdpvr-video.c b/drivers/media/video/hdpvr/hdpvr-video.c
index 7cfccfd..c338f3f 100644
--- a/drivers/media/video/hdpvr/hdpvr-video.c
+++ b/drivers/media/video/hdpvr/hdpvr-video.c
@@ -366,7 +366,7 @@ static int hdpvr_open(struct file *file)
 
 	dev = (struct hdpvr_device *)video_get_drvdata(video_devdata(file));
 	if (!dev) {
-		v4l2_err(&dev->v4l2_dev, "open failing with with ENODEV\n");
+		pr_err("open failing with with ENODEV\n");
 		retval = -ENODEV;
 		goto err;
 	}
diff --git a/drivers/media/dvb/firewire/firedtv-1394.c b/drivers/media/dvb/firewire/firedtv-1394.c
index 26333b4..b34ca7a 100644
--- a/drivers/media/dvb/firewire/firedtv-1394.c
+++ b/drivers/media/dvb/firewire/firedtv-1394.c
@@ -58,7 +58,7 @@ static void rawiso_activity_cb(struct hpsb_iso *iso)
 	num = hpsb_iso_n_ready(iso);
 
 	if (!fdtv) {
-		dev_err(fdtv->device, "received at unknown iso channel\n");
+		pr_err("received at unknown iso channel\n");
 		goto out;
 	}
 
