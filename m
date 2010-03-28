Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab0C1Lt6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 07:49:58 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:37062 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508Ab0C1Lty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 07:49:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=u7+UtzRKXdIxvfBbmdSnhS71S8n2vIgTAkxDjmpHrOO6JJJihbgLp5HE40UfUs0J0S
         BQR2tL2Nm65qEnXqqsqmVQJmSTn3jwx1Go/sM0xyiu2G4vJ4tFbhhun23AIp086CW7Rc
         LF5zbpT2orkRl068jGfp3iLVWW4/b35/NfBdU=
Date: Sun, 28 Mar 2010 14:49:45 +0300
From: Dan Carpenter <error27@gmail.com>
To: Luca Risolia <luca.risolia@studio.unibo.it>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Andreas Mohr <andi@lisas.de>,
       linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] video/et61x251: improve error handling
Message-ID: <20100328114945.GV5069@bicker>
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

The original code doesn't handle the situation where the controller is
not found.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/video/et61x251/et61x251_core.c b/drivers/media/video/et61x251/et61x251_core.c
index e6c23d5..a5cfc76 100644
--- a/drivers/media/video/et61x251/et61x251_core.c
+++ b/drivers/media/video/et61x251/et61x251_core.c
@@ -1713,7 +1713,7 @@ et61x251_vidioc_s_ctrl(struct et61x251_device* cam, void __user * arg)
 	if (copy_from_user(&ctrl, arg, sizeof(ctrl)))
 		return -EFAULT;
 
-	for (i = 0; i < ARRAY_SIZE(s->qctrl); i++)
+	for (i = 0; i < ARRAY_SIZE(s->qctrl); i++) {
 		if (ctrl.id == s->qctrl[i].id) {
 			if (s->qctrl[i].flags & V4L2_CTRL_FLAG_DISABLED)
 				return -EINVAL;
@@ -1723,7 +1723,9 @@ et61x251_vidioc_s_ctrl(struct et61x251_device* cam, void __user * arg)
 			ctrl.value -= ctrl.value % s->qctrl[i].step;
 			break;
 		}
-
+	}
+	if (i == ARRAY_SIZE(s->qctrl))
+		return -EINVAL;
 	if ((err = s->set_ctrl(cam, &ctrl)))
 		return err;
 
