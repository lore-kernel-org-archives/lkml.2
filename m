Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643Ab1DED1V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 23:27:21 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38774 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab1DED1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 23:27:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=p4cC+yBw4lbiIop2ysn0h8lQ1v+WVXjQ/bhwyGdmYf5y5KUWs4eUUicspuJ5A+YSoV
         ixKCADcD3FyL0Rz82fg8ycTMuyvTsLfryWskG6igJf+AtFk+pAmOaYfuOyqm7hn99h1b
         EYhk1vA2PL7PQ2z1j2PYC+2EYtINFTP0pTxlA=
Date: Mon, 4 Apr 2011 22:27:13 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: linux-media@vger.kernel.org
Cc: Huber Andreas <hobrom@corax.at>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-kernel@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>,
        Steven Toth <stoth@kernellabs.com>
Subject: [PATCH 3/7] [media] cx88: hold device lock during sub-driver
 initialization
Message-ID: <20110405032713.GD4498@elie>
References: <20110327150610.4029.95961.reportbug@xen.corax.at>
 <20110327152810.GA32106@elie>
 <20110402093856.GA17015@elie>
 <20110405032014.GA4498@elie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110405032014.GA4498@elie>
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
index 9731daa..3d32f4a 100644
--- a/drivers/media/video/cx88/cx88.h
+++ b/drivers/media/video/cx88/cx88.h
@@ -505,13 +505,10 @@ struct cx8802_driver {
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
1.7.5.rc0

