Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab0DZWYy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 18:24:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59680 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755226Ab0DZWYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 18:24:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@zeniv.linux.org.uk>,
       Jan Blunck <jblunck@suse.de>, Ingo Molnar <mingo@elte.hu>,
       John Kacur <jkacur@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 1/6] dvb: push down BKL into ioctl functions
Date: Tue, 27 Apr 2010 00:24:00 +0200
Message-Id: <1272320645-8671-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <201004262112.39906.arnd@arndb.de>
References: <201004262112.39906.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18PSvaypX/PDf2Xbwt86lbjUrVbYodS1AI/9fE
 hyh9SwEcEm4l6ExBQeYJVJSmXd/jux1W4ALfn9vRlnQBgd+SFA
 g5GEL+tw5mQyxbh0ZleaQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This requires changing all users of dvb_usercopy to
omit the inode argument.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/dvb/dvb-core/dmxdev.c         |   31 +++++++++++++++++++-------
 drivers/media/dvb/dvb-core/dvb_ca_en50221.c |   17 ++++++++++----
 drivers/media/dvb/dvb-core/dvb_frontend.c   |   30 +++++++++++++-------------
 drivers/media/dvb/dvb-core/dvb_net.c        |   15 +++++++++---
 drivers/media/dvb/dvb-core/dvbdev.c         |   17 +++++++++-----
 drivers/media/dvb/dvb-core/dvbdev.h         |   11 +++------
 drivers/media/dvb/firewire/firedtv-ci.c     |    5 +--
 drivers/media/dvb/ttpci/av7110.c            |    4 +-
 drivers/media/dvb/ttpci/av7110_av.c         |    8 +++---
 drivers/media/dvb/ttpci/av7110_ca.c         |    5 +--
 10 files changed, 85 insertions(+), 58 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dmxdev.c b/drivers/media/dvb/dvb-core/dmxdev.c
index 9ddc579..425862f 100644
--- a/drivers/media/dvb/dvb-core/dmxdev.c
+++ b/drivers/media/dvb/dvb-core/dmxdev.c
@@ -25,6 +25,7 @@
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/module.h>
+#include <linux/smp_lock.h>
 #include <linux/poll.h>
 #include <linux/ioctl.h>
 #include <linux/wait.h>
@@ -963,7 +964,7 @@ dvb_demux_read(struct file *file, char __user *buf, size_t count,
 	return ret;
 }
 
-static int dvb_demux_do_ioctl(struct inode *inode, struct file *file,
+static int dvb_demux_do_ioctl(struct file *file,
 			      unsigned int cmd, void *parg)
 {
 	struct dmxdev_filter *dmxdevfilter = file->private_data;
@@ -1084,10 +1085,16 @@ static int dvb_demux_do_ioctl(struct inode *inode, struct file *file,
 	return ret;
 }
 
-static int dvb_demux_ioctl(struct inode *inode, struct file *file,
-			   unsigned int cmd, unsigned long arg)
+static long dvb_demux_ioctl(struct file *file, unsigned int cmd,
+			    unsigned long arg)
 {
-	return dvb_usercopy(inode, file, cmd, arg, dvb_demux_do_ioctl);
+	int ret;
+
+	lock_kernel();
+	ret = dvb_usercopy(file, cmd, arg, dvb_demux_do_ioctl);
+	unlock_kernel();
+
+	return ret;
 }
 
 static unsigned int dvb_demux_poll(struct file *file, poll_table *wait)
@@ -1139,7 +1146,7 @@ static int dvb_demux_release(struct inode *inode, struct file *file)
 static const struct file_operations dvb_demux_fops = {
 	.owner = THIS_MODULE,
 	.read = dvb_demux_read,
-	.ioctl = dvb_demux_ioctl,
+	.unlocked_ioctl = dvb_demux_ioctl,
 	.open = dvb_demux_open,
 	.release = dvb_demux_release,
 	.poll = dvb_demux_poll,
@@ -1152,7 +1159,7 @@ static struct dvb_device dvbdev_demux = {
 	.fops = &dvb_demux_fops
 };
 
-static int dvb_dvr_do_ioctl(struct inode *inode, struct file *file,
+static int dvb_dvr_do_ioctl(struct file *file,
 			    unsigned int cmd, void *parg)
 {
 	struct dvb_device *dvbdev = file->private_data;
@@ -1176,10 +1183,16 @@ static int dvb_dvr_do_ioctl(struct inode *inode, struct file *file,
 	return ret;
 }
 
-static int dvb_dvr_ioctl(struct inode *inode, struct file *file,
+static long dvb_dvr_ioctl(struct file *file,
 			 unsigned int cmd, unsigned long arg)
 {
-	return dvb_usercopy(inode, file, cmd, arg, dvb_dvr_do_ioctl);
+	int ret;
+
+	lock_kernel();
+	ret = dvb_usercopy(file, cmd, arg, dvb_dvr_do_ioctl);
+	unlock_kernel();
+
+	return ret;
 }
 
 static unsigned int dvb_dvr_poll(struct file *file, poll_table *wait)
@@ -1208,7 +1221,7 @@ static const struct file_operations dvb_dvr_fops = {
 	.owner = THIS_MODULE,
 	.read = dvb_dvr_read,
 	.write = dvb_dvr_write,
-	.ioctl = dvb_dvr_ioctl,
+	.unlocked_ioctl = dvb_dvr_ioctl,
 	.open = dvb_dvr_open,
 	.release = dvb_dvr_release,
 	.poll = dvb_dvr_poll,
diff --git a/drivers/media/dvb/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb/dvb-core/dvb_ca_en50221.c
index cb22da5..ef259a0 100644
--- a/drivers/media/dvb/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb/dvb-core/dvb_ca_en50221.c
@@ -36,6 +36,7 @@
 #include <linux/delay.h>
 #include <linux/spinlock.h>
 #include <linux/sched.h>
+#include <linux/smp_lock.h>
 #include <linux/kthread.h>
 
 #include "dvb_ca_en50221.h"
@@ -1181,7 +1182,7 @@ static int dvb_ca_en50221_thread(void *data)
  *
  * @return 0 on success, <0 on error.
  */
-static int dvb_ca_en50221_io_do_ioctl(struct inode *inode, struct file *file,
+static int dvb_ca_en50221_io_do_ioctl(struct file *file,
 				      unsigned int cmd, void *parg)
 {
 	struct dvb_device *dvbdev = file->private_data;
@@ -1255,10 +1256,16 @@ static int dvb_ca_en50221_io_do_ioctl(struct inode *inode, struct file *file,
  *
  * @return 0 on success, <0 on error.
  */
-static int dvb_ca_en50221_io_ioctl(struct inode *inode, struct file *file,
-				   unsigned int cmd, unsigned long arg)
+static long dvb_ca_en50221_io_ioctl(struct file *file,
+				    unsigned int cmd, unsigned long arg)
 {
-	return dvb_usercopy(inode, file, cmd, arg, dvb_ca_en50221_io_do_ioctl);
+	int ret;
+
+	lock_kernel();
+	ret = dvb_usercopy(file, cmd, arg, dvb_ca_en50221_io_do_ioctl);
+	unlock_kernel();
+
+	return ret;
 }
 
 
@@ -1611,7 +1618,7 @@ static const struct file_operations dvb_ca_fops = {
 	.owner = THIS_MODULE,
 	.read = dvb_ca_en50221_io_read,
 	.write = dvb_ca_en50221_io_write,
-	.ioctl = dvb_ca_en50221_io_ioctl,
+	.unlocked_ioctl = dvb_ca_en50221_io_ioctl,
 	.open = dvb_ca_en50221_io_open,
 	.release = dvb_ca_en50221_io_release,
 	.poll = dvb_ca_en50221_io_poll,
diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 55ea260..5450d1f 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -36,6 +36,7 @@
 #include <linux/list.h>
 #include <linux/freezer.h>
 #include <linux/jiffies.h>
+#include <linux/smp_lock.h>
 #include <linux/kthread.h>
 #include <asm/processor.h>
 
@@ -1188,14 +1189,14 @@ static void dtv_property_cache_submit(struct dvb_frontend *fe)
 	}
 }
 
-static int dvb_frontend_ioctl_legacy(struct inode *inode, struct file *file,
+static int dvb_frontend_ioctl_legacy(struct file *file,
 			unsigned int cmd, void *parg);
-static int dvb_frontend_ioctl_properties(struct inode *inode, struct file *file,
+static int dvb_frontend_ioctl_properties(struct file *file,
 			unsigned int cmd, void *parg);
 
 static int dtv_property_process_get(struct dvb_frontend *fe,
 				    struct dtv_property *tvp,
-				    struct inode *inode, struct file *file)
+				    struct file *file)
 {
 	int r = 0;
 
@@ -1328,7 +1329,6 @@ static int dtv_property_process_get(struct dvb_frontend *fe,
 
 static int dtv_property_process_set(struct dvb_frontend *fe,
 				    struct dtv_property *tvp,
-				    struct inode *inode,
 				    struct file *file)
 {
 	int r = 0;
@@ -1359,7 +1359,7 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
 		dprintk("%s() Finalised property cache\n", __func__);
 		dtv_property_cache_submit(fe);
 
-		r |= dvb_frontend_ioctl_legacy(inode, file, FE_SET_FRONTEND,
+		r |= dvb_frontend_ioctl_legacy(file, FE_SET_FRONTEND,
 			&fepriv->parameters);
 		break;
 	case DTV_FREQUENCY:
@@ -1391,12 +1391,12 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
 		break;
 	case DTV_VOLTAGE:
 		fe->dtv_property_cache.voltage = tvp->u.data;
-		r = dvb_frontend_ioctl_legacy(inode, file, FE_SET_VOLTAGE,
+		r = dvb_frontend_ioctl_legacy(file, FE_SET_VOLTAGE,
 			(void *)fe->dtv_property_cache.voltage);
 		break;
 	case DTV_TONE:
 		fe->dtv_property_cache.sectone = tvp->u.data;
-		r = dvb_frontend_ioctl_legacy(inode, file, FE_SET_TONE,
+		r = dvb_frontend_ioctl_legacy(file, FE_SET_TONE,
 			(void *)fe->dtv_property_cache.sectone);
 		break;
 	case DTV_CODE_RATE_HP:
@@ -1480,7 +1480,7 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
 	return r;
 }
 
-static int dvb_frontend_ioctl(struct inode *inode, struct file *file,
+static int dvb_frontend_ioctl(struct file *file,
 			unsigned int cmd, void *parg)
 {
 	struct dvb_device *dvbdev = file->private_data;
@@ -1502,17 +1502,17 @@ static int dvb_frontend_ioctl(struct inode *inode, struct file *file,
 		return -ERESTARTSYS;
 
 	if ((cmd == FE_SET_PROPERTY) || (cmd == FE_GET_PROPERTY))
-		err = dvb_frontend_ioctl_properties(inode, file, cmd, parg);
+		err = dvb_frontend_ioctl_properties(file, cmd, parg);
 	else {
 		fe->dtv_property_cache.state = DTV_UNDEFINED;
-		err = dvb_frontend_ioctl_legacy(inode, file, cmd, parg);
+		err = dvb_frontend_ioctl_legacy(file, cmd, parg);
 	}
 
 	up(&fepriv->sem);
 	return err;
 }
 
-static int dvb_frontend_ioctl_properties(struct inode *inode, struct file *file,
+static int dvb_frontend_ioctl_properties(struct file *file,
 			unsigned int cmd, void *parg)
 {
 	struct dvb_device *dvbdev = file->private_data;
@@ -1548,7 +1548,7 @@ static int dvb_frontend_ioctl_properties(struct inode *inode, struct file *file,
 		}
 
 		for (i = 0; i < tvps->num; i++) {
-			(tvp + i)->result = dtv_property_process_set(fe, tvp + i, inode, file);
+			(tvp + i)->result = dtv_property_process_set(fe, tvp + i, file);
 			err |= (tvp + i)->result;
 		}
 
@@ -1580,7 +1580,7 @@ static int dvb_frontend_ioctl_properties(struct inode *inode, struct file *file,
 		}
 
 		for (i = 0; i < tvps->num; i++) {
-			(tvp + i)->result = dtv_property_process_get(fe, tvp + i, inode, file);
+			(tvp + i)->result = dtv_property_process_get(fe, tvp + i, file);
 			err |= (tvp + i)->result;
 		}
 
@@ -1597,7 +1597,7 @@ out:
 	return err;
 }
 
-static int dvb_frontend_ioctl_legacy(struct inode *inode, struct file *file,
+static int dvb_frontend_ioctl_legacy(struct file *file,
 			unsigned int cmd, void *parg)
 {
 	struct dvb_device *dvbdev = file->private_data;
@@ -2022,7 +2022,7 @@ static int dvb_frontend_release(struct inode *inode, struct file *file)
 
 static const struct file_operations dvb_frontend_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= dvb_generic_ioctl,
+	.unlocked_ioctl	= dvb_generic_ioctl,
 	.poll		= dvb_frontend_poll,
 	.open		= dvb_frontend_open,
 	.release	= dvb_frontend_release
diff --git a/drivers/media/dvb/dvb-core/dvb_net.c b/drivers/media/dvb/dvb-core/dvb_net.c
index 441c064..a96eee3 100644
--- a/drivers/media/dvb/dvb-core/dvb_net.c
+++ b/drivers/media/dvb/dvb-core/dvb_net.c
@@ -59,6 +59,7 @@
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/dvb/net.h>
+#include <linux/smp_lock.h>
 #include <linux/uio.h>
 #include <asm/uaccess.h>
 #include <linux/crc32.h>
@@ -1333,7 +1334,7 @@ static int dvb_net_remove_if(struct dvb_net *dvbnet, unsigned long num)
 	return 0;
 }
 
-static int dvb_net_do_ioctl(struct inode *inode, struct file *file,
+static int dvb_net_do_ioctl(struct file *file,
 		  unsigned int cmd, void *parg)
 {
 	struct dvb_device *dvbdev = file->private_data;
@@ -1435,10 +1436,16 @@ static int dvb_net_do_ioctl(struct inode *inode, struct file *file,
 	return 0;
 }
 
-static int dvb_net_ioctl(struct inode *inode, struct file *file,
+static long dvb_net_ioctl(struct file *file,
 	      unsigned int cmd, unsigned long arg)
 {
-	return dvb_usercopy(inode, file, cmd, arg, dvb_net_do_ioctl);
+	int ret;
+
+	lock_kernel();
+	ret = dvb_usercopy(file, cmd, arg, dvb_net_do_ioctl);
+	unlock_kernel();
+
+	return ret;
 }
 
 static int dvb_net_close(struct inode *inode, struct file *file)
@@ -1459,7 +1466,7 @@ static int dvb_net_close(struct inode *inode, struct file *file)
 
 static const struct file_operations dvb_net_fops = {
 	.owner = THIS_MODULE,
-	.ioctl = dvb_net_ioctl,
+	.unlocked_ioctl = dvb_net_ioctl,
 	.open =	dvb_generic_open,
 	.release = dvb_net_close,
 };
diff --git a/drivers/media/dvb/dvb-core/dvbdev.c b/drivers/media/dvb/dvb-core/dvbdev.c
index 94159b9..b915c39 100644
--- a/drivers/media/dvb/dvb-core/dvbdev.c
+++ b/drivers/media/dvb/dvb-core/dvbdev.c
@@ -154,10 +154,11 @@ int dvb_generic_release(struct inode *inode, struct file *file)
 EXPORT_SYMBOL(dvb_generic_release);
 
 
-int dvb_generic_ioctl(struct inode *inode, struct file *file,
-		      unsigned int cmd, unsigned long arg)
+long dvb_generic_ioctl(struct file *file,
+		       unsigned int cmd, unsigned long arg)
 {
 	struct dvb_device *dvbdev = file->private_data;
+	int ret;
 
 	if (!dvbdev)
 		return -ENODEV;
@@ -165,7 +166,11 @@ int dvb_generic_ioctl(struct inode *inode, struct file *file,
 	if (!dvbdev->kernel_ioctl)
 		return -EINVAL;
 
-	return dvb_usercopy (inode, file, cmd, arg, dvbdev->kernel_ioctl);
+	lock_kernel();
+	ret = dvb_usercopy(file, cmd, arg, dvbdev->kernel_ioctl);
+	unlock_kernel();
+
+	return ret;
 }
 EXPORT_SYMBOL(dvb_generic_ioctl);
 
@@ -377,9 +382,9 @@ EXPORT_SYMBOL(dvb_unregister_adapter);
    define this as video_usercopy(). this will introduce a dependecy
    to the v4l "videodev.o" module, which is unnecessary for some
    cards (ie. the budget dvb-cards don't need the v4l module...) */
-int dvb_usercopy(struct inode *inode, struct file *file,
+int dvb_usercopy(struct file *file,
 		     unsigned int cmd, unsigned long arg,
-		     int (*func)(struct inode *inode, struct file *file,
+		     int (*func)(struct file *file,
 		     unsigned int cmd, void *arg))
 {
 	char    sbuf[128];
@@ -416,7 +421,7 @@ int dvb_usercopy(struct inode *inode, struct file *file,
 	}
 
 	/* call driver */
-	if ((err = func(inode, file, cmd, parg)) == -ENOIOCTLCMD)
+	if ((err = func(file, cmd, parg)) == -ENOIOCTLCMD)
 		err = -EINVAL;
 
 	if (err < 0)
diff --git a/drivers/media/dvb/dvb-core/dvbdev.h b/drivers/media/dvb/dvb-core/dvbdev.h
index f7b499d..fcc6ae9 100644
--- a/drivers/media/dvb/dvb-core/dvbdev.h
+++ b/drivers/media/dvb/dvb-core/dvbdev.h
@@ -116,8 +116,7 @@ struct dvb_device {
 
 	wait_queue_head_t	  wait_queue;
 	/* don't really need those !? -- FIXME: use video_usercopy  */
-	int (*kernel_ioctl)(struct inode *inode, struct file *file,
-			    unsigned int cmd, void *arg);
+	int (*kernel_ioctl)(struct file *file, unsigned int cmd, void *arg);
 
 	void *priv;
 };
@@ -138,17 +137,15 @@ extern void dvb_unregister_device (struct dvb_device *dvbdev);
 
 extern int dvb_generic_open (struct inode *inode, struct file *file);
 extern int dvb_generic_release (struct inode *inode, struct file *file);
-extern int dvb_generic_ioctl (struct inode *inode, struct file *file,
+extern long dvb_generic_ioctl (struct file *file,
 			      unsigned int cmd, unsigned long arg);
 
 /* we don't mess with video_usercopy() any more,
 we simply define out own dvb_usercopy(), which will hopefully become
 generic_usercopy()  someday... */
 
-extern int dvb_usercopy(struct inode *inode, struct file *file,
-			    unsigned int cmd, unsigned long arg,
-			    int (*func)(struct inode *inode, struct file *file,
-			    unsigned int cmd, void *arg));
+extern int dvb_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
+			    int (*func)(struct file *file, unsigned int cmd, void *arg));
 
 /** generic DVB attach function. */
 #ifdef CONFIG_MEDIA_ATTACH
diff --git a/drivers/media/dvb/firewire/firedtv-ci.c b/drivers/media/dvb/firewire/firedtv-ci.c
index 853e04b..d3c2cf6 100644
--- a/drivers/media/dvb/firewire/firedtv-ci.c
+++ b/drivers/media/dvb/firewire/firedtv-ci.c
@@ -175,8 +175,7 @@ static int fdtv_ca_send_msg(struct firedtv *fdtv, void *arg)
 	return err;
 }
 
-static int fdtv_ca_ioctl(struct inode *inode, struct file *file,
-			    unsigned int cmd, void *arg)
+static int fdtv_ca_ioctl(struct file *file, unsigned int cmd, void *arg)
 {
 	struct dvb_device *dvbdev = file->private_data;
 	struct firedtv *fdtv = dvbdev->priv;
@@ -217,7 +216,7 @@ static unsigned int fdtv_ca_io_poll(struct file *file, poll_table *wait)
 
 static const struct file_operations fdtv_ca_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= dvb_generic_ioctl,
+	.unlocked_ioctl	= dvb_generic_ioctl,
 	.open		= dvb_generic_open,
 	.release	= dvb_generic_release,
 	.poll		= fdtv_ca_io_poll,
diff --git a/drivers/media/dvb/ttpci/av7110.c b/drivers/media/dvb/ttpci/av7110.c
index 3891559..a6be529 100644
--- a/drivers/media/dvb/ttpci/av7110.c
+++ b/drivers/media/dvb/ttpci/av7110.c
@@ -708,7 +708,7 @@ static void gpioirq(unsigned long cookie)
 
 
 #ifdef CONFIG_DVB_AV7110_OSD
-static int dvb_osd_ioctl(struct inode *inode, struct file *file,
+static int dvb_osd_ioctl(struct file *file,
 			 unsigned int cmd, void *parg)
 {
 	struct dvb_device *dvbdev = file->private_data;
@@ -727,7 +727,7 @@ static int dvb_osd_ioctl(struct inode *inode, struct file *file,
 
 static const struct file_operations dvb_osd_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= dvb_generic_ioctl,
+	.unlocked_ioctl	= dvb_generic_ioctl,
 	.open		= dvb_generic_open,
 	.release	= dvb_generic_release,
 };
diff --git a/drivers/media/dvb/ttpci/av7110_av.c b/drivers/media/dvb/ttpci/av7110_av.c
index 5388481..13efba9 100644
--- a/drivers/media/dvb/ttpci/av7110_av.c
+++ b/drivers/media/dvb/ttpci/av7110_av.c
@@ -1089,7 +1089,7 @@ static int play_iframe(struct av7110 *av7110, char __user *buf, unsigned int len
 }
 
 
-static int dvb_video_ioctl(struct inode *inode, struct file *file,
+static int dvb_video_ioctl(struct file *file,
 			   unsigned int cmd, void *parg)
 {
 	struct dvb_device *dvbdev = file->private_data;
@@ -1297,7 +1297,7 @@ static int dvb_video_ioctl(struct inode *inode, struct file *file,
 	return ret;
 }
 
-static int dvb_audio_ioctl(struct inode *inode, struct file *file,
+static int dvb_audio_ioctl(struct file *file,
 			   unsigned int cmd, void *parg)
 {
 	struct dvb_device *dvbdev = file->private_data;
@@ -1517,7 +1517,7 @@ static int dvb_audio_release(struct inode *inode, struct file *file)
 static const struct file_operations dvb_video_fops = {
 	.owner		= THIS_MODULE,
 	.write		= dvb_video_write,
-	.ioctl		= dvb_generic_ioctl,
+	.unlocked_ioctl	= dvb_generic_ioctl,
 	.open		= dvb_video_open,
 	.release	= dvb_video_release,
 	.poll		= dvb_video_poll,
@@ -1535,7 +1535,7 @@ static struct dvb_device dvbdev_video = {
 static const struct file_operations dvb_audio_fops = {
 	.owner		= THIS_MODULE,
 	.write		= dvb_audio_write,
-	.ioctl		= dvb_generic_ioctl,
+	.unlocked_ioctl	= dvb_generic_ioctl,
 	.open		= dvb_audio_open,
 	.release	= dvb_audio_release,
 	.poll		= dvb_audio_poll,
diff --git a/drivers/media/dvb/ttpci/av7110_ca.c b/drivers/media/dvb/ttpci/av7110_ca.c
index ac7779c..4eba35a 100644
--- a/drivers/media/dvb/ttpci/av7110_ca.c
+++ b/drivers/media/dvb/ttpci/av7110_ca.c
@@ -248,8 +248,7 @@ static unsigned int dvb_ca_poll (struct file *file, poll_table *wait)
 	return mask;
 }
 
-static int dvb_ca_ioctl(struct inode *inode, struct file *file,
-		 unsigned int cmd, void *parg)
+static int dvb_ca_ioctl(struct file *file, unsigned int cmd, void *parg)
 {
 	struct dvb_device *dvbdev = file->private_data;
 	struct av7110 *av7110 = dvbdev->priv;
@@ -350,7 +349,7 @@ static const struct file_operations dvb_ca_fops = {
 	.owner		= THIS_MODULE,
 	.read		= dvb_ca_read,
 	.write		= dvb_ca_write,
-	.ioctl		= dvb_generic_ioctl,
+	.unlocked_ioctl	= dvb_generic_ioctl,
 	.open		= dvb_ca_open,
 	.release	= dvb_generic_release,
 	.poll		= dvb_ca_poll,
-- 
1.7.0.4

