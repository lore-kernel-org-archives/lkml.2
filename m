Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab1EAJaY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 05:30:24 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41482 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822Ab1EAJaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 05:30:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rw6Qij3JqtgbP5oPp0kFj53LOangRLAnmAQl1T29tcXX1ibHbF114laEPsA3p8PvaQ
         JGVw920IYvAgT5/bRyP8lXn6AwAqUVJ1+2SncPKnMUt0brdijQ+9S34eoVmR8yDXJVgH
         FswGZayOCgrtDFt3/gSBRCxAcG/RwprgxYO7g=
Date: Sun, 1 May 2011 04:30:14 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mauro Carvalho Chehab <mchehab@redhat.com>,
        Dan Carpenter <error27@gmail.com>, Hans Verkuil <hverkuil@xs4all.nl>,
        Andi Huber <hobrom@gmx.at>, Marlon de Boer <marlon@hyves.nl>,
        Damien Churchill <damoxc@gmail.com>
Subject: [PATCH 4/7] [media] cx88: protect cx8802_devlist with a mutex
Message-ID: <20110501093014.GD18380@elie>
References: <20110501091710.GA18263@elie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110501091710.GA18263@elie>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add and use a mutex to protect the cx88-mpeg device list.  Previously
the BKL prevented races.

Based on work by Ben Hutchings <ben@decadent.org.uk>.

Tested-by: Andi Huber <hobrom@gmx.at>
Tested-by: Marlon de Boer <marlon@hyves.nl>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
 drivers/media/video/cx88/cx88-mpeg.c |   20 +++++++++++++++++---
 1 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/cx88/cx88-mpeg.c b/drivers/media/video/cx88/cx88-mpeg.c
index 497f26f..b18f9fe 100644
--- a/drivers/media/video/cx88/cx88-mpeg.c
+++ b/drivers/media/video/cx88/cx88-mpeg.c
@@ -78,6 +78,7 @@ static void flush_request_modules(struct cx8802_dev *dev)
 
 
 static LIST_HEAD(cx8802_devlist);
+static DEFINE_MUTEX(cx8802_mutex);
 /* ------------------------------------------------------------------ */
 
 static int cx8802_start_dma(struct cx8802_dev    *dev,
@@ -689,6 +690,8 @@ int cx8802_register_driver(struct cx8802_driver *drv)
 		return err;
 	}
 
+	mutex_lock(&cx8802_mutex);
+
 	list_for_each_entry(dev, &cx8802_devlist, devlist) {
 		printk(KERN_INFO
 		       "%s/2: subsystem: %04x:%04x, board: %s [card=%d]\n",
@@ -698,8 +701,10 @@ int cx8802_register_driver(struct cx8802_driver *drv)
 
 		/* Bring up a new struct for each driver instance */
 		driver = kzalloc(sizeof(*drv),GFP_KERNEL);
-		if (driver == NULL)
-			return -ENOMEM;
+		if (driver == NULL) {
+			err = -ENOMEM;
+			goto out;
+		}
 
 		/* Snapshot of the driver registration data */
 		drv->core = dev->core;
@@ -722,7 +727,10 @@ int cx8802_register_driver(struct cx8802_driver *drv)
 		mutex_unlock(&drv->core->lock);
 	}
 
-	return i ? 0 : -ENODEV;
+	err = i ? 0 : -ENODEV;
+out:
+	mutex_unlock(&cx8802_mutex);
+	return err;
 }
 
 int cx8802_unregister_driver(struct cx8802_driver *drv)
@@ -736,6 +744,8 @@ int cx8802_unregister_driver(struct cx8802_driver *drv)
 	       drv->type_id == CX88_MPEG_DVB ? "dvb" : "blackbird",
 	       drv->hw_access == CX8802_DRVCTL_SHARED ? "shared" : "exclusive");
 
+	mutex_lock(&cx8802_mutex);
+
 	list_for_each_entry(dev, &cx8802_devlist, devlist) {
 		printk(KERN_INFO
 		       "%s/2: subsystem: %04x:%04x, board: %s [card=%d]\n",
@@ -762,6 +772,8 @@ int cx8802_unregister_driver(struct cx8802_driver *drv)
 		mutex_unlock(&dev->core->lock);
 	}
 
+	mutex_unlock(&cx8802_mutex);
+
 	return err;
 }
 
@@ -799,7 +811,9 @@ static int __devinit cx8802_probe(struct pci_dev *pci_dev,
 		goto fail_free;
 
 	INIT_LIST_HEAD(&dev->drvlist);
+	mutex_lock(&cx8802_mutex);
 	list_add_tail(&dev->devlist,&cx8802_devlist);
+	mutex_unlock(&cx8802_mutex);
 
 	/* now autoload cx88-dvb or cx88-blackbird */
 	request_modules(dev);
-- 
1.7.5

