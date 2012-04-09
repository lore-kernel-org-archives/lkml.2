Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891Ab2DIVQF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 17:16:05 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:37863 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab2DIVQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 17:16:03 -0400
From: Xi Wang <xi.wang@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Xi Wang <xi.wang@gmail.com>
Subject: [PATCH] [media] zoran: fix integer overflow in setup_window()
Date: Mon,  9 Apr 2012 17:15:45 -0400
Message-Id: <1334006145-31859-1-git-send-email-xi.wang@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

`clipcount' is from userspace and thus needs validation.  Otherwise,
a large `clipcount' could overflow the vmalloc() size, leading to
out-of-bounds access.

| setup_window()
| zoran_s_fmt_vid_overlay()
| __video_do_ioctl()
| video_ioctl2()

Use 2048 as the maximum `clipcount'.  Also change the corresponding
parameter type to `unsigned int'.

Signed-off-by: Xi Wang <xi.wang@gmail.com>
---
The upper bound `2048' is from get_v4l2_window32() in
drivers/media/video/v4l2-ioctl.c.

bt8xx and saa7134 also use the bound for `clipcount'.
---
 drivers/media/video/zoran/zoran_driver.c |   20 +++++++++++++++++---
 1 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/zoran/zoran_driver.c b/drivers/media/video/zoran/zoran_driver.c
index 4c09ab7..c573109 100644
--- a/drivers/media/video/zoran/zoran_driver.c
+++ b/drivers/media/video/zoran/zoran_driver.c
@@ -1131,8 +1131,14 @@ static int setup_fbuffer(struct zoran_fh *fh,
 }
 
 
-static int setup_window(struct zoran_fh *fh, int x, int y, int width, int height,
-	struct v4l2_clip __user *clips, int clipcount, void __user *bitmap)
+static int setup_window(struct zoran_fh *fh,
+			int x,
+			int y,
+			int width,
+			int height,
+			struct v4l2_clip __user *clips,
+			unsigned int clipcount,
+			void __user *bitmap)
 {
 	struct zoran *zr = fh->zr;
 	struct v4l2_clip *vcp = NULL;
@@ -1155,6 +1161,14 @@ static int setup_window(struct zoran_fh *fh, int x, int y, int width, int height
 		return -EINVAL;
 	}
 
+	if (clipcount > 2048) {
+		dprintk(1,
+			KERN_ERR
+			"%s: %s - invalid clipcount\n",
+			 ZR_DEVNAME(zr), __func__);
+		return -EINVAL;
+	}
+
 	/*
 	 * The video front end needs 4-byte alinged line sizes, we correct that
 	 * silently here if necessary
@@ -1218,7 +1232,7 @@ static int setup_window(struct zoran_fh *fh, int x, int y, int width, int height
 				   (width * height + 7) / 8)) {
 			return -EFAULT;
 		}
-	} else if (clipcount > 0) {
+	} else if (clipcount) {
 		/* write our own bitmap from the clips */
 		vcp = vmalloc(sizeof(struct v4l2_clip) * (clipcount + 4));
 		if (vcp == NULL) {
-- 
1.7.5.4

