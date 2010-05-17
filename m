Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab0EQGv2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 02:51:28 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62133 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594Ab0EQGu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 02:50:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=ttjpIA3AHAxLjVmadMG4QPUh7XHqE1WN5mWidoa/uu0cuEGZeDV9sQYBp1kMxLPARu
         yGbDctc2T/diyaejW5rrL4IE++du5eUJp5rMm6Fq0XUp5SISv0f8BMjuL91eTQmRa1Ig
         HESDza1b7JY1Yo/aQq0THBzfb8SlZnXgj5S10=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
       Hans Verkuil <hverkuil@xs4all.nl>, Arnd Bergmann <arnd@arndb.de>,
       John Kacur <jkacur@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Blunck <jblunck@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 3/4] v4l: Pushdown bkl to drivers that implement their own ioctl
Date: Mon, 17 May 2010 08:50:51 +0200
Message-Id: <1274079052-23611-4-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1274079052-23611-1-git-send-regression-fweisbec@gmail.com>
References: <1274079052-23611-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are the last remaining v4l drivers that implement the ioctl
callback.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 drivers/media/radio/radio-mr800.c            |    5 +++-
 drivers/media/video/bw-qcam.c                |   11 ++++++++-
 drivers/media/video/c-qcam.c                 |   11 ++++++++-
 drivers/media/video/cpia.c                   |   11 ++++++++-
 drivers/media/video/cpia2/cpia2_v4l.c        |   11 ++++++++-
 drivers/media/video/cx18/cx18-ioctl.c        |    4 +++
 drivers/media/video/cx18/cx18-streams.c      |   12 +++++-----
 drivers/media/video/et61x251/et61x251_core.c |   27 +++++++++++++++++++------
 drivers/media/video/ov511.c                  |   15 ++++++++-----
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c   |   20 ++++++++++++------
 drivers/media/video/pwc/pwc-if.c             |   19 ++++++++++-------
 drivers/media/video/saa5246a.c               |   11 ++++++---
 drivers/media/video/saa5249.c                |    6 ++++-
 drivers/media/video/se401.c                  |   20 ++++++++++++------
 drivers/media/video/sn9c102/sn9c102_core.c   |   27 +++++++++++++++++++------
 drivers/media/video/stradis.c                |   26 ++++++++++++++++++------
 drivers/media/video/stv680.c                 |   20 ++++++++++++------
 drivers/media/video/usbvideo/usbvideo.c      |   21 +++++++++++++------
 drivers/media/video/usbvideo/vicam.c         |   14 ++++++++++++-
 drivers/media/video/uvc/uvc_v4l2.c           |   11 ++++++++-
 drivers/media/video/vivi.c                   |    2 +-
 drivers/media/video/w9968cf.c                |   25 ++++++++++++++++++-----
 drivers/media/video/zc0301/zc0301_core.c     |   27 +++++++++++++++++++------
 drivers/staging/cx25821/cx25821-audups11.c   |   18 ++++++++++------
 drivers/staging/cx25821/cx25821-videoioctl.c |   27 +++++++++++++++++++------
 drivers/staging/cx25821/cx25821-vidups10.c   |   19 +++++++++++------
 drivers/staging/cx25821/cx25821-vidups9.c    |   18 ++++++++++------
 drivers/staging/dream/camera/msm_v4l2.c      |   27 ++++++++++++++++++-------
 28 files changed, 329 insertions(+), 136 deletions(-)

diff --git a/drivers/media/radio/radio-mr800.c b/drivers/media/radio/radio-mr800.c
index 353b828..106c079 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -551,6 +551,7 @@ static long usb_amradio_ioctl(struct file *file, unsigned int cmd,
 	struct amradio_device *radio = file->private_data;
 	long retval = 0;
 
+	lock_kernel();
 	mutex_lock(&radio->lock);
 
 	if (!radio->usbdev) {
@@ -562,6 +563,8 @@ static long usb_amradio_ioctl(struct file *file, unsigned int cmd,
 
 unlock:
 	mutex_unlock(&radio->lock);
+	unlock_kernel();
+
 	return retval;
 }
 
@@ -615,7 +618,7 @@ static const struct v4l2_file_operations usb_amradio_fops = {
 	.owner		= THIS_MODULE,
 	.open		= usb_amradio_open,
 	.release	= usb_amradio_close,
-	.ioctl		= usb_amradio_ioctl,
+	.unlocked_ioctl	= usb_amradio_ioctl,
 };
 
 static const struct v4l2_ioctl_ops usb_amradio_ioctl_ops = {
diff --git a/drivers/media/video/bw-qcam.c b/drivers/media/video/bw-qcam.c
index 3c9e754..11367b0 100644
--- a/drivers/media/video/bw-qcam.c
+++ b/drivers/media/video/bw-qcam.c
@@ -76,6 +76,7 @@ OTHER DEALINGS IN THE SOFTWARE.
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 #include <linux/mutex.h>
+#include <linux/smp_lock.h>
 #include <asm/uaccess.h>
 
 #include "bw-qcam.h"
@@ -831,7 +832,13 @@ static long qcam_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 static long qcam_ioctl(struct file *file,
 		unsigned int cmd, unsigned long arg)
 {
-	return video_usercopy(file, cmd, arg, qcam_do_ioctl);
+	long ret;
+
+	lock_kernel();
+	ret = video_usercopy(file, cmd, arg, qcam_do_ioctl);
+	unlock_kernel();
+
+	return ret;
 }
 
 static ssize_t qcam_read(struct file *file, char __user *buf,
@@ -879,7 +886,7 @@ static const struct v4l2_file_operations qcam_fops = {
 	.owner		= THIS_MODULE,
 	.open           = qcam_exclusive_open,
 	.release        = qcam_exclusive_release,
-	.ioctl          = qcam_ioctl,
+	.unlocked_ioctl = qcam_ioctl,
 	.read		= qcam_read,
 };
 static struct video_device qcam_template = {
diff --git a/drivers/media/video/c-qcam.c b/drivers/media/video/c-qcam.c
index 8f1dd88..0eb42fd 100644
--- a/drivers/media/video/c-qcam.c
+++ b/drivers/media/video/c-qcam.c
@@ -38,6 +38,7 @@
 #include <media/v4l2-ioctl.h>
 #include <linux/mutex.h>
 #include <linux/jiffies.h>
+#include <linux/smp_lock.h>
 
 #include <asm/uaccess.h>
 
@@ -663,7 +664,13 @@ static long qcam_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 static long qcam_ioctl(struct file *file,
 		      unsigned int cmd, unsigned long arg)
 {
-	return video_usercopy(file, cmd, arg, qcam_do_ioctl);
+	long ret;
+
+	lock_kernel();
+	ret = video_usercopy(file, cmd, arg, qcam_do_ioctl);
+	unlock_kernel();
+
+	return ret;
 }
 
 static ssize_t qcam_read(struct file *file, char __user *buf,
@@ -704,7 +711,7 @@ static const struct v4l2_file_operations qcam_fops = {
 	.owner		= THIS_MODULE,
 	.open           = qcam_exclusive_open,
 	.release        = qcam_exclusive_release,
-	.ioctl          = qcam_ioctl,
+	.unlocked_ioctl = qcam_ioctl,
 	.read		= qcam_read,
 };
 
diff --git a/drivers/media/video/cpia.c b/drivers/media/video/cpia.c
index 933ae4c..f3f08cc 100644
--- a/drivers/media/video/cpia.c
+++ b/drivers/media/video/cpia.c
@@ -38,6 +38,7 @@
 #include <linux/ctype.h>
 #include <linux/pagemap.h>
 #include <linux/delay.h>
+#include <linux/smp_lock.h>
 #include <asm/io.h>
 #include <linux/mutex.h>
 
@@ -3715,7 +3716,13 @@ static long cpia_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 static long cpia_ioctl(struct file *file,
 		     unsigned int cmd, unsigned long arg)
 {
-	return video_usercopy(file, cmd, arg, cpia_do_ioctl);
+	long ret;
+
+	lock_kernel();
+	ret = video_usercopy(file, cmd, arg, cpia_do_ioctl);
+	unlock_kernel();
+
+	return ret;
 }
 
 
@@ -3775,7 +3782,7 @@ static const struct v4l2_file_operations cpia_fops = {
 	.release       	= cpia_close,
 	.read		= cpia_read,
 	.mmap		= cpia_mmap,
-	.ioctl          = cpia_ioctl,
+	.unlocked_ioctl = cpia_ioctl,
 };
 
 static struct video_device cpia_template = {
diff --git a/drivers/media/video/cpia2/cpia2_v4l.c b/drivers/media/video/cpia2/cpia2_v4l.c
index 5520789..2a841e3 100644
--- a/drivers/media/video/cpia2/cpia2_v4l.c
+++ b/drivers/media/video/cpia2/cpia2_v4l.c
@@ -39,6 +39,7 @@
 #include <linux/init.h>
 #include <linux/videodev.h>
 #include <linux/stringify.h>
+#include <linux/smp_lock.h>
 #include <media/v4l2-ioctl.h>
 
 #include "cpia2.h"
@@ -1840,7 +1841,13 @@ static long cpia2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 static long cpia2_ioctl(struct file *file,
 		       unsigned int cmd, unsigned long arg)
 {
-	return video_usercopy(file, cmd, arg, cpia2_do_ioctl);
+	long ret;
+
+	lock_kernel();
+	ret = video_usercopy(file, cmd, arg, cpia2_do_ioctl);
+	unlock_kernel();
+
+	return ret;
 }
 
 /******************************************************************************
@@ -1914,7 +1921,7 @@ static const struct v4l2_file_operations fops_template = {
 	.release	= cpia2_close,
 	.read		= cpia2_v4l_read,
 	.poll		= cpia2_v4l_poll,
-	.ioctl		= cpia2_ioctl,
+	.unlocked_ioctl	= cpia2_ioctl,
 	.mmap		= cpia2_mmap,
 };
 
diff --git a/drivers/media/video/cx18/cx18-ioctl.c b/drivers/media/video/cx18/cx18-ioctl.c
index 2530fc5..493624a 100644
--- a/drivers/media/video/cx18/cx18-ioctl.c
+++ b/drivers/media/video/cx18/cx18-ioctl.c
@@ -41,6 +41,7 @@
 #include <media/tveeprom.h>
 #include <media/v4l2-chip-ident.h>
 #include <linux/i2c-id.h>
+#include <linux/smp_lock.h>
 
 u16 cx18_service2vbi(int type)
 {
@@ -1083,6 +1084,7 @@ long cx18_v4l2_ioctl(struct file *filp, unsigned int cmd,
 	struct cx18 *cx = id->cx;
 	long res;
 
+	lock_kernel();
 	mutex_lock(&cx->serialize_lock);
 
 	/* FIXME - consolidate v4l2_prio_check()'s here */
@@ -1092,6 +1094,8 @@ long cx18_v4l2_ioctl(struct file *filp, unsigned int cmd,
 	res = video_ioctl2(filp, cmd, arg);
 	vfd->debug = 0;
 	mutex_unlock(&cx->serialize_lock);
+	unlock_kernel();
+
 	return res;
 }
 
diff --git a/drivers/media/video/cx18/cx18-streams.c b/drivers/media/video/cx18/cx18-streams.c
index f5c9126..1c66750 100644
--- a/drivers/media/video/cx18/cx18-streams.c
+++ b/drivers/media/video/cx18/cx18-streams.c
@@ -37,13 +37,13 @@
 #define CX18_DSP0_INTERRUPT_MASK     	0xd0004C
 
 static struct v4l2_file_operations cx18_v4l2_enc_fops = {
-	.owner = THIS_MODULE,
-	.read = cx18_v4l2_read,
-	.open = cx18_v4l2_open,
+	.owner		= THIS_MODULE,
+	.read		= cx18_v4l2_read,
+	.open		= cx18_v4l2_open,
 	/* FIXME change to video_ioctl2 if serialization lock can be removed */
-	.ioctl = cx18_v4l2_ioctl,
-	.release = cx18_v4l2_close,
-	.poll = cx18_v4l2_enc_poll,
+	.unlocked_ioctl = cx18_v4l2_ioctl,
+	.release	= cx18_v4l2_close,
+	.poll		= cx18_v4l2_enc_poll,
 };
 
 /* offset from 0 to register ts v4l2 minors on */
diff --git a/drivers/media/video/et61x251/et61x251_core.c b/drivers/media/video/et61x251/et61x251_core.c
index a5cfc76..2f64a24 100644
--- a/drivers/media/video/et61x251/et61x251_core.c
+++ b/drivers/media/video/et61x251/et61x251_core.c
@@ -34,6 +34,7 @@
 #include <linux/mm.h>
 #include <linux/vmalloc.h>
 #include <linux/page-flags.h>
+#include <linux/smp_lock.h>
 #include <media/v4l2-ioctl.h>
 #include <asm/byteorder.h>
 #include <asm/page.h>
@@ -2525,15 +2526,27 @@ static long et61x251_ioctl(struct file *filp,
 	return err;
 }
 
+static long
+et61x251_locked_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+{
+	long ret;
+
+	lock_kernel();
+	ret = et61x251_ioctl(filp, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
+
 
 static const struct v4l2_file_operations et61x251_fops = {
-	.owner = THIS_MODULE,
-	.open =    et61x251_open,
-	.release = et61x251_release,
-	.ioctl =   et61x251_ioctl,
-	.read =    et61x251_read,
-	.poll =    et61x251_poll,
-	.mmap =    et61x251_mmap,
+	.owner		= THIS_MODULE,
+	.open		= et61x251_open,
+	.release	= et61x251_release,
+	.unlocked_ioctl = et61x251_locked_ioctl,
+	.read		= et61x251_read,
+	.poll		= et61x251_poll,
+	.mmap		= et61x251_mmap,
 };
 
 /*****************************************************************************/
diff --git a/drivers/media/video/ov511.c b/drivers/media/video/ov511.c
index a109120..28945f8 100644
--- a/drivers/media/video/ov511.c
+++ b/drivers/media/video/ov511.c
@@ -44,6 +44,7 @@
 #include <asm/processor.h>
 #include <linux/mm.h>
 #include <linux/device.h>
+#include <linux/smp_lock.h>
 
 #if defined (__i386__)
 	#include <asm/cpufeature.h>
@@ -4460,7 +4461,9 @@ ov51x_v4l1_ioctl(struct file *file,
 	if (mutex_lock_interruptible(&ov->lock))
 		return -EINTR;
 
+	lock_kernel();
 	rc = video_usercopy(file, cmd, arg, ov51x_v4l1_ioctl_internal);
+	unlock_kernel();
 
 	mutex_unlock(&ov->lock);
 	return rc;
@@ -4662,12 +4665,12 @@ ov51x_v4l1_mmap(struct file *file, struct vm_area_struct *vma)
 }
 
 static const struct v4l2_file_operations ov511_fops = {
-	.owner =	THIS_MODULE,
-	.open =		ov51x_v4l1_open,
-	.release =	ov51x_v4l1_close,
-	.read =		ov51x_v4l1_read,
-	.mmap =		ov51x_v4l1_mmap,
-	.ioctl =	ov51x_v4l1_ioctl,
+	.owner		= THIS_MODULE,
+	.open		= ov51x_v4l1_open,
+	.release	= ov51x_v4l1_close,
+	.read		= ov51x_v4l1_read,
+	.mmap		= ov51x_v4l1_mmap,
+	.unlocked_ioctl	= ov51x_v4l1_ioctl,
 };
 
 static struct video_device vdev_template = {
diff --git a/drivers/media/video/pvrusb2/pvrusb2-v4l2.c b/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
index 5ffa0d2..f52866e 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
@@ -22,6 +22,7 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/version.h>
+#include <linux/smp_lock.h>
 #include "pvrusb2-context.h"
 #include "pvrusb2-hdw.h"
 #include "pvrusb2.h"
@@ -950,8 +951,13 @@ static void pvr2_v4l2_internal_check(struct pvr2_channel *chp)
 static long pvr2_v4l2_ioctl(struct file *file,
 			   unsigned int cmd, unsigned long arg)
 {
+	long ret;
 
-	return video_usercopy(file, cmd, arg, pvr2_v4l2_do_ioctl);
+	lock_kernel();
+	ret = video_usercopy(file, cmd, arg, pvr2_v4l2_do_ioctl);
+	unlock_kernel();
+
+	return ret;
 }
 
 
@@ -1231,12 +1237,12 @@ static unsigned int pvr2_v4l2_poll(struct file *file, poll_table *wait)
 
 
 static const struct v4l2_file_operations vdev_fops = {
-	.owner      = THIS_MODULE,
-	.open       = pvr2_v4l2_open,
-	.release    = pvr2_v4l2_release,
-	.read       = pvr2_v4l2_read,
-	.ioctl      = pvr2_v4l2_ioctl,
-	.poll       = pvr2_v4l2_poll,
+	.owner		= THIS_MODULE,
+	.open		= pvr2_v4l2_open,
+	.release	= pvr2_v4l2_release,
+	.read		= pvr2_v4l2_read,
+	.unlocked_ioctl	= pvr2_v4l2_ioctl,
+	.poll		= pvr2_v4l2_poll,
 };
 
 
diff --git a/drivers/media/video/pwc/pwc-if.c b/drivers/media/video/pwc/pwc-if.c
index aea7e22..cb9c93d 100644
--- a/drivers/media/video/pwc/pwc-if.c
+++ b/drivers/media/video/pwc/pwc-if.c
@@ -157,13 +157,13 @@ static long  pwc_video_ioctl(struct file *file,
 static int  pwc_video_mmap(struct file *file, struct vm_area_struct *vma);
 
 static const struct v4l2_file_operations pwc_fops = {
-	.owner =	THIS_MODULE,
-	.open =		pwc_video_open,
-	.release =     	pwc_video_close,
-	.read =		pwc_video_read,
-	.poll =		pwc_video_poll,
-	.mmap =		pwc_video_mmap,
-	.ioctl =        pwc_video_ioctl,
+	.owner		= THIS_MODULE,
+	.open		= pwc_video_open,
+	.release	= pwc_video_close,
+	.read		= pwc_video_read,
+	.poll		= pwc_video_poll,
+	.mmap		= pwc_video_mmap,
+	.unlocked_ioctl = pwc_video_ioctl,
 };
 static struct video_device pwc_template = {
 	.name =		"Philips Webcam",	/* Filled in later */
@@ -1424,8 +1424,11 @@ static long pwc_video_ioctl(struct file *file,
 	pdev = video_get_drvdata(vdev);
 
 	mutex_lock(&pdev->modlock);
-	if (!pdev->unplugged)
+	if (!pdev->unplugged) {
+		lock_kernel();
 		r = video_usercopy(file, cmd, arg, pwc_video_do_ioctl);
+		unlock_kernel();
+	}
 	mutex_unlock(&pdev->modlock);
 out:
 	return r;
diff --git a/drivers/media/video/saa5246a.c b/drivers/media/video/saa5246a.c
index 6b3b09e..095ce9c 100644
--- a/drivers/media/video/saa5246a.c
+++ b/drivers/media/video/saa5246a.c
@@ -47,6 +47,7 @@
 #include <linux/mutex.h>
 #include <linux/videotext.h>
 #include <linux/videodev2.h>
+#include <linux/smp_lock.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/v4l2-ioctl.h>
@@ -962,7 +963,9 @@ static long saa5246a_ioctl(struct file *file,
 
 	cmd = vtx_fix_command(cmd);
 	mutex_lock(&t->lock);
+	lock_kernel();
 	err = video_usercopy(file, cmd, arg, do_saa5246a_ioctl);
+	lock_kernel();
 	mutex_unlock(&t->lock);
 	return err;
 }
@@ -1026,10 +1029,10 @@ static int saa5246a_release(struct file *file)
 }
 
 static const struct v4l2_file_operations saa_fops = {
-	.owner	 = THIS_MODULE,
-	.open	 = saa5246a_open,
-	.release = saa5246a_release,
-	.ioctl	 = saa5246a_ioctl,
+	.owner		= THIS_MODULE,
+	.open		= saa5246a_open,
+	.release	= saa5246a_release,
+	.unlocked_ioctl	= saa5246a_ioctl,
 };
 
 static struct video_device saa_template =
diff --git a/drivers/media/video/saa5249.c b/drivers/media/video/saa5249.c
index 31ff27d..279c204 100644
--- a/drivers/media/video/saa5249.c
+++ b/drivers/media/video/saa5249.c
@@ -51,6 +51,7 @@
 #include <linux/videotext.h>
 #include <linux/videodev2.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/v4l2-ioctl.h>
@@ -498,8 +499,11 @@ static long saa5249_ioctl(struct file *file,
 
 	cmd = vtx_fix_command(cmd);
 	mutex_lock(&t->lock);
+	lock_kernel();
 	err = video_usercopy(file, cmd, arg, do_saa5249_ioctl);
+	unlock_kernel();
 	mutex_unlock(&t->lock);
+
 	return err;
 }
 
@@ -551,7 +555,7 @@ static const struct v4l2_file_operations saa_fops = {
 	.owner		= THIS_MODULE,
 	.open		= saa5249_open,
 	.release       	= saa5249_release,
-	.ioctl          = saa5249_ioctl,
+	.unlocked_ioctl = saa5249_ioctl,
 };
 
 static struct video_device saa_template =
diff --git a/drivers/media/video/se401.c b/drivers/media/video/se401.c
index 41d0166..285e31a 100644
--- a/drivers/media/video/se401.c
+++ b/drivers/media/video/se401.c
@@ -1154,7 +1154,13 @@ static long se401_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 static long se401_ioctl(struct file *file,
 		       unsigned int cmd, unsigned long arg)
 {
-	return video_usercopy(file, cmd, arg, se401_do_ioctl);
+	long ret;
+
+	lock_kernel();
+	ret = video_usercopy(file, cmd, arg, se401_do_ioctl);
+	unlock_kernel();
+
+	return ret;
 }
 
 static ssize_t se401_read(struct file *file, char __user *buf,
@@ -1237,12 +1243,12 @@ static int se401_mmap(struct file *file, struct vm_area_struct *vma)
 }
 
 static const struct v4l2_file_operations se401_fops = {
-	.owner  = 	THIS_MODULE,
-	.open =         se401_open,
-	.release =      se401_close,
-	.read =         se401_read,
-	.mmap =         se401_mmap,
-	.ioctl =        se401_ioctl,
+	.owner		= THIS_MODULE,
+	.open		= se401_open,
+	.release	= se401_close,
+	.read		= se401_read,
+	.mmap		= se401_mmap,
+	.unlocked_ioctl = se401_ioctl,
 };
 static struct video_device se401_template = {
 	.name =         "se401 USB camera",
diff --git a/drivers/media/video/sn9c102/sn9c102_core.c b/drivers/media/video/sn9c102/sn9c102_core.c
index 28e19da..843b56a 100644
--- a/drivers/media/video/sn9c102/sn9c102_core.c
+++ b/drivers/media/video/sn9c102/sn9c102_core.c
@@ -34,6 +34,7 @@
 #include <linux/mm.h>
 #include <linux/vmalloc.h>
 #include <linux/page-flags.h>
+#include <linux/smp_lock.h>
 #include <asm/byteorder.h>
 #include <asm/page.h>
 #include <asm/uaccess.h>
@@ -3232,16 +3233,28 @@ static long sn9c102_ioctl(struct file *filp,
 	return err;
 }
 
+static long
+sn9c102_locked_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+{
+	long ret;
+
+	lock_kernel();
+	ret = sn9c102_ioctl(filp, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
+
 /*****************************************************************************/
 
 static const struct v4l2_file_operations sn9c102_fops = {
-	.owner = THIS_MODULE,
-	.open = sn9c102_open,
-	.release = sn9c102_release,
-	.ioctl = sn9c102_ioctl,
-	.read = sn9c102_read,
-	.poll = sn9c102_poll,
-	.mmap = sn9c102_mmap,
+	.owner		= THIS_MODULE,
+	.open		= sn9c102_open,
+	.release	= sn9c102_release,
+	.unlocked_ioctl	= sn9c102_locked_ioctl,
+	.read		= sn9c102_read,
+	.poll		= sn9c102_poll,
+	.mmap		= sn9c102_mmap,
 };
 
 /*****************************************************************************/
diff --git a/drivers/media/video/stradis.c b/drivers/media/video/stradis.c
index a057824..51e4d9b 100644
--- a/drivers/media/video/stradis.c
+++ b/drivers/media/video/stradis.c
@@ -1739,6 +1739,18 @@ static long saa_ioctl(struct file *file,
 	return 0;
 }
 
+static long saa_locked_ioctl(struct file *file,
+		     unsigned int cmd, unsigned long argl)
+{
+	long ret;
+
+	lock_kernel();
+	ret = saa_ioctl(file, cmd, argl);
+	unlock_kernel();
+
+	return ret;
+}
+
 static int saa_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct saa7146 *saa = file->private_data;
@@ -1908,13 +1920,13 @@ static int saa_release(struct file *file)
 }
 
 static const struct v4l2_file_operations saa_fops = {
-	.owner = THIS_MODULE,
-	.open = saa_open,
-	.release = saa_release,
-	.ioctl = saa_ioctl,
-	.read = saa_read,
-	.write = saa_write,
-	.mmap = saa_mmap,
+	.owner		= THIS_MODULE,
+	.open		= saa_open,
+	.release	= saa_release,
+	.unlocked_ioctl = saa_locked_ioctl,
+	.read		= saa_read,
+	.write		= saa_write,
+	.mmap		= saa_mmap,
 };
 
 /* template for video_device-structure */
diff --git a/drivers/media/video/stv680.c b/drivers/media/video/stv680.c
index 5938ad8..675ae58 100644
--- a/drivers/media/video/stv680.c
+++ b/drivers/media/video/stv680.c
@@ -1304,7 +1304,13 @@ static long stv680_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 static long stv680_ioctl(struct file *file,
 			unsigned int cmd, unsigned long arg)
 {
-	return video_usercopy(file, cmd, arg, stv680_do_ioctl);
+	long ret;
+
+	lock_kernel();
+	ret = video_usercopy(file, cmd, arg, stv680_do_ioctl);
+	unlock_kernel();
+
+	return ret;
 }
 
 static int stv680_mmap (struct file *file, struct vm_area_struct *vma)
@@ -1394,12 +1400,12 @@ static ssize_t stv680_read (struct file *file, char __user *buf,
 }				/* stv680_read */
 
 static const struct v4l2_file_operations stv680_fops = {
-	.owner =	THIS_MODULE,
-	.open =		stv_open,
-	.release =     	stv_close,
-	.read =		stv680_read,
-	.mmap =		stv680_mmap,
-	.ioctl =        stv680_ioctl,
+	.owner		= THIS_MODULE,
+	.open		= stv_open,
+	.release	= stv_close,
+	.read		= stv680_read,
+	.mmap		= stv680_mmap,
+	.unlocked_ioctl	= stv680_ioctl,
 };
 static struct video_device stv680_template = {
 	.name =		"STV0680 USB camera",
diff --git a/drivers/media/video/usbvideo/usbvideo.c b/drivers/media/video/usbvideo/usbvideo.c
index 5ac37c6..b7865d8 100644
--- a/drivers/media/video/usbvideo/usbvideo.c
+++ b/drivers/media/video/usbvideo/usbvideo.c
@@ -23,6 +23,7 @@
 #include <linux/vmalloc.h>
 #include <linux/init.h>
 #include <linux/spinlock.h>
+#include <linux/smp_lock.h>
 
 #include <asm/io.h>
 
@@ -943,12 +944,12 @@ static int usbvideo_find_struct(struct usbvideo *cams)
 }
 
 static const struct v4l2_file_operations usbvideo_fops = {
-	.owner =  THIS_MODULE,
-	.open =   usbvideo_v4l_open,
-	.release =usbvideo_v4l_close,
-	.read =   usbvideo_v4l_read,
-	.mmap =   usbvideo_v4l_mmap,
-	.ioctl =  usbvideo_v4l_ioctl,
+	.owner		= THIS_MODULE,
+	.open		= usbvideo_v4l_open,
+	.release	= usbvideo_v4l_close,
+	.read		= usbvideo_v4l_read,
+	.mmap		= usbvideo_v4l_mmap,
+	.unlocked_ioctl = usbvideo_v4l_ioctl,
 };
 static const struct video_device usbvideo_template = {
 	.fops =       &usbvideo_fops,
@@ -1500,7 +1501,13 @@ static long usbvideo_v4l_do_ioctl(struct file *file, unsigned int cmd, void *arg
 static long usbvideo_v4l_ioctl(struct file *file,
 		       unsigned int cmd, unsigned long arg)
 {
-	return video_usercopy(file, cmd, arg, usbvideo_v4l_do_ioctl);
+	long ret;
+
+	lock_kernel();
+	ret = video_usercopy(file, cmd, arg, usbvideo_v4l_do_ioctl);
+	unlock_kernel();
+
+	return ret;
 }
 
 /*
diff --git a/drivers/media/video/usbvideo/vicam.c b/drivers/media/video/usbvideo/vicam.c
index 6030410..575a783 100644
--- a/drivers/media/video/usbvideo/vicam.c
+++ b/drivers/media/video/usbvideo/vicam.c
@@ -470,6 +470,18 @@ vicam_ioctl(struct file *file, unsigned int ioctlnr, unsigned long arg)
 	return retval;
 }
 
+static long
+vicam_locked_ioctl(struct file *file, unsigned int ioctlnr, unsigned long arg)
+{
+	long ret;
+
+	lock_kernel();
+	ret = vicam_ioctl(file, ioctlnr, arg);
+	unlock_kernel();
+
+	return ret;
+}
+
 static int
 vicam_open(struct file *file)
 {
@@ -790,7 +802,7 @@ static const struct v4l2_file_operations vicam_fops = {
 	.release	= vicam_close,
 	.read		= vicam_read,
 	.mmap		= vicam_mmap,
-	.ioctl		= vicam_ioctl,
+	.unlocked_ioctl	= vicam_locked_ioctl,
 };
 
 static struct video_device vicam_template = {
diff --git a/drivers/media/video/uvc/uvc_v4l2.c b/drivers/media/video/uvc/uvc_v4l2.c
index 7c9ab29..3971fa3 100644
--- a/drivers/media/video/uvc/uvc_v4l2.c
+++ b/drivers/media/video/uvc/uvc_v4l2.c
@@ -21,6 +21,7 @@
 #include <linux/vmalloc.h>
 #include <linux/mm.h>
 #include <linux/wait.h>
+#include <linux/smp_lock.h>
 #include <asm/atomic.h>
 
 #include <media/v4l2-common.h>
@@ -1029,13 +1030,19 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 static long uvc_v4l2_ioctl(struct file *file,
 		     unsigned int cmd, unsigned long arg)
 {
+	long ret;
+
 	if (uvc_trace_param & UVC_TRACE_IOCTL) {
 		uvc_printk(KERN_DEBUG, "uvc_v4l2_ioctl(");
 		v4l_printk_ioctl(cmd);
 		printk(")\n");
 	}
 
-	return video_usercopy(file, cmd, arg, uvc_v4l2_do_ioctl);
+	lock_kernel();
+	ret = video_usercopy(file, cmd, arg, uvc_v4l2_do_ioctl);
+	unlock_kernel();
+
+	return ret;
 }
 
 static ssize_t uvc_v4l2_read(struct file *file, char __user *data,
@@ -1134,7 +1141,7 @@ const struct v4l2_file_operations uvc_fops = {
 	.owner		= THIS_MODULE,
 	.open		= uvc_v4l2_open,
 	.release	= uvc_v4l2_release,
-	.ioctl		= uvc_v4l2_ioctl,
+	.unlocked_ioctl	= uvc_v4l2_ioctl,
 	.read		= uvc_v4l2_read,
 	.mmap		= uvc_v4l2_mmap,
 	.poll		= uvc_v4l2_poll,
diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index e17b6fe..b5e4855 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -1086,7 +1086,7 @@ static const struct v4l2_file_operations vivi_fops = {
 	.release        = vivi_close,
 	.read           = vivi_read,
 	.poll		= vivi_poll,
-	.ioctl          = video_ioctl2, /* V4L2 ioctl handler */
+	.unlocked_ioctl	= video_ioctl2, /* V4L2 ioctl handler */
 	.mmap           = vivi_mmap,
 };
 
diff --git a/drivers/media/video/w9968cf.c b/drivers/media/video/w9968cf.c
index d807eea..149a192 100644
--- a/drivers/media/video/w9968cf.c
+++ b/drivers/media/video/w9968cf.c
@@ -39,6 +39,7 @@
 #include <linux/ioctl.h>
 #include <linux/delay.h>
 #include <linux/stddef.h>
+#include <linux/smp_lock.h>
 #include <asm/page.h>
 #include <asm/uaccess.h>
 #include <linux/page-flags.h>
@@ -2846,6 +2847,18 @@ w9968cf_ioctl(struct file *filp,
 	return err;
 }
 
+static long
+w9968cf_locked_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+{
+	long ret;
+
+	lock_kernel();
+	ret = w9968cf_ioctl(filp, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
+
 
 static long w9968cf_v4l_ioctl(struct file *filp,
 			     unsigned int cmd, void __user *arg)
@@ -3390,12 +3403,12 @@ ioctl_fail:
 
 
 static const struct v4l2_file_operations w9968cf_fops = {
-	.owner =   THIS_MODULE,
-	.open =    w9968cf_open,
-	.release = w9968cf_release,
-	.read =    w9968cf_read,
-	.ioctl =   w9968cf_ioctl,
-	.mmap =    w9968cf_mmap,
+	.owner		= THIS_MODULE,
+	.open		= w9968cf_open,
+	.release	= w9968cf_release,
+	.read		= w9968cf_read,
+	.unlocked_ioctl	= w9968cf_locked_ioctl,
+	.mmap		= w9968cf_mmap,
 };
 
 
diff --git a/drivers/media/video/zc0301/zc0301_core.c b/drivers/media/video/zc0301/zc0301_core.c
index bb51cfb..b7c839b 100644
--- a/drivers/media/video/zc0301/zc0301_core.c
+++ b/drivers/media/video/zc0301/zc0301_core.c
@@ -38,6 +38,7 @@
 #include <linux/mm.h>
 #include <linux/vmalloc.h>
 #include <linux/page-flags.h>
+#include <linux/smp_lock.h>
 #include <asm/byteorder.h>
 #include <asm/page.h>
 #include <asm/uaccess.h>
@@ -1927,15 +1928,27 @@ static long zc0301_ioctl(struct file *filp,
 	return err;
 }
 
+static long
+zc0301_locked_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+{
+	long ret;
+
+	lock_kernel();
+	ret = zc0301_ioctl(filp, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
+
 
 static const struct v4l2_file_operations zc0301_fops = {
-	.owner =   THIS_MODULE,
-	.open =    zc0301_open,
-	.release = zc0301_release,
-	.ioctl =   zc0301_ioctl,
-	.read =    zc0301_read,
-	.poll =    zc0301_poll,
-	.mmap =    zc0301_mmap,
+	.owner		= THIS_MODULE,
+	.open		= zc0301_open,
+	.release	= zc0301_release,
+	.unlocked_ioctl = zc0301_locked_ioctl,
+	.read		= zc0301_read,
+	.poll		= zc0301_poll,
+	.mmap		= zc0301_mmap,
 };
 
 /*****************************************************************************/
diff --git a/drivers/staging/cx25821/cx25821-audups11.c b/drivers/staging/cx25821/cx25821-audups11.c
index 32c0e03..2d9b5d6 100644
--- a/drivers/staging/cx25821/cx25821-audups11.c
+++ b/drivers/staging/cx25821/cx25821-audups11.c
@@ -22,6 +22,7 @@
  */
 
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 
 #include "cx25821-video.h"
 
@@ -301,6 +302,7 @@ static long video_ioctl_upstream11(struct file *file, unsigned int cmd,
 		return 0;
 	}
 
+	lock_kernel();
 	dev->input_filename = data_from_user->input_filename;
 	dev->input_audiofilename = data_from_user->input_filename;
 	dev->vid_stdname = data_from_user->vid_stdname;
@@ -318,6 +320,8 @@ static long video_ioctl_upstream11(struct file *file, unsigned int cmd,
 		break;
 	}
 
+	unlock_kernel();
+
 	return 0;
 }
 
@@ -358,13 +362,13 @@ static int vidioc_s_ctrl(struct file *file, void *priv,
 
 // exported stuff
 static const struct v4l2_file_operations video_fops = {
-	.owner = THIS_MODULE,
-	.open = video_open,
-	.release = video_release,
-	.read = video_read,
-	.poll = video_poll,
-	.mmap = cx25821_video_mmap,
-	.ioctl = video_ioctl_upstream11,
+	.owner		= THIS_MODULE,
+	.open		= video_open,
+	.release	= video_release,
+	.read		= video_read,
+	.poll		= video_poll,
+	.mmap		= cx25821_video_mmap,
+	.unlocked_ioctl = video_ioctl_upstream11,
 };
 
 static const struct v4l2_ioctl_ops video_ioctl_ops = {
diff --git a/drivers/staging/cx25821/cx25821-videoioctl.c b/drivers/staging/cx25821/cx25821-videoioctl.c
index d16807d..0d178ba 100644
--- a/drivers/staging/cx25821/cx25821-videoioctl.c
+++ b/drivers/staging/cx25821/cx25821-videoioctl.c
@@ -21,6 +21,7 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include <linux/smp_lock.h>
 #include "cx25821-video.h"
 
 static void buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
@@ -387,6 +388,18 @@ static long video_ioctl_set(struct file *file, unsigned int cmd,
 	return 0;
 }
 
+static long video_locked_ioctl_set(struct file *file, unsigned int cmd,
+				   unsigned long arg)
+{
+	long ret;
+
+	lock_kernel();
+	ret = video_ioctl_set(file, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
+
 static int vidioc_log_status(struct file *file, void *priv)
 {
 	struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
@@ -419,13 +432,13 @@ static int vidioc_s_ctrl(struct file *file, void *priv,
 
 // exported stuff
 static const struct v4l2_file_operations video_fops = {
-	.owner = THIS_MODULE,
-	.open = video_open,
-	.release = video_release,
-	.read = video_read,
-	.poll = video_poll,
-	.mmap = cx25821_video_mmap,
-	.ioctl = video_ioctl_set,
+	.owner		= THIS_MODULE,
+	.open		= video_open,
+	.release	= video_release,
+	.read		= video_read,
+	.poll		= video_poll,
+	.mmap		= cx25821_video_mmap,
+	.unlocked_ioctl = video_locked_ioctl_set,
 };
 
 static const struct v4l2_ioctl_ops video_ioctl_ops = {
diff --git a/drivers/staging/cx25821/cx25821-vidups10.c b/drivers/staging/cx25821/cx25821-vidups10.c
index c746a17..bd872a7 100644
--- a/drivers/staging/cx25821/cx25821-vidups10.c
+++ b/drivers/staging/cx25821/cx25821-vidups10.c
@@ -21,6 +21,7 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include <linux/smp_lock.h>
 #include "cx25821-video.h"
 
 static void buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
@@ -271,6 +272,8 @@ static long video_ioctl_upstream10(struct file *file, unsigned int cmd,
 		return 0;
 	}
 
+	lock_kernel();
+
 	dev->input_filename_ch2 = data_from_user->input_filename;
 	dev->input_audiofilename = data_from_user->input_filename;
 	dev->vid_stdname_ch2 = data_from_user->vid_stdname;
@@ -288,6 +291,8 @@ static long video_ioctl_upstream10(struct file *file, unsigned int cmd,
 		break;
 	}
 
+	unlock_kernel();
+
 	return 0;
 }
 
@@ -357,13 +362,13 @@ static int vidioc_s_ctrl(struct file *file, void *priv,
 
 //exported stuff
 static const struct v4l2_file_operations video_fops = {
-	.owner = THIS_MODULE,
-	.open = video_open,
-	.release = video_release,
-	.read = video_read,
-	.poll = video_poll,
-	.mmap = cx25821_video_mmap,
-	.ioctl = video_ioctl_upstream10,
+	.owner		= THIS_MODULE,
+	.open		= video_open,
+	.release	= video_release,
+	.read		= video_read,
+	.poll		= video_poll,
+	.mmap		= cx25821_video_mmap,
+	.unlocked_ioctl = video_ioctl_upstream10,
 };
 
 static const struct v4l2_ioctl_ops video_ioctl_ops = {
diff --git a/drivers/staging/cx25821/cx25821-vidups9.c b/drivers/staging/cx25821/cx25821-vidups9.c
index 466e0f3..2cacee2 100644
--- a/drivers/staging/cx25821/cx25821-vidups9.c
+++ b/drivers/staging/cx25821/cx25821-vidups9.c
@@ -271,6 +271,8 @@ static long video_ioctl_upstream9(struct file *file, unsigned int cmd,
 		return 0;
 	}
 
+	lock_kernel();
+
 	dev->input_filename = data_from_user->input_filename;
 	dev->input_audiofilename = data_from_user->input_filename;
 	dev->vid_stdname = data_from_user->vid_stdname;
@@ -288,6 +290,8 @@ static long video_ioctl_upstream9(struct file *file, unsigned int cmd,
 		break;
 	}
 
+	unlock_kernel();
+
 	return 0;
 }
 
@@ -355,13 +359,13 @@ static int vidioc_s_ctrl(struct file *file, void *priv,
 
 // exported stuff
 static const struct v4l2_file_operations video_fops = {
-	.owner = THIS_MODULE,
-	.open = video_open,
-	.release = video_release,
-	.read = video_read,
-	.poll = video_poll,
-	.mmap = cx25821_video_mmap,
-	.ioctl = video_ioctl_upstream9,
+	.owner		= THIS_MODULE,
+	.open		= video_open,
+	.release	= video_release,
+	.read		= video_read,
+	.poll		= video_poll,
+	.mmap		= cx25821_video_mmap,
+	.unlocked_ioctl = video_ioctl_upstream9,
 };
 
 static const struct v4l2_ioctl_ops video_ioctl_ops = {
diff --git a/drivers/staging/dream/camera/msm_v4l2.c b/drivers/staging/dream/camera/msm_v4l2.c
index c276f2f..7744287 100644
--- a/drivers/staging/dream/camera/msm_v4l2.c
+++ b/drivers/staging/dream/camera/msm_v4l2.c
@@ -12,6 +12,7 @@
 #include <linux/spinlock.h>
 #include <linux/videodev2.h>
 #include <linux/proc_fs.h>
+#include <linux/smp_lock.h>
 #include <linux/slab.h>
 #include <media/v4l2-dev.h>
 #include <media/msm_camera.h>
@@ -99,6 +100,7 @@ static unsigned int msm_v4l2_poll(struct file *f, struct poll_table_struct *w)
 static long msm_v4l2_ioctl(struct file *filep,
 			   unsigned int cmd, unsigned long arg)
 {
+	long ret;
 	struct msm_ctrl_cmd *ctrlcmd;
 
 	D("msm_v4l2_ioctl, cmd = %d, %d\n", cmd, __LINE__);
@@ -119,18 +121,27 @@ static long msm_v4l2_ioctl(struct file *filep,
 		D("msm_v4l2_ioctl,  MSM_V4L2_START_SNAPSHOT v4l2 ioctl %d\n",
 		cmd);
 		ctrlcmd->type = MSM_V4L2_SNAPSHOT;
-		return g_pmsm_v4l2_dev->drv->ctrl(g_pmsm_v4l2_dev->drv->sync,
+		lock_kernel();
+		ret = g_pmsm_v4l2_dev->drv->ctrl(g_pmsm_v4l2_dev->drv->sync,
 							ctrlcmd);
+		unlock_kernel();
+		return ret;
 
 	case MSM_V4L2_GET_PICTURE:
 		D("msm_v4l2_ioctl,  MSM_V4L2_GET_PICTURE v4l2 ioctl %d\n", cmd);
 		ctrlcmd = (struct msm_ctrl_cmd *)arg;
-		return g_pmsm_v4l2_dev->drv->get_pict(
+		lock_kernel();
+		ret = g_pmsm_v4l2_dev->drv->get_pict(
 				g_pmsm_v4l2_dev->drv->sync, ctrlcmd);
+		unlock_kernel();
+		return ret;
 
 	default:
 		D("msm_v4l2_ioctl, standard v4l2 ioctl %d\n", cmd);
-		return video_ioctl2(filep, cmd, arg);
+		lock_kernel();
+		ret = video_ioctl2(filep, cmd, arg);
+		unlock_kernel();
+		return ret;
 	}
 }
 
@@ -640,11 +651,11 @@ int msm_v4l2_read_proc(char *pbuf, char **start, off_t offset,
 #endif
 
 static const struct v4l2_file_operations msm_v4l2_fops = {
-	.owner = THIS_MODULE,
-	.open = msm_v4l2_open,
-	.poll = msm_v4l2_poll,
-	.release = msm_v4l2_release,
-	.ioctl = msm_v4l2_ioctl,
+	.owner		= THIS_MODULE,
+	.open		= msm_v4l2_open,
+	.poll		= msm_v4l2_poll,
+	.release	= msm_v4l2_release,
+	.unlocked_ioctl = msm_v4l2_ioctl,
 };
 
 static void msm_v4l2_dev_init(struct msm_v4l2_device *pmsm_v4l2_dev)
-- 
1.6.2.3

