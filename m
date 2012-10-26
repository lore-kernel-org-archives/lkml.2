Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430Ab2JZAIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:08:18 -0400
Received: from mail.kernel.org ([198.145.19.201]:53797 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754456Ab2JZAIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:08:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Larry Finger <larry.finger@lwfinger.net>,
        Jay Harbeston <jharbestonus@gmail.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [ 61/85] media: au0828: fix case where STREAMOFF being called on stopped stream causes BUG()
Date: Thu, 25 Oct 2012 17:06:19 -0700
Message-Id: <20121026000037.255531187@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121026000031.107227138@linuxfoundation.org>
References: <20121026000031.107227138@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/media/video/au0828/au0828-video.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/media/video/au0828/au0828-video.c
+++ b/drivers/media/video/au0828/au0828-video.c
@@ -1692,14 +1692,18 @@ static int vidioc_streamoff(struct file
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


