Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab0C1OrY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 10:47:24 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:49841 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754687Ab0C1OrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 10:47:23 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 28 Mar 2010 16:47:06 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH RFC v2] DVB: add dvb_generic_nonseekable_open,
 dvb_generic_unlocked_ioctl, use in firedtv
To: linux-media@vger.kernel.org
cc: linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Arnd Bergmann <arnd@arndb.de>, Henrik Kurelid <henrik@kurelid.se>
In-Reply-To: <tkrat.7662a00017241225@s5r6.in-berlin.de>
Message-ID: <tkrat.a7b7e7df43463db1@s5r6.in-berlin.de>
References: <201003242240.54907.arnd@arndb.de>
 <alpine.LRH.2.00.1003251354200.16443@twin.jikos.cz>
 <201003251406.10177.arnd@arndb.de> <201003251438.59062.arnd@arndb.de>
 <4BAD4795.2040700@s5r6.in-berlin.de>
 <tkrat.7662a00017241225@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to remove Big Kernel Lock usages from the DVB subsystem,
we need to
  - provide .llseek file operations that do not grab the BKL (unlike
    fs/read_write.c::default_llseek) or mark files as not seekable,
  - provide .unlocked_ioctl file operations.

Add two dvb_generic_ file operations for file interfaces which are not
seekable and, respectively, do not require the BKL in their ioctl
handlers.

Use them in one driver of which I am sure of that these are applicable.
(Affected code paths in firedtv-ci were not runtime-tested since I don't
have a CAM, but the frontend ioctls were of course runtime-tested.)

Notes:

  - The dvb-core internal dvb_usercopy() API is changed to match
    .unlocked_ioctl() prototypes.

  - I suspect that all dvb_generic_open() users really want
    nonseekable_open --- then we should simply change dvb_generic_open()
    instead of adding dvb_generic_nonseekable_open() --- but I haven't
    checked other users of dvb_generic_open whether they require
    .llssek mehods other than fs/read_write.c::no_llseek.
    Applies to:
    drivers/media/dvb/ttpci/av7110.c
    drivers/media/dvb/ttpci/av7110_av.c
    drivers/media/dvb/ttpci/av7110_ca.c
    drivers/media/dvb/dvb-core/dvb_net.c
    drivers/media/dvb/dvb-core/dvb_frontend.c
    drivers/media/dvb/dvb-core/dvb_ca_en50221.c

  - To be done by those who know the code:  Check all users of
    struct dvb_device.kernel_ioctl whether they really need the BKL.
    Convert to .unlocked_ioctl and remove .kernel_ioctl and the
    temporarily introduced dvbdev.c::legacy_usercopy().
    Applies to:
    drivers/media/dvb/ttpci/av7110.c
    drivers/media/dvb/ttpci/av7110_av.c
    drivers/media/dvb/ttpci/av7110_ca.c
    drivers/media/dvb/dvb-core/dvb_frontend.c

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

Update:  Split dvb_usercopy into one that follows the .unlocked_ioctl
prototype form and another one that preserves the old form.

 drivers/media/dvb/dvb-core/dmxdev.c         |   10 -
 drivers/media/dvb/dvb-core/dvb_ca_en50221.c |    6 
 drivers/media/dvb/dvb-core/dvb_net.c        |    5 
 drivers/media/dvb/dvb-core/dvbdev.c         |  190 +++++++++++++-------
 drivers/media/dvb/dvb-core/dvbdev.h         |   23 +-
 drivers/media/dvb/firewire/firedtv-ci.c     |    9 
 6 files changed, 148 insertions(+), 95 deletions(-)

Index: b/drivers/media/dvb/dvb-core/dmxdev.c
===================================================================
--- a/drivers/media/dvb/dvb-core/dmxdev.c
+++ b/drivers/media/dvb/dvb-core/dmxdev.c
@@ -963,8 +963,7 @@ dvb_demux_read(struct file *file, char _
 	return ret;
 }
 
-static int dvb_demux_do_ioctl(struct inode *inode, struct file *file,
-			      unsigned int cmd, void *parg)
+static long dvb_demux_do_ioctl(struct file *file, unsigned int cmd, void *parg)
 {
 	struct dmxdev_filter *dmxdevfilter = file->private_data;
 	struct dmxdev *dmxdev = dmxdevfilter->dev;
@@ -1087,7 +1086,7 @@ static int dvb_demux_do_ioctl(struct ino
 static int dvb_demux_ioctl(struct inode *inode, struct file *file,
 			   unsigned int cmd, unsigned long arg)
 {
-	return dvb_usercopy(inode, file, cmd, arg, dvb_demux_do_ioctl);
+	return dvb_usercopy(file, cmd, arg, dvb_demux_do_ioctl);
 }
 
 static unsigned int dvb_demux_poll(struct file *file, poll_table *wait)
@@ -1152,8 +1151,7 @@ static struct dvb_device dvbdev_demux = 
 	.fops = &dvb_demux_fops
 };
 
-static int dvb_dvr_do_ioctl(struct inode *inode, struct file *file,
-			    unsigned int cmd, void *parg)
+static long dvb_dvr_do_ioctl(struct file *file, unsigned int cmd, void *parg)
 {
 	struct dvb_device *dvbdev = file->private_data;
 	struct dmxdev *dmxdev = dvbdev->priv;
@@ -1179,7 +1177,7 @@ static int dvb_dvr_do_ioctl(struct inode
 static int dvb_dvr_ioctl(struct inode *inode, struct file *file,
 			 unsigned int cmd, unsigned long arg)
 {
-	return dvb_usercopy(inode, file, cmd, arg, dvb_dvr_do_ioctl);
+	return dvb_usercopy(file, cmd, arg, dvb_dvr_do_ioctl);
 }
 
 static unsigned int dvb_dvr_poll(struct file *file, poll_table *wait)
Index: b/drivers/media/dvb/dvb-core/dvb_ca_en50221.c
===================================================================
--- a/drivers/media/dvb/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb/dvb-core/dvb_ca_en50221.c
@@ -1181,8 +1181,8 @@ static int dvb_ca_en50221_thread(void *d
  *
  * @return 0 on success, <0 on error.
  */
-static int dvb_ca_en50221_io_do_ioctl(struct inode *inode, struct file *file,
-				      unsigned int cmd, void *parg)
+static long dvb_ca_en50221_io_do_ioctl(struct file *file,
+				       unsigned int cmd, void *parg)
 {
 	struct dvb_device *dvbdev = file->private_data;
 	struct dvb_ca_private *ca = dvbdev->priv;
@@ -1258,7 +1258,7 @@ static int dvb_ca_en50221_io_do_ioctl(st
 static int dvb_ca_en50221_io_ioctl(struct inode *inode, struct file *file,
 				   unsigned int cmd, unsigned long arg)
 {
-	return dvb_usercopy(inode, file, cmd, arg, dvb_ca_en50221_io_do_ioctl);
+	return dvb_usercopy(file, cmd, arg, dvb_ca_en50221_io_do_ioctl);
 }
 
 
Index: b/drivers/media/dvb/dvb-core/dvb_net.c
===================================================================
--- a/drivers/media/dvb/dvb-core/dvb_net.c
+++ b/drivers/media/dvb/dvb-core/dvb_net.c
@@ -1333,8 +1333,7 @@ static int dvb_net_remove_if(struct dvb_
 	return 0;
 }
 
-static int dvb_net_do_ioctl(struct inode *inode, struct file *file,
-		  unsigned int cmd, void *parg)
+static long dvb_net_do_ioctl(struct file *file, unsigned int cmd, void *parg)
 {
 	struct dvb_device *dvbdev = file->private_data;
 	struct dvb_net *dvbnet = dvbdev->priv;
@@ -1438,7 +1437,7 @@ static int dvb_net_do_ioctl(struct inode
 static int dvb_net_ioctl(struct inode *inode, struct file *file,
 	      unsigned int cmd, unsigned long arg)
 {
-	return dvb_usercopy(inode, file, cmd, arg, dvb_net_do_ioctl);
+	return dvb_usercopy(file, cmd, arg, dvb_net_do_ioctl);
 }
 
 static int dvb_net_close(struct inode *inode, struct file *file)
Index: b/drivers/media/dvb/dvb-core/dvbdev.c
===================================================================
--- a/drivers/media/dvb/dvb-core/dvbdev.c
+++ b/drivers/media/dvb/dvb-core/dvbdev.c
@@ -135,6 +135,18 @@ int dvb_generic_open(struct inode *inode
 EXPORT_SYMBOL(dvb_generic_open);
 
 
+int dvb_generic_nonseekable_open(struct inode *inode, struct file *file)
+{
+	int retval = dvb_generic_open(inode, file);
+
+	if (retval == 0)
+		retval = nonseekable_open(inode, file);
+
+	return retval;
+}
+EXPORT_SYMBOL(dvb_generic_nonseekable_open);
+
+
 int dvb_generic_release(struct inode *inode, struct file *file)
 {
 	struct dvb_device *dvbdev = file->private_data;
@@ -154,6 +166,102 @@ int dvb_generic_release(struct inode *in
 EXPORT_SYMBOL(dvb_generic_release);
 
 
+#define STATIC_BUFFER_SIZE 128
+
+/* If necessary, swap out static *buf by a slab-allocated buffer */
+static int get_arg(unsigned int cmd, unsigned long arg, void **parg, void **buf)
+{
+	switch (_IOC_DIR(cmd)) {
+	case _IOC_NONE:
+		/*
+		 * For this command, the pointer is actually an integer
+		 * argument.
+		 */
+		*parg = (void *)arg;
+		break;
+	case _IOC_READ: /* some v4l ioctls are marked wrong ... */
+	case _IOC_WRITE:
+	case (_IOC_WRITE | _IOC_READ):
+		if (_IOC_SIZE(cmd) > STATIC_BUFFER_SIZE) {
+			*buf = kmalloc(_IOC_SIZE(cmd), GFP_KERNEL);
+			if (!*buf)
+				return -ENOMEM;
+		}
+		*parg = *buf;
+
+		if (copy_from_user(*parg, (void __user *)arg, _IOC_SIZE(cmd)))
+			return -EFAULT;
+	}
+	return 0;
+}
+
+static int put_arg(unsigned int cmd, unsigned long arg, void *parg)
+{
+	switch (_IOC_DIR(cmd)) {
+	case _IOC_READ:
+	case (_IOC_WRITE | _IOC_READ):
+		if (copy_to_user((void __user *)arg, parg, _IOC_SIZE(cmd)))
+			return -EFAULT;
+	}
+	return 0;
+}
+
+/*
+ * Wrapper around ioctl handlers; copies arguments and results from/ to user.
+ * Could be changed into a "generic_usercopy()" for all kernel subsystems.
+ */
+long dvb_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
+		  long (*func)(struct file *file, unsigned int cmd, void *arg))
+{
+	char sbuf[STATIC_BUFFER_SIZE];
+	void *parg, *buf = sbuf;
+	long retval;
+
+	retval = get_arg(cmd, arg, &parg, &buf);
+	if (retval < 0)
+		goto out;
+
+	/* call driver */
+	retval = func(file, cmd, parg);
+	if (retval == -ENOIOCTLCMD)
+		retval = -EINVAL;
+	if (retval < 0)
+		goto out;
+
+	retval = put_arg(cmd, arg, parg);
+out:
+	if (buf != sbuf)
+		kfree(buf);
+	return retval;
+}
+
+static int legacy_usercopy(struct inode *inode, struct file *file,
+			   unsigned int cmd, unsigned long arg,
+			   int (*func)(struct inode *inode, struct file *file,
+			   unsigned int cmd, void *arg))
+{
+	char sbuf[STATIC_BUFFER_SIZE];
+	void *parg, *buf = sbuf;
+	int retval;
+
+	retval = get_arg(cmd, arg, &parg, &buf);
+	if (retval < 0)
+		goto out;
+
+	/* call driver */
+	retval = func(inode, file, cmd, parg);
+	if (retval == -ENOIOCTLCMD)
+		retval = -EINVAL;
+	if (retval < 0)
+		goto out;
+
+	retval = put_arg(cmd, arg, parg);
+out:
+	if (buf != sbuf)
+		kfree(buf);
+	return retval;
+}
+
 int dvb_generic_ioctl(struct inode *inode, struct file *file,
 		      unsigned int cmd, unsigned long arg)
 {
@@ -165,11 +273,27 @@ int dvb_generic_ioctl(struct inode *inod
 	if (!dvbdev->kernel_ioctl)
 		return -EINVAL;
 
-	return dvb_usercopy (inode, file, cmd, arg, dvbdev->kernel_ioctl);
+	return legacy_usercopy(inode, file, cmd, arg, dvbdev->kernel_ioctl);
 }
 EXPORT_SYMBOL(dvb_generic_ioctl);
 
 
+long dvb_generic_unlocked_ioctl(struct file *file,
+				unsigned int cmd, unsigned long arg)
+{
+	struct dvb_device *dvbdev = file->private_data;
+
+	if (!dvbdev)
+		return -ENODEV;
+
+	if (!dvbdev->unlocked_ioctl)
+		return -EINVAL;
+
+	return dvb_usercopy(file, cmd, arg, dvbdev->unlocked_ioctl);
+}
+EXPORT_SYMBOL(dvb_generic_unlocked_ioctl);
+
+
 static int dvbdev_get_free_id (struct dvb_adapter *adap, int type)
 {
 	u32 id = 0;
@@ -372,70 +496,6 @@ int dvb_unregister_adapter(struct dvb_ad
 }
 EXPORT_SYMBOL(dvb_unregister_adapter);
 
-/* if the miracle happens and "generic_usercopy()" is included into
-   the kernel, then this can vanish. please don't make the mistake and
-   define this as video_usercopy(). this will introduce a dependecy
-   to the v4l "videodev.o" module, which is unnecessary for some
-   cards (ie. the budget dvb-cards don't need the v4l module...) */
-int dvb_usercopy(struct inode *inode, struct file *file,
-		     unsigned int cmd, unsigned long arg,
-		     int (*func)(struct inode *inode, struct file *file,
-		     unsigned int cmd, void *arg))
-{
-	char    sbuf[128];
-	void    *mbuf = NULL;
-	void    *parg = NULL;
-	int     err  = -EINVAL;
-
-	/*  Copy arguments into temp kernel buffer  */
-	switch (_IOC_DIR(cmd)) {
-	case _IOC_NONE:
-		/*
-		 * For this command, the pointer is actually an integer
-		 * argument.
-		 */
-		parg = (void *) arg;
-		break;
-	case _IOC_READ: /* some v4l ioctls are marked wrong ... */
-	case _IOC_WRITE:
-	case (_IOC_WRITE | _IOC_READ):
-		if (_IOC_SIZE(cmd) <= sizeof(sbuf)) {
-			parg = sbuf;
-		} else {
-			/* too big to allocate from stack */
-			mbuf = kmalloc(_IOC_SIZE(cmd),GFP_KERNEL);
-			if (NULL == mbuf)
-				return -ENOMEM;
-			parg = mbuf;
-		}
-
-		err = -EFAULT;
-		if (copy_from_user(parg, (void __user *)arg, _IOC_SIZE(cmd)))
-			goto out;
-		break;
-	}
-
-	/* call driver */
-	if ((err = func(inode, file, cmd, parg)) == -ENOIOCTLCMD)
-		err = -EINVAL;
-
-	if (err < 0)
-		goto out;
-
-	/*  Copy results into user buffer  */
-	switch (_IOC_DIR(cmd))
-	{
-	case _IOC_READ:
-	case (_IOC_WRITE | _IOC_READ):
-		if (copy_to_user((void __user *)arg, parg, _IOC_SIZE(cmd)))
-			err = -EFAULT;
-		break;
-	}
-
-out:
-	kfree(mbuf);
-	return err;
-}
 
 static int dvb_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
Index: b/drivers/media/dvb/dvb-core/dvbdev.h
===================================================================
--- a/drivers/media/dvb/dvb-core/dvbdev.h
+++ b/drivers/media/dvb/dvb-core/dvbdev.h
@@ -118,6 +118,7 @@ struct dvb_device {
 	/* don't really need those !? -- FIXME: use video_usercopy  */
 	int (*kernel_ioctl)(struct inode *inode, struct file *file,
 			    unsigned int cmd, void *arg);
+	long (*unlocked_ioctl)(struct file *file, unsigned int cmd, void *arg);
 
 	void *priv;
 };
@@ -136,19 +137,15 @@ extern int dvb_register_device (struct d
 
 extern void dvb_unregister_device (struct dvb_device *dvbdev);
 
-extern int dvb_generic_open (struct inode *inode, struct file *file);
-extern int dvb_generic_release (struct inode *inode, struct file *file);
-extern int dvb_generic_ioctl (struct inode *inode, struct file *file,
-			      unsigned int cmd, unsigned long arg);
-
-/* we don't mess with video_usercopy() any more,
-we simply define out own dvb_usercopy(), which will hopefully become
-generic_usercopy()  someday... */
-
-extern int dvb_usercopy(struct inode *inode, struct file *file,
-			    unsigned int cmd, unsigned long arg,
-			    int (*func)(struct inode *inode, struct file *file,
-			    unsigned int cmd, void *arg));
+extern int dvb_generic_open(struct inode *inode, struct file *file);
+extern int dvb_generic_nonseekable_open(struct inode *inode, struct file *file);
+extern int dvb_generic_release(struct inode *inode, struct file *file);
+extern int dvb_generic_ioctl(struct inode *inode, struct file *file,
+			     unsigned int cmd, unsigned long arg);
+extern long dvb_generic_unlocked_ioctl(struct file *file,
+					unsigned int cmd, unsigned long arg);
+extern long dvb_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
+		long (*func)(struct file *file, unsigned int cmd, void *arg));
 
 /** generic DVB attach function. */
 #ifdef CONFIG_MEDIA_ATTACH
Index: b/drivers/media/dvb/firewire/firedtv-ci.c
===================================================================
--- a/drivers/media/dvb/firewire/firedtv-ci.c
+++ b/drivers/media/dvb/firewire/firedtv-ci.c
@@ -175,8 +175,7 @@ static int fdtv_ca_send_msg(struct fired
 	return err;
 }
 
-static int fdtv_ca_ioctl(struct inode *inode, struct file *file,
-			    unsigned int cmd, void *arg)
+static long fdtv_ca_ioctl(struct file *file, unsigned int cmd, void *arg)
 {
 	struct dvb_device *dvbdev = file->private_data;
 	struct firedtv *fdtv = dvbdev->priv;
@@ -217,8 +216,8 @@ static unsigned int fdtv_ca_io_poll(stru
 
 static const struct file_operations fdtv_ca_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= dvb_generic_ioctl,
-	.open		= dvb_generic_open,
+	.unlocked_ioctl	= dvb_generic_unlocked_ioctl,
+	.open		= dvb_generic_nonseekable_open,
 	.release	= dvb_generic_release,
 	.poll		= fdtv_ca_io_poll,
 };
@@ -228,7 +227,7 @@ static struct dvb_device fdtv_ca = {
 	.readers	= 1,
 	.writers	= 1,
 	.fops		= &fdtv_ca_fops,
-	.kernel_ioctl	= fdtv_ca_ioctl,
+	.unlocked_ioctl	= fdtv_ca_ioctl,
 };
 
 int fdtv_ca_register(struct firedtv *fdtv)

-- 
Stefan Richter
-=====-==-=- --== ===--
http://arcgraph.de/sr/

