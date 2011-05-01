Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040Ab1EAJ3Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 05:29:25 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41482 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433Ab1EAJ3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 05:29:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HVyu/cnakr8alCCXkqkfbwWSaNa9z64dJj+2vfKUNGT7280QqjviLUpLwVEwY754fH
         4AqWfpgWpxqMAgWMBnpzhcgkpSo1ACmkEwo8DWw43U4CJf7lQrAOv9RorImot+60PSsB
         YlcXqytWO/Caac9KldsCuDx4GQH9fGTPg/8K8=
Date: Sun, 1 May 2011 04:29:16 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mauro Carvalho Chehab <mchehab@redhat.com>,
        Dan Carpenter <error27@gmail.com>, Hans Verkuil <hverkuil@xs4all.nl>,
        Andi Huber <hobrom@gmx.at>, Marlon de Boer <marlon@hyves.nl>,
        Damien Churchill <damoxc@gmail.com>
Subject: [PATCH 1/7] [media] cx88: protect per-device driver list with device
 lock
Message-ID: <20110501092859.GA18380@elie>
References: <20110501091710.GA18263@elie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110501091710.GA18263@elie>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: stable@kernel.org
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
 drivers/media/video/cx88/cx88-blackbird.c |    3 ++-
 drivers/media/video/cx88/cx88-dvb.c       |    3 +++
 drivers/media/video/cx88/cx88-mpeg.c      |   11 +++++++----
 drivers/media/video/cx88/cx88.h           |    9 ++++++++-
 4 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/cx88/cx88-blackbird.c b/drivers/media/video/cx88/cx88-blackbird.c
index bca307e..b93fbd3 100644
--- a/drivers/media/video/cx88/cx88-blackbird.c
+++ b/drivers/media/video/cx88/cx88-blackbird.c
@@ -1122,10 +1122,11 @@ static int mpeg_release(struct file *file)
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
 
diff --git a/drivers/media/video/cx88/cx88-dvb.c b/drivers/media/video/cx88/cx88-dvb.c
index 90717ee..88a1507 100644
--- a/drivers/media/video/cx88/cx88-dvb.c
+++ b/drivers/media/video/cx88/cx88-dvb.c
@@ -132,7 +132,10 @@ static int cx88_dvb_bus_ctrl(struct dvb_frontend* fe, int acquire)
 		return -EINVAL;
 	}
 
+	mutex_lock(&dev->core->lock);
 	drv = cx8802_get_driver(dev, CX88_MPEG_DVB);
+	mutex_unlock(&dev->core->lock);
+
 	if (drv) {
 		if (acquire){
 			dev->frontends.active_fe_id = fe_id;
diff --git a/drivers/media/video/cx88/cx88-mpeg.c b/drivers/media/video/cx88/cx88-mpeg.c
index addf954..918172b 100644
--- a/drivers/media/video/cx88/cx88-mpeg.c
+++ b/drivers/media/video/cx88/cx88-mpeg.c
@@ -748,6 +748,8 @@ int cx8802_unregister_driver(struct cx8802_driver *drv)
 		       dev->pci->subsystem_device, dev->core->board.name,
 		       dev->core->boardnr);
 
+		mutex_lock(&dev->core->lock);
+
 		list_for_each_entry_safe(d, dtmp, &dev->drvlist, drvlist) {
 			/* only unregister the correct driver type */
 			if (d->type_id != drv->type_id)
@@ -755,15 +757,14 @@ int cx8802_unregister_driver(struct cx8802_driver *drv)
 
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
@@ -827,6 +828,8 @@ static void __devexit cx8802_remove(struct pci_dev *pci_dev)
 
 	flush_request_modules(dev);
 
+	mutex_lock(&dev->core->lock);
+
 	if (!list_empty(&dev->drvlist)) {
 		struct cx8802_driver *drv, *tmp;
 		int err;
@@ -838,9 +841,7 @@ static void __devexit cx8802_remove(struct pci_dev *pci_dev)
 		list_for_each_entry_safe(drv, tmp, &dev->drvlist, drvlist) {
 			err = drv->remove(drv);
 			if (err == 0) {
-				mutex_lock(&drv->core->lock);
 				list_del(&drv->drvlist);
-				mutex_unlock(&drv->core->lock);
 			} else
 				printk(KERN_ERR "%s/2: cx8802 driver remove "
 				       "failed (%d)\n", dev->core->name, err);
@@ -848,6 +849,8 @@ static void __devexit cx8802_remove(struct pci_dev *pci_dev)
 		}
 	}
 
+	mutex_unlock(&dev->core->lock);
+
 	/* Destroy any 8802 reference. */
 	dev->core->dvbdev = NULL;
 
diff --git a/drivers/media/video/cx88/cx88.h b/drivers/media/video/cx88/cx88.h
index c9981e7..6ff34c7 100644
--- a/drivers/media/video/cx88/cx88.h
+++ b/drivers/media/video/cx88/cx88.h
@@ -496,7 +496,11 @@ struct cx8802_driver {
 	int (*resume)(struct pci_dev *pci_dev);
 
 	/* MPEG 8802 -> mini driver - Driver probe and configuration */
+
+	/* Caller must _not_ hold core->lock */
 	int (*probe)(struct cx8802_driver *drv);
+
+	/* Caller must hold core->lock */
 	int (*remove)(struct cx8802_driver *drv);
 
 	/* MPEG 8802 -> mini driver - Access for hardware control */
@@ -551,8 +555,9 @@ struct cx8802_dev {
 	/* for switching modulation types */
 	unsigned char              ts_gen_cntrl;
 
-	/* List of attached drivers */
+	/* List of attached drivers; must hold core->lock to access */
 	struct list_head	   drvlist;
+
 	struct work_struct	   request_module_wk;
 };
 
@@ -675,6 +680,8 @@ int cx88_audio_thread(void *data);
 
 int cx8802_register_driver(struct cx8802_driver *drv);
 int cx8802_unregister_driver(struct cx8802_driver *drv);
+
+/* Caller must hold core->lock */
 struct cx8802_driver * cx8802_get_driver(struct cx8802_dev *dev, enum cx88_board_type btype);
 
 /* ----------------------------------------------------------- */
-- 
1.7.5

