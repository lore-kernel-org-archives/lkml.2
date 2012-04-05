Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab2DERw6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 13:52:58 -0400
Received: from oyp.chewa.net ([91.121.6.101]:46481 "EHLO oyp.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753135Ab2DERw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 13:52:56 -0400
From: =?UTF-8?q?R=C3=A9mi=20Denis-Courmont?= <remi@remlab.net>
To: mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC] [PATCH] v4l2: use unsigned rather than enums in ioctl() structs
Date: Thu,  5 Apr 2012 20:52:51 +0300
Message-Id: <1333648371-24812-1-git-send-email-remi@remlab.net>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With an enumeration, the compiler assumes that the integer value is one
allowed by the underlying enumeration type. With optimization enabled
this can result in byte code that is unable to cope with other values.
For instance, GCC can compile a switch() block using a "jump table" to
avoid repetitive conditional branching.

This can be a problem both from user to kernel and kernel to user.

* Evil user space can pass error values to the kernel via system
calls. There are no sane ways to protect the kernel: the compiler may
optimize away range checks if it deems that all legitimate values are
within the range.

* The kernel can break the user space binary interface whenever a new
value is added to an existing enumeration. A newer kernel can then
return an enumerated value that was not allowed by older kernel headers
against which the user program was compiled. In principles, V4L2 user
space needs to be recompiled whenever videodev2.h has updated enums...
(This an obvious problem with V4L2_QUERYCTRL.)

Fortunately, the Linux ABI disables short-enums on all platforms. Even
the Linux variant of the ARM AAPCS contradicts the standard ARM AAPCS
in doing so.

Signed-off-by: Rémi Denis-Courmont <remi@remlab.net>
---
 include/linux/videodev2.h |   42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index c9c9a46..df3b8f0 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -292,10 +292,10 @@ struct v4l2_pix_format {
 	__u32         		width;
 	__u32			height;
 	__u32			pixelformat;
-	enum v4l2_field  	field;
+	unsigned		field;
 	__u32            	bytesperline;	/* for padding, zero if unused */
 	__u32          		sizeimage;
-	enum v4l2_colorspace	colorspace;
+	unsigned		colorspace;
 	__u32			priv;		/* private data, depends on pixelformat */
 };
 
@@ -432,7 +432,7 @@ struct v4l2_pix_format {
  */
 struct v4l2_fmtdesc {
 	__u32		    index;             /* Format number      */
-	enum v4l2_buf_type  type;              /* buffer type        */
+	unsigned	    type;              /* buffer type        */
 	__u32               flags;
 	__u8		    description[32];   /* Description string */
 	__u32		    pixelformat;       /* Format fourcc      */
@@ -573,8 +573,8 @@ struct v4l2_jpegcompression {
  */
 struct v4l2_requestbuffers {
 	__u32			count;
-	enum v4l2_buf_type      type;
-	enum v4l2_memory        memory;
+	unsigned		type;
+	unsigned		memory;
 	__u32			reserved[2];
 };
 
@@ -636,16 +636,16 @@ struct v4l2_plane {
  */
 struct v4l2_buffer {
 	__u32			index;
-	enum v4l2_buf_type      type;
+	unsigned		type;
 	__u32			bytesused;
 	__u32			flags;
-	enum v4l2_field		field;
+	unsigned		field;
 	struct timeval		timestamp;
 	struct v4l2_timecode	timecode;
 	__u32			sequence;
 
 	/* memory location */
-	enum v4l2_memory        memory;
+	unsigned		memory;
 	union {
 		__u32           offset;
 		unsigned long   userptr;
@@ -708,7 +708,7 @@ struct v4l2_clip {
 
 struct v4l2_window {
 	struct v4l2_rect        w;
-	enum v4l2_field  	field;
+	unsigned		field;
 	__u32			chromakey;
 	struct v4l2_clip	__user *clips;
 	__u32			clipcount;
@@ -745,14 +745,14 @@ struct v4l2_outputparm {
  *	I N P U T   I M A G E   C R O P P I N G
  */
 struct v4l2_cropcap {
-	enum v4l2_buf_type      type;
+	unsigned		type;
 	struct v4l2_rect        bounds;
 	struct v4l2_rect        defrect;
 	struct v4l2_fract       pixelaspect;
 };
 
 struct v4l2_crop {
-	enum v4l2_buf_type      type;
+	unsigned		type;
 	struct v4l2_rect        c;
 };
 
@@ -1156,7 +1156,7 @@ enum v4l2_ctrl_type {
 /*  Used in the VIDIOC_QUERYCTRL ioctl for querying controls */
 struct v4l2_queryctrl {
 	__u32		     id;
-	enum v4l2_ctrl_type  type;
+	unsigned	     type;
 	__u8		     name[32];	/* Whatever */
 	__s32		     minimum;	/* Note signedness */
 	__s32		     maximum;
@@ -1788,7 +1788,7 @@ enum v4l2_jpeg_chroma_subsampling {
 struct v4l2_tuner {
 	__u32                   index;
 	__u8			name[32];
-	enum v4l2_tuner_type    type;
+	unsigned		type;
 	__u32			capability;
 	__u32			rangelow;
 	__u32			rangehigh;
@@ -1838,14 +1838,14 @@ struct v4l2_modulator {
 
 struct v4l2_frequency {
 	__u32		      tuner;
-	enum v4l2_tuner_type  type;
+	unsigned	      type;
 	__u32		      frequency;
 	__u32		      reserved[8];
 };
 
 struct v4l2_hw_freq_seek {
 	__u32		      tuner;
-	enum v4l2_tuner_type  type;
+	unsigned	      type;
 	__u32		      seek_upward;
 	__u32		      wrap_around;
 	__u32		      spacing;
@@ -2056,7 +2056,7 @@ struct v4l2_sliced_vbi_cap {
 				 (equals frame lines 313-336 for 625 line video
 				  standards, 263-286 for 525 line standards) */
 	__u16   service_lines[2][24];
-	enum v4l2_buf_type type;
+	unsigned type;
 	__u32   reserved[3];    /* must be 0 */
 };
 
@@ -2146,8 +2146,8 @@ struct v4l2_pix_format_mplane {
 	__u32				width;
 	__u32				height;
 	__u32				pixelformat;
-	enum v4l2_field			field;
-	enum v4l2_colorspace		colorspace;
+	unsigned			field;
+	unsigned			colorspace;
 
 	struct v4l2_plane_pix_format	plane_fmt[VIDEO_MAX_PLANES];
 	__u8				num_planes;
@@ -2165,7 +2165,7 @@ struct v4l2_pix_format_mplane {
  * @raw_data:	placeholder for future extensions and custom formats
  */
 struct v4l2_format {
-	enum v4l2_buf_type type;
+	unsigned type;
 	union {
 		struct v4l2_pix_format		pix;     /* V4L2_BUF_TYPE_VIDEO_CAPTURE */
 		struct v4l2_pix_format_mplane	pix_mp;  /* V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE */
@@ -2179,7 +2179,7 @@ struct v4l2_format {
 /*	Stream type-dependent parameters
  */
 struct v4l2_streamparm {
-	enum v4l2_buf_type type;
+	unsigned type;
 	union {
 		struct v4l2_captureparm	capture;
 		struct v4l2_outputparm	output;
@@ -2299,7 +2299,7 @@ struct v4l2_dbg_chip_ident {
 struct v4l2_create_buffers {
 	__u32			index;
 	__u32			count;
-	enum v4l2_memory        memory;
+	unsigned		memory;
 	struct v4l2_format	format;
 	__u32			reserved[8];
 };
-- 
1.7.9.5

