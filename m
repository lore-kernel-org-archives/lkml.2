Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304Ab0C1Ltd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 07:49:33 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:37062 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444Ab0C1Lta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 07:49:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=hTHWgs5xKRI2ii/V5XiRWGaj+TutY5fHIS8CtToveLcTxYTiYMHiuR/BgX8N6Z3tBk
         uWt6smc3YRQdYuSmiOl6w0ssBLQUv9GB36XM0prVcUgyTy6xnFYmts9h6ZTicp2AeKHD
         lfZm4DR6VR12CxwNxwGNTW71sGfG9EYywna2o=
Date: Sun, 28 Mar 2010 14:49:20 +0300
From: Dan Carpenter <error27@gmail.com>
To: Luca Risolia <luca.risolia@studio.unibo.it>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Andreas Mohr <andi@lisas.de>,
       linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] video/zc0301: improve error handling
Message-ID: <20100328114920.GU5069@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Luca Risolia <luca.risolia@studio.unibo.it>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Alexey Dobriyan <adobriyan@gmail.com>, Andreas Mohr <andi@lisas.de>,
	linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return an error if the controller is not found.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/video/zc0301/zc0301_core.c b/drivers/media/video/zc0301/zc0301_core.c
index e44e4b5..bb51cfb 100644
--- a/drivers/media/video/zc0301/zc0301_core.c
+++ b/drivers/media/video/zc0301/zc0301_core.c
@@ -1153,7 +1153,7 @@ zc0301_vidioc_s_ctrl(struct zc0301_device* cam, void __user * arg)
 	if (copy_from_user(&ctrl, arg, sizeof(ctrl)))
 		return -EFAULT;
 
-	for (i = 0; i < ARRAY_SIZE(s->qctrl); i++)
+	for (i = 0; i < ARRAY_SIZE(s->qctrl); i++) {
 		if (ctrl.id == s->qctrl[i].id) {
 			if (s->qctrl[i].flags & V4L2_CTRL_FLAG_DISABLED)
 				return -EINVAL;
@@ -1163,7 +1163,9 @@ zc0301_vidioc_s_ctrl(struct zc0301_device* cam, void __user * arg)
 			ctrl.value -= ctrl.value % s->qctrl[i].step;
 			break;
 		}
-
+	}
+	if (i == ARRAY_SIZE(s->qctrl))
+		return -EINVAL;
 	if ((err = s->set_ctrl(cam, &ctrl)))
 		return err;
 
