Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761470Ab0GTTWO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 15:22:14 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35820 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758567Ab0GTTWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 15:22:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=NpCxWRCkmSvgt8SLmIptJ4qBxM8lXiDZfaSOT2l76Zbf4dUKWaEYnwvBY0oi/44X2k
         hLqO1FJivbrWqGRGtMXkRAyjgJIT35ZX4LYGOlN73Ss7nYnARVicqnX/c8kxcKjggCEN
         Jt1wtaWm2XFUt0/uOXpwB5zP6MsJ+HzDFD8OQ=
Date: Tue, 20 Jul 2010 21:19:23 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fbdev@vger.kernel.org, nouveau@lists.freedesktop.org
Subject: [PATCH] vga16fb: refuse to load in face of other driver
 controlling primary card
Message-ID: <20100720191923.GA11056@joi.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't want vga16fb to mess with hardware initialized by other driver.
Detect it and refuse to load.
It fixes nouveau interrupt storm on some machines.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
---
 drivers/video/vga16fb.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/video/vga16fb.c b/drivers/video/vga16fb.c
index 28ccab4..4505446 100644
--- a/drivers/video/vga16fb.c
+++ b/drivers/video/vga16fb.c
@@ -22,6 +22,7 @@
 #include <linux/platform_device.h>
 #include <linux/screen_info.h>
 
+#include <asm/fb.h>
 #include <asm/io.h>
 #include <video/vga.h>
 
@@ -1415,7 +1416,7 @@ static struct platform_device *vga16fb_device;
 
 static int __init vga16fb_init(void)
 {
-	int ret;
+	int ret, i;
 #ifndef MODULE
 	char *option = NULL;
 
@@ -1424,6 +1425,16 @@ static int __init vga16fb_init(void)
 
 	vga16fb_setup(option);
 #endif
+	for (i = 0 ; i < FB_MAX; i++) {
+		if (!registered_fb[i])
+			continue;
+		if (fb_is_primary_device(registered_fb[i])) {
+			printk(KERN_INFO "vga16fb: %s is driving the primary card, refusing to load\n",
+				registered_fb[i]->fix.id);
+			return -EBUSY;
+		}
+	}
+
 	ret = platform_driver_register(&vga16fb_driver);
 
 	if (!ret) {
-- 
1.7.1


