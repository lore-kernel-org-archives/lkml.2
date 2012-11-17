Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648Ab2KQLkc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 06:40:32 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57250 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab2KQLkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 06:40:31 -0500
From: David Herrmann <dh.herrmann@googlemail.com>
To: fuse-devel@lists.sourceforge.net
Cc: Tejun Heo <tj@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
        linux-kernel@vger.kernel.org,
        David Herrmann <dh.herrmann@googlemail.com>
Subject: [PATCH v3 2/2] cuse: do not register multiple devices with identical names
Date: Sat, 17 Nov 2012 12:45:48 +0100
Message-Id: <1353152748-6867-2-git-send-email-dh.herrmann@googlemail.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353152748-6867-1-git-send-email-dh.herrmann@googlemail.com>
References: <1353152748-6867-1-git-send-email-dh.herrmann@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sysfs doesn't allow two devices with the same name, but we register a
sysfs entry for each cuse device without checking for name collisions.
This extends the registration to first check whether the name was already
registered.

To avoid race-conditions between the name-check and linking the device, we
need to protect the whole registration with a mutex.

Signed-off-by: David Herrmann <dh.herrmann@googlemail.com>
---
Hi

Changes in v2 include:
 - move mutex-conversion into a separate patch
 - check every list in the cuse_conntbl array, not only the current one

 fs/fuse/cuse.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/fs/fuse/cuse.c b/fs/fuse/cuse.c
index e830dab..c56c84c 100644
--- a/fs/fuse/cuse.c
+++ b/fs/fuse/cuse.c
@@ -308,14 +308,14 @@ static void cuse_gendev_release(struct device *dev)
  */
 static void cuse_process_init_reply(struct fuse_conn *fc, struct fuse_req *req)
 {
-	struct cuse_conn *cc = fc_to_cc(fc);
+	struct cuse_conn *cc = fc_to_cc(fc), *pos;
 	struct cuse_init_out *arg = req->out.args[0].value;
 	struct page *page = req->pages[0];
 	struct cuse_devinfo devinfo = { };
 	struct device *dev;
 	struct cdev *cdev;
 	dev_t devt;
-	int rc;
+	int rc, i;
 
 	if (req->out.h.error ||
 	    arg->major != FUSE_KERNEL_VERSION || arg->minor < 11) {
@@ -359,15 +359,24 @@ static void cuse_process_init_reply(struct fuse_conn *fc, struct fuse_req *req)
 	dev_set_drvdata(dev, cc);
 	dev_set_name(dev, "%s", devinfo.name);
 
+	mutex_lock(&cuse_lock);
+
+	/* make sure the device-name is unique */
+	for (i = 0; i < CUSE_CONNTBL_LEN; ++i) {
+		list_for_each_entry(pos, &cuse_conntbl[i], list)
+			if (!strcmp(dev_name(pos->dev), dev_name(dev)))
+				goto err_unlock;
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
@@ -380,7 +389,6 @@ static void cuse_process_init_reply(struct fuse_conn *fc, struct fuse_req *req)
 	cc->cdev = cdev;
 
 	/* make the device available */
-	mutex_lock(&cuse_lock);
 	list_add(&cc->list, cuse_conntbl_head(devt));
 	mutex_unlock(&cuse_lock);
 
@@ -394,7 +402,8 @@ out:
 
 err_cdev:
 	cdev_del(cdev);
-err_device:
+err_unlock:
+	mutex_unlock(&cuse_lock);
 	put_device(dev);
 err_region:
 	unregister_chrdev_region(devt, 1);
-- 
1.8.0

