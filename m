Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584Ab2E3FHJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 01:07:09 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:18202 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751334Ab2E3FHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 01:07:06 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zcb8kzzz1202hzz8275bhz2dh2a8h668h839he5bhf0ah)
From: Liu Ying <Ying.Liu@freescale.com>
To: <FlorianSchandinat@gmx.de>
CC: <lg@denx.de>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Liu Ying <Ying.Liu@freescale.com>
Subject: [PATCH 1/1] mx3fb: support pan display with fb_set_var
Date: Wed, 30 May 2012 12:14:27 +0800
Message-ID: <1338351267-25561-1-git-send-email-Ying.Liu@freescale.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Users may call FBIOPUT_VSCREENINFO ioctrl to do pan display.
This ioctrl relies on fb_set_var() to do the job. fb_set_var()
calls custom fb_set_par() method and then calls custom
fb_pan_display() method. The current implementation of mx3fb
reinitializes IPU display controller every time the custom
fb_set_par() method is called, which makes the display flash
if fb_set_var() is called to do panning frequently. The custom
fb_pan_display() method checks if the current xoffset and
yoffset are different from previous ones before doing actual
panning, which prevents the panning from happening within the
fb_set_var() context. This patch checks new var info to decide
whether we really need to reinitialize IPU display controller.
We ignore xoffset and yoffset update because it doesn't require
to reinitialize the controller. Users may specify activate field
of var info with FB_ACTIVATE_NOW and FB_ACTIVATE_FORCE to
reinialize the controller by force. Meanwhile, this patch removes
the check in custom fb_pan_display() method mentioned before to
have the panning work within fb_set_var() context. It doesn't
hurt to do panning again if there is no update for xoffset and
yoffset.

Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
---
 drivers/video/mx3fb.c |   31 +++++++++++++++++++++++++++----
 1 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/drivers/video/mx3fb.c b/drivers/video/mx3fb.c
index e3406ab..86daabe 100644
--- a/drivers/video/mx3fb.c
+++ b/drivers/video/mx3fb.c
@@ -269,6 +269,8 @@ struct mx3fb_info {
 	struct scatterlist		sg[2];
 
 	u32				sync;	/* preserve var->sync flags */
+
+	struct fb_var_screeninfo	cur_var; /* current var info */
 };
 
 static void mx3fb_dma_done(void *);
@@ -721,6 +723,26 @@ static void mx3fb_dma_done(void *arg)
 	complete(&mx3_fbi->flip_cmpl);
 }
 
+static bool fb_need_not_to_set_par(struct fb_info *fbi)
+{
+	struct mx3fb_info *mx3_fbi = fbi->par;
+	struct fb_var_screeninfo old_var = mx3_fbi->cur_var;
+	struct fb_var_screeninfo new_var = fbi->var;
+
+	if ((fbi->var.activate & FB_ACTIVATE_FORCE) &&
+	    (fbi->var.activate & FB_ACTIVATE_MASK) == FB_ACTIVATE_NOW)
+		return false;
+
+	/*
+	 * Ignore xoffset and yoffset update,
+	 * because pan display handles this case.
+	 */
+	old_var.xoffset = new_var.xoffset;
+	old_var.yoffset = new_var.yoffset;
+
+	return !memcmp(&old_var, &new_var, sizeof(struct fb_var_screeninfo));
+}
+
 static int __set_par(struct fb_info *fbi, bool lock)
 {
 	u32 mem_len;
@@ -732,6 +754,9 @@ static int __set_par(struct fb_info *fbi, bool lock)
 	struct idmac_video_param *video = &ichan->params.video;
 	struct scatterlist *sg = mx3_fbi->sg;
 
+	if (fb_need_not_to_set_par(fbi))
+		return 0;
+
 	/* Total cleanup */
 	if (mx3_fbi->txd)
 		sdc_disable_channel(mx3_fbi);
@@ -808,6 +833,8 @@ static int __set_par(struct fb_info *fbi, bool lock)
 	if (mx3_fbi->blank == FB_BLANK_UNBLANK)
 		sdc_enable_channel(mx3_fbi);
 
+	mx3_fbi->cur_var = fbi->var;
+
 	return 0;
 }
 
@@ -1068,10 +1095,6 @@ static int mx3fb_pan_display(struct fb_var_screeninfo *var,
 		return -EINVAL;
 	}
 
-	if (fbi->var.xoffset == var->xoffset &&
-	    fbi->var.yoffset == var->yoffset)
-		return 0;	/* No change, do nothing */
-
 	y_bottom = var->yoffset;
 
 	if (!(var->vmode & FB_VMODE_YWRAP))
-- 
1.7.1


