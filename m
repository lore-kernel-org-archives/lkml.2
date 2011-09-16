Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab1IPGTW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 02:19:22 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36090 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411Ab1IPGTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 02:19:18 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Joe Perches <joe@perches.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH 41/44] Staging: cx25821: Replace :? by if-else in cx25821-video.c
Date: Fri, 16 Sep 2011 14:15:14 +0800
Message-Id: <1316153717-7272-42-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
References: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace :? operator by equivalent if-else statement where in improves
readability. Don't add else branch if it is not needed.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-video.c |   32 +++++++++++++++++++-----------
 1 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video.c b/drivers/staging/cx25821/cx25821-video.c
index c54d309..084fc08 100644
--- a/drivers/staging/cx25821/cx25821-video.c
+++ b/drivers/staging/cx25821/cx25821-video.c
@@ -599,8 +599,8 @@ int cx25821_buffer_prepare(struct videobuf_queue *q, struct videobuf_buffer *vb,
 	if (init_buffer) {
 
 		channel_opened = dev->channel_opened;
-		channel_opened = (channel_opened < 0
-				  || channel_opened > 7) ? 7 : channel_opened;
+		if (channel_opened < 0 || channel_opened > 7)
+			channel_opened = 7;
 
 		if (dev->channels[channel_opened].pixel_formats ==
 				PIXEL_FRMT_411)
@@ -840,8 +840,10 @@ static int video_open(struct file *file)
 		fh->height = 480;
 
 	dev->channel_opened = fh->channel_id;
-	pix_format = (dev->channels[ch_id].pixel_formats == PIXEL_FRMT_411) ?
-			V4L2_PIX_FMT_Y41P : V4L2_PIX_FMT_YUYV;
+	if (dev->channels[ch_id].pixel_formats == PIXEL_FRMT_411)
+		pix_format = V4L2_PIX_FMT_Y41P;
+	else
+		pix_format = V4L2_PIX_FMT_YUYV;
 	fh->fmt = cx25821_format_by_fourcc(pix_format);
 
 	v4l2_prio_open(&dev->channels[ch_id].prio, &fh->prio);
@@ -1124,8 +1126,10 @@ int cx25821_vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 	maxh = 576;
 
 	if (V4L2_FIELD_ANY == field) {
-		field = (f->fmt.pix.height > maxh / 2)
-		    ? V4L2_FIELD_INTERLACED : V4L2_FIELD_TOP;
+		if (f->fmt.pix.height > maxh / 2)
+			field = V4L2_FIELD_INTERLACED;
+		else
+			field = V4L2_FIELD_TOP;
 	}
 
 	switch (field) {
@@ -1847,8 +1851,10 @@ static long video_ioctl_set(struct file *file, unsigned int cmd,
 
 	switch (command) {
 	case SET_VIDEO_STD:
-		dev->tvnorm = !strcmp(data_from_user->vid_stdname, "PAL") ?
-					V4L2_STD_PAL_BG : V4L2_STD_NTSC_M;
+		if (!strcmp(data_from_user->vid_stdname, "PAL"))
+			dev->tvnorm = V4L2_STD_PAL_BG;
+		else
+			dev->tvnorm = V4L2_STD_NTSC_M;
 		medusa_set_videostandard(dev);
 		break;
 
@@ -1874,11 +1880,13 @@ static long video_ioctl_set(struct file *file, unsigned int cmd,
 
 		if (cif_enable) {
 			if (dev->tvnorm & V4L2_STD_PAL_BG
-			    || dev->tvnorm & V4L2_STD_PAL_DK)
+			    || dev->tvnorm & V4L2_STD_PAL_DK) {
 				width = 352;
-			else
-				width = (cif_width == 320 || cif_width == 352) ?
-							cif_width : 320;
+			} else {
+				width = cif_width;
+				if (cif_width != 320 && cif_width != 352)
+					width = 320;
+			}
 		}
 
 		if (!(selected_channel <= 7 && selected_channel >= 0)) {
-- 
1.7.0.4

