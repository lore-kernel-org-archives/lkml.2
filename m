Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab1EAJay (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 05:30:54 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52691 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab1EAJav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 05:30:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=j2GDEe5FSRFP6EBNd5Mj0XrpeEGaRZ/CEianhgtJqGsPWW3rDNjYdPd89TCFr3DF/z
         n5p4DrrxsvkuArtDQ+yIJkGccJOLtSsBX/l7DGNLcL1DA4gJSO7JBcnvHormgIzZVVz/
         SRnchWxdijBsVU+UXi803ZpzLv3RRS4tbOfYA=
Date: Sun, 1 May 2011 04:30:46 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mauro Carvalho Chehab <mchehab@redhat.com>,
        Dan Carpenter <error27@gmail.com>, Hans Verkuil <hverkuil@xs4all.nl>,
        Andi Huber <hobrom@gmx.at>, Marlon de Boer <marlon@hyves.nl>,
        Damien Churchill <damoxc@gmail.com>
Subject: [PATCH 5/7] [media] cx88: gracefully reject attempts to use
 unregistered cx88-blackbird driver
Message-ID: <20110501093046.GE18380@elie>
References: <20110501091710.GA18263@elie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110501091710.GA18263@elie>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It should not be possible to enter mpeg_open and acquire core->lock
without the blackbird driver being registered, so just error out if it
is not.  This makes the code more readable and should prevent the bug
fixed by the patch "hold device lock during sub-driver initialization"
from resurfacing again.

Similarly, if we enter mpeg_release and acquire core->lock then either
the blackbird driver is registered (since open files keep it loaded)
or the sysadmin forced the driver's removal.  In the latter case the
state will be inconsistent and this is worth a loud warning.

Tested-by: Andi Huber <hobrom@gmx.at>
Tested-by: Marlon de Boer <marlon@hyves.nl>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
 drivers/media/video/cx88/cx88-blackbird.c |   25 ++++++++++++++-----------
 1 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/media/video/cx88/cx88-blackbird.c b/drivers/media/video/cx88/cx88-blackbird.c
index f637d34..fa8e347 100644
--- a/drivers/media/video/cx88/cx88-blackbird.c
+++ b/drivers/media/video/cx88/cx88-blackbird.c
@@ -1060,18 +1060,21 @@ static int mpeg_open(struct file *file)
 
 	/* Make sure we can acquire the hardware */
 	drv = cx8802_get_driver(dev, CX88_MPEG_BLACKBIRD);
-	if (drv) {
-		err = drv->request_acquire(drv);
-		if(err != 0) {
-			dprintk(1,"%s: Unable to acquire hardware, %d\n", __func__, err);
-			mutex_unlock(&dev->core->lock);
-			return err;
-		}
+	if (!drv) {
+		dprintk(1, "%s: blackbird driver is not loaded\n", __func__);
+		mutex_unlock(&dev->core->lock);
+		return -ENODEV;
+	}
+
+	err = drv->request_acquire(drv);
+	if (err != 0) {
+		dprintk(1,"%s: Unable to acquire hardware, %d\n", __func__, err);
+		mutex_unlock(&dev->core->lock);
+		return err;
 	}
 
 	if (!atomic_read(&dev->core->mpeg_users) && blackbird_initialize_codec(dev) < 0) {
-		if (drv)
-			drv->request_release(drv);
+		drv->request_release(drv);
 		mutex_unlock(&dev->core->lock);
 		return -EINVAL;
 	}
@@ -1080,8 +1083,7 @@ static int mpeg_open(struct file *file)
 	/* allocate + initialize per filehandle data */
 	fh = kzalloc(sizeof(*fh),GFP_KERNEL);
 	if (NULL == fh) {
-		if (drv)
-			drv->request_release(drv);
+		drv->request_release(drv);
 		mutex_unlock(&dev->core->lock);
 		return -ENOMEM;
 	}
@@ -1125,6 +1127,7 @@ static int mpeg_release(struct file *file)
 
 	/* Make sure we release the hardware */
 	drv = cx8802_get_driver(dev, CX88_MPEG_BLACKBIRD);
+	WARN_ON(!drv);
 	if (drv)
 		drv->request_release(drv);
 
-- 
1.7.5

