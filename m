Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab1AYVA0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 16:00:26 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64716 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379Ab1AYVAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 16:00:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=BelYzVVv9NL0hfNWxMr/4hhNDHK77QL2cHTvGFCfeadoIYzxOyG9M76PopyRy7bTvH
         9jJMGOZjnkGbdkZUzTknVkH4qkgC4EGDxYzahVZ+0CSvlcLvdPSzCHz7Xm76w2oM9mPA
         aInNo7N1TaVEnqgqDWD6ra9VVJB5Z3sQITorY=
From: Alexander Strakh <cromlehg@gmail.com>
To: shijie8@gmail.com
Cc: kangyong@telegent.com, xbzhang@telegent.com, mchehab@infradead.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Strakh <cromlehg@gmail.com>,
        Alexander Strakh <strakh@ispras.ru>
Subject: [PATCH 1/1] drivers/media/video/tlg2300/pd-video.c: Remove second mutex_unlock in pd_vidioc_s_fmt
Date: Wed, 26 Jan 2011 00:00:13 +0300
Message-Id: <1295989213-5171-1-git-send-email-strakh@ispras.ru>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Strakh <cromlehg@gmail.com>

Error path in file drivers/media/video/tlg2300/pd-video.c:
1. First mutex_unlock on &pd->lock in line 767 (in function that
   called from line 805) 
2. Second in line  806

 805        pd_vidioc_s_fmt(pd, &f->fmt.pix);
 806        mutex_unlock(&pd->lock);

Found by Linux Device Drivers Verification Project

Signed-off-by: Alexander Strakh <strakh@ispras.ru>
---
 drivers/media/video/tlg2300/pd-video.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/tlg2300/pd-video.c b/drivers/media/video/tlg2300/pd-video.c
index df33a1d..a794ae6 100644
--- a/drivers/media/video/tlg2300/pd-video.c
+++ b/drivers/media/video/tlg2300/pd-video.c
@@ -764,10 +764,8 @@ static int pd_vidioc_s_fmt(struct poseidon *pd, struct v4l2_pix_format *pix)
 	}
 	ret |= send_set_req(pd, VIDEO_ROSOLU_SEL,
 				vid_resol, &cmd_status);
-	if (ret || cmd_status) {
-		mutex_unlock(&pd->lock);
+	if (ret || cmd_status)
 		return -EBUSY;
-	}
 
 	pix_def->pixelformat = pix->pixelformat; /* save it */
 	pix->height = (context->tvnormid & V4L2_STD_525_60) ?  480 : 576;
-- 
1.7.1

