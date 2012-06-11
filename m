Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab2FKB6y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 21:58:54 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:10810
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751039Ab2FKB6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 21:58:52 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 8
X-BigFish: VS8(zcb8kz78fbmzz1202hzz8275bhz2dh2a8h668h839he5bhf0ah)
From: Liu Ying <Ying.Liu@freescale.com>
To: <g.liakhovetski@gmx.de>
CC: <liu.y.victor@gmail.com>, <FlorianSchandinat@gmx.de>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Liu Ying <Ying.Liu@freescale.com>
Subject: [PATCH 3/3] mx3fb: avoid screen flash when panning with fb_set_var
Date: Mon, 11 Jun 2012 09:06:50 +0800
Message-ID: <1339376810-8247-3-git-send-email-Ying.Liu@freescale.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1339376810-8247-1-git-send-email-Ying.Liu@freescale.com>
References: <1339376810-8247-1-git-send-email-Ying.Liu@freescale.com>
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
fb_set_par() method is called, which makes the screen flash
if fb_set_var() is called to do panning frequently. This patch
compares the new var info with the cached old one to decide
whether we really need to reinitialize IPU display controller.
We ignore xoffset and yoffset update because it doesn't require
to reinitialize the controller. Users may specify activate field
of var info with FB_ACTIVATE_NOW and FB_ACTIVATE_FORCE to
reinialize the controller by force.

Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
---
 drivers/video/mx3fb.c |   22 +++++++++++++++++++++-
 1 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/drivers/video/mx3fb.c b/drivers/video/mx3fb.c
index 2dd11c4..7d0aa7b 100644
--- a/drivers/video/mx3fb.c
+++ b/drivers/video/mx3fb.c
@@ -721,6 +721,26 @@ static void mx3fb_dma_done(void *arg)
 	complete(&mx3_fbi->flip_cmpl);
 }
 
+static bool mx3fb_must_set_par(struct fb_info *fbi)
+{
+	struct mx3fb_info *mx3_fbi = fbi->par;
+	struct fb_var_screeninfo old_var = mx3_fbi->cur_var;
+	struct fb_var_screeninfo new_var = fbi->var;
+
+	if ((fbi->var.activate & FB_ACTIVATE_FORCE) &&
+	    (fbi->var.activate & FB_ACTIVATE_MASK) == FB_ACTIVATE_NOW)
+		return true;
+
+	/*
+	 * Ignore xoffset and yoffset update,
+	 * because pan display handles this case.
+	 */
+	old_var.xoffset = new_var.xoffset;
+	old_var.yoffset = new_var.yoffset;
+
+	return !!memcmp(&old_var, &new_var, sizeof(struct fb_var_screeninfo));
+}
+
 static int __set_par(struct fb_info *fbi, bool lock)
 {
 	u32 mem_len, cur_xoffset, cur_yoffset;
@@ -844,7 +864,7 @@ static int mx3fb_set_par(struct fb_info *fbi)
 
 	mutex_lock(&mx3_fbi->mutex);
 
-	ret = __set_par(fbi, true);
+	ret = mx3fb_must_set_par(fbi) ? __set_par(fbi, true) : 0;
 
 	mutex_unlock(&mx3_fbi->mutex);
 
-- 
1.7.1


