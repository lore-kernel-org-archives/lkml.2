Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933946Ab2E0BP0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:15:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38960 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932211Ab2E0BPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:15:19 -0400
Message-Id: <20120527002511.203719787@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 09:25:26 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [ 20/91] fbdev: sh_mobile_lcdc: Dont confuse line size with pitch
In-Reply-To: <20120527010903.GA18244@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

commit 72c04af9a2d57b7945cf3de8e71461bd80695d50 upstream.

When using the MERAM the LCDC line size needs to be programmed with a
MERAM-specific value different than the real frame buffer pitch. Fix it.

Reported-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/sh_mobile_lcdcfb.c |    5 +++--
 drivers/video/sh_mobile_lcdcfb.h |    1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/video/sh_mobile_lcdcfb.c
+++ b/drivers/video/sh_mobile_lcdcfb.c
@@ -758,7 +758,7 @@ static void __sh_mobile_lcdc_start(struc
 		}
 
 		lcdc_write_chan(ch, LDDFR, tmp);
-		lcdc_write_chan(ch, LDMLSR, ch->pitch);
+		lcdc_write_chan(ch, LDMLSR, ch->line_size);
 		lcdc_write_chan(ch, LDSA1R, ch->base_addr_y);
 		if (ch->format->yuv)
 			lcdc_write_chan(ch, LDSA2R, ch->base_addr_c);
@@ -847,6 +847,7 @@ static int sh_mobile_lcdc_start(struct s
 
 		ch->base_addr_y = ch->dma_handle;
 		ch->base_addr_c = ch->base_addr_y + ch->xres * ch->yres_virtual;
+		ch->line_size = ch->pitch;
 
 		/* Enable MERAM if possible. */
 		if (mdev == NULL || mdev->ops == NULL ||
@@ -882,7 +883,7 @@ static int sh_mobile_lcdc_start(struct s
 
 		meram = mdev->ops->meram_register(mdev, ch->cfg->meram_cfg,
 					ch->pitch, ch->yres, pixelformat,
-					&ch->pitch);
+					&ch->line_size);
 		if (!IS_ERR(meram)) {
 			mdev->ops->meram_update(mdev, meram,
 					ch->base_addr_y, ch->base_addr_c,
--- a/drivers/video/sh_mobile_lcdcfb.h
+++ b/drivers/video/sh_mobile_lcdcfb.h
@@ -84,6 +84,7 @@ struct sh_mobile_lcdc_chan {
 
 	unsigned long base_addr_y;
 	unsigned long base_addr_c;
+	unsigned int line_size;
 
 	int (*notify)(struct sh_mobile_lcdc_chan *ch,
 		      enum sh_mobile_lcdc_entity_event event,


