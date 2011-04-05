Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730Ab1DEDb1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 23:31:27 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:33263 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739Ab1DEDbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 23:31:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Rix8M1gwhz2MFOPF5Y84OIJIPumLcccAprq/7mwH4xRphnYzg2jsIkG/ySyXcPM64I
         zG15fmYkgR3gr9Q3PEu7lrupVm9dyuk7Nu5+timGn7hGal7PYWNPfEGi2p2itAAd4j9k
         S5YlBse79UkiWQY/BrbNrUjdQtpVk3MiDgDK8=
Date: Mon, 4 Apr 2011 22:31:15 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: linux-media@vger.kernel.org
Cc: Huber Andreas <hobrom@corax.at>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-kernel@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>,
        Steven Toth <stoth@kernellabs.com>
Subject: [PATCH 7/7] [mpeg] cx88: don't use atomic_t for core->users
Message-ID: <20110405033114.GH4498@elie>
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

users is always read or written with core->lock held.  A plain int is
simpler and faster.

Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
Thanks for reading.

 drivers/media/video/cx88/cx88-video.c |    5 +++--
 drivers/media/video/cx88/cx88.h       |    2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/cx88/cx88-video.c b/drivers/media/video/cx88/cx88-video.c
index 287a41e..d719d12 100644
--- a/drivers/media/video/cx88/cx88-video.c
+++ b/drivers/media/video/cx88/cx88-video.c
@@ -824,7 +824,7 @@ static int video_open(struct file *file)
 		call_all(core, tuner, s_radio);
 	}
 
-	atomic_inc(&core->users);
+	core->users++;
 	mutex_unlock(&core->lock);
 
 	return 0;
@@ -922,7 +922,8 @@ static int video_release(struct file *file)
 	file->private_data = NULL;
 	kfree(fh);
 
-	if(atomic_dec_and_test(&dev->core->users))
+	dev->core->users--;
+	if (!dev->core->users)
 		call_all(dev->core, core, s_power, 0);
 	mutex_unlock(&dev->core->lock);
 
diff --git a/drivers/media/video/cx88/cx88.h b/drivers/media/video/cx88/cx88.h
index 9e8176e..a399a8b 100644
--- a/drivers/media/video/cx88/cx88.h
+++ b/drivers/media/video/cx88/cx88.h
@@ -389,7 +389,7 @@ struct cx88_core {
 	struct mutex               lock;
 	/* various v4l controls */
 	u32                        freq;
-	atomic_t		   users;
+	int                        users;
 	int                        mpeg_users;
 
 	/* cx88-video needs to access cx8802 for hybrid tuner pll access. */
-- 
1.7.5.rc0

