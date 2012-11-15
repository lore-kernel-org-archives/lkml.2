Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767681Ab2KOMSR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 07:18:17 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:61153 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767601Ab2KOMSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 07:18:15 -0500
From: David Herrmann <dh.herrmann@googlemail.com>
To: fuse-devel@lists.sourceforge.net
Cc: Tejun Heo <tj@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
        linux-kernel@vger.kernel.org,
        David Herrmann <dh.herrmann@googlemail.com>
Subject: [PATCH v2] cuse: do not register multiple devices with the same name
Date: Thu, 15 Nov 2012 13:23:17 +0100
Message-Id: <1352982197-7447-1-git-send-email-dh.herrmann@googlemail.com>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We do not check whether we already registered a CUSE device with a given
name so we might end up with two devices with the same name. Sysfs will
then complain as it cannot create suitable directories.

This patch makes the init-command fail if there is already a device with
the given name. To avoid race-conditions, we protect the whole
registration with a mutex now.

Following the sysfs warnings when registering two devices with the same
name:

 ------------[ cut here ]------------
 WARNING: at fs/sysfs/dir.c:529 sysfs_add_one+0xc8/0xf0()
 Hardware name: N150P/N210P/N220P
 sysfs: cannot create duplicate filename '/devices/virtual/cuse/ttyFseat0'
 Modules linked in: btusb bluetooth
 Pid: 14089, comm: lt-kmscon Tainted: G        W    3.5.3+ #60
 Call Trace:
  [<ffffffff81136400>] ? sysfs_add_one+0x60/0xf0
  [<ffffffff8102f99d>] warn_slowpath_common+0x7d/0xc0
  [<ffffffff8102fa83>] warn_slowpath_fmt+0x43/0x50
  [<ffffffff81136468>] sysfs_add_one+0xc8/0xf0
  [<ffffffff81136686>] create_dir+0x76/0xd0
  [<ffffffff81136a14>] sysfs_create_dir+0x84/0xe0
  [<ffffffff811fe67b>] kobject_add_internal+0x9b/0x200
  [<ffffffff811feb38>] kobject_add+0x68/0xc0
  [<ffffffff81310c73>] device_add+0xe3/0x680
  [<ffffffff8130f5ae>] ? dev_set_name+0x3e/0x40
  [<ffffffff811c6834>] cuse_process_init_reply+0x204/0x410
  [<ffffffff811c6630>] ? cuse_open+0xe0/0xe0
  [<ffffffff811bb23c>] request_end+0xfc/0x1a0
  [<ffffffff811bc6e2>] fuse_dev_do_write+0xa32/0xd10
  [<ffffffff811ba435>] ? fuse_copy_one+0x45/0x60
  [<ffffffff8109cf06>] ? find_get_page+0x66/0xb0
  [<ffffffff811bccc0>] ? fuse_dev_splice_write+0x300/0x300
  [<ffffffff811bcd29>] fuse_dev_write+0x69/0x80
  [<ffffffff810d569c>] do_sync_readv_writev+0xdc/0x120
  [<ffffffff810d57db>] ? rw_copy_check_uvector+0x6b/0x130
  [<ffffffff810b9c5e>] ? handle_mm_fault+0x12e/0x1f0
  [<ffffffff810d5973>] do_readv_writev+0xd3/0x1e0
  [<ffffffff810d5ab0>] vfs_writev+0x30/0x60
  [<ffffffff810d5c38>] sys_writev+0x48/0xb0
  [<ffffffff815846a2>] system_call_fastpath+0x16/0x1b
 ---[ end trace 368eb04507b14c94 ]---

Signed-off-by: David Herrmann <dh.herrmann@googlemail.com>
---
Hi again

I changed the spinlock to a mutex now. This should make it more readable as
Tejun suggested.

Thanks
David

 fs/fuse/cuse.c | 36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/fs/fuse/cuse.c b/fs/fuse/cuse.c
index 1326051..3f392e9 100644
--- a/fs/fuse/cuse.c
+++ b/fs/fuse/cuse.c
@@ -45,7 +45,6 @@
 #include <linux/miscdevice.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
-#include <linux/spinlock.h>
 #include <linux/stat.h>
 #include <linux/module.h>
 
@@ -63,7 +62,7 @@ struct cuse_conn {
 	bool			unrestricted_ioctl;
 };
 
-static DEFINE_SPINLOCK(cuse_lock);		/* protects cuse_conntbl */
+static DEFINE_MUTEX(cuse_lock);			/* protects registration */
 static struct list_head cuse_conntbl[CUSE_CONNTBL_LEN];
 static struct class *cuse_class;
 
@@ -117,14 +116,18 @@ static int cuse_open(struct inode *inode, struct file *file)
 	int rc;
 
 	/* look up and get the connection */
-	spin_lock(&cuse_lock);
+	rc = mutex_lock_interruptible(&cuse_lock);
+	if (rc)
+		return rc;
+
 	list_for_each_entry(pos, cuse_conntbl_head(devt), list)
 		if (pos->dev->devt == devt) {
 			fuse_conn_get(&pos->fc);
 			cc = pos;
 			break;
 		}
-	spin_unlock(&cuse_lock);
+
+	mutex_unlock(&cuse_lock);
 
 	/* dead? */
 	if (!cc)
@@ -308,7 +311,7 @@ static void cuse_gendev_release(struct device *dev)
  */
 static void cuse_process_init_reply(struct fuse_conn *fc, struct fuse_req *req)
 {
-	struct cuse_conn *cc = fc_to_cc(fc);
+	struct cuse_conn *cc = fc_to_cc(fc), *pos;
 	struct cuse_init_out *arg = req->out.args[0].value;
 	struct page *page = req->pages[0];
 	struct cuse_devinfo devinfo = { };
@@ -359,15 +362,23 @@ static void cuse_process_init_reply(struct fuse_conn *fc, struct fuse_req *req)
 	dev_set_drvdata(dev, cc);
 	dev_set_name(dev, "%s", devinfo.name);
 
+	mutex_lock(&cuse_lock);
+
+	/* make sure the device-name is unique */
+	list_for_each_entry(pos, cuse_conntbl_head(devt), list) {
+		if (!strcmp(dev_name(pos->dev), dev_name(dev)))
+			goto err_unlock;
+	}
+
 	rc = device_add(dev);
 	if (rc)
-		goto err_device;
+		goto err_unlock;
 
 	/* register cdev */
 	rc = -ENOMEM;
 	cdev = cdev_alloc();
 	if (!cdev)
-		goto err_device;
+		goto err_unlock;
 
 	cdev->owner = THIS_MODULE;
 	cdev->ops = &cuse_frontend_fops;
@@ -380,9 +391,9 @@ static void cuse_process_init_reply(struct fuse_conn *fc, struct fuse_req *req)
 	cc->cdev = cdev;
 
 	/* make the device available */
-	spin_lock(&cuse_lock);
 	list_add(&cc->list, cuse_conntbl_head(devt));
-	spin_unlock(&cuse_lock);
+
+	mutex_unlock(&cuse_lock);
 
 	/* announce device availability */
 	dev_set_uevent_suppress(dev, 0);
@@ -394,7 +405,8 @@ out:
 
 err_cdev:
 	cdev_del(cdev);
-err_device:
+err_unlock:
+	mutex_unlock(&cuse_lock);
 	put_device(dev);
 err_region:
 	unregister_chrdev_region(devt, 1);
@@ -524,9 +536,9 @@ static int cuse_channel_release(struct inode *inode, struct file *file)
 	int rc;
 
 	/* remove from the conntbl, no more access from this point on */
-	spin_lock(&cuse_lock);
+	mutex_lock(&cuse_lock);
 	list_del_init(&cc->list);
-	spin_unlock(&cuse_lock);
+	mutex_unlock(&cuse_lock);
 
 	/* remove device */
 	if (cc->dev)
-- 
1.8.0

