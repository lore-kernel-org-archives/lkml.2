Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761122Ab0J0Mar (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 08:30:47 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:49243 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755906Ab0J0Man (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 08:30:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH, RFC] v4l: kill the BKL
Date: Wed, 27 Oct 2010 14:30:32 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010271430.33034.arnd@arndb.de>
X-Provags-ID: V02:K0:IctP0tJLgKTS+jpqFgWvo4HFOUxaQENMS3KckPWj0H5
 oZkpysvVwkWUg2GJA1Fpqe++WQuZ9Jdlj165nB5jkawYeuCULv
 Sy3rAx8/ELojRfEWHOGRzSoLQQZRWg0SIRyAdZsRuV4WlnLpZu
 9y/pvFsS7nGp3B5/gkNhGxkSiXugaGphRb198MCdoAJgw+cToN
 ZsYlHP23659FXPfTfOj5A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All of the hard problems for BKL removal appear to be solved in the
v4l-dvb/master tree. This removes the BKL from the various open
functions that do not need it, or only use it to protect an
open count.

The zoran driver is nontrivial in this regard, so I introduce
a new mutex that locks both the open/release and the ioctl
functions. Someone with access to the hardware can probably
improve that by using the existing lock in all cases.

Finally, all drivers that still use the locked version of the
ioctl function now get called under a new mutex instead of
the BKL.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
Mauro, Hans,

Not sure if you were planning to do this in the merge window,
but it seems pointless to leave the BKL in V4L when it's so
easy to remove, especially after you've already done most
of the hard work.

This should not interfere with your effort to clean up the
rest of the locking, since the basic problem (locked ioctl)
is unchanged, it just replaces one global lock with another.

 drivers/media/Kconfig                       |    1 -
 drivers/media/video/cx231xx/cx231xx-417.c   |    6 +---
 drivers/media/video/cx23885/cx23885-417.c   |    9 +-------
 drivers/media/video/cx23885/cx23885-video.c |    5 ----
 drivers/media/video/se401.c                 |    7 ++---
 drivers/media/video/stk-webcam.c            |    4 ---
 drivers/media/video/tlg2300/pd-main.c       |   13 +++--------
 drivers/media/video/usbvideo/vicam.c        |   29 +++++++++++++--------------
 drivers/media/video/v4l2-dev.c              |    7 +++--
 drivers/media/video/zoran/zoran.h           |    1 +
 drivers/media/video/zoran/zoran_card.c      |    1 +
 drivers/media/video/zoran/zoran_driver.c    |   27 +++++++++++++++++++-----
 12 files changed, 51 insertions(+), 59 deletions(-)

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index bad2ced..a28541b 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -19,7 +19,6 @@ comment "Multimedia core support"
 
 config VIDEO_DEV
 	tristate "Video For Linux"
-	depends on BKL # used in many drivers for ioctl handling, need to kill
 	---help---
 	  V4L core support for video capture and overlay devices, webcams and
 	  AM/FM radio cards.
diff --git a/drivers/media/video/cx231xx/cx231xx-417.c b/drivers/media/video/cx231xx/cx231xx-417.c
index aab21f3..4c7cac3 100644
--- a/drivers/media/video/cx231xx/cx231xx-417.c
+++ b/drivers/media/video/cx231xx/cx231xx-417.c
@@ -31,7 +31,6 @@
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/firmware.h>
-#include <linux/smp_lock.h>
 #include <linux/vmalloc.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
@@ -1927,10 +1926,9 @@ static int mpeg_open(struct file *file)
 			dev = h;
 	}
 
-	if (dev == NULL) {
-		unlock_kernel();
+	if (dev == NULL)
 		return -ENODEV;
-	}
+
 	mutex_lock(&dev->lock);
 
 	/* allocate + initialize per filehandle data */
diff --git a/drivers/media/video/cx23885/cx23885-417.c b/drivers/media/video/cx23885/cx23885-417.c
index a6cc12f..9a98dc5 100644
--- a/drivers/media/video/cx23885/cx23885-417.c
+++ b/drivers/media/video/cx23885/cx23885-417.c
@@ -31,7 +31,6 @@
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/firmware.h>
-#include <linux/smp_lock.h>
 #include <linux/slab.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
@@ -1576,12 +1575,8 @@ static int mpeg_open(struct file *file)
 
 	/* allocate + initialize per filehandle data */
 	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
-	if (NULL == fh) {
-		unlock_kernel();
+	if (!fh)
 		return -ENOMEM;
-	}
-
-	lock_kernel();
 
 	file->private_data = fh;
 	fh->dev      = dev;
@@ -1592,8 +1587,6 @@ static int mpeg_open(struct file *file)
 			    V4L2_FIELD_INTERLACED,
 			    sizeof(struct cx23885_buffer),
 			    fh, NULL);
-	unlock_kernel();
-
 	return 0;
 }
 
diff --git a/drivers/media/video/cx23885/cx23885-video.c b/drivers/media/video/cx23885/cx23885-video.c
index 93af9c6..3cc9f46 100644
--- a/drivers/media/video/cx23885/cx23885-video.c
+++ b/drivers/media/video/cx23885/cx23885-video.c
@@ -26,7 +26,6 @@
 #include <linux/kmod.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/kthread.h>
@@ -743,8 +742,6 @@ static int video_open(struct file *file)
 	if (NULL == fh)
 		return -ENOMEM;
 
-	lock_kernel();
-
 	file->private_data = fh;
 	fh->dev      = dev;
 	fh->radio    = radio;
@@ -762,8 +759,6 @@ static int video_open(struct file *file)
 
 	dprintk(1, "post videobuf_queue_init()\n");
 
-	unlock_kernel();
-
 	return 0;
 }
 
diff --git a/drivers/media/video/se401.c b/drivers/media/video/se401.c
index 41d0166..41360d7 100644
--- a/drivers/media/video/se401.c
+++ b/drivers/media/video/se401.c
@@ -31,7 +31,6 @@ static const char version[] = "0.24";
 #include <linux/init.h>
 #include <linux/vmalloc.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/pagemap.h>
 #include <linux/usb.h>
 #include "se401.h"
@@ -951,9 +950,9 @@ static int se401_open(struct file *file)
 	struct usb_se401 *se401 = (struct usb_se401 *)dev;
 	int err = 0;
 
-	lock_kernel();
+	mutex_lock(&se401->lock);
 	if (se401->user) {
-		unlock_kernel();
+		mutex_unlock(&se401->lock);
 		return -EBUSY;
 	}
 	se401->fbuf = rvmalloc(se401->maxframesize * SE401_NUMFRAMES);
@@ -962,7 +961,7 @@ static int se401_open(struct file *file)
 	else
 		err = -ENOMEM;
 	se401->user = !err;
-	unlock_kernel();
+	mutex_unlock(&se401->lock);
 
 	return err;
 }
diff --git a/drivers/media/video/stk-webcam.c b/drivers/media/video/stk-webcam.c
index f07a0f6..b5afe5f 100644
--- a/drivers/media/video/stk-webcam.c
+++ b/drivers/media/video/stk-webcam.c
@@ -27,7 +27,6 @@
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 
 #include <linux/usb.h>
 #include <linux/mm.h>
@@ -673,14 +672,11 @@ static int v4l_stk_open(struct file *fp)
 	vdev = video_devdata(fp);
 	dev = vdev_to_camera(vdev);
 
-	lock_kernel();
 	if (dev == NULL || !is_present(dev)) {
-		unlock_kernel();
 		return -ENXIO;
 	}
 	fp->private_data = dev;
 	usb_autopm_get_interface(dev->interface);
-	unlock_kernel();
 
 	return 0;
 }
diff --git a/drivers/media/video/tlg2300/pd-main.c b/drivers/media/video/tlg2300/pd-main.c
index 4555f4a..c91424c 100644
--- a/drivers/media/video/tlg2300/pd-main.c
+++ b/drivers/media/video/tlg2300/pd-main.c
@@ -36,7 +36,6 @@
 #include <linux/string.h>
 #include <linux/types.h>
 #include <linux/firmware.h>
-#include <linux/smp_lock.h>
 
 #include "vendorcmds.h"
 #include "pd-common.h"
@@ -485,15 +484,11 @@ static void poseidon_disconnect(struct usb_interface *interface)
 	/*unregister v4l2 device */
 	v4l2_device_unregister(&pd->v4l2_dev);
 
-	lock_kernel();
-	{
-		pd_dvb_usb_device_exit(pd);
-		poseidon_fm_exit(pd);
+	pd_dvb_usb_device_exit(pd);
+	poseidon_fm_exit(pd);
 
-		poseidon_audio_free(pd);
-		pd_video_exit(pd);
-	}
-	unlock_kernel();
+	poseidon_audio_free(pd);
+	pd_video_exit(pd);
 
 	usb_set_intfdata(interface, NULL);
 	kref_put(&pd->kref, poseidon_delete);
diff --git a/drivers/media/video/usbvideo/vicam.c b/drivers/media/video/usbvideo/vicam.c
index 5d6fd01..dc17cce 100644
--- a/drivers/media/video/usbvideo/vicam.c
+++ b/drivers/media/video/usbvideo/vicam.c
@@ -43,7 +43,6 @@
 #include <linux/vmalloc.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/mutex.h>
 #include <linux/firmware.h>
 #include <linux/ihex.h>
@@ -483,29 +482,28 @@ vicam_open(struct file *file)
 		return -EINVAL;
 	}
 
-	/* the videodev_lock held above us protects us from
-	 * simultaneous opens...for now. we probably shouldn't
-	 * rely on this fact forever.
+	/* cam_lock/open_count protects us from simultaneous opens
+	 * ... for now. we probably shouldn't rely on this fact forever.
 	 */
 
-	lock_kernel();
+	mutex_lock(&cam->cam_lock);
 	if (cam->open_count > 0) {
 		printk(KERN_INFO
 		       "vicam_open called on already opened camera");
-		unlock_kernel();
+		mutex_unlock(&cam->cam_lock);
 		return -EBUSY;
 	}
 
 	cam->raw_image = kmalloc(VICAM_MAX_READ_SIZE, GFP_KERNEL);
 	if (!cam->raw_image) {
-		unlock_kernel();
+		mutex_unlock(&cam->cam_lock);
 		return -ENOMEM;
 	}
 
 	cam->framebuf = rvmalloc(VICAM_MAX_FRAME_SIZE * VICAM_FRAMES);
 	if (!cam->framebuf) {
 		kfree(cam->raw_image);
-		unlock_kernel();
+		mutex_unlock(&cam->cam_lock);
 		return -ENOMEM;
 	}
 
@@ -513,10 +511,17 @@ vicam_open(struct file *file)
 	if (!cam->cntrlbuf) {
 		kfree(cam->raw_image);
 		rvfree(cam->framebuf, VICAM_MAX_FRAME_SIZE * VICAM_FRAMES);
-		unlock_kernel();
+		mutex_unlock(&cam->cam_lock);
 		return -ENOMEM;
 	}
 
+	cam->needsDummyRead = 1;
+	cam->open_count++;
+
+	file->private_data = cam;
+	mutex_unlock(&cam->cam_lock);
+
+
 	// First upload firmware, then turn the camera on
 
 	if (!cam->is_initialized) {
@@ -527,12 +532,6 @@ vicam_open(struct file *file)
 
 	set_camera_power(cam, 1);
 
-	cam->needsDummyRead = 1;
-	cam->open_count++;
-
-	file->private_data = cam;
-	unlock_kernel();
-
 	return 0;
 }
 
diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index 0ca7978..03f7f46 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -25,7 +25,6 @@
 #include <linux/init.h>
 #include <linux/kmod.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <asm/uaccess.h>
 #include <asm/system.h>
 
@@ -247,10 +246,12 @@ static long v4l2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			mutex_unlock(vdev->lock);
 	} else if (vdev->fops->ioctl) {
 		/* TODO: convert all drivers to unlocked_ioctl */
-		lock_kernel();
+		static DEFINE_MUTEX(v4l2_ioctl_mutex);
+
+		mutex_lock(&v4l2_ioctl_mutex);
 		if (video_is_registered(vdev))
 			ret = vdev->fops->ioctl(filp, cmd, arg);
-		unlock_kernel();
+		mutex_unlock(&v4l2_ioctl_mutex);
 	} else
 		ret = -ENOTTY;
 
diff --git a/drivers/media/video/zoran/zoran.h b/drivers/media/video/zoran/zoran.h
index 37fe161..27f0555 100644
--- a/drivers/media/video/zoran/zoran.h
+++ b/drivers/media/video/zoran/zoran.h
@@ -388,6 +388,7 @@ struct zoran {
 	struct videocodec *vfe;	/* video front end */
 
 	struct mutex resource_lock;	/* prevent evil stuff */
+	struct mutex other_lock;	/* please merge with above */
 
 	u8 initialized;		/* flag if zoran has been correctly initialized */
 	int user;		/* number of current users */
diff --git a/drivers/media/video/zoran/zoran_card.c b/drivers/media/video/zoran/zoran_card.c
index 0aac376..7e6d624 100644
--- a/drivers/media/video/zoran/zoran_card.c
+++ b/drivers/media/video/zoran/zoran_card.c
@@ -1227,6 +1227,7 @@ static int __devinit zoran_probe(struct pci_dev *pdev,
 	snprintf(ZR_DEVNAME(zr), sizeof(ZR_DEVNAME(zr)), "MJPEG[%u]", zr->id);
 	spin_lock_init(&zr->spinlock);
 	mutex_init(&zr->resource_lock);
+	mutex_init(&zr->other_lock);
 	if (pci_enable_device(pdev))
 		goto zr_unreg;
 	pci_read_config_byte(zr->pci_dev, PCI_CLASS_REVISION, &zr->revision);
diff --git a/drivers/media/video/zoran/zoran_driver.c b/drivers/media/video/zoran/zoran_driver.c
index 401082b..04e916f 100644
--- a/drivers/media/video/zoran/zoran_driver.c
+++ b/drivers/media/video/zoran/zoran_driver.c
@@ -49,7 +49,6 @@
 #include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/pci.h>
 #include <linux/vmalloc.h>
 #include <linux/wait.h>
@@ -913,7 +912,7 @@ static int zoran_open(struct file *file)
 	dprintk(2, KERN_INFO "%s: %s(%s, pid=[%d]), users(-)=%d\n",
 		ZR_DEVNAME(zr), __func__, current->comm, task_pid_nr(current), zr->user + 1);
 
-	lock_kernel();
+	mutex_lock(&zr->other_lock);
 
 	if (zr->user >= 2048) {
 		dprintk(1, KERN_ERR "%s: too many users (%d) on device\n",
@@ -963,14 +962,14 @@ static int zoran_open(struct file *file)
 	file->private_data = fh;
 	fh->zr = zr;
 	zoran_open_init_session(fh);
-	unlock_kernel();
+	mutex_unlock(&zr->other_lock);
 
 	return 0;
 
 fail_fh:
 	kfree(fh);
 fail_unlock:
-	unlock_kernel();
+	mutex_unlock(&zr->other_lock);
 
 	dprintk(2, KERN_INFO "%s: open failed (%d), users(-)=%d\n",
 		ZR_DEVNAME(zr), res, zr->user);
@@ -989,7 +988,7 @@ zoran_close(struct file  *file)
 
 	/* kernel locks (fs/device.c), so don't do that ourselves
 	 * (prevents deadlocks) */
-	/*mutex_lock(&zr->resource_lock);*/
+	mutex_lock(&zr->other_lock);
 
 	zoran_close_end_session(fh);
 
@@ -1023,6 +1022,7 @@ zoran_close(struct file  *file)
 			encoder_call(zr, video, s_routing, 2, 0, 0);
 		}
 	}
+	mutex_unlock(&zr->other_lock);
 
 	file->private_data = NULL;
 	kfree(fh->overlay_mask);
@@ -3370,11 +3370,26 @@ static const struct v4l2_ioctl_ops zoran_ioctl_ops = {
 #endif
 };
 
+/* please use zr->resource_lock consistently and kill this wrapper */
+static long zoran_ioctl(struct file *file, unsigned int cmd,
+			unsigned long arg)
+{
+	struct zoran_fh *fh = file->private_data;
+	struct zoran *zr = fh->zr;
+	int ret;
+
+	mutex_lock(&zr->other_lock);
+	ret = video_ioctl2(file, cmd, arg);
+	mutex_unlock(&zr->other_lock);
+
+	return ret;
+}
+
 static const struct v4l2_file_operations zoran_fops = {
 	.owner = THIS_MODULE,
 	.open = zoran_open,
 	.release = zoran_close,
-	.ioctl = video_ioctl2,
+	.unlocked_ioctl = zoran_ioctl,
 	.read = zoran_read,
 	.write = zoran_write,
 	.mmap = zoran_mmap,
