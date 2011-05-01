Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab1EAJaF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 05:30:05 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41482 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab1EAJaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 05:30:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=X7GLBhK4Mc/jR8iVXhwuJPf3npDDJ28VUx/NqGTqkMA3VVRoPabg6sx6tzds+U1klX
         ThvR51Z9VbCfVgH5T7htSQZaSQ0CIgSHu6cdBQ9EtR2rupca2ZZYROVVBQjNsJ9ff0D4
         yswRaJOBtYD0b4nyJy7r3yiZL1rgN+rWsotiY=
Date: Sun, 1 May 2011 04:29:56 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mauro Carvalho Chehab <mchehab@redhat.com>,
        Dan Carpenter <error27@gmail.com>, Hans Verkuil <hverkuil@xs4all.nl>,
        Andi Huber <hobrom@gmx.at>, Marlon de Boer <marlon@hyves.nl>,
        Damien Churchill <damoxc@gmail.com>
Subject: [PATCH 3/7] [media] cx88: hold device lock during sub-driver
 initialization
Message-ID: <20110501092956.GC18380@elie>
References: <20110501091710.GA18263@elie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110501091710.GA18263@elie>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cx8802_blackbird_probe makes a device node for the mpeg sub-device
before it has been added to dev->drvlist.  If the device is opened
during that time, the open succeeds but request_acquire cannot be
called, so the reference count remains zero.  Later, when the device
is closed, the reference count becomes negative --- uh oh.

Close the race by holding core->lock during probe and not releasing
until the device is in drvlist and initialization finished.
Previously the BKL prevented this race.

Reported-by: Andreas Huber <hobrom@gmx.at>
Tested-by: Andi Huber <hobrom@gmx.at>
Tested-by: Marlon de Boer <marlon@hyves.nl>
Cc: stable@kernel.org
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
 drivers/media/video/cx88/cx88-blackbird.c |    2 --
 drivers/media/video/cx88/cx88-mpeg.c      |    5 ++---
 drivers/media/video/cx88/cx88.h           |    7 ++-----
 3 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/media/video/cx88/cx88-blackbird.c b/drivers/media/video/cx88/cx88-blackbird.c
index a6f7d53..f637d34 100644
--- a/drivers/media/video/cx88/cx88-blackbird.c
+++ b/drivers/media/video/cx88/cx88-blackbird.c
@@ -1335,11 +1335,9 @@ static int cx8802_blackbird_probe(struct cx8802_driver *drv)
 	blackbird_register_video(dev);
 
 	/* initial device configuration: needed ? */
-	mutex_lock(&dev->core->lock);
 //	init_controls(core);
 	cx88_set_tvnorm(core,core->tvnorm);
 	cx88_video_mux(core,0);
-	mutex_unlock(&dev->core->lock);
 
 	return 0;
 
diff --git a/drivers/media/video/cx88/cx88-mpeg.c b/drivers/media/video/cx88/cx88-mpeg.c
index 9147c16..497f26f 100644
--- a/drivers/media/video/cx88/cx88-mpeg.c
+++ b/drivers/media/video/cx88/cx88-mpeg.c
@@ -709,18 +709,17 @@ int cx8802_register_driver(struct cx8802_driver *drv)
 		drv->request_release = cx8802_request_release;
 		memcpy(driver, drv, sizeof(*driver));
 
+		mutex_lock(&drv->core->lock);
 		err = drv->probe(driver);
 		if (err == 0) {
 			i++;
-			mutex_lock(&drv->core->lock);
 			list_add_tail(&driver->drvlist, &dev->drvlist);
-			mutex_unlock(&drv->core->lock);
 		} else {
 			printk(KERN_ERR
 			       "%s/2: cx8802 probe failed, err = %d\n",
 			       dev->core->name, err);
 		}
-
+		mutex_unlock(&drv->core->lock);
 	}
 
 	return i ? 0 : -ENODEV;
diff --git a/drivers/media/video/cx88/cx88.h b/drivers/media/video/cx88/cx88.h
index e912919..93a94bf 100644
--- a/drivers/media/video/cx88/cx88.h
+++ b/drivers/media/video/cx88/cx88.h
@@ -495,13 +495,10 @@ struct cx8802_driver {
 	int (*suspend)(struct pci_dev *pci_dev, pm_message_t state);
 	int (*resume)(struct pci_dev *pci_dev);
 
+	/* Callers to the following functions must hold core->lock */
+
 	/* MPEG 8802 -> mini driver - Driver probe and configuration */
-
-	/* Caller must _not_ hold core->lock */
 	int (*probe)(struct cx8802_driver *drv);
-
-	/* Callers to the following functions must hold core->lock */
-
 	int (*remove)(struct cx8802_driver *drv);
 
 	/* MPEG 8802 -> mini driver - Access for hardware control */
-- 
1.7.5

