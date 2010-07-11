Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab0GKVTg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 17:19:36 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:50476 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755208Ab0GKVTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 17:19:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org
Subject: [PATCH 04/12] media: autoconvert trivial BKL users to private mutex
Date: Sun, 11 Jul 2010 23:18:55 +0200
Message-Id: <1278883143-29035-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1278883143-29035-1-git-send-email-arnd@arndb.de>
References: <1278883143-29035-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:o5YkiCh9kuTWSzW52oVS+uLygSVSPbrhxzkB1EKeBFm
 ULp3LNjhBl/qDltxiFkEq6cBGEoz7c/ulNMerz0YkoWif0TN3n
 nnfXuBO7vqFCh1/OqptfANYq2LvhXYQBEmi/ZoTvduuqUi319L
 F/F8NnSfosAgH8kPmpv7zX5X9EZYF2YVPrzPN/heUpEl0Eq+we
 cvBQi70lMH9WHUqdYPZkQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All these files use the big kernel lock in a trivial
way to serialize their private file operations,
typically resulting from an earlier semi-automatic
pushdown from VFS.

None of these drivers appears to want to lock against
other code, and they all use the BKL as the top-level
lock in their file operations, meaning that there
is no lock-order inversion problem.

Consequently, we can remove the BKL completely,
replacing it with a per-file mutex in every case.
Using a scripted approach means we can avoid
typos.

file=$1
name=$2
if grep -q lock_kernel ${file} ; then
    if grep -q 'include.*linux.mutex.h' ${file} ; then
            sed -i '/include.*<linux\/smp_lock.h>/d' ${file}
    else
            sed -i 's/include.*<linux\/smp_lock.h>.*$/include <linux\/mutex.h>/g' ${file}
    fi
    sed -i ${file} \
        -e "/^#include.*linux.mutex.h/,$ {
                1,/^\(static\|int\|long\)/ {
                     /^\(static\|int\|long\)/istatic DEFINE_MUTEX(${name}_mutex);

} }"  \
    -e "s/\(un\)*lock_kernel\>[ ]*()/mutex_\1lock(\&${name}_mutex)/g" \
    -e '/[      ]*cycle_kernel_lock();/d'
else
    sed -i -e '/include.*\<smp_lock.h\>/d' ${file}  \
                -e '/cycle_kernel_lock()/d'
fi

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
---
 drivers/media/dvb/bt8xx/dst_ca.c          |    7 ++++---
 drivers/media/video/cx88/cx88-blackbird.c |   13 +++++++------
 drivers/media/video/dabusb.c              |   18 +++++++++---------
 drivers/media/video/se401.c               |    9 +++++----
 drivers/media/video/stradis.c             |    9 +++++----
 drivers/media/video/usbvideo/vicam.c      |   14 +++++++-------
 6 files changed, 37 insertions(+), 33 deletions(-)

diff --git a/drivers/media/dvb/bt8xx/dst_ca.c b/drivers/media/dvb/bt8xx/dst_ca.c
index 770243c..f0c59c0 100644
--- a/drivers/media/dvb/bt8xx/dst_ca.c
+++ b/drivers/media/dvb/bt8xx/dst_ca.c
@@ -22,7 +22,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/init.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/string.h>
 #include <linux/dvb/ca.h>
 #include "dvbdev.h"
@@ -52,6 +52,7 @@
 } while(0)
 
 
+static DEFINE_MUTEX(dst_ca_mutex);
 static unsigned int verbose = 5;
 module_param(verbose, int, 0644);
 MODULE_PARM_DESC(verbose, "verbose startup messages, default is 1 (yes)");
@@ -564,7 +565,7 @@ static long dst_ca_ioctl(struct file *file, unsigned int cmd, unsigned long ioct
 	void __user *arg = (void __user *)ioctl_arg;
 	int result = 0;
 
-	lock_kernel();
+	mutex_lock(&dst_ca_mutex);
 	dvbdev = (struct dvb_device *)file->private_data;
 	state = (struct dst_state *)dvbdev->priv;
 	p_ca_message = kmalloc(sizeof (struct ca_msg), GFP_KERNEL);
@@ -652,7 +653,7 @@ static long dst_ca_ioctl(struct file *file, unsigned int cmd, unsigned long ioct
 	kfree (p_ca_slot_info);
 	kfree (p_ca_caps);
 
-	unlock_kernel();
+	mutex_unlock(&dst_ca_mutex);
 	return result;
 }
 
diff --git a/drivers/media/video/cx88/cx88-blackbird.c b/drivers/media/video/cx88/cx88-blackbird.c
index e46e1ce..6bb59f1 100644
--- a/drivers/media/video/cx88/cx88-blackbird.c
+++ b/drivers/media/video/cx88/cx88-blackbird.c
@@ -33,7 +33,7 @@
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/firmware.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 #include <media/cx2341x.h>
@@ -44,6 +44,7 @@ MODULE_DESCRIPTION("driver for cx2388x/cx23416 based mpeg encoder cards");
 MODULE_AUTHOR("Jelle Foks <jelle@foks.us>, Gerd Knorr <kraxel@bytesex.org> [SuSE Labs]");
 MODULE_LICENSE("GPL");
 
+static DEFINE_MUTEX(mpeg_mutex);
 static unsigned int mpegbufs = 32;
 module_param(mpegbufs,int,0644);
 MODULE_PARM_DESC(mpegbufs,"number of mpeg buffers, range 2-32");
@@ -1057,7 +1058,7 @@ static int mpeg_open(struct file *file)
 
 	dprintk( 1, "%s\n", __func__);
 
-	lock_kernel();
+	mutex_lock(&mpeg_mutex);
 
 	/* Make sure we can acquire the hardware */
 	drv = cx8802_get_driver(dev, CX88_MPEG_BLACKBIRD);
@@ -1065,7 +1066,7 @@ static int mpeg_open(struct file *file)
 		err = drv->request_acquire(drv);
 		if(err != 0) {
 			dprintk(1,"%s: Unable to acquire hardware, %d\n", __func__, err);
-			unlock_kernel();
+			mutex_unlock(&mpeg_mutex);
 			return err;
 		}
 	}
@@ -1073,7 +1074,7 @@ static int mpeg_open(struct file *file)
 	if (!atomic_read(&dev->core->mpeg_users) && blackbird_initialize_codec(dev) < 0) {
 		if (drv)
 			drv->request_release(drv);
-		unlock_kernel();
+		mutex_unlock(&mpeg_mutex);
 		return -EINVAL;
 	}
 	dprintk(1, "open dev=%s\n", video_device_node_name(vdev));
@@ -1083,7 +1084,7 @@ static int mpeg_open(struct file *file)
 	if (NULL == fh) {
 		if (drv)
 			drv->request_release(drv);
-		unlock_kernel();
+		mutex_unlock(&mpeg_mutex);
 		return -ENOMEM;
 	}
 	file->private_data = fh;
@@ -1099,7 +1100,7 @@ static int mpeg_open(struct file *file)
 	/* FIXME: locking against other video device */
 	cx88_set_scale(dev->core, dev->width, dev->height,
 			fh->mpegq.field);
-	unlock_kernel();
+	mutex_unlock(&mpeg_mutex);
 
 	atomic_inc(&dev->core->mpeg_users);
 
diff --git a/drivers/media/video/dabusb.c b/drivers/media/video/dabusb.c
index 0f50508..716d0ee 100644
--- a/drivers/media/video/dabusb.c
+++ b/drivers/media/video/dabusb.c
@@ -32,7 +32,6 @@
 #include <linux/list.h>
 #include <linux/vmalloc.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/init.h>
 #include <asm/uaccess.h>
 #include <asm/atomic.h>
@@ -61,6 +60,7 @@
 
 /*-------------------------------------------------------------------*/
 
+static DEFINE_MUTEX(dabusb_mutex);
 static dabusb_t dabusb[NRDABUSB];
 static int buffers = 256;
 static struct usb_driver dabusb_driver;
@@ -621,7 +621,7 @@ static int dabusb_open (struct inode *inode, struct file *file)
 	if (devnum < DABUSB_MINOR || devnum >= (DABUSB_MINOR + NRDABUSB))
 		return -EIO;
 
-	lock_kernel();
+	mutex_lock(&dabusb_mutex);
 	s = &dabusb[devnum - DABUSB_MINOR];
 
 	dbg("dabusb_open");
@@ -636,7 +636,7 @@ static int dabusb_open (struct inode *inode, struct file *file)
 		msleep_interruptible(500);
 
 		if (signal_pending (current)) {
-			unlock_kernel();
+			mutex_unlock(&dabusb_mutex);
 			return -EAGAIN;
 		}
 		mutex_lock(&s->mutex);
@@ -644,7 +644,7 @@ static int dabusb_open (struct inode *inode, struct file *file)
 	if (usb_set_interface (s->usbdev, _DABUSB_IF, 1) < 0) {
 		mutex_unlock(&s->mutex);
 		dev_err(&s->usbdev->dev, "set_interface failed\n");
-		unlock_kernel();
+		mutex_unlock(&dabusb_mutex);
 		return -EINVAL;
 	}
 	s->opened = 1;
@@ -654,7 +654,7 @@ static int dabusb_open (struct inode *inode, struct file *file)
 	file->private_data = s;
 
 	r = nonseekable_open(inode, file);
-	unlock_kernel();
+	mutex_unlock(&dabusb_mutex);
 	return r;
 }
 
@@ -689,9 +689,9 @@ static long dabusb_ioctl (struct file *file, unsigned int cmd, unsigned long arg
 
 	dbg("dabusb_ioctl");
 
-	lock_kernel();
+	mutex_lock(&dabusb_mutex);
 	if (s->remove_pending) {
-		unlock_kernel();
+		mutex_unlock(&dabusb_mutex);
 		return -EIO;
 	}
 
@@ -699,7 +699,7 @@ static long dabusb_ioctl (struct file *file, unsigned int cmd, unsigned long arg
 
 	if (!s->usbdev) {
 		mutex_unlock(&s->mutex);
-		unlock_kernel();
+		mutex_unlock(&dabusb_mutex);
 		return -EIO;
 	}
 
@@ -740,7 +740,7 @@ static long dabusb_ioctl (struct file *file, unsigned int cmd, unsigned long arg
 		break;
 	}
 	mutex_unlock(&s->mutex);
-	unlock_kernel();
+	mutex_unlock(&dabusb_mutex);
 	return ret;
 }
 
diff --git a/drivers/media/video/se401.c b/drivers/media/video/se401.c
index 41d0166..87cfdd9 100644
--- a/drivers/media/video/se401.c
+++ b/drivers/media/video/se401.c
@@ -31,11 +31,12 @@ static const char version[] = "0.24";
 #include <linux/init.h>
 #include <linux/vmalloc.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/pagemap.h>
 #include <linux/usb.h>
 #include "se401.h"
 
+static DEFINE_MUTEX(se401_mutex);
 static int flickerless;
 static int video_nr = -1;
 
@@ -951,9 +952,9 @@ static int se401_open(struct file *file)
 	struct usb_se401 *se401 = (struct usb_se401 *)dev;
 	int err = 0;
 
-	lock_kernel();
+	mutex_lock(&se401_mutex);
 	if (se401->user) {
-		unlock_kernel();
+		mutex_unlock(&se401_mutex);
 		return -EBUSY;
 	}
 	se401->fbuf = rvmalloc(se401->maxframesize * SE401_NUMFRAMES);
@@ -962,7 +963,7 @@ static int se401_open(struct file *file)
 	else
 		err = -ENOMEM;
 	se401->user = !err;
-	unlock_kernel();
+	mutex_unlock(&se401_mutex);
 
 	return err;
 }
diff --git a/drivers/media/video/stradis.c b/drivers/media/video/stradis.c
index a057824..844ef47 100644
--- a/drivers/media/video/stradis.c
+++ b/drivers/media/video/stradis.c
@@ -26,7 +26,7 @@
 #include <linux/kernel.h>
 #include <linux/major.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/mm.h>
 #include <linux/init.h>
 #include <linux/poll.h>
@@ -58,6 +58,7 @@
 
 #define SAA7146_MAX 6
 
+static DEFINE_MUTEX(saa_mutex);
 static struct saa7146 saa7146s[SAA7146_MAX];
 
 static int saa_num;		/* number of SAA7146s in use */
@@ -1883,16 +1884,16 @@ static int saa_open(struct file *file)
 	struct video_device *vdev = video_devdata(file);
 	struct saa7146 *saa = container_of(vdev, struct saa7146, video_dev);
 
-	lock_kernel();
+	mutex_lock(&saa_mutex);
 	file->private_data = saa;
 
 	saa->user++;
 	if (saa->user > 1) {
-		unlock_kernel();
+		mutex_unlock(&saa_mutex);
 		return 0;	/* device open already, don't reset */
 	}
 	saa->writemode = VID_WRITE_MPEG_VID;	/* default to video */
-	unlock_kernel();
+	mutex_unlock(&saa_mutex);
 	return 0;
 }
 
diff --git a/drivers/media/video/usbvideo/vicam.c b/drivers/media/video/usbvideo/vicam.c
index 6030410..a87b5b4 100644
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
@@ -81,6 +80,7 @@
  * in the future.
  *
 */
+static DEFINE_MUTEX(vicam_mutex);
 static void *rvmalloc(unsigned long size)
 {
 	void *mem;
@@ -488,24 +488,24 @@ vicam_open(struct file *file)
 	 * rely on this fact forever.
 	 */
 
-	lock_kernel();
+	mutex_lock(&vicam_mutex);
 	if (cam->open_count > 0) {
 		printk(KERN_INFO
 		       "vicam_open called on already opened camera");
-		unlock_kernel();
+		mutex_unlock(&vicam_mutex);
 		return -EBUSY;
 	}
 
 	cam->raw_image = kmalloc(VICAM_MAX_READ_SIZE, GFP_KERNEL);
 	if (!cam->raw_image) {
-		unlock_kernel();
+		mutex_unlock(&vicam_mutex);
 		return -ENOMEM;
 	}
 
 	cam->framebuf = rvmalloc(VICAM_MAX_FRAME_SIZE * VICAM_FRAMES);
 	if (!cam->framebuf) {
 		kfree(cam->raw_image);
-		unlock_kernel();
+		mutex_unlock(&vicam_mutex);
 		return -ENOMEM;
 	}
 
@@ -513,7 +513,7 @@ vicam_open(struct file *file)
 	if (!cam->cntrlbuf) {
 		kfree(cam->raw_image);
 		rvfree(cam->framebuf, VICAM_MAX_FRAME_SIZE * VICAM_FRAMES);
-		unlock_kernel();
+		mutex_unlock(&vicam_mutex);
 		return -ENOMEM;
 	}
 
@@ -531,7 +531,7 @@ vicam_open(struct file *file)
 	cam->open_count++;
 
 	file->private_data = cam;
-	unlock_kernel();
+	mutex_unlock(&vicam_mutex);
 
 	return 0;
 }
-- 
1.7.1

