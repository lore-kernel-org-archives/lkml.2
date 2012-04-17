Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab2DQRvU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 13:51:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753593Ab2DQRvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 13:51:18 -0400
Message-ID: <4F8DAD82.4000608@redhat.com>
Date: Tue, 17 Apr 2012 14:50:58 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: =?UTF-8?B?UsOpbWkgRGVuaXMtQ291cm1vbnQ=?= <remi@remlab.net>
CC: James Courtier-Dutton <james.dutton@gmail.com>, mchehab@infradead.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC] [PATCH] v4l2: use unsigned rather than enums in ioctl()
 structs
References: <1333648371-24812-1-git-send-email-remi@remlab.net> <4F85B908.4070404@redhat.com> <201204112147.55348.remi@remlab.net> <CAAMvbhHviuwC0ik2ZY91ZgN4hZyqUbuk=qVcAOH0VYMhva4LeA@mail.gmail.com> <4F86ECD0.6060708@redhat.com> <0c4d0f509a99540d87224c05fd27d322@chewa.net>
In-Reply-To: <0c4d0f509a99540d87224c05fd27d322@chewa.net>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Apr 2012 11:55:12 -0300, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> I can see only two viable fixes for it:
>
> 1) add a typedef for the enum, using the sizeof(enum) in order to select
> the
> size of the used integer.
>
> Pros:
> 	- Patch is easy to write/easy to review;
> 	- Won't change the struct size, so applications compiled without
> 	  strong gcc optimization won't break;
> Cons:
> 	- It will add a typedef, with is ugly;
> 	- struct size on 32 bits will be different thant he size on 64 bits
> 	  (not really an issue, as v4l2-compat32 will handle that;
> 	- v4l2-compat32 code may require changes.
>
> 2) just replace it by a 32 bits integer.
>
> Pros:
> 	- no typedefs;
> 	- struct size won't change between 32/64 bits (except when they also
> 	  have pointers);
> Cons:
> 	- will break ABI. So, a compat code is required;
> 	- will require a "videodev2.h" fork for the legacy API with the enum's;
> 	- will require a compat code to convert from enum into integer and
> 	  vice-versa.


After reflecting about that, I think that (2) is better at long term. Doing it
won't be easy, as there are 24 ioctl's affected by enum's (if I didn't forget
anything - please double check!).

We'll need to patch for videodev2.h, v4l2-ioctl.h and v4l2-compat-ioctl32.c,
in order to add the compatibility code for handling the old API calls.

If done well, this could be an opportunity to cleanup the code at v4l2-compat-ioctl32.c,
as, i thesis, only structures with pointers would need compat bits, but the
current implementation forces a compatibility code for everything.

Anyway, the first step is something like the patch bellow.

Comments are welcome.

Regards,
Mauro

[RFC] [media] videodev2: don't use enum's at the public API.

Enum size is not portable and g++ might try to do wrong optimizations
with it.

PS.: Patch is incomplete, as the compatibility bits aren't there. 

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index e69cacc..37443a9 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -292,10 +292,10 @@ struct v4l2_pix_format {
 	__u32         		width;
 	__u32			height;
 	__u32			pixelformat;
-	enum v4l2_field  	field;
+	__u32		  	field;		/* enum v4l2_field */
 	__u32            	bytesperline;	/* for padding, zero if unused */
 	__u32          		sizeimage;
-	enum v4l2_colorspace	colorspace;
+	__u32			colorspace;	/* enum v4l2_colorspace */
 	__u32			priv;		/* private data, depends on pixelformat */
 };
 
@@ -432,7 +432,7 @@ struct v4l2_pix_format {
  */
 struct v4l2_fmtdesc {
 	__u32		    index;             /* Format number      */
-	enum v4l2_buf_type  type;              /* buffer type        */
+	__u32		  type;                /* buffer type (enum v4l2_buf_type) */
 	__u32               flags;
 	__u8		    description[32];   /* Description string */
 	__u32		    pixelformat;       /* Format fourcc      */
@@ -573,8 +573,8 @@ struct v4l2_jpegcompression {
  */
 struct v4l2_requestbuffers {
 	__u32			count;
-	enum v4l2_buf_type      type;
-	enum v4l2_memory        memory;
+	__u32		      type;		/* enum v4l2_buf_type */
+	__u32		        memory;		/* enum v4l2_memory */
 	__u32			reserved[2];
 };
 
@@ -636,16 +636,16 @@ struct v4l2_plane {
  */
 struct v4l2_buffer {
 	__u32			index;
-	enum v4l2_buf_type      type;
+	__u32			type;		/* enum v4l2_buf_type */
 	__u32			bytesused;
 	__u32			flags;
-	enum v4l2_field		field;
+	__u32			field;		/* enum v4l2_field */
 	struct timeval		timestamp;
 	struct v4l2_timecode	timecode;
 	__u32			sequence;
 
 	/* memory location */
-	enum v4l2_memory        memory;
+	__u32		        memory;		/* enum v4l2_memory */
 	union {
 		__u32           offset;
 		unsigned long   userptr;
@@ -708,7 +708,7 @@ struct v4l2_clip {
 
 struct v4l2_window {
 	struct v4l2_rect        w;
-	enum v4l2_field  	field;
+	__u32			field;		/* enum v4l2_field */
 	__u32			chromakey;
 	struct v4l2_clip	__user *clips;
 	__u32			clipcount;
@@ -745,14 +745,14 @@ struct v4l2_outputparm {
  *	I N P U T   I M A G E   C R O P P I N G
  */
 struct v4l2_cropcap {
-	enum v4l2_buf_type      type;
+	__u32			type;		/* enum v4l2_buf_type */
 	struct v4l2_rect        bounds;
 	struct v4l2_rect        defrect;
 	struct v4l2_fract       pixelaspect;
 };
 
 struct v4l2_crop {
-	enum v4l2_buf_type      type;
+	__u32			type;		/* enum v4l2_buf_type */
 	struct v4l2_rect        c;
 };
 
@@ -1157,7 +1157,7 @@ enum v4l2_ctrl_type {
 /*  Used in the VIDIOC_QUERYCTRL ioctl for querying controls */
 struct v4l2_queryctrl {
 	__u32		     id;
-	enum v4l2_ctrl_type  type;
+	__u32		     type;	/* enum v4l2_ctrl_type */
 	__u8		     name[32];	/* Whatever */
 	__s32		     minimum;	/* Note signedness */
 	__s32		     maximum;
@@ -1792,7 +1792,7 @@ enum v4l2_jpeg_chroma_subsampling {
 struct v4l2_tuner {
 	__u32                   index;
 	__u8			name[32];
-	enum v4l2_tuner_type    type;
+	__u32			type;		/* enum v4l2_tuner_type */
 	__u32			capability;
 	__u32			rangelow;
 	__u32			rangehigh;
@@ -1842,14 +1842,14 @@ struct v4l2_modulator {
 
 struct v4l2_frequency {
 	__u32		      tuner;
-	enum v4l2_tuner_type  type;
+	__u32		      type;		/* enum v4l2_tuner_type */
 	__u32		      frequency;
 	__u32		      reserved[8];
 };
 
 struct v4l2_hw_freq_seek {
 	__u32		      tuner;
-	enum v4l2_tuner_type  type;
+	__u32		      type;		/* enum v4l2_tuner_type */
 	__u32		      seek_upward;
 	__u32		      wrap_around;
 	__u32		      spacing;
@@ -2060,7 +2060,7 @@ struct v4l2_sliced_vbi_cap {
 				 (equals frame lines 313-336 for 625 line video
 				  standards, 263-286 for 525 line standards) */
 	__u16   service_lines[2][24];
-	enum v4l2_buf_type type;
+	__u32	 type;		/* enum v4l2_buf_type */
 	__u32   reserved[3];    /* must be 0 */
 };
 
@@ -2150,8 +2150,8 @@ struct v4l2_pix_format_mplane {
 	__u32				width;
 	__u32				height;
 	__u32				pixelformat;
-	enum v4l2_field			field;
-	enum v4l2_colorspace		colorspace;
+	__u32				field;		/* enum v4l2_field */
+	__u32				colorspace;	/* enum v4l2_colorspace */
 
 	struct v4l2_plane_pix_format	plane_fmt[VIDEO_MAX_PLANES];
 	__u8				num_planes;
@@ -2169,7 +2169,7 @@ struct v4l2_pix_format_mplane {
  * @raw_data:	placeholder for future extensions and custom formats
  */
 struct v4l2_format {
-	enum v4l2_buf_type type;
+	__u32	type;		/* enum v4l2_buf_type */
 	union {
 		struct v4l2_pix_format		pix;     /* V4L2_BUF_TYPE_VIDEO_CAPTURE */
 		struct v4l2_pix_format_mplane	pix_mp;  /* V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE */
@@ -2183,7 +2183,7 @@ struct v4l2_format {
 /*	Stream type-dependent parameters
  */
 struct v4l2_streamparm {
-	enum v4l2_buf_type type;
+	__u32	type;		/* enum v4l2_buf_type */
 	union {
 		struct v4l2_captureparm	capture;
 		struct v4l2_outputparm	output;
@@ -2303,7 +2303,7 @@ struct v4l2_dbg_chip_ident {
 struct v4l2_create_buffers {
 	__u32			index;
 	__u32			count;
-	enum v4l2_memory        memory;
+	__u32		        memory;		/* enum v4l2_memory */
 	struct v4l2_format	format;
 	__u32			reserved[8];
 };
@@ -2417,4 +2417,213 @@ struct v4l2_create_buffers {
 
 #define BASE_VIDIOC_PRIVATE	192		/* 192-255 are private */
 
+/*
+ * Backward-compatible IOCTL's to be used by V4L2 core to work with the
+ * old ioctl's defined with "enum's" inside the structures
+ */
+
+#ifdef CONFIG_V4L2_COMPAT
+
+struct v4l2_pix_format_enum {
+	__u32         		width;
+	__u32			height;
+	__u32			pixelformat;
+	enum v4l2_field  	field;
+	__u32            	bytesperline;	/* for padding, zero if unused */
+	__u32          		sizeimage;
+	enum v4l2_colorspace	colorspace;
+	__u32			priv;		/* private data, depends on pixelformat */
+};
+
+struct v4l2_fmtdesc_enum {
+	__u32		    index;             /* Format number      */
+	enum v4l2_buf_type  type;              /* buffer type        */
+	__u32               flags;
+	__u8		    description[32];   /* Description string */
+	__u32		    pixelformat;       /* Format fourcc      */
+	__u32		    reserved[4];
+};
+
+struct v4l2_requestbuffers_enum {
+	__u32			count;
+	enum v4l2_buf_type      type;
+	enum v4l2_memory        memory;
+	__u32			reserved[2];
+};
+
+struct v4l2_buffer_enum {
+	__u32			index;
+	enum v4l2_buf_type      type;
+	__u32			bytesused;
+	__u32			flags;
+	enum v4l2_field		field;
+	struct timeval		timestamp;
+	struct v4l2_timecode	timecode;
+	__u32			sequence;
+
+	/* memory location */
+	enum v4l2_memory        memory;
+	union {
+		__u32           offset;
+		unsigned long   userptr;
+		struct v4l2_plane *planes;
+	} m;
+	__u32			length;
+	__u32			input;
+	__u32			reserved;
+};
+
+struct v4l2_framebuffer_enum {
+	__u32			capability;
+	__u32			flags;
+/* FIXME: in theory we should pass something like PCI device + memory
+ * region + offset instead of some physical address */
+	void                    *base;
+	struct v4l2_pix_format_enum	fmt;
+};
+
+struct v4l2_window_enum {
+	struct v4l2_rect        w;
+	enum v4l2_field  	field;
+	__u32			chromakey;
+	struct v4l2_clip	__user *clips;
+	__u32			clipcount;
+	void			__user *bitmap;
+	__u8                    global_alpha;
+};
+
+struct v4l2_crop_enumcap_enum {
+	enum v4l2_buf_type      type;
+	struct v4l2_rect        bounds;
+	struct v4l2_rect        defrect;
+	struct v4l2_fract       pixelaspect;
+};
+
+struct v4l2_crop_enum {
+	enum v4l2_buf_type      type;
+	struct v4l2_rect        c;
+};
+
+struct v4l2_queryctrl_enum {
+	__u32		     id;
+	enum v4l2_ctrl_type  type;
+	__u8		     name[32];	/* Whatever */
+	__s32		     minimum;	/* Note signedness */
+	__s32		     maximum;
+	__s32		     step;
+	__s32		     default_value;
+	__u32                flags;
+	__u32		     reserved[2];
+};
+
+struct v4l2_tuner_enum {
+	__u32                   index;
+	__u8			name[32];
+	enum v4l2_tuner_type    type;
+	__u32			capability;
+	__u32			rangelow;
+	__u32			rangehigh;
+	__u32			rxsubchans;
+	__u32			audmode;
+	__s32			signal;
+	__s32			afc;
+	__u32			reserved[4];
+};
+
+struct v4l2_frequency_enum {
+	__u32		      tuner;
+	enum v4l2_tuner_type  type;
+	__u32		      frequency;
+	__u32		      reserved[8];
+};
+
+struct v4l2_hw_freq_seek_enum {
+	__u32		      tuner;
+	enum v4l2_tuner_type  type;
+	__u32		      seek_upward;
+	__u32		      wrap_around;
+	__u32		      spacing;
+	__u32		      reserved[7];
+};
+
+struct v4l2_sliced_vbi_cap_enum {
+	__u16   service_set;
+	/* service_lines[0][...] specifies lines 0-23 (1-23 used) of the first field
+	   service_lines[1][...] specifies lines 0-23 (1-23 used) of the second field
+				 (equals frame lines 313-336 for 625 line video
+				  standards, 263-286 for 525 line standards) */
+	__u16   service_lines[2][24];
+	enum v4l2_buf_type type;
+	__u32   reserved[3];    /* must be 0 */
+};
+
+struct v4l2_pix_format_mplane_enum {
+	__u32				width;
+	__u32				height;
+	__u32				pixelformat;
+	enum v4l2_field			field;
+	enum v4l2_colorspace		colorspace;
+
+	struct v4l2_plane_pix_format	plane_fmt[VIDEO_MAX_PLANES];
+	__u8				num_planes;
+	__u8				reserved[11];
+} __attribute__ ((packed));
+
+struct v4l2_format_enum {
+	enum v4l2_buf_type type;
+	union {
+		struct v4l2_pix_format_enum		pix;     /* V4L2_BUF_TYPE_VIDEO_CAPTURE */
+		struct v4l2_pix_format_mplane_enum	pix_mp;  /* V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE */
+		struct v4l2_window_enum		win;     /* V4L2_BUF_TYPE_VIDEO_OVERLAY */
+		struct v4l2_vbi_format		vbi;     /* V4L2_BUF_TYPE_VBI_CAPTURE */
+		struct v4l2_sliced_vbi_format	sliced;  /* V4L2_BUF_TYPE_SLICED_VBI_CAPTURE */
+		__u8	raw_data[200];                   /* user-defined */
+	} fmt;
+};
+
+/*	Stream type-dependent parameters
+ */
+struct v4l2_streamparm_enum {
+	enum v4l2_buf_type type;
+	union {
+		struct v4l2_captureparm	capture;
+		struct v4l2_outputparm	output;
+		__u8	raw_data[200];  /* user-defined */
+	} parm;
+};
+
+struct v4l2_create_buffers_enum {
+	__u32			index;
+	__u32			count;
+	enum v4l2_memory        memory;
+	struct v4l2_format_enum	format;
+	__u32			reserved[8];
+};
+
+#define VIDIOC_ENUM_FMT_ENUM     	_IOWR('V',  2, struct v4l2_fmtdesc_enum)
+#define VIDIOC_G_FMT_ENUM		_IOWR('V',  4, struct v4l2_format_enum)
+#define VIDIOC_S_FMT_ENUM		_IOWR('V',  5, struct v4l2_format_enum)
+#define VIDIOC_REQBUFS_ENUM		_IOWR('V',  8, struct v4l2_requestbuffers_enum)
+#define VIDIOC_QUERYBUF_ENUM		_IOWR('V',  9, struct v4l2_buffer_enum)
+#define VIDIOC_G_FBUF_ENUM		_IOR('V', 10, struct v4l2_framebuffer_enum)
+#define VIDIOC_S_FBUF_ENUM		_IOW('V', 11, struct v4l2_framebuffer_enum)
+#define VIDIOC_QBUF_ENUM		_IOWR('V', 15, struct v4l2_buffer_enum)
+#define VIDIOC_DQBUF_ENUM		_IOWR('V', 17, struct v4l2_buffer_enum)
+#define VIDIOC_G_PARM_ENUM		_IOWR('V', 21, struct v4l2_streamparm_enum)
+#define VIDIOC_S_PARM_ENUM		_IOWR('V', 22, struct v4l2_streamparm_enum)
+#define VIDIOC_G_TUNER_ENUM		_IOWR('V', 29, struct v4l2_tuner_enum)
+#define VIDIOC_S_TUNER_ENUM		_IOW('V', 30, struct v4l2_tuner_enum)
+#define VIDIOC_QUERYCTRL_ENUM		_IOWR('V', 36, struct v4l2_queryctrl_enum)
+#define VIDIOC_G_FREQUENCY_ENUM		_IOWR('V', 56, struct v4l2_frequency_enum)
+#define VIDIOC_S_FREQUENCY_ENUM		_IOW('V', 57, struct v4l2_frequency_enum)
+#define VIDIOC_CROPCAP_ENUM		_IOWR('V', 58, struct v4l2_crop_enumcap_enum)
+#define VIDIOC_G_CROP_ENUM		_IOWR('V', 59, struct v4l2_crop_enum)
+#define VIDIOC_S_CROP_ENUM		_IOW('V', 60, struct v4l2_crop_enum)
+#define VIDIOC_TRY_FMT_ENUM      	_IOWR('V', 64, struct v4l2_format_enum)
+#define VIDIOC_G_SLICED_VBI_CAP_ENUM	_IOWR('V', 69, struct v4l2_sliced_vbi_cap_enum)
+#define VIDIOC_S_HW_FREQ_SEEK_ENUM	_IOW('V', 82, struct v4l2_hw_freq_seek_enum)
+#define VIDIOC_CREATE_BUFS_ENUM		_IOWR('V', 92, struct v4l2_create_buffers_enum)
+#define VIDIOC_PREPARE_BUF_ENUM		_IOWR('V', 93, struct v4l2_buffer_enum)
+#endif /* V4L2_COMPAT */
+
 #endif /* __LINUX_VIDEODEV2_H */


