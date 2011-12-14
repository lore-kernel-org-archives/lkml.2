Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374Ab1LNOCF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 09:02:05 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56233 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757358Ab1LNOB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 09:01:57 -0500
From: Ming Lei <ming.lei@canonical.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Tony Lindgren <tony@atomide.com>
Cc: Sylwester Nawrocki <snjw23@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Ming Lei <ming.lei@canonical.com>
Subject: [RFC PATCH v2 6/8] media: v4l2: introduce two IOCTLs for object detection
Date: Wed, 14 Dec 2011 22:00:12 +0800
Message-Id: <1323871214-25435-7-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323871214-25435-1-git-send-email-ming.lei@canonical.com>
References: <1323871214-25435-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces two new IOCTLs and related data
structure which will be used by the coming video device
with object detect capability.

The two IOCTLs and related data structure will be used by
user space application to retrieve the results of object
detection.

The utility fdif[1] is useing the two IOCTLs to find
objects(faces) deteced in raw images or video streams.

[1],http://kernel.ubuntu.com/git?p=ming/fdif.git;a=shortlog;h=refs/heads/v4l2-fdif

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
v2:
	- extend face detection API to object detection API
	- introduce capability of V4L2_CAP_OBJ_DETECTION for object detection
	- 32/64 safe array parameter
---
 drivers/media/video/v4l2-ioctl.c |   41 ++++++++++++-
 include/linux/videodev2.h        |  124 ++++++++++++++++++++++++++++++++++++++
 include/media/v4l2-ioctl.h       |    6 ++
 3 files changed, 170 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index ded8b72..575d445 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -2140,6 +2140,30 @@ static long __video_do_ioctl(struct file *file,
 		dbgarg(cmd, "index=%d", b->index);
 		break;
 	}
+	case VIDIOC_G_OD_RESULT:
+	{
+		struct v4l2_od_result *or = arg;
+
+		if (!ops->vidioc_g_od_result)
+			break;
+
+		ret = ops->vidioc_g_od_result(file, fh, or);
+
+		dbgarg(cmd, "index=%d", or->frm_seq);
+		break;
+	}
+	case VIDIOC_G_OD_COUNT:
+	{
+		struct v4l2_od_count *oc = arg;
+
+		if (!ops->vidioc_g_od_count)
+			break;
+
+		ret = ops->vidioc_g_od_count(file, fh, oc);
+
+		dbgarg(cmd, "index=%d", oc->frm_seq);
+		break;
+	}
 	default:
 		if (!ops->vidioc_default)
 			break;
@@ -2241,7 +2265,22 @@ static int check_array_args(unsigned int cmd, void *parg, size_t *array_size,
 
 static int is_64_32_array_args(unsigned int cmd, void *parg, int *extra_len)
 {
-	return 0;
+	int ret = 0;
+
+	switch (cmd) {
+	case VIDIOC_G_OD_RESULT: {
+		struct v4l2_od_result *or = parg;
+
+		*extra_len = or->obj_cnt *
+			sizeof(struct v4l2_od_object);
+		ret = 1;
+		break;
+	}
+	default:
+		break;
+	}
+
+	return ret;
 }
 
 long
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 4b752d5..c08ceaf 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -270,6 +270,9 @@ struct v4l2_capability {
 #define V4L2_CAP_RADIO			0x00040000  /* is a radio device */
 #define V4L2_CAP_MODULATOR		0x00080000  /* has a modulator */
 
+/* The device has capability of object detection */
+#define V4L2_CAP_OBJ_DETECTION		0x00100000
+
 #define V4L2_CAP_READWRITE              0x01000000  /* read/write systemcalls */
 #define V4L2_CAP_ASYNCIO                0x02000000  /* async I/O */
 #define V4L2_CAP_STREAMING              0x04000000  /* streaming I/O ioctls */
@@ -2160,6 +2163,125 @@ struct v4l2_create_buffers {
 	__u32			reserved[8];
 };
 
+/**
+ * struct v4l2_od_obj_desc
+ * @centerx:	return, position in x direction of detected object
+ * @centery:	return, position in y direction of detected object
+ * @sizex:	return, size in x direction of detected object
+ * @sizey:	return, size in y direction of detected object
+ * @angle:	return, angle of detected object
+ * 		0 deg ~ 359 deg, vertical is 0 deg, clockwise
+ * @reserved:	future extensions
+ */
+struct v4l2_od_obj_desc {
+	__u16		centerx;
+	__u16		centery;
+	__u16		sizex;
+	__u16		sizey;
+	__u16		angle;
+	__u16		reserved[5];
+};
+
+/**
+ * struct v4l2_od_face_desc
+ * @id:		return, used to be associated with detected eyes, mouth,
+ * 		and other objects inside this face, and each face in one
+ * 		frame has a unique id, start from 1
+ * @smile_level:return, smile level of the face
+ * @f:		return, face description
+ */
+struct v4l2_od_face_desc {
+	__u16	id;
+	__u8	smile_level;
+	__u8    reserved[15];
+
+	struct v4l2_od_obj_desc	f;
+};
+
+/**
+ * struct v4l2_od_eye_desc
+ * @face_id:	return, used to associate with which face, 0 means
+ * 		no face associated with the eye
+ * @blink_level:return, blink level of the eye
+ * @e:		return, eye description
+ */
+struct v4l2_od_eye_desc {
+	__u16	face_id;
+	__u8	blink_level;
+	__u8    reserved[15];
+
+	struct v4l2_od_obj_desc	e;
+};
+
+/**
+ * struct v4l2_od_mouth_desc
+ * @face_id:	return, used to associate with which face, 0 means
+ * 		no face associated with the mouth
+ * @m:		return, mouth description
+ */
+struct v4l2_od_mouth_desc {
+	__u16	face_id;
+	__u8    reserved[16];
+
+	struct v4l2_od_obj_desc	m;
+};
+
+enum v4l2_od_type {
+	V4L2_OD_TYPE_FACE		= 1,
+	V4L2_OD_TYPE_LEFT_EYE		= 2,
+	V4L2_OD_TYPE_RIGHT_EYE		= 3,
+	V4L2_OD_TYPE_MOUTH		= 4,
+	V4L2_OD_TYPE_USER_DEFINED	= 255,
+	V4L2_OD_TYPE_MAX_CNT		= 256,
+};
+
+/**
+ * struct v4l2_od_object
+ * @type:	return, type of detected object
+ * @confidence:	return, confidence level of detection result
+ * 		0: the heighest level, 100: the lowest level
+ * @face:	return, detected face object description
+ * @eye:	return, detected eye object description
+ * @mouth:	return, detected mouth object description
+ * @rawdata:	return, user defined data
+ */
+struct v4l2_od_object {
+	enum v4l2_od_type	type;
+	__u16			confidence;
+	union {
+		struct v4l2_od_face_desc face;
+		struct v4l2_od_face_desc eye;
+		struct v4l2_od_face_desc mouth;
+		__u8	rawdata[60];
+	} o;
+};
+
+/**
+ * struct v4l2_od_result - VIDIOC_G_OD_RESULT argument
+ * @frm_seq:	entry, frame sequence No.
+ * @obj_cnt:	return, how many objects detected in frame @frame_seq
+ * @reserved:	reserved for future use
+ * @od:		return, result of detected objects in frame @frame_seq
+ */
+struct v4l2_od_result {
+	__u32			frm_seq;
+	__u32			obj_cnt;
+	__u32			reserved[6];
+	struct v4l2_od_object	od[0];
+};
+
+/**
+ * struct v4l2_od_count - VIDIOC_G_OD_COUNT argument
+ * @frm_seq:	entry, frame sequence No. for ojbect detection
+ * @obj_cnt:	return, how many objects detected from the @frm_seq
+ * @reserved:	reserved for future useage.
+ */
+struct v4l2_od_count {
+	__u32	frm_seq;
+	__u32	obj_cnt;
+	__u32	reserved[6];
+};
+
 /*
  *	I O C T L   C O D E S   F O R   V I D E O   D E V I C E S
  *
@@ -2254,6 +2376,8 @@ struct v4l2_create_buffers {
    versions */
 #define VIDIOC_CREATE_BUFS	_IOWR('V', 92, struct v4l2_create_buffers)
 #define VIDIOC_PREPARE_BUF	_IOWR('V', 93, struct v4l2_buffer)
+#define VIDIOC_G_OD_COUNT	_IOWR('V', 94, struct v4l2_od_count)
+#define VIDIOC_G_OD_RESULT	_IOWR('V', 95, struct v4l2_od_result)
 
 /* Reminder: when adding new ioctls please add support for them to
    drivers/media/video/v4l2-compat-ioctl32.c as well! */
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index 4d1c74a..81a32a3 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -270,6 +270,12 @@ struct v4l2_ioctl_ops {
 	int (*vidioc_unsubscribe_event)(struct v4l2_fh *fh,
 					struct v4l2_event_subscription *sub);
 
+	/* object detect IOCTLs */
+	int (*vidioc_g_od_count) (struct file *file, void *fh,
+					struct v4l2_od_count *arg);
+	int (*vidioc_g_od_result) (struct file *file, void *fh,
+					struct v4l2_od_result *arg);
+
 	/* For other private ioctls */
 	long (*vidioc_default)	       (struct file *file, void *fh,
 					bool valid_prio, int cmd, void *arg);
-- 
1.7.5.4

