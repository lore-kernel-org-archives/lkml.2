Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241Ab0HIBpV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 21:45:21 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50678 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222Ab0HIBpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 21:45:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=OdvpotF3pWL6qPBiSZVpLd9YnkR2BjUiH+qM5FQYDU7MWHpkQFueJEWl2MxY56lEEz
         RvcH5kP19AcysRigyaWF5qsI1uqlrMo+Bw0g2eODpYcxl3O8bZtc4ie2Wr4x8SIu7WMh
         /GsVVkA2n6GK//o8076rkOPkKemLaBIpB/GCg=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, John Kacur <jkacur@redhat.com>,
        Greg KH <gregkh@suse.de>
Subject: [PATCH] staging: Pushdown bkl to easycap ioctl handlers
Date: Mon,  9 Aug 2010 03:45:14 +0200
Message-Id: <1281318314-29828-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These were amongst the last users of struct file_operations:ioctl

(applied in my bkl/ioctl branch)

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: John Kacur <jkacur@redhat.com>
Cc: Greg KH <gregkh@suse.de>
---
 drivers/staging/easycap/easycap.h       |    8 +---
 drivers/staging/easycap/easycap_ioctl.c |   52 ++++++++++++++++++-------------
 drivers/staging/easycap/easycap_main.c  |   38 +++++++++++-----------
 3 files changed, 51 insertions(+), 47 deletions(-)

diff --git a/drivers/staging/easycap/easycap.h b/drivers/staging/easycap/easycap.h
index ad836d2..f3c827e 100644
--- a/drivers/staging/easycap/easycap.h
+++ b/drivers/staging/easycap/easycap.h
@@ -463,15 +463,12 @@ struct data_buffer audio_buffer[];
 void             easycap_complete(struct urb *);
 int              easycap_open(struct inode *, struct file *);
 int              easycap_release(struct inode *, struct file *);
-int              easycap_ioctl(struct inode *, struct file *, \
-						unsigned int,  unsigned long);
+long             easycap_ioctl(struct file *, unsigned int,  unsigned long);
 
 /*vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv*/
 #if defined(EASYCAP_IS_VIDEODEV_CLIENT)
 int              easycap_open_noinode(struct file *);
 int              easycap_release_noinode(struct file *);
-long             easycap_ioctl_noinode(struct file *, \
-						unsigned int,  unsigned long);
 int              videodev_release(struct video_device *);
 #endif /*EASYCAP_IS_VIDEODEV_CLIENT*/
 /*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^*/
@@ -515,8 +512,7 @@ void             easysnd_complete(struct urb *);
 ssize_t          easysnd_read(struct file *, char __user *, size_t, loff_t *);
 int              easysnd_open(struct inode *, struct file *);
 int              easysnd_release(struct inode *, struct file *);
-int              easysnd_ioctl(struct inode *, struct file *, \
-						unsigned int,  unsigned long);
+long             easysnd_ioctl(struct file *, unsigned int,  unsigned long);
 unsigned int     easysnd_poll(struct file *, poll_table *);
 void             easysnd_delete(struct kref *);
 int              submit_audio_urbs(struct easycap *);
diff --git a/drivers/staging/easycap/easycap_ioctl.c b/drivers/staging/easycap/easycap_ioctl.c
index 276b63d..9a42ae0 100644
--- a/drivers/staging/easycap/easycap_ioctl.c
+++ b/drivers/staging/easycap/easycap_ioctl.c
@@ -25,6 +25,7 @@
 */
 /*****************************************************************************/
 
+#include <linux/smp_lock.h>
 #include "easycap.h"
 #include "easycap_debug.h"
 #include "easycap_standard.h"
@@ -773,19 +774,10 @@ while (0xFFFFFFFF != easycap_control[i1].id) {
 SAY("WARNING: failed to adjust mute: control not found\n");
 return -ENOENT;
 }
-/****************************************************************************/
-/*vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv*/
-#if defined(EASYCAP_IS_VIDEODEV_CLIENT)
-long
-easycap_ioctl_noinode(struct file *file, unsigned int cmd, unsigned long arg)\
-									{
-	return easycap_ioctl((struct inode *)NULL, file, cmd, arg);
-}
-#endif /*EASYCAP_IS_VIDEODEV_CLIENT*/
-/*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^*/
+
 /*--------------------------------------------------------------------------*/
-int easycap_ioctl(struct inode *inode, struct file *file, \
-					unsigned int cmd, unsigned long arg)
+static int easycap_ioctl_bkl(struct inode *inode, struct file *file,
+			     unsigned int cmd, unsigned long arg)
 {
 static struct easycap *peasycap;
 static struct usb_device *p;
@@ -1956,19 +1948,22 @@ default: {
 }
 return 0;
 }
-/****************************************************************************/
-/*vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv*/
-#if defined(EASYCAP_IS_VIDEODEV_CLIENT)
-long
-easysnd_ioctl_noinode(struct file *file, unsigned int cmd, unsigned long arg)
+
+long easycap_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	return easysnd_ioctl((struct inode *)NULL, file, cmd, arg);
+	struct inode *inode = file->f_dentry->d_inode;
+	long ret;
+
+	lock_kernel();
+	ret = easycap_ioctl_bkl(inode, file, cmd, arg);
+	unlock_kernel();
+
+	return ret;
 }
-#endif /*EASYCAP_IS_VIDEODEV_CLIENT*/
-/*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^*/
+
 /*--------------------------------------------------------------------------*/
-int easysnd_ioctl(struct inode *inode, struct file *file, \
-					unsigned int cmd, unsigned long arg)
+static int easysnd_ioctl_bkl(struct inode *inode, struct file *file,
+			     unsigned int cmd, unsigned long arg)
 {
 struct easycap *peasycap;
 struct usb_device *p;
@@ -2158,6 +2153,19 @@ default: {
 }
 return 0;
 }
+
+long easysnd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	struct inode *inode = file->f_dentry->d_inode;
+	long ret;
+
+	lock_kernel();
+	ret = easysnd_ioctl_bkl(inode, file, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
+
 /*****************************************************************************/
 int explain_ioctl(__u32 wot)
 {
diff --git a/drivers/staging/easycap/easycap_main.c b/drivers/staging/easycap/easycap_main.c
index 09c194c..5a4bbd9 100644
--- a/drivers/staging/easycap/easycap_main.c
+++ b/drivers/staging/easycap/easycap_main.c
@@ -60,13 +60,13 @@ struct usb_driver easycap_usb_driver = {
  */
 /*---------------------------------------------------------------------------*/
 const struct file_operations easycap_fops = {
-.owner =   THIS_MODULE,
-.open =    easycap_open,
-.release = easycap_release,
-.ioctl =   easycap_ioctl,
-.poll =    easycap_poll,
-.mmap =    easycap_mmap,
-.llseek =  no_llseek,
+	.owner		= THIS_MODULE,
+	.open		= easycap_open,
+	.release	= easycap_release,
+	.unlocked_ioctl	= easycap_ioctl,
+	.poll		= easycap_poll,
+	.mmap		= easycap_mmap,
+	.llseek		= no_llseek,
 };
 struct vm_operations_struct easycap_vm_ops = {
 .open  = easycap_vma_open,
@@ -83,12 +83,12 @@ struct usb_class_driver easycap_class = {
 #if defined(EASYCAP_IS_VIDEODEV_CLIENT)
 #if defined(EASYCAP_NEEDS_V4L2_FOPS)
 const struct v4l2_file_operations v4l2_fops = {
-.owner =   THIS_MODULE,
-.open =    easycap_open_noinode,
-.release = easycap_release_noinode,
-.ioctl =   easycap_ioctl_noinode,
-.poll =    easycap_poll,
-.mmap =    easycap_mmap,
+	.owner		= THIS_MODULE,
+	.open		= easycap_open_noinode,
+	.release	= easycap_release_noinode,
+	.unlocked_ioctl	= easycap_ioctl,
+	.poll		= easycap_poll,
+	.mmap		= easycap_mmap,
 };
 #endif /*EASYCAP_NEEDS_V4L2_FOPS*/
 int video_device_many /*=0*/;
@@ -102,12 +102,12 @@ struct video_device *pvideo_array[VIDEO_DEVICE_MANY], *pvideo_device;
  */
 /*--------------------------------------------------------------------------*/
 const struct file_operations easysnd_fops = {
-.owner =   THIS_MODULE,
-.open =    easysnd_open,
-.release = easysnd_release,
-.ioctl =   easysnd_ioctl,
-.read =    easysnd_read,
-.llseek =  no_llseek,
+	.owner		= THIS_MODULE,
+	.open		= easysnd_open,
+	.release	= easysnd_release,
+	.unlocked_ioctl	= easysnd_ioctl,
+	.read		= easysnd_read,
+	.llseek		= no_llseek,
 };
 struct usb_class_driver easysnd_class = {
 .name = "usb/easysnd%d",
-- 
1.6.2.3

