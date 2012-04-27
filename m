Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759434Ab2D0IeW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 04:34:22 -0400
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39069 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755444Ab2D0IeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 04:34:17 -0400
X-Greylist: delayed 611 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Apr 2012 04:34:16 EDT
From: Sakari Ailus <sakari.ailus@iki.fi>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        remi@remlab.net, james.dutton@gmail.com, alan@lxorguk.ukuu.org.uk,
        linux-kernel@vger.kernel.org
Subject: [RFC 1/1] v4l: Implement compat handlers for ioctls containing enums
Date: Fri, 27 Apr 2012 11:24:01 +0300
Message-Id: <1335515041-6611-1-git-send-email-sakari.ailus@iki.fi>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <4F8DAD82.4000608@redhat.com>
References: <4F8DAD82.4000608@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quite a few V4L2 IOCTLs contained enum types in IOCTL definitions which are
considered bad. To get rid of these types, the enum types are replaced with
integer types with fixed size. This causes the actual IOCTL commands to
change, which requires special handling during the transition period to new
IOCTL commands.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
Hi all,

I'm sending this as RFC and this what it really means: I haven't tested the
patch, not even compiled it. What I'd like to ask is how do you like the
approach. Handling for only one IOCTL is implemented.

The compat IOCTLs are recognised and special handling for them is performed
in place of copy_from_user() and copy_to_user(). I do not handle array
IOCTLs yet.

I thought of the option of copying everything to kernel space first and then
performing the conversion there, but doing it at the same time does not seem
to cause much additional complications. The expense is likely more CPU time
usage but less stack usage / memory allocation which also can consume
noteworthy amounts of CPU time.

This patch goes on top of Mauro's earlier patch.

 drivers/media/video/v4l2-ioctl.c |  207 ++++++++++++++++++++++++++++++++++++--
 1 files changed, 198 insertions(+), 9 deletions(-)

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 5b2ec1f..cb2ed57 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -2303,6 +2303,177 @@ static long __video_do_ioctl(struct file *file,
 	return ret;
 }
 
+static long copy_compat_from_user(unsigned int cmd, void *parg,
+				  void __user *arg)
+{
+	union {
+		struct v4l2_fmtdesc_enum *fmtdesc;
+		struct v4l2_format_enum *fmt;
+		struct v4l2_requestbuffers_enum *reqbufs;
+		struct v4l2_framebuffer_enum *fb;
+		struct v4l2_buffer_enum *buf;
+		struct v4l2_streamparm_enum *sparm;
+		struct v4l2_tuner_enum *tuner;
+		struct v4l2_queryctrl_enum *qc;
+		struct v4l2_frequency_enum *freq;
+		struct v4l2_crop_enumcap_enum *cropcap;
+		struct v4l2_crop_enum *crop;
+		struct v4l2_sliced_vbi_cap_enum *vbi_cap;
+		struct v4l2_hw_freq_seek_enum *hw_freq_seek;
+		struct v4l2_create_buffers_enum *create_bufs;
+	} __user cu = arg;
+	union {
+		struct v4l2_fmtdesc fmtdesc;
+		struct v4l2_format fmt;
+		struct v4l2_requestbuffers reqbufs;
+		struct v4l2_framebuffer fb;
+		struct v4l2_buffer buf;
+		struct v4l2_streamparm sparm;
+		struct v4l2_tuner tuner;
+		struct v4l2_queryctrl qc;
+		struct v4l2_frequency freq;
+		struct v4l2_crop_enumcap cropcap;
+		struct v4l2_crop crop;
+		struct v4l2_sliced_vbi_cap vbi_cap;
+		struct v4l2_hw_freq_seek hw_freq_seek;
+		struct v4l2_create_buffers create_bufs;
+	} k = parg;
+
+	switch (cmd) {
+	case VIDIOC_ENUM_FMT_ENUM:
+		if (!access_ok(VERIFY_READ, cu, sizeof(*cu->fmtdesc))
+		    || get_user(k->fmtdesc.index, cu->fmtdesc->index)
+		    || get_user(k->fmtdesc.type, cu->fmtdesc->type)
+		    || get_user(k->fmtdesc.flags, cu->fmtdesc->flags)
+		    || copy_from_user(k->fmtdesc.description,
+				      cu->fmtdesc->description,
+				      sizeof(k->fmtdesc.description))
+		    || get_user(k->fmtdesc.pixelformat,
+				u->fmtdesc->pixelformat)
+		    || copy_from_user(k->fmtdesc.reserved,
+				      cu->fmtdesc->reserved,
+				      sizeof(k->fmtdesc.reserved)))
+			return -EFAULT;
+		return 0;
+	default:
+		WARN();
+		return -EINVAL;
+	}
+}
+
+static long copy_compat_to_user(unsigned int cmd, void __user *arg,
+				void *parg)
+{
+	union {
+		struct v4l2_fmtdesc_enum *fmtdesc;
+		struct v4l2_format_enum *fmt;
+		struct v4l2_requestbuffers_enum *reqbufs;
+		struct v4l2_framebuffer_enum *fb;
+		struct v4l2_buffer_enum *buf;
+		struct v4l2_streamparm_enum *sparm;
+		struct v4l2_tuner_enum *tuner;
+		struct v4l2_queryctrl_enum *qc;
+		struct v4l2_frequency_enum *freq;
+		struct v4l2_crop_enumcap_enum *cropcap;
+		struct v4l2_crop_enum *crop;
+		struct v4l2_sliced_vbi_cap_enum *vbi_cap;
+		struct v4l2_hw_freq_seek_enum *hw_freq_seek;
+		struct v4l2_create_buffers_enum *create_bufs;
+	} __user cu = arg;
+	union {
+		struct v4l2_fmtdesc fmtdesc;
+		struct v4l2_format fmt;
+		struct v4l2_requestbuffers reqbufs;
+		struct v4l2_framebuffer fb;
+		struct v4l2_buffer buf;
+		struct v4l2_streamparm sparm;
+		struct v4l2_tuner tuner;
+		struct v4l2_queryctrl qc;
+		struct v4l2_frequency freq;
+		struct v4l2_crop_enumcap cropcap;
+		struct v4l2_crop crop;
+		struct v4l2_sliced_vbi_cap vbi_cap;
+		struct v4l2_hw_freq_seek hw_freq_seek;
+		struct v4l2_create_buffers create_bufs;
+	} k = parg;
+
+	switch (cmd) {
+	case VIDIOC_ENUM_FMT_ENUM:
+		if (!access_ok(VERIFY_WRITE, cu, sizeof(*cu->fmtdesc))
+		    || put_user(cu->fmtdesc->index, k->fmtdesc.index)
+		    || put_user(cu->fmtdesc->type, k->fmtdesc.type)
+		    || put_user(cu->fmtdesc->flags, k->fmtdesc.flags)
+		    || copy_to_user(cu->fmtdesc->description,
+				    k->fmtdesc.description,
+				    sizeof(k->fmtdesc.description))
+		    || put_user(cu->fmtdesc->pixelformat,
+				k->fmtdesc.pixelformat)
+		    || copy_to_user(cu->fmtdesc->reserved, k->fmtdesc.reserved,
+				    sizeof(k->fmtdesc.reserved)))
+			return -EFAULT;
+		return 0;
+	default:
+		WARN();
+		return -EINVAL;
+	}
+}
+
+static unsigned int get_non_compat_cmd(unsigned int cmd)
+{
+	switch (cmd) {
+	case VIDIOC_ENUM_FMT_ENUM:
+		return VIDIOC_ENUM_FMT;
+	case VIDIOC_G_FMT_ENUM:
+		return VIDIOC_G_FMT;
+	case VIDIOC_S_FMT_ENUM:
+		return VIDIOC_S_FMT;
+	case VIDIOC_REQBUFS_ENUM:
+		return VIDIOC_REQBUFS;
+	case VIDIOC_QUERYBUF_ENUM:
+		return VIDIOC_QUERYBUF;
+	case VIDIOC_G_FBUF_ENUM:
+		return VIDIOC_G_FBUF;
+	case VIDIOC_S_FBUF_ENUM:
+		return VIDIOC_S_FBUF;
+	case VIDIOC_QBUF_ENUM:
+		return VIDIOC_QBUF;
+	case VIDIOC_DQBUF_ENUM:
+		return VIDIOC_DQBUF;
+	case VIDIOC_G_PARM_ENUM:
+		return VIDIOC_G_PARM;
+	case VIDIOC_S_PARM_ENUM:
+		return VIDIOC_S_PARM;
+	case VIDIOC_G_TUNER_ENUM:
+		return VIDIOC_G_TUNER;
+	case VIDIOC_S_TUNER_ENUM:
+		return VIDIOC_S_TUNER;
+	case VIDIOC_QUERYCTRL_ENUM:
+		return VIDIOC_QUERYCTRL;
+	case VIDIOC_G_FREQUENCY_ENUM:
+		return VIDIOC_G_FREQUENCY;
+	case VIDIOC_S_FREQUENCY_ENUM:
+		return VIDIOC_S_FREQUENCY;
+	case VIDIOC_CROPCAP_ENUM:
+		return VIDIOC_CROPCAP;
+	case VIDIOC_G_CROP_ENUM:
+		return VIDIOC_G_CROP;
+	case VIDIOC_S_CROP_ENUM:
+		return VIDIOC_S_CROP;
+	case VIDIOC_TRY_FMT_ENUM:
+		return VIDIOC_TRY_FMT;
+	case VIDIOC_G_SLICED_VBI_CAP_ENUM:
+		return VIDIOC_G_SLICED_VBI_CAP;
+	case VIDIOC_S_HW_FREQ_SEEK_ENUM:
+		return VIDIOC_S_HW_FREQ_SEEK;
+	case VIDIOC_CREATE_BUFS_ENUM:
+		return VIDIOC_CREATE_BUFS;
+	case VIDIOC_PREPARE_BUF_ENUM:
+		return VIDIOC_PREPARE_BUF;
+	default:
+		return cmd;
+	}
+}
+
 /* In some cases, only a few fields are used as input, i.e. when the app sets
  * "index" and then the driver fills in the rest of the structure for the thing
  * with that index.  We only need to copy up the first non-input field.  */
@@ -2390,7 +2561,7 @@ static int check_array_args(unsigned int cmd, void *parg, size_t *array_size,
 }
 
 long
-video_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
+video_usercopy(struct file *file, unsigned int compat_cmd, unsigned long arg,
 	       v4l2_kioctl func)
 {
 	char	sbuf[128];
@@ -2401,6 +2572,7 @@ video_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
 	size_t  array_size = 0;
 	void __user *user_ptr = NULL;
 	void	**kernel_ptr = NULL;
+	unsigned int cmd = get_non_compat_cmd(cmd);
 
 	/*  Copy arguments into temp kernel buffer  */
 	if (_IOC_DIR(cmd) != _IOC_NONE) {
@@ -2418,12 +2590,23 @@ video_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
 		if (_IOC_DIR(cmd) & _IOC_WRITE) {
 			unsigned long n = cmd_input_size(cmd);
 
-			if (copy_from_user(parg, (void __user *)arg, n))
-				goto out;
-
-			/* zero out anything we don't copy from userspace */
-			if (n < _IOC_SIZE(cmd))
-				memset((u8 *)parg + n, 0, _IOC_SIZE(cmd) - n);
+			if (cmd == compat_cmd) {
+				if (copy_from_user(
+					    parg, (void __user *)arg, n))
+					goto out;
+
+				/*
+				 * zero out anything we don't copy
+				 * from userspace
+				 */
+				if (n < _IOC_SIZE(cmd))
+					memset((u8 *)parg + n, 0,
+					       _IOC_SIZE(cmd) - n);
+			} else {
+				if (copy_compat_from_user(cmd, parg,
+							  (void __user *)arg))
+					goto out;
+			}
 		} else {
 			/* read-only ioctl */
 			memset(parg, 0, _IOC_SIZE(cmd));
@@ -2471,8 +2654,14 @@ out_array_args:
 	switch (_IOC_DIR(cmd)) {
 	case _IOC_READ:
 	case (_IOC_WRITE | _IOC_READ):
-		if (copy_to_user((void __user *)arg, parg, _IOC_SIZE(cmd)))
-			err = -EFAULT;
+		if (cmd == compat_cmd) {
+			if (copy_to_user((void __user *)arg, parg,
+					 _IOC_SIZE(cmd)))
+				err = -EFAULT;
+		} else {
+			if (copy_compat_to_user(cmd, arg, parg))
+				err = -EFAULT;
+		}
 		break;
 	}
 
-- 
1.7.2.5

