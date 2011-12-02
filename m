Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893Ab1LBPED (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 10:04:03 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55237 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065Ab1LBPD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 10:03:59 -0500
From: Ming Lei <ming.lei@canonical.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Tony Lindgren <tony@atomide.com>
Cc: Sylwester Nawrocki <snjw23@gmail.com>, Greg KH <greg@kroah.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, Ming Lei <ming.lei@canonical.com>
Subject: [RFC PATCH v1 5/7] media: v4l2: introduce two IOCTLs for face detection
Date: Fri,  2 Dec 2011 23:02:50 +0800
Message-Id: <1322838172-11149-6-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1322838172-11149-1-git-send-email-ming.lei@canonical.com>
References: <1322838172-11149-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces two new IOCTLs and related data
structure defination which will be used by the coming
face detection video device.

The two IOCTLs and related data structure are used by
user space application to retrieve the results of face
detection. They can be called after one v4l2_buffer
has been ioctl(VIDIOC_DQBUF) and before it will be
ioctl(VIDIOC_QBUF).

The utility fdif[1] is useing the two IOCTLs to find
faces deteced in raw images or video streams.

[1],http://kernel.ubuntu.com/git?p=ming/fdif.git;a=shortlog;h=refs/heads/v4l2-fdif

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/media/video/v4l2-ioctl.c |   38 ++++++++++++++++++++
 include/linux/videodev2.h        |   70 ++++++++++++++++++++++++++++++++++++++
 include/media/v4l2-ioctl.h       |    6 +++
 3 files changed, 114 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index e1da8fc..fc6266f 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -2140,6 +2140,30 @@ static long __video_do_ioctl(struct file *file,
 		dbgarg(cmd, "index=%d", b->index);
 		break;
 	}
+	case VIDIOC_G_FD_RESULT:
+	{
+		struct v4l2_fd_result *fr = arg;
+
+		if (!ops->vidioc_g_fd_result)
+			break;
+
+		ret = ops->vidioc_g_fd_result(file, fh, fr);
+
+		dbgarg(cmd, "index=%d", fr->buf_index);
+		break;
+	}
+	case VIDIOC_G_FD_COUNT:
+	{
+		struct v4l2_fd_count *fc = arg;
+
+		if (!ops->vidioc_g_fd_count)
+			break;
+
+		ret = ops->vidioc_g_fd_count(file, fh, fc);
+
+		dbgarg(cmd, "index=%d", fc->buf_index);
+		break;
+	}
 	default:
 		if (!ops->vidioc_default)
 			break;
@@ -2234,6 +2258,20 @@ static int check_array_args(unsigned int cmd, void *parg, size_t *array_size,
 		}
 		break;
 	}
+
+	case VIDIOC_G_FD_RESULT: {
+		struct v4l2_fd_result *fr = parg;
+
+		if (fr->face_cnt != 0) {
+			*user_ptr = (void __user *)fr->fd;
+			*kernel_ptr = (void *)&fr->fd;
+			*array_size = sizeof(struct v4l2_fd_detection)
+				    * fr->face_cnt;
+			ret = 1;
+		}
+		break;
+
+	}
 	}
 
 	return ret;
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 4b752d5..073eb4d 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -2160,6 +2160,74 @@ struct v4l2_create_buffers {
 	__u32			reserved[8];
 };
 
+/**
+ * struct v4l2_obj_detection
+ * @buf_index:	entry, index of v4l2_buffer for face detection
+ * @centerx:	return, position in x direction of detected object
+ * @centery:	return, position in y direction of detected object
+ * @angle:	return, angle of detected object
+ * 		0 deg ~ 359 deg, vertical is 0 deg, clockwise
+ * @sizex:	return, size in x direction of detected object
+ * @sizey:	return, size in y direction of detected object
+ * @confidence:	return, confidence level of detection result
+ * 		0: the heighest level, 9: the lowest level
+ * @reserved:	future extensions
+ */
+struct v4l2_obj_detection {
+	__u16		centerx;
+	__u16		centery;
+	__u16		angle;
+	__u16		sizex;
+	__u16		sizey;
+	__u16		confidence;
+	__u32		reserved[4];
+};
+
+#define V4L2_FD_HAS_LEFT_EYE	0x1
+#define V4L2_FD_HAS_RIGHT_EYE	0x2
+#define V4L2_FD_HAS_MOUTH	0x4
+#define V4L2_FD_HAS_FACE	0x8
+
+/**
+ * struct v4l2_fd_detection - VIDIOC_G_FD_RESULT argument
+ * @flag:	return, describe which objects are detected
+ * @left_eye:	return, left_eye position if detected
+ * @right_eye:	return, right_eye position if detected
+ * @mouth_eye:	return, mouth_eye position if detected
+ * @face:	return, face position if detected
+ */
+struct v4l2_fd_detection {
+	__u32	flag;
+	struct v4l2_obj_detection	left_eye;
+	struct v4l2_obj_detection	right_eye;
+	struct v4l2_obj_detection	mouth;
+	struct v4l2_obj_detection	face;
+};
+
+/**
+ * struct v4l2_fd_result - VIDIOC_G_FD_RESULT argument
+ * @buf_index:	entry, index of v4l2_buffer for face detection
+ * @face_cnt:	return, how many faces detected from the @buf_index
+ * @fd:		return, result of faces' detection
+ */
+struct v4l2_fd_result {
+	__u32	buf_index;
+	__u32	face_cnt;
+	__u32	reserved[6];
+	struct v4l2_fd_detection *fd;
+};
+
+/**
+ * struct v4l2_fd_count - VIDIOC_G_FD_COUNT argument
+ * @buf_index:	entry, index of v4l2_buffer for face detection
+ * @face_cnt:	return, how many faces detected from the @buf_index
+ */
+struct v4l2_fd_count {
+	__u32	buf_index;
+	__u32	face_cnt;
+	__u32	reserved[6];
+};
+
 /*
  *	I O C T L   C O D E S   F O R   V I D E O   D E V I C E S
  *
@@ -2254,6 +2322,8 @@ struct v4l2_create_buffers {
    versions */
 #define VIDIOC_CREATE_BUFS	_IOWR('V', 92, struct v4l2_create_buffers)
 #define VIDIOC_PREPARE_BUF	_IOWR('V', 93, struct v4l2_buffer)
+#define VIDIOC_G_FD_COUNT	_IOWR('V', 94, struct v4l2_fd_count)
+#define VIDIOC_G_FD_RESULT	_IOWR('V', 95, struct v4l2_fd_result)
 
 /* Reminder: when adding new ioctls please add support for them to
    drivers/media/video/v4l2-compat-ioctl32.c as well! */
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index 4d1c74a..19f03b0 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -270,6 +270,12 @@ struct v4l2_ioctl_ops {
 	int (*vidioc_unsubscribe_event)(struct v4l2_fh *fh,
 					struct v4l2_event_subscription *sub);
 
+	/* Face detect IOCTLs */
+	int (*vidioc_g_fd_count) (struct file *file, void *fh,
+					struct v4l2_fd_count *arg);
+	int (*vidioc_g_fd_result) (struct file *file, void *fh,
+					struct v4l2_fd_result *arg);
+
 	/* For other private ioctls */
 	long (*vidioc_default)	       (struct file *file, void *fh,
 					bool valid_prio, int cmd, void *arg);
-- 
1.7.5.4

