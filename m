Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552Ab0LMP70 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 10:59:26 -0500
Received: from smtp.ispras.ru ([83.149.198.201]:36692 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917Ab0LMP7Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 10:59:24 -0500
X-Greylist: delayed 1141 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Dec 2010 10:59:24 EST
From: Alexander Strakh <strakh@ispras.ru>
Organization: ISP RAS
To: linux-kernel@vger.kernel.org, kangyong@telegent.com, xbzhang@telegent.com,
        zyziii@telegent.com, shijie8@gmail.com,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org
Subject: BUG: double mutex_unlock in drivers/media/video/tlg2300/pd-video.c
Date: Mon, 13 Dec 2010 18:59:14 +0300
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201012131859.15152.strakh@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

        KERNEL_VERSION: 2.6.36
        SUBJECT: double mutex_lock in drivers/media/video/tlg2300/pd-video.c 
in function vidioc_s_fmt
        SUBSCRIBE:
	First mutex_unlock in function pd_vidioc_s_fmt in line 767:

 764        ret |= send_set_req(pd, VIDEO_ROSOLU_SEL,
 765                                vid_resol, &cmd_status);
 766        if (ret || cmd_status) {
 767                mutex_unlock(&pd->lock);
 768                return -EBUSY;
 769        }

	Second mutex_unlock in function vidioc_s_fmt in line 806:

 805        pd_vidioc_s_fmt(pd, &f->fmt.pix);
 806        mutex_unlock(&pd->lock);

Found by Linux Device Drivers Verification Project

Сhecks the return code of pd_vidioc_s_fm before mutex_unlocking.

Signed-off-by: Alexander Strakh <strakh@ispras.ru>

---
diff --git a/drivers/media/video/tlg2300/pd-video.c 
b/drivers/media/video/tlg2300/pd-video.c
index a1ffe18..fe6bd2b 100644
--- a/drivers/media/video/tlg2300/pd-video.c
+++ b/drivers/media/video/tlg2300/pd-video.c
@@ -802,8 +802,8 @@ static int vidioc_s_fmt(struct file *file, void *fh, 
struct v4l2_format *f)
 		return -EINVAL;
 	}
 
-	pd_vidioc_s_fmt(pd, &f->fmt.pix);
-	mutex_unlock(&pd->lock);
+	if(!pd_vidioc_s_fmt(pd, &f->fmt.pix)) 
+		mutex_unlock(&pd->lock);
 	return 0;
 }
 

