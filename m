Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab2EEK0C (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 06:26:02 -0400
Received: from smtp.nokia.com ([147.243.1.48]:27988 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752170Ab2EEK0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 06:26:00 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, mchehab@redhat.com, remi@remlab.net
Subject: [PATCH 1/1] v4l2: use __u32 rather than enums in ioctl() structs
Date: Sat,  5 May 2012 13:25:45 +0300
Message-Id: <1336213545-8549-1-git-send-email-sakari.ailus@iki.fi>
X-Mailer: git-send-email 1.7.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rémi Denis-Courmont <remi@remlab.net>

V4L2 uses the enum type in IOCTL arguments in IOCTLs that were defined until
the use of enum was considered less than ideal. Recently Rémi Denis-Courmont
brought up the issue by proposing a patch to convert the enums to unsigned:

<URL:http://www.spinics.net/lists/linux-media/msg46167.html>

This sparked a long discussion where another solution to the issue was
proposed: two sets of IOCTL structures, one with __u32 and the other with
enums, and conversion code between the two:

<URL:http://www.spinics.net/lists/linux-media/msg47168.html>

Both approaches implement a complete solution that resolves the problem. The
first one is simple but requires assuming enums and __u32 are the same in
size (so we won't break the ABI) while the second one is more complex and
less clean but does not require making that assumption.

The issue boils down to whether enums are fundamentally different from __u32
or not, and can the former be substituted by the latter. During the
discussion it was concluded that the __u32 has the same size as enums on all
archs Linux is supported: it has not been shown that replacing those enums
in IOCTL arguments would break neither source or binary compatibility. If no
such reason is found, just replacing the enums with __u32s is the way to go.

This is what this patch does. This patch is slightly different from Remi's
first RFC (link above): it uses __u32 instead of unsigned and also changes
the arguments of VIDIOC_G_PRIORITY and VIDIOC_S_PRIORITY.

Signed-off-by: Rémi Denis-Courmont <remi@remlab.net>
Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 include/linux/videodev2.h |   46 ++++++++++++++++++++++----------------------
 1 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 5a09ac3..585e4b4 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -292,10 +292,10 @@ struct v4l2_pix_format {
 	__u32         		width;
 	__u32			height;
 	__u32			pixelformat;
-	enum v4l2_field  	field;
+	__u32			field;
 	__u32            	bytesperline;	/* for padding, zero if unused */
 	__u32          		sizeimage;
-	enum v4l2_colorspace	colorspace;
+	__u32			colorspace;
 	__u32			priv;		/* private data, depends on pixelformat */
 };
 
@@ -432,7 +432,7 @@ struct v4l2_pix_format {
  */
 struct v4l2_fmtdesc {
 	__u32		    index;             /* Format number      */
-	enum v4l2_buf_type  type;              /* buffer type        */
+	__u32		    type;              /* buffer type        */
 	__u32               flags;
 	__u8		    description[32];   /* Description string */
 	__u32		    pixelformat;       /* Format fourcc      */
@@ -573,8 +573,8 @@ struct v4l2_jpegcompression {
  */
 struct v4l2_requestbuffers {
 	__u32			count;
-	enum v4l2_buf_type      type;
-	enum v4l2_memory        memory;
+	__u32			type;
+	__u32			memory;
 	__u32			reserved[2];
 };
 
@@ -636,16 +636,16 @@ struct v4l2_plane {
  */
 struct v4l2_buffer {
 	__u32			index;
-	enum v4l2_buf_type      type;
+	__u32			type;
 	__u32			bytesused;
 	__u32			flags;
-	enum v4l2_field		field;
+	__u32			field;
 	struct timeval		timestamp;
 	struct v4l2_timecode	timecode;
 	__u32			sequence;
 
 	/* memory location */
-	enum v4l2_memory        memory;
+	__u32			memory;
 	union {
 		__u32           offset;
 		unsigned long   userptr;
@@ -708,7 +708,7 @@ struct v4l2_clip {
 
 struct v4l2_window {
 	struct v4l2_rect        w;
-	enum v4l2_field  	field;
+	__u32			field;
 	__u32			chromakey;
 	struct v4l2_clip	__user *clips;
 	__u32			clipcount;
@@ -745,14 +745,14 @@ struct v4l2_outputparm {
  *	I N P U T   I M A G E   C R O P P I N G
  */
 struct v4l2_cropcap {
-	enum v4l2_buf_type      type;
+	__u32			type;
 	struct v4l2_rect        bounds;
 	struct v4l2_rect        defrect;
 	struct v4l2_fract       pixelaspect;
 };
 
 struct v4l2_crop {
-	enum v4l2_buf_type      type;
+	__u32			type;
 	struct v4l2_rect        c;
 };
 
@@ -1157,7 +1157,7 @@ enum v4l2_ctrl_type {
 /*  Used in the VIDIOC_QUERYCTRL ioctl for querying controls */
 struct v4l2_queryctrl {
 	__u32		     id;
-	enum v4l2_ctrl_type  type;
+	__u32		     type;
 	__u8		     name[32];	/* Whatever */
 	__s32		     minimum;	/* Note signedness */
 	__s32		     maximum;
@@ -1792,7 +1792,7 @@ enum v4l2_jpeg_chroma_subsampling {
 struct v4l2_tuner {
 	__u32                   index;
 	__u8			name[32];
-	enum v4l2_tuner_type    type;
+	__u32			type;
 	__u32			capability;
 	__u32			rangelow;
 	__u32			rangehigh;
@@ -1842,14 +1842,14 @@ struct v4l2_modulator {
 
 struct v4l2_frequency {
 	__u32		      tuner;
-	enum v4l2_tuner_type  type;
+	__u32		      type;
 	__u32		      frequency;
 	__u32		      reserved[8];
 };
 
 struct v4l2_hw_freq_seek {
 	__u32		      tuner;
-	enum v4l2_tuner_type  type;
+	__u32		      type;
 	__u32		      seek_upward;
 	__u32		      wrap_around;
 	__u32		      spacing;
@@ -2060,7 +2060,7 @@ struct v4l2_sliced_vbi_cap {
 				 (equals frame lines 313-336 for 625 line video
 				  standards, 263-286 for 525 line standards) */
 	__u16   service_lines[2][24];
-	enum v4l2_buf_type type;
+	__u32	type;
 	__u32   reserved[3];    /* must be 0 */
 };
 
@@ -2150,8 +2150,8 @@ struct v4l2_pix_format_mplane {
 	__u32				width;
 	__u32				height;
 	__u32				pixelformat;
-	enum v4l2_field			field;
-	enum v4l2_colorspace		colorspace;
+	__u32				field;
+	__u32				colorspace;
 
 	struct v4l2_plane_pix_format	plane_fmt[VIDEO_MAX_PLANES];
 	__u8				num_planes;
@@ -2169,7 +2169,7 @@ struct v4l2_pix_format_mplane {
  * @raw_data:	placeholder for future extensions and custom formats
  */
 struct v4l2_format {
-	enum v4l2_buf_type type;
+	__u32	 type;
 	union {
 		struct v4l2_pix_format		pix;     /* V4L2_BUF_TYPE_VIDEO_CAPTURE */
 		struct v4l2_pix_format_mplane	pix_mp;  /* V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE */
@@ -2183,7 +2183,7 @@ struct v4l2_format {
 /*	Stream type-dependent parameters
  */
 struct v4l2_streamparm {
-	enum v4l2_buf_type type;
+	__u32	 type;
 	union {
 		struct v4l2_captureparm	capture;
 		struct v4l2_outputparm	output;
@@ -2303,7 +2303,7 @@ struct v4l2_dbg_chip_ident {
 struct v4l2_create_buffers {
 	__u32			index;
 	__u32			count;
-	enum v4l2_memory        memory;
+	__u32			memory;
 	struct v4l2_format	format;
 	__u32			reserved[8];
 };
@@ -2360,8 +2360,8 @@ struct v4l2_create_buffers {
 #define VIDIOC_TRY_FMT      	_IOWR('V', 64, struct v4l2_format)
 #define VIDIOC_ENUMAUDIO	_IOWR('V', 65, struct v4l2_audio)
 #define VIDIOC_ENUMAUDOUT	_IOWR('V', 66, struct v4l2_audioout)
-#define VIDIOC_G_PRIORITY        _IOR('V', 67, enum v4l2_priority)
-#define VIDIOC_S_PRIORITY        _IOW('V', 68, enum v4l2_priority)
+#define VIDIOC_G_PRIORITY	 _IOR('V', 67, __u32)
+#define VIDIOC_S_PRIORITY	 _IOW('V', 68, __u32)
 #define VIDIOC_G_SLICED_VBI_CAP _IOWR('V', 69, struct v4l2_sliced_vbi_cap)
 #define VIDIOC_LOG_STATUS         _IO('V', 70)
 #define VIDIOC_G_EXT_CTRLS	_IOWR('V', 71, struct v4l2_ext_controls)
-- 
1.7.2.5

