Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab1DEDao (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 23:30:44 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62881 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab1DEDal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 23:30:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lPnroZ99P8HKU0bgR1e/hJou3JFUfnXHygAK3yq4uGNOl14ogKbkXHeU8bHMZt9Ifa
         YwUx3NBFAQGsCbFPCMMah5lqO0zHeW6j4XLQDSZSzVO25iagaiyk+luT2bIyXQK1XdYg
         cv6O8QlZKlJTbDm8jnhZihYuOTyJatnS/5QJw=
Date: Mon, 4 Apr 2011 22:30:35 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: linux-media@vger.kernel.org
Cc: Huber Andreas <hobrom@corax.at>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-kernel@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>,
        Steven Toth <stoth@kernellabs.com>
Subject: [PATCH 6/7] [media] cx88: don't use atomic_t for core->mpeg_users
Message-ID: <20110405033035.GG4498@elie>
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

mpeg_users is always read or written with core->lock held except
in mpeg_release (where it looks like a bug).  A plain int is simpler
and faster.

Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
 drivers/media/video/cx88/cx88-blackbird.c |   11 ++++++-----
 drivers/media/video/cx88/cx88.h           |    2 +-
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/cx88/cx88-blackbird.c b/drivers/media/video/cx88/cx88-blackbird.c
index fa8e347..11e49bb 100644
--- a/drivers/media/video/cx88/cx88-blackbird.c
+++ b/drivers/media/video/cx88/cx88-blackbird.c
@@ -1073,7 +1073,7 @@ static int mpeg_open(struct file *file)
 		return err;
 	}
 
-	if (!atomic_read(&dev->core->mpeg_users) && blackbird_initialize_codec(dev) < 0) {
+	if (!dev->core->mpeg_users && blackbird_initialize_codec(dev) < 0) {
 		drv->request_release(drv);
 		mutex_unlock(&dev->core->lock);
 		return -EINVAL;
@@ -1101,7 +1101,7 @@ static int mpeg_open(struct file *file)
 	cx88_set_scale(dev->core, dev->width, dev->height,
 			fh->mpegq.field);
 
-	atomic_inc(&dev->core->mpeg_users);
+	dev->core->mpeg_users++;
 	mutex_unlock(&dev->core->lock);
 	return 0;
 }
@@ -1112,7 +1112,9 @@ static int mpeg_release(struct file *file)
 	struct cx8802_dev *dev = fh->dev;
 	struct cx8802_driver *drv = NULL;
 
-	if (dev->mpeg_active && atomic_read(&dev->core->mpeg_users) == 1)
+	mutex_lock(&dev->core->lock);
+
+	if (dev->mpeg_active && dev->core->mpeg_users == 1)
 		blackbird_stop_codec(dev);
 
 	cx8802_cancel_buffers(fh->dev);
@@ -1121,7 +1123,6 @@ static int mpeg_release(struct file *file)
 
 	videobuf_mmap_free(&fh->mpegq);
 
-	mutex_lock(&dev->core->lock);
 	file->private_data = NULL;
 	kfree(fh);
 
@@ -1131,7 +1132,7 @@ static int mpeg_release(struct file *file)
 	if (drv)
 		drv->request_release(drv);
 
-	atomic_dec(&dev->core->mpeg_users);
+	dev->core->mpeg_users--;
 
 	mutex_unlock(&dev->core->lock);
 
diff --git a/drivers/media/video/cx88/cx88.h b/drivers/media/video/cx88/cx88.h
index 3d32f4a..9e8176e 100644
--- a/drivers/media/video/cx88/cx88.h
+++ b/drivers/media/video/cx88/cx88.h
@@ -390,7 +390,7 @@ struct cx88_core {
 	/* various v4l controls */
 	u32                        freq;
 	atomic_t		   users;
-	atomic_t                   mpeg_users;
+	int                        mpeg_users;
 
 	/* cx88-video needs to access cx8802 for hybrid tuner pll access. */
 	struct cx8802_dev          *dvbdev;
-- 
1.7.5.rc0

