Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163006Ab1FAIiT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:38:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44341 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162977Ab1FAI0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:26:08 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:12:05 2011
Message-Id: <20110601081204.704416584@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:11:34 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jonathan Nieder <jrnieder@gmail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [124/165] [media] cx88: protect per-device driver list with device
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
 lock
Content-Length: 5085
Lines: 156

From: Jonathan Nieder <jrnieder@gmail.com>

commit 8a317a8760cfffa8185b56ff59fb4b6c58488d79 upstream.

The BKL conversion of this driver seems to have gone wrong.  Various
uses of the sub-device and driver lists appear to be subject to race
conditions.

In particular, some functions access drvlist without a relevant lock
held, which will race against removal of drivers.  Let's start with
that --- clean up by consistently protecting dev->drvlist with
dev->core->lock, noting driver functions that require the device lock
to be held or not to be held.

After this patch, there are still some races --- e.g.,
cx8802_blackbird_remove can run between the time the blackbird driver
is acquired and the time it is used in mpeg_release, and there's a
similar race in cx88_dvb_bus_ctrl.  Later patches will address the
remaining known races and the deadlock noticed by Andi.  This patch
just makes the semantics clearer in preparation for those later
changes.

Based on work by Ben Hutchings <ben@decadent.org.uk>.

Tested-by: Andi Huber <hobrom@gmx.at>
Tested-by: Marlon de Boer <marlon@hyves.nl>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/cx88/cx88-blackbird.c |    3 ++-
 drivers/media/video/cx88/cx88-dvb.c       |    3 +++
 drivers/media/video/cx88/cx88-mpeg.c      |   11 +++++++----
 drivers/media/video/cx88/cx88.h           |    9 ++++++++-
 4 files changed, 20 insertions(+), 6 deletions(-)

--- a/drivers/media/video/cx88/cx88-blackbird.c
+++ b/drivers/media/video/cx88/cx88-blackbird.c
@@ -1122,10 +1122,11 @@ static int mpeg_release(struct file *fil
 	mutex_lock(&dev->core->lock);
 	file->private_data = NULL;
 	kfree(fh);
-	mutex_unlock(&dev->core->lock);
 
 	/* Make sure we release the hardware */
 	drv = cx8802_get_driver(dev, CX88_MPEG_BLACKBIRD);
+	mutex_unlock(&dev->core->lock);
+
 	if (drv)
 		drv->request_release(drv);
 
--- a/drivers/media/video/cx88/cx88-dvb.c
+++ b/drivers/media/video/cx88/cx88-dvb.c
@@ -133,7 +133,10 @@ static int cx88_dvb_bus_ctrl(struct dvb_
 		return -EINVAL;
 	}
 
+	mutex_lock(&dev->core->lock);
 	drv = cx8802_get_driver(dev, CX88_MPEG_DVB);
+	mutex_unlock(&dev->core->lock);
+
 	if (drv) {
 		if (acquire){
 			dev->frontends.active_fe_id = fe_id;
--- a/drivers/media/video/cx88/cx88-mpeg.c
+++ b/drivers/media/video/cx88/cx88-mpeg.c
@@ -748,6 +748,8 @@ int cx8802_unregister_driver(struct cx88
 		       dev->pci->subsystem_device, dev->core->board.name,
 		       dev->core->boardnr);
 
+		mutex_lock(&dev->core->lock);
+
 		list_for_each_entry_safe(d, dtmp, &dev->drvlist, drvlist) {
 			/* only unregister the correct driver type */
 			if (d->type_id != drv->type_id)
@@ -755,15 +757,14 @@ int cx8802_unregister_driver(struct cx88
 
 			err = d->remove(d);
 			if (err == 0) {
-				mutex_lock(&drv->core->lock);
 				list_del(&d->drvlist);
-				mutex_unlock(&drv->core->lock);
 				kfree(d);
 			} else
 				printk(KERN_ERR "%s/2: cx8802 driver remove "
 				       "failed (%d)\n", dev->core->name, err);
 		}
 
+		mutex_unlock(&dev->core->lock);
 	}
 
 	return err;
@@ -827,6 +828,8 @@ static void __devexit cx8802_remove(stru
 
 	flush_request_modules(dev);
 
+	mutex_lock(&dev->core->lock);
+
 	if (!list_empty(&dev->drvlist)) {
 		struct cx8802_driver *drv, *tmp;
 		int err;
@@ -838,9 +841,7 @@ static void __devexit cx8802_remove(stru
 		list_for_each_entry_safe(drv, tmp, &dev->drvlist, drvlist) {
 			err = drv->remove(drv);
 			if (err == 0) {
-				mutex_lock(&drv->core->lock);
 				list_del(&drv->drvlist);
-				mutex_unlock(&drv->core->lock);
 			} else
 				printk(KERN_ERR "%s/2: cx8802 driver remove "
 				       "failed (%d)\n", dev->core->name, err);
@@ -848,6 +849,8 @@ static void __devexit cx8802_remove(stru
 		}
 	}
 
+	mutex_unlock(&dev->core->lock);
+
 	/* Destroy any 8802 reference. */
 	dev->core->dvbdev = NULL;
 
--- a/drivers/media/video/cx88/cx88.h
+++ b/drivers/media/video/cx88/cx88.h
@@ -506,7 +506,11 @@ struct cx8802_driver {
 	int (*resume)(struct pci_dev *pci_dev);
 
 	/* MPEG 8802 -> mini driver - Driver probe and configuration */
+
+	/* Caller must _not_ hold core->lock */
 	int (*probe)(struct cx8802_driver *drv);
+
+	/* Caller must hold core->lock */
 	int (*remove)(struct cx8802_driver *drv);
 
 	/* MPEG 8802 -> mini driver - Access for hardware control */
@@ -561,8 +565,9 @@ struct cx8802_dev {
 	/* for switching modulation types */
 	unsigned char              ts_gen_cntrl;
 
-	/* List of attached drivers */
+	/* List of attached drivers; must hold core->lock to access */
 	struct list_head	   drvlist;
+
 	struct work_struct	   request_module_wk;
 };
 
@@ -685,6 +690,8 @@ int cx88_audio_thread(void *data);
 
 int cx8802_register_driver(struct cx8802_driver *drv);
 int cx8802_unregister_driver(struct cx8802_driver *drv);
+
+/* Caller must hold core->lock */
 struct cx8802_driver * cx8802_get_driver(struct cx8802_dev *dev, enum cx88_board_type btype);
 
 /* ----------------------------------------------------------- */


