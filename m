Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab1DED3r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 23:29:47 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:34237 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab1DED3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 23:29:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NwzCF7CfLdM2Olt2hZEVMou8Ra7Mr12aetALO68+D3Oz2lIuXrabIcuvSZzfS29jRs
         qTB3k3y2btDbGchMrbDwD2tZtwta4ZDPE5SgF4/RS6nqhxvHIMVxh6UeslSwYJF42w5l
         wVsDBjOLVJFO6Wuebn/BDa88ez50afX1YzNog=
Date: Mon, 4 Apr 2011 22:29:40 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: linux-media@vger.kernel.org
Cc: Huber Andreas <hobrom@corax.at>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-kernel@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>,
        Steven Toth <stoth@kernellabs.com>
Subject: [PATCH 5/7] [media] cx88: gracefully reject attempts to use
 unregistered cx88-blackbird driver
Message-ID: <20110405032939.GF4498@elie>
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

It should not be possible to enter mpeg_open and acquire core->lock
without the blackbird driver being registered, so just error out if it
is not.  This makes the code more readable and should prevent the bug
fixed by the patch "hold device lock during sub-driver initialization"
from resurfacing again.

Similarly, if we enter mpeg_release and acquire core->lock then either
the blackbird driver is registered (since open files keep it loaded)
or the sysadmin forced the driver's removal.  In the latter case the
state will be inconsistent and this is worth a loud warning.

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
1.7.5.rc0

