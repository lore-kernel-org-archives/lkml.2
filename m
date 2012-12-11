Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab2LKUug (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 15:50:36 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:14619 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab2LKUue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 15:50:34 -0500
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFJhy0PGlDs
X-RZG-CLASS-ID: mo00
From: Olaf Hering <olaf@aepfle.de>
To: konrad.wilk@oracle.com
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xen.org, jbeulich@suse.com,
        Olaf Hering <olaf@aepfle.de>
Subject: [PATCH] xen/blkback: prevent repeated backend_changed invocations
Date: Tue, 11 Dec 2012 21:50:26 +0100
Message-Id: <1355259026-16946-1-git-send-email-olaf@aepfle.de>
X-Mailer: git-send-email 1.8.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

backend_changed might be called multiple times, which will leak
be->mode. Make sure it will be called only once. Remove some unneeded
checks. Also the be->mode string was leaked, release the memory on
device shutdown.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
---

incorporate all comments from Jan.
fold the oneline change to xen_blkbk_remove into this change
now its compile tested.

 drivers/block/xen-blkback/xenbus.c | 69 ++++++++++++++++++--------------------
 1 file changed, 33 insertions(+), 36 deletions(-)

diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index f58434c..5ca77c3 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -28,6 +28,7 @@ struct backend_info {
 	unsigned		major;
 	unsigned		minor;
 	char			*mode;
+	unsigned		alive;
 };
 
 static struct kmem_cache *xen_blkif_cachep;
@@ -366,6 +367,7 @@ static int xen_blkbk_remove(struct xenbus_device *dev)
 		be->blkif = NULL;
 	}
 
+	kfree(be->mode);
 	kfree(be);
 	dev_set_drvdata(&dev->dev, NULL);
 	return 0;
@@ -501,10 +503,14 @@ static void backend_changed(struct xenbus_watch *watch,
 		= container_of(watch, struct backend_info, backend_watch);
 	struct xenbus_device *dev = be->dev;
 	int cdrom = 0;
-	char *device_type;
+	char *device_type, *p;
+	long handle;
 
 	DPRINTK("");
 
+	if (be->alive)
+		return;
+
 	err = xenbus_scanf(XBT_NIL, dev->nodename, "physical-device", "%x:%x",
 			   &major, &minor);
 	if (XENBUS_EXIST_ERR(err)) {
@@ -520,12 +526,7 @@ static void backend_changed(struct xenbus_watch *watch,
 		return;
 	}
 
-	if ((be->major || be->minor) &&
-	    ((be->major != major) || (be->minor != minor))) {
-		pr_warn(DRV_PFX "changing physical device (from %x:%x to %x:%x) not supported.\n",
-			be->major, be->minor, major, minor);
-		return;
-	}
+	be->alive = 1;
 
 	be->mode = xenbus_read(XBT_NIL, dev->nodename, "mode", NULL);
 	if (IS_ERR(be->mode)) {
@@ -541,39 +542,35 @@ static void backend_changed(struct xenbus_watch *watch,
 		kfree(device_type);
 	}
 
-	if (be->major == 0 && be->minor == 0) {
-		/* Front end dir is a number, which is used as the handle. */
-
-		char *p = strrchr(dev->otherend, '/') + 1;
-		long handle;
-		err = strict_strtoul(p, 0, &handle);
-		if (err)
-			return;
-
-		be->major = major;
-		be->minor = minor;
+	/* Front end dir is a number, which is used as the handle. */
+	p = strrchr(dev->otherend, '/') + 1;
+	err = strict_strtoul(p, 0, &handle);
+	if (err)
+		return;
 
-		err = xen_vbd_create(be->blkif, handle, major, minor,
-				 (NULL == strchr(be->mode, 'w')), cdrom);
-		if (err) {
-			be->major = 0;
-			be->minor = 0;
-			xenbus_dev_fatal(dev, err, "creating vbd structure");
-			return;
-		}
+	be->major = major;
+	be->minor = minor;
 
-		err = xenvbd_sysfs_addif(dev);
-		if (err) {
-			xen_vbd_free(&be->blkif->vbd);
-			be->major = 0;
-			be->minor = 0;
-			xenbus_dev_fatal(dev, err, "creating sysfs entries");
-			return;
-		}
+	err = xen_vbd_create(be->blkif, handle, major, minor,
+			 (NULL == strchr(be->mode, 'w')), cdrom);
+	if (err) {
+		be->major = 0;
+		be->minor = 0;
+		xenbus_dev_fatal(dev, err, "creating vbd structure");
+		return;
+	}
 
-		/* We're potentially connected now */
-		xen_update_blkif_status(be->blkif);
+	err = xenvbd_sysfs_addif(dev);
+	if (err) {
+		xen_vbd_free(&be->blkif->vbd);
+		be->major = 0;
+		be->minor = 0;
+		xenbus_dev_fatal(dev, err, "creating sysfs entries");
+		return;
 	}
+
+	/* We're potentially connected now */
+	xen_update_blkif_status(be->blkif);
 }
 
 
-- 
1.8.0.1

