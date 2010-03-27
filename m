Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575Ab0C0Kks (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 06:40:48 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:42050 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036Ab0C0Kkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 06:40:46 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 27 Mar 2010 11:40:31 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH RFC] DVB: add dvb_generic_nonseekable_open,
 dvb_generic_unlocked_ioctl, use in firedtv
To: linux-media@vger.kernel.org
cc: linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Arnd Bergmann <arnd@arndb.de>, Henrik Kurelid <henrik@kurelid.se>
In-Reply-To: <4BAD4795.2040700@s5r6.in-berlin.de>
Message-ID: <tkrat.7662a00017241225@s5r6.in-berlin.de>
References: <201003242240.54907.arnd@arndb.de>
 <alpine.LRH.2.00.1003251354200.16443@twin.jikos.cz>
 <201003251406.10177.arnd@arndb.de> <201003251438.59062.arnd@arndb.de>
 <4BAD4795.2040700@s5r6.in-berlin.de>
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
(Affected code paths were not runtime-tested since I don't have a CAM.)

Notes:

  - In order to maximize code reuse and minimize API churn, I pass a
    dummy NULL struct inode * through dvb_usercopy() to
    dvbdev->kernel_ioctl().  Very ugly; it may be better to convert
    everything from .ioctl to .unlocked_ioctl in one go and remove the
    inode pointer argument everywhere.

  - I suspect that actually all dvb_generic_open() users really want
    nonseekable_open --- then we should simply change dvb_generic_open()
    instead of adding dvb_generic_nonseekable_open() --- but I haven't
    checked other users of dvb_generic_open whether they require
    .llssek mehods other than fs/read_write.c::no_llseek.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

This patch is motivated by Arnd's
"bkl removal: make unlocked_ioctl mandatory"
http://git.kernel.org/?p=linux/kernel/git/arnd/playground.git;a=blobdiff;f=drivers/media/dvb/firewire/firedtv-ci.c;h=7ab89035c101240a860d6c72bf8541a0fdf3aed9;hp=853e04b7cb361d45257f80dcafdcf121cd340c63;hb=05e7753338045e9ee3950b2da032c5e5774efa90;hpb=03165e1d096afb4b1d9cfccdad66eed038121cec
"BKL removal: mark remaining users as 'depends on BKL'"
http://git.kernel.org/?p=linux/kernel/git/arnd/playground.git;a=blobdiff;f=drivers/media/dvb/firewire/Kconfig;h=ba8938e26414c8c82c41677f87c1361ed8fcebd0;hp=4afa29256df110d3383b6b469762cefbb46436b6;hb=abb83d8fe5f8dcc8fca09bd9117429f73e1417e0;hpb=33c014b118f45516113d4b6823e40ea6f834dc6a


 drivers/media/dvb/dvb-core/dvbdev.c     |   20 ++++++++++++++++++++
 drivers/media/dvb/dvb-core/dvbdev.h     |   11 +++++++----
 drivers/media/dvb/firewire/firedtv-ci.c |    4 ++--
 3 files changed, 29 insertions(+), 6 deletions(-)

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
@@ -170,6 +182,14 @@ int dvb_generic_ioctl(struct inode *inod
 EXPORT_SYMBOL(dvb_generic_ioctl);
 
 
+long dvb_generic_unlocked_ioctl(struct file *file,
+				unsigned int cmd, unsigned long arg)
+{
+	return dvb_generic_ioctl(NULL, file, cmd, arg);
+}
+EXPORT_SYMBOL(dvb_generic_unlocked_ioctl);
+
+
 static int dvbdev_get_free_id (struct dvb_adapter *adap, int type)
 {
 	u32 id = 0;
Index: b/drivers/media/dvb/dvb-core/dvbdev.h
===================================================================
--- a/drivers/media/dvb/dvb-core/dvbdev.h
+++ b/drivers/media/dvb/dvb-core/dvbdev.h
@@ -136,10 +136,13 @@ extern int dvb_register_device (struct d
 
 extern void dvb_unregister_device (struct dvb_device *dvbdev);
 
-extern int dvb_generic_open (struct inode *inode, struct file *file);
-extern int dvb_generic_release (struct inode *inode, struct file *file);
-extern int dvb_generic_ioctl (struct inode *inode, struct file *file,
-			      unsigned int cmd, unsigned long arg);
+extern int dvb_generic_open(struct inode *inode, struct file *file);
+extern int dvb_generic_nonseekable_open(struct inode *inode, struct file *file);
+extern int dvb_generic_release(struct inode *inode, struct file *file);
+extern int dvb_generic_ioctl(struct inode *inode, struct file *file,
+			     unsigned int cmd, unsigned long arg);
+extern long dvb_generic_unlocked_ioctl(struct file *file,
+				       unsigned int cmd, unsigned long arg);
 
 /* we don't mess with video_usercopy() any more,
 we simply define out own dvb_usercopy(), which will hopefully become
Index: b/drivers/media/dvb/firewire/firedtv-ci.c
===================================================================
--- a/drivers/media/dvb/firewire/firedtv-ci.c
+++ b/drivers/media/dvb/firewire/firedtv-ci.c
@@ -217,8 +217,8 @@ static unsigned int fdtv_ca_io_poll(stru
 
 static const struct file_operations fdtv_ca_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= dvb_generic_ioctl,
-	.open		= dvb_generic_open,
+	.unlocked_ioctl	= dvb_generic_unlocked_ioctl,
+	.open		= dvb_generic_nonseekable_open,
 	.release	= dvb_generic_release,
 	.poll		= fdtv_ca_io_poll,
 };

-- 
Stefan Richter
-=====-==-=- --== ==-==
http://arcgraph.de/sr/


