Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759479Ab2FUMWy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 08:22:54 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:54494 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759450Ab2FUMWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 08:22:53 -0400
MIME-Version: 1.0
Date: Thu, 21 Jun 2012 07:22:50 -0500
Message-ID: <CAL3m8eA=46wdwVosiE54eNx3FOuLyxfE5axKs_HjyMTGxDHRDw@mail.gmail.com>
Subject: [PATCH] fbdev: Add ioctls FBIO_COPYRECT, FBIO_FILLRECT, lest these
 operations be done in software.
From: Strake <strake888@gmail.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Farkas-Dyck <strake888@gmail.com>

Add ioctls FBIO_COPYRECT, FBIO_FILLRECT, lest these operations be done
in software.

Signed-off-by: Matthew Farkas-Dyck <strake888@gmail.com>
---

Reason: If it can be done in hardware, it ought to be. This will
enable user-mode software to do so.

commit 2c002c58b6c5d5b211423da8eaa242ca443fdd72
Author: strake <strake888@gmail.com>
Date:   Wed Jan 1 19:10:24 2003 -0500

    Add ioctls FBIO_COPYRECT, FBIO_FILLRECT

diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index 4ac1201..f525e91 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1019,6 +1019,8 @@ static long do_fb_ioctl(struct fb_info *info,
unsigned int cmd,
 	struct fb_cmap cmap_from;
 	struct fb_cmap_user cmap;
 	struct fb_event event;
+	struct fb_copyarea copy;
+	struct fb_fillrect fill;
 	void __user *argp = (void __user *)arg;
 	long ret = 0;

@@ -1126,6 +1128,26 @@ static long do_fb_ioctl(struct fb_info *info,
unsigned int cmd,
 		console_unlock();
 		unlock_fb_info(info);
 		break;
+	case FBIO_FILLRECT:
+		if (copy_from_user(&fill, argp, sizeof(fill)))
+			return -EFAULT;
+		if (!lock_fb_info(info))
+			return -ENODEV;
+		console_lock();
+		(*(info->fbops->fb_fillrect))(info, &fill);
+		console_unlock();
+		unlock_fb_info(info);
+		break;
+	case FBIO_COPYRECT:
+		if (copy_from_user(&copy, argp, sizeof(copy)))
+			return -EFAULT;
+		if (!lock_fb_info(info))
+			return -ENODEV;
+		console_lock();
+		(*(info->fbops->fb_copyarea))(info, &copy);
+		console_unlock();
+		unlock_fb_info(info);
+		break;
 	default:
 		if (!lock_fb_info(info))
 			return -ENODEV;
diff --git a/include/linux/fb.h b/include/linux/fb.h
index d1631d3..fc18459 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -39,6 +39,8 @@
 #define FBIOPUT_MODEINFO        0x4617
 #define FBIOGET_DISPINFO        0x4618
 #define FBIO_WAITFORVSYNC	_IOW('F', 0x20, __u32)
+#define FBIO_COPYRECT		_IOW('F', 0x22, struct fb_copyarea)
+#define FBIO_FILLRECT		_IOW('F', 0x23, struct fb_fillrect)

 #define FB_TYPE_PACKED_PIXELS		0	/* Packed Pixels	*/
 #define FB_TYPE_PLANES			1	/* Non interleaved planes */
