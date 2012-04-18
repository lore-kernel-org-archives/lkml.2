Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab2DRIcX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 04:32:23 -0400
Received: from mail.telros.ru ([83.136.244.21]:64330 "EHLO mail.telros.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116Ab2DRIcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 04:32:14 -0400
X-Greylist: delayed 2509 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Apr 2012 04:32:13 EDT
Message-ID: <1334735415.1693.9.camel@VPir>
Subject: [PATCH] Staging: go7007: detector features - add new tuning option
From: volokh <volokh@telros.ru>
To: mchehab@infradead.org
Cc: gregkh@linuxfoundation.org, my84@bk.ru, volokh@telros.ru,
        dhowells@redhat.com, justinmattock@gmail.com, pradheep.sh@gmail.com,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Wed, 18 Apr 2012 11:50:15 +0400
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From a600b33c0824bf1b5031f820f8afaefa9e51dc16 Mon Sep 17 00:00:00 2001
From: Volokh Konstantin <my84@bk.ru>
Date: Tue, 17 Apr 2012 21:39:15 +0400
Subject: [PATCH] Staging: go7007: detector features - add new tuning option
 for card(     V4L2_MPEG_VIDEO_ENCODING_H263    
 ,V4L2_CID_MPEG_VIDEO_B_FRAMES) - add
 framesizes&frameintervals control - tested&realize motion
 detector control(     GO7007IOC_REGION_NUMBER    
 ,GO7007IOC_PIXEL_THRESOLD     ,GO7007IOC_MOTION_THRESOLD   
  ,GO7007IOC_TRIGGER     ,GO7007IOC_REGION_CONTROL    
 ,GO7007IOC_CLIP_LEFT     ,GO7007IOC_CLIP_TOP    
 ,GO7007IOC_CLIP_WIDTH     ,GO7007IOC_CLIP_HEIGHT)

Tested with  Angelo PCI-MPG24(Adlink) with go7007&tw2804 onboard

With Utility script for conversation to 'c' style based on checkpatch.pl

Signed-off-by: Volokh Konstantin <my84@bk.ru>
---
 drivers/staging/media/go7007/go7007-priv.h |    3 +-
 drivers/staging/media/go7007/go7007-v4l2.c |  988 ++++++++++++++++++----------
 drivers/staging/media/go7007/go7007.h      |   95 +---
 drivers/staging/media/go7007/wis-tw2804.c  |  414 +++++++-----
 scripts/correctpatch.pl                    |  269 ++++++++
 5 files changed, 1175 insertions(+), 594 deletions(-)
 create mode 100755 scripts/correctpatch.pl

diff --git a/drivers/staging/media/go7007/go7007-priv.h b/drivers/staging/media/go7007/go7007-priv.h
index b58c394..4e47f29 100644
--- a/drivers/staging/media/go7007/go7007-priv.h
+++ b/drivers/staging/media/go7007/go7007-priv.h
@@ -215,7 +215,8 @@ struct go7007 {
 	} modet[4];
 	unsigned char modet_map[1624];
 	unsigned char active_map[216];
-
+	struct v4l2_rect fClipRegion;
+	unsigned char fCurrentRegion:2;
 	/* Video streaming */
 	struct go7007_buffer *active_buf;
 	enum go7007_parser_state state;
diff --git a/drivers/staging/media/go7007/go7007-v4l2.c b/drivers/staging/media/go7007/go7007-v4l2.c
index 3ef4cd8..88054f0 100644
--- a/drivers/staging/media/go7007/go7007-v4l2.c
+++ b/drivers/staging/media/go7007/go7007-v4l2.c
@@ -39,14 +39,6 @@
 #include "go7007-priv.h"
 #include "wis-i2c.h"
 
-/* Temporary defines until accepted in v4l-dvb */
-#ifndef V4L2_MPEG_STREAM_TYPE_MPEG_ELEM
-#define	V4L2_MPEG_STREAM_TYPE_MPEG_ELEM   6 /* MPEG elementary stream */
-#endif
-#ifndef V4L2_MPEG_VIDEO_ENCODING_MPEG_4
-#define	V4L2_MPEG_VIDEO_ENCODING_MPEG_4   3
-#endif
-
 #define call_all(dev, o, f, args...) \
 	v4l2_device_call_until_err(dev, 0, o, f, ##args)
 
@@ -136,6 +128,7 @@ static u32 get_frame_type_flag(struct go7007_buffer *gobuf, int format)
 	switch (format) {
 	case GO7007_FORMAT_MJPEG:
 		return V4L2_BUF_FLAG_KEYFRAME;
+	case GO7007_FORMAT_H263:
 	case GO7007_FORMAT_MPEG4:
 		switch ((f[gobuf->frame_offset + 4] >> 6) & 0x3) {
 		case 0:
@@ -159,6 +152,8 @@ static u32 get_frame_type_flag(struct go7007_buffer *gobuf, int format)
 		default:
 			return 0;
 		}
+	default:
+	  break;
 	}
 
 	return 0;
@@ -171,7 +166,7 @@ static int set_capture_size(struct go7007 *go, struct v4l2_format *fmt, int try)
 
 	if (fmt != NULL && fmt->fmt.pix.pixelformat != V4L2_PIX_FMT_MJPEG &&
 			fmt->fmt.pix.pixelformat != V4L2_PIX_FMT_MPEG &&
-			fmt->fmt.pix.pixelformat != V4L2_PIX_FMT_MPEG4)
+			fmt->fmt.pix.pixelformat != V4L2_PIX_FMT_H263)
 		return -EINVAL;
 
 	switch (go->standard) {
@@ -303,11 +298,10 @@ static int set_capture_size(struct go7007 *go, struct v4l2_format *fmt, int try)
 		go->gop_header_enable = 1;
 		go->dvd_mode = 0;
 		break;
-	/* Backwards compatibility only! */
-	case V4L2_PIX_FMT_MPEG4:
-		if (go->format == GO7007_FORMAT_MPEG4)
+	case V4L2_PIX_FMT_H263:
+		if (go->format == GO7007_FORMAT_H263)
 			break;
-		go->format = GO7007_FORMAT_MPEG4;
+		go->format = GO7007_FORMAT_H263;
 		go->pali = 0xf5;
 		go->aspect_ratio = GO7007_RATIO_1_1;
 		go->gop_size = go->sensor_framerate / 1000;
@@ -334,112 +328,388 @@ static int set_capture_size(struct go7007 *go, struct v4l2_format *fmt, int try)
 	return 0;
 }
 
-#if 0
-static int clip_to_modet_map(struct go7007 *go, int region,
-		struct v4l2_clip *clip_list)
+static int md_g_ctrl(struct v4l2_control *ctrl, struct go7007 *go)
 {
-	struct v4l2_clip clip, *clip_ptr;
-	int x, y, mbnum;
-
-	/* Check if coordinates are OK and if any macroblocks are already
-	 * used by other regions (besides 0) */
-	clip_ptr = clip_list;
-	while (clip_ptr) {
-		if (copy_from_user(&clip, clip_ptr, sizeof(clip)))
-			return -EFAULT;
-		if (clip.c.left < 0 || (clip.c.left & 0xF) ||
-				clip.c.width <= 0 || (clip.c.width & 0xF))
-			return -EINVAL;
-		if (clip.c.left + clip.c.width > go->width)
-			return -EINVAL;
-		if (clip.c.top < 0 || (clip.c.top & 0xF) ||
-				clip.c.height <= 0 || (clip.c.height & 0xF))
-			return -EINVAL;
-		if (clip.c.top + clip.c.height > go->height)
-			return -EINVAL;
-		for (y = 0; y < clip.c.height; y += 16)
-			for (x = 0; x < clip.c.width; x += 16) {
-				mbnum = (go->width >> 4) *
-						((clip.c.top + y) >> 4) +
-					((clip.c.left + x) >> 4);
-				if (go->modet_map[mbnum] != 0 &&
-						go->modet_map[mbnum] != region)
-					return -EBUSY;
-			}
-		clip_ptr = clip.next;
+	switch (ctrl->id) {
+	case GO7007IOC_REGION_NUMBER:
+	ctrl->value = go->fCurrentRegion;
+	break;
+	case GO7007IOC_PIXEL_THRESOLD:
+	ctrl->value = (go->modet[go->fCurrentRegion].pixel_threshold<<1)+1;
+	break;
+	case GO7007IOC_MOTION_THRESOLD:
+	ctrl->value = (go->modet[go->fCurrentRegion].motion_threshold<<1)+1;
+	break;
+	case GO7007IOC_TRIGGER:
+	ctrl->value = (go->modet[go->fCurrentRegion].mb_threshold<<1)+1;
+	break;
+	case GO7007IOC_CLIP_LEFT:
+	ctrl->value = go->fClipRegion.left;
+	break;
+	case GO7007IOC_CLIP_TOP:
+	ctrl->value = go->fClipRegion.top;
+	break;
+	case GO7007IOC_CLIP_WIDTH:
+	ctrl->value = go->fClipRegion.width;
+	break;
+	case GO7007IOC_CLIP_HEIGHT:
+	ctrl->value = go->fClipRegion.height;
+	break;
+	case GO7007IOC_REGION_CONTROL:
+	default:
+	return -EINVAL;
 	}
+	return 0;
+}
 
-	/* Clear old region macroblocks */
-	for (mbnum = 0; mbnum < 1624; ++mbnum)
-		if (go->modet_map[mbnum] == region)
+static void ClearModetMap(struct go7007 *go, char Region)
+{
+  /* Clear old region macroblocks */
+	int mbnum;
+	for (mbnum = 0; mbnum < sizeof(go->modet_map); ++mbnum)
+		if (go->modet_map[mbnum] == Region)
 			go->modet_map[mbnum] = 0;
+}
 
-	/* Claim macroblocks in this list */
-	clip_ptr = clip_list;
-	while (clip_ptr) {
-		if (copy_from_user(&clip, clip_ptr, sizeof(clip)))
-			return -EFAULT;
-		for (y = 0; y < clip.c.height; y += 16)
-			for (x = 0; x < clip.c.width; x += 16) {
-				mbnum = (go->width >> 4) *
-						((clip.c.top + y) >> 4) +
-					((clip.c.left + x) >> 4);
-				go->modet_map[mbnum] = region;
-			}
-		clip_ptr = clip.next;
+static int RectToModetMap(
+	struct go7007 *go,
+	char Region,
+	struct v4l2_rect *Rect,
+	int Delete)
+{
+	register int x, y, mbnum;
+  /* Check if coordinates are OK and if any macroblocks are already
+   * used by other regions (besides 0) */
+/*  if(Rect)*/
+	if (
+	Rect->left < 0 || (
+	Rect->left & 0xF) || Rect->width <= 0 || (
+	Rect->width & 0xF))
+		return -EINVAL;
+	if (Rect->left+Rect->width > go->width)
+		return -EINVAL;
+	if (
+	Rect->top < 0 || (
+	Rect->top & 0xF) || Rect->height <= 0 || (
+	Rect->height & 0xF))
+		return -EINVAL;
+	if (Rect->top+Rect->height > go->height)
+		return -EINVAL;
+	for (y = 0; y < Rect->height; y += 16)
+		for (x = 0; x < Rect->width; x += 16) {
+			mbnum = (
+	go->width>>4)*(
+	(
+	Rect->top+y)>>4)+(
+	(
+	Rect->left+x)>>4);
+	if (go->modet_map[mbnum] != 0 && go->modet_map[mbnum] != Region)
+		return -EBUSY;
+	else
+	go->modet_map[mbnum] = Delete ? 0 : Region;
+	}
+	return 0;
+}
+
+static int md_s_ctrl(struct v4l2_control *ctrl, struct go7007 *go)
+{
+	switch (ctrl->id) {
+	case GO7007IOC_REGION_NUMBER:
+	if (ctrl->value < 0 || ctrl->value > 3)
+		return -EINVAL;
+	go->fCurrentRegion = ctrl->value;
+	break;
+	case GO7007IOC_PIXEL_THRESOLD:
+	if (ctrl->value < 0 || ctrl->value > 65535)
+		return -EINVAL;
+	go->modet[go->fCurrentRegion].pixel_threshold = ctrl->value>>1;
+	break;
+	case GO7007IOC_MOTION_THRESOLD:
+	if (ctrl->value < 0 || ctrl->value > 65535)
+		return -EINVAL;
+	go->modet[go->fCurrentRegion].motion_threshold = ctrl->value>>1;
+	break;
+	case GO7007IOC_TRIGGER:
+	if (ctrl->value < 0 || ctrl->value > 65535)
+		return -EINVAL;
+	go->modet[go->fCurrentRegion].mb_threshold = ctrl->value>>1;
+	go->modet[go->fCurrentRegion].enable = ctrl->value > 0;
+	break;
+	case GO7007IOC_REGION_CONTROL:
+	if (go->fCurrentRegion < 1 || go->fCurrentRegion > 3)
+		return -EINVAL;
+	switch (ctrl->value) {
+	case rcAdd:
+	RectToModetMap(go, go->fCurrentRegion, &go->fClipRegion, 0);
+	break;
+	case rcDelete:
+	RectToModetMap(go, go->fCurrentRegion, &go->fClipRegion, 1);
+	break;
+	case rcClear:
+	ClearModetMap(go, go->fCurrentRegion);
+	break;
+	default:
+	return -EINVAL;
+	}
+	break;
+	case GO7007IOC_CLIP_LEFT:
+	go->fClipRegion.top = ctrl->value;
+	break;
+	case GO7007IOC_CLIP_TOP:
+	go->fClipRegion.left = ctrl->value;
+	break;
+	case GO7007IOC_CLIP_WIDTH:
+	go->fClipRegion.width = ctrl->value;
+	break;
+	case GO7007IOC_CLIP_HEIGHT:
+	go->fClipRegion.height = ctrl->value;
+	break;
+	default:
+	return -EINVAL;
+	}
+	return 0;
+}
+
+static int vidioc_querymenu(
+	struct file *file,
+	void *fh,
+	struct v4l2_querymenu *menuctrl)
+{
+	switch (menuctrl->id) {
+	case V4L2_CID_MPEG_STREAM_TYPE:
+	switch (menuctrl->index) {
+	case V4L2_MPEG_STREAM_TYPE_MPEG2_DVD:
+	strcpy(menuctrl->name, "MPEG2 DVD");
+	break;
+	case V4L2_MPEG_STREAM_TYPE_MPEG_ELEM:
+	strcpy(menuctrl->name, "MPEG ELEM");
+	break;
+	default:
+	return -EINVAL;
+	}
+	break;
+	case V4L2_CID_MPEG_VIDEO_ENCODING:
+	switch (menuctrl->index) {
+	case V4L2_MPEG_VIDEO_ENCODING_MPEG_1:
+	strcpy(menuctrl->name, "MPEG1");
+	break;
+	case V4L2_MPEG_VIDEO_ENCODING_MPEG_2:
+	strcpy(menuctrl->name, "MPEG2");
+	break;
+	case V4L2_MPEG_VIDEO_ENCODING_MPEG_4_AVC:
+	strcpy(menuctrl->name, "MPEG4");
+	break;
+	default:
+	return -EINVAL;
+	}
+	break;
+	case V4L2_CID_MPEG_VIDEO_ASPECT:
+	switch (menuctrl->index) {
+	case V4L2_MPEG_VIDEO_ASPECT_1x1:
+	strcpy(menuctrl->name, "1x1");
+	break;
+	case V4L2_MPEG_VIDEO_ASPECT_4x3:
+	strcpy(menuctrl->name, "4x3");
+	break;
+	case V4L2_MPEG_VIDEO_ASPECT_16x9:
+	strcpy(menuctrl->name, "16x9");
+	break;
+	case V4L2_MPEG_VIDEO_ASPECT_221x100:
+	strcpy(menuctrl->name, "221x100");
+/*          break;*/
+	default:
+	return -EINVAL;
+	}
+	break;
+	case GO7007IOC_REGION_CONTROL:
+	switch (menuctrl->index) {
+	case rcAdd:
+	strcpy(menuctrl->name, "Add");
+	break;
+	case rcDelete:
+	strcpy(menuctrl->name, "Delete");
+	break;
+	case rcClear:
+	strcpy(menuctrl->name, "Clear");
+	break;
+	default:
+	return -EINVAL;
+	}
+	break;
+	default:
+	return -EINVAL;
+	}
+	return 0;
+}
+
+static int md_query_ctrl(struct v4l2_queryctrl *ctrl, struct go7007 *go)
+{
+	static const u32 md_ctrls[] = {
+	GO7007IOC_REGION_NUMBER
+	, GO7007IOC_PIXEL_THRESOLD
+	, GO7007IOC_MOTION_THRESOLD
+	, GO7007IOC_TRIGGER
+	, GO7007IOC_REGION_CONTROL
+	, GO7007IOC_CLIP_LEFT
+	, GO7007IOC_CLIP_TOP
+	, GO7007IOC_CLIP_WIDTH
+	, GO7007IOC_CLIP_HEIGHT
+	, 0
+	};
+
+	static const u32 *ctrl_classes[] = {
+	md_ctrls
+	, NULL
+	};
+
+	printk(KERN_INFO"Before Try md query ctrl %d", ctrl->id);
+
+	ctrl->id = v4l2_ctrl_next(ctrl_classes, ctrl->id);
+
+	printk(KERN_INFO"Try md query ctrl %d", ctrl->id);
+	switch (ctrl->id) {
+	case GO7007IOC_REGION_NUMBER:
+	ctrl->type = V4L2_CTRL_TYPE_INTEGER;
+	strncpy(ctrl->name, "Region MD", sizeof(ctrl->name));
+	ctrl->minimum = 0;
+	ctrl->maximum = 3;
+	ctrl->step = 1;
+	ctrl->default_value = 0;
+	ctrl->flags = 0;
+	break;
+	case GO7007IOC_PIXEL_THRESOLD:
+	ctrl->type = V4L2_CTRL_TYPE_INTEGER;
+	strncpy(ctrl->name, "Pixel Thresold", sizeof(ctrl->name));
+	ctrl->minimum = 0;
+	ctrl->maximum = 65535;
+	ctrl->step = 1;
+	ctrl->default_value = 32767;
+	ctrl->flags = 0;
+	break;
+	case GO7007IOC_MOTION_THRESOLD:
+	ctrl->type = V4L2_CTRL_TYPE_INTEGER;
+	strncpy(ctrl->name, "Motion Thresold", sizeof(ctrl->name));
+	ctrl->minimum = 0;
+	ctrl->maximum = 65535;
+	ctrl->step = 1;
+	ctrl->default_value = 32767;
+	ctrl->flags = 0;
+	break;
+	case GO7007IOC_TRIGGER:
+	ctrl->type = V4L2_CTRL_TYPE_INTEGER;
+	strncpy(ctrl->name, "Trigger", sizeof(ctrl->name));
+	ctrl->minimum = 0;
+	ctrl->maximum = 65535;
+	ctrl->step = 1;
+	ctrl->default_value = 32767;
+	ctrl->flags = 0;
+	break;
+	case GO7007IOC_REGION_CONTROL:
+	ctrl->type = V4L2_CTRL_TYPE_MENU;/*V4L2_CTRL_TYPE_BUTTON;*/
+	strncpy(ctrl->name, "Region Control", sizeof(ctrl->name));
+	ctrl->minimum = rcAdd;
+	ctrl->maximum = rcClear;
+	ctrl->step = 1;
+	ctrl->default_value = rcAdd;
+	ctrl->flags = 0;
+	break;
+	case GO7007IOC_CLIP_LEFT:
+	ctrl->type = V4L2_CTRL_TYPE_INTEGER;
+	strncpy(ctrl->name, "Left of Region", sizeof(ctrl->name));
+	ctrl->minimum = 0;
+	ctrl->maximum = go->width-1;
+	ctrl->step = 1;
+	ctrl->default_value = 0;
+	ctrl->flags = 0;
+	break;
+	case GO7007IOC_CLIP_TOP:
+	ctrl->type = V4L2_CTRL_TYPE_INTEGER;
+	strncpy(ctrl->name, "Top of Region", sizeof(ctrl->name));
+	ctrl->minimum = 0;
+	ctrl->maximum = go->height-1;
+	ctrl->step = 1;
+	ctrl->default_value = 0;
+	ctrl->flags = 0;
+	break;
+	case GO7007IOC_CLIP_WIDTH:
+	ctrl->type = V4L2_CTRL_TYPE_INTEGER;
+	strncpy(ctrl->name, "Width of Region", sizeof(ctrl->name));
+	ctrl->minimum = 0;
+	ctrl->maximum = go->width;
+	ctrl->step = 1;
+	ctrl->default_value = 0;
+	ctrl->flags = 0;
+	break;
+	case GO7007IOC_CLIP_HEIGHT:
+	ctrl->type = V4L2_CTRL_TYPE_INTEGER;
+	strncpy(ctrl->name, "Height of Region", sizeof(ctrl->name));
+	ctrl->minimum = 0;
+	ctrl->maximum = go->height;
+	ctrl->step = 1;
+	ctrl->default_value = 0;
+	ctrl->flags = 0;
+	break;
+	default:
+	return -EINVAL;
 	}
 	return 0;
 }
-#endif
 
 static int mpeg_query_ctrl(struct v4l2_queryctrl *ctrl)
 {
 	static const u32 mpeg_ctrls[] = {
-		V4L2_CID_MPEG_CLASS,
-		V4L2_CID_MPEG_STREAM_TYPE,
-		V4L2_CID_MPEG_VIDEO_ENCODING,
-		V4L2_CID_MPEG_VIDEO_ASPECT,
-		V4L2_CID_MPEG_VIDEO_GOP_SIZE,
-		V4L2_CID_MPEG_VIDEO_GOP_CLOSURE,
-		V4L2_CID_MPEG_VIDEO_BITRATE,
-		0
+	V4L2_CID_MPEG_CLASS
+	, V4L2_CID_MPEG_STREAM_TYPE
+	, V4L2_CID_MPEG_VIDEO_ENCODING
+	, V4L2_CID_MPEG_VIDEO_ASPECT
+	, V4L2_CID_MPEG_VIDEO_B_FRAMES
+	, V4L2_CID_MPEG_VIDEO_GOP_SIZE
+	, V4L2_CID_MPEG_VIDEO_GOP_CLOSURE
+	, V4L2_CID_MPEG_VIDEO_BITRATE
+/*GO7007_COMP_OMIT_SEQ_HEADER,*/
+/*GO7007_MPEG_REPEAT_SEQHEADER*/
+/*GO7007_MPEG_OMIT_GOP_HEADER*/
+	, 0
 	};
+
 	static const u32 *ctrl_classes[] = {
-		mpeg_ctrls,
-		NULL
+	mpeg_ctrls
+	, NULL
 	};
 
 	ctrl->id = v4l2_ctrl_next(ctrl_classes, ctrl->id);
 
 	switch (ctrl->id) {
 	case V4L2_CID_MPEG_CLASS:
-		return v4l2_ctrl_query_fill(ctrl, 0, 0, 0, 0);
+	return v4l2_ctrl_query_fill(ctrl, 0, 0, 0, 0);
 	case V4L2_CID_MPEG_STREAM_TYPE:
-		return v4l2_ctrl_query_fill(ctrl,
-				V4L2_MPEG_STREAM_TYPE_MPEG2_DVD,
-				V4L2_MPEG_STREAM_TYPE_MPEG_ELEM, 1,
-				V4L2_MPEG_STREAM_TYPE_MPEG_ELEM);
+	return v4l2_ctrl_query_fill(ctrl,
+	V4L2_MPEG_STREAM_TYPE_MPEG2_DVD,
+	V4L2_MPEG_STREAM_TYPE_MPEG_ELEM, 1,
+	V4L2_MPEG_STREAM_TYPE_MPEG_ELEM);
 	case V4L2_CID_MPEG_VIDEO_ENCODING:
-		return v4l2_ctrl_query_fill(ctrl,
-				V4L2_MPEG_VIDEO_ENCODING_MPEG_1,
-				V4L2_MPEG_VIDEO_ENCODING_MPEG_4, 1,
-				V4L2_MPEG_VIDEO_ENCODING_MPEG_2);
+	return v4l2_ctrl_query_fill(ctrl,
+	V4L2_MPEG_VIDEO_ENCODING_MPEG_1,
+	V4L2_MPEG_VIDEO_ENCODING_MPEG_4_AVC, 1,
+	V4L2_MPEG_VIDEO_ENCODING_MPEG_2);
 	case V4L2_CID_MPEG_VIDEO_ASPECT:
-		return v4l2_ctrl_query_fill(ctrl,
-				V4L2_MPEG_VIDEO_ASPECT_1x1,
-				V4L2_MPEG_VIDEO_ASPECT_16x9, 1,
-				V4L2_MPEG_VIDEO_ASPECT_1x1);
+	return v4l2_ctrl_query_fill(ctrl,
+	V4L2_MPEG_VIDEO_ASPECT_1x1,
+	V4L2_MPEG_VIDEO_ASPECT_16x9, 1,
+	V4L2_MPEG_VIDEO_ASPECT_1x1);
 	case V4L2_CID_MPEG_VIDEO_GOP_SIZE:
-		return v4l2_ctrl_query_fill(ctrl, 0, 34, 1, 15);
+	return v4l2_ctrl_query_fill(ctrl, 0, 34, 1, 15);
 	case V4L2_CID_MPEG_VIDEO_GOP_CLOSURE:
-		return v4l2_ctrl_query_fill(ctrl, 0, 1, 1, 0);
+	return v4l2_ctrl_query_fill(ctrl, 0, 1, 1, 0);
 	case V4L2_CID_MPEG_VIDEO_BITRATE:
-		return v4l2_ctrl_query_fill(ctrl,
-				64000,
-				10000000, 1,
-				1500000);
+	return v4l2_ctrl_query_fill(ctrl,
+	64000,
+	10000000, 1,
+	1500000);
+	case V4L2_CID_MPEG_VIDEO_B_FRAMES:
+	return v4l2_ctrl_query_fill(ctrl, 0, 2, 1, 0);
 	default:
-		return -EINVAL;
+	return -EINVAL;
 	}
 	return 0;
 }
@@ -484,7 +754,7 @@ static int mpeg_s_ctrl(struct v4l2_control *ctrl, struct go7007 *go)
 			else*/
 				go->pali = 0x48;
 			break;
-		case V4L2_MPEG_VIDEO_ENCODING_MPEG_4:
+		case V4L2_MPEG_VIDEO_ENCODING_MPEG_4_AVC:
 			go->format = GO7007_FORMAT_MPEG4;
 			/*if (mpeg->pali >> 24 == 4)
 				go->pali = mpeg->pali & 0xff;
@@ -537,8 +807,13 @@ static int mpeg_s_ctrl(struct v4l2_control *ctrl, struct go7007 *go)
 			return -EINVAL;
 		go->bitrate = ctrl->value;
 		break;
+	case V4L2_CID_MPEG_VIDEO_B_FRAMES:
+	if (ctrl->value < 0 || ctrl->value > 2)/*/checking*/
+	return -EINVAL;
+	go->ipb = ctrl->value > 0;
+	break;
 	default:
-		return -EINVAL;
+	return -EINVAL;
 	}
 	return 0;
 }
@@ -561,7 +836,7 @@ static int mpeg_g_ctrl(struct v4l2_control *ctrl, struct go7007 *go)
 			ctrl->value = V4L2_MPEG_VIDEO_ENCODING_MPEG_2;
 			break;
 		case GO7007_FORMAT_MPEG4:
-			ctrl->value = V4L2_MPEG_VIDEO_ENCODING_MPEG_4;
+			ctrl->value = V4L2_MPEG_VIDEO_ENCODING_MPEG_4_AVC;
 			break;
 		default:
 			return -EINVAL;
@@ -591,8 +866,11 @@ static int mpeg_g_ctrl(struct v4l2_control *ctrl, struct go7007 *go)
 	case V4L2_CID_MPEG_VIDEO_BITRATE:
 		ctrl->value = go->bitrate;
 		break;
+	case V4L2_CID_MPEG_VIDEO_B_FRAMES:
+	ctrl->value = go->ipb ? 2 : 0;
+	break;
 	default:
-		return -EINVAL;
+	return -EINVAL;
 	}
 	return 0;
 }
@@ -604,9 +882,7 @@ static int vidioc_querycap(struct file *file, void  *priv,
 
 	strlcpy(cap->driver, "go7007", sizeof(cap->driver));
 	strlcpy(cap->card, go->name, sizeof(cap->card));
-#if 0
-	strlcpy(cap->bus_info, dev_name(&dev->udev->dev), sizeof(cap->bus_info));
-#endif
+	strlcpy(cap->bus_info, dev_name(go->dev), sizeof(cap->bus_info));
 
 	cap->version = KERNEL_VERSION(0, 9, 8);
 
@@ -633,6 +909,9 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
 		fmt->pixelformat = V4L2_PIX_FMT_MPEG;
 		desc = "MPEG1/MPEG2/MPEG4";
 		break;
+	case 2:
+		fmt->pixelformat = V4L2_PIX_FMT_H263;
+		desc = "Compressed H263";
 	default:
 		return -EINVAL;
 	}
@@ -652,8 +931,10 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 	fmt->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	fmt->fmt.pix.width = go->width;
 	fmt->fmt.pix.height = go->height;
-	fmt->fmt.pix.pixelformat = (go->format == GO7007_FORMAT_MJPEG) ?
-				   V4L2_PIX_FMT_MJPEG : V4L2_PIX_FMT_MPEG;
+	fmt->fmt.pix.pixelformat = (
+	go->format == GO7007_FORMAT_MJPEG) ? V4L2_PIX_FMT_MJPEG : (
+	(
+	go->format == GO7007_FORMAT_H263) ? V4L2_PIX_FMT_H263 : V4L2_PIX_FMT_MPEG);
 	fmt->fmt.pix.field = V4L2_FIELD_NONE;
 	fmt->fmt.pix.bytesperline = 0;
 	fmt->fmt.pix.sizeimage = GO7007_BUF_SIZE;
@@ -974,39 +1255,52 @@ static int vidioc_streamoff(struct file *file, void *priv,
 	return 0;
 }
 
-static int vidioc_queryctrl(struct file *file, void *priv,
-			   struct v4l2_queryctrl *query)
+static int vidioc_queryctrl(
+	struct file *file,
+	void *priv,
+	struct v4l2_queryctrl *query)
 {
-	struct go7007 *go = ((struct go7007_file *) priv)->go;
+	struct go7007 *go = ((struct go7007_file *)priv)->go;
 	int id = query->id;
 
 	if (0 == call_all(&go->v4l2_dev, core, queryctrl, query))
 		return 0;
 
 	query->id = id;
-	return mpeg_query_ctrl(query);
+	if (mpeg_query_ctrl(query) == 0)
+		return 0;
+	query->id = id;
+	return md_query_ctrl(query, go);
 }
 
-static int vidioc_g_ctrl(struct file *file, void *priv,
-				struct v4l2_control *ctrl)
+static int vidioc_g_ctrl(
+	struct file *file,
+	void *priv,
+	struct v4l2_control *ctrl)
 {
-	struct go7007 *go = ((struct go7007_file *) priv)->go;
+	struct go7007 *go = ((struct go7007_file *)priv)->go;
 
 	if (0 == call_all(&go->v4l2_dev, core, g_ctrl, ctrl))
 		return 0;
 
-	return mpeg_g_ctrl(ctrl, go);
+	if (mpeg_g_ctrl(ctrl, go) == 0)
+		return 0;
+	return md_g_ctrl(ctrl, go);
 }
 
-static int vidioc_s_ctrl(struct file *file, void *priv,
-				struct v4l2_control *ctrl)
+static int vidioc_s_ctrl(
+	struct file *file,
+	void *priv,
+	struct v4l2_control *ctrl)
 {
-	struct go7007 *go = ((struct go7007_file *) priv)->go;
+	struct go7007 *go = ((struct go7007_file *)priv)->go;
 
 	if (0 == call_all(&go->v4l2_dev, core, s_ctrl, ctrl))
 		return 0;
 
-	return mpeg_s_ctrl(ctrl, go);
+	if (mpeg_s_ctrl(ctrl, go) == 0)
+		return 0;
+	return md_s_ctrl(ctrl, go);
 }
 
 static int vidioc_g_parm(struct file *filp, void *priv,
@@ -1059,16 +1353,92 @@ static int vidioc_s_parm(struct file *filp, void *priv,
 
    The two functions below implement the newer ioctls
 */
-static int vidioc_enum_framesizes(struct file *filp, void *priv,
-				  struct v4l2_frmsizeenum *fsize)
+static int vidioc_enum_framesizes(
+	struct file *filp,
+	void *priv,
+	struct v4l2_frmsizeenum *fsize)
 {
-	struct go7007 *go = ((struct go7007_file *) priv)->go;
-
-	/* Return -EINVAL, if it is a TV board */
-	if ((go->board_info->flags & GO7007_BOARD_HAS_TUNER) ||
-	    (go->board_info->sensor_flags & GO7007_SENSOR_TV))
+	struct go7007 *go = ((struct go7007_file *)priv)->go;
+  /* Return -EINVAL, if it is a TV board */
+	if (go->board_info->flags & GO7007_BOARD_HAS_TUNER)
 		return -EINVAL;
 
+	if (go->board_info->sensor_flags & GO7007_SENSOR_TV) {
+		switch (go->standard) {
+		case GO7007_STD_NTSC:
+	switch (fsize->pixel_format) {
+	case V4L2_PIX_FMT_MJPEG:
+	case V4L2_PIX_FMT_MPEG:
+	case V4L2_PIX_FMT_H263:
+	switch (fsize->index) {
+	case 0:
+	fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
+	fsize->discrete.width = 720;
+	fsize->discrete.height = 480;
+	break;
+	case 1:
+	fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
+	fsize->discrete.width = 640;
+	fsize->discrete.height = 480;
+	break;
+	case 2:
+	fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
+	fsize->discrete.width = 352;
+	fsize->discrete.height = 240;
+	break;
+	case 3:
+	fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
+	fsize->discrete.width = 320;
+	fsize->discrete.height = 240;
+	break;
+	case 4:
+	fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
+	fsize->discrete.width = 176;
+	fsize->discrete.height = 112;
+	break;
+	default:
+	return -EINVAL;
+	}
+	break;
+	default:
+	return -EINVAL;
+	}
+	break;
+		case GO7007_STD_PAL:
+	switch (fsize->pixel_format) {
+	case V4L2_PIX_FMT_MJPEG:
+	case V4L2_PIX_FMT_MPEG:
+	case V4L2_PIX_FMT_H263:
+	switch (fsize->index) {
+	case 0:
+	fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
+	fsize->discrete.width = 720;
+	fsize->discrete.height = 576;
+	break;
+	case 1:
+	fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
+	fsize->discrete.width = 352;
+	fsize->discrete.height = 288;
+	break;
+	case 2:
+	fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
+	fsize->discrete.width = 176;
+	fsize->discrete.height = 144;
+	break;
+	default:
+	return -EINVAL;
+	}
+	break;
+	default:
+	return -EINVAL;
+	}
+	break;
+		default:
+	return -EINVAL;
+	}
+	return 0;
+	}
+
 	if (fsize->index > 0)
 		return -EINVAL;
 
@@ -1079,16 +1449,140 @@ static int vidioc_enum_framesizes(struct file *filp, void *priv,
 	return 0;
 }
 
-static int vidioc_enum_frameintervals(struct file *filp, void *priv,
-				      struct v4l2_frmivalenum *fival)
+static int vidioc_enum_frameintervals(
+	struct file *filp,
+	void *priv,
+	struct v4l2_frmivalenum *fival)
 {
-	struct go7007 *go = ((struct go7007_file *) priv)->go;
+	struct go7007 *go = ((struct go7007_file *)priv)->go;
 
-	/* Return -EINVAL, if it is a TV board */
-	if ((go->board_info->flags & GO7007_BOARD_HAS_TUNER) ||
-	    (go->board_info->sensor_flags & GO7007_SENSOR_TV))
+  /* Return -EINVAL, if it is a TV board */
+	if ((go->board_info->flags & GO7007_BOARD_HAS_TUNER))
 		return -EINVAL;
 
+	if (go->board_info->sensor_flags & GO7007_SENSOR_TV) {
+		switch (fival->pixel_format) {
+		case V4L2_PIX_FMT_MJPEG:
+		case V4L2_PIX_FMT_MPEG:
+		case V4L2_PIX_FMT_H263:
+	switch (go->standard) {
+	case GO7007_STD_NTSC:
+	switch (fival->index) {
+	case 0:
+	fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+	fival->discrete.numerator = 1001*1;
+	fival->discrete.denominator = go->sensor_framerate;
+	break;
+	case 1:
+	fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+	fival->discrete.numerator = 1001*2;
+	fival->discrete.denominator = go->sensor_framerate;
+	break;
+	case 2:
+	fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+	fival->discrete.numerator = 1001*3;
+	fival->discrete.denominator = go->sensor_framerate;
+	break;
+	case 3:
+	fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+	fival->discrete.numerator = 1001*4;
+	fival->discrete.denominator = go->sensor_framerate;
+	break;
+	case 4:
+	fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+	fival->discrete.numerator = 1001*5;
+	fival->discrete.denominator = go->sensor_framerate;
+	break;
+	case 5:
+	fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+	fival->discrete.numerator = 1001*6;
+	fival->discrete.denominator = go->sensor_framerate;
+	break;
+	case 6:
+	fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+	fival->discrete.numerator = 1001*7;
+	fival->discrete.denominator = go->sensor_framerate;
+	break;
+	case 7:
+	fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+	fival->discrete.numerator = 1001*10;
+	fival->discrete.denominator = go->sensor_framerate;
+	break;
+	case 8:
+	fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+	fival->discrete.numerator = 1001*15;
+	fival->discrete.denominator = go->sensor_framerate;
+	break;
+	case 9:
+	fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+	fival->discrete.numerator = 1001*30;
+	fival->discrete.denominator = go->sensor_framerate;
+	break;
+	default:
+	return -EINVAL;
+	}
+	break;
+	case GO7007_STD_PAL:
+	switch (fival->index) {
+	case 0:
+	fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+	fival->discrete.numerator = 1001*1;
+	fival->discrete.denominator = go->sensor_framerate;
+	break;
+	case 1:
+	fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+	fival->discrete.numerator = 1001*2;
+	fival->discrete.denominator = go->sensor_framerate;
+	break;
+	case 2:
+	fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+	fival->discrete.numerator = 1001*3;
+	fival->discrete.denominator = go->sensor_framerate;
+	break;
+	case 3:
+	fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+	fival->discrete.numerator = 1001*4;
+	fival->discrete.denominator = go->sensor_framerate;
+	break;
+	case 4:
+	fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+	fival->discrete.numerator = 1001*5;
+	fival->discrete.denominator = go->sensor_framerate;
+	break;
+	case 5:
+	fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+	fival->discrete.numerator = 1001*6;
+	fival->discrete.denominator = go->sensor_framerate;
+	break;
+	case 6:
+	fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+	fival->discrete.numerator = 1001*8;
+	fival->discrete.denominator = go->sensor_framerate;
+	break;
+	case 7:
+	fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+	fival->discrete.numerator = 1001*13;
+	fival->discrete.denominator = go->sensor_framerate;
+	break;
+	case 8:
+	fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+	fival->discrete.numerator = 1001*25;
+	fival->discrete.denominator = go->sensor_framerate;
+	break;
+	default:
+	return -EINVAL;
+	}
+	break;
+	default:
+	return -EINVAL;
+	}
+	break;
+		default:
+	return -EINVAL;
+	}
+	return 0;
+	}
+
 	if (fival->index > 0)
 		return -EINVAL;
 
@@ -1404,235 +1898,6 @@ static int vidioc_s_jpegcomp(struct file *file, void *priv,
 	return 0;
 }
 
-/* FIXME:
-	Those ioctls are private, and not needed, since several standard
-	extended controls already provide streaming control.
-	So, those ioctls should be converted into vidioc_g_ext_ctrls()
-	and vidioc_s_ext_ctrls()
- */
-
-#if 0
-	/* Temporary ioctls for controlling compression characteristics */
-	case GO7007IOC_S_BITRATE:
-	{
-		int *bitrate = arg;
-
-		if (go->streaming)
-			return -EINVAL;
-		/* Upper bound is kind of arbitrary here */
-		if (*bitrate < 64000 || *bitrate > 10000000)
-			return -EINVAL;
-		go->bitrate = *bitrate;
-		return 0;
-	}
-	case GO7007IOC_G_BITRATE:
-	{
-		int *bitrate = arg;
-
-		*bitrate = go->bitrate;
-		return 0;
-	}
-	case GO7007IOC_S_COMP_PARAMS:
-	{
-		struct go7007_comp_params *comp = arg;
-
-		if (go->format == GO7007_FORMAT_MJPEG)
-			return -EINVAL;
-		if (comp->gop_size > 0)
-			go->gop_size = comp->gop_size;
-		else
-			go->gop_size = go->sensor_framerate / 1000;
-		if (go->gop_size != 15)
-			go->dvd_mode = 0;
-		/*go->ipb = comp->max_b_frames > 0;*/ /* completely untested */
-		if (go->board_info->sensor_flags & GO7007_SENSOR_TV) {
-			switch (comp->aspect_ratio) {
-			case GO7007_ASPECT_RATIO_4_3_NTSC:
-			case GO7007_ASPECT_RATIO_4_3_PAL:
-				go->aspect_ratio = GO7007_RATIO_4_3;
-				break;
-			case GO7007_ASPECT_RATIO_16_9_NTSC:
-			case GO7007_ASPECT_RATIO_16_9_PAL:
-				go->aspect_ratio = GO7007_RATIO_16_9;
-				break;
-			default:
-				go->aspect_ratio = GO7007_RATIO_1_1;
-				break;
-			}
-		}
-		if (comp->flags & GO7007_COMP_OMIT_SEQ_HEADER) {
-			go->dvd_mode = 0;
-			go->seq_header_enable = 0;
-		} else {
-			go->seq_header_enable = 1;
-		}
-		/* fall-through */
-	}
-	case GO7007IOC_G_COMP_PARAMS:
-	{
-		struct go7007_comp_params *comp = arg;
-
-		if (go->format == GO7007_FORMAT_MJPEG)
-			return -EINVAL;
-		memset(comp, 0, sizeof(*comp));
-		comp->gop_size = go->gop_size;
-		comp->max_b_frames = go->ipb ? 2 : 0;
-		switch (go->aspect_ratio) {
-		case GO7007_RATIO_4_3:
-			if (go->standard == GO7007_STD_NTSC)
-				comp->aspect_ratio =
-					GO7007_ASPECT_RATIO_4_3_NTSC;
-			else
-				comp->aspect_ratio =
-					GO7007_ASPECT_RATIO_4_3_PAL;
-			break;
-		case GO7007_RATIO_16_9:
-			if (go->standard == GO7007_STD_NTSC)
-				comp->aspect_ratio =
-					GO7007_ASPECT_RATIO_16_9_NTSC;
-			else
-				comp->aspect_ratio =
-					GO7007_ASPECT_RATIO_16_9_PAL;
-			break;
-		default:
-			comp->aspect_ratio = GO7007_ASPECT_RATIO_1_1;
-			break;
-		}
-		if (go->closed_gop)
-			comp->flags |= GO7007_COMP_CLOSED_GOP;
-		if (!go->seq_header_enable)
-			comp->flags |= GO7007_COMP_OMIT_SEQ_HEADER;
-		return 0;
-	}
-	case GO7007IOC_S_MPEG_PARAMS:
-	{
-		struct go7007_mpeg_params *mpeg = arg;
-
-		if (go->format != GO7007_FORMAT_MPEG1 &&
-				go->format != GO7007_FORMAT_MPEG2 &&
-				go->format != GO7007_FORMAT_MPEG4)
-			return -EINVAL;
-
-		if (mpeg->flags & GO7007_MPEG_FORCE_DVD_MODE) {
-			go->format = GO7007_FORMAT_MPEG2;
-			go->bitrate = 9800000;
-			go->gop_size = 15;
-			go->pali = 0x48;
-			go->closed_gop = 1;
-			go->repeat_seqhead = 0;
-			go->seq_header_enable = 1;
-			go->gop_header_enable = 1;
-			go->dvd_mode = 1;
-		} else {
-			switch (mpeg->mpeg_video_standard) {
-			case GO7007_MPEG_VIDEO_MPEG1:
-				go->format = GO7007_FORMAT_MPEG1;
-				go->pali = 0;
-				break;
-			case GO7007_MPEG_VIDEO_MPEG2:
-				go->format = GO7007_FORMAT_MPEG2;
-				if (mpeg->pali >> 24 == 2)
-					go->pali = mpeg->pali & 0xff;
-				else
-					go->pali = 0x48;
-				break;
-			case GO7007_MPEG_VIDEO_MPEG4:
-				go->format = GO7007_FORMAT_MPEG4;
-				if (mpeg->pali >> 24 == 4)
-					go->pali = mpeg->pali & 0xff;
-				else
-					go->pali = 0xf5;
-				break;
-			default:
-				return -EINVAL;
-			}
-			go->gop_header_enable =
-				mpeg->flags & GO7007_MPEG_OMIT_GOP_HEADER
-				? 0 : 1;
-			if (mpeg->flags & GO7007_MPEG_REPEAT_SEQHEADER)
-				go->repeat_seqhead = 1;
-			else
-				go->repeat_seqhead = 0;
-			go->dvd_mode = 0;
-		}
-		/* fall-through */
-	}
-	case GO7007IOC_G_MPEG_PARAMS:
-	{
-		struct go7007_mpeg_params *mpeg = arg;
-
-		memset(mpeg, 0, sizeof(*mpeg));
-		switch (go->format) {
-		case GO7007_FORMAT_MPEG1:
-			mpeg->mpeg_video_standard = GO7007_MPEG_VIDEO_MPEG1;
-			mpeg->pali = 0;
-			break;
-		case GO7007_FORMAT_MPEG2:
-			mpeg->mpeg_video_standard = GO7007_MPEG_VIDEO_MPEG2;
-			mpeg->pali = GO7007_MPEG_PROFILE(2, go->pali);
-			break;
-		case GO7007_FORMAT_MPEG4:
-			mpeg->mpeg_video_standard = GO7007_MPEG_VIDEO_MPEG4;
-			mpeg->pali = GO7007_MPEG_PROFILE(4, go->pali);
-			break;
-		default:
-			return -EINVAL;
-		}
-		if (!go->gop_header_enable)
-			mpeg->flags |= GO7007_MPEG_OMIT_GOP_HEADER;
-		if (go->repeat_seqhead)
-			mpeg->flags |= GO7007_MPEG_REPEAT_SEQHEADER;
-		if (go->dvd_mode)
-			mpeg->flags |= GO7007_MPEG_FORCE_DVD_MODE;
-		return 0;
-	}
-	case GO7007IOC_S_MD_PARAMS:
-	{
-		struct go7007_md_params *mdp = arg;
-
-		if (mdp->region > 3)
-			return -EINVAL;
-		if (mdp->trigger > 0) {
-			go->modet[mdp->region].pixel_threshold =
-					mdp->pixel_threshold >> 1;
-			go->modet[mdp->region].motion_threshold =
-					mdp->motion_threshold >> 1;
-			go->modet[mdp->region].mb_threshold =
-					mdp->trigger >> 1;
-			go->modet[mdp->region].enable = 1;
-		} else
-			go->modet[mdp->region].enable = 0;
-		/* fall-through */
-	}
-	case GO7007IOC_G_MD_PARAMS:
-	{
-		struct go7007_md_params *mdp = arg;
-		int region = mdp->region;
-
-		if (mdp->region > 3)
-			return -EINVAL;
-		memset(mdp, 0, sizeof(struct go7007_md_params));
-		mdp->region = region;
-		if (!go->modet[region].enable)
-			return 0;
-		mdp->pixel_threshold =
-			(go->modet[region].pixel_threshold << 1) + 1;
-		mdp->motion_threshold =
-			(go->modet[region].motion_threshold << 1) + 1;
-		mdp->trigger =
-			(go->modet[region].mb_threshold << 1) + 1;
-		return 0;
-	}
-	case GO7007IOC_S_MD_REGION:
-	{
-		struct go7007_md_region *region = arg;
-
-		if (region->region < 1 || region->region > 3)
-			return -EINVAL;
-		return clip_to_modet_map(go, region->region, region->clips);
-	}
-#endif
-
 static ssize_t go7007_read(struct file *file, char __user *data,
 		size_t count, loff_t *ppos)
 {
@@ -1778,7 +2043,9 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_g_crop            = vidioc_g_crop,
 	.vidioc_s_crop            = vidioc_s_crop,
 	.vidioc_g_jpegcomp        = vidioc_g_jpegcomp,
-	.vidioc_s_jpegcomp        = vidioc_s_jpegcomp,
+	.vidioc_s_jpegcomp        = vidioc_s_jpegcomp
+	, .vidioc_querymenu = vidioc_querymenu
+	,
 };
 
 static struct video_device go7007_template = {
@@ -1786,13 +2053,15 @@ static struct video_device go7007_template = {
 	.fops		= &go7007_fops,
 	.release	= go7007_vfl_release,
 	.ioctl_ops	= &video_ioctl_ops,
-	.tvnorms	= V4L2_STD_ALL,
+	.tvnorms	= V4L2_STD_SECAM | V4L2_STD_NTSC | V4L2_STD_PAL,
+	/*/V4L2_STD_ALL,*/
 	.current_norm	= V4L2_STD_NTSC,
 };
 
 int go7007_v4l2_init(struct go7007 *go)
 {
 	int rv;
+	register int i;
 
 	go->video_dev = video_device_alloc();
 	if (go->video_dev == NULL)
@@ -1815,7 +2084,10 @@ int go7007_v4l2_init(struct go7007 *go)
 	++go->ref_count;
 	printk(KERN_INFO "%s: registered device %s [v4l2]\n",
 	       go->video_dev->name, video_device_node_name(go->video_dev));
-
+	memset(&go->fClipRegion, 0, sizeof(go->fClipRegion));
+	go->fCurrentRegion = 0;
+	for (i = 0; i < 4; i++)
+		memset(&go->modet[i], 0, sizeof(go->modet[i]));
 	return 0;
 }
 
diff --git a/drivers/staging/media/go7007/go7007.h b/drivers/staging/media/go7007/go7007.h
index 7399c91..39fd533 100644
--- a/drivers/staging/media/go7007/go7007.h
+++ b/drivers/staging/media/go7007/go7007.h
@@ -19,69 +19,11 @@
 
 /* DEPRECATED -- use V4L2_PIX_FMT_MPEG and then call GO7007IOC_S_MPEG_PARAMS
  * to select between MPEG1, MPEG2, and MPEG4 */
-#define V4L2_PIX_FMT_MPEG4     v4l2_fourcc('M', 'P', 'G', '4') /* MPEG4 */
 
-/* These will be replaced with a better interface
- * soon, so don't get too attached to them */
-#define	GO7007IOC_S_BITRATE	_IOW('V', BASE_VIDIOC_PRIVATE + 0, int)
-#define	GO7007IOC_G_BITRATE	_IOR('V', BASE_VIDIOC_PRIVATE + 1, int)
-
-enum go7007_aspect_ratio {
-	GO7007_ASPECT_RATIO_1_1 = 0,
-	GO7007_ASPECT_RATIO_4_3_NTSC = 1,
-	GO7007_ASPECT_RATIO_4_3_PAL = 2,
-	GO7007_ASPECT_RATIO_16_9_NTSC = 3,
-	GO7007_ASPECT_RATIO_16_9_PAL = 4,
-};
-
-/* Used to set generic compression parameters */
-struct go7007_comp_params {
-	__u32 gop_size;
-	__u32 max_b_frames;
-	enum go7007_aspect_ratio aspect_ratio;
-	__u32 flags;
-	__u32 reserved[8];
-};
-
-#define GO7007_COMP_CLOSED_GOP		0x00000001
-#define GO7007_COMP_OMIT_SEQ_HEADER	0x00000002
-
-enum go7007_mpeg_video_standard {
-	GO7007_MPEG_VIDEO_MPEG1 = 0,
-	GO7007_MPEG_VIDEO_MPEG2 = 1,
-	GO7007_MPEG_VIDEO_MPEG4 = 2,
-};
-
-/* Used to set parameters for V4L2_PIX_FMT_MPEG format */
-struct go7007_mpeg_params {
-	enum go7007_mpeg_video_standard mpeg_video_standard;
-	__u32 flags;
-	__u32 pali;
-	__u32 reserved[8];
-};
-
-#define GO7007_MPEG_FORCE_DVD_MODE	0x00000001
-#define GO7007_MPEG_OMIT_GOP_HEADER	0x00000002
-#define GO7007_MPEG_REPEAT_SEQHEADER	0x00000004
-
-#define GO7007_MPEG_PROFILE(format, pali)	(((format)<<24)|(pali))
-
-#define GO7007_MPEG2_PROFILE_MAIN_MAIN		GO7007_MPEG_PROFILE(2, 0x48)
-
-#define GO7007_MPEG4_PROFILE_S_L0		GO7007_MPEG_PROFILE(4, 0x08)
-#define GO7007_MPEG4_PROFILE_S_L1		GO7007_MPEG_PROFILE(4, 0x01)
-#define GO7007_MPEG4_PROFILE_S_L2		GO7007_MPEG_PROFILE(4, 0x02)
-#define GO7007_MPEG4_PROFILE_S_L3		GO7007_MPEG_PROFILE(4, 0x03)
-#define GO7007_MPEG4_PROFILE_ARTS_L1		GO7007_MPEG_PROFILE(4, 0x91)
-#define GO7007_MPEG4_PROFILE_ARTS_L2		GO7007_MPEG_PROFILE(4, 0x92)
-#define GO7007_MPEG4_PROFILE_ARTS_L3		GO7007_MPEG_PROFILE(4, 0x93)
-#define GO7007_MPEG4_PROFILE_ARTS_L4		GO7007_MPEG_PROFILE(4, 0x94)
-#define GO7007_MPEG4_PROFILE_AS_L0		GO7007_MPEG_PROFILE(4, 0xf0)
-#define GO7007_MPEG4_PROFILE_AS_L1		GO7007_MPEG_PROFILE(4, 0xf1)
-#define GO7007_MPEG4_PROFILE_AS_L2		GO7007_MPEG_PROFILE(4, 0xf2)
-#define GO7007_MPEG4_PROFILE_AS_L3		GO7007_MPEG_PROFILE(4, 0xf3)
-#define GO7007_MPEG4_PROFILE_AS_L4		GO7007_MPEG_PROFILE(4, 0xf4)
-#define GO7007_MPEG4_PROFILE_AS_L5		GO7007_MPEG_PROFILE(4, 0xf5)
+/* Temporary defines until accepted in v4l2-api (videodev2.h) */
+#ifndef V4L2_MPEG_STREAM_TYPE_MPEG_ELEM
+  #define V4L2_MPEG_STREAM_TYPE_MPEG_ELEM   6 /* MPEG elementary stream */
+#endif
 
 struct go7007_md_params {
 	__u16 region;
@@ -98,17 +40,18 @@ struct go7007_md_region {
 	__u32 reserved[8];
 };
 
-#define	GO7007IOC_S_MPEG_PARAMS	_IOWR('V', BASE_VIDIOC_PRIVATE + 2, \
-					struct go7007_mpeg_params)
-#define	GO7007IOC_G_MPEG_PARAMS	_IOR('V', BASE_VIDIOC_PRIVATE + 3, \
-					struct go7007_mpeg_params)
-#define	GO7007IOC_S_COMP_PARAMS	_IOWR('V', BASE_VIDIOC_PRIVATE + 4, \
-					struct go7007_comp_params)
-#define	GO7007IOC_G_COMP_PARAMS	_IOR('V', BASE_VIDIOC_PRIVATE + 5, \
-					struct go7007_comp_params)
-#define	GO7007IOC_S_MD_PARAMS	_IOWR('V', BASE_VIDIOC_PRIVATE + 6, \
-					struct go7007_md_params)
-#define	GO7007IOC_G_MD_PARAMS	_IOR('V', BASE_VIDIOC_PRIVATE + 7, \
-					struct go7007_md_params)
-#define	GO7007IOC_S_MD_REGION	_IOW('V', BASE_VIDIOC_PRIVATE + 8, \
-					struct go7007_md_region)
+#define GO7007IOC_REGION_NUMBER (V4L2_CID_PRIVATE_BASE)
+#define GO7007IOC_PIXEL_THRESOLD (V4L2_CID_PRIVATE_BASE+1)
+#define GO7007IOC_MOTION_THRESOLD (V4L2_CID_PRIVATE_BASE+2)
+#define GO7007IOC_TRIGGER (V4L2_CID_PRIVATE_BASE+3)
+#define GO7007IOC_REGION_CONTROL (V4L2_CID_PRIVATE_BASE+4)
+#define GO7007IOC_CLIP_LEFT (V4L2_CID_PRIVATE_BASE+5)
+#define GO7007IOC_CLIP_TOP (V4L2_CID_PRIVATE_BASE+6)
+#define GO7007IOC_CLIP_WIDTH (V4L2_CID_PRIVATE_BASE+7)
+#define GO7007IOC_CLIP_HEIGHT (V4L2_CID_PRIVATE_BASE+8)
+
+enum RegionControl {
+	rcAdd = 0
+	, rcDelete = 1
+	, rcClear = 2
+};
diff --git a/drivers/staging/media/go7007/wis-tw2804.c b/drivers/staging/media/go7007/wis-tw2804.c
index 9134f03..5a39ce0 100644
--- a/drivers/staging/media/go7007/wis-tw2804.c
+++ b/drivers/staging/media/go7007/wis-tw2804.c
@@ -21,10 +21,13 @@
 #include <linux/videodev2.h>
 #include <linux/ioctl.h>
 #include <linux/slab.h>
+#include <media/v4l2-subdev.h>
+#include <media/v4l2-device.h>
 
 #include "wis-i2c.h"
 
 struct wis_tw2804 {
+	struct v4l2_subdev sd;
 	int channel;
 	int norm;
 	int brightness;
@@ -33,6 +36,13 @@ struct wis_tw2804 {
 	int hue;
 };
 
+static inline struct wis_tw2804 *to_state(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct wis_tw2804, sd);
+}
+
+static int tw2804_log_status(struct v4l2_subdev *sd);
+
 static u8 global_registers[] = {
 	0x39, 0x00,
 	0x3a, 0xff,
@@ -105,9 +115,23 @@ static u8 channel_registers[] = {
 
 static int write_reg(struct i2c_client *client, u8 reg, u8 value, int channel)
 {
-	return i2c_smbus_write_byte_data(client, reg | (channel << 6), value);
+	int i;
+	for (i = 0; i < 10; i++)
+		/*return */if (
+	i2c_smbus_write_byte_data(
+	client,
+	reg|(
+	channel<<6),
+	value) < 0)
+			return -1;
+	return 0;
 }
 
+/**static u8 read_reg(struct i2c_client *client, u8 reg, int channel)
+{
+  return i2c_smbus_read_byte_data(client,reg|(channel<<6));
+}*/
+
 static int write_regs(struct i2c_client *client, u8 *regs, int channel)
 {
 	int i;
@@ -119,183 +143,247 @@ static int write_regs(struct i2c_client *client, u8 *regs, int channel)
 	return 0;
 }
 
-static int wis_tw2804_command(struct i2c_client *client,
-				unsigned int cmd, void *arg)
+static int wis_tw2804_command(
+	struct i2c_client *client,
+	unsigned int cmd,
+	void *arg)
 {
-	struct wis_tw2804 *dec = i2c_get_clientdata(client);
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct wis_tw2804 *dec = to_state(sd);
+	int *input;
 
+	printk(KERN_INFO"wis-tw2804: call command %d\n", cmd);
 	if (cmd == DECODER_SET_CHANNEL) {
-		int *input = arg;
-
-		if (*input < 0 || *input > 3) {
-			printk(KERN_ERR "wis-tw2804: channel %d is not "
-					"between 0 and 3!\n", *input);
-			return 0;
-		}
-		dec->channel = *input;
-		printk(KERN_DEBUG "wis-tw2804: initializing TW2804 "
-				"channel %d\n", dec->channel);
-		if (dec->channel == 0 &&
-				write_regs(client, global_registers, 0) < 0) {
-			printk(KERN_ERR "wis-tw2804: error initializing "
-					"TW2804 global registers\n");
-			return 0;
-		}
-		if (write_regs(client, channel_registers, dec->channel) < 0) {
-			printk(KERN_ERR "wis-tw2804: error initializing "
-					"TW2804 channel %d\n", dec->channel);
-			return 0;
-		}
-		return 0;
+		printk(
+	KERN_INFO"wis-tw2804: DecoderSetChannel call command %d\n",
+	cmd);
+
+	input = arg;
+
+	if (*input < 0 || *input > 3) {
+		printk(
+	KERN_ERR"wis-tw2804: channel %d is not between 0 and 3!\n",
+	*input);
+	return 0;
+	}
+	dec->channel = *input;
+	printk(
+	KERN_DEBUG"wis-tw2804: initializing TW2804 channel %d\n",
+	dec->channel);
+	if (dec->channel == 0 && write_regs(client, global_registers, 0) < 0) {
+		printk(KERN_ERR"wis-tw2804: error initializing TW2804 global registers\n");
+	return 0;
+	}
+	if (write_regs(client, channel_registers, dec->channel) < 0) {
+		printk(
+	KERN_ERR"wis-tw2804: error initializing TW2804 channel %d\n",
+	dec->channel);
+	return 0;
+	}
+	return 0;
 	}
 
 	if (dec->channel < 0) {
-		printk(KERN_DEBUG "wis-tw2804: ignoring command %08x until "
-				"channel number is set\n", cmd);
-		return 0;
+		printk(
+	KERN_DEBUG"wis-tw2804: ignoring command %08x until channel number is set\n",
+				cmd);
+	return 0;
 	}
 
-	switch (cmd) {
-	case VIDIOC_S_STD:
-	{
-		v4l2_std_id *input = arg;
-		u8 regs[] = {
-			0x01, *input & V4L2_STD_NTSC ? 0xc4 : 0x84,
-			0x09, *input & V4L2_STD_NTSC ? 0x07 : 0x04,
-			0x0a, *input & V4L2_STD_NTSC ? 0xf0 : 0x20,
-			0x0b, *input & V4L2_STD_NTSC ? 0x07 : 0x04,
-			0x0c, *input & V4L2_STD_NTSC ? 0xf0 : 0x20,
-			0x0d, *input & V4L2_STD_NTSC ? 0x40 : 0x4a,
-			0x16, *input & V4L2_STD_NTSC ? 0x00 : 0x40,
-			0x17, *input & V4L2_STD_NTSC ? 0x00 : 0x40,
-			0x20, *input & V4L2_STD_NTSC ? 0x07 : 0x0f,
-			0x21, *input & V4L2_STD_NTSC ? 0x07 : 0x0f,
-			0xff,	0xff,
-		};
-		write_regs(client, regs, dec->channel);
-		dec->norm = *input;
-		break;
+	return 0;
+}
+
+static int tw2804_log_status(struct v4l2_subdev *sd)
+{
+	struct wis_tw2804 *state = to_state(sd);
+	v4l2_info(
+	sd,
+	"Standard: %s\n",
+	state->norm == V4L2_STD_NTSC ? "NTSC" : state->norm == V4L2_STD_PAL ? "PAL" : state->norm == V4L2_STD_SECAM ? "SECAM" : "unknown");
+	v4l2_info(sd, "Input: %d\n", state->channel);
+	v4l2_info(sd, "Brightness: %d\n", state->brightness);
+	v4l2_info(sd, "Contrast: %d\n", state->contrast);
+	v4l2_info(sd, "Saturation: %d\n", state->saturation);
+	v4l2_info(sd, "Hue: %d\n", state->hue);
+	return 0;
+}
+
+static int tw2804_queryctrl(
+	struct v4l2_subdev *sd,
+	struct v4l2_queryctrl *query)
+{
+	static const u32 user_ctrls[] = {
+	V4L2_CID_USER_CLASS,
+	V4L2_CID_BRIGHTNESS,
+	V4L2_CID_CONTRAST,
+	V4L2_CID_SATURATION,
+	V4L2_CID_HUE,
+	0
+	};
+
+	static const u32 *ctrl_classes[] = {
+	user_ctrls,
+	NULL
+	};
+
+	query->id = v4l2_ctrl_next(ctrl_classes, query->id);
+
+	switch (query->id) {
+	case V4L2_CID_USER_CLASS:
+	return v4l2_ctrl_query_fill(query, 0, 0, 0, 0);
+	case V4L2_CID_BRIGHTNESS:
+	return v4l2_ctrl_query_fill(query, 0, 255, 1, 128);
+	case V4L2_CID_CONTRAST:
+	return v4l2_ctrl_query_fill(query, 0, 255, 1, 128);
+	case V4L2_CID_SATURATION:
+	return v4l2_ctrl_query_fill(query, 0, 255, 1, 128);
+	case V4L2_CID_HUE:
+	return v4l2_ctrl_query_fill(query, 0, 255, 1, 128);
+	default:
+	return -EINVAL;
 	}
-	case VIDIOC_QUERYCTRL:
-	{
-		struct v4l2_queryctrl *ctrl = arg;
-
-		switch (ctrl->id) {
-		case V4L2_CID_BRIGHTNESS:
-			ctrl->type = V4L2_CTRL_TYPE_INTEGER;
-			strncpy(ctrl->name, "Brightness", sizeof(ctrl->name));
-			ctrl->minimum = 0;
-			ctrl->maximum = 255;
-			ctrl->step = 1;
-			ctrl->default_value = 128;
-			ctrl->flags = 0;
-			break;
-		case V4L2_CID_CONTRAST:
-			ctrl->type = V4L2_CTRL_TYPE_INTEGER;
-			strncpy(ctrl->name, "Contrast", sizeof(ctrl->name));
-			ctrl->minimum = 0;
-			ctrl->maximum = 255;
-			ctrl->step = 1;
-			ctrl->default_value = 128;
-			ctrl->flags = 0;
-			break;
-		case V4L2_CID_SATURATION:
-			ctrl->type = V4L2_CTRL_TYPE_INTEGER;
-			strncpy(ctrl->name, "Saturation", sizeof(ctrl->name));
-			ctrl->minimum = 0;
-			ctrl->maximum = 255;
-			ctrl->step = 1;
-			ctrl->default_value = 128;
-			ctrl->flags = 0;
-			break;
-		case V4L2_CID_HUE:
-			ctrl->type = V4L2_CTRL_TYPE_INTEGER;
-			strncpy(ctrl->name, "Hue", sizeof(ctrl->name));
-			ctrl->minimum = 0;
-			ctrl->maximum = 255;
-			ctrl->step = 1;
-			ctrl->default_value = 128;
-			ctrl->flags = 0;
-			break;
-		}
-		break;
+}
+
+static int tw2804_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+{
+	struct wis_tw2804 *dec = to_state(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	int Addr = 0x00;
+	switch (ctrl->id) {
+	case V4L2_CID_BRIGHTNESS:
+	Addr = 0x12;
+	break;
+	case V4L2_CID_CONTRAST:
+	Addr = 0x11;
+	break;
+	case V4L2_CID_SATURATION:
+	Addr = 0x10;
+	break;
+	case V4L2_CID_HUE:
+	Addr = 0x0f;
+	break;
+	default:
+	return -EINVAL;
 	}
-	case VIDIOC_S_CTRL:
-	{
-		struct v4l2_control *ctrl = arg;
-
-		switch (ctrl->id) {
-		case V4L2_CID_BRIGHTNESS:
-			if (ctrl->value > 255)
-				dec->brightness = 255;
-			else if (ctrl->value < 0)
-				dec->brightness = 0;
-			else
-				dec->brightness = ctrl->value;
-			write_reg(client, 0x12, dec->brightness, dec->channel);
-			break;
-		case V4L2_CID_CONTRAST:
-			if (ctrl->value > 255)
-				dec->contrast = 255;
-			else if (ctrl->value < 0)
-				dec->contrast = 0;
-			else
-				dec->contrast = ctrl->value;
-			write_reg(client, 0x11, dec->contrast, dec->channel);
-			break;
-		case V4L2_CID_SATURATION:
-			if (ctrl->value > 255)
-				dec->saturation = 255;
-			else if (ctrl->value < 0)
-				dec->saturation = 0;
-			else
-				dec->saturation = ctrl->value;
-			write_reg(client, 0x10, dec->saturation, dec->channel);
-			break;
-		case V4L2_CID_HUE:
-			if (ctrl->value > 255)
-				dec->hue = 255;
-			else if (ctrl->value < 0)
-				dec->hue = 0;
-			else
-				dec->hue = ctrl->value;
-			write_reg(client, 0x0f, dec->hue, dec->channel);
-			break;
-		}
-		break;
+	ctrl->value = ctrl->value > 255 ? 255 : (
+	ctrl->value < 0 ? 0 : ctrl->value);
+	Addr = write_reg(client, Addr, ctrl->value, dec->channel);
+	if (Addr < 0) {
+		printk(
+	KERN_INFO"wis_tw2804: can`t set_ctrl value:id=%d;value=%d",
+	ctrl->id,
+	ctrl->value);
+	return Addr;
 	}
-	case VIDIOC_G_CTRL:
-	{
-		struct v4l2_control *ctrl = arg;
-
-		switch (ctrl->id) {
-		case V4L2_CID_BRIGHTNESS:
-			ctrl->value = dec->brightness;
-			break;
-		case V4L2_CID_CONTRAST:
-			ctrl->value = dec->contrast;
-			break;
-		case V4L2_CID_SATURATION:
-			ctrl->value = dec->saturation;
-			break;
-		case V4L2_CID_HUE:
-			ctrl->value = dec->hue;
-			break;
-		}
-		break;
+	printk(
+	KERN_INFO"wis_tw2804: set_ctrl value:id=%d;value=%d",
+	ctrl->id,
+	ctrl->value);
+	switch (ctrl->id) {
+	case V4L2_CID_BRIGHTNESS:
+	dec->brightness = ctrl->value;
+	break;
+	case V4L2_CID_CONTRAST:
+	dec->contrast = ctrl->value;
+	break;
+	case V4L2_CID_SATURATION:
+	dec->saturation = ctrl->value;
+	break;
+	case V4L2_CID_HUE:
+	dec->hue = ctrl->value;
+	break;
+	default:
+	return -EINVAL;
 	}
+	return 0;
+}
+
+static int tw2804_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+{
+	struct wis_tw2804 *state = to_state(sd);
+	/*/ struct i2c_client *client=v4l2_get_subdevdata(sd);*/
+
+	switch (ctrl->id) {
+	case V4L2_CID_BRIGHTNESS:
+	ctrl->value = state->brightness;/*=read_reg(
+	client,
+	0x12,
+	state->channel);*/
+	break;
+	case V4L2_CID_CONTRAST:
+	ctrl->value = state->contrast;/*=read_reg(client,0x11,state->channel);*/
+	break;
+	case V4L2_CID_SATURATION:
+	ctrl->value = state->saturation;/*=read_reg(
+	client,
+	0x10,
+	state->channel);*/
+	break;
+	case V4L2_CID_HUE:
+	ctrl->value = state->hue;/*=read_reg(client,0x0f,state->channel);*/
+	break;
 	default:
-		break;
+	return -EINVAL;
 	}
 	return 0;
 }
 
+static int tw2804_s_std(struct v4l2_subdev *sd, v4l2_std_id norm)
+{
+	struct wis_tw2804 *dec = to_state(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+/*/      v4l2_std_id *input=arg;*/
+	u8 regs[] = {
+	0x01, norm&V4L2_STD_NTSC ? 0xc4 : 0x84,
+	0x09, norm&V4L2_STD_NTSC ? 0x07 : 0x04,
+	0x0a, norm&V4L2_STD_NTSC ? 0xf0 : 0x20,
+	0x0b, norm&V4L2_STD_NTSC ? 0x07 : 0x04,
+	0x0c, norm&V4L2_STD_NTSC ? 0xf0 : 0x20,
+	0x0d, norm&V4L2_STD_NTSC ? 0x40 : 0x4a,
+	0x16, norm&V4L2_STD_NTSC ? 0x00 : 0x40,
+	0x17, norm&V4L2_STD_NTSC ? 0x00 : 0x40,
+	0x20, norm&V4L2_STD_NTSC ? 0x07 : 0x0f,
+	0x21, norm&V4L2_STD_NTSC ? 0x07 : 0x0f,
+	0xff, 0xff,
+	};
+	write_regs(client, regs, dec->channel);
+	dec->norm = norm;
+	return 0;
+}
+
+static const struct v4l2_subdev_core_ops tw2804_core_ops = {
+	.log_status = tw2804_log_status,
+	.g_ctrl = tw2804_g_ctrl,
+	.s_ctrl = tw2804_s_ctrl,
+	.queryctrl = tw2804_queryctrl,
+	.s_std = tw2804_s_std,
+};
+
+/*
+static const struct v4l2_subdev_video_ops tw2804_video_ops = {
+  .s_routing = tw2804_s_video_routing,
+  .s_fmt = tw2804_s_fmt,
+};*/
+
+static const struct v4l2_subdev_ops tw2804_ops = {
+	.core = &tw2804_core_ops,
+/*/  .audio = &s2250_audio_ops,*/
+/*/  .video = &s2250_video_ops,*/
+};
+
 static int wis_tw2804_probe(struct i2c_client *client,
 			    const struct i2c_device_id *id)
 {
 	struct i2c_adapter *adapter = client->adapter;
 	struct wis_tw2804 *dec;
+	struct v4l2_subdev *sd;
 
+	printk(
+	KERN_DEBUG "wis_tw2804 :probing %s adapter %s",
+	id->name,
+	client->adapter->name);
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA))
 		return -ENODEV;
 
@@ -303,13 +391,20 @@ static int wis_tw2804_probe(struct i2c_client *client,
 	if (dec == NULL)
 		return -ENOMEM;
 
+	sd = &dec->sd;
 	dec->channel = -1;
 	dec->norm = V4L2_STD_NTSC;
 	dec->brightness = 128;
 	dec->contrast = 128;
 	dec->saturation = 128;
 	dec->hue = 128;
-	i2c_set_clientdata(client, dec);
+	v4l2_i2c_subdev_init(sd, client, &tw2804_ops);
+	v4l2_info(
+	sd,
+	"initializing %s at address 0x%x on %s\n",
+	"tw 2804",
+	client->addr,
+	client->adapter->name);
 
 	printk(KERN_DEBUG "wis-tw2804: creating TW2804 at address %d on %s\n",
 		client->addr, adapter->name);
@@ -319,9 +414,10 @@ static int wis_tw2804_probe(struct i2c_client *client,
 
 static int wis_tw2804_remove(struct i2c_client *client)
 {
-	struct wis_tw2804 *dec = i2c_get_clientdata(client);
-
-	kfree(dec);
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	printk(KERN_INFO"wis_tw2804: remove");
+	v4l2_device_unregister_subdev(sd);
+	kfree(to_state(sd));
 	return 0;
 }
 
diff --git a/scripts/correctpatch.pl b/scripts/correctpatch.pl
new file mode 100755
index 0000000..2bcf5ea
--- /dev/null
+++ b/scripts/correctpatch.pl
@@ -0,0 +1,269 @@
+#!/usr/bin/perl
+#***************************************************************************
+#*   Copyright (C) 2012 by volokh                                          *
+#*   my84@bk.ru                                                            *
+#*                                                                         *
+#*   This program is under GPL2 licence you may redistribute it and/or     *
+#*   modify                                                                *
+#*   Ligovskii 203-207, StPetersburg, Home Work, Russia                    *
+#***************************************************************************
+
+#use strict;
+
+my $File=0;
+my $DirOut="";#The Same directory to output
+my $NoWarn=0;
+my $NoError=0;
+my $Debug=0;
+
+local $MaxWidht=80;
+ 
+use Getopt::Long;
+# qw(:config no_auto_abbrev);
+
+GetOptions
+(
+  'dirout=s'=>\$DirOut
+  ,'nowarn'=>\$NoWarn
+  ,'noerror'=>\$NoError
+  ,'f|file'=>\$File
+  ,'debug'=>\$Debug
+);
+
+if($#ARGV<0)
+{
+  print "$0: no input files\n";
+  exit(1);
+}
+
+my $TmpFile=".corpach";
+
+if($ARGV[0]=~/([^\/]+)$/)
+{
+  $TmpFile.=".$1";
+}
+
+my $BaseDir;
+if($0=~/(.*)\/[^\/]+$/)
+{
+  $BaseDir=$1;
+}
+
+print "Try correct File Enter this file:$ARGV[0] file=$File to $TmpFile\n";
+print "\t\t\033[1;35mPlease, keep copy of your source.\n\tRun this script again while count of errors/warnings will be const.\033[0;39m\n";
+
+my @FileSource;
+if(ReadFile($ARGV[0],\@FileSource)==0)
+{
+  system("$BaseDir/checkpatch.pl ".($File ? "--file" : "")." --terse $ARGV[0] > $TmpFile");
+  my @ErrorsList;
+  if(ReadFile($TmpFile,\@ErrorsList)==0)
+  {
+    if($File)
+    {
+      CorrectSource($ARGV[0],\@ErrorsList,\@FileSource);
+      WriteFile($ARGV[0],\@FileSource);
+    }else
+    {
+      #todo Correct patch operations
+    }
+  }
+}
+
+unlink $TmpFile;
+
+exec("$BaseDir/checkpatch.pl ".($File ? "--file" : "")." $ARGV[0]");
+
+sub CorrectSource
+{
+  my ($File,$EList,$Source)=@_;
+  my $Offset=0;
+  foreach my $Item (@$EList)
+  {
+    my $FFile=$File;
+    $FFile=~s/(\W)/\\$1/g;
+    if($Item=~/$File:([0-9]+): (WARNING|ERROR): (.+)/)
+    {
+      my $Pos=int($1)+$Offset;
+      my $Type=$2;
+      my $Error=$3;
+      if($Debug!=0)
+      {
+        print "Find Error in File:".$File." in pos=".$1." with type ".$2.",with text=".$3."\n";
+        print "Source=".@$Source[$Pos-1]."\n";
+      }
+      if($Type eq "WARNING" && !$NoWarn)
+      {
+        ###############################################################
+        # It would be correctly if every error has its own error code #
+        ###############################################################
+        if($Error eq "please, no spaces at the start of a line")
+        {
+          if(@$Source[$Pos-1]=~/[^\s]/)
+          {
+            @$Source[$Pos-1]=~s/^\s*/\t/;
+          }
+        }elsif($Error eq "line over 80 characters")
+        {
+          my $Text=@$Source[$Pos-1];
+          #@$Source[$Pos-1]=~s#(\w+)|(//.+\s*)#defined $1 ? $1."\n\t" : $2#gse;
+          @$Source[$Pos-1]=~s#([,(])\s*|(//.+\s*)#defined $1 ? $1."\n\t" : $2#gse;
+        }elsif($Error=~/suspect code indent for conditional statements \(/)
+        {
+          my $BrOpen=0;
+          my $Text=@$Source[$Pos-1];
+          if($Text=~s/.*(if|for)//)
+          {
+            do
+            {
+              if($Text=~s/\(//)
+              {
+                $BrOpen++;
+              }elsif($Text=~s/\)//)
+              {
+                $BrOpen--;
+              }else
+              {
+                $Pos++;
+                $Text=@$Source[$Pos-1];
+              }
+            }while($BrOpen!=0);
+            if($BrOpen==0)
+            {
+              @$Source[$Pos]=~s/^(\t*)[ ]*/$1/;
+              @$Source[$Pos]="\t".@$Source[$Pos];
+#              if(@$Source[$Pos]=~s/^(.)//)
+ #             {
+  #            }
+            }
+          }
+        }
+      }elsif($Type eq "ERROR" && !$NoError)
+      {
+        if($Error=~/space required after that '(.)'/)
+        {
+          my $That=$1;
+          my $TThat=$That;
+          $TThat=~s/(\W)/\\$1/g;
+          @$Source[$Pos-1]=~s/$TThat([^\s])/$That $1/;
+        }elsif($Error=~/spaces required around that '(.+)'/)
+        {
+          my $That=$1;
+          my $TThat=$That;
+          $TThat=~s/(\W)/\\$1/g;
+          if(@$Source[$Pos-1]!~s/([^ \-<>!=])$TThat([^ <>=])/$1 $That $2/)#@$Source[$Pos-1]!~s/([^ ->])$TThat([^ ])/$1 $That $2/)
+          {
+            print "Can`t replace [$1] in [$2] and[$3] on ".@$Source[$Pos-1]." with [$That] on [$TThat]\n";
+          }
+        }elsif($Error eq "trailing whitespace")
+        {
+          @$Source[$Pos-1]=~s/[ ]+$//;
+        }elsif($Error eq "do not use C99 // comments")
+        {
+          @$Source[$Pos-1]=~s/\/\/(.*)/\/*$1*\//;
+        }elsif(($Error eq "that open brace { should be on the previous line") || ($Error=~/open brace '{' following (\w+) go on the same line/))
+        {
+          if(@$Source[$Pos-1]!~s/^(\s*){(\s*)//)
+          {
+            #This bug found correct (point to prev line instead real line)
+            $Pos++;
+            if(@$Source[$Pos-1]!~s/^(\s*){(\s*)//)
+            {
+              next;
+            }
+          }
+          @$Source[$Pos-2]=~s/[ ]*([\s]+)$/ {$1/;
+        }elsif($Error eq "space required before the open parenthesis '('")
+        {
+          @$Source[$Pos-1]=~s/([^\s])\(/$1 \(/;
+        }elsif($Error eq "code indent should use tabs where possible")
+        {
+          @$Source[$Pos-1]=~s/        /\t/g;
+        }elsif($Error eq "switch and case should be at the same indent")
+        {
+          my $BrOpen=0;
+          my $InSwitch=0;
+          my $Text=@$Source[$Pos-1];
+          if($Text=~s/([^\s]*)(\s*)switch(.)*\(.+\)//)
+          {
+            my $Spaces=$2;
+            do
+            {
+              if($BrOpen==1)
+              {
+                if(@$Source[$Pos-1]=~s/([^{}\s]*)(\s*)(case|default)([^:]*):/$1$Spaces$3$4:/)
+                {
+                }
+              }
+              if($Text=~s/\{//)
+              {
+                $BrOpen++;
+              }elsif($Text=~s/\}//)
+              {
+                $BrOpen--;
+              }else
+              {
+                $Pos++;
+                $Text=@$Source[$Pos-1];
+              }
+            }while($BrOpen!=0);# && $Pos<length(@$Source));
+          }
+        }elsif($Error=~/space prohibited before that '(.+)'/)
+        {
+          my $That=$1;
+          my $TThat=$That;
+          $TThat=~s/(\W)/\\$1/g;
+          @$Source[$Pos-1]=~s/\s$TThat/$That/;
+        }
+      }else
+      {
+        print "Nothing to correct at $File in $Pos position\n";
+      }
+    }
+  }
+}
+
+sub ReadFile
+{
+  my ($File,$InArrayRef)=@_;
+  if(!open(SRC,'<',"$File"))
+  {
+    print("\033[1;41mfile: \'$File\' not found for read\033[0;39m\n");
+    #die("file: '.$File.' not found\n");
+    return -1;
+  }
+  @$InArrayRef=<SRC>;
+  close(SRC);
+  return 0;
+}
+
+sub WriteFile
+{
+  my ($File,$InArrayRef)=@_;
+  if(!open(DST,'>',"$File"))
+  {
+    print("\033[1;41mfile: \'$File\' not found for write\033[0;39m\n");
+    #die("file: '.$File.' not found\n");
+    return -1;
+  }
+  print DST @$InArrayRef;
+  close(DST);
+  return 0;
+}
+
+my $Version='20.12.04';
+
+sub Help
+{
+  print "
+    Usage: $0 [OPTION] FILE
+    Version: $Version
+
+    Options:
+todo      --dirout=PATH                Use this temp PATH instead of ./
+      --file                       Input is a source file, otherwise it`s a patch
+      --nowarn                     No need correct warnings
+      --noerror                    No need correct errors
+      --debug                      Show debug messages
+  ";
+}
-- 
1.7.7.6



