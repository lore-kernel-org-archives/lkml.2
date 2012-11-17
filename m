Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599Ab2KQLkb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 06:40:31 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57250 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408Ab2KQLk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 06:40:29 -0500
From: David Herrmann <dh.herrmann@googlemail.com>
To: fuse-devel@lists.sourceforge.net
Cc: Tejun Heo <tj@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
        linux-kernel@vger.kernel.org,
        David Herrmann <dh.herrmann@googlemail.com>
Subject: [PATCH v3 1/2] cuse: use mutex as registration lock instead of spinlocks
Date: Sat, 17 Nov 2012 12:45:47 +0100
Message-Id: <1353152748-6867-1-git-send-email-dh.herrmann@googlemail.com>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to check for name-collisions during cuse-device registration. To
avoid race-conditions, this needs to be protected during the whole device
registration. Therefore, replace the spinlocks by mutexes first so we can
safely extend the locked regions to include more expensive or sleeping
code paths.

Signed-off-by: David Herrmann <dh.herrmann@googlemail.com>
---
Hi again

Sorry for the noise, but I think this time everything should work. I fixed the
name-check to check for all registered devices instead only one list.
And I split it into two patches.

Thanks for the reviews!
David

 fs/fuse/cuse.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/fs/fuse/cuse.c b/fs/fuse/cuse.c
index ee8d550..e830dab 100644
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
 
@@ -114,14 +113,18 @@ static int cuse_open(struct inode *inode, struct file *file)
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
@@ -377,9 +380,9 @@ static void cuse_process_init_reply(struct fuse_conn *fc, struct fuse_req *req)
 	cc->cdev = cdev;
 
 	/* make the device available */
-	spin_lock(&cuse_lock);
+	mutex_lock(&cuse_lock);
 	list_add(&cc->list, cuse_conntbl_head(devt));
-	spin_unlock(&cuse_lock);
+	mutex_unlock(&cuse_lock);
 
 	/* announce device availability */
 	dev_set_uevent_suppress(dev, 0);
@@ -520,9 +523,9 @@ static int cuse_channel_release(struct inode *inode, struct file *file)
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

