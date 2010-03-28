Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab0C1LuW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 07:50:22 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:37062 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283Ab0C1LuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 07:50:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=swa4Nf60nk/8x5oArgRpMWskDbAOlKYcBBuGYNKTS7IUKJgU0H3odKF7+6MjmmyXrY
         VaR4fr/b+O5I7TAajFYpWFw4NY7m2Rn9s+hkqIPObQBCmtmIA+1hmtkc3pgTD8LvkKH2
         KjZglE7G94vm3EjoUNfHJqOJx9mN3rX9y4qhQ=
Date: Sun, 28 Mar 2010 14:50:05 +0300
From: Dan Carpenter <error27@gmail.com>
To: Luca Risolia <luca.risolia@studio.unibo.it>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Andreas Mohr <andi@lisas.de>,
       linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] video/sn9c102: improve error handling
Message-ID: <20100328115005.GW5069@bicker>
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

diff --git a/drivers/media/video/sn9c102/sn9c102_core.c b/drivers/media/video/sn9c102/sn9c102_core.c
index cbf8087..28e19da 100644
--- a/drivers/media/video/sn9c102/sn9c102_core.c
+++ b/drivers/media/video/sn9c102/sn9c102_core.c
@@ -2295,7 +2295,7 @@ sn9c102_vidioc_s_ctrl(struct sn9c102_device* cam, void __user * arg)
 	if (copy_from_user(&ctrl, arg, sizeof(ctrl)))
 		return -EFAULT;
 
-	for (i = 0; i < ARRAY_SIZE(s->qctrl); i++)
+	for (i = 0; i < ARRAY_SIZE(s->qctrl); i++) {
 		if (ctrl.id == s->qctrl[i].id) {
 			if (s->qctrl[i].flags & V4L2_CTRL_FLAG_DISABLED)
 				return -EINVAL;
@@ -2305,7 +2305,9 @@ sn9c102_vidioc_s_ctrl(struct sn9c102_device* cam, void __user * arg)
 			ctrl.value -= ctrl.value % s->qctrl[i].step;
 			break;
 		}
-
+	}
+	if (i == ARRAY_SIZE(s->qctrl))
+		return -EINVAL;
 	if ((err = s->set_ctrl(cam, &ctrl)))
 		return err;
 
