Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab1EAJbq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 05:31:46 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43895 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068Ab1EAJbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 05:31:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Np+zAxFY5vRD7COhl5uNTV1CBzlD2JSXPZJKBzCaXB72FwA6iXof1J/gVMHxGP2qQW
         /UUFtLZHUSxjgkJ21aySbwu0S/qkHufdWFV5ChwavHw3bwNwWroc/Tx9QNSjm8p9btW0
         gWe+rjdYtgo/fH/JfY1QL+hOtQL52anGXGUks=
Date: Sun, 1 May 2011 04:31:40 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mauro Carvalho Chehab <mchehab@redhat.com>,
        Dan Carpenter <error27@gmail.com>, Hans Verkuil <hverkuil@xs4all.nl>,
        Andi Huber <hobrom@gmx.at>, Marlon de Boer <marlon@hyves.nl>,
        Damien Churchill <damoxc@gmail.com>
Subject: [PATCH 7/7] [media] cx88: don't use atomic_t for core->users
Message-ID: <20110501093140.GG18380@elie>
References: <20110501091710.GA18263@elie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110501091710.GA18263@elie>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

users is always read or written with core->lock held.  A plain int is
simpler and faster.

Tested-by: Andi Huber <hobrom@gmx.at>
Tested-by: Marlon de Boer <marlon@hyves.nl>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
That's the end of the series.  Thanks for reading.

 drivers/media/video/cx88/cx88-video.c |    5 +++--
 drivers/media/video/cx88/cx88.h       |    2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/cx88/cx88-video.c b/drivers/media/video/cx88/cx88-video.c
index 508dabb..51d1b09 100644
--- a/drivers/media/video/cx88/cx88-video.c
+++ b/drivers/media/video/cx88/cx88-video.c
@@ -823,7 +823,7 @@ static int video_open(struct file *file)
 		call_all(core, tuner, s_radio);
 	}
 
-	atomic_inc(&core->users);
+	core->users++;
 	mutex_unlock(&core->lock);
 
 	return 0;
@@ -921,7 +921,8 @@ static int video_release(struct file *file)
 	file->private_data = NULL;
 	kfree(fh);
 
-	if(atomic_dec_and_test(&dev->core->users))
+	dev->core->users--;
+	if (!dev->core->users)
 		call_all(dev->core, core, s_power, 0);
 	mutex_unlock(&dev->core->lock);
 
diff --git a/drivers/media/video/cx88/cx88.h b/drivers/media/video/cx88/cx88.h
index 09e329f..887a978 100644
--- a/drivers/media/video/cx88/cx88.h
+++ b/drivers/media/video/cx88/cx88.h
@@ -383,7 +383,7 @@ struct cx88_core {
 	struct mutex               lock;
 	/* various v4l controls */
 	u32                        freq;
-	atomic_t		   users;
+	int                        users;
 	int                        mpeg_users;
 
 	/* cx88-video needs to access cx8802 for hybrid tuner pll access. */
-- 
1.7.5

