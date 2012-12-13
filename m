Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933239Ab2LMO2G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:28:06 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44890 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933054Ab2LMOMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:12:09 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 183/241] [media] au0828: fix case where STREAMOFF being called on stopped stream causes BUG()
Date: Thu, 13 Dec 2012 11:59:08 -0200
Message-Id: <1355407206-17100-184-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/media/video/au0828/au0828-video.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/au0828/au0828-video.c b/drivers/media/video/au0828/au0828-video.c
index ac3dd73..902825a 100644
--- a/drivers/media/video/au0828/au0828-video.c
+++ b/drivers/media/video/au0828/au0828-video.c
@@ -1692,14 +1692,18 @@ static int vidioc_streamoff(struct file *file, void *priv,
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
-- 
1.7.9.5

