Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759952Ab1D0Ug0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 16:36:26 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:38463 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759910Ab1D0UgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 16:36:24 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Subject: [PATCH 2/4] usbvision: remove broken YUV format conversion
Date: Wed, 27 Apr 2011 22:36:13 +0200
User-Agent: KMail/1.9.10
Cc: "Hans de Goede" <hdegoede@redhat.com>,
        "Joerg Heckenbach" <joerg@heckenbach-aw.de>,
        "Dwaine Garden" <dwainegarden@rogers.com>, linux-media@vger.kernel.org,
        "Kernel development list" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201104272236.17852.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The YVU420 and YUV422P formats are broken and cause kernel panic on use.
(YVU420 does not work and sometimes causes "unable to handle paging request"
panic, YUV422P always causes "NULL pointer dereference").

As V4L2 spec says that drivers shouldn't do any in-kernel image format
conversion, just remove the broken formats.

The removal also reveals an off-by-one bug in enum_fmt ioctl - it misses the
last format, so this patch fixes it too.

This allows the driver to work with mplayer without need to manually specify a
format and also to work with VLC without causing kernel panic.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

diff -up linux-2.6.39-rc2-/drivers/media/video/usbvision/usbvision-core.c linux-2.6.39-rc2/drivers/media/video/usbvision/usbvision-core.c
--- linux-2.6.39-rc2-/drivers/media/video/usbvision/usbvision-core.c	2011-04-27 22:05:39.000000000 +0200
+++ linux-2.6.39-rc2/drivers/media/video/usbvision/usbvision-core.c	2011-04-27 22:06:28.000000000 +0200
@@ -801,12 +801,7 @@ static enum parse_state usbvision_parse_
 
 	frame = usbvision->cur_frame;
 	image_size = frame->frmwidth * frame->frmheight;
-	if ((frame->v4l2_format.format == V4L2_PIX_FMT_YUV422P) ||
-	    (frame->v4l2_format.format == V4L2_PIX_FMT_YVU420)) {       /* this is a planar format */
-		/* ... v4l2_linesize not used here. */
-		f = frame->data + (frame->width * frame->curline);
-	} else
-		f = frame->data + (frame->v4l2_linesize * frame->curline);
+	f = frame->data + (frame->v4l2_linesize * frame->curline);
 
 	if (frame->v4l2_format.format == V4L2_PIX_FMT_YUYV) { /* initialise u and v pointers */
 		/* get base of u and b planes add halfoffset */
@@ -814,9 +809,6 @@ static enum parse_state usbvision_parse_
 			+ image_size
 			+ (frame->frmwidth >> 1) * frame->curline;
 		v = u + (image_size >> 1);
-	} else if (frame->v4l2_format.format == V4L2_PIX_FMT_YVU420) {
-		v = frame->data + image_size + ((frame->curline * (frame->width)) >> 2);
-		u = v + (image_size >> 2);
 	}
 
 	if (frame->curline == 0)
@@ -891,20 +883,6 @@ static enum parse_state usbvision_parse_
 		if (frame->v4l2_format.format == V4L2_PIX_FMT_YUYV) {
 			*f++ = Y[idx];
 			*f++ = idx & 0x01 ? U[idx / 2] : V[idx / 2];
-		} else if (frame->v4l2_format.format == V4L2_PIX_FMT_YUV422P) {
-			*f++ = Y[idx];
-			if (idx & 0x01)
-				*u++ = U[idx >> 1];
-			else
-				*v++ = V[idx >> 1];
-		} else if (frame->v4l2_format.format == V4L2_PIX_FMT_YVU420) {
-			*f++ = Y[idx];
-			if (!((idx & 0x01) | (frame->curline & 0x01))) {
-				/* only need do this for 1 in 4 pixels */
-				/* intraframe buffer is YUV420 format */
-				*u++ = U[idx >> 1];
-				*v++ = V[idx >> 1];
-			}
 		} else {
 			YUV_TO_RGB_BY_THE_BOOK(Y[idx], U[idx / 2], V[idx / 2], rv, gv, bv);
 			switch (frame->v4l2_format.format) {
@@ -938,11 +916,7 @@ static enum parse_state usbvision_parse_
 		}
 		clipmask_index++;
 	}
-	/* Deal with non-integer no. of bytes for YUV420P */
-	if (frame->v4l2_format.format != V4L2_PIX_FMT_YVU420)
-		*pcopylen += frame->v4l2_linesize;
-	else
-		*pcopylen += frame->curline & 0x01 ? frame->v4l2_linesize : frame->v4l2_linesize << 1;
+	*pcopylen += frame->v4l2_linesize;
 
 	frame->curline += 1;
 
diff -up linux-2.6.39-rc2-/drivers/media/video/usbvision/usbvision-video.c linux-2.6.39-rc2/drivers/media/video/usbvision/usbvision-video.c
--- linux-2.6.39-rc2-/drivers/media/video/usbvision/usbvision-video.c	2011-04-27 22:05:39.000000000 +0200
+++ linux-2.6.39-rc2/drivers/media/video/usbvision/usbvision-video.c	2011-04-27 22:06:28.000000000 +0200
@@ -118,8 +118,6 @@ static struct usbvision_v4l2_format_st u
 	{ 1, 4, 32, V4L2_PIX_FMT_RGB32   , "RGB32" },
 	{ 1, 2, 16, V4L2_PIX_FMT_RGB555  , "RGB555" },
 	{ 1, 2, 16, V4L2_PIX_FMT_YUYV    , "YUV422" },
-	{ 1, 2, 12, V4L2_PIX_FMT_YVU420  , "YUV420P" }, /* 1.5 ! */
-	{ 1, 2, 16, V4L2_PIX_FMT_YUV422P , "YUV422P" }
 };
 
 /* Function prototypes */
@@ -888,7 +886,7 @@ static int vidioc_streamoff(struct file
 static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
 					struct v4l2_fmtdesc *vfd)
 {
-	if (vfd->index >= USBVISION_SUPPORTED_PALETTES - 1)
+	if (vfd->index > USBVISION_SUPPORTED_PALETTES - 1)
 		return -EINVAL;
 	strcpy(vfd->description, usbvision_v4l2_format[vfd->index].desc);
 	vfd->pixelformat = usbvision_v4l2_format[vfd->index].format;
@@ -1659,13 +1657,6 @@ static int __init usbvision_init(void)
 	PDEBUG(DBG_PROBE, "PROBE   debugging is enabled [video]");
 	PDEBUG(DBG_MMAP, "MMAP    debugging is enabled [video]");
 
-	/* disable planar mode support unless compression enabled */
-	if (isoc_mode != ISOC_MODE_COMPRESS) {
-		/* FIXME : not the right way to set supported flag */
-		usbvision_v4l2_format[6].supported = 0; /* V4L2_PIX_FMT_YVU420 */
-		usbvision_v4l2_format[7].supported = 0; /* V4L2_PIX_FMT_YUV422P */
-	}
-
 	err_code = usb_register(&usbvision_driver);
 
 	if (err_code == 0) {


-- 
Ondrej Zary
