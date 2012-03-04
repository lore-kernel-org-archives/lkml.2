Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab2CDU0q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 15:26:46 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:25541 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488Ab2CDU0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 15:26:45 -0500
Date: Sun, 4 Mar 2012 21:25:04 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-media@vger.kernel.org
cc: linux-kernel@vger.kernel.org, srinivasa.deevi@conexant.com,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        =?ISO-8859-15?Q?M=E1rcio_A_Alves?= <froooozen@gmail.com>,
        Julia Lawall <julia@diku.dk>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH] media, cx231xx: Fix double free on close
Message-ID: <alpine.LNX.2.00.1203042121100.9371@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In cx231xx_v4l2_close() there are two calls to
cx231xx_release_resources(dev) followed by kfree(dev). That is a
problem since cx231xx_release_resources() already kfree()'s its
argument, so we end up doing a double free.

Easily resolved by just removing the redundant kfree() calls after the
calls to cx231xx_release_resources().

I also changed the 'dev = NULL' assignments (which are rather
pointless since 'dev' is about to go out of scope), to 'fh->dev = NULL'
since it looks to me that that is what was actually intended.
And I removed the 'dev = NULL' assignment at the end of
cx231xx_release_resources() since it is pointless.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/media/video/cx231xx/cx231xx-cards.c |    1 -
 drivers/media/video/cx231xx/cx231xx-video.c |    6 ++----
 2 files changed, 2 insertions(+), 5 deletions(-)

 Please note that I do not have hardware to actually test this properly, 
 so this patch is compile tested only.
 I also do not have very intimate knowledge of this driver, so please 
 review carefully before applying.

diff --git a/drivers/media/video/cx231xx/cx231xx-cards.c b/drivers/media/video/cx231xx/cx231xx-cards.c
index 875a7ce..8ed460d 100644
--- a/drivers/media/video/cx231xx/cx231xx-cards.c
+++ b/drivers/media/video/cx231xx/cx231xx-cards.c
@@ -861,7 +861,6 @@ void cx231xx_release_resources(struct cx231xx *dev)
 	kfree(dev->sliced_cc_mode.alt_max_pkt_size);
 	kfree(dev->ts1_mode.alt_max_pkt_size);
 	kfree(dev);
-	dev = NULL;
 }
 
 /*
diff --git a/drivers/media/video/cx231xx/cx231xx-video.c b/drivers/media/video/cx231xx/cx231xx-video.c
index 829a41b..7f916f0 100644
--- a/drivers/media/video/cx231xx/cx231xx-video.c
+++ b/drivers/media/video/cx231xx/cx231xx-video.c
@@ -2319,8 +2319,7 @@ static int cx231xx_v4l2_close(struct file *filp)
 			if (dev->state & DEV_DISCONNECTED) {
 				if (atomic_read(&dev->devlist_count) > 0) {
 					cx231xx_release_resources(dev);
-					kfree(dev);
-					dev = NULL;
+					fh->dev = NULL;
 					return 0;
 				}
 				return 0;
@@ -2350,8 +2349,7 @@ static int cx231xx_v4l2_close(struct file *filp)
 		   free the remaining resources */
 		if (dev->state & DEV_DISCONNECTED) {
 			cx231xx_release_resources(dev);
-			kfree(dev);
-			dev = NULL;
+			fh->dev = NULL;
 			return 0;
 		}
 
-- 
1.7.9.2


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

