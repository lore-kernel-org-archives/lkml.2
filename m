Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036Ab0CUTJb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 15:09:31 -0400
Received: from mx01.qsc.de ([213.148.129.14]:38799 "EHLO mx01.qsc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295Ab0CUTJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 15:09:29 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Mar 2010 15:09:28 EDT
Date: Sun, 21 Mar 2010 20:02:45 +0100
From: Andreas Bombe <aeb@debian.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       devel@driverdev.osuosl.org, Antoine Jacquet <royale@zerezo.com>,
       linux-usb@vger.kernel.org
Subject: [PATCH] V4L2: Replace loops for finding max buffers in
 VIDIOC_REQBUFS callbacks
Message-ID: <20100321190243.GA4533@amos.infernal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to obvious copy and paste coding a number of video capture drivers
which implement a limit on the buffer memory decremented the user
supplied buffer count in a while loop until it reaches an acceptable
value.

This is a silly thing to do when the maximum value can be directly
computed.

Signed-off-by: Andreas Bombe <aeb@debian.org>
---

I tested the looping variants (represented by vivi.c) with large numbers
of requested buffers.  There was no easily measurable delay on my
desktop machine, but still.  At least the buffer count isn't 64 bit on
any architecture.

I think I got them all.  These are the files which I grepped as
candidates (correct = no loop, unlimited = no limit on buffer count,
fixed = in this patch), relative to drivers/media/video:

../common/saa7146_video.c: correct
au0828/au0828-video.c:     unlimited
bt8xx/bttv-driver.c:       fixed
cx231xx/cx231xx-video.c:   unlimited
cx23885/cx23885-video.c:   fixed
cx88/cx88-video.c:         fixed
davinci/vpfe_capture.c:    unlimited
davinci/vpif_capture.c:    unlimited
davinci/vpif_display.c:    unlimited
em28xx/em28xx-video.c:     unlimited
mx1_camera.c:              fixed
mx3_camera.c:              correct
omap24xxcam.c:             fixed
pxa_camera.c:              fixed
s2255drv.c:                fixed
saa7134/saa7134-core.c:    correct
sh_mobile_ceu_camera.c:    fixed
tlg2300/pd-video.c:        unlimited
vivi.c:                    fixed
zr364xx.c:                 fixed
../../staging/cx25821/cx25821-video.c: fixed

 drivers/media/video/bt8xx/bttv-driver.c     |    4 ++--
 drivers/media/video/cx23885/cx23885-video.c |    4 ++--
 drivers/media/video/cx88/cx88-video.c       |    4 ++--
 drivers/media/video/mx1_camera.c            |    4 ++--
 drivers/media/video/omap24xxcam.c           |    4 ++--
 drivers/media/video/pxa_camera.c            |    4 ++--
 drivers/media/video/s2255drv.c              |    4 ++--
 drivers/media/video/sh_mobile_ceu_camera.c  |    4 ++--
 drivers/media/video/vivi.c                  |    4 ++--
 drivers/media/video/zr364xx.c               |    4 ++--
 drivers/staging/cx25821/cx25821-video.c     |    4 ++--
 11 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
index cb46e8f..79af895 100644
--- a/drivers/media/video/bt8xx/bttv-driver.c
+++ b/drivers/media/video/bt8xx/bttv-driver.c
@@ -1805,8 +1805,8 @@ buffer_setup(struct videobuf_queue *q, unsigned int *count, unsigned int *size)
 	*size = fh->fmt->depth*fh->width*fh->height >> 3;
 	if (0 == *count)
 		*count = gbuffers;
-	while (*size * *count > gbuffers * gbufsize)
-		(*count)--;
+	if (*size * *count > gbuffers * gbufsize)
+		*count = (gbuffers * gbufsize) / *size;
 	return 0;
 }
 
diff --git a/drivers/media/video/cx23885/cx23885-video.c b/drivers/media/video/cx23885/cx23885-video.c
index 2d3ac8b..543b854 100644
--- a/drivers/media/video/cx23885/cx23885-video.c
+++ b/drivers/media/video/cx23885/cx23885-video.c
@@ -514,8 +514,8 @@ static int buffer_setup(struct videobuf_queue *q, unsigned int *count,
 	*size = fh->fmt->depth*fh->width*fh->height >> 3;
 	if (0 == *count)
 		*count = 32;
-	while (*size * *count > vid_limit * 1024 * 1024)
-		(*count)--;
+	if (*size * *count > vid_limit * 1024 * 1024)
+		*count = (vid_limit * 1024 * 1024) / *size;
 	return 0;
 }
 
diff --git a/drivers/media/video/cx88/cx88-video.c b/drivers/media/video/cx88/cx88-video.c
index 48c450f..9c0ca79 100644
--- a/drivers/media/video/cx88/cx88-video.c
+++ b/drivers/media/video/cx88/cx88-video.c
@@ -561,8 +561,8 @@ buffer_setup(struct videobuf_queue *q, unsigned int *count, unsigned int *size)
 	*size = fh->fmt->depth*fh->width*fh->height >> 3;
 	if (0 == *count)
 		*count = 32;
-	while (*size * *count > vid_limit * 1024 * 1024)
-		(*count)--;
+	if (*size * *count > vid_limit * 1024 * 1024)
+		*count = (vid_limit * 1024 * 1024) / *size;
 	return 0;
 }
 
diff --git a/drivers/media/video/mx1_camera.c b/drivers/media/video/mx1_camera.c
index c167cc3..d07af13 100644
--- a/drivers/media/video/mx1_camera.c
+++ b/drivers/media/video/mx1_camera.c
@@ -140,8 +140,8 @@ static int mx1_videobuf_setup(struct videobuf_queue *vq, unsigned int *count,
 	if (!*count)
 		*count = 32;
 
-	while (*size * *count > MAX_VIDEO_MEM * 1024 * 1024)
-		(*count)--;
+	if (*size * *count > MAX_VIDEO_MEM * 1024 * 1024)
+		*count = (MAX_VIDEO_MEM * 1024 * 1024) / *size;
 
 	dev_dbg(icd->dev.parent, "count=%d, size=%d\n", *count, *size);
 
diff --git a/drivers/media/video/omap24xxcam.c b/drivers/media/video/omap24xxcam.c
index 142c327..c910e86 100644
--- a/drivers/media/video/omap24xxcam.c
+++ b/drivers/media/video/omap24xxcam.c
@@ -451,8 +451,8 @@ static int omap24xxcam_vbq_setup(struct videobuf_queue *vbq, unsigned int *cnt,
 	*size = fh->pix.sizeimage;
 
 	/* accessing fh->cam->capture_mem is ok, it's constant */
-	while (*size * *cnt > fh->cam->capture_mem)
-		(*cnt)--;
+	if (*size * *cnt > fh->cam->capture_mem)
+		*cnt = fh->cam->capture_mem / *size;
 
 	return 0;
 }
diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index 322ac4e..520a35b 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -252,8 +252,8 @@ static int pxa_videobuf_setup(struct videobuf_queue *vq, unsigned int *count,
 
 	if (0 == *count)
 		*count = 32;
-	while (*size * *count > vid_limit * 1024 * 1024)
-		(*count)--;
+	if (*size * *count > vid_limit * 1024 * 1024)
+		*count = (vid_limit * 1024 * 1024) / *size;
 
 	return 0;
 }
diff --git a/drivers/media/video/s2255drv.c b/drivers/media/video/s2255drv.c
index fb742f1..b932d28 100644
--- a/drivers/media/video/s2255drv.c
+++ b/drivers/media/video/s2255drv.c
@@ -702,8 +702,8 @@ static int buffer_setup(struct videobuf_queue *vq, unsigned int *count,
 	if (0 == *count)
 		*count = S2255_DEF_BUFS;
 
-	while (*size * (*count) > vid_limit * 1024 * 1024)
-		(*count)--;
+	if (*size * *count > vid_limit * 1024 * 1024)
+		*count = (vid_limit * 1024 * 1024) / *size;
 
 	return 0;
 }
diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index fb88c63..d2eb339 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -212,8 +212,8 @@ static int sh_mobile_ceu_videobuf_setup(struct videobuf_queue *vq,
 		*count = 2;
 
 	if (pcdev->video_limit) {
-		while (PAGE_ALIGN(*size) * *count > pcdev->video_limit)
-			(*count)--;
+		if (PAGE_ALIGN(*size) * *count > pcdev->video_limit)
+			*count = pcdev->video_limit / PAGE_ALIGN(*size);
 	}
 
 	dev_dbg(icd->dev.parent, "count=%d, size=%d\n", *count, *size);
diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index cdbe703..5a736b8 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -749,8 +749,8 @@ buffer_setup(struct videobuf_queue *vq, unsigned int *count, unsigned int *size)
 	if (0 == *count)
 		*count = 32;
 
-	while (*size * *count > vid_limit * 1024 * 1024)
-		(*count)--;
+	if (*size * *count > vid_limit * 1024 * 1024)
+		*count = (vid_limit * 1024 * 1024) / *size;
 
 	dprintk(dev, 1, "%s, count=%d, size=%d\n", __func__,
 		*count, *size);
diff --git a/drivers/media/video/zr364xx.c b/drivers/media/video/zr364xx.c
index 3d4bac2..a82b5bd 100644
--- a/drivers/media/video/zr364xx.c
+++ b/drivers/media/video/zr364xx.c
@@ -376,8 +376,8 @@ static int buffer_setup(struct videobuf_queue *vq, unsigned int *count,
 	if (*count == 0)
 		*count = ZR364XX_DEF_BUFS;
 
-	while (*size * (*count) > ZR364XX_DEF_BUFS * 1024 * 1024)
-		(*count)--;
+	if (*size * *count > ZR364XX_DEF_BUFS * 1024 * 1024)
+		*count = (ZR364XX_DEF_BUFS * 1024 * 1024) / *size;
 
 	return 0;
 }
diff --git a/drivers/staging/cx25821/cx25821-video.c b/drivers/staging/cx25821/cx25821-video.c
index 8cd3986..33d75ab 100644
--- a/drivers/staging/cx25821/cx25821-video.c
+++ b/drivers/staging/cx25821/cx25821-video.c
@@ -516,8 +516,8 @@ int buffer_setup(struct videobuf_queue *q, unsigned int *count,
 	if (0 == *count)
 		*count = 32;
 
-	while (*size * *count > vid_limit * 1024 * 1024)
-		(*count)--;
+	if (*size * *count > vid_limit * 1024 * 1024)
+		*count = (vid_limit * 1024 * 1024) / *size;
 
 	return 0;
 }
-- 
1.7.0.2

