Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab1HCGHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 02:07:46 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:27165 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab1HCGHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 02:07:41 -0400
Message-ID: <4E38E58D.6080007@oracle.com>
Date: Wed, 03 Aug 2011 14:07:09 +0800
From: Joe Jin <joe.jin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Joe Jin <joe.jin@oracle.com>
CC: Daniel Stodden <daniel.stodden@citrix.com>,
        Jens Axboe <jaxboe@fusionio.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Annie Li <annie.li@oracle.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        Kurt C Hackel <KURT.HACKEL@oracle.com>,
        Greg Marsden <greg.marsden@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH -v2 3/3] xen-blkback: refactor vbd remove/disconnect.
References: <4E38E4A2.3070003@oracle.com>
In-Reply-To: <4E38E4A2.3070003@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090208.4E38E5A6.0009,ss=1,re=-2.300,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch refactor vbd remove/disconnect.
1. Add blkback shutdown watch for the remove/disconnect.
2. Don't disconnect backend when frontend state is XenbusStateClosing
   until frontend state changed to XenbusStateClosed.

Signed-off-by: Joe Jin <joe.jin@oracle.com>
Cc: Daniel Stodden <daniel.stodden@citrix.com>
Cc: Jens Axboe <jaxboe@fusionio.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Annie Li <annie.li@oracle.com>
Cc: Ian Campbell <Ian.Campbell@eu.citrix.com>
---
 drivers/block/xen-blkback/xenbus.c |  203 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 182 insertions(+), 21 deletions(-)

diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index 3f129b4..32d4c3c 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -25,16 +25,25 @@ struct backend_info {
 	struct xenbus_device	*dev;
 	struct xen_blkif	*blkif;
 	struct xenbus_watch	backend_watch;
+	struct xenbus_watch	shutdown_watch;
 	unsigned		major;
 	unsigned		minor;
 	char			*mode;
+	bool			group_added;
+	char			*nodename;
+	atomic_t		refcnt;
+	pid_t			kthread_pid;
+	bool			shutdown_signalled;
 };
 
+DEFINE_SEMAPHORE(blkback_dev_sem);
+
 static struct kmem_cache *xen_blkif_cachep;
 static void connect(struct backend_info *);
 static int connect_ring(struct backend_info *);
 static void backend_changed(struct xenbus_watch *, const char **,
 			    unsigned int);
+static void xen_vbd_free(struct xen_vbd *vbd);
 
 struct xenbus_device *xen_blkbk_xenbus(struct backend_info *be)
 {
@@ -99,6 +108,16 @@ static void xen_update_blkif_status(struct xen_blkif *blkif)
 		blkif->xenblkd = NULL;
 		xenbus_dev_error(blkif->be->dev, err, "start xenblkd");
 	}
+
+	blkif->be->kthread_pid = blkif->xenblkd->pid;
+	atomic_inc(&blkif->be->refcnt);
+
+	err = xenbus_printf(XBT_NIL, blkif->be->dev->nodename, "kthread-pid",
+			    "%d", blkif->xenblkd->pid);
+	if (err) {
+		xenbus_dev_error(blkif->be->dev, err, "write kthread-pid");
+		return;
+	}
 }
 
 static struct xen_blkif *xen_blkif_alloc(domid_t domid)
@@ -213,11 +232,6 @@ static int xen_blkif_map(struct xen_blkif *blkif, unsigned long shared_page,
 
 static void xen_blkif_disconnect(struct xen_blkif *blkif)
 {
-	if (blkif->xenblkd) {
-		kthread_stop(blkif->xenblkd);
-		blkif->xenblkd = NULL;
-	}
-
 	atomic_dec(&blkif->refcnt);
 	wait_event(blkif->waiting_to_free, atomic_read(&blkif->refcnt) == 0);
 	atomic_inc(&blkif->refcnt);
@@ -296,6 +310,7 @@ VBD_SHOW(mode, "%s\n", be->mode);
 int xenvbd_sysfs_addif(struct xenbus_device *dev)
 {
 	int error;
+	struct backend_info *be = dev_get_drvdata(&dev->dev);
 
 	error = device_create_file(&dev->dev, &dev_attr_physical_device);
 	if (error)
@@ -309,6 +324,8 @@ int xenvbd_sysfs_addif(struct xenbus_device *dev)
 	if (error)
 		goto fail3;
 
+	be->group_added = true;
+
 	return 0;
 
 fail3:	sysfs_remove_group(&dev->dev.kobj, &xen_vbdstat_group);
@@ -319,11 +336,73 @@ fail1:	device_remove_file(&dev->dev, &dev_attr_physical_device);
 
 void xenvbd_sysfs_delif(struct xenbus_device *dev)
 {
+	struct backend_info *be = dev_get_drvdata(&dev->dev);
+	if (!be->group_added)
+		return;
 	sysfs_remove_group(&dev->dev.kobj, &xen_vbdstat_group);
 	device_remove_file(&dev->dev, &dev_attr_mode);
 	device_remove_file(&dev->dev, &dev_attr_physical_device);
+	be->group_added = false;
+}
+
+static int xenvbd_kthread_remove(struct backend_info *be)
+{
+	struct xen_blkif *blkif = be->blkif;
+
+	if (!blkif || !blkif->xenblkd)
+		return 0;
+
+	blkif->remove_requested = true;
+	wake_up_process(blkif->xenblkd);
+
+	return -EBUSY;
+}
+
+static void xenvbd_signal_shutdown(struct backend_info *be)
+{
+	int err;
+
+	down(&blkback_dev_sem);
+
+	if (be->shutdown_signalled)
+		goto out;
+
+	err = xenbus_write(XBT_NIL, be->nodename, "shutdown-done", "");
+	if (err)
+		WPRINTK("Error writing shutdown-done for %s: %d\n",
+			be->nodename, err);
+
+	if (be->dev)
+		xenbus_switch_state(be->dev, XenbusStateClosed);
+
+	be->shutdown_signalled = true;
+
+ out:
+	up(&blkback_dev_sem);
 }
 
+static void backend_release(struct backend_info *be)
+{
+	struct xen_blkif *blkif = be->blkif;
+
+	if (current->pid == be->kthread_pid)
+		xenvbd_signal_shutdown(be);
+
+	if (!atomic_dec_and_test(&be->refcnt))
+		return;
+
+	xenvbd_signal_shutdown(be);
+
+	if (blkif) {
+		xen_blkif_disconnect(blkif);
+		xen_vbd_free(&blkif->vbd);
+		xen_blkif_free(blkif);
+		be->blkif = NULL;
+	}
+
+	kfree(be->nodename);
+	kfree(be);
+}
 
 static void xen_vbd_free(struct xen_vbd *vbd)
 {
@@ -332,6 +411,12 @@ static void xen_vbd_free(struct xen_vbd *vbd)
 	vbd->bdev = NULL;
 }
 
+void xen_vbd_sync(struct xen_vbd *vbd)
+{
+	if (vbd->bdev)
+		fsync_bdev(vbd->bdev);
+}
+
 static int xen_vbd_create(struct xen_blkif *blkif, blkif_vdev_t handle,
 			  unsigned major, unsigned minor, int readonly,
 			  int cdrom)
@@ -384,8 +469,9 @@ static int xen_blkbk_remove(struct xenbus_device *dev)
 
 	DPRINTK("");
 
-	if (be->major || be->minor)
-		xenvbd_sysfs_delif(dev);
+	down(&blkback_dev_sem);
+	be->dev = NULL;
+	up(&blkback_dev_sem);
 
 	if (be->backend_watch.node) {
 		unregister_xenbus_watch(&be->backend_watch);
@@ -393,18 +479,73 @@ static int xen_blkbk_remove(struct xenbus_device *dev)
 		be->backend_watch.node = NULL;
 	}
 
-	if (be->blkif) {
-		xen_blkif_disconnect(be->blkif);
-		xen_vbd_free(&be->blkif->vbd);
-		xen_blkif_free(be->blkif);
-		be->blkif = NULL;
+	if (be->shutdown_watch.node) {
+		unregister_xenbus_watch(&be->shutdown_watch);
+		kfree(be->shutdown_watch.node);
+		be->shutdown_watch.node = NULL;
 	}
 
-	kfree(be);
+	if (xenvbd_kthread_remove(be))
+		WPRINTK("BAD REMOVE REQUEST for %s\n", be->nodename);
+
+	xenvbd_sysfs_delif(dev);
+	backend_release(be);
+
 	dev_set_drvdata(&dev->dev, NULL);
+
 	return 0;
 }
 
+/*
+ * called by kthread when closing
+ */
+void xen_blkback_close(struct xen_blkif *blkif)
+{
+	xen_blkif_disconnect(blkif);
+	xen_vbd_sync(&blkif->vbd);
+	blkif->remove_requested = false;
+
+	down(&blkback_dev_sem);
+	if (blkif->be->dev)
+		xenvbd_sysfs_delif(blkif->be->dev);
+	up(&blkback_dev_sem);
+
+	backend_release(blkif->be);
+	blkif->xenblkd = NULL;
+}
+
+static void xenvbd_start_shutdown(struct xenbus_watch *watch,
+			   const char **vec, unsigned int length)
+{
+	int err;
+	char *type;
+	unsigned int len;
+	struct backend_info *be
+		= container_of(watch, struct backend_info, shutdown_watch);
+	struct xenbus_device *dev = be->dev;
+
+	if (be->shutdown_signalled)
+		return;
+
+	type = xenbus_read(XBT_NIL, dev->nodename, "shutdown-request", &len);
+	err  = (IS_ERR(type) ? PTR_ERR(type) : 0);
+
+	if (XENBUS_EXIST_ERR(err))
+		return;
+
+	if (err) {
+		xenbus_dev_fatal(dev, err, "reading shutdown-request");
+		return;
+	}
+
+	xenbus_switch_state(dev, XenbusStateClosing);
+
+	if (len == sizeof("force") - 1 && !memcmp(type, "force", len))
+		if (!xenvbd_kthread_remove(be))
+			xenvbd_signal_shutdown(be); /* shutdown immediately */
+
+	kfree(type);
+}
 int xen_blkbk_flush_diskcache(struct xenbus_transaction xbt,
 			      struct backend_info *be, int state)
 {
@@ -437,6 +578,15 @@ static int xen_blkbk_probe(struct xenbus_device *dev,
 	}
 	be->dev = dev;
 	dev_set_drvdata(&dev->dev, be);
+	atomic_set(&be->refcnt, 1);
+
+	be->nodename = kasprintf(GFP_KERNEL, "%s", dev->nodename);
+	if (!be->nodename) {
+		xenbus_dev_fatal(dev, -ENOMEM,
+				 "allocating backend structure");
+		kfree(be);
+		return -ENOMEM;
+	}
 
 	be->blkif = xen_blkif_alloc(dev->otherend_id);
 	if (IS_ERR(be->blkif)) {
@@ -454,6 +604,12 @@ static int xen_blkbk_probe(struct xenbus_device *dev,
 	if (err)
 		goto fail;
 
+	err = xenbus_watch_pathfmt(dev, &be->shutdown_watch,
+				   xenvbd_start_shutdown, "%s/%s",
+				   dev->nodename, "shutdown-request");
+	if (err)
+		goto fail;
+
 	err = xenbus_switch_state(dev, XenbusStateInitWait);
 	if (err)
 		goto fail;
@@ -567,13 +723,17 @@ static void frontend_changed(struct xenbus_device *dev,
 	struct backend_info *be = dev_get_drvdata(&dev->dev);
 	int err;
 
-	DPRINTK("%s", xenbus_strstate(frontend_state));
+	DPRINTK("%s: %s", dev->nodename, xenbus_strstate(frontend_state));
 
 	switch (frontend_state) {
 	case XenbusStateInitialising:
 		if (dev->state == XenbusStateClosed) {
 			pr_info(DRV_PFX "%s: prepare for reconnect\n",
 				dev->nodename);
+
+			xenbus_rm(XBT_NIL, dev->nodename, "shutdown-done");
+			be->shutdown_signalled = false;
+
 			xenbus_switch_state(dev, XenbusStateInitWait);
 		}
 		break;
@@ -590,7 +750,7 @@ static void frontend_changed(struct xenbus_device *dev,
 
 		/*
 		 * Enforce precondition before potential leak point.
-		 * blkif_disconnect() is idempotent.
+		 * xen_blkif_disconnect() is idempotent.
 		 */
 		xen_blkif_disconnect(be->blkif);
 
@@ -601,17 +761,16 @@ static void frontend_changed(struct xenbus_device *dev,
 		break;
 
 	case XenbusStateClosing:
-		xen_blkif_disconnect(be->blkif);
 		xenbus_switch_state(dev, XenbusStateClosing);
 		break;
 
 	case XenbusStateClosed:
-		xenbus_switch_state(dev, XenbusStateClosed);
-		if (xenbus_dev_is_online(dev))
-			break;
-		/* fall through if not online */
+		if (!xenvbd_kthread_remove(be))
+			xenvbd_signal_shutdown(be);
+		break;
+
 	case XenbusStateUnknown:
-		/* implies blkif_disconnect() via blkback_remove() */
+		/* implies xen_blkif_disconnect() via blkback_remove() */
 		device_unregister(&dev->dev);
 		break;
 
@@ -620,6 +779,8 @@ static void frontend_changed(struct xenbus_device *dev,
 				 frontend_state);
 		break;
 	}
+
+	DPRINTK("%s: %s", dev->nodename, xenbus_strstate(dev->state));
 }
 
 

