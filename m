Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795Ab1DEBQw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 21:16:52 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61673 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583Ab1DEBQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 21:16:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aUQAbxbL3Fhd6rOGXxUWOpEOgmcJtLwFVXynbygqUVq8CEH7ZnImHDsejCL0vTtLJq
         2PniBN56ii1P1LapzpqPmjPh3bi8yqHimy1jNRvVAWq7PHrxXnuswqfo2V8s7fZGKHRf
         Zr0t+ooIgkG1QdQSVJu3Apyuse0mKfF4W5Uio=
Date: Mon, 4 Apr 2011 20:16:40 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Andreas Huber <hobrom@gmx.at>
Cc: linux-media@vger.kernel.org, Huber Andreas <hobrom@corax.at>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-kernel@vger.kernel.org,
        andrew.walker27@ntlworld.com, Ben Hutchings <ben@decadent.org.uk>,
        Trent Piepho <xyzzy@speakeasy.org>, Roland Stoll <dvb.rs@xindex.de>
Subject: Re: [PATCH 3/3] [media] cx88: use a mutex to protect cx8802_devlist
Message-ID: <20110405011640.GB1830@elie>
References: <20110327150610.4029.95961.reportbug@xen.corax.at>
 <20110327152810.GA32106@elie>
 <20110402093856.GA17015@elie>
 <20110402094451.GD17015@elie>
 <4D971B8D.4040305@corax.at>
 <20110402192902.GD20064@elie>
 <4D978378.7060106@gmx.at>
 <4D992920.4040400@gmx.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D992920.4040400@gmx.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again,

Andreas Huber wrote:

> [...]
>     /* Make sure we can acquire the hardware */
>     drv = cx8802_get_driver(dev, CX88_MPEG_BLACKBIRD);      // HOW TO DEAL WITH NULL  ??????
>     if (drv) {

Reasonable question.  Could you try this patch?

-- 8< -- 
Subject: [media] cx88: lock device during driver initialization

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
index 6b58647..b18f9fe 100644
--- a/drivers/media/video/cx88/cx88-mpeg.c
+++ b/drivers/media/video/cx88/cx88-mpeg.c
@@ -714,18 +714,17 @@ int cx8802_register_driver(struct cx8802_driver *drv)
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
 
 	err = i ? 0 : -ENODEV;
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

