Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab2HTS3V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 14:29:21 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:58051 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752778Ab2HTS3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 14:29:14 -0400
From: Emil Goode <emilgoode@gmail.com>
To: FlorianSchandinat@gmx.de
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Emil Goode <emilgoode@gmail.com>
Subject: [PATCH] video: hpfb: Fix error handling
Date: Mon, 20 Aug 2012 20:32:25 +0200
Message-Id: <1345487545-9590-1-git-send-email-emilgoode@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch solves problems with the error handling by
introducing labels for proper error paths and it also
frees resources that where missed.

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
 drivers/video/hpfb.c |   28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/video/hpfb.c b/drivers/video/hpfb.c
index ebf8495..7324865 100644
--- a/drivers/video/hpfb.c
+++ b/drivers/video/hpfb.c
@@ -210,6 +210,7 @@ static int __devinit hpfb_init_one(unsigned long phys_base,
 				   unsigned long virt_base)
 {
 	unsigned long fboff, fb_width, fb_height, fb_start;
+	int ret;
 
 	fb_regs = virt_base;
 	fboff = (in_8(fb_regs + HPFB_FBOMSB) << 8) | in_8(fb_regs + HPFB_FBOLSB);
@@ -290,19 +291,29 @@ static int __devinit hpfb_init_one(unsigned long phys_base,
 	fb_info.var   = hpfb_defined;
 	fb_info.screen_base = (char *)fb_start;
 
-	fb_alloc_cmap(&fb_info.cmap, 1 << hpfb_defined.bits_per_pixel, 0);
+	ret = fb_alloc_cmap(&fb_info.cmap, 1 << hpfb_defined.bits_per_pixel, 0);
+	if (ret < 0)
+		goto unmap_screen_base;
 
-	if (register_framebuffer(&fb_info) < 0) {
-		fb_dealloc_cmap(&fb_info.cmap);
-		iounmap(fb_info.screen_base);
-		fb_info.screen_base = NULL;
-		return 1;
-	}
+	ret = register_framebuffer(&fb_info);
+	if (ret < 0)
+		goto dealloc_cmap;
 
 	printk(KERN_INFO "fb%d: %s frame buffer device\n",
 	       fb_info.node, fb_info.fix.id);
 
 	return 0;
+
+dealloc_cmap:
+	fb_dealloc_cmap(&fb_info.cmap);
+
+unmap_screen_base:
+	if (fb_info.screen_base) {
+		iounmap(fb_info.screen_base);
+		fb_info.screen_base = NULL;
+	}
+
+	return ret;
 }
 
 /* 
@@ -345,6 +356,9 @@ static void __devexit hpfb_remove_one(struct dio_dev *d)
 	if (d->scode >= DIOII_SCBASE)
 		iounmap((void *)fb_regs);
 	release_mem_region(d->resource.start, resource_size(&d->resource));
+	fb_dealloc_cmap(&fb_info.cmap);
+	if (fb_info.screen_base)
+		iounmap(fb_info.screen_base);
 }
 
 static struct dio_device_id hpfb_dio_tbl[] = {
-- 
1.7.10.4

