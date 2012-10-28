Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186Ab2J1XuJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:50:09 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41782 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755915Ab2J1X1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:27:00 -0400
Message-Id: <20121028231541.944810096@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:15:52 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Larry Finger <larry.finger@lwfinger.net>,
        Jay Harbeston <jharbestonus@gmail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [ 016/105] [media] au0828: fix case where STREAMOFF being called on stopped
 stream causes BUG()
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Devin Heitmueller <dheitmueller@kernellabs.com>

commit a595c1ce4c9d572cf53513570b9f1a263d7867f2 upstream.

We weren't checking whether the resource was in use before calling
res_free(), so applications which called STREAMOFF on a v4l2 device that
wasn't already streaming would cause a BUG() to be hit (MythTV).

Reported-by: Larry Finger <larry.finger@lwfinger.net>
Reported-by: Jay Harbeston <jharbestonus@gmail.com>
Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/video/au0828/au0828-video.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/au0828/au0828-video.c b/drivers/media/video/au0828/au0828-video.c
index df92322..4d5b670 100644
--- a/drivers/media/video/au0828/au0828-video.c
+++ b/drivers/media/video/au0828/au0828-video.c
@@ -1702,14 +1702,18 @@ static int vidioc_streamoff(struct file *file, void *priv,
 			(AUVI_INPUT(i).audio_setup)(dev, 0);
 		}
 
-		videobuf_streamoff(&fh->vb_vidq);
-		res_free(fh, AU0828_RESOURCE_VIDEO);
+		if (res_check(fh, AU0828_RESOURCE_VIDEO)) {
+			videobuf_streamoff(&fh->vb_vidq);
+			res_free(fh, AU0828_RESOURCE_VIDEO);
+		}
 	} else if (fh->type == V4L2_BUF_TYPE_VBI_CAPTURE) {
 		dev->vbi_timeout_running = 0;
 		del_timer_sync(&dev->vbi_timeout);
 
-		videobuf_streamoff(&fh->vb_vbiq);
-		res_free(fh, AU0828_RESOURCE_VBI);
+		if (res_check(fh, AU0828_RESOURCE_VBI)) {
+			videobuf_streamoff(&fh->vb_vbiq);
+			res_free(fh, AU0828_RESOURCE_VBI);
+		}
 	}
 
 	return 0;


