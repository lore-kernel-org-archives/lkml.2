Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab1ALWOx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 17:14:53 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48785 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab1ALWOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 17:14:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=sjP1C2EsbmyxXFtrjIOOc2O9n8U5olLXCHQ5TNEn0J8rUzMkCuZXS6PgtSDkaS3Br4
         K+HflUXRe4L+DChdG8aaOicy7Frhoz/sMUlEhEPohOTgE2EURRXAE9EQlS4xLXv5RCYK
         N4PKgMkCPllEBHmElTzEw5hfAGdvl2BvOkiZY=
Date: Thu, 13 Jan 2011 01:14:44 +0300
From: Alexey Charkov <alchark@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        vt8500-wm8505-linux-kernel@googlegroups.com
Subject: [PATCH] fbdev: Implement simple blanking in pseudocolor modes for
 vt8500lcdfb
Message-ID: <20110112221443.GA574@alchark-u3s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement simple blanking in pseudocolor modes for vt8500lcdfb

This follows the style of some other in-tree drivers by just setting
the hardware palette colors to all black. True Color modes are not
affected, but this at least allows to run xf86-video-fbdev without
errors due to blanking being unimplemented.

Signed-off-by: Alexey Charkov <alchark@gmail.com>

diff --git a/drivers/video/vt8500lcdfb.c b/drivers/video/vt8500lcdfb.c
index 7617f12..0e120d6 100644
--- a/drivers/video/vt8500lcdfb.c
+++ b/drivers/video/vt8500lcdfb.c
@@ -215,6 +215,33 @@ static int vt8500lcd_pan_display(struct fb_var_screeninfo *var,
 	return 0;
 }
 
+/*
+ * vt8500lcd_blank():
+ *	Blank the display by setting all palette values to zero.  Note,
+ * 	True Color modes do not really use the palette, so this will not
+ *      blank the display in all modes.
+ */
+static int vt8500lcd_blank(int blank, struct fb_info *info)
+{
+	int i;
+
+	switch (blank) {
+	case FB_BLANK_POWERDOWN:
+	case FB_BLANK_VSYNC_SUSPEND:
+	case FB_BLANK_HSYNC_SUSPEND:
+	case FB_BLANK_NORMAL:
+		if (info->fix.visual == FB_VISUAL_PSEUDOCOLOR ||
+		    info->fix.visual == FB_VISUAL_STATIC_PSEUDOCOLOR)
+			for (i = 0; i < 256; i++)
+				vt8500lcd_setcolreg(i, 0, 0, 0, 0, info);
+	case FB_BLANK_UNBLANK:
+		if (info->fix.visual == FB_VISUAL_PSEUDOCOLOR ||
+		    info->fix.visual == FB_VISUAL_STATIC_PSEUDOCOLOR)
+			fb_set_cmap(&info->cmap, info);
+	}
+	return 0;
+}
+
 static struct fb_ops vt8500lcd_ops = {
 	.owner		= THIS_MODULE,
 	.fb_set_par	= vt8500lcd_set_par,
@@ -225,6 +252,7 @@ static struct fb_ops vt8500lcd_ops = {
 	.fb_sync	= wmt_ge_sync,
 	.fb_ioctl	= vt8500lcd_ioctl,
 	.fb_pan_display	= vt8500lcd_pan_display,
+	.fb_blank	= vt8500lcd_blank,
 };
 
 static irqreturn_t vt8500lcd_handle_irq(int irq, void *dev_id)
